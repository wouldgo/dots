#!/usr/bin/env bash

sudo apt install -y \
  zsh \
  ttf-ancient-fonts \
  wget \
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
  libgdbm-dev \
  git \
  mercurial \
  make \
  binutils \
  gcc \
  cmake \
  pkg-config \
  python3-venv \
  python3-pip \
  gettext \
  xsel \
  libfreetype6-dev \
  libfontconfig1-dev \
  libxcb-xfixes0-dev \
  libxkbcommon-dev \
  unzip \
  zip \
  pavucontrol \
  kpartx \
  binfmt-support \
  qemu-kvm \
  qemu-user-static \
  e2fsprogs \
  dosfstools && \

sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1
