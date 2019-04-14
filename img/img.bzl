def container_image(name, **kwargs):
    context = kwargs["context"]

    container_image_id = name + "_container_image_id"

    native.genrule(
        name = name,
        outs = [name + ".json"],
        cmd = "$(location //cmd/img_build) -out $@ -context $(location %s)" % context,
        tools = ["//cmd/img_build"],
        srcs = [
            context,
        ],
    )