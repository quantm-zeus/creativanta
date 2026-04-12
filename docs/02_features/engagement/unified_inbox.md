---
layer: features
module: M12
canonical: true
domain: engagement
status: READY
last_updated: 2026-03-30
---

# Feature: Unified Inbox & Engagement Center (M12)

## Purpose

Creator commerce generates interactions across 5+ platforms — comments, DMs, inquiries, sponsor messages, sample requests — each with different semantics, intent signals, and follow-up needs. Without a unified operating inbox, threads get lost, SLAs are missed, and high-value opportunities (sponsor inquiries, purchase intent) drown in noise.

M12 exists as the **semantic operating inbox** — it ingests all interactions into canonical threads with classified intent, assigned ownership, SLA tracking, and one-tap conversion to downstream actions (ideas, offers, seeding, CRM entries). Every thread is an operating object, not just a message container.

## Scope

### Covers (M12 owns engagement operating layer)
- Thread ingestion: comments, DMs, inquiries, sponsor inquiries, sample requests
- Thread state machine: NEW → TRIAGED → ACTIVE → {WAITING_ON_USER, WAITING_ON_TEAM, SNOOZED, STALE} → {CONVERTED_TO_TASK, RESOLVED} → ARCHIVED (see RULE-M12-003 for full 10-state enum)
- AI intent classification: purchase_interest, question, support_issue, objection, sponsor_interest, sample_request, moderation_risk, unknown
- AI summaries and suggested replies
- Suggested commerce actions (pin offer, create coupon, route to seeding)
- Thread assignment and ownership
- SLA/follow-up state tracking with breach notifications
- Thread conversions: → Idea (M05), → Commerce/Offer (M14), → CRM/Seeding (M18), → Follow-up Task
- Sponsor inquiry routing (to Brand Collaboration mode / S16)
- Sample request routing (to Seeding CRM / M18)
- Contact/Entity registry (Person/Entity canonical objects)
- Reply-As identity indicator for multi-account workspaces
- Moderation capability awareness (native vs recommendation-only vs unsupported)
- Ingestion throttle for viral surge protection (100/500/10K thresholds)
- Auto-reply loop detection (bot-to-bot circuit breaker)
- Ghost message handling (platform-side deletion detection)

### Does NOT cover (M12 boundaries)
- **M11 owns**: publish execution, channel post sync (M12 consumes `channel_post.synced` events)
- **M14 owns**: offer lifecycle, coupon creation (M12 triggers conversion → M14 executes)
- **M18 owns**: sample request lifecycle after routing (M12 routes → M18 manages)
- **S16 owns**: brand deal pipeline, media kit (M12 detects sponsor intent → S16 manages)
- Message platform APIs: M12 ingests via connector layer, does NOT own connector lifecycle (M22 owns)

## Actors

| Actor | Role | Primary Actions |
|---|---|---|
| Operator | Editor+ | Triage threads, classify intent, reply, assign, set follow-up, convert thread |
| Manager | Manager+ | Assign ownership, merge entities, bulk triage, configure SLA policies |
| AI System | System | Intent classification, suggested replies, suggested actions, thread summarization |
| Ingestion Worker | System | Ingest messages from connected platforms, apply throttle rules |
| Notification | System | SLA approach/breach alerts, new high-priority thread alerts |

## Business Rules

1. **RULE-M12-001**: Every thread MUST have `owner_user_id`, `intent`, `status`, and `next_action` populated. A thread CANNOT exist without these mandatory fields. When ingested, system auto-sets `intent = 'unknown'` and `next_action` based on heuristics; human triage refines (PRD §13.8, §23.12 AC).
2. **RULE-M12-002**: Sponsor inquiries and sample requests are **ingested as messages** into threads, but when classified, they create canonical thread-linked business records (stored as `threads` with `thread_type = 'sponsor_inquiry'` or `thread_type = 'sample_request'`). Routing to M18/S16 owners MUST NOT destroy inbox provenance — the original thread relationship is preserved (Pack 05 §6.4, DB schema §10 Sponsor Inquiry Mapping note).
3. **RULE-M12-003**: Thread status machine MUST follow canonical transitions. Status = `{new, triaged, active, waiting_on_user, waiting_on_team, snoozed, stale, converted_to_task, resolved, archived}`. `snoozed` = user-initiated pause with timer (returns to `active` on expiry); `stale` = no activity for configurable threshold (ghost message detection). No status skipping — a `new` thread cannot jump to `resolved` without passing through `triaged` or `active` (DB schema §9.2).
4. **RULE-M12-004**: SLA tracking is mandatory when configured. When `sla_due_at` is set, system MUST emit `thread.sla_approaching` (at configurable threshold, default 30 min before) and `thread.sla_breached` (at due time). SLA breach feeds M01 Daily Brief as urgent card (Domain events §7).
5. **RULE-M12-005**: Thread conversions MUST create downstream objects linked back to the source thread. Conversion types: → Idea (M05: `idea_sources` entry), → Offer/Commerce action (M14), → Seeding/Sample request (M18), → Follow-up Task (`follow_up_tasks.source_thread_id`). The thread's `related_object_refs` MUST be updated to include the created object (PRD §25, §23.12 AC).
6. **RULE-M12-006**: Reply-As identity MUST be visible in compose box. When workspace has multiple Connected Accounts, the compose box MUST display a color-coded badge + avatar + account name. Users CANNOT send a reply without identity tag visible. Identity auto-updates when switching between threads from different accounts (Pack 05 §7.4).
7. **RULE-M12-007**: Ingestion throttle protects system during viral surges. Thresholds: <100 msg/min = normal (real-time AI); 100-500 msg/min = throttled (batch AI every 5 min); >500 msg/min = circuit breaker (raw ingest only, AI paused). Recovery: auto-resume after <100/min for 10 continuous minutes. Skipped messages are stored; user can trigger manual batch analysis (costs AI credits) (Pack 05 §6.5).
8. **RULE-M12-008**: Auto-reply loop detection: ≥3 consecutive system-only replies → pause auto-reply for that thread. ≥5 auto-replies in 5 min → immediate circuit breaker. Reply similarity >80% between consecutive auto-replies → immediate stop. Max 10 auto-replies per thread per hour (hard cap). Paused thread requires manual re-enable; second trigger = permanent disable (Pack 05 §7.6).

## Main Flow

1. **Message ingestion**: Platform connectors deliver messages (comments, DMs, inquiries) to ingestion worker
   - Worker creates/updates `Thread` with entity reference if known
   - Message appended to thread: `messages.subtype`, `author_direction`, timestamps
   - `thread.created` or `message.received` event emitted
2. **AI intent classification**: System classifies thread intent
   - Intent options: question, purchase_interest, support_issue, objection, sponsor_interest, sample_request, moderation_risk, unknown
   - Intent written to `threads.intent`, `thread.intent_classified` event emitted
   - Confidence score included in event payload for downstream consumers (M20 triggers)
3. **Suggested actions generated**:
   - AI suggests reply text (SuggestionService/GetReply)
   - AI suggests business actions: pin offer, create coupon, route to seeding, convert to idea (SuggestionService/GetActions)
4. **Operator triage**:
   - Operator reviews thread → sets priority, confirms/overrides intent, assigns owner, sets next_action
   - `ThreadService/Triage` (Editor+) → status transitions to `triaged` or `active`
5. **Reply / Action**:
   - Operator replies (ThreadService/Reply, Contributor+) via native or manual path
   - Reply-As identity visible in compose box
   - Or: Operator converts thread → downstream object created
6. **Resolution**:
   - Operator resolves thread (ThreadService/Resolve, Editor+) → `thread.resolved` event
   - Or: thread enters `waiting_on_user` / `waiting_on_team` with follow-up tracking

## Alternate Flows

### A1: Sponsor Inquiry Routing
- Trigger: AI classifies `intent = 'sponsor_interest'` or `thread_type = 'sponsor_inquiry'`
- Steps: Thread flagged with sponsor intent → `sponsor_inquiry.detected` event → notification to Brand Collaboration mode operators → operator can convert to Brand Deal (S16) while preserving thread provenance
- Result: Sponsor inquiry managed in S16 Brand Deal pipeline; thread remains inspectable in inbox

### A2: Sample Request Routing
- Trigger: AI classifies `intent = 'sample_request'` or incoming message matches sample request patterns
- Steps: Thread flagged → routed to Seeding CRM (M18) owner → `sample_request.created` event → M18 manages lifecycle
- Result: Sample request tracked in M18; thread preserved in inbox with `related_object_refs` linking to sample request

### A3: Thread-to-Idea Conversion
- Trigger: Operator identifies content opportunity from comment/thread
- Steps: Operator clicks "Convert to Idea" → M05 `IdeaService/Create` called with `source_ref = {type: 'thread', id: thread_id}` → idea created → thread's `related_object_refs` updated → thread can optionally transition to `converted_to_task`
- Result: Idea traceable back to engagement source

### A4: Ghost Message Handling
- Trigger: Platform API returns 404/403/410 when attempting to reply to a thread
- Steps: 404 → show "Content deleted by user" + disable compose. 403 → show "Post restricted by platform" + disable. 410 → show "Permanently removed" + archive thread. 5xx/timeout → show "Connection issue" + allow retry (transient error, compose stays enabled). Thread status → `stale` on permanent errors.
- Result: User-facing explanation follows WHAT → WHY → NEXT formula; stale threads visible but non-actionable

## Edge Cases

### EC-M12-001: Viral Surge Overwhelms Ingestion
- Condition: Video goes viral, 100K+ comments per hour flood inbox
- Expected behavior: Throttle kicks in at 100 msg/min (batch AI), then 500 msg/min (circuit breaker). UI shows "⚡ High volume — AI analyzing in batches" or "🔴 Extremely high volume — AI paused." Messages still ingested raw. User can manually trigger batch analysis later (costs credits). Auto-recovery when rate drops below 100/min for 10 continuous minutes.
- Reference: RULE-M12-007, Pack 05 §6.5

### EC-M12-002: Bot-to-Bot Auto-Reply Loop
- Condition: Creativanta auto-reply meets third-party chatbot → infinite loop risk
- Expected behavior: After 3 consecutive system-only replies, auto-reply pauses for that thread only. Alert sent: "🔄 Auto-reply loop detected on thread [X]." Hard cap: 10 auto-replies per thread per hour. Manual re-enable required; second detection = permanent disable for thread.
- Reference: RULE-M12-008, Pack 05 §7.6

### EC-M12-003: Multi-Account Reply Confusion
- Condition: Workspace has 5 connected Facebook pages; operator replies from wrong account
- Expected behavior: Compose box MUST show color-coded identity badge BEFORE typing. Identity auto-updates as operator switches threads. Reply without visible identity tag = hard UX block. Mobile: compact identity bar above compose box.
- Reference: RULE-M12-006, Pack 05 §7.4

### EC-M12-004: SLA Breach During Throttle
- Condition: Throttled ingestion mode delays AI classification → SLA timer running on threads
- Expected behavior: SLA timer runs on thread creation time, not classification time. Throttle does NOT pause SLA clocks. SLA breach events fire normally. UI shows both throttle status AND SLA warnings simultaneously so operator can manually prioritize.
- Reference: RULE-M12-004

## State Machine

Object: thread | DB column: `threads.status`
see [04_contracts/database_schema.md#9.2](../../04_contracts/database_schema.md)

| From | To | Trigger | Condition |
|---|---|---|---|
| — | new | Thread created from ingested message | Message received from platform |
| new | triaged | Operator triages (sets intent/priority) | ThreadService/Triage called |
| new | active | Operator replies directly | ThreadService/Reply without explicit triage |
| triaged | active | Operator takes action (reply/assign) | Reply or assignment action |
| active | waiting_on_user | Operator sends reply, awaiting response | Outbound reply sent |
| active | waiting_on_team | Thread needs internal action | Assignment or escalation |
| waiting_on_user | active | User responds | Inbound message received |
| waiting_on_team | active | Team member takes action | Assignment resolved |
| active | converted_to_task | Thread converted to downstream object | Conversion action (→ idea, → offer, etc.) |
| active | resolved | Operator marks resolved | ThreadService/Resolve |
| waiting_on_user | resolved | No response + auto-resolve policy | After configurable timeout |
| resolved | active | Reopened by new message | Inbound message on resolved thread |
| any | archived | Manual archive or auto-archive policy | Operator action or time-based |
| any (except archived) | snoozed | Operator snoozes thread | Snooze action with wake time |
| snoozed | active | Snooze time reached or new message | Timer expires or inbound message |

## Related Contracts

| Topic | File | Section |
|---|---|---|
| DB tables | [04_contracts/database_schema.md](../../04_contracts/database_schema.md) | §9 (entities, threads, messages, follow_up_tasks) |
| API | [04_contracts/api_endpoint_map.md](../../04_contracts/api_endpoint_map.md) | §2.5 (ThreadService, EntityService, SuggestionService, FollowUpService — ~18 RPCs) |
| Events | [04_contracts/domain_event_catalog.md](../../04_contracts/domain_event_catalog.md) | §7 (thread.created, thread.intent_classified, thread.assigned, thread.resolved, thread.sla_*, message.received, sponsor_inquiry.detected, follow_up_task.created) |
| RBAC | [04_contracts/rbac_permission_matrix.md](../../04_contracts/rbac_permission_matrix.md) | §2.6 (thread:triage — Editor+; thread:assign — Manager+; thread:reply — Contributor+; entity:merge — Manager+) |
| Pack 05 | Pack 05 — Inbox Contract <!-- Legacy ref: creativanta_detail_design_pack_05_connector_capability_publish_inbox_contract_v_3_1.md — superseded by current feature docs + contract layer --> | §6 (Ingestion), §7 (Reply/Moderation), §6.5 (Throttle), §7.4 (Reply-As), §7.5 (Ghost), §7.6 (Loop detection) |
| Real-time | PRD Part 2, §32B.1 | WebSocket / SSE, ≤ 2s message arrival |

## Related Screens

| Platform | Screen | Notes |
|---|---|---|
| Web | Inbox — thread list | Filterable by intent, priority, status, platform, SLA state |
| Web | Thread detail | Message timeline + AI summary + suggested replies + related objects + conversion CTAs |
| Web | Entity / Contact detail | Cross-thread history, relationship state, CRM view |
| Mobile | Swipe triage | Swipe left/right for quick triage, quick reply, assign, set next action |
| Mobile | Quick reply + identity bar | Compact compose with Reply-As identity indicator |

## Acceptance Criteria

1. **Given** a new comment arrives from a connected TikTok account, **when** the ingestion worker processes it, **then** a Thread MUST exist with `owner_user_id` set (auto or default), `intent` classified (at minimum `'unknown'`), `status = 'new'`, and `next_action` populated — the `thread.created` event MUST be emitted.

2. **Given** a thread with `intent = 'sponsor_interest'`, **when** the operator clicks "Route to Brand Deals," **then** the thread MUST remain in the inbox with its original `thread_id`, AND a brand deal reference MUST appear in `related_object_refs`, AND the `sponsor_inquiry.detected` event MUST have been emitted.

3. **Given** an operator converts a thread to an Idea (M05), **when** the conversion completes, **then** the Idea MUST have `source_refs` linking to the originating `thread_id`, AND the thread's `related_object_refs` MUST include the new `idea_id`.

4. **Given** a workspace with SLA policy (response within 2 hours), **when** a thread exceeds 1.5 hours without reply, **then** `thread.sla_approaching` MUST fire; **when** 2 hours pass, `thread.sla_breached` MUST fire and appear as urgent card in M01 Daily Brief.

5. **Given** a viral video generating 600 messages/minute on a single thread, **when** the ingestion worker detects this rate, **then** circuit breaker mode MUST activate: messages ingested raw (no AI), UI shows "🔴 Extremely high volume" banner, and user is offered "Analyze [N] unprocessed messages" button (costs credits).

## Open Questions / Blockers

- [NONE] — No critical blockers specific to M12 in OPEN_BLOCKERS.md. M12 endpoints are defined in API map §2.5 (~18 RPCs).
