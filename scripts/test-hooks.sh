#!/bin/bash
# SDD Behavioral Tests: Verify hooks execute correctly with controlled inputs
# Traces to: specs/behavior-spec.md Section 1 (Hooks)
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PASS=0
FAIL=0
TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT

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

check_contains() {
  local desc="$1"
  local file="$2"
  local pattern="$3"
  if grep -q "$pattern" "$file" 2>/dev/null; then
    echo "  ✓ $desc"
    PASS=$((PASS + 1))
  else
    echo "  ✗ $desc (pattern '$pattern' not found in $file)"
    FAIL=$((FAIL + 1))
  fi
}

check_not_exists() {
  local desc="$1"
  local file="$2"
  if [ ! -f "$file" ]; then
    echo "  ✓ $desc"
    PASS=$((PASS + 1))
  else
    echo "  ✗ $desc (file still exists: $file)"
    FAIL=$((FAIL + 1))
  fi
}

echo "SDD Behavioral Tests — Hooks"
echo "════════════════════════════"

# ─── session-init.sh ───

echo ""
echo "session-init.sh"
echo "───────────────"

# Test 1.1.1: Default init (no config, no yolo)
echo ""
echo "Spec 1.1.1: Default init"
ENV_FILE="$TMPDIR/env-default"
touch "$ENV_FILE"
CLAUDE_PROJECT_DIR="$TMPDIR" CLAUDE_ENV_FILE="$ENV_FILE" \
  bash "$PLUGIN_DIR/hooks/scripts/session-init.sh" 2>/dev/null
check_contains "SDD_ACTIVE=true" "$ENV_FILE" "SDD_ACTIVE=true"
check_contains "GUARDRAILS_DISABLED=false" "$ENV_FILE" "GUARDRAILS_DISABLED=false"

# Test 1.1.2: Yolo flag present
echo ""
echo "Spec 1.1.2: Yolo flag"
ENV_FILE="$TMPDIR/env-yolo"
touch "$ENV_FILE"
touch "$TMPDIR/.sdd-yolo"
CLAUDE_PROJECT_DIR="$TMPDIR" CLAUDE_ENV_FILE="$ENV_FILE" \
  bash "$PLUGIN_DIR/hooks/scripts/session-init.sh" 2>/dev/null
check_contains "GUARDRAILS_DISABLED=true" "$ENV_FILE" "GUARDRAILS_DISABLED=true"
check_not_exists "Yolo flag removed" "$TMPDIR/.sdd-yolo"

# Test 1.1.3: Config found
echo ""
echo "Spec 1.1.3: Config file exists"
ENV_FILE="$TMPDIR/env-config"
touch "$ENV_FILE"
echo "enabled: true" > "$TMPDIR/.sdd.yaml"
CLAUDE_PROJECT_DIR="$TMPDIR" CLAUDE_ENV_FILE="$ENV_FILE" \
  bash "$PLUGIN_DIR/hooks/scripts/session-init.sh" 2>/dev/null
check_contains "SDD_CONFIG_FOUND=true" "$ENV_FILE" "SDD_CONFIG_FOUND=true"

# Test 1.1.4: No config
echo ""
echo "Spec 1.1.4: No config file"
TMPDIR2=$(mktemp -d)
ENV_FILE="$TMPDIR2/env-noconfig"
touch "$ENV_FILE"
CLAUDE_PROJECT_DIR="$TMPDIR2" CLAUDE_ENV_FILE="$ENV_FILE" \
  bash "$PLUGIN_DIR/hooks/scripts/session-init.sh" 2>/dev/null
check_contains "SDD_CONFIG_FOUND=false" "$ENV_FILE" "SDD_CONFIG_FOUND=false"
rm -rf "$TMPDIR2"

# ─── post-edit-review.sh ───

echo ""
echo "post-edit-review.sh"
echo "───────────────────"

# Test 1.3.3: Guardrails disabled → skip
echo ""
echo "Spec 1.3.3: Guardrails disabled"
check "Exits 0 when guardrails disabled" bash -c \
  'echo "{}" | GUARDRAILS_DISABLED=true bash '"$PLUGIN_DIR"'/hooks/scripts/post-edit-review.sh'

# Test 1.3 normal: Edit inside project
echo ""
echo "Spec 1.3: Normal edit"
check "Exits 0 for project-relative file" bash -c \
  'echo "{\"file_path\": \"'$TMPDIR'/src/main.ts\"}" | CLAUDE_PROJECT_DIR="'$TMPDIR'" bash '"$PLUGIN_DIR"'/hooks/scripts/post-edit-review.sh'

# Test 1.3.1: Edit outside project
echo ""
echo "Spec 1.3.1: Edit outside project"
RESULT=0
echo '{"file_path": "/etc/something"}' | CLAUDE_PROJECT_DIR="$TMPDIR" \
  bash "$PLUGIN_DIR/hooks/scripts/post-edit-review.sh" 2>/dev/null || RESULT=$?
if [ "$RESULT" -eq 2 ]; then
  echo "  ✓ Exits 2 for outside-project edit"
  PASS=$((PASS + 1))
else
  echo "  ✗ Expected exit 2, got $RESULT"
  FAIL=$((FAIL + 1))
fi

echo ""
echo "════════════════════════════"
echo "Results: $PASS passed, $FAIL failed"

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
