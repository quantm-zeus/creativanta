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
| 2 | Script | `02_features/content/script_lab.md` | ✅ DEFINED (§SM: lifecycle_state + approval_state — dual machine) |
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
| **Starter** | Hard block at limit — có thể mua credit packs bổ sung |
| **Pro** | Hard block at limit — có thể mua credit packs hoặc auto-buy |
| **Business** | Warning at 80% → stronger warning at 95% → warning + email at 100% → allow usage to 110% **only if** valid payment method on file AND overage terms accepted; otherwise hard block at 100% → auto-charge overage on next invoice cycle → hard block at 110% |
| **Enterprise** | Custom budget alerts per contract, invoiced monthly |

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

**BIZ-002: Business tier overage billing** — `DECISION` [FINALIZED]
- Problem: Business tier allows 10% overage buffer (§3.3) but billing mechanism for overage credits undefined.
- Decision: **Auto-charge overage at standard credit pack rate** ($0.030/credit) at end of billing cycle.
  - Warning at 80% usage (in-app notification)
  - Stronger warning at 95% usage (in-app notification)
  - Warning + email at 100% usage
  - Allow usage up to 110% **only if**: valid payment method on file AND overage terms accepted
  - Otherwise hard-block at 100% (no buffer without both conditions)
  - Auto-charge overage on next invoice cycle only when both conditions above are met
  - Hard-block at 110% (absolute cap)
  - Overage credits tracked in `credit_transactions.transaction_type = 'overage_charge'`
  - Invoice line item: "AI Credit Overage — {N} credits × $0.030"
  - Enterprise tier: custom overage terms per contract (no auto-charge)
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
- Decision: Existing referral feature doc (`02_features/platform/referral_growth.md`) is canonical. Summary:
  - Referrer earns 100 AI credits when referee completes first paid subscription.
  - Referee gets 14-day Pro trial extension (stacks with standard trial).
  - Max 50 referral rewards per workspace per calendar year.
  - Anti-abuse: Same IP/device/payment method → auto-flagged, manual review required.
- Cross-ref: `api_endpoint_map.md` §2.8.11 ReferralService, `domain_event_catalog.md` §18 `referral.qualified`

**BIZ-007: Tax calculation** — `DECISION` [FINALIZED]
- Problem: Tax jurisdiction rules undefined.
- Decision: **Phase 0 (MVP): Tax disclaimer, creator responsible.**
  - No native tax engine in Phase 0 / MVP
  - Platform displays: "Thuế được tính bởi sàn thương mại. Đối với Creator Store, người bán chịu trách nhiệm kê khai thuế."
  - Orders imported from platforms (Shopee, TikTok Shop): preserve imported marketplace/platform tax data as-is
  - Creator Store direct sales: `orders.tax_amount = 0` (default), `orders.tax_note = 'creator_responsible'` — do not calculate tax natively; make creator responsibility explicit through disclaimers/settings/export
  - Invoice displays: subtotal + platform fees — no tax line item from Creativanta
  - Tax-related fields in `orders` table: `tax_amount NUMERIC(18,6) DEFAULT 0`, `tax_jurisdiction VARCHAR(10)`, `tax_note VARCHAR(100)`
  - Collect basic settings: `tax_registration_id`, `tax_jurisdiction_default`
  - Provide exportable raw data for downstream accounting/tax handling
- **Phase 2 (post-PMF)**: Integrate TaxJar/Avalara when Creator Store (M15) reaches PMF
  - Tax API called at checkout for direct sales only
  - Platform marketplace orders continue using platform-provided tax data
  - Tax settings added to workspace settings: `tax_registration_id`, `tax_jurisdiction_default`
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

**BIZ-011: AI credit refund on generation failure/partial output** — `DECISION`
- Problem: What happens to credits when AI generation fails, produces partial output, or user disputes quality?
- Decision: 3-tier refund policy based on failure type:
  - **Full refund (automatic)**: System-side failure (provider error, timeout, infrastructure crash). Credits returned immediately via credit escrow release. `credit_transactions.transaction_type = 'refund_system_failure'`.
  - **Full refund (automatic)**: Generation produces no usable output (empty result, corrupt file, 0-second video). Detected by output validator. `transaction_type = 'refund_no_output'`.
  - **Partial refund (automatic)**: Generation produces partial output (e.g., 15s video instead of requested 60s). Refund = `estimated_cost × (1 - actual_duration/requested_duration)`. Minimum refund: 20% of estimated cost. `transaction_type = 'refund_partial_output'`.
  - **No automatic refund**: Generation completes successfully but user dislikes quality. User may file quality dispute via support ticket. Support can issue discretionary credit grant (max 1 per workspace per 24h, max 50 credits per grant). `transaction_type = 'refund_quality_dispute'`.
  - **Anti-abuse**: Max 10 automatic refunds per workspace per day. Beyond threshold → manual review queue + temporary throttle on that workspace's AI generation.
- Cross-ref: `pricing_and_credits.md` §2.3 Credit Reservation Flow, `database_schema.md` §13.2 `ai_credit_transactions`

**BIZ-012: Affiliate commission clawback** — `DECISION`
- Problem: What happens to affiliate commissions when the referred order is returned/refunded?
- Decision: Commission clawback rules:
  - **Return window**: 15 days from order delivery. If buyer returns product within window, commission is clawed back in full.
  - **Partial refund**: Commission reduced proportionally to refund amount. Formula: `clawback = original_commission × (refund_amount / order_total)`.
  - **Post-window returns** (day 16+): No clawback — commission is finalized and locked.
  - **Commission hold period**: All commissions are held in `pending` status for 15 days after order delivery (matching return window). After hold period, status transitions to `confirmed` and becomes eligible for payout.
  - **Payout threshold**: Minimum 100,000 VND (or equivalent in workspace currency) accumulated confirmed commission before payout is triggered.
  - **Fraud clawback**: If order is flagged as fraud (by platform or admin), commission is clawed back regardless of timing. `affiliate_commissions.status = 'clawed_back'`, `clawback_reason = 'fraud'`.
  - **Dispute**: Creator can dispute clawback within 7 days via support ticket. Dispute outcome logged in audit trail.
- Cross-ref: `database_schema.md` §8 `affiliate_commissions`, `domain_event_catalog.md` §8 (`affiliate.commission.earned`, `affiliate.commission.confirmed`, `affiliate.commission.clawed_back`, `affiliate.commission.paid_out`), `api_endpoint_map.md` §20.4 AffiliateService

**BIZ-013: Plan downgrade data retention** — `DECISION`
- Problem: What happens to data and resources when a user downgrades to a lower tier?
- Decision: Data preservation with feature restriction:
  - **Effective date**: Downgrade takes effect at start of next billing cycle (not immediately).
  - **7-day adjustment period**: After downgrade notification, user has 7 days to reduce usage to new tier limits before enforcement begins.
  - **Connected accounts**: Accounts beyond new limit are **disconnected but credentials retained** for 30 days. User can choose which to keep within new limit. If no choice within 7 days, system retains most-recently-active accounts.
  - **AI credits**: Unused subscription credits do NOT carry over to new tier. Purchased credit packs are preserved (they never expire per BIZ §2.2). Credit balance is reset to new tier allocation at cycle start.
  - **Workflows/automations**: Beyond-limit workflows are **paused** (not deleted). User can re-enable within new limit. Excess workflows show "paused — upgrade to re-enable" status.
  - **Content/assets**: All content, scripts, ideas, assets are **preserved** (read-only access for beyond-limit items). No deletion on downgrade.
  - **Characters/voices**: Beyond-limit character slots and voice clones are **frozen** (cannot generate new content with them, but existing generated content is preserved). User can choose which to keep active within new limit.
  - **Storage**: If over new storage limit, no new uploads allowed. Existing files preserved. 30-day grace to delete/export excess.
  - **Team members**: Beyond-limit members retain read-only access for 7 days, then are removed from workspace (notified via email). Workspace data they created is preserved.
- Cross-ref: `pricing_and_credits.md` §5.2 Plan Changes, `auth.md` §Plan Changes

**BIZ-014: Cancellation and data lifecycle** — `DECISION`
- Problem: Detailed cancellation flow and data lifecycle not fully specified beyond §5.4.
- Decision: Cancellation lifecycle:
  - **Cancellation request**: User can cancel anytime from Billing settings. No cancellation fee.
  - **Retention offer**: On cancellation, system offers one retention option (e.g., 30% discount for 3 months or temporary downgrade to Starter). Max 1 retention offer per subscription lifetime. If accepted, cancel is aborted.
  - **Active until cycle end**: After confirmed cancellation, full access continues until end of current billing cycle. Banner shows: "Your plan expires on {date}. Renew anytime before then."
  - **Read-only period (Day 0–30 after expiry)**: Workspace enters read-only mode (BIZ-010 Phase 1). User can view, export, and delete data. Cannot create, generate, or publish. Connected accounts disconnected (credentials retained).
  - **Soft delete (Day 30–90)**: `deleted_at` set (BIZ-010 Phase 2). Data retained in database but inaccessible via UI/API. Reactivation possible via support ticket + payment.
  - **Hard delete (Day 90+)**: Permanent deletion of all workspace data (BIZ-010 Phase 3). Export reminder emails sent at Day 0, Day 14, Day 25, Day 60.
  - **Annual plan early cancellation**: No partial refund. Access continues until annual cycle end.
  - **Data export**: User can request full data export (GDPR Article 20) at any point before hard delete. Export includes: content, assets, analytics, financial records, contact data. Format: ZIP containing JSON + media files. Processing: up to 72 hours. Download link valid for 7 days.
- Cross-ref: `pricing_and_credits.md` §5.4 Cancellation, BIZ-010 Workspace Deletion Quarantine

