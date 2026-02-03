# Behavior Spec: Spec-Kit Inspired Enhancements

## AC1: Constitution Concept

**Given** a project with `.sdd/constitution.md`
**When** guardrails fire or reviews run
**Then** constitution content is injected into Claude's context
**And** Claude is instructed to check work against constitution principles
**And** if user edits constitution, a warning is shown (not blocked)
**Note** Enforcement is advisory (LLM judgment), not mechanical

## AC2: Cross-Artifact Analyzer

**Given** user runs `/sdd-analyze`
**When** specs, architecture, and tests exist
**Then** report shows:
  - Spec criteria (AC1, AC2, etc.) without matching test file references
  - Test files without spec criteria references
  - Architecture components not mentioned in roadmap
**And** uses grep/regex only (no LLM calls)
**And** reports "unknown" for semantic checks it cannot perform

## AC3: Structured Clarification

**Given** user runs `/sdd-clarify [topic]`
**When** command executes
**Then** systematic questions are asked about:
  - Edge cases
  - Error handling
  - Scale/performance requirements
  - Security considerations
  - Integration points
**And** answers are appended to relevant spec

## AC4: Consolidated Planning Mode

**Given** user runs `/sdd-execute --plan-first <description>`
**When** command executes
**Then** generates planning docs with minimal pauses:
  - proposal.md + behavior-spec.md → pause for spec review
  - architecture.md + roadmap.md → pause for design review
**And** implementation begins after design approval
**Note** Reduces 5 pauses to 2 while preserving course-correction opportunity

## AC5: Interactive Onboarding

**Given** user runs `/sdd-onboard`
**When** command executes
**Then** step-by-step tutorial explains:
  - What SDD is (30 seconds)
  - The 5 phases
  - Essential commands (3-4)
  - How guardrails work
**And** offers to create sample spec
**And** config generation is optional final step

## AC6: Proposal Document

**Given** user creates a new feature
**When** spec-first workflow runs
**Then** `proposal.md` is generated containing:
  - Rationale (why build this)
  - Scope (what's in/out)
  - Alternatives considered
  - Success metrics
**And** `behavior-spec.md` contains only acceptance criteria

## AC7: Feature Numbering

**Given** user creates new feature spec
**When** spec directory is created
**Then** directory named `NNN-feature-name` where NNN is auto-incremented
**Example** `specs/001-auth/`, `specs/002-payments/`
**And** existing unnumbered specs are not renamed

## AC8: Non-Blocking Phase Transitions

**Given** user is in any phase
**When** they want to edit an artifact from an earlier phase
**Then** they can edit without running `/sdd-phase` first
**And** `/sdd-phase` remains meaningful (suggests relevant skills)
**But** phase does not BLOCK edits, only GUIDES them
**And** guardrails still apply based on mode

## AC9: Feature Creation Script

**Given** user wants to create a new feature
**When** they run `scripts/new-feature.sh <name>`
**Then** creates numbered feature directory with templates
**And** uses file locking to prevent race conditions
**And** works without Claude running
**Note** Other helper scripts removed (commands are sufficient)

## AC10: Checklist Generator

**Given** user runs `/sdd-checklist <type>`
**When** type is one of: pre-commit, pre-pr, feature-complete, security, performance
**Then** generates markdown checklist customized to project
**And** checklist references actual project files/patterns

## Verification

- [ ] AC1: Constitution file recognized and referenced
- [ ] AC2: `/sdd-analyze` runs without LLM, reports gaps
- [ ] AC3: `/sdd-clarify` asks systematic questions
- [ ] AC4: `--plan-first` consolidates to 2 review points
- [ ] AC5: `/sdd-onboard` provides interactive tutorial
- [ ] AC6: Proposal separate from behavior spec
- [ ] AC7: Feature directories auto-numbered
- [ ] AC8: Artifacts editable regardless of phase
- [ ] AC9: new-feature.sh creates numbered directories
- [ ] AC10: `/sdd-checklist` generates custom checklists
