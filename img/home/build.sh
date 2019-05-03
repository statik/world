#!/usr/bin/env bash

set -euo pipefail

main() {
    sudo docker build -t home - <./img/home/context.tar
}

main "$@"
exit $?
