#!/usr/bin/env bash
set -euo pipefail

# Read stdin JSON once
payload="$(cat)"

# Extract all fields in a single jq invocation using @sh for safe eval
eval "$(printf '%s' "$payload" | jq -r '
  @sh "STATE=\(.agent_state // "idle")",
  @sh "CONFIRM=\(.tool_confirmation_pending // false)",
  @sh "MODE=\(.cycle_mode // "normal")",
  @sh "SANDBOX=\(.sandbox.enabled // false)",
  @sh "MODEL=\(.model.display_name // "No Model")",
  @sh "CTX_PCT=\(.context_window.used_percentage // 0 | floor)",
  @sh "OVER_200K=\(.exceeds_200k_tokens // false)",
  @sh "SUB_RUN=\([.subagents[]? | select(.status == "running")] | length)",
  @sh "SUB_TOT=\(.subagents // [] | length)",
  @sh "TASKS=\(.task_count // 0)",
  @sh "ARTIFACTS=\(.artifact_count // 0)",
  @sh "COST=\(.cost.total_usd // 0)",
  @sh "QUOTA_PCT=\([.quota[]?.remaining_fraction] | first // -1 | if . >= 0 then (. * 100 | floor) else -1 end)",
  @sh "CWD=\(.workspace.current_dir // .cwd // "")"
')"

# ANSI Colors
RST=$'\033[0m'
BOLD=$'\033[1m'
DIM=$'\033[2m'
RED=$'\033[31m'
GRN=$'\033[32m'
YLW=$'\033[33m'
BLU=$'\033[34m'
MAG=$'\033[35m'
CYN=$'\033[36m'

# 1. State Badge
if [[ "$CONFIRM" == "true" ]]; then
  STATE_BADGE="${BOLD}${YLW}⚠ CONFIRM TOOL${RST}"
else
  case "$STATE" in
    idle)           STATE_BADGE="${GRN}● READY${RST}" ;;
    working)        STATE_BADGE="${CYN}◉ THINKING${RST}" ;;
    tool_use)       STATE_BADGE="${MAG}⚙ TOOL${RST}" ;;
    reviewing)      STATE_BADGE="${BLU}◎ REVIEW${RST}" ;;
    error)          STATE_BADGE="${RED}✖ ERROR${RST}" ;;
    *)              STATE_BADGE="${DIM}○ $(printf '%s' "$STATE" | tr '[:lower:]' '[:upper:]')${RST}" ;;
  esac
fi

# 2. Mode & Sandbox Indicator
case "$MODE" in
  plan)         MODE_BADGE="${BLU}PLAN${RST}" ;;
  auto)         MODE_BADGE="${YLW}AUTO${RST}" ;;
  accept-edits) MODE_BADGE="${MAG}ACCEPT${RST}" ;;
  *)            MODE_BADGE="${DIM}STD${RST}" ;;
esac

if [[ "$SANDBOX" == "true" ]]; then
  SBX_ICON="${GRN}🛡${RST}"
else
  SBX_ICON="${YLW}🔓${RST}"
fi

# 3. Context Progress Bar (10 segments)
FILLED=$(( CTX_PCT / 10 ))
(( FILLED > 10 )) && FILLED=10
EMPTY=$(( 10 - FILLED ))

if [[ "$OVER_200K" == "true" || "$CTX_PCT" -ge 80 ]]; then
  CTX_CLR="$RED"
elif [[ "$CTX_PCT" -ge 50 ]]; then
  CTX_CLR="$YLW"
else
  CTX_CLR="$GRN"
fi

BAR=""
(( FILLED > 0 )) && BAR+="$(printf "%${FILLED}s" | tr ' ' '━')"
(( EMPTY > 0 ))  && BAR+="${DIM}$(printf "%${EMPTY}s" | tr ' ' '─')${RST}"
CTX_INFO="${CTX_CLR}${BAR} ${CTX_PCT}%${RST}"
[[ "$OVER_200K" == "true" ]] && CTX_INFO="${CTX_INFO} ${RED}!200k${RST}"

# 4. Cached Git Branch (5-second TTL in /tmp to avoid slowing down the 300ms loop)
GIT_INFO=""
if [[ -n "$CWD" && -d "$CWD" ]]; then
  CACHE_KEY="$(printf '%s' "$CWD" | cksum | cut -d' ' -f1)"
  CACHE_FILE="/tmp/agy_git_${CACHE_KEY}"
  NOW="$(date +%s)"
  if [[ -f "$CACHE_FILE" ]] && (( NOW - $(stat -f %m "$CACHE_FILE" 2>/dev/null || echo 0) < 5 )); then
    GIT_INFO="$(cat "$CACHE_FILE")"
  else
    if BRANCH="$(git -C "$CWD" symbolic-ref --short HEAD 2>/dev/null || git -C "$CWD" rev-parse --short HEAD 2>/dev/null)"; then
      DIRTY=""
      [[ -n "$(git -C "$CWD" status --porcelain -uno 2>/dev/null | head -n 1)" ]] && DIRTY="*"
      GIT_INFO=" ${DIM}│${RST} ${MAG} ${BRANCH}${YLW}${DIRTY}${RST}"
    fi
    printf '%s' "$GIT_INFO" > "$CACHE_FILE" 2>/dev/null || true
  fi
fi

# 5. Optional Counters (Subagents, Tasks, Artifacts, Quota, Cost)
EXTRAS=""
(( SUB_TOT > 0 ))    && EXTRAS+=" ${DIM}│${RST} 🤖 ${SUB_RUN}/${SUB_TOT}"
(( TASKS > 0 ))      && EXTRAS+=" ${DIM}│${RST} ⏳ ${TASKS}"
(( ARTIFACTS > 0 ))  && EXTRAS+=" ${DIM}│${RST} 📄 ${ARTIFACTS}"
(( QUOTA_PCT >= 0 )) && EXTRAS+=" ${DIM}│${RST} 🔋 ${QUOTA_PCT}%"
if [[ "$COST" != "0" && "$COST" != "0.0" ]]; then
  COST_FMT="$(printf '%.2f' "$COST")"
  EXTRAS+=" ${DIM}│${RST} ${DIM}\$${COST_FMT}${RST}"
fi

# Output final single-line status
printf "%s %s %s %s│%s %s %s│%s %s%s%s\n" \
  "$STATE_BADGE" "$SBX_ICON" "$MODE_BADGE" \
  "$DIM" "$RST" "$MODEL" \
  "$DIM" "$RST" "$CTX_INFO" "$GIT_INFO" "$EXTRAS"
