# App Description: SDD Plugin

**Version**: 0.1
**Date**: 2026-01-31

## Problem Statement
LLMs make predictable, repeated mistakes during software development: sycophantic agreement, premature abstraction, scope creep, completion theater, and 8 other documented failure modes. Without structural enforcement, these failures recur across every session.

## Users
Individual developers using Claude Code who want disciplined AI-assisted development.

## Core Value Proposition
Enforces spec-driven, test-first, iteratively-verified development through hooks, skills, agents, and commands — preventing known LLM failure modes automatically.

## Success Criteria
- Hooks fire at correct lifecycle points and provide useful guardrail checks
- Skills activate on relevant prompts and guide behavior appropriately
- Agents produce actionable, honest reviews when invoked
- Commands execute their documented behavior correctly
- The full flow (spec → design → implement with TDD → verify → review) works end-to-end
- The plugin can be used to develop itself (self-referential verification)

## Non-Goals
- Not a project scaffolding tool (doesn't generate boilerplate code)
- Not a CI/CD system (doesn't run in pipelines)
- Not an enterprise workflow tool (no team coordination, no approval gates)

## Constraints
- Must work as a Claude Code plugin (`.claude-plugin/plugin.json` format)
- All hooks must complete within their timeout (10-15s for command hooks)
- Skills must be under 3000 words (Claude Code limit for effective skill loading)
