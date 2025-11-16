const std = @import("std");
const m = @import("main.zig");
const log = @import("Log.zig");

pub const Instruction = enum { Add, Constant, Substract, Multiply, Divide, Label, Goto, If, StoreByte, LoadByte, StoreDouble, LoadDouble };

pub const Registers = enum { Unused, A0, A1, A2, A3, A4, A5, A6, A7 };

pub const TAC = struct { return_addr: u32, instruction: Instruction, op1_addr: u32, op2_addr: u32 };
