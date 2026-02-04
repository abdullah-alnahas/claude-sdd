---
name: sdd-plugin
description: Manage external plugin integrations — register, remove, list, run, and sync plugins for use in SDD workflows.
argument-hint: "<add|remove|list|run|sync> [args...]"
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
  - Task
  - WebFetch
  - AskUserQuestion
---

# /sdd-plugin

Manage external Claude Code plugins registered with SDD. Registered plugins' agents and commands become available in `/sdd-execute`, `/sdd-orchestrate`, and direct invocation via `run`.

## Usage

- `/sdd-plugin add <source>` — Register a plugin from a local path, marketplace name, or git URL
- `/sdd-plugin remove <name>` — Unregister a plugin
- `/sdd-plugin list` — Show all registered plugins and their capabilities
- `/sdd-plugin run <plugin>:<command> [args]` — Invoke a registered plugin's command through SDD
- `/sdd-plugin sync` — Rescan all registered plugins and update the registry with latest capabilities

## Registry File

The plugin registry lives at `.sdd-plugins.json` in the project root. It tracks:

```json
{
  "version": 1,
  "plugins": {
    "plugin-name": {
      "source": "/path/to/plugin | marketplace:name | git:url",
      "path": "/resolved/absolute/path",
      "version": "1.0.0",
      "description": "Plugin description from its manifest",
      "agents": ["agent-name-1", "agent-name-2"],
      "commands": ["command-1", "command-2"],
      "skills": ["skill-1"],
      "registered_at": "2024-01-15T10:30:00Z",
      "last_synced": "2024-01-15T10:30:00Z"
    }
  }
}
```

## Subcommands

### add

Register an external plugin with SDD.

**Sources supported:**
- **Local path**: `/sdd-plugin add /path/to/plugin` or `/sdd-plugin add ./relative/path`
- **Marketplace name**: `/sdd-plugin add marketplace:plugin-name`
- **Git URL**: `/sdd-plugin add git:https://github.com/user/plugin-repo`

**Behavior:**

1. **Resolve the source**:
   - **Local path**: Verify the path exists and contains `.claude-plugin/plugin.json`
   - **Marketplace name**: Run `claude /plugin marketplace search <name>` to find it, then determine its installed path. If not installed, inform the user they need to install it first via `/plugin install`
   - **Git URL**: Clone the repo to a temporary location, verify it's a valid plugin, then ask the user where to store it permanently (suggest `.sdd-plugins/<name>/`)
2. **Scan the plugin**: Read its `plugin.json`, then scan its directories:
   - `agents/` — list all `.md` files (strip extension for agent names)
   - `commands/` — list all `.md` files (strip extension for command names)
   - `skills/` — list all subdirectories containing `SKILL.md`
3. **Check for conflicts**: Warn if any agent/command names collide with SDD's built-in agents/commands or other registered plugins
4. **Register**: Write entry to `.sdd-plugins.json` (create file if it doesn't exist)
5. **Report**: Show what was registered

**Output:**

```
SDD Plugin — Registered
───────────────────────

  Plugin:      pr-review-toolkit
  Source:      /home/user/.claude/plugins/pr-review-toolkit
  Version:     1.2.0

  Agents:      silent-failure-hunter, pr-test-analyzer, type-design-analyzer
  Commands:    review-pr
  Skills:      (none)

  Registry:    .sdd-plugins.json updated
```

### remove

Unregister a plugin from SDD.

**Behavior:**

1. Read `.sdd-plugins.json`
2. Find the plugin by name (case-insensitive match)
3. Remove its entry
4. Write updated registry
5. Note: This does NOT uninstall the plugin from Claude Code — it only removes SDD's awareness of it

**Output:**

```
SDD Plugin — Removed
────────────────────

  Removed:     pr-review-toolkit
  Registry:    .sdd-plugins.json updated

  Note: Plugin is still installed in Claude Code.
        Use /plugin uninstall to fully remove it.
```

### list

Show all registered plugins and their capabilities.

**Behavior:**

1. Read `.sdd-plugins.json`
2. For each plugin, display its name, source, and discovered capabilities
3. If no plugins registered, suggest using `add`

**Output:**

```
SDD Plugin — Registry
─────────────────────

  pr-review-toolkit (v1.2.0)
    Source:    /home/user/.claude/plugins/pr-review-toolkit
    Agents:   silent-failure-hunter, pr-test-analyzer, type-design-analyzer
    Commands: review-pr
    Synced:   2024-01-15 10:30

  code-simplifier (v0.5.0)
    Source:    marketplace:code-simplifier
    Agents:   code-simplifier
    Commands: simplify
    Synced:   2024-01-14 09:15

  Total: 2 plugins, 4 agents, 2 commands
```

### run

Invoke a registered plugin's command or agent through SDD's discipline layer.

**Usage:** `/sdd-plugin run <plugin-name>:<component> [args]`

**Behavior:**

1. Parse `<plugin-name>:<component>` — the plugin name and the command/agent to run
2. Look up the plugin in `.sdd-plugins.json`
3. Verify the component exists in the plugin's registered capabilities
4. **For commands**: Invoke the plugin's command by reading the command file from the plugin's path and executing its instructions, passing any additional args
5. **For agents**: Launch the agent using the Task tool with the agent's definition from the plugin's path
6. Apply SDD guardrails around the execution (pre-implementation checkpoint if in dev mode)

**Output:** The output of the invoked command/agent, wrapped in SDD's standard formatting.

### sync

Rescan all registered plugins and update the registry.

**Behavior:**

1. Read `.sdd-plugins.json`
2. For each registered plugin:
   a. Verify the path still exists (warn if not)
   b. Re-read `plugin.json` for updated version/description
   c. Rescan `agents/`, `commands/`, `skills/` directories
   d. Update the registry entry with new capabilities
   e. Update `last_synced` timestamp
3. Write updated `.sdd-plugins.json`
4. Report changes (new agents/commands discovered, removed ones, version changes)

**Output:**

```
SDD Plugin — Sync Complete
──────────────────────────

  pr-review-toolkit
    Version:  1.2.0 → 1.3.0
    Added:    comment-analyzer (agent)
    Removed:  (none)

  code-simplifier
    No changes

  Synced 2 plugins. 1 updated.
```

## Integration with SDD Workflows

### /sdd-execute integration

When `/sdd-execute` runs, it checks `.sdd-plugins.json` for registered plugins. The user controls how plugin agents are used via the `--plugins` flag:

- `--plugins=ask` — Show available plugin agents at start, ask which to include in the verification stack
- `--plugins=auto` — Automatically include all registered plugin agents in the verification stack
- `--plugins=off` — Don't use plugin agents (default behavior, backwards compatible)

If `--plugins` is not specified, the default is `off`.

When plugins are active, their agents are added to the verification stack in step 3 of the execution loop:
1. Test runners (project test suite)
2. Type checkers / linters
3. SDD built-in agents (critic, spec-compliance, etc.)
4. **Registered plugin agents** (from `.sdd-plugins.json`)

### /sdd-orchestrate integration

Registered plugin agents become available for use in custom pipelines:

```
/sdd-orchestrate custom critic,pr-review-toolkit:silent-failure-hunter,simplifier
```

The `Available agents` list in `/sdd-orchestrate` expands to include registered plugin agents using the `<plugin>:<agent>` notation. Built-in agents can be referenced by name alone.

## Error Handling

- **Plugin path not found**: Report which path is missing, suggest `sync` or `remove`
- **Invalid plugin structure**: Report what's missing (no plugin.json, etc.)
- **Name collision**: Warn about conflicts, ask user whether to proceed
- **Registry file missing**: Create it on first `add`
- **Registry file malformed**: Back up the broken file, create a fresh one, ask user to re-add plugins

## Notes

- The registry is project-local (`.sdd-plugins.json` in project root) — different projects can have different plugin registrations
- Consider adding `.sdd-plugins.json` to `.gitignore` if plugin paths are machine-specific, or committing it if paths are relative
- `sync` is idempotent — safe to run repeatedly
- Plugin capabilities are cached in the registry to avoid scanning on every invocation
