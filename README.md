# SDD — Spec-Driven Development Plugin

A Claude Code plugin that enforces disciplined software development: behavioral guardrails, spec-first development, architecture awareness, TDD enforcement, and iterative execution loops.

## Installation

```bash
# Local development
claude --plugin-dir /path/to/sdd

# Or symlink into Claude plugins directory
ln -s /path/to/sdd ~/.claude/plugins/sdd
```

## What It Does

### Behavioral Guardrails
Defends against 12 known LLM failure modes (sycophantic agreement, premature abstraction, scope creep, etc.) through automatic hooks:
- **Pre-implementation checkpoint**: Enumerates assumptions, flags ambiguity, surfaces alternatives, plans TDD approach
- **Scope guard**: Detects unrelated file modifications during edits
- **Completion review**: Verifies spec adherence, test coverage, complexity, dead code

### Spec-First Development
Guides you from rough idea → formal specification through interactive questioning:
1. Intent Discovery → `app-description.md`
2. Behavioral Bounding → `behavior-spec.md`
3. Technical Context → `stack.md`
4. Architecture → `architecture.md`
5. Prioritization → `roadmap.md`

### Architecture Awareness
Integration patterns, anti-patterns, and ADR (Architecture Decision Record) guidance.

### TDD Discipline
Red → Green → Refactor enforcement. Test traceability from behavior spec to test to code.

### Iterative Execution
Disciplined delivery loops: implement with TDD → verify against spec → fix gaps → repeat. TDD is the inner discipline (how you write code), iterative execution is the outer cycle (how you deliver features).

## Commands

| Command | Purpose |
|---------|---------|
| `/sdd-guardrails` | Show/toggle guardrail status |
| `/sdd-yolo` | Disable all guardrails (auto-clears next session) |
| `/sdd-phase` | Show/set development phase |
| `/sdd-review` | On-demand review with critic + simplifier agents |
| `/sdd-adopt` | Adopt an existing project into SDD |
| `/sdd-execute` | Start iterative execution loop against a spec |
| `/sdd-autopilot` | Full autonomous lifecycle: specify → design → implement → verify → review |

## Agents

| Agent | Role |
|-------|------|
| **critic** | Adversarial reviewer — finds logical errors, spec drift, assumption issues |
| **simplifier** | Complexity reducer — proposes simpler alternatives |
| **spec-compliance** | Spec adherence checker — verifies traceability (spec → test → code) |
| **security-reviewer** | Security analysis — OWASP Top 10, input validation, auth review |

## Configuration

Create `.sdd.yaml` in your project root:

```yaml
verbosity: standard  # minimal | standard | verbose
enabled: true

guardrails:
  pre-implementation:
    enabled: true
    require-assumptions: true
    require-alternatives: 2
    require-clarification-check: true
  scope-guard:
    enabled: true
    warn-unrelated-files: true
    warn-dead-code: true
  completion-review:
    enabled: true
    max-function-lines: 50
    max-file-lines: 500
  pushback:
    enabled: true
    flag-overengineering: true
    flag-sycophancy: true

discipline:
  require-spec-before-code: false
  require-tests-before-merge: true
  require-adr-for-architecture: true

logging:
  enabled: false
  path: .guardrails-log.jsonl

whitelist:
  - "*.md"
  - "*.yaml"
  - "*.yml"
```

## Self-Test

```bash
bash sdd/scripts/verify-hooks.sh
bash sdd/scripts/verify-skills.sh
bash sdd/scripts/verify-commands.sh
```

## Development Phases

The recommended flow:

```
specify → design → implement → verify → review
```

Each phase activates relevant skills and agents. Set phase with `/sdd-phase <name>`.

## Troubleshooting

**Hooks not firing**: Ensure the plugin is loaded (`claude --plugin-dir ./sdd`). Check `hooks.json` is valid JSON.

**Skills not triggering**: Skills activate based on keyword matching in your prompts. Use natural language that matches skill descriptions.

**YOLO mode stuck**: Delete `.sdd-yolo` from your project root, or run `/sdd-guardrails enable`.
