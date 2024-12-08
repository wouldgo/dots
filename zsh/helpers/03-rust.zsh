#!/usr/bin/env zsh

function __rust_bootstrap () {
  if [ -f "${HOME}/.cargo/env" ]; then
    . "$HOME/.cargo/env"

    if [ ! -f "${ZSH_COMPLETION_FOLDER}/_rustup.zsh" ]; then
      rustup completions zsh | tee "${ZSH_COMPLETION_FOLDER}/_rustup.zsh" >/dev/null
    fi

    if [ $commands[cargo] ] && [ ! -f "${ZSH_COMPLETION_FOLDER}/_cargo.zsh" ]; then
      rustup completions zsh cargo | tee "${ZSH_COMPLETION_FOLDER}/_cargo.zsh" >/dev/null
    fi
  fi
}

__rust_bootstrap "$@"
