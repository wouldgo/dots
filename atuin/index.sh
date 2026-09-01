#!/usr/bin/env bash

function do_it () {
  local CURRENT_DIR

  CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
  mkdir --parents "${HOME}/.config/atuin"

  ln -sf "${CURRENT_DIR}/config.toml" "${HOME}/.config/atuin/config.toml"
}

do_it "$@"
