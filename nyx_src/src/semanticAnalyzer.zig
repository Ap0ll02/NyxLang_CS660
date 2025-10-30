const std = @import("std");
const ast = @import("ast.zig");

pub fn semantic_analyze_node(node: *ast.Node) void {
    switch (node.*) {
        .Declaration => {
            std.debug.print("Declaration node semantically analyzed!\n", .{});
            const decl = node.Declaration;
            if (decl.assignNode) |assgn| {
                semantic_analyze_node(assgn);
            }
        },
        .Assignment => {
            std.debug.print("Assignment node semantically analyzed!\n", .{});
            const assgn = node.Assignment;
            semantic_analyze_node(assgn.declarator);
            if (assgn.initializer) |init| {
                semantic_analyze_node(init);
            }
            if (assgn.ass_op) |op| {
                semantic_analyze_node(op);
            }
        },
        .Function => {
            std.debug.print("Function node semantically analyzed!\n", .{});
            const func = node.Function;
            semantic_analyze_node(func.nameParam);
            semantic_analyze_node(func.body);
        },
        .FunctionCall => {
            std.debug.print("FunctionCall node semantically analyzed!\n", .{});
            const funcCall = node.FunctionCall;
            semantic_analyze_node(funcCall.name);
            if (funcCall.args) |argsNode| {
                semantic_analyze_node(argsNode);
            }
        },
        .ArgumentList => {
            std.debug.print("ArgumentList node semantically analyzed!\n", .{});
            const arg_list = node.ArgumentList;
            for (arg_list.args) |arg| {
                semantic_analyze_node(arg);
            }
        },
        .BlockItems => {
            std.debug.print("BlockItems node semantically analyzed!\n", .{});
            const block_items = node.BlockItems;
            for (block_items.items) |item| {
                semantic_analyze_node(item);
            }
        },
        // TODO everything below this gets to do cool fun stuff w/ type checking (probably others too)
        .Binary => {
            std.debug.print("Binary node semantically analyzed!\n", .{});
            const binary = node.Binary;
            semantic_analyze_node(binary.lhs);
            semantic_analyze_node(binary.rhs);
        },
        .Unary => {
            std.debug.print("Unary node semantically analyzed!\n", .{});
            const unary = node.Unary;
            semantic_analyze_node(unary.val);
        },
        .PostFix => {
            std.debug.print("PostFix node semantically analyzed!\n", .{});
            const postfix = node.PostFix;
            semantic_analyze_node(postfix.val);
        },
        .PreFix => {
            std.debug.print("PreFix node semantically analyzed!\n", .{});
            const prefix = node.PreFix;
            semantic_analyze_node(prefix.val);
        },
        .AssOp => {
            std.debug.print("AssOp node semantically analyzed!\n", .{});
        },
        .Comp => {
            std.debug.print("Comp node semantically analyzed!\n", .{});
            const comp = node.Comp;
            semantic_analyze_node(comp.comp_op);
            semantic_analyze_node(comp.val);
        },
        .Cast => {
            std.debug.print("Cast node semantically analyzed!\n", .{});
            const cast = node.Cast;
            semantic_analyze_node(cast.cast);
            semantic_analyze_node(cast.val);
        },
        .WhileStmt => {
            std.debug.print("WhileStmt node semantically analyzed!\n", .{});
            const while_stmt = node.WhileStmt;
            if (while_stmt.init) |init| {
                semantic_analyze_node(init);
            }
            semantic_analyze_node(while_stmt.cond);
            semantic_analyze_node(while_stmt.body);
        },
        .IfStmt => {
            std.debug.print("IfStmt node semantically analyzed!\n", .{});
            const if_stmt = node.IfStmt;
            semantic_analyze_node(if_stmt.cond);
            semantic_analyze_node(if_stmt.if_branch);
            if (if_stmt.el_branch) |el| {
                semantic_analyze_node(el);
            }
        },
        .ReturnStmt => {
            std.debug.print("ReturnStmt node semantically analyzed!\n", .{});
            const ret_stmt = node.ReturnStmt;
            if (ret_stmt.val) |val| {
                semantic_analyze_node(val);
            }
        },
        .NameParameterNode => {
            std.debug.print("NameParameterNode node semantically analyzed!\n", .{});
            const name_param = node.NameParameterNode;
            semantic_analyze_node(name_param.name);
            if (name_param.parameterList) |params| {
                semantic_analyze_node(params);
            }
        },
        .ConditionalExpression => {
            std.debug.print("ConditionalExpression node semantically analyzed!\n", .{});
            const cond = node.ConditionalExpression;
            semantic_analyze_node(cond.expr1);
            semantic_analyze_node(cond.expr2);
        },
        .ExpressionStmt => {
            std.debug.print("ExpressionStmt node semantically analyzed!\n", .{});
            const expr_stmt = node.ExpressionStmt;
            if (expr_stmt.expr) |expr_node| {
                semantic_analyze_node(expr_node);
            }
        },
        .IdPointer => {
            std.debug.print("IdPointer node semantically analyzed!\n", .{});
            const id = node.IdPointer;
            semantic_analyze_node(id.pointer);
            semantic_analyze_node(id.identifier);
        },
        .Pointer => {
            std.debug.print("Pointer node semantically analyzed!\n", .{});
            const pointer = node.Pointer;
            if (pointer.pointee) |pointee| {
                semantic_analyze_node(pointee);
            }
        },
        .Struct => {
            std.debug.print("Struct node semantically analyzed!\n", .{});
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
            std.debug.print("StructDecl node semantically analyzed!\n", .{});
            const struct_decl = node.StructDecl;
            for (struct_decl.decl_list) |decl| {
                semantic_analyze_node(decl);
            }
        },
        .StructDeclaration => {
            std.debug.print("StructDeclaration node semantically analyzed!\n", .{});
            const struct_decl = node.StructDeclaration;
            semantic_analyze_node(struct_decl.packedNode);
            if (struct_decl.assignNode) |assgn| {
                semantic_analyze_node(assgn);
            }
        },
        .StructDeclaratorList => {
            std.debug.print("StructDeclaratorList node semantically analyzed!\n", .{});
            const decl_list = node.StructDeclaratorList;
            for (decl_list.declarators) |decl| {
                semantic_analyze_node(decl);
            }
        },
        .StructDeclList => {
            std.debug.print("StructDeclList node semantically analyzed!\n", .{});
            const decl_list = node.StructDeclList;
            for (decl_list.decl_list) |decl| {
                semantic_analyze_node(decl);
            }
        },
        .TranslationUnitList => {
            std.debug.print("TranslationUnitList node semantically analyzed!\n", .{});
            const translationList = node.TranslationUnitList;
            for (translationList.translationUnits) |listNode| {
                semantic_analyze_node(listNode);
            }
        },
        // everything below this is an "atomic" node and doesn't call anymore nodes
        .Error => {
            std.debug.print("Error node semantically analyzed!\n", .{});
        },
        .Identifier => {
            std.debug.print("Identifier node semantically analyzed!\n", .{});
        },
        .Constant => {
            std.debug.print("Constant node semantically analyzed!\n", .{});
        },
        .String => {
            std.debug.print("String node semantically analyzed!\n", .{});
        },
        .Char => {
            std.debug.print("Char node semantically analyzed!\n", .{});
        },
        .Int => {
            std.debug.print("Int node semantically analyzed!\n", .{});
        },
        .Float => {
            std.debug.print("Float node semantically analyzed!\n", .{});
        },
        .Type => {
            std.debug.print("Type node semantically analyzed!\n", .{});
        },
        else => |tag| {
            std.debug.print("Unknown node type: {}\n", .{tag});
        },
    }
}
