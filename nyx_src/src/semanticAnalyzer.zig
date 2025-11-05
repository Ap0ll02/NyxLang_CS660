const std = @import("std");
const ast = @import("ast.zig");
const sym_tab = @import("symbolTable.zig");
const m = @import("main.zig");
const log = @import("Log.zig");
var Symbol_Table: ?*sym_tab.SymbolTable = null;

pub fn setSymbolTable(t: *sym_tab.SymbolTable) void {
    Symbol_Table = t;
}
pub fn st() *sym_tab.SymbolTable {
    return Symbol_Table orelse @panic("semanticAnalyzer: symbol table not set");
}

pub fn semantic_analyze_node(node_opt: ?*ast.Node) void {
    const symbol_table = st();
    if (node_opt == null) {
        return;
    }
    const node = node_opt.?;
    switch (node.*) {
        .Declaration => {
            const decl = node.Declaration;
            if (ast.debug_mode) std.debug.print("Declaration node semantically analyzed!\n", .{});

            if (decl.assignNode) |n| {
                if (n.* == .Assignment) {
                    const ident = n.Assignment.declarator.Identifier;
                    symbol_table.assign_variable(ident) catch |err| {
                        log.Error(
                            ident.location.?.col, ident.location.?.line, 
                            "Could not assign variable",
                            m.diagnostic_source(ident.location.?.line),
                            "",
                        );
                    };
                }
                else if (n.* == .Identifier) {
                    const ident = n.Identifier;
                    // Use Jacks Error log here eventually
                    symbol_table.assign_variable(ident) catch |err| {
                        std.debug.print(
                            "Error assigning variable {s}: {s}\n",
                            .{ ident.name, @errorName(err) },
                        );
                    };
                }
                else semantic_analyze_node(n);
            }
        },
        .Assignment => {
            if (ast.debug_mode) std.debug.print("Assignment node semantically analyzed!\n", .{});
            const assgn = node.Assignment;
            semantic_analyze_node(assgn.declarator);
            if (assgn.initializer) |init| {
                // where we would check the box that
                semantic_analyze_node(init);
            }
            if (assgn.ass_op) |op| {
                semantic_analyze_node(op);
            }
        },
        .Function => {
            if (ast.debug_mode) std.debug.print("Function node semantically analyzed!\n", .{});
            const func = node.Function;

            semantic_analyze_node(func.nameParam);
            semantic_analyze_node(func.body);
        },
        .FunctionCall => {
            if (ast.debug_mode) std.debug.print("FunctionCall node semantically analyzed!\n", .{});
            const funcCall = node.FunctionCall;
            semantic_analyze_node(funcCall.name);
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
            const block_items = node.BlockItems;
            for (block_items.items) |item| {
                semantic_analyze_node(item);
            }
        },
        // TODO everything below this gets to do cool fun stuff w/ type checking (probably others too)
        .Binary => {
            if (ast.debug_mode) std.debug.print("Binary node semantically analyzed!\n", .{});
            const binary = node.Binary;
            semantic_analyze_node(binary.lhs);
            semantic_analyze_node(binary.rhs);
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
            if (ast.debug_mode) {
                std.debug.print("Identifier node semantically analyzed!\n", .{});
            }
            // Have a Jack Error log here eventually
            // symbol_table.get_variable(node.Identifier.name) orelse {
            //     std.debug.print(
            //         "Semantic Error: Variable {s} used before declaration.\n",
            //         .{node.Identifier.name},
            //     );
            // };
        },
        .Constant => {
            if (ast.debug_mode) std.debug.print("Constant node semantically analyzed!\n", .{});
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
            if (ast.debug_mode) std.debug.print("Type node semantically analyzed!\n", .{});
        },
        else => |tag| {
            if (ast.debug_mode) std.debug.print("Unknown node type: {}\n", .{tag});
        },
    }
}
