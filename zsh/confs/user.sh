#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

[[ ! -f ~/.zshrc ]] || (
  echo "shell configurations are already done" 2>&1
  exit 1;
) && \

git clone git://github.com/robbyrussell/oh-my-zsh.git ${CURRENT_DIR}/../.oh-my-zsh && \
curl -sL git.io/antibody | bash -s
