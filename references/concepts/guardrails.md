# SDD Guardrails

Guardrails are automatic checks that defend against common LLM failure modes. They fire via hooks without manual invocation.

## Active Guardrails

### Pre-Implementation Checkpoint

**When**: Before starting any implementation task (via UserPromptSubmit hook)

**What it checks**:
- Enumerate assumptions
- Flag ambiguity in requirements
- Surface alternative approaches
- Push back on potentially bad ideas
- Define explicit scope boundaries
- Check for existence of spec
- Plan TDD approach

**Skip in**: review mode, research mode, or trivial responses ("yes", "ok", "continue")

### Scope Guard

**When**: After every Write/Edit operation (via PostToolUse hook)

**What it checks**:
- File is inside project directory
- Number of modified files is below threshold (default: 10)
- Changes are related to current task

**Feedback**: `→ SDD: scope warning — N files modified (limit: 10)`

### Completion Review

**When**: When Claude stops responding (via Stop hook)

**What it checks**:
- Spec adherence
- Test coverage
- Complexity audit
- Dead code
- Scope creep

**Skip in**: review mode, research mode, or when guardrails disabled

### Compaction Counter

**When**: After every tool use (via PostToolUse hook)

**What it checks**:
- Tool invocation count since last compaction suggestion
- Threshold is configurable (default: 50)

**Feedback**: `→ SDD: N tool calls — consider /compact`

## Configuration

Enable/disable guardrails in `.sdd.yaml`:

```yaml
guardrails:
  pre-implementation:
    enabled: true
  scope-guard:
    enabled: true
  completion-review:
    enabled: true
```

Or toggle at runtime:

```
/sdd-guardrails             # Show status
/sdd-guardrails disable     # Disable all
/sdd-guardrails enable      # Enable all
```

## Emergency Escape

If guardrails are blocking legitimate work:

```
/sdd-yolo    # Disable all guardrails for this session
```

The yolo flag auto-clears on next session start.

## Guardrail Philosophy

Guardrails are **friction by design**. They slow you down to prevent mistakes. If they feel annoying, ask: "Am I skipping something important?"

The friction is calibrated to catch:
- Scope creep
- Premature implementation
- Missing tests
- Spec drift
- Overengineering
