workspace(name = "com_github_whilp_world")

load("//ext:ext.bzl", "ext_dependencies")

ext_dependencies()

load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")

go_rules_dependencies()

go_register_toolchains()

load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")

gazelle_dependencies()

load("//ext:go.bzl", "ext_dependencies_go")

ext_dependencies_go()
