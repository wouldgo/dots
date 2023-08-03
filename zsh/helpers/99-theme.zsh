#!/usr/bin/env zsh

__NORD0="#2E3440"
__NORD1="#3B4252"
__NORD2="#434C5E"
__NORD3="#4C566A"

__NORD4="#D8DEE9"
__NORD5="#E5E9F0"
__NORD6="#ECEFF4"

__NORD7="#8FBCBB"
__NORD8="#88C0D0"
__NORD9="#81A1C1"
__NORD10="#5E81AC"

__NORD11="#BF616A"
__NORD12="#D08770"
__NORD13="#EBCB8B"
__NORD14="#A3BE8C"
__NORD15="#B48EAD"

# Separators
__OPEN_SEPARATOR='\ue0b6'
__CLOSE_SEPARATOR='\ue0b4'

# STATUS
__THEME_STATUS_FG=green
__THEME_STATUS_BG=black

__THEME_STATUS_ERROR_FG=white
__THEME_STATUS_ERROR_BG=red

# NVM
__THEME_NVM_FG=black
__THEME_NVM_BG=green
__THEME_NVM_PREFIX="\ue718"

# Go
__THEME_GO_FG=black
__THEME_GO_BG=cyan
__THEME_GO_PREFIX="\ue627"

# Rust
__THEME_RUST_FG=black
__THEME_RUST_BG=red
__THEME_RUST_PREFIX="\ue68b"

# Kubernetes Context
__THEME_KCTX_FG=black
__THEME_KCTX_BG=blue
__THEME_KCTX_PREFIX="󱃾"

# PYTHON
__THEME_PYTHON_FG=black
__THEME_PYTHON_BG=yellow
__THEME_PYTHON_PREFIX="\ue606"

# DIR
__THEME_DIR_FG=white
__THEME_DIR_BG=${__NORD3}
__THEME_DIR_EXTENDED=1

# GIT
__THEME_GIT_FG=black
__THEME_GIT_BG=${__NORD12}

__THEME_GIT_BEHIND="⬇"
__THEME_GIT_AHEAD="⬆"
__THEME_GIT_STAGED="✚" #"%F{green}✚"
__THEME_GIT_CONFLICTS="✖" #"%F{red}✖"
__THEME_GIT_CHANGED="✹" #"%F{blue}✹"
__THEME_GIT_UNTRACKED="✭" #"%F{yellow}✭"
__THEME_GIT_CLEAN="✓" #"%F{green}✓"

# SCREEN
__THEME_SCREEN_FG=white
__THEME_SCREEN_PREFIX="⬗"

# COMMAND EXECUTION TIME
__THEME_EXEC_TIME_ELAPSED=5
__THEME_EXEC_TIME_FG=yellow
__THEME_EXEC_TIME_BG=black

# Begin a segment
# prompt_segment foreground_color=default text=none background_color=default
prompt_segment() {
  local __fg __bg
  local __separator_fg __separator_bg

  if [ -n ${1} ]; then
    __fg="%F{$1}"

    if [ -n ${3} ]; then
      __separator_fg="%F{$3}"
    else
      __separator_fg="%f"
    fi
  else
    __fg="%f"
  fi

  __separator_bg="%k"

  [[ -n ${3} ]] && __bg="%K{$3}" || __bg="%k"

  echo -n "%{${__separator_bg}%}%{${__separator_fg}%}${__OPEN_SEPARATOR}%{%k%f%}" #open separator style
  echo -n "%{${__bg}%}%{${__fg}%}${2}%{%k%f%}" #content style
  echo -n "%{${__separator_bg}%}%{${__separator_fg}%}${__CLOSE_SEPARATOR}%{%k%f%}" #close separator style
}

# End the prompt, closing any open segments
prompt_end() {
  echo -n "%{%k%f%}"
}

# ------------------------------------------------------------------------------
# PROMPT COMPONENTS
# Each component will draw itself, and hide itself if no information needs
# to be shown
# ------------------------------------------------------------------------------

# Based on http://stackoverflow.com/a/32164707/3859566
function displaytime {
  local T=$1
  local D=$((T/60/60/24))
  local H=$((T/60/60%24))
  local M=$((T/60%60))
  local S=$((T%60))
  [[ $D -gt 0 ]] && printf '%dd' $D
  [[ $H -gt 0 ]] && printf '%dh' $H
  [[ $M -gt 0 ]] && printf '%dm' $M
  printf '%ds' $S
}

prompt_cmd_exec_time() {
  if [ $___THEME_last_exec_duration -gt $__THEME_EXEC_TIME_ELAPSED ]; then
    prompt_segment $__THEME_EXEC_TIME_FG "$(displaytime $___THEME_last_exec_duration)" $__THEME_EXEC_TIME_BG
  fi
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

    prompt_segment $__THEME_GIT_FG $git_status $__THEME_GIT_BG
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

  prompt_segment $__THEME_DIR_FG $dir $__THEME_DIR_BG
}

# nvm
prompt_nvm() {
  if [[ (-f $(nvm_find_nvmrc)) ]]; then
    local nvm_prompt=$(nvm current 2>/dev/null)

    if [[ "${nvm_prompt}x" == "x" || "${nvm_prompt}" == "system" ]]; then
      return
    fi

    prompt_segment $__THEME_NVM_FG "${__THEME_NVM_PREFIX} ${nvm_prompt}" $__THEME_NVM_BG
  fi
}

# Go
prompt_go() {
  if [ ! -z ${__GO_PATH+x} ]; then
    prompt_segment $__THEME_GO_FG $__THEME_GO_PREFIX" $(go version  | grep --colour=never -oE '[[:digit:]]+.[[:digit:]]+' | head -n 1)" $__THEME_GO_BG
  fi
}

# Rust
prompt_rust() {
  local current_dir="${1:-$(pwd)}"

  if [[ -f "${current_dir}/Cargo.toml" && $(command -v rustc) ]]; then

    prompt_segment $__THEME_RUST_FG $__THEME_RUST_PREFIX" $(rustc -V version | cut -d' ' -f2)" $__THEME_RUST_BG
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

      prompt_segment $__THEME_KCTX_FG $__THEME_KCTX_PREFIX" ${k8s_context}" $__THEME_KCTX_BG
    fi
  fi
}

# Python: current working python
prompt_python() {
  if [ ! -z ${__PYTHON_PATH+x} ]; then
    prompt_segment $__THEME_PYTHON_FG $__THEME_PYTHON_PREFIX" $(python --version | sed 's/Python\ //g') ($(basename $__PYTHON_PATH))" $__THEME_PYTHON_BG
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
    prompt_segment $__THEME_STATUS_ERROR_FG "${(j: :)_symbols}" $__THEME_STATUS_ERROR_BG
  elif [[ -n "${_symbols}" ]]; then
    prompt_segment $__THEME_STATUS_FG "${(j: :)_symbols}" $__THEME_STATUS_BG
  fi
}

# ------------------------------------------------------------------------------
# MAIN
# Entry point
# ------------------------------------------------------------------------------

build_prompt_left() {
  #prompt_screen
  prompt_dir
  prompt_go
  prompt_nvm
  prompt_rust
  prompt_python
  prompt_status
}

build_prompt_right() {
  prompt_cmd_exec_time
  prompt_git
  prompt_kctx
  #prompt_end
}

# Prompt previous command execution time
preexec() {
  cmd_timestamp=$(date +%s)
}

precmd() {
  RETVAL=$?
  local stop
  stop=$(date +%s)
  local start=${cmd_timestamp:-$stop}
  let ___THEME_last_exec_duration=$stop-$start
  cmd_timestamp=''

  __THEME_L_PROMPT=$(build_prompt_left)
  __THEME_R_PROMPT=$(build_prompt_right)
}

prompt_length() {
  local -i x y=${#1} m
  if (( y )); then
    while (( ${${(%):-$1%$y(l.1.0)}[-1]} )); do
      x=y
      (( y *= 2 ))
    done
    while (( y > x + 1 )); do
      (( m = x + (y - x) / 2 ))
      (( ${${(%):-$1%$m(l.x.y)}[-1]} = m ))
    done
  fi
  echo $x
}

padding () {
  local L_VALUE=$(prompt_length $__THEME_L_PROMPT)
  local R_VALUE=$(prompt_length $__THEME_R_PROMPT)

  local PADDING=$(((COLUMNS - 1) - (L_VALUE + R_VALUE)))
  for ((i=0;i<PADDING;i++)); do
    print -n " "
  done
}

PROMPT='%{%f%b%k%}$__THEME_L_PROMPT$(padding)$__THEME_R_PROMPT%{${fg_bold[default]}%} %(!.%F{red}# .%F{green}%f)%{$reset_color%}'
