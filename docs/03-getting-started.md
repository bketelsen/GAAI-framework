# Getting Started

## Prerequisites

- bash 3.2+ (macOS default is fine)
- git
- An AI coding tool: Claude Code, Cursor, or Windsurf

---

## Installation

```bash
# 1. Clone the GAAI framework
git clone https://github.com/gaai-framework/gaai-framework.git /tmp/gaai
cd /tmp/gaai

# 2. Run the installer from your project root
bash install.sh
```

The installer will:
1. Check prerequisites
2. Ask which AI tool you use
3. Copy `.gaai/` into your project
4. Deploy the right tool adapter (CLAUDE.md, .mdc file, or AGENTS.md)
5. Run a health check

That's it. Your project now has a `.gaai/` folder.

---

## First Session

### Existing project? Run Bootstrap first.

The Bootstrap Agent scans your codebase and builds project memory.

**Claude Code:** `/gaai-bootstrap`

**Cursor / Windsurf / Other:** Ask your AI:
> "Read `.gaai/GAAI.md`, then `.gaai/agents/bootstrap.agent.md`, then follow `.gaai/workflows/context-bootstrap.workflow.md`."

Bootstrap will:
1. Scan your codebase
2. Extract architecture decisions
3. Build memory files in `.gaai/contexts/memory/`
4. Normalize existing conventions into rules

When it's done, you'll see: `✅ Bootstrap PASS — context ready.`

---

### New project? Start with Discovery.

No existing codebase to scan. Go straight to Discovery.

Fill in `.gaai/contexts/memory/memory/project/context.md` with your project's basic context.

Then activate Discovery:

**Claude Code:** `/gaai-discover`

**Other tools:** Tell your AI:
> "Read `.gaai/agents/discovery.agent.md`. I want to build [your idea]. Help me create the first Epics and Stories."

---

## Your First Delivery

Once you have Stories in the backlog (status: `refined`), run the Delivery Loop:

**Claude Code:** `/gaai-deliver`

**Other tools:** Tell your AI:
> "Read `.gaai/agents/delivery.agent.md` and `.gaai/workflows/delivery-loop.workflow.md`. Execute the next ready backlog item."

The Delivery Agent will:
1. Pick the highest-priority refined Story
2. Build an execution plan
3. Implement it
4. Run QA
5. Report PASS or FAIL

---

## Check Your Status

At any time:

**Claude Code:** `/gaai-status`

**Other tools:** Ask:
> "Read `.gaai/contexts/backlog/active.backlog.yaml` and give me a summary of what's ready to deliver."

---

## What's Next

- Add more Stories through Discovery
- Customize rules in `.gaai/contexts/rules/`
- Review the skills catalog: `.gaai/skills/README.skills.md`
- Read [Core Concepts](02-core-concepts.md) for deeper understanding

→ [Quick Start](guides/quick-start.md) for a concrete walkthrough
→ [Senior Engineer Guide](guides/senior-engineer-guide.md) for governance customization
