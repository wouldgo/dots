#!/usr/bin/env zsh

function __wsl_shims_bootstrap () {
  if [ "${IS_WSL}" ] && [ "$(command -v /mnt/c/Program\ Files/Microsoft\ VS\ Code/bin/code)" ]; then
    alias code="/mnt/c/Program\ Files/Microsoft\ VS\ Code/bin/code"
  fi
}

__wsl_shims_bootstrap "$@"
