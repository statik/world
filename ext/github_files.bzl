def github_files():
    return dict(
        com_github_genuinetools_img_bin = github_file(
            owner = "genuinetools",
            repo = "img",
            release = "v0.5.6",
            src = "img-linux-amd64",
            sha256 = "c3d7debf55f1fff6e5d26715546fab9803fa799d97ef25fc71ed88615d3c662e",
        ),
    )

def github_file(**attrs):
    return attrs

def expanded_github_files():
    expanded = dict()
    for name, attrs in github_files().items():
        expanded[name] = expand(name, attrs)
    return expanded

def expand(name, attrs):
    attrs.setdefault("name", name)

    owner = attrs.pop("owner")
    repo = attrs.pop("repo")
    release = attrs.pop("release")
    src = attrs.pop("src")

    url = github_release_url(owner, repo, release, src)
    attrs.setdefault("urls", [url])
    return attrs

def github_release_url(owner, repo, release, src):
    return "https://github.com/{owner}/{repo}/releases/download/{release}/{src}".format(
        owner = owner,
        repo = repo,
        release = release,
        src = src,
    )