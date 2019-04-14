#/usr/bin/env bash

set -euo pipefail

URL="https://github.com/bazelbuild/bazel/releases/download/0.24.1/bazel-0.24.1-linux-x86_64"
SHA256SUM="e18e2877e18a447eb5d94f5efbec375366d82af6443c6a83a93c62657a7b1c32"
CACHE="${CACHE:-/tmp}/whilp_world}"

main () {
  tmp="${CACHE}/tmp"
  bin="${CACHE}/bin"
  export PATH="${PATH}:${bin}"
  
  command -v bazel && exec bazel "$@"
  
  mkdir -p "$bin"
  mkdir -p "$tmp"
  
  fetch "$URL" "$tmp"/bazel
  checksum "$SHA256SUM" "$tmp"/bazel
  
  chmod a+x "$tmp"/bazel
  mv "$tmp"/bazel "$bin"/bazel
  
  exec bazel "$@"
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