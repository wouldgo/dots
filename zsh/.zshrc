CONFS_FOLDER=~/git/confs/dots/zsh

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=10000

export NVM_DIR="${HOME}/.nvm"
export GVM_DIR="${HOME}/.gvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "${GVM_DIR}/scripts/gvm" ] && source "${GVM_DIR}/scripts/gvm"

#customizations
for FILE in ${CONFS_FOLDER}/helpers/*.zsh; do

  source ${FILE}
done

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

source ${CONFS_FOLDER}/antigen.zsh
source ${HOME}/.cargo/env
antigen use oh-my-zsh

antigen bundle mttrs/zsh-git-prompt
antigen bundle git
antigen bundle nvm
antigen bundle dgnest/zsh-gvm-plugin
antigen bundle docker

antigen theme https://github.com/wouldgo/bullet-train.zsh bullet-train

antigen bundle johanhaleby/kubetail
antigen bundle ahmetb/kubectx
antigen apply

ln -sf ~/.antigen/bundles/ahmetb/kubectx/completion/kubectx.zsh ~/.zsh/completion/_kubectx.zsh
ln -sf ~/.antigen/bundles/ahmetb/kubectx/completion/kubens.zsh ~/.zsh/completion/_kubens.zsh
ln -sf ~/.antigen/bundles/johanhaleby/kubetail/completion/kubetail.zsh ~/.zsh/completion/_kubetail.zsh

#Completion
fpath=(~/.zsh/completion $fpath)
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
