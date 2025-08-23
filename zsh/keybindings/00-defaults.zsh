HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=default,fg=green,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=default,fg=red,bold'

### THANKS TO https://wiki.archlinux.org/title/Zsh#Key_bindings

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Control-Up]="${terminfo[kUP5]}"
key[Control-Down]="${terminfo[kDN5]}"
key[Control-Right]="${terminfo[kRIT]}"
key[Control-Left]="${terminfo[kLFT]}"
key[Alt-Right]="${terminfo[arit]}"
key[Alt-Left]="${terminfo[alft]}"
key[F12]="${terminfo[kf12]}"

# setup key accordingly
[[ -n "${key[Home]}"          ]] && bindkey -- "${key[Home]}"           beginning-of-line
[[ -n "${key[End]}"           ]] && bindkey -- "${key[End]}"            end-of-line
[[ -n "${key[Backspace]}"     ]] && bindkey -- "${key[Backspace]}"      backward-delete-char
[[ -n "${key[Delete]}"        ]] && bindkey -- "${key[Delete]}"         delete-char
[[ -n "${key[Up]}"            ]] && bindkey -- "${key[Up]}"             up-line-or-history
[[ -n "${key[Down]}"          ]] && bindkey -- "${key[Down]}"           down-line-or-history
[[ -n "${key[Left]}"          ]] && bindkey -- "${key[Left]}"           backward-char
[[ -n "${key[Right]}"         ]] && bindkey -- "${key[Right]}"          forward-char
[[ -n "${key[PageUp]}"        ]] && bindkey -- "${key[PageUp]}"         beginning-of-line
[[ -n "${key[PageDown]}"      ]] && bindkey -- "${key[PageDown]}"       end-of-line

[[ -n "${key[Control-Up]}"    ]] && bindkey -- "${key[Control-Up]}"     history-substring-search-up
[[ -n "${key[Control-Down]}"  ]] && bindkey -- "${key[Control-Down]}"   history-substring-search-down
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}"  forward-word
[[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"   backward-word

[[ -n "${key[F12]}"           ]] && bindkey -s "${key[F12]}" 'tmux new-session -A -s session\n'

if [[ "${TERM}" != "tmux-256color" ]]; then
	[[ -n "${key[Alt-Right]}"   ]] && bindkey -- "${key[Alt-Right]}"      forward-word
	[[ -n "${key[Alt-Left]}"    ]] && bindkey -- "${key[Alt-Left]}"       backward-word
fi


# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi
