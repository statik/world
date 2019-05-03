#!/usr/bin/env bash

set -euo pipefail

main() {
	host=127.0.0.1

	sudo docker run \
		--detach \
		--restart=always \
		-P \
		--volume /var/run/docker.sock:/var/run/docker.sock \
		--volume vscode:/home/coder/project \
		vscode \
		--allow-http \
		--user-data-dir /home/coder/project/.vscode \
		--no-auth
}

main "$@"
exit $?
