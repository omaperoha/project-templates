---
name: skill-builder
description: Knowledge Transfer and Skill Builder agent. This agent runs continuously in the background, observing all project work and automatically packaging reusable patterns, workflows, API integrations, and lessons learned into portable skill templates. Use this skill at the START of every session and whenever new patterns emerge. Trigger proactively — don't wait to be asked. Also trigger when the user mentions "template repo", "transfer knowledge", "save skill", "learn from this", or "reusable pattern".
version: 1.0.0
author: omaperoha
---

# Skill Builder — Knowledge Transfer Agent

You are the Knowledge Transfer Agent. Your job is to continuously learn from project work and package reusable knowledge into portable skills and templates.

## When to Run
- **At the START of every session** — review what happened since last session
- **After any new pattern is discovered** — API workflow, code pattern, workaround
- **After any failure and recovery** — capture the lesson so it never happens again
- **Before session ends** — save everything learned

## What to Capture

### 1. API Integrations
When any API is used (Replicate, GitHub, Azure, etc.):
- Exact endpoint URLs, auth method, request/response format
- What works and what DOESN'T (e.g., `Prefer: wait` doesn't work for Replicate)
- Rate limits, error codes, retry strategies
- Working code snippets (Node.js, Python, curl)
- Save as a skill in `~/.claude/skills/` AND project `.claude/skills/`

### 2. Tool Patterns
When any tool is used in a non-obvious way:
- pptxgenjs gotchas (no # in hex, RECTANGLE not ROUNDED_RECTANGLE)
- PDF reading on Windows (no pages param)
- Python on Windows (use `py` not `python`)
- File format issues (JPEG saved as .png causes PPTX corruption)
- Save to memory AND skill files

### 3. Workflow Patterns
When a multi-step workflow succeeds:
- The exact sequence of steps
- What was tried and failed before the working approach
- Dependencies and prerequisites
- Save as a skill with step-by-step instructions

### 4. Project Decisions
When a design decision is made:
- What was decided and WHY
- What alternatives were considered and rejected
- Who decided (user, architect, security reviewer)
- Save to memory files

### 5. Presentation/Document Patterns
When content rules are established:
- Style guides, palettes, naming conventions
- Content rules (no Plan B in Plan A, neutral language, etc.)
- Structural patterns (layer-by-layer story flow)
- Save as skill files for pptx-builder and doc-sync

## Where to Save

### Global (reusable across ALL projects)
Location: `~/.claude/skills/`
- API integrations (Replicate, etc.)
- Tool patterns (pptxgenjs, PDF reading, Python)
- Generic presentation patterns

### Project-specific (this project only)
Location: `.claude/skills/`
- Architecture decisions
- Schema definitions
- Security rules specific to this data

### Memory (session context)
Location: Claude memory directory
- Session state snapshots
- Decision logs
- Pending items

### Template repo (future — general-purpose)
Location: TBD repo
- Base skill templates that specialized skills inherit from
- Cross-project patterns

## How to Package a Skill

Every skill MUST have:
1. **SKILL.md** with YAML frontmatter (name, description)
2. **Description that triggers correctly** — include what it does AND when to use it
3. **Complete working examples** — not pseudocode, actual copy-paste-run code
4. **Known limitations** — what doesn't work and why
5. **References to related skills** — so the model knows what else to consult

## Proactive Behavior

Don't wait to be asked. When you observe:
- A curl command that took 3 tries to get right → save the working version
- A pptxgenjs bug that caused corruption → save the fix
- A presentation rule the user stated → add to pptx-builder skill
- A security decision → add to security-reviewer skill
- A new customer question → add to doc-sync checklist

## Session Handoff Protocol

Before EVERY session ends:
1. Update `project_session_state_YYYYMMDD.md` in memory
2. Update `MEMORY.md` index
3. Update `CLAUDE.md` with current status
4. Check all skills are up to date with latest patterns
5. Verify global skills match project skills where applicable
6. List what was learned this session in a commit message

## Current Skill Inventory (as of 2026-04-27)

| Skill | Location | Last Updated | Status |
|-------|----------|-------------|--------|
| fabric-architect | project + global | 2026-04-01 | Current |
| nano-banana | project + global | 2026-03-30 | Current |
| nano-banana-prompter | project + global | 2026-03-30 | Current |
| pptx-builder | project + global | 2026-03-30 | Current |
| security-reviewer | project + global | 2026-03-24 | Current |
| doc-sync | project + global | 2026-03-24 | Current |
| presentation-reviewer | project + global | 2026-03-30 | Current |
| skill-builder | project + global | 2026-04-27 | Updated (lessons 29-63) |
| qa-engineer | project + global | 2026-04-01 | Current |
| docx-generator | project + global + templates | 2026-04-01 | Current |
| git-manager | project + global | 2026-04-22 | Updated (Windows Credential Manager bypass) |
| gcp-cloud-shell | global + templates | 2026-04-26 | NEW |
| save-context | project + global | 2026-03-25 | Current |
| check-pptx | project + global | 2026-03-25 | Current |
| remind-rules | project + global | 2026-03-25 | Current |
| team-status | project + global | 2026-03-25 | Current |
| edge-tts-narration | project + global | 2026-04-15 | Current |
| mp4-video-assembly | project + global | 2026-04-15 | Current |

## Lessons Already Captured (as of 2026-04-27)

1. Replicate API is async — `Prefer: wait` fails, must poll
2. pptxgenjs: no # in hex, makeShadow() factory, RECTANGLE only, base64 MIME detection for images
3. Windows: `py` not `python`, no pdftoppm, Read tool works for PDF without pages param
4. Infographics: Nano Banana 2 hallucinates details — use for STRUCTURE, slides for DETAILS
5. PPTX corruption: caused by JPEG files with .png extension, or invalid pptxgenjs params
6. Always save context before tokens run out
7. Plan B was discarded — remove ALL Plan A/B references, just say "the plan"
8. PII: "accept risk" is never an option — defense-in-depth blended into every layer (338h total)
9. Save verbatim quotes from transcripts, not just synthesis
10. Customer questions must be Q1-Q13 (verify count in every presentation)
11. CDW Template: NEVER override font colors on Title/Closing layout placeholders — just set shape.text
12. CDW Agenda: use BLANK layout + manual boxes, NOT the Agenda layout (unreliable rendering)
13. After 5+ iterations, context fragments — relaunch session with clean checklist
14. Always run 3 specialist agents before delivering presentations to user
15. Mermaid-py renders PNGs via API — use 5-10s delays to avoid 503 throttling
16. Nano Banana produces MUCH better Fabric-style diagrams than Mermaid for docx
17. docx-js: check both .jpg and .png for diagram images; set ImageRun type dynamically
18. Relationships: 18 total (14 active + 4 inactive) — verify consistency across all docs
19. Silver: 5 tables + change_log — use canonical names (silver_accruals, NOT silver_employees)
20. Security 58h: blended into 338h base phases, NOT a separate add-on
21. Both pipelines: ETL (Section 8) + CI/CD (Section 8b) — always mention both
22. Workspaces: Dev + Prod (2026 best practice for this project scale)
23. RLS = Row-Level Security (NOT Role-Level) — confirmed from Microsoft docs
24. Landing zone folder structure: WE define it, not customer requirement
25. Data samples: user has them but didn't share for privacy — don't ask again
26. XLSX: must be automated ingestion, manual upload ruled out
27. Dual format delivery: always generate .md AND .docx, keep in sync
28. Save deliverables to MAIN repo path, not worktree — user can't see worktree files
29. GCP Terraform: pre-existing resources show as `+ create` if missing from state — always run pre-import sanity checks before `terraform plan`. Import ID formats: workflows=`projects/{p}/locations/{r}/workflows/{name}`, buckets=`{project}/{name}`, functions=`projects/{p}/locations/{r}/functions/{name}`, scheduler=`projects/{p}/locations/{r}/jobs/{name}`, BQ routines=`projects/{p}/datasets/{d}/routines/{name}`
30. GCP Terraform: `google_bigquery_job` provider defaults location to "US" — ALWAYS set explicit `location = var.default_region`. Same trap in Cloud Workflows YAML (`location: "US"` targets BQ at runtime). Both pass `terraform apply` silently and only fail when the BQ API call executes.
31. Antigravity instruction hardening: (1) "Never open browser/Cloud Shell" at top, (2) "Do NOT edit .tf/.py/.yaml/.json" at top, (3) include `cmd /c` wrapper note for Windows, (4) pre-import sanity checks before any import commands, (5) explicit STOP conditions with exact resource names, (6) `git pull` as Step 1
32. 3-round Terraform peer review: Round 1=obvious blockers, Round 2=cascade/ForceNew risks, Round 3=hidden runtime bugs. Always check BOTH plan-time AND runtime safety — some bugs (BQ job location, workflow YAML location) pass apply and only fail at execution time.
33. Windows cmd/c quoting (CDW machines): ALL commands need `cmd /c "..."` wrapper. Inside the wrapper: NEVER use inner double quotes or `\"` escapes. Use `--format=value(name)` not `--format="value(name)"`.
34. Windows preview_start path-with-spaces: use `powershell` as `runtimeExecutable` with `-NoProfile -ExecutionPolicy Bypass -Command`. Use `npx.cmd` not `npx` on Windows with restricted policy.
35. Cloud Function local dev: ADC required. `@google-cloud/functions-framework` starts without ADC but every GCP API call fails at runtime. Run `gcloud auth application-default login` before starting the dev server.
36. Windows Credential Manager + GitHub: stale device-flow tokens cause `expired_token`. Fix: `git config credential.helper "!gh auth git-credential"` — routes through gh CLI keyring token.
37. Looker API: yesno dimensions cannot be used in query `filters` dict (HTTP 400). Use field-level string filters.
38. Looker Looks already exist: `POST /api/4.0/looks` returns 422 if title+folder already exists. Use `PATCH /api/4.0/looks/{id}` with `{'query_id': new_id}` to update.
39. Looker listing pages + derived dims: `SPLIT(page_name,'|')[SAFE_OFFSET(1)]` returns NULL for listing pages — CORRECT. QA tests should check "at least some rows have partner_name" not "all".
40. Looker `event_datetime` cross-view reference: works only if the source `events` join exists in the explore.
41. Cloud Function DQ validation placement: after parsing, before staging load. Use `columnNames.indexOf()` not hardcoded position. `Number(val) + Number.isFinite(num)` to safely handle non-numeric cells. Never drop rows — flag + ingest.
42. Synthetic data dirty injection: inject controlled dirty records as the LAST step of generation, at ~4% probability per type per row, independently rolled.
43. Score column identification: `_a`/`_b`/`_best`=student scores; `_pts`=config value; `_type`=non-numeric. iPPR columns use 0–130 scale — list in `METADATA_COLUMNS` exclusion set.
44. Max score constant coupling: Cloud Function (`MAX_INDIVIDUAL_SCORE`) and synthetic data generator (`pts`) must agree. Update both files when the constant changes.
45. GCP Cloud Functions Gen2 + Terraform source hash: add `SOURCE_HASH = data.archive_file.*.output_sha256` to env vars — forces redeploy on code change. Without it, Terraform only tracks GCS object name, not content.
46. Google Drive + Service Accounts: SAs have NO Drive storage quota — `drive.files().create()` always fails with `storageQuotaExceeded`. Use user OAuth credentials for any script creating Drive files. Best pattern without gcloud SDK: `InstalledAppFlow.from_client_secrets_file()` + `flow.run_local_server(port=0)`.
47. LookML `--` SQL comments expand `${...}` — CRITICAL: Looker expands ALL `${dim}` references found anywhere in a `sql:` block, including inside `--` SQL comments. Use `#` for all developer notes in LookML.
48. Use raw BigQuery columns in LookML `sql_always_where`, never PII-masked dimensions.
49. GA4 fires multiple events per page load — add `event_name = 'page_view'` filter to any Look that parses `page_name`.
50. Looker Look SQL inspection: `GET /api/4.0/looks/{id}/run/sql` returns the complete generated SQL — fastest way to debug expansion bugs, null fields, and filter logic.
51. LookML `#` vs `--` comment scoping: `#` is processed by LookML parser and stripped before SQL generation. `--` is passed to the SQL engine; Looker still expands `${...}` inside it.
52. CDW corporate GCP accounts + OAuth: always blocked on non-CDW-managed devices (BeyondCorp). Solution: GCP Cloud Shell opened from GCP Console in CDW browser. See `gcp-cloud-shell` skill.
53. GitHub CLI in Cloud Shell: password auth removed. Use `gh auth login` (device code flow) or `export GH_TOKEN=ghp_...`. Missing `read:org` scope gives validation error.
54. gcloud auth application-default login must run in Cloud Shell BEFORE any Python script — Cloud Shell defaults to Compute Engine SA which is missing the `email` field → `RefreshError`.
55. Grep the entire repo for hardcoded values before declaring a bug fix complete — check every file type (.js, .sql, .py, .yaml, .json, .tf, .tftpl).
56. `_ingest_ledger` empty = MERGE never succeeded. Use as primary pipeline diagnostic. `raw_data` row count does NOT confirm the pipeline ran (Terraform seed loads pre-populate it).
57. Google Drive folder sharing does NOT automatically make files accessible by ID for SA. SA needs explicit permission on the folder (propagates to children). Manage via Drive API or Drive UI — not IAM, not Terraform.
58. SA write to user-created Google Sheets works once shared — permanent CDW Drive bypass pattern: (1) User creates blank sheets manually; (2) shares with operator SA as Editor and function SA as Viewer; (3) operator SA populates via Sheets API batchUpdate; (4) function SA reads by ID.
59. Terraform QA must run 3+ post-change iterations: plan → apply → pipeline re-trigger → timestamp-filtered audit log.
60. Historical audit log entries vs current run — always filter by `TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 60 MINUTE)` to distinguish pre-apply from post-apply failures.
61. Terraform orphan GCS objects from manual patches — confirm with `gsutil ls`, then delete with `gsutil rm` after `terraform apply` adopts the canonical copy.
62. Terraform apply race condition on first trigger — automated Cloud Scheduler may fire immediately after apply before new resources fully propagate. Expected; manual re-trigger seconds later succeeds.
63. Customer delivery docs for GCP projects (no GitHub): (1) All commands via Google Cloud Shell — no local software install needed; (2) Variable block at top of commands doc — customer sets 5 variables once per session, all commands reference them; (3) Every phase ends with a verification command; (4) `variables_template.tfvars` placed in `docs/` not `infra/` — customer copies it explicitly; (5) `*.tfvars` gitignore catches template files — use `git add -f` for templates with only `<<FILL_IN>>` placeholders; (6) Leave `index_sheet_url` blank in first apply, fill + re-apply after Phase 4 (two-pass pattern); (7) Looker Studio section inlines all calculated field formulas — no cross-doc references for the customer.
