#!/usr/bin/env bash


function do_it () {
  local CURRENT_DIR

  CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

  "${CURRENT_DIR}"/antibody bundle < "${CURRENT_DIR}"/zsh_plugins.txt > "${CURRENT_DIR}"/zsh_plugins.sh
}

do_it "$@"
