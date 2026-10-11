__copy_command() {
	echo -n "${BUFFER}" | xsel --clipboard --input
	zle -M "'${BUFFER}' copied to clipboard"
}

zle -N __copy_command
bindkey -- "^Xc" __copy_command
