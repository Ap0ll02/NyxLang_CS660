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
pub const Compiler = struct {
    alloc: std.mem.Allocator,
    root: *ast.Node,
    nyac_list: std.ArrayList(NYAC),
    
    pub fn init(alloc: std.mem.Allocator, root: *ast.Node) !Compiler {
        const compiler = Compiler {
            .alloc = alloc,
            .root = root,
            .nyac_list = .empty,
        };
        return compiler;
    }

    pub fn compile(self: *Compiler) !std.ArrayList(NYAC) {
        try self.compile_node(self.root);
        return self.nyac_list;
    }

    pub fn compile_node(self: *Compiler) !void {
        switch (self.root.*) {
            .Identifier => |id| {
                try nyac_list.append(self.alloc, try handle_ident(id));
            },
            .Declaration => |decl| {
                try nyac_list.append(self.alloc, try handle_decl(decl));
            },
            .Assignment => |as| {
                try nyac_list.append(self.alloc, try handle_assignment(as));
            },
            .Function => |fun| {
                try nyac_list.append(self.alloc, try handle_function(fun));
            },
            .Constant => |c| {
                try nyac_list.append(self.alloc, try handle_constant(c));
            },
            .Binary => |bn| {
                try nyac_list.append(self.alloc, try handle_binary(bn));
            },

            else => {},
        }

    }
    pub fn handle_ident(self: *Compiler, root: *ast.IdentifierNode) !NYAC {
        return error.Error;
    }

    pub fn handle_decl(self: *Compiler, root: *ast.DeclarationNode) !NYAC {
        return error.Error;
    }

    pub fn handle_assignment(self: *Compiler, root: *ast.AssignmentNode) !NYAC {
        return error.Error;
    }

    pub fn handle_function(self: *Compiler, root: *ast.FunctionNode) !NYAC {
        return error.Error;
    }

    pub fn handle_binary(self: *Compiler, root: *ast.BinaryNode) !NYAC {
        return error.Error;
    }

    pub fn handle_constant(self: *Compiler, root: *ast.ConstantNode) !NYAC {
        count += 1;
        return NYAC {
            .instruction = .Constant,
            .op1_addr = root.value,
            .return_addr = count,
            .op2_addr = Unused,
        };
    }
};
