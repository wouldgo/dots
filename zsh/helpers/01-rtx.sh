#!/usr/bin/env bash

if [ -s "${HOME}/.local/share/rtx/bin/rtx" ]; then
  export RTX_TRUSTED_CONFIG_PATHS="${HOME}/.config/rtx/config.toml"

  eval "$("${HOME}"/.local/share/rtx/bin/rtx activate zsh)"
fi

if [ ! -f "${ZSH_COMPLETION_FOLDER}/_rtx.zsh" ]; then

  "${HOME}"/.local/share/rtx/bin/rtx completion zsh > "${ZSH_COMPLETION_FOLDER}/_rtx.zsh"
fi
