typeset -g -A key

key=(
  Home          '^[[1~ ^[[H ^[OH'
  End           '^[[4~ ^[[F ^[OF'
  Backspace     '^?'
  Delete        '^[[3~'
  Up            '^[[A'
  Down          '^[[B'
  Left          '^[[D'
  Right         '^[[C'
  PageUp        '^[[5~'
  PageDown      '^[[6~'
  Control-Up    '^[[1;5A'
  Control-Down  '^[[1;5B'
  Control-Right '^[[1;5C'
  Control-Left  '^[[1;5D'
  Alt-Right     '^[[1;3C'
  Alt-Left      '^[[1;3D'
  F12           '^[[24~'
)

# Helper that binds every sequence stored under a key
bind_key() {
  local k="$1" widget="$2"
  local seq
  # If the key does not exist or is empty, return without errors
  [[ -z "${key[$k]}" ]] && return

  for seq in ${=key[$k]}; do
    bindkey "$seq" "$widget"
  done
}

# --- BINDINGS ZLE ---

bind_key Home           beginning-of-line
bind_key End            end-of-line
bind_key Backspace      backward-delete-char
bind_key Delete         delete-char
bind_key Up             atuin-history-up
bind_key Down           atuin-history-down
bind_key Left           backward-char
bind_key Right          forward-char
bind_key PageUp         beginning-of-line
bind_key PageDown       end-of-line
bind_key Control-Up     atuin-history-fulltext-up
bind_key Control-Down   atuin-history-fulltext-down
bind_key Control-Right  forward-word
bind_key Control-Left   backward-word
bind_key Alt-Right      forward-word
bind_key Alt-Left       backward-word

# F12 macro: -s treats the string as a key sequence to send
if [[ -n "${key[F12]}" ]]; then
  for seq in ${=key[F12]}; do
    bindkey -s "$seq" 'tmux new-session -A -s session\n'
  done
fi
