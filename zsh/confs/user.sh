#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

[[ ! -f ~/.zshrc ]] || (
  echo "shell configurations are already done" 2>&1
  exit 1;
) && \

curl -L git.io/antigen > ~/git/confs/dots/zsh/antigen.zsh && \
ln -s ${CURRENT_DIR}/../.zshrc ~/.zshrc
