# Contributing to claude-sdd

Thank you for your interest in improving the SDD plugin. This guide covers the plugin structure and how to add new components.

## Plugin Structure

```
sdd/
├── agents/          — Specialized review agents (sonnet model)
├── commands/        — User-invocable slash commands
│   ├── checklists/  — Reusable checklists referenced by commands
│   └── sdd-autopilot/ — Step files for autopilot phases
├── contexts/        — Mode-specific guardrail profiles (dev/review/research)
├── hooks/           — Automatic triggers (hooks.json + scripts/)
├── skills/          — Behavioral disciplines with references/
├── scripts/         — Validation and testing scripts
├── specs/           — SDD's own specifications
└── references/      — Shared reference documents
```

## Adding a Command

1. Create `commands/your-command.md` with required frontmatter:
   ```yaml
   ---
   name: your-command
   description: One-line description of what the command does
   allowed-tools:
     - Read
     - Glob
   ---
   ```
2. Add a `## Usage` section and `## Behavior` section
3. Add the command to `manifest.yaml` under `commands:`
4. Run `bash scripts/verify-commands.sh` to validate

## Adding a Skill

1. Create `skills/your-skill/SKILL.md` with frontmatter:
   ```yaml
   ---
   name: Your Skill Name
   description: >
     When to use this skill — trigger phrases and contexts.
   ---
   ```
2. Keep SKILL.md under 3000 words
3. Add reference materials in `skills/your-skill/references/`
4. Add the skill to `manifest.yaml` under `skills:`
5. Run `bash scripts/verify-skills.sh` to validate

## Adding an Agent

1. Create `agents/your-agent.md` with frontmatter:
   ```yaml
   ---
   name: your-agent
   model: sonnet
   color: blue
   description: >
     What the agent does. Include 2-3 <example> blocks.
   allowed-tools:
     - Read
     - Glob
   ---
   ```
2. Add a `## Persona` section (icon, tone, focus, principles)
3. Keep agents under 150 total lines
4. Add the agent to `manifest.yaml` under `agents:`

## Testing

Before submitting changes, run all validators:

```bash
bash scripts/validate-plugin.sh   # Comprehensive plugin validation
bash scripts/verify-commands.sh   # Command structure
bash scripts/verify-skills.sh     # Skill structure
bash scripts/verify-hooks.sh      # Hook configuration
```

All scripts must exit with code 0.

## Pull Request Process

1. Fork the repository and create a feature branch
2. Make your changes following the patterns above
3. Run all validation scripts
4. Submit a PR with:
   - What you changed and why
   - Which validation scripts pass
   - Any new commands/skills/agents added

## Style Guidelines

- Commands use imperative voice ("Scan the project", not "Scans the project")
- Skills describe behavioral discipline, not implementation steps
- Agents have a clear persona and structured output format
- All markdown files use ATX headers (`#`, `##`, `###`)
- Frontmatter fields use lowercase kebab-case
