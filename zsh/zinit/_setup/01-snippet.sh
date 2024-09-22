#!/usr/bin/env bash

function do_it () {
  zinit snippet OMZP::ansible
  zinit snippet OMZP::command-not-found
  zinit snippet OMZP::git
  zinit snippet OMZP::sudo
  zinit snippet OMZP::kubectx
  zinit snippet OMZ::plugins/git/git.plugin.zsh

  zinit snippet https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/lib/history.zsh
  zinit snippet https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/lib/grep.zsh
}

do_it "$@"
