---
title: NyxLang Developer Docs
description: Architecture and contributor documentation for the NyxLang C11 compiler in Zig.
---

NyxLang is a C11 compiler written in Zig.

**Pipeline:** C11 source → Lexer/Parser → AST → Semantic Analysis → 3AC IR → RISC-V RV32 codegen.

This documentation is written for contributors and for anyone trying to understand or extend the compiler.

## Where to start

- **Architecture overview:** `architecture/overview`
- **Compiler pipeline:** `architecture/pipeline`
- **AST layout and invariants:** `frontend/ast`
- **Scopes + resolution:** `semantic/scope`
- **IR (3AC):** `ir/three-address-code`
- **Backend (RV32):** `backend/riscv32`

## Key code locations

- Frontend grammar: `c11.l`, `c11.y`
- AST: `ast.zig`
- Semantic analysis: `semanticAnalyzer.zig`, `scope.zig`, `variables.zig`, `builtin.zig`
- IR: `3ac.zig`
- Backend: `assembler.zig`
- Build: `build.zig`
