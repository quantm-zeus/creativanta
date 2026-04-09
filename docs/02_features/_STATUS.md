---
layer: features
canonical: true
last_updated: 2026-04-09
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
| — | **Supplementary Specs** | — | — | — | — |
| S16 | commerce | commerce/creator_pro_tools.md | READY | ✅ API §5 (7 services, 28+ RPCs). Link-in-Bio, Media Kit, Brand Deals | P3E |
| S24 | platform | platform/public_api.md | READY | ✅ API §4 (2 services). API keys, webhooks, OAuth scopes | P3E |
| S26 | platform | platform/internal_admin.md | READY | ✅ API §6 + §34 (8 services, 200+ RPCs). Internal admin panel | P3E |
| copilot | platform | platform/copilot.md | READY | ✅ API §2.8 CopilotService (5 RPCs) | P3E |
| referral | platform | platform/referral_growth.md | READY | ✅ API §2.8.11 ReferralService (5 RPCs) + JSON A.21 | P3E |
| gamification | platform | platform/gamification.md | READY | ✅ API §8 GamificationService (6 RPCs) | P3E |
| help | platform | platform/help_center.md | READY | ✅ Help Center, Changelog, Beta, Status Page | P3E |

## Summary

| Status | Count | Note |
|--------|-------|------|
| READY | **31** | Doc-spec alignment: Feature + Schema + API service name + JSON examples + Screen (see caveats below) |
| DRAFT | 0 | — |
| BLOCKED | **0** | No feature-doc-specific blockers remain in this file. Global corpus blockers still exist in `00_index/OPEN_BLOCKERS.md`. |
| **Total** | **31** | 23 core (M01-M23) + auth + 3 supplementary (copilot, referral, help) + 3 specs (S16, S24, S26) + gamification |

> **Feature-doc state (2026-04-08)**:
> - **31/31 feature modules READY.** Zero DRAFT. Zero feature-doc-specific blockers. All M07 API blockers (API-C-001, API-H-001, API-H-002) remain resolved. Includes 23 core (M01-M23) + auth + 7 supplementary/spec modules.
> - **28/28 doc-spec aligned** (feature doc ↔ schema ↔ screens ↔ API service name) and **full-contract aligned** for screen-referenced API usage. All previously missing screen RPCs were promoted to canonical definitions in `api_endpoint_map.md`.
> - Schema: canonicalized for workflow/agent step persistence, public API usage/webhooks, KB content, admin broadcasts, and operational queue tables.
> - API: canonical map remains the authoring source during docs phase; `/protos/` are generated from `api_endpoint_map.md` + `api_examples.md` during implementation Phase 1 per ADR-005.
> - Events: 225 canonical event types with 74-row CamelCase mapping
> - Error catalog: canonical coverage across all active domains, gRPC↔HTTP, retry policies, bilingual UX
> - Business rules: 10/10 DECISION (BIZ-002/007 FINALIZED)
> - JSON examples: 24 concrete request/response payloads
>
> **Readiness caveats**:
> - Feature docs: READY (all 31/31 — 23 core M01-M23 + auth + 7 supplementary/spec modules).
> - Screen docs: use `03_screens/SCREEN_IMPLEMENTATION_PROTOCOL.md` whenever a legacy screen contains conceptual aliases or placeholder data-binding rows.
> - Contract docs: spec-complete; generated transport artifacts remain deferred implementation derivatives until typed codegen starts.
> - Ops docs: executable seed SQL now exists; CI/CD remains a canonical spec until code scaffolding is generated.
> - **Do not read this file as a launch-approval verdict.** As of 2026-04-09, the remaining corpus caveats are deferred `.proto` generation and external legal sign-off; internal documentation blockers have been remediated in `OPEN_BLOCKERS.md`.
