#!/usr/bin/env zsh

if [ $commands[kubectl] ]; then
  source <(kubectl completion zsh | sed '/"-f"/d')
fi

alias k=kubectl
