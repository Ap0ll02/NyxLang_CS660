const std = @import("std");
const c = @cImport(@cInclude("c11.tab.h"));

pub const NodeTag = enum {
    Identifier,
    Constant,
    Declaration,
    WhileStmt,
    IfStmt,

    ReturnStmt,

    // Unlabeled
    Function,
    Block,

    // Mathematical: Arith, Logic, Comp, Cast
    Binary,
    Unary,
    Logic,
    Comp,
    Cast,

    // Variables, Pointers and Arrays

    // Control Flow (If, Loops)

    // Literals
    String,
    Int,
    Float,
};

// Identifier node represents variable/function names
// It includes the name as a string
pub const IdentifierNode = struct {
    name: []const u8,
};

// Constant node represents literal values
// It includes the value and its type information
pub const constantNode = struct {
    value: []const u8,
    typeInfo: TypeInfo,
};

// Declaration node represents variable declarations
// It includes the variable name, type, and optional initializer
pub const declarationNode = struct {
    varName: []const u8,
    varType: TypeInfo,
    initializer: ?*Node = null,
};

// This is the main AST node type
// It is a tagged union of all possible node types
// Each node type is a struct with its own fields
// Now when we create a new node, we specify its type and fill in the relevant fields
// This helps identify what kind of node it is and access its data accordingly alongside of enforcing type safety
pub const Node = union(NodeTag) {
    Identifier: *IdentifierNode,
    Constant: *constantNode,
    Declaration: *declarationNode,
};

// Type information structure
// This can be expanded to include more type details as needed
// We can add enums for type kinds (int, float, string, etc.)
// and additional fields for complex types (arrays, structs, etc.) in the future
pub const TypeInfo = struct {
    type_name: []const u8,
    size: usize,
    alignment: usize,
};

// Function to get type information based on token
// This is based off the c11.tab.h tokens
// We can expand this function as we add more types
// For now, it handles int, float, and string types
pub fn type_info(token: c_int) TypeInfo {
    switch (token) {
        c.FLOAT => {
            return TypeInfo{ .type_name = "float", .size = @sizeOf(f64), .alignment = @alignOf(f64) };
        },
        c.INT => {
            return TypeInfo{ .type_name = "int", .size = @sizeOf(i64), .alignment = @alignOf(i64) };
        },
        c.STRING => {
            return TypeInfo{ .type_name = "string", .size = @sizeOf([]const u8), .alignment = @alignOf([]const u8) };
        },
        else => {
            // Error
        },
    }
}

// Creation Functions

export fn create_identifier(name: []const u8) *Node {
    // We create the identifier node
    const id_node = std.heap.c_allocator.create(IdentifierNode) catch return null;
    // We set the name for the identifier node
    id_node.* = IdentifierNode{ .name = name };

    // We create a *node that wraps a specific node type
    const node = std.heap.c_allocator.create(Node) catch return null;
    // We set the union to be of type Identifier and assign the created identifier node
    node.* = Node{ .Identifier = id_node };

    // We return the created node
    return node;
}

export fn create_constant(value: []const u8, typeInfo: TypeInfo) *Node {
    // We create the constant node
    const const_node = std.heap.c_allocator.create(constantNode) catch return null;
    // We set the value and type information for the constant node
    const_node.* = constantNode{ .value = value, .typeInfo = typeInfo };

    // We create a *node that wraps a specific node type
    const node = std.heap.c_allocator.create(Node) catch return null;
    // We set the union to be of type Constant and assign the created constant node
    node.* = Node{ .Constant = const_node };

    // We return the created node
    return node;
}

// The initializer is optional, so it can be null if there is no initializer
// int x = 5;  // initializer is present
// int y;      // initializer is null
export fn create_declaration(varName: []const u8, varType: TypeInfo, initializer: ?*Node) *Node {
    // We create the declaration node
    const decl_node = std.heap.c_allocator.create(declarationNode) catch return null;
    // We set the variable name, type, and optional initializer for the declaration node
    decl_node.* = declarationNode{ .varName = varName, .varType = varType, .initializer = initializer };

    // We create a *node that wraps a specific node type
    const node = std.heap.c_allocator.create(Node) catch return null;
    // We set the union to be of type Declaration and assign the created declaration node
    node.* = Node{ .Declaration = decl_node };

    // We return the created node
    return node;
}

export fn printNode(node: *Node) void {
    switch (node.*) {
        .Identifier => {
            const id_node = node.Identifier;
            std.debug.print("Identifier: {s}\n", .{id_node.name});
        },

        .Constant => {
            const const_node = node.Constant;
            std.debug.print("Constant: {s}, Type: {s}\n", .{ const_node.value, const_node.typeInfo.type_name });
        },

        .Declaration => {
            const decl_node = node.Declaration;
            std.debug.print("Declaration: {s}, Type: {s}\n", .{ decl_node.varName, decl_node.varType.type_name });
            if (decl_node.initializer) |init| {
                std.debug.print("  Initializer:\n", .{});
                printNode(init);
            } else {
                std.debug.print("  No Initializer\n", .{});
            }
        },
    }
}
