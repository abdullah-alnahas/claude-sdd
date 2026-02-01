#!/bin/bash
# SDD Self-Test: Verify hooks configuration and scripts
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

echo "SDD Hook Verification"
echo "─────────────────────"

# Detect Python interpreter
PYTHON=""
for candidate in python3 python; do
  if command -v "$candidate" &>/dev/null; then
    PYTHON="$candidate"
    break
  fi
done

# Check hooks.json exists and is valid JSON
echo ""
echo "hooks.json:"
check "File exists" test -f "$PLUGIN_DIR/hooks/hooks.json"
if [ -n "$PYTHON" ]; then
  check "Valid JSON" "$PYTHON" -c "import json, sys; json.load(open(sys.argv[1]))" "$PLUGIN_DIR/hooks/hooks.json"
  check "Has hooks wrapper" "$PYTHON" -c "
import json, sys
d = json.load(open(sys.argv[1]))
assert 'hooks' in d, 'Missing hooks key'
" "$PLUGIN_DIR/hooks/hooks.json"
  check "Has SessionStart hook" "$PYTHON" -c "
import json, sys
d = json.load(open(sys.argv[1]))
assert 'SessionStart' in d['hooks']
" "$PLUGIN_DIR/hooks/hooks.json"
  check "Has UserPromptSubmit hook" "$PYTHON" -c "
import json, sys
d = json.load(open(sys.argv[1]))
assert 'UserPromptSubmit' in d['hooks']
" "$PLUGIN_DIR/hooks/hooks.json"
  check "Has PostToolUse hook" "$PYTHON" -c "
import json, sys
d = json.load(open(sys.argv[1]))
assert 'PostToolUse' in d['hooks']
" "$PLUGIN_DIR/hooks/hooks.json"
  check "Has Stop hook" "$PYTHON" -c "
import json, sys
d = json.load(open(sys.argv[1]))
assert 'Stop' in d['hooks']
" "$PLUGIN_DIR/hooks/hooks.json"
else
  echo "  ⚠ Python not found — skipping JSON validation (install python3 or activate a venv)"
  FAIL=$((FAIL + 1))
fi

# Check scripts exist and are executable
echo ""
echo "Hook scripts:"
check "session-init.sh exists" test -f "$PLUGIN_DIR/hooks/scripts/session-init.sh"
check "post-edit-review.sh exists" test -f "$PLUGIN_DIR/hooks/scripts/post-edit-review.sh"
check "session-init.sh is executable or bash-runnable" bash -n "$PLUGIN_DIR/hooks/scripts/session-init.sh"
check "post-edit-review.sh is executable or bash-runnable" bash -n "$PLUGIN_DIR/hooks/scripts/post-edit-review.sh"

# Test session-init.sh runs without error (in isolated temp dir to avoid side effects)
echo ""
echo "Script execution:"
check "session-init.sh runs without error" bash -c "
  TMPDIR=\$(mktemp -d)
  CLAUDE_PROJECT_DIR=\"\$TMPDIR\" CLAUDE_ENV_FILE=\"\" bash \"$PLUGIN_DIR/hooks/scripts/session-init.sh\" 2>/dev/null
  rc=\$?
  rm -rf \"\$TMPDIR\"
  exit \$rc
"

echo ""
echo "─────────────────────"
echo "Results: $PASS passed, $FAIL failed"

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
