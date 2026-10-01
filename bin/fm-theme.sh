#!/usr/bin/env bash
# bin/fm-theme.sh - Extensible persona and theme manager for Nexus.
#
# Reads the active theme from $CONFIG/theme or $FM_THEME (fallback: "nautical").
# Queries attributes and prompts from personas/<theme>.md.
#
# Usage:
#   bin/fm-theme.sh current                 # prints active theme name
#   bin/fm-theme.sh user-title              # prints user title (e.g. Captain, The One, Chief)
#   bin/fm-theme.sh supervisor-role         # prints supervisor role (e.g. Number One, First Mate)
#   bin/fm-theme.sh secondmate-role         # prints secondmate role
#   bin/fm-theme.sh worker-role [ship|scout] # prints worker role (e.g. Engineering Officer, Science Officer)
#   bin/fm-theme.sh idle-ack                # prints idle acknowledgment string
#   bin/fm-theme.sh brief-intro [ship|scout]# prints role contract paragraph for briefs
#   bin/fm-theme.sh prompt                  # prints full persona instruction block
#   bin/fm-theme.sh list                    # lists available personas
#   bin/fm-theme.sh set <name>              # sets active theme in $CONFIG/theme

set -euo pipefail

SCRIPT_DIR=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P)
FM_ROOT="${FM_ROOT_OVERRIDE:-$(cd "$SCRIPT_DIR/.." && pwd -P)}"
FM_HOME="${FM_HOME:-${FM_ROOT_OVERRIDE:-$FM_ROOT}}"
CONFIG="${FM_CONFIG_OVERRIDE:-$FM_HOME/config}"
PERSONAS_DIR="$FM_ROOT/personas"

get_active_theme() {
  if [ -n "${FM_THEME:-}" ]; then
    printf '%s\n' "$FM_THEME"
    return 0
  fi
  if [ -f "$CONFIG/theme" ]; then
    local t
    t=$(tr -d '[:space:]' < "$CONFIG/theme")
    if [ -n "$t" ] && [ -f "$PERSONAS_DIR/$t.md" ]; then
      printf '%s\n' "$t"
      return 0
    fi
  fi
  printf 'nautical\n'
}

get_field() {
  local theme=$1 field=$2 fallback=$3 file
  file="$PERSONAS_DIR/$theme.md"
  if [ ! -f "$file" ]; then
    file="$PERSONAS_DIR/nautical.md"
  fi
  if [ ! -f "$file" ]; then
    printf '%s\n' "$fallback"
    return 0
  fi
  local val
  val=$(sed -n "s/^${field}:[[:space:]]*//p" "$file" | head -n 1 | sed -e 's/^"//' -e 's/"$//' -e "s/^'//" -e "s/'$//")
  if [ -n "$val" ]; then
    printf '%s\n' "$val"
  else
    printf '%s\n' "$fallback"
  fi
}

cmd="${1:-current}"
shift || true

ACTIVE_THEME=$(get_active_theme)

case "$cmd" in
  current)
    printf '%s\n' "$ACTIVE_THEME"
    ;;
  user-title)
    get_field "$ACTIVE_THEME" "user_title" "Captain"
    ;;
  supervisor-role)
    get_field "$ACTIVE_THEME" "supervisor_role" "Nexus"
    ;;
  secondmate-role)
    get_field "$ACTIVE_THEME" "secondmate_role" "Second Mate"
    ;;
  worker-role)
    kind="${1:-ship}"
    if [ "$kind" = "scout" ]; then
      get_field "$ACTIVE_THEME" "worker_researcher" "Scout"
    else
      get_field "$ACTIVE_THEME" "worker_builder" "Crewmate"
    fi
    ;;
  idle-ack)
    get_field "$ACTIVE_THEME" "idle_ack" "Captain, shipshape."
    ;;
  brief-intro)
    kind="${1:-ship}"
    worker_role=$(get_field "$ACTIVE_THEME" $([ "$kind" = "scout" ] && echo "worker_researcher" || echo "worker_builder") "Crewmate")
    supervisor_role=$(get_field "$ACTIVE_THEME" "supervisor_role" "Nexus")
    cat <<EOF
You are a $worker_role: an autonomous worker agent managed by $supervisor_role.
This section establishes your current identity before every project or task instruction below and supersedes any conflicting role identity in those instructions.
Do the assigned work yourself and report only to $supervisor_role; do not adopt a supervisor identity, delegate the task, run fleet supervision, or address the operator.
EOF
    ;;
  prompt)
    file="$PERSONAS_DIR/$ACTIVE_THEME.md"
    if [ -f "$file" ]; then
      awk 'BEGIN{c=0} /^---$/{c++; next} c>=2{print}' "$file"
    else
      cat <<EOF
You are Nexus. The user is the Captain.
Address the user as Captain at least once in every chat message.
Reply exactly "Captain, shipshape." for a true no-op.
EOF
    fi
    ;;
  list)
    if [ -d "$PERSONAS_DIR" ]; then
      for p in "$PERSONAS_DIR"/*.md; do
        [ -e "$p" ] || continue
        b=$(basename "$p" .md)
        title=$(get_field "$b" "user_title" "Captain")
        sup=$(get_field "$b" "supervisor_role" "Nexus")
        marker=" "
        [ "$b" = "$ACTIVE_THEME" ] && marker="*"
        printf '%s %-16s (%s / %s)\n' "$marker" "$b" "$title" "$sup"
      done
    fi
    ;;
  set)
    new_theme="${1:-}"
    if [ -z "$new_theme" ]; then
      echo "error: bin/fm-theme.sh set <theme-name>" >&2
      exit 1
    fi
    if [ ! -f "$PERSONAS_DIR/$new_theme.md" ]; then
      echo "error: persona '$new_theme' not found in $PERSONAS_DIR" >&2
      exit 1
    fi
    mkdir -p "$CONFIG"
    printf '%s\n' "$new_theme" > "$CONFIG/theme"
    echo "theme set to: $new_theme"
    ;;
  *)
    echo "error: unknown command '$cmd'" >&2
    echo "usage: fm-theme.sh [current|user-title|supervisor-role|secondmate-role|worker-role|idle-ack|brief-intro|prompt|list|set]" >&2
    exit 1
    ;;
esac
