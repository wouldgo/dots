#zmodload zsh/zprof

DOTS_FOLDER="${HOME}/git/dots"
CONFS_FOLDER="${DOTS_FOLDER}/zsh"
HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTFILE="${HOME}/.zsh_history"
HISTDUP=erase

KERNEL_RELEASE=$(uname --kernel-release)
WINDOWS_SUBSYSTEM_LINUX='WSL'
IS_WSL=0
if [[ $KERNEL_RELEASE == *"${WINDOWS_SUBSYSTEM_LINUX}"* ]]; then
  IS_WSL=1
fi

# history
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

#customizations
eval `dircolors ${CONFS_FOLDER}/colors/gruvbox.dircolors`
for FILE in `ls ${CONFS_FOLDER}/helpers/*.{zsh,sh} | sort -g`; do

  source ${FILE}
  #echo "${FILE} loaded."
done

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light BreakingPitt/zsh-packer
zinit light StackExchange/blackbox

zinit snippet OMZP::ansible
zinit snippet OMZP::command-not-found
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::kubectx

zinit snippet https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/lib/history.zsh
zinit snippet https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/lib/grep.zsh
zinit snippet https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/lib/key-bindings.zsh

# completions
fpath+=( "${ZSH_COMPLETION_FOLDER}" )
autoload -U +X bashcompinit && bashcompinit
autoload -Uz compinit && compinit

zinit cdreplay -q

autoload -Uz add-zsh-hook

compdef __pnpm_completion pnpm

# completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

add-zsh-hook chpwd __load_node
add-zsh-hook chpwd __load_go
add-zsh-hook chpwd __load_python

__load_node
__load_go
__load_python

#zprof
