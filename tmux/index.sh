#!/usr/bin/env bash
function do_it () {
  local CURRENT_DIR

  CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

  git clone https://github.com/tmux-plugins/tpm.git "${HOME}/.tmux/plugins/tmux"
  ln -sf "${CURRENT_DIR}/.tmux.conf" "${HOME}/.tmux.conf"

  "${HOME}/.tmux/plugins/tpm/bin/install_plugins"
}

do_it "$@"
