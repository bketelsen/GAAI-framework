# Contexts Reference

The `.gaai/contexts/` directory contains everything that constrains and informs agent behavior: rules, memory, backlog, and artefacts.

---

## Structure

```
.gaai/contexts/
├── rules/                 ← what agents may and may not do
├── memory/                ← durable project knowledge
├── backlog/               ← execution authorization queue
├── artefacts/             ← evidence and traceability
└── specialists.registry.yaml  ← domain specialists for Tier 3 delivery
```

Each subdirectory has a `README.{type}.md` that is the source of truth for that area. Read those files — not this one — for authoritative structure, formats, and governance rules.

---

## Rules

**Location:** `.gaai/contexts/rules/`
**Source of truth:** `.gaai/contexts/rules/README.rules.md`

Rules constrain agent behavior. They are loaded explicitly — never automatically. `orchestration.rules.md` is always loaded first.

The framework ships with a baseline set of rules. **Add your own** by creating `contexts/rules/your-name.rules.md` and registering it in `README.rules.md` with a loading priority.

---

## Memory

**Location:** `.gaai/contexts/memory/`
**Source of truth:** `.gaai/contexts/memory/README.memory.md`

Memory is **never auto-loaded**. Agents select what they need using `memory-retrieve`. This prevents context pollution and token waste.

**The golden rule:** Agents retrieve memory. Memory never loads itself.

The memory structure includes project context, decisions log, patterns, summaries, and session working files. For the complete structure and frontmatter format, see `README.memory.md`.

---

## Backlog

**Location:** `.gaai/contexts/backlog/`
**Source of truth:** `.gaai/contexts/backlog/README.backlog.md`

The backlog is the **sole authorization mechanism**. Nothing is executed without a backlog item.

**Item states:**

```
draft → needs-refinement → refined → in-progress → done
                                         ↓
                                      blocked
                                         ↓
                                    (unblocked → in-progress or cancelled)
```

Only `status: refined` items may be picked up by the Delivery Agent.

For backlog item format and full state machine, see `README.backlog.md` and `_template.backlog.yaml`.

---

## Artefacts

**Location:** `.gaai/contexts/artefacts/`
**Source of truth:** `.gaai/contexts/artefacts/README.artefacts.md`

Artefacts document intent and decisions. They are **evidence** — not authorization.

**Artefacts vs authorization:**

| Document | Authorizes execution? |
|---|---|
| Epic artefact | No |
| Story artefact | No |
| Backlog item `status: refined` | **Yes** |

A Story artefact with no backlog item cannot trigger Delivery. A backlog item with no artefact can (though artefacts are strongly recommended).

Templates for each artefact type are in `contexts/artefacts/_template.*.md`.

---

## Specialists Registry

**Location:** `.gaai/contexts/specialists.registry.yaml`

Defines domain-specific sub-agents available for Tier 3 delivery. The Implementation Sub-Agent reads this file, matches trigger keywords from the execution plan, and spawns matching specialists.

**To add a specialist:** append an entry to `specialists.registry.yaml`. No agent or skill files need to change.

---

→ [Agents Reference](agents.md)
→ [Memory Model](../architecture/memory-model.md)
