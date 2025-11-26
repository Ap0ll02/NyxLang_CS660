const std = @import("std");
const m = @import("main.zig");
const ast = @import("ast.zig");
const log = @import("Log.zig");

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
    
    pub fn init(alloc: std.mem.Allocator, root: *ast.Node) !Compiler {
        const compiler = Compiler {
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

    pub fn compile(self: *Compiler) !std.ArrayList(NYAC) {
        const old_root = self.root;

        switch (self.root.*) {
            .BlockItems => |bi| {
                for (bi.items) |b| {
                    self.root = b;
                    try self.compile_node(true);
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
        try file.writer(self.file_text);
        return self.nyac_list;
    }

    pub fn compile_node(self: *Compiler, is_root: bool) !Register {
        try check_write(self, is_root); 
        // Note: All of the diagnostic source prints need to be moved
        // to file writing, we will write the source line and then
        // write the associated 3ac with it below.
        return switch (self.root.*) {
            .Identifier => |id| try self.handle_ident(id),
            .Declaration => |decl| try self.handle_decl(decl),
            .Assignment => |as| try self.handle_assignment(as),
            .Function => |fun| try self.handle_function(fun),
            .Constant => |c| try self.handle_constant(c),
            .Binary => |bn| try self.handle_binary(bn),
            else => return error.UnsupportedNode,
        };

    }
    pub fn handle_ident(self: *Compiler, root: *ast.IdentifierNode) !Register {
        const reg_opt = self.var_registers.get(root.name);
        if(!reg_opt) return error.UndefinedVariable;
        return reg_opt.?;
    }

    pub fn handle_decl(self: *Compiler, root: *ast.DeclarationNode) !NYAC {
        const name = root.declaration_specifier.?.Identifier.name;
        // allocate register slot
        self.count += 1;
        const dest = self.count;

        // track the variable and register
        try self.var_registers.put(name, dest);

        const nyac = NYAC {
            .instruction = .ImbueRegister,
            .return_addr = dest,
            .op1_addr = .Unused,
            .op2_addr = Unused,
        };
        try self.nyac_list.append(self.alloc, nyac);
        try self.emit(nyac);
        return dest;
    }

    pub fn handle_assignment(self: *Compiler, root: *ast.AssignmentNode) !NYAC {
        const var_name = root.declarator.Identifier.name;
        const lhs_reg_opt = self.var_registers.get(var_name);
        if(!lhs_reg_opt) return error.UndefinedVariable;
        const lhs_reg = lhs_reg_opt.?;
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

    pub fn handle_function(self: *Compiler, root: *ast.FunctionNode) !NYAC {
        return error.Error;
    }

    pub fn handle_binary(self: *Compiler, node: *ast.BinaryNode) !Register {
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
            else => return error.UnsupportedBinaryOp
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

    pub fn handle_constant(self: *Compiler, root: *ast.ConstantNode) !Register {
        self.count += 1;
        const dest = self.count;
        const nyi = NYAC {
            .instruction = .Constant,
            .op1_addr = @intCast(root.value),
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
        const line = switch (self.root) {
            .Identifier => |id| id.location.?.line,
            .Declaration => |decl| decl.location.?.line,
            .Assignment => |as| as.location.?.line,
            .Function => |fun| fun.location.?.line,
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

    pub fn compile_expr(self: *Compiler, node: *ast.Node) !Register {
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
        });

        var tmp = std.fmt.allocPrint(self.alloc, "{}", .{inst.return_addr});
        try writer.appendSlice(self.alloc, ", ");
        try writer.append(self.alloc, tmp);

        tmp = std.fmt.allocPrint(self.alloc, "{}", .{inst.op1_addr});
        try writer.appendSlice(self.alloc, ", ");
        try writer.append(self.alloc, inst.op1_addr);

        if(inst.op2_addr != Unused) {
            tmp = std.fmt.allocPrint(self.alloc, "{}", .{inst.op2_addr});
            try writer.appendSlice(self.alloc, ", ");
            try writer.append(self.alloc, inst.op2_addr); 
        }

        try writer.append(self.alloc, '\n');
        self.alloc.free(tmp);
    }
};
