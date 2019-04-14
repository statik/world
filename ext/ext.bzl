load("//ext:github_files.bzl", "expanded_github_files")
load("//ext:github_archives.bzl", "expanded_github_archives")

def files():
    _files = {}
    _files.update(expanded_github_files())
    return _files

def archives():
    _archives = {}
    _archives.update(expanded_github_archives())
    return _archives

def ext_dependencies():
    for name, kwargs in archives().items():
        url_repository(**kwargs)

    for name, kwargs in files().items():
        url_file(**kwargs)

def _url_file(ctx):
    ctx.download(
        url = ctx.attr.urls,
        output = "file/" + ctx.attr.output,
        sha256 = ctx.attr.sha256,
        executable = ctx.attr.executable,
    )

    overlay_files = []
    for src, dst in ctx.attr.overlay.items():
        ctx.symlink(src, dst)
        overlay_files.append(dst)
    
    ctx.file("file/BUILD.bazel", """exports_files(glob(["*"]))""")
    
url_file = repository_rule(
    attrs = dict(
        output = attr.string(default="file"),
        overlay = attr.label_keyed_string_dict(),
        sha256 = attr.string(),
        urls = attr.string_list(),
        executable = attr.bool(),
    ),
    implementation = _url_file,
)

def _url_repository(ctx):
    ctx.download_and_extract(
        url = ctx.attr.urls,
        output = ctx.attr.output,
        sha256 = ctx.attr.sha256,
        type = ctx.attr.type,
        stripPrefix = ctx.attr.strip_prefix,
    )

    for src, dst in ctx.attr.overlay.items():
        ctx.symlink(src, dst)

url_repository = repository_rule(
    attrs = dict(
        output = attr.string(),
        overlay = attr.label_keyed_string_dict(),
        sha256 = attr.string(),
        strip_prefix = attr.string(),
        type = attr.string(),
        urls = attr.string_list(),
    ),
    implementation = _url_repository,
)