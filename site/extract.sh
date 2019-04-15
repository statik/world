#!/usr/bin/env bash

set -euo pipefail
set -x

main() {
    src="$PWD/$1"
    dst="$2"
    echo "$@"
    tar -xf "$src" -C "$dst"
}

main "$@"
exit $?
