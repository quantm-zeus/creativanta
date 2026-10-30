# Creativanta — Claude Code

## Shared rules
@AGENTS.md

## Claude Code-specific rules

### Tech stack (follow exactly — see tech_stack_adr.md for rationale)
- Go backend: net/http + ConnectRPC, pgx/v5 + sqlc, Goose SQL migrations; see ADR-015
- Web frontend: SvelteKit 2 + Svelte 5 Runes ($state/$derived/$effect, NOT stores)
- Mobile: Flutter 3.41 + Riverpod 2.x + go_router + grpc-dart
- DB: PostgreSQL 17 with RLS; always use NUMERIC(18,6) for money/credits, never REAL

### Before finishing any task
- [ ] Field names verified against docs/04_contracts/database_schema.md
- [ ] Event names verified against docs/04_contracts/domain_event_catalog.md
- [ ] RBAC requirements checked in docs/04_contracts/rbac_permission_matrix.md
- [ ] No CRITICAL blockers from docs/00_index/OPEN_BLOCKERS.md silently ignored
- [ ] New DB tables have ENABLE + FORCE ROW LEVEL SECURITY (see DB-C-001)
- [ ] Money/credit fields use NUMERIC(18,6), not REAL/FLOAT (see DB-H-001)

### Modular rules (auto-loaded from .claude/rules/)
See .claude/rules/ for scoped rules:
- docs-reading.md: docs reading order and constraints
- security.md: RLS, RBAC, data isolation rules
- code-quality.md: Go, Svelte, Flutter code standards
