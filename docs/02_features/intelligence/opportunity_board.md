---
layer: features
module: M04
canonical: true
domain: intelligence
status: SPECIFIED
last_updated: 2026-10-29
---

# Feature: Opportunity Board (M04)

## Purpose

Trends and competitor insights are useless if they remain observations without being converted into prioritized, actionable decisions. Creators and operators need a structured decision surface where raw signals and research become **prioritized opportunities with clear ownership, impact/effort scoring, and conversion paths** to downstream objects (ideas, scripts, campaigns, live plans).

M04 exists to be the bridge between intelligence (M02/M03) and execution (M05/M06/M14). It provides a Kanban-style board with state management, impact vs effort scoring, owner assignment, and conversion workflows — ensuring every opportunity can be traced back to its source and forward to its outcome.

## Scope

### Covers
- Opportunity registry (create, list, detail)
- State machine: draft → open → prioritized → assigned → in_progress → converted | parked | closed_won | closed_lost
- Impact vs effort scoring (Expected Impact Model + Expected Effort Model)
- Urgency tagging
- Owner assignment (assign to team member)
- Conversion to idea (M05), script (M06), campaign (M14), or live plan (M17)
- Source traceability via `opportunity_sources` junction table
- Decision status tracking and outcome recording
- Expected profit estimation (with confidence caveat)

### Does NOT cover (Non-goals for this module)
- Signal ingestion and trend scoring (owned by M02)
- Competitor benchmarking and insight generation (owned by M03)
- Idea enrichment and AI generation (owned by M05)
- Script creation and approval workflow (owned by M06)
- Campaign management and offer creation (owned by M14)
- Financial profit calculation and reconciliation (owned by M19)

## Actors

| Actor | Role | Primary Actions |
|---|---|---|
| Creator | Contributor+ | Create opportunities, browse board, convert to idea |
| Seller | Editor+ | Create product opportunities, assign to team, convert to campaign |
| Affiliate Operator | Editor+ | Browse product opportunities, score/prioritize, convert to campaign |
| Manager | Manager+ | Assign owners, prioritize, review outcomes, close opportunities |
| System (M02/M03) | System | Auto-create opportunities from trend spikes or competitor gaps |

## Business Rules

> INVARIANTS — rút từ PRD §13.1, §23.4, Pack 02 §9.1 AC. Bắt buộc implement đúng.

1. **RULE-M04-001**: Every Opportunity MUST map back to at least one source object (trend, signal, competitor entity, product opportunity, or thread) via `opportunity_sources` junction table. Orphan opportunities without source provenance are forbidden (PRD §12.3: "Mỗi Opportunity phải map được về ít nhất một source object", §23.4 AC).
2. **RULE-M04-002**: Every Opportunity MUST have an `owner_user_id` once it transitions beyond `draft` state. Unowned opportunities in `open` or later states MUST trigger a system prompt to assign an owner (PRD §23.4 AC: "opportunity phải có owner và status").
3. **RULE-M04-003**: Every Opportunity MUST have either a `priority_reason` (text explanation) OR a `confidence` context explaining why it's at its current priority. Opportunities without any priority justification are not valid for board display (PRD §23.4 AC: "opportunity phải có priority reason hoặc confidence context", PRD §13.1).
4. **RULE-M04-004**: State transitions MUST follow the defined state machine — skipping states is forbidden. The `converted_to_type` and `converted_to_id` fields MUST be populated when transitioning to `converted` state (DB schema §5.4).
5. **RULE-M04-005**: Expected profit estimation MUST carry `confidence` band and `source_class`. Estimated profit MUST NOT be displayed as finalized truth — UI MUST show "Estimate" badge with explanation of assumptions (PRD §15.1, §15.2).
6. **RULE-M04-006**: Conversion to downstream objects MUST preserve the source lineage. When an opportunity converts to an idea, the idea's `idea_sources` table MUST reference the opportunity. When converting to a campaign, the campaign MUST reference the opportunity as origin.

## Main Flow

1. **Opportunity created**: User creates manually or system auto-creates from trend spike/competitor gap
   - calls `OpportunityService/Create` (Contributor+)
   - writes to `opportunities` table with `opportunity_type`, `title`, `summary`, `expected_impact`, `expected_effort`
   - writes to `opportunity_sources` junction with source refs
   - emits `opportunity.created`
   - see [04_contracts/api_endpoint_map.md#2.2](../../04_contracts/api_endpoint_map.md)
   - see [04_contracts/domain_event_catalog.md#3](../../04_contracts/domain_event_catalog.md)
2. **User browses Opportunity Board**: calls `OpportunityService/List` → board view with state columns
   - Filterable by: `opportunity_type`, `priority_state`, `owner_user_id`, `confidence`
3. **User scores/prioritizes**: sets `expected_impact` and `expected_effort` scores with descriptions
   - `priority_reason` populated
   - State transitions to `prioritized`
4. **User assigns owner**: calls `OpportunityService/Assign` (Manager+)
   - `owner_user_id` set
   - State transitions to `assigned`
   - emits `opportunity.state_changed`
5. **User converts to downstream object**: calls `OpportunityService/Convert` (Editor+)
   - Selects conversion type: idea, script, campaign, live_plan
   - System creates the target object with source reference
   - `converted_to_type` and `converted_to_id` populated
   - State transitions to `converted`
   - emits `opportunity.converted`
6. **Decision outcome tracking**: User records whether the converted execution resulted in success (closed_won) or failure (closed_lost)

## Alternate Flows

### A1: Auto-Created Opportunity from Trend Spike
- Trigger: M02 emits `trend.spike_detected` for a trend matching the workspace's niche/category
- Steps: System auto-creates opportunity with `opportunity_type = 'content'`, `priority_state = 'draft'`, and `opportunity_sources` linking to the triggering trend. Opportunity appears in Draft column of the board.
- Result: User reviews, validates, and promotes or dismisses

### A2: Opportunity Parked
- Trigger: User decides opportunity is valid but not actionable now
- Steps: State transitions from current state to `parked` with reason text
- Result: Opportunity moves off the active board but remains queryable under "Parked" filter

### A3: Multiple Source Attribution
- Trigger: An opportunity arises from both a trend (M02) and a competitor gap (M03) simultaneously
- Steps: `opportunity_sources` junction has two entries: `(opportunity_id, 'trend', trend_id)` and `(opportunity_id, 'competitor', competitor_id)`
- Result: Opportunity detail shows both sources in "Sources" section with links to original objects

## Edge Cases

> Tối thiểu 3. Phải handle tường minh.

### EC-M04-001: Source Object Deleted After Opportunity Created
- Condition: A trend (source) is expired/archived after an opportunity was created referencing it
- Expected behavior: Opportunity remains valid — it does not auto-delete or lose its source reference. The `opportunity_sources` entry retains the `source_id`. When user navigates to the source from opportunity detail, system shows "Source trend has expired — historical data available" with read-only access to the archived trend.
- Reference: Pack 02 §13 (soft delete / archive strategy)

### EC-M04-002: Conversion to Idea When User Lacks M05 Permission
- Condition: A Contributor tries to convert an opportunity to an idea, but `idea:convert` requires Editor+ role
- Expected behavior: System denies the conversion with RBAC error: "You need Editor or higher role to convert opportunities to ideas. Contact your workspace admin." The opportunity remains in its current state — no partial conversion occurs.
- Reference: RBAC §2.2 (opportunity:convert — Editor+), §2.3 (idea:convert — Editor+)

### EC-M04-003: Concurrent State Transition by Two Users
- Condition: Two users attempt to transition the same opportunity simultaneously (e.g., one assigns while another converts)
- Expected behavior: Optimistic concurrency control via `updated_at` timestamp check. First write wins. Second user receives 409 Conflict error with message: "This opportunity was just updated by [user]. Please refresh and try again." Board refreshes automatically on conflict detection.
- Reference: Pack 02 §8.2 (state transition validation), API response contract §16.2 (409 conflict)

### EC-M04-004: Expected Profit Estimation with Low Data Quality
- Condition: User sets expected profit estimate but workspace has very limited historical revenue data (new workspace, <10 orders)
- Expected behavior: System allows the estimate but annotates it with `confidence = 'low'` automatically. The profit estimate card shows "Low Confidence" badge with explanation: "Based on limited data (X orders). Accuracy improves as more transactions are recorded." This estimate MUST NOT flow into M19 Operating Ledger as actual revenue.
- Reference: PRD §15.2, §15.4

## State Machine

Object: opportunity | DB enum: `opportunities.priority_state`
see [04_contracts/database_schema.md#5.4](../../04_contracts/database_schema.md)

| From | To | Trigger | Condition |
|---|---|---|---|
| — | draft | Opportunity created (manual or auto) | Source refs populated |
| draft | open | User validates and opens | `title` + `summary` filled |
| open | prioritized | User scores impact/effort | `expected_impact` + `expected_effort` set |
| prioritized | assigned | Manager assigns owner | `owner_user_id` set (Manager+ role) |
| assigned | in_progress | Owner starts execution | Owner confirms active work |
| in_progress | converted | User converts to idea/script/campaign | `converted_to_type` + `converted_to_id` populated |
| converted | closed_won | Execution produced measurable result | Outcome evidence available |
| converted | closed_lost | Execution failed or abandoned | Outcome reason recorded |
| open/prioritized/assigned/in_progress | parked | User parks opportunity | Reason text provided |
| parked | open | User re-activates | Any |

## Related Contracts

| Topic | File | Section |
|---|---|---|
| DB tables | [04_contracts/database_schema.md](../../04_contracts/database_schema.md) | §5.4 (opportunities), §5.5 (opportunity_sources) |
| API | [04_contracts/api_endpoint_map.md](../../04_contracts/api_endpoint_map.md) | §2.2 (OpportunityService: List, Create, UpdateState, Assign, Convert, Get) |
| Events | [04_contracts/domain_event_catalog.md](../../04_contracts/domain_event_catalog.md) | §3 (opportunity.created, opportunity.converted, opportunity.state_changed) |
| RBAC | [04_contracts/rbac_permission_matrix.md](../../04_contracts/rbac_permission_matrix.md) | §2.2 (opportunity:read — Member; create — Contributor+; assign — Manager+; convert — Editor+) |

## Related Screens

| Platform | Screen | Notes |
|---|---|---|
| Web | Opportunity Board (Kanban) | State columns, drag-drop, filter by type/owner/confidence |
| Web | Opportunity Detail | Source attribution, impact/effort matrix, conversion CTA, audit timeline |
| Mobile | Opportunity list/card view | Quick assign, prioritize, convert gestures |
| Web | Home (M01 integration) | Top Opportunities card family sourced from M04 board |

## Acceptance Criteria

1. **Given** a user creates a new opportunity from a trend spike, **when** the opportunity is stored, **then** the `opportunity_sources` table MUST contain an entry with `source_type = 'trend'` and `source_id` matching the originating trend — and the opportunity detail page MUST show a clickable link to the source trend.

2. **Given** an opportunity in `prioritized` state with no `owner_user_id`, **when** the user attempts to transition it to `assigned`, **then** the system MUST require an owner assignment — the transition MUST fail if no owner is specified.

3. **Given** a user with Manager+ role assigns an opportunity and another user with Editor+ role simultaneously tries to convert it, **when** both requests arrive, **then** the first request MUST succeed and the second MUST receive a 409 Conflict response — no partial state corruption occurs.

4. **Given** an opportunity with `priority_reason = NULL` and `confidence = NULL`, **when** the board renders, **then** the opportunity card MUST show a warning indicator: "Missing priority context — add a reason or confidence explanation" with "Edit" CTA.

5. **Given** a user converts an opportunity to a campaign (M14), **when** the conversion completes, **then** the opportunity's `converted_to_type` MUST be `'campaign'`, `converted_to_id` MUST reference the new campaign, the state MUST be `'converted'`, and the event `opportunity.converted` MUST be emitted with payload containing `{opportunity_id, to_type: 'campaign', to_id}`.

## Open Questions / Blockers

- [NONE] — No critical blockers specific to M04 in OPEN_BLOCKERS.md.
