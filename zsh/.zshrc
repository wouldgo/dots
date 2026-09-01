#zmodload zsh/zprof

export TERM=alacritty
ZSHRC_LS_COMMAND="/bin/ls"

ZSHRC_DOTS_FOLDER="${HOME}/git/dots"
ZSHRC_CONFS_FOLDER="${ZSHRC_DOTS_FOLDER}/zsh"

KERNEL_RELEASE=$(uname --kernel-release)
WINDOWS_SUBSYSTEM_LINUX='WSL'
IS_WSL=0
if [[ $KERNEL_RELEASE == *"${WINDOWS_SUBSYSTEM_LINUX}"* ]]; then
  IS_WSL=1
fi

#customizations
eval `dircolors ${ZSHRC_CONFS_FOLDER}/colors/gruvbox.dircolors`
for FILE in `${ZSHRC_LS_COMMAND} -L ${ZSHRC_CONFS_FOLDER}/helpers/*.{zsh,sh} | sort -g`; do

  source ${FILE}
  #echo "helper ${FILE} loaded."
done

for FILE in `${ZSHRC_LS_COMMAND} -L ${ZSHRC_CONFS_FOLDER}/zinit/_setup/*.sh | sort -g`; do
  source ${FILE}
  #echo "zinit setup ${FILE} loaded"
done

# completions
fpath+=( "${ZSH_COMPLETION_FOLDER}" )
autoload -U +X bashcompinit && bashcompinit
autoload -Uz compinit && compinit

zinit cdreplay -q

autoload -Uz add-zsh-hook

for FILE in `${ZSHRC_LS_COMMAND} -L ${ZSHRC_CONFS_FOLDER}/keybindings/*.zsh | sort -g`; do

  source ${FILE}
  #echo "config ${FILE} loaded."
done

# completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1lh --git-ignore --group-directories-first --sort=accessed --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1lh --git-ignore --group-directories-first --sort=accessed --color=always $realpath'

add-zsh-hook chpwd __load_node
add-zsh-hook chpwd __load_go
add-zsh-hook chpwd __load_python

__load_node
__load_go
__load_python

#zprof
