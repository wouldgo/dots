#!/usr/bin/env bash

function fzf () {
  local FZF_HIDDEN_FOLDER
  FZF_HIDDEN_FOLDER="${HOME}/.fzf"

  if [ -e "${FZF_HIDDEN_FOLDER}" ]; then

    echo "fzf already installed" 2>&1
    return
  fi

  git clone --depth 1 https://github.com/junegunn/fzf.git "${FZF_HIDDEN_FOLDER}" && \
  "${FZF_HIDDEN_FOLDER}/install" \
    --key-bindings \
    --completion \
    --no-update-rc \
    --no-bash \
    --no-fish
}

function nvim () {
  local NVIM_HIDDEN_FOLDER
  NVIM_HIDDEN_FOLDER="${HOME}/.nvim"

  if [ -e "${NVIM_HIDDEN_FOLDER}" ]; then

    echo "nvim already installed" 2>&1
    return
  fi

  mkdir -p "${NVIM_HIDDEN_FOLDER}" && \
  (cd "${NVIM_HIDDEN_FOLDER}"; curl -LOk https://github.com/neovim/neovim/releases/latest/download/nvim.appimage) && \
  chmod u+x "${NVIM_HIDDEN_FOLDER}/nvim.appimage" && \
  mv "${NVIM_HIDDEN_FOLDER}/nvim.appimage" "${NVIM_HIDDEN_FOLDER}/nvim"
}

function rbenv () {
  echo "Installing rbenv..." && \
  curl -sL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer | bash -
}

function rustup () {
  echo "Installing rustup..." && \
  wget -O /tmp/rustup.sh https://sh.rustup.rs && \
  bash /tmp/rustup.sh -y &&
  rm -Rfv /tmp/rustup.sh
}

function sdkman () {
  echo "Installing sdkman" && \
  curl -s "https://get.sdkman.io" | bash
  #shellcheck source=/dev/null
  source "${HOME}/.sdkman/bin/sdkman-init.sh"
}

function gvm () {
  echo "Installing gvm" && \
  zsh < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
}

function nvm () {
  echo "Installing nvm" && \
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
}

function miniforge () {
  echo "Installing miniforge" && \
  DIR=$(mktemp) && \
  wget -P "${DIR}" https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh && \
  chmod u+x "${DIR}/Miniforge3-Linux-x86_64.sh" && \
  bash "${DIR}/Miniforge3-Linux-x86_64.sh" -p "${HOME}/.miniforge3" -b -u && \
  rm -Rfv "${DIR}"
}

function kubectl () {
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
  kubectl version --client
}

function ripgrep () {
  cargo install ripgrep
}

function apple_keyboard () {
  echo "Apple keyboard workaround" && \
  echo options hid_apple fnmode=2 | sudo tee -a /etc/modprobe.d/hid_apple.conf && \
  sudo update-initramfs -u -k all
}

function do_it () {
  fzf;
  nvim;
  rbenv;
  rustup;
  sdkman;
  gvm;
  nvm;
  miniforge;
  kubectl;
#  ripgrep;
  apple_keyboard;
}

do_it "$@"
