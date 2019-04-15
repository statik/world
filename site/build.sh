#!/usr/bin/env bash

set -euo pipefail

main () {
    hugo="$PWD/cmd/hugo"
    cd site && "$hugo"
}

main "$@"
exit $?