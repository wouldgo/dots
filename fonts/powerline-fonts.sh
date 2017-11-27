#!/usr/bin/env bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
FONT_FACE="Ubuntu Mono derivative Powerline"
FONT_SIZE="12"

[[ ! -f ${CURRENT_DIR}/../powerline-fonts ]] || {
  echo "powerline fonts are already downloaded" 2>&1
  exit 0;
} && \

git clone https://github.com/powerline/fonts.git ${CURRENT_DIR}/../powerline-fonts &&
${CURRENT_DIR}/../powerline-fonts/install.sh && \

#XXX sudo ${CURRENT_DIR}/font-system-console.sh && \
command -v gconftool-2 && {

  gconftool-2 --set /apps/gnome-terminal/profiles/Default/use_system_font --type=boolean false && \
  gconftool-2 --set /apps/gnome-terminal/profiles/Default/font --type string "${FONT_FACE} ${FONT_SIZE}"
} || {

  echo "No GNOME shell..." 2>&1
  exit 0;
}
