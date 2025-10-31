const std = @import("std");

var column: i32 = 0;
var line: i32 = 0;

const LogType = enum {
    INFO,
    WARN,
    ERROR
};

fn info(this_column: i32, this_line: i32, length: i32, msg: [*c]const u8, source: [*c]const u8, hint: [*c]const u8) void {
    const new_msg = std.mem.span(msg) catch return "null";
    const new_src = std.mem.span(source) catch return "null";
    const new_hint = std.mem.span(hint) catch return "null";
    log(this_column, this_line, length, new_msg, new_src, new_hint);
}

fn Warn(this_column: i32, this_line: i32, length: i32, msg: [*c]const u8, source: [*c]const u8, hint: [*c]const u8) void {
    const new_msg = std.mem.span(msg) catch return "null";
    const new_src = std.mem.span(source) catch return "null";
    const new_hint = std.mem.span(hint) catch return "null";
    log(this_column, this_line, length, new_msg, new_src, new_hint);
}

fn Error(this_column: i32, this_line: i32, length: i32, msg: [*c]const u8, source: [*c]const u8, hint: [*c]const u8) void {
    const new_msg = std.mem.span(msg) catch return "null";
    const new_src = std.mem.span(source) catch return "null";
    const new_hint = std.mem.span(hint) catch return "null";
    log(this_column, this_line, length, new_msg, new_src, new_hint);
}

fn log(this_column: i32, this_line: i32, length: i32, msg: []const u8, source: []const u8, hint: []const u8, l_type: LogType) void {
    // Line 1
    switch (l_type) {
        .INFO => std.debug.print("\x1b[1;32mNyxLang | Info: \x1b[0m"),
        .ERROR => std.debug.print("\x1b[1;33mNyxLang | Error: \x1b[0m"),
        .WARN => std.debug.print("\x1b[1;34mNyxLang | Warning: \x1b[0m"),
    }
    std.debug.print("{s} at location {d}:{d}\n", .{msg, this_line, this_column});

    // Line 2
    if (length < 80) {
        std.debug.print("{s}", .{source});
    } else {
        std.debug.print("{s}", .{source[length-40..length+40]});
    }
    
    for (0..this_column) |_| {
        std.debug.print(" ");
    }

    // Line 3
    for (length-1) |_| {
        std.debug.print("-");
    }
    std.debug.print("^\n");
    std.debug.print("{s}\n", .{hint});
    
}
