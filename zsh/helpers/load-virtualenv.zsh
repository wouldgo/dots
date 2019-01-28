#!/usr/bin/env zsh

load-virtualenv() {
  if [[ -f ".venv" ]]; then
    _VENV_PATH=$VENV_HOME/$(cat .venv)

    # Check to see if already activated to avoid redundant activating
    if [[ "$VIRTUAL_ENV" != $_VENV_PATH ]]; then
      source $_VENV_PATH/bin/activate
    fi
  elif [ -n "$VIRTUAL_ENV" ]; then

    deactivate
  fi
}
