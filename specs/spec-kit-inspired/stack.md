# Stack: Spec-Kit Inspired Enhancements

## Technology

- **Platform**: Claude Code Plugin (existing)
- **Languages**: Markdown, Bash, JSON
- **No new dependencies**

## Implementation Approach

### Commands (Markdown)
- `commands/sdd-analyze.md` — Cross-artifact validator
- `commands/sdd-clarify.md` — Structured questioning
- `commands/sdd-onboard.md` — Interactive tutorial
- `commands/sdd-checklist.md` — Checklist generator
- Update `commands/sdd-execute.md` — Add `--fast` flag

### Scripts (Bash)
- `scripts/new-feature.sh` — Create numbered feature directory
- `scripts/check-consistency.sh` — Artifact validation
- `scripts/list-criteria.sh` — List all acceptance criteria

### Templates
- `skills/spec-first/references/templates/proposal.md` — Proposal template
- `skills/spec-first/references/templates/constitution.md` — Constitution template

### Documentation
- Update README with new commands
- Update `using-sdd/SKILL.md` command catalog
- Add constitution concept to `references/concepts/`
