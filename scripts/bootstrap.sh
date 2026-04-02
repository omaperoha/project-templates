#!/usr/bin/env bash
# bootstrap.sh — Create a new project repo from project-templates
#
# Usage:
#   bash scripts/bootstrap.sh <project-name> [project-type]
#
# Arguments:
#   project-name   Name for the new repo and local folder (e.g., My-New-Project)
#   project-type   One of: data-platform, bi-analytics, minimal (default: minimal)
#
# Example:
#   bash scripts/bootstrap.sh Acme-Datalake data-platform

set -euo pipefail

# ── Configuration ────────────────────────────────────────────────────────────
GITHUB_OWNER="omaperoha"
BASE_PATH="/h/Users/Nosotros/Documents/GIT"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="$SCRIPT_DIR/templates"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
VALID_TYPES=("data-platform" "bi-analytics" "minimal")

# ── Helpers ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

info()  { echo -e "${CYAN}[INFO]${NC}  $1"; }
ok()    { echo -e "${GREEN}[OK]${NC}    $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

usage() {
    echo "Usage: bash scripts/bootstrap.sh <project-name> [project-type]"
    echo ""
    echo "Project types:"
    echo "  data-platform  - Data engineering / Fabric / Databricks / Medallion"
    echo "  bi-analytics   - BI / Looker / Power BI / Tableau"
    echo "  minimal        - Bare skeleton with empty CLAUDE.md (default)"
    echo ""
    echo "Example:"
    echo "  bash scripts/bootstrap.sh Acme-Datalake data-platform"
    exit 1
}

# ── Validate arguments ──────────────────────────────────────────────────────
[[ $# -lt 1 ]] && usage

PROJECT_NAME="$1"
PROJECT_TYPE="${2:-minimal}"

# Validate project type
TYPE_VALID=false
for t in "${VALID_TYPES[@]}"; do
    [[ "$PROJECT_TYPE" == "$t" ]] && TYPE_VALID=true
done
$TYPE_VALID || error "Invalid project type '$PROJECT_TYPE'. Must be one of: ${VALID_TYPES[*]}"

# Validate project name (alphanumeric, hyphens, underscores)
[[ "$PROJECT_NAME" =~ ^[a-zA-Z0-9_-]+$ ]] || error "Project name must contain only letters, numbers, hyphens, and underscores."

PROJECT_DIR="$BASE_PATH/$PROJECT_NAME"
REPO_FULL="$GITHUB_OWNER/$PROJECT_NAME"

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║              Project Bootstrap                              ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
info "Project name:  $PROJECT_NAME"
info "Project type:  $PROJECT_TYPE"
info "GitHub repo:   $REPO_FULL (private)"
info "Local path:    $PROJECT_DIR"
echo ""

# ── Pre-flight checks ───────────────────────────────────────────────────────
info "Running pre-flight checks..."

# Check gh CLI (optional — falls back to local-only mode)
GH_AVAILABLE=false
if command -v gh >/dev/null 2>&1; then
    if gh auth status >/dev/null 2>&1; then
        GH_AVAILABLE=true
        ok "gh CLI found and authenticated"
        # Check GitHub repo doesn't exist
        if gh repo view "$REPO_FULL" >/dev/null 2>&1; then
            error "GitHub repo already exists: $REPO_FULL"
        fi
        ok "GitHub repo name available"
    else
        warn "gh CLI found but not authenticated. Run: gh auth login"
        warn "Continuing in LOCAL-ONLY mode (no GitHub repo will be created)"
    fi
else
    warn "GitHub CLI (gh) not installed. Install: https://cli.github.com/ or: winget install --id GitHub.cli"
    warn "Continuing in LOCAL-ONLY mode (no GitHub repo will be created)"
fi

# Check local dir doesn't exist
[[ -d "$PROJECT_DIR" ]] && error "Local directory already exists: $PROJECT_DIR"
ok "Local path available"

# Check templates exist
[[ -f "$TEMPLATES_DIR/gitignore.template" ]] || error "Missing template: $TEMPLATES_DIR/gitignore.template"
[[ -f "$TEMPLATES_DIR/readme.template" ]] || error "Missing template: $TEMPLATES_DIR/readme.template"
ok "Templates found"

echo ""

# ── Create local directory ──────────────────────────────────────────────────
info "Creating local directory..."
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"
ok "Created $PROJECT_DIR"

# ── Initialize git ──────────────────────────────────────────────────────────
info "Initializing git repository..."
git init -b main >/dev/null 2>&1
ok "Git initialized (branch: main)"

# ── Scaffold directory structure ────────────────────────────────────────────
info "Scaffolding directory structure..."

DIRS=(docs notebooks pipelines scripts semantic_model warehouse .claude .claude/skills)
for dir in "${DIRS[@]}"; do
    mkdir -p "$dir"
    # Add .gitkeep to empty dirs (except .claude which will have CLAUDE.md)
    if [[ "$dir" != ".claude" ]]; then
        touch "$dir/.gitkeep"
    fi
done
ok "Created directories: ${DIRS[*]}"

# ── Generate .gitignore ────────────────────────────────────────────────────
info "Generating .gitignore..."
cp "$TEMPLATES_DIR/gitignore.template" .gitignore
ok ".gitignore created"

# ── Generate README.md ──────────────────────────────────────────────────────
info "Generating README.md..."
sed "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" "$TEMPLATES_DIR/readme.template" > README.md
ok "README.md created"

# ── First commit: project skeleton ──────────────────────────────────────────
info "Creating initial commit..."
git add -A
git commit -m "Initial project structure

Scaffolded from project-templates ($PROJECT_TYPE template).
Directories: docs, notebooks, pipelines, scripts, semantic_model, warehouse

Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>" >/dev/null 2>&1
ok "Commit 1/2: project skeleton"

# ── Generate CLAUDE.md ──────────────────────────────────────────────────────
info "Generating .claude/CLAUDE.md ($PROJECT_TYPE template)..."

case "$PROJECT_TYPE" in
    data-platform)
        cp "$REPO_ROOT/templates/claude-md/data-platform.md" .claude/CLAUDE.md
        # Fill in what we know
        sed -i "s|{{PROJECT_NAME}}|$PROJECT_NAME|g" .claude/CLAUDE.md
        sed -i "s|{{GITHUB_ORG}}|$GITHUB_OWNER|g" .claude/CLAUDE.md
        sed -i "s|{{REPO_NAME}}|$PROJECT_NAME|g" .claude/CLAUDE.md
        sed -i "s|{{LOCAL_PATH}}|$PROJECT_DIR|g" .claude/CLAUDE.md
        sed -i "s|{{DEFAULT_BRANCH}}|main|g" .claude/CLAUDE.md
        sed -i "s|{{DATE}}|$(date +%Y-%m-%d)|g" .claude/CLAUDE.md
        ok "CLAUDE.md created from data-platform template"
        warn "Remaining placeholders to fill: {{AGENT_ROLE}}, {{PROJECT_GOAL}}, {{SCOPE_BOUNDARY}}, {{PLATFORM}}, {{DATA_SENSITIVITY_DESCRIPTION}}"
        ;;
    bi-analytics)
        cp "$REPO_ROOT/templates/claude-md/bi-analytics.md" .claude/CLAUDE.md
        sed -i "s|{{PROJECT_NAME}}|$PROJECT_NAME|g" .claude/CLAUDE.md
        sed -i "s|{{GITHUB_ORG}}|$GITHUB_OWNER|g" .claude/CLAUDE.md
        sed -i "s|{{REPO_NAME}}|$PROJECT_NAME|g" .claude/CLAUDE.md
        sed -i "s|{{DATE}}|$(date +%Y-%m-%d)|g" .claude/CLAUDE.md
        ok "CLAUDE.md created from bi-analytics template"
        warn "Remaining placeholders to fill: {{AGENT_ROLE}}, {{BI_PLATFORM}}, {{API_BASE_URL}}, {{CONFIG_FILE}}, {{PROJECT_ID}}, etc."
        ;;
    minimal)
        cat > .claude/CLAUDE.md << 'MINIMAL_EOF'
# {{PROJECT_NAME}} — Claude Code Project Context

> **This file is auto-loaded by Claude Code.** Update it with your project context, rules, and workflow.

## Identity & Role

You are a **Senior Engineer** for this project.

## Project Overview

- **Goal:** TBD
- **Platform:** TBD
- **Repo:** TBD
- **Default branch:** `main`

## Rules

1. Always plan before building.
2. Never push to `main` without explicit approval.
3. Ask clarifying questions — never guess.

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

Use these resources when starting architecture plans, running peer reviews, or needing guidance. Copy templates into this project — do not modify the originals.

## Current Work Status

### Completed
<!-- Update as work progresses -->

### Pending
<!-- Track pending items -->
MINIMAL_EOF
        sed -i "s|{{PROJECT_NAME}}|$PROJECT_NAME|g" .claude/CLAUDE.md
        ok "CLAUDE.md created (minimal template)"
        ;;
esac

# ── Second commit: CLAUDE.md ───────────────────────────────────────────────
git add .claude/CLAUDE.md
git commit -m "Add CLAUDE.md project context ($PROJECT_TYPE template)

Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>" >/dev/null 2>&1
ok "Commit 2/2: CLAUDE.md"

# ── Create GitHub repo and push ────────────────────────────────────────────
if $GH_AVAILABLE; then
    info "Creating GitHub repo: $REPO_FULL (private)..."
    gh repo create "$REPO_FULL" --private --source=. --remote=origin --push >/dev/null 2>&1
    ok "GitHub repo created and pushed"
fi

# ── Summary ─────────────────────────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║              Bootstrap Complete!                            ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
ok "Local:   $PROJECT_DIR"
ok "Type:    $PROJECT_TYPE"

if $GH_AVAILABLE; then
    ok "GitHub:  https://github.com/$REPO_FULL"
    ok "Branch:  main (2 commits pushed)"
    echo ""
    info "Next steps:"
    echo "  1. cd \"$PROJECT_DIR\""
    echo "  2. Open .claude/CLAUDE.md and fill in remaining {{PLACEHOLDERS}}"
    echo "  3. Start working: claude"
else
    warn "GitHub repo was NOT created (gh CLI not available)"
    ok "Branch:  main (2 local commits)"
    echo ""
    info "Next steps:"
    echo "  1. Create the repo manually: https://github.com/new"
    echo "     Name: $PROJECT_NAME | Visibility: Private | Do NOT initialize with README"
    echo "  2. Then run:"
    echo "     cd \"$PROJECT_DIR\""
    echo "     git remote add origin https://github.com/$REPO_FULL.git"
    echo "     git push -u origin main"
    echo "  3. Open .claude/CLAUDE.md and fill in remaining {{PLACEHOLDERS}}"
    echo "  4. Start working: claude"
fi
echo ""
