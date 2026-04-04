---
layer: index
canonical: true
created: 2026-04-01
last_updated: 2026-04-06
status: FINAL_MATRIX
---

# Cross-Layer Alignment Matrix

> Production matrix — 2026-04-06 (Round 7 update)
>
> **✅ FULL-CONTRACT ALIGNMENT ACHIEVED** (2026-04-06): This matrix reflects full documentation-spec-contract alignment. The canonical API map defines **~1,160 concrete RPCs** across §2-§20, covering **100% of screen-referenced RPC patterns** (907/907). The previous ~572-RPC gap is fully closed.
>
> **Status**: Full-contract alignment verified. API: ~1,160 RPC definitions + ~14 REST endpoints + 6 webhook endpoints (per `api_endpoint_map.md` §2-§20) with 24 JSON examples. DB hardened (RLS 106+, deleted_at 51+, CHECK 23+, ~122 tables). Events: ~230 canonical event types with 74-row mapping table. Business rules: 10/10 DECISION (BIZ-002/007 FINALIZED). All phantom screen refs fixed. All feature frontmatters upgraded to READY. Legal/compliance: engineering-approved, launch-gated pending legal sign-off. Ops: `ci_cd_pipeline.md` remains SCAFFOLD.
> **Methodology**: Feature Doc ✅/❌, Schema table coverage (verified/total), Screen file count, API service mapping + JSON examples in api_examples.md, Overall status.

| Module | Feature Doc | Schema Tables | Screens | API Services | Overall |
|--------|------------|---------------|---------|-------------|---------|
| Auth | ✅ | ✅ 3/3 | ✅ 3 | ✅ Defined (§2.1: 15 RPCs + JSON A.1) | ✅ Aligned |
| M22 Capability | ✅ | ✅ 1/1 | ✅ 1 | ✅ Defined (§2.8.7: 5 RPCs + JSON A.20) | ✅ Aligned |
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
| M01 Home | ✅ | ✅ 1/1 | ✅ 12 | ✅ Defined (copilot §2.8.5 + WorkspaceService) | ✅ Aligned |
| M23 Billing | ✅ | ✅ 3/3 | ✅ 2 | ✅ Defined (§2.8.6: 14 RPCs + JSON A.18-A.19) | ✅ Aligned |
| S16 Creator Pro | ✅ | ✅ 4/4 | ✅ 2 | ✅ Defined (§5: 13 RPCs) | ✅ Aligned |
| S24 Public API | ✅ | ✅ 1/1 | ✅ 1 | ✅ Defined (§4: 14 endpoints + webhook detail) | ✅ Aligned |
| S26 Admin | ✅ | ✅ 2/2 | ✅ 32 | ✅ Defined (§6: 28 RPCs) | ✅ Aligned |

**Summary**: **28 doc-spec aligned** (feature doc ↔ schema ↔ screens ↔ API service name), 0 partial, 0 blocked. ✅ Full-contract alignment achieved — all 907 screen-referenced RPCs have canonical API definitions in `api_endpoint_map.md` §2-§20. Legal/compliance is engineering-approved but launch-gated pending legal sign-off. Ops CI/CD is SCAFFOLD (not production-ready).

> **Scope note**: 28/28 covers all core modules (M01-M23 + auth) and spec modules (S16, S24, S26, Gamification). Three supplementary feature docs — **copilot**, **referral_growth**, **help_center** — are tracked in `_STATUS.md` (31/31 READY) but not included in this cross-layer matrix. Their API and schema coverage is verified within their respective feature docs.

> **Per-RPC coverage (current)**: ✅ All 907 screen-referenced RPCs now have concrete canonical definitions in `api_endpoint_map.md` §2-§20 (~1,160 total RPCs). The previous gap of ~572 undefined RPCs was closed on 2026-04-06 by promoting all screen-derived RPCs to canonical status with method, auth level, rate limit, and description. See `screen_api_reconciliation.md` (status: RESOLVED) for the full traceability matrix.

> **All documentation gaps closed (2026-04-02 Final)**:
> - Gamification: §14 cross-linked to §22.10-11 (5 tables total)
> - M14: `screen_web_monetization_os.md` created + `monetization_offer_views` table added
> - M22: `home_dashboard_config` table added (card ordering, morning brief, onboarding state)
> - M01: Feature doc promoted DRAFT → READY
> - BIZ-002/BIZ-007: FINALIZED (overage billing at §3.3 rates with 110% hard cap; tax disclaimer with creator responsibility for direct sales)
>
> **Caveats**:
> - This matrix reflects **documentation-level alignment** (feature docs ↔ schema ↔ screens ↔ API definitions).
> - It does NOT assert that `.proto` files, DDL migrations, or infrastructure artifacts exist. See `protobuf_contracts.md` L314: "Actual `.proto` files will be created during implementation Phase 1."
> - Ops docs have mixed readiness: `ci_cd_pipeline.md` is SCAFFOLD; `observability.md` and `runbook.md` are READY.

---

## Known Integrity Gaps (Validated 2026-04-04)

> These items are **verified from validation scripts**, not hand-edited. They represent downstream integrity issues that exist independently of the doc-spec alignment above.

| Area | Finding | Status | Notes |
|------|---------|--------|-------|
| Internal links | 0 broken links | ✅ RESOLVED | Was 161; fixed 2026-04-04 (path-depth + legacy link cleanup) |
| Seed ↔ Schema | 0 column mismatches | ✅ RESOLVED | Was 10; `seed_data.md` aligned to canonical schema 2026-04-04 |
| DDL syntax | 0 remaining | ✅ RESOLVED | 49 missing commas fixed 2026-04-04. 2 additional defects in `coupons` and `store_pages` fixed 2026-04-04 (Round 5). |
| Notification ↔ Events | 0 events missing from catalog | ✅ RESOLVED | Round 5 (2026-04-04): All 5 previously-missing events added to `domain_event_catalog.md`: `user.registered`, `workspace.member_invited`, `auth.suspicious_login`, `thread.priority_changed`, `idea.scored`. Notification matrix is now fully canonical. |
| Screen permissions ↔ RBAC | All screens use canonical tokens | ✅ RESOLVED | Round 5 (2026-04-04): Workspace-facing screens fixed (`team:invite` → `workspace:members:invite`). Round 6 (2026-04-05): All 10 admin screen shorthand tokens canonicalized (`admin:billing` → `admin:billing:read`/`admin:plan:override`, `admin:config` → `admin:feature_flag:toggle`, `admin:users` → `admin:user:read`/`admin:user:suspend`, `admin:ai` → `admin:analytics:read`/`admin:queue:manage`, `admin:audit` → `admin:audit_log:read`, `admin:support` → `admin:support:manage`, `admin:system_health`/`admin:ai_ops` → `admin:analytics:read`, `admin:analytics` → `admin:analytics:read`, `admin:viewer` → Analyst/Auditor role reference). `permission_alias_policy.md` moved to `09_archive/`. |
| RBAC ↔ Screens | 71 canonical permissions not referenced in screens | ℹ️ KNOWN | Intentional: not all RBAC permissions surface in screen UI (e.g., admin-only, system-level) |
| Screen IDs ↔ SCREEN_INDEX | 0 mismatches | ✅ RESOLVED | Was 176; all 238 screen files aligned to canonical SCREEN_INDEX.md 2026-04-04 |
| Screen ↔ API RPCs | 907/907 screen RPCs have canonical API definitions | ✅ RESOLVED | All screen-referenced RPCs promoted to canonical status in `api_endpoint_map.md` §10-§20 (2026-04-06). ~1,160 total canonical RPCs. `screen_api_reconciliation.md` status: RESOLVED. |
| UUID policy | Mixed v4/v7 usage | ⚠️ OPEN | Awaiting product decision: standardize on v7 (time-sortable) or keep v4. No implementation impact until decided. |
| Protobuf | Overview doc only; no actual `.proto` files | ℹ️ KNOWN | Planned for implementation Phase 1 |