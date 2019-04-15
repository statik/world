#!/usr/bin/env bash

set -euo pipefail

main () {
    dst="$1"
    hugo="$PWD/cmd/hugo"
    find . -ls
    (cd site && "$hugo")
    (cd site/public && tar -cvf "$dst" .)
}

main "$@"
exit $?