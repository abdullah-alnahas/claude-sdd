# Behavior Spec: /sdd-autopilot Command

**Version**: 0.1
**Date**: 2026-01-31

## Overview
A command that takes an app description (rough idea or existing `app-description.md`) and autonomously drives through all SDD phases — generating specs, designing architecture, implementing with TDD, verifying against spec, and reviewing — asking clarifying questions only when genuinely blocked.

## Acceptance Criteria

### AC-1: Accepts app description input
**Given** the user runs `/sdd-autopilot` with a rough app description (inline text or path to app-description.md)
**When** the command starts
**Then** it acknowledges the input, summarizes understanding, and begins the Specify phase

### AC-2: Specify phase — generates foundation documents
**Given** the autopilot has an app description
**When** it enters the Specify phase
**Then** it generates: behavior-spec.md (with Given-When-Then criteria), stack.md, and architecture.md — asking the user clarifying questions ONLY for genuinely ambiguous decisions (e.g., "which database?" when multiple are equally valid)

### AC-3: Design phase — produces architecture decisions
**Given** foundation documents exist
**When** it enters the Design phase
**Then** it identifies architectural decisions, generates ADRs for non-obvious choices, and produces a roadmap.md with prioritized implementation order

### AC-4: Implement phase — uses TDD within iterative execution
**Given** a behavior spec with acceptance criteria and a roadmap exist
**When** it enters the Implement phase
**Then** it works through roadmap items in order, using TDD (test first → minimal code) within the iterative execution outer loop (implement → verify → fix gaps → repeat)

### AC-5: Verify phase — holistic verification
**Given** implementation is complete
**When** it enters the Verify phase
**Then** it runs all available verification: test suite, spec-compliance agent, critic agent, security-reviewer agent — and reports findings

### AC-6: Review phase — self-review with fix cycle
**Given** verification findings exist
**When** it enters the Review phase
**Then** it runs the simplifier agent, addresses critical/high findings using TDD, and re-verifies until no critical issues remain (max 3 review iterations)

### AC-7: Completion report
**Given** all phases complete
**When** autopilot finishes
**Then** it outputs an honest completion report: which spec criteria are satisfied, which aren't, what was built, and any remaining issues

### AC-8: Phase transitions are visible
**Given** the autopilot is running
**When** it transitions between phases
**Then** it announces the transition clearly (e.g., "Entering Implement phase — 5 roadmap items to build")

### AC-9: User can interrupt at any phase
**Given** the autopilot is in any phase
**When** the user provides input or correction
**Then** the autopilot incorporates the feedback and continues (does not restart from scratch)

### AC-10: Asks questions only when genuinely blocked
**Given** a decision has a clear best answer from context
**When** the autopilot encounters it
**Then** it makes the decision and states it (does NOT ask the user for confirmation on obvious choices)

**Given** a decision is genuinely ambiguous (multiple equally valid options)
**When** the autopilot encounters it
**Then** it asks the user with clear options and rationale

## Non-Goals
- Does NOT replace individual commands (they still work independently)
- Does NOT create CI/CD pipelines or deploy
- Does NOT handle multi-project orchestration
- Does NOT run without any user interaction (questions are rare but possible)

## Edge Cases
- User provides a path to an existing app-description.md → reads and uses it
- User provides inline text → treats it as the raw app description
- No test runner available in project → skips automated test verification, relies on agents
- Spec criteria can't all be satisfied → reports partial completion honestly
- User interrupts mid-phase → gracefully pauses, can resume
