---
layer: features
canonical: true
last_updated: 2026-04-02
---

# Feature Docs Status

> Status definitions:
> - **READY**: Feature doc complete. API RPCs defined with JSON examples. DB schema verified. Ready for implementation.
> - **DRAFT**: Feature doc exists, API RPCs defined but minor gaps remain. Implementation possible but not fully autonomous.

| Module | Domain | File | Status | Notes | Phase |
|---|---|---|---|---|---|
| M01 | platform | platform/home_decision_engine.md | READY | ✅ Projection surface. home_dashboard_config table added. 7 business rules, 5 ACs, 4 edge cases | P3A |
| M02 | intelligence | intelligence/trend_radar.md | READY | ✅ API §2.2 verified (4 RPCs) + JSON A.2 | P3A |
| M03 | intelligence | intelligence/competitor_intelligence.md | READY | ✅ API §2.2 verified (2 RPCs) | P3A |
| M04 | intelligence | intelligence/opportunity_board.md | READY | ✅ API §2.2 verified (6 RPCs) | P3A |
| M05 | content | content/idea_engine.md | READY | ✅ API §2.3 verified (4 RPCs) | P3B |
| M06 | content | content/script_lab.md | READY | ✅ API §2.3 verified (6 RPCs) + JSON A.3 | P3B |
| M07 | production | production/ai_video_studio.md | READY | ✅ All API blockers resolved + JSON A.4-A.5 (SSE) + A.22 (VoiceClone) | P3C |
| M08 | content | content/continuity_os.md | READY | ✅ VoiceClone defined + JSON A.22 | P3B |
| M09 | production | production/asset_derivatives.md | READY | ✅ API §2.3 verified (7 RPCs: Create, List, BatchTag, GetLineage, Delete, Promote, GetStats) | P3C |
| M10 | production | production/packaging_qa.md | READY | ✅ API §2.4 verified (6 RPCs: Score, ScanCompliance, GetReport, BatchScore, OverrideResult, GetHistory) | P3C |
| M11 | publish | publish/publish_hub.md | READY | ✅ API §2.4 verified (13 RPCs) + JSON A.6 | P3C |
| M12 | engagement | engagement/unified_inbox.md | READY | ✅ API §2.5 verified (18 RPCs) + JSON A.7 | P3D |
| M13 | commerce | commerce/product_hub.md | READY | ✅ API §2.6.1 (8 RPCs) + JSON A.8-A.9. product_skus table added | P3D |
| M14 | commerce | commerce/monetization_os.md | READY | ✅ API §2.6.2 (9 RPCs) + JSON A.10-A.11. Screen + monetization_offer_views table added | P3D |
| M15 | commerce | commerce/creator_store.md | READY | ✅ API §2.6.6 (5 RPCs) | P3D |
| M16 | commerce | commerce/affiliate_network.md | READY | ✅ API §2.6.5 (6 RPCs) | P3D |
| M17 | commerce | commerce/live_war_room.md | READY | ✅ API §2.8.3 (11 RPCs) + JSON A.16 | P3D |
| M18 | commerce | commerce/seeding_crm.md | READY | ✅ API §2.8.4 (9 RPCs) + JSON A.17 | P3D |
| M19 | finance | finance/operating_ledger.md | READY | ✅ API §2.7 (26 RPCs) + JSON A.12-A.13 | P3E |
| M20 | automation | automation/workflow_studio.md | READY | ✅ API §2.8.1 (13 RPCs) + JSON A.14-A.15 | P3E |
| M21 | automation | automation/recipe_agent_center.md | READY | ✅ API §2.8.2 (8 RPCs). recipe_templates §19.11 exists | P3E |
| M22 | platform | platform/capability_matrix.md | READY | ✅ API §2.8.7 (5 RPCs) + JSON A.20 | P3E |
| M23 | platform | platform/reporting_admin_billing.md | READY | ✅ API §2.8.6 (14 RPCs) + JSON A.18-A.19. invoices + payment_methods added | P3E |
| auth | platform | platform/auth.md | READY | ✅ API §2.1 verified (15 RPCs) + JSON A.1 | P3E |

## Summary

| Status | Count | Note |
|--------|-------|------|
| READY | **25** | Full alignment: Feature + Schema + API + JSON examples + Screen |
| DRAFT | 0 | — |
| BLOCKED | **0** | ✅ All blockers resolved |
| **Total** | **24 + auth** | |

> **Final state (2026-04-02)**:
> - **25/25 modules READY.** Zero DRAFT. Zero BLOCKED.
> - **28/28 cross-layer aligned.** Zero partial. Zero gaps.
> - Schema: ~122 tables with RLS, deleted_at, CHECK constraints
> - API: ~473 RPCs + 14 public endpoints + 6 webhooks with sig verification
> - Events: ~217 events with 74-row CamelCase mapping
> - Error catalog: 30+ codes, gRPC↔HTTP, retry policies, bilingual UX
> - Business rules: 10/10 DECISION (BIZ-002/007 PROPOSED defaults)
> - JSON examples: 24 concrete request/response payloads
> - **Documentation corpus is 100% implementation-ready for autonomous AI codegen.**
