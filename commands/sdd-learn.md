---
name: sdd-learn
description: "[REMOVED] Edit CLAUDE.md directly. Capture lessons learned."
argument-hint: "[lesson text]"
user_invocable: false
allowed-tools:
  - Read
  - Write
  - Grep
---

# /sdd-learn

Capture a lesson from this session and add it to CLAUDE.md (or a notes directory). "Update your CLAUDE.md so you don't make that mistake again."

## Usage

- `/sdd-learn` — Infer lesson from recent conversation (last 10 messages or since last lesson)
- `/sdd-learn "Always validate input before processing"` — Add explicit lesson

## Behavior

### Step 1: Determine lesson source

**If explicit text provided:**
- Use the provided text as the lesson

**If no text provided:**
- Analyze the last 10 messages (or since last `/sdd-learn` invocation)
- Look for patterns: user corrections, "no, do X instead", "that's wrong", explicit feedback
- If no correction found, say: "No recent correction found. Use `/sdd-learn 'lesson text'` to add a specific lesson."

### Step 2: Formulate the rule

Transform the lesson into a CLAUDE.md-style rule:

```markdown
<!-- Learned: YYYY-MM-DD -->
- [Category]: [Rule in imperative form]
```

Categories:
- **Code Style**: Formatting, naming, patterns
- **Architecture**: Design decisions, structure
- **Testing**: Test practices, coverage
- **Workflow**: Process, tool usage
- **Domain**: Project-specific knowledge
- **Security**: Auth, validation, secrets handling
- **Performance**: Optimization, caching, queries

Example:
```markdown
<!-- Learned: 2026-02-03 -->
- Code Style: Always use explicit return types in TypeScript functions
```

### Step 3: Determine target file

1. Check if `.sdd.yaml` exists and has `notes_dir` configured
2. If yes, target is `{notes_dir}/lessons.md`
3. If no, target is `CLAUDE.md` (project root, then `~/.claude/CLAUDE.md`)

### Step 4: Write (append-only)

1. Show the proposed rule to the user
2. Ask: "Add this to [target]? [y/n]"
3. If confirmed:
   - Append to target file (never modify existing content)
   - Create file if it doesn't exist
   - Report success: "Lesson added to [target]"

## Output Format

```
SDD Learn
─────────

Detected correction: "Use async/await instead of .then() chains"

Proposed rule:
<!-- Learned: 2026-02-03 -->
- Code Style: Prefer async/await over .then() chains for readability

Add this to CLAUDE.md? [y/n]
```

## Edge Cases

- **No CLAUDE.md exists**: Create it with a header section
- **notes_dir doesn't exist**: Create the directory and file
- **Ambiguous correction**: Ask user to clarify or provide explicit text
- **Multiple corrections in context**: Capture the most recent/clear one, mention others

## Principles

- Append-only to avoid merge conflicts in multi-worktree setups
- Timestamp all entries for auditability
- Keep rules concise and actionable
- Don't duplicate existing rules (check before adding)

**Note on concurrent writes**: While append-only reduces conflict risk, simultaneous writes from multiple worktrees can still corrupt the file. For teams with heavy parallel usage, consider using a shared notes repository or manual coordination.
