---
name: sdd-guardrails
description: Show guardrail status, toggle individual guardrails, and view configuration
argument-hint: "[enable|disable <name>]"
allowed-tools:
  - Read
  - Write
  - Bash
---

# /sdd-guardrails

Show the current state of all SDD guardrails and optionally toggle them.

## Usage

- `/sdd-guardrails` — Show status of all guardrails
- `/sdd-guardrails disable <name>` — Disable a specific guardrail
- `/sdd-guardrails enable <name>` — Re-enable a specific guardrail

## Guardrails

| Name | Hook | Purpose |
|------|------|---------|
| `pre-implementation` | UserPromptSubmit | Assumption check, ambiguity flagging, scope definition, TDD planning |
| `scope-guard` | PostToolUse (Write/Edit) | Detect unrelated file modifications |
| `completion-review` | Stop | Spec adherence, test coverage, complexity audit, dead code check |

## Behavior

1. Check if `.sdd.yaml` exists in project root — if so, read guardrail config from it
2. Check if `GUARDRAILS_DISABLED=true` (set by `/sdd-yolo`) — if so, report all disabled
3. Display each guardrail with its enabled/disabled status
4. If an argument is provided, toggle the specified guardrail

## Output Format

```
SDD Guardrails Status
─────────────────────
  pre-implementation .... enabled
  scope-guard ........... enabled
  completion-review ..... enabled

Config: .sdd.yaml (found / not found — using defaults)
```
