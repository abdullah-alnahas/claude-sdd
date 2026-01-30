#!/bin/bash
# SDD Self-Test: Verify commands structure
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PASS=0
FAIL=0

check() {
  local desc="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    echo "  ✓ $desc"
    PASS=$((PASS + 1))
  else
    echo "  ✗ $desc"
    FAIL=$((FAIL + 1))
  fi
}

echo "SDD Command Verification"
echo "────────────────────────"

COMMANDS=("sdd-guardrails" "sdd-yolo" "sdd-phase" "sdd-review" "sdd-adopt" "sdd-execute" "sdd-autopilot")

for cmd in "${COMMANDS[@]}"; do
  echo ""
  echo "Command: /$cmd"
  CMD_FILE="$PLUGIN_DIR/commands/$cmd.md"

  check "File exists" test -f "$CMD_FILE"
  check "Has frontmatter" grep -q "^---" "$CMD_FILE"
  check "Has name field" grep -q "^name:" "$CMD_FILE"
  check "Has description field" grep -q "^description:" "$CMD_FILE"
  check "Is non-empty (>100 chars)" test "$(wc -c < "$CMD_FILE")" -gt 100
done

# Check for duplicate command names
echo ""
echo "Uniqueness:"
NAMES=$(grep -h "^name:" "$PLUGIN_DIR/commands/"*.md | sort)
UNIQUE_NAMES=$(echo "$NAMES" | sort -u)
check "All command names are unique" test "$(echo "$NAMES" | wc -l)" -eq "$(echo "$UNIQUE_NAMES" | wc -l)"

# Check agents referenced by commands exist
echo ""
echo "Agent references:"
AGENTS=("critic" "simplifier" "spec-compliance" "security-reviewer")
for agent in "${AGENTS[@]}"; do
  check "Agent: $agent.md exists" test -f "$PLUGIN_DIR/agents/$agent.md"
done

echo ""
echo "────────────────────────"
echo "Results: $PASS passed, $FAIL failed"

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
