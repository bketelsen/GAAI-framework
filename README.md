# GAAI — Governed Agentic AI Infrastructure

A `.gaai/` folder you drop into any project. Markdown + YAML + bash. No SDK. No package.

**GAAI turns agentic coding tools into reliable delivery systems.**

Works with Claude Code, OpenCode, Codex CLI, Gemini CLI, Antigravity, Cursor, Windsurf — or any AI coding tool that can read files.

---

## The Problem

You're using Claude Code, OpenCode, Codex CLI, Cursor, or another agentic coding tool. It writes code fast. Sometimes very good code. You ship more than before.

Then something starts breaking down — not the code. The *process*.

- You ask the agent to implement something. It does. But it also changes three things you didn't ask for.
- You start a new session. The agent has no idea what was decided last week. You re-explain. Again.
- The agent asks a clarifying question mid-implementation. You answer. It goes in a different direction than you meant.
- You have a rule: "always use the repository pattern for database access." The agent follows it sometimes.
- Three sessions in, you realize the feature that just shipped contradicts a decision you made two weeks ago.
- You're not sure what the agent is allowed to do on its own versus what it should ask you first.

None of these are bugs in the AI. They are symptoms of using a powerful execution engine without a governance layer.

**An LLM is a V12 engine. Without the right steering system, speed becomes the problem.**

---

## What GAAI Adds

GAAI is the operating layer between you and your AI tools. It answers four questions that AI tools don't answer by themselves:

**1. What is the agent allowed to do right now?**
The backlog is the only authorization mechanism. If a task isn't in the backlog with `status: refined`, the agent doesn't touch it. No implicit scope expansion.

**2. What does the agent know about this project?**
Memory is explicit — never auto-loaded, never polluted with stale context. Agents load exactly what they need: project facts, past decisions, learned conventions.

**3. What counts as "done"?**
Every backlog item has acceptance criteria. QA is a hard gate — PASS or FAIL, no "close enough". The agent iterates until criteria pass, or escalates.

**4. Who decides what?**
You decide what to build (Discovery). The agent decides how to build it (Delivery). Those are separate tracks, with a clear handoff. The agent never improvises product decisions.

---

## What Changes in Practice

Without GAAI, a typical AI coding session looks like:

```
You: implement user authentication
Agent: [writes auth, also refactors your session handling, adds a new middleware,
        changes your error format, asks three questions mid-way]
You: ...ok, but why did you change the error format?
```

With GAAI:

```
You: [Story already in backlog: "User can log in with email+password"
      Acceptance criteria: session created, invalid credentials return 401,
      brute-force protection after 5 attempts]

Agent: [implements exactly that, no more, no less]
       [QA: all 3 criteria — PASS]
       [marks Story done, moves to next]
```

The agent still writes the code. You still review it. But the scope is locked before execution begins, the criteria define what "done" means, and the loop runs autonomously until it passes.

---

## What GAAI Is (Technically)

A single `.gaai/` folder you drop into any project:

```
your-project/
└── .gaai/
    ├── agents/      ← Discovery + Delivery + Bootstrap agent specs
    ├── skills/      ← 28 pure execution units (one thing, explicit output)
    ├── contexts/    ← rules, memory, backlog, artefacts
    ├── workflows/   ← delivery loop, bootstrap, handoffs
    ├── scripts/     ← bash utilities (backlog scheduler, health check)
    └── compat/      ← thin adapters for Claude Code, OpenCode, Codex CLI, Gemini CLI, Antigravity, Cursor, Windsurf
```

**No SDK. No npm package. No pip install. No external services.**
Markdown + YAML + bash. Readable by humans and any AI tool.

---

## 30-Second Install

```bash
git clone https://github.com/your-org/gaai-framework.git
cd gaai-framework && ./install.sh
```

The installer asks which AI tool you use, copies `.gaai/` into your project, and deploys the right adapter.

Or manually: copy `.gaai/` into your project root. Done.

---

## The Model — Dual-Track Delivery

```
You ←→ Discovery Agent     Understand. Define. Write Stories. Acceptance criteria.
              ↓
        active.backlog.yaml     Authorization gate. Only refined Stories proceed.
              ↓
       Delivery Agent →     Plan. Implement. QA. Done.
              ↓
          Working code
```

**Discovery** is a conversation. You talk to the Discovery Agent to clarify what to build — needs, scope, edge cases. Output: a Story with acceptance criteria in the backlog.

**Delivery** is autonomous execution. The Delivery Agent reads the Story and runs until the acceptance criteria pass — no improvisation, no scope drift.

**The backlog is the contract.** Nothing gets built that isn't in it.

---

### Why Two Tracks?

This mirrors **Dual-Track Agile** — a well-established practice used by product engineering teams (Spotify, Intercom, and others) to separate *figuring out what to build* from *building it*. The separation prevents scope drift, reduces rework, and keeps decision-making where it belongs.

For AI agents specifically, the separation matters even more. Research on LLM agents consistently shows that mixing reasoning (what to do?) with execution (how to do it?) in a single context degrades output quality. Discovery and Delivery run in separate context windows by design — each does one thing well.

**If you're new to this:** Discovery is "make sure we know exactly what we're building before we start." Delivery is "build it, exactly that, nothing more." You already know this distinction intuitively — GAAI just enforces it structurally.

**If you're a senior engineer:** GAAI applies Dual-Track separation at the agent level. Stories carry acceptance criteria. The delivery loop is a governed QA gate — PASS or escalate, no "close enough". Memory is explicit and selective, not ambient context. Rules are files you own and version.

---

## Five Rules (Non-Negotiable)

1. Every execution unit must be in the backlog.
2. Every agent action must reference a skill.
3. Memory is explicit — agents select what to load, never auto-loaded.
4. Artefacts document — they do not authorize. Only the backlog authorizes.
5. When in doubt, stop and ask.

---

## Tool Compatibility

| Tool | Adapter |
|------|---------|
| Claude Code | `CLAUDE.md` + `.claude/commands/` (slash commands) |
| OpenCode | `AGENTS.md` |
| Codex CLI | `AGENTS.md` |
| Gemini CLI | `AGENTS.md` |
| Antigravity | `AGENTS.md` |
| Cursor | `.cursor/rules/*.mdc` |
| Windsurf | `AGENTS.md` |
| Any other | Read `.gaai/GAAI.md` directly |

One canonical source (`.gaai/`). Thin adapters per tool. No content duplication.

Claude Code has the deepest integration (slash commands, auto-loaded CLAUDE.md, SKILL.md auto-discovery). All other tools work via `AGENTS.md` or direct file access — full framework capability, manual activation.

---

## Fork & Own

This is not a library you pin a version to. It is a design pattern expressed in files.

Fork or clone. Run `install.sh`. Adapt the rules, memory, and skills to your project. The `.gaai/` folder is yours.

---

## Documentation

- [Quick Start](docs/guides/quick-start.md) — first working Story in 30 minutes
- [What is GAAI?](docs/01-what-is-gaai.md) — the problem in full
- [Core Concepts](docs/02-core-concepts.md) — dual track, backlog, memory, skills, artefacts
- [Vibe Coder Guide](docs/guides/vibe-coder-guide.md) — fast daily workflow
- [Senior Engineer Guide](docs/guides/senior-engineer-guide.md) — governance, rules, CI
- [Skills Index](.gaai/skills/README.skills.md) — all 31 skills
- [Tool Compatibility](docs/reference/tool-compatibility.md) — Claude Code, OpenCode, Codex CLI, Gemini CLI, Antigravity, Cursor, Windsurf

---

MIT — see [LICENSE](LICENSE)
