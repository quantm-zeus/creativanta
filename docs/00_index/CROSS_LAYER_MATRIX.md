---
layer: index
canonical: true
created: 2026-04-01
last_updated: 2026-04-09
status: DOCS_ALIGNED
---

# Cross-Layer Alignment Matrix

> Validation matrix — 2026-04-09 remediation pass.
>
> **Status**: module-level artifact chains exist broadly and the internal documentation corpus is now aligned enough for AI-assisted implementation. Remaining caveats are deferred typed transport generation and external legal launch approval, not cross-layer documentation contradictions.
>
> **Methodology**: this matrix records whether a module has a mapped feature/spec/schema/API chain. `Overall` below means **artifact chain present**, not "contradiction-free" or "implementation-ready without caveats".

| Module | Feature Doc | Schema Tables | Screens | API Services | Overall |
|--------|------------|---------------|---------|-------------|---------|
| Auth | ✅ | ✅ 3/3 | ✅ 3 | ✅ Defined (§2.1 + JSON A.1) | ⚠️ Mapped |
| M22 Capability | ✅ | ✅ 1/1 | ✅ 1 | ✅ Defined (§2.8.7 + JSON A.20) | ⚠️ Mapped |
| Gamification | ✅ | ✅ 5/5 | ✅ 2 | ✅ Defined (§8) | ⚠️ Mapped |
| M02 Trend | ✅ | ✅ 3/3 | ✅ 3 | ✅ Defined (§2.2 + JSON A.2) | ⚠️ Mapped |
| M03 Competitor | ✅ | ✅ 3/3 | ✅ 2 | ✅ Defined (§2.2) | ⚠️ Mapped |
| M04 Opportunity | ✅ | ✅ 2/2 | ✅ 3 | ✅ Defined (§2.2) | ⚠️ Mapped |
| M05 Idea | ✅ | ✅ 2/2 | ✅ 5 | ✅ Defined (§2.3) | ⚠️ Mapped |
| M06 Script | ✅ | ✅ 3/3 | ✅ 6 | ✅ Defined (§2.3 + JSON A.3) | ⚠️ Mapped |
| M07 AI Studio | ✅ | ✅ 2/2 | ✅ varies | ✅ Defined (§2.3, §7, §2.8.8-10 + JSON A.4-A.5) | ⚠️ Mapped |
| M08 Continuity | ✅ | ✅ 3/3 | ✅ 1 | ✅ Defined (§2.3 + §2.8.9) | ⚠️ Mapped |
| M09 Derivatives | ✅ | ✅ 2/2 | ✅ 1 | ✅ Defined (§2.3) | ⚠️ Mapped |
| M10 QA | ✅ | ✅ 1/1 | ✅ 1 | ✅ Defined (§2.4) | ⚠️ Mapped |
| M11 Publish | ✅ | ✅ 3/3 | ✅ 10 | ✅ Defined (§2.4 + JSON A.6) | ⚠️ Mapped |
| M12 Inbox | ✅ | ✅ 3/3 | ✅ 2 | ✅ Defined (§2.5 + JSON A.7) | ⚠️ Mapped |
| M13 Product | ✅ | ✅ 4/4 | ✅ 4 | ✅ Defined (§2.6.1 + JSON A.8) | ⚠️ Mapped |
| M14 Monetization | ✅ | ✅ 2/2 | ✅ 1 | ✅ Defined (§2.6.2 + JSON A.10-A.11) | ⚠️ Mapped |
| M15 Store | ✅ | ✅ 2/2 | ✅ 1 | ✅ Defined (§2.6.6) | ⚠️ Mapped |
| M16 Affiliate | ✅ | ✅ 2/2 | ✅ 3 | ✅ Defined (§2.6.5) | ⚠️ Mapped |
| M17 Live | ✅ | ✅ 2/2 | ✅ 5 | ✅ Defined (§2.8.3 + JSON A.16) | ⚠️ Mapped |
| M18 Seeding | ✅ | ✅ 2/2 | ✅ 4 | ✅ Defined (§2.8.4 + JSON A.17) | ⚠️ Mapped |
| M19 Finance | ✅ | ✅ 3/3 | ✅ 10 | ✅ Defined (§2.7 + JSON A.12-A.13) | ⚠️ Mapped |
| M20 Workflow | ✅ | ✅ 2/2 | ✅ 8 | ✅ Defined (§2.8.1 + JSON A.14-A.15) | ⚠️ Mapped |
| M21 Agent | ✅ | ✅ 2/2 | ✅ 3 | ✅ Defined (§2.8.2) | ⚠️ Mapped |
| M01 Home | ✅ | ✅ 1/1 | ✅ 12 | ✅ Defined (copilot §2.8.5 + WorkspaceService) | ⚠️ Mapped |
| M23 Billing | ✅ | ✅ 3/3 | ✅ 2 | ✅ Defined (§2.8.6 + JSON A.18-A.19) | ⚠️ Mapped |
| S16 Creator Pro | ✅ | ✅ 4/4 | ✅ 2 | ✅ Defined (§5) | ⚠️ Mapped |
| S24 Public API | ✅ | ✅ 1/1 | ✅ 1 | ✅ Defined (§4) | ⚠️ Mapped |
| S26 Admin | ✅ | ✅ 2/2 | ✅ 37 | ✅ Defined (§6 + §18 + §19.5A) | ⚠️ Mapped |

**Summary**: 28 modules have a mapped doc/spec/schema/API chain. Internal cross-layer contradictions that previously blocked implementation were remediated during the 2026-04-09 docs pass. Remaining caveats are external/deferred items (`legal` launch sign-off and future `/protos/` generation), not missing internal module documentation.

> **Scope note**: 28/28 covers all core modules (M01-M23 + auth) and spec modules (S16, S24, S26, Gamification). Three supplementary feature docs — **copilot**, **referral_growth**, **help_center** — are tracked in `_STATUS.md` (31/31 READY) but not included in this cross-layer matrix. Their API and schema coverage is verified within their respective feature docs.

> **Per-RPC coverage note**: broad canonical RPC coverage exists in `api_endpoint_map.md`, but that alone does not prove screen semantic cleanliness or implementation-ready UX docs.

> **Important**: not all documentation gaps are closed.
> - Gamification: §14 cross-linked to §22.10-11 (5 tables total)
> - M14: `screen_web_monetization_os.md` created + `monetization_offer_views` table added
> - M22: `home_dashboard_config` table added (card ordering, morning brief, onboarding state)
> - M01: Feature doc promoted DRAFT → READY
> - BIZ-002/BIZ-007: FINALIZED (overage billing at §3.3 rates with 110% hard cap; tax disclaimer with creator responsibility for direct sales)
>
> **Caveats**:
> - This matrix reflects **documentation-level alignment** (feature docs ↔ schema ↔ screens ↔ API definitions).
> - It does NOT assert that generated code artifacts already exist. `/protos/` remain a deferred implementation artifact until typed client/server generation begins.
> - Legal sign-off remains an external launch gate; engineering implementation may still proceed per `legal_compliance.md`.

---

## Known Integrity Gaps (Validated 2026-04-09)

> These items are **verified from validation scripts**, not hand-edited. They represent downstream integrity issues that exist independently of the doc-spec alignment above.

| Area | Finding | Status | Notes |
|------|---------|--------|-------|
| Internal links | 0 broken links | ✅ RESOLVED | Was 161; fixed 2026-04-04 (path-depth + legacy link cleanup) |
| Seed ↔ Schema | 0 column mismatches | ✅ RESOLVED | Was 10; `seed_data.md` and `seed_data.sql` (`cost_items.description`, `ai_credit_transactions` 1420 balance, topological seed order) aligned to canonical schema |
| DDL syntax & topological order | 0 remaining | ✅ RESOLVED | 0 missing/trailing commas, 0 forward FK references (`regions`/`currencies` at §4.0, `recipe_templates` at §12.3B), and all 123 RLS policies use `NULLIF(current_setting('app.current_tenant_id', true), '')::uuid` |
| Notification ↔ Events | 0 events missing from catalog | ✅ RESOLVED | Round 5 (2026-04-04): All 5 previously-missing events added to `domain_event_catalog.md`: `user.registered`, `workspace.member_invited`, `auth.suspicious_login`, `thread.priority_changed`, `idea.scored`. Notification matrix is now fully canonical. |
| Screen permissions ↔ RBAC | 0 active screen-role alias contradictions | ✅ RESOLVED | Remaining alias references are intentionally centralized in `SCREEN_IMPLEMENTATION_PROTOCOL.md` as historical mapping guidance. |
| RBAC ↔ Screens | 71 canonical permissions not referenced in screens | ℹ️ KNOWN | Intentional: not all RBAC permissions surface in screen UI (e.g., admin-only, system-level) |
| Screen IDs ↔ SCREEN_INDEX | 0 mismatches | ✅ RESOLVED | Was 176; all 243 screen files aligned to canonical SCREEN_INDEX.md 2026-04-06 |
| Screen template contamination | Historical shorthand governed by protocol only | ✅ RESOLVED | Exact implementation-bearing placeholder markers are now centralized in `SCREEN_IMPLEMENTATION_PROTOCOL.md`; remaining placeholder mentions in active screens are revision history or loading-state copy. |
| UUID policy | Application-generated IDs use v7; DB defaults remain fallback v4-style random UUIDs | ✅ RESOLVED | See ADR-015 + database schema naming conventions |
| Protobuf | Phase-gated consolidation contract defined; physical `.proto` files deferred to Phase 0/1 codegen | ℹ️ DEFERRED | See `protobuf_contracts.md` §6 and `OPEN_BLOCKERS.md` (`PROTO-C-001`) |
