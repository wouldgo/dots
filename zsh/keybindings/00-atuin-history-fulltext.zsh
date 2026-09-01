#!/usr/bin/env zsh

# Ctrl-Up / Ctrl-Down: navigate fulltext Atuin history results
#
# Ctrl-Up   -> older result
# Ctrl-Down -> newer result
#
# The first invocation uses the current $BUFFER as the query.
# Subsequent invocations navigate the same result set.
#
# If the user edits the buffer, a new search is started.

# global configuration
: ${ATUIN_HISTORY_SEARCH_FILTER_MODE='session'}

typeset -g _ATUIN_FULLTEXT_INITIAL=""
typeset -g _ATUIN_FULLTEXT_QUERY=""
typeset -g _ATUIN_FULLTEXT_CURRENT=""
typeset -g _ATUIN_FULLTEXT_OFFSET=-1

_atuin_history_fulltext_reset() {
  _ATUIN_FULLTEXT_INITIAL=""
  _ATUIN_FULLTEXT_QUERY=""
  _ATUIN_FULLTEXT_CURRENT=""
  _ATUIN_FULLTEXT_OFFSET=-1
}

_atuin_history_fulltext_search() {
  local direction="$1"
  local result

  # Start a new search when this is the first invocation,
  # or when the user has edited the selected result.
  if [[ "$BUFFER" != "$_ATUIN_FULLTEXT_CURRENT" ]]; then
      _ATUIN_FULLTEXT_INITIAL="$BUFFER"
      _ATUIN_FULLTEXT_QUERY="$BUFFER"
      _ATUIN_FULLTEXT_CURRENT="$BUFFER"
      _ATUIN_FULLTEXT_OFFSET=-1
  fi

  if [[ "$direction" == "up" ]]; then
    (( _ATUIN_FULLTEXT_OFFSET++ ))
  else
    (( _ATUIN_FULLTEXT_OFFSET-- ))

    # We cannot navigate before the first result.
    if (( _ATUIN_FULLTEXT_OFFSET < 0 )); then
      _ATUIN_FULLTEXT_OFFSET=0
      BUFFER="$_ATUIN_FULLTEXT_INITIAL"
      CURSOR=${#BUFFER}
      _atuin_history_fulltext_reset
      zle redisplay
      return
    fi
  fi

  result="$(
    atuin search \
      --filter-mode "$ATUIN_HISTORY_SEARCH_FILTER_MODE" \
      --search-mode fulltext \
      --limit 1 \
      --offset "$_ATUIN_FULLTEXT_OFFSET" \
      --format "{command}" \
      "$_ATUIN_FULLTEXT_QUERY" \
      2>/dev/null
  )"

  if [[ -z "$result" ]]; then
    # Don't move past the available results.
    if [[ "$direction" == "up" ]]; then
      (( _ATUIN_FULLTEXT_OFFSET-- ))
    fi
    return
  fi

  BUFFER="$result"
  CURSOR=${#BUFFER}
  _ATUIN_FULLTEXT_CURRENT="$BUFFER"

  zle redisplay
}

_atuin_history_fulltext_up() {
  _atuin_history_fulltext_search up
}

_atuin_history_fulltext_down() {
  _atuin_history_fulltext_search down
}

zle -N atuin-history-fulltext-up _atuin_history_fulltext_up
zle -N atuin-history-fulltext-down _atuin_history_fulltext_down
