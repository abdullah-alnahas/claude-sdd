# Roadmap: SDD DX Improvement

## Implementation Order

### Phase A: Hook Feedback (AC2, AC7)
**Priority**: High — Immediate visibility improvement
**Effort**: Small
**Dependencies**: None

1. Update `session-init.sh` — add feedback message
2. Update `post-edit-review.sh` — add feedback message
3. Update `completion-review.sh` — add feedback message
4. Update `compaction-counter.sh` — add feedback message

### Phase B: README Restructure (AC1, AC5)
**Priority**: High — First thing users see
**Effort**: Medium
**Dependencies**: None (can run in parallel with Phase A)

1. Create quick-start flowchart (ASCII or mermaid)
2. Restructure README with essential/advanced split
3. Add installation → first-command path

### Phase C: Command Consolidation (AC4)
**Priority**: Medium — Reduces confusion
**Effort**: Medium
**Dependencies**: Phase B (README should reflect new structure)

1. Create `/sdd-start` command (unified entry)
2. Create `/sdd-check` command (unified verification)
3. Create aliases for deprecated commands
4. Update command catalog in skills

### Phase D: Interactive Setup (AC3)
**Priority**: Medium — Helps new users configure
**Effort**: Medium
**Dependencies**: Phase C (so init can reference correct commands)

1. Create `/sdd-init` command
2. Implement question flow (3-5 questions)
3. Generate minimal `.sdd.yaml`

### Phase E: Centralized Concepts (AC6)
**Priority**: Low — Polish
**Effort**: Medium
**Dependencies**: Phases A-D complete

1. Create `references/concepts/` directory
2. Write `phases.md`, `modes.md`, `guardrails.md`
3. Update skill files to reference instead of duplicate

## Verification Checklist

After each phase, verify:
- [ ] No existing functionality broken
- [ ] Deprecated commands print warnings
- [ ] Documentation updated to reflect changes

## Rollback Criteria

If within 2 weeks of release:
- >5 GitHub issues about command changes → revert command consolidation
- >3 reports of hook feedback being annoying → make feedback opt-in
- Migration confusion reported → add migration guide to README
