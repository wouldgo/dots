#!/usr/bin/env zsh

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

function load () {
  zinit light Aloxaf/fzf-tab
  zinit light zsh-users/zsh-syntax-highlighting

  zinit ice blockf
  zinit light zsh-users/zsh-completions

  zinit light zsh-users/zsh-autosuggestions
  #zinit light BreakingPitt/zsh-packer

  # zinit snippet OMZP::ansible
  # zinit snippet OMZP::command-not-found
  # zinit snippet OMZP::git
  # zinit snippet OMZP::sudo
  # zinit snippet OMZP::kubectx
  # zinit snippet OMZ::plugins/git/git.plugin.zsh

  zinit snippet https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/lib/grep.zsh
}

function __zinit_bootstrap () {
  if [ ! -d "$ZINIT_HOME" ]; then
    mkdir --parents "$(dirname $ZINIT_HOME)"
    git clone --depth 1 https://github.com/zdharma-continuum/zinit.git "${ZINIT_HOME}"
  fi

  source "${ZINIT_HOME}/zinit.zsh"

  load "$@"
}

__zinit_bootstrap "$@"
