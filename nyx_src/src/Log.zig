const std = @import("std");

const LogType = enum {
    INFO,
    WARN,
    ERROR
};
const Location = struct { line: i32, col: i32 };
pub fn InfoLoc(loc: Location, msg: [*c]const u8, source: []const u8, hint: [*c]const u8) void {
    const new_msg = std.mem.span(msg);
    const new_hint = std.mem.span(hint);
    log(loc.col, loc.line, new_msg, source, new_hint, .INFO);
}
pub fn Info(this_column: usize, this_line: usize, msg: [*c]const u8, source: []const u8, hint: [*c]const u8) void {
    const new_msg = std.mem.span(msg);
    const new_hint = std.mem.span(hint);
    log(this_column, this_line, new_msg, source, new_hint, .INFO);
}

pub fn Warn(this_column: usize, this_line: usize, msg: [*c]const u8, source: []const u8, hint: [*c]const u8) void {
    const new_msg = std.mem.span(msg);
    const new_hint = std.mem.span(hint);
    log(this_column, this_line, new_msg, source, new_hint, .WARN);
}

pub fn Error(this_column: usize, this_line: usize, msg: [*c]const u8, source: []const u8, hint: [*c]const u8) void {
    const new_msg = std.mem.span(msg);
    const new_hint = std.mem.span(hint);
    log(this_column, this_line, new_msg, source, new_hint, .ERROR);
}

fn log(this_column: usize, this_line: usize, msg: []const u8, source: []const u8, hint: []const u8, l_type: LogType) void {
    const ulen = @max(0, this_column);
    // Line 1
    switch (l_type) {
        .INFO => std.debug.print("\x1b[1;32mNyxLang | Info: \x1b[0m", .{}),
        .ERROR => std.debug.print("\x1b[1;33mNyxLang | Error: \x1b[0m", .{}),
        .WARN => std.debug.print("\x1b[1;34mNyxLang | Warning: \x1b[0m", .{}),
    }
    std.debug.print("{s} at location {d}:{d}\n", .{msg, this_line, this_column});

    // Line 2
    std.debug.print("{s}\n", .{source});

    // Line 3
    const len = if(ulen < 4) 0 else ulen - 4;
    var i: usize = ulen;
    for (0..len-2) |_| {
        std.debug.print(" ", .{});
    }
    while (source.len-1 > 0) : (i -= 1) {
        if (i == ulen) { continue; }
        if (source[i-1] == ' ') { break; }
        std.debug.print("\x1b[1;35m~\x1b[0m", .{});
    }
    std.debug.print("\x1b[1;35m^\x1b[0m\n", .{});
    // std.debug.print("\x1b[1;35m~~~^\x1b[0m\n", .{});
    if (hint.len >= 2) std.debug.print("\x1b[1;36mHint: \x1b[0m{s}\n", .{hint}); 
}
