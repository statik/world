load("//ext:github_files.bzl", "expanded_github_files")
load("//ext:github_archives.bzl", "expanded_github_archives")

def ext():
    _ext = {}
    _ext.update(expanded_github_archives())
    _ext.update(expanded_github_files())
    return _ext

def ext_dependencies():
    for name, kwargs in ext().items():
        url_repository(**kwargs)

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