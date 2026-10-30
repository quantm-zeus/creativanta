---
layer: features
module: M17
canonical: true
domain: commerce
status: SPECIFIED
last_updated: 2026-10-29
blockers: []  # API-M-001 resolved 2026-04-02 — LiveCommerceService §2.8.3 (11 RPCs)
---

# Feature: Live Commerce War Room (M17)

## Purpose

Live commerce is a real-time operating surface — sellers and creators conduct live sessions where they pin offers, handle comments, mark product highlights, trigger cues, and manage audience interaction at speed. The session produces actionable data: highlight clips, engagement spikes, conversion moments, and post-live proof documents. Without a dedicated war room, operators resort to platform-native tools that don't connect to the commerce graph.

M17 exists as the **real-time live commerce orchestrator** — managing the full live session lifecycle from planning through post-live analysis, with run-of-show coordination, cue cards, offer pinning, highlight marking, and automatic post-live summary generation that feeds into the proof layer (M19).

## Scope

### Covers (M17 owns live commerce operations)
- Live session lifecycle state machine: PLANNED → READY → LIVE → PAUSED → ENDED → POST_LIVE_PROCESSING → CLOSED
- Run-of-show planning: ordered segment list with timing, products, talking points
- Cue cards: real-time prompts for operators during live
- Offer pinning: link offers to live timeline moments
- Comment triage: high-priority/purchase-intent comments surfaced in real-time
- Highlight marking: tag moments for post-live clip extraction (feeds M09)
- Post-live summary generation: automatic proof document = performance evidence
- Live performance linking: session → orders → revenue → proof

### Does NOT cover (M17 boundaries)
- **Platform native live**: M17 does NOT replace TikTok Live / Facebook Live — it operates alongside as an orchestration layer
- **M09 owns**: clip extraction from highlights (M17 marks → M09 extracts)
- **M12 owns**: full inbox/thread management (M17 surfaces high-priority comments during live)
- **M19 owns**: profit calculations from live (M17 provides session data → M19 aggregates)
- **M13 owns**: order lifecycle (M17's `live_session_id` links orders to sessions)

## Actors

| Actor | Role | Primary Actions |
|---|---|---|
| Live Operator | Editor+ | Manage run-of-show, pin offers, trigger cues, mark highlights |
| Host / Presenter | Contributor+ | View cue cards, respond to prompted actions |
| Comment Monitor | Contributor+ | Triage comments, flag purchase intent, escalate urgent |
| Manager | Manager+ | Create live plans, review post-live summary, approve proof bundle |
| System (Real-time) | System | WebSocket event streaming, comment intent classification, metrics capture |
| System (Post-live) | System | Generate summary, extract highlights → M09, calculate performance metrics |

## Business Rules

1. **RULE-M17-001**: Live session lifecycle MUST follow canonical state machine: `planned → ready → live → paused → ended → post_live_processing → closed`. `paused` state supports temporary breaks during live (resume = return to `live`). `post_live_processing` is system-driven (summary generation, clip extraction) (PRD §24, DB schema §12.1).
2. **RULE-M17-002**: Every highlight and cue card MUST link back to the parent `live_session_id`. Highlights include timestamp, type (product_demo, engagement_spike, conversion_moment, objection_handling, custom), and optional offer reference. Cue cards include prompt text, target time, linked product/offer (PRD §23.17 AC).
3. **RULE-M17-003**: Post-live summary is a **proof document** — it contains performance metrics (viewers, engagement, conversions, orders, revenue attributed), highlight timeline, and evidence references. This document is accessible from M19's proof layer and can be assembled into Proof Bundles (PRD §23.17 AC, Pack 06 §7).
4. **RULE-M17-004**: Live performance linking traces: Live Session → Orders (via `orders.live_session_id`) → Revenue → Costs (AI credits, platform fees) → Profit. This chain MUST be navigable in both directions. Live-attributed revenue feeds M19 operating ledger with `source_class` appropriate to data quality (PRD §16, §19).
5. **RULE-M17-005**: Real-time surfaces (comment stream, metrics, cue timing) use WebSocket with ≤500ms latency requirement. CSR rendering priority — no SSR for war room (PRD §32.2, §32B.1).
6. **RULE-M17-006**: Run-of-show is stored as `JSONB` array of segment items. Each segment: `{segment_index, title, planned_duration_seconds, product_ids, offer_ids, talking_points, cue_card_ids}`. The run-of-show is the operational script for the live session — it can be pre-planned and adjusted in real-time (DB schema §12.1, §25.2 RunOfShowItem).

## Main Flow

1. **Live planning**: Operator creates live session
   - Title, platform, connected account, planned start time
   - Run-of-show built: segments with products, offers, talking points, cues
   - `status = 'planned'`
2. **Pre-live preparation**: Operator readies session
   - Verify connected account health, platform capability
   - Load cue cards, verify offer availability
   - `status = 'ready'`
3. **Go live**: Session starts
   - `status = 'live'`, `actual_start_at` recorded
   - `live.session_started` event emitted
   - WebSocket channel active: real-time comment stream, metrics, cue timing
4. **During live**:
   - Operator pins/unpins offers at appropriate moments → `live.offer_pinned`
   - Operator triggers cue cards → `live.cue_triggered`
   - Comment monitor triages high-priority comments (purchase intent, objections)
   - Operator marks highlights → `live.highlight_marked` (timestamp, type, context)
   - Optional: pause session (breaks) → `status = 'paused'` → resume → `status = 'live'`
5. **Session ends**: Operator ends live
   - `status = 'ended'`, `actual_end_at` recorded
   - `live.session_ended` event emitted with summary
6. **Post-live processing**: System generates summary
   - `status = 'post_live_processing'`
   - Metrics snapshot calculated: peak viewers, avg viewers, engagement rate, comments, orders attributed
   - Highlights extracted → sent to M09 for clip processing
   - Post-live summary (proof document) assembled
   - `status = 'closed'` when processing complete

## Alternate Flows

### A1: Live Session Interrupted (Connectivity Loss)
- Trigger: Platform connection drops during live
- Steps: System detects disconnection → `status` remains `live` (platform-side may still be live). Diagnostics record created. Reconnection attempted. If reconnected → resume monitoring. If not → operator manually transitions to `ended`.
- Result: Data gap documented in post-live summary; metrics marked as incomplete

### A2: Post-Live Clip Extraction
- Trigger: Session ends with marked highlights
- Steps: System sends highlighted timestamps to M09 → M09 creates derivative clips → clips available for editing/publishing via M11. Post-live summary links to extracted clips.
- Result: Live highlights become reusable content assets in the derivative pipeline

## Edge Cases

### EC-M17-001: No Highlights Marked During Live
- Condition: Operator forgets to mark highlights
- Expected behavior: Post-live processing still generates complete summary. System offers "AI-suggested highlights" based on engagement spikes and comment density. Operator can retroactively mark highlights from the recording timeline (if recording available).
- Reference: RULE-M17-002

### EC-M17-002: Orders Arrive After Session Ends
- Condition: Viewers purchase products after live ends but within attribution window
- Expected behavior: Orders still linked to `live_session_id` via campaign/offer association. Post-live summary is a living document updated as late orders arrive (during `post_live_processing` → `closed`). Re-opened if significant late order volume detected.
- Reference: RULE-M17-004

### EC-M17-003: Concurrent Live Sessions
- Condition: Workspace runs simultaneous lives on multiple platforms
- Expected behavior: Each session is independent — separate `live_session_id`, separate WebSocket channels, separate metrics. Dashboard shows all active sessions. Operator can switch between session war rooms. Cross-session summary available in M19.
- Reference: RULE-M17-001

## State Machine

Object: live_session | DB column: `live_sessions.status`
see [04_contracts/database_schema.md#12.1](../../04_contracts/database_schema.md)

| From | To | Trigger | Condition |
|---|---|---|---|
| — | planned | Session created | Title + platform + planned time |
| planned | ready | Operator marks ready | Connector healthy, run-of-show set |
| ready | live | Operator starts session | Platform live or monitoring active |
| live | paused | Operator pauses | Temporary break |
| paused | live | Operator resumes | Resume from break |
| live | ended | Operator ends session | Session complete |
| ended | post_live_processing | System initiates processing | Automatic on session end |
| post_live_processing | closed | Processing complete | Summary, clips, metrics finalized |

## Related Contracts

| Topic | File | Section |
|---|---|---|
| DB tables | [04_contracts/database_schema.md](../../04_contracts/database_schema.md) | §12.1 (live_sessions), §25.2 (RunOfShowItem, LiveMetricsSnapshot JSONB shapes) |
| API | [04_contracts/api_endpoint_map.md](../../04_contracts/api_endpoint_map.md) | §2.8 (Live — ~10 RPCs: Session, Cue, Highlight) |
| Events | [04_contracts/domain_event_catalog.md](../../04_contracts/domain_event_catalog.md) | §9 (live.session_started, live.session_ended, live.highlight_marked, live.offer_pinned, live.cue_triggered), §19 (live_segment.created) |
| RBAC | [04_contracts/rbac_permission_matrix.md](../../04_contracts/rbac_permission_matrix.md) | §2.11 (live — Editor+ for operations, Manager+ for session management) |
| Real-time | PRD Part 2, §32B.1 | WebSocket, ≤500ms latency |
| Rendering | PRD Part 2, §32.2 | CSR + WebSocket (war room is real-time priority) |

## Related Screens

| Platform | Screen | Notes |
|---|---|---|
| Web | Live planning | Run-of-show builder, product/offer selection, cue card editor |
| Web | War room (during live) | Split view: comment stream, metrics panel, cue cards, offer pin controls |
| Web | Post-live summary | Performance metrics, highlight timeline, proof document, clip links |
| Mobile | Live monitoring | Compact war room: comments, cue trigger, highlight mark |
| Mobile | Quick cue + highlight | One-tap cue trigger, one-tap highlight mark, urgent reply |

## Acceptance Criteria

1. **Given** a live session is active, **when** the operator marks a highlight at timestamp T, **then** the highlight record MUST include `live_session_id`, timestamp, type (product_demo/engagement_spike/etc.), and optional offer reference — the `live.highlight_marked` event MUST fire.

2. **Given** a live session ends, **when** post-live processing completes, **then** a post-live summary MUST exist containing: peak/avg viewers, engagement metrics, attributed orders, total revenue, highlight timeline — AND this summary MUST be accessible from M19's proof layer.

3. **Given** cue cards are defined in the run-of-show, **when** the live session is active, **then** cue cards MUST appear at their planned times in the operator's war room view — each linked to their parent `live_session_id`.

4. **Given** highlights were marked during a live session, **when** post-live processing runs, **then** highlighted timestamps MUST be sent to M09 for clip extraction — the resulting clips MUST link back to the source live session.

5. **Given** orders arrive with `live_session_id` set, **when** the post-live summary is generated, **then** those orders MUST appear in the summary with their revenue contribution — traceable through Product → Offer → Order → Revenue chain.

## Open Questions / Blockers

> ✅ **RESOLVED: API-M-001** (2026-04-02) — `LiveCommerceService` now fully defined in `api_endpoint_map.md` §2.8.3 with 11 RPCs: CreateSession, Get, List, StartSession, EndSession, AddCue, RemoveCue, HighlightProduct, GetAnalytics, UpdateRunOfShow, CreateHighlight. Each RPC has Method, Auth, Rate Limit, Description.
> ✅ **RESOLVED: API-M-002** (2026-04-02) — JSON request/response example in `api_examples.md` A.16 (LiveCommerceService/CreateSession).
