#!/usr/bin/env zsh

if [ $commands[rustup] ]; then
  if [ ! -f "${HOME}/.zsh/completion/_rustup.zsh" ]; then
    rustup completions zsh | tee "${HOME}/.zsh/completion/_rustup.zsh" >/dev/null
  fi

  if [ $commands[cargo] ] && [ ! -f "${HOME}/.zsh/completion/_cargo.zsh" ]; then
    rustup completions zsh cargo | tee "${HOME}/.zsh/completion/_cargo.zsh" >/dev/null
  fi
fi
