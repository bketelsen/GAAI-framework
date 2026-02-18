---
name: rules-normalize
description: Convert implicit or scattered project rules and conventions into explicit, governed GAAI rule files. Activate during Bootstrap when project has existing conventions, linters, or architecture docs that need to become explicit governance.
license: MIT
compatibility: Works with any filesystem-based AI coding agent
metadata:
  author: gaai-framework
  version: "1.0"
  category: cross
  track: cross-cutting
  id: SKILL-RULES-NORMALIZE-001
  updated_at: 2026-01-27
inputs:
  - detected_rule_files
  - existing_conventions  (linters, security configs, style guides, CI constraints)
  - project_guidelines
outputs:
  - contexts/rules/**
---

# Rules Normalize

## Purpose / When to Activate

Activate during Bootstrap when the project has existing:
- Linter configurations
- Security policies
- Style guides
- Architecture docs
- CI quality constraints

Converts all implicit conventions into explicit GAAI governance rules.

---

## Process

1. Locate all rule-like files and convention sources
2. Classify by domain: architecture / code quality / security / testing / performance
3. Translate each rule into standard GAAI rule format:
   - Explicit condition
   - Scope of application
   - Enforcement level
4. Store normalized rules under `contexts/rules/`
5. Remove ambiguity and duplication

---

## Quality Checks

- All critical project constraints are explicit
- Rules are machine-checkable
- No important convention remains implicit
- Governance coverage is clear
- No duplication across rule files

---

## Non-Goals

This skill must NOT:
- Create new architectural decisions
- Modify business logic
- Enforce rules during delivery (enforcement is handled by workflows and validation stages)

**No silent assumptions. Every constraint becomes explicit and governed.**
