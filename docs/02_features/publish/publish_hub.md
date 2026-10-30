---
layer: features
module: M11
canonical: true
domain: publish
status: SPECIFIED
last_updated: 2026-10-30
---

# Feature: Publish Hub (M11)

## Purpose

Content that passes QA (M10) is ready to reach audiences — but publishing across 5+ platforms with different APIs, capabilities, rate limits, and approval policies is operationally complex. Creators need a system that understands **what each platform can do** (capability awareness), schedules intelligently, handles failures gracefully, provides manual fallbacks when APIs are unavailable, and maintains an **immutable evidence trail** of every publish action for compliance and dispute resolution.

M11 exists as the **multi-platform publish orchestrator** — the execution engine that takes QA-approved content and delivers it to connected platforms with full capability transparency, diagnostics, retry logic, and immutable audit logs.

## Scope

### Covers (M11 owns publish execution)
- Content calendar: visual scheduling across platforms
- Publish queue: inspection, reorder, cancel
- Publish modes: native direct, scheduled, draft, export/manual fallback
- Capability-aware publishing: show platform capability BEFORE execution
- Publish Job execution: dispatch, monitor, retry
- Approval workflow: gate publish actions requiring human approval
- Batch publishing: N items across M platforms (Clip Factory batch, etc.)
- Publish logs: immutable evidence records
- Post-publish sync: channel post tracking, engagement snapshot
- Diagnostics and repair: failure explanation, retry, reconnect CTAs
- Manual fallback flow: export package for manual upload when API unavailable
- System-level queue fairness: jitter for hotspot prevention

### Does NOT cover (M11 vs M09 boundary)
- **M09 owns**: derivative management AFTER publish (organizing, tagging, collections, repurpose recommendations, derivative performance tracking)
- M11 **publishes** content → emits `publish.succeeded` → M09 tracks post-publish derivative lifecycle
- M11 syncs channel posts for engagement data but does NOT own derivative-level analytics
- Content creation (M07), packaging/QA (M10), and derivative organizing (M09) are upstream modules

## Actors

| Actor | Role | Primary Actions |
|---|---|---|
| Creator | Editor+ | Schedule publish, manage queue, retry failed, configure manual fallback |
| Manager | Manager+ | Execute immediate publish, cancel queued, approve publish-gated items |
| Approver | by policy | Approve/reject publish approval requests |
| System (Scheduler) | System | Dispatch scheduled jobs, apply jitter, rate-limit per platform |
| System (Sync) | System | Post-publish sync: import channel post, capture engagement snapshot |

## Business Rules

1. **RULE-M11-001**: Every publish action MUST display the platform's capability status BEFORE execution. The capability snapshot includes: publish capability (Native/Read-only/Manual/Unsupported), connector health state, and any active policy notes. User MUST see "This platform supports: [capability summary]" before confirming publish (PRD §23.11 AC, Pack 05 §3, §4.5).
2. **RULE-M11-002**: Publish logs are **immutable execution records**. Every retry creates a new log entry or appends to run history — never overwrites history. A publish state CANNOT be marked `published` without EITHER a success publish log (`result_status = 'success'`) OR an imported proof equivalent (Pack 05 §5.2, PRD §23.11 AC).
3. **RULE-M11-003**: Publish state machine MUST follow canonical transitions. State skipping is forbidden — content cannot jump from `draft` to `published` without passing through `queued → executing`. The `requires_manual_fallback` state is a waiting-for-user state that can complete after valid manual proof (DB schema §8.1, §8.2).
4. **RULE-M11-004**: Manual fallback MUST preserve publish intent in the object graph. Even when publishing via export/manual upload, the system MUST maintain: publish item, publish job (mode=export), publish log (execution_path='manual_upload'), and evidence ref (user-uploaded proof screenshot/URL). Fallback items are first-class citizens — not off-graph workarounds (Pack 05 §4.5, §5.2).
5. **RULE-M11-005**: Batch publishing creates N individual Publish Jobs (1 per clip × 1 per platform), NOT a single group job. Each job has an independent lifecycle: clip 3 failing does NOT stop remaining clips. Rate limits per app/account/action come from the verified connector contract; no platform is assumed unlimited (Pack 05 §5.3).
6. **RULE-M11-006**: System-level publish queue fairness: when >100 jobs/minute target the same platform globally, jitter mode activates — each job delayed 0–30s after its scheduled time (never publish before the approved time). Paid tiers get priority dispatch. No workspace may consume >20% of system-wide publish slots in any 1-minute window (Pack 05 §5.4).
7. **RULE-M11-007**: Post-publish sync MUST import the external post reference (`external_post_id`, `external_post_url`) and capture an initial engagement snapshot. The `channel_post.synced` event MUST be emitted so M12 (Unified Inbox) and M19 (Finance) can link back to the published content (Domain event catalog §6).

## Main Flow

1. **Content enters M11**: from M10 QA-approved content → `publish_items` created
   - `lifecycle_state = 'draft'`
   - User configures: target platform, target account, publish mode, schedule, hashtags, caption
2. **Capability check**: system resolves current capability snapshot for target platform
   - displays capability status to user: Native / Read-only / Manual / Unsupported
   - if Manual/Unsupported → suggest export/manual fallback path
3. **User schedules or triggers publish**:
   - Schedule: `PublishService/Schedule` (Editor+) → `lifecycle_state = 'scheduled'`
   - Immediate: `PublishService/Execute` (Manager+) → `lifecycle_state = 'executing'`
   - Approval gate: if workspace has approval policy → `Approval Request` created
4. **Execution**:
   - Publish Job dispatched → worker executes via platform API
   - `lifecycle_state = 'executing'`
   - On success → `published`, emits `publish.succeeded`
   - On failure → `failed`, emits `publish.failed`, diagnostics logged
   - On partial → `partially_published` (batch scenarios)
5. **Publish log**: immutable record created with result, evidence ref, capability snapshot ref, diagnostics ref
6. **Post-publish sync**: system imports `external_post_id`, captures engagement snapshot
   - emits `channel_post.synced`
7. **Retry/Repair**: if failed → user can retry (creates new attempt), reconnect (if connector issue), or fall back to manual

## Alternate Flows

### A1: Manual Fallback Flow
- Trigger: Platform API unavailable or capability = 'Manual'
- Steps: User clicks "Export for manual upload." System generates export package (video file + caption + hashtags + recommended settings). User uploads manually on platform. User returns and provides proof (screenshot or URL). System creates publish log with `execution_path = 'manual_upload'` and `evidence_ref`.
- Result: Content marked as published with manual proof — fully tracked in the graph

### A2: Batch Publish from Clip Factory
- Trigger: User selects 10 clips from M09 derivative library → "Publish All"
- Steps: 10 individual Publish Jobs created (1 per clip). Rate-limited dispatch: dispatch respects the verified app/account/action quota. Progress bar: "Publishing 5/10 clips..." Each job has independent lifecycle. Failed job 3 does NOT stop job 4-10.
- Result: Partial success is acceptable — user sees summary with per-clip status

### A3: Approval-Gated Publish
- Trigger: Workspace has approval policy for publish actions
- Steps: User triggers publish → Approval Request created → notification sent to approver → approver reviews in approval queue → approves/rejects. Rejection pauses the publish item.
- Result: Content only published after human approval gate clears

## Edge Cases

### EC-M11-001: Published Without Success Log
- Condition: Network issue prevents publish log write after successful API call
- Expected behavior: System uses transactional write: publish log and state update are atomic. If log write fails, state remains `executing` (NOT `published`). Retry mechanism re-attempts both state update and log write. Content is NOT shown as published until evidence exists.
- Reference: RULE-M11-002, Pack 05 §5.2

### EC-M11-002: Hotspot Jitter Delay Exceeds User Expectation
- Condition: 500 workspaces schedule posts for exactly 20:00:00. Jitter delays a user's post by 25 seconds.
- Expected behavior: If delay > 15s, system shows: "Đang tối ưu thời gian đăng để đạt hiệu quả tốt nhất." Paid tiers dispatched first. Post still publishes within ±30s window. User can see estimated dispatch time in queue.
- Reference: RULE-M11-006, Pack 05 §5.4

### EC-M11-003: Connector Revoked Mid-Publish
- Condition: Platform connector token expires/revoked while a publish job is executing
- Expected behavior: Job fails with `error_code = 'auth_revoked'`. Diagnostics: "Connection to [Platform] was lost. [Reconnect] [Export for manual upload]." No retry attempted until connector is re-authenticated. Other queued items for the same connector are paused (not failed).
- Reference: Pack 05 §2.1, §8.1

### EC-M11-004: Capability State Changes Between Schedule and Execute
- Condition: At schedule time, TikTok has Native publish capability. At execution time (2 hours later), TikTok capability degraded to Manual due to API changes.
- Expected behavior: System re-checks capability at execution time. If degraded → `publish.requires_manual_fallback` emitted. Job state = `requires_manual_fallback`. Notification sent: "TikTok publish capability changed since scheduling. [Export for manual upload] [Wait and retry]."
- Reference: RULE-M11-001, Pack 05 §3.2

## State Machine

Object: publish_item | DB column: `publish_items.lifecycle_state`
see [04_contracts/database_schema.md#8.1](../../04_contracts/database_schema.md)

| From | To | Trigger | Condition |
|---|---|---|---|
| — | draft | Publish item created | Content selected + target set |
| draft | queued | User confirms publish | M10 QA passed (or overridden) |
| queued | scheduled | User sets schedule time | Schedule time in future |
| scheduled | ready_to_execute | Schedule time reached | Scheduled time has arrived; any fairness delay is nonnegative |
| ready_to_execute | executing | Worker dispatches | Worker available, capability OK |
| queued | executing | Immediate publish | Manager+ triggers, capability OK |
| executing | published | Platform API success | Publish log with `result_status = 'success'` created |
| executing | partially_published | Batch: some succeed, some fail | At least 1 success + 1 failure |
| executing | failed | Platform API failure | All retries exhausted |
| executing | requires_manual_fallback | Capability degraded or API unavailable | Fallback path offered |
| failed | queued | User retries | Connector healthy |
| requires_manual_fallback | published | User uploads manual proof | Evidence ref provided |
| any (pre-published) | cancelled | User/Manager cancels | Before execution completes |

## Related Contracts

| Topic | File | Section |
|---|---|---|
| DB tables | [04_contracts/database_schema.md](../../04_contracts/database_schema.md) | §8.1 (publish_items), §8.2 (publish_jobs), §8.3 (publish_logs — immutable) |
| API | [04_contracts/api_endpoint_map.md](../../04_contracts/api_endpoint_map.md) | §2.4 (PublishService: CreateItem, Schedule, Execute, Retry, Cancel, ListQueue, GetLogs, GetDiagnostics) |
| Events | [04_contracts/domain_event_catalog.md](../../04_contracts/domain_event_catalog.md) | §6 (publish.queued, publish.scheduled, publish.executing, publish.succeeded, publish.failed, publish.requires_manual_fallback, channel_post.synced) |
| RBAC | [04_contracts/rbac_permission_matrix.md](../../04_contracts/rbac_permission_matrix.md) | §2.5 (publish:schedule — Editor+; publish:execute — Manager+; publish:cancel — Manager+) |
| Pack 05 | Pack 05 — Publish Contract <!-- Legacy ref: creativanta_detail_design_pack_05_connector_capability_publish_inbox_contract_v_3_1.md — superseded by current feature docs + contract layer --> | §4-5 (Publish I/O, logs, batch), §8 (Diagnostics) |
| Connector | Pack 05 — Connector <!-- Legacy ref: creativanta_detail_design_pack_05_connector_capability_publish_inbox_contract_v_3_1.md — superseded by current feature docs + contract layer --> | §2 (Connector lifecycle), §3 (Capability registry) |

## Related Screens

| Platform | Screen | Notes |
|---|---|---|
| Web | Content Calendar | Visual calendar view, drag to schedule, per-platform color coding |
| Web | Publish Queue | Inspectable queue with per-item status, cancel/retry CTAs |
| Web | Publish diagnostics | Per-item failure explanation, repair wizard, reconnect CTAs |
| Web | Manual fallback export | Export package download + proof upload form |
| Mobile | Quick publish + approve + retry | Simplified publish trigger, approval actions |
| Mobile | Diagnostics inspector | Failure details, retry button |

## Acceptance Criteria

1. **Given** a user enters the publish flow for TikTok, **when** the publish confirmation page loads, **then** it MUST show the current TikTok capability status (Native/Manual/Unsupported) and the connector health state — BEFORE the user can confirm publish.

2. **Given** a successful publish via platform API, **when** the system records the result, **then** a publish log MUST exist with `result_status = 'success'`, `external_post_id`, `external_post_url`, and `capability_snapshot_id` — the publish item's `lifecycle_state` MUST be `'published'` ONLY after this log exists.

3. **Given** a publish item in `requires_manual_fallback` state, **when** the user uploads proof (screenshot + external URL), **then** the system MUST create a publish log with `execution_path = 'manual_upload'` and `evidence_ref` — and transition the item to `'published'`.

4. **Given** a batch publish of 10 clips with a test connector configured for 10/hour, **when** execution begins, **then** the system MUST dispatch sequentially respecting rate limits — clip 3 failing MUST NOT stop clips 4-10 — and the user MUST see per-clip status in the progress UI.

5. **Given** content is in `executing` state, **when** the connector token is revoked mid-execution, **then** the job MUST fail with `error_code = 'auth_revoked'`, and other queued items for the same connector MUST be paused (not auto-failed) — diagnostics MUST show "[Reconnect]" CTA.

## Open Questions / Blockers

- [NONE] — No critical blockers specific to M11 in OPEN_BLOCKERS.md.
