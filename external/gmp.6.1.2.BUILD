exports_files([
    "gmpxx.h",
])

load("@io_bazel_rules_m4//:m4.bzl", "m4")

m4(
    name = "hdrs",
    srcs = ["gmp-h.in"],
    out = "gmp.h",
    visibility = ["//visibility:public"],
)
