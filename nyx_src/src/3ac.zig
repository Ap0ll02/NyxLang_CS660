const std = @import("std");
const m = @import("main.zig");
const ast = @import("ast.zig");
const log = @import("Log.zig");

pub const CompileError = error{
    OutOfMemory,
    UnsupportedNode,
    UnsupportedBinaryOp,
    UndefinedVariable,
    Invalid,
    todo,
};

pub const Instruction = enum { 
    Add, Subtract, Multiply, Divide, 
    Constant, LoadByte, StoreByte, StoreDouble, LoadDouble,
    Label, Goto, If,
    ImbueFrame,
    ImbueRegister,
    ImbueLabel,
    StoreRegister,
    LoadRegister,
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
    file_text: std.ArrayList(u8),
    var_registers: std.StringHashMap(Register),
    var_locations: std.StringHashMap(usize),
    count: Register,
    fp_offset: usize,
    
    pub fn init(alloc: std.mem.Allocator, root: *ast.Node) !*Compiler {
        const compiler = try alloc.create(Compiler);
        compiler.* = .{
            .alloc = alloc,
            .root = root,
            .nyac_list = .empty,
            .file_text = .empty,
            .var_registers = std.StringHashMap(Register).init(alloc),
            .var_locations = std.StringHashMap(usize).init(alloc),
            .count = 8,
            .fp_offset = 0,
        };
        return compiler;
    }
    pub fn deinit(self: *Compiler) void {
        self.nyac_list.deinit(self.alloc);
        self.file_text.deinit(self.alloc);
        self.var_registers.deinit();
        self.var_locations.deinit();
        self.alloc.destroy(self);
    }

    pub fn compile(self: *Compiler) !std.ArrayList(NYAC) {
        const old_root = self.root;

        switch (self.root.*) {
            .BlockItems => |bi| {
                for (bi.items) |b| {
                    self.root = b;
                    _ = try self.compile_node(true);
                }
            },
            else => {}
        }

        self.root = old_root;

        const file_name = "a.nyac";
        const file = try std.fs.cwd().openFile(file_name, .{
            .mode = .write_only,
        });
        defer file.close();
        if(ast.debug_mode) std.debug.print("{s}", .{self.file_text.items});
        try file.writeAll(self.file_text.items);

        return self.nyac_list;
    }

    pub fn compile_node(self: *Compiler, is_root: bool) anyerror!Register {
        try check_write(self, is_root); 
        // Note: All of the diagnostic source prints need to be moved
        // to file writing, we will write the source line and then
        // write the associated 3ac with it below.
        return switch (self.root.*) {
            .Identifier => |id| try self.handle_ident(id),
            .Declaration => |decl| try self.handle_decl(decl),
            .Assignment => |as| try self.handle_assignment(as),
            // .Function => |fun| try self.handle_function(fun),
            .Constant => |c| try self.handle_constant(c),
            .Binary => |bn| try self.handle_binary(bn),
            else => return CompileError.UnsupportedNode,
        };

    }
    pub fn handle_ident(self: *Compiler, root: *ast.IdentifierNode) anyerror!Register {
        return self.var_registers.get(root.name) orelse return CompileError.UndefinedVariable;
    }

    pub fn handle_decl(self: *Compiler, root: *ast.DeclarationNode) anyerror!Register {
        const name = root.declaration_specifier.?.Identifier.name;
        // allocate register slot
        self.count += 1;
        const dest = self.count;

        // track the variable and register
        try self.var_registers.put(name, dest);

        const nyac = NYAC {
            .instruction = .ImbueRegister,
            .return_addr = dest,
            .op1_addr = Unused,
            .op2_addr = Unused,
        };
        try self.nyac_list.append(self.alloc, nyac);
        try self.emit(nyac);
        return dest; // should return register? fixed return type
    }

    pub fn handle_assignment(self: *Compiler, root: *ast.AssignmentNode) anyerror!Register {
        const var_name = root.declarator.Identifier.name;
        const lhs_reg = self.var_registers.get(var_name) orelse return CompileError.UndefinedVariable;
        const rhs_reg = try self.compile_expr(root.initializer.?);

        const nyac = NYAC {
            .instruction = .StoreRegister,
            .return_addr = lhs_reg,
            .op1_addr = rhs_reg,
            .op2_addr = Unused,
        };

        try self.nyac_list.append(self.alloc, nyac);
        try self.emit(nyac);

        return lhs_reg;
    }

    // pub fn handle_function(self: *Compiler, root: *ast.FunctionNode) !NYAC {
    //     return error.Error;
    // }

    pub fn handle_binary(self: *Compiler, node: *ast.BinaryNode) anyerror!Register {
        // Compiling the left and right nodes into registers
        self.root = node.lhs;
        const left_reg = try self.compile_node(false);

        self.root = node.rhs;
        const right_reg = try self.compile_node(false);

        // Destination reg
        self.count += 1;
        const dest= self.count;

        // ENUM Instruction
        const instr = switch(node.op) {
            '+' => Instruction.Add,
            '-' => Instruction.Subtract,
            '*' => Instruction.Multiply,
            '/' => Instruction.Divide,
            else => return CompileError.UnsupportedBinaryOp
        };

        const nyi = NYAC {
            .instruction = instr,
            .return_addr = dest,
            .op1_addr = left_reg,
            .op2_addr = right_reg,
        };

        // Append to NYAC list and emit to file
        try self.nyac_list.append(self.alloc, nyi);
        try self.emit(nyi);

        return dest;
    }

    pub fn handle_constant(self: *Compiler, root: *ast.ConstantNode) anyerror!Register {
        self.count += 1;
        const dest = self.count;
        const val = try std.fmt.parseInt(i32, root.value, 10);
        const nyi = NYAC {
            .instruction = .Constant,
            .op1_addr = @intCast(val),
            .return_addr = dest,
            .op2_addr = Unused,
        };

        // Append to list
        try self.nyac_list.append(self.alloc, nyi);
        // Emit IR to file
        try self.emit(nyi);

        return dest;
    }

    pub fn check_write(self: *Compiler, is_root: bool) !void {
        if(!is_root) return;
        const line = switch (self.root.*) {
            .Identifier => |id| id.location.?.line,
            .Declaration => |decl| decl.location.?.line,
            .Assignment => |as| as.location.?.line,
            // .Function => |fun| fun.location.?.line,
            .Constant => |c| c.location.?.line,
            .Binary => |bn| bn.location.?.line,
            // if any node type lacks a location, fallback:
            else => 0,
        };
        if (ast.debug_mode and is_root) {
            try self.file_text.appendSlice(self.alloc, m.diagnostic_source(line));
            try self.file_text.append(self.alloc, '\n');
        }
    }

    pub fn compile_expr(self: *Compiler, node: *ast.Node) anyerror!Register {
        const original = self.root;
        self.root = node;
        const reg = try self.compile_node(false);
        self.root = original;
        return reg;
    }

    pub fn emit(self: *Compiler, inst: NYAC) !void {
        const writer = &self.file_text;
        try writer.appendSlice(self.alloc, switch(inst.instruction) {
            .Add => "ADD",
            .Subtract => "SUB",
            .Multiply => "MUL",
            .Divide => "DIV",
            .Constant => "CONST",
            .LoadByte => "LB",
            .StoreByte => "SB",
            .LoadDouble => "LD",
            .StoreDouble => "SD",
            .Label => "LABEL",
            .Goto => "GOTO",
            .If => "IF",
            else => "UNKNOWN",
        });

        // should be using appendSlide for strings
        var tmp = try std.fmt.allocPrint(self.alloc, " {}", .{inst.return_addr});
        try writer.appendSlice(self.alloc, tmp);
        self.alloc.free(tmp);

        tmp = try std.fmt.allocPrint(self.alloc, ", {}", .{inst.op1_addr});
        try writer.appendSlice(self.alloc, tmp);
        self.alloc.free(tmp);

        if(inst.op2_addr != Unused) {
            tmp = try std.fmt.allocPrint(self.alloc, ", {}", .{inst.op2_addr});
            try writer.appendSlice(self.alloc, tmp);
            self.alloc.free(tmp);
        }

        try writer.append(self.alloc, '\n');
    }
};
