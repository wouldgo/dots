#!/usr/bin/env bash

function do_it () {
  mkdir --parents "${HOME}/.omp"
  curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "${HOME}/.omp"

  "${HOME}/.omp/oh-my-posh" font install 'UbuntuMono'
}

do_it "$@"
