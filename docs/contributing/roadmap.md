# Roadmap

What's planned for GAAI. This is a public signal of direction — not a commitment or timeline.

---

## v2.1.3 — Current Release

**Status:** Complete

- `.gaai/` restructured into `core/` (framework) + `project/` (user data via scaffolding)
- 40 core skills across discovery (6), delivery (11), and cross (23) categories
- License: ELv2 (Elastic License 2.0)
- Tool adapters: Claude Code, Cursor, Windsurf, OpenCode, Codex CLI, Gemini CLI, Antigravity
- CI validation via `health-check.sh`
- Full documentation
- Git subtree support for framework updates
- `backlog-scheduler.sh` with 4 modes: `--next`, `--list`, `--graph`, `--conflicts`
- Sub-agent orchestration design analysis (see [architecture doc](../architecture/sub-agent-orchestration.md))
- `bump-version.sh` — syncs version across all canonical locations in one command
- Daemon scripts documentation (automation section in README)

### Changes since v2.1.1

- 7 niche/duplicate skills pruned from core (47 → 40): i18n-extract, i18n-validate, i18n-glossary-sync, idiomatique-translate, build-skills-index, generate-build-in-public-content, frontend-design
- Stale skill counts fixed across all docs
- README consolidated: "Honest Trade-offs" section, research basis added to 5 ADRs
- `docs/hackernews-post.md` removed (distribution content absorbed into README)

---

## Near Term

**GitHub Copilot adapter**
Compat layer for GitHub Copilot workspace.

---

## Under Consideration

**Sub-agent orchestration for Delivery (v3.0 design target)**
The v3.0 architecture designates the Delivery Agent as orchestrator-only, coordinating a dynamic team of specialized sub-agents (MicroDelivery for simple tasks, core team + specialists for complex Stories). Sub-agents are ephemeral — spawn → execute → handoff-artefact → die. Full design specification: [Sub-Agent Orchestration](../architecture/sub-agent-orchestration.md).

Trigger conditions for v3.0 adoption:
- Claude Code Task agents reach stable API
- Real-world evidence that Stories consistently benefit from phase isolation
- Specialist registry pattern validated against real project patterns

**Experimental skills promotion**
Three current experimental skills (`success-metrics-evaluation`, `security-audit`, `post-mortem-learning`) need real-world usage before promotion to stable. Community feedback welcome via GitHub issues.

---

## What Will NOT Change

By design, GAAI will not become:
- An SDK or code library
- A cloud service or managed platform
- A UI or dashboard
- A framework for a specific language or stack

The file-based, tool-agnostic design is a permanent principle.

---

## Feedback

Report bugs and suggest improvements at [GitHub Issues](https://github.com/Fr-e-d/GAAI-framework/issues).

See [Fork & Own](fork-and-own.md) for how to adapt GAAI for your own project.
