const std = @import("std");
const ast = @import("ast.zig");


struct SymbolTable
{
    
    const var parent: ?*SymbolTable = null;
    // Creating structs that we point to in our maps
    // Type, Variable, Function Quinn
    struct Type
    {
        name: []const u8,
        size: usize,
        allignment: usize,
        is_pointer: bool,
    }

    struct Variable
    {
        name: []const u8,
        var_type: *Type,
        is_mutable: bool,
        is_contant: bool,
    }

    struct Function
    {
        name: []const u8,
        return_type: *Type,
        parameters: []Variable,
    }

    // Creating the maps that we will use in our symbol table

    // To use our Allocator
    // Quinn
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    // To free our allocated memory
    defer {
        const leaked = gpa.deinit();
        if (leaked) {
            std.debug.print("ERROR: Memory leak detected!\n", .{});
        }
    }

        // Assign values to maps
        var type_map = std.AutoHashMap([]const u8, Type).init(allocator);
        var variable_map = std.AutoHashMap([]const u8, Variable).init(allocator);
        var function_map = std.AutoHashMap([]const u8, Function).init(allocator);
        defer {
            type_map.deinit();
            variable_map.deinit();
            function_map.deinit();
        }
        

        // We need 3  Assign functions to add types, variables and functions to our symbol table
        // Param: string name, Node* node
        // we will use the Node* to grab all the relevant information to create our type, variable, and function structs then assign them to a key in the respective symbol table
        fn assignType(name: []const u8, type_node: *ast.Node) void
        {
            // Implementation here
        }

        fn assignVariable(name: []const u8, var_node: *ast.Node) void
        {
            // Implementation here
        }

        fn assignFunction(name: []const u8, func_node: *ast.Node) void
        {
            // Implementation here
        }

        // We need 3 Get functions to retrieve types, variables and functions from our symbol table
        // Param: string name
        // return the struct pointer if found, else return null
        fn getType(name: []const u8) ?*Type
        {
            // Implementation here
        }
        fn getVariable(name: []const u8) ?*Variable
        {
            // Implementation here
        }
        fn getFunction(name: []const u8) ?*Function
        {
            // Implementation here
        }

        // *************Symbol Table Functions********************
        // Symbol Table initilization function
        fn initSymbolTable() void
        {
            // Implementation here
        }

        // Symbol Table deinitilization function 
        fn deinitSymbolTable() void
        {
            // Implementation here
        }
        // Symbol Table Push function Richie
        fn pushSymbolTable() void
        {
            // Implementation here
        }
        // Symbol Table Pop function Richie 
        fn popSymbolTable() void
        {
            // Implementation here
        }
        // Symbol Table Get Depth function Richie and Quinn
        fn getSymbolTableDepth() usize
        {
            // Implementation here
        }


}


