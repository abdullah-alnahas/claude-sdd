# .sdd.yaml Schema Reference

Place `.sdd.yaml` in your project root to configure SDD behavior.

## Supported Keys

```yaml
# Project identity
project_name: my-project          # Project name (string)

# Mode and behavior
mode: dev                          # Default mode: dev | review | research
verbosity: standard                # Output detail: minimal | standard | verbose
compaction_threshold: 50           # PostToolUse count before compaction warning (integer)

# Directory paths (relative to project root)
spec_dir: specs                    # Where spec files live (default: specs)
test_dir: tests                    # Where test files live (default: auto-detect)

# Scope guard
scope_file_threshold: 10           # Modified file count before scope creep warning (integer)

# Guardrail toggles
guardrails:
  pre_implementation: true         # Pre-implementation checkpoint (boolean)
  completion_review: true          # Completion review gate (boolean)
  scope_guard: true                # Scope creep detection (boolean)

# Agent customization (single-line values only)
agents:
  critic:
    extra_instructions: Focus on security implications
  simplifier:
    extra_instructions: Ignore test files
  spec-compliance:
    extra_instructions: Use strict matching
  security-reviewer:
    extra_instructions: Check for OWASP top 10
  performance-reviewer:
    extra_instructions: Focus on database queries
  planner:
    extra_instructions: Prefer simple architectures
```

## Notes

- All keys are optional. Omitted keys use defaults.
- Agent `extra_instructions` are injected as `$SDD_AGENT_<NAME>_EXTRA` environment variables.
- YAML parsing is grep-based (no external YAML parser required). Only single-line values are supported for agent extra_instructions.
