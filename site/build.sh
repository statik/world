#!/usr/bin/env bash

set -euo pipefail

main () {
    echo "$@"
    hugo="$1"
    dst="$2"
    find . -ls
    (cd site && "$hugo")
    (cd site/public && tar -cvf "$dst" .)
}

main "$@"
exit $?