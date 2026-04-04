# Screen: Web — Settings: Billing & Plan

> **Screen ID**: W119
> **Module**: M23 — Settings
> **Route**: `/settings/billing`
> **Platform**: Web (SvelteKit)
> **Upstream**: Product Freeze §27, A1 Schema (subscriptions, subscription_plans, payment_methods, invoices, ai_credit_transactions), B5 RBAC §2.19

---

## 1. Purpose & Context

The Billing & Plan screen is the financial command center for workspace subscription management. Creators can view their current plan and usage, upgrade/downgrade between tiers, purchase additional AI credits, manage payment methods (via Stripe), view billing history with downloadable invoices, and handle cancellation. This screen directly impacts revenue and must handle edge cases (failed payments, expired cards, mid-cycle changes) with precision.

### User Story
> As a workspace owner, I want to manage my subscription plan, view how much I'm using, buy more AI credits when running low, and access my invoices for accounting — all from one screen.

### Business Goals
- Enable seamless self-service plan upgrades (reduce support tickets)
- Drive AI credit purchases when usage is high
- Reduce involuntary churn from payment failures (clear recovery flows)
- Provide transparent billing history for trust and compliance
- Support retention by offering downgrade alternatives to cancellation

### When This Screen Is Used
- **Plan evaluation**: Creator considering upgrading to unlock more features/credits
- **Mid-month credit purchase**: Running low on AI credits, needs top-up
- **Payment issue**: Card expired or payment failed → needs to update method
- **Accounting**: Download invoices for tax/business records
- **Cancellation**: Creator wants to cancel (retention flow)
- **Team growth**: Upgrading plan to add more team seats

### Entry Points
- Settings Hub ([W008]): "💳 Thanh toán & Gói dịch vụ"
- Credit usage warning: "AI credits còn 120/500 [Nạp thêm →]" from any screen
- Morning Brief warning: "Credits hết trong ~3 ngày [Nạp thêm →]"
- Invoice email: "Xem hóa đơn" link in email → deep link
- Direct URL: `/settings/billing`

### Exit Points
- Stripe Checkout: External redirect for payment → return to `/settings/billing?success=true`
- Stripe Customer Portal: External redirect for card management → return
- "← Settings" → `/settings` (Settings Hub)

---

## 2. Preconditions / Postconditions

### Preconditions
- User authenticated with valid session
- User has `workspace:billing:manage` permission (Owner role only for plan changes; Admin can view)
- Workspace has a subscription record (created during onboarding)
- Stripe customer ID linked to workspace

### Postconditions
- Plan changes → subscription updated via Stripe webhook → `subscriptions` table updated
- Credit purchases → Stripe checkout → `ai_credit_transactions` credited via webhook
- Payment method updates → reflected in Stripe → cached locally
- Invoice downloads → direct Stripe-hosted PDF URL

---

## 3. Screen Layout

### Responsive Behavior
| Breakpoint | Layout |
|---|---|
| Desktop (≥1280px) | Settings Shell (sidebar 240px) + Single-column content (max-width: 800px) |
| Tablet (768-1279px) | Settings Shell (collapsed sidebar) + Full-width content |
| Mobile (≤767px) | Redirect to Mobile Billing equivalent |

### ASCII Wireframe
```
┌─ Settings Shell ─────────────────────────────────────────────────────┐
│ ← Settings   💳 Thanh toán & Gói dịch vụ                            │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ Current Plan ────────────────────────────────────────────────────┐│
│ │ 💎 Pro Plan                                                        ││
│ │ 499.000 VND/tháng                                                  ││
│ │ ─────────────────────────────────────────────────────────          ││
│ │ Next billing: 15/04/2026 · Auto-renew: ✅ ON                       ││
│ │                                                                     ││
│ │ Credits:  [████████░░░░░░] 320 / 1.000 còn lại                     ││
│ │           Resets: 15/04 · ~10 ngày nữa                             ││
│ │ Storage:  [█████░░░░░░░░░] 4.2 GB / 10 GB                         ││
│ │ Members:  3 / 5 seats                                               ││
│ │ Channels: 3 / 5 connected                                          ││
│ │                                                                     ││
│ │ [📊 Chi tiết sử dụng] [⬆ Nâng cấp gói] [⏸ Hủy gói đăng ký]     ││
│ └─────────────────────────────────────────────────────────────────── ┘│
│                                                                      │
│ ┌─ Mua thêm Credits ───────────────────────────────────────────────┐│
│ │ ┌──────────┐ ┌──────────────┐ ┌───────────────┐                  ││
│ │ │ 🪙 100   │ │ 🪙 500       │ │ 🪙 1.000      │                  ││
│ │ │ credits  │ │ credits      │ │ credits       │                  ││
│ │ │ 99.000đ  │ │ 399.000đ     │ │ 699.000đ      │                  ││
│ │ │          │ │ 🏷 Giảm 20%  │ │ 🏷 Giảm 30%   │                  ││
│ │ │ [Mua]    │ │ [Mua]        │ │ [Mua] ⭐      │                  ││
│ │ └──────────┘ └──────────────┘ └───────────────┘                  ││
│ │ Credits mua thêm không reset, dùng đến khi hết.                  ││
│ └─────────────────────────────────────────────────────────────────── ┘│
│                                                                      │
│ ┌─ Phương thức thanh toán ─────────────────────────────────────────┐│
│ │ 💳 **** **** **** 4242 · Visa · Expires 12/27      [Primary]     ││
│ │    [✏ Thay đổi thẻ]                                              ││
│ │                                                                    ││
│ │ [+ Thêm phương thức dự phòng]                                     ││
│ └─────────────────────────────────────────────────────────────────── ┘│
│                                                                      │
│ ┌─ ⚠ Payment Alert (conditional) ─────────────────────────────────┐│
│ │ 🔴 Thanh toán thất bại ngày 15/03. Thẻ *4242 bị từ chối.       ││
│ │ Dịch vụ sẽ bị tạm ngưng sau 7 ngày nếu không cập nhật.         ││
│ │ [💳 Cập nhật thẻ ngay] [📧 Gửi hóa đơn qua email]              ││
│ └─────────────────────────────────────────────────────────────────── ┘│
│                                                                      │
│ ┌─ Lịch sử thanh toán ────────────────────────────────────────────┐│
│ │ Date          Description        Amount        Status  Invoice  ││
│ │ ──────────────────────────────────────────────────────────────── ││
│ │ 15/03/2026   Pro Plan (monthly)  499.000đ      ✅ Paid [📄]    ││
│ │ 01/03/2026   AI Credits (500)    399.000đ      ✅ Paid [📄]    ││
│ │ 15/02/2026   Pro Plan (monthly)  499.000đ      ✅ Paid [📄]    ││
│ │ 15/01/2026   Pro Plan (monthly)  499.000đ      ✅ Paid [📄]    ││
│ │ ──────────────────────────────────────────────────────────────── ││
│ │ [Tải thêm ↓]                                                    ││
│ └─────────────────────────────────────────────────────────────────── ┘│
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
SettingsBillingPage
├── SettingsShell (shared settings layout)
│   ├── SettingsSidebar (billing highlighted)
│   └── TopBar
├── PageHeader
│   ├── BackLink ("← Settings")
│   └── Title ("💳 Thanh toán & Gói dịch vụ")
├── CurrentPlanCard
│   ├── PlanBadge (💎 Pro / 🥈 Starter / 🆓 Free)
│   ├── PriceLine ("499.000 VND/tháng")
│   ├── BillingCycle ("Next billing: 15/04/2026 · Auto-renew: ✅ ON")
│   ├── UsageMetrics
│   │   ├── CreditsBar (progress bar + "320 / 1.000 còn lại" + reset date)
│   │   ├── StorageBar (progress bar + "4.2 GB / 10 GB")
│   │   ├── MembersCount ("3 / 5 seats")
│   │   └── ChannelsCount ("3 / 5 connected")
│   └── ActionBar
│       ├── UsageDetailButton ("📊 Chi tiết sử dụng") → modal/drawer
│       ├── UpgradeButton ("⬆ Nâng cấp gói") → PlanComparisonModal
│       └── CancelButton ("⏸ Hủy gói đăng ký") → CancellationFlow
├── CreditPurchaseSection
│   ├── SectionHeader ("Mua thêm Credits")
│   ├── CreditTierCard[] (3 tiers in grid)
│   │   ├── CreditAmount (100 / 500 / 1,000)
│   │   ├── Price ("99.000đ" etc.)
│   │   ├── DiscountBadge ("🏷 Giảm 20%" — conditionally shown)
│   │   ├── PopularBadge (⭐ on best-value tier)
│   │   └── BuyButton ("Mua") → Stripe Checkout
│   └── Note ("Credits mua thêm không reset, dùng đến khi hết.")
├── PaymentMethodSection
│   ├── SectionHeader ("Phương thức thanh toán")
│   ├── PrimaryCard
│   │   ├── CardIcon (Visa/Mastercard/etc.)
│   │   ├── CardLast4 ("**** 4242")
│   │   ├── ExpiryDate ("Expires 12/27")
│   │   ├── PrimaryBadge ("[Primary]")
│   │   └── ChangeButton ("✏ Thay đổi thẻ") → Stripe Customer Portal
│   └── AddBackupButton ("+ Thêm phương thức dự phòng")
├── PaymentAlertBanner (conditional — shown when payment failed)
│   ├── AlertIcon (🔴)
│   ├── AlertMessage ("Thanh toán thất bại... tạm ngưng sau 7 ngày")
│   ├── UpdateCardButton ("💳 Cập nhật thẻ ngay")
│   └── SendInvoiceButton ("📧 Gửi hóa đơn qua email")
├── BillingHistorySection
│   ├── SectionHeader ("Lịch sử thanh toán")
│   ├── InvoiceTable
│   │   └── InvoiceRow[]
│   │       ├── Date ("15/03/2026")
│   │       ├── Description ("Pro Plan (monthly)")
│   │       ├── Amount ("499.000đ")
│   │       ├── StatusBadge ("✅ Paid" / "❌ Failed" / "⏳ Pending")
│   │       └── DownloadButton ("📄" → Stripe invoice PDF)
│   └── LoadMoreButton ("Tải thêm ↓")
├── PlanComparisonModal (when "⬆ Nâng cấp" clicked)
│   ├── PlanColumn[] (Free / Starter / Pro / Enterprise)
│   │   ├── PlanName + Price
│   │   ├── FeatureList (credits, storage, members, channels, AI features)
│   │   └── SelectButton ("Chọn gói này" → Stripe Checkout)
│   └── FAQSection
├── CancellationModal (when "⏸ Hủy" clicked)
│   ├── RetentionOffer ("Giảm 50% cho 2 tháng tiếp theo?")
│   ├── DowngradeOption ("Hoặc chuyển xuống Starter?")
│   ├── ReasonSelector (checkbox list: too expensive, not using enough, etc.)
│   └── ConfirmCancelButton ("Xác nhận hủy — giữ đến 15/04")
└── UsageDetailDrawer (when "📊 Chi tiết" clicked)
    ├── CreditBreakdown (by type: text gen, image gen, voice, etc.)
    ├── StorageBreakdown (by asset type: video, image, audio)
    └── DailyUsageChart
```

---

## 5. Displayed Data / Data Binding

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Current plan name | `subscriptions.plan_id → subscription_plans.name` | `BillingService/GetSubscription(workspace_id)` | Badge + name ("💎 Pro Plan") | 5m TTL |
| Plan price | `subscription_plans.price_monthly` | Same | "499.000 VND/tháng" (VND compact) | 5m TTL |
| Next billing | `subscriptions.current_period_end` | Same | "15/04/2026" (DD/MM/YYYY) | 5m TTL |
| Auto-renew status | `subscriptions.auto_renew` | Same | "✅ ON" / "⏸ OFF" | 5m TTL |
| Credit balance | `ai_credit_transactions` aggregated | `CreditService/GetBalance(workspace_id)` | "320 / 1.000 còn lại" + progress bar | 1m TTL |
| Credit reset date | `subscriptions.current_period_end` | Same | "Resets: 15/04" | 5m TTL |
| Storage used | `workspace_usage.storage_bytes` | `UsageService/GetStorageUsage` | "4.2 GB / 10 GB" + progress bar | 5m TTL |
| Member count | `workspace_members.count` | `WorkspaceService/GetMemberCount` | "3 / 5 seats" | 5m TTL |
| Channel count | `connectors.count WHERE active=true` | `ConnectorService/CountActive` | "3 / 5 connected" | 5m TTL |
| Credit tiers | `credit_packages` config table | `BillingService/ListCreditPackages` | Price cards with discounts | 1h TTL |
| Payment method | Stripe Customer → PaymentMethods | `BillingService/GetPaymentMethods` | Card type + last 4 + expiry | 5m TTL |
| Payment alert | `subscriptions.payment_status` | `BillingService/GetSubscription` | Alert banner if status = "past_due" | Real-time |
| Billing history | Stripe invoices | `BillingService/ListInvoices(page)` | Invoice table rows | 15m TTL |

### Plan Comparison Matrix
| Feature | Free (0đ) | Starter (199K) | Pro (499K) | Enterprise (Custom) |
|---|---|---|---|---|
| AI Credits/month | 50 | 300 | 1,000 | Unlimited |
| Storage | 1 GB | 5 GB | 10 GB | 50 GB |
| Team members | 1 | 3 | 5 | Unlimited |
| Connected channels | 2 | 3 | 5 | Unlimited |
| AI Studio access | ❌ | Basic | Full | Full + Priority |
| Trend Intelligence | ❌ | ❌ | ✅ | ✅ + Custom |
| Priority support | ❌ | ❌ | ✅ | ✅ + Dedicated |

---

## 6. User Actions

| # | Action | Trigger | API Call | System Response | Permission |
|---|---|---|---|---|---|
| 1 | View usage details | "📊 Chi tiết" | `UsageService/GetBreakdown` | Drawer slides in with credit/storage breakdown | `workspace:billing:read` |
| 2 | Open plan comparison | "⬆ Nâng cấp gói" | `BillingService/ListPlans` | Modal with plan comparison grid | `workspace:billing:manage` |
| 3 | Select plan (upgrade) | Click "Chọn gói này" in modal | Redirect → Stripe Checkout | External: Stripe checkout → return on success | `workspace:billing:manage` |
| 4 | Downgrade plan | Select lower plan in modal → confirm | `BillingService/ChangePlan(plan_id)` | Plan changes at end of current period | `workspace:billing:manage` |
| 5 | Buy credits | Click "Mua" on credit tier | Redirect → Stripe Checkout | External: Stripe checkout → credits added on success webhook | `workspace:billing:manage` |
| 6 | Change payment method | "✏ Thay đổi thẻ" | Redirect → Stripe Customer Portal | External: update card → return | `workspace:billing:manage` |
| 7 | Add backup method | "+ Thêm phương thức" | Redirect → Stripe Customer Portal | External: add card → return | `workspace:billing:manage` |
| 8 | Download invoice | Click "📄" on invoice row | Direct URL → Stripe-hosted PDF | PDF opens in new tab | `workspace:billing:read` |
| 9 | Cancel subscription | "⏸ Hủy" → reason → confirm | `BillingService/Cancel(workspace_id, reason)` | Cancellation scheduled at period end. Toast: "Gói sẽ hết hiệu lực ngày 15/04" | `workspace:billing:manage` |
| 10 | Accept retention offer | "Giảm 50%" in cancellation modal | `BillingService/ApplyRetentionDiscount(workspace_id)` | Discount applied. Modal closes. Toast: "Đã áp dụng ưu đãi! Giảm 50% cho 2 tháng." | `workspace:billing:manage` |
| 11 | Update failed payment | "💳 Cập nhật thẻ ngay" | Redirect → Stripe Customer Portal | Card updated → payment retried automatically | `workspace:billing:manage` |
| 12 | Load more invoices | "Tải thêm ↓" on billing history | `BillingService/ListInvoices(page+1)` | More rows appended | `workspace:billing:read` |

---

## 7. States / State Machine

| State | Condition | Visual |
|---|---|---|
| LOADING | Page loading | Card skeletons for plan + payment + history |
| ACTIVE | Subscription active, payment OK | Green plan badge, all sections visible |
| TRIAL | On free trial period | Banner: "🎁 Dùng thử Pro — còn 7 ngày. [⬆ Nâng cấp]" |
| PAST_DUE | Payment failed, grace period | 🔴 Payment alert banner visible. "Cập nhật thẻ ngay" prominent. |
| CANCELING | Cancellation scheduled | Plan card shows: "⏸ Hủy vào 15/04. [↩ Khôi phục gói]" |
| CANCELED | Subscription ended | Plan shows Free tier. "⬆ Đăng ký lại" button. |
| FREE | On free plan (no subscription) | No billing history. Upgrade CTA prominent. |
| STRIPE_ERROR | Stripe API unreachable | "Không tải được thông tin thanh toán. [Thử lại]" |

---

## 8. Validation Rules

### Plan Change
| Rule | Constraint | Error Message |
|---|---|---|
| Downgrade seat limit | Cannot downgrade if current members > target plan seats | "Gói {plan} chỉ cho phép {n} thành viên. Hiện có {current}. [Xóa thành viên trước]" |
| Downgrade channel limit | Cannot downgrade if connected channels > target plan limit | "Gói {plan} chỉ cho phép {n} kênh. Hiện kết nối {current}. [Ngắt kết nối trước]" |
| Downgrade storage limit | Cannot downgrade if storage used > target plan limit | "Gói {plan} chỉ có {n}GB. Đang dùng {current}GB. [Xóa file trước]" |

### Credit Purchase
| Rule | Constraint | Error Message |
|---|---|---|
| Payment method required | Must have valid card | "Thêm phương thức thanh toán trước khi mua credits" |

---

## 9. Permission Matrix

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View billing page | ✅ | ✅ (read-only) | ❌ | ❌ | ❌ | ❌ | ❌ |
| View current plan | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| View credit balance | ✅ | ✅ | ✅ (via usage widget) | ❌ | ❌ | ❌ | ❌ |
| Upgrade/downgrade plan | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Purchase credits | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Change payment method | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Cancel subscription | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Download invoices | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |

### Critical Note
- **Only Owner can modify billing** (plan changes, payments, cancellation)
- Admin has read-only access for oversight
- All other roles see a generic "Liên hệ Owner để quản lý gói" if they navigate here

---

## 10. Navigation Map

```
Settings Billing (/settings/billing)
├── → Stripe Checkout (external)                    (Upgrade / Buy credits)
├── → Stripe Customer Portal (external)             (Change card)
├── → UsageDetailDrawer (inline)                     (Credit/storage breakdown)
├── → PlanComparisonModal (inline)                   (Plan compare & select)
├── → CancellationModal (inline)                     (Cancel flow + retention)
├── → Invoice PDF (external, new tab)                (Download invoice)
└── ← /settings                                     (Settings Hub)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Stripe API unreachable | Stripe timeout / network error | "Không tải được thông tin thanh toán. [Thử lại]" with partial page (show cached plan info) | Retry button |
| Checkout abandoned | User closes Stripe Checkout without completing | Return to billing page, no change. Toast: "Thanh toán bị hủy." | No action needed |
| Checkout failed | Card declined in Stripe | Return with `?error=payment_failed`. Banner: "Thẻ bị từ chối. Thử thẻ khác." | Re-initiate checkout |
| Payment method expired | Card expiry passed | Alert on payment section: "⚠ Thẻ *4242 hết hạn 12/25. [Cập nhật →]" | Update card |
| Subscription past due | Stripe payment retry failed (3 attempts) | 🔴 Prominent alert banner with countdown: "Tạm ngưng sau {n} ngày" | Update card + retry |
| Invoice download failed | Stripe PDF URL expired or unavailable | Toast: "Không tải được hóa đơn. [Thử lại]" | Retry generates new URL |
| Cancellation error | Server error during cancellation | Toast: "Không hủy được. [Thử lại]" | Retry |
| Webhook delay | Stripe webhook slow (>10s) | After checkout return: "Đang xử lý thanh toán..." spinner for 10s, then show success | Auto-poll for confirmation |
| Downgrade blocked | Exceeds target plan limits | Modal: specific blocker with action buttons (remove members, disconnect channels) | Complete pre-conditions first |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Plan card | `role="region"`, `aria-label="Current subscription: Pro Plan, 499,000 VND per month"` |
| Usage progress bars | `role="progressbar"`, `aria-valuenow`, `aria-valuemax`, `aria-label="AI credits: 320 of 1000 remaining"` |
| Credit tier cards | `role="listitem"`, `aria-label="500 credits for 399,000 VND, 20 percent discount"` |
| Payment card info | Mask all but last 4 digits. `aria-label="Visa card ending in 4242, expires December 2027"` |
| Payment alert | `role="alert"`, `aria-live="assertive"` |
| Invoice table | `role="table"` with proper `th` headers |
| Stripe redirects | `aria-label="Opens Stripe checkout in same window"` (inform user about redirect) |
| Color contrast | All text meets WCAG 2.1 AA (4.5:1 ratio) |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Shell render | 0ms | Settings shell renders (SSR). Sidebar visible. |
| Plan card | 100-400ms | Plan name and price appear. Usage bars animate from 0 to value. |
| Credit tiers | 200-500ms | Credit cards fade in with staggered animation |
| Payment method | 300-600ms | Card info loaded from Stripe (may be slower) |
| Billing history | 400-800ms | Invoice rows appear with staggered slide-in |

---

## 14. Performance Requirements

| Metric | Target | Measurement |
|---|---|---|
| LCP | < 2.0s | Current plan card (most important above-fold content) |
| FID | < 100ms | Click on upgrade/buy button |
| CLS | < 0.05 | Fixed layout — no shift when data loads |
| TTI | < 2.5s | All action buttons interactive |
| Stripe redirect | < 2s | Time from click to Stripe Checkout loading |

---

## 15. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| Credit balance | Polling | Every 1 minute (credits consumed by background AI jobs) |
| Payment status | Webhook-driven | Real-time via Stripe webhook → DB → SSE to client |
| Plan changes | Webhook-driven | Stripe webhook confirms plan change |

### Post-Checkout Return
- After Stripe Checkout success → redirect to `/settings/billing?checkout=success&session_id=xxx`
- Client polls `BillingService/GetCheckoutStatus(session_id)` every 2s for up to 30s
- Once confirmed: Toast "✅ Thanh toán thành công!" and data refreshes

---

## 16. Localization Notes

- Primary language: Vietnamese
- Currency: VND with dot separator ("499.000đ", "1.200.000đ") — NO decimals for VND
- Prices always include "đ" suffix or "VND" on first mention
- Dates: DD/MM/YYYY format ("15/04/2026")
- Percentage discounts: "Giảm 20%" with 🏷 tag icon
- Plan names: Vietnamese ("Gói Pro", "Gói Starter") but English brand names kept ("Pro", "Starter")
- Tone: Professional, trustworthy — "Thanh toán an toàn qua Stripe" for trust

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `billing.viewed` | Page load | `current_plan`, `credit_balance`, `credit_pct`, `source` |
| `billing.upgrade.started` | Click "Nâng cấp" → opens comparison modal | `current_plan`, `credit_balance` |
| `billing.upgrade.plan_selected` | Select plan in comparison modal | `current_plan`, `target_plan`, `price_diff` |
| `billing.upgrade.completed` | Stripe webhook confirms upgrade | `old_plan`, `new_plan`, `price`, `session_id` |
| `billing.credits.tier_viewed` | Credit purchase section scrolled into view | `credit_balance`, `credit_pct` |
| `billing.credits.purchased` | Stripe webhook confirms credit purchase | `tier` (100/500/1000), `amount_paid`, `session_id` |
| `billing.payment.updated` | Card updated via Stripe Portal | `card_brand`, `card_last4` |
| `billing.invoice.downloaded` | Click invoice PDF | `invoice_date`, `invoice_amount` |
| `billing.cancel.started` | Click "Hủy" → opens cancellation modal | `current_plan`, `months_subscribed`, `credit_balance` |
| `billing.cancel.retention_offered` | Retention offer shown | `offer_type` (discount/downgrade) |
| `billing.cancel.retention_accepted` | User accepts retention offer | `offer_type`, `offer_value` |
| `billing.cancel.confirmed` | Cancellation confirmed | `plan`, `reason`, `months_subscribed`, `credit_balance` |
| `billing.cancel.aborted` | User closes cancellation modal without confirming | `step_reached` |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-accent` | Upgrade CTA, "Mua" buttons |
| `--color-success` | ✅ Active subscription, paid invoices, successful checkout |
| `--color-warning` | Credit bar (when < 30% remaining), expiring card |
| `--color-danger` | 🔴 Payment failed alert, past-due banner, cancel button |
| `--color-surface-primary` | Page background |
| `--color-surface-elevated` | Plan card, credit tier cards, payment section |
| `--color-text-primary` | Plan names, prices, main content |
| `--color-text-secondary` | Billing cycle info, credit notes, invoice descriptions |
| `--color-border` | Card borders, table row separators |
| `--color-plan-free` | Free plan badge color (neutral grey) |
| `--color-plan-starter` | Starter plan badge color (silver/blue) |
| `--color-plan-pro` | Pro plan badge color (gold/amber) |
| `--color-plan-enterprise` | Enterprise plan badge color (deep accent) |
| `--font-metric` | Prices, credit numbers (tabular-nums) |
| `--radius-card` | Card border-radius (12px) |
| `--shadow-card` | Card elevation shadow |

---

## 19. Technical Implementation Notes

### SvelteKit Specifics
- **Route**: `src/routes/(app)/settings/billing/+page.svelte`
- **Server load**: `+page.server.ts` → fetch subscription, credit balance, payment methods, recent invoices
- **URL params**: `?checkout=success&session_id=xxx` (post-checkout return)

### Data Fetching Strategy
```
+page.server.ts:
  const [subscription, creditBalance, paymentMethods, invoices] = await Promise.all([
    billingService.getSubscription(workspaceId),
    creditService.getBalance(workspaceId),
    billingService.getPaymentMethods(workspaceId),  // Stripe API call
    billingService.listInvoices(workspaceId, { page: 1, limit: 10 })  // Stripe API
  ])
```

### Stripe Integration
- **Checkout Session**: Server-side `stripe.checkout.sessions.create()` → redirect to Stripe
- **Customer Portal**: Server-side `stripe.billingPortal.sessions.create()` → redirect
- **Webhooks**: Handle `checkout.session.completed`, `customer.subscription.updated`, `invoice.payment_failed`
- **Security**: Webhook signature verification with `stripe.webhooks.constructEvent()`

### Credit System
- **Monthly credits**: Reset on billing cycle date (from subscription)
- **Purchased credits**: Never reset, consumed after monthly credits are depleted
- **Deduction order**: Monthly → Purchased (FIFO within purchased batches)

### Cancellation Flow
1. User clicks "⏸ Hủy" → CancellationModal opens
2. Retention offer presented first (50% discount for 2 months)
3. If declined: downgrade to Starter option
4. If declined: reason selector → confirm
5. On confirm: `stripe.subscriptions.update({ cancel_at_period_end: true })`
6. Service remains active until `current_period_end`

---

## 20. Related Screens

| Screen | Relationship |
|---|---|
| [W007] Settings Hub | Parent navigation |
| [W121] Credit Usage Detail | Detailed credit/storage breakdown |
| [A021] Admin Subscriptions | Admin-side subscription management |
| [M057] Mobile Settings | Mobile equivalent (billing section) |

---

## 21. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Full Tier A rewrite**: Upgraded from 163-line Tier C with generic boilerplate to 500+ line full spec. Added: plan comparison matrix (Free/Starter/Pro/Enterprise), credit purchase tiers with discount logic, Stripe integration flow (Checkout Session, Customer Portal, Webhooks), cancellation flow with retention offer, payment failure recovery, downgrade validation rules, 13 analytics events, Owner-only permission enforcement. Removed all generic boilerplate. Standardized Screen ID from W93 to W119. | System |
| 2026-03-28 | 1.0 | Initial specification (Tier C) | System |
