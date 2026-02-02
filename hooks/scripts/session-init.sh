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
YOLO_ACTIVE=false
if [ -f "$YOLO_FLAG" ]; then
  YOLO_ACTIVE=true
  echo "SDD: YOLO flag detected — removing flag, guardrails disabled for this session only" >&2
  # Remove yolo flag (auto-clears on session start)
  if ! rm -f "$YOLO_FLAG" 2>/dev/null; then
    echo "SDD WARNING: Could not remove yolo flag at $YOLO_FLAG — guardrails may remain disabled next session" >&2
  fi
  if [ -n "$ENV_FILE" ]; then
    echo "GUARDRAILS_DISABLED=true" >> "$ENV_FILE"
    echo "SDD_YOLO_CLEARED=true" >> "$ENV_FILE"
  fi
  # NOTE: Do not exit here — continue initialization so SDD env vars and
  # skill injection still work. Only guardrails are disabled, not the whole system.
fi

# Set defaults (skip GUARDRAILS_DISABLED if yolo already set it)
if [ -n "$ENV_FILE" ]; then
  if [ "$YOLO_ACTIVE" = "false" ]; then
    echo "GUARDRAILS_DISABLED=false" >> "$ENV_FILE"
  fi
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
  # Read project_name from config
  CONFIG_PROJECT_NAME=$(grep -E '^\s*project_name\s*:' "$CONFIG_FILE" 2>/dev/null | head -1 | sed 's/.*:\s*//' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | tr -d '"'"'" || true)
  # Read spec_dir from config (default: specs)
  CONFIG_SPEC_DIR=$(grep -E '^\s*spec_dir\s*:' "$CONFIG_FILE" 2>/dev/null | head -1 | sed 's/.*:\s*//' | tr -d '[:space:]"'"'" || true)
  # Read test_dir from config
  CONFIG_TEST_DIR=$(grep -E '^\s*test_dir\s*:' "$CONFIG_FILE" 2>/dev/null | head -1 | sed 's/.*:\s*//' | tr -d '[:space:]"'"'" || true)
  # Read verbosity from config (default: standard)
  CONFIG_VERBOSITY=$(grep -E '^\s*verbosity\s*:' "$CONFIG_FILE" 2>/dev/null | head -1 | sed 's/.*:\s*//' | tr -d '[:space:]"'"'" || true)
  if [ -n "$CONFIG_VERBOSITY" ] && ! echo "$CONFIG_VERBOSITY" | grep -qE '^(minimal|standard|verbose)$'; then
    CONFIG_VERBOSITY=""
  fi
  # Read agent extra instructions from config
  # Matches lines like: agents.<name>.extra_instructions: <value>
  # NOTE: This grep-based parsing only supports single-line values. Multi-line YAML values are not supported.
  while IFS= read -r line; do
    AGENT_NAME=$(echo "$line" | sed -n 's/^[[:space:]]*\([a-zA-Z_-]*\):/\1/p' || true)
    if [ -n "$AGENT_NAME" ]; then
      AGENT_EXTRA=$(grep -A5 "^[[:space:]]*${AGENT_NAME}:" "$CONFIG_FILE" 2>/dev/null | grep -E '^\s*extra_instructions\s*:' | head -1 | sed 's/.*:\s*//' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | tr -d '"'"'" || true)
      if [ -n "$AGENT_EXTRA" ] && [ -n "$ENV_FILE" ]; then
        AGENT_UPPER=$(echo "$AGENT_NAME" | tr '[:lower:]-' '[:upper:]_')
        echo "SDD_AGENT_${AGENT_UPPER}_EXTRA=$AGENT_EXTRA" >> "$ENV_FILE"
      fi
    fi
  done < <(awk '/^[[:space:]]*agents:/{found=1; next} found && /^[[:space:]]{2,}[a-zA-Z]/{print} found && /^[^ ]/{exit}' "$CONFIG_FILE" 2>/dev/null || true)
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
  echo "SDD_PROJECT_NAME=${CONFIG_PROJECT_NAME:-}" >> "$ENV_FILE"
  echo "SDD_SPEC_DIR=${CONFIG_SPEC_DIR:-specs}" >> "$ENV_FILE"
  echo "SDD_TEST_DIR=${CONFIG_TEST_DIR:-}" >> "$ENV_FILE"
  echo "SDD_VERBOSITY=${CONFIG_VERBOSITY:-standard}" >> "$ENV_FILE"
fi

# Inject using-sdd skill as additionalContext
if [ -z "${CLAUDE_PLUGIN_ROOT:-}" ]; then
  echo "SDD WARNING: CLAUDE_PLUGIN_ROOT is empty — cannot locate skill and context files" >&2
  exit 0
fi
USING_SDD_PATH="${CLAUDE_PLUGIN_ROOT}/skills/using-sdd/SKILL.md"
if [ -f "$USING_SDD_PATH" ]; then
  # Strip frontmatter and output as additionalContext
  sed '1{/^---$/!q;};1,/^---$/d' "$USING_SDD_PATH"
else
  echo "SDD WARNING: using-sdd skill not found at $USING_SDD_PATH" >&2
fi

# Inject context mode file
CONTEXT_PATH="${CLAUDE_PLUGIN_ROOT}/contexts/${SDD_DEFAULT_MODE}.md"
if [ -f "$CONTEXT_PATH" ]; then
  echo ""
  cat "$CONTEXT_PATH"
else
  echo "SDD WARNING: context file not found at $CONTEXT_PATH" >&2
fi

echo "SDD: Session initialized — mode=$SDD_DEFAULT_MODE, guardrails active" >&2
exit 0
