#!/usr/bin/env zsh

function __mise_bootstrap () {
  if [ -s "${HOME}/.local/bin/mise" ]; then
    export MISE_TRUSTED_CONFIG_PATHS="${HOME}/.config/mise/config.toml"

    eval "$("${HOME}"/.local/bin/mise activate zsh)"

    # path=(
    #   "${HOME}/.local/share/mise/shims"
    #   $path)
    # export PATH
  fi

  if [ ! -f "${ZSH_COMPLETION_FOLDER}/_mise.zsh" ]; then

    "${HOME}"/.local/bin/mise completion zsh > "${ZSH_COMPLETION_FOLDER}/_mise.zsh"
  fi
}

__mise_bootstrap
