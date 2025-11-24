const std = @import("std");
const ast = @import("ast.zig");
const scope = @import("scope.zig");
const m = @import("main.zig");
const log = @import("Log.zig");
var Symbol_Table: ?*scope.SymbolTable = null;

pub fn setSymbolTable(t: *scope.SymbolTable) void {
    Symbol_Table = t;
}
pub fn st() *scope.SymbolTable {
    return Symbol_Table orelse @panic("semanticAnalyzer: symbol table not set");
}

pub fn semantic_analyze_node(node_opt: ?*ast.Node) !void {
    if (node_opt == null) {
        return;
    }
    const node = node_opt.?;
    switch (node.*) {
        .Declaration => {
            const decl = node.Declaration;
            if (decl.declaration_specifier) |spec| {
                switch (spec.*) {
                    .Type => |newtype| {
                        // Grab name from parsed type
                        const decl_type_name: []const u8 = std.mem.span(newtype.type_name);

                        // Lookup in type table
                        if (get_base_type(newtype.base)) |ty| {
                            if (ast.debug_mode) {
                                std.debug.print("Type has been found: {s}\n", .{decl_type_name});
                            }
                            if(newtype.is_const) {
                                ty.is_const = true;
                            }
                            spec.* = .{ .Type = ty };
                            // Overwrite the union value with the resolved type node
                        } else {
                            log.ErrorLoc(decl.location.?, log.f_str("Unknown type: {s}\n", .{decl_type_name}), m.diagnostic_source(decl.location.?.line), "Ensure Type is initilized");
                        }
                    },
                    .StructSpecifier => |new_struct| {
                        if (ast.debug_mode) std.debug.print("StructSpecifier semantically analyzed!\n", .{});

                        const alloc = st().allocator;

                        const name_slice: []const u8 = blk: {
                            if (new_struct.identifier) |name_node| {
                                break :blk name_node.Identifier.name;
                            } else {
                                break :blk "<anonymous>";
                            }
                        };

                        const name_z = try alloc.dupeZ(u8, name_slice);

                        // allocate the field_map on the heap
                        const field_map_ptr = try alloc.create(std.StringHashMap(*ast.StructsFieldInfo));
                        field_map_ptr.* = std.StringHashMap(*ast.StructsFieldInfo).init(alloc);

                        const type_node = try alloc.create(ast.TypeNode);
                        type_node.* = .{
                            .is_unsigned = false,
                            .is_floating = false,
                            .is_const = false,
                            .qualifier = 0,
                            .base = .STRUCT,
                            .type_name = name_z.ptr,
                            .size = 0, // compute later
                            .alignment = 1,
                            .location = new_struct.location,
                            .field_map = field_map_ptr,
                        };

                        new_struct.typeNode = type_node;

                        try st().assign_type(type_node);

                        var offset: usize = 0;
                        var struct_align: usize = 1;

                        if (new_struct.struct_declaration_list) |decls| {
                            for (decls) |decl_node| {
                                // const struct_decl = decl_node.StructDeclaration;
                                switch (decl_node.*) {
                                    .StructDeclaration => |sd| {
                                        const struct_decl = sd;

                                        var field_type: *ast.TypeNode = undefined;

                                        switch (struct_decl.specifier.*) {
                                            .Type => |t| {
                                                field_type = t;
                                            },
                                            .StructSpecifier => |inner_struct| {
                                                const inner_name: []const u8 = blk2: {
                                                    if (inner_struct.identifier) |id_node| {
                                                        break :blk2 id_node.Identifier.name;
                                                    } else {
                                                        break :blk2 "<anonymous>";
                                                    }
                                                };

                                                field_type = st().get_type(inner_name) orelse {
                                                    // unknown struct type
                                                    if (ast.debug_mode) {
                                                        std.debug.print("Unknown struct type for field: {s}\n", .{inner_name});
                                                    }
                                                    continue;
                                                };
                                            },
                                            else => {
                                                // unsupported field specifier for now
                                                continue;
                                            },
                                        }

                                        const field_size = field_type.size;
                                        const field_align = field_type.alignment;

                                        if (field_align == 0 or field_size == 0) {
                                            if (ast.debug_mode) {
                                                std.debug.print("Field has incomplete type, skipping\n", .{});
                                            }
                                            continue;
                                        }

                                        for (struct_decl.declarators) |decltor_node| {
                                            const field_name: []const u8 = switch (decltor_node.*) {
                                                .Identifier => |id| id.name,
                                                else => continue, // TODO support pointers & arrays as fields
                                            };

                                            offset = alignForward(offset, field_align);

                                            const field_info = try alloc.create(ast.StructsFieldInfo);
                                            field_info.* = .{
                                                .name = field_name,
                                                .type = field_type,
                                                .offset = offset,
                                            };

                                            try type_node.field_map.?.put(field_name, field_info);

                                            offset += field_size;
                                            if (field_align > struct_align) struct_align = field_align;
                                        }
                                    },
                                    else => |tag| {
                                        if (ast.debug_mode) {
                                            std.debug.print(
                                                "BUG: expected StructDeclaration inside struct_declaration_list, got {s}\n",
                                                .{@tagName(tag)},
                                            );
                                        }
                                        continue;
                                    },
                                }
                            }
                        }

                        type_node.alignment = struct_align;
                        type_node.size = alignForward(offset, struct_align);
                        spec.* = .{ .Type = type_node };
                    },
                    else => |tag| {
                        if (ast.debug_mode) {
                            std.debug.print("unexpected declaration_specifier tag: {}\n", .{tag});
                        }
                    },
                }
            }

            // For handling Variables Arrays and Pointers types is handled before this call so we should capture bad types before this point
            // For handling Variables, Arrays, and Pointers.
            // decl.assign_node can be:
            //   - Assignment (whose declarator is Identifier / Array / Pointer)
            //   - Array       (e.g., direct array declarator)
            //   - Pointer     (direct pointer declarator)
            if (decl.assign_node) |ass| {
                switch (ass.*) {
                    // int x[5];
                    // int *p;
                    // int x = 3;
                    .Assignment => |assign| {
                        const declarator = assign.declarator;
                        switch (declarator.*) {
                            .Array => |array_node| {
                                if (ast.debug_mode) std.debug.print("Declaration: array declarator\n", .{});

                                if (array_node.constant) |size| {
                                    const count_str = size.Constant.value;

                                    const count = std.fmt.parseUnsigned(usize, count_str, 10) catch {
                                        log.Error(
                                            decl.location.?.col,
                                            decl.location.?.line,
                                            "Non-integer array size",
                                            m.diagnostic_source(decl.location.?.line),
                                            "",
                                        );
                                        return;
                                    };

                                    if (assign.initializer) |init_node| {
                                        if (init_node.* == .InitializerList) {
                                            const init_list = init_node.InitializerList;
                                            const init_count: usize = init_list.inits.len;

                                            if (init_count > count) {
                                                // Too many initializers is a hard error
                                                log.Error(
                                                    decl.location.?.col,
                                                    decl.location.?.line,
                                                    "Too many initializers for array",
                                                    m.diagnostic_source(decl.location.?.line),
                                                    "",
                                                );
                                                return;
                                            } else if (init_count < count and ast.debug_mode) {
                                                // Fewer is legal in C (zero-initialize rest) – just warn in debug
                                                log.Warn(
                                                    decl.location.?.col,
                                                    decl.location.?.line,
                                                    log.f_str(
                                                        "Fewer initializers than array size (got {d}, expected {d})",
                                                        .{ init_count, count },
                                                    ),
                                                    m.diagnostic_source(decl.location.?.line),
                                                    "",
                                                );
                                            }
                                        }
                                    }

                                    const elem_size = decl.declaration_specifier.?.Type.size;
                                    const total_bytes = count * elem_size;
                                    array_node.length = @as(u32, @intCast(total_bytes));

                                    if (ast.debug_mode)
                                        std.debug.print(
                                            "the length of the array is: {d} (count={d}, elem_size={d})\n",
                                            .{ array_node.length, count, elem_size },
                                        );
                                }
                                if (array_node.identifier) |id_node| {
                                    const name = id_node.Identifier.name;
                                    if (st().get_variable(name) != null) {
                                        log.Warn(
                                            decl.location.?.col,
                                            decl.location.?.line,
                                            log.f_str("Shadowing previous variable: {s}", .{name}),
                                            m.diagnostic_source(decl.location.?.line),
                                            "",
                                        );
                                    }
                                }
                            },
                            .Pointer => |pointer_node| {
                                // Pointer declarator in an Assignment, e.g., int *p, or int **pp;
                                if (ast.debug_mode) {
                                    std.debug.print("Declaration: pointer declarator (depth={d})\n", .{pointer_node.depth});
                                }
                                // If your grammar fills an IdPointerNode for `int *p;`,
                                // you probably *don't* have to do anything here to find the name.
                                // assign_variable will see the IdPointerNode and pull identifier.Identifier.name.
                                // If you *do* want a shadowing warning, you can look into the pointee:
                                if (pointer_node.pointee) |pointee| switch (pointee.*) {
                                    .Identifier => |id| {
                                        const name = id.name;
                                        if (st().get_variable(name) != null) {
                                            log.Warn(
                                                decl.location.?.col,
                                                decl.location.?.line,
                                                log.f_str("Shadowing previous variable: {s}", .{name}),
                                                m.diagnostic_source(decl.location.?.line),
                                                "",
                                            );
                                        }
                                    },
                                    .IdPointer => |idp| {
                                        const name = idp.identifier.Identifier.name;
                                        if (st().get_variable(name) != null) {
                                            log.Warn(
                                                decl.location.?.col,
                                                decl.location.?.line,
                                                log.f_str("Shadowing previous variable: {s}", .{name}),
                                                m.diagnostic_source(decl.location.?.line),
                                                "",
                                            );
                                        }
                                    },
                                    else => {},
                                };
                            },
                            .Identifier => |_| {
                                // Simple scalar like: int x;
                                if (ast.debug_mode) std.debug.print("Declaration: simple identifier declarator\n", .{});
                            },
                            else => {
                                if (ast.debug_mode) {
                                    std.debug.print(
                                        "Declaration: unexpected inner declarator tag: {s}\n",
                                        .{@tagName(declarator.*)},
                                    );
                                }
                            },
                        }
                        // After analyzing the declarator shape, actually register the variable:
                        st().assign_variable(decl) catch {
                            log.Error(
                                decl.location.?.col,
                                decl.location.?.line,
                                "Could not assign variable",
                                m.diagnostic_source(decl.location.?.line),
                                "",
                            );
                        };
                    },
                    // Pretty much ignore this Most of the work should be done in the above switch case
                    // Case where the parser directly made assign_node an Array node
                    .Array => |array_node| {
                        if (ast.debug_mode) std.debug.print("Declaration: array declarator\n", .{});

                        if (array_node.constant) |size| {
                            const count_str = size.Constant.value;

                            const count = std.fmt.parseUnsigned(usize, count_str, 10) catch {
                                log.Error(
                                    decl.location.?.col,
                                    decl.location.?.line,
                                    "Non-integer array size",
                                    m.diagnostic_source(decl.location.?.line),
                                    "",
                                );
                                return;
                            };

                            const elem_size = decl.declaration_specifier.?.Type.size;
                            const total_bytes = count * elem_size;
                            array_node.length = @as(u32, @intCast(total_bytes));

                            if (ast.debug_mode)
                                std.debug.print(
                                    "the length of the array is: {d} (count={d}, elem_size={d})\n",
                                    .{ array_node.length, count, elem_size },
                                );
                        }

                        if (array_node.identifier) |id_node| {
                            const name = id_node.Identifier.name;
                            if (st().get_variable(name) != null) {
                                log.Warn(
                                    decl.location.?.col,
                                    decl.location.?.line,
                                    log.f_str("Shadowing previous variable: {s}", .{name}),
                                    m.diagnostic_source(decl.location.?.line),
                                    "",
                                );
                            }
                        }
                    },

                    // Case where the parser directly made assign_node a Pointer node
                    .Pointer => |pointer| {
                        _ = pointer;
                        if (ast.debug_mode) std.debug.print("Declaration: direct pointer assign_node\n", .{});

                        st().assign_variable(decl) catch {
                            log.Error(
                                decl.location.?.col,
                                decl.location.?.line,
                                "Could not assign pointer variable",
                                m.diagnostic_source(decl.location.?.line),
                                "",
                            );
                        };
                    },

                    else => {
                        // Unknown node type so we should just do some error handling
                        if (ast.debug_mode) {
                            std.debug.print(
                                "Declaration: unknown assign_node tag: {s}\n",
                                .{@tagName(ass.*)},
                            );
                        }

                        // You can choose to still try assigning, or just skip.
                        st().assign_variable(decl) catch {
                            log.Error(
                                decl.location.?.col,
                                decl.location.?.line,
                                "Could not assign variable (unknown assign_node shape)",
                                m.diagnostic_source(decl.location.?.line),
                                "",
                            );
                        };
                    },
                }
            }
        },
        .ArgumentList => {
            const arg_list = node.ArgumentList;
            for (arg_list.args) |arg| {
                semantic_analyze_node(arg) catch |err| {
                    if (ast.debug_mode) std.debug.print("Semantic analysis failed: {s}\n", .{@errorName(err)});
                    return;
                };
            }
            if (ast.debug_mode) std.debug.print("ArgumentList node semantically analyzed!\n", .{});
        },
        .InitializerList => {
            const init_list = node.InitializerList;
            for (init_list.inits) |init| {
                semantic_analyze_node(init) catch |err| {
                    if (ast.debug_mode) std.debug.print("Semantic Failure: {any}\n", .{err});
                    return;
                };
            }
            if (ast.debug_mode)
                std.debug.print("InitializerList node semantically analyzed! (count={d})\n", .{init_list.inits.len});
            },
        .Assignment => {
                const assgn = node.Assignment;
 
                if (ast.debug_mode) std.debug.print("Assignment node semantically analyzed!\n", .{});
                semantic_analyze_node(assgn.declarator) catch |err| {
                    if (ast.debug_mode) std.debug.print("Semantic analysis failed: {s}\n", .{@errorName(err)});
                    return;
                };
                switch (assgn.declarator.*) {
                    .Identifier => |id| {
                        if(id.spawner) |spawner| {
                            if (spawner.declaration_specifier) |dec_spec| {
                                if (dec_spec.* == .Type and dec_spec.Type.is_const) {
                                    log.ErrorLoc(assgn.location.?, "Cannot reassign to constant", 
                                        m.diagnostic_source(assgn.location.?.line), 
                                        "Remove 'const' keyword for variable mutability");
                                    return;
                                }
                            }
                        }
                    },
                    else => {},
                }
                if (assgn.initializer) |init| {
                    // where we would check the box that
                    semantic_analyze_node(init) catch |err| {
                        if (ast.debug_mode) std.debug.print("Semantic Failure: {any}\n", .{err});
                        return;
                    };
                    if (init.* == .InitializerList and assgn.declarator.* == .Array) {
                        const array_node = assgn.declarator.Array;
                        const init_list = init.InitializerList;
                        const init_count: usize = init_list.inits.len;

                        if (array_node.constant) |size_node| {
                            // size_node is the constant that held the array size (e.g. "5" in int x[5])
                            const count_str = size_node.Constant.value;

                            const declared_count = std.fmt.parseUnsigned(usize, count_str, 10) catch {
                                log.Error(
                                    assgn.location.?.col,
                                    assgn.location.?.line,
                                    "Non-integer array size",
                                    m.diagnostic_source(assgn.location.?.line),
                                    "",
                                );
                                return;
                            };

                            if (init_count > declared_count) {
                                log.Error(
                                    assgn.location.?.col,
                                    assgn.location.?.line,
                                    "Too many initializers for array",
                                    m.diagnostic_source(assgn.location.?.line),
                                    "Remove extra elements or increase the array size.",
                                );
                                return;
                            } else if (init_count < declared_count and ast.debug_mode) {
                                log.WarnLoc(
                                    assgn.location.?,
                                    log.f_str("Fewer initializers than array size (got {d}, expected {d})", .{ init_count, declared_count }),
                                    m.diagnostic_source(assgn.location.?.line),
                                    "Remaining elements are zero-initialized in C.",
                                );
                            }
                        }
                    }
                    switch (init.*) {
                        .Identifier => |id| {
                            if(id.typeNode) |at| {
                                if(at.is_const) {
                                    log.ErrorLoc(assgn.location.?, "Cannot reassign to identififer constant", m.diagnostic_source(assgn.location.?.line), "Remove 'const' keyword for variable mutability");
                                    return;
                                }
                            }
                            const str1 = std.mem.span(id.typeNode.?.type_name);
                            if (assgn.typeNode) |atn| {
                                const str2 = std.mem.span(atn.type_name);
                                if (!std.mem.eql(u8, str1, str2)) {
                                    log.WarnLoc(assgn.location.?, "Mismatched types", m.diagnostic_source(assgn.location.?.line), log.f_str("Change variable type to match initializer: {s}", .{id.typeNode.?.type_name}));
                                }
                            }
                        },
                        .FunctionCall => |fc| {
                            const str1 = std.mem.span(fc.spawner.?.retType.type_name);
                            if(fc.typeNode) |at| {
                                if(at.is_const) {
                                    log.ErrorLoc(assgn.location.?, "Cannot reassign to functioncall constant", m.diagnostic_source(assgn.location.?.line), "Remove 'const' keyword for variable mutability");
                                    return;
                                }
                            }
                            if (assgn.typeNode) |atn| {
                                const str2 = std.mem.span(atn.type_name);
                                if (!std.mem.eql(u8, str1, str2)) {
                                    log.WarnLoc(assgn.location.?, "Mismatched types", m.diagnostic_source(assgn.location.?.line), log.f_str("Change variable type to match initializer: {s}", .{str1}));
                                }
                            }
                        },
                        .Constant => |c| {
                            const str1 = std.mem.span(c.typeNode.type_name);

                            if (assgn.typeNode) |atn| {
                                const str2 = std.mem.span(atn.type_name);
                                if (!std.mem.eql(u8, str1, str2)) {
                                    log.WarnLoc(
                                        assgn.location.?,
                                        "Mismatched types",
                                        m.diagnostic_source(assgn.location.?.line),
                                        log.f_str(
                                            "Change variable type to match initializer: {s}",
                                            .{c.typeNode.type_name},
                                        ),
                                    );
                                }
                            } else if (ast.debug_mode) {
                                std.debug.print(
                                    "Assignment has Constant initializer but no assgn.typeNode (skipping type match)\n",
                                    .{},
                                );
                            }
                                if(assgn.typeNode) |tp2| {
                                    const str2 = std.mem.span(tp2.type_name);
                                    if (!std.mem.eql(u8, str1, str2)) {
                                        log.WarnLoc(assgn.location.?, "Mismatched types", m.diagnostic_source(assgn.location.?.line), log.f_str("Change variable type to match initializer: {s}", .{c.typeNode.type_name}));
                                    }
                                }
                            },

                            else => {},
                        }
                    }
                    if (assgn.ass_op) |op| {
                        semantic_analyze_node(op) catch |err| {
                            if (ast.debug_mode) std.debug.print("Semantic Failure: {any}\n", .{err});
                            return;
                        };
                    }
                },
                .Function => {
                    if (ast.debug_mode) std.debug.print("Function node semantically analyzed!\n", .{});
                    const func = node.Function;

                    // add function to symbol table
                    if (ast.debug_mode) std.debug.print("Adding {s} in symbol table\n", .{func.nameParam.NameParameterNode.name.Identifier.name});
                    st().assign_function(func) catch {
                        log.Error(func.location.?.col, func.location.?.line, "Error assigning function to symbol table!", m.diagnostic_source(func.location.?.line), "");
                    };
                    if (func.nameParam.NameParameterNode.parameterList) |fp| {
                        for (fp.ParameterList.params) |p| {
                            st().assign_variable(p.Declaration) catch {
                                log.Error(func.location.?.col, func.location.?.line, "Error assigning parameters to symbol table", m.diagnostic_source(func.location.?.line), "");
                            };
                        }
                    }
                    if (func.body.* == .BlockItems) {
                        semantic_analyze_node(func.body) catch |err| {
                            if (ast.debug_mode) std.debug.print("Semantic Failure: {any}\n", .{err});
                            return;
                        };
                    }

                    // TODO might need to add this later to type check
                    // semantic_analyze_node(func.typeNode);
                    // semantic_analyze_node(func.retType);
                },
                .FunctionCall => {
                    if (ast.debug_mode)
                        std.debug.print("FunctionCall node semantically analyzed!\n", .{});
                    const funcCall = node.FunctionCall;

                    // --- Step 1: check if function exists in the symbol table ---
                    const func = st().get_function(funcCall.name.Identifier.name);
                    if (func == null) {
                        log.Error(
                            funcCall.location.?.col,
                            funcCall.location.?.line,
                            log.f_str(
                                "Usage of function: {s}, prior to definition.",
                                .{funcCall.name.Identifier.name},
                            ),
                            m.diagnostic_source(funcCall.location.?.line),
                            "Try defining your function first!",
                        );
                        return; // early return prevents null deref of spawner
                    }

                    // --- Step 2: set spawner safely ---
                    funcCall.spawner = func;

                    // --- Step 3: normal argument checking ---
                    const spawner = funcCall.spawner.?; // now guaranteed non-null

                    if (spawner.arity != 1000) {
                        if (funcCall.arity < spawner.arity) {
                            log.ErrorLoc(
                                funcCall.location.?,
                                "Too few arguments for function",
                                m.diagnostic_source(funcCall.location.?.line),
                                "Ensure argument arity matches function arity.",
                            );
                        } else if (funcCall.arity > spawner.arity) {
                            log.ErrorLoc(
                                funcCall.location.?,
                                "Too many arguments for function",
                                m.diagnostic_source(funcCall.location.?.line),
                                "Ensure argument arity matches function arity.",
                            );
                        } else {
                            if (funcCall.args) |argsNode| {
                                semantic_analyze_node(argsNode) catch |err| {
                                    if (ast.debug_mode)
                                        std.debug.print("Semantic Failure: {any}\n", .{err});
                                    return;
                                };
                                for (argsNode.ArgumentList.args, spawner.nameParam.NameParameterNode.parameterList.?.ParameterList.params, 0..) |arg, par, i| {
                                    check_arg_par(arg, par, i + 1, funcCall.name.Identifier.name);
                                }
                            }
                        }
                    }
                },
                .BlockItems => {
                    if (ast.debug_mode) std.debug.print("BlockItems node semantically analyzed!\n", .{});
                    if (ast.debug_mode) st().print_sym_tables();
                    const new_table = st().push();
                    if (new_table) |nt| {
                        setSymbolTable(nt);
                    }

                    const block_items = node.BlockItems;
                    for (block_items.items) |item| {
                        semantic_analyze_node(item) catch |err| {
                            if (ast.debug_mode) std.debug.print("Semantic Failure: {any}\n", .{err});
                            return;
                        };
                    }

                    const prev_table = st().pop();
                    if (prev_table) |pt| {
                        setSymbolTable(pt);
                    }
                },
                // TODO everything below this gets to do cool fun stuff w/ type checking (probably others too)
                .Binary => {
                    const binary = node.Binary;
                    semantic_analyze_node(binary.lhs) catch |err| {
                        if (ast.debug_mode) std.debug.print("Semantic Failure: {any}\n", .{err});
                        return;
                    };
                    semantic_analyze_node(binary.rhs) catch |err| {
                        if (ast.debug_mode) std.debug.print("Semantic Failure: {any}\n", .{err});
                        return;
                    };
                    binary.typeNode = resolve_common_type(binary.lhs, binary.rhs);
                    if (binary.typeNode) |bn| {
                        if (ast.debug_mode) std.debug.print("Binary Node ({s})\n", .{bn.type_name});
                    } else {
                        if (ast.debug_mode) log.InfoLoc(binary.location.?, "Binary node has no type", m.diagnostic_source(binary.location.?.line), "");
                    }
                    if (ast.debug_mode) std.debug.print("Binary node semantically analyzed!\n", .{});
                },
                .Unary => {
                    if (ast.debug_mode) std.debug.print("Unary node semantically analyzed!\n", .{});
                    const unary = node.Unary;
                    semantic_analyze_node(unary.val) catch |err| {
                        if (ast.debug_mode) std.debug.print("Semantic Failure: {any}\n", .{err});
                        return;
                    };
                },
                .PostFix => {
                    if (ast.debug_mode) std.debug.print("PostFix node semantically analyzed!\n", .{});
                    const postfix = node.PostFix;
                    semantic_analyze_node(postfix.val) catch |err| {
                        if (ast.debug_mode) std.debug.print("Semantic Failure: {any}\n", .{err});
                        return;
                    };
                },
                .PreFix => {
                    if (ast.debug_mode) std.debug.print("PreFix node semantically analyzed!\n", .{});
                    const prefix = node.PreFix;
                    semantic_analyze_node(prefix.val) catch |err| {
                        if (ast.debug_mode) std.debug.print("Semantic Failure: {any}\n", .{err});
                        return;
                    };
                },
                .AssOp => {
                    if (ast.debug_mode) std.debug.print("AssOp node semantically analyzed!\n", .{});
                },
                .Comp => {
                    if (ast.debug_mode) std.debug.print("Comp node semantically analyzed!\n", .{});
                    const comp = node.Comp;
                    semantic_analyze_node(comp.comp_op) catch |err| {
                        if (ast.debug_mode) std.debug.print("Semantic Failure: {any}\n", .{err});
                        return;
                    };
                    semantic_analyze_node(comp.val) catch |err| {
                        if (ast.debug_mode) std.debug.print("Semantic Failure: {any}\n", .{err});
                        return;
                    };
                },
                .Cast => {
                    if (ast.debug_mode) std.debug.print("Cast node semantically analyzed!\n", .{});
                    const cast = node.Cast;
                    semantic_analyze_node(cast.cast) catch |err| {
                        if (ast.debug_mode) std.debug.print("Semantic Failure: {any}\n", .{err});
                        return;
                    };
                    semantic_analyze_node(cast.val) catch |err| {
                        if (ast.debug_mode) std.debug.print("Semantic Failure: {any}\n", .{err});
                        return;
                    };
                },
                .WhileStmt => {
                    if (ast.debug_mode) std.debug.print("WhileStmt node semantically analyzed!\n", .{});
                    const while_stmt = node.WhileStmt;
                    if (while_stmt.init) |init| {
                        semantic_analyze_node(init) catch |err| {
                            if (ast.debug_mode) std.debug.print("Semantic Failure: {any}\n", .{err});
                            return;
                        };
                    }
                    semantic_analyze_node(while_stmt.cond) catch |err| {
                        if (ast.debug_mode) std.debug.print("Semantic Failure: {any}\n", .{err});
                        return;
                    };
                    semantic_analyze_node(while_stmt.body) catch |err| {
                        if (ast.debug_mode) std.debug.print("Semantic Failure: {any}\n", .{err});
                        return;
                    };
                },
                .IfStmt => {
                    if (ast.debug_mode) std.debug.print("IfStmt node semantically analyzed!\n", .{});
                    const if_stmt = node.IfStmt;
                    semantic_analyze_node(if_stmt.cond) catch |err| {
                        if (ast.debug_mode) std.debug.print("Semantic Failure: {any}\n", .{err});
                        return;
                    };
                    semantic_analyze_node(if_stmt.if_branch) catch |err| {
                        if (ast.debug_mode) std.debug.print("Semantic Failure: {any}\n", .{err});
                        return;
                    };
                    if (if_stmt.el_branch) |el| {
                        semantic_analyze_node(el) catch |err| {
                            if (ast.debug_mode) std.debug.print("Semantic Failure: {any}\n", .{err});
                            return;
                        };
                    }
                },
                .ReturnStmt => {
                    if (ast.debug_mode) std.debug.print("ReturnStmt node semantically analyzed!\n", .{});
                    const ret_stmt = node.ReturnStmt;
                    if (ret_stmt.val) |val| {
                        semantic_analyze_node(val) catch |err| {
                            if (ast.debug_mode) std.debug.print("Semantic Failure: {any}\n", .{err});
                            return;
                        };
                    }
                },
                .NameParameterNode => {
                    if (ast.debug_mode) std.debug.print("NameParameterNode node semantically analyzed!\n", .{});
                    const name_param = node.NameParameterNode;
                    semantic_analyze_node(name_param.name) catch |err| {
                        if (ast.debug_mode) std.debug.print("Semantic Failure: {any}\n", .{err});
                        return;
                    };
                    if (name_param.parameterList) |params| {
                        semantic_analyze_node(params) catch |err| {
                            if (ast.debug_mode) std.debug.print("Semantic Failure: {any}\n", .{err});
                            return;
                        };
                    }
                },
                .ConditionalExpression => {
                    if (ast.debug_mode) std.debug.print("ConditionalExpression node semantically analyzed!\n", .{});
                    const cond = node.ConditionalExpression;
                    semantic_analyze_node(cond.expr1) catch |err| {
                        if (ast.debug_mode) std.debug.print("Semantic Failure: {any}\n", .{err});
                        return;
                    };
                    semantic_analyze_node(cond.expr2) catch |err| {
                        if (ast.debug_mode) std.debug.print("Semantic Failure: {any}\n", .{err});
                        return;
                    };
                },
                .ExpressionStmt => {
                    if (ast.debug_mode) std.debug.print("ExpressionStmt node semantically analyzed!\n", .{});
                    const expr_stmt = node.ExpressionStmt;
                    if (expr_stmt.expr) |expr_node| {
                        semantic_analyze_node(expr_node) catch |err| {
                            if (ast.debug_mode) std.debug.print("Semantic Failure: {any}\n", .{err});
                            return;
                        };
                    }
                },
                .IdPointer => {
                    if (ast.debug_mode) std.debug.print("IdPointer node semantically analyzed!\n", .{});
                    const id = node.IdPointer;
                    semantic_analyze_node(id.pointer) catch |err| {
                        if (ast.debug_mode) std.debug.print("Semantic Failure: {any}\n", .{err});
                        return;
                    };
                    semantic_analyze_node(id.identifier) catch |err| {
                        if (ast.debug_mode) std.debug.print("Semantic Failure: {any}\n", .{err});
                        return;
                    };
                },
                .Pointer => {
                    if (ast.debug_mode) std.debug.print("Pointer node semantically analyzed!\n", .{});
                    const pointer = node.Pointer;
                    if (pointer.pointee) |pointee| {
                        semantic_analyze_node(pointee) catch |err| {
                            if (ast.debug_mode) std.debug.print("Semantic Failure: {any}\n", .{err});
                            return;
                        };
                    }
                },
                //     StructDeclaration: *StructDeclarationNode,
                // StructDeclarationList: *StructDeclarationListNode,
                // StructDeclaratorList: *StructDeclaratorListNode,
                // StructSpecifier: *StructSpecifierNode,
                // StructOrUnion: *StructOrUnionNode,
                // .Struct => {
                //     if (ast.debug_mode) std.debug.print("Struct node semantically analyzed!\n", .{});
                //     const struct_node = node.Struct;
                //     if (struct_node.name) |name| {
                //         semantic_analyze_node(name);
                //     }
                //     if (struct_node.decl_list) |list| {
                //         for (list) |item| {
                //             semantic_analyze_node(item);
                //         }
                //     }
                // },
                // .StructDeclarationList => { // unwraped and not an AST node.
                //     if (ast.debug_mode) std.debug.print("StructDecl node semantically analyzed!\n", .{});
                //     const struct_decl = node.StructDecl;
                //     for (struct_decl.decl_list) |decl| {
                //         semantic_analyze_node(decl);
                //     }
                // },
                .StructDeclaration => {
                    if (ast.debug_mode) std.debug.print("StructDeclaration node semantically analyzed!\n", .{});
                    const struct_decl = node.StructDeclaration;
                    semantic_analyze_node(struct_decl.specifier) catch |err| {
                        if (ast.debug_mode) std.debug.print("Semantic Failure: {any}\n", .{err});
                        return;
                    };
                    for (struct_decl.declarators) |d| {
                        semantic_analyze_node(d) catch |err| {
                            if (ast.debug_mode) std.debug.print("Semantic Failure: {any}\n", .{err});
                            return;
                        };
                    }
                },
                // .StructDeclaratorList => { // unwraped and not a AST node
                //     if (ast.debug_mode) std.debug.print("StructDeclaratorList node semantically analyzed!\n", .{});
                //     const decl_list = node.StructDeclaratorList;
                //     for (decl_list.declarators) |decl| {
                //         semantic_analyze_node(decl);
                //     }
                // },
                // .StructDeclList => { // unwrapped and not an AST node
                //     if (ast.debug_mode) std.debug.print("StructDeclList node semantically analyzed!\n", .{});
                //     const decl_list = node.StructDeclList;
                //     for (decl_list.decl_list) |decl| {
                //         semantic_analyze_node(decl);
                //     }
                // },
                .TranslationUnitList => {
                    if (ast.debug_mode) std.debug.print("TranslationUnitList node semantically analyzed!\n", .{});
                    const translationList = node.TranslationUnitList;
                    for (translationList.translationUnits) |listNode| {
                        semantic_analyze_node(listNode) catch |err| {
                            if (ast.debug_mode) std.debug.print("Semantic Failure: {any}\n", .{err});
                            return;
                        };
                    }
                },
                // everything below this is an "atomic" node and doesn't call anymore nodes
                .Identifier => {
                    const ident = node.Identifier;

                    if (ast.debug_mode) {
                        std.debug.print(
                            "Identifier '{s}' BEFORE: spawner = {s}\n",
                            .{ ident.name, if (ident.spawner == null) "null" else "set" },
                        );
                    }

                    const dec_link = st().get_variable(ident.name);
                    if (dec_link == null) {
                        log.ErrorLoc(
                            ident.location.?,
                            log.f_str("Use of undeclared variable: {s}", .{ident.name}),
                            m.diagnostic_source(ident.location.?.line),
                            "Ensure the variable is defined before use.",
                        );
                        return;
                    }

                    const dc = dec_link.?;
                    if (dc.declaration_specifier) |spec| {
                        if (spec.* == .Type) {
                            ident.typeNode = spec.Type;
                        }
                    } else {
                        log.ErrorLoc(
                            ident.location.?,
                            "Declaration of this identifier does not have a valid type.",
                            m.diagnostic_source(ident.location.?.line),
                            "Ensure variable declaration has a type.",
                        );
                        return;
                    }

                    ident.spawner = dec_link.?;

                    if (ast.debug_mode) {
                        std.debug.print(
                            "Identifier '{s}' AFTER: spawner = {s}\n",
                            .{ ident.name, if (ident.spawner == null) "null" else "set" },
                        );
                    }
                },

                .Constant => {
                    if (ast.debug_mode) std.debug.print("Constant node semantically analyzed!\n", .{});
                    node.Constant.typeNode = get_base_type(node.Constant.typeNode.base).?;
                },
                .String => {
                    if (ast.debug_mode) std.debug.print("String node semantically analyzed!\n", .{});
                },
                .Char => {
                    if (ast.debug_mode) std.debug.print("Char node semantically analyzed!\n", .{});
                },
                .Int => {
                    if (ast.debug_mode) std.debug.print("Int node semantically analyzed!\n", .{});
                },
                .Float => {
                    if (ast.debug_mode) std.debug.print("Float node semantically analyzed!\n", .{});
                },
                .Type => {
                    st().assign_type(node.Type) catch {
                        log.Error(
                            node.Type.location.?.col,
                            node.Type.location.?.line,
                            "Could not assign type",
                            m.diagnostic_source(node.Type.location.?.line),
                            "",
                        );
                    };
                    if (ast.debug_mode) std.debug.print("Type node semantically analyzed!\n", .{});
                },
                else => |tag| {
                    if (ast.debug_mode) std.debug.print("Unknown node type: {}\n", .{tag});
                },
            }
    }

    pub fn resolve_common_type(type1: ?*ast.Node, type2: ?*ast.Node) ?*ast.TypeNode {
        // Hold the types temporarily for easy comparison
        var type1_node: *ast.TypeNode = undefined;
        var type2_node: *ast.TypeNode = undefined;

        // Unwrap node to get inner type of lhs and rhs
        if (type1) |t1| {
            switch (t1.*) {
                .Constant => |t| {
                    type1_node = t.typeNode;
                },
                .Identifier => |t| {
                    type1_node = t.typeNode.?;
                },
                else => return null,
            }
        } else return null;
        if (type2) |t2| {
            switch (t2.*) {
                .Constant => |t| {
                    type2_node = t.typeNode;
                },
                .Identifier => |t| {
                    type2_node = t.typeNode.?;
                },
                else => return null,
            }
        } else return null;
        const zig_str1: []const u8 = std.mem.span(type1_node.type_name);
        const zig_str2: []const u8 = std.mem.span(type2_node.type_name);

        // Compare types and promote or demote
        // Floats win
        if (type1_node.is_floating and !type2_node.is_floating) {
            if (ast.debug_mode) std.debug.print("Float vs. NonFloat\n", .{});
            return st().get_type(zig_str1);
        } else if (!type1_node.is_floating and type2_node.is_floating) {
            if (ast.debug_mode) std.debug.print("Nonfloat vs. Float\n", .{});
            return st().get_type(zig_str2);
        } else if (type2_node.size > type1_node.size) {
            if (ast.debug_mode) std.debug.print("Type 1 Bytes < Type 2 Bytes\n", .{});
            return st().get_type(zig_str2);
        } else if (type1_node.size > type2_node.size) {
            if (ast.debug_mode) std.debug.print("Type 1 Bytes > Type 2 Bytes\n", .{});
            return st().get_type(zig_str1);
        } else if (type1_node.is_unsigned and !type2_node.is_unsigned) {
            if (ast.debug_mode) std.debug.print("Type 1 Unsigned promotes to Signed\n", .{});
            return st().get_type(zig_str2);
        } else {
            if (ast.debug_mode) std.debug.print("Type 2 Unsigned promotes to Signed\n", .{});
            // const my_type = st().get_type(zig_str1);
            return st().get_type(zig_str1);
        }
    }

    pub fn check_arg_par(arg: *ast.Node, par: *ast.Node, arg_num: usize, func_name: []const u8) void {
        var type1: ?*ast.TypeNode = null;
        var type2: ?*ast.TypeNode = null;
        var arg_loc: ?*ast.Location = null;

        switch (arg.*) {
            .Identifier => |a| {
                if (a.spawner) |as| {
                    type1 = as.declaration_specifier.?.Type;
                }
                arg_loc = a.location;
            },
            .Constant => |a| {
                type1 = a.typeNode;
                arg_loc = a.location;
            },
            .FunctionCall => |a| {
                if (a.spawner) |as| {
                    type1 = as.retType;
                }
                arg_loc = a.location;
            },
            else => {},
        }

        switch (par.*) {
            .Identifier => |a| {
                if (a.spawner) |as| {
                    type2 = as.declaration_specifier.?.Type;
                }
            },
            .Declaration => |a| {
                type2 = a.declaration_specifier.?.Type;
            },
            else => {},
        }

        // Make sure we have both types before comparing
        if (type1 == null or type2 == null) return;

        const name1: []const u8 = std.mem.span(type1.?.type_name);
        const name2: []const u8 = std.mem.span(type2.?.type_name);

        // Warn if types DON'T match (inverted logic from original)
        if (!std.mem.eql(u8, name1, name2)) {
            log.WarnLoc(arg_loc.?, log.f_str("Type mismatch in argument {d} to function '{s}'", .{ arg_num, func_name }), m.diagnostic_source(arg_loc.?.line), log.f_str("Expected '{s}' but got '{s}'", .{ name2, name1 }));
        }
    }

    pub fn get_base_type(b: ast.BaseType) ?*ast.TypeNode {
        return switch (b) {
            .INT => st().get_type("int"),
            .FLOAT => st().get_type("float"),
            .BOOL => st().get_type("bool"),
            .CHAR => st().get_type("char"),
            .DOUBLE => st().get_type("double"),
            .LONG => st().get_type("long"),
            .STRING => st().get_type("string"),
            else => st().get_type("int"),
        };
    }

    fn alignForward(offset: usize, alignment: usize) usize {
        if (alignment == 0) return offset;
        const rem = offset % alignment;
        return if (rem == 0) offset else offset + (alignment - rem);
    }
