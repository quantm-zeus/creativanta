---
layer: index
canonical: true
last_updated: 2026-10-30
status: SPECIFIED
---

# Cross-Layer Ownership and Evidence Matrix

This records canonical artifact ownership, not proof of runtime correctness. All 31 feature/spec entries are retained in [Feature Status](../02_features/_STATUS.md). [Implementation Order](IMPLEMENTATION_ORDER.md) owns phased completion; [Build Execution](BUILD_EXECUTION_CONTRACT.md) owns acceptance evidence. Earlier blanket contradiction-free/fully implementation-ready claims are superseded.

| Boundary | Source of truth | Static check | Required implementation evidence |
|---|---|---|---|
| Feature → phase | IMPLEMENTATION_ORDER.md | All 31 entries and Build Index phase projection agree | Every scope/AC assigned and accepted by P8 |
| RPC → permission | rpc_permission_bindings.csv + RBAC | Every inventory RPC bound to existing key/family | Role + object + tier + approval denial/allow tests |
| Request/response | api_behavior_contracts.md + phase .proto | Critical field/message authoring rules exist; JSON examples parse | Exact compiled TS/Go/Dart messages and validation/failure tests |
| DB → tenant | database_schema.md | Tenant tables/junctions have direct RLS; relational tenant FKs; unique index names; topological references | PostgreSQL runtime role/isolation/owner/discovery/grant tests |
| Credit → execution | credit_accounting_contract.md | Durable tables, cost/TTL authority and role sample | Concurrent reserve, cycle reset, restart, duplicate and late result fixtures |
| Finance → proof | financial_computation_contract.md | Tax/FX/source fields and projection components | Hand-calculated F01–F09, immutable evidence and economic dedup |
| Event → worker | queue_retry_design.md | Outbox event identity and durable inbox/effect objects | Process-kill/replay/unknown-effect recovery |
| Screen → domain | SCREEN_IMPLEMENTATION_PROTOCOL.md | Owning layers and binding rule explicit; targeted high-risk screens corrected | Every shipped action reconciled; full screen corpus review by P8 |
| Connector → platform | connector_specs.md | Fail-closed access/evidence/fallback contract | Actual app/account/action approval + endpoint probe |
| Workflow → engine | activepieces_integration.md | Owned baseline and licensed optional adapter boundary | Complete node/recipe ACs, isolation and budget tests |
| Release → production | ci_cd_pipeline.md | Required fail-closed stage semantics | Actual CI, authenticated smoke, restore/rollback, legal/external gates |

Run `python3 tooling/check_docs.py`, optional `--sql` with pinned pglast, and `python3 -m unittest discover -s tooling/tests`. These checks cover selected static invariants and checker regressions; they do not certify every screen/algorithm or execute app/DB/provider behavior. Canonical sources and runtime gates must be reevaluated when their inputs change.

## Review additions — 2026-10-30

Source-linked task/section/screen coverage is now checked by [build_plan](../../tooling/build_plan.py); [backlog](AGENT_BUILD_BACKLOG.md) defines its limits. Inventory locking/reservations and public directory/template extensions require their PostgreSQL and privacy fixtures in addition to the prior boundary checks. A passing source map proves assignment/freshness, not semantic correctness of every screen or compiled RPC.
