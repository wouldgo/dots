CONFS_FOLDER="${HOME}/git/confs/dots/zsh"
HISTFILE="${HOME}/.histfile"

ZSH_CACHE_DIR=/tmp
HISTSIZE=1000
SAVEHIST=10000

setopt +o nomatch

#customizations
eval `dircolors ${CONFS_FOLDER}/colors/nord-dircolors`
for FILE in ${CONFS_FOLDER}/helpers/*.{zsh,sh}; do

  source ${FILE}
done

source "${CONFS_FOLDER}/zsh_plugins.sh"

ln -sf $(${CONFS_FOLDER}/antibody path ahmetb/kubectx)/completion/_kubectx.zsh "${HOME}/.zsh/completion/_kubectx.zsh"
ln -sf $(${CONFS_FOLDER}/antibody path ahmetb/kubectx)/completion/_kubens.zsh "${HOME}/.zsh/completion/_kubens.zsh"
ln -sf $(${CONFS_FOLDER}/antibody path johanhaleby/kubetail)/completion/kubetail.zsh "${HOME}/.zsh/completion/_kubetail.zsh"

export PATH="${HOME}/.local/bin:$PATH"

#Completion
fpath+=( "${HOME}/.zsh/completion" )
autoload -Uz compinit && compinit -i
autoload -Uz add-zsh-hook
autoload -U select-word-style

zle -N __first_tab
bindkey '^I' __first_tab

if [ $commands[nvm] ]; then
  add-zsh-hook chpwd __load_nvmrc
  __load_nvmrc
fi

if [ $commands[conda] ]; then
  add-zsh-hook chpwd __load_conda
  __load_conda
fi

if [ $commands[gvm] ]; then
  add-zsh-hook chpwd __load_gvm
  __load_gvm
fi

select-word-style bash

zstyle ':completion:*' menu select
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==02}:${(s.:.)LS_COLORS}")';

zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:kill:*:processes' command 'ps xo pid,user:10,cmd | grep -v "sshd:|-zsh$"'
