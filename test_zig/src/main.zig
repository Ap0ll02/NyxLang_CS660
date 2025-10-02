const std = @import("std");

const arithmetic = @cImport({ @cInclude("arithmetic.h");});

pub fn main() void {
    const result = arithmetic.add(5, 7);
    std.debug.print("5 + 7 = {}\n", .{result});
}
