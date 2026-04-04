---
layer: features
module: M09
canonical: true
domain: production
status: READY
last_updated: 2026-03-30
---

# Feature: Asset Derivative Manager / Repurpose Hub (M09)

## Purpose

M07 (AI Video Studio) is a **production engine** — it creates clips, variants, remixes, and repurposed assets. But after an asset is produced, someone needs to **manage its lifecycle**: organize, tag, track lineage, batch-operate, and route derivatives toward packaging (M10) and publishing (M11). Without M09, derivatives pile up in an unstructured library with no way to trace which clip came from which source, which variant performed best, or which derivatives are ready for the next stage.

M09 exists as the **derivative lifecycle manager** — the organizational layer between production (M07) and distribution (M10/M11). It does NOT produce content; it manages what M07 produces.

## Scope

### Covers (M09 owns lifecycle management)
- Derivative library: browse, search, filter all clips/variants/remixes
- Clip/variant organizing: folders, tags, collections
- Lineage inspector: complete source → derivative → publish trail
- Batch operations: tag, archive, delete, queue publish (≥100 items)
- Live highlight management: organize highlights from M17
- Repurpose recommendations: AI suggests "Cut into 3 more clips?" from source asset
- Derivative performance tracking: metrics per derivative feeding back to source analytics
- Ratio/CTA/subtitle variant management

### Does NOT cover (M07 vs M09 boundary)
- **M07 owns**: all production (generation, editing, clipping, merging, remixing)
- M07 **creates** derivatives via `clip.extracted`, `remix.completed`, `asset.generation_completed` events → M09 **receives and manages** them
- Packaging and QA scoring (owned by M10)
- Publishing and scheduling (owned by M11)

## Actors

| Actor | Role | Primary Actions |
|---|---|---|
| Creator | Editor+ | Browse derivatives, organize, tag, batch operate, queue for publish |
| Manager | Manager+ | Bulk archive, curate collections, review derivative performance |
| System (Ingest) | System | Listen for M07 production events → auto-register derivative in library |
| System (AI) | System | Generate repurpose recommendations, auto-tag derivatives |

## Business Rules

1. **RULE-M09-001**: Every derivative asset MUST link back to its source asset via `assets.parent_asset_id`. Derivatives without source lineage are invalid and MUST NOT proceed to M10/M11. The lineage chain MUST be inspectable: source → derivative → derivative-of-derivative (if any) (PRD §23.9 AC, Pack 04 §9.3.5).
2. **RULE-M09-002**: Batch operations MUST support ≥100 items simultaneously. The system MUST handle partial failures gracefully: if 3 out of 100 tag operations fail, the remaining 97 MUST succeed, and the user MUST see a summary: "97/100 succeeded. 3 failed: [view details]." (PRD §23.9 AC).
3. **RULE-M09-003**: Derivative performance metrics (views, engagement, CTR) MUST feed back into source asset analytics. Source asset dashboard MUST show "Derivative Performance" section listing each derivative's metrics and a roll-up total. This enables "which clip performed best?" analysis (PRD §23.9: derivative performance tracking).
4. **RULE-M09-004**: Every derivative MUST have `derivative_type` (clip, variant, remix, repurpose, thumbnail) and `target_channel` metadata populated. Variants MUST additionally specify aspect ratio, CTA variant, or subtitle language (DB schema §7.3).
5. **RULE-M09-005**: When M07 emits `clip.extracted` or `asset.generation_completed` with `derivative_type`, M09 MUST auto-register the derivative in the library within 5 seconds. No manual intervention required for ingestion (Domain event catalog §5).
6. **RULE-M09-006**: Repurpose recommendations MUST be based on: (a) source asset content type, (b) existing derivative coverage (don't suggest what already exists), (c) trending formats from M02/M03. Recommendations appear as actionable CTA cards: "This 20-min video has 2 clips. [Generate 3 more clips?]" (PRD §23.9: repurpose recommendations).

## Main Flow

1. **Derivative auto-ingestion**: M07 produces clip/variant/remix → emits event → M09 listener auto-registers derivative in library with lineage link
2. **User browses derivative library**: `DerivativeService/List` (Member)
   - Filterable by: source asset, derivative type, channel, status, date range
   - Sortable by: performance metrics, creation date, Virality Score
3. **User organizes**: creates folders, applies tags, adds to collections
   - `DerivativeService/BatchTag` (Editor+)
4. **Lineage inspection**: user clicks "View lineage" → source → derivative chain visualized
   - `DerivativeService/GetLineage` (Member)
5. **Batch operations**: select 100+ derivatives → bulk tag / archive / queue publish
6. **Route to M10/M11**: user selects derivatives → marks as "Ready for Packaging" → enters M10 QA flow → M11 publish

## State Machine

### Derivative Readiness Lifecycle

| From | To | Trigger | Condition |
|---|---|---|---|
| — | ingested | M07 production event received | `clip.extracted`, `remix.completed`, or `asset.generation_completed` with `derivative_type` |
| ingested | organized | User tags/folders derivative | Manual organization action |
| ingested / organized | ready_for_packaging | User marks "Ready" | User routes derivative to M10 QA flow |
| ready_for_packaging | packaging | M10 QA panel opens | Derivative enters packaging score evaluation |
| packaging | packaged | QA checks pass | Packaging score ≥ threshold |
| packaged | queued_for_publish | User adds to M11 queue | `PublishService/Schedule` called |
| any (except archived) | archived | User or batch archives | Soft delete with `deleted_at`, reversible |
| archived | ingested | User restores | Unarchive action |

> Notes:
> - Derivatives without `parent_asset_id` (lineage) are blocked from `ready_for_packaging` → `packaging` transition (RULE-M09-001).
> - Batch operations may move collections of derivatives through states simultaneously, with partial failure handling (RULE-M09-002).

## Edge Cases

### EC-M09-001: Derivative Source Asset Deleted
- Condition: Source asset is deleted (soft delete) while 10 derivatives reference it
- Expected behavior: Derivatives remain valid and usable. Lineage inspector shows "Source asset: [archived/deleted] — view archived record." Derivatives can still proceed to M10/M11. Source performance roll-up shows "Source unavailable."
- Reference: DB-H-003 (soft delete), RULE-M09-001

### EC-M09-002: Batch Operation on 500+ Items Timeout
- Condition: User selects 500 derivatives for batch tagging → operation exceeds request timeout
- Expected behavior: System converts to async batch job. User sees: "Batch operation queued (500 items). You'll be notified when complete." Progress tracked via job ID. Partial results available in real-time.
- Reference: RULE-M09-002

### EC-M09-003: Duplicate Derivative Detection
- Condition: Clip Factory generates a clip, then user manually creates a near-identical clip from the same source, same time range
- Expected behavior: System warns: "A similar clip from this source already exists (same time range ±5s). [View existing] [Create anyway]." Both derivatives preserved if user proceeds — no silent deduplication.
- Reference: Pack 04 §9.3.5

### EC-M09-004: Performance Data Lag for Recent Derivatives
- Condition: Derivative published 2 hours ago — no performance data yet from platform API
- Expected behavior: Performance card shows "⏳ Collecting data... Performance metrics typically available within 6-24 hours." Source asset roll-up excludes this derivative from calculations until data arrives. No zeros shown.
- Reference: RULE-M09-003

## Related Contracts

| Topic | File | Section |
|---|---|---|
| DB tables | [04_contracts/database_schema.md](../../04_contracts/database_schema.md) | §7.3 (assets — parent_asset_id, derivative_type) |
| API | [04_contracts/api_endpoint_map.md](../../04_contracts/api_endpoint_map.md) | §2.3 (DerivativeService: List, BatchTag, GetLineage) |
| Events consumed | [04_contracts/domain_event_catalog.md](../../04_contracts/domain_event_catalog.md) | §5 (clip.extracted, remix.completed, asset.generation_completed) |
| RBAC | [04_contracts/rbac_permission_matrix.md](../../04_contracts/rbac_permission_matrix.md) | §2.4 (derivative:list — Member; derivative:batch_tag — Editor+) |

## Related Screens

| Platform | Screen | Notes |
|---|---|---|
| Web | Derivative Library (grid + list view) | Filterable by source/type/channel, lineage breadcrumbs |
| Web | Lineage Inspector | Visual tree: source → derivatives with performance badges |
| Web | Batch Operation dashboard | Progress indicator, partial failure summary |
| Mobile | Derivative list (swipe cards) | Approve, quick tag, queue publish |
| Mobile | Quick share derivative | Share directly from mobile library |

## Acceptance Criteria

1. **Given** Clip Factory (M07) extracts 5 clips from a source video, **when** the `clip.extracted` events fire, **then** M09 MUST auto-register all 5 clips in the derivative library within 5 seconds — each with `parent_asset_id` pointing to the source and `derivative_type = 'clip'`.

2. **Given** a user selects 150 derivatives and applies a batch tag operation, **when** 3 fail due to permission errors, **then** the remaining 147 MUST succeed — and the user MUST see: "147/150 succeeded. 3 failed: [view details]."

3. **Given** a derivative clip has been published for 48 hours, **when** the user views the source asset dashboard, **then** the "Derivative Performance" section MUST show the clip's metrics (views, engagement, CTR) and a roll-up total across all derivatives.

4. **Given** a user clicks "View lineage" on a remix, **when** the lineage tree loads, **then** it MUST show the complete chain: source asset → remix → any subsequent derivatives — with clickable links to each node.

5. **Given** a derivative with no `parent_asset_id` is detected, **when** the system validates it for M10/M11 routing, **then** it MUST block with: "Missing source lineage. Cannot proceed to packaging/publish without source attribution."

## Open Questions / Blockers

- [NONE] — No critical blockers specific to M09 in OPEN_BLOCKERS.md.

---

## Content Repurpose Pipeline (PRD §35)

> This section describes the end-to-end batch repurpose flow that spans M07 (production) → M09 (management) → M10 (packaging) → M11 (publish).

### Batch Repurpose Flow

1. User uploads long-form content (video, podcast, article)
2. System analyzes content → proposes derivative plan:
   - N short clips (via M07 Clip Factory)
   - Text posts (script excerpts adapted per platform)
   - Thumbnails (via M07 Thumbnail Studio)
3. User reviews proposed plan with estimated credit cost
4. User confirms → system generates all derivatives as **DRAFTS**
5. `asset.generation_completed` events fire → M09 auto-registers all derivatives
6. User reviews derivatives in M09 batch review interface
7. User approves/edits selected derivatives → marks "Ready for Packaging"
8. Approved derivatives enter M10 QA → M11 batch publish scheduling

### Tier Limits for Repurpose

| Tier | Max Source Duration | Max Derivatives Per Batch |
|---|---|---|
| Free | 5 minutes | 3 clips + 1 text + 1 thumbnail |
| Starter | 15 minutes | 10 clips + 3 text + 3 thumbnails |
| Pro | 60 minutes | 20 clips + 10 text + 5 thumbnails |
| Business | 120 minutes | 50 clips + 20 text + 10 thumbnails |

### Acceptance Scenario

```gherkin
Feature: Content Repurpose Pipeline
  Scenario: Batch repurpose from long video
    Given a Pro user uploads a 10-minute video
    When the system analyzes the video
    Then a repurpose plan is proposed: "5 clips + 3 text posts + 2 thumbnails"
    And estimated credit cost is shown: "45 credits"
    When user confirms the plan
    Then all derivatives are generated as DRAFTS
    And each derivative appears in M09 library with lineage to source
    And user can batch-approve selected derivatives for M10/M11

  Scenario: Free tier repurpose limit
    Given a Free user attempts to repurpose a 30-minute video
    When the system checks tier limits
    Then repurpose is blocked: "Free tier supports videos up to 5 minutes. [Upgrade] to process longer content."
```
