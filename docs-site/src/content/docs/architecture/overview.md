---
title: Architecture Overview
---

NyxLang is structured as a multi-phase compiler with clear boundaries between parsing, semantics, IR, and code generation.

## Module responsibilities

- `main.zig`: entrypoint (CLI, file loading, coordinating compilation)
- `c11.l` / `c11.y`: C11 lexer/parser (tokenize + parse into AST)
- `ast.zig`: AST definitions (syntax structure, no typechecking)
- `semanticAnalyzer.zig`: semantic validation/type checks, produces errors
- `scope.zig`: lexical scope tracking, symbol resolution strategy
- `variables.zig`: variable metadata (storage class, offsets, lifetime decisions, etc.)
- `builtin.zig`: builtin functions/types inserted into the environment
- `3ac.zig`: IR generation (Three Address Code)
- `assembler.zig`: RV32 lowering + emitting assembly
- `build.zig`: build orchestration

## Design principles

### Phase separation
- Parser builds *structure* (AST) only.
- Semantic pass checks *meaning* (types, declarations, legality).
- IR pass focuses on *lowering* into explicit operations.
- Backend is *target-specific* (RV32 instruction selection + calling convention).

### Explicitness in IR
3AC exists to make implicit AST details explicit:
- temporaries for intermediate values
- branches/labels for control flow
- explicit loads/stores and address computations

### Errors
Prefer errors as early as possible:
- parsing errors for grammar violations
- semantic errors for type/scope issues
- backend errors only for unsupported lowering cases
