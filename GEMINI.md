# Creativanta — Antigravity Overrides (GEMINI.md)
# Antigravity reads both AGENTS.md (lower priority) and this file (higher priority)
# Rules here override the same rule in AGENTS.md

## Base rules
@AGENTS.md

## Antigravity-specific behavior

### Planning mode (required for complex tasks)
- Use Plan mode before any task affecting >3 files
- Generate an Artifact (task plan) before writing code for new features
- Use Review-driven mode for tasks touching docs/04_contracts/ or DB schema

### Agent Skills
- Project skills: .agent/skills/ (workspace-scope)
- Global skills: ~/.gemini/antigravity/skills/
- See .agent/rules/ for Antigravity-specific project constraints

### Verification
After any implementation task, generate a verification Artifact listing:
- Files changed
- Decisions made
- Any [CONFLICT] or [NEEDS INPUT] flags encountered

## ⚠️ Global GEMINI.md path conflict warning

This file (repo root GEMINI.md) is PROJECT-LEVEL — no conflict.
But ~/.gemini/GEMINI.md (global) is SHARED between Antigravity IDE and Gemini CLI.
Avoid storing project-specific rules in ~/.gemini/GEMINI.md to prevent cross-tool pollution.
Reference: GitHub Issue #16058 in google-gemini/gemini-cli (open as of March 2026).
