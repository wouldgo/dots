#!/usr/bin/env zsh

VIRTUAL_ENV_DISABLE_PROMPT=true

# CONTEXT
__THEME_CONTEXT_BG=default
__THEME_CONTEXT_FG=black
__THEME_CONTEXT_HOSTNAME=%m

# STATUS
__THEME_STATUS_EXIT_SHOW=false
__THEME_STATUS_BG=green
__THEME_STATUS_ERROR_BG=red
__THEME_STATUS_FG=white

# NVM
__THEME_NVM_BG=green
__THEME_NVM_FG=black
__THEME_NVM_PREFIX="⬡"

# Go
__THEME_GO_BG=cyan
__THEME_GO_FG=black
__THEME_GO_PREFIX="go"

# Rust
__THEME_RUST_BG=red
__THEME_RUST_FG=black
__THEME_RUST_PREFIX="🦀"

# Kubernetes Context
__THEME_KCTX_BG=magenta
__THEME_KCTX_FG=black
__THEME_KCTX_PREFIX="⎈"

# VIRTUALENV
__THEME_VIRTUALENV_BG=yellow
__THEME_VIRTUALENV_FG=black
__THEME_VIRTUALENV_PREFIX=🐍

# DIR
__THEME_DIR_BG=blue
__THEME_DIR_FG=black
__THEME_DIR_EXTENDED=1

# GIT
__THEME_GIT_BG=white
__THEME_GIT_FG=black

__THEME_GIT_BEHIND="⬇"
__THEME_GIT_AHEAD="⬆"
__THEME_GIT_STAGED="%F{green}✚%F{black}"
__THEME_GIT_CONFLICTS="%F{red}✘%F{black}"
__THEME_GIT_CHANGED="%F{blue}✹%F{black}"
__THEME_GIT_UNTRACKED="%F{yellow}✭%F{black}"
__THEME_GIT_CLEAN="%F{green}✓%F{black}"

# SCREEN
__THEME_SCREEN_BG=white
__THEME_SCREEN_FG=black
__THEME_SCREEN_PREFIX="⬗"

# COMMAND EXECUTION TIME
__THEME_EXEC_TIME_ELAPSED=5
__THEME_EXEC_TIME_BG=yellow
__THEME_EXEC_TIME_FG=black

# ------------------------------------------------------------------------------
# SEGMENT DRAWING
# A few functions to make it easy and re-usable to draw segmented prompts
# ------------------------------------------------------------------------------

CURRENT_BG='NONE'
SEGMENT_SEPARATOR=''

# Begin a segment
# Takes three arguments, background, foreground and text. All of them can be omitted,
# rendering default background/foreground and no text.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

# ------------------------------------------------------------------------------
# PROMPT COMPONENTS
# Each component will draw itself, and hide itself if no information needs
# to be shown
# ------------------------------------------------------------------------------

# Context: user@hostname (who am I and where am I)
context() {
  local user="$(whoami)"
  [[ "$user" != "$__THEME_CONTEXT_DEFAULT_USER" || -n "$__THEME_IS_SSH_CLIENT" ]] && echo -n "${user}@$__THEME_CONTEXT_HOSTNAME"
}

# Based on http://stackoverflow.com/a/32164707/3859566
function displaytime {
  local T=$1
  local D=$((T/60/60/24))
  local H=$((T/60/60%24))
  local M=$((T/60%60))
  local S=$((T%60))
  [[ $D > 0 ]] && printf '%dd' $D
  [[ $H > 0 ]] && printf '%dh' $H
  [[ $M > 0 ]] && printf '%dm' $M
  printf '%ds' $S
}

# Prompt previous command execution time
preexec() {
  cmd_timestamp=`date +%s`
}

precmd() {
  local stop=`date +%s`
  local start=${cmd_timestamp:-$stop}
  let ___THEME_last_exec_duration=$stop-$start
  cmd_timestamp=''
}

prompt_context() {
  prompt_segment $__THEME_CONTEXT_BG $__THEME_CONTEXT_FG "$(context)"
}

prompt_cmd_exec_time() {
  [ $___THEME_last_exec_duration -gt $__THEME_EXEC_TIME_ELAPSED ] && prompt_segment $__THEME_EXEC_TIME_BG $__THEME_EXEC_TIME_FG "$(displaytime $___THEME_last_exec_duration)"
}

# Git
__theme_git_status () {
  precmd_update_git_vars
  if [ -n "$__CURRENT_GIT_STATUS" ]; then
    STATUS="$GIT_BRANCH "

    if [ "$GIT_AHEAD" -ne "0" ]; then
      STATUS="$STATUS$__THEME_GIT_AHEAD $GIT_AHEAD "
    fi

    if [ "$GIT_BEHIND" -ne "0" ]; then
      STATUS="$STATUS$__THEME_GIT_BEHIND $GIT_BEHIND "
    fi

    if [ "$GIT_STAGED" -ne "0" ]; then
      STATUS="$STATUS$__THEME_GIT_STAGED $GIT_STAGED "
    fi

    if [ "$GIT_CONFLICTS" -ne "0" ]; then
      STATUS="$STATUS$__THEME_GIT_CONFLICTS $GIT_CONFLICTS "
    fi

    if [ "$GIT_CHANGED" -ne "0" ]; then
      STATUS="$STATUS$__THEME_GIT_CHANGED $GIT_CHANGED "
    fi

    if [ "$GIT_UNTRACKED" -ne "0" ]; then
      STATUS="$STATUS$__THEME_GIT_UNTRACKED $GIT_UNTRACKED "
    fi

    if [ "$GIT_CHANGED" -eq "0" ] && [ "$GIT_CONFLICTS" -eq "0" ] && [ "$GIT_STAGED" -eq "0" ] && [ "$GIT_UNTRACKED" -eq "0" ]
    then
      STATUS="$STATUS$__THEME_GIT_CLEAN"
    fi
    echo "${STATUS}"
  fi
}


prompt_git() {
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    local git_status="$(__theme_git_status)"

    prompt_segment $__THEME_GIT_BG $__THEME_GIT_FG $git_status
  fi
}

# Dir: current working directory
prompt_dir() {
  local dir=''

  if [[ $__THEME_DIR_EXTENDED == 0 ]]; then
    #short directories
    dir="${dir}%1~"
  elif [[ $__THEME_DIR_EXTENDED == 2 ]]; then
    #long directories
    dir="${dir}%0~"
  else
    #medium directories (default case)
    dir="${dir}%4(c:...:)%3c"
  fi

  prompt_segment $__THEME_DIR_BG $__THEME_DIR_FG $dir
}

# nvm
prompt_nvm() {
  if [[ (-f $(nvm_find_nvmrc)) ]]; then
    local nvm_prompt=$(nvm current 2>/dev/null)

    if [[ "${nvm_prompt}x" == "x" || "${nvm_prompt}" == "system" ]]; then
      return
    fi

    prompt_segment $__THEME_NVM_BG $__THEME_NVM_FG "${__THEME_NVM_PREFIX} ${nvm_prompt}"
  fi
}

# Go
prompt_go() {
  local current_dir="${1:-$(pwd)}"

  if [[ -f "${current_dir}/go.mod" && $(command -v go) ]]; then

    prompt_segment $__THEME_GO_BG $__THEME_GO_FG $__THEME_GO_PREFIX" $(go version  | grep --colour=never -oE '[[:digit:]]+.[[:digit:]]+' | head -n 1)"
  elif [[ "${current_dir}" != '/' ]]; then

    prompt_go $(dirname ${current_dir})
  fi
}

# Rust
prompt_rust() {
  local current_dir="${1:-$(pwd)}"

  if [[ -f "${current_dir}/Cargo.toml" && $(command -v rustc) ]]; then

    prompt_segment $__THEME_RUST_BG $__THEME_RUST_FG $__THEME_RUST_PREFIX" $(rustc -V version | cut -d' ' -f2)"
  elif [[ "${current_dir}" != '/' ]]; then

    prompt_rust $(dirname ${current_dir})
  fi
}

# Kubernetes Context
prompt_kctx() {
  if [[ $(command -v kubectl) ]]; then
    local k8s_context=$(kubectl config view --minify --output "jsonpath={.current-context}{':'}{..namespace}" 2>/dev/null)

    [[ $k8s_context =~ ^.*:$  ]] && k8s_context=${k8s_context%?}

    prompt_segment $__THEME_KCTX_BG $__THEME_KCTX_FG $__THEME_KCTX_PREFIX" ${k8s_context}"
  fi
}

# Virtualenv: current working virtualenv
prompt_virtualenv() {
  local virtualenv_path="$VIRTUAL_ENV"
  if [[ -n $virtualenv_path && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
    prompt_segment $__THEME_VIRTUALENV_BG $__THEME_VIRTUALENV_FG $__THEME_VIRTUALENV_PREFIX" $(python --version | sed 's/Python\ //g') ($(basename $virtualenv_path))"
  elif which pyenv &> /dev/null; then
    if [[ "$(pyenv version | sed -e 's/ (set.*$//' | tr '\n' ' ' | sed 's/.$//')" != "system" ]]; then
      prompt_segment $__THEME_VIRTUALENV_BG $__THEME_VIRTUALENV_FG $__THEME_VIRTUALENV_PREFIX" $(pyenv version | sed -e 's/ (set.*$//' | tr '\n' ' ' | sed 's/.$//')"
    fi
  fi
}

# SCREEN Session
prompt_screen() {
  local session_name="$STY"
  if [[ "$session_name" != "" ]]; then
    prompt_segment $__THEME_SCREEN_BG $__THEME_SCREEN_FG $__THEME_SCREEN_PREFIX" $session_name"
  fi
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 && $__THEME_STATUS_EXIT_SHOW != true ]] && symbols+="✘"
  [[ $RETVAL -ne 0 && $__THEME_STATUS_EXIT_SHOW == true ]] && symbols+="✘ $RETVAL"
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡%f"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="⚙"

  if [[ -n "$symbols" && $RETVAL -ne 0 ]]; then
    prompt_segment $__THEME_STATUS_ERROR_BG $__THEME_STATUS_FG "$symbols"
  elif [[ -n "$symbols" ]]; then
    prompt_segment $__THEME_STATUS_BG $__THEME_STATUS_FG "$symbols"
  fi

}

# ------------------------------------------------------------------------------
# MAIN
# Entry point
# ------------------------------------------------------------------------------

build_prompt() {
  RETVAL=$?
  prompt_status
  #prompt_context
  prompt_dir
  prompt_screen
  prompt_kctx
  prompt_virtualenv
  prompt_nvm
  prompt_go
  prompt_rust
  prompt_git
  prompt_cmd_exec_time
  prompt_end
}

PROMPT='%{%f%b%k%}$(build_prompt)%{${fg_bold[default]}%} %(!.%F{red}# .%F{green}%f)%{$reset_color%}'
