---
layer: features
module: M03
canonical: true
domain: intelligence
status: SPECIFIED
last_updated: 2026-10-29
---

# Feature: Research & Competitor Intelligence (M03)

## Purpose

Creators and operators lack a systematic way to track competitors, benchmark their own performance against the market, and identify white-space opportunities. Current research workflows involve manual spreadsheets, screenshots, and disconnected notes that quickly become stale and unreliable.

M03 exists to **transform market/competitor research into actionable operating intelligence** — not just notes or reports. It provides structured competitor mapping, periodic benchmark snapshots with provenance, pricing/offer comparisons, format/content pattern analysis, and white-space detection. Critically, every inferred insight MUST be clearly labeled as "inferred" to prevent users from conflating market intelligence with accounting truth.

## Scope

### Covers
- Competitor entity registry (name, platform, handle, category)
- Benchmark snapshot capture (periodic or on-demand)
- Pricing and offer comparison analysis
- Content format and pattern analysis
- White-space detection (gaps in competitor coverage)
- Research note linking to canonical objects (trends, opportunities, products)
- Inferred insight confidence labeling and explanation
- Integration with M02 (shared trend data) and M04 (opportunity creation)

### Does NOT cover (Non-goals for this module)
- Automated scraping of competitor accounts in violation of platform policies (PRD §6.3)
- Trend signal ingestion and scoring (owned by M02)
- Opportunity prioritization and conversion workflow (owned by M04)
- Real-time competitor monitoring or alerting (potential P2 feature — Pack 01 §S05.1 footnote)
- Financial benchmarking against competitor revenue (no access to competitor financial data)

## Actors

| Actor | Role | Primary Actions |
|---|---|---|
| Creator/Seller | Editor+ | Add competitors, view benchmarks, create opportunities from insights |
| Affiliate Operator | Editor+ | Compare product offers/pricing across competitors, detect gaps |
| Agency Manager | Manager+ | Set up competitor tracking for clients, review cross-portfolio benchmarks |
| System (Analysis) | System | Generate AI-powered benchmark analysis, detect patterns, compute white-space |

## Business Rules

> INVARIANTS — rút từ PRD §23.3, §15, Pack 02 §9.12 AC. Bắt buộc implement đúng.

1. **RULE-M03-001**: Every inferred insight MUST carry the label `source_class = 'inferred'` and display an "Inferred" badge in the UI. The system MUST NOT present inferred market intelligence as if it were accounting truth or official data (PRD §23.3 AC: "inferred insights phải gắn nhãn inferred").
2. **RULE-M03-002**: Every insight MUST have a visible `confidence` band and an explanation accessible via a "Why" drawer — users MUST understand the basis, limitations, and data gaps of any insight (PRD §23.3 AC: "insight phải có confidence/explanation").
3. **RULE-M03-003**: Market intelligence data MUST NOT be conflated with financial/accounting truth. Competitor pricing data is observational, not transactional. Benchmark comparisons MUST carry caveats about data completeness (PRD §23.3 AC: "không conflates market intelligence với accounting truth").
4. **RULE-M03-004**: Benchmark snapshots MUST record `captured_at` timestamp, `data_period_start/end`, `source_class`, and `confidence`. Stale snapshots (>30 days without refresh) MUST show a "stale data" warning badge (Pack 02 §9.12).
5. **RULE-M03-005**: Competitor entities MUST be scoped to workspace — workspace A's competitors are invisible to workspace B (Pack 02 §14.1).
6. **RULE-M03-006**: System MUST NOT perform scraping that violates connected platform policies. Data collection methods must be limited to official APIs, manual user input, and authorized import (PRD §6.3).

## Main Flow

1. **User adds competitor**: calls `CompetitorService/List` to view existing, then adds new competitor entity with name, platform, handle, category
   - Writes to `competitor_entities` table
   - see [04_contracts/database_schema.md#5.6](../../04_contracts/database_schema.md)
   - see [04_contracts/api_endpoint_map.md#2.2](../../04_contracts/api_endpoint_map.md)
2. **User requests benchmark analysis**: calls `CompetitorService/AnalyzeBenchmark` (Editor+)
   - System collects publicly available data points from connected platforms
   - AI generates benchmark snapshot with metrics: content frequency, engagement rate, format distribution, pricing range, offer types
3. **Benchmark snapshot stored**: writes to `benchmark_snapshots` table with `source_class`, `confidence`, metrics JSONB
   - see [04_contracts/database_schema.md#5.7](../../04_contracts/database_schema.md)
4. **User reviews insights**: views benchmark comparison, pricing gaps, format coverage gaps
   - Every AI-generated insight carries `source_class = 'inferred'` badge
   - "Why" drawer available on every metric
5. **User creates opportunity from insight**: navigates to M04 flow, passes competitor insight as source reference
   - Creates `opportunity_sources` entry with `source_type = 'competitor'`
6. **User links research to trends**: connects benchmark findings to existing trends from M02 for cross-referencing

## Alternate Flows

### A1: White-Space Detection
- Trigger: User requests "Find Gaps" analysis for a competitor set
- Steps: System compares competitor content formats, pricing tiers, and product categories against the user's own catalog. Identifies under-served formats, unaddressed price points, or uncovered niches.
- Result: White-space opportunities presented as actionable cards with "Create Opportunity" CTA

### A2: Benchmark Refresh
- Trigger: User requests refresh on an existing competitor benchmark, or auto-refresh schedule fires
- Steps: System re-captures current data, generates delta comparison (vs previous snapshot)
- Result: User sees trend direction (↑↓→) for each metric with delta percentage

### A3: Manual Research Note Attachment
- Trigger: User writes a research note and wants to link it to a competitor entity
- Steps: Note is attached to competitor entity. Note may also link to trends, products, or opportunities.
- Result: Research note appears in competitor detail timeline and in linked objects' "Related" tabs

## Edge Cases

> Tối thiểu 3. Phải handle tường minh.

### EC-M03-001: Competitor Platform Account Made Private
- Condition: A tracked competitor changes their account to private, limiting publicly available data
- Expected behavior: System marks affected benchmark metrics as `source_class = 'estimated'` with reduced confidence. Previous snapshots remain valid for their captured period. New snapshots carry an "incomplete data" caveat with explicit explanation: "Some data unavailable — competitor account is private."
- Reference: PRD §15.1, Pack 01 §7.1

### EC-M03-002: User Conflates Inferred Pricing with Real Margin
- Condition: User attempts to use competitor pricing data in profit calculations or financial reports
- Expected behavior: Financial surfaces (M19) MUST NOT accept competitor benchmark data as cost/revenue inputs. If a user tries to reference competitor pricing in Operating Ledger, system shows validation error: "Competitor pricing is observational data and cannot be used as financial truth. Use actual transaction data instead."
- Reference: PRD §23.3 (non-conflation rule), PRD §16.3

### EC-M03-003: Benchmark Data Period Overlap
- Condition: Two benchmark snapshots for the same competitor have overlapping `data_period_start/end` ranges
- Expected behavior: System warns user about overlap during benchmark creation. Both snapshots are preserved (no auto-dedup) since methodology or scope may differ. Comparison views default to most recent snapshot unless user explicitly selects historical.
- Reference: DB schema §5.7

### EC-M03-004: Large Competitor Registry (>100 Entities)
- Condition: Agency workspace tracks >100 competitors across multiple clients
- Expected behavior: Competitor list supports pagination, search-by-name, and filter-by-category/platform. Benchmark analysis requests are queued (not synchronous) for large competitor sets. Rate limit on `CompetitorService/AnalyzeBenchmark`: Editor+ max 10/min.
- Reference: API endpoint map §2.2

## State Machine

M03 does not own a first-class state machine. Benchmark snapshots are immutable point-in-time captures — they are created and never transition states.

Competitor entities have soft lifecycle managed implicitly:
- Active (default) — appears in registry
- Archived — hidden from active views but retained for historical benchmarks

## Related Contracts

| Topic | File | Section |
|---|---|---|
| DB tables | [04_contracts/database_schema.md](../../04_contracts/database_schema.md) | §5.6 (competitor_entities), §5.7 (benchmark_snapshots) |
| API | [04_contracts/api_endpoint_map.md](../../04_contracts/api_endpoint_map.md) | §2.2 (CompetitorService: List, AnalyzeBenchmark) |
| Events | [04_contracts/domain_event_catalog.md](../../04_contracts/domain_event_catalog.md) | §3 (intelligence events — M03 shares trend context with M02) |
| RBAC | [04_contracts/rbac_permission_matrix.md](../../04_contracts/rbac_permission_matrix.md) | §2.2 (competitor:manage — Editor+; opportunity:create — Contributor+) |

## Related Screens

| Platform | Screen | Notes |
|---|---|---|
| Web | Competitor Intelligence list/detail | Competitor registry, benchmark comparison, white-space analysis |
| Web | Benchmark Snapshot detail | Metrics breakdown, confidence badges, delta trends |
| Mobile | Competitor browse | Quick save benchmark, share snapshot, create opportunity |
| Web | Opportunity Board (M04 integration) | Competitor insights as opportunity sources |

## Acceptance Criteria

1. **Given** the system generates an AI benchmark insight comparing creator engagement rates, **when** the insight is displayed, **then** it MUST carry an "Inferred" source badge and a confidence band badge — tapping the badge MUST show the data sources used, limitations, and what additional data would improve confidence.

2. **Given** a user views a benchmark snapshot captured 45 days ago, **when** the snapshot is rendered, **then** it MUST display a "Stale Data" warning badge indicating the snapshot is >30 days old with a "Refresh" CTA.

3. **Given** a user creates an opportunity from a competitor white-space insight, **when** the opportunity is stored in M04, **then** it MUST have an `opportunity_sources` entry with `source_type = 'competitor'` and `source_id` referencing the competitor entity.

4. **Given** competitor pricing data exists in M03, **when** a user or system attempts to use this data as revenue/cost input in the Operating Ledger (M19), **then** the system MUST reject the input with a validation error explaining that observational market data cannot be used as financial truth.

5. **Given** a user with role `Viewer` accesses the Competitor Intelligence page, **when** they attempt to add a new competitor or trigger a benchmark analysis, **then** the system MUST deny the action with a permission error since `competitor:manage` requires Editor+ role.

## Open Questions / Blockers

- [NONE] — No critical blockers specific to M03. Note: real-time competitor monitoring is explicitly marked as P2 in Pack 01 and excluded from P1 scope.
