CONFS_FOLDER=~/git/confs/dots/zsh

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=10000

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
    perl
    ruby
    virtualenv
    nvm
    aws
    go
    rust
    elixir
    git
    hg
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
antigen bundle docker

antigen theme https://github.com/wouldgo/bullet-train.zsh bullet-train
antigen apply

#Completion
fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit && compinit -i

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

autoload -U add-zsh-hook

zle -N first-tab
bindkey '^I' first-tab

add-zsh-hook chpwd load-nvmrc
load-nvmrc

add-zsh-hook chpwd load-virtualenv
load-virtualenv
