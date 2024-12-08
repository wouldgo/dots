#!/usr/bin/env bash

function do_it () {

  eval "$("${HOME}"/.local/bin/mise activate bash)"
  local CURRENT_DIR

  CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

  git clone https://github.com/tmux-plugins/tpm.git "${HOME}/.tmux/plugins/tpm"
  ln -sf "${CURRENT_DIR}/.tmux.conf" "${HOME}/.tmux.conf"

  "${HOME}/.tmux/plugins/tpm/bin/install_plugins"
}

do_it "$@"
