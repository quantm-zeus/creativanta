---
layer: index
canonical: true
last_updated: 2026-04-06
---

# Requirements Traceability Matrix

This matrix is the implementation traceability backbone for the documentation corpus. It answers: for each module/spec, which business source defines intent, which feature doc defines behavior, which downstream artifacts define UI/contracts/runtime, and which quality pack validates it.

## 1. Traceability Rules

- Business intent is owned by `docs/01_business/` and the upstream PRD section referenced in each feature doc.
- Behavioral requirements are owned by `docs/02_features/`.
- Schema/API/event/RBAC requirements are owned by `docs/04_contracts/`.
- Runtime/async/provider behavior is owned by `docs/05_system/`.
- UI route/layout/state details are owned by `docs/03_screens/` subject to `SCREEN_IMPLEMENTATION_PROTOCOL.md`.
- Acceptance and operational validation are owned by `docs/06_quality_ops/` and `docs/00_index/ACCEPTANCE_TESTS.md`.

## 2. Matrix

| Domain | Module | Business Source | Feature Spec | Screen Coverage | Contract Coverage | Runtime Coverage | Quality / Ops Coverage |
|---|---|---|---|---|---|---|---|
| Platform | auth | `product_overview.md`, `user_segments_and_modes.md` | `platform/auth.md` | Web auth screens | Identity + RBAC + errors | ADR + runtime auth flow | Acceptance tests + threat model |
| Platform | M01 | `product_overview.md`, `business_rules.md` | `platform/home_decision_engine.md` | Home web/mobile screens | Workspace + brief + notifications | queue/retry + analytics | QA packs + analytics taxonomy |
| Intelligence | M02 | `product_overview.md` | `intelligence/trend_radar.md` | Trend screens | trend schema/API/events/RBAC | cache/search | QA packs + perf |
| Intelligence | M03 | `product_overview.md` | `intelligence/competitor_intelligence.md` | Competitor screens | competitor contracts | cache/search | QA packs |
| Intelligence | M04 | `product_overview.md`, `business_rules.md` | `intelligence/opportunity_board.md` | Opportunity screens | opportunity contracts | queue/retry | QA packs |
| Content | M05 | `product_overview.md` | `content/idea_engine.md` | Idea screens | ideas contracts | copilot/runtime as needed | QA packs |
| Content | M06 | `product_overview.md` | `content/script_lab.md` | Script screens | scripts/contracts | runtime workflow for approvals | QA packs |
| Production | M07 | `product_overview.md`, `legal_compliance.md` | `production/ai_video_studio.md` | Studio screens | generation/asset/voice contracts | ai provider guide + media continuity | perf + threat model + QA |
| Content | M08 | `product_overview.md` | `content/continuity_os.md` | Continuity screens | continuity/voice contracts | ai media continuity | QA packs |
| Production | M09 | `product_overview.md` | `production/asset_derivatives.md` | Derivatives screen | derivative contracts | runtime queues | QA packs |
| Production | M10 | `business_rules.md` | `production/packaging_qa.md` | Packaging QA screens | packaging contracts | queue/retry | QA packs |
| Publish | M11 | `business_rules.md` | `publish/publish_hub.md` | Publish screens | publish/contracts/events | sequence diagrams + queue/retry | QA packs + notifications |
| Engagement | M12 | `user_segments_and_modes.md` | `engagement/unified_inbox.md` | Inbox/contact screens | thread/entity/contracts | runtime workflow + notifications | QA packs |
| Commerce | M13 | `product_overview.md`, `pricing_and_credits.md` | `commerce/product_hub.md` | Product screens | product/order contracts | connector flows | QA packs |
| Commerce | M14 | `pricing_and_credits.md` | `commerce/monetization_os.md` | Monetization screens | offer/coupon/campaign contracts | sequence diagrams | QA packs |
| Commerce | M15 | `pricing_and_credits.md` | `commerce/creator_store.md` | Store screens | store/membership contracts | connector/runtime as needed | QA packs |
| Commerce | M16 | `pricing_and_credits.md`, `business_rules.md` | `commerce/affiliate_network.md` | Affiliate + Creator Pro screens | affiliate/revenue contracts | sequence diagrams | QA packs |
| Commerce | M17 | `business_rules.md` | `commerce/live_war_room.md` | Live screens | live contracts/events | queue/retry + runtime | perf + QA packs |
| Commerce | M18 | `business_rules.md` | `commerce/seeding_crm.md` | Seeding screens | sample/shipment contracts | queue/retry | QA packs |
| Finance | M19 | `business_rules.md`, `glossary.md`, `pricing_and_credits.md` | `finance/operating_ledger.md` | Finance screens | profit/settlement/reconciliation/proof contracts | sequence diagrams + queue/retry | QA packs + analytics + security |
| Automation | M20 | `business_rules.md` | `automation/workflow_studio.md` | Workflow screens | workflow contracts/events/RBAC | runtime_workflow + queue/retry | QA packs + notifications |
| Automation | M21 | `business_rules.md` | `automation/recipe_agent_center.md` | Recipe/agent screens | recipe/agent contracts/events | runtime_workflow + queue/retry | QA packs |
| Platform | M22 | `product_overview.md`, `business_rules.md` | `platform/capability_matrix.md` | Capability screens | capability/contracts/events | cache/search + provider health | QA packs |
| Platform | M23 | `pricing_and_credits.md`, `legal_compliance.md` | `platform/reporting_admin_billing.md` | Settings/billing/admin-adjacent screens | billing/admin/contracts | queue/retry + notifications | QA packs + perf + threat model |
| Commerce | S16 | `pricing_and_credits.md` | `commerce/creator_pro_tools.md` | Creator Pro screens | creator-pro contracts | analytics/runtime | QA packs |
| Platform | S24 | `pricing_and_credits.md`, `legal_compliance.md` | `platform/public_api.md` | API key/settings screens | API keys/webhooks/contracts | queue/retry + webhook/runtime | security + perf + QA |
| Platform | S26 | `legal_compliance.md`, `business_rules.md` | `platform/internal_admin.md` | Admin screens | internal admin + broadcast + job + KB contracts | queue/retry + runbook | threat model + runbook + QA |
| Platform | copilot | `product_overview.md` | `platform/copilot.md` | Copilot dialog + shortcuts | copilot contracts | ai provider/runtime | QA packs |
| Platform | referral | `pricing_and_credits.md` | `platform/referral_growth.md` | Referral screens | referral contracts | notifications + analytics | QA packs |
| Platform | gamification | `pricing_and_credits.md`, `user_segments_and_modes.md` | `platform/gamification.md` | Gamification screens | gamification contracts/events | analytics/runtime | QA packs |
| Platform | help | `legal_compliance.md` | `platform/help_center.md` | Support/help screens + KB admin | support/KB/contracts | observability + runbook | QA packs + notifications |

## 3. Implementation Use

Before building any feature:

1. Locate the row in this matrix.
2. Read business source → feature spec → contracts → runtime → screens.
3. Use the listed quality/ops docs as the minimum validation set.

If a downstream artifact exists without a row here, it is not implementation-authoritative until linked.
