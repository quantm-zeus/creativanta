---
layer: index
canonical: false
last_updated: 2026-10-30
---

# Task cards — generated projection

Generated from [task catalog](agent_task_catalog.json); do not edit this projection. Reading sequence and evidence contract: [Agent Build Backlog](AGENT_BUILD_BACKLOG.md). All tasks are SPECIFIED; empty implementation evidence is not acceptance.

## P0-01 — Bootstrap repo, toolchain và CI

Phase: P0. Dependencies: none. Modules: auth, M23.

Pin Go toolchain/dependencies/codegen tools; one apps/api Go module with api/admin-api/worker/outbox/migrate commands; web/admin/mobile shells, local services and fail-closed CI.

Read: [auth.md](../02_features/platform/auth.md), [reporting_admin_billing.md](../02_features/platform/reporting_admin_billing.md), [tech_stack_adr.md](../05_system/tech_stack_adr.md), [docker_dev_environment.md](../06_quality_ops/docker_dev_environment.md), [ci_cd_pipeline.md](../06_quality_ops/ci_cd_pipeline.md).

Required outcomes:

- Clean checkout bootstraps with documented commands
- Failing command/smoke makes CI fail
- Go module/tool versions pinned; role-isolated process configuration; gofmt/vet/race/vulnerability checks wired and failing on violations

Implementation packet: `build/phase-P0/p0-01/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P0-02 — Transport, errors và request identity

Phase: P0. Dependencies: P0-01. Modules: S24, auth.

Compile common proto messages and TS/Go/Dart clients; validation, pagination, error and idempotency middleware.

Read: [public_api.md](../02_features/platform/public_api.md), [auth.md](../02_features/platform/auth.md), [protobuf_contracts.md](../04_contracts/protobuf_contracts.md).

Required outcomes:

- Three-language round trip
- Changed payload with same key conflicts
- Foreign cursor rejected
- TS Connect and Flutter gRPC/HTTP2 call the same Go handler; deadline, metadata, error and stream cancellation tested; no generated drift

Implementation packet: `build/phase-P0/p0-02/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P0-03 — Identity, workspace và personal onboarding

Phase: P0. Dependencies: P0-02. Modules: auth, M01.

Clerk session mapping, signup/recovery/MFA, invitations, workspace discovery and self-scoped progress.

Read: [auth.md](../02_features/platform/auth.md), [home_decision_engine.md](../02_features/platform/home_decision_engine.md).

Required outcomes:

- Delayed user webhook does not block login
- Non-owner discovers joined workspace
- Recovery revokes sessions
- Personal completion cannot change workspace settings

Implementation packet: `build/phase-P0/p0-03/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P0-04 — Tenant schema, RBAC và private projections

Phase: P0. Dependencies: P0-03. Modules: auth, M23, S26.

Slice migrations, grants, direct RLS, tenant FKs and response filtering.

Read: [auth.md](../02_features/platform/auth.md), [reporting_admin_billing.md](../02_features/platform/reporting_admin_billing.md), [internal_admin.md](../02_features/platform/internal_admin.md).

Required outcomes:

- Two-tenant and direct-junction attacks denied
- Last owner protected
- Member revocation enforced
- Private notes/secrets never serialized
- pgx/sqlc WithTx covers every tenant query; context isolation, rollback and Goose SQL migrations tested with app_user; money never converts through float

Implementation packet: `build/phase-P0/p0-04/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P0-05 — Outbox, inbox và unknown external effects

Phase: P0. Dependencies: P0-04. Modules: M23, S24.

Durable queues, audit, dedup, lease recovery and diagnostics.

Read: [reporting_admin_billing.md](../02_features/platform/reporting_admin_billing.md), [public_api.md](../02_features/platform/public_api.md), [queue_retry_design.md](../05_system/queue_retry_design.md).

Required outcomes:

- Kill before/after commit and ACK
- Duplicate webhook has one effect
- Unresolved external result never blindly retried

Implementation packet: `build/phase-P0/p0-05/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P0-06 — Credit lots, quotes và billing foundations

Phase: P0. Dependencies: P0-05. Modules: M23.

Versioned pricebook, lots, holds, debit/refund, expiry and billing sandbox.

Read: [reporting_admin_billing.md](../02_features/platform/reporting_admin_billing.md), [credit_accounting_contract.md](../04_contracts/credit_accounting_contract.md).

Required outcomes:

- Concurrent holds cannot overspend
- Late result and cycle boundary preserve lots
- Paid retry cannot exceed confirmed quote

Implementation packet: `build/phase-P0/p0-06/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P0-07 — Capability và internal-admin isolation

Phase: P0. Dependencies: P0-04, P0-05. Modules: M22, S26.

Account/action verification registry; isolated admin MFA, audit, moderation and kill switch foundation.

Read: [capability_matrix.md](../02_features/platform/capability_matrix.md), [internal_admin.md](../02_features/platform/internal_admin.md).

Required outcomes:

- Unverified route cannot execute
- Workspace role cannot call admin listener
- Impersonation is read-only

Implementation packet: `build/phase-P0/p0-07/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P0-08 — Shells, notifications và help entry

Phase: P0. Dependencies: P0-03, P0-07. Modules: M01, help, M23.

Web/mobile/admin navigation, loading/empty/error/repair, i18n/a11y base, scoped notification/help.

Read: [home_decision_engine.md](../02_features/platform/home_decision_engine.md), [help_center.md](../02_features/platform/help_center.md), [reporting_admin_billing.md](../02_features/platform/reporting_admin_billing.md).

Required outcomes:

- Six mode identities retained
- Unbuilt action unavailable with explanation
- No demo data in customer totals

Implementation packet: `build/phase-P0/p0-08/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P0-09 — Foundation acceptance

Phase: P0. Dependencies: P0-06, P0-08. Modules: auth, S24.

Run P0 integration gates and evidence pack; auth complete, service identity ready.

Read: [auth.md](../02_features/platform/auth.md), [public_api.md](../02_features/platform/public_api.md).

Required outcomes:

- Seed twice
- All P0 security/credit/recovery cases pass
- No future-phase RPC accidentally exposed

Implementation packet: `build/phase-P0/p0-09/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P1-01 — Products, SKU và import preview

Phase: P1. Dependencies: P0-09. Modules: M13.

Canonical catalog, variants, import mapping/preview and product-content refs.

Read: [product_hub.md](../02_features/commerce/product_hub.md), [data_migration_strategy.md](../06_quality_ops/data_migration_strategy.md).

Required outcomes:

- Two shops with same source ID remain separate
- Repeated rows no-op
- Invalid mappings need correction

Implementation packet: `build/phase-P1/p1-01/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P1-02 — Orders, stock ledger và reservations

Phase: P1. Dependencies: P1-01. Modules: M13.

Order ingestion/transitions, stock baselines, balances/holds and refund/return core.

Read: [product_hub.md](../02_features/commerce/product_hub.md), [inventory_computation_contract.md](../04_contracts/inventory_computation_contract.md).

Required outcomes:

- Inventory I01–I10 on PostgreSQL
- Historical imports do not double-deduct
- Partial refund followed by full refund works

Implementation packet: `build/phase-P1/p1-02/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P1-03 — Financial postings, FX và cost snapshots

Phase: P1. Dependencies: P1-02. Modules: M19.

Recognition, decimal/FX arithmetic, costs, settlement lines and correcting postings.

Read: [operating_ledger.md](../02_features/finance/operating_ledger.md), [financial_computation_contract.md](../04_contracts/financial_computation_contract.md).

Required outcomes:

- Independent F01–F09 values
- Settlement fee not duplicated
- Missing COGS never verified zero

Implementation packet: `build/phase-P1/p1-03/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P1-04 — Reconciliation, evidence và repair queue

Phase: P1. Dependencies: P1-03. Modules: M19, M01.

Match capacity, immutable proof, source/confidence drilldown and permission-filtered data gaps.

Read: [operating_ledger.md](../02_features/finance/operating_ledger.md), [home_decision_engine.md](../02_features/platform/home_decision_engine.md).

Required outcomes:

- Concurrent partial match cannot overallocate
- Evidence modification denied
- Finance gaps do not leak to Viewer

Implementation packet: `build/phase-P1/p1-04/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P1-05 — First-value loop và payment replay

Phase: P1. Dependencies: P1-04. Modules: M01, M19, M23.

Web/mobile import-to-profit loop, configured local brief, billing replay and pilot instrumentation.

Read: [home_decision_engine.md](../02_features/platform/home_decision_engine.md), [operating_ledger.md](../02_features/finance/operating_ledger.md), [reporting_admin_billing.md](../02_features/platform/reporting_admin_billing.md).

Required outcomes:

- No connector required for authorized import
- DST/timezone cannot double-deliver brief
- Payment replay cannot double-grant
- P1 pilot measurements record actual unknowns

Implementation packet: `build/phase-P1/p1-05/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P2-01 — Signals, scoring, search và watchlists

Phase: P2. Dependencies: P1-05. Modules: M02.

Authorized ingestion, trend lineage, scoring/freshness, alerts and searchable watchlist.

Read: [trend_radar.md](../02_features/intelligence/trend_radar.md).

Required outcomes:

- Source unavailable shows degraded data
- Threshold alerts deduplicate
- Tenant-scoped semantic search

Implementation packet: `build/phase-P2/p2-01/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P2-02 — Competitor registry và benchmark

Phase: P2. Dependencies: P2-01. Modules: M03.

Competitor imports/on-demand analysis, pricing/format comparison, white-space and notes.

Read: [competitor_intelligence.md](../02_features/intelligence/competitor_intelligence.md).

Required outcomes:

- Inferred insight labeled
- Stale snapshots visible
- No assumed access to competitor finance

Implementation packet: `build/phase-P2/p2-02/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P2-03 — Opportunity prioritization và ownership

Phase: P2. Dependencies: P2-02. Modules: M04.

Source links, scoring/reasons, state transitions, owners and Home intelligence.

Read: [opportunity_board.md](../02_features/intelligence/opportunity_board.md).

Required outcomes:

- Unassigned open items remain repairable
- Concurrent assign/convert conflicts
- No orphan opportunity

Implementation packet: `build/phase-P2/p2-03/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P2-04 — Intelligence acceptance và access proof

Phase: P2. Dependencies: P2-03. Modules: M02, M03, M04, M22.

P2 authorized-source and manual/import operating loop; downstream actions gated.

Read: [trend_radar.md](../02_features/intelligence/trend_radar.md), [competitor_intelligence.md](../02_features/intelligence/competitor_intelligence.md), [opportunity_board.md](../02_features/intelligence/opportunity_board.md), [capability_matrix.md](../02_features/platform/capability_matrix.md).

Required outcomes:

- Every live source has access evidence
- Future conversions remain assigned to later tasks
- Empty/degraded/audit paths pass

Implementation packet: `build/phase-P2/p2-04/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P3-01 — Ideas, hooks, dedup và mobile capture

Phase: P3. Dependencies: P2-04. Modules: M05.

Manual/trend/product ideas, hook bank, AI enrichment, state progression and capture.

Read: [idea_engine.md](../02_features/content/idea_engine.md).

Required outcomes:

- Duplicate idea warns without silent merge
- Source lineage retained
- Mobile title-only draft works

Implementation packet: `build/phase-P3/p3-01/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P3-02 — Scripts, approvals, versions và asset briefs

Phase: P3. Dependencies: P3-01. Modules: M06.

Structured scenes/shots, channel rewrite, approval conflict handling and production brief.

Read: [script_lab.md](../02_features/content/script_lab.md).

Required outcomes:

- Stale approval fails
- Rejection reason validated
- Ready-for-production requires approval and complete brief

Implementation packet: `build/phase-P3/p3-02/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P3-03 — Continuity packs, characters và consent

Phase: P3. Dependencies: P0-06, P3-02. Modules: M08.

Versioned packs, references, character setup, consent and slot gating; production preview completed in P4.

Read: [continuity_os.md](../02_features/content/continuity_os.md).

Required outcomes:

- Revoked consent blocks generation
- Pack updates retain old lineage
- Only one default character

Implementation packet: `build/phase-P3/p3-03/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P3-04 — Copilot read/creative assistance

Phase: P3. Dependencies: P3-03. Modules: copilot.

Permission-filtered workspace Q&A, help and quoted draft generation.

Read: [copilot.md](../02_features/platform/copilot.md).

Required outcomes:

- Contributor cannot delete product
- Read query cannot expose finance
- Generated script needs quote confirmation

Implementation packet: `build/phase-P3/p3-04/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P3-05 — Content handoffs và mobile review acceptance

Phase: P3. Dependencies: P3-04. Modules: M02, M04, M05, M06, M01.

Trend/opportunity-to-idea/script flow and mobile approvals; validate P3 ACs.

Read: [trend_radar.md](../02_features/intelligence/trend_radar.md), [opportunity_board.md](../02_features/intelligence/opportunity_board.md), [idea_engine.md](../02_features/content/idea_engine.md), [script_lab.md](../02_features/content/script_lab.md), [home_decision_engine.md](../02_features/platform/home_decision_engine.md).

Required outcomes:

- Source chain reaches approved brief
- Concurrent edits preserve data
- No publish side effects from creative assistant

Implementation packet: `build/phase-P3/p3-05/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P4-01 — Production jobs, router và budgets

Phase: P4. Dependencies: P3-05. Modules: M07.

Durable jobs, bounded quotes, provider adapters, BYOK, lineage, upload safety and post-production.

Read: [ai_video_studio.md](../02_features/production/ai_video_studio.md).

Required outcomes:

- Cancel/timeout/unknown-result recovery
- Fallback no double charge
- Budget preview and partial batch input validation
- FFmpeg/ffprobe arguments allowlisted; worker CPU/memory/disk/time limits and process-tree cancellation enforced; output validated before completion

Implementation packet: `build/phase-P4/p4-01/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P4-02 — Quick Edit

Phase: P4. Dependencies: P4-01. Modules: M07.

Text edits, captions, reframe, beat sync, B-roll, hook library and licensed audio.

Read: [ai_video_studio.md](../02_features/production/ai_video_studio.md).

Required outcomes:

- Poor ASR can be repaired
- Correct ratio/audio/subtitles
- Deleted text maps to intended segment

Implementation packet: `build/phase-P4/p4-02/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P4-03 — Clip Factory

Phase: P4. Dependencies: P4-02. Modules: M07.

Scene/transcript analysis, clip review, variants, scoring and batch outputs.

Read: [ai_video_studio.md](../02_features/production/ai_video_studio.md).

Required outcomes:

- No speech uses visual path
- Missing trend data labeled
- Each clip has source lineage

Implementation packet: `build/phase-P4/p4-03/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P4-04 — Multi-Merge và Remix

Phase: P4. Dependencies: P4-01. Modules: M07.

Multi-input timeline, creative-DNA analysis, licensed generation and originality gate.

Read: [ai_video_studio.md](../02_features/production/ai_video_studio.md).

Required outcomes:

- One canonical similarity threshold
- No unlicensed media bypass
- Foreign/DRM source has usable error

Implementation packet: `build/phase-P4/p4-04/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P4-05 — Showcase, Image/Link-to-Video và thumbnails

Phase: P4. Dependencies: P4-03, P4-04. Modules: M07.

EF01–04 production modes; product context, safe URL fetch and thumbnails.

Read: [ai_video_studio.md](../02_features/production/ai_video_studio.md).

Required outcomes:

- All listed styles/options
- SSRF/unsafe source blocked
- Missing product attributes explained

Implementation packet: `build/phase-P4/p4-05/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P4-06 — Translation, sound và voice

Phase: P4. Dependencies: P4-01, P3-03. Modules: M07, M08.

EF05–06 localization, dubbing, music/SFX/voice clone and post-production.

Read: [ai_video_studio.md](../02_features/production/ai_video_studio.md), [continuity_os.md](../02_features/content/continuity_os.md).

Required outcomes:

- Consent required
- Language/voice quality repair
- Licensed input and measured quote

Implementation packet: `build/phase-P4/p4-06/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P4-07 — Style learning và complete continuity

Phase: P4. Dependencies: P4-06. Modules: M07, M08.

EF07 style extraction/transfer, character preview, drift and reference/version QA.

Read: [ai_video_studio.md](../02_features/production/ai_video_studio.md), [continuity_os.md](../02_features/content/continuity_os.md).

Required outcomes:

- 15s preview quoted
- High drift blocks readiness
- Consent withdrawal prevents new use

Implementation packet: `build/phase-P4/p4-07/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P4-08 — Derivative library và packaging QA

Phase: P4. Dependencies: P4-05, P4-07. Modules: M09, M10.

Lineage/collections/bulk operations, QA components, presets, review and hard-block handling.

Read: [asset_derivatives.md](../02_features/production/asset_derivatives.md), [packaging_qa.md](../02_features/production/packaging_qa.md).

Required outcomes:

- 150-item partial batch results
- No lineage → routing denied
- Hard blocks cannot be workspace-overridden

Implementation packet: `build/phase-P4/p4-08/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P4-09 — Production integration acceptance

Phase: P4. Dependencies: P4-08. Modules: M02, M07, M08, M09, M10, gamification.

Trend-to-remix integration, all core/EF01–07 production ACs, durable event hooks.

Read: [trend_radar.md](../02_features/intelligence/trend_radar.md), [ai_video_studio.md](../02_features/production/ai_video_studio.md), [continuity_os.md](../02_features/content/continuity_os.md), [asset_derivatives.md](../02_features/production/asset_derivatives.md), [packaging_qa.md](../02_features/production/packaging_qa.md), [gamification.md](../02_features/platform/gamification.md).

Required outcomes:

- All four production modes exercised
- Provider route evidence or honest disabled path
- Future coaching/agent/gamification completion retained

Implementation packet: `build/phase-P4/p4-09/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P5-01 — Publish calendar, scheduling và native/manual proof

Phase: P5. Dependencies: P4-09. Modules: M11.

Per-target jobs, approval/capability recheck, schedule fairness and manual fallback.

Read: [publish_hub.md](../02_features/publish/publish_hub.md).

Required outcomes:

- Never publish before schedule
- Unknown submit reconciles
- Manual proof retains graph
- Token revoke pauses affected queued work

Implementation packet: `build/phase-P5/p5-01/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P5-02 — Inbox, entities, reply và SLA

Phase: P5. Dependencies: P5-01. Modules: M12.

Authorized message ingestion, triage, reply-as, assignments, suggestions and follow-up.

Read: [unified_inbox.md](../02_features/engagement/unified_inbox.md).

Required outcomes:

- Messaging-window denial
- Bot-loop/viral surge handling
- Ghost messages and revoked account repair

Implementation packet: `build/phase-P5/p5-02/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P5-03 — Metrics, attribution và derivative feedback

Phase: P5. Dependencies: P5-02. Modules: M09, M19, S16.

Channel post metrics and attributed order links, source rollups and confidence.

Read: [asset_derivatives.md](../02_features/production/asset_derivatives.md), [operating_ledger.md](../02_features/finance/operating_ledger.md), [creator_pro_tools.md](../02_features/commerce/creator_pro_tools.md).

Required outcomes:

- Workspace revenue counted once
- Missing denominators remain unknown
- Imported proof not upgraded to official

Implementation packet: `build/phase-P5/p5-03/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P5-04 — Distribution/engagement acceptance

Phase: P5. Dependencies: P5-03. Modules: M11, M12, M22.

Web/mobile publish/inbox loop across verified and manual routes.

Read: [publish_hub.md](../02_features/publish/publish_hub.md), [unified_inbox.md](../02_features/engagement/unified_inbox.md), [capability_matrix.md](../02_features/platform/capability_matrix.md).

Required outcomes:

- Five acceptance paths
- Replay with one external result
- Commerce/seeding actions retain P6 task links

Implementation packet: `build/phase-P5/p5-04/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P5-05 — Experiment Lab và Performance Coach

Phase: P5. Dependencies: P5-04. Modules: M07, M10.

EF09–10 analytics, thumbnails/video experiments and improvement feedback.

Read: [ai_video_studio.md](../02_features/production/ai_video_studio.md), [packaging_qa.md](../02_features/production/packaging_qa.md).

Required outcomes:

- Low exposure → inconclusive
- Observational label retained
- Scaling rechecks M11 gates

Implementation packet: `build/phase-P5/p5-05/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P6-01 — Offers, coupons, campaigns và experiments

Phase: P6. Dependencies: P5-05. Modules: M14.

Pricing/lifecycle, coupon redemption limits, campaign budgets and monetization coordination.

Read: [monetization_os.md](../02_features/commerce/monetization_os.md).

Required outcomes:

- Expired offer rejected at checkout
- Coupon races do not exceed limits
- Financial impact reaches ledger

Implementation packet: `build/phase-P6/p6-01/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P6-02 — Store, checkout, digital delivery và memberships

Phase: P6. Dependencies: P6-01, P1-02. Modules: M15, M13.

Store builder/domain/SEO/widgets, bundles, buyer entitlements and payment integration.

Read: [creator_store.md](../02_features/commerce/creator_store.md), [product_hub.md](../02_features/commerce/product_hub.md).

Required outcomes:

- Bundle stock atomic
- Payment replay no duplicate delivery
- Buyer subscription cannot unlock SaaS privileges

Implementation packet: `build/phase-P6/p6-02/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P6-03 — Affiliate links, attribution và payouts

Phase: P6. Dependencies: P6-01. Modules: M16, M19.

Creator assignments, links/coupons, statement imports, commissions/reversals and payout proof.

Read: [affiliate_network.md](../02_features/commerce/affiliate_network.md), [operating_ledger.md](../02_features/finance/operating_ledger.md).

Required outcomes:

- Creator income distinct from seller expense
- Ambiguous attribution labeled
- Broken link repair

Implementation packet: `build/phase-P6/p6-03/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P6-04 — Creator Pro v1 và brand deals

Phase: P6. Dependencies: P6-03. Modules: S16, M16.

Bio pages, media kits, rate cards, deal proof, content ROI and exports.

Read: [creator_pro_tools.md](../02_features/commerce/creator_pro_tools.md), [affiliate_network.md](../02_features/commerce/affiliate_network.md).

Required outcomes:

- Canonical deal lifecycle
- Phishing cannot be acknowledged away
- Zero-view RPM undefined
- All six modes can reach entitled tools

Implementation packet: `build/phase-P6/p6-04/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P6-05 — Live War Room và post-live highlights

Phase: P6. Dependencies: P6-01, P5-02. Modules: M17, M09.

Run-of-show, cues, live pin/manual controls, highlights and proof summary.

Read: [live_war_room.md](../02_features/commerce/live_war_room.md), [asset_derivatives.md](../02_features/production/asset_derivatives.md).

Required outcomes:

- Reconnect does not duplicate commands
- M07 extracts, M09 registers clips
- Revenue traceable and labeled

Implementation packet: `build/phase-P6/p6-05/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P6-06 — Seeding CRM và costs/outcomes

Phase: P6. Dependencies: P6-03, P5-02. Modules: M18.

Roster/sample requests, shipments, follow-up, content outcomes and seeding ROI.

Read: [seeding_crm.md](../02_features/commerce/seeding_crm.md).

Required outcomes:

- Request/shipment/outcome states separate
- Missing outcome not definitive zero
- Replay no duplicate sample cost

Implementation packet: `build/phase-P6/p6-06/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P6-07 — Fulfillment/refund and finance adapters

Phase: P6. Dependencies: P6-02, P6-04, P6-05, P6-06. Modules: M13, M19.

Complete commerce platform adapters, physical returns, partial refunds and stock/ledger reconciliation.

Read: [product_hub.md](../02_features/commerce/product_hub.md), [operating_ledger.md](../02_features/finance/operating_ledger.md).

Required outcomes:

- I01–I10 plus payment races
- Correcting fees preserve proof
- No double refund/restock

Implementation packet: `build/phase-P6/p6-07/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P6-08 — Cross-domain commerce conversions

Phase: P6. Dependencies: P6-07. Modules: M04, M05, M12.

Opportunity/idea/thread → campaign/live/offer/seeding/deal with shared lineage.

Read: [opportunity_board.md](../02_features/intelligence/opportunity_board.md), [idea_engine.md](../02_features/content/idea_engine.md), [unified_inbox.md](../02_features/engagement/unified_inbox.md).

Required outcomes:

- Each target permission rechecked
- Failed conversion atomic
- Source survives conversion

Implementation packet: `build/phase-P6/p6-08/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P6-09 — Commerce acceptance across web/mobile

Phase: P6. Dependencies: P6-08. Modules: M04, M05, M09, M12, M13, M14, M15, M16, M17, M18, S16.

Complete owning P6 ACs, operational repairs, mobile execution and scope reconciliation.

Read: [opportunity_board.md](../02_features/intelligence/opportunity_board.md), [idea_engine.md](../02_features/content/idea_engine.md), [asset_derivatives.md](../02_features/production/asset_derivatives.md), [unified_inbox.md](../02_features/engagement/unified_inbox.md), [product_hub.md](../02_features/commerce/product_hub.md), [monetization_os.md](../02_features/commerce/monetization_os.md), [creator_store.md](../02_features/commerce/creator_store.md), [affiliate_network.md](../02_features/commerce/affiliate_network.md), [live_war_room.md](../02_features/commerce/live_war_room.md), [seeding_crm.md](../02_features/commerce/seeding_crm.md), [creator_pro_tools.md](../02_features/commerce/creator_pro_tools.md).

Required outcomes:

- No function lost between modules
- Partial/unreconciled outcomes visible
- Actual provider/payment/shipping gate evidence

Implementation packet: `build/phase-P6/p6-09/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P7-01 — Workflow builder và complete node model

Phase: P7. Dependencies: P6-09. Modules: M20.

Owned canvas or entitled adapter; all triggers/nodes, validation, versions and imports.

Read: [workflow_studio.md](../02_features/automation/workflow_studio.md).

Required outcomes:

- Cycle/unbounded graph rejected
- Every node type round trip
- No embedding license assumed

Implementation packet: `build/phase-P7/p7-01/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P7-02 — Workflow runtime, preflight và approvals

Phase: P7. Dependencies: P7-01. Modules: M20.

Simulation, scoped execution, waits/approval expiry, resume/fallback/diagnostics and DLQ.

Read: [workflow_studio.md](../02_features/automation/workflow_studio.md).

Required outcomes:

- Simulation has no business effects
- Changed action invalidates approval
- Resume never replays confirmed effect

Implementation packet: `build/phase-P7/p7-02/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P7-03 — Recipe marketplace và governance

Phase: P7. Dependencies: P7-02. Modules: M21.

Install editable workflows, review/rating/versioning, submission/takedown and revenue share.

Read: [recipe_agent_center.md](../02_features/automation/recipe_agent_center.md).

Required outcomes:

- Install preserves canonical graph
- Missing capability explained
- Tenant/system template isolation

Implementation packet: `build/phase-P7/p7-03/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P7-04 — Agent runtime, Video Agent và Copilot actions

Phase: P7. Dependencies: P7-03. Modules: M21, M07, copilot.

Planning, bounded memory, approvals, budgets, handoff and one-click production orchestration.

Read: [recipe_agent_center.md](../02_features/automation/recipe_agent_center.md), [ai_video_studio.md](../02_features/production/ai_video_studio.md), [copilot.md](../02_features/platform/copilot.md).

Required outcomes:

- Every step checks delegated permissions
- Budget ceiling pauses
- Partial failure has audited handoff

Implementation packet: `build/phase-P7/p7-04/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P7-05 — Public API, webhooks và automation acceptance

Phase: P7. Dependencies: P7-04. Modules: S24, M20, M21.

Developer scopes/keys/rotation, outbound signatures/retries, quotas and P7 acceptance.

Read: [public_api.md](../02_features/platform/public_api.md), [workflow_studio.md](../02_features/automation/workflow_studio.md), [recipe_agent_center.md](../02_features/automation/recipe_agent_center.md).

Required outcomes:

- Read-only key cannot mutate
- Replay-safe outbound webhook
- All automation node/agent outcomes pass

Implementation packet: `build/phase-P7/p7-05/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P8-01 — Six-mode Home, mobile parity và onboarding completion

Phase: P8. Dependencies: P7-05. Modules: M01.

Complete decision/brief/learning paths and shared web/mobile surfaces.

Read: [home_decision_engine.md](../02_features/platform/home_decision_engine.md).

Required outcomes:

- All six mode priorities
- First-value and full-loop completion distinct
- Every shared UI state and route mapped

Implementation packet: `build/phase-P8/p8-01/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P8-02 — Full billing, reporting, retention và cost economics

Phase: P8. Dependencies: P8-01. Modules: M23, M19.

All payment methods behind access gates, add-ons, trial/dunning, exports/retention and complete financial reports.

Read: [reporting_admin_billing.md](../02_features/platform/reporting_admin_billing.md), [operating_ledger.md](../02_features/finance/operating_ledger.md).

Required outcomes:

- Cancellation differs from dunning
- Purchased credits preserved
- Restore/export/erase evidence
- Measured cohort economics

Implementation packet: `build/phase-P8/p8-02/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P8-03 — Internal admin, ops và capability completion

Phase: P8. Dependencies: P8-02. Modules: S26, M22.

Complete moderation/support/fraud/config/jobs/analytics tools and proactive capability coaching.

Read: [internal_admin.md](../02_features/platform/internal_admin.md), [capability_matrix.md](../02_features/platform/capability_matrix.md).

Required outcomes:

- Privileged role boundaries
- Hard-block appeal audit
- Technical health distinct from business metrics

Implementation packet: `build/phase-P8/p8-03/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P8-04 — Help, changelog, beta, status và support

Phase: P8. Dependencies: P8-03. Modules: help.

Full KB authoring/review, contextual help, beta/changelog/status and support SLAs.

Read: [help_center.md](../02_features/platform/help_center.md).

Required outcomes:

- Stale article review
- Beta grant once
- Incident notifications and subscription privacy

Implementation packet: `build/phase-P8/p8-04/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P8-05 — Referral, commissions và anti-fraud

Phase: P8. Dependencies: P8-02. Modules: referral.

Full referral tiers, qualification/hold/reversal, prompts and growth analytics.

Read: [referral_growth.md](../02_features/platform/referral_growth.md).

Required outcomes:

- No immediate qualified reward on pending payment
- Self-referral held for review
- Replay/refund reverses once

Implementation packet: `build/phase-P8/p8-05/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P8-06 — Gamification và style-template sharing

Phase: P8. Dependencies: P8-04, P8-05. Modules: gamification, M07, M21.

All XP/streak/quest/achievement rules and EF11; retained style-pack marketplace extension through recipe governance.

Read: [gamification.md](../02_features/platform/gamification.md), [ai_video_studio.md](../02_features/production/ai_video_studio.md), [recipe_agent_center.md](../02_features/automation/recipe_agent_center.md).

Required outcomes:

- Per-user progress
- Reward event replay once
- Licensed template install clones tenant-owned pack
- No private source media in shared style template

Implementation packet: `build/phase-P8/p8-06/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P8-07 — Competitor monitoring và brand collaboration expansion

Phase: P8. Dependencies: P8-03, P8-06. Modules: M03, S16.

Authorized continuous alerts, deal kanban, contract templates and opt-in creator directory/inquiries.

Read: [competitor_intelligence.md](../02_features/intelligence/competitor_intelligence.md), [creator_pro_tools.md](../02_features/commerce/creator_pro_tools.md).

Required outcomes:

- No source access → paused/import path
- Opt-out removes public snapshot immediately
- Sponsor cannot read private workspace; directory_reader cannot read hidden snapshots even with a forged tenant session setting
- Contract versions immutable

Implementation packet: `build/phase-P8/p8-07/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P8-08 — Security, accessibility, load và release rehearsal

Phase: P8. Dependencies: P8-07. Modules: M23, S26.

Full-surface a11y/i18n, security/load/restore/rollback and provider/legal review.

Read: [reporting_admin_billing.md](../02_features/platform/reporting_admin_billing.md), [internal_admin.md](../02_features/platform/internal_admin.md), [accessibility_spec.md](../06_quality_ops/accessibility_spec.md), [performance_benchmarks.md](../06_quality_ops/performance_benchmarks.md), [security_threat_model.md](../06_quality_ops/security_threat_model.md), [runbook.md](../06_quality_ops/runbook.md).

Required outcomes:

- Real restore and failing smoke
- No stale provider/license evidence
- Tenant/privacy tests across public and internal paths

Implementation packet: `build/phase-P8/p8-08/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.

## P8-09 — Full-scope acceptance và handoff

Phase: P8. Dependencies: P8-08. Modules: M01, M23.

Reconcile every section, PRD-derived AC, screen action, RPC and retained extension; evidence-backed release decision.

Read: [home_decision_engine.md](../02_features/platform/home_decision_engine.md), [reporting_admin_billing.md](../02_features/platform/reporting_admin_billing.md).

Required outcomes:

- Zero uncovered requirements
- No stub success or untracked remaining scope
- Unmet external gate remains explicit, no full launch claim

Implementation packet: `build/phase-P8/p8-09/manifest.json`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.
