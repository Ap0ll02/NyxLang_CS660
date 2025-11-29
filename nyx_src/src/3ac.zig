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
    Label, Goto, If, Jump, JumpFalse,
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

pub const NYACOperand = union(enum) {
    Label: []const u8,
    Value: Value,
    Register: u32,
};

pub const NYAC = struct { 
    return_addr: u32, instruction: Instruction, 
    op1: NYACOperand, op2_addr: NYACOperand
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
    label_counter: usize,
    fp_offset: usize,
    cur_line: usize,
    last_line: usize,
    
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
            .cur_line = 0,
            .last_line = 0,
            .label_counter = 0,
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
        self.cur_line = 0;
        switch (self.root.*) {
            .BlockItems => |bi| {
                for (bi.items) |b| {
                    std.debug.print("Processing item: {s}\n", .{@tagName(b.*)});
                    try check_write(self);
                    self.root = b;
                    _ = try self.compile_node();
                }
            },
            else => {}
        }

        self.root = old_root;

        // try to open file_name to emit 3AC, if it doesn't exist, then create it
        const file_name = "a.nyac";
        const file = try std.fs.cwd().createFile(file_name, .{
            .truncate = true,
            .exclusive = false,
        });

        defer file.close();
        if(ast.debug_mode) std.debug.print("{s}", .{self.file_text.items});
        try file.writeAll(self.file_text.items);

        return self.nyac_list;
    }

    pub fn compile_node(self: *Compiler) anyerror!Register {

        std.debug.print("Compiling node: {s}\n", .{@tagName(self.root.*)});

        // Note: All of the diagnostic source prints need to be moved
        // to file writing, we will write the source line and then
        // write the associated 3ac with it below.
        return switch (self.root.*) {
            .Binary => |node| try self.handle_binary(node),
            .Identifier => |node| try self.handle_ident(node),
            .Constant => |node| try self.handle_constant(node),
            .Function => |node| try self.handle_function(node),
            .FunctionCall => |node| try self.handle_func_call(node),
            // .ArgumentList => |node| try self.handle_some_node(node),
            // .InitializerList => |node| try self.handle_some_node(node),
            // .ParameterList => |node| try self.handle_some_node(node),
            // .NameParameterNode => |node| try self.handle_some_node(node),
            .TranslationUnitList => |node| try self.handle_translation_units(node),
            .BlockItems => |node| try self.handle_block(node),
            // .Unary => |node| try self.handle_some_node(node),
            // .PostFix => |node| try self.handle_some_node(node),
            // .PreFix => |node| try self.handle_some_node(node),
            // .ConditionalExpression => |node| try self.handle_some_node(node),
            // .Comp => |node| try self.handle_some_node(node),
            // .Cast => |node| try self.handle_some_node(node),
            // .AssOp => |node| try self.handle_some_node(node),
            .Declaration => |node| try self.handle_decl(node),
            .Assignment => |node| try self.handle_assignment(node),
            // .WhileStmt => |node| try self.handle_some_node(node),
            // .IfStmt => |node| try self.handle_if(node),
            // .ReturnStmt => |node| try self.handle_some_node(node),
            // .String => |node| try self.handle_some_node(node),
            // .Char => |node| try self.handle_some_node(node),
            // .Int => |node| try self.handle_some_node(node),
            // .Float => |node| try self.handle_some_node(node),
            .Type => |_| return Unused,
            .ExpressionStmt => |node| try self.handle_expr_stmt(node),
            .Pointer => |node| try self.handle_pointer(node),
            .IdPointer => |node| try self.handle_id_pointer(node),
            // .Array => |node| try self.handle_array(node),
            // .StructDeclaration => |node| try self.handle_some_node(node),
            // .StructDeclarationList => |node| try self.handle_some_node(node),
            // .StructDeclaratorList => |node| try self.handle_some_node(node),
            // .StructSpecifier => |node| try self.handle_some_node(node),
            // .StructOrUnion => |node| try self.handle_some_node(node),
            else => return Unused,
        };

    }
    pub fn handle_ident(self: *Compiler, root: *ast.IdentifierNode) anyerror!Register {
        self.cur_line = if(root.location) |loc| loc.line else 0;
        if(ast.debug_mode) std.debug.print("Identifier ({s}) Node Emitted\n", .{root.name});
        return self.var_registers.get(root.name) orelse return CompileError.UndefinedVariable;
    }

    pub fn handle_decl(self: *Compiler, root: *ast.DeclarationNode) anyerror!Register {
        self.cur_line = if(root.location) |loc| loc.line else 0;
        var name: []const u8 = "";
        if (root.assign_node) |ar| {
            name = ar.Assignment.declarator.Identifier.name;
        } else return Unused;
        // allocate register slot
        self.count += 1;
        const dest = self.count;

        // track the variable and register
        try self.var_registers.put(name, dest);
        if (ast.debug_mode) std.debug.print("Identifier \"{s}\" assigned to register {d}\n", .{name, dest});

        const nyac = NYAC {
            .instruction = .ImbueRegister,
            .return_addr = dest,
            .op1 = NYACOperand{.Register = Unused},
            .op2_addr = NYACOperand{.Register = Unused},
        };
        try self.nyac_list.append(self.alloc, nyac);
        try self.emit(nyac);
        if(root.assign_node) |an| {
            _ = try self.compile_expr(an);
        }
        if(ast.debug_mode) std.debug.print("Decl Node Emitted\n", .{});
        return dest;
    }
    
    pub fn handle_pointer(self: *Compiler, root: *ast.PointerNode) anyerror!Register {
        self.cur_line = if(root.location) |loc| loc.line else 0;
        var pointee_reg = Unused;
        if(root.pointee) |pte| {
            pointee_reg = try self.compile_expr(pte);
        }

        self.count += 1;
        const dest = self.count;
        const nyac = NYAC {
            .instruction = .LoadRegister,
            .return_addr = Unused,
            .op1 = .{ .Register = pointee_reg },
            .op2_addr = .{ .Register = Unused },
        };
        try self.nyac_list.append(self.alloc, nyac);
        try self.emit(nyac);
        if (ast.debug_mode) std.debug.print("Pointer Node Emitted, depth {d}\n", .{root.depth});
        return dest;
    }

    pub fn handle_id_pointer(self: *Compiler, node: *ast.IdPointerNode) anyerror!Register {
        self.cur_line = if (node.location) |loc| loc.line else 0;

        // Compile the pointer
        const ptr_reg = try self.compile_expr(node.pointer);

        // Compile the identifier (could just be variable lookup)
        // const id_name = switch (node.identifier.*) {
        //     .Identifier => |id| id.name,
        //     else => return CompileError.UnsupportedNode,
        // };
        // const id_reg = self.var_registers.get(id_name) orelse return CompileError.UndefinedVariable;

        // Allocate a register for the loaded value
        self.count += 1;
        const dest = self.count;

        const nyac = NYAC{
            .instruction = .LoadRegister,
            .return_addr = dest,
            .op1 = NYACOperand{.Register = ptr_reg},
            .op2_addr = NYACOperand{.Register = Unused},
        };

        try self.nyac_list.append(self.alloc, nyac);
        try self.emit(nyac);

        if (ast.debug_mode) std.debug.print("IdPointer Node Emitted\n", .{});
        return dest;
    }

    pub fn handle_assignment(self: *Compiler, root: *ast.AssignmentNode) anyerror!Register {
        self.cur_line = if(root.location) |loc| loc.line else 0;
        const var_name = root.declarator.Identifier.name;
        const lhs_reg = self.var_registers.get(var_name) orelse return CompileError.UndefinedVariable;
        const rhs_reg = try self.compile_expr(root.initializer.?);

        // TODO different NYAC structs probably need to be created here for StoreByte, StoreDouble, depending on type
        const nyac = NYAC {
            .instruction = .StoreRegister,
            .return_addr = lhs_reg,
            .op1 = NYACOperand{.Register = rhs_reg},
            .op2_addr = NYACOperand{.Register = Unused},
        };

        try self.nyac_list.append(self.alloc, nyac);
        try self.emit(nyac);

        if(ast.debug_mode) std.debug.print("Assign Node Emitted\n", .{});
        return lhs_reg;
    }

    pub fn handle_function(self: *Compiler, root: *ast.FunctionNode) anyerror!Register {
        self.cur_line = if(root.location) |loc| loc.line else 0;
        const func_ident_node = root.nameParam.NameParameterNode.name.Identifier;
        
        const nyac = NYAC {
            .instruction = .Label,
            .return_addr = Unused,
            .op1 = NYACOperand{.Label = func_ident_node.name},
            .op2_addr = .{ .Register = Unused }
        };

        try self.nyac_list.append(self.alloc, nyac);
        try self.emit(nyac);
        _ = try self.compile_expr(root.body);

        return Unused;
    }

    pub fn handle_func_call(self: *Compiler, root: *ast.FunctionCallNode) !Register {
        self.cur_line = root.location.?.line;
        const func_ident_node = root.name.Identifier;

        const nyac = NYAC {
            .instruction = .Goto,
            .return_addr = Unused,
            .op1 = NYACOperand{.Label = func_ident_node.name},
            .op2_addr = .{ .Register = Unused }
        };

        try self.nyac_list.append(self.alloc, nyac);
        try self.emit(nyac);

        return Unused;
    }

    pub fn handle_translation_units(self: *Compiler, root: *ast.TranslationUnitListNode) !Register {
        self.cur_line = if(root.location) |loc| loc.line else 0;
        for (root.translationUnits) |unit| {
            _ = try self.compile_expr(unit);
        } 

        return Unused;
    }

    pub fn handle_binary(self: *Compiler, node: *ast.BinaryNode) anyerror!Register {
        self.cur_line = if(node.location) |loc| loc.line else 0;
        // Compiling the left and right nodes into registers
        self.root = node.lhs;
        const left_reg = try self.compile_node();

        self.root = node.rhs;
        const right_reg = try self.compile_node();

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

        const nyac = NYAC {
            .instruction = instr,
            .return_addr = dest,
            .op1 = NYACOperand{.Register = left_reg},
            .op2_addr = .{ .Register = right_reg }
        };

        // Append to NYAC list and emit to file
        try self.nyac_list.append(self.alloc, nyac);
        try self.emit(nyac);

        if(ast.debug_mode) std.debug.print("Binary Node Emitted\n", .{});
        return dest;
    }

    pub fn handle_constant(self: *Compiler, root: *ast.ConstantNode) anyerror!Register {
        self.cur_line = if(root.location) |loc| loc.line else 0;
        self.count += 1;
        const dest = self.count;
        const val = try std.fmt.parseInt(i32, root.value, 10);
        const nyac = NYAC {
            .instruction = .Constant,
            .op1 = NYACOperand{.Register = @intCast(val)},
            .return_addr = dest,
            .op2_addr= NYACOperand{.Register = Unused},
        };

        // Append to list
        try self.nyac_list.append(self.alloc, nyac);
        // Emit IR to file
        try self.emit(nyac);

        if(ast.debug_mode) std.debug.print("Constant Node Emitted\n", .{});
        return dest;
    }

    pub fn handle_if(self: *Compiler, node: *ast.IfNode) anyerror!Register {
        self.cur_line = if(node.location) |nl| nl.line else 0;
        const cond_reg = self.compile_expr(node.cond);

        const else_label = new_label();
        const end_label = new_label();

        // Jump False
        try self.emit_jump_false(cond_reg, else_label);

        // THen branch
        _ = try self.compile_expr(node.if_branch);

        try self.emit_jump(end_label);
        try self.emit_label(else_label);

        if(node.el_branch) |eb| {
            _ = try self.compile_expr(eb);
        }

        self.emit_label(end_label);
        return Unused;
    }

    pub fn emit_jump_false(self: *Compiler, cond: Register, label: usize) !void {
        if(ast.debug_mode) std.debug.print("Label: {d} to emit\n", .{label});
        const nyac = NYAC {
            .instruction = .JumpFalse,
            .return_addr = Unused,
            .op1 = .{ .Register = cond },
            .op2_addr = .{ .Label = "TBA" }
        };
        try self.nyac_list.append(self.alloc, nyac);
        try self.emit(nyac);
    }

    pub fn emit_jump(self: *Compiler, label: usize) !void {
        if(ast.debug_mode) std.debug.print("Label: {d} to emit\n", .{label});
        const nyac = NYAC {
            .instruction = .Jump,
            .return_addr = Unused,
            .op1 = .{ .Label = "TBA" },
            .op2_addr = .{ .Register = Unused }
        };
        try self.nyac_list.append(self.alloc, nyac);
        try self.emit(nyac);
    }

    pub fn emit_label(self: *Compiler, label: usize) !void {
        if(ast.debug_mode) std.debug.print("Label: {d} to emit\n", .{label});
        const nyac = NYAC {
            .instruction = .Label,
            .return_addr = Unused,
            .op1 = .{ .Label = "TBA" },
            .op2_addr = .{ .Register = Unused }
        };
        try self.nyac_list.append(self.alloc, nyac);
        try self.emit(nyac);
    }

    pub fn handle_expr_stmt(self: *Compiler, root: *ast.ExpressionStmtNode) anyerror!Register {
        self.cur_line = if(root.location) |loc| loc.line else 0;
        if (root.expr) |re| {
            _ = try self.compile_expr(re);
        }
        return Unused;
    }

    pub fn handle_block(self: *Compiler, root: *ast.BlockItemsNode) anyerror!Register {
        self.cur_line = if(root.location) |loc| loc.line else 0;
        for (root.items) |bi| {
            _ = try self.compile_expr(bi);
        }
        return Unused;
    }

    pub fn check_write(self: *Compiler) !void {
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
        if(line == 0) return;
        if (ast.debug_mode) {
            try self.file_text.appendSlice(self.alloc, m.diagnostic_source(line));
            try self.file_text.append(self.alloc, '\n');
        }
    }

    pub fn compile_expr(self: *Compiler, node: *ast.Node) anyerror!Register {
        const original = self.root;
        self.root = node;
        const reg = try self.compile_node();
        self.root = original;
        return reg;
    }

    pub fn emit(self: *Compiler, inst: NYAC) !void {
        const writer = &self.file_text;
        if(self.cur_line != 0 and self.last_line != self.cur_line) {
            const src = m.diagnostic_source(self.cur_line);
            try writer.appendSlice(self.alloc, src);
            try writer.append(self.alloc, '\n');
            self.last_line = self.cur_line;
        }
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
            .ImbueFrame => "IMBUE_FRAME",
            .ImbueRegister => "IMBUE_REGISTER",
            .ImbueLabel => "IMBUE_LABEL",
            .StoreRegister => "SR", // TODO should this and LOAD_REGISTER be replaced w/ the LB, SB, etc?
            .LoadRegister => "LR",
            else => "INVALID"
        });

        // should be using appendSlide for strings
        var tmp = try std.fmt.allocPrint(self.alloc, " {d}", .{inst.return_addr});
        try writer.appendSlice(self.alloc, tmp);
        self.alloc.free(tmp);

        switch (inst.op1) {
            .Register => |register| {
                tmp = try std.fmt.allocPrint(self.alloc, ", (register: {d})", .{register});
            },
            .Label => |label| {
                tmp = try std.fmt.allocPrint(self.alloc, ", (label: \"{s}\")", .{label});
            },
            .Value => |label| {
                // TODO is there a better way to do this? No I don't think it is that bad
                switch (label) {
                    .Number => |num| {
                        tmp = try std.fmt.allocPrint(self.alloc, ", (value: {d})", .{num});
                    },
                    .String => |str| {
                        tmp = try std.fmt.allocPrint(self.alloc, ", (value: \"{s}\")", .{str});
                    },
                    .Char => |character| {
                        tmp = try std.fmt.allocPrint(self.alloc, ", (value: {c})", .{character});
                    },
                    .Void => |_| {
                        tmp = try std.fmt.allocPrint(self.alloc, ", (value: void)", .{});
                    },
                    // else => |c| {
                    //     tmp = try std.fmt.allocPrint(self.alloc, ", (value: {any})", .{c});
                    // }
                }
            }
        }
        try writer.appendSlice(self.alloc, tmp);
        self.alloc.free(tmp);

        if(inst.op2_addr.Register != Unused) {
            tmp = try std.fmt.allocPrint(self.alloc, ", {}", .{inst.op2_addr});
            try writer.appendSlice(self.alloc, tmp);
            self.alloc.free(tmp);
        }
        try writer.append(self.alloc, '\n');
    }
    pub fn new_label(self: *Compiler) usize {
        const id = self.label_counter;
        self.label_counter += 1;
        return id;
    }

};
