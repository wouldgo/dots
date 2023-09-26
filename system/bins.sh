#!/usr/bin/env bash

function git_config () {
  git config \
    --global pull.rebase true
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

function rustup () {
  echo "Installing rustup..." && \
  wget -O /tmp/rustup.sh https://sh.rustup.rs && \
  bash /tmp/rustup.sh -y &&
  rm -Rfv /tmp/rustup.sh
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

function websocat () {
  cargo install \
    --features=ssl \
    websocat
}

function operator_sdk () {
  curl -LO "https://github.com/operator-framework/operator-sdk/releases/latest/download/operator-sdk_linux_amd64" && \
  mv -v operator-sdk_linux_amd64 operator-sdk && \
  sudo install -o root -g root -m 0755 operator-sdk /usr/local/bin/operator-sdk && \
  operator-sdk version
}

function krew () {
  cd "$(mktemp -d)" && \
  OS="$(uname | tr '[:upper:]' '[:lower:]')" && \
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" && \
  KREW="krew-${OS}_${ARCH}" && \
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" && \
  tar zxvf "${KREW}.tar.gz" && \
  ./"${KREW}" install krew
}

function do_it () {
  # git_config;
  # ansible;
  # fzf;
  # nvim;
  # rustup;
  # miniforge;
  # kubectl;
  # operator_sdk;
  # krew;
  # apple_keyboard;
  # alacritty;
  # ripgrep;
  # websocat;
  rtx-cli;
}

do_it "$@"
