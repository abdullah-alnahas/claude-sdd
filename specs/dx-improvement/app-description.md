# SDD Plugin DX Improvement

## Problem Statement

The SDD plugin has sophisticated discipline enforcement but poor developer experience. New users face:

- **17 commands** with unclear entry points
- **7 skills** that overlap in applicability
- **3 modes** and **5 phases** with subtle differences
- **Silent hooks** that fire without explanation
- **40+ line config** with no defaults documentation
- **50+ markdown files** scattered across nested directories

## Goal

Transform SDD from "powerful but confusing" to "obvious and helpful" while preserving the discipline enforcement that makes it valuable.

## Scope

### In Scope

1. README restructuring with quick-start flowchart
2. Command consolidation (reduce from 17 to fewer, clearer commands)
3. Hook feedback visibility
4. Interactive setup wizard (`/sdd-init`)
5. Progressive disclosure (basic vs advanced modes)
6. Centralized concept reference

### Out of Scope

- Core guardrail logic changes
- Agent behavior modifications
- New development phases
- Breaking changes to existing workflows that work

## Success Criteria

A new user can:
1. Install the plugin and see what to do next within 30 seconds
2. Start their first disciplined task with a single command
3. Understand what guardrails are doing when they fire
4. Configure the plugin without reading 40 lines of YAML
