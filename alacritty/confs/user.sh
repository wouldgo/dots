#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

[[ ! -f "${HOME}/.alacritty.yml" ]] || (
  echo "alacritty configurations are already done" 2>&1
  exit 1;
) \

(cd "${CURRENT_DIR}/../" || exit; curl -LOk https://raw.githubusercontent.com/nordtheme/alacritty/main/src/nord.yaml) && \

ln -s "${CURRENT_DIR}/../nord.yaml" "${HOME}/.nord.yaml"
ln -s "${CURRENT_DIR}/../alacritty.yaml" "${HOME}/.alacritty.yml"
