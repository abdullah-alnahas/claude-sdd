#!/bin/bash
# Test: Agent files have correct format, required metadata, and <example> triggers
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PASS=0
FAIL=0

assert() {
  local desc="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    echo "  PASS: $desc"
    PASS=$((PASS + 1))
  else
    echo "  FAIL: $desc"
    FAIL=$((FAIL + 1))
  fi
}

echo "=== Agent Tests ==="
echo ""

AGENT_COUNT=0
VALID_MODELS="sonnet opus haiku"

for agent_file in "$PLUGIN_DIR/agents/"*.md; do
  [ -f "$agent_file" ] || continue
  agent_name=$(basename "$agent_file" .md)
  AGENT_COUNT=$((AGENT_COUNT + 1))
  echo "-- $agent_name --"

  # Frontmatter
  assert "[$agent_name] has frontmatter start" bash -c "sed -n '1p' '$agent_file' | grep -q '^---'"
  assert "[$agent_name] has name field" grep -q "^name:" "$agent_file"
  assert "[$agent_name] has model field" grep -q "^model:" "$agent_file"
  assert "[$agent_name] has description field" grep -q "^description:" "$agent_file"
  assert "[$agent_name] has allowed-tools" grep -q "^allowed-tools:" "$agent_file"

  # Model is valid
  MODEL=$(grep "^model:" "$agent_file" | head -1 | sed 's/^model: *//' | tr -d '\r')
  assert "[$agent_name] model '$MODEL' is valid" echo "$VALID_MODELS" | grep -qw "$MODEL"

  # Has example blocks for trigger detection
  EXAMPLE_COUNT=$(grep -c '<example>' "$agent_file" || true)
  assert "[$agent_name] has at least 2 examples ($EXAMPLE_COUNT found)" test "$EXAMPLE_COUNT" -ge 2

  # Example blocks are properly closed
  CLOSE_COUNT=$(grep -c '</example>' "$agent_file" || true)
  assert "[$agent_name] examples are properly closed" test "$EXAMPLE_COUNT" -eq "$CLOSE_COUNT"

  # Has a review process or instructions section
  assert "[$agent_name] has review/process section" grep -q "^## " "$agent_file"

  # Has output format
  assert "[$agent_name] has output format" grep -qi "output\|format\|findings" "$agent_file"

  # Under 150 lines (Claude Code agent size limit)
  LINE_COUNT=$(wc -l < "$agent_file")
  assert "[$agent_name] under 150 lines ($LINE_COUNT)" test "$LINE_COUNT" -le 150

  echo ""
done

# Expected agents
echo "-- Required Agents --"
for required_agent in critic simplifier spec-compliance security-reviewer performance-reviewer planner; do
  assert "Agent $required_agent exists" test -f "$PLUGIN_DIR/agents/$required_agent.md"
done

assert "At least 6 agents" test "$AGENT_COUNT" -ge 6

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
exit $FAIL
