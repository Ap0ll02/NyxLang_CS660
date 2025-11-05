const std = @import("std");
const ast = @import("ast.zig");

pub const Variable = struct {
    name: []const u8,
    var_type: *ast.TypeNode,
    is_global: bool = false,
    is_const: bool = false,
    is_mutable: bool = false,
    is_initialized: bool = false,
    scope_depth: u32 = 0, // which lexical depth this belongs to
};

pub const Function = struct {
    name: []const u8,
    return_type: *ast.TypeNode,
    parameters: []Variable,
};

pub const SymbolTable = struct {

    // Allocators
    upstream: std.mem.Allocator, // allocator that created this SymbolTable
    arena: std.heap.ArenaAllocator, // This SymbolTable's local allocator
    allocator: std.mem.Allocator, // derived from arena
    //
    // Maps to hold types, variables, and functions

    type_map: std.StringHashMap(ast.TypeNode),
    variable_map: std.StringHashMap(Variable),
    function_map: std.StringHashMap(Function),

    // To support nested scopes, we keep a reference to the parent symbol table
    parent: ?*SymbolTable,

    pub fn create(upstream: std.mem.Allocator, parent: ?*SymbolTable) !*SymbolTable {
        // Allocate the struct from its upstream heap
        const self = try upstream.create(SymbolTable);
        self.* = .{
            .upstream = upstream,
            .arena = std.heap.ArenaAllocator.init(upstream),
            .allocator = undefined,
            .type_map = undefined,
            .variable_map = undefined,
            .function_map = undefined,
            .parent = parent,
        };
        // build our allocator
        self.allocator = self.arena.allocator();
        // initialize and allocate
        self.type_map = std.StringHashMap(ast.TypeNode).init(self.allocator);
        self.variable_map = std.StringHashMap(Variable).init(self.allocator);
        self.function_map = std.StringHashMap(Function).init(self.allocator);

        if (parent == null) {
            // This is the root symbol table
            var at: ast.TypeNode = ast.TypeNode{
                .is_unsigned = false,
                .is_const = false,
                .qualifier = 0, // 0 none, 1 long, 2 long long
                .type_name = "int",
                .size = @sizeOf(i32),
                .alignment = @alignOf(i32),
            };
            try self.assign_type(&at);
            at = ast.TypeNode{
                .is_unsigned = false,
                .is_const = false,
                .qualifier = 1, // 0 none, 1 long, 2 long long
                .type_name = "long",
                .size = @sizeOf(i64),
                .alignment = @alignOf(i64),
            };
            try self.assign_type(&at);
            at = ast.TypeNode{
                .is_unsigned = false,
                .is_const = false,
                .qualifier = 2, // 0 none, 1 long, 2 long long
                .type_name = "long long",
                .size = @sizeOf(i64),
                .alignment = @alignOf(i64),
            };
            try self.assign_type(&at);
            at = ast.TypeNode{
                .is_unsigned = true,
                .is_const = false,
                .qualifier = 0, // 0 none, 1 long, 2 long long
                .type_name = "uint",
                .size = @sizeOf(u32),
                .alignment = @alignOf(u32),
            };
            try self.assign_type(&at);
            at = ast.TypeNode{
                .is_unsigned = true,
                .is_const = false,
                .qualifier = 1, // 0 none, 1 long, 2 long long
                .type_name = "ulong",
                .size = @sizeOf(u64),
                .alignment = @alignOf(u64),
            };
            try self.assign_type(&at);
            at = ast.TypeNode{
                .is_unsigned = true,
                .is_const = false,
                .qualifier = 2, // 0 none, 1 long, 2
                .type_name = "ulong long",
                .size = @sizeOf(u64),
                .alignment = @alignOf(u64),
            };
            try self.assign_type(&at);
            at = ast.TypeNode{
                .is_unsigned = false,
                .is_const = false,
                .qualifier = 0, // 0 none, 1 long, 2 long long
                .type_name = "float",
                .size = @sizeOf(f32),
                .alignment = @alignOf(f32),
            };
            try self.assign_type(&at);
            at = ast.TypeNode{
                .is_unsigned = false,
                .is_const = false,
                .qualifier = 1, // 0 none, 1 long, 2
                .type_name = "double",
                .size = @sizeOf(f64),
                .alignment = @alignOf(f64),
            };
            try self.assign_type(&at);
            at = ast.TypeNode{
                .is_unsigned = false,
                .is_const = false,
                .qualifier = 0, // 0 none, 1 long, 2 long long
                .type_name = "char",
                .size = @sizeOf(u8),
                .alignment = @alignOf(u8),
            };
            try self.assign_type(&at);
            at = ast.TypeNode{
                .is_unsigned = false,
                .is_const = false,
                .qualifier = 0, // 0 none, 1 long, 2 long long
                .type_name = "void",
                .size = 0,
                .alignment = 1,
            };
            try self.assign_type(&at);
            at = ast.TypeNode{
                .is_unsigned = false,
                .is_const = false,
                .qualifier = 0, // 0 none, 1 long, 2 long long
                .type_name = "bool",
                .size = @sizeOf(bool),
                .alignment = @alignOf(bool),
            };
            try self.assign_type(&at);
        }
        return self;
    }

    // Full deinit of maps, local arena and
    // the SymbolTable using its upstream allocator
    pub fn destroy(self: *SymbolTable) void {
        self.type_map.deinit();
        self.variable_map.deinit();
        self.function_map.deinit();
        self.arena.deinit(); // frees everything allocated by self.allocator
        self.upstream.destroy(self);
    }

    pub fn push(self: *SymbolTable) !*SymbolTable {
        return SymbolTable.create(self.upstream, self);
    }

    // Destroys this table and returns the parent
    pub fn pop(self: *SymbolTable) ?*SymbolTable {
        const parent = self.parent;
        self.destroy();
        return parent; // returns null if this is the root
    }

    pub fn current_depth(self: *SymbolTable) usize {
        var idx: usize = 0;
        var current_table = self.parent;
        while (current_table) |ct| {
            current_table = ct.parent;
            idx += 1;
        }
        return idx;
    }

    // We need 3  Assign functions to add types, variables and functions to our symbol table
    // Param: string name, Node* node
    // we will use the Node* to grab all the relevant information to create our type, variable, and function structs then assign them to a key in the respective symbol table
    pub fn assign_type(self: *SymbolTable, type_node: *ast.TypeNode) !void {
        const type_string: []const u8 = std.mem.span(type_node.type_name);
        const key = try self.allocator.dupe(u8, type_string);
        try self.type_map.put(key, type_node.*);
    }

    pub fn assign_variable(self: *SymbolTable, var_node: *ast.IdentifierNode) !void {
        const type_ptr = var_node.typeNode orelse return error.UnknownType;
        const type_name_slice: []const u8 = std.mem.span(type_ptr.type_name);

        const key = try self.allocator.dupe(u8, var_node.name);
        if (ast.debug_mode)
            std.debug.print("Assigning variable {s} of type {s}\n", .{ key, type_name_slice });
        try self.variable_map.put(key, Variable{
            .name = key,
            .var_type = self.get_type(type_name_slice) orelse return error.UnknownType,
        });
    }

    pub fn assign_function(self: *SymbolTable, name: []const u8, func_node: *ast.FunctionNode) !void {
        const key = try self.allocator.dupe(u8, name);
        try self.function_map.put(key, Function{
            .name = key,
            .return_type = self.get_type(func_node.retType.type_name) orelse null,
        });
    }

    // We need 3 Get functions to retrieve types, variables and functions from our symbol table
    // Param: string name
    // return the struct pointer if found, else return null

    pub fn get_type(self: *SymbolTable, name: []const u8) ?*ast.TypeNode {
        var current_table: ?*SymbolTable = self;
        while (current_table) |tbl| : (current_table = tbl.parent) {
            if (tbl.type_map.getPtr(name)) |ptr| return ptr;
        }
        // create and error message here
        std.debug.print("Type {s} not found in symbol table.\n", .{name});
        return null;
    }

    pub fn get_variable(self: *SymbolTable, name: []const u8) ?*Variable {
        var current_table: ?*SymbolTable = self;
        while (current_table) |table| : (current_table = table.parent) {
            if (table.variable_map.getPtr(name)) |var_ptr| return var_ptr;
        }
        std.debug.print("Variable {s} not found in symbol table.\n", .{name});
        return null;
    }

    pub fn get_function(self: *SymbolTable, name: []const u8) ?*Function {
        var current_table: ?*SymbolTable = self;
        while (current_table) |table| : (current_table = table.parent) {
            if (table.function_map.getPtr(name)) |func_ptr| return func_ptr;
        }
        std.debug.print("Function {s} not found in symbol table.\n", .{name});
        return null;
    }
};
