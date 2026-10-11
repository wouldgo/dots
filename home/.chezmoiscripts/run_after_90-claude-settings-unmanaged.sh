#!/usr/bin/env bash
# Reports, on every apply, the Claude Code settings not tracked in the repo
set -euo pipefail

"${HOME}/.local/bin/claude-settings-unmanaged"
