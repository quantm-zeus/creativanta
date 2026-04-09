# Screen: Web — Coupon Manager

> **Screen ID**: W068
> **Module**: M14 — Monetization OS (Coupons)
> **Route**: `/coupons`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 06 §Commerce, Product Freeze §23, coupons schema + CouponService projections, B5 RBAC §2.7

---

## 1. Purpose & Context

Create and manage discount coupons across platforms with usage tracking, revenue impact analysis, and platform distribution. Coupons are the promotional instrument layer — used inside campaigns, shared via affiliate links, or distributed directly to customers.

### User Goals
- Create discount codes with configurable rules (%, fixed, free shipping, BOGO)
- Track redemption count and revenue impact per coupon
- Distribute codes across platforms with copy/share actions
- Pause expired or underperforming coupons

### Business Goals
- Drive conversion through strategic discounting
- Track discount impact on margin for profit optimization
- Prevent coupon abuse through limits and validation rules

### Entry Points
- Sidebar: Commerce → "🎟️ Mã giảm giá"
- Offer List (W066): "Create coupon" from offer
- Campaign Detail (W065): linked coupons section
- Copilot: "Tạo mã giảm giá 20% cho Serum VitC"

### Exit Points
- Click coupon → Coupon Detail/Edit
- "📊 Stats" → Coupon analytics view
- Click platform badge → Platform connector settings

---

## 2. Preconditions / Postconditions

### Preconditions
- User has coupon-management access aligned to `CouponService/*` auth: create/update/pause/resume require Owner/Admin/Manager; read/list requires at least Editor
- At least one product exists (coupons apply to products)

### Postconditions
- Created coupons are immediately usable on selected platforms
- Usage events update in real-time via platform webhook
- Coupon creates a `billing_event` of type `discount` in operating ledger

---

## 3. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 🎟️ Mã giảm giá (20)                   [+ Tạo mã mới] [📊 Stats]  │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Summary Bar ─────────────────────────────────────────────────┐   │
│ │ 🟢 8 active · 📝 3 draft · ⏸ 1 paused · ❌ 8 expired       │   │
│ │ Usage (30d): 234 redemptions · Impact: -4.5M VND discount     │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ Filter: [Status ▾] [Type ▾] [Platform ▾] Search: [🔍          ]    │
│                                                                      │
│ ┌─ Coupon Row ──────────────────────────────────────────────────┐   │
│ │ 🎟️ SUMMER20 · Giảm 20% · All products         [🟢 Active]   │   │
│ │ Valid: 1/4 – 30/4/2026 · Max discount: 100,000đ/order         │   │
│ │ Platform: [🎵 TikTok] [🛍 Shopee]                             │   │
│ │ Usage: 45/100 (45%) [████████░░ ]                              │   │
│ │ Revenue impact: +8.2M VND (revenue from orders using this)     │   │
│ │ Discount given: -2.3M VND                                      │   │
│ │ [✏ Edit] [📋 Copy code] [🔗 Share] [⏸ Pause] [🗑 Delete]    │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Coupon Row ──────────────────────────────────────────────────┐   │
│ │ 🎟️ VIP50 · Giảm 50,000đ · Serum VitC only     [🟢 Active]   │   │
│ │ Valid: Không giới hạn · Per-user: 1 lần                        │   │
│ │ Usage: 12/∞ (unlimited)                                        │   │
│ │ Revenue impact: +1.1M → Discount: -600K                        │   │
│ │ [✏ Edit] [📋 Copy] [🔗 Share] [⏸ Pause]                     │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ Pagination: [← Trước] Page 1/2 [Tiếp →]                           │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
CouponManagerPage
├── AppShell (shared)
├── PageHeader
│   ├── PageTitle ("🎟️ Mã giảm giá" + count)
│   ├── CreateButton ("+ Tạo mã mới", primary CTA)
│   └── StatsButton ("📊 Stats")
├── SummaryBar
│   ├── StatusCounts (active, draft, paused, expired)
│   ├── TotalRedemptions (30d)
│   └── TotalDiscountImpact (30d, formatted VND)
├── FilterBar
│   ├── StatusFilter (Active, Draft, Paused, Expired, All)
│   ├── TypeFilter (Percentage, Fixed, Free Ship, Bundle, BOGO)
│   ├── PlatformFilter
│   └── SearchInput (search by code or name)
├── CouponList
│   └── CouponRow[]
│       ├── CouponCode (monospace, bold)
│       ├── DiscountLabel ("Giảm 20%" or "Giảm 50K" or "Free ship")
│       ├── ProductScope ("All products" or specific product names)
│       ├── StatusBadge
│       ├── ValidityDates ("1/4 – 30/4" or "Không giới hạn")
│       ├── MaxDiscountCap (if applicable)
│       ├── PlatformChips[]
│       ├── UsageBar
│       │   ├── UsedCount
│       │   ├── LimitCount (or "∞")
│       │   └── ProgressBar (color: green < 70%, yellow 70-90%, red > 90%)
│       ├── ImpactMetrics
│       │   ├── RevenueGenerated (orders using this coupon)
│       │   └── DiscountGiven (total discount amount)
│       └── ActionBar
│           ├── EditButton
│           ├── CopyCodeButton
│           ├── ShareButton (link/QR)
│           ├── PauseResumeButton
│           └── DeleteButton
├── Pagination
└── CreateEditModal
    ├── CodeSection
    │   ├── AutoGenerate toggle
    │   └── CustomCodeInput (if not auto)
    ├── DiscountTypeSelector
    │   ├── PercentageOption + ValueInput
    │   ├── FixedAmountOption + ValueInput
    │   ├── FreeShippingOption
    │   ├── BundleOption (buy_qty + discount)
    │   └── BOGOOption (buy_qty + get_qty)
    ├── MaxDiscountInput (for percentage — cap per order)
    ├── MinOrderAmountInput (minimum order to qualify)
    ├── ProductScopeSelector
    │   ├── AllProducts
    │   ├── CategoriesSelector
    │   └── SpecificProductsPicker
    ├── PlatformSelector (multi-checkbox)
    ├── ValidityPicker (start + end date, or "Unlimited")
    ├── UsageLimitInput (total uses, or "Unlimited")
    ├── PerUserLimitInput (default: 1)
    ├── CampaignLinker (optional — attach to campaign)
    └── CreateButton
```

---

## 5. Displayed Data

| Field | Source | Format |
|---|---|---|
| Code | `coupons.code` | Uppercase monospace "SUMMER20" |
| Type | `CouponService/List` projection derived from `coupons.coupon_type` + `discount_value` | "Giảm 20%" / "Giảm 50K" / "Free ship" |
| Status | `coupons.lifecycle_state` | Badge |
| Validity | `coupons.valid_from` + `valid_until` | Date range or "Không giới hạn" |
| Max discount | Coupon validation/display projection (for percentage coupons) | VND "100,000đ" |
| Platforms | Channel-distribution projection returned by `CouponService/List` | Platform chips |
| Usage | `coupons.current_uses` / `coupons.max_uses` (or `remaining_uses`) | "45/100" + progress bar |
| Revenue impact | Orders using coupon → sum revenue | VND format |
| Discount given | Coupon redemption / order-discount projection from analytics service | VND format |
| Products | Offer / campaign linkage projection derived from `related_offer_ids` / `related_campaign_ids` | "All" or product names |

---

## 6. User Actions

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Create coupon | "+ Tạo mã mới" → modal | `CouponService/Create` | New coupon in list, toast "Đã tạo mã {code}" | `offer:manage` |
| 2 | Edit coupon | "✏ Edit" → modal (pre-filled) | `CouponService/Update` | Coupon updated, toast | `offer:manage` |
| 3 | Copy code | "📋 Copy" | — (clipboard) | Toast "Đã sao chép mã SUMMER20" | Any |
| 4 | Share | "🔗 Share" | — | Popup: copy link + generate QR + share to social | `offer:read` |
| 5 | Pause | "⏸ Pause" → confirm | `CouponService/Pause` | "Mã sẽ không thể sử dụng khi bị tạm dừng." → paused | `offer:manage` |
| 6 | Resume | "▶ Resume" | `CouponService/Resume` | Coupon reactivated | `offer:manage` |
| 7 | Delete | "🗑 Delete" → confirm | `CouponService/Delete` | Confirmation (S007) → removed | `offer:manage` |
| 8 | View stats | "📊 Stats" | — | → Analytics view for coupons | `report:read` |

---

## 7. Validation Rules (Create/Edit)

| Field | Rule | Error |
|---|---|---|
| Code | Required, 3-20 chars, uppercase alphanumeric + hyphens | "Mã chỉ chứa chữ in hoa, số và dấu gạch ngang" |
| Code | Unique in workspace | "Mã này đã tồn tại" |
| Discount value | Required, > 0 | "Giá trị giảm phải lớn hơn 0" |
| Percentage | ≤ 100 | "Phần trăm không thể vượt quá 100%" |
| Max discount (for %) | Optional, if set must be > 0 | "Giới hạn giảm phải lớn hơn 0" |
| Min order | Optional, if set must be > 0 | "Đơn tối thiểu phải lớn hơn 0" |
| Start date | If set, today or future | "Ngày bắt đầu phải từ hôm nay" |
| End date | If set, after start date | "Ngày kết thúc phải sau ngày bắt đầu" |
| Usage limit | Optional, if set must be ≥ 1 | "Giới hạn sử dụng phải ≥ 1" |
| Per-user limit | Default 1, must be ≥ 1 | "Giới hạn mỗi người phải ≥ 1" |
| At least 1 platform | Required | "Chọn ít nhất 1 nền tảng" |

---

## 8. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial fetch | Coupon row skeletons |
| LOADED | Data received | Coupon list with usage bars |
| EMPTY | No coupons | "Chưa có mã giảm giá nào. Tạo mã đầu tiên để tăng doanh số. [+ Tạo mã giảm giá]" |
| ERROR | API failed | Error banner |
| USAGE_WARNING | Coupon at > 90% usage | Yellow highlight on usage bar |
| EXPIRED_NOTICE | Coupon expired with unused quota | "Mã đã hết hạn. Còn {remaining} lượt chưa dùng. [📋 Tạo mã mới tương tự]" |

---

## 9. Permissions

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer |
|---|---|---|---|---|---|---|
| View coupons | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| View revenue impact | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Create coupon | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Edit coupon | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Pause/resume | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Delete coupon | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Copy/share code | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |

---

## 10. Discount Types Reference

| Type | Create UI | Display | Example | Limit Config |
|---|---|---|---|---|
| Percentage | Slider/input (1-100%) + max cap | "Giảm 20% (max 100K)" | 20% off, cap at 100K | Max discount amount |
| Fixed amount | Input (VND) | "Giảm 50,000đ" | 50K off order total | Min order amount |
| Free shipping | Toggle | "Miễn phí vận chuyển" | No shipping fee | Min order amount |
| Bundle | Buy qty + discount % | "Mua 2 giảm 10%" | Buy 2+, get 10% off | Product scope |
| BOGO | Buy qty + get qty | "Mua 2 tặng 1" | Buy 2 get 1 free | Product scope |

---

## 11. Edge Cases

| Edge Case | Handling |
|---|---|
| Code already exists on platform | Pre-check: "Mã SUMMER20 đã tồn tại trên TikTok Shop. Chọn mã khác." |
| Usage limit reached | Auto-pause, badge: "Hết lượt sử dụng" |
| Coupon used with 0 revenue (return) | Track as "refunded usage" — don't count toward valid redemptions |
| Platform API doesn't support coupon type | Grey out unsupported platforms with tooltip |
| Coupon stacking | System prevents stacking: max 1 coupon per order (configurable) |

---
## 12. SvelteKit Implementation Notes

### Route & Server Load
- **Route**: `src/routes/(app)/coupons/+page.svelte`
- **Server load**: `+page.server.ts` → fetch coupons + summary stats
- **SSR**: Server renders first page of coupon rows for fast LCP
- **Real-time**: SSE on `/events/coupons` for usage updates (webhook-driven)

### Data Fetching Strategy
```
+page.server.ts:
  Promise.all([
    couponService.list({ status, type, platform, page, limit: 20 }),
    couponService.getSummary(period: '30d')
  ])

Client-side:
  onSearch(query) → couponService.list({ query, ...filters })
  onPause(id) → couponService.pause(id)
  onDelete(id) → couponService.delete(id)
```

### Code Uniqueness
- Code uniqueness checked workspace-wide via `couponService.checkCode(code)`
- Platform-level uniqueness checked via `connectorService.checkCouponCode(platform, code)`
- Auto-generation uses: `[PREFIX][RANDOM_6_CHAR]` pattern (e.g., `SALE-A3B7K2`)

### Usage Tracking
- Platform/redemption events: `coupon.used` → increment `coupons.current_uses` and refresh coupon analytics projection
- Revenue impact: `orders WHERE coupon_id = X` → sum revenue
- Discount impact: order-discount / redemption projection → sum discount amount

---
## 13. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `coupons.list.viewed` | Page load | `total_count`, `active_count`, `total_redemptions` |
| `coupons.created` | New coupon created | `code`, `type`, `discount_value`, `platforms` |
| `coupons.edited` | Coupon updated | `coupon_id`, `fields_changed` |
| `coupons.paused` | Coupon paused | `coupon_id`, `usage_at_pause` |
| `coupons.deleted` | Coupon deleted | `coupon_id`, `total_usage` |
| `coupons.code_copied` | Code copied | `coupon_id`, `code` |
| `coupons.shared` | Share action | `coupon_id`, `share_method` ('link'/'qr'/'social') |
| `coupons.stats_viewed` | Stats page opened | — |

---
## 14. Performance Requirements

| Metric | Target |
|---|---|
| LCP | < 1.5s (first coupon row) |
| TTI | < 2.0s |
| Summary bar render | < 200ms |
| Search response | < 300ms |
| Create modal open | < 200ms |
| Usage bar animation | 60fps |

---
## 15. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến — hiển thị dữ liệu cached" + stale coupons visible | Auto-retry when online |
| API error (5xx) | Server failure | Error banner: "Không tải được mã giảm giá. [Thử lại]" | Retry button |
| Code already exists | Duplicate code on create | Inline error: "Mã {code} đã tồn tại. [Tạo mã ngẫu nhiên]" | Auto-generate or change code |
| Platform code conflict | Code exists on platform | Inline error: "Mã đã tồn tại trên {platform}. Chọn mã khác." | Change code |
| Pause failed | Platform API error | Toast: "Không tạm dừng được trên {platform}. [Thử lại]" | Retry |
| Delete with active usage | Coupon currently in use | Warning: "Mã đang được sử dụng. Xóa sẽ vô hiệu hóa ngay lập tức. [Tiếp tục]" | Confirm or cancel |
| Stacking conflict | Multi-coupon attempted | Auto-prevent: "Chỉ được dùng 1 mã/đơn hàng" (system default) | — |

---
## 16. Accessibility

| Element | Requirement |
|---|---|
| Coupon rows | `role="article"`, `aria-label="Mã {code}, giảm {value}, trạng thái {status}"` |
| Usage progress bar | `role="progressbar"`, `aria-valuenow={used}`, `aria-valuemax={limit}` |
| Code text | `aria-label="Mã giảm giá: {code}"`, monospace for visual clarity |
| Copy button | `aria-label="Sao chép mã {code}"` |
| Status badges | Color + icon + text label (never color-only) |
| Create modal | Focus trap, `aria-modal="true"`, `aria-labelledby="modal-title"` |

---
## 17. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | App Shell + summary bar shimmer + row skeletons |
| Summary stats | 200-300ms | Counters animate in |
| Coupon rows | 300-500ms | Rows populate with stagger animation |
| Usage bars | 400-600ms | Progress bars animate from 0% to actual value |
| Search results | < 300ms | Rows crossfade to filtered results |

---
## 18. Localization Notes

- Primary language: Vietnamese
- Currency: VND (no decimals, dot separator: "100.000đ")
- Compact format in summary: "4.5M VND"
- Discount formats: "Giảm 20%", "Giảm 50.000đ", "Miễn phí vận chuyển"
- Usage: "45/100 (45%)" or "12/∞ (unlimited)"
- Validity: "1/4 – 30/4/2026" or "Không giới hạn"
- Code format: Uppercase, monospace: "SUMMER20"
- Status: "Bản nháp", "Đang hoạt động", "Tạm dừng", "Hết hạn", "Thu hồi"
- Revenue impact: "+8.2M VND" (positive), "-2.3M VND" (discount given)

---
## 19. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-coupon-active` | Active status badge (🟢 green) |
| `--color-coupon-draft` | Draft status badge (📝 blue) |
| `--color-coupon-paused` | Paused status badge (⏸ gray) |
| `--color-coupon-expired` | Expired status badge (❌ red) |
| `--color-usage-safe` | Usage < 70% (green progress) |
| `--color-usage-warning` | Usage 70-90% (yellow progress) |
| `--color-usage-full` | Usage > 90% (red progress) |
| `--color-revenue-positive` | Revenue generated (green) |
| `--color-discount-negative` | Discount given (red) |
| `--color-accent` | Primary CTAs |
| `--color-surface-elevated` | Coupon rows |
| `--font-mono` | Coupon code display |

---
## 20. Related Screens

| Screen | Relationship |
|---|---|
| [W066] Offer List | Offers can include coupons |
| [W064] Campaign List | Campaigns link to coupons |
| [W060] Product List | Product scope selection |
| [W081] Profit Dashboard | Discount impact on margin |
| [M033] Mobile Coupons | Mobile equivalent |
| [S007] Confirmations | Delete confirmation dialog |

---
## 21. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A standardization**: Fixed section numbering (1-21 sequential). Removed duplicate §5 and generic boilerplate. Added SvelteKit Implementation Notes (code uniqueness, usage tracking), 8 Analytics Events, Performance Requirements, screen-specific Error Handling (7 scenarios with platform conflicts and stacking), Accessibility with progress bar ARIA, Loading Behavior (5 stages), Localization with coupon-specific discount formats, Design Tokens with usage-threshold and revenue/discount colors. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
