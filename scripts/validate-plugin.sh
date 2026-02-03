#!/bin/bash
# SDD Plugin Validator — comprehensive validation of entire plugin structure
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PASS=0
FAIL=0
WARN=0

check() {
  local desc="$1"
  shift
  local output
  if output=$("$@" 2>&1); then
    echo "  ✓ $desc"
    PASS=$((PASS + 1))
  else
    echo "  ✗ $desc"
    [ -n "$output" ] && echo "    $output"
    FAIL=$((FAIL + 1))
  fi
}

warn() {
  local desc="$1"
  shift
  local output
  if output=$("$@" 2>&1); then
    echo "  ✓ $desc"
    PASS=$((PASS + 1))
  else
    echo "  ⚠ $desc (warning)"
    [ -n "$output" ] && echo "    $output"
    WARN=$((WARN + 1))
  fi
}

section() {
  echo ""
  echo "═══ $1 ═══"
}

# ─────────────────────────────────────────────
section "Commands"
# ─────────────────────────────────────────────

for cmd_file in "$PLUGIN_DIR/commands/"*.md; do
  [ -f "$cmd_file" ] || continue
  cmd_name=$(basename "$cmd_file" .md)
  echo ""
  echo "  Command: /$cmd_name"
  check "Has frontmatter start" bash -c "sed -n '1p' \"$cmd_file\" | grep -q '^---'"
  check "Has frontmatter end" bash -c "awk '/^---/{n++; if(n==2) exit 0} END{exit (n>=2)?0:1}' \"$cmd_file\""
  check "Has name field" grep -q "^name:" "$cmd_file"
  check "Has description field" grep -q "^description:" "$cmd_file"
  check "Has allowed-tools" grep -q "^allowed-tools:" "$cmd_file"
  check "Non-trivial content (>100 chars)" test "$(wc -c < "$cmd_file")" -gt 100
done

# Uniqueness
echo ""
NAMES=$(grep -h "^name:" "$PLUGIN_DIR/commands/"*.md 2>/dev/null | sort)
UNIQUE_NAMES=$(echo "$NAMES" | sort -u)
check "All command names unique" test "$(echo "$NAMES" | wc -l)" -eq "$(echo "$UNIQUE_NAMES" | wc -l)"

# ─────────────────────────────────────────────
section "Skills"
# ─────────────────────────────────────────────

for skill_dir in "$PLUGIN_DIR/skills/"*/; do
  [ -d "$skill_dir" ] || continue
  skill_name=$(basename "$skill_dir")
  echo ""
  echo "  Skill: $skill_name"
  SKILL_FILE="$skill_dir/SKILL.md"
  check "SKILL.md exists" test -f "$SKILL_FILE"
  if [ -f "$SKILL_FILE" ]; then
    check "Has frontmatter" bash -c "sed -n '1p' \"$SKILL_FILE\" | grep -q '^---'"
    check "Has name field" grep -q "^name:" "$SKILL_FILE"
    check "Has description field" grep -q "^description:" "$SKILL_FILE"
    WORD_COUNT=$(wc -w < "$SKILL_FILE")
    check "Under 3000 words ($WORD_COUNT)" test "$WORD_COUNT" -lt 3000
  fi
  if [ -d "$skill_dir/references" ]; then
    REF_COUNT=$(find "$skill_dir/references" -name "*.md" -type f | wc -l)
    check "Has reference files ($REF_COUNT)" test "$REF_COUNT" -gt 0
    while IFS= read -r ref; do
      SIZE=$(wc -c < "$ref")
      check "$(basename "$ref") non-empty" test "$SIZE" -gt 10
    done < <(find "$skill_dir/references" -name "*.md" -type f)
  fi
done

# ─────────────────────────────────────────────
section "Agents"
# ─────────────────────────────────────────────

for agent_file in "$PLUGIN_DIR/agents/"*.md; do
  [ -f "$agent_file" ] || continue
  agent_name=$(basename "$agent_file" .md)
  echo ""
  echo "  Agent: $agent_name"
  check "Has frontmatter" bash -c "sed -n '1p' \"$agent_file\" | grep -q '^---'"
  check "Has name field" grep -q "^name:" "$agent_file"
  check "Has model field" grep -q "^model:" "$agent_file"
  check "Has description field" grep -q "^description:" "$agent_file"
  # Description should have examples
  check "Has examples in description" grep -q "<example>" "$agent_file"
  check "Has allowed-tools" grep -q "^allowed-tools:" "$agent_file"
  # Check under 150 lines
  LINE_COUNT=$(wc -l < "$agent_file")
  check "Under 150 lines ($LINE_COUNT)" test "$LINE_COUNT" -le 150
done

# ─────────────────────────────────────────────
section "Hooks"
# ─────────────────────────────────────────────

HOOKS_JSON="$PLUGIN_DIR/hooks/hooks.json"
check "hooks.json exists" test -f "$HOOKS_JSON"
if [ -f "$HOOKS_JSON" ]; then
  check "hooks.json is valid JSON" bash -c "python3 -c \"import json; json.load(open('$HOOKS_JSON'))\" 2>&1"
  check "Has hooks key" grep -q '"hooks"' "$HOOKS_JSON"
  # Check referenced scripts exist
  while IFS= read -r script_path; do
    # Extract path after $CLAUDE_PLUGIN_ROOT/
    rel_path=$(echo "$script_path" | sed 's|.*\$CLAUDE_PLUGIN_ROOT/||' | sed 's|".*||')
    check "Hook script exists: $rel_path" test -f "$PLUGIN_DIR/$rel_path"
  done < <(grep -o '"bash.*\.sh"' "$HOOKS_JSON" 2>/dev/null || true)
fi

# ─────────────────────────────────────────────
section "Contexts"
# ─────────────────────────────────────────────

for mode in dev review research; do
  check "Context: $mode.md exists" test -f "$PLUGIN_DIR/contexts/$mode.md"
done

# ─────────────────────────────────────────────
section "Checklists"
# ─────────────────────────────────────────────

CHECKLIST_DIR="$PLUGIN_DIR/commands/checklists"
check "Checklists directory exists" test -d "$CHECKLIST_DIR"
if [ -d "$CHECKLIST_DIR" ]; then
  for cl in "$CHECKLIST_DIR/"*.md; do
    [ -f "$cl" ] || continue
    SIZE=$(wc -c < "$cl")
    check "$(basename "$cl") non-empty" test "$SIZE" -gt 10
  done
fi

# ─────────────────────────────────────────────
section "Cross-References"
# ─────────────────────────────────────────────

# Agent names referenced in commands should have agent files
AGENT_NAMES=$(grep -h "^name:" "$PLUGIN_DIR/agents/"*.md 2>/dev/null | sed 's/^name: *//' | tr -d '\r')
while IFS= read -r agent; do
  [ -z "$agent" ] && continue
  check "Agent '$agent' file exists" test -f "$PLUGIN_DIR/agents/$agent.md"
done <<< "$AGENT_NAMES"

# Check that reference paths in skills actually exist
for skill_dir in "$PLUGIN_DIR/skills/"*/; do
  [ -d "$skill_dir" ] || continue
  SKILL_FILE="$skill_dir/SKILL.md"
  [ -f "$SKILL_FILE" ] || continue
  # Find "See: `references/..." patterns
  while IFS= read -r ref_line; do
    ref_path=$(echo "$ref_line" | grep -oP 'references/[^`]+' || true)
    [ -z "$ref_path" ] && continue
    warn "Skill ref: $ref_path" test -e "$skill_dir/$ref_path"
  done < <(grep '`references/' "$SKILL_FILE" 2>/dev/null || true)
done

# ─────────────────────────────────────────────
section "Manifest"
# ─────────────────────────────────────────────

warn "manifest.yaml exists" test -f "$PLUGIN_DIR/manifest.yaml"

# ─────────────────────────────────────────────
section "Autopilot Steps"
# ─────────────────────────────────────────────

for step in 1 2 3 4 5; do
  STEP_FILE="$PLUGIN_DIR/commands/sdd-autopilot/step-$step-*.md"
  # shellcheck disable=SC2086
  check "Step $step file exists" bash -c "ls $STEP_FILE >/dev/null 2>&1"
done

# ─────────────────────────────────────────────
echo ""
echo "═══════════════════════════════════"
echo "Results: $PASS passed, $FAIL failed, $WARN warnings"
echo "═══════════════════════════════════"

if [ "$FAIL" -gt 0 ]; then
  echo "VALIDATION FAILED"
  exit 1
else
  echo "VALIDATION PASSED"
  exit 0
fi
