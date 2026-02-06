#!/bin/bash
# Test: Root specs exist, are complete, and are internally consistent
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

echo "=== Spec Tests ==="
echo ""

SPECS_DIR="$PLUGIN_DIR/specs"

# --- Required root specs ---
echo "-- Required Root Specs --"
for spec in app-description.md behavior-spec.md stack.md architecture.md roadmap.md test-plan.md; do
  assert "$spec exists" test -f "$SPECS_DIR/$spec"
  if [ -f "$SPECS_DIR/$spec" ]; then
    SIZE=$(wc -c < "$SPECS_DIR/$spec")
    assert "$spec is non-trivial (>200 chars)" test "$SIZE" -gt 200
    assert "$spec has a heading" grep -q '^#' "$SPECS_DIR/$spec"
  fi
done

echo ""

# --- Spec content validation ---
echo "-- Spec Content --"

# app-description should mention SDD
assert "app-description mentions SDD" grep -qi "sdd\|spec-driven" "$SPECS_DIR/app-description.md"
assert "app-description has problem statement" grep -qi "problem" "$SPECS_DIR/app-description.md"
assert "app-description has success criteria" grep -qi "success\|criteria" "$SPECS_DIR/app-description.md"

# behavior-spec should have Given-When-Then or acceptance criteria
assert "behavior-spec has behavioral patterns" grep -qiE "given|when|then|acceptance|criteria" "$SPECS_DIR/behavior-spec.md"
assert "behavior-spec covers hooks" grep -qi "hook" "$SPECS_DIR/behavior-spec.md"
assert "behavior-spec covers skills" grep -qi "skill" "$SPECS_DIR/behavior-spec.md"
assert "behavior-spec covers agents" grep -qi "agent" "$SPECS_DIR/behavior-spec.md"
assert "behavior-spec covers commands" grep -qi "command" "$SPECS_DIR/behavior-spec.md"

# stack.md should describe technology
assert "stack.md mentions Markdown" grep -qi "markdown" "$SPECS_DIR/stack.md"
assert "stack.md mentions Bash" grep -qi "bash" "$SPECS_DIR/stack.md"
assert "stack.md mentions Claude Code" grep -qi "claude code\|claude-plugin" "$SPECS_DIR/stack.md"

# architecture.md should describe components
assert "architecture.md mentions commands layer" grep -qi "command" "$SPECS_DIR/architecture.md"
assert "architecture.md mentions hooks" grep -qi "hook" "$SPECS_DIR/architecture.md"
assert "architecture.md mentions agents" grep -qi "agent" "$SPECS_DIR/architecture.md"
assert "architecture.md mentions skills" grep -qi "skill" "$SPECS_DIR/architecture.md"

# roadmap.md should reference versions
assert "roadmap.md mentions current version" grep -q "0\.12" "$SPECS_DIR/roadmap.md"
assert "roadmap.md has implementation phases or milestones" grep -qiE "phase|milestone|v0\." "$SPECS_DIR/roadmap.md"

echo ""

# --- Version consistency across specs ---
echo "-- Version Consistency --"
# plugin.json version
PLUGIN_VER=$(python3 -c "import json; print(json.load(open('$PLUGIN_DIR/.claude-plugin/plugin.json'))['version'])")

# Check specs that mention version match current
for spec_with_version in stack.md architecture.md roadmap.md; do
  if grep -q "Version" "$SPECS_DIR/$spec_with_version" 2>/dev/null; then
    SPEC_VER=$(grep -oP '\d+\.\d+\.\d+' "$SPECS_DIR/$spec_with_version" | head -1)
    if [ -n "$SPEC_VER" ]; then
      assert "$spec_with_version version ($SPEC_VER) matches plugin ($PLUGIN_VER)" test "$SPEC_VER" = "$PLUGIN_VER"
    fi
  fi
done

echo ""

# --- Feature spec directories are complete ---
echo "-- Feature Spec Completeness --"
for feature_dir in "$SPECS_DIR"/*/; do
  [ -d "$feature_dir" ] || continue
  feature_name=$(basename "$feature_dir")
  echo "  Feature: $feature_name"

  # Each feature dir should have at least behavior-spec and app-description
  assert "[$feature_name] has app-description.md" test -f "$feature_dir/app-description.md"
  assert "[$feature_name] has behavior-spec.md" test -f "$feature_dir/behavior-spec.md"
done

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
exit $FAIL
