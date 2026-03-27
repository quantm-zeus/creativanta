# Screen Specs 07 — Commerce (M13-M15)

> **Upstream**: Product Freeze §21-24, A1 Schema (products, offers, campaigns, coupons, affiliate_links, orders, refunds, memberships, store_pages, samples)
> **Screens**: 15 web + 8 mobile screens
> **Screen Numbers**: §55-§69 (per screen_index.md canonical numbering)

---

## 55. Product List

**Route**: `/products`
**Purpose**: All products in workspace — from connected e-commerce platforms + manually created.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 🛍️ Sản phẩm          [+ Tạo mới] [📥 Import] [View: ▦|☰]      │
├──────────────────────────────────────────────────────────────────┤
│ Filter: [Platform ▾] [Status ▾] [Category ▾]  Search: [🔍    ]  │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Product Card (Grid) ──────────────────┐ ┌─ Product Card ───┐│
│ │ [📸 Product Image]                      │ │ [📸 Image]        ││
│ │                                         │ │                   ││
│ │ Serum Vitamin C 30ml                   │ │ Kem chống nắng   ││
│ │ 299,000đ · TikTok Shop                │ │ 199,000đ · Shopee││
│ │ Status: 🟢 Active                      │ │ Status: 🟡 Draft  ││
│ │ SKUs: 3 · Stock: 245                   │ │ SKUs: 1 · Stock: 0││
│ │ Orders (30d): 89 · Rev: 26.6M         │ │ —                  ││
│ │ [→ Detail] [📤 Tạo nội dung]           │ │ [→ Detail]        ││
│ └────────────────────────────────────────┘ └────────────────────┘│
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Create product | "+ Tạo mới" | — | → `/products/new` |
| Import products | "📥 Import" | — | Modal: select platform → sync |
| View detail | Click product | — | → `/products/[id]` |
| Create content | "📤 Tạo nội dung" | — | → `/ideas/new?product_id=[id]` |
| Filter / Search | Filter UI | Meilisearch + API | List updates |
| Delete | ⋮ → "Xóa" → confirm | `ProductService/Delete` | Card removed |

---

## 56. Product Detail

**Route**: `/products/[id]`
**Purpose**: Full product detail — variants, SKUs, inventory, pricing, related content, performance.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Products   Serum Vitamin C 30ml           [🟢 Active] [⋮]    │
├──────────────────────────────────┬───────────────────────────────┤
│ Main (65%)                       │ Side Panel (35%)               │
│                                  │                                │
│ ┌─ Product Images ───────────┐  │ ┌─ Quick Stats ─────────────┐ │
│ │ [Image carousel with zoom] │  │ │ Revenue (30d): 26.6M VND  │ │
│ └────────────────────────────┘  │ │ Orders: 89                 │ │
│                                  │ │ Avg Rating: 4.8⭐          │ │
│ Tabs: [Info] [Variants/SKU] [Inventory] [Content] [Performance]│ │ │ Content: 5 videos          │ │
│                                  │ │ [📊 Full analytics →]      │ │
│ ── Info Tab ──                   │ └─────────────────────────────┘│
│ ┌─ Basic Info ───────────────┐  │                                │
│ │ Name: [Serum Vitamin C    ]│  │ ┌─ Related Offers ──────────┐ │
│ │ Description: [Rich text]   │  │ │ 🏷 Offer: "Giảm 20%"     │ │
│ │ Category: [Skincare ▾]     │  │ │ 🏷 Offer: "Combo 2 giảm" │ │
│ │ Brand: [My Brand ▾]       │  │ │ [+ Tạo offer mới]         │ │
│ │ Platform: TikTok Shop      │  │ └─────────────────────────────┘│
│ │ External ID: product_123   │  │                                │
│ │ Source: 🔗 Synced          │  │ ┌─ Related Content ─────────┐ │
│ │ Last sync: 30m ago         │  │ │ 🎬 "5 tips nấu ăn" (24K) │ │
│ └────────────────────────────┘  │ │ 🎬 "Review serum" (3K)    │ │
│                                  │ │ [+ Tạo nội dung mới]      │ │
│ ── Variants/SKU Tab ──           │ └─────────────────────────────┘│
│ ┌─ Variant Table ────────────┐  │                                │
│ │ Variant   │ SKU │ Price │ Stock│ ┌─ Actions ─────────────────┐ │
│ │ 30ml      │ SKU1│ 299K  │ 245 │ │ [📤 Tạo nội dung]        │ │
│ │ 50ml      │ SKU2│ 449K  │ 123 │ │ [🏷 Tạo offer]           │ │
│ │ Set 2pcs  │ SKU3│ 549K  │ 56  │ │ [🔄 Sync từ platform]    │ │
│ │ [+ Thêm variant]              │ │ [✏️ Edit] [🗑 Xóa]       │ │
│ └────────────────────────────┘  │ └─────────────────────────────┘│
└──────────────────────────────────┴───────────────────────────────┘
```

---

## 57. Offer List

**Route**: `/offers`
**Purpose**: Manage promotional offers — discounts, bundles, flash sales tied to products.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 🏷 Offers                     [+ Tạo offer] [Filter ▾]          │
├──────────────────────────────────────────────────────────────────┤
│ Tabs: [Active (5)] [Scheduled (2)] [Ended (12)] [Draft (3)]    │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Offer Card ────────────────────────────────────────────────┐ │
│ │ 🏷 "Giảm 20% Serum Vitamin C"           [🟢 Active]        │ │
│ │ Type: Percentage · Discount: 20% · Product: Serum VitC     │ │
│ │ Period: 25/3 - 30/3 · Remaining: 3 days                    │ │
│ │ Used: 23/100 · Revenue: 5.2M VND                           │ │
│ │ [📊 Stats] [✏️ Edit] [⏸ Pause] [📤 Tạo nội dung]          │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

---

## 58. Offer Detail/Create

**Route**: `/offers/[id]` or `/offers/new`
**Purpose**: Create or edit a promotional offer with product selection, discount rules, and campaign links.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Offers   Tạo Offer mới                                        │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Basic Info ────────────────────────────────────────────────┐ │
│ │ Tên offer: [Giảm 20% Serum Vitamin C                  ]    │ │
│ │ Loại: ○ Phần trăm giảm  ● Giảm tiền  ○ Bundle  ○ Quà tặng │ │
│ │ Giá trị: [60,000 ▾] VND                                    │ │
│ │ Áp dụng cho: [Serum Vitamin C ▾] (product selector)        │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Thời gian & Giới hạn ─────────────────────────────────────┐ │
│ │ Bắt đầu: [25/03/2026] Kết thúc: [30/03/2026]              │ │
│ │ Giới hạn: [100 ▾] lượt sử dụng                             │ │
│ │ Tối thiểu đơn: [0 ▾] VND                                   │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Kênh phân phối ───────────────────────────────────────────┐ │
│ │ ☑ Coupon code: [AUTO_GENERATE ▾] or [custom: GIAM20     ] │ │
│ │ ☑ Affiliate link: [Auto-generate for offer]                │ │
│ │ ☑ Campaign liên kết: [Chọn campaign ▾]                     │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ [Hủy]                                [Lưu draft] [🚀 Kích hoạt] │
└──────────────────────────────────────────────────────────────────┘
```

---

## 59. Campaign Manager

**Route**: `/campaigns`
**Purpose**: Marketing campaigns — grouping offers, content, and affiliate links under a campaign umbrella.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 📊 Campaigns               [+ Tạo campaign] [Filter ▾]          │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Campaign Card ─────────────────────────────────────────────┐ │
│ │ 📊 "Spring Sale 2026"                     [🟢 Running]      │ │
│ │ Period: 15/3 - 30/3 · Budget: 10M VND · Spent: 6.2M        │ │
│ │ Products: 5 · Offers: 3 · Content: 12 posts                 │ │
│ │ Results: 234 orders · Revenue: 45M · ROAS: 7.2x             │ │
│ │ [📊 Dashboard] [✏️ Edit] [⏸ Pause]                         │ │
│ └──────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

---

## 60. Campaign Detail

**Route**: `/campaigns/[id]`
**Purpose**: Campaign dashboard with real-time metrics, linked content, offers, and attribution.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Campaigns   "Spring Sale 2026"          [🟢 Running] [⋮]     │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Metrics Bar ───────────────────────────────────────────────┐ │
│ │ Revenue    │ Orders   │ ROAS    │ Conv. Rate │ Budget      │ │
│ │ 45M VND   │ 234      │ 7.2x   │ 3.4%       │ 62% used   │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ Tabs: [Overview] [Content] [Offers] [Attribution] [Costs]       │
│                                                                  │
│ ── Overview ──                                                   │
│ ┌─ Revenue Chart (line, over time) ──────────────────────────┐ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ── Content Tab ──                                                │
│ Published content linked to this campaign with performance      │
│                                                                  │
│ ── Offers Tab ──                                                 │
│ Active offers under this campaign with usage stats              │
│                                                                  │
│ ── Attribution Tab ──                                            │
│ ┌─ Funnel ────────────────────────────────────────────────────┐ │
│ │ Views (120K) → Clicks (8.5K) → Add to Cart (2.1K) →        │ │
│ │ Orders (234) → Revenue (45M)                                 │ │
│ │ Per-platform breakdown below                                 │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ── Costs Tab ──                                                  │
│ Cost items, ad spend, sample costs linked to campaign            │
└──────────────────────────────────────────────────────────────────┘
```

---

## 61. Order Management

**Route**: `/orders`
**Purpose**: Cross-platform order list — all orders synced from TikTok Shop, Shopee, Lazada, etc.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 📦 Đơn hàng                 [Platform ▾] [Status ▾] [🔍]       │
├──────────────────────────────────────────────────────────────────┤
│ Quick stats: 📦 Today: 12 new · 💰 Today revenue: 5.2M        │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Order Row ─────────────────────────────────────────────────┐ │
│ │ #TK-1234    Nguyễn Văn A    🎵 TikTok Shop                 │ │
│ │ Serum Vitamin C × 2         598,000đ   [🟢 Delivered]       │ │
│ │ Ordered: 25/3 · Delivered: 27/3 · Commission: 59,800đ      │ │
│ │ [→ Detail] [💬 Contact buyer]                               │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Order Row ─────────────────────────────────────────────────┐ │
│ │ #SP-5678    Lê Hoa          🛍 Shopee                       │ │
│ │ Kem chống nắng × 1          199,000đ   [🟡 Shipping]       │ │
│ │ Ordered: 27/3 · Est. delivery: 29/3                         │ │
│ │ [→ Detail] [💬 Contact buyer]                               │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ [Tải thêm ↓]                                                    │
└──────────────────────────────────────────────────────────────────┘
```

### Order Status States
| State | Badge | Color |
|---|---|---|
| Pending | ⏳ Chờ xác nhận | Orange |
| Confirmed | ✅ Đã xác nhận | Blue |
| Shipping | 🚚 Đang giao | Yellow |
| Delivered | 🟢 Đã giao | Green |
| Completed | ✅ Hoàn thành | Green dark |
| Cancelled | ❌ Đã hủy | Gray |
| Refunded | 🔄 Đã hoàn tiền | Red |

---

## 62. Order Detail

**Route**: `/orders/[id]`
**Purpose**: Full order detail with items, buyer info, timeline, related proof.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Đơn hàng   #TK-1234              [🟢 Đã giao] [⋮]    │
├──────────────────────────────────┬───────────────────────────────┤
│ Main (65%)                       │ Side Panel (35%)               │
│                                  │                                │
│ ┌─ Order Items ───────────────┐  │ ┌─ Buyer Info ──────────────┐│
│ │ [📸] Serum Vitamin C 30ml   │  │ │ [👤] Nguyễn Văn A          ││
│ │     SKU: SKU-001 × 2        │  │ │ @nguyenvana · TikTok       ││
│ │     299,000đ × 2 = 598,000đ│  │ │ Orders: 3 · Total: 2.4M    ││
│ └────────────────────────────┘  │ │ Value: ★★★★☆ · VIP tag     ││
│                                  │ │ [👤 Profile] [💬 Message]  ││
│ ┌─ Price Breakdown ───────────┐  │ └─────────────────────────────┘│
│ │ Subtotal:      598,000đ    │  │                                │
│ │ Discount:      -59,800đ   │  │ ┌─ Proof & Trust ───────────┐│
│ │ Shipping:      +30,000đ   │  │ │ Source: [🟢 Official]     ││
│ │ Platform fee:  -47,840đ   │  │ │ Reconciled: ✅ Yes         ││
│ │ Commission:    -59,800đ   │  │ │ Settlement: #S-042        ││
│ │ ─────────────────────────  │  │ │ Last sync: 30m ago        ││
│ │ Net Revenue:   460,560đ   │  │ │ [Why? ▾]                  ││
│ └────────────────────────────┘  │ └─────────────────────────────┘│
│                                  │                                │
│ ┌─ Order Timeline ───────────┐  │ ┌─ Content Attribution ─────┐│
│ │ 25/3 10:05 ⏳ Order placed    │  │ │ 🎬 "5 tips nấu ăn" (TT)  ││
│ │ 25/3 10:10 ✅ Confirmed       │  │ │ 🔗 Affiliate link #AF-12  ││
│ │ 25/3 14:00 🚚 Shipped (VN)  │  │ │ 🏷 Offer: "Giảm 20%"      ││
│ │ 27/3 09:30 🟢 Delivered      │  │ │ 📊 Campaign: Spring Sale ││
│ │ 28/3 —    ✅ Completed       │  │ └─────────────────────────────┘│
│ └────────────────────────────┘  │                                │
│                                  │ ┌─ Actions ────────────────┐│
│                                  │ │ [💬 Liên hệ người mua]   ││
│                                  │ │ [📌 Tạo follow-up]       ││
│                                  │ │ [🔄 Yêu cầu hoàn tiền]   ││
│                                  │ │ [📎 Xuất hóa đơn]       ││
│                                  │ └─────────────────────────────┘│
└──────────────────────────────────┴───────────────────────────────┘
```

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Contact buyer | "💬 Liên hệ" | — | → Inbox thread with entity |
| Create follow-up | "📌 Tạo follow-up" | `FollowUpTaskService/Create` | Task linked to order |
| Request refund | "🔄 Hoàn tiền" | — | → Refund creation modal |
| Export invoice | "📎 Xuất hóa đơn" | Client-side PDF gen | Download invoice |
| View on platform | "→ TikTok Shop" | — | External link |
| Why this number | "Why? ▾" on proof | — | Explanation drawer |

### States
- **Loading**: Skeleton for header + items + timeline
- **Error**: "Không tải được đơn hàng" + retry button
- **Refunded**: Red banner "Order has been fully refunded" at top
- **Cancelled**: Gray overlay + "Cancelled" badge

---

## 63. Coupon Manager

**Route**: `/coupons`
**Purpose**: Create and manage discount coupons across platforms with usage tracking.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 🎟️ Mã giảm giá                      [+ Tạo mã mới] [📊 Stats]  │
├──────────────────────────────────────────────────────────────────┤
│ Filter: [Status ▾] [Platform ▾]   Search: [🔍              ]   │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Coupon Row ───────────────────────────────────────────────┐  │
│ │ 🎟️ SUMMER20 · 20% off · All products                      │  │
│ │ Valid: 1/4 – 30/4/2026 · Platform: TikTok Shop, Shopee    │  │
│ │ Usage: 45/100 (45%) · Revenue impact: -2.3M VND           │  │
│ │ Status: 🟢 Active                                          │  │
│ │ [✏ Edit] [📋 Copy code] [⏸ Pause] [🗑 Delete]            │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Coupon Row ───────────────────────────────────────────────┐  │
│ │ 🎟️ NEWUSER50K · 50,000đ off · Min order 200K              │  │
│ │ Valid: 1/3 – 31/12/2026 · Platform: All                    │  │
│ │ Usage: 12/∞ · Revenue impact: -600K VND                    │  │
│ │ Status: 🟢 Active                                          │  │
│ │ [✏ Edit] [📋 Copy code] [⏸ Pause] [🗑 Delete]            │  │
│ └────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

### Create/Edit Coupon (Modal)
```
┌─ Modal: Tạo mã giảm giá ─────────────────────────────────────┐
│ Code: [AUTO-GENERATE ▾] or [Custom: ________]                 │
│ Type: [● Percentage] [○ Fixed amount]                          │
│ Value: [20 %] or [50,000 đ]                                   │
│ Min order: [200,000 đ ▾]  Max discount: [100,000 đ ▾]        │
│ Products: [● All] [○ Specific categories] [○ Specific items]  │
│ Platforms: [☑ TikTok Shop] [☑ Shopee] [☐ Direct]             │
│ Valid from: [01/04/2026] to [30/04/2026]                       │
│ Usage limit: [100 ▾] or [∞]   Per-user limit: [1 ▾]          │
│ [Hủy]                                            [Tạo mã ✓]  │
└────────────────────────────────────────────────────────────────┘
```

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Create coupon | "+ Tạo mã" → form → submit | `CouponService/Create` | New coupon row |
| Edit | ✏ Edit | `CouponService/Update` | Coupon updated |
| Pause | ⏸ Pause → confirm | `CouponService/Pause` | Status → Paused |
| Resume | ▶ Resume | `CouponService/Resume` | Status → Active |
| Delete | 🗑 Delete → confirm | `CouponService/Delete` | Coupon removed |
| Copy code | 📋 Copy | — (clipboard) | Toast "Đã copy" |
| View stats | 📊 Stats | — | Drawer: usage chart, conversion rate, revenue impact |

---

## 64. Affiliate Links

**Route**: `/affiliates`
**Purpose**: Generate, manage, and track affiliate links with revenue attribution.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 🔗 Affiliate Links                    [+ Tạo link] [📊 Health]  │
├──────────────────────────────────────────────────────────────────┤
│ Filter: [Platform ▾] [Product ▾] [Status ▾]                    │
│ Summary: 23 links · 5.2K clicks (30d) · 342 orders · 18.5M rev│
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Link Row ─────────────────────────────────────────────────┐  │
│ │ 🔗 Serum Vitamin C · TikTok Shop affiliate                 │  │
│ │ Link: vt.tiktok.com/ZSYL... · [📋 Copy] [📱 QR]          │  │
│ │ 30d: 👁 1,234 clicks → 🛒 89 orders → 💰 12.5M rev       │  │
│ │ Commission: 8% · Earned: 1.0M VND                          │  │
│ │ CVR: 7.2% · Avg order: 140K                                │  │
│ │ Health: 🟢 Active · Last click: 2h ago                     │  │
│ │ [📊 Analytics] [✏ Edit] [📤 Share] [🗑 Remove]            │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Link Row ─────────────────────────────────────────────────┐  │
│ │ 🔗 Kem chống nắng · Shopee affiliate                       │  │
│ │ Link: s.shopee.vn/1abc... · [📋 Copy] [📱 QR]             │  │
│ │ 30d: 👁 456 clicks → 🛒 23 orders → 💰 3.2M rev          │  │
│ │ Health: 🟡 Stale (no clicks in 3d)                         │  │
│ │ [📊 Analytics] [✏ Edit] [🔄 Refresh] [🗑 Remove]          │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ── Link Health Dashboard ──                                      │
│ ┌─ Health Summary ───────────────────────────────────────────┐  │
│ │ 🟢 Active: 18 │ 🟡 Stale: 3 │ 🔴 Broken: 2 │ Total: 23  │  │
│ │ Broken links need attention: [🔧 Fix all →]                │  │
│ └────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

### Create Link Flow
1. Click "+ Tạo link" → Select product → Select platform → Generate
2. Platform-specific link generated via platform API
3. UTM/tracking parameters auto-appended
4. QR code generated alongside

### Health States
| State | Trigger | Badge |
|---|---|---|
| 🟢 Active | Clicked in last 24h | Green |
| 🟡 Stale | No clicks in 3+ days | Yellow |
| 🔴 Broken | HTTP 404 or API error | Red |
| ⚪ Expired | Platform link expired | Grey |

---

## 65. Membership Plans

**Route**: `/memberships`
**Purpose**: Create paid membership tiers with exclusive content/perks for followers.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 🎖️ Gói thành viên                              [+ Tạo gói mới] │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Summary ──────────────────────────────────────────────────┐  │
│ │ Active subscribers: 124 · MRR: 12.4M VND · Churn: 3.2%    │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Plan Card ────────────────────────────────────────────────┐  │
│ │ 🥉 Fan — 49,000đ/tháng · 89 subscribers                   │  │
│ │ Features: Early access, member badge, monthly Q&A          │  │
│ │ Status: 🟢 Active · Revenue: 4.36M/mo                     │  │
│ │ [✏ Edit] [👥 View members] [📊 Analytics]                 │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Plan Card ────────────────────────────────────────────────┐  │
│ │ 🥈 Supporter — 149,000đ/tháng · 28 subscribers            │  │
│ │ Features: All Fan perks + exclusive tutorials, discord VIP │  │
│ │ Status: 🟢 Active · Revenue: 4.17M/mo                     │  │
│ │ [✏ Edit] [👥 View members] [📊 Analytics]                 │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Plan Card ────────────────────────────────────────────────┐  │
│ │ 🥇 VIP — 499,000đ/tháng · 7 subscribers                   │  │
│ │ Features: All Supporter + 1:1 monthly call, custom content │  │
│ │ Status: 🟢 Active · Revenue: 3.49M/mo                     │  │
│ │ [✏ Edit] [👥 View members] [📊 Analytics]                 │  │
│ └────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

### Create/Edit Plan Modal
- Plan name, emoji, price, billing period
- Feature list (checkboxes from predefined + custom)
- Access rules: which content is gated
- Welcome message for new subscribers
- Trial period option

---

## 66. Store Pages

**Route**: `/store`
**Purpose**: Micro-store landing pages with visual editor — product showcases, testimonials.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 🏪 Store Pages                  [+ Tạo page mới] [👁 Preview]   │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Page Card ────────────────────────────────────────────────┐  │
│ │ 🏪 "Summer Skincare Collection"                            │  │
│ │ URL: creativanta.link/shop/summer-skincare                 │  │
│ │ Products: 8 · Views: 1,234 · Orders: 45 · CVR: 3.6%      │  │
│ │ Status: 🟢 Published · Last edited: 2d ago                │  │
│ │ [✏ Edit] [📊 Analytics] [📤 Share] [🗑 Delete]           │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ── Editor (opens on Edit) ──                                     │
│ ┌─ Visual Editor ────────────────────────────────────────────┐  │
│ │ Section: [Hero]                                             │  │
│ │ ┌──────────────────────────────────────────────┐            │  │
│ │ │ [Background image/video ▾]                    │            │  │
│ │ │ Headline: [Summer Skincare 2026           ]  │            │  │
│ │ │ Subtitle: [Chăm sóc da mùa hè hoàn hảo  ]  │            │  │
│ │ │ CTA: [Mua ngay →]                            │            │  │
│ │ └──────────────────────────────────────────────┘            │  │
│ │ [↓ Add section: Products | Testimonials | FAQ | Custom]    │  │
│ │                                                              │  │
│ │ Section: [Products Grid]                                    │  │
│ │ ┌──────────────────────────────────────────────┐            │  │
│ │ │ [Drag products here — or select from catalog] │            │  │
│ │ │ [Prod 1 ×] [Prod 2 ×] [Prod 3 ×] [+ Add]   │            │  │
│ │ └──────────────────────────────────────────────┘            │  │
│ │                                                              │  │
│ │ Section: [Testimonials]                                     │  │
│ │ ┌──────────────────────────────────────────────┐            │  │
│ │ │ [Import from comments/reviews ▾]             │            │  │
│ │ │ "Serum tuyệt vời!" ⭐⭐⭐⭐⭐ — Nguyễn A    │            │  │
│ │ └──────────────────────────────────────────────┘            │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ Device preview: [📱 Mobile] [💻 Desktop]                        │
│ [💾 Save draft] [📤 Publish]                                    │
└──────────────────────────────────────────────────────────────────┘
```

---

## 67. Refund Management

**Route**: `/orders/refunds`
**Purpose**: Track and process refund requests across platforms.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 🔄 Hoàn tiền                [Status ▾] [Platform ▾]             │
├──────────────────────────────────────────────────────────────────┤
│ Tabs: [Chờ xử lý (3)] [Đã duyệt (8)] [Từ chối (2)]           │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Refund Request ────────────────────────────────────────────┐ │
│ │ 🔄 Order #TK-1234 · Nguyễn Văn A · 598,000đ                │ │
│ │ Reason: Sản phẩm không như mô tả                            │ │
│ │ Platform: TikTok Shop · Requested: 1d ago                   │ │
│ │ [📸 Evidence photos (3)] · Source: [Official platform data] │ │
│ │                                                              │ │
│ │ [✅ Accept refund] [❌ Reject] [💬 Contact buyer] [📊 Detail]│ │
│ └──────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

---

## 68. Sample Requests

**Route**: `/samples`
**Purpose**: Track sample requests from influencers/reviewers.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 📦 Yêu cầu mẫu                        [+ Tạo yêu cầu][Filter] │
├──────────────────────────────────────────────────────────────────┤
│ Pipeline: [Requested(5)] → [Approved(3)] → [Shipped(2)] →      │
│           [Received(8)] → [Review Published(12)]                │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Request Card ─────────────────────────────────────────────┐  │
│ │ 📦 Serum Vitamin C → @skincare_queen (45K followers)       │  │
│ │ Status: [🟡 Shipped] · Tracking: VNPOST-123456             │  │
│ │ Expected review: 05/04/2026 · Platform: TikTok             │  │
│ │ [📋 Track] [💬 Contact] [📊 Profile]                      │  │
│ └────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

### 69. Sample Shipments (`/samples/shipments`)
- Track physical shipment of samples
- Link to carrier tracking APIs
- Status: preparing → shipped → in_transit → delivered

---

## Mobile Screens

### M30. Mobile Product List

**Route**: `/commerce/products` (mobile)
**Purpose**: Browse products in a card grid with quick creation.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ 🛍 Sản phẩm                                 [🔍] [Filter ▾]    │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ Filter: [All] [Active] [Draft] [Out of stock]                    │
│                                                                  │
│ ┌──────────────┐  ┌──────────────┐                               │
│ │ [🖼 thumb]   │  │ [🖼 thumb]   │                               │
│ │ Serum Vit C  │  │ Sunscreen    │                               │
│ │ 350,000đ     │  │ 250,000đ     │                               │
│ │ [🟢 Active]  │  │ [🟡 Draft]   │                               │
│ │ 45 sold      │  │ 0 sold       │                               │
│ ├──────────────┤  ├──────────────┤                               │
│ │ [🖼 thumb]   │  │ [🖼 thumb]   │                               │
│ │ Toner HA     │  │ Mặt nạ đất   │                               │
│ │ 280,000đ     │  │ sét 150,000đ │                               │
│ │ [🟢 Active]  │  │ [🔴 Out]     │                               │
│ │ 120 sold     │  │ 89 sold      │                               │
│ └──────────────┘  └──────────────┘                               │
│                                                                  │
│                                        [+ Thêm sản phẩm] ⊕      │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M30 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| View detail | Tap card | — | → Product detail full screen |
| Create | FAB "+" | — | → Product creation flow |
| Filter | Tap chip | — | Grid filtered |

---

### M31. Mobile Order List

**Route**: `/commerce/orders` (mobile)
**Purpose**: Browse and triage orders with swipe actions.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ 📦 Đơn hàng                                 [🔍] [Filter ▾]    │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ Quick stats: 💰 Today: 2.5M · 📦 Pending: 3 · ↩ Refund: 1     │
│                                                                  │
│ Tabs: [All] [⏳ Pending (3)] [📦 Shipped (5)] [✅ Done (12)]    │
│                                                                  │
│ ┌─ Order Row ────────────────────────────────────────────────┐  │
│ │ #12456 · Serum Vit C × 1 · 350,000đ        [⏳ Pending]  │  │
│ │ Nguyễn A · 30 min ago · COD                                │  │
│ │ ← Swipe R: [📱 Contact buyer]                             │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Order Row ────────────────────────────────────────────────┐  │
│ │ #12455 · Sunscreen × 2 · 500,000đ          [📦 Shipped]   │  │
│ │ Trần B · 2h ago · Prepaid                                  │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Order Row ────────────────────────────────────────────────┐  │
│ │ #12454 · Toner × 1 · 280,000đ              [✅ Done]      │  │
│ │ Lê C · 1d ago · Prepaid                                    │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ Pull-to-refresh · Infinite scroll                                │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M31 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| View detail | Tap row | — | → Order detail full screen |
| Contact buyer | Swipe right | — | → M5 thread with buyer |
| Filter | Tap tab | — | List filtered by status |
| Pull-to-refresh | Pull down | `OrderService/List` | Orders refreshed |

---

### M32. Mobile Offer List

**Route**: `/commerce/offers` (mobile)
**Purpose**: Browse promotional offers with status and usage tracking.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ 🎁 Ưu đãi                                    [+ Tạo mới]       │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Offer Card ───────────────────────────────────────────────┐  │
│ │ 🏷 "SUMMER2026" · 20% off all products     [🟢 Active]   │  │
│ │ Used: 45/100 · Revenue impact: +2.1M · Expires 30/4       │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Offer Card ───────────────────────────────────────────────┐  │
│ │ 🏷 "NEWUSER" · Free shipping                [🟢 Active]   │  │
│ │ Used: 120/∞ · Revenue impact: +800K · No expiry           │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Offer Card ───────────────────────────────────────────────┐  │
│ │ 🏷 "NEWYEAR" · 30% off skincare            [⚪ Expired]   │  │
│ │ Used: 89/100 · Revenue impact: +3.5M · Expired 1/2        │  │
│ └──────────────────────────────────────────────────────────────┘  │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M32 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| View/Edit | Tap card | — | → Offer detail/edit bottom sheet |
| Create | "+ Tạo mới" | — | → Offer creation flow |

---

### M33. Mobile Refund Review

**Route**: `/commerce/refunds` (mobile)
**Purpose**: Review and process refund requests with evidence.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Yêu cầu hoàn tiền                         [Pending: 3]       │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Refund Request ───────────────────────────────────────────┐  │
│ │ ↩ Order #12450 · Serum Vit C · 350,000đ                   │  │
│ │ Reason: "Sản phẩm bị vỡ khi ship"                         │  │
│ │ [📷 Evidence: 2 photos] ← tap to view carousel             │  │
│ │ Requested: 2h ago · Customer: ★★★★☆                       │  │
│ │ ← Swipe R: [✅ Accept] · Swipe L: [❌ Reject]             │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Refund Request ───────────────────────────────────────────┐  │
│ │ ↩ Order #12448 · Toner × 1 · 280,000đ                     │  │
│ │ Reason: "Giao sai sản phẩm"                               │  │
│ │ [📷 Evidence: 1 photo]                                     │  │
│ │ Requested: 5h ago · Customer: ★★★☆☆                       │  │
│ │ ← Swipe R: [✅ Accept] · Swipe L: [❌ Reject]             │  │
│ └──────────────────────────────────────────────────────────────┘  │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M33 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Accept | Swipe right → confirm | `RefundService/Approve` | Refund processed |
| Reject | Swipe left → reason | `RefundService/Reject` | Refund rejected with reason |
| View evidence | Tap photos | — | Full-screen photo carousel |
| View order | Tap order ID | — | → Order detail |

---

### M45. Mobile Campaign List

**Route**: `/commerce/campaigns` (mobile)
**Purpose**: Browse marketing campaigns with performance badges.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ 📣 Campaigns                                  [+ Tạo mới]       │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ Filter: [All] [🟢 Active] [⏸ Paused] [✅ Done]                 │
│                                                                  │
│ ┌─ Campaign Card ────────────────────────────────────────────┐  │
│ │ 📣 "Summer Skincare Sale"                   [🟢 Active]   │  │
│ │ Budget: 5M/10M · ROAS: 3.2x · Clicks: 12K               │  │
│ │ Running since 15/3 · Ends 30/4                             │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Campaign Card ────────────────────────────────────────────┐  │
│ │ 📣 "New Product Launch"                     [⏸ Paused]    │  │
│ │ Budget: 2M/5M · ROAS: 1.8x · Clicks: 5K                 │  │
│ │ Paused on 25/3 · Resume pending                            │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Campaign Card ────────────────────────────────────────────┐  │
│ │ 📣 "Valentine Special"                      [✅ Done]      │  │
│ │ Budget: 3M/3M · ROAS: 4.5x · Clicks: 25K                │  │
│ │ Completed 15/2                                              │  │
│ └──────────────────────────────────────────────────────────────┘  │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M45 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| View detail | Tap card | — | → Campaign detail (deep link to web) |
| Create | "+ Tạo mới" | — | → Campaign creation flow |
| Filter | Tap chip | — | List filtered by status |


### M46. Mobile Affiliate Dashboard

**Route**: `/commerce/affiliates` (mobile)
**Purpose**: Manage affiliate links with performance indicators and quick sharing.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ 🔗 Affiliate Links                         [+ Tạo link mới]     │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Quick Stats ──────────────────────────────────────────────┐  │
│ │ 💰 MTD: 3.07M commission · 🔗 12 links · 📊 56 orders    │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Link Card ────────────────────────────────────────────────┐  │
│ │ 🟢 "Serum Vitamin C" · TikTok Shop                        │  │
│ │ Clicks: 2,345 · Orders: 56 · Revenue: 25.6M               │  │
│ │ Commission: 12% → 3.07M earned                             │  │
│ │ [📋 Copy] [📤 Share] [📎 Add to bio]                      │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Link Card ────────────────────────────────────────────────┐  │
│ │ 🟡 "Sunscreen SPF50" · Shopee                              │  │
│ │ Clicks: 891 · Orders: 23 · Revenue: 5.8M                  │  │
│ │ Commission: 10% → 580K earned                              │  │
│ │ [📋 Copy] [📤 Share] [📎 Add to bio]                      │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Link Card ────────────────────────────────────────────────┐  │
│ │ 🔴 "Toner HA" · Website (low performance)                  │  │
│ │ Clicks: 45 · Orders: 1 · Revenue: 280K                    │  │
│ │ Commission: 15% → 42K earned                               │  │
│ │ [📋 Copy] [📤 Share]                                      │  │
│ └──────────────────────────────────────────────────────────────┘  │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M46 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| View analytics | Tap card | — | → Link analytics detail |
| Copy link | "Copy" | — | Clipboard + toast |
| Share | "Share" | — | Native share sheet |
| Add to bio | "Add to bio" | — | → Link-in-bio editor |
| Create | "+ Tạo link mới" | — | → Link creation flow |

---

### M47. Mobile Coupon Manager

**Route**: `/commerce/coupons` (mobile)
**Purpose**: Manage coupon codes with quick copy and sharing.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ 🏷 Mã giảm giá                               [+ Tạo mới]       │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Coupon Card ──────────────────────────────────────────────┐  │
│ │ 🏷 "SUMMER2026" · 20% off                 [🟢 Active]    │  │
│ │ Used: 45/100 · Revenue: +2.1M · Expires 30/4             │  │
│ │ [📋 Copy code] [📤 Share]                                 │  │
│ │ ← Swipe L: [⏸ Pause]                                     │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Coupon Card ──────────────────────────────────────────────┐  │
│ │ 🏷 "NEWUSER" · Free shipping               [🟢 Active]    │  │
│ │ Used: 120/∞ · Revenue: +800K · No expiry                  │  │
│ │ [📋 Copy code] [📤 Share]                                 │  │
│ │ ← Swipe L: [⏸ Pause]                                     │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Coupon Card ──────────────────────────────────────────────┐  │
│ │ 🏷 "NEWYEAR" · 30% off skincare            [⚪ Expired]   │  │
│ │ Used: 89/100 · Revenue: +3.5M · Expired 1/2              │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ Pull-to-refresh                                                  │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M47 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| View detail | Tap card | — | → Coupon detail bottom sheet |
| Copy code | "Copy code" | — | Clipboard + toast |
| Share | "Share" | — | Native share sheet |
| Pause | Swipe left | `CouponService/Update(paused)` | Status → Paused |
| Create | "+ Tạo mới" | — | → Coupon creation flow |

---

### M48. Mobile Sample Requests

**Route**: `/commerce/samples` (mobile)
**Purpose**: Track product sample requests pipeline with influencers.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ 🎁 Sample Requests                           [+ Tạo yêu cầu]   │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ Filter: [All] [📩 New] [📦 Shipped] [✅ Received] [📝 Reviewed] │
│                                                                  │
│ ┌─ Sample Card ──────────────────────────────────────────────┐  │
│ │ 🎁 Serum Vit C → @beauty_mi (45K followers)               │  │
│ │ Status: [📦 Shipped] · Tracking: VN12345678                │  │
│ │ Sent: 25/3 · Est. delivery: 28/3                           │  │
│ │ [📦 Track shipment]                                        │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Sample Card ──────────────────────────────────────────────┐  │
│ │ 🎁 Sunscreen SPF50 → @skin_expert (120K followers)        │  │
│ │ Status: [📩 New] · Awaiting approval                       │  │
│ │ Requested: 27/3                                             │  │
│ │ [✅ Approve] [❌ Decline]                                  │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Sample Card ──────────────────────────────────────────────┐  │
│ │ 🎁 Toner HA → @daily_glow (25K followers)                 │  │
│ │ Status: [✅ Received] · Review pending                     │  │
│ │ Delivered: 22/3 · Content due: 29/3                        │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ Pull-to-refresh                                                  │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M48 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| View detail | Tap card | — | → Request detail bottom sheet |
| Approve | "Approve" | `SampleService/Approve` | Status → Approved |
| Decline | "Decline" → reason | `SampleService/Decline` | Status → Declined |
| Track shipment | "Track shipment" | — | External tracking link |
| Create | "+ Tạo yêu cầu" | — | → Sample request creation |

---

## Missing Detail Screens (Gap Fixes)

### 63b. Coupon Detail (`/coupons/[id]`)

**Route**: `/coupons/[id]`
**Purpose**: Create/edit coupon with discount rules, conditions, usage limits, and analytics.

#### Layout
```
┌─ App Shell ─────────────────────────────────────────────────────┐
│ ← Mã giảm giá   "SUMMER2026"               [✏️ Edit] [🗑 Delete]│
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Coupon Info ───────────────────────────────────────────────┐  │
│ │ Code: SUMMER2026 · Status: 🟢 Active                        │  │
│ │ Type: [Percentage ▾] · Value: [15%]                         │  │
│ │ Min order: [200,000 VND] · Max discount: [100,000 VND]      │  │
│ │ Valid: 01/06 → 30/06/2026                                    │  │
│ │ Usage: 45/100 (45%)                                          │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Conditions ────────────────────────────────────────────────┐  │
│ │ Applies to: [☑ All products] [☐ Specific categories]        │  │
│ │ Platforms: [☑ TikTok Shop] [☑ Shopee] [☐ Website]           │  │
│ │ Stackable: [No ▾]                                            │  │
│ │ One per user: [Yes]                                          │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Usage Analytics ──────────────────────────────────────────┐   │
│ │ Total uses: 45 · Revenue influenced: 15.2M VND             │   │
│ │ Avg order: 338K VND · Conversion: 12%                       │   │
│ │ [Bar chart: daily usage over validity period]                │   │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ [💾 Save changes] [📋 Copy code] [📤 Share]                     │
└──────────────────────────────────────────────────────────────────┘
```

#### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Save | "Save changes" | `CouponService/Update` | Toast "Đã lưu" |
| Delete | "Delete" → confirm | `CouponService/Delete` | → `/coupons` |
| Copy code | "Copy code" | — | Clipboard + toast |
| Pause | ⋮ → Pause | `CouponService/Update(paused)` | Status → Paused |

---

### 64b. Affiliate Link Detail (`/affiliates/[id]`)

**Route**: `/affiliates/[id]`
**Purpose**: View/edit individual affiliate link analytics, commission settings, and performance.

#### Layout
```
┌─ App Shell ─────────────────────────────────────────────────────┐
│ ← Affiliate Links   "Serum Review Link"         [✏️] [📋 Copy]  │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Link Info ─────────────────────────────────────────────────┐  │
│ │ URL: creativanta.link/abc123                                │  │
│ │ Product: Serum Vitamin C · Platform: TikTok Shop            │  │
│ │ Commission: 12% · Created: 15/2/2026                        │  │
│ │ UTM: source=tiktok&medium=affiliate&campaign=serum          │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Performance (30d) ─────────────────────────────────────────┐  │
│ │ Clicks: 2,345 │ Orders: 56 │ Revenue: 25.6M VND            │  │
│ │ CTR: 2.4% │ Conv: 2.4% │ Commission earned: 3.07M VND     │  │
│ │ [Line chart: clicks + orders over 30d]                      │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Content Using This Link ──────────────────────────────────┐   │
│ │ Video: "Serum review honest" — 45K views · 30 orders        │   │
│ │ Post: "Skincare routine" — 12K reach · 8 orders             │   │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ [📤 Share] [📋 Copy link] [⏸ Pause] [🗑 Delete]                │
└──────────────────────────────────────────────────────────────────┘
```

---

### 65b. Membership Plan Detail (`/memberships/[id]`)

**Route**: `/memberships/[id]`
**Purpose**: Create/edit membership plan with tiers, pricing, benefits, and subscriber management.

#### Layout
```
┌─ App Shell ─────────────────────────────────────────────────────┐
│ ← Gói thành viên   "VIP Club"              [✏️ Edit] [🗑 Delete]│
├──────────────────────────────────────────────────────────────────┤
│ Tabs: [Details] [Benefits] [Subscribers] [Analytics]             │
│                                                                  │
│ ── Details Tab ──                                                │
│ ┌─ Plan Info ─────────────────────────────────────────────────┐  │
│ │ Name: VIP Club · Status: 🟢 Active                          │  │
│ │ Price: 199,000 VND/month                                     │  │
│ │ Trial: 7 days free                                           │  │
│ │ Renewal: Auto · Billing: Stripe/VNPay                        │  │
│ │ Description: [Rich text editor]                              │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ── Benefits Tab ──                                               │
│ ┌─ Benefit List (drag to reorder) ────────────────────────────┐  │
│ │ ⠿ 🎬 Exclusive behind-the-scenes content       [✏️] [🗑]   │  │
│ │ ⠿ 💬 Priority DM responses                      [✏️] [🗑]   │  │
│ │ ⠿ 🛍️ 20% off all products                      [✏️] [🗑]   │  │
│ │ [+ Add benefit]                                              │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ── Subscribers Tab ──                                            │
│ Total: 234 · MRR: 46.6M VND · Churn: 5%                        │
│ [Table: Name, Joined, Status, Revenue, Last active]              │
│                                                                  │
│ [💾 Save] [👁 Preview page]                                      │
└──────────────────────────────────────────────────────────────────┘
```

---

### 66b. Store Page Editor (`/store/editor`)

**Route**: `/store/editor`
**Purpose**: Visual builder for customizing the public storefront page with drag-and-drop sections.

#### Layout
```
┌─ App Shell ─────────────────────────────────────────────────────┐
│ ← Cửa hàng   Store Editor              [👁 Preview] [🚀 Publish]│
├─────────────────────────────┬────────────────────────────────────┤
│ Section Panel (30%)         │ Preview (70%)                      │
│                             │                                    │
│ ── Sections ──              │ ┌─ Live Preview ────────────────┐ │
│ ⠿ 🖼 Hero Banner           │ │ [Hero: Brand image + tagline] │ │
│ ⠿ 🛍️ Featured Products    │ │                                │ │
│ ⠿ 📝 About Us             │ │ [Product Grid: 6 items]        │ │
│ ⠿ 📸 Gallery              │ │                                │ │
│ ⠿ ⭐ Testimonials          │ │ [About section]                │ │
│ ⠿ 📧 Contact Form         │ │                                │ │
│                             │ │ [Gallery carousel]             │ │
│ [+ Add section]             │ │                                │ │
│                             │ │ [Testimonial cards]            │ │
│ ── Settings ──              │ └────────────────────────────────┘ │
│ Theme: [Modern ▾]          │                                    │
│ Primary color: [🎨]         │                                    │
│ Font: [Inter ▾]            │                                    │
│ Custom domain: [shop.me]   │                                    │
└─────────────────────────────┴────────────────────────────────────┘
```

#### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Reorder | Drag sections | — | Local state update |
| Edit section | Click section | — | Inline editor opens in preview |
| Add section | "+ Add section" | — | Section type picker modal |
| Preview | "Preview" | — | New tab with live preview |
| Publish | "Publish" | `StoreService/Publish` | Store page live |
| Save draft | Auto-save every 30s | `StoreService/SaveDraft` | Draft saved |
