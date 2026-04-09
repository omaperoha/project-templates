# GitHub Repo Creation (Windows, no `gh` CLI)

`scripts/bootstrap.sh` prefers `gh` CLI for creating the GitHub repo. If `gh` is not installed (default state on this Windows machine), the bootstrap will fall back to one of the paths below, in order of preference.

## Fallback order

### 1. Classic PAT with `repo` scope (automated, zero clicks)

The script reads a token from `~/.claude/github_pat`. If the file exists and the token is a **classic PAT with `repo` scope**, the script calls `POST /user/repos` directly and then pushes via a temporary token-embedded remote URL (which is wiped immediately after the first push).

**Token storage:**
- File: `~/.claude/github_pat` (aka `C:\Users\nosotros\.claude\github_pat`)
- Format: single line, plain text, just the token (no `Bearer` prefix)
- Permissions: `0600` (owner read/write only) — set with `umask 077` before writing
- **MUST be outside any git repository.** Never commit this file. Never put it inside `project-templates/` — that repo is public, GitHub secret scanning would auto-revoke the token within minutes.

**Important — fine-grained PATs do NOT work for repo creation.** `POST /user/repos` requires classic PAT with `repo` scope, or org-level fine-grained with "Administration: Write" at the account (not repository) level. A fine-grained PAT scoped to specific repositories returns `403 "Resource not accessible by personal access token"` even if it has all repository permissions.

Generate a classic PAT here (pre-filled, scope `repo`, 90-day expiry):
https://github.com/settings/tokens/new?description=project-templates%20bootstrap&scopes=repo

### 2. Manual creation + Git Credential Manager push

If no token is available or the token is fine-grained, the script prints instructions and exits with `status=1`:

1. Go to https://github.com/new
2. Owner: `omaperoha`, Name: `{project-name}`, Private, **uncheck all init options**
3. Click Create
4. Re-run the bootstrap — the second pass will detect the empty remote and push via Git Credential Manager (which is already configured in `~/.gitconfig` as `credential.helperselector = manager`, so it uses stored browser auth and does not prompt).

This path requires **one browser click** but no token management.

### 3. Install `gh` CLI

For long-term use, install `gh` so fallbacks 1 and 2 aren't needed:

```bash
winget install --id GitHub.cli
gh auth login   # browser flow
```

After install, bootstrap uses `gh repo create ... --push` and no PAT is required.

## Folder naming

Bootstrap validates project name with `^[a-zA-Z0-9_-]+$` — **spaces are rejected.** If you have an existing local folder with spaces (e.g. `PBI Health Check SOP`), rename it to hyphens (`PBI-Health-Check-SOP`) **before** running the bootstrap.

On Windows, a folder that is the current shell's `cwd` cannot be `rmdir`'d (directory handle is locked by the process). If you can't rename in-place, create the new folder alongside the old one, work in the new folder, and delete the old empty folder after closing the shell session.

## Why this document exists

The previous bootstrap workflow embedded a classic PAT directly inside the remote URL in `.git/config`, which leaked the token into every clone of the repo. That token is now revoked. The replacement workflow stores the token once, outside any repo, and strips it from remote URLs immediately after the first push. Fine-grained PATs are preferred for day-to-day work but cannot create repos — which is why classic is still needed for the bootstrap step specifically.
