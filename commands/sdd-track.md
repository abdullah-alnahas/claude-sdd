---
name: sdd-track
description: Manage project task tracking via status.yaml — show status, add tasks, mark done, flag blockers.
argument-hint: "[show|add <task>|done <task>|block <task> <reason>]"
allowed-tools:
  - Read
  - Write
  - Bash
  - Glob
---

# /sdd-track

Lightweight task tracking using `status.yaml` in the project root.

## Usage

- `/sdd-track` or `/sdd-track show` — Display current status
- `/sdd-track add <task description>` — Add a new task
- `/sdd-track done <task name or number>` — Mark a task as complete
- `/sdd-track block <task name or number> <reason>` — Mark a task as blocked
- `/sdd-track unblock <task name or number>` — Remove blocker from a task

## File Format

`status.yaml` structure:

```yaml
phase: implement
tasks:
  - name: "Set up database schema"
    status: done
  - name: "Implement user auth"
    status: in-progress
  - name: "Add API rate limiting"
    status: blocked
    blocker: "Waiting on auth to be complete"
  - name: "Write integration tests"
    status: pending
summary:
  total: 4
  done: 1
  in-progress: 1
  blocked: 1
  pending: 1
```

## Behavior

### show (default)
1. Read `status.yaml` (create if missing with current phase from `.sdd-phase`)
2. Display tasks grouped by status
3. Show summary counts

### add
1. Append task with `status: pending`
2. Update summary counts
3. Confirm addition

### done
1. Find task by name (fuzzy match) or number (1-indexed)
2. Set `status: done`
3. Update summary counts

### block
1. Find task by name or number
2. Set `status: blocked` and `blocker: <reason>`
3. Update summary counts

### unblock
1. Find task by name or number
2. Set `status: pending`, remove `blocker`
3. Update summary counts

## Output Format

```
SDD Track
─────────

Phase: implement

  ✓ Set up database schema
  ► Implement user auth
  ✗ Add API rate limiting — blocked: Waiting on auth to be complete
  ○ Write integration tests

Summary: 4 tasks — 1 done, 1 in-progress, 1 blocked, 1 pending
```
