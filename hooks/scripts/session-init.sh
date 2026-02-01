#!/bin/bash
# SDD Session Initialization Hook
# Loads .sdd.yaml config, sets environment variables, checks yolo flag

set -euo pipefail

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

# Check for config file
if [ -f "$CONFIG_FILE" ]; then
  echo "SDD: Config file found at $CONFIG_FILE" >&2
  if [ -n "$ENV_FILE" ]; then
    echo "SDD_CONFIG_FOUND=true" >> "$ENV_FILE"
  fi
else
  echo "SDD: No .sdd.yaml found — using defaults" >&2
  if [ -n "$ENV_FILE" ]; then
    echo "SDD_CONFIG_FOUND=false" >> "$ENV_FILE"
  fi
fi

echo "SDD: Session initialized — guardrails active" >&2
exit 0
