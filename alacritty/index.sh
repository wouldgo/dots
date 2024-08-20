#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

[[ ! -f "${HOME}/.alacritty.toml" ]] || (
  echo "alacritty configurations are already done" 2>&1
  exit 1;
) \

(cd "${CURRENT_DIR}/../" || exit; curl -LOk https://raw.githubusercontent.com/alacritty/alacritty-theme/master/themes/gruvbox_dark.toml) && \

ln -s "${CURRENT_DIR}/../gruvbox_dark.toml" "${HOME}/.gruvbox_dark.toml"
ln -s "${CURRENT_DIR}/../alacritty.toml" "${HOME}/.alacritty.toml"
