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
antigen use oh-my-zsh

antigen bundle mttrs/zsh-git-prompt
antigen bundle git
antigen bundle gulp
antigen bundle nvm
antigen bundle rust
antigen bundle docker
antigen bundle docker-compose

antigen theme https://github.com/wouldgo/bullet-train.zsh bullet-train
antigen apply

first-tab() {
  if [[ $#BUFFER == 0 ]]; then
    BUFFER="ls -al "
    CURSOR=7
    zle list-choices
  else
    zle expand-or-complete
  fi
}
zle -N first-tab
bindkey '^I' first-tab

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
