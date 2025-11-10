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

pub fn semantic_analyze_node(node_opt: ?*ast.Node) void {
    if (node_opt == null) {
        return;
    }
    const node = node_opt.?;
    switch (node.*) {
        .Declaration => {
            const decl = node.Declaration;
            if (ast.debug_mode) std.debug.print("Declaration node semantically analyzed!\n", .{});
            const dec_typename = std.mem.span(decl.typeNode.type_name);
                const my_type = st().get_type(dec_typename);
                if (my_type == null) { decl.typeNode = get_base_type(decl.typeNode.base).?; }
                else decl.typeNode = my_type.?;

            // add decl to symbol table
            st().assign_variable(decl) catch {
                log.Error(
                    decl.location.?.col,
                    decl.location.?.line,
                    "Could not assign variable",
                    m.diagnostic_source(decl.location.?.line),
                    "",
                );
            };

            // if there is an assignment attached to the Declaration then semantically analyze that node
            if (decl.assignNode) |n| {
                n.Assignment.typeNode = decl.typeNode;
                semantic_analyze_node(n);
            }
        },
        .Assignment => {
            if (ast.debug_mode) std.debug.print("Assignment node semantically analyzed!\n", .{});
            const assgn = node.Assignment;
            semantic_analyze_node(assgn.declarator);
            if (assgn.initializer) |init| {
                // where we would check the box that
                semantic_analyze_node(init);
                switch(init.*) {
                    .Identifier => |id| {
                        const str1 = std.mem.span(id.typeNode.?.type_name);
                        if (assgn.typeNode) |atn| {
                            const str2 = std.mem.span(atn.type_name);
                            if(!std.mem.eql(u8, str1, str2)) {
                                log.WarnLoc(
                                    assgn.location.?, 
                                    "Mismatched types", 
                                    m.diagnostic_source(assgn.location.?.line),
                                    log.f_str("Change variable type to match initializer: {s}", .{id.typeNode.?.type_name} )
                                );
                            }
                        }
                    }, 
                    .Constant => |c| {
                        const str1 = std.mem.span(c.typeNode.type_name);
                        const str2 = std.mem.span(assgn.typeNode.?.type_name);
                        if(!std.mem.eql(u8, str1, str2)) {
                            log.WarnLoc(
                                assgn.location.?, 
                                "Mismatched types", 
                                m.diagnostic_source(assgn.location.?.line),
                                log.f_str("Change variable type to match initializer: {s}", .{c.typeNode.type_name} )
                            );
                        }
                        
                    },
                    else => {}
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
            if(ast.debug_mode) std.debug.print("Adding {s} in symbol table\n", .{func.nameParam.NameParameterNode.name.Identifier.name});
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
            semantic_analyze_node(func.body);

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

            if (funcCall.args) |argsNode| {
                semantic_analyze_node(argsNode);
            }
        },
        .ArgumentList => {
            if (ast.debug_mode) std.debug.print("ArgumentList node semantically analyzed!\n", .{});
            const arg_list = node.ArgumentList;
            for (arg_list.args) |arg| {
                semantic_analyze_node(arg);
            }
        },
        .BlockItems => {
            if (ast.debug_mode) std.debug.print("BlockItems node semantically analyzed!\n", .{});
            if (ast.debug_mode)  st().print_sym_tables();
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
            if(binary.typeNode) |bn| {
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
        .Struct => {
            if (ast.debug_mode) std.debug.print("Struct node semantically analyzed!\n", .{});
            const struct_node = node.Struct;
            if (struct_node.name) |name| {
                semantic_analyze_node(name);
            }
            if (struct_node.decl_list) |list| {
                for (list) |item| {
                    semantic_analyze_node(item);
                }
            }
        },
        .StructDecl => {
            if (ast.debug_mode) std.debug.print("StructDecl node semantically analyzed!\n", .{});
            const struct_decl = node.StructDecl;
            for (struct_decl.decl_list) |decl| {
                semantic_analyze_node(decl);
            }
        },
        .StructDeclaration => {
            if (ast.debug_mode) std.debug.print("StructDeclaration node semantically analyzed!\n", .{});
            const struct_decl = node.StructDeclaration;
            semantic_analyze_node(struct_decl.packedNode);
            if (struct_decl.assignNode) |assgn| {
                semantic_analyze_node(assgn);
            }
        },
        .StructDeclaratorList => {
            if (ast.debug_mode) std.debug.print("StructDeclaratorList node semantically analyzed!\n", .{});
            const decl_list = node.StructDeclaratorList;
            for (decl_list.declarators) |decl| {
                semantic_analyze_node(decl);
            }
        },
        .StructDeclList => {
            if (ast.debug_mode) std.debug.print("StructDeclList node semantically analyzed!\n", .{});
            const decl_list = node.StructDeclList;
            for (decl_list.decl_list) |decl| {
                semantic_analyze_node(decl);
            }
        },
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
                log.ErrorLoc(
                    ident.location.?, "Declaration of this identifier does not have a valid type.",
                    m.diagnostic_source(ident.location.?.line), "Ensure variable declaration has a type"
                );
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
    if(type1) |t1| {
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
    if(type2) |t2| {
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
    if(type1_node.is_floating and !type2_node.is_floating) {
        if(ast.debug_mode) std.debug.print("Float vs. NonFloat\n", .{});
        return st().get_type(zig_str1);
    } else if(!type1_node.is_floating and type2_node.is_floating) {
        if(ast.debug_mode) std.debug.print("Nonfloat vs. Float\n", .{});
        return st().get_type(zig_str2);
    } else if (type2_node.size > type1_node.size) {
        if(ast.debug_mode) std.debug.print("Type 1 Bytes < Type 2 Bytes\n", .{});
        return st().get_type(zig_str2);
    } else if (type1_node.size > type2_node.size) {
        if(ast.debug_mode) std.debug.print("Type 1 Bytes > Type 2 Bytes\n", .{});
        return st().get_type(zig_str1);
    } else if(type1_node.is_unsigned and !type2_node.is_unsigned) {
        if(ast.debug_mode) std.debug.print("Type 1 Unsigned promotes to Signed\n", .{});
        return st().get_type(zig_str2);
    } else {
        if(ast.debug_mode) std.debug.print("Type 2 Unsigned promotes to Signed\n", .{});
        // const my_type = st().get_type(zig_str1);
        return st().get_type(zig_str1);
    }
}

pub fn get_base_type(b: ast.BaseType) ?*ast.TypeNode {
    return switch(b) {
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
