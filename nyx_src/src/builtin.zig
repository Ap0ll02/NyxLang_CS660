const ast = @import("ast.zig");
const m = @import("main.zig");

pub fn built_in_types(root: *ast.Node) ?*ast.Node {
    const int32 = ast.TypeNode{
        .is_unsigned = false,
        .is_const = false,
        .qualifier = 0, // 0 none, 1 long, 2 long long
        .type_name = "int",
        .size = @sizeOf(i32),
        .alignment = @alignOf(i32),
    };
    const int64 = ast.TypeNode{
        .is_unsigned = false,
        .is_const = false,
        .qualifier = 1, // 0 none, 1 long, 2 long long
        .type_name = "long",
        .size = @sizeOf(i64),
        .alignment = @alignOf(i64),
    };
    const int128 = ast.TypeNode{
        .is_unsigned = false,
        .is_const = false,
        .qualifier = 2, // 0 none, 1 long, 2 long long
        .type_name = "long long",
        .size = @sizeOf(i64),
        .alignment = @alignOf(i64),
    };
    const uint32 = ast.TypeNode{
        .is_unsigned = true,
        .is_const = false,
        .qualifier = 0, // 0 none, 1 long, 2 long long
        .type_name = "uint",
        .size = @sizeOf(u32),
        .alignment = @alignOf(u32),
    };
    const uint64 = ast.TypeNode{
        .is_unsigned = true,
        .is_const = false,
        .qualifier = 1, // 0 none, 1 long, 2 long long
        .type_name = "ulong",
        .size = @sizeOf(u64),
        .alignment = @alignOf(u64),
    };
    const uint128 = ast.TypeNode{
        .is_unsigned = true,
        .is_const = false,
        .qualifier = 2, // 0 none, 1 long, 2
        .type_name = "ulong long",
        .size = @sizeOf(u64),
        .alignment = @alignOf(u64),
    };
    const float32 = ast.TypeNode{
        .is_unsigned = false,
        .is_const = false,
        .qualifier = 0, // 0 none, 1 long, 2 long long
        .type_name = "float",
        .size = @sizeOf(f32),
        .alignment = @alignOf(f32),
    };
    const float64 = ast.TypeNode{
        .is_unsigned = false,
        .is_const = false,
        .qualifier = 1, // 0 none, 1 long, 2
        .type_name = "double",
        .size = @sizeOf(f64),
        .alignment = @alignOf(f64),
    };
    const charu8 = ast.TypeNode{
        .is_unsigned = false,
        .is_const = false,
        .qualifier = 0, // 0 none, 1 long, 2 long long
        .type_name = "char",
        .size = @sizeOf(u8),
        .alignment = @alignOf(u8),
    };
    const VOID = ast.TypeNode{
        .is_unsigned = false,
        .is_const = false,
        .qualifier = 0, // 0 none, 1 long, 2 long long
        .type_name = "void",
        .size = 0,
        .alignment = 1,
    };
    const catgirl = ast.TypeNode{
        .is_unsigned = false,
        .is_const = false,
        .qualifier = 0, // 0 none, 1 long, 2 long long
        .type_name = "bool",
        .size = @sizeOf(bool),
        .alignment = @alignOf(bool),
    };
    const printf_node = m.parse_alloc.create(ast.FunctionNode) catch return null;
    const nameparm = m.parse_alloc.create(ast.NameParameterNode) catch return null;
    const p_ident = m.parse_alloc.create(ast.IdentifierNode) catch return null;
    const body_node = m.parse_alloc.create(ast.Node) catch return null;
    const ident_node = m.parse_alloc.create(ast.Node) catch return null;
    p_ident.* = ast.IdentifierNode {.name = "printf"};
    ident_node.* = ast.Node {.Identifier = p_ident};
    nameparm.* = ast.NameParameterNode {.parameterList = null, .name = ident_node};
    const nameparm_node = m.parse_alloc.create(ast.Node) catch return null;
    nameparm_node.* = ast.Node { .NameParameterNode = nameparm };
    printf_node.* = ast.FunctionNode {.retType = @constCast(&VOID), .nameParam = nameparm_node, .body = body_node};
    const ret_node = m.parse_alloc.create(ast.Node) catch return null;
    ret_node.* = ast.Node {.Function = printf_node};

    const block_node = m.parse_alloc.create(ast.Node) catch return null;
    const builtin_block = m.parse_alloc.create(ast.BlockItemsNode) catch return null;
    builtin_block.* = ast.BlockItemsNode{ .items = [_]*ast.Node{ int32, int64, int128, uint32, uint64, uint128, float32, float64, charu8, VOID, ret_node, catgirl, root }};
    block_node.* = ast.Node {.BlockItems = builtin_block };

    return block_node;
}
