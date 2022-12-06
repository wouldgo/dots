#!/usr/bin/env zsh

if [ $commands[kubectl] ] && [ ! -f "${HOME}/.zsh/completion/_kubectl.zsh" ]; then
  kubectl completion zsh | tee "${HOME}/.zsh/completion/_kubectl.zsh" >/dev/null

  alias k=kubectl
fi
