#zmodload zsh/zprof

CONFS_FOLDER="${HOME}/git/confs/dots/zsh"
HISTFILE="${HOME}/.histfile"
ZSH_CACHE_DIR="${HOME}/.zsh/_cache"

HISTSIZE=1000
SAVEHIST=10000

mkdir -p "${ZSH_CACHE_DIR}"
setopt +o nomatch

source "${CONFS_FOLDER}/zsh_plugins.sh"

ln -sf $(${CONFS_FOLDER}/antibody path ahmetb/kubectx)/completion/_kubectx.zsh "${HOME}/.zsh/completion/_kubectx.zsh"
ln -sf $(${CONFS_FOLDER}/antibody path ahmetb/kubectx)/completion/_kubens.zsh "${HOME}/.zsh/completion/_kubens.zsh"
ln -sf $(${CONFS_FOLDER}/antibody path johanhaleby/kubetail)/completion/kubetail.zsh "${HOME}/.zsh/completion/_kubetail.zsh"

export PATH="${HOME}/.local/bin:$PATH"

#Completion
fpath+=( "${HOME}/.zsh/completion" )
autoload -Uz compinit && compinit -i

#customizations
eval `dircolors ${CONFS_FOLDER}/colors/nord-dircolors`
for FILE in `ls ${CONFS_FOLDER}/helpers/*.{zsh,sh} | sort -g`; do

  source ${FILE}
  #echo "${FILE} loaded."
done

autoload -Uz add-zsh-hook
autoload -U select-word-style

compdef __pnpm_completion pnpm

select-word-style bash

zstyle ':completion:*' menu select
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==02}:${(s.:.)LS_COLORS}")';

zle -N __first_tab
bindkey '^I' __first_tab

if [ $commands[conda] ]; then
  add-zsh-hook chpwd __load_conda
  __load_conda
fi

if [ $commands[gvm] ]; then
  add-zsh-hook chpwd __load_gvm
  __load_gvm
fi

#zprof
