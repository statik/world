def github_archives():
    return dict(
        io_bazel_rules_go = github_archive(
            owner = "bazelbuild",
            repo = "rules_go",
            ref = "3ac08dddedec1b1b7f72bae49e24eda6a1f703bf",
            sha256 = "c3d7debf55f1fff6e5d26715546fab9803fa799d97ef25fc71ed88615d3c662e",
        ),
        bazel_gazelle = github_archive(
            owner = "bazelbuild",
            repo = "bazel-gazelle",
            ref = "99f7bcae18d0c84524eca529384723979ce473bc",
            sha256 = "6d62c377558bbea9228b9ea945ddafb1cdc7e3844bb66240c8b955ef975eae90",
        ),
        io_bazel_rules_docker = github_archive(
            owner = "bazelbuild",
            repo = "rules_docker",
            ref = "a98bc3b9cb9c530e45d2c74a8da44ab9efdbb0f3",
            sha256 = "e8bf969983b23ea0cf0c4ed156efffc72d454b81de8c1aaca77d3ea035ffd637",
        ),
    )

def github_archive(**attrs):
    return attrs

def expanded_github_archives():
    expanded = dict()
    for name, attrs in github_archives().items():
        expanded[name] = expand(name, attrs)
    return expanded

def expand(name, attrs):
    attrs.setdefault("name", name)

    owner = attrs.pop("owner")
    repo = attrs.pop("repo")
    ref = attrs.pop("ref")

    url = github_archive_url(owner, repo, ref)
    attrs.setdefault("urls", [url])

    prefix = "{repo}-{ref}".format(
        repo = repo,
        ref = ref,
    )
    attrs.setdefault("strip_prefix", prefix)

    return attrs

def github_archive_url(owner, repo, ref):
    return "https://github.com/{owner}/{repo}/archive/{ref}.tar.gz".format(
        owner = owner,
        repo = repo,
        ref = ref,
    )
