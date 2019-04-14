#!/usr/bin/env bash

set -euo pipefail
set -x

main () {
    dst="$1"
    tar -xf site/site.tgz -C "$dst"
}

main "$@"
exit $?