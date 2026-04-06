# Screen: Web — Settings: Credit Purchase

> **Screen ID**: W120
> **Module**: M23 — Settings
> **Route**: `/settings/credits/purchase`
> **Platform**: Web (SvelteKit)
> **Upstream**: M23 Part A, A1 Schema (`ai_credit_transactions`, `workspaces`, `subscriptions`), A3 API (`CreditService/GetBalance`, `CreditService/GetMonthlyUsage`, `BillingService/ListCreditPackages`, `BillingService/ListCreditPurchases`), B5 RBAC §2.9

---

## 1. Purpose & Context

Buy additional AI credits — credit packs with volume discounts, auto-refill configuration, usage analytics, and depletion projections.

### User Goals
- See current credit balance and projected depletion date
- Purchase credit packs with clear pricing and volume discounts
- Configure auto-refill to avoid running out during critical work
- Review credit usage history

### Business Goals
- Generate revenue through credit purchases
- Reduce churn by preventing "out of credits" friction
- Enable auto-refill as a recurring revenue stream
- Provide transparent pricing with volume incentives

### Entry Points
- Sidebar: Settings → "🪙 Credits"
- AI Studio: "⚠️ Credits low" warning → "Buy more"
- Top navigation: credit counter click → quick purchase
- Notification: "Credits running low — auto-refill is OFF"

### Exit Points
- "📊 Usage history" → Credit Usage Detail (W124)
- Stripe Checkout (external popup)
- "← Settings" → Settings index

---

## 2. Preconditions / Postconditions

### Preconditions
- User has `workspace:billing:manage` permission (Owner, Admin)

### Postconditions
- Purchase adds credits to workspace balance immediately
- Transaction recorded in `credit_transactions`
- Auto-refill purchase triggered automatically when threshold hit

---

## 3. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Settings   🪙 Mua thêm AI Credits                                │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Current Balance ─────────────────────────────────────────────┐   │
│ │ 🪙 120 credits remaining                                      │   │
│ │ Plan allocation: 200/month (resets in 18 days)                 │   │
│ │ Usage rate: 15 credits/day avg (last 7d)                      │   │
│ │ Projected depletion: 8 days ⚠️ (before reset)                │   │
│ │ [████████░░░░░░░░░░░░] 60% used                              │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Credit Packs ────────────────────────────────────────────────┐   │
│ │ ┌─────────────┐ ┌────────────────┐ ┌─────────────────────┐   │   │
│ │ │ 100 credits │ │ 300 credits    │ │ ⭐ 500 credits      │   │   │
│ │ │ 99,000đ     │ │ 249,000đ       │ │ 399,000đ            │   │   │
│ │ │ 990đ/credit │ │ 830đ/cr(-16%) │ │ 798đ/cr(-20%) ⭐    │   │   │
│ │ │             │ │                 │ │ Best value!          │   │   │
│ │ │ [Mua]       │ │ [Mua]          │ │ [Mua ⭐]            │   │   │
│ │ └─────────────┘ └────────────────┘ └─────────────────────┘   │   │
│ │                                                                │   │
│ │ 💎 Enterprise: Unlimited credits — [→ Contact sales]          │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Auto-Refill ────────────────────────────────────────────────┐    │
│ │ [🟢 ON / 🔴 OFF toggle]                                      │    │
│ │ Trigger when balance < [50 ▾] credits                         │    │
│ │ Auto-buy pack: [100 credits ▾]                                 │    │
│ │ Monthly max: [1 purchase ▾] (prevent runaway spend)           │    │
│ │ Payment method: •••• 4242 [Change →]                           │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Recent Usage ────────────────────────────────────────────────┐   │
│ │ 28/3 · Quick Edit ×3 · -75 cr · Balance: 120                  │   │
│ │ 27/3 · AI Remix · -43 cr · Balance: 195                       │   │
│ │ 26/3 · Auto-caption · -8 cr · Balance: 238                    │   │
│ │ [📊 View full usage history →]                                 │   │
│ └────────────────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
CreditPurchasePage
├── AppShell (shared)
├── PageHeader
│   ├── BackLink ("← Settings")
│   └── PageTitle ("🪙 Mua thêm AI Credits")
├── CurrentBalanceCard
│   ├── CreditBalance (animated counter)
│   ├── PlanAllocation (monthly included / used)
│   ├── ResetCountdown
│   ├── UsageRate (credits/day average)
│   ├── DepletionProjection (days until 0)
│   └── UsageProgressBar
├── CreditPacksGrid
│   └── PackCard[] (100, 300, 500)
│       ├── CreditCount
│       ├── Price (VND)
│       ├── PricePerCredit
│       ├── DiscountBadge (if applicable)
│       ├── BestValueBadge (on highest tier)
│       └── BuyButton (→ Stripe Checkout)
│   └── EnterpriseLink
├── AutoRefillSection
│   ├── EnableToggle
│   ├── ThresholdSelector (when to trigger)
│   ├── PackSelector (which pack to auto-buy)
│   ├── MonthlyMaxSelector (spending cap)
│   └── PaymentMethodPreview + ChangeLink
├── RecentUsageSection
│   └── UsageRow[] (date, action, credits consumed, balance)
│   └── ViewFullHistoryLink
```

---

## 5. User Actions

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Buy pack | "Mua" → Stripe popup | `CreditService/Purchase(pack_id)` | Stripe checkout → credits added | `workspace:billing:manage` |
| 2 | Toggle auto-refill | ON/OFF toggle | `AdminBillingService/ChangePlan` | Auto-refill enabled/disabled | `workspace:billing:manage` |
| 3 | Change threshold | Threshold dropdown | `AdminBillingService/ChangePlan` | Updated | `workspace:billing:manage` |
| 4 | View full history | "📊 View full" | — | → Credit Usage Detail (W124) | `workspace:billing:read` |
| 5 | Change payment | "Change →" | — | → Billing settings | `workspace:billing:manage` |

---

## 6. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial fetch | Balance shimmer + pack skeletons |
| LOADED | Data received | Full purchase page |
| LOW_CREDITS | < 20% remaining or < projected threshold | Orange warning on balance: "⚠️ Credits sẽ hết trong {days} ngày" |
| ZERO_CREDITS | Balance = 0 | Red alert: "🔴 Đã hết credits. AI features tạm dừng. Mua thêm để tiếp tục." |
| PURCHASING | Stripe checkout open | Pack card shows loading state |
| PURCHASED | Just bought credits | Toast: "✅ Đã thêm {count} credits!" Balance animates up |
| ERROR | Payment failed | Error: "Thanh toán thất bại. Kiểm tra thẻ hoặc thử lại." |

---

## 7. Permissions

| Feature | Owner | Admin | Manager+ |
|---|---|---|---|
| View balance | ✅ | ✅ | ✅ (read-only) |
| Purchase credits | ✅ | ✅ | ❌ |
| Configure auto-refill | ✅ | ✅ | ❌ |
| View usage history | ✅ | ✅ | ✅ |

---

## 8. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached balance | Retry online |
| Stripe checkout fail | Card declined | Return: "❌ Thanh toán thất bại: {reason}. [Thử lại]" | Retry |
| Auto-refill fail | Stripe API error | Notification: "Tự động nạp thất bại. [Cập nhật thẻ]" | Update card |
| Balance sync fail | API error | Skeleton persists + toast | Retry |
| Usage row fail | API error | "Không tải được sử dụng gần đây." | Retry |

---

## 9. Accessibility

| Element | Requirement |
|---|---|
| Balance card | `role="status"`, `aria-label="120 credits remaining, 60% used"` |
| Progress bar | `role="progressbar"`, `aria-valuenow`, `aria-valuemax` |
| Pack cards | `role="listitem"`, `aria-label="{n} credits for {price}, {discount}% discount"` |
| Auto-refill toggle | `role="switch"`, `aria-checked`, `aria-label="Auto-refill: {on/off}"` |
| Enterprise link | `aria-label="Contact sales for unlimited credits"` |

---

## 10. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Balance + pack skeletons |
| Balance | 100-300ms | Counter + bar animate |
| Pack cards | 200-500ms | Cards stagger in with prices |
| Auto-refill | 200-400ms | Toggle state loads |
| Recent usage | 300-600ms | Rows stagger |

---

## 11. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `credits.viewed` | Page load | `balance`, `plan`, `burn_rate` |
| `credits.pack_clicked` | "Mua" on pack | `pack_size`, `price`, `discount` |
| `credits.checkout_completed` | Stripe success | `pack_size`, `session_id` |
| `credits.checkout_failed` | Stripe decline | `error_type` |
| `credits.autorefill_toggled` | Toggle auto-refill | `enabled`, `threshold` |
| `credits.autorefill_config_changed` | Config updated | `pack`, `cap` |
| `credits.usage_link_clicked` | "📊 View full" | — |
| `credits.enterprise_clicked` | "Contact sales" | — |

---

## 12. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/settings/credits/purchase/+page.svelte`
- **Server load**: `+page.server.ts` → `AdminBillingService/GetCreditBalance` + `AdminBillingService/PurchaseCredits` + `AdminBillingService/GetBillingSummary` + `CreditService/ListRecentUsage(limit:5)`
- **Buy flow**: Server creates Stripe Checkout Session → redirect to Stripe → return to `/settings/credits/purchase?checkout=success`
- **Auto-refill**: `CreditService/UpdateAutoRefill(config)` → background worker checks balance hourly
- **Depletion**: `balance / avg_burn_rate` server-side, refreshed every 5m
- **Enterprise CTA**: Opens Calendly embed or mailto
- **Payment change**: Link to Stripe Customer Portal

---

## 13. Localization Notes

- Balance: "🪙 120 credits còn lại"
- Plan: "Gói Pro (200/tháng) · Reset: 1/4/2026"
- Packs: "Giảm 16%", "⭐ Tiết kiệm nhất"
- Auto-refill: "Tự động nạp khi dưới {n} credits"
- Currency: VND with đ (99.000đ)
- Tone: Urgent when depleting, confident on purchase

---

## 14. Design Tokens

| Token | Usage |
|---|---|
| `--color-accent` | Buy CTA |
| `--color-success` | Purchase success, healthy balance |
| `--color-warning` | Depletion warning, low balance |
| `--color-danger` | Payment fail, zero credits |
| `--color-surface-elevated` | Pack cards, balance card |
| `--color-pack-best` | ⭐ Best value highlight |
| `--color-discount` | Discount badge |
| `--font-metric` | Credit numbers (tabular-nums) |
| `--color-text-secondary` | Per-credit cost |

---

## 15. Related Screens

| Screen | Relationship |
|---|---|
| [W121] Credit Usage Detail | Full usage history |
| [W119] Billing & Plans | Payment methods |
| [W123] AI Preferences | AI model preferences |
| [W021] Studio Launcher | Where credits are consumed |

---

## 16. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 errors (Stripe, auto-refill), pack/balance a11y, 8 analytics, SvelteKit impl (Stripe checkout, auto-refill), localization, 9 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
