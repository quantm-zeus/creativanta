---
layer: features
module: M05
canonical: true
domain: content
status: DRAFT
last_updated: 2026-03-30
---

# Feature: Idea Engine (M05)

## Purpose

Before any script or video can be produced, there must be a validated **idea** — a structured capture of what content to create, for whom, and why. Today, creators jot down ideas in scattered notes, screenshots, and chat messages with no way to trace why an idea exists, who it's for, or whether it was already covered.

M05 exists to **transform raw signals — trends, product data, comment sentiment, objections, and opportunities — into structured, scorable, convertible idea objects** with full source provenance. Every idea carries its origin story (why was this created?), audience intent, and a clear conversion path to scripts (M06), campaigns (M14), or live plans (M17).

## Scope

### Covers
- Idea creation from multiple source types: trend-led, product-led, comment/objection-led, offer-led, manual
- Idea state machine: draft → candidate → selected → converted | archived
- Source reference tracking via `idea_sources` junction table
- Hook bank integration (hooks attached to ideas)
- Angle and format suggestions (AI-powered)
- Idea scoring algorithm with audience/creator intent analysis
- Idea deduplication / clustering (embedding-based)
- Convert-to-script flow (idea → M06)
- Quick capture from mobile

### Does NOT cover (Non-goals for this module)
- Trend signal ingestion and scoring (owned by M02)
- Competitor insight generation (owned by M03)
- Opportunity board and state management (owned by M04)
- Script drafting, approval, and production handoff (owned by M06)
- Campaign creation logic (owned by M14)

## Actors

| Actor | Role | Primary Actions |
|---|---|---|
| Creator | Contributor+ | Capture ideas (quick/detailed), browse, score, convert to script |
| Seller | Editor+ | Create product-led ideas (from product catalog or comment clusters) |
| Affiliate Operator | Editor+ | Create offer-led ideas (from affiliate product opportunities) |
| Agency Manager | Manager+ | Review and curate team ideas, bulk archive/prioritize |
| System (AI) | System | Generate ideas from trends, score ideas, suggest hooks/angles/formats, dedup |

## Business Rules

1. **RULE-M05-001**: Every Idea MUST link back to at least one source object via `idea_sources` junction table. Valid source types: `trend`, `opportunity`, `product`, `thread`, `comment_cluster`, `objection`, `offer`, `manual`. Manual ideas use `source_type = 'manual'` with `source_id = user_id` (PRD §23.5 AC: "mỗi idea link được về source refs").
2. **RULE-M05-002**: Idea status MUST follow the canonical state machine: `draft → candidate → selected → converted | archived`. State skipping is forbidden — an idea cannot jump from `draft` directly to `converted` without passing through `candidate` and `selected` (DB schema §6.1).
3. **RULE-M05-003**: When an idea is converted to a script, the `converted_to_type` MUST be set to `'script'`, `converted_to_id` MUST reference the new script, and the event `idea.converted` MUST be emitted with `{idea_id, to_type: 'script', to_id}` (Domain event catalog §4).
4. **RULE-M05-004**: AI-generated ideas MUST carry `source_class = 'inferred'` and a `confidence` band. Hooks/angles suggested by AI MUST be labeled as AI-generated (PRD §15.2).
5. **RULE-M05-005**: Idea deduplication MUST use semantic similarity via `ideas.embedding` (pgvector). When a new idea's embedding similarity exceeds 0.85 with an existing idea in the same workspace, the system MUST warn the user about potential duplication — not silently block or auto-merge (DB schema §6.1 embedding column).
6. **RULE-M05-006**: Hooks attached to ideas MUST be stored in the `hooks` table with `hook_type` classification (question, shock, story, pov, listicle, contrast) and `source` attribution (manual, ai_generated, library) (DB schema §6.3).

## Main Flow

1. **User creates an idea**: manually or via "Create Idea from [Trend/Product/Comment]" CTA
   - calls `IdeaService/Create` (Contributor+)
   - writes to `ideas` table with `title`, `description`, `audience_intent`, `creator_intent`, `suggested_format`
   - writes to `idea_sources` junction with source reference(s)
   - emits `idea.created`
   - see [04_contracts/api_endpoint_map.md#2.3](../04_contracts/api_endpoint_map.md)
   - see [04_contracts/domain_event_catalog.md#4](../04_contracts/domain_event_catalog.md)
2. **AI enrichment** (optional): calls `IdeaService/Generate` (Editor+)
   - System generates hook suggestions, angle suggestions, format recommendations
   - Hook suggestions written to `hooks` table linked to `idea_id`
   - Idea scoring computed (`idea_score`) based on audience fit, trend relevance, competitive gap
3. **User browses and curates ideas**: calls `IdeaService/List`
   - Filterable by status, source type, score, format
   - Dedup warning shown for high-similarity ideas
4. **User promotes idea**: draft → candidate → selected (via status update)
5. **User converts idea to script**: calls `IdeaService/Convert` (Editor+)
   - System pre-fills script with idea's `description`, `suggested_format`, `cta_blocks` from hooks
   - State transitions to `converted`
   - New script created in M06 with `idea_id` reference
   - emits `idea.converted`
6. **Archival**: unconverted ideas can be archived — they remain queryable for historical analysis

## Alternate Flows

### A1: Idea from Trend (M02 Integration)
- Trigger: User clicks "Create Idea" on a trend card in Trend Radar
- Steps: System pre-fills idea with trend title, `why_now` context, and default `audience_intent` derived from trend data. `idea_sources` gets `(idea_id, 'trend', trend_id)`.
- Result: Idea in `draft` state with trend provenance

### A2: Idea from Comment Cluster (M12 Integration)
- Trigger: System detects a cluster of similar comments/DMs asking about the same topic
- Steps: AI generates an idea suggestion: "Your audience is asking about [topic]. Create content about it?" User confirms → idea created with `source_type = 'comment_cluster'`.
- Result: Idea with comment-driven provenance, hook suggestions based on actual audience language

### A3: Objection-Led Ideation
- Trigger: User or AI identifies recurring objections in threads (e.g., "too expensive", "doesn't work for [use case]")
- Steps: System generates idea addressing the objection. Source is `objection` pattern. Suggested format might be "Before/After" or "FAQ Response".
- Result: Idea designed to counter specific audience objections

### A4: Quick Capture from Mobile
- Trigger: User on mobile taps ➕ → "New Idea" from bottom nav Create tab
- Steps: Minimal form: title + optional voice note → system captures and creates draft idea
- Result: Draft idea ready for later enrichment on web

## Edge Cases

### EC-M05-001: Duplicate Idea Detection Across Source Types
- Condition: User creates an idea from a trend, then separately creates a similar idea from a product — both targeting the same content angle
- Expected behavior: System shows duplicate warning: "Similar idea exists: '[existing title]' — View existing or create anyway?" Both ideas preserved if user chooses to create. They share high embedding similarity but different source types.
- Reference: DB schema §6.1 (embedding), PRD §23.5 (dedupe/clustering)

### EC-M05-002: Source Object Deleted After Idea Creation
- Condition: A trend used as idea source expires or is archived
- Expected behavior: Idea remains valid with intact `idea_sources` entry. Source link in idea detail shows "Source trend has expired — view archived data" with read-only access. Idea's own data (title, description, hooks) is self-contained and not affected.
- Reference: Pack 02 §13 (archive strategy)

### EC-M05-003: AI-Generated Idea Spam
- Condition: User triggers `IdeaService/Generate` repeatedly, generating 50+ AI ideas in one session
- Expected behavior: Rate limit: Editor+ max 20 idea generations per hour per workspace. Beyond limit → 429 error with "Wait [N] minutes before generating more ideas." Generated ideas all carry `source_class = 'inferred'` and are in `draft` state — they do not pollute the active idea pipeline until user manually promotes.
- Reference: API endpoint map §2.3 rate limits

### EC-M05-004: Converting Idea Without Required Fields
- Condition: User tries to convert a `draft` idea that has only a title (no description, no hooks, no audience_intent)
- Expected behavior: System blocks conversion with validation error: "Idea needs at least a description and suggested format before converting to script. [Complete Idea]" — state remains unchanged.
- Reference: PRD §23.5 (idea có state rõ ràng)

## State Machine

Object: idea | DB column: `ideas.status`
see [04_contracts/database_schema.md#6.1](../04_contracts/database_schema.md)

| From | To | Trigger | Condition |
|---|---|---|---|
| — | draft | Idea created (manual, AI, or from source) | `title` populated |
| draft | candidate | User promotes idea | `description` + `suggested_format` populated |
| candidate | selected | User selects for execution | Review complete |
| selected | converted | User converts to script/campaign | `converted_to_type` + `converted_to_id` populated |
| draft/candidate/selected | archived | User archives | Any |
| archived | draft | User un-archives | Any |

## Related Contracts

| Topic | File | Section |
|---|---|---|
| DB tables | [04_contracts/database_schema.md](../04_contracts/database_schema.md) | §6.1 (ideas), §6.2 (idea_sources), §6.3 (hooks) |
| API | [04_contracts/api_endpoint_map.md](../04_contracts/api_endpoint_map.md) | §2.3 (IdeaService: Create, List, Generate, Convert) |
| Events | [04_contracts/domain_event_catalog.md](../04_contracts/domain_event_catalog.md) | §4 (idea.created, idea.converted) |
| RBAC | [04_contracts/rbac_permission_matrix.md](../04_contracts/rbac_permission_matrix.md) | §2.3 (idea:create — Contributor+; idea:generate — Editor+; idea:convert — Editor+) |

## Related Screens

| Platform | Screen | Notes |
|---|---|---|
| Web | Idea Library (list + detail) | Filterable, sortable, dedup warnings, score badges |
| Web | Idea Detail | Source provenance, hooks, angles, "Convert to Script" CTA |
| Mobile | Quick Capture (➕ Create → New Idea) | Minimal title + voice note, enrichment deferred |
| Mobile | Idea list view | Swipe to archive/convert, tap for detail |

## Acceptance Criteria

1. **Given** a user creates an idea from a trending topic, **when** the idea is stored, **then** the `idea_sources` table MUST contain an entry with `source_type = 'trend'` and `source_id` matching the trend — and the idea detail page MUST show a clickable "Source: [Trend Title]" link.

2. **Given** an idea in `draft` state, **when** the user attempts to convert it to a script, **then** the system MUST block the conversion if `description` or `suggested_format` are empty — the user MUST receive a message specifying which fields need to be completed.

3. **Given** a user creates a new idea with title "5 cách chăm sóc da mùa hè", **when** an existing idea with title "Hướng dẫn skincare mùa hè" exists with embedding similarity > 0.85, **then** the system MUST display a duplicate warning before saving — the user can choose to proceed or view the existing idea.

4. **Given** a user converts an idea to a script, **when** conversion completes, **then** the idea's `converted_to_type` MUST be `'script'`, `converted_to_id` MUST reference the new script, status MUST be `'converted'`, and the event `idea.converted` MUST be emitted.

5. **Given** a mobile user taps "New Idea" from the Create tab, **when** they enter only a title and tap save, **then** the system MUST create a `draft` idea with the title — no description or format is required for draft state.

## Open Questions / Blockers

- [NONE] — No critical blockers specific to M05 in OPEN_BLOCKERS.md.
