#!/usr/bin/env bash
set -euo pipefail

# Single-pass jq parsing to avoid spawning multiple subshells every 300ms
jq -r '
  (.workspace.project_dir // .cwd // "agy" | split("/") | last) as $proj |
  (if .tool_confirmation_pending == true then "⚠️ ACTION REQUIRED"
   elif .agent_state == "working" then "⚡ working"
   elif .agent_state == "tool_use" then "🔧 tool"
   elif .agent_state == "reviewing" then "👀 review"
   elif .agent_state == "error" then "❌ error"
   else "🟢 idle" end) as $state |
  (.cycle_mode // "std" | ascii_upcase) as $mode |
  (.conversation_title // "") as $title |
  if ($title | length) > 0 then
    "\($state) [\($proj) | \($mode)] — \($title)"
  else
    "\($state) [\($proj) | \($mode)]"
  end
' 2>/dev/null || echo "agy"
