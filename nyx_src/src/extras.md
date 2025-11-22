                    // try to find out what the type_struct needs?
                    // we know it needs
                    // 1. size
                    // 2. alignment
                    // 3. a padding function
                    // 4. and to some how be wrapped into a fucking type node

                    // st.assign_type(type); problem how do we turn struct into a type node

                    // We have to make structs a new user define type
                    // We should also figure out 2 things about structs

                    // Part One Finding the SIZE multiply the size of all fields with in the struct
                    // struct point {
                    // int x;
                    // int y;
                    // }
                    // size = 8 bytes
                    // alignment = 4 bytes

                    // Now we have user defined type that has a size field
                    // How to find Alignment?
                    // Structs with different types (Just have to be a multiple of their own alignment)
                    // Example
                    // struct Example1 {
                    // char  a;     size 1, align 1
                    // short b;     size 2, align 2
                    // int   c;     size 4, align 4
                    // };
                    // Field a (char)
                    // offset must be multiple of 1 → OK at 0
                    // placed at offset 0–0
                    // Next = 1
                    // Field b (short)
                    // alignment = 2
                    // current offset = 1 → not divisible by 2
                    // pad 1 byte (offset 1)
                    // place at offset 2–3
                    // Next = 4
                    // Field c (int)
                    // alignment = 4
                    // current offset = 4 → OK
                    // place at offset 4–7
                    // Next = 8

                    // Some rules to remember
                    // 1. What struct padding is doing
                    // Struct padding exists for two reasons:
                    // Per-field padding
                    // So each field starts at an offset that satisfies its own alignment requirement.
                    // End padding
                    // So the total struct size is a multiple of the struct’s overall alignment.
                    // This is required so arrays of that struct are correctly aligned.
                    // No magic beyond that.
                    // 2. Key facts you need for each field
                    // For each field type you must know:
                    // field_size (e.g. sizeof(int) == 4)
                    // field_align (e.g. alignof(int) == 4)
                    // For the struct as a whole, you compute:

                    // struct_align = max of all field_align

                    // struct_size = computed via offsets + final padding
                    // 3. Padding only occurs between fields
                    // 4. Final struct padding aligns whole struct
                    // 5. Fields align to their own alignment, NOT the struct’s

                    // We create the declaration node
                    // if (typeNode.* == .Struct) {
                    //     const decl_node = glob_alloc.create(StructDeclarationNode) catch return null;
                    //     if (asgnNode) |n| {
                    //         decl_node.* = StructDeclarationNode{ .packedNode = typeNode, .assignNode = n, .location = get_location() };
                    //     } else {
                    //         decl_node.* = StructDeclarationNode{ .packedNode = typeNode, .assignNode = null, .location = get_location() };
                    //     } // We create a *node that wraps a specific node type
                    //     const node = glob_alloc.create(Node) catch return null;
                    //     // We set the union to be of type Declaration and assign the created declaration node
                    //     node.* = Node{ .StructDeclaration = decl_node };
                    //     const n: *Node = @ptrCast(node);
                    //     return n;