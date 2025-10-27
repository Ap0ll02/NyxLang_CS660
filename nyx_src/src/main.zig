const std = @import("std");

const parse = @cImport(@cInclude("c11.tab.h"));
const sym_tab = @import("symbolTable.zig");
const ast = @import("ast.zig");

pub const YY_BUFFER_STATE = *opaque {};
extern fn yylex() c_int; // from your lexer
extern fn yy_scan_bytes(bytes: [*c]const u8, len: c_int) YY_BUFFER_STATE;
extern fn yyparse() c_int;
export var root: ?*ast.Node = null;

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len < 2) {
        std.debug.print("Usage: {s} <filename>. Found {d} args\n", .{ args[0], args.len });
        return;
    }
    const cwd = try std.fs.cwd().realpathAlloc(allocator, ".");
    std.debug.print("CWD: {s}\n", .{cwd});
    defer allocator.free(cwd);
    const filename = args[1];
    std.debug.print("\n\nFILENAME: {s}\n\n", .{filename});
    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();

    const contents = try file.readToEndAlloc(allocator, std.math.maxInt(usize));
    defer allocator.free(contents);

    const length: c_int = @intCast(contents.len);
    _ = yy_scan_bytes(contents.ptr, length);

    const result = yyparse();

    std.debug.print("\n\n\n \x1b[1;33mPARSE/AST PRINTOUT\x1b[0m Nya Nya Meow Meow\n", .{});
    if (root) |r| {
        try ast.printNode(r, 0);
    } else {
        std.debug.print("Completed, but NULL.", .{});
    }
    std.debug.print("\nValid C?: {s}\n", .{if (result == 1) "No" else "Yes"});
}

export fn yyerror(msg: [*c]const u8) void {
    std.debug.print("Parse Error! {s}\n", .{msg});
}

export fn zig_error() void {
    std.debug.print("\x1b[1;35mNyxLang:\x1b[0m \x1b[1;33mError Caught Nya\x1b[0m\n", .{});
}
