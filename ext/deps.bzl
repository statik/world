load("//ext:url.bzl", "url_repository")

def ext_dependencies():
    url_repository(
        name = "io_bazel_rules_go",
        strip_prefix = "rules_go-ef7cca8857f2f3a905b86c264737d0043c6a766e",
        urls = ["https://github.com/bazelbuild/rules_go/archive/ef7cca8857f2f3a905b86c264737d0043c6a766e.tar.gz"],
        sha256 = "1a400dc2f69971e3ebce29f7950dc38f8bb7e41c727258b6d2fb70060a4ce429",
    )

    url_repository(
        name = "bazel_gazelle",
        strip_prefix = "bazel-gazelle-99f7bcae18d0c84524eca529384723979ce473bc",
        urls = ["https://github.com/bazelbuild/bazel-gazelle/archive/99f7bcae18d0c84524eca529384723979ce473bc.tar.gz"],
        sha256 = "6d62c377558bbea9228b9ea945ddafb1cdc7e3844bb66240c8b955ef975eae90",
    )
