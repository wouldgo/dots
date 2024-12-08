#!/usr/bin/env bash

function do_it () {
  local CURRENT_DIR

  CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

  mkdir --parents "${HOME}/.config/mise" && \
  ln -sf "${CURRENT_DIR}/mise_config.toml" "${HOME}/.config/mise/config.toml"

  "${HOME}/.local/bin/mise install"
}

do_it "$@"
