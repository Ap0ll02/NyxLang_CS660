const std = @import("std");

const parse = @cImport(@cInclude("c11.tab.h"));

extern fn yyparse() c_int;

pub fn main() !void {
    const result = parse.yyparse();
    std.debug.print("?: {any}", .{result});
}

export fn yyerror(msg: [*c]const u8) void {
    std.debug.print("Parse Error! {s}\n", .{msg});
}

export fn zig_error() void {
    std.debug.print("\x1b[1;35mNyxLang:\x1b[0m \x1b[1;33mError Caught Nya\x1b[0m\n", .{});
}
