---
title: Adding Features
---

This guide describes the expected workflow to add a language feature to NyxLang.

## Workflow checklist

1. **Grammar**
   - update `c11.y` (and `c11.l` if new tokens are needed)

2. **AST**
   - add/modify node kinds in `ast.zig`

3. **Semantic analysis**
   - validate legality and types in `semanticAnalyzer.zig`
   - update `scope.zig` / `variables.zig` as needed

4. **IR lowering**
   - lower new node(s) into 3AC in `3ac.zig`

5. **Backend**
   - implement RV32 lowering in `assembler.zig`

6. **Tests**
   - add a minimal repro program
   - verify: parse → sema → IR → asm → run (if you have an execution harness)

## Good contributor habits

- Start with the smallest feature slice
- Keep dumps of AST/IR/ASM for debugging
- Document new invariants in the relevant docs page
