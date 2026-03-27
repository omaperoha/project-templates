# project-templates — Claude Code Project Context

> **This file is auto-loaded by Claude Code.** It tells you what this repo is and how to use it.

---

## What This Repo Is

This is **NOT a project repo** — it is a **template library**. It contains reusable templates, agent roles, rules, and automation scripts for bootstrapping and running data engineering and BI consulting engagements.

**Repo:** `omaperoha/project-templates` (public)
**GitHub:** https://github.com/omaperoha/project-templates
**Local path:** `H:\Users\Nosotros\Documents\GIT\project-templates`
**Owner:** omaperoha (GitHub personal account)

---

## Primary Use Case: Create a New Project

### Option A: Automated (requires `gh` CLI)

```bash
bash scripts/bootstrap.sh <Project-Name> <project-type>
```

**Arguments:**
- `Project-Name` — becomes the GitHub repo name AND local folder name (e.g., `Acme-Datalake`)
- `project-type` — one of: `data-platform`, `bi-analytics`, `minimal` (default: `minimal`)

**What it does:**
1. Creates `H:\Users\Nosotros\Documents\GIT\{Project-Name}\`
2. Creates private GitHub repo `omaperoha/{Project-Name}`
3. Scaffolds directories: `/docs`, `/notebooks`, `/pipelines`, `/scripts`, `/semantic_model`, `/warehouse`
4. Generates `.gitignore`, `README.md`, and `.claude/CLAUDE.md` from templates
5. Makes 2 commits and pushes to GitHub

**Prerequisites:**
- GitHub CLI (`gh`) installed and authenticated (`gh auth login`)
- Install: https://cli.github.com/ or `winget install --id GitHub.cli`

### Option B: Manual (no `gh` CLI)

If `gh` is not installed, do these steps manually:

1. **Create the GitHub repo** — go to https://github.com/new, name it, set to Private, do NOT initialize with README
2. **Create the local folder:**
   ```bash
   mkdir -p "H:\Users\Nosotros\Documents\GIT\{Project-Name}"
   cd "H:\Users\Nosotros\Documents\GIT\{Project-Name}"
   git init -b main
   ```
3. **Scaffold directories:**
   ```bash
   for dir in docs notebooks pipelines scripts semantic_model warehouse .claude; do
     mkdir -p "$dir"
     [ "$dir" != ".claude" ] && touch "$dir/.gitkeep"
   done
   ```
4. **Copy templates from this repo:**
   ```bash
   TEMPLATES="H:\Users\Nosotros\Documents\GIT\project-templates"
   cp "$TEMPLATES/scripts/templates/gitignore.template" .gitignore
   cp "$TEMPLATES/templates/claude-md/data-platform.md" .claude/CLAUDE.md  # or bi-analytics.md
   ```
5. **Fill in placeholders** in `.claude/CLAUDE.md` — replace all `{{PLACEHOLDERS}}`
6. **Create README.md** with project name and structure
7. **Commit and push:**
   ```bash
   git add -A
   git commit -m "Initial project structure"
   git remote add origin https://github.com/omaperoha/{Project-Name}.git
   git push -u origin main
   ```

---

## Configuration

- **GitHub owner:** `omaperoha` (hardcoded in bootstrap.sh)
- **Local base path:** `H:\Users\Nosotros\Documents\GIT\` (hardcoded in bootstrap.sh)
- **Default branch:** `main`
- **Repo visibility:** Private (all new projects)

---

## Full Resource Inventory

| Category | Path | Contents |
|----------|------|----------|
| **CLAUDE.md templates** | `templates/claude-md/` | `data-platform.md` — Fabric/Databricks/Medallion; `bi-analytics.md` — Looker/Power BI/Tableau |
| **Architecture templates** | `templates/architecture/` | `architecture_plan_template.md` — full Medallion plan; `peer_review_template.md` — multi-agent review; `data_validation_checklist_template.md` — column-by-column validation |
| **Data profiling notebook** | `templates/notebooks/data-profiling/` | `nb_data_profiling_template.py` — PySpark, 15 cells, 38 checks; `fabric_setup_instructions.md` — Fabric guide |
| **Presentation patterns** | `templates/presentations/` | pptxgenjs patterns and gotchas |
| **Agent roles** | `agents/` | `data-architect.md` — Senior Data Architect; `security-reviewer.md` — IT Security & Compliance; `fabric-specialist.md` — Fabric Platform; `sql-performance.md` — SQL & Query Performance; `peer-review-orchestrator.md` — how to run 4-agent peer review |
| **Rules** | `rules/` | `pii-handling.md` — PII classification & protection; `document-standards.md` — naming, formatting; `git-workflow.md` — branch strategy, commits; `quality-gates.md` — review checkpoints, definition of done |
| **Bootstrap script** | `scripts/bootstrap.sh` | Automated new project scaffolding |
| **File templates** | `scripts/templates/` | `gitignore.template`, `readme.template` |

---

## Rules for This Repo

1. **Never delete or overwrite existing templates** without explicit approval.
2. **All templates use `{{PLACEHOLDERS}}`** — never hardcode project-specific details.
3. **When adding new templates:** parameterize, add a README, place in the right directory.
4. **This repo is public** — never add credentials, PII, or client-specific data.
5. **Default branch is `master`** (not `main`) for this repo.

---

## How Templates Were Built

Every template was extracted from real consulting engagements:
- **Fabric-Datalake** (`omaperoha/Fabric-Datalake`) — data platform, Medallion architecture, Microsoft Fabric
- **DASH-Looker-Integration** — BI/analytics, LookML, BigQuery, Looker dashboards

When a project discovers a new reusable pattern, extract it here.
