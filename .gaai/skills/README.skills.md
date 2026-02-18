# GAAI Skills — Index

Skills are **pure execution units**. They perform a single, well-defined operation and produce explicit outputs. They never reason about intent or strategy.

> Agents decide. Skills execute.

---

## Structure

Each skill lives in its own directory with a `SKILL.md` file:

```
skills/
├── discovery/   ← produce artefacts (PRD, Epics, Stories, validation)
├── delivery/    ← orchestrate and execute (planning, implementation, QA)
└── cross/       ← memory, context, governance, analysis — usable by any agent
```

The source of truth for available skills is the directory itself.
Browse each folder to see what skills exist and read their `SKILL.md` for details.

---

## Invocation Rules

1. Skills are **never invoked implicitly** — an agent always selects and invokes explicitly
2. Skills execute in **isolated context windows** — no shared state between skills
3. Skills **never chain** other skills — only agents orchestrate
4. Skills **never access memory** autonomously — context is always provided by the agent
5. Skills **never make product or architectural decisions** — they execute only

---

## Final Rule

> If a skill appears to "think", it is wrongly designed.

---

→ [discovery/](discovery/) — skills that produce artefacts
→ [delivery/](delivery/) — skills that orchestrate and execute
→ [cross/](cross/) — skills for memory, context, governance
→ [Back to GAAI.md](../GAAI.md)
