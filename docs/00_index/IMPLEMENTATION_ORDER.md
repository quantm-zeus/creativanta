---
layer: index
canonical: true
last_updated: 2026-10-30
---

# Implementation Order — Full Scope Through Nine Phases

## 1. Delivery decision

The product owner authorized retaining every function and completing it progressively on 2026-10-29. [Product scope](../01_business/product_overview.md) owns this decision. P0–P8 below replace historical P3A–P3E and the former phase numbering. Early slices never waive later acceptance criteria.

Phases are acceptance gates, not calendar estimates. Develop an independent slice once its dependencies exist; activation requires its gate. Generate contracts and migrations by slice rather than all services/screens upfront.

## 2. Deliverables and exit gates

| Phase | Deliverables | Dependencies | Exit evidence |
|---|---|---|---|
| P0 — Secure foundation | Repository/toolchain lockfiles; dev bootstrap; auth/workspace discovery; RBAC; tenant isolation; common transport; transactional outbox/inbox; durable credits and quote catalog; M22 capability registry; minimal M23 billing/config; isolated S26 auth/audit; web/admin/mobile shells; help/error/notification infrastructure | Canonical docs; local services; deterministic test adapters for external credentials | Clean bootstrap + seed twice; two-tenant RLS including junctions; tenant FK guard; non-owner discovery; revoke membership; permission denial; duplicate request/event; reservation restart/expiry; TS/Go/Dart transport round trip |
| P1 — Commerce and financial truth | M13 product/SKU/order/inventory/import core; M19 costs/settlements/reconciliation/evidence/profit/export core; FX and historical cost snapshots; initial Home money/tasks; M23 payment sandbox | P0 | Hand-calculated finance fixtures; repeat CSV import/update; partial settlement/refund; COGS/FX snapshots; no double-counted revenue/fees; web/mobile drilldown; payment replay |
| P2 — Intelligence and decisions | M02 trends; M03 competitor/benchmark; M04 opportunity/conversion; M22 data-access/freshness; Home intelligence cards | P0–P1 canonical product context | Authorized sources or imports → trend → opportunity → linked draft; score/source/confidence/freshness; empty/degraded/repair; no assumed competitor API access |
| P3 — Content and continuity | M05 ideas; M06 scripts/approval; M08 characters/brand/voice/scene packs and consent; Copilot creative/help/analytics; Home content queue | P0–P2; verified provider routes for live generation | Opportunity → idea → script → approved brief; versions/conflicts; lineage; consent withdrawal; quote/credit flow; web/mobile review |
| P4 — Production and packaging | All four M07 core modes and EF01–07 production; M09 derivatives/repurpose; M10 QA/experiments; production queues; character/voice/music; gamification event hooks | P0–P3; M13 catalog; licensed media/provider routes | All P4 production-mode ACs; cancel/timeout/late completion; retry without double billing; lineage; batch partial success; upload/security limits; packaging handoff |
| P5 — Distribution and engagement | M11 publishing/calendar/manual proof; M12 inbox/entities/intent/reply/tasks; metrics/attribution, EF09 Performance Coach and EF10 experiments; M22 connector enforcement; M19 content-revenue adapter | P0–P4; per-action access gate | Script → asset → QA → publish → engagement; unaudited/manual/degraded routes; unknown publish result recovery; schedule/execute permissions; revoke token; messaging-window policy; webhook replay |
| P6 — Complete commerce operations | Remaining M13; M14 offers/coupons; M15 store/membership/digital delivery; M16 affiliate/brand deals; M17 live; M18 seeding; S16 creator pro; all financial adapters | P0–P5; commerce/payment/shipping gates | Owning ACs; checkout/fulfillment/refund; affiliate reversal; stock concurrency; live reconnect/manual pin; seeding attribution; brand proof/payout; web/mobile operating loops |
| P7 — Automation and developer platform | M20 complete visual builder/runtime; M21 recipes/marketplace/agents; Copilot actions and EF08 Video Agent; S24 API/webhooks | P0–P6 commands; licensed embed or own builder with approved core adapter | Dry run without effects; scoped service identity; approval expiry; replay; engine tenant isolation; agent budget; signed outbound webhooks; API scope/rotation; every node type |
| P8 — Full-product acceptance | Complete M01; remaining M22/M23/S26; full help/changelog/status/beta; referral/gamification including EF11; authorized competitor monitoring, style-template sharing and brand CRM/templates/discovery expansions; six modes; every web/mobile surface; release hardening | P0–P7 | Every scope item/AC mapped to passing evidence; all screen actions reconciled; every tier/cancellation/retention/export flow; a11y/i18n; restore/perf/load/security; launch review |

## 3. Full-scope ownership matrix

This is the sole module-to-phase mapping. `Complete` includes all Scope/Covers bullets, rules, alternate/edge flows, screen actions and ACs in the owning feature. Nothing omitted from this summary is removed from scope.

| Module/spec | Start | Complete | Required dependency |
|---|---|---|---|
| auth | P0 | P0 | Clerk sessions and local membership authorization |
| M01 | P0 | P8 | Incremental projections of shipped domains |
| M02 | P2 | P4 | Authorized signals or labeled imports |
| M03 | P2 | P8 | Authorized competitor data/import and product context |
| M04 | P2 | P6 | Intelligence first; all content/campaign/live conversion targets complete with owning domains |
| M05 | P3 | P6 | M04 and AI quote |
| M06 | P3 | P3 | M05 and approvals |
| M07 | P4 | P8 | M06/M08/M13 and durable credits |
| M08 | P3 | P4 | Consent and media/provider adapters |
| M09 | P4 | P6 | M07; live highlights with M17 |
| M10 | P4 | P5 | M07; experiments receive M11 telemetry |
| M11 | P5 | P5 | M10 and current capability |
| M12 | P5 | P6 | Connectors; commerce/seeding conversions in P6 |
| M13 | P1 | P6 | Core first; complete commerce adapters in P6 |
| M14 | P6 | P6 | M13 |
| M15 | P6 | P6 | M13/M14 and payment gate |
| M16 | P6 | P6 | M13 and attribution/reversal |
| M17 | P6 | P6 | M13/M14/M12 and stream capability |
| M18 | P6 | P6 | M13/M12 and shipment capability |
| M19 | P1 | P8 | Core first; add domain adapters and final reporting progressively |
| M20 | P7 | P7 | Canonical commands and licensed/own builder |
| M21 | P7 | P8 | M20 and agent budgets/permissions |
| M22 | P0 | P8 | Capability before any provider action |
| M23 | P0 | P8 | Billing/credits/audit before paid or AI actions |
| copilot | P3 | P8 | Creative/read P3; actions after P7 gates |
| referral | P8 | P8 | Verified subscriptions and durable grants |
| help | P0 | P8 | Minimal entry P0; full support/status/beta P8 |
| gamification | P4 | P8 | Event dedup and credit reward integrity |
| S16 | P6 | P8 | M13/M16/M19 |
| S24 | P0 | P7 | Service identity P0; developer product P7 |
| S26 | P0 | P8 | Isolated identity and privileged DB surface P0 |

## 4. Dependency and migration rules

- Default validation order: P0 → P1 → P2 → P3 → P4 → P5 → P6 → P7 → P8. Finance, credit, capability and auth foundations precede consumers.
- Canonical references may point toward later-phase types, but the undelivered action remains disabled with explanation. The target phase owns enabling and testing the link.
- `database_schema.md` is the complete target model. Current-slice migrations include required parent/global tables, policies, tenant FK guards and narrow grants; future tables/RPCs are not automatically deployed.
- Author and compile current-slice `.proto` messages before endpoint/UI code. Names alone do not pass the gate; follow [API behavior contracts](../04_contracts/api_behavior_contracts.md).
- A slice can launch only after its security, operational, external access and legal gates pass. Only P8 permits claiming full-product completion.
- Evidence/handoff: [Build Execution Contract](BUILD_EXECUTION_CONTRACT.md). Documentation lint alone never passes a phase.

## 5. Executable task decomposition

[Agent Build Backlog](AGENT_BUILD_BACKLOG.md) and its task catalog decompose these phase gates into dependency-ordered work packets. Phase dependencies mean the accepted prerequisite slice, not premature completion of every module started earlier. In particular, M02 downstream production links, M05 commerce conversions, M07 coaching/agents/gamification, and retained M03/S16/M21 expansions close only with their consumer tasks. Preserve all function scope while correcting completion dates. No phase number in an older feature footnote overrides this matrix.
