---
layer: features
module: M02
canonical: true
domain: intelligence
status: SPECIFIED
last_updated: 2026-10-29
---

# Feature: Trend Fusion Radar (M02)

## Purpose

Creators and operators currently discover trends through fragmented manual research — scrolling TikTok, checking Google Trends, reading competitor posts — with no systematic way to evaluate relevance, freshness, or saturation. M02 exists to **ingest, normalize, and score trend signals** from multiple sources into a unified intelligence surface, enabling users to make data-backed decisions about what content to create, what products to push, and what opportunities to pursue.

The Trend Fusion Radar transforms raw signals into scored trends with velocity, freshness, and saturation dimensions, making it the foundational intelligence layer that feeds M01 (Home), M04 (Opportunity Board), M05 (Idea Engine), and M07 (AI Video Studio — Remix integration).

## Scope

### Covers
- Signal ingestion from connected platforms and external sources
- Signal normalization into canonical signal objects
- Trend creation by clustering/merging related signals
- Multi-dimensional scoring: velocity, freshness, saturation, strength
- Semantic search across trends (pgvector embeddings)
- Watchlist creation and management with alert thresholds
- Alert lifecycle (threshold breach → notification → action/dismiss)
- Trend → Opportunity conversion flow
- Trend → Idea conversion flow
- "Remix this" integration entry point for M07

### Does NOT cover (Non-goals for this module)
- Competitor entity management and benchmarking (owned by M03)
- Opportunity prioritization, scoring, and assignment (owned by M04)
- Idea generation and enrichment (owned by M05)
- AI content generation triggered from trends (owned by M07)
- Revenue/profit attribution from trend-driven content (owned by M19)

## Actors

| Actor | Role | Primary Actions |
|---|---|---|
| Creator | Editor+ | Browse trends, save to watchlist, convert to idea, dismiss, share |
| Affiliate Operator | Editor+ | Browse product trends, convert to opportunity, link to product |
| Seller | Editor+ | Monitor product/category trends, detect white-space, track saturation |
| Agency Manager | Manager+ | Manage watchlists across creators, receive trend alerts for portfolio |
| System (Ingestion) | System | Ingest raw signals from platform APIs, normalize, cluster into trends |

## Business Rules

> INVARIANTS — rút từ PRD §23.2, §15, Pack 02 §7/§9.12 AC. Bắt buộc implement đúng.

1. **RULE-M02-001**: Every Trend MUST carry a `confidence` band (high/medium_high/medium/low_medium/low) and a `source_class` (official/imported/inferred/estimated/unreconciled). Users MUST be able to see why a trend has its current confidence and what would improve it (PRD §15.2).
2. **RULE-M02-002**: Trend scoring MUST use at minimum 3 independent dimensions: `velocity_score`, `freshness_score`, `saturation_score` (PRD §23.2). A composite `strength_score` (0-100) MUST be derived from these.
3. **RULE-M02-003**: Every Trend MUST be traceable back to its source Signals via `trend_signals` junction — no orphan trends without provenance (Pack 02 §7.1, invariant: "Trend phải truy ngược được về source lineage").
4. **RULE-M02-004**: Watchlist alerts MUST fire when a tracked trend's metrics breach the user-defined `alert_threshold` — alert delivery via push, email, or in-app notification per user preferences (PRD §23.2 AC: "watchlist alerts hoạt động").
5. **RULE-M02-005**: Signal lifecycle MUST follow: `detected → processed → merged → expired | discarded`. Signals cannot skip states. Expired signals remain queryable for historical analysis but are excluded from active scoring (DB schema §5.1).
6. **RULE-M02-006**: Trend data surfaced on Home (M01) or used by AI Studio (M07) MUST carry freshness timestamp — stale trend data (>24h without refresh) MUST show "last updated" warning badge (PRD §15.7).

## Main Flow

1. **Signal Ingestion**: System collects raw signals from connected platform APIs, Google Trends, and manual input
   - Writes to `signals` table with `signal_type`, `source_system`, `raw_payload`
   - see [04_contracts/database_schema.md#5.1](../../04_contracts/database_schema.md)
2. **Normalization**: System normalizes signal payload into `normalized_summary`, assigns `freshness_hours` and initial `confidence`
   - emits `trend.signal_detected`
   - see [04_contracts/domain_event_catalog.md#3](../../04_contracts/domain_event_catalog.md)
3. **Clustering**: System clusters related signals into Trends or attaches to existing Trends
   - Writes/updates `trends` table, creates `trend_signals` junction entries
   - Computes `velocity_score`, `freshness_score`, `saturation_score`, `strength_score`
4. **Trend Created/Updated**: If a new trend is formed or existing trend's strength changes significantly
   - emits `trend.created` (consumers: M01, M04, M05)
   - emits `trend.spike_detected` if velocity crosses spike threshold (consumers: M01, Notification)
5. **User browses Trend list**: calls `TrendService/List` → paginated, sorted by strength
   - see [04_contracts/api_endpoint_map.md#2.2](../../04_contracts/api_endpoint_map.md)
6. **User saves to watchlist**: calls `TrendService/ManageWatchlist` (Editor+)
7. **User converts trend to opportunity**: navigates to M04 conversion flow, passes trend as source reference
   - Future opportunity links back via `opportunity_sources` junction
8. **User converts trend to idea**: navigates to M05, passes trend context
   - Idea links back via `idea_sources` junction

## Alternate Flows

### A1: Trend Spike Detected
- Trigger: A trend's `velocity_score` exceeds the spike threshold within a short time window
- Steps: System emits `trend.spike_detected`. If user has an active watchlist matching that trend, alert fires. Alert appears as Home card (M01) and push notification.
- Result: User sees spike alert, can act (convert to idea/opportunity) or dismiss

### A2: Semantic Search
- Trigger: User searches for trend by keyword/topic using natural language
- Steps: System uses `trends.embedding` (pgvector) for semantic matching via `TrendService/Search`
- Result: Ranked results by semantic relevance + strength score

### A3: Trend Expired
- Trigger: Trend's freshness falls below minimum threshold OR saturation reaches 100%
- Steps: System transitions trend lifecycle, emits `trend.expired`. Trend removed from active lists but remains in history.
- Result: Watchlist alerts for this trend are deactivated. User notified if actively watching.

## Edge Cases

> Tối thiểu 3. Phải handle tường minh.

### EC-M02-001: Duplicate Signals from Multiple Sources
- Condition: Same trending topic arrives from TikTok API and Google Trends within the same ingestion window
- Expected behavior: Normalization layer detects semantic overlap and merges into a single signal or clusters into the same trend. Provenance retains both source systems. Dedup key: normalized title + time window + source hash.
- Reference: DB schema §5.1 (`related_trend_ids`), Pack 02 §7.1

### EC-M02-002: Connected Account Token Expired During Ingestion
- Condition: Signal ingestion job starts but the connected account's token has expired mid-sync
- Expected behavior: Ingestion for that source gracefully degrades — partial signals already collected are processed. System emits `account.token_expired` event. Trend scores based on remaining available data carry lower confidence. User sees "Source [Platform] disconnected" banner on Trend Radar with Reconnect CTA.
- Reference: Domain event catalog §2 (`account.token_expired`), Pack 01 §8.3 (Broken State)

### EC-M02-003: Zero Signals for a Workspace
- Condition: New workspace, no connected accounts, no trending data available
- Expected behavior: Trend Radar shows empty state with "Connect your first platform to start seeing trends" CTA. Curated/global trending topics (non-workspace-specific) may be shown as "Explore" section with `source_class = 'estimated'` labeling.
- Reference: Pack 01 §8.1 (Empty State)

### EC-M02-004: Watchlist Alert Storm
- Condition: A market event causes 20+ watchlist alerts to fire simultaneously
- Expected behavior: System batches alerts into a single summary notification: "15 watchlist trends spiking — View All". Individual alerts remain in notification center. Alert throttle: max 5 push notifications per hour per workspace for trend alerts.
- Reference: Pack 01 §9E (Notification Center)

## State Machine

Object: signal | DB enum: `signals.lifecycle_state`
see [04_contracts/database_schema.md#5.1](../../04_contracts/database_schema.md)

| From | To | Trigger | Condition |
|---|---|---|---|
| — | detected | Signal ingested from source | Raw payload received |
| detected | processed | Normalization complete | Summary + confidence assigned |
| processed | merged | Clustered into Trend | Matched to existing or new trend |
| processed | discarded | Quality filter rejects | Spam, irrelevant, or below threshold |
| detected/processed/merged | expired | Freshness timeout | `freshness_hours` exceeded + no renewal |

## Related Contracts

| Topic | File | Section |
|---|---|---|
| DB tables | [04_contracts/database_schema.md](../../04_contracts/database_schema.md) | §5 (signals, trends, trend_signals, watchlists) |
| API | [04_contracts/api_endpoint_map.md](../../04_contracts/api_endpoint_map.md) | §2.2 (TrendService: List, Get, Search, ManageWatchlist) |
| Events | [04_contracts/domain_event_catalog.md](../../04_contracts/domain_event_catalog.md) | §3 (trend.signal_detected, trend.created, trend.spike_detected, trend.expired) |
| RBAC | [04_contracts/rbac_permission_matrix.md](../../04_contracts/rbac_permission_matrix.md) | §2.2 (trend:read — all members; trend:watchlist:manage — Editor+) |

## Related Screens

| Platform | Screen | Notes |
|---|---|---|
| Web | Trend Radar list/detail | Sortable, filterable trend list + detail with signal provenance |
| Web | Watchlist management | Create/edit watchlists with alert thresholds |
| Mobile | Trend browse (Tasks tab / object navigation) | Swipeable trend cards, save/dismiss/convert quick actions |
| Web | AI Remix Studio (M07 integration) | "🔄 Remix this" button on trending video entries |

## Acceptance Criteria

1. **Given** a user browses the Trend Radar, **when** they view a trend card, **then** the card MUST display: title, `strength_score`, `confidence` badge, `freshness_at` timestamp, and `source_class` badge.

2. **Given** a user saves a trend to a watchlist with `alert_threshold: {velocity_score > 80}`, **when** that trend's velocity score crosses 80, **then** the system MUST fire a notification to the user within 5 minutes of detection.

3. **Given** a user clicks "Convert to Opportunity" on a trend, **when** the opportunity is created in M04, **then** the new opportunity MUST have `opportunity_sources` entry linking back to the source trend with `source_type = 'trend'`.

4. **Given** a trend with `confidence = 'low'`, **when** displayed anywhere (Home, Radar, Opportunity), **then** the confidence badge MUST be visible and tapping it MUST show an explanation of why confidence is low and what would improve it.

5. **Given** a connected TikTok account with expired token, **when** the trend ingestion job runs, **then** partial data already collected MUST still be processed, the trend scores MUST carry a reduced confidence, and the Trend Radar MUST show a "Source Disconnected" banner for TikTok.

## Open Questions / Blockers

- [NONE] — No critical blockers specific to M02 in OPEN_BLOCKERS.md. Note: EVT-H-001 (event naming inconsistency) was resolved 2026-04-02 with 74-row CamelCase→dot.notation mapping in `runtime_workflow.md` §3.1B-C.
