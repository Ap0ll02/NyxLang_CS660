const std = @import("std");
const c = @cImport(@cInclude("c11.tab.h"));

// ==============
// NODE STRUCTS
// ==============

// Identifier node represents variable/function names
// It includes the name as a string
pub const IdentifierNode = struct {
    name: []const u8,
};
// Constant node represents literal values
// It includes the value and its type information
pub const ConstantNode = struct {
    value: []const u8,
    typeNode: TypeNode,
};
// Declaration node represents variable declarations
// It includes the variable name, type, and optional initializer
pub const DeclarationNode = struct {
    typeNode: *TypeNode,
    assignNode: ?*AssignmentNode,
};
pub const FunctionNode = struct {
    funcName: []const u8,
    retType: TypeNode,
    body: *Node,
};

pub const BlockItemsNode = struct { 
    items: []*Node 
    }; // A list of statements/declarations in a block

pub const BinaryNode = struct {
    lhs: *Node,
    op: u8,
    rhs: *Node,
};
pub const UnaryNode = struct { un_op: u8, val: *Node };
pub const LogicNode = struct {
    log_op: *Node,
    val: *Node,
};
pub const CompNode = struct {
    comp_op: *Node,
    val: *Node,
};
pub const CastNode = struct { cast: *Node, val: *Node };
pub const WhileNode = struct {
    cond: *Node,
    body: *Node,
    init: ?*Node, //optional initializer to handle for loops
};
pub const IfNode = struct {
    cond: *Node,
    if_branch: *Node, // Block
    el_branch: ?*Node, // Block
};
pub const ReturnNode = struct { val: ?*Node };
pub const StringNode = struct {
    raw_val: []const u8,
};
pub const CharNode = struct {
    char: u8,
};
pub const IntNode = struct {
    val: i32,
};
pub const FloatNode = struct { val: f32 };
// and additional fields for complex types (arrays, structs, etc.) in the future
pub const TypeNode = extern struct {
    type_name: [*c]const u8,
    size: usize,
    alignment: usize,
};

pub const AssignmentNode = struct {
    declarator: *Node, // i.e. x in int x;
    initializer: ?*Node, // i.e. 5 in int x = 5;
};

pub const ConditionalExpressionNode = struct {
    logicalOperator: [*c]const u8,
    expr1: *Node,
    expr2: *Node,
};

pub const ExpressionStmtNode = struct {
    expr: ?*Node,
};

// This is the main AST node type
// It is a tagged union of all possible node types
// Each node type is a struct with its own fields
// Now when we create a new node, we specify its type and fill in the relevant fields
// This helps identify what kind of node it is and access its data accordingly alongside of enforcing type safety
pub const NodeTag = enum {
    Identifier, Constant, // Just wraps a literal with extra stuff?

    // Unlabeled
    Function,
    BlockItems,

    // Mathematical: Arith, Logic, Comp, Cast
    Binary, Unary, ConditionalExpressionNode, Comp, Cast,

    // Variables, Pointers and Arrays
    Declaration, Assignment,

    // Control Flow (If, Loops)
    WhileStmt, IfStmt, ReturnStmt,

    // Literals
    String, Char, Int, Float,

    // Types
    Type,

    // Statements
    ExpressionStmt,
};

pub const Node = union(NodeTag) {
    // Const Ident
    Identifier: *IdentifierNode,
    Constant: *ConstantNode,

    // Blocks and Function
    Function: *FunctionNode,
    BlockItems: *BlockItemsNode,

    // Arithmetic and Cast
    Binary: *BinaryNode,
    Unary: *UnaryNode,
    ConditionalExpressionNode: *ConditionalExpressionNode,
    Comp: *CompNode,
    Cast: *CastNode,

    // Vars
    Declaration: *DeclarationNode,
    Assignment: *AssignmentNode,

    // Control Flow
    WhileStmt: *WhileNode,
    IfStmt: *IfNode,
    ReturnStmt: *ReturnNode,

    // Literals
    String: *StringNode,
    Char: *CharNode,
    Int: *IntNode,
    Float: *FloatNode,

    // Types
    Type: *TypeNode,

    // Statements 
    ExpressionStmt: *ExpressionStmtNode
};

// Type information structure
// This can be expanded to include more type details as needed
// We can add enums for type kinds (int, float, string, etc.)
//=============
//Functions   =
//=============
// Function to get type information based on token
// This is based off the c11.tab.h tokens
// We can expand this function as we add more types
// For now, it handles int, float, and string types

// expand this function to handle the multicharacter operators
export fn make_conditional_expression_node(expr1: *Node, token: c.yytokentype, expr2: *Node) ?*Node {
    const CondExpNodePtr = std.heap.c_allocator.create(ConditionalExpressionNode) catch return null;

    std.debug.print("===> LOGICAL OPERATOR INFO FOR INPUT: {any}\n", .{token});
    switch (token) {
        c.GE_OP => {
            CondExpNodePtr.* = ConditionalExpressionNode{
                .logicalOperator = ">= ",
                .expr1 = expr1,
                .expr2 = expr2,
            };
        },
        c.LE_OP => {
            CondExpNodePtr.* = ConditionalExpressionNode{
                .logicalOperator = "<= ",
                .expr1 = expr1,
                .expr2 = expr2,
            };
        },
        c.EQ_OP => {
            CondExpNodePtr.* = ConditionalExpressionNode{
                .logicalOperator = "== ",
                .expr1 = expr1,
                .expr2 = expr2,
            };
        },
        c.NE_OP => {
            CondExpNodePtr.* = ConditionalExpressionNode{
                .logicalOperator = "!= ",
                .expr1 = expr1,
                .expr2 = expr2,
            };
        },
        c.AND_OP => {
            CondExpNodePtr.* = ConditionalExpressionNode{
                .logicalOperator = "&&",
                .expr1 = expr1,
                .expr2 = expr2,
            };
        },
        c.OR_OP => {
            CondExpNodePtr.* = ConditionalExpressionNode{
                .logicalOperator = "||",
                .expr1 = expr1,
                .expr2 = expr2,
            };
        },
        else => {
            CondExpNodePtr.* = ConditionalExpressionNode{
                .logicalOperator = "Error_Unknown_Op",
                .expr1 = expr1,
                .expr2 = expr2,
            };
        },
    }

    const node = std.heap.c_allocator.create(Node) catch return null;
    node.* = Node{ .ConditionalExpressionNode = CondExpNodePtr };

    return node;
}

export fn make_type_node(token: c.yytokentype) ?*Node {
    const type_node_ptr = std.heap.c_allocator.create(TypeNode) catch return null;
    std.debug.print("===> TYPE INFO FOR INPUT: {any}\n", .{token});
    switch (token) {
        c.FLOAT => {
            type_node_ptr.* = TypeNode{ .type_name = "float", .size = @sizeOf(f64), .alignment = @alignOf(f64) };
        },
        c.INT => {
            type_node_ptr.* = TypeNode{ .type_name = "int", .size = @sizeOf(i64), .alignment = @alignOf(i64) };
        },
        c.STRING_LITERAL => {
            type_node_ptr.* = TypeNode{ .type_name = "string", .size = @sizeOf([]const u8), .alignment = @alignOf([]const u8) };
        },
        else => {
            type_node_ptr.* = TypeNode{ .type_name = "unknown", .size = 0, .alignment = 0 };
        },
    }

    const node = std.heap.c_allocator.create(Node) catch return null;
    node.* = Node{ .Type = type_node_ptr };

    return node;
}

export fn make_identifier_node(name: [*c]const u8) ?*Node {
    // We create the identifier node
    const id_node = std.heap.c_allocator.create(IdentifierNode) catch return null;

    const name_copy = std.heap.c_allocator.dupe(u8, std.mem.span(name)) catch return null;

    // We set the name for the identifier node
    id_node.* = IdentifierNode{ .name = name_copy };

    // We create a *node that wraps a specific node type
    const node = std.heap.c_allocator.create(Node) catch return null;
    // We set the union to be of type Identifier and assign the created identifier node
    node.* = Node{ .Identifier = id_node };

    // We return the created node
    const n: *Node = @ptrCast(node);
    return n;
}

export fn make_constant_node(value: [*c]const u8, typeNode: TypeNode) ?*Node {
    // We create the constant node
    const const_node = std.heap.c_allocator.create(ConstantNode) catch return null;
    // We set the value and type information for the constant node
    const val_copy = std.heap.c_allocator.dupe(u8, std.mem.span(value)) catch return null;

    const_node.* = ConstantNode{ .value = val_copy, .typeNode = typeNode };

    // We create a *node that wraps a specific node type
    const node = std.heap.c_allocator.create(Node) catch return null;
    // We set the union to be of type Constant and assign the created constant node
    node.* = Node{ .Constant = const_node };

    // We return the created node
    const n: *Node = @ptrCast(node);
    return n;
}

export fn make_assignment_node(declarator: *Node, initializer: ?*Node) ?*Node {
    const assignment_node = std.heap.c_allocator.create(AssignmentNode) catch return null;

    if (initializer) |init| {
        assignment_node.* = .{ .declarator = declarator, .initializer = init };
    } else {
        assignment_node.* = .{ .declarator = declarator, .initializer = null };
    }

    const node = std.heap.c_allocator.create(Node) catch return null;
    node.* = Node{ .Assignment = assignment_node };
    return node;
}

// The initializer is optional, so it can be null if there is no initializer
// int x = 5;  // initializer is present
// int y;      // initializer is null
export fn make_declaration_node(typeNode: *Node, asgnNode: ?*Node) ?*Node {
    std.debug.print("make_declaration_node function reached\n", .{});
    // We create the declaration node
    const decl_node = std.heap.c_allocator.create(DeclarationNode) catch return null;
    if (asgnNode) |n| {
        decl_node.* = DeclarationNode{ .typeNode = typeNode.Type, .assignNode = n.Assignment };
    } else {
        decl_node.* = DeclarationNode{ .typeNode = typeNode.Type, .assignNode = null };
    }
    // We set the variable name, type, and optional initializer for the declaration node

    // We create a *node that wraps a specific node type
    const node = std.heap.c_allocator.create(Node) catch return null;
    // We set the union to be of type Declaration and assign the created declaration node
    node.* = Node{ .Declaration = decl_node };

    // We return the created node
    const n: *Node = @ptrCast(node);
    return n;
}

export fn make_binary_node(lhs: *Node, op: c_char, rhs: *Node) ?*Node {
    const binary_node = std.heap.c_allocator.create(BinaryNode) catch return null;
    const op_val: u8 = @intCast(op);
    binary_node.* = BinaryNode{ .lhs = lhs, .op = op_val, .rhs = rhs };

    const node = std.heap.c_allocator.create(Node) catch return null;

    node.* = Node{ .Binary = binary_node };

    const n: *Node = @ptrCast(node);
    return n;
}

export fn make_unary_node(un_op: u8, val: *Node) ?*Node {
    const unary_node = std.heap.c_allocator.create(UnaryNode) catch return null;

    unary_node.* = UnaryNode{ .un_op = un_op, .val = val };

    const node = std.heap.c_allocator.create(Node) catch return null;

    node.* = Node{ .Unary = unary_node };

    const n: *Node = @ptrCast(node);
    return n;
}

export fn make_int_node(val: i32) ?*Node { // FOR DEBUGGING
    const int_node = std.heap.c_allocator.create(IntNode) catch return null;

    int_node.* = IntNode{ .val = val };

    const node = std.heap.c_allocator.create(Node) catch return null;

    node.* = Node{ .Int = int_node };

    const n: *Node = @ptrCast(node);
    return n;
}

// =================
// | Stmt Creators |
// =================

export fn append_block_list(item: *Node, items: ?*Node) ?*Node {
    // If items is null, then we have a declaration node or statement node, create a new BlockItemsNode with the item as the first element
    if (items == null) {
        const block_items_node = std.heap.c_allocator.create(BlockItemsNode) catch return null;
        block_items_node.* = BlockItemsNode{ .items = @constCast(&[_]*Node{ item }) };

    const node = std.heap.c_allocator.create(Node) catch return null;
        node.* = Node{ .BlockItems = block_items_node }; // Wrap the BlockItemsNode in a Node

        return node;
    } else {
        // Otherwise, we have an existing BlockItemsNode, append the new item to its items array

        // Unwrap the items from Node
        const items_block = items.?.BlockItems;

        // Append the new item to the list in items_block
        const new_len = items_block.items.len + 1;
        const new_items = std.heap.c_allocator.alloc(*Node, new_len) catch return null;
        // Copy existing items
        @memcpy(new_items[0..items_block.items.len], items_block.items[0..items_block.items.len]);
        // std.mem.copy(*Node, new_items[0..items_block.items.len], items_block.items[0..items_block.items.len]);
        new_items[items_block.items.len] = item;

        // Create a new BlockItemsNode with the updated items
        const block_list_node = std.heap.c_allocator.create(BlockItemsNode) catch return null;
        block_list_node.* = BlockItemsNode{ .items = new_items[0..new_len] };

        // Wrap the items block in node and return
        const node = std.heap.c_allocator.create(Node) catch return null;
        node.* = Node{ .BlockItems = block_list_node }; // Wrap the BlockItemsNode in a Node
        return node;
    }
}

// =================
// | Stmt Creators |
// =================

export fn make_expr_stmt(expr: *Node) ?*Node {
   const expr_stmt = std.heap.c_allocator.create(ExpressionStmtNode) catch return null;
   expr_stmt.* = ExpressionStmtNode { .expr = expr };

   const stmt = std.heap.c_allocator.create(Node) catch return null;
   stmt.* = Node { .ExpressionStmt = expr_stmt };

   return stmt;
}

export fn make_if_stmt(cond: *Node, if_branch: *Node, el_branch: ?*Node) ?*Node {
    std.debug.print("make_if_stmt function reached\n", .{});

    const if_node = std.heap.c_allocator.create(IfNode) catch return null;

    if_node.* = IfNode{
        .cond = cond,
        .if_branch = if_branch,
        .el_branch = el_branch,
    };

    const node = std.heap.c_allocator.create(Node) catch return null;
    node.* = Node{ .IfStmt = if_node };

    return node;
}

export fn make_iteration_stmt(cond: *Node, body: *Node, init: ?*Node) ?*Node {
    std.debug.print("make_iteration_stmt function reached\n", .{});

    const while_node = std.heap.c_allocator.create(WhileNode) catch return null;

    while_node.* = WhileNode{
        .cond = cond,
        .body = body,
        .init = init,
    };

    const node = std.heap.c_allocator.create(Node) catch return null;
    node.* = Node{ .WhileStmt = while_node };

    return node;
}

pub fn printNode(orig_node: ?*Node, indent: usize) void {
    // Print indentation
    for (0..indent + 1) |_| std.debug.print("⎯⎯ ", .{});
    if (orig_node == null) {
        std.debug.print("Null", .{});
        return;
    }
    const node = orig_node.?;
    switch (node.*) {
        .Identifier => {
            const id_node = node.Identifier;
            std.debug.print("Identifier: {s}\n", .{id_node.name});
        },
        .Constant => {
            const const_node = node.Constant;
            std.debug.print("Constant: {s}\n", .{ const_node.value});
        },
        .Declaration => {
            const decl_node = node.Declaration;
            const new_type_string: []const u8 = std.mem.span(decl_node.typeNode.type_name);
            std.debug.print("Declaration, Type: {s}\n", .{new_type_string});
            if (decl_node.assignNode) |asgn| {
                for (0..indent + 2) |_| std.debug.print("⎯⎯ ", .{});
                std.debug.print("Assignment:\n", .{});
                printNode(asgn.initializer, indent + 2);
                const n: *Node = @ptrCast(asgn.declarator);
                printNode(n, indent + 2);
            }
        },
        .Assignment => {
            const asgn_node = node.Assignment;
            std.debug.print("Assignment:\n", .{});
            for (0..indent + 1) |_| std.debug.print("⎯⎯ ", .{});
            std.debug.print("Declarator:\n", .{});
            printNode(asgn_node.declarator, indent + 1);
            if (asgn_node.initializer) |init| {
                for (0..indent + 1) |_| std.debug.print("⎯⎯ ", .{});
                std.debug.print("Initializer:\n", .{});
                printNode(init, indent + 1);
            } else {
                for (0..indent + 1) |_| std.debug.print("⎯⎯ ", .{});
                std.debug.print("No initializer\n", .{});
            }
        },
        .Function => {
            const func_node = node.Function;
            const new_type_string: []const u8 = std.mem.span(func_node.retType.type_name);
            std.debug.print("Function: {s}, Return Type: {s}\n", .{ func_node.funcName, new_type_string });
            for (0..indent + 1) |_| std.debug.print("⎯⎯ ", .{});
            std.debug.print("Body:\n", .{});
            printNode(&func_node.body.*, indent + 2);
        },
        .BlockItems => {
            const block_node = node.BlockItems;
            std.debug.print("Block Node with {d} items:\n", .{block_node.items.len});
            for (block_node.items) |item| {
                printNode(item, indent + 1);
            }
        },
        .Binary => {
            const bin_node = node.Binary;
            std.debug.print("Binary Op: '{c}'\n", .{bin_node.op});
            for (0..indent + 1) |_| std.debug.print("⎯⎯ ", .{});
            std.debug.print("Left:\n", .{});
            printNode(bin_node.lhs, indent + 2);
            for (0..indent + 1) |_| std.debug.print("⎯⎯ ", .{});
            std.debug.print("Right:\n", .{});
            printNode(bin_node.rhs, indent + 2);
        },
        .Unary => {
            const un_node = node.Unary;
            std.debug.print("Unary Op: '{c}'\n", .{un_node.un_op});
            printNode(un_node.val, indent + 1);
        },
        .Comp => {
            const comp_node = node.Comp;
            std.debug.print("Comparison Node\n", .{});
            printNode(comp_node.comp_op, indent + 1);
            printNode(comp_node.val, indent + 1);
        },
        .Cast => {
            const cast_node = node.Cast;
            std.debug.print("Cast Node\n", .{});
            printNode(cast_node.cast, indent + 1);
            printNode(cast_node.val, indent + 1);
        },
        .WhileStmt => {
            const while_node = node.WhileStmt;
            std.debug.print("While Loop\n", .{});
            printNode(while_node.init, indent + 1);
            printNode(while_node.cond, indent + 1);
            printNode(while_node.body, indent + 1);
        },
        .IfStmt => {
            const if_node = node.IfStmt;
            std.debug.print("If Statement\n", .{});
            printNode(if_node.cond, indent + 1);
            std.debug.print("Then:\n", .{});
            printNode(if_node.if_branch, indent + 1);
            if (if_node.el_branch) |else_branch| {
                std.debug.print("Else:\n", .{});
                printNode(else_branch, indent + 1);
            }
        },
        .ReturnStmt => {
            const ret_node = node.ReturnStmt;
            std.debug.print("Return Statement\n", .{});
            if (ret_node.val) |val| printNode(val, indent + 1);
        },
        .String => std.debug.print("String: {s}\n", .{node.String.raw_val}),
        .Char => std.debug.print("Char: '{c}'\n", .{node.Char.char}),
        .Int => std.debug.print("Int: {d}\n", .{node.Int.val}),
        .Float => std.debug.print("Float: {d}\n", .{node.Float.val}),
        .Type => {
            const type_node = node.Type;
            const new_type_string: []const u8 = std.mem.span(type_node.type_name);
            std.debug.print("Type: {s} (size: {d}, align: {d})\n", .{ new_type_string, type_node.size, type_node.alignment });
        },
        .ConditionalExpressionNode => {
            const cond_node = node.ConditionalExpressionNode;
            std.debug.print("Conditional Expression\n", .{});
            std.debug.print("Logical Operator: {s}\n", .{cond_node.logicalOperator});
            std.debug.print("Expression 1:\n", .{});
            printNode(cond_node.expr1, indent + 1);
            std.debug.print("Expression 2:\n", .{});
            printNode(cond_node.expr2, indent + 1);
        },
        .ExpressionStmt => {
            const expr_stmt = node.ExpressionStmt;
            std.debug.print("Expression Stmt:\n", .{});
            printNode(expr_stmt.expr, indent + 1);
        }
    }
}
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢾⣿⣷⣮⣛⠷⢄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⣿⣿⡷⢦⡈⠑⢤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⣿⡥⠖⠀⠈⠲⣄⠙⢦⣀⡠⠤⠤⠤⢄⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⠄
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣟⡄⠀⠀⠀⠀⠈⠳⡤⣹⡄⠀⢀⣀⠀⠀⠀⠉⠑⠦⣀⠀⠀⠀⠀⣀⡠⠤⠖⠒⠋⢉⣠⣴⣾
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢻⣀⣤⣄⣠⢆⠄⣀⣵⢀⡽⠊⠁⠀⠉⠓⠔⠒⠒⠦⣈⣳⠤⠒⠉⠀⢀⣠⠴⢶⡿⠙⣹⣿⡟
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢉⣷⠞⠚⣳⣾⢟⡽⠋⠀⠀⢀⣀⣀⡀⠀⠀⡀⠀⠈⠳⣤⡠⠴⠾⢁⡠⠒⡾⢿⣿⡿⠋⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⢿⠇⢀⡞⠉⢡⠞⠀⠀⢀⣴⠿⠛⠋⣉⠒⠛⠻⣷⡄⠀⠘⣆⠀⡒⡁⢀⣼⠿⠟⠉⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡎⡏⢠⠞⠀⣰⢋⠆⠀⣰⠋⠁⢀⡴⠊⠁⠀⠀⠀⠘⣿⡄⠀⠘⡏⠉⠙⠋⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣸⢁⡏⠀⡼⡡⠈⠀⡰⠁⠀⡠⠋⠀⠀⠀⠀⠀⠀⠀⢘⣷⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣇⡇⡞⢀⡞⠙⠁⠀⣰⠁⢀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⢠⢿⡄⠀⠈⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡽⣸⣡⠏⠀⠠⢀⢰⠃⣴⠟⢡⢶⣿⠁⠀⠀⠀⣠⢆⣶⡟⠀⡇⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡞⣣⣟⣵⡮⠊⣠⢣⣿⣚⣣⡴⠞⠉⣿⠀⠀⠀⢈⣿⠞⡰⢧⠀⡇⠀⠀⢻⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣠⢼⣛⠥⠛⣁⡤⣞⣿⡿⣯⣭⣤⣭⣛⠶⢿⣁⣠⣴⢿⢋⡼⠁⠘⣦⡇⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢶⣿⣋⣩⠴⠒⣉⣥⣾⠟⢻⡇⠻⣿⣿⣿⣙⡇⠸⣏⣩⣶⣿⣿⣿⣯⣍⣽⠇⢠⡇⠈⡇⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⣻⡟⢋⠛⠛⣯⣿⡘⡜⡇⠀⠀⠀⠀⠤⠖⢚⣫⡴⠋⠺⢿⣯⣴⣿⣿⠆⡸⣧⡌⢷⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡿⢠⣿⠃⠄⣿⡇⢿⣦⣳⣄⠀⠀⠀⠀⠀⢾⣁⣳⠀⠀⠀⠀⣰⣿⡿⢀⢇⣿⣷⣜⣆⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡿⢡⢿⠏⠀⣼⣿⠀⠘⣿⣿⣇⠀⠀⠀⠀⠀⠀⠘⠁⠀⠀⢀⣼⣿⣿⡇⠈⣼⣿⣏⣿⡻⠇⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣳⠏⡞⠀⢰⣿⡿⢸⡠⢿⡿⠈⠳⣄⠀⠀⠉⠓⠒⠀⢀⣤⣾⣿⣿⡿⡄⣰⣿⢹⠙⠿⠷⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣷⠏⣸⠁⢠⡏⣿⡇⢸⡟⣾⣇⠀⠀⠈⠳⣄⠀⢀⣤⣾⣿⣿⣿⣿⣿⡿⣰⣿⣿⠸⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⠃⣰⠳⢰⠏⢐⢿⠇⢸⡇⣿⣿⣷⣦⣤⣤⣈⣩⣭⣿⣿⣿⣿⣿⣿⣿⠟⡟⣿⢿⣇⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡾⠃⣰⣿⡵⠋⢀⣠⣾⢠⣿⡃⡇⠀⠉⠛⠻⢿⡿⠟⡻⢿⣿⣏⠍⠙⡏⢻⣸⣹⣿⡞⣿⡸⡀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⡯⠒⠚⣿⡻⠯⣍⣹⡟⠁⣿⠿⣷⠃⠀⠀⠀⠀⢿⡿⠰⠁⠀⢳⡍⠓⠶⢧⣼⣿⢣⢿⣷⡘⣷⢧⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⠃⠀⠀⠀⠈⠻⣟⣻⣮⣥⣾⣟⣳⣿⣕⡒⢦⡤⣀⠀⠀⢀⣀⣀⣀⣹⣤⠤⠄⣼⡇⢸⣺⠛⠣⠼⣾⣧⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣷⠇⠀⠀⠀⠀⠀⠀⠈⠛⢭⡁⣸⣷⠿⠃⠀⠈⠉⠙⠎⠲⠤⠚⠁⠀⠀⠀⠙⣆⢸⣿⣤⣿⡏⠀⠀⠀⠀⠻⣷⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⡝⢹⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠽⣿⢋⠴⠋⠀⠀⠀⠀⠀⠀⣿⣧⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⠟⠀⣼⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣧⠀⠀⠀⠀⠀⠀⠀⠀⢸⢻⣧⡀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡾⠃⠀⡰⢻⡀⠀⠀⠀⠀⢠⡀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣧⠀⠀⠀⠀⢰⠀⠀⣼⠀⠙⢷⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⡟⠁⣠⠞⠁⠈⣇⠀⠀⠀⠀⠈⡷⠀⠀⠀⣾⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣇⢄⠀⢀⠏⠀⠀⣟⠣⡀⠀⠑⢄⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⣻⠋⢠⣼⡷⠀⠘⠀⢻⠀⠀⠀⠀⢸⠃⠀⠀⣸⡏⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣀⡞⠀⠀⢸⡏⠳⣌⣳⢤⡀⠉
// ⠀⠀⠀⠀⠀⠀⠀⠀⢀⢞⡝⢁⡶⢫⣿⠃⠀⠀⠀⢸⠀⠀⠀⠀⡏⠀⠀⢰⣿⣧⡘⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⢹⣿⣆⠀⠀⡼⠘⣄⠈⠻⣟⠿⢷
// ⠀⠀⠀⠀⠀⠀⢀⣴⡳⢋⡠⠋⢀⣾⠇⠀⠀⠀⠀⢸⡀⠀⠀⢸⡇⠀⢀⣿⣿⣿⣷⣌⣦⠀⠀⠀⠀⠀⡀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣎⣰⣿⣿⡆⢀⡇⠀⠘⢦⠀⠈⢦⠀
// ⠻⢍⣒⣒⡶⠾⢛⡟⣡⠎⠀⠀⣼⡟⠀⠀⠀⠀⠀⠘⡇⠀⠀⠘⣇⠀⢸⣿⣿⣿⣿⣿⣿⣷⡀⠀⠀⢀⡇⠀⠀⠸⡄⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⡗⢸⡃⠂⠀⠀⠱⣄⠀⠑
// ⠀⠀⠀⠀⠀⢠⢎⠜⠁⠀⠀⣸⡟⠀⠀⠀⠀⠀⢰⠀⣷⠀⠀⠀⢻⡄⢹⣿⣿⣿⣿⣿⣿⣿⣷⣄⣠⠞⠀⠀⠀⠀⢻⡄⠀⠀⢀⣠⣾⣿⣿⣿⣿⣿⣿⠃⣼⠯⠳⣄⠀⠀⠈⠢⡀
// ⠀⠀⠀⠀⢠⢣⠏⠀⠀⠀⢰⡿⠀⠀⠀⠀⠀⠀⡞⠀⢸⡄⠀⠀⠸⣿⣿⣿⣿⣿⣿⡿⠿⠿⣿⠟⠓⠒⠒⠒⠒⠒⠒⢿⡶⢶⣿⣿⣿⣿⣿⣿⣿⠿⠃⠀⣿⠀⠀⠘⢦⡀⠀⠀⠘
// ⠀⠀⠀⢠⣿⡏⠀⠀⠀⢀⣿⠃⠀⠀⠀⠀⠀⢠⠃⠀⠀⣧⠀⠀⠀⣿⠀⠀⠀⠀⠀⠁⣠⠞⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠢⡀⠉⠉⠉⢹⡏⠁⠀⠀⠀⣿⠀⠀⠀⠘⡆⠀⠀⠀
// ⠀⠀⢠⣿⢻⠁⠀⠀⢀⢾⠇⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⢸⡄⠀⠀⢹⡁⠀⠀⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢦⡀⠀⢸⠇⠀⠀⠀⢰⡇⠀⠀⠀⠀⠹⣄⠀⠀
// ⠀⢀⢿⢃⡜⠀⠀⢀⡎⡎⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣇⠀⠀⠈⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡿⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠙⠢
// ⠀⡸⡟⡸⡇⠀⠀⡞⡼⠁⢀⠆⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⢸⡆⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⡇⠇⠀⡇⠀⡜⢰⠃⣠⠋⢠⠇⠀⠀⠀⠀⠀⠘⠀⠀⠀⣿⠀⠀⠀⠀⣷⠀⠀⠀⠀⠘⡄⠀⠀⠀⠀⠀⠘⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢧⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⡇⠀⢀⡇⡼⢡⠏⠐⠁⢠⡟⠀⠀⠀⠀⠀⠀⠇⠀⠀⠀⣿⠀⠀⠀⠀⣸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢳⡀⠀⠀⠸⣇⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⣧⠀⠸⣿⠁⡞⠀⠀⢠⡟⠀⠀⠀⠀⠀⠀⠐⠀⠀⠀⢰⡇⠀⠀⠀⢀⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢳⡀⠀⠀⢻⡄⠀⠀⠀⠀⠀⠀⠀
// ⠀⠹⣧⠀⢱⣼⠁⢀⣴⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⣼⠁⠀⠀⠀⢀⣀⡀⠀⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣤⠀⠀⠀⠀⠀⠙⢦⡀⠀⢿⡀⠀⠀⠀⠀⠀⠀
// ⠀⠀⢹⣦⠘⡇⢀⣾⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢼⠀⠀⠀⢸⠇⠀⠀⠀⠀⠚⢻⡉⢢⣱⠀⠀⠀⢾⡆⠀⠀⢰⡟⠉⡞⢁⡀⠀⠀⠀⠀⠀⠀⢱⣄⠘⣇⠀⠀⠀⠀⠀⠀
// ⠀⠀⡎⡼⢁⡰⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⠀⠀⢀⣾⠀⠀⠀⠀⣰⠒⢀⣧⡾⣹⣄⡀⠀⠀⠀⢀⡤⠬⣝⢢⣷⢄⠈⢧⠀⠀⠀⠀⠀⣼⠋⢦⢻⠀⠀⠀⠀⠀⠀
// ⠀⡸⣸⢡⡾⣿⣹⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡄⠀⣼⠹⡆⠀⠀⠀⡇⣰⣿⢹⣱⠁⢠⣀⣠⣄⢤⣄⣠⠀⠈⡘⡎⢣⣷⣸⠀⠀⠀⠀⡼⠃⠀⠀⢻⡆⠀⠀⠀⠀⠀
// ⢰⢱⠇⣾⠁⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⢸⠃⠀⢻⡀⠀⠀⠱⣿⣷⠀⠹⣦⡈⠻⣿⣯⣽⡿⠋⣀⡼⢃⠇⣸⢷⡟⠀⠀⢠⡞⠁⠀⠀⠀⠀⣻⢆⠀⠀⠀⠀
// ⡏⡞⣬⠃⣸⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣧⣿⠀⠀⠀⠹⣄⠀⠈⠚⠯⢷⣦⠬⣭⣒⣺⣯⠻⣷⡾⠉⠒⡩⢾⠛⠉⠀⢀⣴⠟⠀⠀⠀⠀⠀⢠⡟⠘⢧⠀⠀⠀
// ⢹⢡⡿⣠⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡟⢧⣀⠀⠀⠘⢶⣄⠀⠀⠀⠁⢸⣁⣤⣔⢿⣿⣯⢊⣠⣷⡿⠀⠀⠀⣠⡾⠁⠀⠀⠀⠀⣀⡴⠋⠀⠀⠀⢣⠀⠀
// ⠀⠈⠱⠇⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⡾⠀⠀⠉⠳⢦⣄⡀⠙⢷⣄⠀⠀⠈⠻⠉⢙⣷⣿⣧⣿⡁⠘⠁⠀⢀⣴⠟⠀⠀⢀⣠⡴⠞⠋⠀⠀⠀⠀⠀⠀⢇⠀
// ⠀⠘⣠⣾⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣧⠀⠀⠀⠀⣰⡇⠀⠀⠀⠀⠀⠈⠙⠓⠶⣽⣷⣦⣀⠀⠀⠸⣌⠻⡟⢁⠇⠀⢀⣴⣿⣃⣠⡴⠞⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠄
// ⠀⢰⣿⡏⠀⠀⢠⠀⠀⠀⠀⠀⠀⠀⠀⠀⡜⡆⠀⠀⠀⣾⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣿⣶⣦⣬⣷⣶⣯⣴⣾⣿⣿⣿⣿⠏⠀⢀⡤⠖⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⢸⣿⠃⠀⠀⢸⠀⠀⠀⠀⠀⢐⢰⡀⠀⡆⡇⠀⠀⢠⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡡⠔⠊⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠
// ⠀⠘⣿⠀⠀⡀⢸⡀⠀⠀⠀⠀⠈⢸⣇⠀⣇⣇⠁⠀⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⢻⠀⠀⠣⢸⡇⠀⠀⠀⠀⠀⠀⣿⣷⣿⣿⠈⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠻⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
//
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⢣⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡤⠀⠀⢀⣀⡀⢄⣀⣀⣀⠀⠠⠀⠒⠀⠈⠉⠛⠩⡉⢂⠑⡄⠀⠐⠒⠂⠤⠄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢏⢢⠀⠀⠀⢀⠄⢊⠜⠋⠉⠁⠀⠀⠀⠀⠀⡠⠒⠉⠀⡠⠃⠑⠺⢄⠀⠀⠀⠀⠉⠑⠢⢄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡄⠑⣄⠈⡠⠊⠁⠀⠀⠀⠀⠀⠀⠀⢀⠔⢀⠀⠀⠘⠰⣆⠀⠀⠀⢢⠀⠀⠀⠂⠤⢄⡀⠈⠑⠤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠇⠀⣸⠊⠀⠀⠀⠀⠀⠀⠀⠀⡠⢂⠊⡰⠃⠀⠀⡆⠀⣏⠀⠀⠀⠀⠡⡀⠀⠀⠀⠀⠈⠁⠣⣔⡈⠢⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⠞⢁⠀⠀⠀⠀⠀⢀⠄⢀⠞⠀⢆⡜⠁⠀⠀⢰⠅⡀⠹⡇⠀⠀⠀⠀⠱⡀⠀⠀⠀⠀⠀⠀⠈⠉⠓⠚⠦⠄⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⡡⢋⡔⠁⠀⠀⠀⡰⢀⠎⠠⡝⠀⢸⡜⠀⠀⠀⢀⢃⢡⢣⠀⢣⠀⠀⠀⠀⠀⢡⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠠⢐⠖⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠮⡎⡝⠀⠀⠀⢀⡞⠁⡞⢠⡝⠀⠀⣿⠃⠀⠀⠀⡜⡌⡜⡼⣆⠈⢣⠀⠀⠀⠀⠈⠀⣀⣀⠀⠀⠀⠠⠄⠂⢁⠔⠋⢃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠴⠊⠁⡜⡌⠀⠀⠀⢒⠞⢲⠸⢧⣿⠁⠀⢀⡟⠀⢀⠆⢠⠡⡰⡇⡘⢿⣦⡀⠣⡀⠀⠀⠀⡆⢢⠀⠀⠀⠀⠀⣠⠖⠁⠀⠀⠈⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡙⠀⢠⠁⠀⡌⡄⣎⡗⡡⡌⠀⠀⡼⠇⠀⡜⠀⡬⢤⠧⣇⢱⠀⠑⠱⢄⡈⠢⢄⠀⠇⢢⢣⠀⠀⡠⡪⢲⡆⠀⠀⠀⠀⢣⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣬⠀⢠⡇⠀⡜⡠⠐⢹⡌⠀⡇⠀⢰⢸⠀⢀⠇⡷⡆⠸⠀⡇⢩⠂⢄⠀⠀⠈⠁⠀⠀⠁⡎⡆⡤⢊⠔⠀⠀⣇⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⢣⠀⣞⠁⢰⣯⣤⣤⡘⢅⠀⡇⠀⡄⡀⠀⢸⢠⢃⢀⡇⠀⣠⢨⠀⡇⠁⡆⠀⠀⠀⠀⠀⣇⠏⡗⠁⠀⠀⠀⢹⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⣄⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣎⢞⢰⢸⠀⡘⢈⣶⣶⣾⣵⠀⢳⡇⡇⡇⠀⢸⡎⣌⠸⠥⡀⠉⡄⠀⡇⠀⠀⠀⠀⠀⠀⠚⠀⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⡆⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡼⠃⡏⢸⠀⡀⣇⢸⠉⢻⡽⢟⠁⠘⢷⢻⡅⠀⣺⣿⣭⣭⣿⣰⢤⣱⠀⠃⢀⡀⠀⠀⠀⠀⠇⢸⠀⠀⠀⠀⠀⠀⡀⠀⠀⡄⠀⡸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⢰⡏⠀⣇⡿⡦⣃⡘⣁⠎⠀⠀⠈⢻⠱⡀⠘⠛⠿⣟⣻⣿⡷⡝⣷⠀⣸⠀⠀⢸⢀⢲⠀⡆⢰⠀⠀⡇⠀⢠⡇⠀⡸⠀⢀⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⡀⠐⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠿⣀⡏⣇⢞⢼⠉⠑⠈⠀⠀⠀⠀⠉⠻⢄⣆⠸⣻⠟⠁⠹⠅⣸⢀⡋⠀⠀⡎⡸⡈⠰⠀⡛⠀⢠⠇⢀⢳⠁⢰⢁⢼⡘⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀
// ⢠⠎⠉⠐⠀⠀⠸⡆⠀⠀⠀⠀⠀⠀⠠⠄⡀⠀⠀⠀⢹⠊⠈⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣘⠢⢤⣠⡔⣎⠀⡇⡌⠃⠀⡸⢠⢣⡇⢆⢠⠁⢠⢻⠀⣌⣸⠀⢃⠎⡸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀
// ⢸⣆⠀⠀⠀⠀⢸⠃⠀⠀⢰⠉⠑⠤⠃⠀⡇⠀⠀⠀⠀⢂⠀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀⠀⢲⣿⡟⣾⣾⡦⠱⣸⣿⠘⠀⣰⡡⠁⠸⣇⢀⠇⠀⠎⡌⣼⡪⢷⠸⠃⡰⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀
// ⠀⠙⠲⠤⠄⠀⠎⠀⠀⠀⠈⢆⢄⠀⠀⢠⠃⠀⠀⠀⠀⠀⠱⡀⠀⠀⠀⠀⠑⠀⠀⠀⠀⠀⠈⠉⡝⠚⠿⠃⠆⡝⡝⡆⡴⠟⢁⠂⢀⢋⣬⢀⢊⡜⡼⠋⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⠒⠂⠁⠀⠀⠀⠀⠀⠀⠀⠈⢢⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢰⣣⡘⡀⠀⡎⢀⡧⠂⡏⡰⢱⠊⠀⠀⠀⠈⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⠤⠀⣀⣀⣀⣀⣀⣀⣀⠀⠀⠤⠐⠂⠈⠋⡏⢱⢠⣿⡇⣬⣀⠀⢷⠁⠈⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠰⡉⠀⠀⡇⠀⠀⠀⠉⠀⠉⠉⠉⠉⠉⠁⣠⡔⠛⢆⠰⡼⣣⠀⠀⠀⠀⠀⠀⡠⠊⠀⡇⣿⣾⠛⠳⠇⠶⣭⣺⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠉⠀⠀⠀⠀⠀⠀⠀⠀⣀⠤⠤⠴⠿⡷⡀⠘⡄⢻⡿⠆⠀⠀⡠⠔⠁⠀⠀⣀⣿⣽⠟⠠⠠⠐⠂⠙⠋⣁⡅⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡜⠀⠀⠀⠀⠀⠱⡹⡄⢱⠈⣿⠘⡆⠁⠀⠀⣠⡖⠟⠋⣉⠠⠄⡀⠒⠂⠀⠋⠁⠩⣃⠒⢄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠁⠀⠀⠀⠀⠀⠀⢵⣿⡄⡇⢹⠘⠀⢀⣴⠟⢉⠤⡚⠭⠐⠈⠀⣀⠀⠠⠤⠀⠐⠂⠉⠉⠁⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⡀⠀⡇⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡜⠀⠀⠀⠸⡀⠀⠀⣸⣿⣿⣤⢸⠀⡴⠋⣠⡾⢛⠭⠔⠂⠈⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠤⠒⠀⠀⠐⠒⠤⢄⡀⠀⠀⠐⡀⡵⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠤⠤⡇⠀⠀⠀⠀⠀⠀⠀⢻⡇⠉⢻⣰⠊⣠⠾⠓⠉⠀⢀⡀⠀⣀⣤⣀⡀⠀⠀⠀⠀⠒⠂⠤⠤⢐⣣⠀⠀⠀⠀⠀⠀⠀⠀⡠⠊⠁⠀⠀⠀⠀⠀⠀⠀⠀⠈⡆⠀⠀⠀⠂⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠁⠀⠀⠀⠀⠀⠀⠸⣿⠡⠀⠀⠉⠉⠉⠉⠉⢩⣿⢼⡟⣅⠀⠀⠀⠀⠀⠀⠀⠠⠀⡀⠠⠀⠀⠀⠉⢢⡀⠀⠀⠀⢀⠞⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡿⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡄⠀⠀⠀⢀⠁⠀⡄⣿⠀⠀⠀⠀⠀⠀⠀⢠⡿⣹⠀⢰⠸⡀⠀⠀⠀⠀⠀⠀⡠⠊⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⡰⠁⠀⠀⠀⣀⠔⠊⠁⠈⠉⠒⠠⠔⠊⠁⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡎⡇⠀⠀⠀⢸⠀⠀⣧⠁⠀⠀⠀⠀⠀⠀⢀⢧⠃⣿⠀⠈⡀⡇⠀⠀⠀⢀⡶⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⡜⠀⠀⠀⢀⠎⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠇⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡘⠀⡇⠀⠀⠀⠘⠀⠀⣋⡇⠀⠀⠀⠀⠀⠀⡸⡜⠀⢻⠀⠀⡇⢣⠀⠀⡠⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠀⠘⠀⠀⠀⢠⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠒⠒⠒⠒⠒⠒⢢
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡅⠀⠁⠀⠀⠀⡀⠀⢰⡿⡇⠀⠀⠀⠀⠀⠀⡇⡇⢰⢸⣰⠀⢱⢸⠀⡐⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠇⠀⡇⠀⠀⠀⠎⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⡇⠀⢸⣷⠁⠀⠀⠀⠀⠀⢠⢻⠀⡘⢸⣷⣀⠼⣼⡐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠎⠀⢐⠁⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢁⠀⠀⠀⠀⠀⡇⠀⠸⣯⠀⠀⠀⠀⠀⠀⠸⡾⠿⣿⡟⢽⠁⠊⢡⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠞⠤⠤⠼⠀⠀⠀⢸⠠⠤⠤⠤⠤⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡀⠀⠀⠀⠀⢰⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⡼⡇⢸⠀⢠⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠎⠆⠀⠀⠀⡆⠀⠀⠀⢇⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢣⠀⠀⠀⠀⠀⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⡇⢸⠀⠎⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠂⡜⠀⠀⠀⠀⠸⡀⠀⠀⠀⠣⣀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⡆⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢷⣞⡘⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⣠⠊⠀⠀⠀⠀⠀⠀⠱⡀⠀⠀⠀⢈⠓⢄⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⠀⠀⠀⠀⠁⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢈⠜⠀⠀⡠⠊⠀⠀⠀⠀⠀⠀⡠⠊⡜⠀⠀⠀⠀⠀⠀⠀⠀⠘⢄⠀⠀⠀⠠⡀⠑⢅⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡄⠀⠇⠀⠀⣸⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠊⠀⢀⠜⠀⠀⠀⠀⠀⠀⡠⠊⠀⡰⢠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⢄⠀⠀⠈⠀⠀⠑⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠘⡄⠸⠀⢠⢀⠂⠀⢃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⡠⠃⠀⠀⠀⠀⠀⡠⠊⠀⠀⡰⠁⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⢄⠀⠀⠀⠄⠀⢣⠤⠤⠤⠤⠀⠀⠀⠀⠀⠀⠤⠤⠤⠤⠼
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠘⠄⠀⠀⠘⠈⠄⠈⡄⠀⠀⠀⠀⠀⠀⠀⠀⣄⠜⠀⠀⠀⠀⠀⡠⠊⠀⡠⢀⡌⠀⡠⢠⠱⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢡⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢣⠀⠈⠄⠀⠀⢇⠈⢆⠰⡀⠀⠀⠀⠀⠀⠀⡠⠃⠀⠀⠀⠀⠀⢀⠠⠀⢁⠔⡙⠀⠌⠀⢸⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠐⠀⢱⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡆⠈⡄⠀⠈⠀⠀⠘⡄⠀⢂⢣⠀⠀⠀⠀⠀⠜⠀⠀⠀⠀⠀⠀⠂⠁⠀⡠⠂⠰⠁⠌⠀⠀⠀⠀⡼⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⢡⠀⠀⠀⠀⠀⢇⠣⠀⠊⠆⠀⠀⠀⡌⠀⠀⠀⠀⠀⠀⠀⢀⠔⠉⠀⢀⠃⡜⠀⠀⠀⠇⢜⠠⠈⢢⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡆⠀⠀⠀⢰⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠘⡄⠀⠀⠀⢸⠘⡀⠡⡀⠨⡄⠀⡘⠀⠀⠀⠀⠀⠀⡠⠂⠁⠀⠀⠀⡌⠰⠁⠀⠀⢠⠌⡜⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⡰⠁⠀⠀⢀⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠆⠀⢃⠀⠀⠀⠘⡄⢃⢀⠘⢄⠈⢲⠁⠀⠀⠀⠀⠄⠊⠀⠠⠐⠈⠀⡸⢠⠁⠀⠀⡠⠊⠰⠀⠀⠀⠀⡗⡄⠀⠀⠀⠀⠀⠀⢀⠔⠁⠀⠀⢀⠎⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠈⠄⠈⡄⠀⠀⡀⣇⠘⡀⠑⢄⠑⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⢡⢃⠂⠀⠀⠔⠁⡰⠁⠀⠀⠀⠀⡇⠘⡄⠀⠀⠀⢀⠔⠁⠀⠀⠀⡠⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠃⠀⠈⠄⠘⡀⠀⠀⡇⢀⠰⠀⠀⡜⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠃⠀⠀⡠⠊⢀⠔⠁⠀⠀⠀⠀⠀⡇⠀⠘⠄⢀⠔⠁⠀⠀⠀⢈⠔⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠈⢂⠀⠀⠀⢸⡄⢂⢁⠜⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠊⠀⠀⠊⠀⠐⠁⠀⠀⠀⠀⠀⠀⢀⠀⠠⠠⡈⠅⠀⠀⠀⢀⠔⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡾⠀⠀⠀⠀⠀⠀⠀⢸⢁⣠⠎⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⠀⠀⠀⠑⡈⠄⡠⠔⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠤⠺⣏⠳⣄⠀⠀⠀⠀⠀⠀⣘⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⡻⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡆⠀⠀⠀⠀⠈⠜⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠤⠚⠁⠀⠀⡇⠉⠺⣛⢦⠤⠤⢶⣟⣽⡙⡵⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⢡⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠀⠀⠀⠀⠀⠀⠈⢱⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⢀⠤⠪⠁⠀⠀⠀⠀⠀⡇⠀⠀⠀⠉⠁⠈⡟⣻⡿⠑⢼⢞⢢⡀⠀⠀⠀⠀⠀⠀⠀⢁⣴⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠃⠀⠀⠀⠀⠀⠀⠀⠀⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⢀⣴⠊⠁⠀⠀⠀⠀⠀⠀⠀⠀⢧⡂⠄⢀⠀⢀⣼⢰⠋⠀⠀⠀⠑⠍⣚⡷⠶⢲⡶⠶⠶⢿⡛⣿⢇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡴⢪⠋⠀⠀⢠⣖⣢⠄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⢠⠏⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢦⢓⠢⠤⠤⣬⢞⢆⠀⠀⠀⠀⠀⠀⠈⠁⠀⠛⠒⠀⣡⣾⠘⣦⣕⠤⡀⠀⠀⠀⣶⡆⠀⣶⡦⠀⠀⠀⠠⢐⣤⢶⢾⢿⡔⠁⠀⠀⣰⡟⠀⠀⠈⠁⠘⠲⡠⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⢀⡎⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢸⠀⢰⢰⢡⠂⠈⠢⡀⠀⠀⠀⠀⠀⠀⠀⢀⡠⠊⡱⢡⠊⠁⠀⠁⡈⢆⠀⢀⣀⡀⠀⠉⠀⠀⠀⣀⡴⠛⢹⠀⠀⠸⠀⠀⠀⣰⡟⠀⠀⠀⠀⠀⠀⠀⠈⠑⢏⠡⠶⠤⣀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⢸⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡼⣸⠈⣼⢁⠂⠄⢀⠙⢢⣀⣀⣀⣀⣀⠀⠀⠠⠤⣧⠇⠀⠀⠀⠀⠀⠈⠉⠉⠉⠛⠛⠻⢆⠴⠛⠁⠀⠀⡏⠀⢠⠃⢒⡮⠋⠁⠙⢶⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢢⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠘⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠧⣿⣰⠂⠄⠎⣠⡏⣰⣟⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⡰⠁⢀⠊⠀⠀⠀⠀⢘⡌⠄⡀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⠃⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠙⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣼⡜⣼⣿⣼⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡪⠁⡴⠃⡀⣀⢄⡐⠠⠅⠒⠒⠂⠉⠉⠉⠉⠉⠉⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠈⠳⣠⠄⡀⠀⠀⠀⣀⠀⡀⠀⠐⠒⠊⢉⣉⣻⡟⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⠄⠊⢁⠩⠟⠛⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠁⠪⠤⡤⠥⠔⠒⠒⠒⠒⠈⠁⠀⠀⣼⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠤⠤⠤⠤⢤⡤⢶⠒⣰⣨⣧⡧⠔⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠠⠐⣦⡷⢟⣫⢷⡝⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⡠⠄⠂⠀⠀⢀⡠⠜⠛⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠂⢁⣀⣀⡀⠤⠚⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⠤⢀⣀⣀⡀⠀⠀⠀⢀⣈⡰⠤⠒⠈⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
