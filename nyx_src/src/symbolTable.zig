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

    // Symbol Table Fields
    gpa: std.heap.GeneralPurposeAllocator(.{}),
    allocator: std.mem.Allocator,
    // Maps to hold types, variables, and functions
    type_map: std.AutoHashMap([]const u8, Type),
    variable_map: std.AutoHashMap([]const u8, Variable),
    function_map: std.AutoHashMap([]const u8, Function),

    // To support nested scopes, we keep a reference to the parent symbol table
    parent: ?*SymbolTable,

    pub fn init(parent: ?*SymbolTable) SymbolTable {
        // Build SymbolTable's allocator first
        var self = SymbolTable{
            .gpa = std.heap.GeneralPurposeAllocator(.{}){},
            .allocator = undefined,
            .type_map = undefined,
            .variable_map = undefined,
            .function_map = undefined,
            .parent = parent,
            .owns_allocatpr = true,
        };
    
        // build our allocator 
        self.allocator = self.gpa.allocator();
        // initialize and allocate
        self.type_map = std.AutoHashMap([]const u8, Type).init(self.allocator);
        self.variable_map = std.AutoHashMap([]const u8, Variable).init(self.allocator);
        self.function_map = std.AutoHashMap([]const u8, Function).init(self.allocator);

        return self;
    }

    pub fn deinit(self: *SymbolTable) void {
        self.type_map.deinit();
        self.variable_map.deinit();
        self.function_map.deinit();

        _ = self.gpa.deinit();
    }

    // pub fn init(allocator: std.mem.Allocator) SymbolTable {
    //     // create a global scope which will be the root of all scopes
    //     const global = allocator.create(Scope) catch unreachable;
    //     global.* = Scope{
    //         // This is the global scope hash table
    //         .symbols = std.StringHashMap(*Symbol).init(allocator),
    //         // No parent for the global scope
    //         .parent = null,
    //     };
    //     // return the symbol table with the global scope as the current scope
    //     return SymbolTable{ .allocator = allocator, .current = global };
    // }
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

    // *************Symbol Table Functions********************
    // Symbol Table initilization function

    pub fn push_table(self: *SymbolTable) *SymbolTable {
        _ = self;
        // Implementation here create a new symbol table and set the new table to self
    }

    pub fn pop_table(self: *SymbolTable) *SymbolTable {
        _ = self;
        // Implementation here set self to parent and deinitialize the current table
    }

    pub fn current_depth(self: *SymbolTable) u32 {
        _ = self;
        // Implementation here return the current depth of the symbol table
    }
};
