const std = @import("std");
const nya = @import("3ac.zig");

// Map color (0-18) to actual RISC-V register name
// Colors 0-6 -> t0-t6 and
// Colors 7-18 -> s0-s11
fn color_to_reg_name(color: usize, buf: []u8) ![]const u8 {
    if (color >= 100 and color < 108) {
        // Argument registers
        return try std.fmt.bufPrint(buf, "a{d}", .{color - 100});
    } else if (color < 7) {
        // t0-t6
        return try std.fmt.bufPrint(buf, "t{d}", .{color});
    } else if (color < 19) {
        // s0-s11
        return try std.fmt.bufPrint(buf, "s{d}", .{color - 7});
    } else {
        return error.InvalidRegisterColor;
    }
}

pub fn assemble(
    alloc: std.mem.Allocator,
    nyac: []const nya.NYAC,
) !void {
    // 1. Allocate registers
    const allocated = try allocate_registers(alloc, nyac);
    defer alloc.free(allocated);

    // 2. Lower to RISC-V instructions
    var riscv = try lower_to_riscv(alloc, allocated);
    defer riscv.deinit(alloc);

    // 3. Emit assembly
    try emit_assembly(alloc, riscv);
}

pub fn assemble_file(alloc: std.mem.Allocator, nyac: []const u8) !void {
    _ = try alloc.alloc(u8, 8);
    _ = try std.fs.cwd().openFile(nyac, .{});
    return;
}

fn allocate_registers(
    alloc: std.mem.Allocator,
    nyac: []const nya.NYAC,
) ![]nya.NYAC {
    const temp_count = find_max_temp(nyac) + 1;

    // 1. Liveness analysis
    const live_list = try analyze_lifetimes(alloc, nyac, temp_count);
    defer {
        for (live_list) |*bs| bs.deinit();
        alloc.free(live_list);
    }

    // 2. Build interference graph
    const graph = try build_interference_graph(alloc, nyac, live_list, temp_count);
    defer free_graph(alloc, graph);

    // 3. Graph coloring
    const coloring = try color_graph(alloc, graph);
    defer alloc.free(coloring);

    // 4. Rewrite NYAC with physical registers
    return try rewrite_registers(alloc, nyac, coloring);
}

fn analyze_lifetimes(
    alloc: std.mem.Allocator,
    nyac: []const nya.NYAC,
    temp_count: usize,
) ![]std.bit_set.DynamicBitSet {
    var live_now = try std.bit_set.DynamicBitSet.initEmpty(alloc, temp_count);
    defer live_now.deinit();

    var live_list = try alloc.alloc(std.bit_set.DynamicBitSet, nyac.len);
    errdefer {
        for (live_list) |*bs| bs.deinit();
        alloc.free(live_list);
    }

    var i: usize = nyac.len;
    while (i > 0) {
        i -= 1;
        const inst = nyac[i];

        // Snapshot live-after for this instruction
        live_list[i] = try live_now.clone(alloc);

        // Defs kill liveness
        if (inst.return_addr != nya.Unused) {
            live_now.unset(inst.return_addr);
        }

        // Uses add liveness
        if (inst.op1 == .Register) {
            live_now.set(inst.op1.Register);
        }
        if (inst.op2 == .Register) {
            live_now.set(inst.op2.Register);
        }
    }

    return live_list;
}

fn build_interference_graph(
    alloc: std.mem.Allocator,
    nyac: []const nya.NYAC,
    live_list: []const std.bit_set.DynamicBitSet,
    temp_count: usize,
) ![]std.ArrayList(usize) {
    // Adjacency list representation
    var graph = try alloc.alloc(std.ArrayList(usize), temp_count);
    for (graph) |*adj| {
        adj.* = std.ArrayList(usize).empty;
    }

    errdefer {
        for (graph) |*adj| adj.deinit(alloc);
        alloc.free(graph);
    }

    // For each instruction, the defined register interferes with all live registers
    for (nyac, 0..) |inst, i| {
        if (inst.return_addr == nya.Unused) continue;

        const def = inst.return_addr;
        var iter = live_list[i].iterator(.{});

        while (iter.next()) |live_reg| {
            if (live_reg != def) {
                // Add edge: def <-> live_reg
                try add_edge(&graph[def], live_reg, alloc);
                try add_edge(&graph[live_reg], def, alloc);
            }
        }
    }

    return graph;
}

fn add_edge(adj_list: *std.ArrayList(usize), neighbor: usize, alloc: std.mem.Allocator) !void {
    // Avoid duplicates
    for (adj_list.items) |n| {
        if (n == neighbor) return;
    }
    try adj_list.append(alloc, neighbor);
}

fn color_graph(
    alloc: std.mem.Allocator,
    graph: []const std.ArrayList(usize),
) ![]usize {
    // RISCV has 19 usable registrs
    // t0-t6 and s0-s11
    // a0-a7 are reserved for arguments
    const num_colors = 19;

    var coloring = try alloc.alloc(usize, graph.len);
    @memset(coloring, std.math.maxInt(usize)); // uncolored

    // Simple greedy coloring
    for (graph, 0..) |neighbors, node| {
        var used_colors = try std.bit_set.DynamicBitSet.initEmpty(alloc, num_colors);
        defer used_colors.deinit();

        // Mark colors used by neighbors
        for (neighbors.items) |neighbor| {
            if (coloring[neighbor] != std.math.maxInt(usize)) {
                used_colors.set(coloring[neighbor]);
            }
        }

        // Find first available color
        var color: usize = 0;
        while (color < num_colors) : (color += 1) {
            if (!used_colors.isSet(color)) {
                coloring[node] = color;
                break;
            }
        }

        // If we run out of colors, we'd need to spill (not implemented)
        if (coloring[node] == std.math.maxInt(usize)) {
            return error.RegisterSpillNeeded;
        }
    }

    return coloring;
}

fn free_graph(alloc: std.mem.Allocator, graph: []std.ArrayList(usize)) void {
    for (graph) |*adj| adj.deinit(alloc);
    alloc.free(graph);
}

fn rewrite_registers(
    alloc: std.mem.Allocator,
    nyac: []const nya.NYAC,
    coloring: []const usize,
) ![]nya.NYAC {
    var result = try alloc.alloc(nya.NYAC, nyac.len);

    for (nyac, 0..) |inst, i| {
        result[i] = inst;

        // Map virtual register to physical register
        if (inst.return_addr != nya.Unused) {
            result[i].return_addr = @intCast(coloring[inst.return_addr]);
        }

        if (inst.op1 == .Register) {
            result[i].op1 = .{ .Register = @intCast(coloring[inst.op1.Register]) };
        }

        if (inst.op2 == .Register) {
            result[i].op2 = .{ .Register = @intCast(coloring[inst.op2.Register]) };
        }
    }

    return result;
}

fn find_max_temp(nyac: []const nya.NYAC) usize {
    var max: usize = 0;

    for (nyac) |inst| {
        if (inst.return_addr != nya.Unused and inst.return_addr > max) {
            max = inst.return_addr;
        }
        if (inst.op1 == .Register and inst.op1.Register > max) {
            max = inst.op1.Register;
        }
        if (inst.op2 == .Register and inst.op2.Register > max) {
            max = inst.op2.Register;
        }
    }

    return max;
}

const RiscVInst = struct {
    op: Op,
    rd: usize = 0,
    rs1: usize = 0,
    rs2: usize = 0,
    imm: i32 = 0,
    label: []const u8 = "",

    const Op = enum { add, sub, mul, div, li, la, beq, label, call, mv, ret, sw, lw, addi, prologue, epilogue, j, slt };
};

fn lower_to_riscv(
    alloc: std.mem.Allocator,
    nyac: []const nya.NYAC,
) !std.ArrayList(RiscVInst) {
    var arg_count: usize = 0;
    var out = std.ArrayList(RiscVInst).empty;
    var current_function: ?[]const u8 = null;
    var stack_offset: i32 = 0;
    var reg_to_stack = std.AutoHashMap(usize, i32).init(alloc);
    defer reg_to_stack.deinit();
    var const_regs = std.AutoHashMap(usize, void).init(alloc);
    defer const_regs.deinit();

    for (nyac) |inst| {
        switch (inst.instruction) {
            .Add => {
                // Handle both register-register and register-immediate adds
                if (inst.op2 == .Register) {
                    try out.append(alloc, .{
                        .op = .add,
                        .rd = inst.return_addr,
                        .rs1 = inst.op1.Register,
                        .rs2 = inst.op2.Register,
                    });
                } else if (inst.op2 == .Value and inst.op2.Value == .Number) {
                    try out.append(alloc, .{
                        .op = .addi,
                        .rd = inst.return_addr,
                        .rs1 = inst.op1.Register,
                        .imm = inst.op2.Value.Number,
                    });
                }
            },
            .Multiply => {
                // Handle both register-register and register-immediate adds
                if (inst.op2 == .Register) {
                    try out.append(alloc, .{
                        .op = .mul,
                        .rd = inst.return_addr,
                        .rs1 = inst.op1.Register,
                        .rs2 = inst.op2.Register,
                    });
                } else if (inst.op2 == .Value and inst.op2.Value == .Number) {
                    const temp_reg = 31;
                    try out.append(alloc, .{
                        .op = .li,
                        .rd = inst.return_addr,
                        .rs1 = inst.op1.Register,
                        .imm = inst.op2.Value.Number,
                    });
                    try out.append(alloc, .{
                        .op = .mul,
                        .rd = inst.return_addr,
                        .rs1 = inst.op1.Register,
                        .rs2 = temp_reg,
                    });
                }
            },
            .Divide => {
                // Handle both register-register and register-immediate adds
                if (inst.op2 == .Register) {
                    try out.append(alloc, .{
                        .op = .div,
                        .rd = inst.return_addr,
                        .rs1 = inst.op1.Register,
                        .rs2 = inst.op2.Register,
                    });
                } else if (inst.op2 == .Value and inst.op2.Value == .Number) {
                    const temp_reg = 31;
                    try out.append(alloc, .{
                        .op = .li,
                        .rd = inst.return_addr,
                        .rs1 = inst.op1.Register,
                        .imm = inst.op2.Value.Number,
                    });
                    try out.append(alloc, .{
                        .op = .div,
                        .rd = inst.return_addr,
                        .rs1 = inst.op1.Register,
                        .rs2 = temp_reg
                    });
                }
            },
            .Subtract => {
                // Handle register-register subtraction
                if (inst.op2 == .Register) {
                    try out.append(alloc, .{
                        .op = .sub,
                        .rd = inst.return_addr,
                        .rs1 = inst.op1.Register,
                        .rs2 = inst.op2.Register,
                    });
                } else if (inst.op2 == .Value and inst.op2.Value == .Number) {
                    // Subtract with immediate by add negative value
                    try out.append(alloc, .{
                        .op = .addi,
                        .rd = inst.return_addr,
                        .rs1 = inst.op1.Register,
                        .imm = -inst.op2.Value.Number,
                    });
                }
            },
            .LessThan => {
                try out.append(alloc, .{
                    .op = .slt,
                    .rd = inst.return_addr,
                    .rs1 = inst.op1.Register,
                    .rs2 = inst.op2.Register,
                });
            },
            .GreaterThan => {
                // GT: swap operands for SLT
                try out.append(alloc, .{
                    .op = .slt,
                    .rd = inst.return_addr,
                    .rs1 = inst.op2.Register,
                    .rs2 = inst.op1.Register,
                });
            },
            .Constant => {
                if (inst.op1 == .Value) {
                    try const_regs.put(inst.return_addr, {});

                    switch (inst.op1.Value) {
                        .String => |str| {
                            try out.append(alloc, .{
                                .op = .la,
                                .rd = inst.return_addr,
                                .label = str,
                            });
                        },
                        .Number => |num| {
                            try out.append(alloc, .{ .op = .li, .rd = inst.return_addr, .imm = num });
                        },
                        .Char => |ch| {
                            try out.append(alloc, .{
                                .op = .li,
                                .rd = inst.return_addr,
                                .imm = @intCast(ch),
                            });
                        },
                        .Float => |flt| {
                            try out.append(alloc, .{
                                .op = .li,
                                .rd = inst.return_addr,
                                .imm = @intFromFloat(flt),
                            });
                        },
                        .Void => {},
                    }
                }
            },
            .JumpFalse => {
                try out.append(alloc, .{
                    .op = .beq,
                    .rs1 = inst.op1.Register,
                    .rs2 = 0,
                    .label = inst.op2.Label,
                });
            },
            .Jump => {
                try out.append(alloc, .{
                    .op = .j,
                    .label = inst.op1.Label,
                });
            },
            .Label => {
                // Track if this is a function label
                if (inst.op1 == .Label) {
                    const label = inst.op1.Label;
                    // Function labels don't start with L (which are loop/if labels)
                    if (label.len > 0 and label[0] != 'L') {
                        current_function = label;
                        stack_offset = 0;
                        reg_to_stack.clearRetainingCapacity();
                    }
                }
                try out.append(alloc, .{
                    .op = .label,
                    .label = inst.op1.Label,
                });
                // Add prologue for non-main functions
                if (inst.op1 == .Label) {
                    const label = inst.op1.Label;
                    if (label.len > 0 and label[0] != 'L') {
                        try out.append(alloc, .{ .op = .prologue });
                    }
                }
            },
            .Call => {
                arg_count = 0;

                try out.append(alloc, .{
                    .op = .call,
                    .label = inst.op1.Label,
                    .rd = inst.return_addr,
                });

                // Move return value from a0 to destination register
                if (inst.return_addr != nya.Unused) {
                    try out.append(alloc, .{
                        .op = .mv,
                        .rd = inst.return_addr,
                        .rs1 = 0, // a0 (mapped to register 0 in our system)
                    });
                }
            },
            .PushArg => {
                // If the register holds a stack address, we need to load the value
                if (inst.op1 == .Register) {
                    const reg = inst.op1.Register;
                    // Use 100+ for argument registers to distinguish from allocated registers
                    const arg_reg = 100 + arg_count;
                    // Check if this register was created by IMBUE_REGISTER
                    // but don't dereference constants like string addresses
                    if (reg_to_stack.contains(reg) and !const_regs.contains(reg)) {
                        // This is a stack address, load the value first
                        try out.append(alloc, .{
                            .op = .lw,
                            .rd = arg_reg,
                            .rs1 = reg,
                            .imm = 0,
                        });
                    } else {
                        // This is a regular value or constant, just move it
                        try out.append(alloc, .{
                            .op = .mv,
                            .rd = arg_reg,
                            .rs1 = reg,
                        });
                    }
                }
                arg_count += 1;
            },
            .ImbueRegister => {
                // Allocate stack space for a variable/struct
                // op1 is the register itself and op2 contains the size
                const size = if (inst.op2 == .Value and inst.op2.Value == .Number)
                    inst.op2.Value.Number
                else
                    4; // default to 4 bytes

                // rd = sp + offset
                try out.append(alloc, .{
                    .op = .addi,
                    .rd = inst.return_addr,
                    .rs1 = 2, // sp register
                    .imm = stack_offset,
                });

                stack_offset += size;
                try reg_to_stack.put(inst.return_addr, stack_offset);
            },
            .StoreRegister => {
                // Store value from op2 to memory at address in op1
                const dest_addr = inst.op1.Register;
                const src = inst.op2.Register;

                // Check if source is a stack address that needs dereferencing
                if (reg_to_stack.contains(src)) {
                    // Source is a stack address, load the value first into a temp
                    // Use t6 as scratch register
                    const temp_reg: usize = 6;
                    try out.append(alloc, .{
                        .op = .lw,
                        .rd = temp_reg,
                        .rs1 = src,
                        .imm = 0,
                    });
                    // Now store that value to destination
                    try out.append(alloc, .{
                        .op = .sw,
                        .rs1 = temp_reg,
                        .rs2 = dest_addr,
                        .imm = 0,
                    });
                } else {
                    // Source is a value register, store it directly
                    try out.append(alloc, .{
                        .op = .sw,
                        .rs1 = src,
                        .rs2 = dest_addr,
                        .imm = 0,
                    });
                }
            },
            .LoadRegister => {
                // Load from memory at address in op1 to rd
                try out.append(alloc, .{
                    .op = .lw,
                    .rd = inst.return_addr,
                    .rs1 = inst.op1.Register, // address
                    .imm = 0,
                });
                _ = reg_to_stack.remove(inst.return_addr);
            },
            .Return => {
                if (inst.op1 == .Register and inst.op1.Register != nya.Unused) {
                    try out.append(alloc, .{
                        .op = .mv,
                        .rd = 0,
                        .rs1 = inst.op1.Register,
                    });
                }

                const is_main = if (current_function) |func|
                    std.mem.eql(u8, func, "main")
                else
                    false;

                if (!is_main) {
                    try out.append(alloc, .{ .op = .epilogue });
                    try out.append(alloc, .{ .op = .ret });
                }
            },
            else => {},
        }
    }

    return out;
}

fn emit_assembly(alloc: std.mem.Allocator, riscv: std.ArrayList(RiscVInst)) !void {
    const file_name = "a.s";
    const file = try std.fs.cwd().createFile(file_name, .{
        .truncate = true,
        .exclusive = false,
    });
    defer file.close();

    var asm_text = std.ArrayList(u8).empty;
    defer asm_text.deinit(alloc);

    // First pass: collect all string literals and function labels
    var strings = std.ArrayList([]const u8).empty;
    defer strings.deinit(alloc);

    var functions = std.ArrayList([]const u8).empty;
    defer functions.deinit(alloc);

    for (riscv.items) |inst| {
        if (inst.op == .la) {
            try strings.append(alloc, inst.label);
        }
        // Collect function labels (labels that don't start with L or '.' btw)
        if (inst.op == .label) {
            const label = inst.label;
            if (label.len > 0 and label[0] != 'L' and label[0] != '.') {
                try functions.append(alloc, label);
            }
        }
    }

    // Emit .data section if we have strings
    try asm_text.appendSlice(alloc, "# RISC-V Assembly Output\n");

    if (strings.items.len > 0) {
        try asm_text.appendSlice(alloc, "    .data\n");
        for (strings.items, 0..) |str, i| {
            // Strip quotes if they exist
            const clean_str = if (str.len >= 2 and str[0] == '"' and str[str.len - 1] == '"')
                str[1 .. str.len - 1]
            else
                str;

            var buf: [512]u8 = undefined;
            const data_line = try std.fmt.bufPrint(&buf, ".str{d}:\n    .string \"{s}\"\n", .{ i, clean_str });
            try asm_text.appendSlice(alloc, data_line);
        }
        try asm_text.appendSlice(alloc, "\n");
    }

    // Emit .text section
    try asm_text.appendSlice(alloc, "    .text\n");

    // Emit .globl for all functions
    for (functions.items) |func| {
        var buf: [128]u8 = undefined;
        const globl_line = try std.fmt.bufPrint(&buf, "    .globl {s}\n", .{func});
        try asm_text.appendSlice(alloc, globl_line);
    }
    try asm_text.appendSlice(alloc, "\n");

    var str_index: usize = 0;
    var max_stack: i32 = 0;

    // First pass: calculate maximum stack usage
    for (riscv.items) |inst| {
        if (inst.op == .addi and inst.rs1 == 2 and inst.imm > 0) {
            if (inst.imm > max_stack) {
                max_stack = inst.imm;
            }
        }
    }

    for (riscv.items) |inst| {
        var line_buf: [256]u8 = undefined;
        const line = switch (inst.op) {
            .add => blk: {
                var rd_buf: [16]u8 = undefined;
                var rs1_buf: [16]u8 = undefined;
                var rs2_buf: [16]u8 = undefined;
                const rd_name = try color_to_reg_name(inst.rd, &rd_buf);
                const rs1_name = try color_to_reg_name(inst.rs1, &rs1_buf);
                const rs2_name = try color_to_reg_name(inst.rs2, &rs2_buf);
                break :blk try std.fmt.bufPrint(&line_buf, "    add {s}, {s}, {s}\n", .{ rd_name, rs1_name, rs2_name });
            },
            .sub => blk: {
                var rd_buf: [16]u8 = undefined;
                var rs1_buf: [16]u8 = undefined;
                var rs2_buf: [16]u8 = undefined;
                const rd_name = try color_to_reg_name(inst.rd, &rd_buf);
                const rs1_name = try color_to_reg_name(inst.rs1, &rs1_buf);
                const rs2_name = try color_to_reg_name(inst.rs2, &rs2_buf);
                break :blk try std.fmt.bufPrint(&line_buf, "    sub {s}, {s}, {s}\n", .{ rd_name, rs1_name, rs2_name });
            },
            .mul => blk: {
                var rd_buf: [16]u8 = undefined;
                var rs1_buf: [16]u8 = undefined;
                var rs2_buf: [16]u8 = undefined;
                const rd_name = try color_to_reg_name(inst.rd, &rd_buf);
                const rs1_name = try color_to_reg_name(inst.rs1, &rs1_buf);
                const rs2_name = try color_to_reg_name(inst.rs2, &rs2_buf);
                break :blk try std.fmt.bufPrint(&line_buf, "    mul {s}, {s}, {s}\n", .{ rd_name, rs1_name, rs2_name });
            },
            .div => blk: {
                var rd_buf: [16]u8 = undefined;
                var rs1_buf: [16]u8 = undefined;
                var rs2_buf: [16]u8 = undefined;
                const rd_name = try color_to_reg_name(inst.rd, &rd_buf);
                const rs1_name = try color_to_reg_name(inst.rs1, &rs1_buf);
                const rs2_name = try color_to_reg_name(inst.rs2, &rs2_buf);
                break :blk try std.fmt.bufPrint(&line_buf, "    div {s}, {s}, {s}\n", .{ rd_name, rs1_name, rs2_name });
            },
            .slt => blk: {
                var rd_buf: [16]u8 = undefined;
                var rs1_buf: [16]u8 = undefined;
                var rs2_buf: [16]u8 = undefined;
                const rd_name = try color_to_reg_name(inst.rd, &rd_buf);
                const rs1_name = try color_to_reg_name(inst.rs1, &rs1_buf);
                const rs2_name = try color_to_reg_name(inst.rs2, &rs2_buf);
                break :blk try std.fmt.bufPrint(&line_buf, "    slt {s}, {s}, {s}\n", .{ rd_name, rs1_name, rs2_name });
            },
            .li => blk: {
                var reg_buf: [16]u8 = undefined;
                const reg_name = try color_to_reg_name(inst.rd, &reg_buf);
                break :blk try std.fmt.bufPrint(&line_buf, "    li {s}, {d}\n", .{ reg_name, inst.imm });
            },
            .addi => blk: {
                var rd_buf: [16]u8 = undefined;
                const rd_name = try color_to_reg_name(inst.rd, &rd_buf);
                if (inst.rs1 == 2) { // rs1 == 2 then its a  sp
                    break :blk try std.fmt.bufPrint(&line_buf, "    addi {s}, sp, {d}\n", .{ rd_name, inst.imm });
                } else {
                    var rs1_buf: [16]u8 = undefined;
                    const rs1_name = try color_to_reg_name(inst.rs1, &rs1_buf);
                    break :blk try std.fmt.bufPrint(&line_buf, "    addi {s}, {s}, {d}\n", .{ rd_name, rs1_name, inst.imm });
                }
            },
            .sw => blk: {
                var rs1_buf: [16]u8 = undefined;
                var rs2_buf: [16]u8 = undefined;
                const rs1_name = try color_to_reg_name(inst.rs1, &rs1_buf);
                const rs2_name = try color_to_reg_name(inst.rs2, &rs2_buf);
                break :blk try std.fmt.bufPrint(&line_buf, "    sw {s}, {d}({s})\n", .{ rs1_name, inst.imm, rs2_name });
            },
            .lw => blk: {
                var rd_buf: [16]u8 = undefined;
                var rs1_buf: [16]u8 = undefined;
                const rd_name = try color_to_reg_name(inst.rd, &rd_buf);
                const rs1_name = try color_to_reg_name(inst.rs1, &rs1_buf);
                break :blk try std.fmt.bufPrint(&line_buf, "    lw {s}, {d}({s})\n", .{ rd_name, inst.imm, rs1_name });
            },
            .prologue => blk: {
                if (max_stack > 0) {
                    // Align to 16 bytes
                    const aligned_stack = @divTrunc(((max_stack) + 15), 16) * 16;
                    break :blk try std.fmt.bufPrint(&line_buf, "    addi sp, sp, -{d}\n", .{aligned_stack});
                } else {
                    break :blk try std.fmt.bufPrint(&line_buf, "", .{});
                }
            },
            .epilogue => blk: {
                if (max_stack > 0) {
                    const aligned_stack = @divTrunc(((max_stack) + 15), 16) * 16;
                    break :blk try std.fmt.bufPrint(&line_buf, "    addi sp, sp, {d}\n", .{aligned_stack});
                } else {
                    break :blk try std.fmt.bufPrint(&line_buf, "", .{});
                }
            },
            .la => blk: {
                var rd_buf: [16]u8 = undefined;
                const rd_name = try color_to_reg_name(inst.rd, &rd_buf);
                const str_label = try std.fmt.bufPrint(&line_buf, "    la {s}, .str{d}\n", .{ rd_name, str_index });
                str_index += 1;
                break :blk str_label;
            },
            .beq => blk: {
                var rs1_buf: [16]u8 = undefined;
                const rs1_name = try color_to_reg_name(inst.rs1, &rs1_buf);
                break :blk try std.fmt.bufPrint(&line_buf, "    beq {s}, x{d}, {s}\n", .{ rs1_name, inst.rs2, inst.label });
            },
            .j => try std.fmt.bufPrint(&line_buf, "    j {s}\n", .{inst.label}),
            .label => try std.fmt.bufPrint(&line_buf, "{s}:\n", .{inst.label}),
            .mv => blk: {
                var rd_buf: [16]u8 = undefined;
                var rs_buf: [16]u8 = undefined;
                const rd_name = try color_to_reg_name(inst.rd, &rd_buf);
                const rs_name = try color_to_reg_name(inst.rs1, &rs_buf);
                break :blk try std.fmt.bufPrint(&line_buf, "    mv {s}, {s}\n", .{ rd_name, rs_name });
            },
            .call => blk: {
                // push all temporaries to stack TODO actually check which temporaries are needed
                try asm_text.appendSlice(alloc,
                    \\    addi sp, sp, -28
                    \\    sw t0, 0(sp)
                    \\    sw t1, 4(sp)
                    \\    sw t2, 8(sp)
                    \\    sw t3, 12(sp)
                    \\    sw t4, 16(sp)
                    \\    sw t5, 20(sp)
                    \\    sw t6, 24(sp)
                    \\
                );

                const call_asm = try std.fmt.bufPrint(&line_buf, "    call {s}\n", .{inst.label});
                try asm_text.appendSlice(alloc, call_asm);

                // pop all temporaries off stack
                try asm_text.appendSlice(alloc,
                    \\    lw t0, 0(sp)
                    \\    lw t1, 4(sp)
                    \\    lw t2, 8(sp)
                    \\    lw t3, 12(sp)
                    \\    lw t4, 16(sp)
                    \\    lw t5, 20(sp)
                    \\    lw t6, 24(sp)
                    \\    addi sp, sp, 28
                    \\
                );

                break :blk "";
            },
            .ret => try std.fmt.bufPrint(&line_buf, "    ret\n", .{}),
        };
        try asm_text.appendSlice(alloc, line);
    }

    // Add exit code for main
    try asm_text.appendSlice(alloc,
        \\    # flush stdout
        \\    li a0, 0
        \\    call fflush
        \\    # Exit
        \\    li a7, 93
        \\    li a0, 0
        \\    ecall
        \\
    );

    try file.writeAll(asm_text.items);
    std.debug.print("Assembly written to {s}\n", .{file_name});
}
