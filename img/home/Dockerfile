ARG builder=docker

FROM ubuntu@sha256:d26d529daa4d8567167181d9d569f2a85da3c5ecaf539cace2c6223355d69981 as base

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    git \
    golang \
    openssl \
    python3 \
    python3-pip \
    wget \
    ;
RUN ln -sf /usr/bin/python3 /usr/local/bin/python

# Run the build in docker.
FROM gcr.io/cloud-marketplace-containers/google/bazel@sha256:80eee1a58b8f1e5cae4afecd7b13b7d1d6120653921ca2ecd62a04d010a1b20e as build-docker

WORKDIR /workspace
COPY . ./
RUN bazel --output_user_root=/tmp/bazel build img/home:context.tar && cp bazel-bin/img/home/context.tar /tmp/.

# Expect that the build was run outside of docker and is available as context.
FROM base as build-context

COPY . /tmp/context/
RUN tar cf /tmp/context.tar -C /tmp/context ./

FROM build-${builder} as context

FROM base

COPY --from=context /tmp/context.tar /tmp/.
RUN tar xf /tmp/context.tar -C / && rm -f /tmp/context.tar
