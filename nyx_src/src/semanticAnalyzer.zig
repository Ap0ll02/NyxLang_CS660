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
                        const decl_type_name = std.mem.span(newtype.type_name);

                        // Lookup in type table
                        if (st().get_type(decl_type_name)) |ty| {
                            if (ast.debug_mode) {
                                std.debug.print("Type has been found: {s}\n", .{decl_type_name});
                            }
                            // Overwrite the union value with the resolved type node
                            spec.* = .{ .Type = ty };
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
                            .base = .INT,
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
                                const struct_decl = decl_node.StructDeclaration;

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
                            }
                        }

                        type_node.alignment = struct_align;
                        type_node.size = alignForward(offset, struct_align);
                    },
                    else => |tag| {
                        if (ast.debug_mode) {
                            std.debug.print("unexpected declaration_specifier tag: {}\n", .{tag});
                        }
                    },
                }
            }

            // For handling Variables Arrays and Pointers types is handled before this call so we should capture bad types before this point
            if (decl.assign_node) |ass| {
                switch (ass.*) {
                    .Assignment => {
                        // We assign it and then move to the next stage of type checking
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
                    .Array => {
                        // We have an array so we need to find the length size * array
                        // array.length = array.constant.value * decl.declaration_specifier.type.alignment;
                        // We can finally add the decl node and name to the map
                        st().assign_variable(decl) catch {
                            log.Error(
                                decl.location.?.col,
                                decl.location.?.line,
                                "Could not assign Array variable",
                                m.diagnostic_source(decl.location.?.line),
                                "",
                            );
                        };
                    },
                    .Pointer => |pointer| // If its a pointer we just need to assign the pointer as a variable
                    {
                        _ = pointer;
                        // Im not sure what we should do with the pointer.
                        // There should be some sort of pointer depth check here
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
                        // Unkown node type so we should just do some error handling
                        if (ast.debug_mode) std.debug.print("unkown assign_node\n", .{});
                    },
                }
            }
        },
        .Assignment => {
            if (ast.debug_mode) std.debug.print("Assignment node semantically analyzed!\n", .{});
            const assgn = node.Assignment;
            semantic_analyze_node(assgn.declarator) catch |err| {
                std.debug.print("Semantic analysis failed: {s}\n", .{@errorName(err)});
                return;
            };
            if (assgn.initializer) |init| {
                // where we would check the box that
                semantic_analyze_node(init);
                switch (init.*) {
                    .Identifier => |id| {
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
                        if (assgn.typeNode) |atn| {
                            const str2 = std.mem.span(atn.type_name);
                            if (!std.mem.eql(u8, str1, str2)) {
                                log.WarnLoc(assgn.location.?, "Mismatched types", m.diagnostic_source(assgn.location.?.line), log.f_str("Change variable type to match initializer: {s}", .{str1}));
                            }
                        }
                    },
                    .Constant => |c| {
                        const str1 = std.mem.span(c.typeNode.type_name);
                        const str2 = std.mem.span(assgn.typeNode.?.type_name);
                        if (!std.mem.eql(u8, str1, str2)) {
                            log.WarnLoc(assgn.location.?, "Mismatched types", m.diagnostic_source(assgn.location.?.line), log.f_str("Change variable type to match initializer: {s}", .{c.typeNode.type_name}));
                        }
                    },
                    else => {},
                }
            }
            if (assgn.ass_op) |op| {
                semantic_analyze_node(op);
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
                semantic_analyze_node(func.body);
            }

            // TODO might need to add this later to type check
            // semantic_analyze_node(func.typeNode);
            // semantic_analyze_node(func.retType);
        },
        .FunctionCall => {
            if (ast.debug_mode) std.debug.print("FunctionCall node semantically analyzed!\n", .{});
            const funcCall = node.FunctionCall;

            // check if function exists in symbol table
            if (st().get_function(funcCall.name.Identifier.name)) |func| {
                funcCall.spawner = func;
            } else {
                log.Error(funcCall.location.?.col, funcCall.location.?.line, log.f_str("Usage of function: {s}, prior to definition.", .{funcCall.name.Identifier.name}), m.diagnostic_source(funcCall.location.?.line), "Try defining your function first!");
            }

            if (funcCall.spawner.?.arity != 1000) {
                if (funcCall.arity < funcCall.spawner.?.arity) {
                    log.ErrorLoc(funcCall.location.?, "Too few arguments for function", m.diagnostic_source(funcCall.location.?.line), "Ensure argument arity matches function arity.");
                } else if (funcCall.arity > funcCall.spawner.?.arity) {
                    log.ErrorLoc(funcCall.location.?, "Too many arguments for function", m.diagnostic_source(funcCall.location.?.line), "Ensure argument arity matches function arity.");
                } else {
                    if (funcCall.args) |argsNode| {
                        semantic_analyze_node(argsNode);
                        for (argsNode.ArgumentList.args, funcCall.spawner.?.nameParam.NameParameterNode.parameterList.?.ParameterList.params, 0..) |arg, par, i| {
                            check_arg_par(arg, par, i + 1, funcCall.name.Identifier.name);
                        }
                    }
                }
            }
        },
        .ArgumentList => {
            const arg_list = node.ArgumentList;
            for (arg_list.args) |arg| {
                semantic_analyze_node(arg);
            }
            if (ast.debug_mode) std.debug.print("ArgumentList node semantically analyzed!\n", .{});
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
                semantic_analyze_node(item);
            }

            const prev_table = st().pop();
            if (prev_table) |pt| {
                setSymbolTable(pt);
            }
        },
        // TODO everything below this gets to do cool fun stuff w/ type checking (probably others too)
        .Binary => {
            const binary = node.Binary;
            semantic_analyze_node(binary.lhs);
            semantic_analyze_node(binary.rhs);
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
            semantic_analyze_node(unary.val);
        },
        .PostFix => {
            if (ast.debug_mode) std.debug.print("PostFix node semantically analyzed!\n", .{});
            const postfix = node.PostFix;
            semantic_analyze_node(postfix.val);
        },
        .PreFix => {
            if (ast.debug_mode) std.debug.print("PreFix node semantically analyzed!\n", .{});
            const prefix = node.PreFix;
            semantic_analyze_node(prefix.val);
        },
        .AssOp => {
            if (ast.debug_mode) std.debug.print("AssOp node semantically analyzed!\n", .{});
        },
        .Comp => {
            if (ast.debug_mode) std.debug.print("Comp node semantically analyzed!\n", .{});
            const comp = node.Comp;
            semantic_analyze_node(comp.comp_op);
            semantic_analyze_node(comp.val);
        },
        .Cast => {
            if (ast.debug_mode) std.debug.print("Cast node semantically analyzed!\n", .{});
            const cast = node.Cast;
            semantic_analyze_node(cast.cast);
            semantic_analyze_node(cast.val);
        },
        .WhileStmt => {
            if (ast.debug_mode) std.debug.print("WhileStmt node semantically analyzed!\n", .{});
            const while_stmt = node.WhileStmt;
            if (while_stmt.init) |init| {
                semantic_analyze_node(init);
            }
            semantic_analyze_node(while_stmt.cond);
            semantic_analyze_node(while_stmt.body);
        },
        .IfStmt => {
            if (ast.debug_mode) std.debug.print("IfStmt node semantically analyzed!\n", .{});
            const if_stmt = node.IfStmt;
            semantic_analyze_node(if_stmt.cond);
            semantic_analyze_node(if_stmt.if_branch);
            if (if_stmt.el_branch) |el| {
                semantic_analyze_node(el);
            }
        },
        .ReturnStmt => {
            if (ast.debug_mode) std.debug.print("ReturnStmt node semantically analyzed!\n", .{});
            const ret_stmt = node.ReturnStmt;
            if (ret_stmt.val) |val| {
                semantic_analyze_node(val);
            }
        },
        .NameParameterNode => {
            if (ast.debug_mode) std.debug.print("NameParameterNode node semantically analyzed!\n", .{});
            const name_param = node.NameParameterNode;
            semantic_analyze_node(name_param.name);
            if (name_param.parameterList) |params| {
                semantic_analyze_node(params);
            }
        },
        .ConditionalExpression => {
            if (ast.debug_mode) std.debug.print("ConditionalExpression node semantically analyzed!\n", .{});
            const cond = node.ConditionalExpression;
            semantic_analyze_node(cond.expr1);
            semantic_analyze_node(cond.expr2);
        },
        .ExpressionStmt => {
            if (ast.debug_mode) std.debug.print("ExpressionStmt node semantically analyzed!\n", .{});
            const expr_stmt = node.ExpressionStmt;
            if (expr_stmt.expr) |expr_node| {
                semantic_analyze_node(expr_node);
            }
        },
        .IdPointer => {
            if (ast.debug_mode) std.debug.print("IdPointer node semantically analyzed!\n", .{});
            const id = node.IdPointer;
            semantic_analyze_node(id.pointer);
            semantic_analyze_node(id.identifier);
        },
        .Pointer => {
            if (ast.debug_mode) std.debug.print("Pointer node semantically analyzed!\n", .{});
            const pointer = node.Pointer;
            if (pointer.pointee) |pointee| {
                semantic_analyze_node(pointee);
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
            semantic_analyze_node(struct_decl.specifier);
            if (struct_decl.declarators) |declor| {
                for (declor) |d| {
                    semantic_analyze_node(d);
                }
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
                semantic_analyze_node(listNode);
            }
        },
        // everything below this is an "atomic" node and doesn't call anymore nodes
        .Identifier => {
            const ident = node.Identifier;
            if (ast.debug_mode) {
                std.debug.print("Identifier '{s}' BEFORE: spawner = {s}\n", .{ ident.name, if (ident.spawner == null) "null" else "set" });
            }
            const dec_link = st().get_variable(ident.name);
            if (dec_link) |dc| {
                ident.typeNode = dc.typeNode;
            } else {
                log.ErrorLoc(ident.location.?, "Declaration of this identifier does not have a valid type.", m.diagnostic_source(ident.location.?.line), "Ensure variable declaration has a type");
            }

            if (st().get_variable(node.Identifier.name)) |decl| {
                ident.spawner = decl;
            } else {
                log.Error(ident.location.?.col, ident.location.?.line, log.f_str("Variable {s} could not be found", .{node.Identifier.name}), m.diagnostic_source(ident.location.?.line), "");
            }

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
                type1 = as.typeNode;
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
                type2 = as.typeNode;
            }
        },
        .Declaration => |a| {
            type2 = a.typeNode;
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
