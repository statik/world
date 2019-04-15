#!/usr/bin/env bash

set -euo pipefail

main () {
    hugo="$PWD/cmd/hugo"
    find . -ls
    cd site && "$hugo"
}

main "$@"
exit $?