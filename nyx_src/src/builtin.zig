const ast = @import("ast.zig");

pub fn built_in_types(root: ast.Node) ast.Node {
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
    const printf = ast.FunctionNode {
        .typeNode = *VOID,
        .retType = *VOID,
        .body = ast.BlockItemsNode {},
        .nameParam = ast.NameParameterNode { .typeNode = *VOID, .name = ast.IdentifierNode {.name = "printf"}},
    };
    return ast.BlockItemsNode{ .items = [_]ast.Node{ int32, int64, int128, uint32, uint64, uint128, float32, float64, charu8, VOID, printf, catgirl, root }, .location = ast.Location{ .col = 0, .line = 0 }, .typeNode = null };
}
