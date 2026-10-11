#!/usr/bin/env bash
set -euo pipefail

"${HOME}/.local/bin/mise" exec -- oh-my-posh font install 'UbuntuMono'

command -v fc-cache >/dev/null && fc-cache -f || true
