# Contributing to GAAI

GAAI is an open-core framework licensed under [ELv2](LICENSE). Contributions to the core framework are welcome.

## How It Works

Since v2.0.0, GAAI separates **framework** (`core/`) from **project data** (`project/`):

```
.gaai/
├── core/       ← Framework — shared, contributable
└── project/    ← Your project data — yours, never upstream
```

You contribute to `core/`. Your project-specific skills, agents, rules, and workflows stay in your `project/` directory.

---

## What You Can Contribute

| Accepted | Examples |
|---|---|
| Bug fixes | Broken scripts, incorrect paths, malformed YAML templates |
| Documentation | Typos, unclear wording, broken links in `docs/` or `.gaai/core/**/*.md` |
| Framework skills | New skills in `core/skills/{cross,delivery,discovery}/` that are project-agnostic |
| Framework agents / sub-agents | Improvements to existing agents, new sub-agents |
| Rules improvements | Clarifications or additions to `core/contexts/rules/` |
| Workflow improvements | Fixes or new workflows in `core/workflows/` |
| Script improvements | Fixes or enhancements to `core/scripts/` |
| Compat adapters | New or updated adapters in `core/compat/` for AI tools |

### What We Do NOT Accept

- **Project-specific content** — skills, agents, or rules that only make sense for your project. Those belong in your `project/` directory.
- **Opinionated philosophy changes** — GAAI has a clear design philosophy (agents decide, skills execute, memory is explicit). PRs that fundamentally change this will be closed.
- **Breaking changes without discussion** — open an issue first to discuss the approach.
- **Competing managed service features** — per ELv2 license terms.

---

## Contribution Workflow

### 1. Fork & Branch

```bash
# Fork the repo on GitHub, then:
git clone https://github.com/<your-username>/GAAI-framework.git
cd GAAI-framework
git checkout -b feat/your-feature staging
```

All PRs target the `staging` branch. `production` is protected — only the maintainer merges `staging → production`.

### 2. Make Your Changes

Follow existing conventions:

- **Skills:** one directory per skill under `core/skills/{track}/`, with a `SKILL.md` following the existing format (frontmatter + Purpose + Prerequisites + Procedure + Non-Goals + Validation)
- **Commit messages:** `feat:`, `fix:`, `docs:`, `chore:` prefix. Keep them concise.
- **File naming:** `kebab-case` for directories, `PascalCase.md` or `kebab-case.md` for files (match the existing pattern in each directory).

### 3. Validate

```bash
bash .gaai/core/scripts/health-check.sh --core-dir .gaai/core
```

Health-check must pass. If you added a new skill or agent, also run:
- `build-skills-index` or `build-agents-index` to verify it's discoverable

### 4. Open a PR

- Target branch: `staging`
- Fill in the PR template
- Keep PRs focused — one feature or fix per PR

### 5. Review

The maintainer reviews all PRs. Expect feedback within a few days. PRs that pass review are merged to `staging`, then batched into `production` releases.

---

## Branching Model

```
your-fork/feat/...  →  PR  →  staging  →  (maintainer)  →  production
                                                              ↓
                                                     CI auto-split
                                                              ↓
                                                      framework branch
                                                    (consumed via subtree)
```

---

## Code of Conduct

Be respectful, constructive, and focused on making GAAI better. Low-effort PRs, spam, or hostile behavior will result in a ban.

---

## Questions?

Open a [feedback issue](.github/ISSUE_TEMPLATE/feedback.md) or start a discussion on GitHub.
