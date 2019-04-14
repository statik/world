#!/usr/bin/env bash

set -euo pipefail

main () {
    sudo docker build -t vscode - < ./img/vscode/context.tar
}

main "$@"
exit $?