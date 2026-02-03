# SDD — Spec-Driven Development Plugin

A Claude Code plugin that enforces disciplined software development through behavioral guardrails, spec-first development, and TDD enforcement.

## Quick Start

**What do you want to do?**

```
┌─────────────────────────────────────────────────────────────┐
│                    SDD Quick Start                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  "I'm new to SDD"                                           │
│      └── Run: /sdd-onboard                                  │
│          (Interactive tutorial explains everything)         │
│                                                             │
│  "I have an existing project"                               │
│      └── Run: /sdd-status                                   │
│          Then: /sdd-init (if not configured)                │
│                                                             │
│  "I want to build something new"                            │
│      └── Run: /sdd-execute <description>                    │
│          (Guides you through spec → design → implement)     │
│                                                             │
│  "I want to build fast (fewer review stops)"                │
│      └── Run: /sdd-execute --plan-first <description>       │
│          (2 review points instead of 5)                     │
│                                                             │
│  "I just want to code without guardrails"                   │
│      └── Run: /sdd-yolo                                     │
│          (Disables all checks for this session)             │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Installation

### From GitHub marketplace (recommended)

```bash
# 1. Add the repo as a marketplace
/plugin marketplace add abdullah-alnahas/claude-sdd

# 2. Install the plugin
/plugin install claude-sdd@claude-sdd
```

### For local development

```bash
# Clone and load directly
git clone https://github.com/abdullah-alnahas/claude-sdd.git
claude --plugin-dir ./claude-sdd
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

### Performance Optimization
Profile-first discipline for performance work. Defends against convenience bias (shallow, input-specific hacks), bottleneck mis-targeting, and correctness regressions during optimization.

## Commands

### Essential (start here)

| Command | Purpose |
|---------|---------|
| `/sdd-onboard` | Interactive tutorial — explains SDD concepts before configuration |
| `/sdd-status` | Show project state — what exists, what's missing, what's next |
| `/sdd-init` | Setup wizard — generates `.sdd.yaml` (use `/sdd-onboard` if new) |
| `/sdd-execute` | Start iterative execution loop (spec → design → implement → verify) |
| `/sdd-verify` | Run automated checks — build, types, lint, tests |

### Standard

| Command | Purpose |
|---------|---------|
| `/sdd-phase` | Show/set development phase |
| `/sdd-mode` | Switch context mode (dev/review/research) |
| `/sdd-review` | Two-stage agent review — spec compliance then code quality |
| `/sdd-track` | Lightweight task tracking via status.yaml |
| `/sdd-guardrails` | Show/toggle guardrail status |
| `/sdd-yolo` | Disable all guardrails (auto-clears next session) |
| `/sdd-analyze` | Cross-artifact consistency checker (no LLM, fast) |
| `/sdd-clarify` | Structured questioning for underspecified requirements |
| `/sdd-checklist` | Generate custom validation checklists |

### Advanced

| Command | Purpose |
|---------|---------|
| `/sdd-orchestrate` | Custom agent pipelines — feature, bugfix, refactor, security |
| `/sdd-challenge` | Adversarial modes — grill, prove, elegant |
| `/sdd-context` | Generate LLM-optimized project context document |

### Deprecated

| Command | Replacement |
|---------|-------------|
| `/sdd-adopt` | Use `/sdd-init` instead |
| `/sdd-autopilot` | Use `/sdd-execute --auto` instead |

## Agents

| Agent | Role |
|-------|------|
| **critic** | Adversarial reviewer — finds logical errors, spec drift, assumption issues |
| **simplifier** | Complexity reducer — proposes simpler alternatives |
| **spec-compliance** | Spec adherence checker — verifies traceability (spec → test → code) |
| **security-reviewer** | Security analysis — OWASP Top 10, input validation, auth review |
| **performance-reviewer** | Performance optimization reviewer — validates patches for bottleneck targeting, convenience bias, measured improvement |
| **planner** | Implementation planner — reads specs/architecture and produces ordered steps |

## Context Modes

SDD supports three context modes that adjust which guardrails are active:

| Mode | Focus | Pre-Implementation | Completion Review | Scope Guard |
|------|-------|-------------------|-------------------|-------------|
| **dev** (default) | Build correctly | Active | Active | Strict |
| **review** | Verify and critique | Skipped | Active | Normal |
| **research** | Explore freely | Skipped | Skipped | Relaxed |

Set mode with `/sdd-mode <mode>` or set a default in `.sdd.yaml`:

```yaml
mode: dev  # dev | review | research
```

## Checklists

SDD includes validation checklists for common workflows in `commands/checklists/`:

| Checklist | Used By | Purpose |
|-----------|---------|---------|
| `pre-commit.md` | `/sdd-verify pre-commit` | Build, types, lint, debug statements, git status |
| `pre-pr.md` | `/sdd-verify pre-pr` | Full checks + security, secrets, TODO scan |
| `feature-complete.md` | `/sdd-verify full` | Spec criteria, tests, review, no dead code |
| `code-review.md` | `/sdd-review` Stage 2 | Spec loaded, ACs cross-checked, quality, security |

## Agent Customization

Override agent behavior per-project via `.sdd.yaml`:

```yaml
agents:
  critic:
    extra_instructions: "Focus on database query performance"
  simplifier:
    extra_instructions: "Ignore complexity in generated code files"
```

Extra instructions are injected into agent prompts when launched via `/sdd-orchestrate` or `/sdd-review`.

## Configuration

Create `.sdd.yaml` in your project root:

```yaml
project_name: my-project  # used in /sdd-context output
spec_dir: specs  # where specs live (default: specs)
test_dir: tests  # where tests live (auto-detected if not set)
verbosity: standard  # minimal | standard | verbose
enabled: true
mode: dev  # dev | review | research
compaction_threshold: 50  # tool invocations before suggesting /compact

agents:
  critic:
    extra_instructions: "Focus on database query performance"
  simplifier:
    extra_instructions: "Ignore complexity in generated code files"

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
bash scripts/verify-hooks.sh
bash scripts/verify-skills.sh
bash scripts/verify-commands.sh
```

## Development Phases

The recommended flow:

```
specify → design → implement → verify → review
```

Each phase activates relevant skills and agents. Set phase with `/sdd-phase <name>`.

## Autopilot Architecture

The `/sdd-autopilot` command uses a step-file architecture. Each phase is defined in a separate file under `commands/sdd-autopilot/` (step-1 through step-5). The main command file acts as a sequential dispatcher that loads each step only when ready to execute it.

## Troubleshooting

**Hooks not firing**: Ensure the plugin is loaded (`claude --plugin-dir ./sdd`). Check `hooks.json` is valid JSON.

**Skills not triggering**: Skills activate based on keyword matching in your prompts. Use natural language that matches skill descriptions.

**YOLO mode stuck**: Delete `.sdd-yolo` from your project root, or run `/sdd-guardrails enable`.
