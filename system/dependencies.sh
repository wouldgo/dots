#!/usr/bin/env bash

sudo apt install -y \
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
  python3-venv && \

sudo update-alternatives --install /usr/bin/python python /usr/bin/python2 1 && \
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 2
