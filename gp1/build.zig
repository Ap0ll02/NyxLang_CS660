const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "gp1",
        .root_module = b.createModule(.{

            .root_source_file = b.path("src/main.zig"),

            .target = target,
            .optimize = optimize,
        }),
    });

    const bison = b.addSystemCommand(&.{"bison", "-d"});
    bison.addFileArg(b.path("src/parser.y"));

    const flex = b.addSystemCommand(&.{"flex"});
    flex.addFileArg(b.path("src/lexer.l"));

    exe.root_module.addCSourceFiles(.{
        .files = &[_][]const u8{
            "src/parser.tab.c",
            "src/lex.yy.c",
        },
        .flags = &.{"-std=c99"},
    });
    exe.linkLibC();
    exe.addIncludePath(b.path("src"));
    exe.step.dependOn(&bison.step);
    exe.step.dependOn(&flex.step);

    b.installArtifact(exe);

    const run_step = b.step("run", "Run the app");

    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);


    run_cmd.step.dependOn(b.getInstallStep());

    // This allows the user to pass arguments to the application in the build
    // command itself, like this: `zig build run -- arg1 arg2 etc`
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
}
