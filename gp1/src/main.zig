const std = @import("std");
const parser = @cImport({ @cInclude("parser.tab.h");});

extern fn yyparse() c_int;

export fn zig_add(a: f64, b: f64) f64 {
    return a + b;
}

pub fn main() !void {
    // const input = "6 + 7";
    const result = parser.yyparse();

    std.debug.print("Result: {any}", .{result});
}

export fn yyerror(msg: [*c]const u8) void {
    std.debug.print("Parse Error! {s}\n", .{msg});
}
