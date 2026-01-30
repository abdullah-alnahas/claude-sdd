# Behavior Spec: SDD Plugin

**Version**: 0.1
**Date**: 2026-01-31

## Overview
Complete behavioral specification for the SDD plugin — every hook, skill, agent, and command has testable acceptance criteria.

---

## 1. Hooks

### 1.1 SessionStart — session-init.sh
**Given** a new Claude Code session starts with the SDD plugin loaded
**When** the SessionStart hook fires
**Then** it sets `SDD_ACTIVE=true` in the env file and outputs "Session initialized" to stderr

**Given** a `.sdd-yolo` flag file exists in the project root
**When** the SessionStart hook fires
**Then** it sets `GUARDRAILS_DISABLED=true`, removes the `.sdd-yolo` file, and outputs "YOLO mode active" to stderr

**Given** a `.sdd.yaml` config file exists in the project root
**When** the SessionStart hook fires
**Then** it sets `SDD_CONFIG_FOUND=true` and outputs "Config loaded" to stderr

**Given** no `.sdd.yaml` exists
**When** the SessionStart hook fires
**Then** it sets `SDD_CONFIG_FOUND=false` and outputs "using defaults" to stderr

### 1.2 UserPromptSubmit — Pre-Implementation Checkpoint
**Given** guardrails are enabled
**When** the user submits any prompt
**Then** Claude enumerates assumptions, flags ambiguity, surfaces alternatives, pushes back on bad ideas, defines scope, checks for spec, and plans TDD approach BEFORE writing any code

**Given** `GUARDRAILS_DISABLED=true`
**When** the user submits a prompt
**Then** the checkpoint is skipped entirely

### 1.3 PostToolUse — post-edit-review.sh
**Given** guardrails are enabled and a Write/Edit tool is used
**When** the edited file is outside the project directory
**Then** the hook exits with code 2 and outputs a scope warning

**Given** guardrails are enabled and more than 10 files are modified in git
**When** a Write/Edit tool is used
**Then** the hook exits with code 2 and outputs a scope creep warning

**Given** `GUARDRAILS_DISABLED=true`
**When** any Write/Edit tool is used
**Then** the hook exits silently with code 0

### 1.4 Stop — Completion Review
**Given** guardrails are enabled and Claude finishes a response
**When** the Stop hook fires
**Then** Claude checks: spec adherence, test coverage (were tests written first?), complexity (function <50 lines, file <500 lines), dead code, scope creep, and conceptual errors

**Given** `GUARDRAILS_DISABLED=true`
**When** the Stop hook fires
**Then** the review is skipped

---

## 2. Skills

### 2.1 Guardrails Skill
**Given** the user asks to "implement", "build", "fix", "refactor", "add", "change", or "modify" something
**When** the skill activates
**Then** it provides the pre-implementation checkpoint, failure mode awareness, scope discipline guidance, and TDD/iterative execution references

### 2.2 Spec-First Skill
**Given** the user says "new project", "start building", "I want to create", "new feature", or "adopt project"
**When** the skill activates
**Then** it guides through interactive questioning (Intent → Behavior → Technical → Architecture → Prioritization) and offers to generate foundation documents at each stage

**Given** the user describes something to build
**When** the spec-first skill is active
**Then** Claude asks clarifying questions conversationally (2-3 at a time, not a checklist dump) and does NOT start coding until at least Intent Discovery and Behavioral Bounding are complete

### 2.3 Architecture-Aware Skill
**Given** the user asks about "design", "architecture", "integration", "patterns", or "structure"
**When** the skill activates
**Then** it provides integration pattern guidance, anti-pattern awareness, and ADR guidance, always checking existing codebase patterns first

### 2.4 TDD Discipline Skill
**Given** the user asks about "test", "TDD", "coverage", "verify", or "validate"
**When** the skill activates
**Then** it enforces Red→Green→Refactor, explains its relationship to iterative execution (TDD = inner discipline, iterative execution = outer cycle), and provides test strategy and traceability guidance

### 2.5 Iterative Execution Skill
**Given** the user asks to "implement", "execute", "make it work", "iterate", or "loop until passing"
**When** the skill activates
**Then** it guides through the outer delivery cycle (implement with TDD → verify holistically → fix gaps → repeat), enforces honest completion reporting, and references available verification tools

---

## 3. Agents

### 3.1 Critic Agent
**Given** code is submitted for review
**When** the critic agent runs
**Then** it reads the spec (if any), compares against implementation, checks logic, validates assumptions, and produces findings categorized as Critical/Warning/Note with spec coverage summary

**Given** the code has no issues
**When** the critic agent runs
**Then** it says so briefly and moves on (no padding or false findings)

### 3.2 Simplifier Agent
**Given** code is submitted for simplification review
**When** the simplifier agent runs
**Then** it identifies unnecessary abstractions, proposes concrete simpler alternatives (not just critiques), and quantifies savings (lines/files reduced), while confirming that simplifications preserve test behavior

### 3.3 Spec-Compliance Agent
**Given** a behavior spec and implementation exist
**When** the spec-compliance agent runs
**Then** it extracts every acceptance criterion, traces each to a test and to code, identifies deviations (built but not specified, specified but not built), and reports exact coverage (X of Y criteria)

**Given** no behavior spec exists
**When** the spec-compliance agent is invoked
**Then** it reports that no spec was found and suggests creating one

### 3.4 Security Reviewer Agent
**Given** code is submitted for security review
**When** the security reviewer runs
**Then** it identifies trust boundaries, checks input validation at boundaries, checks auth/authz, checks injection surfaces, checks for hardcoded secrets, and reports findings by severity (Critical/High/Medium)

---

## 4. Commands

### 4.1 /sdd-guardrails
**Given** the plugin is active
**When** the user runs `/sdd-guardrails`
**Then** it displays the enabled/disabled status of each guardrail (pre-implementation, scope-guard, completion-review) and config file location

**Given** the user runs `/sdd-guardrails disable pre-implementation`
**When** the command executes
**Then** the pre-implementation guardrail is disabled for the session

### 4.2 /sdd-yolo
**Given** the plugin is active
**When** the user runs `/sdd-yolo`
**Then** a `.sdd-yolo` file is created in the project root, all guardrails are disabled for the session, and a warning is displayed

### 4.3 /sdd-phase
**Given** the plugin is active
**When** the user runs `/sdd-phase`
**Then** it shows the current phase (or "none")

**Given** the user runs `/sdd-phase implement`
**When** the command executes
**Then** the phase is set to "implement" and relevant skills/agents are highlighted

### 4.4 /sdd-review
**Given** recent code changes exist
**When** the user runs `/sdd-review`
**Then** the critic and simplifier agents review the changes, findings are presented with severity, and the user is offered auto-fix with re-review (up to 3 iterations by default)

### 4.5 /sdd-adopt
**Given** the user is in an existing project without SDD
**When** the user runs `/sdd-adopt`
**Then** the plugin scans project structure, infers language/framework/patterns, presents inferences for confirmation, generates retroactive foundation docs, and creates `.sdd.yaml`

**Given** the user corrects an inference during adoption
**When** the correction is provided
**Then** the plugin accepts it without argument and adjusts generated docs accordingly

### 4.6 /sdd-execute
**Given** a behavior spec with acceptance criteria exists
**When** the user runs `/sdd-execute`
**Then** the plugin extracts criteria from the spec, implements using TDD (test first), verifies holistically, fixes gaps, and repeats until all criteria are satisfied or max iterations (default 10) reached

**Given** not all criteria can be satisfied within max iterations
**When** the loop terminates
**Then** it reports honest partial status ("X of Y criteria met, blocked on Z") — never claims false completion

---

### 4.7 /sdd-autopilot
**Given** the user runs `/sdd-autopilot` with an app description (inline or file path)
**When** the command starts
**Then** it drives through all 5 phases autonomously (specify → design → implement → verify → review), generating foundation docs, implementing with TDD, verifying with agents, and producing an honest completion report

**Given** the autopilot encounters a genuinely ambiguous decision
**When** multiple options are equally valid
**Then** it asks the user with 2-3 concrete options and rationale

**Given** the autopilot encounters a decision with a clear best answer
**When** context makes one option obviously correct
**Then** it makes the decision itself and states it without asking

**Given** all phases complete
**When** the autopilot finishes
**Then** it outputs a completion report with criteria satisfaction count, test status, documents generated, and any remaining issues — never claiming false completion

See also: `specs/autopilot-behavior-spec.md` for full acceptance criteria.

---

## Edge Cases

- Plugin loaded but no project directory → session-init.sh handles gracefully (uses defaults)
- Multiple skills could trigger on same prompt → all relevant skills activate, no conflict
- Agent invoked with no spec → agent reports no spec found, suggests creating one
- `/sdd-execute` with no spec → prompts user to create one first (spec-first principle)
- `.sdd.yaml` has invalid YAML → session-init.sh logs warning, uses defaults

## Non-Goals (Behavioral)
- Plugin does NOT auto-fix code without user consent
- Plugin does NOT block tool use (hooks warn with exit 2, they don't prevent)
- Plugin does NOT persist state across sessions (each session is fresh, except `.sdd.yaml`)
- Plugin does NOT require all features to be used (each component works independently)
