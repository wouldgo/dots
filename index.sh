#!/usr/bin/env bash

function do_it () {
  local CURRENT_DIR

  CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

  echo "Updating system" && \
  if ! "${CURRENT_DIR}"/system/update-system.sh; then
    echo "Something went wrong" 2>&1
  fi

  echo "Installing dependencies" && \
  if ! "${CURRENT_DIR}"/system/dependencies.sh; then
    echo "Something went wrong" 2>&1
    exit 1;
  fi

  "${CURRENT_DIR}/system/bins.sh"

  chsh "${USER}" -s "$(command -v zsh)"

  ln -s "${CURRENT_DIR}/zsh/.zshrc" "${HOME}/.zshrc"

  echo "Preparing mise config.toml" && \
  mkdir --parents "${HOME}/.config/mise" && \
  ln -sf "${CURRENT_DIR}/system/mise_config.toml" "${HOME}/.config/mise/config.toml"

  "${CURRENT_DIR}/zsh/colors/index.sh"
  "${CURRENT_DIR}/alacritty/confs/user.sh"

  mkdir --parents "${HOME}/.omp"
  curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "${HOME}/.omp"
  git clone https://github.com/tmux-plugins/tpm.git "${HOME}/.tmux/plugins/tmux"

  ln -s "${CURRENT_DIR}/tmux/.tmux.conf" "${HOME}/.tmux.conf"
  "${HOME}/.tmux/plugins/tpm/bin/install_plugins"

  "${HOME}/.omp/oh-my-posh" font install 'UbuntuMono'
}

do_it "$@"
