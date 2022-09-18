#!/usr/bin/env bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

[[ ! -f "${HOME}/.tmux.conf" ]] || [[ ! -f "${HOME}/.tpm" ]] || {
  echo "tmux configurations are already done" 2>&1
  exit 1;
} && \

wget "https://github.com/tmux-plugins/tpm/archive/master.zip" -O "${CURRENT_DIR}"/tpm.zip
unzip -o "${CURRENT_DIR}"/tpm.zip -d "${CURRENT_DIR}/../"
rm "${CURRENT_DIR}"/tpm.zip

mkdir -p "${HOME}/.tmux/plugins"

ln -s "${CURRENT_DIR}/../.tmux.conf" "${HOME}/.tmux.conf"
ln -s "${CURRENT_DIR}/../tpm-master" "${HOME}/.tmux/plugins/tpm"

"${HOME}/.tmux/plugins/tpm/bin/install_plugins"
