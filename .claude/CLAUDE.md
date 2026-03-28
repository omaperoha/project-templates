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

## Post-Bootstrap Checklist (MANDATORY after every new project)

After running bootstrap.sh (or manual Option B), Claude MUST complete these steps before starting work:

### 1. Verify GitHub Connection
- If `gh` CLI was not available, the user must create the repo manually at https://github.com/new
- **ALWAYS run `git pull origin main`** before reading any files — the user may have uploaded docs via the GitHub web UI
- Confirm `git remote -v` shows the correct origin

### 2. Confirm Project Name Match
- The GitHub repo name and local folder name MUST match
- If the user created the repo with a different name than bootstrapped, rename the local folder and update ALL references in CLAUDE.md and README.md
- Do NOT assume the bootstrap name is final — ask the user to confirm

### 3. Fill Placeholders BEFORE Starting Work
- Read the generated `.claude/CLAUDE.md` and identify ALL `{{PLACEHOLDERS}}`
- Ask the user for values — do NOT guess or fill with generic text
- The placeholders define scope, role, and security posture for the entire project

### 4. Discovery Phase (before any design work)
- Read ALL customer-provided files (Excel, CSV, PDF, images, ERDs)
- Extract and document: table names, column counts, row counts, join conditions, subject areas, parent-child relationships
- **Use join conditions from customer spreadsheets** — these are authoritative FK mappings
- Ask clarifying questions — never guess on business domain, scope, or requirements
- Save discovery findings to memory

### 5. Peer Review Before Commit
- NEVER commit a plan or spec without running the 5-agent peer review first
- The peer review pattern is documented in `agents/peer-review-orchestrator.md`
- Use 5 agents: Data Architect, Security, Fabric/Platform Specialist, SQL Performance, BI Engineer
- Consolidate findings, apply all Critical and Important fixes, then commit

### 6. Dual Format Delivery
- Generate both .md (for GitHub/technical review) and .docx (for non-technical stakeholders)
- ALWAYS regenerate the .docx after any spec update — do not let them drift out of sync
- Use `npm install docx` + a generator script for DOCX creation

---

## Known Issues & Workarounds

| Issue | Workaround |
|-------|-----------|
| `gh` CLI not installed | Bootstrap runs in local-only mode. User must create repo at github.com/new manually, then `git remote add origin` + `git push`. |
| User uploads files via GitHub web UI | Always `git pull origin main` before reading docs/. Files may exist on remote but not locally. |
| Project name changes after bootstrap | Rename local folder with `mv`, then `sed` all references in CLAUDE.md and README.md. Update git remote if needed. |
| node_modules for DOCX generation | Add `node_modules/` to .gitignore. Only commit package.json, not node_modules. |
| Mermaid diagrams in DOCX | Mermaid cannot render natively in Word. Convert to text-based relationship tables in the DOCX generator. |

---

## How Templates Were Built

Every template was extracted from real consulting engagements:
- **Fabric-Datalake** (`omaperoha/Fabric-Datalake`) — data platform, Medallion architecture, Microsoft Fabric
- **Fabric-Modeling_Layer-Bank** (`omaperoha/Fabric-Modeling_Layer-Bank`) — Gold star schema design, 5-agent peer review, credit union domain
- **DASH-Looker-Integration** — BI/analytics, LookML, BigQuery, Looker dashboards

When a project discovers a new reusable pattern, extract it here.
