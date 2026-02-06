#!/bin/bash
# Test: Hook configuration is valid and all referenced scripts exist and are executable
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

echo "=== Hook Tests ==="
echo ""

HOOKS_JSON="$PLUGIN_DIR/hooks/hooks.json"

# --- hooks.json validity ---
echo "-- hooks.json --"
assert "hooks.json exists" test -f "$HOOKS_JSON"
assert "hooks.json is valid JSON" python3 -c "import json; json.load(open('$HOOKS_JSON'))"
assert "hooks.json has 'hooks' key" python3 -c "import json; d=json.load(open('$HOOKS_JSON')); assert 'hooks' in d"

# --- Event types are valid ---
echo ""
echo "-- Event Types --"
VALID_EVENTS="PreToolUse PostToolUse Stop SubagentStop SessionStart SessionEnd UserPromptSubmit PreCompact Notification"
HOOK_EVENTS=$(python3 -c "
import json
d = json.load(open('$HOOKS_JSON'))
for k in d['hooks']:
    print(k)
")
while IFS= read -r event; do
  [ -z "$event" ] && continue
  assert "Event '$event' is a valid hook event" echo "$VALID_EVENTS" | grep -qw "$event"
done <<< "$HOOK_EVENTS"

# --- Expected events are configured ---
echo ""
echo "-- Required Events --"
for required_event in SessionStart UserPromptSubmit PostToolUse Stop; do
  assert "Event $required_event is configured" python3 -c "
import json
d = json.load(open('$HOOKS_JSON'))
assert '$required_event' in d['hooks'], '$required_event not found'
"
done

# --- Hook entries have valid structure ---
echo ""
echo "-- Hook Entry Structure --"
python3 -c "
import json, sys
d = json.load(open('$HOOKS_JSON'))
for event, matchers in d['hooks'].items():
    for m in matchers:
        if 'matcher' not in m:
            print(f'MISSING matcher in {event}')
            sys.exit(1)
        if 'hooks' not in m:
            print(f'MISSING hooks in {event}')
            sys.exit(1)
        for h in m['hooks']:
            if 'type' not in h:
                print(f'MISSING type in {event} hook')
                sys.exit(1)
            if h['type'] not in ('command', 'prompt'):
                print(f'INVALID type {h[\"type\"]} in {event}')
                sys.exit(1)
" && {
  echo "  PASS: All hook entries have valid structure"
  PASS=$((PASS + 1))
} || {
  echo "  FAIL: Hook entry structure invalid"
  FAIL=$((FAIL + 1))
}

# --- Command hooks reference existing scripts ---
echo ""
echo "-- Hook Scripts --"
SCRIPT_PATHS=$(python3 -c "
import json
d = json.load(open('$HOOKS_JSON'))
for event, matchers in d['hooks'].items():
    for m in matchers:
        for h in m['hooks']:
            if h['type'] == 'command' and 'command' in h:
                cmd = h['command']
                # Extract script path relative to plugin root
                if '\$CLAUDE_PLUGIN_ROOT/' in cmd:
                    path = cmd.split('\$CLAUDE_PLUGIN_ROOT/')[-1].strip('\"')
                    print(path)
")
while IFS= read -r script_rel; do
  [ -z "$script_rel" ] && continue
  script_path="$PLUGIN_DIR/$script_rel"
  assert "Script $script_rel exists" test -f "$script_path"
  assert "Script $script_rel is non-empty" test -s "$script_path"
  # Verify it starts with shebang or is valid bash
  FIRST_LINE=$(head -1 "$script_path")
  assert "Script $script_rel has shebang" echo "$FIRST_LINE" | grep -q '^#!/'
done <<< "$SCRIPT_PATHS"

# --- Command hooks have timeouts ---
echo ""
echo "-- Hook Timeouts --"
python3 -c "
import json, sys
d = json.load(open('$HOOKS_JSON'))
for event, matchers in d['hooks'].items():
    for m in matchers:
        for h in m['hooks']:
            if h['type'] == 'command':
                if 'timeout' not in h:
                    print(f'MISSING timeout in {event} command hook')
                    sys.exit(1)
                if not isinstance(h['timeout'], (int, float)):
                    print(f'INVALID timeout type in {event}')
                    sys.exit(1)
                if h['timeout'] <= 0 or h['timeout'] > 60:
                    print(f'UNREASONABLE timeout {h[\"timeout\"]}s in {event}')
                    sys.exit(1)
" && {
  echo "  PASS: All command hooks have reasonable timeouts"
  PASS=$((PASS + 1))
} || {
  echo "  FAIL: Hook timeout issue"
  FAIL=$((FAIL + 1))
}

# --- Hook scripts run without error (dry-run / syntax check) ---
echo ""
echo "-- Hook Script Syntax --"
for script in "$PLUGIN_DIR/hooks/scripts/"*.sh; do
  [ -f "$script" ] || continue
  script_name=$(basename "$script")
  assert "[$script_name] passes bash syntax check" bash -n "$script"
done

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
exit $FAIL
