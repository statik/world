#!/usr/bin/env bash

set -euo pipefail

main () {
    ./site/extract $PWD/tmp
    return 1
}

main "$@"
exit $?