const std = @import("std");
const c = @cImport(@cInclude("c11.tab.h"));

pub const Node = struct {
    val: NodeVal,
    loc: Location,

    pub const NodeType = enum {
        // Unlabeled
        Function,
        Block,

        // Mathematical: Arith, Logic, Comp, Cast
        Binary,
        Unary,
        Logic,
        Comp,
        Cast,

        // Variables, Pointers and Arrays 
        
        // Control Flow (If, Loops)
        
        // Literals
        String,
        Int,
        Float,
    };

    const NodeVal = union(NodeType) {
        Function: struct { name: []const u8, params: std.ArrayList(Node), body: Node},
        Block: std.ArrayList(Node),
        // Mathematical 
        Binary: struct {
            op: []const u8,
            left: *Node,
            Right: *Node,
        },

        // Variables, Pointers and Arrays 
       
        // Control Flow (If, Loops)

        // Literals 
        String: []const u8,
        Int: i64,
        Float: f64,

    };

    pub const Location = struct {
        line: usize,
        column: usize,
    };
};

// Creation Functions

// Not sure if this will be one or more functions,
// if we will need a function per type, or have any 
// generics.
pub fn type_info(token: c_int) void {
}

// Find out what type the actual literal will have.
// Help with this QUINN
pub fn create_literal(t_type: c_int, val: __) Node {
    switch (token) {
        c.FLOAT => { }
    }

}
