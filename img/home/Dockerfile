FROM ubuntu@sha256:d26d529daa4d8567167181d9d569f2a85da3c5ecaf539cace2c6223355d69981

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    git \
    golang \
    openssl \
    python3 \
    wget \
    ;
RUN ln -s /usr/bin/python3 /usr/local/bin/python

ENV CACHE /build/cache
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
WORKDIR /build/world
COPY . ./
RUN ./cmd/bazel/bazel.sh run --repository_cache=$CACHE --script_path=/build/bazel cmd/bazel &&
    /build/bazel build --repository_cache=$CACHE img/home:context.tar &&
    tar xf bazel-bin/img/home/context.tar -C / &&
    rm -rf /build
