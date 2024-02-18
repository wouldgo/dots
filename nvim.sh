#!/usr/bin/env bash

function do_it () {
  local CURRENT_DIR
  local NVIM_HOME
  local NVIM_SHARE

  CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
  NVIM_HOME="${HOME}/.config/nvim"

  ln -s "${CURRENT_DIR}/nvim" "${NVIM_HOME}"
}

do_it "$@"
