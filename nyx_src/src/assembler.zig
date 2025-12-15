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
    try emit_assembly(riscv);
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
        if (inst.op2 == .Register) {  // Fixed: was op2_addr
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
    
    const Op = enum {
        add,
        sub,
        li,
        beq,
        label,
    };
};

fn lower_to_riscv(
    alloc: std.mem.Allocator,
    nyac: []const nya.NYAC,
) !std.ArrayList(RiscVInst) {
    var out = std.ArrayList(RiscVInst).empty;
    
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
                try out.append(alloc, .{
                    .op = .li,
                    .rd = inst.return_addr,
                    .imm = inst.op1.Value.Number,
                });
            },
            .JumpFalse => {
                // JUMPFALSE t1, L2 -> beq t1, x0, L2
                try out.append(alloc, .{
                    .op = .beq,
                    .rs1 = inst.op1.Register,
                    .rs2 = 0, // x0 (zero register)
                    .label = inst.op2.Label,
                });
            },
            .Label => {
                try out.append(alloc, .{
                    .op = .label,
                    .label = inst.op1.Label,
                });
            },
            else => {},
        }
    }
    
    return out;
}

fn emit_assembly(riscv: std.ArrayList(RiscVInst)) !void {
    for (riscv.items) |inst| {
        switch (inst.op) {
            .add => std.debug.print("    add t{d}, t{d}, t{d}\n", .{inst.rd, inst.rs1, inst.rs2}),
            .li => std.debug.print("    li t{d}, {d}\n", .{inst.rd, inst.imm}),
            .beq => std.debug.print("    beq t{d}, x{d}, {s}\n", .{inst.rs1, inst.rs2, inst.label}),
            .label => std.debug.print("{s}:\n", .{inst.label}),
            else => {},
        }
    }
}
