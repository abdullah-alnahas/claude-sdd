---
name: sdd-explain
description: "[REMOVED] Ask Claude directly. Generate explanations of code."
argument-hint: "<target> [--format text|ascii|html]"
user_invocable: false
allowed-tools:
  - Read
  - Glob
  - Grep
  - Write
---

# /sdd-explain

Generate explanations of code, architecture, or concepts. "Have Claude generate a visual HTML presentation explaining unfamiliar code."

## Usage

- `/sdd-explain src/auth/` — Text explanation of auth module
- `/sdd-explain --format ascii src/api/` — ASCII diagram of API structure
- `/sdd-explain --format html src/database/` — HTML slides for database layer
- `/sdd-explain "how authentication works"` — Concept explanation

## Formats

### text (default)

Structured prose explanation:

```
Module: src/auth/

Purpose:
  Handles user authentication and session management.

Key Components:
  - auth.ts: Main authentication logic
  - session.ts: Session creation and validation
  - middleware.ts: Express middleware for route protection

Data Flow:
  1. User submits credentials to /login
  2. auth.ts validates against database
  3. session.ts creates JWT token
  4. middleware.ts validates token on subsequent requests

Dependencies:
  - bcrypt (password hashing)
  - jsonwebtoken (JWT operations)
  - express-session (session storage)
```

### ascii

ASCII art diagrams for terminal display:

```
Authentication Flow
═══════════════════

  ┌────────┐     ┌──────────┐     ┌──────────┐
  │ Client │────▶│ /login   │────▶│ auth.ts  │
  └────────┘     └──────────┘     └────┬─────┘
                                       │
                                       ▼
                                 ┌──────────┐
                                 │ Database │
                                 └────┬─────┘
                                      │
                      ┌───────────────┴───────────────┐
                      ▼                               ▼
               ┌──────────┐                    ┌──────────┐
               │ Valid    │                    │ Invalid  │
               └────┬─────┘                    └────┬─────┘
                    │                               │
                    ▼                               ▼
             ┌──────────┐                    ┌──────────┐
             │ JWT      │                    │ 401      │
             │ Token    │                    │ Error    │
             └──────────┘                    └──────────┘
```

### html

Self-contained HTML presentation with slides.

**Security note**: Code snippets are embedded verbatim. If the source code contains `<script>` tags or HTML, they will be rendered. Treat generated HTML files as untrusted if sharing or hosting publicly. Consider escaping code blocks or viewing locally only.

```html
<!DOCTYPE html>
<html>
<head>
  <title>Authentication Module</title>
  <style>
    /* Embedded styles for self-contained file */
    .slide { /* ... */ }
  </style>
</head>
<body>
  <div class="slide" id="slide-1">
    <h1>Authentication Module</h1>
    <p>Overview of src/auth/</p>
  </div>

  <div class="slide" id="slide-2">
    <h2>Components</h2>
    <ul>
      <li>auth.ts — Main logic</li>
      <li>session.ts — Token management</li>
      <li>middleware.ts — Route protection</li>
    </ul>
  </div>

  <!-- More slides... -->

  <script>
    /* Embedded navigation for self-contained file */
  </script>
</body>
</html>
```

## Behavior

### Step 1: Identify target

**If path provided:**
- Read directory structure
- Read key files
- Identify patterns and purpose

**If concept provided:**
- Search codebase for relevant code
- Trace the concept through files
- Build understanding from evidence

### Step 2: Generate explanation

Based on format flag:

| Format | Output |
|--------|--------|
| text | Structured prose to stdout |
| ascii | ASCII diagrams to stdout |
| html | Write file to `explain-{target}.html` |

### Step 3: Present

For text/ascii: Display in response
For html: Write file and report path

## Examples

### Explain a directory

```
> /sdd-explain src/middleware/

Module: src/middleware/

Purpose:
  Express middleware stack for request processing.

Components:
  - auth.ts: JWT validation, attaches user to req
  - logging.ts: Request/response logging
  - error.ts: Global error handler
  - rateLimit.ts: API rate limiting

Middleware Order:
  1. logging (all requests)
  2. rateLimit (API routes)
  3. auth (protected routes)
  4. error (catch-all)

Patterns:
  - All middleware follows (req, res, next) signature
  - Errors passed via next(err)
  - Config loaded from env
```

### Explain a concept

```
> /sdd-explain "how errors are handled"

Error Handling in This Codebase
───────────────────────────────

Entry Points:
  1. Route handlers throw → caught by error middleware
  2. Async functions use try/catch → rethrow as AppError
  3. Database errors → wrapped in DatabaseError class

Error Classes (src/errors/):
  - AppError: Base class with statusCode
  - ValidationError: 400 errors
  - AuthError: 401/403 errors
  - NotFoundError: 404 errors
  - DatabaseError: 500 errors (logged, generic message to client)

Flow:
  throw ValidationError("Invalid email")
    → error middleware catches
    → logs full error (dev) or sanitized (prod)
    → sends { error: message, code: statusCode }
```

### Generate ASCII diagram

```
> /sdd-explain --format ascii src/api/

API Layer Architecture
══════════════════════

                    ┌─────────────────┐
                    │    Express      │
                    │    Server       │
                    └────────┬────────┘
                             │
         ┌───────────────────┼───────────────────┐
         │                   │                   │
         ▼                   ▼                   ▼
    ┌─────────┐        ┌─────────┐        ┌─────────┐
    │ /users  │        │ /posts  │        │ /auth   │
    │ router  │        │ router  │        │ router  │
    └────┬────┘        └────┬────┘        └────┬────┘
         │                   │                   │
         ▼                   ▼                   ▼
    ┌─────────┐        ┌─────────┐        ┌─────────┐
    │ User    │        │ Post    │        │ Auth    │
    │ Service │        │ Service │        │ Service │
    └────┬────┘        └────┬────┘        └────┬────┘
         │                   │                   │
         └───────────────────┼───────────────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │    Database     │
                    │    (Prisma)     │
                    └─────────────────┘
```

### Generate HTML slides

```
> /sdd-explain --format html src/auth/

Generating HTML presentation...

Written to: explain-auth.html

Open in browser to view slides.
Use arrow keys to navigate.
```

## Principles

- Explanations are derived from code, not assumptions
- ASCII diagrams prioritize clarity over detail
- HTML slides are self-contained (no external dependencies)
- Adapt detail level to target scope (file vs directory vs concept)
