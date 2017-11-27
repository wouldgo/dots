#!/usr/bin/env bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

COMPILE=${1:-'false'}

echo "Preparing git folder" && \
mkdir --parents --verbose ~/git/confs && \

echo "Removing workspace shortcuts" && \
if ! ${CURRENT_DIR}/system/disable-workspace-keys.sh; then
  echo "Something went wrong" 2>&1
fi

echo "Fixing python" && \
if ! ${CURRENT_DIR}/system/fix-python.sh; then
  echo "python alias wasn't usefull" 2>&1
fi

echo "Installing fonts" && \
if ! ${CURRENT_DIR}/font/powerline-fonts.sh; then
  echo "font installation went wrong" 2>&1
fi

echo "Preparing shell configuration..." && \
if ! ${CURRENT_DIR}/zsh/confs/user.sh; then
  echo "zsh configurations for ${USER} are already set" 2>&1
fi

echo "Preparing tmux configuration..." && \
if ! ${CURRENT_DIR}/tmux/confs/user.sh; then
  echo "tmux configurations for ${USER} are already set" 2>&1
fi

echo "Preparing vim configuration..." && \
if ! ${CURRENT_DIR}/vim/confs/user.sh; then
  echo "vim configurations for ${USER} are already set" 2>&1
fi

if [[ ${COMPILE} == false ]]; then
  echo "Installing from packages..." && \

  sudo apt install -y \
    zsh \
    tmux \
    vim
else

  echo "Preparing shell..." &&
  if ! ${CURRENT_DIR}/zsh/build.sh; then
    echo "zsh installation skipped" 2>&1
  fi

  if ! ${CURRENT_DIR}/tmux/build.sh; then
    echo "tmux installation skipped" 2>&1
  fi
fi

sudo chsh $USER -s "$(command -v zsh)"
