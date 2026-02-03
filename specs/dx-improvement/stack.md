# Stack: SDD DX Improvement

## Technology

- **Platform**: Claude Code Plugin (existing)
- **Languages**: Markdown, Bash, JSON
- **No new dependencies** — pure documentation and script changes

## Files to Modify

### Documentation
- `README.md` — restructure with flowchart
- `skills/using-sdd/SKILL.md` — update command catalog

### Commands
- Consolidate overlapping commands
- Add `/sdd-init` command
- Add `/sdd-help` command (if not exists)

### Hooks
- `hooks/scripts/session-init.sh` — add visible feedback
- `hooks/scripts/post-edit-review.sh` — add visible feedback
- `hooks/scripts/completion-review.sh` — add visible feedback
- `hooks/scripts/compaction-counter.sh` — add visible feedback

### Configuration
- Document defaults clearly
- Create minimal config examples

## Constraints

- No breaking changes to existing workflows
- Preserve all current functionality
- Changes must be backward compatible
