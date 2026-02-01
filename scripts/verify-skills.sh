#!/bin/bash
# SDD Self-Test: Verify skills structure and content
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PASS=0
FAIL=0

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

echo "SDD Skill Verification"
echo "──────────────────────"

SKILLS=("guardrails" "spec-first" "architecture-aware" "tdd-discipline" "iterative-execution" "performance-optimization")

for skill in "${SKILLS[@]}"; do
  echo ""
  echo "Skill: $skill"
  SKILL_DIR="$PLUGIN_DIR/skills/$skill"

  check "Directory exists" test -d "$SKILL_DIR"
  check "SKILL.md exists" test -f "$SKILL_DIR/SKILL.md"
  check "SKILL.md has frontmatter" bash -c "sed -n '1p' \"$SKILL_DIR/SKILL.md\" | grep -q '^---'"
  check "SKILL.md has name field" grep -q "^name:" "$SKILL_DIR/SKILL.md"
  check "SKILL.md has description field" grep -q "^description:" "$SKILL_DIR/SKILL.md"

  # Check SKILL.md body is under 3000 words
  if [ -f "$SKILL_DIR/SKILL.md" ]; then
    WORD_COUNT=$(wc -w < "$SKILL_DIR/SKILL.md")
    check "SKILL.md under 3000 words ($WORD_COUNT)" test "$WORD_COUNT" -lt 3000
  fi

  # Check references exist
  if [ -d "$SKILL_DIR/references" ]; then
    REF_COUNT=$(find "$SKILL_DIR/references" -name "*.md" -type f | wc -l)
    check "Has reference files ($REF_COUNT found)" test "$REF_COUNT" -gt 0

    # Check no empty reference files
    while IFS= read -r ref; do
      SIZE=$(wc -c < "$ref")
      check "$(basename "$ref") is non-empty" test "$SIZE" -gt 10
    done < <(find "$SKILL_DIR/references" -name "*.md" -type f)
  fi
done

# Check templates
echo ""
echo "Templates:"
TEMPLATE_DIR="$PLUGIN_DIR/skills/spec-first/references/templates"
check "Templates directory exists" test -d "$TEMPLATE_DIR"
TEMPLATES=("app-description.md" "architecture.md" "stack.md" "roadmap.md" "behavior-spec.md" "test-plan.md" "retrospective.md")
for tmpl in "${TEMPLATES[@]}"; do
  check "Template: $tmpl exists" test -f "$TEMPLATE_DIR/$tmpl"
done

echo ""
echo "──────────────────────"
echo "Results: $PASS passed, $FAIL failed"

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
