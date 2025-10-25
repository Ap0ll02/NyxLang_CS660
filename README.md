# 🌑 NyxLang

> *"Born of shadow, parsed by light."*

NyxLang is a **modern C-inspired language** powered by **Flex**, **Bison**, and **Zig**.  
It’s named after **Nyx**, the Greek Titaness of Night — because every language deserves a little darkness, mystery, and just the right amount of ✨chaotic feline energy✨.

This project started as an academic exploration of compiler construction — but it’s quickly grown claws.  
NyxLang aims to blend the **low-level precision of C** with **modern compilation in Zig**, creating a clean, experimental playground for language design.

---

## 🧩 Architecture

NyxLang’s architecture splits cleanly into **three realms**:

| Realm | Description | Tech |
|-------|--------------|------|
| 🌘 **Lexer** | Tokenizes source code. | Flex (.l) |
| 🌗 **Parser** | Converts tokens to an AST. | Bison (.y) |
| 🌑 **Core / Backend** | Allocates nodes, builds trees, and interprets or compiles them. | Zig |

Bison and Flex generate C-compatible symbols (`yyparse`, `yylex`, and `root`), which are **linked directly into Zig** for further processing — like AST printing, semantic analysis, and (eventually) code generation.

---

## 🌲 AST Printing

Once your parser runs, NyxLang’s Zig backend can pretty-print the abstract syntax tree:

```zig
pub fn printTree(node: ?*Node, depth: usize) void {
    if (node == null) return;
    const indent = "  " ** depth;
    switch (node.*) {
        .FunctionCall => |fc| {
            std.debug.print("{s}FunctionCall: ", .{indent});
            printTree(fc.name, depth + 1);
            for (fc.args) |arg| printTree(arg, depth + 1);
        },
        else => std.debug.print("{s}{any}\n", .{indent, node.*}),
    }
}
