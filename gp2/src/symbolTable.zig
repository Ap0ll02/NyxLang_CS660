pub const std = @import("std");

const c = @cImport({
    @cInclude("c11.tab.h");
});

// We define a simple enum for type information
pub const TypeInfo = enum {
    Int,
    Float,
    Bool,
    Str,
    Void,
};

pub const typeKind = struct {
    type: TypeInfo,
    isArray: bool,
    arraySize: ?usize,
};

export fn typeFinder(token: c_int) typeKind {
    return switch (token) {
        c.INT => blk: {
            std.debug.print("Type is Int\n", .{});
            break :blk typeKind{ .type = .Int, .isArray = false, .arraySize = null };
        },
        c.FLOAT => blk: {
            std.debug.print("Type is Float\n", .{});
            break :blk typeKind{ .type = .Float, .isArray = false, .arraySize = null };
        },
        c.BOOL => blk: {
            std.debug.print("Type is Bool\n", .{});
            break :blk typeKind{ .type = .Bool, .isArray = false, .arraySize = null };
        },
        c.VOID => blk: {
            std.debug.print("Type is Void\n", .{});
            break :blk typeKind{ .type = .Void, .isArray = false, .arraySize = null };
        },
        else => blk: {
            std.debug.print("Unknown type token: {}\n", .{token});
            break :blk typeKind{ .type = .Int, .isArray = false, .arraySize = null };
        },
    };
}

// each scope has a hashmap of symbols
pub const Symbol = struct {
    name: []const u8,
    type: typeKind,
    isMutable: bool,
    depth: usize, // Scope depth which we will use for debugging aka shadowing
};

// we use a stack of scopes to manage variable scopes
// when we enter a new scope, we push a new scope onto the stack
pub const Scope = struct {
    parent: ?*Scope,
    symbols: std.StringHashMap(*Symbol),
};

pub const SymbolTableError = error{
    SymbolAlreadyExists,
    OutOfMemory,
};

pub const SymbolTable = struct {
    allocator: ?std.mem.Allocator,
    current: ?*Scope,

    pub fn init(allocator: std.mem.Allocator) SymbolTable {
        // create a global scope which will be the root of all scopes
        const global = allocator.create(Scope) catch unreachable;
        global.* = Scope{
            // This is the global scope hash table
            .symbols = std.StringHashMap(*Symbol).init(allocator),
            // No parent for the global scope
            .parent = null,
        };
        // return the symbol table with the global scope as the current scope
        return SymbolTable{ .allocator = allocator, .current = global };
    }

    pub fn pushScope(self: *SymbolTable) void {
        const allocator = self.allocator orelse return;
        // Create the new scope
        const newScope = allocator.create(Scope) catch unreachable;
        // We set its parent to the current scope
        newScope.* = Scope{
            .symbols = std.StringHashMap(*Symbol).init(allocator),
            .parent = self.current,
        };
        // Update the current scope to the new scope
        self.current = newScope;
    }

    pub fn popScope(self: *SymbolTable) void {
        // Just good error checking to avoid popping the global scope
        if (self.current) |cur| {
            if (cur.parent) |parentScope| {
                self.current = parentScope;
            } else {
                // We are at the global scope, cannot pop further
                std.debug.warn("Warning: Attempted to pop global scope, operation ignored.\n");
            }
        } else {
            std.debug.warn("Warning: Attempted to pop scope when no current scope exists.\n");
        }
    }

    pub fn addSymbol(self: *SymbolTable, name: []const u8, typ: typeKind, isMutable: bool) anyerror!void {
        // Check if the symbol already exists in the current scope
        if (self.current) |cur| {
            if (cur.symbols.get(name)) |_| {
                return SymbolTableError.SymbolAlreadyExists;
            } else {
                const allocator = self.allocator orelse return SymbolTableError.OutOfMemory;
                // Create a new symbol
                const symbol = allocator.create(Symbol) catch return SymbolTableError.OutOfMemory;
                symbol.* = Symbol{
                    .name = name,
                    .type = typ,
                    .isMutable = isMutable,
                    .depth = self.getCurrentDepth(),
                };
                // Add the symbol to the current scope
                try cur.symbols.put(name, symbol);
            }
        } else {
            return SymbolTableError.OutOfMemory;
        }
    }

    /// This function is used to find a symbol in the current scope or any of its parent scopes
    pub fn lookUp(self: *SymbolTable, name: []const u8) ?*Symbol {
        // Look for the symbol in the current scope and its parents
        var scope: ?*Scope = self.current;
        while (scope) |s| {
            // If found, return it
            if (s.symbols.get(name)) |symbol| {
                return symbol;
            }
            // Move to the parent scope
            scope = s.parent;
        }
        std.debug.print("Symbol not found: {}\n", .{name});
        return null;
    }

    pub fn getCurrentDepth(self: *SymbolTable) usize {
        var depth: usize = 0;
        var s: ?*Scope = self.current;
        while (s) |sc| {
            depth += 1;
            s = sc.parent;
        }
        if (depth == 0) return 0;
        return depth - 1;
    }

    // This is a design choice that we need to discuss later, by leaving all the deallocation to the deinit function
    // we can avoid the complexity of managing memory for each scope individually, but it also means that we need to be careful to call deinit when we're done with the symbol table
    // We can also consider using a more sophisticated memory management strategy if needed in the future since we currently are not deallocating memory for symbols or scopes individually
    pub fn deinit(self: *SymbolTable) void {
        const allocator = self.allocator orelse return;
        var scope: ?*Scope = self.current;
        while (scope) |s| {
            // Free all symbols in the current scope
            s.symbols.deinit();
            // Save parent, destroy current scope, then continue
            const parent = s.parent;
            allocator.destroy(s);
            scope = parent;
        }
        self.current = null;
    }
};
