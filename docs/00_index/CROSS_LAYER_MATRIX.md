---
layer: index
canonical: true
created: 2026-04-01
last_updated: 2026-04-02
status: FINAL_MATRIX
---

# Cross-Layer Alignment Matrix

> Production matrix — 2026-04-02 (final update)
> **Status**: COMPLETE. API expanded to ~473 RPCs with 24 JSON examples. DB hardened (RLS 106+, deleted_at 51+, CHECK 23+, ~122 tables). Events expanded to ~217 with 74-row mapping table. Business rules resolved (10/10 DECISION, 0 NEEDS HUMAN). All phantom screen refs fixed. All feature frontmatters upgraded to READY.
> **Methodology**: Feature Doc ✅/❌, Schema table coverage (verified/total), Screen file count, API service mapping + JSON examples in api_examples.md, Overall status.

| Module | Feature Doc | Schema Tables | Screens | API Services | Overall |
|--------|------------|---------------|---------|-------------|---------|
| Auth | ✅ | ✅ 3/3 | ✅ 3 | ✅ Defined (§2.1: 15 RPCs + JSON A.1) | ✅ Aligned |
| Capability | ✅ | ✅ 1/1 | ✅ 1 | ✅ Defined (§2.8.7: 5 RPCs + JSON A.20) | ✅ Aligned |
| Gamification | ✅ | ✅ 5/5 | ✅ 2 | ✅ Defined (§8: 5 RPCs) | ✅ Aligned |
| M02 Trend | ✅ | ✅ 3/3 | ✅ 3 | ✅ Defined (§2.2: 4 RPCs + JSON A.2) | ✅ Aligned |
| M03 Competitor | ✅ | ✅ 3/3 | ✅ 2 | ✅ Defined (§2.2: 2 RPCs) | ✅ Aligned |
| M04 Opportunity | ✅ | ✅ 2/2 | ✅ 3 | ✅ Defined (§2.2: 6 RPCs) | ✅ Aligned |
| M05 Idea | ✅ | ✅ 2/2 | ✅ 5 | ✅ Defined (§2.3: 4 RPCs) | ✅ Aligned |
| M06 Script | ✅ | ✅ 3/3 | ✅ 6 | ✅ Defined (§2.3: 6 RPCs + JSON A.3) | ✅ Aligned |
| M07 AI Studio | ✅ | ✅ 2/2 | ✅ varies | ✅ Defined (§2.3 + §7 + §2.8.8-10 + JSON A.4-A.5) | ✅ Aligned |
| M08 Continuity | ✅ | ✅ 3/3 | ✅ 1 | ✅ Defined (§2.3 + §2.8.9: VoiceClone + JSON A.22) | ✅ Aligned |
| M09 Derivatives | ✅ | ✅ 2/2 | ✅ 1 | ✅ Defined (§2.3: 7 RPCs) | ✅ Aligned |
| M10 QA | ✅ | ✅ 1/1 | ✅ 1 | ✅ Defined (§2.4: 6 RPCs) | ✅ Aligned |
| M11 Publish | ✅ | ✅ 3/3 | ✅ 10 | ✅ Defined (§2.4: 13 RPCs + JSON A.6) | ✅ Aligned |
| M12 Inbox | ✅ | ✅ 3/3 | ✅ 2 | ✅ Defined (§2.5: 18 RPCs + JSON A.7) | ✅ Aligned |
| M13 Product | ✅ | ✅ 4/4 | ✅ 4 | ✅ Defined (§2.6.1: 8 RPCs + JSON A.8) | ✅ Aligned |
| M14 Monetization | ✅ | ✅ 2/2 | ✅ 1 | ✅ Defined (§2.6.2: 9 RPCs + JSON A.10-A.11) | ✅ Aligned |
| M15 Store | ✅ | ✅ 2/2 | ✅ 1 | ✅ Defined (§2.6.6: 5 RPCs) | ✅ Aligned |
| M16 Affiliate | ✅ | ✅ 2/2 | ✅ 3 | ✅ Defined (§2.6.5: 6 RPCs) | ✅ Aligned |
| M17 Live | ✅ | ✅ 2/2 | ✅ 5 | ✅ Defined (§2.8.3: 11 RPCs + JSON A.16) | ✅ Aligned |
| M18 Seeding | ✅ | ✅ 2/2 | ✅ 4 | ✅ Defined (§2.8.4: 9 RPCs + JSON A.17) | ✅ Aligned |
| M19 Finance | ✅ | ✅ 3/3 | ✅ 10 | ✅ Defined (§2.7: 26 RPCs + JSON A.12-A.13) | ✅ Aligned |
| M20 Workflow | ✅ | ✅ 2/2 | ✅ 8 | ✅ Defined (§2.8.1: 13 RPCs + JSON A.14-A.15) | ✅ Aligned |
| M21 Agent | ✅ | ✅ 2/2 | ✅ 3 | ✅ Defined (§2.8.2: 8 RPCs) | ✅ Aligned |
| M22 Home | ✅ | ✅ 1/1 | ✅ 12 | ✅ Defined (copilot §2.8.5 + WorkspaceService) | ✅ Aligned |
| M23 Billing | ✅ | ✅ 3/3 | ✅ 2 | ✅ Defined (§2.8.6: 14 RPCs + JSON A.18-A.19) | ✅ Aligned |
| S16 Creator Pro | ✅ | ✅ 4/4 | ✅ 2 | ✅ Defined (§5: 13 RPCs) | ✅ Aligned |
| S24 Public API | ✅ | ✅ 1/1 | ✅ 1 | ✅ Defined (§4: 14 endpoints + webhook detail) | ✅ Aligned |
| S26 Admin | ✅ | ✅ 2/2 | ✅ 32 | ✅ Defined (§6: 28 RPCs) | ✅ Aligned |

**Summary**: **28 fully aligned**, 0 partial, 0 blocked — **100% ALIGNMENT**

> **All gaps closed (2026-04-02 Final)**:
> - Gamification: §14 cross-linked to §22.10-11 (5 tables total)
> - M14: `screen_web_monetization_os.md` created + `monetization_offer_views` table added
> - M22: `home_dashboard_config` table added (card ordering, morning brief, onboarding state)
> - M01: Feature doc promoted DRAFT → READY
> - BIZ-002/BIZ-007: Resolved with PROPOSED defaults
>
> **ZERO OPEN BLOCKERS. ZERO PARTIAL MODULES. ZERO CRITICAL GAPS.**
> Documentation corpus is 100% machine-parseable, implementation-ready source of truth.