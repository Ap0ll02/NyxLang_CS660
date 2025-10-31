const std = @import("std");
const log = @import("Log.zig");
const parse = @cImport(@cInclude("c11.tab.h"));
const sym_tab = @import("symbolTable.zig");
const ast = @import("ast.zig");
const analyzer = @import("semanticAnalyzer.zig");
const c = @cImport(@cInclude("c11.tab.h"));

pub const YY_BUFFER_STATE = *opaque {};
extern fn yylex() c_int; // from your lexer
extern fn yy_scan_bytes(bytes: [*c]const u8, len: c_int) YY_BUFFER_STATE;
extern fn yyparse() c_int;
export var root: ?*ast.Node = null;
export var column: c_int = 1;
export var line: c_int = 1;

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len == 1 or args.len > 3) {
        std.debug.print("Usage: {s} <filename>. Found {d} args\n", .{ args[0], args.len });
        std.debug.print("Usage: {s} <filename> <flags>. Found {d} args\n", .{ args[0], args.len });
        return;
    }
    const cwd = try std.fs.cwd().realpathAlloc(allocator, ".");
    std.debug.print("CWD: {s}\n", .{cwd});
    defer allocator.free(cwd);
    const filename = args[1];
    if (args.len > 2) {
        if (std.mem.eql(u8, args[2], "-d")) {
            ast.debug_mode = true;
        }
    }
    std.debug.print("\n\nFILENAME: {s}\n\n", .{filename});
    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();

    const contents = try file.readToEndAlloc(allocator, std.math.maxInt(usize));
    defer allocator.free(contents);

    const length: c_int = @intCast(contents.len);
    _ = yy_scan_bytes(contents.ptr, length);

    const result = yyparse();

    if (ast.debug_mode) std.debug.print("\n\n\n \x1b[1;33mPARSE/AST PRINTOUT\x1b[0m DEBUG MODE ENABLED\n", .{}) else std.debug.print("\n\n\n \x1b[1;33mPARSE/AST PRINTOUT\x1b[0m Nya Nya Meow Meow\n", .{});
    // std.debug.print("\n\n\n \x1b[1;33mPARSE/AST PRINTOUT\x1b[0m Nya Nya Meow Meow\n", .{});
    if (root) |r| {
        try ast.printNode(r, 0);
        analyzer.semantic_analyze_node(r);
    } else {
        std.debug.print("Completed, but NULL.", .{});
    }
    std.debug.print("\nValid C?: {s}\n", .{if (result == 1) "No" else "Yes"});
}

export fn yyerror(msg: [*c]const u8) void {
    log.Error(line, column, 40, msg, " ", "Parsing error");
}

export fn zig_error(hint: [*c]const u8, msg: [*c]const u8, src: [*c]const u8) void {
    log.Error(column, line, 40, msg, src, hint);
}
