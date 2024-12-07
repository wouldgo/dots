#!/usr/bin/env bash

function do_it () {
  local CURRENT_DIR

  CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

  chsh "${USER}" -s "$(command -v zsh)"

  ln -sf "${CURRENT_DIR}/.zshrc" "${HOME}/.zshrc"

  # shellcheck source=./colors/index.sh
  source "${CURRENT_DIR}/colors/index.sh"
}

do_it "$@"
