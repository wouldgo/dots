#!/usr/bin/env bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

! command -v tmux || {
  echo "tmux is present." 2>&1
  exit 1;
} && \

# script gives up on any error
set -e && \

sudo ${CURRENT_DIR}/deps/apt.sh && \
sudo ${CURRENT_DIR}/compile-tmux.sh
