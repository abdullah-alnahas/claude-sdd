#!/bin/bash
# SDD Strategic Compaction Counter
# Counts tool invocations per session and suggests compaction at threshold.
# Runs as PostToolUse hook — must be fast and silent on stdout.

set -euo pipefail

THRESHOLD="${SDD_COMPACTION_THRESHOLD:-50}"
COUNTER_FILE="/tmp/sdd-compaction-$$"

# Use parent PID to scope counter to the Claude session
if [ -n "${PPID:-}" ]; then
  COUNTER_FILE="/tmp/sdd-compaction-$PPID"
fi

# Increment counter
COUNT=0
if [ -f "$COUNTER_FILE" ]; then
  COUNT=$(cat "$COUNTER_FILE" 2>/dev/null || echo "0")
fi
COUNT=$((COUNT + 1))
echo "$COUNT" > "$COUNTER_FILE"

# Check threshold
if [ "$COUNT" -ge "$THRESHOLD" ]; then
  echo "→ SDD: $COUNT tool calls — consider /compact (preserve: task, spec, files, tests)" >&2
  # Reset counter after suggesting
  echo "0" > "$COUNTER_FILE"
fi

exit 0
