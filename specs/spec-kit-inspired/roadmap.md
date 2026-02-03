# Roadmap: Spec-Kit Inspired Enhancements

## Implementation Order

### Phase A: Foundation (AC1, AC6, AC7)
**Priority**: High — Enables other features
**Effort**: Low

1. Create constitution template
2. Create proposal template
3. Add feature numbering script (`new-feature.sh`)
4. Update session-init to detect constitution

### Phase B: New Commands (AC2, AC3, AC10)
**Priority**: High — Core functionality
**Effort**: Medium

1. Create `/sdd-analyze` command
2. Create `/sdd-clarify` command
3. Create `/sdd-checklist` command
4. Add helper scripts (`check-consistency.sh`, `list-criteria.sh`)

### Phase C: Workflow Improvements (AC4, AC5, AC8)
**Priority**: Medium — UX improvements
**Effort**: Medium

1. Add `--fast` flag to `/sdd-execute`
2. Create `/sdd-onboard` command
3. Update `/sdd-init` to recommend onboard
4. Remove phase-gating (fluid artifacts)

### Phase D: Documentation & Integration (AC9)
**Priority**: Low — Polish
**Effort**: Low

1. Update README with new commands
2. Update command catalog in using-sdd skill
3. Add constitution concept to references/concepts/
4. Update spec-first skill to use proposal template

## Dependencies

```
Phase A ──┬──> Phase B
          │
          └──> Phase C ──> Phase D
```

Phase A must complete first (templates needed by commands).
Phases B and C can run in parallel.
Phase D requires B and C complete.

## Verification

After each phase:
- [ ] Run `bash scripts/verify-commands.sh`
- [ ] Test new commands manually
- [ ] Check backward compatibility
