#!/usr/bin/env bash

function do_it () {
  local CURRENT_DIR
  CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

  (cd "${CURRENT_DIR}/" || exit; curl -LOk https://raw.githubusercontent.com/alacritty/alacritty-theme/master/themes/gruvbox_dark.toml) && \

  ln -s "${CURRENT_DIR}/gruvbox_dark.toml" "${HOME}/.gruvbox_dark.toml"
  ln -s "${CURRENT_DIR}/alacritty.toml" "${HOME}/.alacritty.toml"

  ln -s "${CURRENT_DIR}/gruvbox_dark.toml" "%APPDATA%\alacritty\.gruvbox_dark.toml"
  ln -s "${CURRENT_DIR}/alacritty.toml" "%APPDATA%\alacritty\alacritty.toml"
}

do_it "$@"
