#!/usr/bin/env bash

set -euo pipefail

main() {
    input="$PWD/$1"
    hugo="$PWD/$2"
    dst="$PWD/$3"

    mkdir -p site
    tar -xf "$input" -C site
    (cd site && "$hugo")
    (cd site/public && tar -cvf "$dst" .)
}

main "$@"
exit $?
