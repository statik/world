def github_files():
    return dict(
        com_github_bazelbuild_buildtools_buildozer = github_file(
            owner = "bazelbuild",
            repo = "buildtools",
            release = "0.22.0",
            src = "buildozer",
            sha256 = "7750fe5bfb1247e8a858f3c87f63a5fb554ee43cb10efc1ce46c2387f1720064",
            executable = True,
        ),

        com_github_bazelbuild_buildtools_buildifier = github_file(
            owner = "bazelbuild",
            repo = "buildtools",
            release = "0.22.0",
            src = "buildifier",
            sha256 = "25159de982ec8896fc8213499df0a7003dfb4a03dd861f90fa5679d16faf0f99",
            executable = True,
        ),

        com_github_mvdan_sh_shfmt = github_file(
            owner = "mvdan",
            repo = "sh",
            release = "v2.6.4",
            src = "shfmt_v2.6.4_linux_amd64",
            sha256 = "2fbf21300150a14cf908c2e3cfd85a54ba8fcc1eba4349a9aad67aaa07d73e86",
            executable = True,
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