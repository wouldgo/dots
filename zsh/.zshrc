CONFS_FOLDER=~/git/confs/dots/zsh
ZSH=$(${CONFS_FOLDER}/antibody path ohmyzsh/ohmyzsh)

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=10000

export NVM_DIR="${HOME}/.nvm"
export GVM_DIR="${HOME}/.gvm"
[[ -s "${NVM_DIR}/nvm.sh" ]] && source "${NVM_DIR}/nvm.sh"
[[ -s "${GVM_DIR}/scripts/gvm" ]] && source "${GVM_DIR}/scripts/gvm"

#customizations
for FILE in ${CONFS_FOLDER}/helpers/*.zsh; do

  source ${FILE}
done

source ${HOME}/.cargo/env
source ${CONFS_FOLDER}/zsh_plugins.sh

ln -sf $(${CONFS_FOLDER}/antibody path ahmetb/kubectx)/completion/kubectx.zsh ~/.zsh/completion/_kubectx.zsh
ln -sf $(${CONFS_FOLDER}/antibody path ahmetb/kubectx)/completion/kubens.zsh ~/.zsh/completion/_kubens.zsh
ln -sf $(${CONFS_FOLDER}/antibody path johanhaleby/kubetail)/completion/kubetail.zsh ~/.zsh/completion/_kubetail.zsh

export PATH="${HOME}/.local/bin:$PATH"

#Completion
fpath+=( ~/.zsh/completion )
autoload -Uz compinit && compinit -i

autoload -U add-zsh-hook

zle -N first-tab
bindkey '^I' first-tab

add-zsh-hook chpwd load-nvmrc
load-nvmrc

add-zsh-hook chpwd load-virtualenv
load-virtualenv

add-zsh-hook chpwd load-gvmrc
load-gvmrc
