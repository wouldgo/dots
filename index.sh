#!/usr/bin/env bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

echo "Preparing git folder" && \
mkdir --parents --verbose "${HOME}/git/confs" && \

echo "Updating system" && \
if ! "${CURRENT_DIR}"/system/update-system.sh; then
  echo "Something went wrong" 2>&1
fi

echo "Installing dependencies" && \
if ! "${CURRENT_DIR}"/system/dependencies.sh; then
  echo "Something went wrong" 2>&1
  exit 1;
fi

echo "Removing workspace shortcuts" && \
if ! "${CURRENT_DIR}"/system/disable-workspace-keys.sh; then
  echo "Something went wrong" 2>&1
  exit 1;
fi

echo "Preparing shell configuration..." && \
if ! "${CURRENT_DIR}"/zsh/confs/user.sh; then
  echo "zsh configurations for ${USER} are already set" 2>&1
fi

echo "Creating zsh completion folder for ${USER}..." && \
mkdir --parents --verbose "${HOME}/.zsh/completion" && \

echo "Installing zsh tmux..." && \
sudo apt install -y \
    zsh \
    tmux && \

echo "Preparing tmux configuration..." && \
if ! "${CURRENT_DIR}"/tmux/confs/user.sh; then
  echo "tmux configurations for ${USER} are already set" 2>&1
fi

sudo chsh "${USER}" -s "$(command -v zsh)" && \

echo "Installing extra binaries..." && \
if ! "${CURRENT_DIR}"/system/bins.sh; then
  echo "Extra binaries for ${USER} are already set" 2>&1
fi
