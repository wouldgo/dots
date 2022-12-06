#!/usr/bin/env zsh

if [ $commands[helm] ] && [ ! -f "${HOME}/.zsh/completion/_helm.zsh" ]; then
  helm completion zsh | tee "${HOME}/.zsh/completion/_helm.zsh" >/dev/null
fi
