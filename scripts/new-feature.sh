#!/bin/bash
# SDD New Feature Script
# Creates a numbered feature directory with templates

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
SPECS_DIR="${SDD_SPEC_DIR:-specs}"
TEMPLATES_DIR="$PROJECT_ROOT/skills/spec-first/references/templates"

# Check arguments
if [ $# -lt 1 ]; then
  echo "Usage: $0 <feature-name>" >&2
  echo "Example: $0 user-authentication" >&2
  exit 1
fi

FEATURE_NAME="$1"
# Sanitize feature name (lowercase, hyphens only)
FEATURE_NAME=$(echo "$FEATURE_NAME" | tr '[:upper:]' '[:lower:]' | tr ' _' '-' | tr -cd 'a-z0-9-')

if [ -z "$FEATURE_NAME" ]; then
  echo "Error: Invalid feature name" >&2
  exit 1
fi

# Ensure specs directory exists
mkdir -p "$SPECS_DIR"

# File locking to prevent race conditions
LOCK_FILE="/tmp/sdd-new-feature.lock"
exec 200>"$LOCK_FILE"
if ! flock -n 200; then
  echo "Error: Another new-feature.sh is running. Waiting..." >&2
  flock 200
fi

# Find next number
LAST_NUM=0
for dir in "$SPECS_DIR"/[0-9][0-9][0-9]-*/; do
  if [ -d "$dir" ]; then
    NUM=$(basename "$dir" | cut -c1-3)
    if [ "$NUM" -gt "$LAST_NUM" ] 2>/dev/null; then
      LAST_NUM=$NUM
    fi
  fi
done
NEXT_NUM=$((LAST_NUM + 1))
NEXT_NUM_PADDED=$(printf "%03d" $NEXT_NUM)

# Create feature directory
FEATURE_DIR="$SPECS_DIR/${NEXT_NUM_PADDED}-${FEATURE_NAME}"

if [ -d "$FEATURE_DIR" ]; then
  echo "Error: Directory already exists: $FEATURE_DIR" >&2
  exit 1
fi

mkdir -p "$FEATURE_DIR"

# Copy templates if they exist
if [ -f "$TEMPLATES_DIR/proposal.md" ]; then
  sed "s/\[Feature Name\]/$FEATURE_NAME/g" "$TEMPLATES_DIR/proposal.md" > "$FEATURE_DIR/proposal.md"
else
  cat > "$FEATURE_DIR/proposal.md" << EOF
# Proposal: $FEATURE_NAME

## Rationale

[Why are we building this?]

## Scope

### In Scope
-

### Out of Scope
-
EOF
fi

# Create behavior-spec.md
cat > "$FEATURE_DIR/behavior-spec.md" << EOF
# Behavior Spec: $FEATURE_NAME

## Acceptance Criteria

### AC1: [First criterion]

**Given** [precondition]
**When** [action]
**Then** [expected result]

### AC2: [Second criterion]

**Given** [precondition]
**When** [action]
**Then** [expected result]

## Verification

- [ ] AC1: [description]
- [ ] AC2: [description]
EOF

echo "→ SDD: Created feature directory: $FEATURE_DIR"
echo "  - proposal.md"
echo "  - behavior-spec.md"
echo ""
echo "Next steps:"
echo "  1. Edit $FEATURE_DIR/proposal.md (rationale, scope)"
echo "  2. Edit $FEATURE_DIR/behavior-spec.md (acceptance criteria)"
echo "  3. Run /sdd-execute to implement"

# Release lock
flock -u 200
