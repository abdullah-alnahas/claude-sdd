#!/bin/bash
# SDD Session Initialization Hook
# Loads .sdd.yaml config, sets environment variables, checks yolo flag, injects using-sdd skill

set -euo pipefail

# Validate plugin environment
if [ -z "${CLAUDE_PLUGIN_ROOT:-}" ]; then
  echo "SDD WARNING: CLAUDE_PLUGIN_ROOT is not set — hooks may not locate plugin resources" >&2
fi

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
ENV_FILE="${CLAUDE_ENV_FILE:-}"
CONFIG_FILE="$PROJECT_DIR/.sdd.yaml"
YOLO_FLAG="$PROJECT_DIR/.sdd-yolo"

# Check for yolo mode
if [ -f "$YOLO_FLAG" ]; then
  echo "SDD: Previous YOLO mode detected — clearing flag, guardrails disabled for this session" >&2
  # Remove yolo flag (auto-clears on session start)
  if ! rm -f "$YOLO_FLAG" 2>/dev/null; then
    echo "SDD WARNING: Could not remove yolo flag at $YOLO_FLAG — guardrails may remain disabled next session" >&2
  fi
  if [ -n "$ENV_FILE" ]; then
    echo "GUARDRAILS_DISABLED=true" >> "$ENV_FILE"
    echo "SDD_YOLO_CLEARED=true" >> "$ENV_FILE"
  fi
  exit 0
fi

# Set defaults
if [ -n "$ENV_FILE" ]; then
  echo "GUARDRAILS_DISABLED=false" >> "$ENV_FILE"
  echo "SDD_ACTIVE=true" >> "$ENV_FILE"
fi

# Check for config file and read settings
SDD_DEFAULT_MODE="dev"
SDD_COMPACTION_THRESHOLD="50"
if [ -f "$CONFIG_FILE" ]; then
  echo "SDD: Config file found at $CONFIG_FILE" >&2
  if [ -n "$ENV_FILE" ]; then
    echo "SDD_CONFIG_FOUND=true" >> "$ENV_FILE"
  fi
  # Read mode from config (grep-based, no yaml parser needed)
  CONFIG_MODE=$(grep -E '^\s*mode\s*:' "$CONFIG_FILE" 2>/dev/null | head -1 | sed 's/.*:\s*//' | tr -d '[:space:]"'"'" || true)
  if [ -n "$CONFIG_MODE" ] && echo "$CONFIG_MODE" | grep -qE '^(dev|review|research)$'; then
    SDD_DEFAULT_MODE="$CONFIG_MODE"
  fi
  # Read compaction threshold from config
  CONFIG_THRESHOLD=$(grep -E '^\s*compaction_threshold\s*:' "$CONFIG_FILE" 2>/dev/null | head -1 | sed 's/.*:\s*//' | tr -d '[:space:]"'"'" || true)
  if [ -n "$CONFIG_THRESHOLD" ] && echo "$CONFIG_THRESHOLD" | grep -qE '^[0-9]+$'; then
    SDD_COMPACTION_THRESHOLD="$CONFIG_THRESHOLD"
  fi
else
  echo "SDD: No .sdd.yaml found — using defaults" >&2
  if [ -n "$ENV_FILE" ]; then
    echo "SDD_CONFIG_FOUND=false" >> "$ENV_FILE"
  fi
fi

# Set mode and compaction threshold in env
if [ -n "$ENV_FILE" ]; then
  echo "SDD_MODE=$SDD_DEFAULT_MODE" >> "$ENV_FILE"
  echo "SDD_COMPACTION_THRESHOLD=$SDD_COMPACTION_THRESHOLD" >> "$ENV_FILE"
fi

# Inject using-sdd skill as additionalContext
USING_SDD_PATH="${CLAUDE_PLUGIN_ROOT:-}/skills/using-sdd/SKILL.md"
if [ -f "$USING_SDD_PATH" ]; then
  # Strip frontmatter and output as additionalContext
  sed '1{/^---$/!q;};1,/^---$/d' "$USING_SDD_PATH"
else
  echo "SDD WARNING: using-sdd skill not found at $USING_SDD_PATH" >&2
fi

# Inject context mode file
CONTEXT_PATH="${CLAUDE_PLUGIN_ROOT:-}/contexts/${SDD_DEFAULT_MODE}.md"
if [ -f "$CONTEXT_PATH" ]; then
  echo ""
  cat "$CONTEXT_PATH"
else
  echo "SDD WARNING: context file not found at $CONTEXT_PATH" >&2
fi

echo "SDD: Session initialized — mode=$SDD_DEFAULT_MODE, guardrails active" >&2
exit 0
