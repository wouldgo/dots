#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

[[ ! -f ~/.zshrc ]] || (
  echo "shell configurations are already done" 2>&1
  exit 1;
) && (
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.tar.gz" &&
  tar zxvf krew.tar.gz &&
  KREW=./krew-"${OS}_${ARCH}" &&
  "$KREW" install krew
) \

wget -O "${CURRENT_DIR}/colors/gnome-terminal.sh" https://raw.githubusercontent.com/arcticicestudio/nord-gnome-terminal/develop/src/nord.sh && \
wget -O "${CURRENT_DIR}/colors/gedit.xml" https://raw.githubusercontent.com/arcticicestudio/nord-gedit/develop/src/xml/nord.xml && \
wget -O "${CURRENT_DIR}/colors/nord-dircolors" https://raw.githubusercontent.com/arcticicestudio/nord-dircolors/develop/src/dir_colors && \

curl -sfL git.io/antibody | sh -s - -b "${CURRENT_DIR}/.." && \
"${CURRENT_DIR}/../antibody-update-plugins.sh" && \
ln -s "${CURRENT_DIR}/../.zshrc" ~/.zshrc && \

chmod u+x "${CURRENT_DIR}/colors/gnome-terminal.sh" && \
"${CURRENT_DIR}/colors/gnome-terminal.sh" --loglevel 4 && \
sudo cp -Rfv "${CURRENT_DIR}/colors/gedit.xml" /usr/share/gtksourceview-4/styles/nord.xml
