#!/bin/bash
# SDD Post-Edit Review Hook
# Detects scope creep by checking if edited files are related to the current task

set -euo pipefail

# Skip if guardrails disabled
if [ "${GUARDRAILS_DISABLED:-false}" = "true" ]; then
  exit 0
fi

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"

# Read tool input from stdin (JSON with file_path)
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | grep -oP '"file_path"\s*:\s*"([^"]*)"' | head -1 | sed 's/.*"\([^"]*\)"/\1/' 2>/dev/null || echo "")

if [ -z "$FILE_PATH" ]; then
  # Try alternate JSON key names
  FILE_PATH=$(echo "$INPUT" | grep -oP '"filePath"\s*:\s*"([^"]*)"' | head -1 | sed 's/.*"\([^"]*\)"/\1/' 2>/dev/null || echo "")
fi

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Check if inside project directory
case "$FILE_PATH" in
  "$PROJECT_DIR"*) ;; # Inside project, OK
  /*)
    echo "SDD SCOPE WARNING: Edit to file outside project directory: $FILE_PATH" >&2
    exit 2
    ;;
esac

# Check git status for unrelated modifications
if command -v git &>/dev/null && [ -d "$PROJECT_DIR/.git" ]; then
  MODIFIED_COUNT=$(cd "$PROJECT_DIR" && git diff --name-only 2>/dev/null | wc -l)
  if [ "$MODIFIED_COUNT" -gt 10 ]; then
    echo "SDD SCOPE WARNING: $MODIFIED_COUNT files modified — possible scope creep. Review changes with 'git diff --stat'" >&2
    exit 2
  fi
fi

exit 0
