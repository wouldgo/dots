#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

[[ ! -f "${HOME}/.zshrc" ]] || (
  echo "shell configurations are already done" 2>&1
  exit 1;
) \

curl -sfL git.io/antibody | sh -s - -b "${CURRENT_DIR}/.." && \
"${CURRENT_DIR}/../antibody-update-plugins.sh" && \
ln -s "${CURRENT_DIR}/../.zshrc" "${HOME}/.zshrc"

ln -s "${CURRENT_DIR}/../.condarc" "${HOME}/.condarc"

# shellcheck source=./../colors/index.sh
source "${CURRENT_DIR}/../colors/index.sh"
