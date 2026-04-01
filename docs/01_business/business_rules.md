---
layer: business
canonical: true
source: creativanta_prd_v_3_1_revised_part_2.md (§24–§30), creativanta_prd_v_3_1_revised_part_1.md (§28)
last_updated: 2026-04-02
---

# Business Rules

> File này chứa các invariants không thể vi phạm. Mọi implementation PHẢI tuân thủ.

---

## 1. Cross-Module Contract Rules (INVARIANTS)

Các contract sau là **bất khả vi phạm** — vi phạm bất kỳ rule nào dưới đây là lỗi nghiêm trọng cấp product.

---

**RULE-001: Trend/Signal → Opportunity/Idea**
- Rule: "Trend/Signal phải đi tiếp được sang Opportunity hoặc Idea."
- If violated: Signal trở thành dead-end data — user không chuyển được intelligence thành action.

**RULE-002: Opportunity → Downstream Objects**
- Rule: "Opportunity phải đi tiếp được sang Idea, Script, Campaign hoặc Live Plan."
- If violated: Opportunity Board thành dashboard trưng bày, không tạo business value.

**RULE-003: Script → Asset Brief + Publish**
- Rule: "Script phải đi tiếp được sang Asset Brief và Publish."
- If violated: Script lơ lửng giữa pipeline — creation và distribution bị đứt.

**RULE-004: Asset → Packaging + Publish**
- Rule: "Asset phải đi tiếp được sang Packaging và Publish."
- If violated: Asset production không nối được output — content tạo xong không publish được.

**RULE-005: Publish → Logs + Engagement/Commerce/Proof**
- Rule: "Publish phải để lại logs và quay về Engagement / Commerce / Proof."
- If violated: Post-publish performance, engagement, revenue attribution bị mất — closed loop bị phá.

**RULE-006: Thread → Actionable Outcomes**
- Rule: "Thread phải đi tiếp được sang reply, task, idea, offer, seeding hoặc campaign action."
- If violated: Inbox thành read-only view — engagement intent không chuyển thành business action.

**RULE-007: Offer/Campaign → Financial Objects**
- Rule: "Offer/Campaign phải nối về Order / Settlement / Cost / Profit."
- If violated: Commerce operations tách rời khỏi financial truth — profit/loss không thể track.

**RULE-008: Proof/Profit → Evidence Drilldown**
- Rule: "Proof/Profit phải mở ngược ra Evidence và source context."
- If violated: Profit claims trở thành assertion không verify được — đánh mất trust layer.

**RULE-009: Workflow/Agent → Canonical Objects Only**
- Rule: "Workflow/Agent phải dùng canonical objects, không tạo parallel state ngoài graph."
- If violated: Automation tạo shadow data — One Graph bị phá, auditability mất.

---

## 2. State Machine Requirements

15 objects sau **bắt buộc** phải có standardized state machines trong downstream specs:

| # | Object Name | Feature Doc Path | Status |
|---|---|---|---|
| 1 | Opportunity | `02_features/intelligence/opportunity_board.md` | ✅ DEFINED (§SM: priority_state — 10 transitions) |
| 2 | Script | `02_features/creation/script_lab.md` | ✅ DEFINED (§SM: lifecycle_state + approval_state — dual machine) |
| 3 | Asset | `02_features/production/ai_video_studio.md` | ✅ DEFINED (§SM: generation_state + quality_state — dual machine) |
| 4 | Publish Job | `02_features/publish/publish_hub.md` | ✅ DEFINED (§SM: lifecycle_state — 9 transitions) |
| 5 | Publish Item | `02_features/publish/publish_hub.md` | ✅ DEFINED (§SM: lifecycle_state — 10 states) |
| 6 | Thread | `02_features/engagement/unified_inbox.md` | ✅ DEFINED (§SM: status — 8 states) |
| 7 | Offer | `02_features/commerce/monetization_os.md` | ✅ DEFINED (§SM: lifecycle_state — 6 states) |
| 8 | Order | `02_features/commerce/product_hub.md` | ✅ DEFINED (§SM: lifecycle_state — 8 states + Refund sub-machine) |
| 9 | Refund | `02_features/commerce/product_hub.md` | ✅ DEFINED (§SM: lifecycle_state — 4 states, sub-section of Order SM) |
| 10 | Reconciliation Record | `02_features/finance/operating_ledger.md` | ✅ DEFINED (§SM: reconciliation_state — 7 states via ENUM) |
| 11 | Workflow Run | `02_features/automation/workflow_studio.md` | ✅ DEFINED (§SM: status — 9 states) |
| 12 | Agent Run | `02_features/automation/workflow_studio.md` | ✅ DEFINED (§SM: current_state — 9 states) |
| 13 | Sample Request | `02_features/commerce/seeding_crm.md` | ✅ DEFINED (§SM: status — 6 states + follow_up sub-machine) |
| 14 | Sample Shipment | `02_features/commerce/seeding_crm.md` | ✅ DEFINED (§SM: embedded in Sample Request lifecycle) |
| 15 | Live Session | `02_features/commerce/live_war_room.md` | ✅ DEFINED (§SM: status — 7 states) |

> PRD khóa rule này ở cấp sản phẩm; state transition table chi tiết nằm ở Feature Docs và Detail Design.
> **Status (2026-04-02): All 15/15 state machines verified as DEFINED in feature docs. Each has From→To transition table with Trigger and Condition columns. CHECK constraints added to database_schema.md for all applicable status fields.**

---

## 3. Feature Gating Rules

Source: PRD §30.4

### 3.1 Gate Priority (QUAN TRỌNG NHẤT)
- **Tier gates** checked **TRƯỚC** role/permission gates
- If tier blocks feature → role doesn't matter
- If tier allows feature → role determines access level

### 3.2 Over-Limit Behavior
- When user hits limit → hiển thị **inline upsell card**, **KHÔNG force redirect** ra landing page
- Free users thấy được Pro features (preview mode) nhưng không thể dùng
- Over-limit warning hiển thị khi đạt **80% quota**
- No dark patterns: upgrade flow phải clear, reversible, có cancel anytime

### 3.3 Block Types Per Tier
| Tier | Credit Exhaustion Behavior |
|---|---|
| **Free** | Hard block — không cho phép overage |
| **Starter** | Hard block — có thể mua credit packs bổ sung |
| **Pro** | Soft warning at 90% → hard block at 100% — có thể mua credit packs hoặc auto-buy |
| **Business** | Soft warning at 80% → email at 100% → allow 10% overage buffer → hard block at 110% |
| **Enterprise** | Custom budget alerts, no hard block, invoiced monthly |

### 3.4 Operator Mode & Tier
- Operator mode availability follows tier allocation
- **Không tạo separate pricing per mode** — mode phụ thuộc tier, không phải ngược lại

---

## 4. Money/Proof Integrity Rules

Source: PRD §28.5

Các rule bất khả vi phạm cho integrity tài chính:

| Rule | Mô tả |
|---|---|
| **No UI-side money logic** | UI không được tự tính money logic khác finance/proof layer — mọi số tiền phải từ backend canonical |
| **Override audit trail** | Manual override phải có reason và audit trail — không override im lặng |
| **Side-effect logging** | Business-critical agent/workflow actions phải lưu side effects đầy đủ |
| **Source class mandatory** | Mọi money-related object phải có source class (Official / Imported / Inferred / Estimated / Unreconciled) |
| **Evidence mandatory** | Mọi money-related object phải có evidence, proof bundle hoặc confidence reason |
| **No mixing truth levels** | Estimated hoặc Unreconciled values không được hiển thị như finalized truth — phải gắn nhãn rõ |
| **Unreconciled separation** | Unreconciled bucket riêng phải hiện rõ, không trộn vào clean data |

---

## 5. Reporting & Explainability Rules

Source: PRD §26

Mọi surface quan trọng phải trả lời được **5 câu hỏi** sau. Nếu thiếu bất kỳ câu nào, surface chưa đạt yêu cầu:

1. **Điều gì đang xảy ra?** — thông tin chính, metric, trạng thái
2. **Vì sao hệ thống nói vậy?** — reasoning, model, logic đằng sau
3. **Dữ liệu đến từ đâu?** — source class, provider, freshness
4. **Chỗ nào còn thiếu hoặc chưa chắc?** — gaps, confidence warnings, unresolved items
5. **Việc tiếp theo nên làm là gì?** — suggested actions, next steps, CTA

> Giải thích phải ưu tiên **plain language trước**, technical detail sau.

---

## 6. Admin/Support Override Rules

Source: PRD §29

### Diagnostics Hierarchy (4 Levels)
Sản phẩm phải support diagnostics từ non-tech user → engineering:

| Level | Name | Audience | Mô tả |
|---|---|---|---|
| L1 | **User-facing explanation** | End user | Plain-language explanation: "Tính năng X không hoạt động vì platform Y đang bảo trì" |
| L2 | **Operator diagnostics** | Workspace admin/manager | Capability status, connector health, state details, repair suggestions |
| L3 | **Engineering trace log** | Dev/support engineer | API logs, error traces, request IDs, latency metrics |
| L4 | **Audit event stream** | Compliance/security | Immutable audit trail, state changes, who-did-what |

### Support-Friendly Design Principles
- Standardized state machines → consistent vocabulary across all objects
- Self-serve diagnostics → user can investigate before filing ticket
- Repair wizards → guided fix flows for common issues (connector broken, data stale, etc.)
- Explanation-first UX → errors explain "why" before "what to do"
- Admin override tools → có kiểm soát, có audit trail, có reason field

---

## 7. Beginner UX Rules

Source: PRD §27

Để người non-tech dùng được, sản phẩm **PHẢI**:

| Rule | Mô tả |
|---|---|
| **No "learn module" prerequisite** | Không bắt user "học module" trước khi làm việc |
| **Task/loop-first navigation** | Ưu tiên flow theo task/loop hơn taxonomy nội bộ |
| **Concrete CTA** | Dùng CTA cụ thể ("Tạo video bán hàng") thay vì abstract score-only views |
| **4 state types mandatory** | Có empty states, partial setup states, broken states và repair states rõ ràng |
| **Trust in plain language** | Giải thích trust/capability bằng ngôn ngữ dễ hiểu, không jargon |
| **Recipe-first entry** | Cho phép user bắt đầu bằng recipe, object hoặc suggested action — không ép vào command-heavy UX |

> Cross-ref: UX detail specs → `03_screens/` (chỉ đọc SAU khi đã đọc feature docs)

---

## 8. Resolved Ambiguous Business Rules (Audit v6 — 2026-04-02)

> These rules were identified as gaps during the systems audit. Each is tagged with its resolution type.

---

**BIZ-001: Credit cost resolution algorithm** — `DECISION`
- Problem: Credit cost tables use ranges (e.g., "15–25 credits") but no resolution algorithm specified.
- Decision: Use **midpoint of range** as default estimated cost. Actual cost determined by AI provider response (token count × model rate). Final cost may be ≤ estimated but NEVER > estimated + 10%.
- Overage protection: If actual > estimated + 10%, system absorbs the difference (logged as `credit_resolution_overage` metric).
- Cross-ref: `pricing_and_credits.md` §3.1, `database_schema.md` §13.2 `ai_credit_transactions.estimated_cost / actual_cost`

**BIZ-002: Business tier overage billing** — `DECISION` [PROPOSED — default until Product Owner overrides]
- Problem: Business tier allows 10% overage buffer (§3.3) but billing mechanism for overage credits undefined.
- Decision: **Option A — Auto-charge overage at standard credit pack rate** ($0.030/credit) at end of billing cycle.
  - At 100% usage: system sends warning notification (push + email)
  - At 110% usage: hard-block all AI generation. No silent overage beyond 110%.
  - Overage invoice generated as Stripe `invoice_item` on next billing cycle
  - Overage credits tracked in `credit_transactions.transaction_type = 'overage_charge'`
  - Invoice line item: "AI Credit Overage — {N} credits × $0.030"
  - Enterprise tier: custom overage terms per contract (no auto-charge)
- Fallback: If Product Owner selects Option C instead, change hard-block to 100% (no buffer). Update `pricing_and_credits.md` §3.3.
- Cross-ref: `pricing_and_credits.md` §3.3, `database_schema.md` §19.1B invoices, `api_endpoint_map.md` §2.8.6 AdminBillingService

**BIZ-003: Coupon stacking** — `DECISION`
- Problem: Can multiple coupons apply to a single order?
- Decision: **Max 1 coupon per order**. If user attempts second coupon, system replaces the first (keeping higher discount). Platform-issued promotional codes DO stack with workspace-level coupons (max total cap: 50% off).
- Cross-ref: `api_endpoint_map.md` §2.6.7 CouponService/ValidateCoupon, `database_schema.md` §7.5 `coupons.stackable BOOLEAN DEFAULT false`

**BIZ-004: Membership entitlement delivery** — `DECISION`
- Problem: What exactly does a "membership plan" entitle the subscriber to?
- Decision: Membership entitlements are defined per plan via 3 entitlement types:
  - `content_access`: Gated content items (videos, downloads, exclusive posts)
  - `feature_unlock`: Platform features beyond tier (e.g., early access tools)
  - `priority_support`: Elevated support tier within creator's workspace
- Entitlements checked via `MembershipService/CheckEntitlement(member_id, entitlement_type)`.
- Cross-ref: `database_schema.md` §7.6 `membership_plans.entitlement_config JSONB`

**BIZ-005: Bundle partial availability** — `DECISION`
- Problem: What happens when a product within a bundle goes out of stock?
- Decision: Bundle is **unavailable** if any component is OOS. System emits `product.catalog_status_changed` event with `reason: component_oos`. Partial bundles NOT offered (prevents fulfillment complexity).
- Exception: Digital-only bundles remain available if any digital component can be delivered.
- Cross-ref: `product_hub.md` §Business Rules

**BIZ-006: Referral program mechanics** — `DECISION`
- Problem: Referral reward mechanics not consolidated.
- Decision: Existing referral feature doc (`02_features/growth/referral_growth.md`) is canonical. Summary:
  - Referrer earns 100 AI credits when referee completes first paid subscription.
  - Referee gets 14-day Pro trial extension (stacks with standard trial).
  - Max 50 referral rewards per workspace per calendar year.
  - Anti-abuse: Same IP/device/payment method → auto-flagged, manual review required.
- Cross-ref: `api_endpoint_map.md` §2.8.11 ReferralService, `domain_event_catalog.md` §18 `referral.qualified`

**BIZ-007: Tax calculation** — `DECISION` [PROPOSED — default until Legal/Finance overrides]
- Problem: Tax jurisdiction rules undefined.
- Decision: **Phase 0 (MVP): Option C — Tax disclaimer, creator responsible.**
  - Platform displays: "Thuế được tính bởi sàn thương mại. Đối với Creator Store, người bán chịu trách nhiệm kê khai thuế."
  - Orders imported from platforms (Shopee, TikTok Shop): tax field preserved as-is from platform data
  - Creator Store direct sales: `orders.tax_amount = 0`, `orders.tax_note = 'creator_responsible'`
  - Invoice displays: subtotal + platform fees — no tax line item from Creativanta
  - Tax-related fields in `orders` table: `tax_amount NUMERIC(18,6) DEFAULT 0`, `tax_jurisdiction VARCHAR(10)`, `tax_note VARCHAR(100)`
- **Phase 2 (post-PMF)**: Integrate TaxJar/Avalara when Creator Store (M15) reaches PMF
  - Tax API called at checkout for direct sales only
  - Platform marketplace orders continue using platform-provided tax data
  - Tax settings added to workspace settings: `tax_registration_id`, `tax_jurisdiction_default`
- Fallback: If Legal selects Option A (zero tax calc forever), remove Phase 2 migration plan. No code changes needed for Phase 0.
- Cross-ref: `database_schema.md` §10 `orders`, `creator_store.md` §Checkout Flow

**BIZ-008: Currency conversion** — `DECISION`
- Problem: Multi-currency handling not specified (creators sell across markets with different currencies).
- Decision: All financial calculations use **workspace base currency** (default: VND). Display in user's preferred currency using cached exchange rates.
  - Exchange rate source: ECB free API (daily update) + fallback to fixer.io
  - Cache TTL: 1 hour for display, daily snapshot for financial records
  - Profit/loss calculations always in workspace base currency
  - Exchange rate at time of transaction is immutably recorded in `orders.exchange_rate_snapshot JSONB`
- Cross-ref: `database_schema.md` §7 `orders.currency`, `operating_ledger.md` §Multi-currency

**BIZ-009: Free trial to paid conversion** — `DECISION`
- Problem: What happens to user data/config when trial expires?
- Decision: **Data preserved, features downgraded** to Free tier limits.
  - All content, assets, workflows, connected accounts preserved (read-only if over limit)
  - Over-limit items: user can view, export, delete — but NOT create new until under limit
  - Connected accounts beyond Free limit: disconnected but credentials retained for 30 days (reconnect on upgrade)
  - AI credits: reset to Free allocation (50/month), reserved credits released
  - No data deletion on trial expiry
- Cross-ref: `pricing_and_credits.md` §5.3 Trial, `auth.md` §Plan Changes

**BIZ-010: Workspace deletion quarantine** — `DECISION`
- Problem: What happens when a workspace is deleted?
- Decision: 3-phase deletion lifecycle:
  - **Phase 1 (Day 0–30): Read-only quarantine**. Workspace enters `suspended` state. Data accessible for export. Workspace can be restored by owner.
  - **Phase 2 (Day 30–90): Soft delete**. `deleted_at` set on workspace. Data retained but inaccessible via API. Restoration requires support ticket.
  - **Phase 3 (Day 90+): Hard delete**. All workspace data permanently purged including: assets, generation jobs, connected accounts, financial records, audit logs. Cross-tenant references nullified.
  - GDPR right to deletion: Honored within 30 days of request (skip to Phase 3).
- Cross-ref: `database_schema.md` §1 `workspaces.deleted_at`, `pricing_and_credits.md` §5.4 Cancellation

