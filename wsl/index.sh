#!/usr/bin/env bash
function do_it () {
  local CURRENT_DIR

  CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

  echo "-- ORIGINAL --"
  printf "\r\n"
  cat "/etc/wsl.conf"
  printf "\r\n"
  echo "-- OWN --"
  printf "\r\n"
  cat "${CURRENT_DIR}/wsl.conf"

  read -rp "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

  ln -sf "${CURRENT_DIR}/wsl.conf" "/etc/wsl.conf"
}

do_it "$@"
