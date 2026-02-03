---
name: sdd-onboard
description: Interactive tutorial for new users — explains SDD concepts before configuration
user_invocable: true
allowed-tools:
  - Read
  - Write
  - AskUserQuestion
---

# /sdd-onboard

Interactive introduction to SDD. Explains concepts, demonstrates workflow, then optionally generates configuration.

## Usage

```
/sdd-onboard           # Full interactive tutorial
/sdd-onboard --quick   # Skip explanations, just configure
```

## Tutorial Flow

### Section 1: What is SDD? (30 seconds)

"SDD (Spec-Driven Development) is a discipline for building software correctly:

1. **Specify** what you want before coding
2. **Design** how to build it
3. **Implement** with tests first (TDD)
4. **Verify** it works
5. **Review** for quality

The plugin adds guardrails that help you follow this discipline."

### Section 2: The 5 Phases (60 seconds)

```
specify → design → implement → verify → review
   │         │          │          │        │
   ▼         ▼          ▼          ▼        ▼
 WHAT?     HOW?      BUILD      CHECK    CRITIQUE
```

- **Specify**: Write behavior specs with acceptance criteria
- **Design**: Create architecture and roadmap
- **Implement**: Build using TDD (tests first)
- **Verify**: Run automated checks
- **Review**: Agent-based code review

### Section 3: Essential Commands (30 seconds)

"You only need to know 4 commands to start:

| Command | When to Use |
|---------|-------------|
| `/sdd-status` | See where you are |
| `/sdd-execute` | Start building |
| `/sdd-verify` | Check your work |
| `/sdd-review` | Get feedback |

Everything else is optional."

### Section 4: How Guardrails Work (30 seconds)

"Guardrails are automatic checks that fire without you running them:

- **Before you code**: Asks 'Do you have a spec? What's the scope?'
- **During edits**: Watches for scope creep
- **When you stop**: Reviews completeness

If they feel annoying, run `/sdd-yolo` to disable them temporarily."

### Section 5: Try It (optional)

"Would you like to create a sample spec to see how it works?"

If yes:
1. Ask for a simple feature description
2. Generate a sample `specs/000-sample/behavior-spec.md`
3. Show how acceptance criteria look
4. Delete sample after demo

### Section 6: Configure (optional)

"Would you like to set up SDD for this project?"

If yes:
1. Ask 3 questions (same as `/sdd-init`)
2. Generate `.sdd.yaml`
3. Optionally create `.sdd/constitution.md`

## Output

At the end:

```
Welcome to SDD! Here's what's set up:

✓ Understood: 5 phases, 4 essential commands, guardrails
✓ Config: .sdd.yaml created (mode: dev)
✓ Constitution: .sdd/constitution.md (optional)

Next steps:
1. Run /sdd-status to see your project state
2. Run /sdd-execute to start building

Need help? Run /sdd-onboard --quick to see this summary again.
```
