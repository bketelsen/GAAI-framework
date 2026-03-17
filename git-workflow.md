# GAAI Git Workflow

## Branch Model

```
story/{id}  ──PR──→  staging  ──PR──→  production
   (AI work)        (AI merges here)    (human-only promotion)
```

**Golden rule:** AI agents never touch `production`. All AI work targets `staging`.

## How Staging Gets Updated

There are two paths code lands on `staging`:

### 1. Automated Delivery (via daemon)
The delivery daemon (`delivery-daemon.sh`) polls the backlog for `status: refined` stories and for each one:

1. **Claims the story** — marks it `in_progress` with a commit directly on `staging`, pushes (uses retry-with-rebase to handle concurrent daemons)
2. **Creates an isolated worktree** — `git worktree add ../{id}-workspace story/{id}` branched from `staging`
3. **Sub-agents work in the worktree** — planning, implementation, QA all happen there
4. **Pushes the story branch** and creates a **PR targeting `staging`** (not main/production)
5. **Human reviews and merges** the PR into `staging` on GitHub
6. **Story marked `done`** — committed + pushed to `staging`, worktree removed

### 2. Manual delivery
Same flow but you kick off a single story yourself instead of the daemon doing it.

## How Staging Gets Merged to Production

This is **strictly a human action**:

1. Human creates a new PR: `staging` → `production`
2. GitHub Actions runs validation (health checks, artefact sync)
3. Human reviews and merges
4. Production deploys via CI

A pre-push hook (`.githooks/pre-push`) can be enabled to block accidental pushes to `production` from dev machines:
```bash
git config core.hooksPath .githooks
```

## Syncing Staging from Production/Main (Gap)

The current workflow follows a **strict one-directional flow**:

```
story branches → staging → production
```

There is **no documented process** for syncing changes from production/main back into staging. The following scenarios are unaccounted for:

- **Hotfixes applied directly to production** — if an urgent fix is committed to production, there is no defined mechanism to backmerge it into staging. Staging would diverge from production.
- **Post-merge drift** — after staging is promoted to production, the two branches should be identical. But if production receives any direct changes (hotfixes, manual edits, GitHub UI changes), staging falls behind.
- **Conflict prevention** — without periodic syncs, the next staging → production PR could contain merge conflicts from diverged histories.

### What the rules say

The orchestration rules (`orchestration.rules.md`) and delivery workflow (`delivery-loop.workflow.md`) both state:
- "All AI-driven execution targets the `staging` branch."
- "AI agents MUST NOT push to, merge to, or interact with `production`."
- "Promotion staging → production is a human action via GitHub PR."

None of these documents address the reverse direction.

### Implicit assumption

The architecture assumes production is a **deployment target only**, never a source of truth. All code originates in story branches and flows forward through staging. This works cleanly **as long as no changes are ever made directly on production**. If that invariant is violated, manual intervention would be needed to reconcile the branches.

### Recommended consideration

If hotfixes or direct production changes are ever needed, the team should define a process for one of:
1. **Backmerge** — merge production into staging after any direct production change
2. **Hotfix branch pattern** — hotfixes branch from production, merge to both production AND staging
3. **Reset staging** — after each production promotion, reset staging to match production before new work begins

Currently none of these are implemented or documented.

## Concurrency / Multi-Device Coordination

When multiple daemons run (e.g., on different machines):

- **Backlog locking** — `flock` on `.delivery-locks/.staging.lock` serializes staging writes
- **Story claiming** — after marking `in_progress` and pushing, if the push fails (non-fast-forward), another daemon claimed it first → skip
- **Retry-with-rebase** — all staging pushes use 3 attempts with exponential backoff (2s, 4s, 6s)

## Recommended GitHub Branch Protection Setup

The GAAI framework expects branch protection to be in place but does not configure it automatically. The `coordinate-handoffs` skill explicitly handles the case where "merge rejected (branch protection / checks required)" — so the agents are designed to work with these rules, not around them.

### Production branch

Production should be the most locked-down branch. No one — human or AI — should be able to push directly.

| Setting | Value | Why |
|---|---|---|
| Require pull request before merging | **Yes** | All changes must come via PR from staging |
| Required approvals | **1+** | Human gate for production promotion |
| Dismiss stale approvals on new pushes | **Yes** | Prevents approving then force-pushing different code |
| Require status checks to pass | **No** (by default) | Enable via `--required-checks` with project-specific CI checks (see [Existing CI checks](#existing-ci-checks-available)) |
| Required checks | None by default | Use `--required-checks` flag during setup to add |
| Require branches to be up to date | **Yes** | Prevents merging stale staging snapshots |
| Restrict who can push | **No one** (enforce PR-only) | Reinforces the pre-push hook protection at the GitHub level |
| Allow force pushes | **Never** | Protects production history |
| Allow deletions | **No** | Prevents accidental branch deletion |

### Staging branch

Staging needs to allow the daemon to push status commits (`chore({id}): in_progress`, `chore({id}): done`) directly, while still requiring PRs for actual code changes from story branches.

| Setting | Value | Why |
|---|---|---|
| Require pull request before merging | **Yes, with bypass** | Story branch code comes via PR; daemon status commits need direct push |
| Bypass list | Bot account or service account running the daemon | Allows daemon to push `chore()` status commits directly |
| Required approvals | **0 or 1** | Depending on team preference — 0 enables auto-merge for AI PRs after CI passes, 1 keeps human review mandatory |
| Require status checks to pass | **No** (by default) | Enable via `--required-checks` if desired |
| Required checks | None by default | Use `--required-checks` flag during setup to add |
| Require branches to be up to date | **No** | The retry-with-rebase pattern handles concurrent pushes; requiring up-to-date would block parallel daemon deliveries |
| Allow force pushes | **Never** | Protects staging history |

### Story branches (`story/*`)

Story branches are ephemeral and AI-managed. Light protection is sufficient.

| Setting | Value | Why |
|---|---|---|
| Branch protection | **None required** | These are short-lived feature branches created per-story |
| Naming convention | `story/{id}` | Enforced by the delivery workflow, not GitHub |
| Auto-delete after merge | **Enable in repo settings** | Keeps the branch list clean after PRs merge |

### Auto-merge configuration

The orchestration rules (`orchestration.rules.md`) specify that after creating a PR, the agent should enable auto-merge:

```bash
gh pr merge --auto --squash story/{id}
```

For this to work, the following repo settings are required:
- **Allow auto-merge** must be enabled in repo Settings → General
- **Required status checks** should be configured if you want auto-merge to wait for CI (otherwise PRs merge immediately when approved). Add checks via `--required-checks` during branch protection setup
- **Squash merging** should be allowed (or set as the only allowed merge method for cleaner history)

### Existing CI checks available

| Workflow | Job | Display Name | Use as required check |
|---|---|---|---|
| `validate-structure.yml` | `validate` | Framework Integrity Check | Optional — validates `.gaai/` structure and artefact references. Add via `--required-checks "Framework Integrity Check"` if desired |
| `resolve-contrib-conflicts.yml` | `resolve` | (contrib-specific) | No — only relevant for `contrib/*` branches |

**Note:** Project-specific test suites, linting, or deployment checks should be added as additional required status checks as the project matures.

### Automated setup

All of the above is automated by a single script:

```bash
bash .gaai/core/scripts/branch-protection-setup.sh
```

This will:
1. Create the `staging` branch from `main` if it doesn't exist
2. Apply branch protection to both `main` and `staging` via `gh api`
3. Configure repo settings (auto-merge, auto-delete branches, squash-only)
4. Set local git hooks path if `.githooks/` exists

Use `--dry-run` to preview changes without applying them. Run `--help` for all options.

### Manual setup checklist

If you prefer to configure manually via the GitHub UI:

1. Go to GitHub repo → Settings → Branches → Add branch ruleset (or classic branch protection)
2. Add rule for `production`: require PR, 1+ approval, status checks, no force push
3. Add rule for `staging`: require PR (with bypass for daemon account), status checks, no force push
4. Enable "Allow auto-merge" in Settings → General
5. Enable "Automatically delete head branches" in Settings → General
6. Set allowed merge types to "Allow squash merging" only (optional, for cleaner history)
7. Activate the local pre-push hook: `git config core.hooksPath .githooks`

## Key Files

| Purpose | File |
|---|---|
| Master reference | `.gaai/core/GAAI.md` (lines 86-105) |
| Full delivery workflow | `.gaai/core/workflows/delivery-loop.workflow.md` |
| Daemon script | `.gaai/core/scripts/delivery-daemon.sh` |
| Team branching options | `docs/guides/team-setup-guide.md` |
| CI/governance | `docs/guides/senior-engineer-guide.md` |
| Branch protection setup | `.gaai/core/scripts/branch-protection-setup.sh` |

## TL;DR

- **AI works on story branches**, PRs into `staging`
- **Humans merge PRs** into staging (AI never self-merges)
- **Humans promote** staging → production via a separate PR
- Concurrency is handled by file locks + retry-with-rebase pushes
- The daemon automates the pick-up → deliver → PR cycle, but human review is always the gate
