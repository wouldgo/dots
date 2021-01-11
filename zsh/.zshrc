CONFS_FOLDER=~/git/confs/dots/zsh
ZSH=$(${CONFS_FOLDER}/antibody path ohmyzsh/ohmyzsh)

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=10000

#bullet-train
BULLETTRAIN_PROMPT_ORDER=(
    #time
    status
    #custom
    #context
    dir
    screen
    kctx
    #perl
    #ruby
    virtualenv
    nvm
    #aws
    go
    rust
    #elixir
    git
    #hg
    cmd_exec_time
  )

BULLETTRAIN_PROMPT_CHAR=""
BULLETTRAIN_PROMPT_SEPARATE_LINE=false
BULLETTRAIN_PROMPT_ADD_NEWLINE=false
BULLETTRAIN_GIT_PROMPT_CMD="\$(git_customized_status)"
BULLETTRAIN_GIT_EXTENDED=false

export NVM_DIR="${HOME}/.nvm"
export GVM_DIR="${HOME}/.gvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "${GVM_DIR}/scripts/gvm" ] && source "${GVM_DIR}/scripts/gvm"

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
