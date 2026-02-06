#!/bin/bash
# Test: Skill modules have correct structure, SKILL.md, and reference files
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

echo "=== Skill Tests ==="
echo ""

SKILL_COUNT=0

for skill_dir in "$PLUGIN_DIR/skills/"*/; do
  [ -d "$skill_dir" ] || continue
  skill_name=$(basename "$skill_dir")
  SKILL_COUNT=$((SKILL_COUNT + 1))
  echo "-- $skill_name --"

  SKILL_FILE="$skill_dir/SKILL.md"

  # SKILL.md exists
  assert "[$skill_name] SKILL.md exists" test -f "$SKILL_FILE"

  if [ -f "$SKILL_FILE" ]; then
    # Frontmatter
    assert "[$skill_name] has frontmatter" bash -c "sed -n '1p' '$SKILL_FILE' | grep -q '^---'"
    assert "[$skill_name] has name field" grep -q "^name:" "$SKILL_FILE"
    assert "[$skill_name] has description field" grep -q "^description:" "$SKILL_FILE"

    # Under 3000 words (Claude Code effectiveness limit)
    WORD_COUNT=$(wc -w < "$SKILL_FILE")
    assert "[$skill_name] under 3000 words ($WORD_COUNT)" test "$WORD_COUNT" -lt 3000

    # Non-trivial content
    CHAR_COUNT=$(wc -c < "$SKILL_FILE")
    assert "[$skill_name] has substantial content (>200 chars)" test "$CHAR_COUNT" -gt 200

    # Check that referenced files in SKILL.md actually exist
    while IFS= read -r ref_line; do
      ref_path=$(echo "$ref_line" | grep -oP 'references/[^`\s)]+' || true)
      [ -z "$ref_path" ] && continue
      # Cross-skill refs (e.g. "skills/spec-first/references/...") resolve from plugin root
      if echo "$ref_line" | grep -q 'skills/'; then
        cross_ref=$(echo "$ref_line" | grep -oP 'skills/[^`\s)]+' || true)
        [ -n "$cross_ref" ] && assert "[$skill_name] cross-ref $cross_ref exists" test -e "$PLUGIN_DIR/$cross_ref"
      else
        assert "[$skill_name] ref $ref_path exists" test -e "$skill_dir/$ref_path"
      fi
    done < <(grep 'references/' "$SKILL_FILE" 2>/dev/null || true)
  fi

  # References directory
  if [ -d "$skill_dir/references" ]; then
    REF_COUNT=$(find "$skill_dir/references" -name "*.md" -type f | wc -l)
    assert "[$skill_name] has reference files ($REF_COUNT)" test "$REF_COUNT" -gt 0

    # Each reference file is non-empty
    while IFS= read -r ref_file; do
      ref_name=$(basename "$ref_file")
      SIZE=$(wc -c < "$ref_file")
      assert "[$skill_name] ref $ref_name is non-empty" test "$SIZE" -gt 10
    done < <(find "$skill_dir/references" -name "*.md" -type f)
  fi

  echo ""
done

# Required skills
echo "-- Required Skills --"
for required_skill in guardrails spec-first tdd-discipline iterative-execution architecture-aware performance-optimization using-sdd; do
  assert "Skill $required_skill exists" test -d "$PLUGIN_DIR/skills/$required_skill"
  assert "Skill $required_skill has SKILL.md" test -f "$PLUGIN_DIR/skills/$required_skill/SKILL.md"
done

assert "At least 7 skills" test "$SKILL_COUNT" -ge 7

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
exit $FAIL
