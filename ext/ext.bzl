load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")
load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies", "go_repository")
load("//ext:url.bzl", "url_file", "url_repository")

def dependencies():
    go_rules_dependencies()
    go_register_toolchains()
    gazelle_dependencies()

def ext():
    dependencies()

    url_file(
        name = "com_github_bazelbuild_buildtools_buildozer",
        urls = ["https://github.com/bazelbuild/buildtools/releases/download/0.22.0/buildozer"],
        sha256 = "7750fe5bfb1247e8a858f3c87f63a5fb554ee43cb10efc1ce46c2387f1720064",
        executable = True,
    )

    url_file(
        name = "com_github_bazelbuild_buildtools_buildifier",
        urls = ["https://github.com/bazelbuild/buildtools/releases/download/0.22.0/buildifier"],
        sha256 = "25159de982ec8896fc8213499df0a7003dfb4a03dd861f90fa5679d16faf0f99",
        executable = True,
    )

    url_file(
        name = "com_github_mvdan_sh_shfmt",
        urls = ["https://github.com/mvdan/sh/releases/download/v2.6.4/shfmt_v2.6.4_linux_amd64"],
        sha256 = "2fbf21300150a14cf908c2e3cfd85a54ba8fcc1eba4349a9aad67aaa07d73e86",
        executable = True,
    )

    url_file(
        name = "com_github_bazelbuild_bazel_bazel",
        urls = ["https://github.com/bazelbuild/bazel/releases/download/0.24.1/bazel-0.24.1-linux-x86_64"],
        sha256 = "e18e2877e18a447eb5d94f5efbec375366d82af6443c6a83a93c62657a7b1c32",
        executable = True,
    )

    # bumped https://download.docker.com/linux/static/stable/x86_64/{{file}}
    url_file(
        name = "com_docker_download_docker",
        urls = ["https://download.docker.com/linux/static/stable/x86_64/docker-18.09.5.tgz"],
        sha256 = "99ca9395e9c7ffbf75537de71aa828761f492491d02bc6e29db2920fa582c6c5",
        output = "docker.tgz",
    )

    # bumped https://dl.google.com/go/go{{version}}.linux-amd64.tar.gz
    url_file(
        name = "org_golang_go",
        urls = ["https://dl.google.com/go/go1.12.4.linux-amd64.tar.gz"],
        sha256 = "d7d1f1f88ddfe55840712dc1747f37a790cbcaa448f6c9cf51bbe10aa65442f5",
        output = "golang.tgz",
    )

    # bumped https://github.com/gohugoio/hugo/releases/download/v{{release}}/hugo_{{release}}_Linux-64bit.tar.gz
    url_repository(
        name = "com_github_gohugoio_hugo_hugo",
        urls = ["https://github.com/gohugoio/hugo/releases/download/v0.55.1/hugo_0.55.1_Linux-64bit.tar.gz"],
        sha256 = "3ac63e37477f16cb8adbef21794f7689f4a3a15887c067a93026113119cf1406",
        overlay = {
            "@com_github_whilp_world//ext:export_all.bzl": "BUILD.bazel",
        },
    )

    # bumped https://github.com/google/go-containerregistry/archive/{{ref}}.tar.gz
    go_repository(
        name = "com_github_google_go_containerregistry",
        sha256 = "a68165e7a3137a3cfd4d77d6405ad84a050afce86fcd042fc660802553ee725d",
        strip_prefix = "go-containerregistry-b6d875c30fe7d51e952909e585882149f6fedf74",
        urls = ["https://github.com/google/go-containerregistry/archive/b6d875c30fe7d51e952909e585882149f6fedf74.tar.gz"],
        importpath = "github.com/google/go-containerregistry",
    )
