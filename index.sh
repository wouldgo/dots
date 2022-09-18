#!/usr/bin/env bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

echo "Preparing git folder" && \
mkdir --parents --verbose ~/git/confs && \

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

echo "Installing rbenv..." && \
curl -sL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer | bash -

echo "Installing rustup..." && \
wget -O /tmp/rustup.sh https://sh.rustup.rs && \
bash /tmp/rustup.sh -y &&
rm -Rfv /tmp/rustup.sh

echo "Installing sdkman" && \
curl -s "https://get.sdkman.io" | bash && \

echo "Installing gvm" && \
zsh < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer) && \

echo "Installing nvm" && \
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
