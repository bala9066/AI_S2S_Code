# CI/CD Workflow Validation Report

**File:** `.github/workflows/hardware_pipeline_ci.yml`
**Validated:** 2026-03-26 23:19:24 — offline YAML syntax check
> **Note:** Your GitHub token IS used — for the git push and PR creation (next step).
> This step validates YAML syntax, job structure, and trigger keys locally.
> No GitHub API call needed here. The token is applied when committing and opening the PR.

---

## Overall: ✅ PASSED

- Errors  : 0
- Warnings: 0
- Passes  : 10

## ✅ Passed Checks

- YAML syntax — valid, parses without error
- Top-level key `name` — present
- Top-level key `on` — present
- Top-level key `jobs` — present
- Job `build-qt-app`: `runs-on` = `ubuntu-latest`
- Job `build-qt-app`: 5 step(s) defined
- Job `static-analysis`: `runs-on` = `ubuntu-latest`
- Job `static-analysis`: 5 step(s) defined
- Job `quality-gate`: `runs-on` = `ubuntu-latest`
- Job `quality-gate`: 1 step(s) defined

## actionlint

_actionlint not installed — skipped._  
Install with: `go install github.com/rhysd/actionlint/cmd/actionlint@latest`

## Jobs Summary

| Job | runs-on | Steps |
|-----|---------|-------|
| `build-qt-app` | `ubuntu-latest` | 5 |
| `static-analysis` | `ubuntu-latest` | 5 |
| `quality-gate` | `ubuntu-latest` | 1 |

## How to Push and Activate

Since Git is not configured in `.env`, the workflow file has been
written to disk but not committed. To activate CI/CD:

```bat
cd <your-project-output-dir>
git init
git add .github/workflows/hardware_pipeline_ci.yml
git commit -m "[AI] Hardware Pipeline: add CI/CD workflow"
git remote add origin https://github.com/<owner>/<repo>.git
git push -u origin main
```

Once pushed, GitHub Actions runs automatically on every commit.

To enable automated commits from this tool, add to `.env`:

```
GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxx
GITHUB_REPO=owner/repo-name
GIT_ENABLED=true
```