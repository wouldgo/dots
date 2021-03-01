#!/usr/bin/env bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

[[ ! -f ~/.tmux.conf ]] || [[ ! -f ~/.tpm ]] || {
  echo "tmux configurations are already done" 2>&1
  exit 1;
} && \

wget "https://github.com/tmux-plugins/tpm/archive/master.zip" -O "${CURRENT_DIR}/.."/tpm.zip
unzip -o "${CURRENT_DIR}"/../tpm.zip
rm "${CURRENT_DIR}/.."/tpm.zip

mkdir -p ~/.tmux/plugins

ln -s "${CURRENT_DIR}/../.tmux.conf" ~/.tmux.conf
ln -s "${CURRENT_DIR}/../tpm-master" ~/.tmux/plugins/tpm

~/.tmux/plugins/tpm/bin/install_plugins
