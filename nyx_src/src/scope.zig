const std = @import("std");
const ast = @import("ast.zig");

pub const SymbolTable = struct {

    // Allocators
    upstream: std.mem.Allocator, // allocator that created this SymbolTable
    arena: std.heap.ArenaAllocator, // This SymbolTable's local allocator
    allocator: std.mem.Allocator, // derived from arena
    //
    // Maps to hold types, variables, and functions

    type_map: std.StringHashMap(ast.TypeNode),
    variable_map: std.StringHashMap(ast.DeclarationNode),
    function_map: std.StringHashMap(ast.FunctionNode),

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
        self.variable_map = std.StringHashMap(ast.DeclarationNode).init(self.allocator);
        self.function_map = std.StringHashMap(ast.FunctionNode).init(self.allocator);
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
        try self.type_map.put(key, type_node);
    }

    pub fn assign_variable(self: *SymbolTable, var_node: *ast.DeclarationNode) !void {
        const type_ptr = var_node.typeNode orelse return error.UnknownType;
        const type_name_slice: []const u8 = std.mem.span(type_ptr.type_name);

        const key = try self.allocator.dupe(u8, var_node.name);
        if (ast.debug_mode)
            std.debug.print("Assigning variable {s} of type {s}\n", .{ key, type_name_slice });
        try self.variable_map.put(key, ast.DeclarationNode{
            .name = key,
            .typeNode = self.get_type(type_name_slice) orelse return error.UnknownType,
        });
    }

    pub fn assign_function(self: *SymbolTable, name: []const u8, func_node: *ast.FunctionNode) !void {
        const key = try self.allocator.dupe(u8, name);
        const func_ret_type_name_slice: []const u8 = std.mem.span(func_node.retType.type_name);

        // create a []Variable from the NameParameter node attached to the Function
        if (func_node.nameParam.NameParameterNode.parameterList) |raw_parameter_list| {
            const parameter_list = raw_parameter_list.ParameterList.params;
            const param_count = parameter_list.len;
            var params = try self.allocator.alloc(Variable, param_count);
            var i: usize = 0;
            for (parameter_list) |p| {
                const param_type = p.Declaration.typeNode;
                const param_type_name: []const u8 = std.mem.span(param_type.type_name);
                const param_name = std.mem.span(p.Declaration.typeNode.type_name);

                // TODO this might be redundant? since we already have param_type so checking the name against symbol table might be unnecessary
                if (self.get_type(param_type_name)) |st_param_type| {
                    params[i] = Variable{
                        .name = param_name,
                        .var_type = st_param_type,
                    };
                } else {
                    // TODO error here "Parameter type param_type_name not found in symbol table"
                    // TODO params[i] might still need to be assigned something here
                }

                i += 1;
            }

            try self.function_map.put(key, Function{ .name = key, .return_type = self.get_type(func_ret_type_name_slice) orelse return error.UnknownType, .parameters = params });
        }
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

    pub fn get_variable(self: *SymbolTable, name: []const u8) ?*ast.DeclarationNode {
        var current_table: ?*SymbolTable = self;
        while (current_table) |table| : (current_table = table.parent) {
            if (table.variable_map.getPtr(name)) |var_ptr| return var_ptr;
        }
        std.debug.print("Variable {s} not found in symbol table.\n", .{name});
        return null;
    }

    pub fn get_function(self: *SymbolTable, name: []const u8) ?*ast.FunctionNode {
        var current_table: ?*SymbolTable = self;
        while (current_table) |table| : (current_table = table.parent) {
            if (table.function_map.getPtr(name)) |func_ptr| return func_ptr;
        }
        std.debug.print("Function {s} not found in symbol table.\n", .{name});
        return null;
    }
};
