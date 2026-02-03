# SDD Context Modes

SDD has three modes that control which guardrails are active. Switch modes based on your current task.

## The Modes

| Mode | Focus | Use When |
|------|-------|----------|
| **dev** | Build correctly | Implementing features, fixing bugs |
| **review** | Verify and critique | Reviewing code, auditing, verifying |
| **research** | Explore freely | Investigating, prototyping, exploring |

## Guardrail Matrix

| Guardrail | dev | review | research |
|-----------|-----|--------|----------|
| Pre-implementation checkpoint | ✅ Active | ⏭️ Skipped | ⏭️ Skipped |
| Completion review | ✅ Active | ✅ Active | ⏭️ Skipped |
| Scope guard | 🔒 Strict | ⚠️ Normal | 🔓 Relaxed |
| TDD enforcement | ✅ Active | ⏭️ Skipped | ⏭️ Skipped |
| Post-edit review | ✅ Active | ⏭️ Skipped | ⏭️ Skipped |

## Switching Modes

```
/sdd-mode dev       # Full guardrails (default)
/sdd-mode review    # Verification focus
/sdd-mode research  # Exploration mode
/sdd-mode           # Show current mode
```

## Default Mode

Set a default mode in `.sdd.yaml`:

```yaml
mode: dev  # dev | review | research
```

## Mode vs Phase

- **Mode** = which guardrails are active (HOW you work)
- **Phase** = where you are in development (WHAT you're doing)

Example combinations:
- `dev` mode + `implement` phase = normal development
- `review` mode + `implement` phase = cautious implementation with extra scrutiny
- `research` mode + `specify` phase = exploring requirements freely
