# Worktree-Aware Development

"Spin up 3-5 git worktrees at once, each running its own Claude session in parallel. It's the single biggest productivity unlock." — Claude Code team

## Why Worktrees?

Git worktrees allow multiple working directories from a single repo. Each worktree:
- Has its own branch checked out
- Can run its own Claude session
- Shares git history with the main repo
- Isolates work without stashing or committing

## Setup Guide

### Create worktrees

```bash
# From main repo
git worktree add ../project-feature-a feature/auth
git worktree add ../project-feature-b feature/api
git worktree add ../project-analysis main  # Read-only analysis

# List worktrees
git worktree list
```

### Shell aliases for quick switching

Add to `~/.zshrc` or `~/.bashrc`:

```bash
# Quick switch between worktrees
alias za='cd ~/projects/myapp-a && claude'
alias zb='cd ~/projects/myapp-b && claude'
alias zc='cd ~/projects/myapp-c && claude'
alias zx='cd ~/projects/myapp-analysis && claude'  # Analysis worktree

# Or use a function for any worktree
wt() {
  cd ~/projects/myapp-$1 && claude
}
# Usage: wt a, wt b, wt analysis
```

### Naming conventions

Use descriptive names that indicate purpose:

```
myapp/              # Main repo
myapp-auth/         # Feature: authentication
myapp-api/          # Feature: API redesign
myapp-bugfix/       # Current bug fixes
myapp-analysis/     # Read-only analysis (always on main)
```

## SDD Context Preservation

Each worktree gets its own SDD state because:
- `.sdd-phase` is per-directory
- `.sdd.yaml` can be copied or shared
- Environment variables are per-session

### Option 1: Shared config (symlink)

```bash
# In each worktree (Linux/macOS)
ln -s ../myapp/.sdd.yaml .sdd.yaml

# On Windows (requires admin or Developer Mode)
mklink .sdd.yaml ..\myapp\.sdd.yaml
# Or use junction for directories:
mklink /J config ..\myapp\config
```

**Windows note**: Symlinks require admin privileges or Developer Mode enabled. Alternative: use a copy script or git hooks to sync config files.

### Option 2: Independent configs

Each worktree can have its own `.sdd.yaml` with different settings:
- Analysis worktree: `default_mode: research`
- Feature worktree: `default_mode: dev`

### Option 3: Session-level override

Set mode per session without touching files:

```bash
# In worktree terminal
export SDD_MODE=research
claude
```

## The Analysis Worktree Pattern

Keep one worktree dedicated to read-only analysis:

**Purpose:**
- Running queries, reading logs
- BigQuery/database exploration
- Codebase archaeology
- Never makes changes

**Setup:**
```bash
git worktree add ../myapp-analysis main
cd ../myapp-analysis
echo "research" > .sdd-phase
```

**In Claude:**
- Use `/sdd-mode research` for relaxed guardrails
- Run analysis commands without write permissions
- Keep context clean for investigation

## Parallel Workflow Example

```
Terminal 1 (za — auth feature):
  $ claude
  > /sdd-execute  # Implementing auth

Terminal 2 (zb — API feature):
  $ claude
  > /sdd-execute  # Implementing API

Terminal 3 (zx — analysis):
  $ claude
  > /sdd-mode research
  > Analyze the error patterns in logs/app.log
```

All three sessions run independently, each with full Claude context.

## Tips from the CC Team

1. **Name worktrees by task, not branch** — `myapp-auth` not `myapp-feature-xyz-123`

2. **Color-code terminal tabs** — Visual distinction prevents wrong-worktree mistakes

3. **One keystroke switching** — Shell aliases like `za`, `zb` are essential

4. **Dedicated analysis worktree** — Never pollute analysis with implementation

5. **Clean up finished worktrees** — `git worktree remove ../myapp-auth` when done

## Cleanup

```bash
# Remove a worktree
git worktree remove ../myapp-feature-a

# Prune stale worktrees (after manual deletion)
git worktree prune

# List and clean
git worktree list
```

## SDD Commands in Worktrees

All SDD commands work normally in worktrees:

| Command | Behavior in Worktree |
|---------|---------------------|
| `/sdd-status` | Shows status for current worktree |
| `/sdd-phase` | Phase is per-worktree (`.sdd-phase` file) |
| `/sdd-execute` | Implements in current worktree only |
| `/sdd-review` | Reviews current worktree changes |
| `/sdd-learn` | Writes to worktree's CLAUDE.md (or shared via symlink) |
