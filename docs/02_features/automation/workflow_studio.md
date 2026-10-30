---
layer: features
module: M20
canonical: true
domain: automation
status: SPECIFIED
last_updated: 2026-10-29
blockers: []  # API-M-001 resolved 2026-04-02 — WorkflowService §2.8.1 (13 RPCs)
---

# Feature: Workflow Studio (M20)

## Purpose

Content operations involve repetitive multi-step processes: "when a new order arrives → create follow-up task → send thank-you DM → add to seeding list if VIP," or "when content reaches 10K views → create proof snapshot → notify manager." Without structured automation, operators perform these sequences manually across modules, with no audit trail and no error handling.

M20 exists as the **visual workflow automation engine** — allowing operators to build, test, and run event-driven workflows that connect modules (M01–M23) with capability-aware execution, approval gates, structured error handling, and mandatory audit trails. Every workflow action that touches a canonical object MUST pass capability and permission checks before execution.

## Scope

### Covers (M20 owns workflow orchestration)
- Visual workflow builder: trigger → conditions → actions → approval gates → terminal nodes
- Workflow lifecycle: DRAFT → ACTIVE → PAUSED → ERROR → ARCHIVED
- Workflow run lifecycle: queued → running → waiting_approval / waiting_external_condition → succeeded / partially_succeeded / failed / cancelled / requires_manual_intervention
- Trigger types: event-based, schedule-based, manual, webhook-triggered
- Node types: trigger, condition, transform, action, approval, wait, fallback, diagnostics, handoff, terminal
- Capability-aware execution: check platform capabilities BEFORE action execution
- Approval gates: configurable approval requirements before destructive/sensitive actions
- Dry run support: simulate workflow execution without side effects
- Dead-letter handling: failed runs with repair paths
- Audit trail: mandatory logging of every side effect
- Runtime diagnostics: user-facing explanations for every failure

### Does NOT cover (M20 boundaries)
- **M21 owns**: recipe marketplace, pre-built templates (M21 installs recipes → M20 runs them)
- **M22 owns**: capability data (M20 queries, M22 provides capability snapshots)
- Module business logic: M20 orchestrates, modules own their domain rules
- Complex AI agent flows: M21 agent runtime handles multi-step AI planning

## Actors

| Actor | Role | Primary Actions |
|---|---|---|
| Workflow Builder | Editor+ | Create/edit workflows, define triggers/conditions/actions, test with dry run |
| Manager | Manager+ | Activate/pause workflows, configure approval gates, review failed runs |
| Approver | Manager+ | Approve/reject approval gate requests within workflow runs |
| System (Runtime) | System | Execute workflow runs, evaluate conditions, dispatch actions, handle retries |
| System (Diagnostics) | System | Generate user-facing explanations for failures, emit diagnostics events |

## Business Rules

1. **RULE-M20-001**: Workflow lifecycle state machine: `draft → active → paused → error → archived`. Only `active` workflows can be triggered. `error` state entered when workflow has persistent runtime failures (≥3 consecutive failures) — requires operator intervention. `archived` is terminal (Pack 03 §4, PRD §23.20 AC).
2. **RULE-M20-002 (CRITICAL)**: **Capability check MANDATORY before every action.** Before executing any workflow action that touches an external platform (publish, sync, DM, etc.), the runtime MUST query M22 for current platform capability status. If capability is `unsupported` or `degraded`, the action MUST NOT execute silently — it MUST take the fallback path (if defined) or halt with a user-facing explanation (Pack 03 §5.2, PRD §23.20 AC).
3. **RULE-M20-003**: **Failures MUST have user-facing explanations.** Every workflow run that enters `failed` or `requires_manual_intervention` state MUST produce a diagnostics record containing: failure type, affected node/action, user-facing explanation (in user's language), operator explanation, recommended next step, and fallback if available (Pack 03 §8).
4. **RULE-M20-004**: Approval gates are configurable per workflow. Actions defined in Pack 03 §6.1 requiring approval: external publish, price/offer activation, destructive archive/retire, reconciliation override, payout-affecting actions, force-complete/cancel. Approval requests have `expires_at` — expired approvals auto-deny and emit diagnostic (Pack 03 §6).
5. **RULE-M20-005**: Every workflow run action that produces side effects MUST be logged in the action log audit trail. Logged fields: actor (system/user), action, affected objects, old/new state summary, reason, timestamp, correlation_id. Runs without side effects (dry runs, condition-only) still log execution path (Pack 03 §10).
6. **RULE-M20-006**: Dead-letter handling: when a workflow run fails after all retries, it enters the dead-letter queue. Dead-letter items MUST retain: original context, failure summary, retry history, suggested repair path, canonical object refs. Operators can: retry single, retry batch, repair and retry, or purge with reason (Pack 03 §7).
7. **RULE-M20-007**: Dry run mode: operator can simulate workflow execution without triggering actual side effects. Dry run shows: which nodes would execute, which conditions would match, which actions would fire, which approval gates would trigger, estimated execution time. Dry run produces a preview report but NO events, NO mutations, NO external calls (PRD §23.20 AC).

## Main Flow

1. **Workflow creation**: Operator builds workflow visually
   - Select trigger: event (domain event type), schedule (cron), manual, webhook
   - Define conditions: if/else nodes evaluating object properties
   - Define actions: module actions (publish, create task, send DM, update status, etc.)
   - Configure approval gates for sensitive actions
   - Define fallback paths for failure scenarios
   - `workflow.created` event, `status = 'draft'`
2. **Testing with dry run**: Operator tests workflow
   - Trigger dry run with sample data
   - System simulates execution path, shows preview report
   - No side effects produced
3. **Activation**: Manager activates workflow
   - Capability checks evaluated: all required capabilities available?
   - `status = 'active'`, `workflow.activated` event emitted
   - Workflow registered with trigger listener
4. **Trigger fires**: Event/schedule/manual triggers workflow run
   - New run persisted with `status = 'queued'`
   - Worker picks up the run → `workflow_run.started` event emitted and run moves to `running`
   - Trigger context captured (event data, schedule context, manual params)
5. **Runtime execution**: Nodes execute sequentially
   - Condition nodes evaluate → route to matching path
   - **Before each action node**: capability check (M22), permission check (RBAC)
   - Action executes → side effect logged → `workflow_run_steps` updated → next node
   - If approval gate: workflow run enters `waiting_approval` state → `workflow_run.approval_required` event emitted
   - If wait node depends on external condition: run enters `waiting_external_condition`
   - Approved / condition satisfied → continue in `running`. Rejected/expired → fallback path or fail
6. **Completion or failure**: Run terminates
   - Success without unresolved actions: `status = 'succeeded'` + `workflow_run.completed`
   - Success with unresolved compensations/fallback outcomes: `status = 'partially_succeeded'` + `workflow_run.partially_completed`
   - Failure: diagnostics record created, `workflow_run.failed` event
   - If manual intervention needed: `status = 'requires_manual_intervention'` + `workflow_run.manual_intervention_required`

## Alternate Flows

### A1: Platform Degraded During Execution
- Trigger: M22 capability check returns `degraded` during action execution
- Steps: Runtime checks fallback node → if fallback defined: execute fallback path + log "Primary action skipped: [Platform] capability degraded — using fallback." If no fallback: run enters `failed` with user-facing explanation: "This workflow couldn't complete because [Platform] is currently experiencing issues. [Retry later] [View status]."
- Result: No silent failures; operator informed with context and next steps

### A2: Approval Gate Expired
- Trigger: Approval request not responded within `expires_at`
- Steps: Auto-deny with reason "Approval timed out" → fallback path if defined → diagnostics record created → run continues on reject path, moves to `failed`, or enters `requires_manual_intervention`
- Result: Workflow doesn't hang indefinitely on unanswered approvals

### A3: Workflow Version Update
- Trigger: Operator edits an active workflow
- Steps: Active workflow creates a new version → previously running runs complete on old version → new triggers use new version → version history maintained
- Result: No in-flight disruption; version lineage traceable

## Edge Cases

### EC-M20-001: Cascading Workflow Trigger
- Condition: Workflow A emits event that triggers Workflow B, which emits event triggering Workflow C
- Expected behavior: System allows cascading up to configurable depth (default: 5). If depth exceeded: last workflow in chain enters `failed` with: "Workflow cascade depth limit (5) reached — potential infinite loop detected." All runs in cascade share `correlation_id` for tracing. Admin can increase depth limit per workspace.
- Reference: RULE-M20-005

### EC-M20-002: Action Fails After Partial Side Effects
- Condition: Multi-action node completes action A but fails on action B
- Expected behavior: Run enters `partially_succeeded` if fallback or compensating action leaves the graph in a safe but incomplete state; otherwise it enters `failed`. Diagnostics show: "Completed: [Action A] ✓, Failed: [Action B] ✗ — [reason]." Partial side effects are logged in `workflow_run_steps`. Operator can choose: retry action B (idempotent), rollback action A (if compensating defined), or move the run to `requires_manual_intervention`.
- Reference: RULE-M20-003, RULE-M20-006

### EC-M20-003: No Triggers Match for Active Workflow
- Condition: Workflow is active but trigger event type never fires (e.g., listening for event from disconnected platform)
- Expected behavior: System tracks "last triggered" timestamp. After configurable period (default: 30 days) with no triggers: surface notification: "Workflow [X] has been active for 30 days with no triggers — review trigger configuration." Does NOT auto-pause — operator decides.
- Reference: RULE-M20-001

## State Machine

### Workflow Lifecycle

Object: workflow | DB column: `workflows.status`

| From | To | Trigger | Condition |
|---|---|---|---|
| — | draft | Workflow created | Basic definition provided |
| draft | active | Manager activates | Trigger + at least 1 action defined |
| active | paused | Manager pauses | Temporary suspension |
| paused | active | Manager resumes | Conditions still valid |
| active | error | Persistent runtime failures | ≥3 consecutive run failures |
| error | active | Operator fixes + reactivates | Root cause addressed |
| any (non-archived) | archived | Manager archives | Terminal — workflows can't be unarchived (clone to reuse) |

### Workflow Run Lifecycle

Object: workflow_run | DB column: `workflow_runs.status`

| From | To | Trigger | Condition |
|---|---|---|---|
| — | queued | Trigger fires | Workflow active, trigger matches |
| queued | running | Runtime picks up run | Worker available |
| running | waiting_approval | Approval gate reached | Approval node in path |
| waiting_approval | running | Approval granted | Approver approves |
| waiting_approval | failed | Approval denied/expired | Rejected or timed out with no safe fallback |
| running | waiting_external_condition | Wait node reached | External signal / timeout awaited |
| waiting_external_condition | running | External condition satisfied | Resume token/event received |
| running | succeeded | All nodes succeed | Terminal node reached with no unresolved actions |
| running | partially_succeeded | Run completes with safe unresolved actions | Fallback path finished with follow-up needed |
| running | failed | Node fails with no recovery path | Diagnostics record created |
| running | requires_manual_intervention | Runtime cannot auto-resolve safely | Human action required |
| running | cancelled | Operator cancels run | Cancellation confirmed |
| failed | queued | Operator retries | Manual retry from dead-letter |
| requires_manual_intervention | queued | Operator repairs and retries | Repair data captured |

## Related Contracts

| Topic | File | Section |
|---|---|---|
| DB tables | [04_contracts/database_schema.md](../../04_contracts/database_schema.md) | §12 (workflows, workflow_runs, workflow_run_steps) |
| API | [04_contracts/api_endpoint_map.md](../../04_contracts/api_endpoint_map.md) | §2.8 (Workflow — ~12 RPCs: CRUD, Activate, Run, Inspect) |
| Events | [04_contracts/domain_event_catalog.md](../../04_contracts/domain_event_catalog.md) | §11 (`workflow.created`, `workflow.activated`, `workflow_run.started`, `workflow_run.completed`, `workflow_run.partially_completed`, `workflow_run.failed`, `workflow_run.approval_required`, `workflow_run.manual_intervention_required`) |
| RBAC | [04_contracts/rbac_permission_matrix.md](../../04_contracts/rbac_permission_matrix.md) | §2.9 (workflow — Editor+ for creation, Manager+ for activation) |
| Pack 03 | Pack 03 — Workflow Runtime Contract <!-- Legacy ref: creativanta_detail_design_pack_03_event_workflow_agent_runtime_contract_v_3_1.md — superseded by current feature docs + contract layer --> | §4 (Runtime), §5 (Agent), §6 (Approval), §7 (Retry/Dead-Letter), §8 (Diagnostics), §10 (Audit) |
| Capability | [02_features/platform/capability_matrix.md](../platform/capability_matrix.md) | M22 provides capability data for RULE-M20-002 |

## Related Screens

| Platform | Screen | Notes |
|---|---|---|
| Web | Workflow builder | Visual canvas: drag-drop triggers, conditions, actions, approval gates, fallback paths |
| Web | Workflow list | All workflows with lifecycle state, last triggered, run count, error count |
| Web | Workflow run inspector | Per-run execution path visualization, node results, side effects, diagnostics |
| Web | Dead-letter queue | Failed runs with retry/repair/purge actions |
| Web | Dry run preview | Simulated execution path, no side effects, preview report |
| Mobile | Workflow monitoring | Active workflow status, recent run results, error alerts |
| Mobile | Approval inbox | Pending approval requests with context, approve/reject actions |

## Acceptance Criteria

1. **Given** a workflow action targets TikTok publish, **when** M22 returns TikTok capability as `'degraded'`, **then** the workflow runtime MUST NOT execute the publish action — it MUST follow the fallback path (if defined) or halt with user-facing explanation: "TikTok is currently experiencing issues. [View platform status]."

2. **Given** a workflow run fails at step 4 of 7, **when** the failure is recorded, **then** a diagnostics record MUST exist containing: failure type, affected node, user-facing explanation (in user's language), operator explanation, recommended next step — the run MUST enter dead-letter queue with full context.

3. **Given** a workflow with an approval gate configured, **when** the run reaches the approval node, **then** the run MUST enter `'waiting_approval'` state, the approver MUST be notified, and if the approval expires without response: the run MUST auto-deny and follow the reject/fallback path.

4. **Given** an operator triggers a dry run, **when** the simulation completes, **then** the system MUST show which nodes would execute and which conditions would match — NO side effects MUST occur (no events emitted, no external calls made, no database mutations).

5. **Given** a workflow run completes with 3 action nodes producing side effects, **when** the run is inspected, **then** each side effect MUST appear in the action log with: actor, action, affected objects, old/new state, timestamp, correlation_id — the audit trail MUST be complete and navigable.

## Open Questions / Blockers

> ✅ **RESOLVED: API-M-001** (2026-04-02; renamed 2026-04-19) — `WorkflowService` now fully defined in `api_endpoint_map.md` §2.8.1 with 13 RPCs: Create, Get, List, Update, Activate, Deactivate, Run, GetRunDetail, GetRunLogs, ListRuns, Clone, Export, Import. Each RPC has Method, Auth, Rate Limit, Description.
> ✅ **RESOLVED: API-M-002** (2026-04-02) — JSON request/response examples added in `api_examples.md` A.14 (WorkflowService/Create) and A.15 (WorkflowService/Run).
