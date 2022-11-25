CONFS_FOLDER="${HOME}/git/confs/dots/zsh"
HISTFILE="${HOME}/.histfile"

ZSH_CACHE_DIR=/tmp
HISTSIZE=1000
SAVEHIST=10000

setopt +o nomatch

export NVM_DIR="${HOME}/.nvm"
export GVM_DIR="${HOME}/.gvm"
[[ -s "${NVM_DIR}/nvm.sh" ]] && source "${NVM_DIR}/nvm.sh"
[[ -s "${GVM_DIR}/scripts/gvm" ]] && source "${GVM_DIR}/scripts/gvm"

#customizations
eval `dircolors ${CONFS_FOLDER}/colors/nord-dircolors`
for FILE in ${CONFS_FOLDER}/helpers/*.{zsh,sh}; do

  source ${FILE}
done

source "${HOME}/.cargo/env"
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

zle -N first-tab
bindkey '^I' first-tab

add-zsh-hook chpwd load-nvmrc
load-nvmrc

#add-zsh-hook chpwd load-virtualenv
#load-virtualenv

add-zsh-hook chpwd load-gvmrc
load-gvmrc

select-word-style bash

zstyle ':completion:*' menu select
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==02}:${(s.:.)LS_COLORS}")';

zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:kill:*:processes' command 'ps xo pid,user:10,cmd | grep -v "sshd:|-zsh$"'
