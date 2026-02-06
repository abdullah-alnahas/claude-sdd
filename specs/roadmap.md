# Roadmap: SDD Plugin

**Version**: 0.12.0
**Date**: 2026-02-07

## Completed Milestones

### v0.10.0 — Core System
- 5 hooks (SessionStart, UserPromptSubmit, PostToolUse ×2, Stop)
- 7 skills (guardrails, spec-first, tdd-discipline, iterative-execution, architecture-aware, performance-optimization, using-sdd)
- 6 agents (critic, simplifier, spec-compliance, security-reviewer, performance-reviewer, planner)
- Core commands (sdd-execute, sdd-review, sdd-phase, sdd-mode, sdd-verify, sdd-guardrails, sdd-yolo)
- 3 context modes (dev, review, research)
- Validation scripts

### v0.11.0 — Spec-Kit & OpenSpec Enhancements
- New commands: sdd-analyze, sdd-clarify, sdd-onboard, sdd-checklist, sdd-challenge
- Proposal and constitution templates
- Feature numbering (new-feature.sh)
- Plan-first mode for sdd-execute
- Interactive onboarding

### v0.12.0 — Plugin Management (Current)
- `/sdd-plugin` command (add, remove, list, run, sync)
- `.sdd-plugins.json` project-local registry
- Plugin agent integration in `/sdd-execute` (--plugins flag)
- Plugin agent support in `/sdd-orchestrate` (plugin:agent notation)
- Validation fixes (sdd-init allowed-tools, manifest.yaml check)

## Next Steps

### v0.13.0 — Test Coverage & Reliability
**Priority**: High
**Focus**: Comprehensive automated testing

1. Expand test suite for all commands, agents, skills, hooks
2. Add integration tests (full workflow: init → execute → review)
3. CI pipeline for automated validation on push
4. Hook timeout tuning and reliability

### v0.14.0 — Plugin Ecosystem
**Priority**: Medium
**Focus**: Cross-plugin workflows

1. Plugin dependency declaration (plugin A depends on plugin B)
2. Plugin agent discovery in named pipelines (not just custom)
3. Plugin settings/config inheritance
4. Marketplace integration for sdd-plugin add

### Future Considerations
- Team workflow support (multi-user, approval gates)
- Metrics and telemetry (how often guardrails fire, what they catch)
- Custom agent creation via /sdd-agent-create
- Visual progress dashboards
- VS Code / IDE integration

## Dependencies

```
v0.12.0 (current) ──> v0.13.0 (testing) ──> v0.14.0 (ecosystem)
```

Testing (v0.13.0) should precede ecosystem work (v0.14.0) to ensure stability.
