DocInfo = provider("deps")

def _target_doc(ctx):
    out = ctx.actions.declare_file(ctx.label.name + ".json")
    info = struct(
        label = ctx.label.name,
        #    package = ctx.label.package,
        #    workspace = ctx.workspace_name,
        #    build_file_path = ctx.build_file_path,
        #    deps = [
        #        struct(
        #            dir = dir(dep),
        #            label = dep.label.name,
        #            package = dep.label.package,
        #        )
        #        for dep in ctx.attr.deps
        #    ],
    )
    ctx.actions.write(
        output = out,
        content = info.to_json(),
    )

    return [
        DefaultInfo(files = depset([out])),
        DocInfo(
            deps = depset(ctx.attr.deps),
        ),
    ]

target_doc = rule(
    implementation = _target_doc,
    attrs = dict(
        content = attr.string(),
        deps = attr.label_list(),
    ),
)

def _package_doc(ctx):
    out = ctx.actions.declare_file(ctx.label.name + ".json")

    #content = "\n".join(["%r %r" % (x, dir(x)) for x in ctx.attr.deps])
    #content = "\n".join([dep[DocInfo].content for dep in ctx.attr.deps])
    info = struct(
        deps = [
            struct(
                label = dep.label.name,
                package = dep.label.package,
                #_ = dir(dep),
            )
            for dep in ctx.attr.deps
        ],
    )
    ctx.actions.write(
        output = out,
        content = info.to_json(),
    )

    return [
        DefaultInfo(files = depset([out])),
        DocInfo(deps = depset(
            #direct = [dep[DocInfo].info for dep in ctx.attr.deps],
            direct = ctx.attr.deps,
            transitive = [dep[DocInfo].deps for dep in ctx.attr.deps],
        )),
    ]

package_doc = rule(
    implementation = _package_doc,
    attrs = dict(
        deps = attr.label_list(
            providers = [DocInfo],
        ),
    ),
)
