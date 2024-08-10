const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "nfqws",
        .root_source_file = null,
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });

    b.installArtifact(exe);

    exe.linkSystemLibrary("netfilter_queue");
    exe.linkSystemLibrary("nfnetlink");
    exe.linkSystemLibrary("z");

    exe.addIncludePath(b.path("nfq"));

    exe.addCSourceFiles(.{
        .root = b.path("nfq"),
        .files = &nfqws_srcs,
        // .flags = &cflags,
    });
    exe.addCSourceFiles(.{
        .root = b.path("nfq"),
        .files = &crypto_srcs,
        // .flags = &cflags,
    });
}

const cflags = [_][]const u8{
    "-std=gnu99",
    "-Og",
    "-ggdb3",
    "-fno-omit-frame-pointer",
};

const nfqws_srcs = [_][]const u8{
    "checksum.c",
    "conntrack.c",
    "darkmagic.c",
    "desync.c",
    "gzip.c",
    "helpers.c",
    "hostlist.c",
    "nfqws.c",
    "packet_queue.c",
    "pools.c",
    "protocol.c",
    "sec.c",
};

const crypto_srcs = [_][]const u8{
    "crypto/aes-gcm.c",
    "crypto/aes.c",
    "crypto/gcm.c",
    "crypto/hkdf.c",
    "crypto/hmac.c",
    "crypto/sha224-256.c",
    "crypto/usha.c",
};
