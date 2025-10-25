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
    retType: *TypeNode,
    nameParam: *NameParameterNode,
    body: *BlockItemsNode,
};
pub const FunctionCallNode = struct {
    name: *Node,
    args: ?*Node,
};
pub const ArgumentListNode = struct {
    args: []*Node,
};
pub const ParameterListNode = struct {
    params: []*Node, // a list of parameter nodes
};
pub const NameParameterNode = struct {
    name: *IdentifierNode,
    parameterList: ?*ParameterListNode,
};
pub const BlockItemsNode = struct { items: []*Node }; // A list of statements/declarations in a block

pub const BinaryNode = struct {
    lhs: *Node,
    op: u8,
    rhs: *Node,
};
pub const UnaryNode = struct { un_op: u8, val: *Node };
// Should combind this with UnaryNode and just make them both strings at one point
pub const PostFixNode = struct {
    post_op: []const u8,
    val: *Node,
};
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
pub const BaseType = enum(u8) {
    INT,
    FLOAT,
    STRING,
    CHAR,
    LONG,
    SHORT,
    DOUBLE,
    BOOL,
    VOID
};
pub const TypeNode = extern struct {
    is_unsigned: bool = false,
    is_const: bool = false,
    qualifier: usize = 0, // 0 none, 1 long, 2 long long
    base: BaseType = .INT,
    type_name: [*c]const u8 = "INT",
    size: usize = @sizeOf(i32),
    alignment: usize = @alignOf(i32),
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

pub const PointerNode = struct {
    pointee: ?*Node,
};

pub const IdPointerNode = struct { pointer: *Node, identifier: *Node };

// This is the main AST node type
// It is a tagged union of all possible node types
// Each node type is a struct with its own fields
// Now when we create a new node, we specify its type and fill in the relevant fields
// This helps identify what kind of node it is and access its data accordingly alongside of enforcing type safety
pub const NodeTag = enum {
    Identifier,
    Constant, // Just wraps a literal with extra stuff?

    // Unlabeled
    // Functions
    Function,
    FunctionCall,
    ArgumentList,
    ParameterList,
    NameParameterNode,
    // Blocks
    BlockItems,

    // Mathematical: Arith, Logic, Comp, Cast
    Binary,
    Unary,
    PostFix,
    ConditionalExpression,
    Comp,
    Cast,

    // Variables, Pointers and Arrays
    Declaration,
    Assignment,

    // Control Flow (If, Loops)
    WhileStmt,
    IfStmt,
    ReturnStmt,

    // Literals
    String,
    Char,
    Int,
    Float,

    // Types
    Type,

    // Statements
    ExpressionStmt,

    // Pointers
    Pointer,
    IdPointer,
};

pub const Node = union(NodeTag) {
    // Const Ident
    Identifier: *IdentifierNode,
    Constant: *ConstantNode,

    // Blocks and Function
    Function: *FunctionNode,
    FunctionCall: *FunctionCallNode,
    ArgumentList: *ArgumentListNode,
    ParameterList: *ParameterListNode,
    NameParameterNode: *NameParameterNode,
    BlockItems: *BlockItemsNode,

    // Arithmetic and Cast
    Binary: *BinaryNode,
    Unary: *UnaryNode,
    PostFix: *PostFixNode,
    ConditionalExpression: *ConditionalExpressionNode,
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
    ExpressionStmt: *ExpressionStmtNode,

    // Pointers
    Pointer: *PointerNode,
    IdPointer: *IdPointerNode,
};

// Type information structure
// This can be expanded to include more type details as needed
// We can add enums for type kinds (int, float, string, etc.)
//=============
//Functions   |
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
                .logicalOperator = ">=",
                .expr1 = expr1,
                .expr2 = expr2,
            };
        },
        c.LE_OP => {
            CondExpNodePtr.* = ConditionalExpressionNode{
                .logicalOperator = "<=",
                .expr1 = expr1,
                .expr2 = expr2,
            };
        },
        c.EQ_OP => {
            CondExpNodePtr.* = ConditionalExpressionNode{
                .logicalOperator = "==",
                .expr1 = expr1,
                .expr2 = expr2,
            };
        },
        c.NE_OP => {
            CondExpNodePtr.* = ConditionalExpressionNode{
                .logicalOperator = "!=",
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
    node.* = Node{ .ConditionalExpression = CondExpNodePtr };

    return node;
}
export fn combine_type_node(left_type: ?*Node, right_type: ?*Node) ?*Node {
    // null check
    if (left_type == null) return right_type;
    if (right_type == null) return left_type;

    const new_type = std.heap.c_allocator.create(TypeNode) catch return null;
    if(left_type != null and right_type != null) {
        const rt = right_type.?;
        const lt = left_type.?;
        const new_base = rt.Type.base;
        const new_sign = lt.Type.is_unsigned or rt.Type.is_unsigned;
        const new_const = lt.Type.is_const or rt.Type.is_const;
        var alignment: usize = 0;
        var size: usize = 0;
        switch(new_base) {
            .BOOL => { alignment = @alignOf(bool); size = @sizeOf(bool); },
            .DOUBLE => { alignment = @alignOf(f64); size = @sizeOf(f64); },
            .FLOAT => { alignment = @alignOf(f32); size = @sizeOf(f32); },
            .INT => { alignment = @alignOf(i32); size = @sizeOf(i32); },
            .LONG => { alignment = @alignOf(i64); size = @sizeOf(i64); },
            .CHAR => { alignment = @alignOf(u8); size = @sizeOf(u8); },
            .SHORT => { alignment = @alignOf(i32); size = @sizeOf(i32); },
            else => { alignment = @alignOf(void); size = @sizeOf(void); }
        }
        const new_qual = rt.Type.qualifier + lt.Type.qualifier;

        const alloc = std.heap.c_allocator;
        var name_parts: std.ArrayList([]const u8) = .empty;
        if(new_const) _ = name_parts.append(alloc, "const") catch {};
        if(new_sign) _ = name_parts.append(alloc, "unsigned") catch {};
        if(new_qual == 1) _ = name_parts.append(alloc, "long") catch {};
        if(new_qual >= 2) _ = name_parts.append(alloc, "long long") catch {};
        const base_name = switch (new_base) {
            .BOOL => "bool",
            .CHAR => "char",
            .SHORT => "short",
            .INT => "int",
            .LONG => "long",
            .FLOAT => "float",
            .DOUBLE => "double",
            .VOID => "void",
            else => "unknown",
        };
        if (!(new_base == .INT or new_base == .LONG) or new_qual == 0) {
            _ = name_parts.append(alloc, base_name) catch {};
        }
        const new_name = std.mem.join(alloc, " ", name_parts.items) catch "unknown";
        new_type.* = TypeNode {
            .base = new_base, .is_const = new_const, .is_unsigned = new_sign, 
            .alignment = alignment, .size = size, 
            .type_name = new_name.ptr, .qualifier = new_qual
        };
    }
    const node = std.heap.c_allocator.create(Node) catch return null;
    node.* = Node {.Type = new_type};
    return node;
}
export fn make_type_node(token: c.yytokentype) ?*Node {
    const type_node_ptr = std.heap.c_allocator.create(TypeNode) catch return null;
    std.debug.print("===> TYPE INFO FOR INPUT: {any}\n", .{token});
    switch (token) {
        c.FLOAT => {
            type_node_ptr.* = TypeNode{ .base = .FLOAT };
        },
        c.DOUBLE => {
            type_node_ptr.* = TypeNode{ .base = .DOUBLE };
        },
        c.INT => {
            type_node_ptr.* = TypeNode{ .base = .INT };
        },
        c.LONG => {
            type_node_ptr.* = TypeNode{ .base = .INT, .qualifier = 1 };
        },
        c.STRING_LITERAL => {
            type_node_ptr.* = TypeNode{ .base = .STRING };
        },
        c.UNSIGNED => {
            type_node_ptr.* = TypeNode { .base = .INT, .is_unsigned = true };
        },
        else => {
            type_node_ptr.* = TypeNode{ .base = .VOID };
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

export fn make_post_fix_node(val: *Node, token: c.yytokentype) ?*Node {
    const postfix_node = std.heap.c_allocator.create(PostFixNode) catch return null;

    switch (token) {
        c.INC_OP => {
            postfix_node.* = PostFixNode{
                .post_op = "++",
                .val = val,
            };
        },
        c.DEC_OP => {
            postfix_node.* = PostFixNode{
                .post_op = "--",
                .val = val,
            };
        },
        else => {
            postfix_node.* = PostFixNode{
                .post_op = "Error_Unknown_Op",
                .val = val,
            };
        },
    }

    const node = std.heap.c_allocator.create(Node) catch return null;
    node.* = Node{ .PostFix = postfix_node };
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
export fn make_string_node(raw_val: [*c]const u8) ?*Node {
    const string_node = std.heap.c_allocator.create(StringNode) catch return null;
    const val_copy = std.heap.c_allocator.dupe(u8, std.mem.span(raw_val)) catch return null;
    string_node.* = StringNode{ .raw_val = val_copy };

    const node = std.heap.c_allocator.create(Node) catch return null;
    node.* = Node{ .String = string_node };
    return node;
}

// =================
// | Stmt Creators |
// =================

export fn append_block_list(item: *Node, items: ?*Node) ?*Node {
    // If items is null, then we have a declaration node or statement node, create a new BlockItemsNode with the item as the first element
    if (items == null) {
        std.debug.print("\nNEW BLOCK LIST CREATED:\n", .{});
        const block_items_node = std.heap.c_allocator.create(BlockItemsNode) catch return null;

        const new_items = std.heap.c_allocator.alloc(*Node, 1) catch return null;
        new_items[0] = item;

        block_items_node.* = BlockItemsNode{ .items = new_items };

        const node = std.heap.c_allocator.create(Node) catch return null;
        node.* = Node{ .BlockItems = block_items_node }; // Wrap the BlockItemsNode in a Node
        return node;
    } else {
        // Otherwise, we have an existing BlockItemsNode, append the new item to its items array
        std.debug.print("\nADDING TO OLD LIST\n", .{});
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

// ======================
// | Functions Creators |
// ======================
// We may need to change it to a run time array
// [_]*Node{item} creates an array literal of pointers to Node with a single element 'item'
// This size is fixed at compile time to 1
// &[_]*Node{item} takes the address of this fixed array
// @constCast removes the const qualifier from the array type but its still a fixed size array
// With a runtime array alloc(*Node, 1) allocates memory for 1 element at runtime
// Returns a slice ([]*Node) that can be resized later
// You can create new slices with different sizes and copy data between them
export fn append_parameter_list(item: *Node, items: ?*Node) ?*Node {
    // If items is null, then we have a declaration node so we, create a new ParameterListNode with the item as the first element
    if (items == null) {
        std.debug.print("\nCREATING PARAM LIST:\n", .{});
        // create the ParameterListNode
        const parameter_items_node = std.heap.c_allocator.create(ParameterListNode) catch return null;
        // initialize it with the single item which

        // Lets try doing a runtime array with space for one item
        const new_params = std.heap.c_allocator.alloc(*Node, 1) catch return null;
        new_params[0] = item;

        // Set the params field
        parameter_items_node.* = ParameterListNode{ .params = new_params };

        const node = std.heap.c_allocator.create(Node) catch return null;
        node.* = Node{ .ParameterList = parameter_items_node };
        std.debug.print("Param: {any}\n", .{item});
        return node;
    } else {
        // Otherwise, we have an existing BlockItemsNode, append the new item to its items array

        // Unwrap the items from Node
        const items_block = items.?.ParameterList;

        // Append the new item to the list in items_block
        const new_len = items_block.params.len + 1;
        const new_params = std.heap.c_allocator.alloc(*Node, new_len) catch return null;

        // Copy existing items
        @memcpy(new_params[0..items_block.params.len], items_block.params);
        // std.mem.copy(*Node, new_items[0..items_block.items.len], items_block.items[0..items_block.items.len]);
        new_params[items_block.params.len] = item;

        // Create a new BlockItemsNode with the updated items
        const parameter_list_node = std.heap.c_allocator.create(ParameterListNode) catch return null;
        parameter_list_node.* = ParameterListNode{ .params = new_params };
        // Wrap the items block in node and return
        const node = std.heap.c_allocator.create(Node) catch return null;
        node.* = Node{ .ParameterList = parameter_list_node };
        std.debug.print("\nAdding to OLD LIST\n", .{});
        std.debug.print("Param: {any}\n", .{item});
        return node;
    }
}

export fn make_name_parameter_node(name: *Node, parameterList: ?*Node) ?*Node {
    const name_param_node = std.heap.c_allocator.create(NameParameterNode) catch return null;

    if (parameterList) |pl| {
        name_param_node.* = NameParameterNode{
            .name = name.Identifier,
            .parameterList = pl.ParameterList,
        };
    } else {
        name_param_node.* = NameParameterNode{
            .name = name.Identifier,
            .parameterList = null,
        };
    }

    const node = std.heap.c_allocator.create(Node) catch return null;
    node.* = Node{ .NameParameterNode = name_param_node };

    return node;
}

export fn make_return_node(ret_val: ?*Node) ?*Node {
    const ret_node = std.heap.c_allocator.create(ReturnNode) catch return null;
    ret_node.* = ReturnNode{ .val = ret_val };

    const node = std.heap.c_allocator.create(Node) catch return null;
    node.* = Node{ .ReturnStmt = ret_node };

    return node;
}

export fn make_function_node(retType: *Node, nameParameter: *Node, body: *Node) ?*Node {
    const function_node = std.heap.c_allocator.create(FunctionNode) catch return null;

    function_node.* = FunctionNode{
        .retType = retType.Type,
        .nameParam = nameParameter.NameParameterNode,
        .body = body.BlockItems,
    };

    const node = std.heap.c_allocator.create(Node) catch return null;
    node.* = Node{ .Function = function_node };

    return node;
}
export fn append_argument_list(item: *Node, items: ?*Node) ?*Node {
    if (items == null) {
        const arg_list_node = std.heap.c_allocator.create(ArgumentListNode) catch return null;

        const new_args = std.heap.c_allocator.alloc(*Node, 1) catch return null;
        new_args[0] = item;

        // Set the params field
        arg_list_node.* = ArgumentListNode{ .args = new_args };

        const node = std.heap.c_allocator.create(Node) catch return null;
        node.* = Node{ .ArgumentList = arg_list_node };
        return node;
    } else {
        const items_block = items.?.ArgumentList;

        const new_len = items_block.args.len + 1;
        const new_args = std.heap.c_allocator.alloc(*Node, new_len) catch return null;

        // Copy existing items
        @memcpy(new_args[0..items_block.args.len], items_block.args);
        new_args[items_block.args.len] = item;

        // Create a new BlockItemsNode with the updated items
        const args_list_node = std.heap.c_allocator.create(ArgumentListNode) catch return null;
        args_list_node.* = ArgumentListNode{ .args = new_args };
        // Wrap the items block in node and return
        const node = std.heap.c_allocator.create(Node) catch return null;
        node.* = Node{ .ArgumentList = args_list_node };
        return node;
    }
}

export fn make_function_call_node(name: *Node, args: ?*Node) ?*Node {
    const fc_node = std.heap.c_allocator.create(FunctionCallNode) catch return null;

    fc_node.* = FunctionCallNode{
        .name = name,
        .args = args,
    };

    const node = std.heap.c_allocator.create(Node) catch return null;
    node.* = Node{ .FunctionCall = fc_node };

    return node;
}

// =================
// | Stmt Creators |
// =================

export fn make_expr_stmt(expr: *Node) ?*Node {
    const expr_stmt = std.heap.c_allocator.create(ExpressionStmtNode) catch return null;
    expr_stmt.* = ExpressionStmtNode{ .expr = expr };

    const stmt = std.heap.c_allocator.create(Node) catch return null;
    stmt.* = Node{ .ExpressionStmt = expr_stmt };

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

export fn make_iteration_stmt(cond: *Node, body: *Node, init: ?*Node, post_expr: ?*Node) ?*Node {
    std.debug.print("make_iteration_stmt function reached\n", .{});

    // make new body with old body and post_expr
    var new_body: *Node = body;
    if (post_expr) |pe| {
        // create expr_stmt for post_expr
        const expr_stmt = make_expr_stmt(pe);
        if (expr_stmt) |es| {
            new_body = append_block_list(es, body).?;
        }
    }

    // create while node
    const while_node = std.heap.c_allocator.create(WhileNode) catch return null;
    while_node.* = WhileNode{
        .cond = cond,
        .body = new_body,
        .init = init,
    };

    const node = std.heap.c_allocator.create(Node) catch return null;
    node.* = Node{ .WhileStmt = while_node };

    return node;
}
// ===============
// | Pointer     |
// ===============
export fn make_pointer_node(pointee: ?*Node) ?*Node {
    const pointer_node = std.heap.c_allocator.create(PointerNode) catch return null;

    pointer_node.* = PointerNode{
        .pointee = pointee,
    };

    const node = std.heap.c_allocator.create(Node) catch return null;

    node.* = Node{ .Pointer = pointer_node };

    const n: *Node = @ptrCast(node);
    return n;
}

export fn make_idpointer_node(pointer: *Node, id: *Node) ?*Node {
    const pointer_node = std.heap.c_allocator.create(IdPointerNode) catch return null;
    pointer_node.* = IdPointerNode{
        .pointer = pointer,
        .identifier = id,
    };

    const node = std.heap.c_allocator.create(Node) catch return null;
    node.* = Node{ .IdPointer = pointer_node };
    const n: *Node = @ptrCast(node);
    return n;
}

// ===============
// | AST Printer |
// ===============

pub fn printIndent(indent: usize) void {
    for (0..indent) |_| {
        std.debug.print("│  ", .{});
    }
}
pub fn printNode(orig_node: ?*Node, indent: usize) void {
    if (orig_node == null) {
        printIndent(indent);
        std.debug.print("Null/Uninitialized\n", .{});
        return;
    }

    const node = orig_node.?;

    printIndent(indent);
    switch (node.*) {
        .Identifier => {
            const id_node = node.Identifier;
            std.debug.print("🟦 Identifier: {s}\n", .{id_node.name});
        },
        .Constant => {
            const const_node = node.Constant;
            std.debug.print("🟪 Constant: {s}\n", .{const_node.value});
        },
        .Declaration => {
            const decl_node = node.Declaration;
            const type_str = std.mem.span(decl_node.typeNode.type_name);
            std.debug.print("🌊 Declaration (Type: {s})\n", .{type_str});

            if (decl_node.assignNode) |asgn| {
                printIndent(indent + 1);
                std.debug.print("↳ Assignment:\n", .{});
                printNode(asgn.initializer, indent + 2);
                const n: *Node = @ptrCast(asgn.declarator);
                printNode(n, indent);
            }
        },
        .Assignment => {
            const asgn = node.Assignment;
            std.debug.print("⬜ Assignment\n", .{});

            printIndent(indent + 1);
            std.debug.print("↳ Declarator:\n", .{});
            printNode(asgn.declarator, indent + 1);

            if (asgn.initializer) |init| {
                printIndent(indent + 1);
                std.debug.print("↳ Initializer:\n", .{});
                printNode(init, indent + 1);
            } else {
                printIndent(indent + 1);
                std.debug.print("(no initializer)\n", .{});
            }
        },
        .Function => {
            const func = node.Function;
            const type_str = std.mem.span(func.retType.type_name);

            std.debug.print("🟩 Function: {s} (returns {s})\n", .{
                func.nameParam.name.name, type_str,
            });

            printIndent(indent + 1);
            std.debug.print("↳ Body:\n", .{});

            if (func.body.items.len == 0) {
                printIndent(indent + 1);
                std.debug.print("(empty block)\n", .{});
                return;
            }

            for (func.body.items) |item| printNode(item, indent + 1);
        },
        .FunctionCall => {
            std.debug.print("📞 Function Call\n", .{});
            const fc = node.FunctionCall;
            printNode(fc.name, indent + 1);
            if (fc.args) |args| {
                printIndent(indent + 2);
                std.debug.print("↳ 📋 Argument List\n", .{});
                printNode(args, indent + 1);
            }
        },
        .ArgumentList => {
            const args = node.ArgumentList;
            for (args.args) |arg| {
                // std.debug.print("Argument DEBUG: {any}\n", .{arg});
                printNode(arg, indent + 1);
            }
        },
        .BlockItems => {
            const blk = node.BlockItems;
            std.debug.print("Block: \n", .{});
            for (blk.items) |item| printNode(item, indent);
        },
        .Binary => {
            const bin = node.Binary;
            std.debug.print("🔸 Binary Op: '{c}'\n", .{bin.op});

            printIndent(indent + 1);
            std.debug.print("↳ Left:\n", .{});
            printNode(bin.lhs, indent + 2);

            printIndent(indent + 1);
            std.debug.print("↳ Right:\n", .{});
            printNode(bin.rhs, indent + 2);
        },
        .Unary => {
            const un = node.Unary;
            std.debug.print("🔹 Unary Op: '{c}'\n", .{un.un_op});
            printNode(un.val, indent + 1);
        },
        .PostFix => {
            const pf = node.PostFix;
            std.debug.print("🔻 Postfix Op: {s}\n", .{pf.post_op});
            printNode(pf.val, indent + 1);
        },
        .Comp => {
            const cmp = node.Comp;
            std.debug.print("⚖️ Comparison\n", .{});
            printNode(cmp.comp_op, indent + 1);
            printNode(cmp.val, indent + 1);
        },
        .Cast => {
            const cast = node.Cast;
            std.debug.print("🌀 Cast\n", .{});
            printNode(cast.cast, indent + 1);
            printNode(cast.val, indent + 1);
        },
        .WhileStmt => {
            const wh = node.WhileStmt;
            if (wh.init) |_| {
                std.debug.print("🔁 For Loop\n", .{});
            } else {
                std.debug.print("🔁 While Loop\n", .{});
            }
            printNode(wh.init, indent + 1);
            printNode(wh.cond, indent + 1);
            printNode(wh.body, indent + 1);
        },
        .IfStmt => {
            const ifn = node.IfStmt;
            std.debug.print("🧩 If Statement\n", .{});

            printIndent(indent + 1);
            std.debug.print("↳ Condition:\n", .{});
            printNode(ifn.cond, indent + 2);

            printIndent(indent + 1);
            std.debug.print("↳ Then:\n", .{});
            printNode(ifn.if_branch, indent);

            if (ifn.el_branch) |elseb| {
                printIndent(indent + 1);
                std.debug.print("↳ Else:\n", .{});
                printNode(elseb, indent + 2);
            }
        },
        .ReturnStmt => {
            const ret = node.ReturnStmt;
            std.debug.print("🔙 Return\n", .{});
            if (ret.val) |v| printNode(v, indent + 1);
        },
        .String => {
            const str = node.String;
            std.debug.print("{s}\n", .{str.raw_val});
        },
        .Char => std.debug.print("'{c}'\n", .{node.Char.char}),
        .Int => std.debug.print("Int: {d}\n", .{node.Int.val}),
        .Float => std.debug.print("Float: {d}\n", .{node.Float.val}),
        .Type => {
            const t = node.Type;
            const s = std.mem.span(t.type_name);
            std.debug.print("Type: {s} (size={d}, align={d})\n", .{
                s, t.size, t.alignment,
            });
        },
        .NameParameterNode => {
            const np = node.NameParameterNode;
            std.debug.print("Parameters:\n", .{});
            if (np.parameterList) |plist| {
                for (plist.params) |item| printNode(item, indent + 2);
            }
        },
        .ConditionalExpression => {
            const cond = node.ConditionalExpression;
            const op = std.mem.span(cond.logicalOperator);
            std.debug.print("❓ Conditional Expression ({s})\n", .{op});

            printIndent(indent + 1);
            std.debug.print("↳ Expression 1:\n", .{});
            printNode(cond.expr1, indent + 2);

            printIndent(indent + 1);
            std.debug.print("↳ Expression 2:\n", .{});
            printNode(cond.expr2, indent + 2);
        },
        .ExpressionStmt => {
            if (node.ExpressionStmt.expr) |expr| {
                printNode(expr, indent);
            }
        },
        .IdPointer => {
            printNode(node.IdPointer.pointer, indent + 1);
            printNode(node.IdPointer.identifier, indent + 2);
        },
        .Pointer => {
            const p_node = node.Pointer;
            std.debug.print("😈 Pointer:\n", .{});
            if (p_node.pointee) |p| {
                printIndent(indent + 2);
                std.debug.print("It's just a pointer to a pointer\n", .{});
                printNode(p, indent + 1);
            } else {
                printIndent(indent + 1);
                std.debug.print("Base\n", .{});
            }
        },
        else => |tag| {
            std.debug.print("Unknown node type: {}\n", .{tag});
        },
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
