#!/usr/bin/env bash
# Builds the Fedora auto-install ISO (netinst + kickstart) with podman.
#   ./build.sh [OUTPUT_DIR] [CACHE_DIR]   (defaults: ./out, ./out/cache)

function do_it () {
  set -euo pipefail

  local CURRENT_DIR
  local OUTPUT_DIR
  local CACHE_DIR

  CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
  OUTPUT_DIR="${1:-${CURRENT_DIR}/out}"
  CACHE_DIR="${2:-${OUTPUT_DIR}/cache}"

  mkdir -p "${OUTPUT_DIR}" "${CACHE_DIR}"

  podman build \
    -t fedora-iso-builder:latest \
    --file "${CURRENT_DIR}/Containerfile" \
    "${CURRENT_DIR}"

  podman run \
    --rm \
    -e FEDORA_VERSION="${FEDORA_VERSION:-44}" \
    -v "${OUTPUT_DIR}:/build/output:Z" \
    -v "${CACHE_DIR}:/build/iso-cache:Z" \
    fedora-iso-builder:latest
}

do_it "$@"
