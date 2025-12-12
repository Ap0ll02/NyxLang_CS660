const std = @import("std");

/// =============================================================
/// Backend Overview (NYAC / 3AC  →  RISC-V)
///
/// Stages:
///   1. Parse NYAC (3AC) text into an internal IR: Functions + Instructions.
///   2. Analyze virtual register usage.
///   3. Build activation records (stack frames).
///   4. Run register allocation + spilling.
///   5. Emit RISC-V for each function:
///        - prologue / epilogue
///        - function calls (4 phases)
///        - lowering each 3AC instruction.
/// =============================================================

// ===============================
// Basic enums & IR structs
// ===============================

/// Opcodes that correspond to NYAC / 3AC instructions.
const OpCode = enum {
    Label, // function/branch label
    Add, // basic example: vdst = vsrc + imm or vsrc1 + vsrc2
    Const, // vdst = constant
    StoreRegister, // e.g., SR addr_reg, (register: val_reg)
    Load, // optional: load from memory to vreg
    Call, // function call
    Return, // function return
    Branch, // conditional/unconditional branches
    ImbueRegister, // metadata about vreg<->identifier
    // TODO: add more (Sub, Mul, Div, Compare, Logical, etc.)
    Unknown,
};

/// What kind of operand we have: virtual register, immediate, or label.
const OperandKind = enum {
    none,
    reg, // virtual register number (e.g., 9)
    imm, // integer immediate (e.g., 42)
    label, // label name (for jumps/branches)
};

/// Represents a single operand in an instruction.
const Operand = struct {
    kind: OperandKind = .none,
    value: i32 = 0, // vreg index or immediate
    label: []const u8 = "", // only used when kind == .label
};

/// NYAC instruction as parsed from the .nyac file.
/// Convert these into RISC-V later in function such as emitFunctionBody().
const Instruction = struct {
    op: OpCode,
    dst: ?i32 = null, // destination virtual register (if any)
    a: Operand = .{}, // first operand (reg or imm)
    b: Operand = .{}, // second operand
    label_name: ?[]const u8 = null, // for Label ops

    // Optional: index of this instruction in the function, for liveness/CFG.
    index: usize = 0,
};

/// Represents one virtual register’s allocation state.
const VirtualRegisterInfo = struct {
    index: i32, // vreg id (e.g., 9)
    // Whether this vreg is assigned a physical register (vs spilled).
    has_physical: bool = false,
    physical_index: ?usize = null, // index into BackendContext.physical_registers
    // If spilled, stack offset relative to sp/fp for this vreg.
    stack_offset: ?i32 = null,
};

/// Represents a physical RISC-V integer register.
const PhysicalRegister = struct {
    name: []const u8, // e.g. "t0", "a0", "s1"
    is_free: bool = true, // allocator can toggle this
    // Optional: you can track which vreg currently occupies this reg.
    current_vreg: ?i32 = null,
};

/// Represents an activation record (stack frame) layout for a function.
///
/// Stores:
///   - total frame size
///   - offsets of special values (ra, fp)
///   - mapping from vregs → stack offsets (for spills, locals, arrays, etc.)
const ActivationRecord = struct {
    frame_size: i32 = 0,
    ra_offset: i32 = 0, // where ra is saved: [sp + ra_offset]
    fp_offset: i32 = 0, // where fp/s0

    /// Map from vreg index → stack offset.
    /// Use this spilled vregs and/or local variables.
    vreg_to_offset: std.AutoHashMap(i32, i32),
};

/// Represents functions in IR:
///   - Name (e.g., "main")
///   - its instructions (3AC)
///   - vreg info, liveness, activation record
const Function = struct {
    name: []const u8,
    instructions: std.ArrayList(Instruction),

    /// Info per virtual register used in this function.
    vregs: std.ArrayList(VirtualRegisterInfo),

    /// Activation record (stack frame) for this function.
    activation_record: ?ActivationRecord = null,
};

/// Backend context: global state for the NYAC → RISC-V translation.
const BackendContext = struct {
    allocator: std.mem.Allocator,
    functions: std.ArrayList(Function),

    /// Pool of physical registers we may allocate to vregs.
    physical_registers: std.ArrayList(PhysicalRegister),

    // Optional: config flags

};

// ===============================
// Helper: BackendContext setup/teardown
// ===============================

fn initBackendContext(alloc: std.mem.Allocator) !BackendContext {
    var ctx = BackendContext{
        .allocator = alloc,
        .functions = std.ArrayList(Function).init(alloc),
        .physical_registers = std.ArrayList(PhysicalRegister).init(alloc),
        .debug = false,
    };

    // Initialize physical registers here we could make a function for this
    try initPhysicalRegisters(&ctx);

    return ctx;
}

// ===============================
// Parsing NYAC (3AC) into IR
// ===============================

/// Parse an entire NYAC file into ctx.functions.
///
/// Example NYAC excerpt:
///   LABEL 0, (label: "main"), (register: 0)
///   ADD 9, (register: 9), (value: 0)
///   CONST 10, (value: 1), (register: 0)
///   SR 9, (register: 10), (register: 0)
fn parseNyacFile(ctx: *BackendContext, path: []const u8) !void {
    _ = ctx;
    _ = path;
    // TODO:
    //  - open file
    //  - loop line-by-line
    //  - create / append to Function when seeing LABEL "main", "foo", ...
    //  - skip library labels like "printf", if needed
    //  - call parseInstructionLine() for non-LABEL lines
    //  - push instructions into current function.instructions
    return error.Unimplemented;
}

/// Parse a single NYAC line into an Instruction.
fn parseInstructionLine(
    alloc: std.mem.Allocator,
    line: []const u8,
) !Instruction {
    _ = alloc;
    _ = line;
    // TODO:
    //  - detect prefix: "LABEL", "ADD", "CONST", "SR", "CALL", "RETURN", ...
    //  - use tokenizeAny to extract tokens
    //  - fill out Instruction fields
    return error.Unimplemented;
}

// ===============================
// Analysis: virtual registers & liveness
// ===============================

/// Discover which virtual registers are used in a function, and initialize
/// the vregs array in Function.
///
/// Compute the maximum vreg index, and then create one
/// VirtualRegisterInfo per vreg.
fn collectVirtualRegistersForFunction(
    alloc: std.mem.Allocator,
    func: *Function,
) !void {
    _ = alloc;
    _ = func;
    // TODO:
    //  - scan instructions
    //  - find all vreg indices mentioned in dst, a, b
    //  - populate func.vregs with a VirtualRegisterInfo for each vreg
    return error.Unimplemented;
}

/// Compute liveness information for each instruction in a function.
/// A minimal version could just compute which vregs are live at each point.
fn analyzeFunctionLiveness(
    alloc: std.mem.Allocator,
    func: *Function,
) !void {
    _ = alloc;
    _ = func;
    // TODO:
    //  - build liveness info (live_in / live_out)
    //  - store into func.liveness
    return error.Unimplemented;
}

/// Run analysis (vregs + liveness) for all functions.
fn analyzeAllFunctions(
    alloc: std.mem.Allocator,
    ctx: *BackendContext,
) !void {
    for (ctx.functions.items) |*func| {
        try collectVirtualRegistersForFunction(alloc, func);
        try analyzeFunctionLiveness(alloc, func);
    }
}

// ===============================
// Physical register initialization
// ===============================

/// Initialize the set of physical registers available for allocation.
///
/// Typical RISC-V integer regs you might use:
///   - t0–t6: temporaries
///   - s0–s11: callee-saved
///   - a0–a7: arguments/returns (be careful with calling convention).
fn initPhysicalRegisters(ctx: *BackendContext) !void {
    const names = [_][]const u8{
        "t0", "t1", "t2", "t3", "t4", "t5", "t6",
        // add other registers later "s0".."s11", "a0".."a7" if desired.
    };

    try ctx.physical_registers.ensureTotalCapacity(names.len);
    for (names) |n| {
        try ctx.physical_registers.append(PhysicalRegister{
            .name = n,
            .is_free = true,
            .current_vreg = null,
        });
    }
}

// ===============================
// Activation records & stack layout
// ===============================

/// Build an activation record (stack frame) for a function.
///
/// Responsibilities:
///   - Decide total frame size.
///   - Reserve space for saved ra, fp.
///   - Reserve slots for spilled vregs and locals.
///   - Fill vreg_to_offset with stack offsets for any spilled vregs.
fn buildActivationRecord(
    alloc: std.mem.Allocator,
    func: *Function,
) !ActivationRecord {
    _ = alloc;
    _ = func;
    // TODO:
    //  - choose a frame size (e.g., 16-byte aligned)
    //  - assign offsets for ra, fp, spilled vregs
    //  - initialize vreg_to_offset map
    return error.Unimplemented;
}

// ===============================
// Register allocation + spilling
// ===============================

/// Assign physical registers and spill slots for vregs in this function.
///
/// A good first step :
///   - spill everything: no real physical allocation
///   - each vreg gets a stack slot in ActivationRecord.vreg_to_offset.
///
/// Later we can improve this by:
///   - implement linear-scan register allocation using liveness.
fn allocateRegistersForFunction(
    alloc: std.mem.Allocator,
    ctx: *BackendContext,
    func: *Function,
    ar: *ActivationRecord,
) !void {
    _ = alloc;
    _ = ctx;
    _ = func;
    _ = ar;
    // TODO:
    //  - first we should do: for each vreg in func.vregs, assign stack_offset
    //  - later on we: assign some vregs to physical_registers, rest spilled
    return error.Unimplemented;
}

/// Helper: find the physical register (if any) for a given vreg index.
///
/// Return:
///   - index into ctx.physical_registers if vreg is in a physical reg
///   - null if vreg is spilled (stack only)
fn getPhysicalRegisterForVReg(
    ctx: *BackendContext,
    func: *Function,
    vreg_index: i32,
) ?usize {
    _ = ctx;
    _ = func;
    _ = vreg_index;
    // TODO:
    //  - look up vreg in func.vregs
    //  - if has_physical == true, return physical_index
    return null;
}

/// Helper: get stack offset for a given vreg index.
///
/// Use ar.vreg_to_offset to look this up. This is needed for spilled vregs.
fn getStackOffsetForVReg(
    ar: *ActivationRecord,
    vreg_index: i32,
) ?i32 {
    _ = ar;
    _ = vreg_index;
    // TODO:
    //  - return offset from vreg_to_offset map
    return null;
}

// ===============================
// Function prologue / epilogue
// ===============================

/// Emit the callee prologue.
///
/// This is phase 2 of the four call phases:
///   1. Caller pre-call
///   2. Callee prologue
///   3. Callee epilogue
///   4. Caller post-call
fn emitFunctionPrologue(
    writer: anytype,
    func: *const Function,
    ar: *const ActivationRecord,
) !void {
    _ = func;
    _ = ar;
    // TODO:
    //  - emit ".globl <name>" and "<name>:"
    //  - emit "addi sp, sp, -frame_size"
    //  - emit "sw ra, ra_offset(sp)"
    //  - save fp/s0 if you use a frame pointer
    _ = writer;
}

/// Emit the callee epilogue.
fn emitFunctionEpilogue(
    writer: anytype,
    func: *const Function,
    ar: *const ActivationRecord,
) !void {
    _ = func;
    _ = ar;
    // TODO:
    //  - restore ra
    //  - restore fp/s0 if needed
    //  - deallocate frame: "addi sp, sp, frame_size"
    //  - return: "ret"
    _ = writer;
}

// ===============================
// Instruction lowering to RISC-V
// ===============================

/// Emit the body of a function (between prologue and epilogue).
/// This is where we lower each NYAC instruction to RISC-V.
/// For each 3AC instruction, call a more specific emit* helper.
fn emitFunctionBody(
    writer: anytype,
    ctx: *BackendContext,
    func: *Function,
    ar: *ActivationRecord,
) !void {
    _ = ctx;
    _ = ar;

    // TODO:
    //  - iterate over func.instructions
    //  - switch on inst.op
    //  - dispatch to helper functions like emitAddInstruction, emitConstInstruction, etc.
    for (func.instructions.items) |*inst| {
        switch (inst.op) {
            .Add => try emitAddInstruction(writer, ctx, func, ar, inst),
            .Const => try emitConstInstruction(writer, ctx, func, ar, inst),
            .StoreRegister => try emitStoreRegisterInstruction(writer, ctx, func, ar, inst),
            .Call => try emitCallInstruction(writer, ctx, func, ar, inst),
            .Return => try emitReturnInstruction(writer, ctx, func, ar, inst),
            .Branch => try emitBranchInstruction(writer, ctx, func, ar, inst),
            .Label => {
                // Optional: if you have inner labels (not just function start),
                // emit them here.
                // TODO: handle label emission if needed.
            },
            .ImbueRegister => {
                // Metadata only; no code emission.
            },
            .Unknown => {
                // You might want to emit a comment or diagnostic.
                // e.g., writer.print("    # unknown instruction\n", .{});
            },
        }
    }
}

/// Example: lower an ADD instruction from NYAC to RISC-V.
///
/// derive the exact sequences the compiler needs.
fn emitAddInstruction(
    writer: anytype,
    ctx: *BackendContext,
    func: *Function,
    ar: *ActivationRecord,
    inst: *const Instruction,
) !void {
    _ = writer;
    _ = ctx;
    _ = func;
    _ = ar;
    _ = inst;
    // TODO:
    //  - find where vdst and vsrc live (physical reg or stack)
    //  - emit loads (if spilled), add/addi, and stores if needed
}

/// Example: lower a CONST instruction.
fn emitConstInstruction(
    writer: anytype,
    ctx: *BackendContext,
    func: *Function,
    ar: *ActivationRecord,
    inst: *const Instruction,
) !void {
    _ = writer;
    _ = ctx;
    _ = func;
    _ = ar;
    _ = inst;
    // TODO:
    //  - vdst = imm
    //  - if vdst in physical register → li <reg>, imm
    //  - if spilled → li t0, imm; sw t0, offset(sp)
}

/// Example: lower a StoreRegister (SR) instruction.
fn emitStoreRegisterInstruction(
    writer: anytype,
    ctx: *BackendContext,
    func: *Function,
    ar: *ActivationRecord,
    inst: *const Instruction,
) !void {
    _ = writer;
    _ = ctx;
    _ = func;
    _ = ar;
    _ = inst;
    // TODO:
    //  - treat dst as address vreg, a as value vreg
    //  - load both into temp registers (or use physical ones)
    //  - emit "sw val_reg, 0(addr_reg)"
}

/// Example: lower a CALL instruction.
///
/// Here you handle:
///   - Caller pre-call (phase 1)
///   - jal/jalr to callee
///   - Caller post-call (phase 4)
fn emitCallInstruction(
    writer: anytype,
    ctx: *BackendContext,
    func: *Function,
    ar: *ActivationRecord,
    inst: *const Instruction,
) !void {
    _ = writer;
    _ = ctx;
    _ = func;
    _ = ar;
    _ = inst;
    // TODO:
    //  - move arguments into a0, a1, ... or stack
    //  - save caller-saved registers if needed
    //  - emit "jal <callee>"
    //  - restore caller-saved registers
    //  - move return value from a0 to desired vreg
}

/// Example: lower a RETURN instruction.
fn emitReturnInstruction(
    writer: anytype,
    ctx: *BackendContext,
    func: *Function,
    ar: *ActivationRecord,
    inst: *const Instruction,
) !void {
    _ = writer;
    _ = ctx;
    _ = func;
    _ = ar;
    _ = inst;
    // TODO:
    //  - move return vreg into a0
    //  - then epilogue + ret will finish the function
    //  - you may just set a flag or emit code inline depending on design
}

/// Example: lower branches (if/while/conditional expressions).
fn emitBranchInstruction(
    writer: anytype,
    ctx: *BackendContext,
    func: *Function,
    ar: *ActivationRecord,
    inst: *const Instruction,
) !void {
    _ = writer;
    _ = ctx;
    _ = func;
    _ = ar;
    _ = inst;
    // TODO:
    //  - based on inst.op/operands, emit beq/bne/blt/etc. + labels
}

// ===============================
// Whole-program emission
// ===============================

/// Emit RISC-V code for the entire program.
///
/// For each function:
///   - analyze vregs + liveness
///   - build activation record
///   - allocate registers
///   - emit prologue/body/epilogue
fn emitProgramRiscV(ctx: *BackendContext) !void {
    var stdout = std.io.getStdOut().writer();
    try stdout.print("    .text\n", .{});

    for (ctx.functions.items) |*func| {
        // Build activation record
        var ar = try buildActivationRecord(ctx.allocator, func);
        func.activation_record = ar;

        // Allocate registers
        try allocateRegistersForFunction(ctx.allocator, ctx, func, &ar);

        // Emit function
        try emitFunctionPrologue(stdout, func, &ar);
        try emitFunctionBody(stdout, ctx, func, &ar);
        try emitFunctionEpilogue(stdout, func, &ar);
    }
}

/// Deinitialize backend context and free resources.
fn deinitBackendContext(ctx: *BackendContext) void {
    // Clean up functions, instructions, maps, etc.
    // This is mostly to avoid leaks when running lots of tests.
    for (ctx.functions.items) |*func| {
        // Deinit instruction list
        func.instructions.deinit();
        // Deinit liveness
        func.liveness.deinit();
        // Deinit vregs
        func.vregs.deinit();

        // Deinit activation record map if present
        if (func.activation_record) |*ar| {
            ar.vreg_to_offset.deinit();
        }
    }
    ctx.functions.deinit();

    // Deinit physical registers array
    ctx.physical_registers.deinit();
}
