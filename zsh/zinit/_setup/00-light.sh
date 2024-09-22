#!/usr/bin/env bash

function do_it () {
  zinit light zsh-users/zsh-syntax-highlighting
  zinit light zsh-users/zsh-completions
  zinit light zsh-users/zsh-autosuggestions
  zinit light Aloxaf/fzf-tab
  zinit light BreakingPitt/zsh-packer
  zinit light StackExchange/blackbox
}

do_it "$@"
