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

# Check hooks.json exists and is valid JSON
echo ""
echo "hooks.json:"
check "File exists" test -f "$PLUGIN_DIR/hooks/hooks.json"
check "Valid JSON" python3 -c "import json, sys; json.load(open(sys.argv[1]))" "$PLUGIN_DIR/hooks/hooks.json"
check "Has hooks wrapper" python3 -c "
import json, sys
d = json.load(open(sys.argv[1]))
assert 'hooks' in d, 'Missing hooks key'
" "$PLUGIN_DIR/hooks/hooks.json"
check "Has SessionStart hook" python3 -c "
import json, sys
d = json.load(open(sys.argv[1]))
assert 'SessionStart' in d['hooks']
" "$PLUGIN_DIR/hooks/hooks.json"
check "Has UserPromptSubmit hook" python3 -c "
import json, sys
d = json.load(open(sys.argv[1]))
assert 'UserPromptSubmit' in d['hooks']
" "$PLUGIN_DIR/hooks/hooks.json"
check "Has PostToolUse hook" python3 -c "
import json, sys
d = json.load(open(sys.argv[1]))
assert 'PostToolUse' in d['hooks']
" "$PLUGIN_DIR/hooks/hooks.json"
check "Has Stop hook" python3 -c "
import json, sys
d = json.load(open(sys.argv[1]))
assert 'Stop' in d['hooks']
" "$PLUGIN_DIR/hooks/hooks.json"

# Check scripts exist and are executable
echo ""
echo "Hook scripts:"
check "session-init.sh exists" test -f "$PLUGIN_DIR/hooks/scripts/session-init.sh"
check "post-edit-review.sh exists" test -f "$PLUGIN_DIR/hooks/scripts/post-edit-review.sh"
check "session-init.sh is executable or bash-runnable" bash -n "$PLUGIN_DIR/hooks/scripts/session-init.sh"
check "post-edit-review.sh is executable or bash-runnable" bash -n "$PLUGIN_DIR/hooks/scripts/post-edit-review.sh"

# Test session-init.sh runs without error
echo ""
echo "Script execution:"
check "session-init.sh runs without error" bash "$PLUGIN_DIR/hooks/scripts/session-init.sh"

echo ""
echo "─────────────────────"
echo "Results: $PASS passed, $FAIL failed"

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
