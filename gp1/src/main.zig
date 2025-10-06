const std = @import("std");
const parser = @cImport({ @cInclude("parser.tab.h");});

extern fn yyparse() c_int;

export fn zig_add(a: f64, b: f64) f64 {
    return a + b;
}

export fn zig_mul(a: f64, b: f64) f64 {
    return a * b;
}

export fn zig_minus(a: f64, b:f64) f64{
    return a - b; 
}

export fn zig_div(a: f64, b:f64) f64{
    return a / b; 
}

export fn zig_neg(a: f64) f64{
    return -a; 
}

export fn zig_print_result(a: f64) void {
    std.debug.print("\n", .{});
    std.debug.print("Evaluated To: {d}\n", .{a});
}

export fn zig_var(name: [*c]const u8) f64 {
    const name_zig: []const u8 = std.mem.span(name);
    const value = map.get(name_zig);
    if (value) |val| return val;
    return 0.0;
}

export fn zig_var_dec(name: [*c]const u8) f64 {
    const name_zig: []const u8 = std.mem.span(name);
    const val = zig_var(name) - 1.0;
    _ = insert_var(name_zig, val);
    return val;
}
export fn zig_var_inc(name: [*c]const u8) f64 {
    const name_zig: []const u8 = std.mem.span(name);
    const val = zig_var(name) + 1.0;
    _ = insert_var(name_zig, val);
    return val;
}

fn insert_var(name: []const u8, val: f64) bool {
    _ = map.put(name, val) catch return false;
    return true;
}

export fn zig_var_init(name: [*c]const u8, val: f64) void {
    const name_zig: []const u8 = std.mem.span(name);
    _ = insert_var(name_zig, val);
}

const allocator = std.heap.page_allocator;
var map: std.StringHashMap(f64) = std.StringHashMap(f64).init(allocator);

pub fn main() !void {
    // const input = "6 + 7";
    const result = parser.yyparse();
    std.debug.print("\n", .{});
    std.debug.print("Parsed?: {any}\n", .{result});
}

export fn yyerror(msg: [*c]const u8) void {
    std.debug.print("Parse Error! {s}\n", .{msg});
}
