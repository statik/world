#!/usr/bin/env bash

set -euo pipefail

main() {
    docker build --build-arg builder=context -t home - <./img/home/context.tar
}

main "$@"
exit $?
