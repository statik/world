load("@bazel_gazelle//:deps.bzl", _go_repository = "go_repository")

def ext_dependencies_go():
    for name, kwargs in expanded_go_repositories().items():
        _go_repository(**kwargs)

def go_repositories():
    return dict(
        com_github_google_go_containerregistry = go_repository(
            owner = "google",
            repo = "go-containerregistry",
            ref = "b6d875c30fe7d51e952909e585882149f6fedf74",
            sha256 = "a68165e7a3137a3cfd4d77d6405ad84a050afce86fcd042fc660802553ee725d",
        ),
    )

def go_repository(**attrs):
    return attrs

def expanded_go_repositories():
    expanded = dict()
    for name, attrs in go_repositories().items():
        expanded[name] = expand(name, attrs)
    return expanded

def expand(name, attrs):
    attrs.setdefault("name", name)

    owner = attrs.pop("owner")
    repo = attrs.pop("repo")
    ref = attrs.pop("ref")
    importpath = attrs.pop("importpath", "github.com/{owner}/{repo}".format(
        owner = owner,
        repo = repo,
    ))
    attrs.setdefault("importpath", importpath)

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
