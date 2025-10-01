const std = @import("std");

extern fn yyparse() c_int;

pub fn main() !void {
    // const input = "6 + 7";
    const result = yyparse();

    std.debug.print("Result: {any}", .{result});
}

export fn yyerror(msg: [*c]const u8) void {
    std.debug.print("Parse Error! {s}\n", .{msg});
}
