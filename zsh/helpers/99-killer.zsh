#!/usr/bin/env zsh

function killer () {
  ps axuf | fzf | awk '{print $2}' | xargs kill
}
