const std = @import("std");
const c = @cImport(@cInclude("c11.tab.h"));
const m = @import("main.zig");
const glob_alloc = m.parse_alloc;
pub var debug_mode: bool = false;
extern var yylineno: c_int;
extern var yycolumn: c_int;
pub const Location = struct {
    line: usize,
    col: usize,
};
// ==============
// NODE STRUCTS
// ==============

// Identifier node represents variable/function names
// It includes the name as a string
pub const IdentifierNode = struct {
    name: []const u8,
    typeNode: ?*TypeNode = null,
    location: ?*Location = null,
    spawner: ?*DeclarationNode = null,
};
// Constant node represents literal values
// It includes the value and its type information
pub const ConstantNode = struct {
    value: []const u8,
    typeNode: *TypeNode,
    location: ?*Location = null,
};
// Declaration node represents variable declarations
// It includes the variable name, type, and optional initializer
pub const DeclarationNode = struct {
    typeNode: *TypeNode, // Structs will return StructNode here, others return TypeNode
    assignNode: ?*Node,
    location: ?*Location = null,
};
pub const StructDeclarationNode = struct {
    packedNode: *Node,
    assignNode: ?*Node,
    typeNode: ?*TypeNode = null,
    location: ?*Location = null,
};
pub const FunctionNode = struct {
    retType: *TypeNode,
    nameParam: *Node,
    body: *Node,
    typeNode: ?*TypeNode = null,
    location: ?*Location = null,
};
pub const FunctionCallNode = struct {
    name: *Node,
    args: ?*Node,
    typeNode: ?*TypeNode = null,
    location: ?*Location = null,
    spawner: ?*FunctionNode = null,
};
pub const ArgumentListNode = struct {
    args: []*Node,
    typeNode: ?*TypeNode = null,
    location: ?*Location = null,
};
pub const ParameterListNode = struct {
    params: []*Node, // a list of parameter nodes
    typeNode: ?*TypeNode = null,
    location: ?*Location = null,
};
pub const NameParameterNode = struct {
    name: *Node,
    parameterList: ?*Node,
    typeNode: ?*TypeNode = null,
    location: ?*Location = null,
};
pub const BlockItemsNode = struct {
    items: []*Node,
    typeNode: ?*TypeNode = null,
    location: ?*Location = null,
}; // A list of statements/declarations in a block

pub const BinaryNode = struct {
    lhs: *Node,
    op: u8,
    rhs: *Node,
    typeNode: ?*TypeNode = null,
    location: ?*Location = null,
};
pub const UnaryNode = struct {
    un_op: u8,
    val: *Node,
    typeNode: ?*TypeNode = null,
    location: ?*Location = null,
};
// Should combind this with UnaryNode and just make them both strings at one point
pub const PostFixNode = struct {
    post_op: []const u8,
    val: *Node,
    typeNode: ?*TypeNode = null,
    location: ?*Location = null,
};
pub const PreFixNode = struct {
    pre_op: []const u8,
    val: *Node,
    typeNode: ?*TypeNode = null,
    location: ?*Location = null,
};
pub const LogicNode = struct {
    log_op: *Node,
    val: *Node,
    typeNode: ?*TypeNode = null,
    location: ?*Location = null,
};
pub const CompNode = struct {
    comp_op: *Node,
    val: *Node,
    typeNode: ?*TypeNode = null,
    location: ?*Location = null,
};
pub const CastNode = struct {
    cast: *Node,
    val: *Node,
    typeNode: ?*TypeNode = null,
    location: ?*Location = null,
};
pub const WhileNode = struct {
    cond: *Node,
    body: *Node,
    init: ?*Node, //optional initializer to handle for loops
    typeNode: ?*TypeNode = null,
    location: ?*Location = null,
};
pub const IfNode = struct {
    cond: *Node,
    if_branch: *Node, // Block
    el_branch: ?*Node, // Block
    typeNode: ?*TypeNode = null,
    location: ?*Location = null,
};
pub const ReturnNode = struct {
    val: ?*Node,
    typeNode: ?*TypeNode = null,
    location: ?*Location = null,
};
pub const StringNode = struct {
    raw_val: []const u8,
    typeNode: ?*TypeNode = null,
    location: ?*Location = null,
};
pub const CharNode = struct {
    char: u8,
    typeNode: ?*TypeNode = null,
    location: ?*Location = null,
};
pub const IntNode = struct {
    val: i32,
    typeNode: ?*TypeNode = null,
    location: ?*Location = null,
};
pub const FloatNode = struct {
    val: f32,
    typeNode: ?*TypeNode = null,
    location: ?*Location = null,
};
// and additional fields for complex types (arrays, structs, etc.) in the future
pub const BaseType = enum(u8) { INT, FLOAT, STRING, CHAR, LONG, SHORT, DOUBLE, BOOL, VOID };
pub const TypeNode = extern struct {
    is_unsigned: bool = false,
    is_const: bool = false,
    qualifier: usize = 0, // 0 none, 1 long, 2 long long
    base: BaseType = .INT,
    type_name: [*c]const u8 = "INT",
    size: usize = @sizeOf(i32),
    alignment: usize = @alignOf(i32),
    location: ?*Location = null,
};
pub const AssignmentNode = struct {
    declarator: *Node, // i.e. x in int x;
    initializer: ?*Node, // i.e. 5 in int x = 5;
    ass_op: ?*Node, // i.e. *=
    typeNode: ?*TypeNode = null,
    location: ?*Location = null,
};

pub const AssignmentOpNode = struct {
    assign_op: []const u8,
    typeNode: ?*TypeNode = null,
    location: ?*Location = null,
};

pub const ConditionalExpressionNode = struct {
    logicalOperator: [*c]const u8,
    expr1: *Node,
    expr2: *Node,
    typeNode: ?*TypeNode = null,
    location: ?*Location = null,
};

pub const ExpressionStmtNode = struct {
    expr: ?*Node,
    typeNode: ?*TypeNode = null,
    location: ?*Location = null,
};

pub const PointerNode = struct {
    pointee: ?*Node,
    typeNode: ?*TypeNode = null,
    location: ?*Location = null,
};

pub const IdPointerNode = struct {
    pointer: *Node,
    identifier: *Node,
    typeNode: ?*TypeNode = null,
    location: ?*Location = null,
};
pub const TranslationUnitListNode = struct {
    translationUnits: []*Node,
    typeNode: ?*TypeNode = null,
    location: ?*Location = null,
};
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
    TranslationUnitList,
    // Blocks
    BlockItems,

    // Mathematical: Arith, Logic, Comp, Cast
    Binary,
    Unary,
    PostFix,
    PreFix,
    ConditionalExpression,
    Comp,
    Cast,
    AssOp,

    // Variables, Pointers and Arrays
    Declaration,
    StructDeclaration,
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

    // Structs
    StructDecl,
    StructDeclList,
    StructDeclaratorList,
    Struct,
    StructUnion,
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
    TranslationUnitList: *TranslationUnitListNode,
    BlockItems: *BlockItemsNode,

    // Arithmetic and Cast
    Binary: *BinaryNode,
    Unary: *UnaryNode,
    PostFix: *PostFixNode,
    PreFix: *PreFixNode,
    ConditionalExpression: *ConditionalExpressionNode,
    Comp: *CompNode,
    Cast: *CastNode,
    AssOp: *AssignmentOpNode,

    // Vars
    Declaration: *DeclarationNode,
    StructDeclaration: *StructDeclarationNode,
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

    // Structs
    StructDecl: *StructDeclNode,
    StructDeclList: *StructDeclListNode,
    StructDeclaratorList: *StructDeclaratorListNode,
    Struct: *StructNode,
    StructUnion: *StructUnionNode,
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

fn get_location() ?*Location {
    const column_loc: usize = @intCast(m.column);
    const line_loc: usize = @intCast(m.line);
    const loc_node = glob_alloc.create(Location) catch return null;
    loc_node.* = Location{ .col = column_loc, .line = line_loc };
    return loc_node;
}
// expand this function to handle the multicharacter operators
export fn make_conditional_expression_node(expr1: *Node, token: c.yytokentype, expr2: *Node) ?*Node {
    const CondExpNodePtr = glob_alloc.create(ConditionalExpressionNode) catch return null;

    if (debug_mode) std.debug.print("===> LOGICAL OPERATOR INFO FOR INPUT: {any}\n", .{token});
    switch (token) {
        c.GE_OP => {
            CondExpNodePtr.* = ConditionalExpressionNode{ .logicalOperator = ">=", .expr1 = expr1, .expr2 = expr2, .location = get_location() };
        },
        c.LE_OP => {
            CondExpNodePtr.* = ConditionalExpressionNode{ .logicalOperator = "<=", .expr1 = expr1, .expr2 = expr2, .location = get_location() };
        },
        c.EQ_OP => {
            CondExpNodePtr.* = ConditionalExpressionNode{ .logicalOperator = "==", .expr1 = expr1, .expr2 = expr2, .location = get_location() };
        },
        c.NE_OP => {
            CondExpNodePtr.* = ConditionalExpressionNode{ .logicalOperator = "!=", .expr1 = expr1, .expr2 = expr2, .location = get_location() };
        },
        c.AND_OP => {
            CondExpNodePtr.* = ConditionalExpressionNode{ .logicalOperator = "&&", .expr1 = expr1, .expr2 = expr2, .location = get_location() };
        },
        c.OR_OP => {
            CondExpNodePtr.* = ConditionalExpressionNode{ .logicalOperator = "||", .expr1 = expr1, .expr2 = expr2, .location = get_location() };
        },
        else => {
            CondExpNodePtr.* = ConditionalExpressionNode{ .logicalOperator = "Error_Unknown_Op", .expr1 = expr1, .expr2 = expr2, .location = get_location() };
        },
    }
    const node = glob_alloc.create(Node) catch return null;
    node.* = Node{ .ConditionalExpression = CondExpNodePtr };

    return node;
}
export fn combine_type_node(left_type: ?*Node, right_type: ?*Node) ?*Node {
    // null check
    if (right_type == null) return left_type;
    if (left_type == null) return right_type;

    // std.debug.print("Both Nodes Valid: Checking Details\n", .{});
    const new_type = glob_alloc.create(TypeNode) catch return null;
    if (left_type != null and right_type != null) {
        const rt = right_type.?;
        const lt = left_type.?;
        if (rt.* != .Type or lt.* != .Type) return null;
        const new_base = rt.Type.base;
        const new_sign = lt.Type.is_unsigned or rt.Type.is_unsigned;
        const new_const = lt.Type.is_const or rt.Type.is_const;
        var alignment: usize = 0;
        var size: usize = 0;
        switch (new_base) {
            .BOOL => {
                alignment = @alignOf(bool);
                size = @sizeOf(bool);
            },
            .DOUBLE => {
                alignment = @alignOf(f64);
                size = @sizeOf(f64);
            },
            .FLOAT => {
                alignment = @alignOf(f32);
                size = @sizeOf(f32);
            },
            .INT => {
                alignment = @alignOf(i32);
                size = @sizeOf(i32);
            },
            .LONG => {
                alignment = @alignOf(i64);
                size = @sizeOf(i64);
            },
            .CHAR => {
                alignment = @alignOf(u8);
                size = @sizeOf(u8);
            },
            .SHORT => {
                alignment = @alignOf(i32);
                size = @sizeOf(i32);
            },
            else => {
                alignment = @alignOf(void);
                size = @sizeOf(void);
            },
        }
        const new_qual = rt.Type.qualifier + lt.Type.qualifier;

        const alloc = glob_alloc;
        var name_parts: std.ArrayList([]const u8) = .empty;
        if (new_const) _ = name_parts.append(alloc, "const") catch {};
        if (new_sign) _ = name_parts.append(alloc, "unsigned") catch {};
        if (new_qual == 1) _ = name_parts.append(alloc, "long") catch {};
        if (new_qual >= 2) _ = name_parts.append(alloc, "long long") catch {};
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
        // std.debug.print("\n Type Node Created: {any}\n", .{new_base});
        new_type.* = TypeNode{ .base = new_base, .is_const = new_const, .is_unsigned = new_sign, .alignment = alignment, .size = size, .type_name = new_name.ptr, .qualifier = new_qual, .location = get_location() };
    }
    const node = glob_alloc.create(Node) catch return null;
    node.* = Node{ .Type = new_type };
    return node;
}
export fn make_type_node(token: c.yytokentype) ?*Node {
    const type_node_ptr = glob_alloc.create(TypeNode) catch return null;
    // std.debug.print("===> TYPE INFO FOR INPUT: {any}\n", .{token});
    if (@TypeOf(token) != c.yytokentype) return null;
    switch (token) {
        c.FLOAT => {
            const tn: [*c]const u8 = "float";
            type_node_ptr.* = TypeNode{ .base = .FLOAT, .type_name = tn, .location = get_location() };
        },
        c.DOUBLE => {
            const tn: [*c]const u8 = "double";
            type_node_ptr.* = TypeNode{ .base = .DOUBLE, .type_name = tn, .location = get_location() };
        },
        c.INT => {
            type_node_ptr.* = TypeNode{ .base = .INT, .location = get_location() };
        },
        c.LONG => {
            const tn: [*c]const u8 = "long";
            type_node_ptr.* = TypeNode{ .base = .INT, .qualifier = 1, .type_name = tn, .location = get_location() };
        },
        c.STRING_LITERAL => {
            const tn: [*c]const u8 = "string";
            type_node_ptr.* = TypeNode{ .base = .STRING, .type_name = tn, .location = get_location() };
        },
        c.UNSIGNED => {
            type_node_ptr.* = TypeNode{ .base = .INT, .is_unsigned = true, .location = get_location() };
        },
        c.CHAR => {
            const tn: [*c]const u8 = "char";
            type_node_ptr.* = TypeNode{ .base = .CHAR, .is_unsigned = true, .type_name = tn, .location = get_location() };
        },
        else => {
            type_node_ptr.* = TypeNode{ .base = .VOID, .location = get_location() };
        },
    }

    const node = glob_alloc.create(Node) catch return null;
    node.* = Node{ .Type = type_node_ptr };

    return node;
}

export fn make_identifier_node(name: [*c]const u8) ?*Node {
    // We create the identifier node
    const id_node = glob_alloc.create(IdentifierNode) catch return null;
    if (@TypeOf(name) != [*c]const u8) {
        return null;
    }
    const name_copy = glob_alloc.dupe(u8, std.mem.span(name)) catch return null;

    // We set the name for the identifier node
    id_node.* = IdentifierNode{ .name = name_copy, .location = get_location() };

    // We create a *node that wraps a specific node type
    const node = glob_alloc.create(Node) catch return null;
    // We set the union to be of type Identifier and assign the created identifier node
    node.* = Node{ .Identifier = id_node };

    // We return the created node
    const n: *Node = @ptrCast(node);
    return n;
}
// if we want float constants
export fn make_constant_node(value: [*c]const u8, typeNode: *TypeNode) ?*Node {
    // We create the constant node
    const const_node = glob_alloc.create(ConstantNode) catch return null;
    // We set the value and type information for the constant node
    if (@TypeOf(value) != [*c]const u8) return null;
    const val_copy = glob_alloc.dupe(u8, std.mem.span(value)) catch return null;

    const_node.* = ConstantNode{ .value = val_copy, .typeNode = typeNode, .location = get_location() };

    // We create a *node that wraps a specific node type
    const node = glob_alloc.create(Node) catch return null;
    // We set the union to be of type Constant and assign the created constant node
    node.* = Node{ .Constant = const_node };

    // We return the created node
    const n: *Node = @ptrCast(node);
    return n;
}

export fn make_assignment_node(declarator: *Node, initializer: ?*Node, ass_op: *Node) ?*Node {
    const assignment_node = glob_alloc.create(AssignmentNode) catch return null;
    assignment_node.* = .{ .declarator = declarator, .initializer = initializer, .ass_op = ass_op, .location = get_location() };

    const node = glob_alloc.create(Node) catch return null;
    node.* = Node{ .Assignment = assignment_node };
    return node;
}

// The initializer is optional, so it can be null if there is no initializer
// int x = 5;  // initializer is present
// int y;      // initializer is null
export fn make_declaration_node(typeNode: *Node, asgnNode: ?*Node) ?*Node {
    // std.debug.print("make_declaration_node function reached\n", .{});
    // We create the declaration node
    if (typeNode.* == .Struct) {
        const decl_node = glob_alloc.create(StructDeclarationNode) catch return null;
        if (asgnNode) |n| {
            decl_node.* = StructDeclarationNode{ .packedNode = typeNode, .assignNode = n, .location = get_location() };
        } else {
            decl_node.* = StructDeclarationNode{ .packedNode = typeNode, .assignNode = null, .location = get_location() };
        } // We create a *node that wraps a specific node type
        const node = glob_alloc.create(Node) catch return null;
        // We set the union to be of type Declaration and assign the created declaration node
        node.* = Node{ .StructDeclaration = decl_node };
        const n: *Node = @ptrCast(node);
        return n;
    } else if (typeNode.* == .Type) {
        const decl_node = glob_alloc.create(DeclarationNode) catch return null;
        // std.debug.print("TypeNode in make_dec_node?: {any}\n", .{typeNode.Type.base});
        if (asgnNode) |n| {
            decl_node.* = DeclarationNode{ .typeNode = typeNode.Type, .assignNode = n, .location = get_location() };
        } else {
            decl_node.* = DeclarationNode{ .typeNode = typeNode.Type, .assignNode = null, .location = get_location() };
        } // We create a *node that wraps a specific node type
        const node = glob_alloc.create(Node) catch return null;
        // We set the union to be of type Declaration and assign the created declaration node
        node.* = Node{ .Declaration = decl_node };
        const n: *Node = @ptrCast(node);
        return n;
    } else return null;
}

export fn make_binary_node(lhs: *Node, op: c_char, rhs: *Node) ?*Node {
    const binary_node = glob_alloc.create(BinaryNode) catch return null;
    const op_val: u8 = @intCast(op);
    binary_node.* = BinaryNode{ .lhs = lhs, .op = op_val, .rhs = rhs, .location = get_location() };

    const node = glob_alloc.create(Node) catch return null;

    node.* = Node{ .Binary = binary_node };

    const n: *Node = @ptrCast(node);
    return n;
}

export fn make_unary_node(un_op: u8, val: *Node) ?*Node {
    const unary_node = glob_alloc.create(UnaryNode) catch return null;

    unary_node.* = UnaryNode{ .un_op = un_op, .val = val, .location = get_location() };

    const node = glob_alloc.create(Node) catch return null;

    node.* = Node{ .Unary = unary_node };

    const n: *Node = @ptrCast(node);
    return n;
}

export fn make_assignment_op_node(token: c.yytokentype) ?*Node {
    const ass_op_node = glob_alloc.create(AssignmentOpNode) catch return null;
    if (@TypeOf(token) != c.yytokentype) return null;
    switch (token) {
        c.MUL_ASSIGN => {
            ass_op_node.* = AssignmentOpNode{ .assign_op = "*=", .location = get_location() };
        },
        c.DIV_ASSIGN => {
            ass_op_node.* = AssignmentOpNode{ .assign_op = "/=", .location = get_location() };
        },
        c.MOD_ASSIGN => {
            ass_op_node.* = AssignmentOpNode{ .assign_op = "%=", .location = get_location() };
        },
        c.ADD_ASSIGN => {
            ass_op_node.* = AssignmentOpNode{ .assign_op = "+=", .location = get_location() };
        },
        c.SUB_ASSIGN => {
            ass_op_node.* = AssignmentOpNode{ .assign_op = "-=", .location = get_location() };
        },
        c.LEFT_ASSIGN => {
            ass_op_node.* = AssignmentOpNode{ .assign_op = "<<=", .location = get_location() };
        },
        c.RIGHT_ASSIGN => {
            ass_op_node.* = AssignmentOpNode{ .assign_op = ">>=", .location = get_location() };
        },
        c.AND_ASSIGN => {
            ass_op_node.* = AssignmentOpNode{ .assign_op = "&=", .location = get_location() };
        },
        c.XOR_ASSIGN => {
            ass_op_node.* = AssignmentOpNode{ .assign_op = "^=", .location = get_location() };
        },
        c.OR_ASSIGN => {
            ass_op_node.* = AssignmentOpNode{ .assign_op = "|=", .location = get_location() };
        },
        else => {
            ass_op_node.* = AssignmentOpNode{ .assign_op = "Error_Unknown_Op", .location = get_location() };
        },
    }

    const node = glob_alloc.create(Node) catch return null;
    node.* = Node{ .AssOp = ass_op_node };
    const n: *Node = @ptrCast(node);
    return n;
}

export fn make_post_fix_node(val: *Node, token: c.yytokentype) ?*Node {
    const postfix_node = glob_alloc.create(PostFixNode) catch return null;
    if (@TypeOf(token) != c.yytokentype) return null;
    switch (token) {
        c.INC_OP => {
            postfix_node.* = PostFixNode{ .post_op = "++", .val = val, .location = get_location() };
        },
        c.DEC_OP => {
            postfix_node.* = PostFixNode{ .post_op = "--", .val = val, .location = get_location() };
        },
        else => {
            postfix_node.* = PostFixNode{ .post_op = "Error_Unknown_Op", .val = val, .location = get_location() };
        },
    }

    const node = glob_alloc.create(Node) catch return null;
    node.* = Node{ .PostFix = postfix_node };
    const n: *Node = @ptrCast(node);
    return n;
}

export fn make_pre_fix_node(token: c.yytokentype, val: *Node) ?*Node {
    const prefix_node = glob_alloc.create(PreFixNode) catch return null;
    if (@TypeOf(token) != c.yytokentype) return null;

    switch (token) {
        c.INC_OP => {
            prefix_node.* = PreFixNode{ .pre_op = "++", .val = val, .location = get_location() };
        },
        c.DEC_OP => {
            prefix_node.* = PreFixNode{ .pre_op = "--", .val = val, .location = get_location() };
        },
        else => {
            prefix_node.* = PreFixNode{ .pre_op = "Error_Unknown_Op", .val = val, .location = get_location() };
        },
    }

    const node = glob_alloc.create(Node) catch return null;
    node.* = Node{ .PreFix = prefix_node };
    const n: *Node = @ptrCast(node);
    return n;
}

export fn make_float_node(val: f32) ?*Node { // FOR DEBUGGING
    const fnode = glob_alloc.create(FloatNode) catch return null;
    if (@TypeOf(val) != f32) {
        return null;
    }
    fnode.* = FloatNode{ .val = val, .location = get_location() };

    const node = glob_alloc.create(Node) catch return null;

    node.* = Node{ .Float = fnode };

    const n: *Node = @ptrCast(node);
    return n;
}
export fn make_int_node(val: i32) ?*Node { // FOR DEBUGGING
    const int_node = glob_alloc.create(IntNode) catch return null;
    if (@TypeOf(val) != i32) {
        return null;
    }

    int_node.* = IntNode{ .val = val, .location = get_location() };

    const node = glob_alloc.create(Node) catch return null;

    node.* = Node{ .Int = int_node };

    const n: *Node = @ptrCast(node);
    return n;
}
export fn make_string_node(raw_val: [*c]const u8) ?*Node {
    if (@TypeOf(raw_val) != [*c]const u8) return null;
    const string_node = glob_alloc.create(StringNode) catch return null;
    const val_copy = glob_alloc.dupe(u8, std.mem.span(raw_val)) catch return null;
    string_node.* = StringNode{ .raw_val = val_copy, .location = get_location() };

    const node = glob_alloc.create(Node) catch return null;
    node.* = Node{ .String = string_node };
    return node;
}

// =================
// | Stmt Creators |
// =================

export fn append_block_list(item: *Node, items: ?*Node) ?*Node {
    // If items is null, then we have a declaration node or statement node, create a new BlockItemsNode with the item as the first element
    if (items == null) {
        // std.debug.print("\nNEW BLOCK LIST CREATED:\n", .{});
        const block_items_node = glob_alloc.create(BlockItemsNode) catch return null;

        const new_items = glob_alloc.alloc(*Node, 1) catch return null;
        new_items[0] = item;

        block_items_node.* = BlockItemsNode{ .items = new_items, .location = get_location() };

        const node = glob_alloc.create(Node) catch return null;
        node.* = Node{ .BlockItems = block_items_node }; // Wrap the BlockItemsNode in a Node
        return node;
    } else {
        // Otherwise, we have an existing BlockItemsNode, append the new item to its items array
        // std.debug.print("\nADDING TO OLD LIST\n", .{});
        // Unwrap the items from Node
        const items_block = items.?.BlockItems;

        // Append the new item to the list in items_block
        const new_len = items_block.items.len + 1;
        const new_items = glob_alloc.alloc(*Node, new_len) catch return null;
        // Copy existing items
        @memcpy(new_items[0..items_block.items.len], items_block.items[0..items_block.items.len]);
        // std.mem.copy(*Node, new_items[0..items_block.items.len], items_block.items[0..items_block.items.len]);
        new_items[items_block.items.len] = item;

        // Create a new BlockItemsNode with the updated items
        const block_list_node = glob_alloc.create(BlockItemsNode) catch return null;
        block_list_node.* = BlockItemsNode{ .items = new_items[0..new_len], .location = get_location() };

        // Wrap the items block in node and return
        const node = glob_alloc.create(Node) catch return null;
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
        // std.debug.print("\nCREATING PARAM LIST:\n", .{});
        // create the ParameterListNode
        const parameter_items_node = glob_alloc.create(ParameterListNode) catch return null;
        // initialize it with the single item which

        // Lets try doing a runtime array with space for one item
        const new_params = glob_alloc.alloc(*Node, 1) catch return null;
        new_params[0] = item;

        // Set the params field
        parameter_items_node.* = ParameterListNode{ .params = new_params, .location = get_location() };

        const node = glob_alloc.create(Node) catch return null;
        node.* = Node{ .ParameterList = parameter_items_node };
        // std.debug.print("Param: {any}\n", .{item});
        return node;
    } else {
        // Otherwise, we have an existing BlockItemsNode, append the new item to its items array

        // Unwrap the items from Node
        const items_block = items.?.ParameterList;

        // Append the new item to the list in items_block
        const new_len = items_block.params.len + 1;
        const new_params = glob_alloc.alloc(*Node, new_len) catch return null;

        // Copy existing items
        @memcpy(new_params[0..items_block.params.len], items_block.params);
        // std.mem.copy(*Node, new_items[0..items_block.items.len], items_block.items[0..items_block.items.len]);
        new_params[items_block.params.len] = item;

        // Create a new BlockItemsNode with the updated items
        const parameter_list_node = glob_alloc.create(ParameterListNode) catch return null;
        parameter_list_node.* = ParameterListNode{ .params = new_params, .location = get_location() };
        // Wrap the items block in node and return
        const node = glob_alloc.create(Node) catch return null;
        node.* = Node{ .ParameterList = parameter_list_node };
        // std.debug.print("\nAdding to OLD LIST\n", .{});
        // std.debug.print("Param: {any}\n", .{item});
        return node;
    }
}

export fn make_name_parameter_node(name: *Node, parameterList: ?*Node) ?*Node {
    const name_param_node = glob_alloc.create(NameParameterNode) catch return null;

    if (parameterList) |pl| {
        name_param_node.* = NameParameterNode{ .name = name, .parameterList = pl, .location = get_location() };
    } else {
        name_param_node.* = NameParameterNode{ .name = name, .parameterList = null, .location = get_location() };
    }

    const node = glob_alloc.create(Node) catch return null;
    node.* = Node{ .NameParameterNode = name_param_node };

    return node;
}

export fn make_return_node(ret_val: ?*Node) ?*Node {
    const ret_node = glob_alloc.create(ReturnNode) catch return null;
    ret_node.* = ReturnNode{ .val = ret_val, .location = get_location() };

    const node = glob_alloc.create(Node) catch return null;
    node.* = Node{ .ReturnStmt = ret_node };

    return node;
}

export fn make_function_node(retType: *Node, nameParameter: *Node, body: *Node) ?*Node {
    const function_node = glob_alloc.create(FunctionNode) catch return null;
    if (retType.* != .Type) return null;
    function_node.* = FunctionNode{ .retType = retType.Type, .nameParam = nameParameter, .body = body, .location = get_location() };

    const node = glob_alloc.create(Node) catch return null;
    node.* = Node{ .Function = function_node };

    return node;
}
export fn append_argument_list(item: *Node, items: ?*Node) ?*Node {
    if (items == null) {
        const arg_list_node = glob_alloc.create(ArgumentListNode) catch return null;

        const new_args = glob_alloc.alloc(*Node, 1) catch return null;
        new_args[0] = item;

        // Set the params field
        arg_list_node.* = ArgumentListNode{ .args = new_args, .location = get_location() };

        const node = glob_alloc.create(Node) catch return null;
        node.* = Node{ .ArgumentList = arg_list_node };
        return node;
    } else {
        if (items.?.* != .ArgumentList) {
            return null;
        }
        const items_b = items;
        if (items_b) |items_bl| {
            const items_block = items_bl.ArgumentList;
            const new_len = items_block.args.len + 1;
            const new_args = glob_alloc.alloc(*Node, new_len) catch return null;

            // Copy existing items
            @memcpy(new_args[0..items_block.args.len], items_block.args);
            new_args[items_block.args.len] = item;

            // Create a new BlockItemsNode with the updated items
            const args_list_node = glob_alloc.create(ArgumentListNode) catch return null;
            args_list_node.* = ArgumentListNode{ .args = new_args, .location = get_location() };
            // Wrap the items block in node and return
            const node = glob_alloc.create(Node) catch return null;
            node.* = Node{ .ArgumentList = args_list_node };
            return node;
        } else return null;
    }
}

export fn make_function_call_node(name: *Node, args: ?*Node) ?*Node {
    const fc_node = glob_alloc.create(FunctionCallNode) catch return null;

    fc_node.* = FunctionCallNode{ .name = name, .args = args, .location = get_location() };

    const node = glob_alloc.create(Node) catch return null;
    node.* = Node{ .FunctionCall = fc_node };

    return node;
}

// =================
// | Stmt Creators |
// =================

export fn make_expr_stmt(expr: *Node) ?*Node {
    const expr_stmt = glob_alloc.create(ExpressionStmtNode) catch return null;
    expr_stmt.* = ExpressionStmtNode{ .expr = expr, .location = get_location() };

    const stmt = glob_alloc.create(Node) catch return null;
    stmt.* = Node{ .ExpressionStmt = expr_stmt };

    return stmt;
}

export fn make_if_stmt(cond: *Node, if_branch: *Node, el_branch: ?*Node) ?*Node {
    // std.debug.print("make_if_stmt function reached\n", .{});

    const if_node = glob_alloc.create(IfNode) catch return null;

    if_node.* = IfNode{ .cond = cond, .if_branch = if_branch, .el_branch = el_branch, .location = get_location() };

    const node = glob_alloc.create(Node) catch return null;
    node.* = Node{ .IfStmt = if_node };

    return node;
}

export fn make_iteration_stmt(cond: *Node, body: *Node, init: ?*Node, post_expr: ?*Node) ?*Node {
    // std.debug.print("make_iteration_stmt function reached\n", .{});

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
    const while_node = glob_alloc.create(WhileNode) catch return null;
    while_node.* = WhileNode{ .cond = cond, .body = new_body, .init = init, .location = get_location() };

    const node = glob_alloc.create(Node) catch return null;
    node.* = Node{ .WhileStmt = while_node };

    return node;
}
// ===============
// | Pointer     |
// ===============
export fn make_pointer_node(pointee: ?*Node) ?*Node {
    const pointer_node = glob_alloc.create(PointerNode) catch return null;

    pointer_node.* = PointerNode{ .pointee = pointee, .location = get_location() };

    const node = glob_alloc.create(Node) catch return null;

    node.* = Node{ .Pointer = pointer_node };

    const n: *Node = @ptrCast(node);
    return n;
}

export fn make_idpointer_node(pointer: *Node, id: *Node) ?*Node {
    const pointer_node = glob_alloc.create(IdPointerNode) catch return null;
    pointer_node.* = IdPointerNode{ .pointer = pointer, .identifier = id, .location = get_location() };

    const node = glob_alloc.create(Node) catch return null;
    node.* = Node{ .IdPointer = pointer_node };
    const n: *Node = @ptrCast(node);
    return n;
}

// ===============
// |   Structs   |
// ===============

pub const StructNode = struct {
    name: ?*Node,
    decl_list: ?[]*Node,
    location: ?*Location = null,
};
pub const StructUnionNode = struct {
    type: c.yytokentype,
    location: ?*Location = null,
};

export fn make_structunion_node(t: c.yytokentype) ?*Node {
    const us = glob_alloc.create(StructUnionNode) catch return null;
    const node = glob_alloc.create(Node) catch return null;

    switch (t) {
        c.UNION => {
            us.* = StructUnionNode{ .type = c.UNION, .location = get_location() };
        },
        c.STRUCT => {
            us.* = StructUnionNode{ .type = c.STRUCT, .location = get_location() };
        },
        else => {
            us.* = StructUnionNode{ .type = c.VOID, .location = get_location() };
        },
    }

    node.* = Node{ .StructUnion = us };
    return node;
}
export fn make_struct_or_union(struct_or_union: *Node, identifier: [*c]const u8, decl_list_node: ?*Node) ?*Node {
    const struct_node = glob_alloc.create(StructNode) catch return null;
    var id: ?*Node = null;
    var decl_list: []*Node = undefined;
    if (identifier) |i| {
        id = make_identifier_node(i);
    } else {
        // Anonymous struct
        const anon_name = glob_alloc.create(IdentifierNode) catch return null;
        anon_name.* = IdentifierNode{ .name = "<anonymous>", .location = get_location() };
        const node = glob_alloc.create(Node) catch return null;
        node.* = Node{ .Identifier = anon_name };
        id = node;
    }
    // For now, we only handle struct
    if (struct_or_union.StructUnion.type == c.STRUCT) {
        if (decl_list_node) |dl| {
            decl_list = dl.StructDeclList.decl_list;
        } else {
            const empty_decl_list = glob_alloc.alloc(*StructNode, 0) catch return null;
            decl_list = empty_decl_list;
        }
        var name: *Node = undefined;
        if (id) |ident| {
            name = ident;
        } else {
            return null;
        }
        struct_node.* = StructNode{ .name = name, .decl_list = decl_list, .location = get_location() };

        const node = glob_alloc.create(Node) catch return null;
        node.* = Node{ .Struct = struct_node };
        return node;
    } else {
        return null; //union later
    }
}

pub const StructDeclNode = struct {
    type: *Node,
    decl_list: []*Node,
    location: ?*Location = null,
};
pub const StructDeclListNode = struct {
    decl_list: []*Node,
    location: ?*Location = null,
};

export fn append_struct_decl_list(decl: *Node, decls: ?*Node) ?*Node {
    if (decls == null) {
        const list_node = glob_alloc.create(StructDeclListNode) catch return null;

        const new_node = glob_alloc.alloc(*Node, 1) catch return null;
        new_node[0] = decl;

        // Set the params field
        list_node.* = StructDeclListNode{ .decl_list = new_node, .location = get_location() };

        const node = glob_alloc.create(Node) catch return null;
        node.* = Node{ .StructDeclList = list_node };
        return node;
    } else {
        const decls_block = decls.?.StructDeclList;
        const new_len = decls_block.decl_list.len + 1;
        const new_node = glob_alloc.alloc(*Node, new_len) catch return null;

        // Copy existing decls
        @memcpy(new_node[0..decls_block.decl_list.len], decls_block.decl_list);
        new_node[decls_block.decl_list.len] = decl;

        const list_node = glob_alloc.create(StructDeclListNode) catch return null;
        list_node.* = StructDeclListNode{ .decl_list = new_node, .location = get_location() };

        const node = glob_alloc.create(Node) catch return null;
        node.* = Node{ .StructDeclList = list_node };
        return node;
    }
}

export fn make_struct_decl(identifier_node: *Node, decl_list_node: ?*Node) ?*Node {
    const struct_node = glob_alloc.create(StructDeclNode) catch return null;

    if (decl_list_node) |dl| {
        struct_node.* = StructDeclNode{ .type = identifier_node, .decl_list = dl.StructDeclaratorList.declarators, .location = get_location() };
    } else {
        // Struct reference (no body)
        const empty_decl_list = glob_alloc.alloc(*Node, 0) catch return null;
        struct_node.* = StructDeclNode{ .type = identifier_node, .decl_list = empty_decl_list, .location = get_location() };
    }

    const node = glob_alloc.create(Node) catch return null;
    node.* = Node{ .StructDecl = struct_node };

    return node;
}

pub const StructDeclaratorListNode = struct {
    declarators: []*Node,
    location: ?*Location = null,
};
export fn append_struct_declarator_list(declarator: *Node, declarators: ?*Node) ?*Node {
    if (declarators == null) {
        const declarators_list_node = glob_alloc.create(StructDeclaratorListNode) catch return null;

        const new_declr = glob_alloc.alloc(*Node, 1) catch return null;
        new_declr[0] = declarator;

        // Set the params field
        declarators_list_node.* = StructDeclaratorListNode{ .declarators = new_declr, .location = get_location() };

        const node = glob_alloc.create(Node) catch return null;
        node.* = Node{ .StructDeclaratorList = declarators_list_node };
        return node;
    } else {
        const declarators_block = declarators.?.StructDeclaratorList;

        const new_len = declarators_block.declarators.len + 1;
        const new_declr = glob_alloc.alloc(*Node, new_len) catch return null;

        // Copy existing declarators
        @memcpy(new_declr[0..declarators_block.declarators.len], declarators_block.declarators);
        new_declr[declarators_block.declarators.len] = declarator;

        const declarators_list_node = glob_alloc.create(StructDeclaratorListNode) catch return null;
        declarators_list_node.* = StructDeclaratorListNode{ .declarators = new_declr, .location = get_location() };

        const node = glob_alloc.create(Node) catch return null;
        node.* = Node{ .StructDeclaratorList = declarators_list_node };
        return node;
    }
}

// ===================
// | TranslationUnit |
// ===================

var myGlobalConst: i32 = 0;

export fn append_translation_unit(unit: *Node, prev: ?*Node) ?*Node {
    myGlobalConst += 1;
    if (debug_mode) std.debug.print("COUNTER: {any}", .{myGlobalConst});

    if (prev) |p| {
        const unit_block = p.TranslationUnitList;

        const new_len = unit_block.translationUnits.len + 1;
        const new_unit = glob_alloc.alloc(*Node, new_len) catch return null;

        // Copy existing declarators
        @memcpy(new_unit[0..unit_block.translationUnits.len], unit_block.translationUnits);
        new_unit[unit_block.translationUnits.len] = unit;

        const unit_list_node = glob_alloc.create(TranslationUnitListNode) catch return null;
        unit_list_node.* = TranslationUnitListNode{ .translationUnits = new_unit, .location = get_location() };

        const node = glob_alloc.create(Node) catch return null;
        node.* = Node{ .TranslationUnitList = unit_list_node };
        return node;
    } else {
        // starting a new list
        const tul = glob_alloc.create(TranslationUnitListNode) catch return null;

        const new_unit = glob_alloc.alloc(*Node, 1) catch return null;
        new_unit[0] = unit;

        // Set the params field
        tul.* = TranslationUnitListNode{ .translationUnits = new_unit, .location = get_location() };

        const node = glob_alloc.create(Node) catch return null;
        node.* = Node{ .TranslationUnitList = tul };
        return node;
    }
}

// ===============
// | AST Printer |
// ===============

pub fn printIndent(indent: usize) void {
    for (0..indent) |_| {
        std.debug.print("│  ", .{});
    }
}
pub fn printNode(orig_node: ?*Node, indent: usize) !void {
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

            if (decl_node.assignNode) |assgn| {
                try printNode(assgn, indent + 1);
            }
        },
        .Assignment => {
            const asgn = node.Assignment;
            std.debug.print("⬜ Assignment\n", .{});

            printIndent(indent + 1);
            std.debug.print("↳ Declarator:\n", .{});
            try printNode(asgn.declarator, indent + 1);

            if (asgn.initializer) |init| {
                printIndent(indent + 1);
                std.debug.print("↳ Initializer:\n", .{});
                try printNode(init, indent + 1);
            }
            if (asgn.ass_op) |ass| {
                std.debug.print("↳ Ass Op:\n", .{});
                try printNode(ass, indent + 1);
            } else {
                printIndent(indent + 1);
                std.debug.print("(no initializer)\n", .{});
            }
        },
        .Function => {
            const func = node.Function;
            const type_str = std.mem.span(func.retType.type_name);

            std.debug.print("🟩 Function: {s} (returns {s})\n", .{
                func.nameParam.NameParameterNode.name.Identifier.name, type_str,
            });

            printIndent(indent + 1);
            std.debug.print("↳ Body:\n", .{});

            if (func.body.BlockItems.items.len == 0) {
                printIndent(indent + 1);
                std.debug.print("(empty block)\n", .{});
            } else {
                for (func.body.BlockItems.items) |item| try printNode(item, indent + 1);
            }
        },
        .FunctionCall => {
            std.debug.print("📞 Function Call\n", .{});
            const fc = node.FunctionCall;
            try printNode(fc.name, indent + 1);
            if (fc.args) |args| {
                printIndent(indent + 2);
                std.debug.print("↳ 📋 Argument List\n", .{});
                try printNode(args, indent + 1);
            }
        },
        .ArgumentList => {
            const args = node.ArgumentList;
            for (args.args) |arg| {
                // std.debug.print("Argument DEBUG: {any}\n", .{arg});
                try printNode(arg, indent + 1);
            }
        },
        .BlockItems => {
            const blk = node.BlockItems;
            std.debug.print("Block: \n", .{});
            for (blk.items) |item| try printNode(item, indent);
        },
        .Binary => {
            const bin = node.Binary;
            std.debug.print("🔸 Binary Op: '{c}'\n", .{bin.op});

            printIndent(indent + 1);
            std.debug.print("↳ Left:\n", .{});
            try printNode(bin.lhs, indent + 2);

            printIndent(indent + 1);
            std.debug.print("↳ Right:\n", .{});
            try printNode(bin.rhs, indent + 2);
        },
        .Unary => {
            const un = node.Unary;
            std.debug.print("🔹 Unary Op: '{c}'\n", .{un.un_op});
            try printNode(un.val, indent + 1);
        },
        .PostFix => {
            const pf = node.PostFix;
            std.debug.print("🔻 Postfix Op: {s}\n", .{pf.post_op});
            try printNode(pf.val, indent + 1);
        },
        .PreFix => {
            const pf = node.PreFix;
            std.debug.print("🔺 Prefix Op: {s}\n", .{pf.pre_op});
            try printNode(pf.val, indent + 1);
        },
        .AssOp => {
            const ao = node.AssOp;
            printIndent(indent + 1);
            std.debug.print("🔻 Ass Op: {s}\n", .{ao.assign_op});
        },
        .Comp => {
            const cmp = node.Comp;
            std.debug.print("⚖️ Comparison\n", .{});
            try printNode(cmp.comp_op, indent + 1);
            try printNode(cmp.val, indent + 1);
        },
        .Cast => {
            const cast = node.Cast;
            std.debug.print("🌀 Cast\n", .{});
            try printNode(cast.cast, indent + 1);
            try printNode(cast.val, indent + 1);
        },
        .WhileStmt => {
            const wh = node.WhileStmt;
            if (wh.init) |_| {
                std.debug.print("🔁 For Loop\n", .{});
            } else {
                std.debug.print("🔁 While Loop\n", .{});
            }
            try printNode(wh.init, indent + 1);
            try printNode(wh.cond, indent + 1);
            try printNode(wh.body, indent + 1);
        },
        .IfStmt => {
            const ifn = node.IfStmt;
            std.debug.print("🧩 If Statement\n", .{});

            printIndent(indent + 1);
            std.debug.print("↳ Condition:\n", .{});
            try printNode(ifn.cond, indent + 2);

            printIndent(indent + 1);
            std.debug.print("↳ Then:\n", .{});
            try printNode(ifn.if_branch, indent);

            if (ifn.el_branch) |elseb| {
                printIndent(indent + 1);
                std.debug.print("↳ Else:\n", .{});
                try printNode(elseb, indent + 2);
            }
        },
        .ReturnStmt => {
            const ret = node.ReturnStmt;
            std.debug.print("🔙 Return\n", .{});
            if (ret.val) |v| try printNode(v, indent + 1);
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
                for (plist.ParameterList.params) |item| try printNode(item, indent + 2);
            }
        },
        .ConditionalExpression => {
            const cond = node.ConditionalExpression;
            const op = std.mem.span(cond.logicalOperator);
            std.debug.print("❓ Conditional Expression ({s})\n", .{op});

            printIndent(indent + 1);
            std.debug.print("↳ Expression 1:\n", .{});
            try printNode(cond.expr1, indent + 2);

            printIndent(indent + 1);
            std.debug.print("↳ Expression 2:\n", .{});
            try printNode(cond.expr2, indent + 2);
        },
        .ExpressionStmt => {
            if (node.ExpressionStmt.expr) |expr| {
                try printNode(expr, indent);
            }
        },
        .IdPointer => {
            try printNode(node.IdPointer.pointer, indent + 1);
            try printNode(node.IdPointer.identifier, indent + 2);
        },
        .Pointer => {
            const p_node = node.Pointer;
            std.debug.print("😈 Pointer:\n", .{});
            if (p_node.pointee) |p| {
                printIndent(indent + 2);
                std.debug.print("It's just a pointer to a pointer\n", .{});
                try printNode(p, indent + 1);
            } else {
                printIndent(indent + 1);
                std.debug.print("Base\n", .{});
            }
        },
        .Struct => {
            const s_node = node.Struct;
            try printNode(s_node.name, indent + 1);
        },
        .StructDecl => {
            const sd = node.StructDecl;
            try printNode(sd.type, indent);
            for (sd.decl_list) |item| {
                try printNode(item, indent);
            }
        },
        .StructDeclaration => {
            const sd = node.StructDeclaration;
            try printNode(sd.packedNode, indent);
            try printNode(sd.assignNode, indent);
        },
        .StructDeclaratorList => {
            const sd = node.StructDeclaratorList;
            for (sd.declarators) |item| {
                try printNode(item, indent + 1);
            }
        },
        .StructDeclList => {
            const s = node.StructDeclList;
            for (s.decl_list) |item| {
                try printNode(item, indent + 1);
            }
        },
        .TranslationUnitList => {
            const tul = node.TranslationUnitList;
            std.debug.print("📦 Translation Unit List ({} units)\n", .{tul.translationUnits.len});
            for (tul.translationUnits, 0..) |tu, i| {
                printIndent(indent + 1);
                std.debug.print("• Unit [{}]:\n", .{i});
                try printNode(tu, indent + 2);
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
