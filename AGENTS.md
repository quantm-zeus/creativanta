# Creativanta — Shared Agent Rules
# Cross-tool: Google Antigravity (v1.20.3+), Cursor, Claude Code (via @import in CLAUDE.md)
# Last updated: 2026-03-30

## Mandatory reading order

Before implementing, generating code, or modifying any file, read:

1. docs/00_index/BUILD_INDEX.md — system map, 23 module registry, dependency graph
2. docs/00_index/OPEN_BLOCKERS.md — known bugs/gaps, do NOT silently work around these
3. docs/00_index/CANONICAL_SOURCES.md — which file is source of truth for each topic

## Reading order for a specific feature

1. docs/00_index/BUILD_INDEX.md — find the module, check build phase
2. docs/02_features/<domain>/<feature>.md — business logic + flow + AC
3. docs/04_contracts/ — exact field names, event names, permission keys
4. docs/05_system/ — runtime behavior (async / queue / AI)
5. docs/03_screens/<platform>/<screen>.md — UI detail, only when needed
6. docs/06_quality_ops/ — security, perf, migration constraints

## Hard rules — NEVER violate

1. NEVER read docs/03_screens/ before the corresponding docs/02_features/ doc
2. NEVER invent field names — check docs/04_contracts/database_schema.md
3. NEVER invent event names — check docs/04_contracts/domain_event_catalog.md
4. NEVER work around a CRITICAL blocker in docs/00_index/OPEN_BLOCKERS.md silently
5. NEVER treat docs/90_archive/ as canonical source — read-only history
6. NEVER duplicate content between layers — use cross-links only
7. NEVER use REAL or FLOAT for money/credit fields — see DB-H-001 in OPEN_BLOCKERS.md
8. NEVER skip RBAC checks — every action needs docs/04_contracts/rbac_permission_matrix.md
9. WHEN PRD and design pack conflict — PRD §23 wins. Write [CONFLICT] note, ask human
10. NEVER modify archived files in docs/90_archive/

## Source conflict resolution

    PRD §23 > design packs > impl docs > screens
    docs/04_contracts/ > docs/02_features/ (for schema/API specifics)
    If conflict: write [CONFLICT: A says X, B says Y — using X per rule above]

## Repo structure

    docs/
    ├── 00_index/       ← READ FIRST: map, rules, blockers
    ├── 01_business/    ← Business context, rules, glossary
    ├── 02_features/    ← Feature behavior + AC (center of gravity)
    ├── 03_screens/     ← UI detail — read AFTER 02_features/
    ├── 04_contracts/   ← DB / API / event / permission contracts
    ├── 05_system/      ← Runtime / queue / AI behavior
    ├── 06_quality_ops/ ← QA / security / perf / migration
    ├── 90_archive/     ← History — NOT canonical
    └── _templates/     ← Standard templates for new docs

## Common task reading paths

| Task | Files to read, in order |
|---|---|
| Implement auth | 02_features/platform/auth.md → 04_contracts/api_endpoint_map.md#identity → 04_contracts/rbac_permission_matrix.md |
| Build order lifecycle | 02_features/commerce/product_hub.md → 04_contracts/database_schema.md#orders → 04_contracts/domain_event_catalog.md#commerce → 05_system/queue_retry_design.md |
| AI video generation | 02_features/production/ai_video_studio.md → 05_system/ai_provider_guide.md → 04_contracts/database_schema.md#generation_jobs |
| Add platform connector | 04_contracts/connector_specs.md → 05_system/sequence_diagrams.md → 06_quality_ops/qa_acceptance_packs.md |
| Debug publish failure | 02_features/publish/publish_hub.md → 04_contracts/api_endpoint_map.md#publish → 05_system/sequence_diagrams.md |
| Build workflow | 02_features/automation/workflow_studio.md → 05_system/runtime_workflow.md → 05_system/queue_retry_design.md |
| Implement billing | 01_business/pricing_and_credits.md → 02_features/platform/reporting_admin_billing.md → 04_contracts/database_schema.md#billing |
| New DB table with RLS | 04_contracts/database_schema.md → 00_index/OPEN_BLOCKERS.md#DB-C-001 → 06_quality_ops/security_threat_model.md |
| Write QA test | 00_index/ACCEPTANCE_TESTS.md → 02_features/<domain>/<feature>.md → 06_quality_ops/qa_acceptance_packs.md |
| Dev environment setup | 06_quality_ops/docker_dev_environment.md → 05_system/tech_stack_adr.md → 04_contracts/database_schema.md |
