---
layer: index
canonical: true
last_updated: 2026-03-30
---

# Open Blockers

> This is the **most critical file** after BUILD_INDEX.md. Every AI agent and developer MUST read this before starting implementation work.

---

## DB-C-001: FORCE ROW LEVEL SECURITY missing from table templates

- Layer: DB
- Severity: **CRITICAL**
- Status: OPEN
- Impact: Without `FORCE ROW LEVEL SECURITY`, table owners (including the application role) bypass RLS policies entirely — cross-tenant data leaks possible
- Blocked tasks: ALL new DB table creation, Phase 0 schema bootstrap
- Resolution: Add `ALTER TABLE <t> FORCE ROW LEVEL SECURITY;` immediately after `ALTER TABLE <t> ENABLE ROW LEVEL SECURITY;` for every table. Update `04_contracts/database_schema.md` template.
- Owner: [NEEDS INPUT]

## DB-C-002: ENABLE ROW LEVEL SECURITY is template-only, not verified per-table

- Layer: DB
- Severity: **CRITICAL**
- Status: OPEN
- Impact: Some tables in `04_contracts/database_schema.md` declare RLS template but individual table DDL blocks may not include it — silent security gap
- Blocked tasks: Phase 0 schema bootstrap, security audit
- Resolution: Audit every table DDL in `04_contracts/database_schema.md` and ensure each has both ENABLE + FORCE RLS statements. Add migration test to CI.
- Owner: [NEEDS INPUT]

## DB-H-001: REAL type used for credit/cost fields

- Layer: DB
- Severity: **HIGH**
- Status: OPEN
- Impact: `REAL` (IEEE 754 float32) causes rounding errors in financial calculations — profit reports will show incorrect numbers. Affects: `cost_items.amount`, `ai_credit_costs`, `metering_records` and similar fields
- Blocked tasks: M19 Operating Ledger, billing implementation, any money-related feature
- Resolution: Change ALL money/credit/cost columns from `REAL`/`FLOAT` to `NUMERIC(18,6)` in `04_contracts/database_schema.md`. Run migration for any existing data.
- Owner: [NEEDS INPUT]

## DB-H-003: deleted_at missing from production tables

- Layer: DB
- Severity: **HIGH**
- Status: OPEN
- Impact: Without `deleted_at TIMESTAMPTZ`, hard deletes on production tables (ideas, scripts, assets, offers, orders) destroy audit trail and break proof bundles
- Blocked tasks: Soft delete implementation, compliance (GDPR delete flows)
- Resolution: Add `deleted_at TIMESTAMPTZ` to all production tables listed in PRD §12/§13. Update SeaORM entity generation.
- Owner: [NEEDS INPUT]

## API-C-001: PerformanceCoachService has no endpoint/proto definition

- Layer: API
- Severity: **CRITICAL**
- Status: OPEN
- Impact: Pack 04 §9.14 (Performance Coach) is a defined feature but has zero proto/RPC/endpoint definition in `04_contracts/protobuf_contracts.md` or `04_contracts/api_endpoint_map.md` — cannot be implemented
- Blocked tasks: M07 Performance Coach feature, Phase 3 AI Production completion
- Resolution: Define `PerformanceCoachService` in protobuf contracts with RPCs: `GetPerformanceInsights`, `GetVideoScorecard`, `GetImprovementPlan`, `ListBenchmarks`. Add to API endpoint map.
- Owner: [NEEDS INPUT]

## API-H-001: VoiceCloneService missing, event namespace incorrect

- Layer: API
- Severity: **HIGH**
- Status: OPEN
- Impact: Voice cloning (Pack 04 §9.11, ElevenLabs Pro feature) has no service definition. Related events in `04_contracts/domain_event_catalog.md` use inconsistent namespace (some use CamelCase, some use dot.notation)
- Blocked tasks: Voice clone feature implementation
- Resolution: Define `VoiceCloneService` proto. Reconcile event naming between Pack 03 CamelCase convention and A4 dot.notation convention (choose one).
- Owner: [NEEDS INPUT]

## API-H-002: SoundStudioService missing

- Layer: API
- Severity: **HIGH**
- Status: OPEN
- Impact: Sound Studio (Pack 04 §9.11 — music/SFX generation via Stable Audio + MusicGen + Librosa) has no proto/endpoint definition
- Blocked tasks: Sound generation feature implementation
- Resolution: Define `SoundStudioService` in protobuf contracts with RPCs: `GenerateMusic`, `GenerateSFX`, `AnalyzeBeat`, `ListSoundLibrary`.
- Owner: [NEEDS INPUT]

## API-M-001: M17/M18/M20/M21 lack detailed RPC tables

- Layer: API
- Severity: **HIGH**
- Status: OPEN
- Impact: `04_contracts/api_endpoint_map.md` has high-level service outlines for these modules but lacks per-endpoint detail (request/response shapes, auth requirements, rate limits)
- Blocked tasks: Implementation of Live Commerce, Seeding CRM, Workflow Studio, Recipe Center APIs
- Resolution: Expand RPC tables for `LiveCommerceService`, `SeedingService`, `WorkflowService`, `RecipeService` with full endpoint specifications.
- Owner: [NEEDS INPUT]

## PRD-H-001: Acceptance criteria not in Given/When/Then format

- Layer: PRD
- Severity: **HIGH**
- Status: OPEN
- Impact: PRD §23 module ACs are prose-based, not structured. QA team cannot directly derive test cases — each team member interprets differently
- Blocked tasks: Automated acceptance test generation, QA pack creation
- Resolution: Convert all PRD §23.1–§23.23 acceptance criteria to Given/When/Then format in `06_quality_ops/qa_acceptance_packs.md`. PRD remains as-is (product contract level).
- Owner: [NEEDS INPUT]

## PRD-H-002: No per-module edge cases documented

- Layer: PRD
- Severity: **HIGH**
- Status: OPEN
- Impact: Edge cases (concurrent edits, network failures during live, partial publish, stale cache reads) are not documented per module — bugs will surface late
- Blocked tasks: Comprehensive QA coverage, security edge case testing
- Resolution: Add edge case sections to each `02_features/` document during feature doc creation (Phase 3).
- Owner: [NEEDS INPUT]

## EVT-H-001: Event naming convention inconsistency

- Layer: System
- Severity: **HIGH**
- Status: OPEN
- Impact: Pack 03 uses CamelCase event names, `impl_a4_domain_event_catalog.md` uses dot.notation (e.g., `content.script.created` vs `ScriptCreated`). Consumer code may not match producer events.
- Blocked tasks: Event bus implementation, workflow triggers based on events
- Resolution: Choose one convention (recommend dot.notation as canonical) and reconcile across all documents. Add mapping table if both must coexist.
- Owner: [NEEDS INPUT]

## SCR-M-001: Screen specs in flat docs/screens/ not mapped to docs/03_screens/

- Layer: Screen
- Severity: **MEDIUM**
- Status: OPEN
- Impact: 231 screen spec files exist in `docs/screens/` but the canonical structure expects `docs/03_screens/`. Navigation from `02_features/` docs will reference wrong paths.
- Blocked tasks: Cross-linking between feature docs and screen docs
- Resolution: Decide on migration strategy (move files or create symlinks). Update all cross-references.
- Owner: [NEEDS INPUT]

---

## Resolved Blockers

> Move entries here when fixed. Record: date, PR/commit, verified by.

(None yet)
