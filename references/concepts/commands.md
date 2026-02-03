# SDD Command Reference

Quick reference for all SDD commands.

## Essential Commands

Start here when using SDD.

| Command | What It Does |
|---------|--------------|
| `/sdd-status` | Show project state — what exists, what's missing, what to do next |
| `/sdd-init` | Interactive setup wizard — generates `.sdd.yaml` |
| `/sdd-execute` | Start TDD execution loop (the main workflow) |
| `/sdd-verify` | Run automated checks — build, types, lint, tests |

## Standard Commands

Regular workflow commands.

| Command | What It Does |
|---------|--------------|
| `/sdd-phase` | Show/set development phase (specify/design/implement/verify/review) |
| `/sdd-mode` | Switch context mode (dev/review/research) |
| `/sdd-review` | Two-stage agent review — spec compliance then code quality |
| `/sdd-track` | Task tracking via status.yaml |
| `/sdd-guardrails` | Show/toggle guardrail status |
| `/sdd-yolo` | Disable all guardrails (escape hatch, auto-clears) |

## Advanced Commands

For power users and custom workflows.

| Command | What It Does |
|---------|--------------|
| `/sdd-orchestrate` | Custom agent pipelines — feature, bugfix, refactor, security |
| `/sdd-challenge` | Adversarial modes — grill (find flaws), prove (verify works), elegant (simplify) |
| `/sdd-context` | Generate LLM-optimized project context document |

## Deprecated Commands

These still work but print warnings.

| Command | Replacement |
|---------|-------------|
| `/sdd-adopt` | Use `/sdd-init` |
| `/sdd-autopilot` | Use `/sdd-execute --auto` |

## Removed Commands

These are no longer available.

| Command | Alternative |
|---------|-------------|
| `/sdd-replan` | Use `/sdd-phase design` |
| `/sdd-learn` | Edit CLAUDE.md directly |
| `/sdd-techdebt` | Use `/sdd-review` with techdebt focus |
| `/sdd-explain` | Ask Claude directly |

## Common Workflows

### New project

```
/sdd-init                    # Setup config
/sdd-execute "build X"       # Start TDD loop
```

### Existing project

```
/sdd-status                  # See what exists
/sdd-init                    # Setup config if needed
/sdd-execute                 # Continue from spec
```

### Quick fix

```
/sdd-mode research           # Relax guardrails
# Make changes
/sdd-verify                  # Check it works
```

### Code review

```
/sdd-mode review             # Review mode
/sdd-review                  # Run agent review
```
