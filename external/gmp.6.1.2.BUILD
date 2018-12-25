exports_files([
    "gmpxx.h",
])

load("@io_bazel_rules_m4//:m4.bzl", "m4")

m4(
    name = "hdrs",
    srcs = ["gmp-h.in"],
    out = "dummy",
)

genrule(
    name = "gmp_hdrs",
    srcs = glob(["**/*"]),
    outs = [
        "gmp.h",
    ],
    cmd = """
        m4_PATH=`pwd`"/bazel-out/host/bin/external/m4_v1.4.18/bin/"
        PATH=$${PATH}:$${m4_PATH}
        cd external/gmp_6_1_2
        ./configure >/dev/null
        cd ../..
        cp external/gmp_6_1_2/gmp.h $(location gmp.h)
    """,
    visibility = ["//visibility:public"],
    tools = ["dummy"],
    local = 1,
)
