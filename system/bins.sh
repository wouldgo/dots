#!/usr/bin/env bash

cargo install evcxr_repl

[[ ! -f "${HOME}/.fzf" ]] || (
  echo "fzf already installed" 2>&1
  exit 1;
) \

git clone --depth 1 https://github.com/junegunn/fzf.git "${HOME}/.fzf" && \
"${HOME}/.fzf/install"
