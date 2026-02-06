# Stack: SDD Plugin

**Version**: 0.12.0
**Date**: 2026-02-07

## Technology

- **Platform**: Claude Code Plugin (`.claude-plugin/plugin.json` manifest)
- **Languages**: Markdown (commands, agents, skills), Bash (hooks, scripts), JSON (config)
- **Runtime**: Claude Code CLI — no external runtime required
- **No dependencies**: Zero npm/pip/system dependencies beyond Claude Code itself

## Component Inventory

### Commands (Markdown — 25 files)
- `commands/*.md` — Slash commands with YAML frontmatter
- `commands/sdd-autopilot/step-*.md` — Multi-step autopilot workflow
- `commands/checklists/*.md` — Validation checklist templates

### Skills (Markdown — 7 skill modules)
Each skill: `skills/<name>/SKILL.md` + `references/` subdirectory

| Skill | References |
|-------|------------|
| using-sdd | 1 |
| spec-first | 13 (includes 8 templates) |
| tdd-discipline | 2 |
| iterative-execution | 5 |
| guardrails | 3 |
| architecture-aware | 3 |
| performance-optimization | 2 |

### Agents (Markdown — 6 agents)
- `agents/*.md` — Subagent definitions with persona, review process, output format

### Hooks (JSON + Bash — 4 events, 4 scripts)
- `hooks/hooks.json` — Event configuration
- `hooks/scripts/*.sh` — Hook implementations

### Scripts (Bash — 6 validation/setup scripts)
- `scripts/validate-plugin.sh` — Comprehensive plugin validation
- `scripts/verify-commands.sh`, `verify-skills.sh`, `verify-hooks.sh`
- `scripts/new-feature.sh`, `scripts/test-hooks.sh`

### Config Files
- `.claude-plugin/plugin.json` — Plugin manifest
- `.claude-plugin/marketplace.json` — Distribution metadata
- `package.json` — npm package metadata
- `contexts/*.md` — Mode-specific context (dev, review, research)

## File Format Conventions

### Command files
```yaml
---
name: command-name
description: One-line description
argument-hint: "[args]"
allowed-tools:
  - Read
  - Write
  - ...
---
```

### Agent files
```yaml
---
name: agent-name
model: sonnet
color: red
description: >
  Agent description with <example> blocks
allowed-tools:
  - Read
  - Glob
  - ...
---
```

### Skill files
```yaml
---
name: Skill Name
description: When to activate
version: 1.0.0
---
```

## Persistence

| File | Scope | Tracked in Git |
|------|-------|----------------|
| `.sdd.yaml` | Project config | Optional |
| `.sdd-phase` | Current phase | No |
| `status.yaml` | Task tracking | Optional |
| `.sdd-plugins.json` | Plugin registry | Optional |
| `.sdd-yolo` | Guardrail escape | No (deleted on use) |
