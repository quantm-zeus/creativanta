---
layer: index
canonical: true
last_updated: 2026-10-30
---

# Build Execution Contract

## 1. Meaning of ready

| State | Meaning |
|---|---|
| SPECIFIED | Behavior and canonical owners exist; code and runtime tests have not passed |
| CONTRACT_READY | Current slice has compiled transport, validation, permissions, migrations, command semantics and deterministic fixtures |
| IMPLEMENTED | Code exists and required local/CI checks pass |
| ACCEPTED | All owning acceptance paths have passing evidence |
| LAUNCH_APPROVED | Operational, provider access, pricing and legal gates for shipped scope are satisfied |

Historical feature `status: READY` means SPECIFIED. Documentation readiness does not certify demand, legal approval, external access, production security or measured performance.

## 2. Agent work packet

Commit a packet at `build/phase-PN/<slice>/manifest.json` during implementation:

```json
{
  "phase": "P0",
  "slice": "tenant-bootstrap",
  "status": "SPECIFIED",
  "feature_refs": ["docs/02_features/platform/auth.md"],
  "scope_items": [{"source": "docs/02_features/platform/auth.md", "requirement": "AC-2 workspace discovery", "evidence": []}],
  "rpc_contracts": [],
  "migration_files": [],
  "permission_keys": [],
  "event_types": [],
  "screen_routes": [],
  "external_gates": [],
  "checks": [],
  "remaining_scope": [],
  "decisions": []
}
```

`requirement` records an actual source heading/AC number and text. `rpc_contracts` entries contain `{rpc, proto_file, request_type, response_type, permission_key, validation_tests, behavior_tests}`. Each `checks` entry contains `{command, exit_code, evidence_path, checked_at}`. Evidence paths must exist in the implementation checkout or CI artifacts. Empty arrays are permitted only before the corresponding state; this docs repository pre-accepts no implementation.

## 3. Execution sequence

1. Read BUILD_INDEX → OPEN_BLOCKERS → CANONICAL_SOURCES → phase → owning feature → contracts → runtime → screens → quality docs. Apply canonical precedence and recorded product decisions.
2. Enumerate included Scope/Covers bullets, rules, alternate/edge flows and ACs. Assign excluded items to their mandatory later phase in `remaining_scope`; none may disappear from P8 coverage.
3. Complete typed request/response fields, validation, nullable/update semantics, errors, tier/permission/object scope, state preconditions, events, side effects, idempotency and provider uncertainty handling. Follow [API behavior contracts](../04_contracts/api_behavior_contracts.md).
4. Compile Rust/TypeScript/Dart transport and run migration/seed/permission fixtures before wiring screens. Correct contracts in their owning layer and link downstream.
5. Implement UI → API → service → persistence/worker → UI, including failure/repair and audit. Test-only adapters cannot satisfy a live provider gate.
6. Run happy/degraded/missing/broken/audit paths, phase exit fixtures, and isolation/replay/concurrency checks for touched boundaries.
7. Record actual results. Mark ACCEPTED only with passing evidence and no unresolved scope item in the slice. Handoff names remaining scope and external gates.

## 4. Hard gates

| Gate | Required evidence |
|---|---|
| D0 docs | `python3 tooling/check_docs.py` passes; no unresolved canonical contradiction in the slice |
| D1 transport | Compiled `.proto` and TS/Rust/Dart generation; no stale diff; every implemented RPC has a complete packet |
| D2 data | Clean migrations + seed; real PostgreSQL tenant/RLS/FK tests; decimal arithmetic; repeatable import; backup/restore before release |
| D3 money/async | Concurrent holds cannot overspend; duplicate requests/events cannot double debit/create orders/repeat provider effects; restart and late results tested |
| D4 product | Owning ACs, web/mobile states and mode behavior pass; unbuilt actions cannot be presented as usable |
| D5 release | Provider entitlement/model/license verification; margin floor; rollback and failing smoke test; security/accessibility/load; legal gate |

The docs checker validates selected static invariants. D0 does not imply D1–D5. Counts, prose, `echo`, mock screenshots and previous agent summaries cannot replace runtime evidence.

## 5. External gates

Approvals, enterprise licenses, production credentials and legal sign-off cannot be created by editing docs. Record owner, scope, evidence and expiry; develop against deterministic adapters and specified manual/import paths meanwhile. Capabilities start `manual`/`unsupported` until access records and probes justify elevation. Never invent approval or silently enable unverified access.

## 6. Full-scope completion

P8 requires every scope item and AC from all 31 entries in [Implementation Order](IMPLEMENTATION_ORDER.md) to map to accepted packets. Every screen action maps to an implemented RPC or defined local interaction. Financial/provider truth must survive degraded and manual paths. Commercial entitlement and phased availability are independently enforced.

## 7. Source-linked task handoff

Use [Agent Build Backlog](AGENT_BUILD_BACKLOG.md) and its generated requirement/screen maps. Each implementation manifest additionally records `task_id`, `requirement_ids`, `screen_refs`, `source_hashes` and `baseline_commit`. The acceptance task reconciles every unit of the module, including earlier delivery tasks and later consumer integrations. Do not treat a section hash as a passing test; enumerate individual behaviors/actions inside each unit and attach evidence.

D0 includes build_plan validation through check_docs. Source drift, removed requirements, task cycles and premature completion must be resolved before continuing dependent work. A changed canonical source invalidates the affected packet's assumption until its tests/contract are reviewed; unrelated accepted packets remain usable.
