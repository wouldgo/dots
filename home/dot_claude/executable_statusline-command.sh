#!/usr/bin/env bash
# Claude Code status line, following ~/git/dots/omp/omp.yaml (oh-my-posh) without
# depending on it, plus Claude info: model, context, cost, rate limits.
# Colors: gruvbox dark hard, true color.
input=$(cat)
field() { echo "$input" | jq -r "$1 // empty"; }

cwd=$(field '.workspace.current_dir // .cwd')
model=$(field '.model.display_name')
ctx=$(field '.context_window.used_percentage')
cost=$(field '.cost.total_cost_usd')
five_pct=$(field '.rate_limits.five_hour.used_percentage')
five_reset=$(field '.rate_limits.five_hour.resets_at')
week_pct=$(field '.rate_limits.seven_day.used_percentage')
week_reset=$(field '.rate_limits.seven_day.resets_at')

# gruvbox dark hard palette
fg() { printf '\033[38;2;%sm' "$1"; }
bg() { printf '\033[48;2;%sm' "$1"; }
R=$'\033[0m'
BG0_H='29;32;33'      # #1d2021
FG1='235;219;178'     # #ebdbb2
BG2='80;73;69'        # #504945
GRAY='146;131;116'    # #928374
RED='251;73;52'       # #fb4934
GREEN='184;187;38'    # #b8bb26
YELLOW='250;189;47'   # #fabd2f
BLUE='131;165;152'    # #83a598
AQUA='142;192;124'    # #8ec07c
ORANGE='254;128;25'   # #fe8019
DBLUE='69;133;136'    # #458588

SEP=" $(fg "$GRAY")│${R} "

badge() { # rgb text
  printf '%s%s %s %s' "$(bg "$1")" "$(fg "$BG0_H")" "$2" "$R"
}

# Usage color: green < 20%, yellow 20-69%, orange 70-89%, red >= 90%
usage_color() {
  local p=${1%%.*}
  if   [ "$p" -ge 90 ]; then echo "$RED"
  elif [ "$p" -ge 70 ]; then echo "$ORANGE"
  elif [ "$p" -ge 20 ]; then echo "$YELLOW"
  else echo "$GREEN"
  fi
}
pct() { # value -> colored "NN%", truncated like the thresholds (69.9 -> 69)
  printf '%s%s%%%s' "$(fg "$(usage_color "$1")")" "${1%%.*}" "$R"
}
bar() { # value -> 10-cell bar, filled part in the usage color (one cell per 10%)
  local p=${1%%.*} width=10 filled empty
  [ "$p" -gt 100 ] && p=100
  filled=$(( p * width / 100 ))
  empty=$(( width - filled ))
  printf '%s' "$(fg "$(usage_color "$1")")"
  [ "$filled" -gt 0 ] && printf '█%.0s' $(seq "$filled")
  printf '%s' "$(fg "$BG2")"
  [ "$empty" -gt 0 ] && printf '█%.0s' $(seq "$empty")
  printf '%s' "$R"
}

# --- path ------------------------------------------------------------

out="$(fg "$YELLOW")${cwd}${R}"

if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
  g() { git --no-optional-locks -C "$cwd" "$@" 2>/dev/null; }
  head=$(g symbolic-ref --short HEAD || g rev-parse --short HEAD)
  out="$out $(fg "$BLUE")${head}${R}"
fi

# --- Claude: model, context, cost --------------------------------------------

claude=""
[ -n "$model" ] && claude="$(fg "$FG1")${model}${R}"
[ -n "$ctx" ] && claude="$claude $(fg "$GRAY")Context: ${R} $(bar "$ctx") $(pct "$ctx")"
[ -n "$cost" ] && claude="$claude $(fg "$AQUA")$(printf '$%.2f' "$cost")${R}"
[ -n "$claude" ] && out="$out$SEP$claude"

# --- rate limits (claude.ai subscribers only): usage and reset time ----------

limits=""
if [ -n "$five_pct" ]; then
  limits="$(fg "$GRAY")5h${R} $(pct "$five_pct")"
  [ -n "$five_reset" ] && limits="$limits $(fg "$GRAY")↻ $(date -d "@$five_reset" '+%H:%M')${R}"
fi
if [ -n "$week_pct" ]; then
  [ -n "$limits" ] && limits="$limits  "
  limits="$limits$(fg "$GRAY")7d${R} $(pct "$week_pct")"
  [ -n "$week_reset" ] && limits="$limits $(fg "$GRAY")↻ $(date -d "@$week_reset" '+%a %H:%M')${R}"
fi
[ -n "$limits" ] && out="$out$SEP$limits"

printf '%s' "$out"
