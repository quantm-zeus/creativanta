# Screen: Mobile — Billing & Subscription

> **Screen ID**: M061
> **Module**: M23 — Reporting / Admin / Billing / Diagnostics
> **Route**: `/m/settings/billing`
> **Platform**: Mobile (Flutter)
> **Upstream**: Pack 08 §Pricing/Credits, A1 Schema (subscriptions, invoices, billing_events), B5 RBAC §2.9

---

## 1. Purpose & Context

Mobile billing management — view current plan, usage breakdown, upgrade/downgrade, payment method management, and invoice history. Optimized for quick plan checks and upgrade decisions on mobile.

### User Story
> As a user on mobile, I want to quickly check my subscription status, remaining credits, and upgrade if needed.

### Business Goal
- Enable mobile-first plan upgrades (capture upgrade intent immediately)
- Reduce support tickets about billing by making status self-evident
- Surface usage warnings early to drive timely upgrades

### When to Use
- Checking remaining AI credits
- Upgrading plan when hitting limits
- Viewing invoice history
- Managing payment methods

### Entry Points
- Settings → "💳 Billing & Thanh toán"
- Dashboard low-credit alert → "Nạp thêm" → this screen
- Push notification: "Credits sắp hết" → deep link
- Upsell banner → "Nâng cấp" → this screen

### Exit Points
- "Nâng cấp" → Plan selection bottom sheet → in-app purchase or web redirect
- "Tải hóa đơn" → PDF download
- ← back → Settings
- "Quản lý thanh toán" → Payment method editor

---

## 2. Preconditions / Postconditions

### Preconditions
- User is authenticated
- User is Owner (for billing actions)
- User is any role (for viewing own plan)

### Postconditions
- Plan changes take effect immediately (upgrade) or at end of billing cycle (downgrade)
- Payment method updates saved to payment processor
- Invoice PDFs downloadable

---

## 3. Layout Structure

### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Billing & Thanh toán                                               │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│ ┌─ Current Plan Card ─────────────────────────────────────────────┐  │
│ │ ⭐ Pro Plan                                                     │  │
│ │ 699.000đ / tháng                                                │  │
│ │                                                                 │  │
│ │ Trạng thái: 🟢 Hoạt động                                       │  │
│ │ Gia hạn: 01/04/2026                                            │  │
│ │                                                                 │  │
│ │ ┌─ Credits ───────────────────────────────────────────────┐     │  │
│ │ │ 🤖 AI Credits  ████████████░░░  320/500 (64%)          │     │  │
│ │ │ Hết hạn: 01/04/2026                                    │     │  │
│ │ └─────────────────────────────────────────────────────────┘     │  │
│ │                                                                 │  │
│ │ ┌─ Storage ───────────────────────────────────────────────┐     │  │
│ │ │ 📁 Lưu trữ     ██████░░░░░░░░░  2.1/10 GB (21%)       │     │  │
│ │ └─────────────────────────────────────────────────────────┘     │  │
│ │                                                                 │  │
│ │ ┌─ Connected ─────────────────────────────────────────────┐     │  │
│ │ │ 🔗 Kết nối      3/15 tài khoản                         │     │  │
│ │ └─────────────────────────────────────────────────────────┘     │  │
│ │                                                                 │  │
│ │ [📈 Nâng cấp Business]          [⏸ Hạ cấp]                   │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ Quick Actions ─────────────────────────────────────────────────┐  │
│ │ [🪙 Mua thêm credits]    [📊 Xem chi tiết sử dụng]           │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ Payment Method ────────────────────────────────────────────────┐  │
│ │ 💳 Visa ****4242                     Hết hạn: 12/2028          │  │
│ │ [✏️ Thay đổi]   [+ Thêm phương thức dự phòng]                 │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ Invoices ──────────────────────────────────────────────────────┐  │
│ │ Lịch sử hóa đơn                                                │  │
│ │                                                                 │  │
│ │ T3/2026 · Pro · 699.000đ · 🟢 Đã thanh toán     [📥 PDF]     │  │
│ │ T2/2026 · Pro · 699.000đ · 🟢 Đã thanh toán     [📥 PDF]     │  │
│ │ T1/2026 · Starter · 299.000đ · 🟢 Đã thanh toán [📥 PDF]     │  │
│ │                                                                 │  │
│ │ [Xem tất cả hóa đơn →]                                        │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [📋] [➕] [💬] [👤]                                            │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
BillingScreen
├── AppBar
│   ├── BackButton
│   └── Title ("Billing & Thanh toán")
├── ScrollableContent
│   ├── CurrentPlanCard
│   │   ├── PlanBadge (star icon + plan name)
│   │   ├── PriceDisplay (formatted VND)
│   │   ├── StatusRow
│   │   │   ├── StatusBadge (🟢 Active / 🟡 Expiring / 🔴 Cancelled)
│   │   │   └── RenewalDate
│   │   ├── UsageBar (credits)
│   │   │   ├── ProgressBar (color-coded: green >50%, yellow 20-50%, red <20%)
│   │   │   ├── UsageLabel ("320/500")
│   │   │   └── ExpiryNote
│   │   ├── UsageBar (storage)
│   │   ├── UsageBar (connected accounts)
│   │   └── ActionButtons
│   │       ├── UpgradeButton (primary CTA)
│   │       └── DowngradeButton (secondary, muted)
│   ├── QuickActionsRow
│   │   ├── BuyCreditsButton
│   │   └── UsageDetailButton
│   ├── PaymentMethodCard
│   │   ├── CardIcon (Visa/Mastercard/etc)
│   │   ├── MaskedCardNumber
│   │   ├── ExpiryDate
│   │   ├── ChangeButton
│   │   └── AddBackupButton
│   └── InvoiceSection
│       ├── SectionHeader ("Lịch sử hóa đơn")
│       ├── InvoiceRow[] (last 3)
│       │   ├── PeriodLabel
│       │   ├── PlanName
│       │   ├── Amount (formatted VND)
│       │   ├── PaymentStatusBadge
│       │   └── DownloadPDFButton
│       └── ViewAllLink
├── BottomNavBar (shared)
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Plan name | `subscriptions.plan_tier` | `BillingService/GetCurrentPlan` | "Pro Plan" with ⭐ icon | 10m TTL |
| Price | `subscriptions.amount` | same | `Intl.NumberFormat('vi-VN')` + "đ / tháng" | 10m TTL |
| Status | `subscriptions.status` | same | 🟢/🟡/🔴 + Vietnamese label | 10m TTL |
| Renewal date | `subscriptions.next_billing_date` | same | DD/MM/YYYY | 10m TTL |
| Credit usage | `ai_credit_transactions` aggregated balance | `CreditService/GetBalance` | "320/500 (64%)" + progress bar | 5m TTL |
| Storage | `workspace_storage.used_bytes` | `WorkspaceService/GetUsage` | "{n}/{max} GB" + progress bar | 15m TTL |
| Connected accounts | `connected_accounts` count | `ConnectorService/CountActive` | "{n}/{max} tài khoản" | 10m TTL |
| Payment method | `payment_methods` | `BillingService/GetPaymentMethods` | Card type icon + "****{last4}" | 30m TTL |
| Invoices | `invoices` | `BillingService/ListInvoices(limit=3)` | Period + plan + amount + status | No cache |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | Upgrade plan | Tap "📈 Nâng cấp Business" | — | — | Open PlanSelectionSheet (bottom sheet) | Owner |
| 2 | Confirm upgrade | Select plan → confirm | `BillingService/ChangePlan(tier)` | `subscription.plan = new_tier` | Toast "Nâng cấp thành công! 🎉" + refresh | Owner |
| 3 | Downgrade plan | Tap "⏸ Hạ cấp" | — | — | Open downgrade confirmation dialog | Owner only |
| 4 | Confirm downgrade | Confirm in dialog | `BillingService/ChangePlan(tier)` | `subscription.scheduled_change` | Toast "Plan sẽ thay đổi vào {date}" | Owner only |
| 5 | Buy credits | Tap "🪙 Mua thêm credits" | — | — | Navigate → Credit Purchase screen | Owner |
| 6 | View usage detail | Tap "📊 Xem chi tiết sử dụng" | — | — | Navigate → Credit Usage Detail screen | Any |
| 7 | Change payment method | Tap "✏️ Thay đổi" | — | — | Open payment method editor (Stripe/Paddle UI) | Owner |
| 8 | Add backup payment | Tap "+ Thêm phương thức dự phòng" | — | — | Open add payment flow | Owner |
| 9 | Download invoice | Tap "📥 PDF" on invoice row | `BillingService/GetInvoiceUrl(id)` | — | Open PDF in system viewer | Owner/Admin |
| 10 | View all invoices | Tap "Xem tất cả hóa đơn" | — | — | Navigate → full invoice list | Owner/Admin |
| 11 | Cancel subscription | From downgrade → "Hủy gói" | `BillingService/CancelPlan` | `subscription.status = cancelled` | Confirmation + grace period banner | Owner only |

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching billing data | Shimmer cards matching layout |
| LOADED | All data available | Full billing page with plan + payment + invoices |
| LOW_CREDITS | Credits < 20% remaining | Orange progress bar + warning badge "⚠️ Credits sắp hết" |
| CREDITS_EXHAUSTED | Credits = 0 | Red progress bar + "❌ Hết credits. [Mua thêm →]" prominent CTA |
| EXPIRING_SOON | Plan expires < 7 days | Orange banner: "⚠️ Gói của bạn hết hạn trong {n} ngày. [Gia hạn →]" |
| CANCELLED | Plan cancelled, in grace period | Red banner: "Plan đã hủy. Hoạt động đến {date}. [Kích hoạt lại]" |
| PAYMENT_FAILED | Last payment failed | Red banner: "❌ Thanh toán thất bại. Cập nhật phương thức thanh toán để tiếp tục. [Cập nhật →]" |
| DOWNGRADE_SCHEDULED | Downgrade pending | Info banner: "Plan sẽ chuyển sang {plan} vào {date}" |
| FREE_TIER | User on free plan | No payment method section. Prominent upgrade CTA. |
| ERROR | API failure | Full-page error state with retry |
| NO_PAYMENT_METHOD | Owner, no card on file | Warning: "Chưa có phương thức thanh toán. [Thêm ngay]" |

---

## 8. Validation Rules

| Field | Rule | Error Message |
|---|---|---|
| Downgrade confirmation | Must acknowledge feature loss | "Bạn sẽ mất quyền truy cập: {lost_features}. Xác nhận?" |
| Cancellation | Must type "HỦY" | "Vui lòng nhập 'HỦY' để xác nhận" |
| Payment method | Valid card via Stripe/Paddle SDK | SDK-provided error messages |

---

## 9. Permission Matrix

| Action | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View billing page | ✅ | ✅ | ✅ (limited) | ✅ (plan only) | ✅ (plan only) | ✅ (plan only) | ❌ |
| View invoices | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Upgrade/downgrade | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Cancel plan | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Manage payment | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Buy credits | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Download invoice | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |

---

## 10. Navigation Map

```
Billing (/m/settings/billing)
├── → PlanSelectionSheet (via Upgrade)
├── → DowngradeDialog (via Downgrade)
├── → /m/settings/credits/purchase (via Buy Credits)
├── → /m/settings/credits/usage (via Usage Detail)
├── → Stripe/Paddle payment UI (via Change/Add payment)
├── → PDF viewer (via Invoice download)
├── → /m/settings/billing/invoices (via View All)
└── ← /m/settings (via back)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network error | No connectivity | Full-page offline state + cached plan data | Pull-to-refresh when online |
| API error (5xx) | Server failure | Toast: "Không tải được thông tin. Thử lại." | Pull-to-refresh |
| Payment failed (upgrade) | Card declined | Dialog: "Thanh toán thất bại. Kiểm tra thẻ hoặc thử phương thức khác." | Retry or change card |
| Downgrade not allowed | Enterprise contract | Toast: "Liên hệ sales để thay đổi gói Enterprise." | Contact info shown |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Progress bars | `aria-valuenow`, `aria-valuemin`, `aria-valuemax`, `aria-label` |
| Status badges | Text + color (not color alone) |
| Plan cards | Semantic grouping with `Semantics` labels |
| Action buttons | Minimum 48x48 tap target |
| Invoice list | Each row is independently focusable |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | App bar visible, shimmer cards |
| Data load | 200-500ms | Progressive: Plan card → Quick actions → Payment → Invoices |
| Upgrade flow | 2-5s | Bottom sheet → spinner → success animation |
| PDF download | 1-3s | Download indicator in system notification tray |

---

## 14. Performance Requirements

| Metric | Target |
|---|---|
| Screen render | <1.5s |
| Data fetch | <500ms |
| Upgrade flow | <3s end-to-end |

---

## 15. Real-time Updates

| Data | Channel | Frequency |
|---|---|---|
| Credit balance | Polling | 5m (matches web) |
| Payment status | Push notification | Real-time (payment success/failure) |

---

## 16. Localization Notes

- Currency: VND with dot separator (699.000đ — no decimals)
- Date format: DD/MM/YYYY
- Invoice periods: "T3/2026" (Tháng 3/2026)
- Tone: Professional, clear, no pressure (no dark patterns)

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `billing.viewed` | Screen load | `current_plan`, `credit_pct_remaining` |
| `billing.upgrade_tapped` | Tap upgrade | `current_plan`, `target_plan` |
| `billing.upgrade_confirmed` | Upgrade complete | `old_plan`, `new_plan`, `price` |
| `billing.credits_buy_tapped` | Tap buy credits | `current_balance` |
| `billing.invoice_downloaded` | Tap PDF | `invoice_id`, `period` |
| `billing.cancellation_initiated` | Start cancel | `current_plan` |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-success` | Active status, paid invoice badge |
| `--color-warning` | Low credits, expiring soon |
| `--color-danger` | Cancelled, payment failed, exhausted |
| `--color-accent` | Upgrade CTA button |
| `--spacing-card` | Card inner padding (16px) |
| `--radius-card` | Card border radius (12px) |

---

## 19. Related Screens

| Screen | Relationship |
|---|---|
| [W119] Web Billing & Plans | Web equivalent (more detailed) |
| [W120] Web AI Credits | Web credit management |
| [W128] Web Credit Purchase | Web credit purchase flow |
| [M057] Mobile Settings | Parent screen |
| [M060] Mobile Copilot | "Nâng cấp" suggested when credit limit hit |

---

## 20. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 3.0 | Full 20-point upgrade from 61-line Tier C. Added component hierarchy, full actions table, permission matrix, 11 states, validation rules, navigation map, error handling, accessibility, analytics, design tokens. Fixed wrong module reference (M26→M23). | System |
| 2026-03-28 | 2.0 | Expanded from 55-line sparse | System |
| 2026-03-28 | 1.0 | Initial specification | System |
