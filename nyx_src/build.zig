const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const exe = b.addExecutable(.{
        .name = "NyxLang",
        .version = .{
            .major = 0,
            .minor = 2,
            .patch = 0,
        },
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
            },
        }),
    });

    const bison = b.addSystemCommand(&.{"bison", "-d", "-v"});
    bison.addFileArg(b.path("src/c11.y"));

    const flex = b.addSystemCommand(&.{"flex", "-d"});
    flex.addFileArg(b.path("src/c11.l"));


    exe.addCSourceFile(.{ .file = b.path("src/c11.tab.c"), .flags = &.{} });
    exe.addCSourceFile(.{ .file = b.path("src/lex.yy.c"), .flags = &.{} });
    exe.linkLibC();
    exe.addIncludePath(b.path("src"));

    exe.step.dependOn(&bison.step);
    exe.step.dependOn(&flex.step);

    b.installArtifact(exe);

    const run_step = b.step("run", "Run the app");

    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);
    if(b.args) |args| {
        run_cmd.addArgs(args);
    }

    run_cmd.step.dependOn(b.getInstallStep());
}
