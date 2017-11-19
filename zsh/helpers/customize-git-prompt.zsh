#!/usr/bin/env zsh

ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg[black]%}"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[green]%}%{●%G%}"
ZSH_THEME_GIT_PROMPT_CONFLICTS="%{$fg[magenta]%}%{✖%G%}"
ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[red]%}%{✚%G%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[black]%}%{↓%G%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[black]%}%{↑%G%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[black]%}%{…%G%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}%{✔%G%}"

git_customized_status() {
  precmd_update_git_vars
    if [ -n "$__CURRENT_GIT_STATUS" ]; then
    STATUS="$GIT_BRANCH "

    if [ "$GIT_BEHIND" -ne "0" ]; then
      STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_BEHIND $GIT_BEHIND "
    fi

    if [ "$GIT_AHEAD" -ne "0" ]; then
      STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_AHEAD $GIT_AHEAD "
    fi

    if [ "$GIT_STAGED" -ne "0" ]; then
      STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED $GIT_STAGED "
    fi

    if [ "$GIT_CONFLICTS" -ne "0" ]; then
      STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CONFLICTS $GIT_CONFLICTS "
    fi

    if [ "$GIT_CHANGED" -ne "0" ]; then
      STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CHANGED$GIT_CHANGED "
    fi

    if [ "$GIT_UNTRACKED" -ne "0" ]; then
      STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED $GIT_UNTRACKED "
    fi

    if [ "$GIT_CHANGED" -eq "0" ] && [ "$GIT_CONFLICTS" -eq "0" ] && [ "$GIT_STAGED" -eq "0" ] && [ "$GIT_UNTRACKED" -eq "0" ]; then
      STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CLEAN"
    fi

    echo "${STATUS}"
  fi
}
