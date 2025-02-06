#!/usr/bin/env bash

function do_it () {
  local CURRENT_DIR
  CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

  curl -o "${CURRENT_DIR}/gruvbox.dircolors" https://raw.githubusercontent.com/twisty/dotfiles/master/gruvbox.dircolors
  sed -i '/^TERM alacritty$/d' "${CURRENT_DIR}/gruvbox.dircolors"
  awk '
    /^TERM / { last = NR }  # Track the last line number where TERM appears
    { lines[NR] = $0 }      # Store all lines
    END {
      for (i = 1; i <= NR; i++) {
        print lines[i]
        if (i == last) print "TERM alacritty"  # Insert TERM alacritty after last TERM line
      }
    }
  ' "${CURRENT_DIR}/gruvbox.dircolors" > "${CURRENT_DIR}/gruvbox.dircolors.temp" && \
  mv "${CURRENT_DIR}/gruvbox.dircolors.temp" "${CURRENT_DIR}/gruvbox.dircolors"
}

do_it "$@"
