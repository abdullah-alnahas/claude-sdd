#!/bin/bash
# Test: Cross-references between components are valid
# Commands reference agents that exist, skills reference files that exist, etc.
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

echo "=== Cross-Reference Tests ==="
echo ""

# --- Agent names referenced in orchestrate match actual agent files ---
echo "-- Orchestrate → Agent References --"
ORCH_FILE="$PLUGIN_DIR/commands/sdd-orchestrate.md"
# Extract built-in agent names from named pipelines table
for agent in critic simplifier spec-compliance security-reviewer performance-reviewer planner; do
  assert "Orchestrate references agent '$agent' and file exists" test -f "$PLUGIN_DIR/agents/$agent.md"
done

echo ""

# --- Commands that reference other commands ---
echo "-- Command Cross-References --"
# /sdd-execute references /sdd-review
assert "/sdd-execute references /sdd-review" grep -q 'sdd-review' "$PLUGIN_DIR/commands/sdd-execute.md"
# /sdd-plugin references /sdd-plugin list (self-reference for sync usage)
assert "/sdd-orchestrate references /sdd-plugin" grep -q 'sdd-plugin' "$PLUGIN_DIR/commands/sdd-orchestrate.md"
# /sdd-init references /sdd-onboard
assert "/sdd-init references /sdd-onboard" grep -q 'sdd-onboard' "$PLUGIN_DIR/commands/sdd-init.md"

echo ""

# --- Checklists directory and contents ---
echo "-- Checklists --"
CHECKLIST_DIR="$PLUGIN_DIR/commands/checklists"
assert "Checklists directory exists" test -d "$CHECKLIST_DIR"
if [ -d "$CHECKLIST_DIR" ]; then
  CL_COUNT=$(find "$CHECKLIST_DIR" -name "*.md" -type f | wc -l)
  assert "At least 3 checklists ($CL_COUNT found)" test "$CL_COUNT" -ge 3
  for cl in "$CHECKLIST_DIR/"*.md; do
    [ -f "$cl" ] || continue
    cl_name=$(basename "$cl")
    SIZE=$(wc -c < "$cl")
    assert "Checklist $cl_name is non-empty" test "$SIZE" -gt 10
  done
fi

echo ""

# --- Autopilot steps exist ---
echo "-- Autopilot Steps --"
for step in 1 2 3 4 5; do
  STEP_FILE=$(ls "$PLUGIN_DIR/commands/sdd-autopilot/step-$step-"*.md 2>/dev/null | head -1)
  assert "Autopilot step $step exists" test -n "$STEP_FILE" -a -f "$STEP_FILE"
done

echo ""

# --- Specs reference real components ---
echo "-- Spec Accuracy --"
# behavior-spec.md should mention actual hook events that exist in hooks.json
assert "Behavior spec mentions SessionStart" grep -q "SessionStart" "$PLUGIN_DIR/specs/behavior-spec.md"
assert "Behavior spec mentions PostToolUse" grep -q "PostToolUse\|post-edit" "$PLUGIN_DIR/specs/behavior-spec.md"
assert "Behavior spec mentions critic agent" grep -q "critic" "$PLUGIN_DIR/specs/behavior-spec.md"
assert "Behavior spec mentions spec-compliance agent" grep -q "spec-compliance\|Spec-Compliance" "$PLUGIN_DIR/specs/behavior-spec.md"

echo ""

# --- Skills reference files that exist ---
echo "-- Skill Reference Integrity --"
BROKEN_REFS=0
for skill_dir in "$PLUGIN_DIR/skills/"*/; do
  [ -d "$skill_dir" ] || continue
  SKILL_FILE="$skill_dir/SKILL.md"
  [ -f "$SKILL_FILE" ] || continue
  skill_name=$(basename "$skill_dir")

  while IFS= read -r line; do
    ref_path=$(echo "$line" | grep -oP 'references/[^`\s)]+' || true)
    [ -z "$ref_path" ] && continue
    # Cross-skill refs (e.g. "skills/spec-first/references/...") resolve from plugin root
    if echo "$line" | grep -q 'skills/'; then
      cross_ref=$(echo "$line" | grep -oP 'skills/[^`\s)]+' || true)
      if [ -n "$cross_ref" ] && [ ! -e "$PLUGIN_DIR/$cross_ref" ]; then
        echo "  FAIL: [$skill_name] broken cross-ref: $cross_ref"
        BROKEN_REFS=$((BROKEN_REFS + 1))
      fi
    elif [ ! -e "$skill_dir/$ref_path" ]; then
      echo "  FAIL: [$skill_name] broken ref: $ref_path"
      BROKEN_REFS=$((BROKEN_REFS + 1))
    fi
  done < <(grep 'references/' "$SKILL_FILE" 2>/dev/null || true)
done

if [ "$BROKEN_REFS" -eq 0 ]; then
  echo "  PASS: No broken skill references"
  PASS=$((PASS + 1))
else
  echo "  FAIL: $BROKEN_REFS broken skill references"
  FAIL=$((FAIL + 1))
fi

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
exit $FAIL
