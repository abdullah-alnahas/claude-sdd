---
name: sdd-yolo
description: Temporarily disable all SDD guardrails for this session
---

# /sdd-yolo

Disables all guardrails for the current session. Use when you need to move fast without discipline checks.

## Behavior

1. Create `.sdd-yolo` flag file in the project root
2. Set `GUARDRAILS_DISABLED=true` for the current session context
3. All hooks check this flag and skip their checks when set
4. The flag auto-clears on next session start (session-init.sh removes it)
5. Can also be cleared manually with `/sdd-guardrails enable`

## Output

```
⚠ YOLO MODE ACTIVATED

All SDD guardrails are disabled for this session:
  - Pre-implementation checkpoint: SKIPPED
  - Scope guard: SKIPPED
  - Completion review: SKIPPED

Guardrails will re-enable automatically on next session start.
To re-enable now: /sdd-guardrails enable
```

## Warning

YOLO mode disables ALL behavioral guardrails. This means:
- No assumption checking before implementation
- No scope creep detection
- No completion review
- No TDD enforcement reminders

Use sparingly. The guardrails exist because LLMs (including this one) make predictable mistakes without them.
