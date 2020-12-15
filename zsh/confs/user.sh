#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

[[ ! -f ~/.zshrc ]] || (
  echo "shell configurations are already done" 2>&1
  exit 1;
) && \

curl -sfL git.io/antibody | sh -s - -b "${CURRENT_DIR}" && \
ln -s "${CURRENT_DIR}/../.zshrc" ~/.zshrc
