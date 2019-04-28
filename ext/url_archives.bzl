def url_archives():
    return dict(
        com_github_gohugoio_hugo_hugo = url_archive(
            url = "https://github.com/gohugoio/hugo/releases/download/v0.55.1/hugo_0.55.1_Linux-64bit.tar.gz",
            sha256 = "3ac63e37477f16cb8adbef21794f7689f4a3a15887c067a93026113119cf1406",
            overlay = {
                "@com_github_whilp_world//ext:export_all.bzl": "BUILD.bazel",
            },
        ),
    )

def url_archive(**attrs):
    return attrs

def expanded_url_archives():
    expanded = dict()
    for name, attrs in url_archives().items():
        expanded[name] = expand(name, attrs)
    return expanded

def expand(name, attrs):
    attrs.setdefault("name", name)

    url = attrs.pop("url")
    attrs.setdefault("urls", [url])
    return attrs
