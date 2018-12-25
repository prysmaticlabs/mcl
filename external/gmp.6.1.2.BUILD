exports_files([
    "gmpxx.h",
])

genrule(
    name = "gmp_hdrs",
    srcs = glob(["**/*"]),
    outs = [
        "gmp.h",
    ],
    cmd = """
        cd external/gmp_6_1_2
        ./configure >/dev/null
        cd ../..
        cp external/gmp_6_1_2/gmp.h $(location gmp.h)
    """,
    visibility = ["//visibility:public"],
)
