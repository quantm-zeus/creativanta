---
layer: index
canonical: true
last_updated: 2026-03-30
---

# Build Index — Creativanta System Map

## 1. System Overview

Creativanta is a **Proofed Trend-to-Profit Operating System** for creator commerce. It unifies 23 modules spanning intelligence, content, production, publishing, engagement, commerce, finance, and automation into a single operating graph — enabling creators and operators to turn signals into profit with proof, trust, and systematic workflows across web and mobile.

## 2. Domain Map — 24 Entries (23 Modules + Auth)

| Module | Name | Domain | Feature Doc (target) | Build Phase |
|--------|------|--------|----------------------|-------------|
| M01 | Home / Daily Decision Engine | platform | 02_features/platform/home_decision_engine.md | P3A |
| M02 | Trend Fusion Radar | intelligence | 02_features/intelligence/trend_radar.md | P3A |
| M03 | Research & Competitor Intelligence | intelligence | 02_features/intelligence/competitor_intelligence.md | P3A |
| M04 | Opportunity Board | intelligence | 02_features/intelligence/opportunity_board.md | P3A |
| M05 | Idea Engine | content | 02_features/content/idea_engine.md | P3B |
| M06 | Script Lab | content | 02_features/content/script_lab.md | P3B |
| M07 | AI Video Studio | production | 02_features/production/ai_video_studio.md | P3C |
| M08 | Continuity OS | content | 02_features/content/continuity_os.md | P3B |
| M09 | Asset Derivative Manager | production | 02_features/production/asset_derivatives.md | P3C |
| M10 | Packaging QA | production | 02_features/production/packaging_qa.md | P3C |
| M11 | Publish Hub | publish | 02_features/publish/publish_hub.md | P3C |
| M12 | Unified Inbox & Engagement | engagement | 02_features/engagement/unified_inbox.md | P3D |
| M13 | Product Hub / Inventory | commerce | 02_features/commerce/product_hub.md | P3D |
| M14 | Monetization OS | commerce | 02_features/commerce/monetization_os.md | P3D |
| M15 | Creator Store / Offers | commerce | 02_features/commerce/creator_store.md | P3D |
| M16 | Affiliate Network | commerce | 02_features/commerce/affiliate_network.md | P3D |
| M17 | Live Commerce War Room | commerce | 02_features/commerce/live_war_room.md | P3D |
| M18 | Seeding / Sample CRM | commerce | 02_features/commerce/seeding_crm.md | P3D |
| M19 | Operating Ledger / Profit | finance | 02_features/finance/operating_ledger.md | P3E |
| M20 | Workflow Studio | automation | 02_features/automation/workflow_studio.md | P3E |
| M21 | Recipe / Agent Center | automation | 02_features/automation/recipe_agent_center.md | P3E |
| M22 | Capability Matrix | platform | 02_features/platform/capability_matrix.md | P3E |
| M23 | Reporting / Admin / Billing | platform | 02_features/platform/reporting_admin_billing.md | P3E |
| auth | Auth & Session (cross-cutting) | platform | 02_features/platform/auth.md | P3E |
| — | **Supplementary Specs** | — | — | — |
| copilot | Copilot (AI Operations Assistant) | platform | 02_features/platform/copilot.md | P3E |
| referral | Referral & Growth Engine | platform | 02_features/platform/referral_growth.md | P3E |
| help | Help Center, Changelog & Beta | platform | 02_features/platform/help_center.md | P3E |

## 3. Cross-Domain Dependency Graph

```
M01 (Home) ← receives data from:
  ├── M02 (Trend)        — trending signals, opportunities
  ├── M04 (Opportunity)  — decision cards, priorities
  ├── M12 (Inbox)        — urgent threads, SLA breaches
  ├── M13 (Product)      — stock alerts, order anomalies
  └── M19 (Profit)       — profit snapshots, anomalies

M07 (AI Studio) ← depends on:
  ├── M08 (Continuity)   — character/brand/voice packs
  ├── M02/M03 (Trend)    — trend data for content direction
  └── M13 (Product)      — product data for showcase generation

M09 (Derivatives) ← receives output from:
  ├── M07 (AI Studio)    — generated assets → derivatives
  └── M17 (Live)         — live highlights → clips

M11 (Publish) → M19 (Profit):
  └── publish logs = revenue evidence

M12 (Inbox) → conversions to:
  ├── M05 (Ideas)        — comment → idea
  ├── M18 (Seeding)      — inquiry → sample request
  └── M14 (Monetization) — thread → offer/coupon

M16 (Affiliate) → M19:
  └── attributed revenue → operating ledger

M19 (Profit) ← aggregates from:
  ├── M11 (Publish)      — publish-driven revenue evidence
  ├── M13 (Product)      — order/settlement data
  ├── M16 (Affiliate)    — commission/affiliate revenue
  ├── M17 (Live)         — live commerce revenue
  └── M18 (Seeding)      — seeding-driven conversions

M20/M21 (Workflow/Recipe):
  └── uses canonical objects from ALL modules
```

## 4. Reading Order by Task (14 Scenarios)

| Task | Files to read, in order |
|------|------------------------|
| Implement auth | 02_features/platform/auth.md → 04_contracts/api_endpoint_map.md#identity → 04_contracts/rbac_permission_matrix.md → 03_screens/web/screen_web_auth_*.md |
| Build order lifecycle | 02_features/commerce/product_hub.md → 04_contracts/database_schema.md#orders → 04_contracts/domain_event_catalog.md#commerce → 05_system/queue_retry_design.md |
| AI video generation | 02_features/production/ai_video_studio.md → 05_system/ai_provider_guide.md → 04_contracts/database_schema.md#generation_jobs → 04_contracts/protobuf_contracts.md |
| Add platform connector | 04_contracts/connector_specs.md → 05_system/sequence_diagrams.md#connector-sync → 04_contracts/api_endpoint_map.md#connectors → 06_quality_ops/qa_acceptance_packs.md |
| Debug publish failure | 02_features/publish/publish_hub.md → 04_contracts/api_endpoint_map.md#publish → 05_system/sequence_diagrams.md#publish-flow → 03_screens/web/screen_web_publish_diagnostics.md |
| Build workflow | 02_features/automation/workflow_studio.md → 05_system/runtime_workflow.md → 05_system/queue_retry_design.md → 04_contracts/domain_event_catalog.md#workflow |
| Implement billing | 01_business/pricing_and_credits.md → 02_features/platform/reporting_admin_billing.md → 04_contracts/database_schema.md#billing → 04_contracts/api_endpoint_map.md#admin |
| Build profit / reconciliation | 02_features/finance/operating_ledger.md → 04_contracts/database_schema.md#finance → 04_contracts/domain_event_catalog.md#finance → 05_system/sequence_diagrams.md |
| Setup dev environment | 06_quality_ops/docker_dev_environment.md → 05_system/tech_stack_adr.md → 04_contracts/database_schema.md |
| New table with RLS | 04_contracts/database_schema.md → 00_index/OPEN_BLOCKERS.md#DB-C-001 → 06_quality_ops/security_threat_model.md |
| Build live commerce | 02_features/commerce/live_war_room.md → 04_contracts/api_endpoint_map.md#live → 04_contracts/domain_event_catalog.md#live → 05_system/sequence_diagrams.md |
| Write QA test for feature | 00_index/ACCEPTANCE_TESTS.md → 02_features/<domain>/<feature>.md → 06_quality_ops/qa_acceptance_packs.md |
| Build continuity system | 02_features/content/continuity_os.md → 04_contracts/database_schema.md#continuity → 05_system/ai_media_continuity.md → 05_system/ai_provider_guide.md |
| Build Daily Brief | 02_features/platform/home_decision_engine.md → 04_contracts/database_schema.md#decision → 05_system/queue_retry_design.md#morning-brief → 06_quality_ops/notification_templates.md |

## 5. What AI MUST NOT Do

1. NEVER read `docs/03_screens/` before reading the corresponding `docs/02_features/` doc
2. NEVER invent field names — check `04_contracts/database_schema.md`
3. NEVER invent event names — check `04_contracts/domain_event_catalog.md`
4. NEVER work around a CRITICAL blocker in `00_index/OPEN_BLOCKERS.md` silently
5. NEVER treat `docs/90_archive/` as canonical source — read-only history
6. NEVER duplicate content between layers — use cross-links only
7. NEVER use REAL or FLOAT for money/credit fields — see DB-H-001
8. NEVER skip RBAC checks — every action needs `04_contracts/rbac_permission_matrix.md`
9. WHEN PRD and design pack conflict — PRD §23 wins. Write `[CONFLICT]` note, ask human
10. NEVER modify archived files in `docs/90_archive/`
11. NEVER create DB tables without `ENABLE ROW LEVEL SECURITY` + `FORCE ROW LEVEL SECURITY` — see DB-C-001
12. NEVER create shadow objects that bypass canonical One Graph — see PRD §12
13. NEVER collapse operator modes into fewer than 6 — all 6 are canonical (PRD §8.2)
14. NEVER assign money/profit calculations to frontend — always use finance/proof layer (PRD §28.5)
15. NEVER build a module as an island surface disconnected from the Unified Operating Loop (PRD §10)
