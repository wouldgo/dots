#!/usr/bin/env bash
# Builds the Arch auto-install ISO with podman.
#   ./build.sh [OUTPUT_DIR]   (default: ./out)

function do_it () {
  set -euo pipefail

  local CURRENT_DIR
  local OUTPUT_DIR

  CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
  OUTPUT_DIR="${1:-${CURRENT_DIR}/out}"

  mkdir -p "${OUTPUT_DIR}"

  podman build \
    -t arch-iso-builder:latest \
    --file "${CURRENT_DIR}/Containerfile" \
    "${CURRENT_DIR}"

  # --privileged: mkarchiso runs pacstrap, which mounts proc/sys/dev in the chroot
  podman run \
    --rm \
    --privileged \
    -v "${OUTPUT_DIR}:/build/output:Z" \
    arch-iso-builder:latest
}

do_it "$@"
