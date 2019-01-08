load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

git_repository(
    name = "io_bazel_rules_m4",
    remote = "https://github.com/jmillikin/rules_m4",
    commit = "2bf69df77dfb6b3ba6b7fc95c304b0dc279375bc",
)

git_repository(
    name = "bazelify_gmp",
    remote = "https://github.com/robin-thomas/bazelify-gmp",
    commit = "bb4881b35e6864c90493980d035e1d984cafd093",
)

load("@io_bazel_rules_m4//:m4.bzl", "m4_register_toolchains")

m4_register_toolchains()
