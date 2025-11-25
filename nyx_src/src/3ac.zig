const std = @import("std");
const m = @import("main.zig");
const ast = @import("ast.zig");
const log = @import("Log.zig");

pub const Instruction = enum { 
    Add, Subtract, Multiply, Divide, 
    Constant, LoadByte, StoreByte, StoreDouble, LoadDouble,
    Label, Goto, If,
};
pub const Value = union(enum) {
    Number: i32,
    String: []const u8,
    Char: u8,
    Void: void,
};

// Reserved Register Allocation
pub const Register = u32;
// pub const Registers = enum { Unused, A0, A1, A2, A3, A4, A5, A6, A7 };
const Unused: Register = 0;
const A0: Register = 1;
const A1: Register = 2;
const A2: Register = 3;
const A3: Register = 4;
const A4: Register = 5;
const A5: Register = 6;
const A6: Register = 7;
const A7: Register = 8;
pub var count: Register = 8;

pub const NYAC = struct { 
    return_addr: u32, instruction: Instruction, 
    op1_addr: u32, op2_addr: u32 
};

// Storage for registers, and the outputted nyac_list
var registers: std.ArrayList(Value) = .empty;
var nyac_list: std.ArrayList(NYAC) = .empty;

// Pre-allocation to Registers

// =======================
// ==    3AC EMISSION   ==
// =======================
//  -- NOTES: --
//  Indices into registers[] list is reserved from 0-8
//  Please be mindful of which index you use. If you need
//  extra registers start from 9.
// pub struct  make this a struct for sharing and recalling
pub fn compile(root: *ast.Node, alloc: std.mem.Allocator) ?std.ArrayList(NYAC) {
    // --- THIS GUARANTEES THE FIRST 8 REGISTERS ARE CREATED ---
    registers.append(alloc, Value {.Void = void} );
    registers.append(alloc, Value {.Void = void} );
    registers.append(alloc, Value {.Void = void} );
    registers.append(alloc, Value {.Void = void} );
    registers.append(alloc, Value {.Void = void} );
    registers.append(alloc, Value {.Void = void} );
    registers.append(alloc, Value {.Void = void} );
    registers.append(alloc, Value {.Void = void} );
    // ---
    
    switch (root.*) {
        .Identifier => |id| {
            nyac_list.append(alloc, handle_ident(id)) catch return null;
        },
        .Declaration => |decl| {
            nyac_list.append(alloc, handle_decl(decl)) catch return null;
        },
        .Assignment => |as| {
            nyac_list.append(alloc, handle_assignment(as)) catch return null;
        },
        .Function => |fun| {
            nyac_list.append(alloc, handle_function(fun)) catch return null;
        },
        .Constant => |c| {
            nyac_list.append(alloc, handle_constant(c)) catch return null;
        },
        .Binary => |bn| {
            nyac_list.append(alloc, handle_binary(bn)) catch return null;
        },

        else => {},
    }
}

pub fn handle_ident(root: *ast.IdentifierNode) ?NYAC {
    return null;
}

pub fn handle_decl(root: *ast.DeclarationNode) ?NYAC {
    return null;
}

pub fn handle_assignment(root: *ast.AssignmentNode) ?NYAC {
    return null;
}

pub fn handle_function(root: *ast.FunctionNode) ?NYAC {
    return null;
}

pub fn handle_binary(root: *ast.BinaryNode) ?NYAC {
    root
}

pub fn handle_constant(root: *ast.ConstantNode) ?NYAC {
    count += 1;
    return NYAC {
        .instruction = .Constant,
        .op1_addr = root.value,
        .return_addr = count,
        .op2_addr = Unused,
    };
}
