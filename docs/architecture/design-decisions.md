# Design Decisions

Why GAAI is structured the way it is. Each decision is an Architecture Decision Record (ADR).

---

## ADR-001: File-Based, Not SDK-Based

**Decision:** GAAI is Markdown + YAML + bash scripts. No code library, no npm package, no SDK.

**Reasoning:**
- Zero-friction installation: `cp -r .gaai/ <project>`
- No dependency management, no version conflicts, no security surface
- Works with any AI tool that can read files (Claude Code, Cursor, Windsurf, any future tool)
- Users own the files completely — fork and modify without waiting for upstream changes
- Transparent: every rule, every constraint, every workflow is readable in plain text

**Trade-off accepted:** No programmatic enforcement. The framework relies on agents following the files. A badly configured AI tool can ignore them. Mitigation: the `health-check.sh` CI gate validates structure integrity.

---

## ADR-002: The Backlog as Sole Authorization Mechanism

**Decision:** The Delivery Agent may only act on backlog items. Nothing outside the backlog is executed.

**Reasoning:**
- Prevents "do things you didn't explicitly decide" — the most common AI coding failure mode
- Makes authorization auditable: you can always trace why something was built
- Forces Discovery to happen before Delivery — Discovery creates the backlog items
- Gives teams a single source of truth for what is authorized

**Research basis:**

- **PARC** — Orimo et al. (2025). *Autonomous Self-Reflective Coding Agent.* Hierarchical multi-agent with self-assessment and self-feedback enables long-horizon autonomous execution — but only when scope is explicitly bounded. [arXiv:2512.03549](https://arxiv.org/abs/2512.03549)

- **Agile backlog governance** — Atlassian. *Epics, Stories, Themes.* Product owner authorizes scope, development team executes. Epic → Story → Task with acceptance criteria as execution contract. GAAI hardens this for AI: "if it's not in the backlog, it must not be executed." [atlassian.com](https://www.atlassian.com/agile/project-management/epics-stories-themes)

- **Ralph Wiggum loop** — ghuntley.com. Studied as contrast: autonomous agent loop (prompt → code → test → fix → repeat) with no governance, no memory, no scope boundaries. Demonstrates what happens when agents decide their own scope. [ghuntley.com/ralph](https://ghuntley.com/ralph)

**Trade-off accepted:** Overhead for trivial tasks (a one-line fix requires a backlog item). Mitigation: backlog items can be minimal (one-liner YAML with basic acceptance criteria).

---

## ADR-003: Explicit Memory, Never Auto-Loaded

**Decision:** Memory files exist. Agents select what they need. Nothing auto-loads.

**Reasoning:**
- Auto-loading all memory into every context window wastes tokens and introduces noise
- Context pollution causes drift: the agent contradicts earlier decisions because old and new are both present
- Explicit selection makes agent behavior reproducible: same context in → same reasoning out
- Auditable: you can see exactly what the agent knew when it made a decision

**Research basis:**

- **Anthropic** — Applied AI team (2025). *Effective Context Engineering for AI Agents.* Context engineering = designing the smallest high-signal token set. Progressive loading outperforms dumping everything. The "architect vs. construction crew" separation. [anthropic.com](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)

- **Manus** — Yichao 'Peak' Ji (2025). *Context Engineering Lessons from Building Manus.* KV-cache optimization (cached tokens 10x cheaper), append-only contexts, file system as unlimited extended memory. Production validation that selective loading beats full-context loading. [manus.im](https://manus.im/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus)

- **LangChain** — (2025). *Context Engineering for Agents.* Four strategies: Write / Select / Compress / Isolate context. "Context management is the #1 job of engineers building AI agents." [blog.langchain.com](https://blog.langchain.com/context-engineering-for-agents)

- **The New Stack** — *Memory for AI Agents: A New Paradigm of Context Engineering.* Maps 3 memory systems (working, short-term, long-term) to agent architecture — aligns with GAAI's 5-category memory model. [thenewstack.io](https://thenewstack.io/memory-for-ai-agents-a-new-paradigm-of-context-engineering/)

**Trade-off accepted:** Agents must invoke `memory-retrieve` explicitly. This adds a step but removes unpredictability.

---

## ADR-004: Agents Reason, Skills Execute — Never Both

**Decision:** The agent-skills separation is strict. Agents decide what to do. Skills do it. A skill that makes decisions is wrongly designed.

**Reasoning:**
- Predictability: given a skill with defined inputs, the output is deterministic
- Isolation: skills run in isolated context windows — no state bleeds between them
- Testability: skills can be validated independently of the agent that invokes them
- Composability: an agent can assemble different skill sequences for different situations

**Research basis:**

- **SWE-agent** — Yang et al. (Princeton, 2024). *Agent-Computer Interfaces Enable Automated Software Engineering.* Custom Agent-Computer Interfaces dramatically outperform raw LLM prompting for code tasks. The interface design matters more than the model. NeurIPS 2024. [arXiv:2405.15793](https://arxiv.org/abs/2405.15793)

- **MetaGPT** — Hong, Zhuge, Chen et al. (2023). *Meta Programming for Multi-Agent Collaborative Framework.* Role-separated multi-agent with SOPs reduces errors vs. naive LLM chaining. Skills as formalized Standard Operating Procedures. NeurIPS. [arXiv:2308.00352](https://arxiv.org/abs/2308.00352)

- **12-Factor Agent** — Dex Horthy, humanlayer (2025). *12 Principles for Production-Ready LLM-Powered Apps.* Tool modularity, prompt ownership, state unification. Skills never chain = direct application of the tool modularity factor. [github.com/humanlayer/12-factor-agents](https://github.com/humanlayer/12-factor-agents)

- **Anthropic Agent Skills** — Anthropic (2025). Skills as modular capabilities with SKILL.md format. Lazy loading. Tool-based invocation. Open standard for agent skill discovery. [github.com/anthropics/skills](https://github.com/anthropics/skills)

**Trade-off accepted:** More files, more explicit invocation. The verbosity is intentional — it makes what's happening observable.

---

## ADR-005: Fork & Own Distribution Model

**Decision:** GAAI is a GitHub template repo. Users fork and adapt. No community skill contributions. Community limited to bug reports and doc fixes.

**Reasoning:**
- A community skill marketplace creates governance risk: untrusted skills get ingested into production workflows
- User projects have wildly different conventions and domains — shared skills would be too generic to be useful
- Fork & Own means the framework serves the project, not the community
- ELv2 license: users can do anything with their fork except offer it as a competing hosted service

**Trade-off accepted:** No ecosystem effect. No skill sharing between projects. This is acceptable for v1.0.

---

## ADR-006: Dual Track (Discovery vs Delivery)

**Decision:** Discovery and Delivery are separate tracks with a formal handoff gate. Planning and execution never share a context window.

**Reasoning:**
- The most common AI failure mode: building the wrong thing fast
- Discovery is human-facing and produces artefacts that document decisions
- Delivery is autonomous and executes only validated decisions
- The separation forces the right question first: "is this the right thing to build?" before "how do we build it?"
- Mixing planning and execution in a single LLM context degrades output quality and introduces cascading errors

**Research basis:**

*Cognitive separation — reasoning and acting are distinct modes:*

- **ReAct** — Yao et al. (2022). *Synergizing Reasoning and Acting in Language Models.* Reasoning and acting are more effective when interleaved but cognitively separated — not fused in a single stream. [arXiv:2210.03629](https://arxiv.org/abs/2210.03629)

- **MetaGPT** — Hong, Zhuge, Chen et al. (2023). *Meta Programming for Multi-Agent Collaborative Framework.* Role-separated multi-agent with SOPs outperforms naive chaining. "Assembly line paradigm" with structured workflows. NeurIPS. [arXiv:2308.00352](https://arxiv.org/abs/2308.00352)

- **FoA** — Giusti, Werner, Taiello et al. (2025). *Federation of Agents: Semantics-Aware Communication Fabric.* Dynamic capability-driven task decomposition. Semantic matching of tasks to agent capabilities. [arXiv:2509.20175](https://arxiv.org/abs/2509.20175)

*Structural separation — planning and execution in isolated tracks:*

- **GoalAct** — Chen et al. (2025). *Enhancing LLM-Based Agents via Global Planning and Hierarchical Execution.* NCIIP 2025 Best Paper. Demonstrates that separating global planning from hierarchical execution achieves +12.22% success rate on LegalAgentBench. [arXiv:2504.16563](https://arxiv.org/abs/2504.16563)

- **Plan-then-Execute (P-t-E)** — Del Rosario et al. (2025). *Architecting Resilient LLM Agents: A Guide to Secure Plan-then-Execute Implementations.* Shows that separating the Planner from the Executor provides control-flow integrity, reduces prompt injection risk, and improves predictability over reactive (single-context) approaches like ReAct. [arXiv:2509.08646](https://arxiv.org/abs/2509.08646)

- **ACE** — Zhang et al. (2025). *Agentic Context Engineering: Evolving Contexts for Self-Improving Language Models.* ICLR 2026. Demonstrates that context collapse and brevity bias degrade LLM agent performance when context management is not deliberate and structured. Explicit context engineering yields +10.6% on agent benchmarks. [arXiv:2510.04618](https://arxiv.org/abs/2510.04618)

**Trade-off accepted:** Discovery adds time before any code is written. This is the point — it prevents rework.

---

## ADR-007: YAML Backlog, Not Markdown Per Item

**Decision:** The backlog is a single YAML file (`active.backlog.yaml`), not one Markdown file per item.

**Reasoning:**
- YAML is machine-readable — `backlog-scheduler.sh` parses it natively
- A single file is easier to diff, review, and merge
- One file per backlog item creates 50+ files for an active project — maintenance overhead with no benefit
- Status transitions are visible in a single file view

**Trade-off accepted:** Large backlogs in a single file. Mitigation: done items are archived monthly (`done/YYYY-MM.done.yaml`), keeping the active file small.

---

## ADR-008: Directory Index Files Named README.{type}.md

**Decision:** Index files inside `.gaai/` subdirectories are named `README.agents.md`, `README.skills.md`, etc. — not `README.md`.

**Reasoning:**
- `README.md` is auto-rendered by GitHub only at the repo root level, not in subdirectories
- `README.agents.md` makes the file type explicit — it's the agents readme, not a generic readme
- Consistent with the `{name}.{type}.md` naming convention throughout the framework

**Trade-off accepted:** GitHub won't auto-render these files as directory descriptions. Acceptable — this is a developer-facing framework.

---

## ADR-009: SKILL.md Directory Structure (agentskills.io Spec)

**Decision:** Skills live in `{skill-name}/SKILL.md` directories, not flat files.

**Reasoning:**
- agentskills.io spec requires this structure for tool auto-discovery
- AI tools (Claude Code, Cursor, VS Code extensions) scan for `SKILL.md` files to auto-discover available skills
- The directory enables optional `references/` and `assets/` subdirectories per skill
- Flat files like `generate-stories.skill.md` would not be discovered by any tool

**Research basis:**

- **Anthropic Agent Skills** — Anthropic (2025). SKILL.md format as open standard for agent skill discovery. Lazy loading prevents context pollution. Tool-based invocation ensures skills are modular and composable. [github.com/anthropics/skills](https://github.com/anthropics/skills)

- **RAG-MCP** — (2025). *Indexed tool discovery outperforms all-tools-in-prompt.* 43% success rate with indexed retrieval vs. 13.6% with all tools loaded — validates lazy loading over eager loading. [arXiv:2505.03275](https://arxiv.org/abs/2505.03275)

**Trade-off accepted:** More directories. Consistent and spec-compliant.

---

## ADR-010: English Only

**Decision:** All framework files are in English. No localization.

**Reasoning:**
- GAAI is a developer tool. The global developer community works in English.
- Localization would double the maintenance surface for v1.0
- User projects can write memory and artefact content in any language — the framework scaffolding stays in English

**Trade-off accepted:** Non-English native users must read framework files in English. Acceptable for v1.0.

---

→ [Memory Model](memory-model.md)
→ [Agent-Skills Spec](agent-skills-spec.md)
