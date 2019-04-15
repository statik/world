def url_files():
    return dict(
        com_docker_download_docker = url_file(
            url = "https://download.docker.com/linux/static/stable/x86_64/docker-18.09.5.tgz",
            sha256 = "99ca9395e9c7ffbf75537de71aa828761f492491d02bc6e29db2920fa582c6c5",
        ),
    )

def url_file(**attrs):
    return attrs

def expanded_url_files():
    expanded = dict()
    for name, attrs in url_files().items():
        expanded[name] = expand(name, attrs)
    return expanded

def expand(name, attrs):
    attrs.setdefault("name", name)

    url = attrs.pop("url")
    attrs.setdefault("urls", [url])
    return attrs
