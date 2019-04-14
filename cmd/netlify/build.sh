#!/usr/bin/env bash

set -euo pipefail

main () {
    out="${PWD}/gen/netlify"
    mkdir -p "$out"
    bash -x cmd/bazel/bazel.sh run //site:extract "$out"
}

main "$@"
exit $?