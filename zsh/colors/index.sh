#!/usr/bin/env bash

function do_it () {
  local CURRENT_DIR
  CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

  curl -o "${CURRENT_DIR}/gruvbox.dircolors" https://raw.githubusercontent.com/twisty/dotfiles/master/gruvbox.dircolors
}

do_it "$@"
