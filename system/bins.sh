#!/usr/bin/env bash

ENABLE_APPLE_KEYBOARD="NO"

KERNEL_RELEASE=$(uname --kernel-release)
WINDOWS_SUBSYSTEM_LINUX='WSL'
IS_WSL="NO"
if [[ $KERNEL_RELEASE == *"${WINDOWS_SUBSYSTEM_LINUX}"* ]]; then
  IS_WSL="YES"
fi

function git_config () {
  git config \
    --global pull.rebase true
  git config \
    --global user.name "wouldgo"
  git config \
    --global user.email would84@gmail.com
}

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

function rtx-cli () {
  local TMP_DIR

  TMP_DIR=$(mktemp -d)

  gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys 0x29DDE9E0
  curl https://rtx.pub/install.sh.sig | gpg --decrypt > "${TMP_DIR}/install.sh"
  sh "${TMP_DIR}/install.sh"
  rm -Rf "${TMP_DIR}"
}

function rustup () {
  echo "Installing rustup..." && \
  wget -O /tmp/rustup.sh https://sh.rustup.rs && \
  bash /tmp/rustup.sh -y &&
  rm -Rfv /tmp/rustup.sh
}

function ansible () {
  pip3 install ansible && \
  pip3 install ansible-lint
}

function alacritty () {
  local FOLDER
  local WITCH

  FOLDER=${HOME}/git/alacritty
  WITCH=$(loginctl show-session 2 -p Type | sed 's/^Type=//')

  git clone https://github.com/alacritty/alacritty.git "${FOLDER}" && \
  cd "${FOLDER}" && \
  cargo build --release --no-default-features --features="${WITCH}"

  if infocmp alacritty >/dev/null 2>&1; then
    echo "alacritty terminfo is already installed"
  else
    sudo tic -xe alacritty,alacritty-direct "${FOLDER}/extra/alacritty.info"
  fi

  sudo cp "${FOLDER}/target/release/alacritty" /usr/local/bin && \
  sudo cp "${FOLDER}/extra/logo/alacritty-term.svg" /usr/share/pixmaps/Alacritty.svg && \
  sudo desktop-file-install "${FOLDER}/extra/linux/Alacritty.desktop" && \
  sudo update-desktop-database && \

  cp -v extra/completions/_alacritty "${ZSH_COMPLETION_FOLDER}/_alacritty.zsh"
}

function apple_keyboard () {
  echo "Apple keyboard workaround" && \
  echo options hid_apple fnmode=2 | sudo tee -a /etc/modprobe.d/hid_apple.conf && \
  sudo update-initramfs -u -k all
}

function do_it () {
  git_config;
  rtx-cli;
  fzf;
  rustup;
  ansible;

  if [ "${IS_WSL}" == "NO" ]; then
    alacritty;

    if [ "${ENABLE_APPLE_KEYBOARD}" == "YES" ]; then
      apple_keyboard;
    fi
  fi
}

do_it "$@"
