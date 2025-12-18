const std = @import("std");
const nya = @import("3ac.zig");

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
    const num_colors = 28; // t0-t6 (7) + s0-s11 (12) + a0-a7 (8) = 27 usable registers

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

    const Op = enum { add, sub, li, la, beq, label, call, mv, ret };
};

fn lower_to_riscv(
    alloc: std.mem.Allocator,
    nyac: []const nya.NYAC,
) !std.ArrayList(RiscVInst) {
    var arg_count: usize = 0;
    var out = std.ArrayList(RiscVInst).empty;
    var current_function: ?[]const u8 = null;

    for (nyac) |inst| {
        switch (inst.instruction) {
            .Add => {
                try out.append(alloc, .{
                    .op = .add,
                    .rd = inst.return_addr,
                    .rs1 = inst.op1.Register,
                    .rs2 = inst.op2.Register,
                });
            },
            .Constant => {
                if (inst.op1 == .Value) {
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
            .Label => {
                // Track if this is a function label
                if (inst.op1 == .Label) {
                    const label = inst.op1.Label;
                    // Function labels don't start with L (which are loop/if labels)
                    if (label.len > 0 and label[0] != 'L') {
                        current_function = label;
                    }
                }
                try out.append(alloc, .{
                    .op = .label,
                    .label = inst.op1.Label,
                });
            },
            .Call => {
                arg_count = 0;
                try out.append(alloc, .{
                    .op = .call,
                    .label = inst.op1.Label,
                    .rd = inst.return_addr,
                });
            },
            .PushArg => {
                try out.append(alloc, .{
                    .op = .mv,
                    .rd = arg_count,
                    .rs1 = inst.op1.Register,
                });
                arg_count += 1;
            },
            .Return => {
                if (inst.op1 == .Register and inst.op1.Register != nya.Unused) {
                    try out.append(alloc, .{
                        .op = .mv,
                        .rd = 0,
                        .rs1 = inst.op1.Register,
                    });
                }
                // Emit ret for all functions
                // Main will have its exit syscall added at the very end
                const is_main = if (current_function) |func|
                    std.mem.eql(u8, func, "main")
                else
                    false;

                if (!is_main) {
                    try out.append(alloc, .{
                        .op = .ret,
                    });
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
    for (riscv.items) |inst| {
        var line_buf: [256]u8 = undefined;
        const line = switch (inst.op) {
            .add => try std.fmt.bufPrint(&line_buf, "    add t{d}, t{d}, t{d}\n", .{ inst.rd, inst.rs1, inst.rs2 }),
            .sub => try std.fmt.bufPrint(&line_buf, "    sub t{d}, t{d}, t{d}\n", .{ inst.rd, inst.rs1, inst.rs2 }),
            .li => try std.fmt.bufPrint(&line_buf, "    li t{d}, {d}\n", .{ inst.rd, inst.imm }),
            .la => blk: {
                const str_label = try std.fmt.bufPrint(&line_buf, "    la t{d}, .str{d}\n", .{ inst.rd, str_index });
                str_index += 1;
                break :blk str_label;
            },
            .beq => try std.fmt.bufPrint(&line_buf, "    beq t{d}, x{d}, {s}\n", .{ inst.rs1, inst.rs2, inst.label }),
            .label => try std.fmt.bufPrint(&line_buf, "{s}:\n", .{inst.label}),
            .mv => blk: {
                const rd_name = if (inst.rd < 8)
                    try std.fmt.bufPrint(&line_buf, "a{d}", .{inst.rd})
                else
                    try std.fmt.bufPrint(&line_buf, "t{d}", .{inst.rd});

                var rs_buf: [16]u8 = undefined;
                const rs_name = try std.fmt.bufPrint(&rs_buf, "t{d}", .{inst.rs1});

                var final_buf: [256]u8 = undefined;
                break :blk try std.fmt.bufPrint(&final_buf, "    mv {s}, {s}\n", .{ rd_name, rs_name });
            },
            .call => try std.fmt.bufPrint(&line_buf, "    call {s}\n", .{inst.label}),
            .ret => try std.fmt.bufPrint(&line_buf, "    ret\n", .{}),
        };
        try asm_text.appendSlice(alloc, line);
    }

    // Add exit code for main
    try asm_text.appendSlice(alloc,
        \\    # Exit
        \\    li a7, 93
        \\    li a0, 0
        \\    ecall
        \\
    );

    try file.writeAll(asm_text.items);
    std.debug.print("Assembly written to {s}\n", .{file_name});
}
