const std = @import("std");
const ast = @import("ast.zig");

const PointerType = struct {
    base_type: *Type = null,
    is_const: bool,
    indirection_level: usize,
};

const Type = struct {
    is_unsigned: bool,
    is_const: bool, // The Value its self is constant think of it as a Pointer to a constant int. You can’t modify the pointee const int* ptr;
    qualifier: usize = 0, // 0 none, 1 long, 2 long long
    //base: BaseType = .INT, We will later integrate this with our ast BaseType enum
    type_name: []const u8,
    size: usize,
    alignment: usize,
};

const Variable = struct {
    name: []const u8,
    var_type: *Type,
    is_global: bool,
    is_const: bool,
    is_mutable: bool,
    is_initialized: bool,
    scope_depth: u32 = 0, // which lexical depth this belongs to
};

const Function = struct {
    name: []const u8,
    return_type: *Type,
    parameters: []Variable,
};

pub const SymbolTable = struct {

    // Allocators
    upstream: std.mem.Allocator,  // allocator that created this SymbolTable
    arena: std.heap.ArenaAllocator,  // This SymbolTable's local allocator
    allocator: std.mem.Allocator,  // derived from arena
                                   //
    // Maps to hold types, variables, and functions
    type_map: std.AutoHashMap([]const u8, Type),
    variable_map: std.AutoHashMap([]const u8, Variable),
    function_map: std.AutoHashMap([]const u8, Function),

    // To support nested scopes, we keep a reference to the parent symbol table
    parent: ?*SymbolTable,

    pub fn create(upstream: std.mem.Allocator, parent: ?*SymbolTable) !*SymbolTable {
        // Allocate the struct from its upstream heap
        const self = try upstream.create(SymbolTable);
        self.* = .{
            .gpa = std.heap.ArenaAllocator.init(upstream),
            .allocator = undefined,
            .type_map = undefined,
            .variable_map = undefined,
            .function_map = undefined,
            .parent = parent,
        };
    
        // build our allocator 
        self.allocator = self.arena.allocator();
        // initialize and allocate
        self.type_map = std.AutoHashMap([]const u8, Type).init(self.allocator);
        self.variable_map = std.AutoHashMap([]const u8, Variable).init(self.allocator);
        self.function_map = std.AutoHashMap([]const u8, Function).init(self.allocator);

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
        return parent;  // returns null if this is the root
    }
    
    pub fn current_depth(self: *SymbolTable) u32 {
        _ = self;
        // Implementation here return the current depth of the symbol table
    }

    // We need 3  Assign functions to add types, variables and functions to our symbol table
    // Param: string name, Node* node
    // we will use the Node* to grab all the relevant information to create our type, variable, and function structs then assign them to a key in the respective symbol table
    pub fn assign_type(self: *SymbolTable, type_node: *ast.TypeNode) void {
        const newType = Type{ .is_unsigned = type_node.is_unsigned, .is_const = type_node.is_const, .qualifier = type_node.qualifier, .type_name = type_node.type_name, .size = type_node.size, .alignment = type_node.alignment };
        try self.type_map.put(newType);
    }

    pub fn assign_variable(self: *SymbolTable, var_node: *ast.IdentifierNode) void {
        const newVar = Variable{
            .name = var_node.name,
            .var_type = get_type(var_node.var_type.type_name) orelse null,
        };
        try self.variable_map.put(var_node.name, newVar);
    }

    pub fn assign_function(self: *SymbolTable, name: []const u8, func_node: *ast.Node) void {
        const newFunc = Function{
            .name = name,
            .return_type = get_type(func_node.return_type.type_name) orelse null,
            // .parameters = func_node.parameters, // This will need to be populated properly
        };
        try self.function_map.put(name, newFunc);
    }

    // We need 3 Get functions to retrieve types, variables and functions from our symbol table
    // Param: string name
    // return the struct pointer if found, else return null

    pub fn get_type(self: *SymbolTable, name: []const u8) ?*Type {
        var current_table: *SymbolTable = self;

        while (current_table) |table| {
            if (table.type_map.getPtr(name)) |type_ptr| {
                return type_ptr;
            }
            current_table = table.parent;
        }
        return null;
    }

    pub fn get_variable(self: *SymbolTable, name: []const u8) ?*Variable {
        var current_table: *SymbolTable = self;
        while (current_table) |table| {
            if (table.variable_map.getPtr(name)) |var_ptr| {
                return var_ptr;
            }
            current_table = table.parent;
        }
    }

    pub fn get_function(self: *SymbolTable, name: []const u8) ?*Function {
        var current_table: *SymbolTable = self;
        while (current_table) |table| {
            if (table.function_map.getPtr(name)) |func_ptr| {
                return func_ptr;
            }
            current_table = table.parent;
        }
    }
};
