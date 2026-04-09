# Screen: Web — Offer Detail / Create

> **Screen ID**: W067
> **Module**: M14 — Monetization & Offers
> **Route**: `/offers/[id]` (edit) or `/offers/new` (create)
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 06 §7 (Commerce), Product Freeze §22, A1 Schema (offers, coupons, products, campaigns), B5 RBAC §2.7

---

## 1. Purpose & Context

The Offer Detail screen is the primary form for creating and editing promotional offers. It supports 4 offer types (percentage, fixed amount, bundle, free gift), product association, time/quantity constraints, and multi-channel distribution (coupon codes, affiliate links, campaigns). This is a revenue-critical form — every SKU promotion flows through this screen.

### User Goals
- Create time-limited promotional offers with clear discount mechanics
- Associate offers with specific products or product categories
- Generate and distribute coupon codes across channels
- Track offer performance (usage count, revenue impact)
- Link offers to campaigns for attribution tracking

### Business Goals
- Enable monetization through structured promotions (not ad-hoc price changes)
- Connect offers to the Proof Graph via revenue attribution
- Support multi-platform distribution (TikTok Shop coupons, Shopee vouchers, direct links)
- Maintain offer audit trail for financial reconciliation (M19)

### When This Screen Is Used
- Creating: Seller launches a new promotion for upcoming sale event
- Editing: Adjusting limits or extending time on active offer
- Reviewing: Checking usage stats on running offer before deciding to extend
- Duplicating: Cloning a successful past offer for a new campaign

### Entry Points
- Offer List (W066): Click "+" or click existing offer row
- Campaign Detail (W065): "Tạo offer cho campaign" link
- Product Detail (W061): "Tạo offer" action on product
- AI Copilot: "Tạo offer giảm 20% cho Serum VitC trong 5 ngày"
- Sidebar: Monetization → Offers → "+ Tạo offer"

### Exit Points
- Save/Activate → redirect to Offer List (W066) with success toast
- Cancel → back to Offer List
- Click product in selector → Product Detail (W061) in new tab
- Click campaign → Campaign Detail (W065)
- "Xem coupon" → Coupon Manager (W068) filtered by this offer

---

## 2. Preconditions / Postconditions

### Preconditions
- User authenticated with valid workspace session
- User has `offer:manage` permission (Owner, Admin, Manager, Editor)
- At least 1 product exists in workspace (for product association)
- For edit mode: offer `offer_id` exists and belongs to current workspace

### Postconditions
- Offer record created/updated in `offers` table
- Associated product linkage updated via `offers.product_id` / `product_less_declaration`
- If coupon enabled: `coupons` record created with generated/custom code
- If campaign linked: `offers.campaign_ids` updated
- Audit event logged: `offer.created` / `offer.updated` / `offer.activated`
- Analytics event dispatched for tracking

---

## 3. Screen Layout

### Responsive Behavior
| Breakpoint | Layout |
|---|---|
| Desktop (≥1280px) | App Shell (sidebar 240px) + single-column form (max-width 720px, centered) |
| Tablet (768-1279px) | App Shell (collapsed sidebar 64px) + full-width form |
| Mobile (≤767px) | Redirect to mobile offer creation (simplified) or web responsive |

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Offers   Tạo Offer mới                            [Lịch sử ▾]    │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ § Thông tin cơ bản ─────────────────────────────────────────────┐│
│ │ Tên offer *                                                       ││
│ │ [Giảm 20% Serum Vitamin C                                     ]  ││
│ │                                                                    ││
│ │ Loại giảm giá *                                                   ││
│ │ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌──────────────┐ ││
│ │ │ ● Phần trăm │ │ ○ Giảm tiền │ │ ○ Bundle    │ │ ○ Quà tặng  │ ││
│ │ └─────────────┘ └─────────────┘ └─────────────┘ └──────────────┘ ││
│ │                                                                    ││
│ │ Giá trị giảm *           Giảm tối đa (cho %)                      ││
│ │ [20         ] %          [100,000     ] VND                        ││
│ │                                                                    ││
│ │ Áp dụng cho *                                                      ││
│ │ ○ Tất cả sản phẩm  ● Sản phẩm cụ thể  ○ Danh mục                ││
│ │ ┌──────────────────────────────────────────────────────────────┐   ││
│ │ │ 🔍 Tìm sản phẩm...                                          │   ││
│ │ │ ☑ Serum Vitamin C · 250,000đ · Stock: 45                   │   ││
│ │ │ ☑ Toner AHA/BHA · 180,000đ · Stock: 120                    │   ││
│ │ │ ☐ Sunscreen SPF50 · 320,000đ · Stock: 78                   │   ││
│ │ └──────────────────────────────────────────────────────────────┘   ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ┌─ § Thời gian & Giới hạn ────────────────────────────────────────┐│
│ │ Thời gian *                                                        ││
│ │ Bắt đầu: [📅 25/03/2026 09:00]   Kết thúc: [📅 30/03/2026 23:59]││
│ │                                                                    ││
│ │ Giới hạn sử dụng                                                  ││
│ │ ☑ Tổng lượt: [100    ] lượt                                       ││
│ │ ☑ Mỗi khách: [1      ] lượt/khách                                ││
│ │                                                                    ││
│ │ Đơn tối thiểu                                                     ││
│ │ [200,000   ] VND                                                   ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ┌─ § Kênh phân phối ──────────────────────────────────────────────┐│
│ │ ☑ Mã giảm giá (coupon)                                           ││
│ │   ○ Tự động tạo   ● Tự nhập: [GIAM20                         ]  ││
│ │   Preview: creativanta.link/c/GIAM20                              ││
│ │                                                                    ││
│ │ ☑ Affiliate link                                                   ││
│ │   Link: creativanta.link/a/offer_xxx (auto, read-only)            ││
│ │                                                                    ││
│ │ ☐ Gắn với campaign                                                ││
│ │   [Chọn campaign ▾]                                               ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ┌─ § Xem trước (conditional — edit mode only) ────────────────────┐│
│ │ ┌─ Performance (live if active) ──────────────────────────┐      ││
│ │ │ Used: 45/100 · Revenue: +5.4M VND · Avg discount: 48K │      ││
│ │ │ Conv rate: 12.3% · Remaining: 55 · Expires in 3d       │      ││
│ │ └─────────────────────────────────────────────────────────┘      ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ┌─ Footer Actions ────────────────────────────────────────────────┐│
│ │ [🗑 Xóa]          [Hủy]         [Lưu draft] [🚀 Kích hoạt]     ││
│ │                                                   ↑ Primary CTA  ││
│ └──────────────────────────────────────────────────────────────────┘│
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
OfferDetailPage
├── AppShell (shared)
├── PageHeader
│   ├── BackLink ("← Offers" → /offers)
│   ├── PageTitle ("Tạo Offer mới" or "{offer.title}")
│   ├── StatusBadge (draft/active/paused/expired — edit only)
│   └── HistoryDropdown (revision history — edit only)
├── FormContainer (max-width: 720px, centered)
│   ├── BasicInfoSection
│   │   ├── OfferNameInput (text, required)
│   │   ├── OfferTypeSelector (radio group: percentage/fixed/bundle/gift)
│   │   ├── DiscountValueInput (number, conditional format per type)
│   │   │   ├── PercentageInput (suffix: "%") — when type=percentage
│   │   │   ├── FixedAmountInput (suffix: "VND") — when type=fixed
│   │   │   ├── BundleBuyGetInputs ("Mua [N] tặng [M]") — when type=bundle
│   │   │   └── GiftProductSelector — when type=gift
│   │   ├── MaxDiscountInput (VND, optional — percentage type only)
│   │   ├── ProductScopeSelector (radio: all/specific/category)
│   │   └── ProductMultiSelect (searchable, checkbox list with stock/price)
│   │       ├── SearchInput ("🔍 Tìm sản phẩm...")
│   │       ├── ProductCheckboxRow[]
│   │       │   ├── Checkbox
│   │       │   ├── ProductName
│   │       │   ├── ProductPrice (VND)
│   │       │   └── StockBadge
│   │       └── SelectedCount ("Đã chọn: 2 sản phẩm")
│   ├── TimeLimitSection
│   │   ├── DateTimeRangePicker
│   │   │   ├── StartDateTimePicker (date + time)
│   │   │   └── EndDateTimePicker (date + time)
│   │   ├── UsageLimitGroup
│   │   │   ├── TotalUsageToggle + Input
│   │   │   └── PerCustomerToggle + Input
│   │   └── MinOrderAmountInput (VND)
│   ├── DistributionSection
│   │   ├── CouponToggle + CouponConfig
│   │   │   ├── AutoGenerateRadio
│   │   │   ├── CustomCodeRadio + CustomCodeInput
│   │   │   └── CouponPreviewLink (read-only URL)
│   │   ├── AffiliateLinkToggle + LinkDisplay (read-only)
│   │   └── CampaignToggle + CampaignSelector (dropdown)
│   └── PerformancePreview (edit mode + active/paused status only)
│       ├── UsageProgress (used/total bar)
│       ├── RevenueImpact (VND)
│       ├── AvgDiscount (VND)
│       ├── ConversionRate (%)
│       ├── RemainingCount
│       └── ExpiryCountdown
├── FooterActions (sticky on scroll)
│   ├── DeleteButton ("🗑 Xóa" — edit mode, destructive)
│   ├── CancelButton ("Hủy" → navigate back)
│   ├── SaveDraftButton ("Lưu draft" — secondary)
│   └── ActivateButton ("🚀 Kích hoạt" — primary CTA)
└── UnsavedChangesGuard (prompt on navigate away if dirty form)
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Offer data (edit) | `offers` table by ID | `OfferService/Get(offer_id)` | Form pre-fill | No cache (always fresh) |
| Product list | `products` table | `ProductService/List(workspace_id, status=active)` | Name + price + stock | 5m TTL |
| Campaign list | `campaigns` table | `CampaignService/List(workspace_id, status=active)` | Dropdown options | 5m TTL |
| Coupon code check | `coupons.code` uniqueness | `CouponService/CheckAvailability(code)` | ✅ Available / ❌ Taken | No cache |
| Performance stats | Offer performance projection from `OfferService/GetPerformance(offer_id)` | `OfferService/GetPerformance(offer_id)` | Used/total, revenue VND | 2m TTL |
| Offer name | `offers.title` | — | Text as-is | — |
| Discount value | `offers.pricing_value` / `offers.pricing_logic` | — | `Intl.NumberFormat('vi-VN')` + suffix (% or VND) | — |
| Start/End dates | `offers.starts_at`, `offers.ends_at` | — | `dd/MM/yyyy HH:mm` | — |
| Product prices | `products.price` | — | VND with dot separator | — |
| Revenue impact | ClickHouse aggregation | `OfferService/GetPerformance` | Compact VND ("5.4M VND") | 2m |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | Save as draft | Click "Lưu draft" | `OfferService/Create(data, lifecycle_state='draft')` or `OfferService/Update(id, data)` | `offers.lifecycle_state = 'draft'` | Toast "✅ Đã lưu draft" → redirect to `/offers` | `offer:manage` |
| 2 | Activate offer | Click "🚀 Kích hoạt" | `OfferService/Activate(id)` or `OfferService/Create(data, lifecycle_state='active')` | `offers.lifecycle_state = 'active'` | Confirmation modal → Toast "🚀 Offer đang hoạt động" → redirect | `offer:manage` |
| 3 | Update active offer | Click "Lưu" (edit mode, active) | `OfferService/Update(id, data)` | Row updated | Toast "✅ Đã cập nhật" | `offer:manage` |
| 4 | Pause offer | Click "⏸ Tạm dừng" (active only) | `OfferService/Pause(id)` | `offers.lifecycle_state = 'paused'` | Status badge → paused | `offer:manage` |
| 5 | Resume offer | Click "▶ Tiếp tục" (paused only) | `OfferService/Resume(id)` | `offers.lifecycle_state = 'active'` | Status badge → active | `offer:manage` |
| 6 | Delete offer | Click "🗑 Xóa" → confirm | `OfferService/Delete(id)` | Soft delete: `offers.deleted_at = now` | Confirmation modal → Toast "Đã xóa offer" → redirect | `offer:manage` |
| 7 | Search products | Type in product search | `ProductService/Search(query, workspace_id)` | — | Filtered product list | `product:read` |
| 8 | Toggle product | Check/uncheck product row | Client-side form state | — | Selected count updates | `offer:manage` |
| 9 | Check coupon code | Blur on custom code input | `CouponService/CheckAvailability(code)` | — | ✅ or ❌ inline validation | `offer:manage` |
| 10 | Generate coupon code | Click "Tự động tạo" | Client-side: `generateCouponCode()` | — | Random 8-char code fills input | `offer:manage` |
| 11 | Duplicate offer | "⋮" → "Nhân bản" (edit mode) | `OfferService/Get(id)` → prefill form | — | New form with data copied (name + " (copy)") | `offer:manage` |
| 12 | View performance | Section auto-loads (edit mode) | `OfferService/GetPerformance(id)` | — | Stats cards update | `offer:read` |
| 13 | Cancel | Click "Hủy" | — | — | Navigate back to `/offers` | Any |

---

## 7. Validation Rules

### Offer Form Fields
| Field | Rule | Error Message (Vietnamese) |
|---|---|---|
| `title` | Required, 3-100 chars | "Tên offer phải từ 3 đến 100 ký tự" |
| `discount_type` | Required, one of: percentage/fixed/bundle/gift | "Chọn loại giảm giá" |
| `discount_value` (percentage) | Required, 1-99 | "Phần trăm giảm phải từ 1% đến 99%" |
| `discount_value` (fixed) | Required, ≥1,000 VND, ≤ product price | "Số tiền giảm phải ≥ 1,000đ và không vượt giá sản phẩm" |
| `discount_value` (bundle buy) | Required, ≥1 | "Số lượng mua phải ≥ 1" |
| `discount_value` (bundle get) | Required, ≥1 | "Số lượng tặng phải ≥ 1" |
| `max_discount` | Optional, if set: ≥10,000 VND | "Giảm tối đa phải ≥ 10,000đ" |
| `products` | Required if scope=specific, ≥1 selected | "Chọn ít nhất 1 sản phẩm" |
| `starts_at` | Required, ≥ now (create) / any (edit) | "Thời gian bắt đầu phải trong tương lai" |
| `ends_at` | Required, > starts_at | "Thời gian kết thúc phải sau thời gian bắt đầu" |
| `total_usage_limit` | Optional, if set: ≥1 | "Giới hạn tổng lượt phải ≥ 1" |
| `per_customer_limit` | Optional, if set: ≥1, ≤ total_usage_limit | "Giới hạn/khách phải ≥ 1 và ≤ tổng giới hạn" |
| `min_order_amount` | Optional, if set: ≥0 | "Đơn tối thiểu phải ≥ 0đ" |
| `coupon_code` (custom) | 4-20 chars, alphanumeric + hyphen, unique | "Mã coupon 4-20 ký tự, chỉ chữ/số/gạch. Mã này đã tồn tại." |

### Activation Guard (before status → active)
| Check | Error |
|---|---|
| All required fields valid | "Vui lòng điền đầy đủ thông tin bắt buộc trước khi kích hoạt" |
| At least 1 product selected (if scope=specific) | "Chọn ít nhất 1 sản phẩm để kích hoạt offer" |
| End date in future | "Không thể kích hoạt offer đã hết hạn" |
| No active offer with same coupon code | "Mã coupon đang được sử dụng bởi offer khác" |

---

## 8. States

| State | Condition | Visual | User Action |
|---|---|---|---|
| LOADING | Fetching offer data (edit mode) | Form skeleton (3 sections shimmer) | Wait |
| CREATE_EMPTY | New offer form, no data | Clean form with default values, all fields empty | Fill form |
| CREATE_DIRTY | User has entered data | Form with data, "Lưu draft" enabled | Continue editing or save |
| EDIT_DRAFT | Existing offer, status=draft | Form pre-filled, StatusBadge = "📝 Draft" | Edit & activate |
| EDIT_ACTIVE | Existing offer, status=active | Form pre-filled, StatusBadge = "🟢 Active", Performance section visible | Edit (limited) or pause |
| EDIT_PAUSED | Existing offer, status=paused | Form pre-filled, StatusBadge = "⏸ Paused" | Edit or resume |
| EDIT_EXPIRED | Existing offer, ends_at < now | Form pre-filled (read-only), StatusBadge = "⏹ Expired", "Nhân bản" CTA | Duplicate or delete |
| EDIT_EXHAUSTED | Usage limit reached | Form pre-filled, StatusBadge = "🔴 Hết lượt", auto-paused | Increase limit or duplicate |
| SAVING | Form submission in progress | Primary CTA shows spinner, form disabled | Wait |
| SAVE_SUCCESS | Save/activate completed | Toast notification, redirect | — |
| SAVE_ERROR | Save failed | Inline error message, form re-enabled | Fix and retry |
| VALIDATION_ERROR | Form has validation errors | Red borders on invalid fields, error messages shown | Fix errors |
| CONFIRM_DELETE | Delete button clicked | Confirmation modal: "Xóa offer? Hành động này không thể hoàn tác." | Confirm or cancel |
| CONFIRM_ACTIVATE | Activate button clicked | Confirmation modal: "Kích hoạt offer? Offer sẽ có hiệu lực ngay." | Confirm or cancel |
| UNSAVED_CHANGES | Navigate away with dirty form | Browser confirm dialog: "Bạn có thay đổi chưa lưu. Rời đi?" | Save, discard, or stay |
| ERROR | API failed to load | "Không tải được offer. [Thử lại]" with retry button | Retry |
| NOT_FOUND | Offer ID doesn't exist | "Offer không tồn tại hoặc đã bị xóa" → redirect after 3s | Navigate to offer list |

### Edit-mode Field Restrictions (Active Offer)
| Field | Editable when Active? | Reason |
|---|---|---|
| name | ✅ Yes | Display-only change |
| discount_type | ❌ No | Would invalidate existing orders |
| discount_value | ⚠️ Limited (can decrease, not increase) | Prevent post-purchase confusion |
| products | ✅ Yes (can add, not remove active) | Can expand scope but not break existing |
| ends_at | ✅ Yes (can extend only) | Cannot shorten active offer |
| usage_limit | ✅ Yes (can increase only) | Cannot reduce active limit |
| coupon_code | ❌ No | Already distributed |

---

## 9. Permission Matrix

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View offer detail | ✅ | ✅ | ✅ | ✅ | ✅ (read) | ✅ (read) | ❌ |
| Create offer | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Edit offer | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Activate offer | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Pause/resume offer | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Delete offer | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| View performance stats | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |

### Visibility Rules
- **Contributor/Viewer**: Form is read-only. Action buttons hidden except "Hủy".
- **Editor**: Can create and edit but "Kích hoạt" and "Xóa" buttons hidden — must request Manager approval.
- **External**: Redirect to permission denied page.

---

## 10. Navigation Map

```
Offer Detail (/offers/[id] or /offers/new)
├── ← /offers                          (Back button, Cancel, after Save)
├── → /offers                          (After successful save/activate/delete)
├── → /products/[id]                   (Click product in selector → new tab)
├── → /campaigns/[id]                  (Click linked campaign)
├── → /coupons?offer_id=[id]           (Click "Xem coupon" link)
├── → /affiliates?offer_id=[id]        (Click affiliate link stats)
├── → /analytics/offer/[id]            (Performance "Xem chi tiết →")
└── ← /campaigns/[id]                  (If opened from campaign context)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity during save | Banner: "📡 Không có kết nối mạng. Thay đổi sẽ được lưu khi có mạng." + disable save | Auto-retry on reconnect |
| API error (save) | Server 5xx on `OfferService/Create` or `Update` | Toast: "❌ Không lưu được offer. Vui lòng thử lại." + form stays enabled | Retry save |
| API error (load) | Server 5xx on `OfferService/Get` | Full-page error: "Không tải được offer. [Thử lại]" | Retry button |
| Offer not found | 404 on `OfferService/Get(id)` | Message: "Offer không tồn tại hoặc đã bị xóa." → auto-redirect to `/offers` after 3s | Navigate to list |
| Permission denied | 403 on any write action | Toast: "Bạn không có quyền thực hiện hành động này." | Contact workspace admin |
| Coupon conflict | Coupon code already exists | Inline error under code input: "❌ Mã coupon đã tồn tại. Chọn mã khác." | Change code |
| Concurrent edit | Stale version on save (409) | Modal: "Offer đã được chỉnh sửa bởi người khác. [Tải lại] hoặc [Lưu đè]" | Reload or force save |
| Product out of stock | Selected product stock = 0 | Warning badge on product row: "⚠️ Hết hàng" (allow save but warn) | Remove product or restock |
| Rate limited | 429 response | Toast: "Quá nhiều yêu cầu. Thử lại sau 30 giây." | Auto-retry after backoff |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Form sections | `<fieldset>` with `<legend>` for each section ("Thông tin cơ bản", "Thời gian & Giới hạn", etc.) |
| Required fields | `aria-required="true"` + visual asterisk (*) |
| Validation errors | `aria-invalid="true"` + `aria-describedby` linking to error message `<span>` |
| Offer type radio | `role="radiogroup"` with `aria-label="Loại giảm giá"` |
| Product checkboxes | `role="listbox"` with `aria-multiselectable="true"`, each item `role="option"` |
| Date pickers | `aria-label="Ngày bắt đầu"` / `"Ngày kết thúc"` |
| Status badge | `aria-label="Trạng thái: Đang hoạt động"` (screen reader friendly) |
| Action buttons | `aria-label` includes action + consequence (e.g., "Kích hoạt offer — offer sẽ có hiệu lực ngay") |
| Focus management | After save error → focus on first error field. After modal close → focus on trigger button. |
| Keyboard navigation | Tab order: Name → Type → Value → Products → Dates → Limits → Distribution → Actions |
| Color contrast | All text meets WCAG 2.1 AA (4.5:1). Error red on white ≥ 4.5:1. |
| Reduced motion | `prefers-reduced-motion: reduce` → disable counter animations in performance preview |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render (create) | 0ms | App Shell renders. Empty form visible immediately (no skeleton needed). |
| Initial render (edit) | 0ms | App Shell renders. Form shows skeleton (3 field groups shimmer). |
| Offer data fetch | 200-500ms | Skeleton → form fields populate with animation (fade-in). |
| Product list fetch | 100-300ms | Product selector shows "Đang tải sản phẩm..." → list appears. |
| Campaign list fetch | 100-300ms | Campaign dropdown shows "Đang tải..." → options appear. |
| Performance stats | 300-800ms | Performance section shows mini skeleton → stats fill in with counter animation. |
| Save action | 500-2000ms | CTA button shows spinner + "Đang lưu..." text. Form fields disabled. |
| Coupon code check | 200-500ms | Inline spinner next to code input → ✅ or ❌ result. |

---

## 14. Performance Requirements

| Metric | Target | Measurement |
|---|---|---|
| LCP | < 1.5s | Form container or first fieldset |
| FID | < 100ms | First interaction with name input |
| CLS | < 0.05 | Fixed-height form sections prevent shift |
| TTI | < 2.0s | All form controls interactive |
| Product search | < 300ms | Debounced 300ms, response < 200ms |
| Save round-trip | < 2.0s | Click → toast confirmation |
| Bundle size | < 30KB page-specific JS | Date picker lazy-loaded |

---

## 15. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| Performance stats | Polling | Every 2 minutes (edit mode, active offers only) |
| Product stock levels | On-demand | Refetch on product search |
| Coupon code availability | On-demand | Check on blur of custom code input |
| Concurrent edit detection | SSE `/events/offers/{id}` | Real-time (show banner if another user editing) |

---

## 16. Localization Notes

- Primary language: Vietnamese (vi-VN)
- Currency display: VND with dot separator ("250.000đ"), no decimals
- Percentage: number + "%" suffix ("20%")
- Date input format: `dd/MM/yyyy HH:mm`
- Date display: `dd/MM/yyyy` (short) or `dd tháng MM, yyyy` (long)
- Numbers: dot for thousands ("1.234")
- Error messages: Vietnamese, friendly tone, actionable
- Placeholders: Vietnamese ("Nhập tên offer...")
- Button labels: Vietnamese verbs ("Lưu", "Kích hoạt", "Xóa", "Hủy")

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `offer.form.viewed` | Page load | `mode` (create/edit), `offer_id` (edit), `offer_status` |
| `offer.form.type_selected` | Select offer type | `discount_type` |
| `offer.form.products_selected` | Product selection changed | `product_count`, `scope` (all/specific/category) |
| `offer.form.coupon_configured` | Coupon section filled | `coupon_type` (auto/custom), `code_length` |
| `offer.draft.saved` | Draft saved | `offer_id`, `discount_type`, `product_count` |
| `offer.activated` | Offer activated | `offer_id`, `discount_type`, `discount_value`, `product_count`, `duration_days` |
| `offer.updated` | Offer updated | `offer_id`, `changed_fields[]` |
| `offer.paused` | Offer paused | `offer_id`, `usage_at_pause`, `reason` |
| `offer.deleted` | Offer deleted | `offer_id`, `status_at_delete`, `usage_count` |
| `offer.duplicated` | Offer duplicated | `source_offer_id`, `new_offer_id` |
| `offer.form.abandoned` | Navigate away without saving | `time_spent_seconds`, `fields_filled_count` |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-surface-primary` | Form section backgrounds |
| `--color-surface-elevated` | Product selector dropdown |
| `--color-accent` | Primary CTA ("🚀 Kích hoạt"), active radio |
| `--color-accent-subtle` | Selected product row background |
| `--color-success` | "✅ Available" coupon check, active status badge |
| `--color-warning` | Low stock badge, "⚠️ Hết hàng" |
| `--color-danger` | "❌ Taken" coupon check, delete button, validation errors |
| `--color-text-primary` | Form labels, values |
| `--color-text-secondary` | Helper text, placeholders |
| `--color-text-disabled` | Disabled field values (read-only on active offer) |
| `--color-border-input` | Form input borders (default) |
| `--color-border-focus` | Input border on focus (accent) |
| `--color-border-error` | Input border on validation error (danger) |
| `--spacing-form-gap` | Vertical gap between form fields (16px) |
| `--spacing-section-gap` | Gap between form sections (32px) |
| `--radius-input` | Input border radius (8px) |
| `--radius-card` | Section card radius (12px) |
| `--font-label` | Form labels (14px, medium, secondary) |
| `--font-input` | Input values (16px, regular) |
| `--font-helper` | Helper text under inputs (12px, secondary) |

---

## 19. Technical Implementation Notes

### SvelteKit Specifics
- **Route**: `src/routes/(app)/offers/[id]/+page.svelte` (handles both `new` and `{uuid}`)
- **Server load**: `+page.server.ts` → if `params.id !== 'new'`, fetch offer data + products + campaigns
- **Form**: Svelte `copilot:use_creative` for progressive enhancement. Client-side validation first, server validation on submit.
- **Product selector**: `Combobox` from shadcn-svelte with `virtualizer` for large product lists (100+)
- **Date picker**: `date-fns` for formatting, `@internationalized/date` for calendar component
- **Coupon code generation**: Client-side `crypto.randomUUID().substring(0, 8).toUpperCase()`
- **Unsaved changes**: `beforeunload` event + SvelteKit `beforeNavigate` hook
- **Optimistic UI**: Save button disabled during submission, re-enabled on error

### Data Fetching Strategy
```
+page.server.ts:
  const isNew = params.id === 'new';
  const [products, campaigns, offer] = await Promise.all([
    productService.list(workspace_id, { status: 'active' }),
    campaignService.list(workspace_id, { status: 'active' }),
    isNew ? null : offerService.get(params.id),
  ]);
  // If editing and offer not found → throw 404
  // Products and campaigns cached 5m via Redis
```

### Form State Management
```
+page.svelte:
  let form = $state(offer ?? defaultOfferForm());
  let isDirty = $derived(/* deep compare form vs original */);
  let validationErrors = $state({});

  function validate(field?: string) {
    // Per-field or full form validation
    // Returns { [field]: errorMessage } map
  }
```

---

## 20. Related Screens & Revision History

### Related Screens
| Screen | Relationship |
|---|---|
| [W066] Offer List | Parent — navigates here on row click or "+" |
| [W061] Product Detail | Linked — product selector opens product in new tab |
| [W065] Campaign Detail | Linked — campaign linking and attribution |
| [W068] Coupon Manager | Child — manages coupon codes generated by this offer |
| [W069] Affiliate Overview | Linked — affiliate links for this offer |
| [W082] Revenue Detail | Linked — revenue attributed to this offer |
| [M029] Mobile Offers | Mobile equivalent (simplified view) |

### Revision History
| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A upgrade**: Full 20-point rewrite. Added: real APIs (OfferService), complete state machine (16 states), full validation (14 fields + activation guard), edit-mode field restrictions, detailed component hierarchy, screen-specific accessibility, performance requirements, 11 analytics events, concurrent edit detection, and comprehensive error handling (9 scenarios). | System |
| 2026-03-28 | 1.0 | Initial specification (Tier C — template-based) | System |
