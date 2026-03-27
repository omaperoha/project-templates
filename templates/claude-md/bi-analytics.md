# {{PROJECT_NAME}} — Claude Code Project Context

> **This file is auto-loaded by Claude Code.** It is the single source of truth for project context, rules, and workflow. Keep it updated after every significant session.

---

## Identity & Role

You are a **{{AGENT_ROLE}}** for the {{PROJECT_NAME}} project. Your job is to plan, develop, test, and deploy {{BI_PLATFORM}} solutions. The user provides requirements and has final approval before any deployment to Production.

---

## API Access

### {{BI_PLATFORM}} API
- **Base URL:** `{{API_BASE_URL}}`
- **Credentials:** stored in `.claude/{{CONFIG_FILE}}` (gitignored, never commit)
- **Project name:** `{{PROJECT_ID}}`

### Python (preferred for API calls)
```python
import requests, configparser
cfg = configparser.ConfigParser()
cfg.read('.claude/{{CONFIG_FILE}}')
# Authenticate and get token
resp = requests.post('{{API_BASE_URL}}/login',
    data={'client_id': cfg['api']['client_id'], 'client_secret': cfg['api']['client_secret']})
token = resp.json()['access_token']
headers = {'Authorization': f'Bearer {token}'}
```

---

## Project Context

### Repository
- **GitHub:** `{{GITHUB_ORG}}/{{REPO_NAME}}`
- **Production branch:** `{{PRODUCTION_BRANCH}}`
- **Dev branch:** `{{DEV_BRANCH}}`
- **Project name:** `{{PROJECT_ID}}`

### Platform
- **Backend:** {{BACKEND_DB}}
- **Schema:** `{{DB_SCHEMA}}`

### Key Files
<!-- List the primary files this project modifies -->
| File | Purpose |
|------|---------|
| `{{PRIMARY_FILE}}` | Primary working file |
| `{{MANIFEST_FILE}}` | Constants and configuration |
| `{{TEST_FILE}}` | Tests |
| `{{DASHBOARD_DIR}}/` | Dashboard definitions |

---

## Rules

### Planning
1. Always provide a plan of action for approval **before making any code changes**.
2. If the user provides feedback on the plan, present the **revised finalized plan again** before executing.
3. Include a testing hypothesis and testing plan in every plan of action.

### Version Control
- **NEVER merge or push to `{{PRODUCTION_BRANCH}}` without explicit user approval.** All work stays in dev branch until instructed.
- Pull and merge latest `{{PRODUCTION_BRANCH}}` into working branch at the start of every session.

### Code Standards
- Never rename or remove existing objects unless explicitly asked.
- Write the simplest, most efficient code possible.
- Only add comments for complex logic — not obvious code.
- Never create a new object if an existing one can be reused.
- If modifying an object, verify it doesn't break existing functionality.
- **PII masking is mandatory** for any field containing personal data.

### Dashboard / Report Standards
- Use existing dashboards/reports as style reference.
- Maintain consistent color scheme, layout, and look-and-feel.

### Testing Standards
- Add a test for every new object used in a dashboard/report.
- Remove tests for removed objects. Update tests for modified objects.

---

## Color Palette

<!-- Customize for your project -->
| Color | Hex | Use |
|-------|-----|-----|
| Primary | `#{{PRIMARY_COLOR}}` | Primary, table bars |
| Secondary | `#{{SECONDARY_COLOR}}` | Secondary accents |
| Tertiary | `#{{TERTIARY_COLOR}}` | Tertiary accents |
| Highlight | `#{{HIGHLIGHT_COLOR}}` | Highlight/attention |
| Alert | `#{{ALERT_COLOR}}` | Negative/alert |
| Text | `#{{TEXT_COLOR}}` | Text/neutral |
| Background | `#{{BG_COLOR}}` | Background/subtle |

---

## Validation Workflow

```
1. Make code changes
2. Add/update tests
3. git commit -> git push to dev branch
4. API: authenticate -> dev mode -> validate
5. Manual UI verification
6. Get user approval -> merge to production branch
7. Deploy to production (if applicable)
```

---

## Cross-Project Resources

This project was bootstrapped from [project-templates](https://github.com/omaperoha/project-templates).

**Local path:** `H:\Users\Nosotros\Documents\GIT\project-templates`

| Category | Path | Contents |
|----------|------|----------|
| **CLAUDE.md templates** | `templates/claude-md/` | `data-platform.md`, `bi-analytics.md` |
| **Architecture templates** | `templates/architecture/` | `architecture_plan_template.md`, `peer_review_template.md`, `data_validation_checklist_template.md` |
| **Data profiling notebook** | `templates/notebooks/data-profiling/` | `nb_data_profiling_template.py` — PySpark, 15 cells, 38 checks |
| **Presentation patterns** | `templates/presentations/` | pptxgenjs patterns and gotchas |
| **Agent roles** | `agents/` | `data-architect.md`, `security-reviewer.md`, `fabric-specialist.md`, `sql-performance.md`, `peer-review-orchestrator.md` |
| **Rules** | `rules/` | `pii-handling.md`, `document-standards.md`, `git-workflow.md`, `quality-gates.md` |
| **Scripts** | `scripts/` | `bootstrap.sh` — new project scaffolding |

Use these resources when starting architecture plans, running peer reviews, or needing security/PII guidance. Copy templates into this project — do not modify the originals.

---

## Current Work Status (as of {{DATE}})

### Completed
<!-- Update as work progresses -->

### Pending
<!-- Track pending items -->
