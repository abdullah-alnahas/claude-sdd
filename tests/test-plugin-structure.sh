#!/bin/bash
# Test: Plugin directory structure and manifest integrity
# Validates that the plugin has all required structural elements.
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

assert_equals() {
  local desc="$1"
  local expected="$2"
  local actual="$3"
  if [ "$expected" = "$actual" ]; then
    echo "  PASS: $desc"
    PASS=$((PASS + 1))
  else
    echo "  FAIL: $desc (expected '$expected', got '$actual')"
    FAIL=$((FAIL + 1))
  fi
}

echo "=== Plugin Structure Tests ==="
echo ""

# --- Manifest ---
echo "-- Manifest --"
assert ".claude-plugin/ directory exists" test -d "$PLUGIN_DIR/.claude-plugin"
assert "plugin.json exists" test -f "$PLUGIN_DIR/.claude-plugin/plugin.json"
assert "plugin.json is valid JSON" python3 -c "import json; json.load(open('$PLUGIN_DIR/.claude-plugin/plugin.json'))"

# Verify manifest has required fields
PLUGIN_NAME=$(python3 -c "import json; print(json.load(open('$PLUGIN_DIR/.claude-plugin/plugin.json'))['name'])")
assert_equals "plugin name is claude-sdd" "claude-sdd" "$PLUGIN_NAME"

PLUGIN_VERSION=$(python3 -c "import json; print(json.load(open('$PLUGIN_DIR/.claude-plugin/plugin.json'))['version'])")
assert "plugin version is semver" echo "$PLUGIN_VERSION" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'

# package.json version matches plugin.json version
PKG_VERSION=$(python3 -c "import json; print(json.load(open('$PLUGIN_DIR/package.json'))['version'])")
assert_equals "package.json version matches plugin.json" "$PLUGIN_VERSION" "$PKG_VERSION"

echo ""

# --- Required directories ---
echo "-- Required Directories --"
assert "commands/ exists" test -d "$PLUGIN_DIR/commands"
assert "agents/ exists" test -d "$PLUGIN_DIR/agents"
assert "skills/ exists" test -d "$PLUGIN_DIR/skills"
assert "hooks/ exists" test -d "$PLUGIN_DIR/hooks"
assert "hooks/scripts/ exists" test -d "$PLUGIN_DIR/hooks/scripts"
assert "scripts/ exists" test -d "$PLUGIN_DIR/scripts"
assert "contexts/ exists" test -d "$PLUGIN_DIR/contexts"
assert "specs/ exists" test -d "$PLUGIN_DIR/specs"

echo ""

# --- No legacy files ---
echo "-- No Legacy Files --"
assert "No manifest.yaml (legacy)" test ! -f "$PLUGIN_DIR/manifest.yaml"

echo ""

# --- Context modes ---
echo "-- Context Modes --"
for mode in dev review research; do
  assert "Context $mode.md exists" test -f "$PLUGIN_DIR/contexts/$mode.md"
  SIZE=$(wc -c < "$PLUGIN_DIR/contexts/$mode.md")
  assert "Context $mode.md is non-empty" test "$SIZE" -gt 10
done

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
exit $FAIL
