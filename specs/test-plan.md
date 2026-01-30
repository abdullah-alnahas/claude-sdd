# Test Plan: SDD Plugin

**Version**: 0.1
**Date**: 2026-01-31

## Strategy

Three levels of testing:
- **Structural tests** (bash scripts): Verify files exist, JSON is valid, frontmatter is correct — automated, fast
- **Behavioral tests** (bash scripts): Verify hooks execute correctly with controlled inputs — automated, medium speed
- **Integration tests** (manual): Verify full plugin flow in a real Claude Code session — manual, slow

## Coverage Goals
Every acceptance criterion in `behavior-spec.md` must be covered by at least one test.

---

## Structural Tests (Existing)

Already covered by `scripts/verify-hooks.sh`, `scripts/verify-skills.sh`, `scripts/verify-commands.sh`.

| Test | Traces to |
|------|-----------|
| hooks.json is valid JSON with correct structure | Spec 1.x (all hooks) |
| All SKILL.md files have frontmatter with name/description | Spec 2.x (all skills) |
| All command .md files have frontmatter with name/description | Spec 4.x (all commands) |
| All agent .md files exist | Spec 3.x (all agents) |
| All referenced files exist | All specs (no broken references) |
| SKILL.md files under 3000 words | Constraint: skill loading limit |

---

## Behavioral Tests (New — scripts/test-hooks.sh)

### session-init.sh

| Test | Input | Expected | Traces to |
|------|-------|----------|-----------|
| Default init | No config, no yolo flag | `SDD_ACTIVE=true`, `GUARDRAILS_DISABLED=false` in env file | Spec 1.1.1 |
| Yolo flag present | `.sdd-yolo` exists | `GUARDRAILS_DISABLED=true`, flag file removed | Spec 1.1.2 |
| Config found | `.sdd.yaml` exists | `SDD_CONFIG_FOUND=true` | Spec 1.1.3 |
| No config | No `.sdd.yaml` | `SDD_CONFIG_FOUND=false` | Spec 1.1.4 |

### post-edit-review.sh

| Test | Input | Expected | Traces to |
|------|-------|----------|-----------|
| Normal edit inside project | JSON with project-relative file_path | Exit 0 | Spec 1.3 (normal case) |
| Edit outside project | JSON with absolute path outside project | Exit 2 + warning | Spec 1.3.1 |
| Guardrails disabled | `GUARDRAILS_DISABLED=true` | Exit 0 (skip) | Spec 1.3.3 |

---

## Integration Tests (Manual Checklist)

### Full Flow Test
- [ ] Start session with plugin loaded → session-init fires, outputs status (Spec 1.1)
- [ ] Say "I want to build a task manager" → spec-first skill activates, asks questions (Spec 2.2)
- [ ] Ask to implement without spec → guardrails suggest creating spec first (Spec 2.2, 4.6)
- [ ] Create a behavior spec → template is offered (Spec 2.2)
- [ ] Run `/sdd-phase implement` → phase is set (Spec 4.3)
- [ ] Ask to implement a feature → pre-implementation checkpoint fires with TDD planning (Spec 1.2)
- [ ] Edit a file → post-edit-review runs (Spec 1.3)
- [ ] Let Claude finish → completion review fires (Spec 1.4)
- [ ] Run `/sdd-review` → critic + simplifier produce findings (Spec 4.4)
- [ ] Run `/sdd-yolo` → guardrails disabled, warning shown (Spec 4.2)
- [ ] Run `/sdd-guardrails` → shows all disabled (Spec 4.1)
- [ ] Start new session → yolo flag cleared, guardrails re-enabled (Spec 1.1.2)

### Adoption Test
- [ ] In an existing Node.js project, run `/sdd-adopt` (Spec 4.5)
- [ ] Verify it detects language, framework, patterns (Spec 4.5)
- [ ] Correct an inference → accepted without argument (Spec 4.5)
- [ ] Foundation docs generated (Spec 4.5)

---

## Not Tested

- Skill keyword matching accuracy (depends on Claude Code's internal matching, not our code)
- Agent output quality (subjective; verified by manual review, not automation)
- `.sdd.yaml` config parsing beyond existence check (session-init.sh only checks if file exists, doesn't parse YAML)
