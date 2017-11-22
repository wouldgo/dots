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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

first-tab() {
  if [[ $#BUFFER == 0 ]]; then
    BUFFER="ls -al "
    CURSOR=7
    zle list-choices
  else
    zle expand-or-complete
  fi
}

autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

zle -N first-tab
bindkey '^I' first-tab

add-zsh-hook chpwd load-nvmrc
load-nvmrc
