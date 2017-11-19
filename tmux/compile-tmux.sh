#!/usr/bin/env bash

[[ $EUID -eq 0 ]] && [[ ! -d /tmp/tmux ]] || {
  echo "you're not root or the previous installation went bad" 2>&1
  exit 0;
} && \


git clone https://github.com/tmux/tmux.git /tmp/tmux && \
cd /tmp/tmux && \

VERSION=$(git describe --tags --abbrev=0) && \
git checkout $VERSION && \
./autogen.sh && \
./configure && \
make -j5 && \
make check && \
make install && \

cd - && \
rm -Rfv /tmp/tmux
