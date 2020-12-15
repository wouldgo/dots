#!/usr/bin/env zsh

if [ $commands[helm] ] && [ ! -f "~/.zsh/completion/_helm.zsh" ]; then
  helm completion zsh > ~/.zsh/completion/_helm.zsh
fi
