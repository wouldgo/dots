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

echo "Installing fonts" && \
if ! "${CURRENT_DIR}"/font/powerline-fonts.sh; then
  echo "font installation went wrong" 2>&1
fi

echo "Preparing shell configuration..." && \
if ! "${CURRENT_DIR}"/zsh/confs/user.sh; then
  echo "zsh configurations for ${USER} are already set" 2>&1
fi

echo "Creating zsh completion folder for ${USER}..." && \
mkdir --parents --verbose ~/.zsh/completion && \

echo "Preparing tmux configuration..." && \
if ! "${CURRENT_DIR}"/tmux/confs/user.sh; then
  echo "tmux configurations for ${USER} are already set" 2>&1
fi

echo "Preparing vim configuration..." && \
if ! "${CURRENT_DIR}"/vim/confs/user.sh; then
  echo "vim configurations for ${USER} are already set" 2>&1
fi

echo "Installing zsh tmux and vim..." && \
sudo apt install -y \
    zsh \
    tmux \
    vim && \

sudo chsh "${USER}" -s "$(command -v zsh)" && \

echo "Running script for completion in terminal" && \
"${CURRENT_DIR}"/zsh/completion.sh && \

echo "Installing rbenv..." && \
sudo apt install -y \
  curl \
  libssl-dev \
  libreadline-dev \
  zlib1g-dev \
  autoconf \
  bison \
  build-essential \
  libyaml-dev \
  libreadline-dev \
  libncurses5-dev \
  libffi-dev \
  libgdbm-dev && \
curl -sL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer | bash -

echo "Installing rustup..." && \
wget -O /tmp/rustup.sh https://sh.rustup.rs && \
bash /tmp/rustup.sh -y &&
rm -Rfv /tmp/rustup.sh && \

echo "Remeber to install:
  - https://github.com/nvm-sh/nvm
  - https://github.com/moovweb/gvm"
