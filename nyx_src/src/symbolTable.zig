const std = @import("std");
const ast = @import("ast.zig");

const PointerType = struct {
    base_type: ?*Type,
    is_const: bool,
    indirection_level: usize,
};

pub const Type = struct {
    is_unsigned: bool = false,
    is_const: bool = false, // The Value its self is constant think of it as a Pointer to a constant int. You can’t modify the pointee const int* ptr;
    qualifier: usize = 0, // 0 none, 1 long, 2 long long
    //base: BaseType = .INT, We will later integrate this with our ast BaseType enum
    type_name: []const u8 = "default_type",
    size: usize = 0,
    alignment: usize = 0,
};

pub const Variable = struct {
    name: []const u8,
    var_type: ?*Type = null,
    is_global: bool = false,
    is_const: bool = false,
    is_mutable: bool = false,
    is_initialized: bool = false,
    scope_depth: u32 = 0, // which lexical depth this belongs to
};

pub const Function = struct {
    name: []const u8,
    return_type: *Type,
    parameters: []Variable,
};

pub const SymbolTable = struct {

    // Allocators
    upstream: std.mem.Allocator, // allocator that created this SymbolTable
    arena: std.heap.ArenaAllocator, // This SymbolTable's local allocator
    allocator: std.mem.Allocator, // derived from arena
    //
    // Maps to hold types, variables, and functions

    type_map: std.StringHashMap(Type),
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
        self.type_map = std.StringHashMap(Type).init(self.allocator);
        self.variable_map = std.StringHashMap(Variable).init(self.allocator);
        self.function_map = std.StringHashMap(Function).init(self.allocator);

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
        const key = try self.allocator.dupe(u8, type_node.type_name);
        try self.type_map.put(key, Type{
            .is_unsigned = type_node.is_unsigned,
            .is_const = type_node.is_const,
            .qualifier = type_node.qualifier,
            .type_name = key,
            .size = type_node.size,
            .alignment = type_node.alignment,
        });
    }

    pub fn assign_variable(self: *SymbolTable, var_node: *ast.IdentifierNode) !void {
        const tn = var_node.typeNode;
        const type_name_slice: []const u8 = std.mem.span(tn.type_name);

        const key = try self.allocator.dupe(u8, var_node.name);
        if (ast.debug_mode)
            std.debug.print("Assigning variable {s} of type {s}\n", .{ key, type_name_slice });
        try self.variable_map.put(key, Variable{
            .name = key,
            .var_type = self.get_type(type_name_slice) orelse return error.UnknownType,
        });
    }

    pub fn assign_function(self: *SymbolTable, name: []const u8, func_node: *ast.Node) !void {
        const key = try self.allocator.dupe(u8, name);
        try self.function_map.put(key, Function{
            .name = key,
            .return_type = self.get_type(func_node.return_type.type_name) orelse null,
        });
    }

    // We need 3 Get functions to retrieve types, variables and functions from our symbol table
    // Param: string name
    // return the struct pointer if found, else return null

    pub fn get_type(self: *SymbolTable, name: []const u8) ?*Type {
        var current_table: ?*SymbolTable = self;
        while (current_table) |tbl| : (current_table = tbl.parent) {
            if (tbl.type_map.getPtr(name)) |ptr| return ptr;
        }
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
