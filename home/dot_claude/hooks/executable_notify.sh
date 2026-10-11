#!/usr/bin/env bash
# Claude Code hook: desktop notification when Claude finishes (Stop) or needs
# input (Notification). The body holds the first 20 characters of the last
# user prompt, saved by the UserPromptSubmit event.
#   - GNOME and sway (mako): the notification closes after 20 seconds
#   - click: inside tmux selects Claude's pane; on sway also focuses the terminal
#     window (GNOME offers no way to focus another window: the click only closes)
set -euo pipefail

input=$(cat)

# jq comes from mise: fall back to it when jq is not in PATH
if command -v jq >/dev/null; then
  jq=(jq)
else
  jq=("${HOME}/.local/bin/mise" exec -- jq)
fi
field() { "${jq[@]}" -r "$1 // empty" <<<"${input}"; }

state_dir="${XDG_RUNTIME_DIR:-/tmp}/claude-notify"
session=$(field '.session_id')
prompt_file="${state_dir}/${session:-unknown}.prompt"

timeout_s=20
prompt_chars=20

# Walks up the process tree from $1 until a pid owning a sway window is found
sway_window_pid() {
  local pid=$1 pids
  pids=$(swaymsg -t get_tree | "${jq[@]}" -r '.. | .pid? // empty')
  while [ -n "${pid}" ] && [ "${pid}" -gt 1 ]; do
    grep -qx "${pid}" <<<"${pids}" && { echo "${pid}"; return 0; }
    pid=$(awk '{print $4}' "/proc/${pid}/stat" 2>/dev/null) || return 1
  done
  return 1
}

focus_claude() {
  local start_pid=$$ window_pid

  if [ -n "${TMUX:-}" ] && [ -n "${TMUX_PANE:-}" ]; then
    tmux select-window -t "${TMUX_PANE}" \; select-pane -t "${TMUX_PANE}" || true
    # The terminal window belongs to the tmux client, not to Claude's process tree
    start_pid=$(tmux display -p -t "${TMUX_PANE}" '#{client_pid}' 2>/dev/null || echo $$)
  fi

  if [ -n "${SWAYSOCK:-}" ] && window_pid=$(sway_window_pid "${start_pid}"); then
    swaymsg "[pid=${window_pid}] focus" >/dev/null || true
  fi
}

notify() { # title body
  local id action closer
  # -p prints the id, --wait then prints the clicked action (nothing when closed)
  notify-send --app-name "Claude Code" --expire-time $((timeout_s * 1000)) \
    --print-id --wait --action "default=Focus" "$1" "$2" | {
    read -r id || exit 0
    # GNOME ignores --expire-time: close the notification explicitly
    ( sleep "${timeout_s}"
      gdbus call --session --dest org.freedesktop.Notifications \
        --object-path /org/freedesktop/Notifications \
        --method org.freedesktop.Notifications.CloseNotification "${id}" >/dev/null 2>&1
    ) &
    closer=$!
    if read -r action && [ "${action}" = "default" ]; then
      focus_claude
    fi
    kill "${closer}" 2>/dev/null || true
  }
}

case "$(field '.hook_event_name')" in
  UserPromptSubmit)
    # Stdout of this event is added to Claude's context: print nothing
    mkdir -p "${state_dir}"
    field '.prompt' | "${jq[@]}" -Rrs --argjson n "${prompt_chars}" \
      'gsub("\\s+"; " ") | ltrimstr(" ") | rtrimstr(" ") | if length > $n then .[0:$n] + "…" else . end' \
      >"${prompt_file}"
    exit 0
    ;;
  Stop)
    title="Claude Code: done"
    ;;
  Notification)
    title="Claude Code: needs your input"
    ;;
  *)
    exit 0
    ;;
esac

project=$(basename "$(field '.cwd')")
[ -n "${project}" ] && title="${title} (${project})"
body=$(cat "${prompt_file}" 2>/dev/null || true)

# Detached: the hook returns at once, the notification lives on its own
notify "${title}" "${body}" </dev/null >/dev/null 2>&1 &
disown
