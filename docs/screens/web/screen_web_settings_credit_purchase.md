# Screen: Web — Credit Purchase

> **Screen ID**: W123
> **Module**: M26 — Settings (Credits)
> **Route**: `/settings/credits/purchase`
> **Platform**: Web (SvelteKit)
> **Upstream**: A1 Schema (credit_packages, credit_purchases, payment_methods), B5 RBAC §2.9

---

## 1. Purpose & Context

Buy additional AI credits — credit packs with tiered pricing (bulk discounts), auto-refill configuration, usage projection highlighting urgency, and payment method management.

### User Goals
- Buy credits quickly with saved payment method
- See which pack offers best value
- Configure auto-refill to never run out
- Review recent purchases

### Entry Points
- Credit Usage (W124): "💳 Mua thêm credits"
- AI Studio: "Not enough credits — Buy more"
- Top nav: credit warning → purchase

### Exit Points
- "📊 Usage detail" → Credit Usage (W124)
- Payment success → confirmation + return to studio

---

## 2. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Settings   🪙 Mua thêm AI Credits                                │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Current Balance ─────────────────────────────────────────────┐   │
│ │ 🪙 120 credits remaining · Resets in 18 days                  │   │
│ │ Usage rate: 15/day avg · Estimated depletion: 8 days ⚠️      │   │
│ │ ⚠️ Dự kiến hết credit trước khi reset! Mua thêm để tiếp tục.│   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Credit Packs ────────────────────────────────────────────────┐   │
│ │ ┌───────────────┐ ┌───────────────┐ ┌─────────────────────┐  │   │
│ │ │ 📦 100 credits│ │ 📦 300 credits│ │ ⭐ 500 credits      │  │   │
│ │ │ 99,000đ       │ │ 249,000đ      │ │ 399,000đ            │  │   │
│ │ │ 990đ/cr       │ │ 830đ/cr       │ │ 798đ/cr             │  │   │
│ │ │               │ │ Save 16%      │ │ Save 20% ⭐ Best    │  │   │
│ │ │ [Mua]         │ │ [Mua]         │ │ [Mua ⭐]            │  │   │
│ │ └───────────────┘ └───────────────┘ └─────────────────────┘  │   │
│ │                                                                │   │
│ │ ┌────────────────────┐                                         │   │
│ │ │ 🏢 1,000 credits   │                                         │   │
│ │ │ 699,000đ · 699đ/cr │                                         │   │
│ │ │ Save 29% · Business│                                         │   │
│ │ │ [Mua]               │                                        │   │
│ │ └────────────────────┘                                         │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Auto-Refill ────────────────────────────────────────────────┐    │
│ │ Enable: [☐ OFF] — Auto-buy when credits fall below threshold │    │
│ │ Trigger at: [50 ▾] credits remaining                          │    │
│ │ Auto-buy pack: [100 credits (99,000đ) ▾]                     │    │
│ │ Monthly cap: [300,000đ ▾]                                     │    │
│ │ Payment: [💳 Visa ****4242 ▾]                                 │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Purchase History ───────────────────────────────────────────┐    │
│ │ 25/3 · 100 credits · 99,000đ · Visa ****4242 · ✅           │    │
│ │ 10/3 · 300 credits · 249,000đ · Visa ****4242 · ✅          │    │
│ │ [Xem tất cả →]                                                │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ Payment method: [💳 Visa ****4242] [+ Thêm thẻ]                    │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Pack cards shimmer |
| LOADED | Packs available | Pack cards with balance |
| PURCHASING | Stripe checkout | Spinner: "Đang xử lý thanh toán..." |
| PURCHASED | Payment success | "✅ Đã mua {n} credits. Balance: {new_total}" |
| PAYMENT_FAILED | Card declined | "❌ Thanh toán thất bại: {reason}. [Thử lại]" |
| WILL_DEPLETE | Depletion before reset | Orange warning on balance |
| ERROR | API failed | Error with retry |

---

## 8. Edge Cases

| Edge Case | Handling |
|---|---|
| Depletion before reset | Orange warning: "⚠️ Dự kiến hết credit trước khi reset!" |
| Auto-refill hits monthly cap | Toast: "Đã đạt giới hạn tự động nạp tháng này." |
| No payment method saved | "Thêm phương thức thanh toán trước khi mua. [+ Thêm thẻ]" |
| Free plan user | Pack cards disabled: "Nâng cấp lên Pro để mua credits. [⬆ Nâng cấp]" |
| Stripe checkout abandoned | Return to page, no change. Toast: "Thanh toán bị hủy." |

---

## 9. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached balance | Retry online |
| Stripe checkout fail | Card declined | Return: "❌ Thanh toán thất bại: {reason}. [Thử lại]" | Retry |
| Auto-refill trigger fail | Stripe API error on auto-buy | Notification: "Tự động nạp thất bại. [Cập nhật thẻ]" | Update card |
| Balance fetch fail | API error | "Không tải được số dư. [Thử lại]" | Retry |
| Purchase history fail | API error | "Không tải được lịch sử. [Thử lại]" | Retry |

---

## 10. Accessibility

| Element | Requirement |
|---|---|
| Balance card | `role="status"`, `aria-label="120 credits remaining, estimated depletion in 8 days"` |
| Pack cards | `role="listitem"`, `aria-label="500 credits for 399,000 VND, 20% discount, best value"` |
| Buy buttons | `aria-label="Buy {n} credits for {price}"` |
| Auto-refill toggle | `role="switch"`, `aria-checked`, `aria-label="Auto-refill: {on/off}"` |
| Purchase history | `role="table"`, date/amount/status headers |

---

## 11. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Balance + pack card skeletons |
| Balance | 100-300ms | Balance populates with depletion estimate |
| Pack cards | 200-500ms | Cards fade in with prices |
| Purchase history | 300-600ms | Rows stagger in |
| Auto-refill | 200-400ms | Toggle state loads |

---

## 12. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `credit_purchase.viewed` | Page load | `credit_balance`, `days_to_depletion`, `source` |
| `credit_purchase.pack_selected` | "Mua" on pack | `pack_size`, `price`, `discount_pct` |
| `credit_purchase.checkout_completed` | Stripe webhook success | `pack_size`, `price`, `session_id` |
| `credit_purchase.checkout_failed` | Stripe decline | `pack_size`, `error_type` |
| `credit_purchase.checkout_abandoned` | User closes Stripe | `pack_size` |
| `credit_purchase.autorefill_toggled` | Toggle auto-refill | `enabled`, `trigger_threshold`, `pack_size` |
| `credit_purchase.autorefill_cap_changed` | Monthly cap changed | `old_cap`, `new_cap` |
| `credit_purchase.history_viewed` | "Xem tất cả" | `purchase_count` |

---

## 13. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/settings/credits/purchase/+page.svelte`
- **Server load**: `+page.server.ts` → `CreditService/GetBalance` + `CreditService/ListPackages` + `CreditService/GetAutoRefillConfig` + `BillingService/ListCreditPurchases(limit:3)`
- **Buy flow**: Click "Mua" → server creates Stripe Checkout Session → redirect → return with `?checkout=success&session_id=xxx`
- **Post-checkout**: Poll `CreditService/GetCheckoutStatus(session_id)` every 2s for 30s
- **Auto-refill**: `CreditService/UpdateAutoRefill(config)` → background job checks balance hourly
- **Depletion estimate**: `credit_balance / avg_daily_usage` computed server-side
- **Pack discount**: Static config, percentage discount computed from base price
- **Tier gate**: Free/Starter → redirect to upgrade page

---

## 14. Localization Notes

- Balance: "🪙 120 credits còn lại"
- Depletion: "Dự kiến hết trong 8 ngày ⚠️"
- Packs: "Giảm 20%", "⭐ Tiết kiệm nhất"
- Auto-refill: "Tự động nạp khi credit dưới {n}"
- Currency: VND with đ suffix (99.000đ)
- Tone: Urgent when low, celebratory on purchase

---

## 15. Design Tokens

| Token | Usage |
|---|---|
| `--color-accent` | Buy CTA |
| `--color-success` | ✅ Purchase success, balance bar (healthy) |
| `--color-warning` | ⚠️ Depletion warning, balance bar (low) |
| `--color-danger` | ❌ Payment failed |
| `--color-surface-elevated` | Pack cards |
| `--color-pack-best` | ⭐ Best value pack highlight |
| `--color-discount` | 🏷 Discount badge |
| `--font-metric` | Credit numbers, prices (tabular-nums) |
| `--color-text-secondary` | Per-credit cost, descriptions |

---

## 16. Related Screens

| Screen | Relationship |
|---|---|
| [W124] Credit Usage | Usage tracking |
| [W125] AI Settings | Credit limits |
| [W093] Billing | Payment methods |

---

## 17. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 edge cases (depletion, cap), 5 errors (Stripe fail, auto-refill), pack card a11y, 8 analytics, SvelteKit impl (Stripe checkout, auto-refill), localization, 9 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
