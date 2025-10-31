const std = @import("std");

var column: i32 = 0;
var line: i32 = 0;

const LogType = enum {
    INFO,
    WARN,
    ERROR
};

fn info(this_column: i32, this_line: i32, source: [*c]const u8, hint: [*c]const u8) void {
}
fn Warn(this_column: i32, this_line: i32, source: [*c]const u8, hint: [*c]const u8) void {

}
fn Error(this_column: i32, this_line: i32, source: [*c]const u8, hint: [*c]const u8) void {

}
fn log(this_column: i32, this_line: i32, source: []const u8, hint: []const u8, l_type: LogType) void {
    switch (l_type) {
        .INFO => std.debug.print("\x1b[1;35mNyxLang | Info: \x1b[0m"),
        .ERROR => std.debug.print("\x1b[1;35mNyxLang | Error: \x1b[0m"),
        .WARN => std.debug.print("\x1b[1;35mNyxLang | Warning: \x1b[0m"),
    }

    std.debug.print("");
    
}
