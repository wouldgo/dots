#!/usr/bin/env bash

function do_it () {
  local CURRENT_DIR
  local NVIM_HOME
  local NVIM_SHARE

  CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
  NVIM_HOME="${HOME}/.config/nvim"
  NVIM_SHARE="${HOME}/.local/share/nvim"

  rm -Rfv "${NVIM_HOME}"
  rm -Rfv "${NVIM_SHARE}"
  mkdir -p "${NVIM_HOME}" "${NVIM_SHARE}"

  ln -s "${CURRENT_DIR}/../after" "${NVIM_HOME}/after"
  ln -s "${CURRENT_DIR}/../lua" "${NVIM_HOME}/lua"
  ln -s "${CURRENT_DIR}/../init.lua" "${NVIM_HOME}/init.lua"
}

do_it "$@"
