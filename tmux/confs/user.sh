#!/usr/bin/env bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

[[ ! -f ~/.tmux.conf ]] || {
  echo "tmux configurations are already done" 2>&1
  exit 1;
} && \

ln -s "${CURRENT_DIR}/../.tmux.conf" ~/.tmux.conf
