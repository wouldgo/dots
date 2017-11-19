#!/usr/bin/env bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

! grep "/bin/zsh" /etc/shells > /dev/null || {
  echo "zsh it's already set" 2>&1
  exit 1;
} && \

# script gives up on any error
set -e && \

sudo ${CURRENT_DIR}/deps/apt.sh && \
sudo ${CURRENT_DIR}/deps/text-info.sh 6.5 && \
${CURRENT_DIR}/deps/powerline-fonts.sh && \

sudo ${CURRENT_DIR}/compile-zsh.sh
