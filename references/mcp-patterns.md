# MCP Integration Patterns

"Enable the Slack MCP, then paste a Slack bug thread into Claude and just say 'fix.' Zero context switching required." — Claude Code team

## What is MCP?

Model Context Protocol (MCP) connects Claude to external services. Instead of copying data into prompts, MCP provides direct access to:
- Slack messages and threads
- Database queries (BigQuery, PostgreSQL)
- GitHub issues and PRs
- Document stores (Google Drive, Notion)

## When to Use What

| Need | Use | Why |
|------|-----|-----|
| Read Slack threads | MCP | Direct access, no copy-paste |
| Run SQL queries | CLI (bq, psql) | More control, better output formatting |
| GitHub operations | gh CLI | Built-in, well-documented |
| File operations | Native tools | Read, Write, Grep are optimized |
| External APIs | WebFetch | When no MCP/CLI exists |

**Decision tree:**
```
Need external data?
├─ MCP server exists? → Use MCP
├─ CLI tool exists? → Use CLI via Bash
├─ REST API available? → Use WebFetch
└─ None of above → Ask user to provide data
```

## Slack MCP Pattern

### Setup

```json
// .mcp.json
{
  "mcpServers": {
    "slack": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-slack"],
      "env": {
        "SLACK_BOT_TOKEN": "${SLACK_BOT_TOKEN}"
      }
    }
  }
}
```

### Usage patterns

**Bug thread triage:**
```
User: Here's a bug thread from #incidents: [slack link]
Claude: [Uses MCP to read thread, identifies the issue, proposes fix]
```

**Daily standup context:**
```
User: Summarize what happened in #engineering today
Claude: [Uses MCP to fetch recent messages, provides summary]
```

**Incident investigation:**
```
User: What do we know about the outage at 3pm?
Claude: [Uses MCP to search relevant channels, compiles timeline]
```

## Database CLI Patterns

### BigQuery (bq)

The CC team uses BigQuery for analytics directly in Claude.

**First-time setup**:
```bash
# Install gcloud CLI: https://cloud.google.com/sdk/docs/install
gcloud auth login
gcloud auth application-default login
gcloud config set project YOUR_PROJECT_ID
```

**Query example**:
```bash
bq query --use_legacy_sql=false '
  SELECT date, count(*) as errors
  FROM `project.dataset.errors`
  WHERE date > DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
  GROUP BY date
  ORDER BY date
'
```

**Common patterns:**

| Task | Command Pattern |
|------|-----------------|
| Error trends | `bq query` with date aggregation |
| User metrics | `bq query` with user grouping |
| Performance | `bq query` on latency tables |
| Export data | `bq extract` to GCS |

**Skill example:**
```markdown
# BigQuery Analytics Skill

When asked about metrics or data:
1. Identify the relevant table from schema
2. Write the query
3. Run via `bq query`
4. Interpret results for the user
```

### PostgreSQL (psql)

```bash
# Direct query
psql -h localhost -U user -d dbname -c "SELECT * FROM users LIMIT 10"

# From file
psql -h localhost -U user -d dbname -f query.sql
```

### SQLite

```bash
sqlite3 database.db "SELECT * FROM config"
```

## GitHub CLI (gh)

Already integrated — use `gh` for:

```bash
# Issues
gh issue list
gh issue view 123
gh issue create --title "Bug" --body "Description"

# PRs
gh pr list
gh pr view 456
gh pr create --title "Fix" --body "Description"

# API (anything else)
gh api repos/owner/repo/commits
```

## Example Configurations

### Full development setup

```json
// .mcp.json
{
  "mcpServers": {
    "slack": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-slack"],
      "env": {
        "SLACK_BOT_TOKEN": "${SLACK_BOT_TOKEN}"
      }
    },
    "notion": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-notion"],
      "env": {
        "NOTION_API_KEY": "${NOTION_API_KEY}"
      }
    }
  }
}
```

### Analytics setup

No MCP needed — use CLI:

```bash
# .claude/CLAUDE.md
## Analytics Commands

For BigQuery:
- Use `bq query` with project: my-project
- Default dataset: analytics

For local metrics:
- SQLite db at: ./data/metrics.db
```

## Security Considerations

1. **Token scope** — Use minimum required permissions for MCP servers
2. **Environment variables** — Never hardcode tokens in .mcp.json
3. **Query validation** — Be cautious with dynamic SQL (injection risk)
4. **Data sensitivity** — Don't query PII unnecessarily

## SDD Integration

MCP patterns work with SDD:

| SDD Command | MCP Use |
|-------------|---------|
| `/sdd-adopt` | Pull docs from Notion/Confluence |
| `/sdd-techdebt` | Query error metrics from BigQuery |
| `/sdd-review` | Fetch related Slack discussions |
| `/sdd-status` | Check GitHub issues for blockers |

## Tips from the CC Team

1. **"I haven't written SQL in 6+ months"** — Claude writes and runs queries via bq CLI

2. **Analytics queries in Claude Code** — Have a BigQuery skill checked into the repo

3. **Zero context switching** — MCP for Slack means bug threads come to you

4. **CLI > MCP when control matters** — bq output formatting is better than MCP
