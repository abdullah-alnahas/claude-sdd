#!/bin/bash
# SDD Completion Review Hook
# Triggers completion review guardrail via additionalContext output
# Uses command-type hook to avoid prompt-based Stop hook bugs (see issues #11947, #13155)

set -euo pipefail

# Skip if guardrails disabled
if [ "${GUARDRAILS_DISABLED:-false}" = "true" ]; then
  exit 0
fi

# Skip if in research mode (relaxed guardrails)
if [ "${SDD_MODE:-dev}" = "research" ]; then
  exit 0
fi

# Skip if in review mode (completion review already part of workflow)
if [ "${SDD_MODE:-dev}" = "review" ]; then
  exit 0
fi

# Output completion review reminder to stderr (shown to user)
# The actual review is performed by Claude following the guardrails skill
echo "SDD: Completion review triggered. Checking: spec adherence, test coverage, complexity, dead code, scope creep." >&2

exit 0
