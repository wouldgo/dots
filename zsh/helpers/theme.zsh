#!/usr/bin/env zsh

VIRTUAL_ENV_DISABLE_PROMPT=true

# CONTEXT
__THEME_CONTEXT_FG=default
__THEME_CONTEXT_HOSTNAME=%m

# STATUS
__THEME_STATUS_FG=green
__THEME_STATUS_ERROR_FG=red

# NVM
__THEME_NVM_FG=green
__THEME_NVM_PREFIX="⬡"

# Go
__THEME_GO_FG=cyan
__THEME_GO_PREFIX="go"

# Rust
__THEME_RUST_FG=red
__THEME_RUST_PREFIX="🦀"

# Kubernetes Context
__THEME_KCTX_FG=blue
__THEME_KCTX_PREFIX="⎈"

# VIRTUALENV
__THEME_VIRTUALENV_FG=yellow
__THEME_VIRTUALENV_PREFIX="🐍"

# DIR
__THEME_DIR_FG=white
__THEME_DIR_EXTENDED=1

# GIT
__THEME_GIT_FG=white

__THEME_GIT_BEHIND="⬇"
__THEME_GIT_AHEAD="⬆"
__THEME_GIT_STAGED="%F{green}✚"
__THEME_GIT_CONFLICTS="%F{red}✖"
__THEME_GIT_CHANGED="%F{blue}✹"
__THEME_GIT_UNTRACKED="%F{yellow}✭"
__THEME_GIT_CLEAN="%F{green}✓"

# SCREEN
__THEME_SCREEN_FG=white
__THEME_SCREEN_PREFIX="⬗"

# COMMAND EXECUTION TIME
__THEME_EXEC_TIME_ELAPSED=5
__THEME_EXEC_TIME_FG=yellow

# ------------------------------------------------------------------------------
# SEGMENT DRAWING
# A few functions to make it easy and re-usable to draw segmented prompts
# ------------------------------------------------------------------------------

CURRENT_FG='NONE'
OPEN_SEGMENT_SEPARATOR='\u27EA'
CLOSE_SEGMENT_SEPARATOR='\u27EB'

# Begin a segment
# prompt_segment foreground_color=default text=none ignore_separators=false
prompt_segment() {
  local __fg
  local __ignore_separators
  [[ -n $1 ]] && __fg="%F{$1}" || __fg="%f"
  [[ -n $3 ]] && __ignore_separators=$3 || __ignore_separators=false
  if [[ ${CURRENT_FG} != 'NONE' && $1 != ${CURRENT_FG} ]]; then

    echo -n "%{%k%F{${CURRENT_FG}}%}%{$__fg%}"
    if [[ ${__ignore_separators} != true ]]; then
      echo -n "${OPEN_SEGMENT_SEPARATOR}"
    fi
  else

    echo -n "%{%k%}%{$__fg%}"
    if [[ ${__ignore_separators} != true ]]; then
      echo -n "${OPEN_SEGMENT_SEPARATOR}"
    fi
  fi

  CURRENT_FG=$1
  if [[ -n $2 ]]; then

    echo -n "$2%F{${CURRENT_FG}}"
    if [[ $__ignore_separators != true ]]; then
      echo -n "${CLOSE_SEGMENT_SEPARATOR}"
    fi
  fi
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n ${CURRENT_FG} ]]; then
    echo -n "%{%k%F{${CURRENT_FG}}%}"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_FG='NONE'
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
  prompt_segment $__THEME_CONTEXT_FG "$(context)"
}

prompt_cmd_exec_time() {
  [ $___THEME_last_exec_duration -gt $__THEME_EXEC_TIME_ELAPSED ] && prompt_segment $__THEME_EXEC_TIME_FG "$(displaytime $___THEME_last_exec_duration)"
}

# Git
__theme_git_status () {
  precmd_update_git_vars
  local __status=()
  if [ -n "$__CURRENT_GIT_STATUS" ]; then
    __status+=($GIT_BRANCH)

    if [ "$GIT_AHEAD" -ne "0" ]; then
      __status+="$__THEME_GIT_AHEAD $GIT_AHEAD"
    fi

    if [ "$GIT_BEHIND" -ne "0" ]; then
      __status+="$__THEME_GIT_BEHIND $GIT_BEHIND"
    fi

    if [ "$GIT_STAGED" -ne "0" ]; then
      __status+="$__THEME_GIT_STAGED $GIT_STAGED"
    fi

    if [ "$GIT_CONFLICTS" -ne "0" ]; then
      __status+="$__THEME_GIT_CONFLICTS $GIT_CONFLICTS"
    fi

    if [ "$GIT_CHANGED" -ne "0" ]; then
      __status+="$__THEME_GIT_CHANGED $GIT_CHANGED"
    fi

    if [ "$GIT_UNTRACKED" -ne "0" ]; then
      __status+="$__THEME_GIT_UNTRACKED $GIT_UNTRACKED"
    fi

    if [ "$GIT_CHANGED" -eq "0" ] && [ "$GIT_CONFLICTS" -eq "0" ] && [ "$GIT_STAGED" -eq "0" ] && [ "$GIT_UNTRACKED" -eq "0" ]
    then
      __status+="$__THEME_GIT_CLEAN"
    fi
    echo -n "${(j: :)__status}"
  fi
}

prompt_git() {
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    local git_status="$(__theme_git_status)"

    prompt_segment $__THEME_GIT_FG $git_status
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

  prompt_segment $__THEME_DIR_FG $dir
}

# nvm
prompt_nvm() {
  if [[ (-f $(nvm_find_nvmrc)) ]]; then
    local nvm_prompt=$(nvm current 2>/dev/null)

    if [[ "${nvm_prompt}x" == "x" || "${nvm_prompt}" == "system" ]]; then
      return
    fi

    prompt_segment $__THEME_NVM_FG "${__THEME_NVM_PREFIX} ${nvm_prompt}"
  fi
}

# Go
prompt_go() {
  local current_dir="${1:-$(pwd)}"

  if [[ -f "${current_dir}/go.mod" && $(command -v go) ]]; then

    prompt_segment $__THEME_GO_FG $__THEME_GO_PREFIX" $(go version  | grep --colour=never -oE '[[:digit:]]+.[[:digit:]]+' | head -n 1)"
  elif [[ "${current_dir}" != '/' ]]; then

    prompt_go $(dirname ${current_dir})
  fi
}

# Rust
prompt_rust() {
  local current_dir="${1:-$(pwd)}"

  if [[ -f "${current_dir}/Cargo.toml" && $(command -v rustc) ]]; then

    prompt_segment $__THEME_RUST_FG $__THEME_RUST_PREFIX" $(rustc -V version | cut -d' ' -f2)"
  elif [[ "${current_dir}" != '/' ]]; then

    prompt_rust $(dirname ${current_dir})
  fi
}

# Kubernetes Context
prompt_kctx() {
  if [[ $(command -v kubectl) ]]; then
    local k8s_context=$(kubectl config view --minify --output "jsonpath={.current-context}{':'}{..namespace}" 2>/dev/null)

    if [[ -n $k8s_context ]]; then
      [[ $k8s_context =~ ^.*:$  ]] && k8s_context=${k8s_context%?}

      prompt_segment $__THEME_KCTX_FG $__THEME_KCTX_PREFIX" ${k8s_context}"
    fi
  fi
}

# Virtualenv: current working virtualenv
prompt_virtualenv() {
  local virtualenv_path="$VIRTUAL_ENV"
  if [[ -n $virtualenv_path && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
    prompt_segment $__THEME_VIRTUALENV_FG $__THEME_VIRTUALENV_PREFIX" $(python --version | sed 's/Python\ //g') ($(basename $virtualenv_path))"
  elif which pyenv &> /dev/null; then
    if [[ "$(pyenv version | sed -e 's/ (set.*$//' | tr '\n' ' ' | sed 's/.$//')" != "system" ]]; then
      prompt_segment $__THEME_VIRTUALENV_FG $__THEME_VIRTUALENV_PREFIX" $(pyenv version | sed -e 's/ (set.*$//' | tr '\n' ' ' | sed 's/.$//')"
    fi
  fi
}

# SCREEN Session
prompt_screen() {
  local session_name="$STY"
  if [[ "$session_name" != "" ]]; then
    prompt_segment $__THEME_SCREEN_FG $__THEME_SCREEN_PREFIX" $session_name"
  fi
}

# Status:
# - was there an error
# - are there background jobs?
prompt_status() {
  local _symbols=()
  local _jobs_count=$(jobs -l | wc -l)
  [[ ${RETVAL} -ne 0 ]] && _symbols+="\u2716 ${RETVAL}"
  [[ ${_jobs_count} -gt 0 ]] && _symbols+="\u2692 ${_jobs_count}"

  if [[ -n "${_symbols}" && ${RETVAL} -ne 0 ]]; then
    prompt_segment $__THEME_STATUS_ERROR_FG "${(j: :)_symbols}" true
  elif [[ -n "${_symbols}" ]]; then
    prompt_segment $__THEME_STATUS_FG "${(j: :)_symbols}" true
  fi
}

# ------------------------------------------------------------------------------
# MAIN
# Entry point
# ------------------------------------------------------------------------------

build_prompt() {
  RETVAL=$?
  #prompt_context
  #prompt_screen
  prompt_dir
  prompt_kctx
  prompt_virtualenv
  prompt_nvm
  prompt_go
  prompt_rust
  prompt_git
  prompt_cmd_exec_time
  prompt_status
  prompt_end
}

PROMPT='%{%f%b%k%}$(build_prompt)%{${fg_bold[default]}%} %(!.%F{red}# .%F{green}%f)%{$reset_color%}'
