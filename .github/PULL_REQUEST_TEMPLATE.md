# Pull Request

## Type of change

- [ ] Bug fix (broken behavior in an existing file)
- [ ] Documentation fix (typo, unclear explanation, broken link)
- [ ] New framework skill
- [ ] Framework improvement (agent, rule, workflow, script, compat adapter)
- [ ] Other (describe below)

## What does this PR do?

<!-- Brief description: what was the problem or gap, and what does this PR add/fix? -->

## Files changed

<!-- List the files modified/added and why. -->

## Checklist

- [ ] PR targets the `staging` branch
- [ ] Changes are in `core/` only (not project-specific data)
- [ ] `bash .gaai/core/scripts/health-check.sh --core-dir .gaai/core` passes
- [ ] Commit messages follow convention (`feat:`, `fix:`, `docs:`, `chore:`)
- [ ] New skills include a complete `SKILL.md` (frontmatter + Purpose + Procedure + Non-Goals)
- [ ] No project-specific paths or data leaked into framework files

## Testing

<!-- How was this tested? Which scenarios were validated? -->

---

> See [CONTRIBUTING.md](../CONTRIBUTING.md) for contribution guidelines and what is accepted upstream.
