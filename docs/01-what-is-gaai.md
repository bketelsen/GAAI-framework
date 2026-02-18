# What is GAAI?

## The Problem

You've used AI coding tools. You know how this goes.

Things move fast — until they don't.

Prompts grow. Context leaks. Intent blurs.
Decisions get re-made, then contradicted.
Agents "do things" you didn't explicitly decide.
Velocity increases while confidence quietly disappears.
Nothing is obviously broken. Yet the system feels fragile.

The problem isn't the AI. The problem is the lack of structure around it.

---

## What GAAI Is

GAAI is a **governance layer** for AI-assisted software development.

It's a `.gaai/` folder you add to any project. Markdown files, YAML, and bash scripts. No SDK. No npm package. No cloud service. No lock-in.

It solves the problem by making four things explicit:

**1. What is authorized to be built** — the backlog is the only execution authority

**2. Who decides vs who executes** — agents reason, skills execute (never both at once)

**3. What the AI knows** — memory is explicit, agent-selected, never auto-loaded

**4. What "done" looks like** — acceptance criteria are the contract, QA is the gate

---

## What GAAI Is Not

- Not a code library
- Not a UI or dashboard
- Not a cloud service
- Not a prompt template collection
- Not an opinionated framework for a specific language or stack

It's a file-based structure. The intelligence is yours and your AI tool's. GAAI provides the governance rails.

---

## The Core Insight

Most AI development problems are not AI problems. They are **coordination problems**:

- Between what you intended and what the AI understood
- Between Discovery (figuring out what to build) and Delivery (building it)
- Between what was decided yesterday and what the AI knows today
- Between moving fast and knowing what's happening

GAAI is the coordination layer.

---

## How It Works (30 seconds)

```
You have an idea
       ↓
Discovery Agent clarifies it → Epics → Stories → acceptance criteria
       ↓
Backlog is the authorization (if it's not there, it doesn't get built)
       ↓
Delivery Agent implements → QA gate → remediate → PASS
       ↓
Memory captures decisions for future sessions
```

That's it.

---

## Next

→ [Core Concepts](02-core-concepts.md) — understand the building blocks
→ [Quick Start](guides/quick-start.md) — try it in 10 minutes
