#!/usr/bin/env bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

echo "Preparing git folder" && \
mkdir --parents --verbose ~/git/confs && \

echo "Updating system" && \
if ! "${CURRENT_DIR}"/system/update-system.sh; then
  echo "Something went wrong" 2>&1
fi

echo "Installing git secret command" && \
if ! "${CURRENT_DIR}"/system/install-git-secret.sh; then
  echo "Something went wrong" 2>&1
fi

echo "Removing workspace shortcuts" && \
if ! "${CURRENT_DIR}"/system/disable-workspace-keys.sh; then
  echo "Something went wrong" 2>&1
fi

echo "Fixing python" && \
if ! "${CURRENT_DIR}"/system/fix-python.sh; then
  echo "python alias wasn't usefull" 2>&1
fi

echo "Installing fonts" && \
if ! "${CURRENT_DIR}"/font/powerline-fonts.sh; then
  echo "font installation went wrong" 2>&1
fi

echo "Preparing shell configuration..." && \
if ! "${CURRENT_DIR}"/zsh/confs/user.sh; then
  echo "zsh configurations for ${USER} are already set" 2>&1
fi

echo "Preparing tmux configuration..." && \
if ! "${CURRENT_DIR}"/tmux/confs/user.sh; then
  echo "tmux configurations for ${USER} are already set" 2>&1
fi

echo "Preparing vim configuration..." && \
if ! "${CURRENT_DIR}"/vim/confs/user.sh; then
  echo "vim configurations for ${USER} are already set" 2>&1
fi

sudo apt install -y \
    zsh \
    tmux \
    vim

sudo chsh "${USER}" -s "$(command -v zsh)"
