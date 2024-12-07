#!/usr/bin/env bash

function do_it () {
  local CURRENT_DIR

  CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
  mkdir --parents "${HOME}/.config/bat"

  ln -sf "${CURRENT_DIR}/bat.conf" "${HOME}/.config/bat/config"
}

do_it "$@"
