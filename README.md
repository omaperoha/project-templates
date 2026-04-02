# Project Templates

Reusable templates, agent roles, rules, and skills for data engineering and BI consulting engagements. Built from real-world project patterns.

## Quick Start

0. **Starting from scratch?** Run the bootstrap script to create a new repo with full scaffolding:
   ```bash
   bash scripts/bootstrap.sh My-New-Project data-platform
   ```
   Project types: `data-platform`, `bi-analytics`, `minimal`

1. Starting a new **data platform** project? Copy `templates/claude-md/data-platform.md` to `.claude/CLAUDE.md`
2. Starting a new **BI/analytics** project? Copy `templates/claude-md/bi-analytics.md` to `.claude/CLAUDE.md`
3. Need to **profile source data**? Copy `templates/notebooks/data-profiling/` to your project
4. Need a **peer review**? Follow `agents/peer-review-orchestrator.md`
5. Need an **architecture plan**? Start from `templates/architecture/architecture_plan_template.md`

## Directory Structure

```
project-templates/
|
|-- templates/
|   |-- claude-md/                  # CLAUDE.md templates for Claude Code projects
|   |   |-- data-platform.md        #   Data engineering / Fabric / Databricks
|   |   +-- bi-analytics.md         #   BI / Looker / Power BI / Tableau
|   |
|   |-- notebooks/
|   |   +-- data-profiling/          # PySpark data profiling notebook
|   |       |-- README.md            #   How to customize
|   |       |-- nb_data_profiling_template.py  # The notebook (15 cells, 38 checks)
|   |       +-- fabric_setup_instructions.md   # Step-by-step Fabric guide
|   |
|   |-- architecture/               # Architecture document templates
|   |   |-- architecture_plan_template.md      # Full Medallion architecture plan
|   |   |-- peer_review_template.md            # Peer review findings report
|   |   +-- data_validation_checklist_template.md  # Column-by-column validation
|   |
|   +-- presentations/              # PPTX generation
|       +-- README.md               # pptxgenjs patterns and gotchas
|
|-- agents/                          # Agent role definitions for multi-agent reviews
|   |-- README.md                    # Overview and usage guide
|   |-- data-architect.md            # Senior Data Architect
|   |-- security-reviewer.md         # IT Security & Compliance Specialist
|   |-- fabric-specialist.md         # Microsoft Fabric Platform Specialist
|   |-- sql-performance.md           # SQL & Query Performance Specialist
|   +-- peer-review-orchestrator.md  # How to run a 4-agent peer review
|
|-- rules/                           # Cross-project rules and standards
|   |-- pii-handling.md              # PII classification and protection
|   |-- document-standards.md        # Naming, formatting, references
|   |-- git-workflow.md              # Branch strategy, commit standards
|   +-- quality-gates.md             # When to review, definition of done
|
|-- scripts/                          # Automation scripts
|   |-- bootstrap.sh                  # Create a new project repo from templates
|   +-- templates/                    # File templates used by bootstrap.sh
|       |-- gitignore.template        #   Standard .gitignore
|       +-- readme.template           #   README.md with placeholders
|
+-- skills/                          # Claude Code skill definitions
    |-- fabric-architect/            #   Fabric Medallion architecture
    |-- docx-generator/              #   Markdown to DOCX converter
    +-- (more added as patterns emerge)
```

## How to Use Templates

### 0. Bootstrap a New Project (Recommended)

The fastest way to start. Creates a private GitHub repo, local folder, directory skeleton, `.gitignore`, `README.md`, and `CLAUDE.md` in two commits:

```bash
# From the project-templates repo root:
bash scripts/bootstrap.sh My-New-Project data-platform
```

**Arguments:**
| Argument | Required | Description |
|----------|----------|-------------|
| `project-name` | Yes | Repo name and local folder name (e.g., `Acme-Datalake`) |
| `project-type` | No | `data-platform`, `bi-analytics`, or `minimal` (default: `minimal`) |

**What it does:**
1. Validates `gh` CLI is installed and authenticated
2. Creates `H:\Users\Nosotros\Documents\GIT\{project-name}\`
3. Runs `gh repo create omaperoha/{project-name} --private`
4. Scaffolds: `/docs`, `/notebooks`, `/pipelines`, `/scripts`, `/semantic_model`, `/warehouse`
5. Generates `.gitignore` and `README.md` from templates
6. Copies the CLAUDE.md template for your project type (with name/repo pre-filled)
7. Makes 2 commits and pushes to GitHub

**After bootstrap**, open `.claude/CLAUDE.md` and fill in remaining `{{PLACEHOLDERS}}`.

### 1. CLAUDE.md Templates

Copy the appropriate template to your project's `.claude/CLAUDE.md` and replace all `{{PLACEHOLDERS}}`:

```bash
# For a data platform project
cp templates/claude-md/data-platform.md /path/to/your/project/.claude/CLAUDE.md

# For a BI/analytics project
cp templates/claude-md/bi-analytics.md /path/to/your/project/.claude/CLAUDE.md
```

Then search-and-replace:
- `{{PROJECT_NAME}}` -> Your project name
- `{{PLATFORM}}` -> Microsoft Fabric, Databricks, Snowflake, etc.
- `{{GITHUB_ORG}}/{{REPO_NAME}}` -> Your repo
- See the template for all placeholders

### 2. Data Profiling Notebook

See [`templates/notebooks/data-profiling/README.md`](templates/notebooks/data-profiling/README.md) for full instructions.

Quick version:
1. Copy `nb_data_profiling_template.py` to your project's `notebooks/` directory
2. Update `CONFIG` with your file names and join keys
3. Upload to Fabric, run, download `profiling_bundle.json`
4. Share with Claude Code for automated Silver layer design

### 3. Agent Roles for Peer Review

See [`agents/peer-review-orchestrator.md`](agents/peer-review-orchestrator.md) for the full multi-agent review pattern.

Quick version: launch 4 Claude Code agents in parallel, each with a specialist role, reviewing the same document. Consolidate findings using the peer review template.

### 4. Architecture Plan

Start from `templates/architecture/architecture_plan_template.md` and fill in your project details. The template covers all 12 sections of a complete Medallion architecture plan.

## Design Principles

- **Parameterized:** All templates use `{{PLACEHOLDERS}}` — never hardcoded project details
- **Battle-tested:** Every template was extracted from real consulting engagements
- **Security-first:** PII handling, anti-exfiltration, and compliance built into every template
- **Portable outputs:** Profiling produces JSON that can be shared with AI tools for automation
- **Quality gates:** Built-in review checkpoints prevent shipping incomplete work

## Contributing

When you complete a project and discover a new reusable pattern:
1. Extract the pattern, strip project-specific details
2. Add `{{PLACEHOLDERS}}` for customizable parts
3. Add a README explaining how to use it
4. Place it in the appropriate directory
