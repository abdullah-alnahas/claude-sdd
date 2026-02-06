#!/bin/bash
# Test: Command files have correct format and required fields
# Every command must have valid YAML frontmatter with name, description, and allowed-tools.
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

echo "=== Command Tests ==="
echo ""

CMD_COUNT=0
NAMES=""

for cmd_file in "$PLUGIN_DIR/commands/"*.md; do
  [ -f "$cmd_file" ] || continue
  cmd_name=$(basename "$cmd_file" .md)
  CMD_COUNT=$((CMD_COUNT + 1))
  echo "-- $cmd_name --"

  # Frontmatter structure
  FIRST_LINE=$(sed -n '1p' "$cmd_file")
  assert "[$cmd_name] starts with ---" test "$FIRST_LINE" = "---"

  # Count frontmatter delimiters (must have at least 2)
  DELIM_COUNT=$(grep -c '^---$' "$cmd_file" || true)
  assert "[$cmd_name] has closing ---" test "$DELIM_COUNT" -ge 2

  # Required fields
  assert "[$cmd_name] has name field" grep -q "^name:" "$cmd_file"
  assert "[$cmd_name] has description field" grep -q "^description:" "$cmd_file"
  assert "[$cmd_name] has allowed-tools" grep -q "^allowed-tools:" "$cmd_file"

  # Name field matches filename
  FILE_NAME=$(grep "^name:" "$cmd_file" | head -1 | sed 's/^name: *//' | tr -d '\r')
  assert "[$cmd_name] name field matches filename" test "$FILE_NAME" = "$cmd_name"

  # Content is non-trivial
  CHAR_COUNT=$(wc -c < "$cmd_file")
  assert "[$cmd_name] has substantial content (>100 chars)" test "$CHAR_COUNT" -gt 100

  # Has a markdown heading (the command's documentation)
  assert "[$cmd_name] has markdown heading" grep -q "^#" "$cmd_file"

  # Collect names for uniqueness check
  NAMES="$NAMES
$FILE_NAME"

  echo ""
done

# Uniqueness
UNIQUE_COUNT=$(echo "$NAMES" | sort -u | grep -c . || true)
TOTAL_COUNT=$(echo "$NAMES" | grep -c . || true)
assert "All command names are unique ($TOTAL_COUNT total)" test "$UNIQUE_COUNT" -eq "$TOTAL_COUNT"

# Minimum command count — the plugin should have a reasonable number
assert "Plugin has at least 20 commands" test "$CMD_COUNT" -ge 20

echo ""

# --- Specific critical commands exist ---
echo "-- Critical Commands Exist --"
for required_cmd in sdd-execute sdd-review sdd-verify sdd-phase sdd-mode sdd-plugin sdd-orchestrate sdd-init sdd-status sdd-guardrails; do
  assert "/sdd-$required_cmd exists" test -f "$PLUGIN_DIR/commands/$required_cmd.md"
done

echo ""

# --- /sdd-plugin command has all subcommands documented ---
echo "-- /sdd-plugin Subcommands --"
PLUGIN_CMD="$PLUGIN_DIR/commands/sdd-plugin.md"
for subcmd in add remove list run sync; do
  assert "/sdd-plugin documents '$subcmd' subcommand" grep -q "### $subcmd" "$PLUGIN_CMD"
done
assert "/sdd-plugin documents .sdd-plugins.json" grep -q '\.sdd-plugins\.json' "$PLUGIN_CMD"

echo ""

# --- /sdd-execute has plugin integration ---
echo "-- /sdd-execute Plugin Integration --"
EXEC_CMD="$PLUGIN_DIR/commands/sdd-execute.md"
assert "/sdd-execute documents --plugins flag" grep -q '\-\-plugins' "$EXEC_CMD"
assert "/sdd-execute documents ask mode" grep -q 'plugins=ask' "$EXEC_CMD"
assert "/sdd-execute documents auto mode" grep -q 'plugins=auto' "$EXEC_CMD"
assert "/sdd-execute documents off mode" grep -q 'plugins=off' "$EXEC_CMD"
assert "/sdd-execute references .sdd-plugins.json" grep -q '\.sdd-plugins\.json' "$EXEC_CMD"

echo ""

# --- /sdd-orchestrate has plugin agent support ---
echo "-- /sdd-orchestrate Plugin Agent Support --"
ORCH_CMD="$PLUGIN_DIR/commands/sdd-orchestrate.md"
assert "/sdd-orchestrate documents plugin:agent notation" grep -q 'plugin.*:.*agent' "$ORCH_CMD"
assert "/sdd-orchestrate has agent resolution order" grep -q 'Agent Resolution Order' "$ORCH_CMD"

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
exit $FAIL
