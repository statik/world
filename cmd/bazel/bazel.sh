#/usr/bin/env bash

#set -euo pipefail
set -x

URL="https://github.com/bazelbuild/bazel/releases/download/0.24.1/bazel-0.24.1-linux-x86_64"
SHA256SUM="e18e2877e18a447eb5d94f5efbec375366d82af6443c6a83a93c62657a7b1c32"
BIN="$PWD/bin"
DST="$BIN/bazel"

main () {
  export PATH="${PATH}:${BIN}"

  command -v bazel >/dev/null && exec bazel "$@"

  mkdir -p "$BIN"
  trap clean EXIT

  fetch "$URL" "${BIN}/bazel"
  checksum "$SHA256SUM" "${BIN}/bazel"
  chmod a+x "${BIN}/bazel"
  
  exec bazel "$@"
}

clean () {
  rm -f "$DST"
}

fetch () {
  url="$1"
  dst="$2"
  
  wget -qO "$dst" "$url"
}

checksum () {
  sha256sum="$1"
  src="$2"
  printf "${sha256sum}\t${src}\n" | sha256sum -c
}

main "$@"
exit $?