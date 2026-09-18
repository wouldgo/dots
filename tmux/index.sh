#!/usr/bin/env bash

function do_it () {
  eval "$("${HOME}"/.local/bin/mise activate bash)"
  local CURRENT_DIR
  local TPM_DIRECTORY

  CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
  TPM_DIRECTORY="${HOME}/.tmux/plugins/tpm"

  if [ ! -d "${TPM_DIRECTORY}" ]; then
    git clone --depth 1 https://github.com/tmux-plugins/tpm.git "${TPM_DIRECTORY}"
  fi
  ln -sf "${CURRENT_DIR}/.tmux.conf" "${HOME}/.tmux.conf"
  "${HOME}/.tmux/plugins/tpm/bin/install_plugins"
}

do_it "$@"
