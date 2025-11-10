grammar productions for int x[5];
declaration
  → declaration_specifiers init_declarator_list ';'

For declaration_specifier to create a type
declaration_specifiers
  → type_specifier
  → type_specifier declaration_specifiers
type_specifier → 'int'

For init_declarator_list to create x[5];
declarator → direct_declarator
direct_declarator
  ⇒ IDENTIFIER                 // "x"
  ⇒ direct_declarator '[' assignment_expression ']'
     where assignment_expression ⇒ constant ⇒ 5

export fn make_declaration_node(typeNode: *Node, asgnNode: ?*Node) ?*Node {
    if (debug_mode) std.debug.print("Dec Node: {any}\n", .{typeNode});
    if (debug_mode) std.debug.print("Dec Node Name?: {any}\n", .{typeNode.Type.type_name});
    // We create the declaration node
    if (typeNode.* == .Struct) {
        const decl_node = glob_alloc.create(StructDeclarationNode) catch return null;
        if (asgnNode) |n| {
            decl_node.* = StructDeclarationNode{ .packedNode = typeNode, .assignNode = n, .location = get_location() };
        } else {
            decl_node.* = StructDeclarationNode{ .packedNode = typeNode, .assignNode = null, .location = get_location() };
        } // We create a *node that wraps a specific node type
        const node = glob_alloc.create(Node) catch return null;
        // We set the union to be of type Declaration and assign the created declaration node
        node.* = Node{ .StructDeclaration = decl_node };
        const n: *Node = @ptrCast(node);
        return n;
    } else if (typeNode.* == .Type) {
        const decl_node = glob_alloc.create(DeclarationNode) catch return null;
        // std.debug.print("TypeNode in make_dec_node?: {any}\n", .{typeNode.Type.base});
        if (asgnNode) |n| {
            decl_node.* = DeclarationNode{ .typeNode = typeNode.Type, .assignNode = n, .location = get_location() };
        } else {
            decl_node.* = DeclarationNode{ .typeNode = typeNode.Type, .assignNode = null, .location = get_location() };
        } // We create a *node that wraps a specific node type
        const node = glob_alloc.create(Node) catch return null;
        // We set the union to be of type Declaration and assign the created declaration node
        node.* = Node{ .Declaration = decl_node };
        const n: *Node = @ptrCast(node);
        return n;
    } else return null;
}
