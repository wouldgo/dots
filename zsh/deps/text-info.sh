#!/usr/bin/env bash

[[ $EUID -eq 0 ]] && [ "$#" -eq 1 ] && ! command -v makeinfo || {
  echo "
  - your're not root;
  - you're not passing the version;
  - makeinfo is already installed." 2>&1
  exit 0;
} && \

VERSION=$1 && \

wget -O /tmp/texinfo.tar.xz http://ftp.gnu.org/gnu/texinfo/texinfo-${VERSION}.tar.xz && \

tar xvfJ /tmp/texinfo.tar.xz -C /tmp/ && \
cd /tmp/texinfo-${VERSION} && \

./configure && \
make -j5 && \
make install && \

cd - && \

rm -Rfv /tmp/texinfo*
