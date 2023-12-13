#zmodload zsh/zprof

CONFS_FOLDER="${HOME}/git/confs/dots/zsh"
HISTFILE="${HOME}/.histfile"
ZSH_CACHE_DIR="${HOME}/.zsh/_cache"
ZSH_COMPLETION_FOLDER=${HOME}/.zsh/completion
KERNEL_RELEASE=$(uname --kernel-release)
WINDOWS_SUBSYSTEM_LINUX='WSL'
IS_WSL="NO"
if [[ $KERNEL_RELEASE == *"${WINDOWS_SUBSYSTEM_LINUX}"* ]]; then
  IS_WSL="YES"
fi

HISTSIZE=1000
SAVEHIST=10000

setopt HIST_IGNORE_ALL_DUPS

mkdir -p "${ZSH_CACHE_DIR}"
setopt +o nomatch

ln -sf $(${CONFS_FOLDER}/antibody path ahmetb/kubectx)/completion/_kubectx.zsh "${ZSH_COMPLETION_FOLDER}/_kubectx.zsh"
ln -sf $(${CONFS_FOLDER}/antibody path ahmetb/kubectx)/completion/_kubens.zsh "${ZSH_COMPLETION_FOLDER}/_kubens.zsh"
ln -sf $(${CONFS_FOLDER}/antibody path johanhaleby/kubetail)/completion/kubetail.zsh "${ZSH_COMPLETION_FOLDER}/_kubetail.zsh"

export PATH="${HOME}/.local/bin:$PATH"

#Completion
fpath+=( "${ZSH_COMPLETION_FOLDER}" )
autoload -U +X bashcompinit && bashcompinit
autoload -U +X compinit && compinit

#customizations
eval `dircolors ${CONFS_FOLDER}/colors/nord-dircolors`
for FILE in `ls ${CONFS_FOLDER}/helpers/*.{zsh,sh} | sort -g`; do

  source ${FILE}
  #echo "${FILE} loaded."
done

source "${CONFS_FOLDER}/zsh_plugins.sh"
autoload -Uz add-zsh-hook
autoload -U select-word-style

compdef __pnpm_completion pnpm

select-word-style bash

zstyle ':completion:*' menu select
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==02}:${(s.:.)LS_COLORS}")';

zle -N __first_tab
bindkey '^I' __first_tab

add-zsh-hook chpwd __load_node
add-zsh-hook chpwd __load_go
add-zsh-hook chpwd __load_python

__load_node
__load_go
__load_python

zle-line-init() {
  emulate -L zsh
  echoti smkx

  [[ $CONTEXT == start ]] || return 0

  while true; do
    zle .recursive-edit
    local -i ret=$?
    [[ $ret == 0 && $KEYS == $'\4' ]] || break
    [[ -o ignore_eof ]] || exit 0
  done

  local saved_prompt=$PROMPT
  local saved_rprompt=$RPROMPT
  PROMPT=$T_PROMPT
  RPROMPT=$T_RPROMPT
  zle .reset-prompt
  PROMPT=$saved_prompt
  RPROMPT=$saved_rprompt

  if (( ret )); then
    zle .send-break
  else
    zle .accept-line
  fi
  return ret
}

zle -N zle-line-init

#zprof
