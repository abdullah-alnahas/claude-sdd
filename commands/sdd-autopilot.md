---
name: sdd-autopilot
description: Autonomous end-to-end development — takes an app description and drives through all SDD phases (specify → design → implement → verify → review) with minimal user intervention
---

# /sdd-autopilot

Drives the full SDD lifecycle autonomously from a rough app description to verified implementation.

## Usage

- `/sdd-autopilot <description>` — Start from a rough idea (inline text)
- `/sdd-autopilot <path-to-app-description.md>` — Start from an existing app description document

## Behavior

When invoked, execute the following phases in order. Announce each phase transition clearly. Ask the user questions ONLY when genuinely blocked by ambiguity — make obvious decisions yourself and state them.

### Phase 1: Specify

**Input**: The app description (from argument).
**Actions**:
1. If input is a file path, read it. If inline text, treat as raw description.
2. Summarize your understanding of what needs to be built. Ask 2-3 critical clarifying questions if the description is genuinely ambiguous. For clear descriptions, proceed without questions.
3. Generate foundation documents in `specs/`:
   - `app-description.md` — formalized from the raw input
   - `behavior-spec.md` — with Given-When-Then acceptance criteria
   - `stack.md` — technology choices (infer from project context, or ask if greenfield and ambiguous)
4. Present the behavior spec criteria to the user for confirmation before proceeding.

**Transition**: "Specify phase complete — N acceptance criteria defined. Entering Design phase."

### Phase 2: Design

**Input**: Foundation documents from Phase 1.
**Actions**:
1. Generate `architecture.md` — system structure, components, patterns
2. If any architectural decision is non-obvious, generate an ADR
3. Generate `roadmap.md` — prioritized implementation order
4. Identify integration points, dependencies between roadmap items

**Transition**: "Design phase complete — N roadmap items planned. Entering Implement phase."

### Phase 3: Implement

**Input**: Behavior spec + roadmap from previous phases.
**Actions**:
1. Work through roadmap items in priority order
2. For each item, use TDD:
   - Write failing test(s) that cover the relevant acceptance criteria
   - Write minimal code to pass
   - Refactor
3. After each roadmap item, run available verification (test suite, linters, type checks)
4. If tests fail, fix using TDD (understand failure → write targeted fix → verify)
5. Continue until all roadmap items complete

Use the iterative execution outer loop: implement → verify → fix gaps → repeat (max 10 iterations per roadmap item).

**Transition**: "Implement phase complete — N of M roadmap items done. Entering Verify phase."

### Phase 4: Verify

**Input**: Implementation from Phase 3.
**Actions**:
1. Run full test suite
2. Invoke **spec-compliance agent** — compare implementation against behavior-spec.md
3. Invoke **critic agent** — find logical errors, assumption issues
4. Invoke **security-reviewer agent** — check for vulnerabilities
5. Collect all findings

**Transition**: "Verify phase complete — N findings (X critical, Y high, Z medium). Entering Review phase."

### Phase 5: Review

**Input**: Verification findings from Phase 4.
**Actions**:
1. Invoke **simplifier agent** — identify unnecessary complexity
2. Address all critical and high findings using TDD
3. Re-run verification on fixed code
4. Repeat until no critical issues remain (max 3 review iterations)
5. Generate completion report

**Output**: Completion report:
```
SDD Autopilot — Complete
════════════════════════

Spec Criteria: X of Y satisfied
Tests: N passing, M failing
Review Iterations: K

Phases completed:
  ✓ Specify — N criteria defined
  ✓ Design — M roadmap items, K ADRs
  ✓ Implement — N items built with TDD
  ✓ Verify — findings addressed
  ✓ Review — no critical issues remaining

Documents generated:
  specs/app-description.md
  specs/behavior-spec.md
  specs/stack.md
  specs/architecture.md
  specs/roadmap.md

Remaining issues:
  [Any unresolved items, or "None"]
```

## Questioning Policy

**Ask when**:
- Technology choice is genuinely ambiguous (greenfield project, multiple equally valid options)
- A behavior spec criterion is contradictory or unclear
- User's description has a critical gap (e.g., no mention of data persistence for a CRUD app)

**Don't ask when**:
- The project context makes the answer obvious (existing package.json → it's JavaScript)
- One option is clearly better for the stated goals
- The decision is easily reversible
- You can infer from conventions in the existing codebase

When you do ask, provide 2-3 concrete options with brief rationale. Don't ask open-ended questions.

## Principles

- Every phase uses the corresponding SDD skill (spec-first, architecture-aware, tdd-discipline, iterative-execution)
- Guardrails remain active throughout (unless `/sdd-yolo` was used)
- Honest completion reporting — never claim done when criteria are unsatisfied
- TDD is the inner discipline at every phase that produces code
- The autopilot is a convenience orchestrator — it follows the same rules as manual phase-by-phase development
