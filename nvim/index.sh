#!/usr/bin/env bash

function do_it () {
  local CURRENT_DIR
  local NVIM_HOME

  CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
  NVIM_HOME="${HOME}/.config/nvim"

  ln -fs "${CURRENT_DIR}" "${NVIM_HOME}"
}

do_it "$@"
