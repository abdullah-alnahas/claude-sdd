#!/bin/bash
# SDD Post-Edit Review Hook
# Detects scope creep by checking if edited files are related to the current task

set -euo pipefail

# Skip if guardrails disabled
if [ "${GUARDRAILS_DISABLED:-false}" = "true" ]; then
  exit 0
fi

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
# Resolve to absolute path (POSIX-compatible fallback when realpath unavailable)
if command -v realpath &>/dev/null; then
  PROJECT_DIR=$(realpath "$PROJECT_DIR" 2>/dev/null || echo "$PROJECT_DIR")
else
  PROJECT_DIR=$(cd "$PROJECT_DIR" 2>/dev/null && pwd || echo "$PROJECT_DIR")
fi

# Read tool input from stdin (JSON with file_path)
INPUT=$(cat)

# Use jq if available, fall back to sed
if command -v jq &>/dev/null; then
  FILE_PATH=$(echo "$INPUT" | jq -r '.file_path // .filePath // empty' 2>/dev/null || true)
  if [ -z "$FILE_PATH" ]; then
    echo "SDD: post-edit-review skipped — could not parse file_path from hook input" >&2
    exit 0
  fi
else
  FILE_PATH=$(echo "$INPUT" | sed -n 's/.*"file_path"[ \t]*:[ \t]*"\([^"]*\)".*/\1/p' | head -1)
  if [ -z "$FILE_PATH" ]; then
    FILE_PATH=$(echo "$INPUT" | sed -n 's/.*"filePath"[ \t]*:[ \t]*"\([^"]*\)".*/\1/p' | head -1)
  fi
fi

if [ -z "$FILE_PATH" ]; then
  echo "SDD: post-edit-review skipped — no file_path in hook input" >&2
  exit 0
fi

# Resolve file path to absolute for consistent comparison
if command -v realpath &>/dev/null; then
  FILE_PATH=$(realpath "$FILE_PATH" 2>/dev/null || echo "$FILE_PATH")
elif [ -f "$FILE_PATH" ]; then
  FILE_PATH=$(cd "$(dirname "$FILE_PATH")" 2>/dev/null && echo "$(pwd)/$(basename "$FILE_PATH")" || echo "$FILE_PATH")
fi

# Check if inside project directory
case "$FILE_PATH" in
  "$PROJECT_DIR/"*|"$PROJECT_DIR") ;; # Inside project, OK
  /*)
    echo "SDD SCOPE WARNING: Edit to file outside project directory: $FILE_PATH" >&2
    exit 2
    ;;
esac

# Check git status for unrelated modifications
if command -v git &>/dev/null && [ -d "$PROJECT_DIR/.git" ]; then
  MODIFIED_COUNT=$(cd "$PROJECT_DIR" && git diff --name-only 2>/dev/null | wc -l | tr -d ' ')
  if [ "$MODIFIED_COUNT" -gt 10 ]; then
    echo "SDD SCOPE WARNING: $MODIFIED_COUNT files modified — possible scope creep. Review changes with 'git diff --stat'" >&2
    exit 2
  fi
fi

exit 0
