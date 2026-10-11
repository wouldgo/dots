#!/usr/bin/env bash
set -euo pipefail

[ -x "${HOME}/.local/bin/mise" ] && exit 0

TMP_DIR=$(mktemp -d)
trap 'rm -rf "${TMP_DIR}"' EXIT

gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys 0x7413A06D
curl -fsSL https://mise.jdx.dev/install.sh.sig | gpg --decrypt > "${TMP_DIR}/install.sh"
sh "${TMP_DIR}/install.sh"
