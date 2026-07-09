#!/usr/bin/env bash
# Claude Code status line
input=$(cat)

user=$(whoami)
host=$(hostname -s)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
# Git branch + dirty status
git_part=""
if [ -n "$cwd" ] && branch=$(git -C "$cwd" branch --show-current 2>/dev/null) && [ -n "$branch" ]; then
  dirty=""
  [ -n "$(git -C "$cwd" status --porcelain 2>/dev/null | head -1)" ] && dirty="±"
  git_part=" $(printf '\033[0;35m')${branch}${dirty}$(printf '\033[0m')"
fi
# Shorten home directory to ~
cwd="${cwd/#$HOME/\~}"

model=$(echo "$input" | jq -r '.model.display_name // ""')

used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Build context progress bar (10 chars wide)
ctx_bar=""
if [ -n "$used" ]; then
  pct=$(printf '%.0f' "$used")
  filled=$(( pct * 10 / 100 ))
  empty=$(( 10 - filled ))
  bar=""
  for i in $(seq 1 $filled); do bar="${bar}#"; done
  for i in $(seq 1 $empty);  do bar="${bar}-"; done
  # Color: green < 70%, yellow < 90%, red >= 90%
  reset=$'\033[0m'
  if [ "$pct" -ge 90 ]; then
    bar_color=$'\033[0;31m'
  elif [ "$pct" -ge 70 ]; then
    bar_color=$'\033[0;33m'
  else
    bar_color=$'\033[0;32m'
  fi
  ctx_bar=" | ctx:[${bar_color}${bar}${reset}] ${pct}%"
fi

# Build rate limit parts
rate_parts=""

five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
if [ -n "$five_pct" ] && [ -n "$five_reset" ]; then
  now=$(date +%s)
  diff=$(( five_reset - now ))
  if [ "$diff" -le 0 ]; then
    time_str="now"
  else
    mins=$(( diff / 60 ))
    hrs=$(( mins / 60 ))
    mins=$(( mins % 60 ))
    if [ "$hrs" -gt 0 ]; then
      time_str="${hrs}h${mins}m"
    else
      time_str="${mins}m"
    fi
  fi
  five_val=$(printf '%.0f' "$five_pct")
  rate_parts="${rate_parts} | 5h:${five_val}% rst:${time_str}"
fi

seven_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
seven_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
if [ -n "$seven_pct" ] && [ -n "$seven_reset" ]; then
  now=$(date +%s)
  diff=$(( seven_reset - now ))
  if [ "$diff" -le 0 ]; then
    time_str7="now"
  else
    mins7=$(( diff / 60 ))
    hrs7=$(( mins7 / 60 ))
    mins7=$(( mins7 % 60 ))
    days7=$(( hrs7 / 24 ))
    hrs7=$(( hrs7 % 24 ))
    if [ "$days7" -gt 0 ]; then
      time_str7="${days7}d${hrs7}h"
    elif [ "$hrs7" -gt 0 ]; then
      time_str7="${hrs7}h${mins7}m"
    else
      time_str7="${mins7}m"
    fi
  fi
  seven_val=$(printf '%.0f' "$seven_pct")
  rate_parts="${rate_parts} | 7d:${seven_val}% rst:${time_str7}"
fi

printf '\033[1;34m%s@%s\033[0m:\033[1;36m%s\033[0m%s [\033[0;33m%s\033[0m%s%s]' \
  "$user" "$host" "$cwd" "$git_part" "$model" "$ctx_bar" "$rate_parts"
