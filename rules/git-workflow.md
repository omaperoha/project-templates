# Git Workflow Rules

## Branch Strategy

```
main (or master)          <- Production. Never push directly.
  |
  +-- feature/{{name}}    <- Feature work. One branch per task.
  +-- dev-{{agent}}       <- Agent working branches (e.g., dev-claude)
  +-- hotfix/{{name}}     <- Emergency production fixes
```

## Rules

1. **Never push to `main`/`master` without explicit approval.** All work stays in feature branches until the user says to merge.

2. **Start of session:** Always pull latest from main and merge into your working branch.
   ```bash
   git fetch origin
   git merge origin/main
   ```

3. **Commit messages:** Concise, descriptive, focused on "why" not "what".
   ```
   Add data profiling notebook with 38 automated checks

   - PySpark notebook for Fabric with encoding, PII, null convention detection
   - Portable JSON export for Silver layer design automation
   - 19/19 local tests pass with synthetic data
   ```

4. **Commit scope:** One logical change per commit. Don't mix unrelated changes.

5. **Never commit secrets.** API keys, tokens, passwords, and credentials must be in `.gitignore`d files (e.g., `.claude/looker.ini`, `.env`).

6. **PR format:**
   ```markdown
   ## Summary
   - [1-3 bullet points describing the change]

   ## Test plan
   - [ ] [How to verify the change works]

   ## Related
   - Addresses [issue/finding reference]
   ```

## Both Pipelines: ETL + CI/CD

Every project should have TWO pipeline definitions:

| Pipeline | Purpose | Tools |
|----------|---------|-------|
| **ETL Pipeline** | Data movement: source → Bronze → Silver → Gold | Data Factory, PySpark notebooks |
| **CI/CD Pipeline** | Deployment: code → test → staging → production | Fabric Git integration, deployment pipelines |

Always mention and document both. ETL handles data; CI/CD handles code and config deployment.

## What to .gitignore

```gitignore
# Credentials
.env
*.ini
credentials.json

# IDE / Editor
.vscode/
.idea/
*.swp

# OS
.DS_Store
Thumbs.db

# Build artifacts
node_modules/
__pycache__/
*.pyc
dist/
build/

# Data (never commit real data)
*.csv
*.xlsx
*.parquet
!scripts/test_data/   # Synthetic test data is OK
```
