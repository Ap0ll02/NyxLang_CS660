const std = @import("std");
const parser = @cImport({ @cInclude("parser.tab.h");});

extern fn yyparse() c_int;

export fn zig_add(a: f64, b: f64) f64 {
    return a + b;
}

export fn zig_print_result(a: f64) void {
    std.debug.print("\n", .{});
    std.debug.print("Evaluated To: {d}\n", .{a});
}

pub fn main() !void {
    // const input = "6 + 7";
    const result = parser.yyparse();
    std.debug.print("\n", .{});
    std.debug.print("Parsed?: {any}\n", .{result});
}

export fn yyerror(msg: [*c]const u8) void {
    std.debug.print("Parse Error! {s}\n", .{msg});
}
