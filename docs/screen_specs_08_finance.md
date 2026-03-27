# Screen Specs 08 — Finance & Proof (M16-M17)

> **Upstream**: Product Freeze §25-27, A1 Schema (profit_snapshots, settlements, cost_items, reconciliation_records, evidence_objects, proof_bundles), D3 Analytics
> **Screens**: 8 web + 4 mobile screens
> **Screen Numbers**: §70-§77 (per screen_index.md canonical numbering)

---

## 70. Profit Dashboard

**Route**: `/profit`
**Purpose**: Central financial dashboard — revenue, costs, net profit, margin tracking with trust/proof indicators. NEVER show unreconciled data without clear caveat.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 💰 Lợi nhuận                              [Period: 30d ▾]       │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ KPI Row ───────────────────────────────────────────────────┐ │
│ │ 💰 Gross Revenue  │ 📉 Total Costs   │ 📊 Net Profit       │ │
│ │ 45.2M VND ↑18%   │ 18.3M VND        │ 26.9M VND ↑22%     │ │
│ │ [Official] [High] │ [Mixed sources]  │ Margin: 59.5%       │ │
│ │ [Why this? ▾]     │ [Why this? ▾]    │ [Why this? ▾]       │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Revenue Chart ─────────────────────────────────────────────┐ │
│ │ [Area chart: Daily revenue + costs over period]             │ │
│ │ Legend: 🟢 Revenue  🔴 Costs  🟡 Net Profit                │ │
│ │ [7d] [30d] [90d] [Custom]                                  │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Revenue by Platform ──┐ ┌─ Revenue by Product ────────────┐ │
│ │ [Donut chart]           │ │ 1. Serum VitC    18.2M (40%)   │ │
│ │ TikTok: 25M (55%)      │ │ 2. Kem chống nắng 8.5M (19%)  │ │
│ │ Shopee: 15M (33%)      │ │ 3. Combo set      6.1M (14%)  │ │
│ │ Direct: 5.2M (12%)     │ │ ... [Xem tất cả →]             │ │
│ └─────────────────────────┘ └─────────────────────────────────┘ │
│                                                                  │
│ ┌─ Reconciliation Status ─────────────────────────────────────┐ │
│ │ ✅ Fully reconciled: 85%                                    │ │
│ │ ⚠️ Partially reconciled: 10% (4.5M VND unverified)         │ │
│ │ ❌ Unreconciled: 5% (2.3M VND)                             │ │
│ │ [Xem chi tiết reconciliation →]                              │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Cost Breakdown ────────────────────────────────────────────┐ │
│ │ 📦 COGS: 12.1M (66%)  · 📊 Ads: 3.2M (17%)                │ │
│ │ 🚚 Shipping: 1.8M (10%) · 🤖 AI credits: 0.6M (3%)        │ │
│ │ 📋 Other: 0.6M (3%)                                         │ │
│ │ [Xem chi tiết costs →]                                       │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Trust Panel (always visible) ──────────────────────────────┐ │
│ │ Source: Mixed (Official + Imported + Estimated)             │ │
│ │ Confidence: Medium-High                                     │ │
│ │ Last full sync: 2h ago                                      │ │
│ │ ⚠️ 3 pending settlements not included in total               │ │
│ │ [📋 Xem Proof Bundle →]                                     │ │
│ └──────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

### Data Sources
| Section | API | Trust Level |
|---|---|---|
| KPIs | `ProfitService/GetSummary(period)` | Shows source_class per metric |
| Charts | ClickHouse `profit_events` aggregation | — |
| Platform breakdown | `ProfitService/GetByPlatform` | Per-platform source |
| Product breakdown | `ProfitService/GetByProduct` | — |
| Reconciliation | `ReconciliationService/GetStatus` | — |
| Costs | `CostItemService/List` aggregated | — |
| Trust | Computed from reconciliation status | — |

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Change period | Period dropdown | Refetch all | Dashboard updates |
| Why this number | Click "Why?" | — | Explanation drawer opens |
| View proof | "📋 Xem Proof Bundle" | — | → `/profit/proof` |
| View costs | "Xem chi tiết costs" | — | → `/profit/costs` |
| View reconciliation | "Xem chi tiết reconciliation" | — | → `/profit/reconciliation` |
| Export P&L | ⋮ → "📥 Export P&L" | Client-side CSV/PDF gen | Download |

---

## 71. Revenue Details

**Route**: `/profit/revenue`
**Purpose**: Detailed revenue breakdown — per order, per product, per platform, with full drilldown and trust indicators.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Profit   💰 Chi tiết doanh thu              [Period: 30d ▾]  │
├──────────────────────────────────────────────────────────────────┤
│ Total: 45.2M VND · Source: [Mixed] · [📊 Full analytics →]   │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Revenue Trend Chart ───────────────────────────────────────┐ │
│ │ [Area chart: daily revenue by platform, stacked]             │ │
│ │ Legend: 🎵 TikTok  🛒 Shopee  📱 Direct  🔗 Affiliate           │ │
│ │ Toggle: [Revenue] [Orders] [AOV]                              │ │
│ └──────────────────────────────────────────────────────────┘ │
│                                                                  │
│ Filter: [Platform ▾] [Product ▾] [Source class ▾] [🔍 Search]   │
│                                                                  │
│ ┌─ Revenue Table ────────────────────────────────────────────┐ │
│ │ Date  │ Platform   │ Product        │ Order   │ Amount  │ Src │ │
│ │──────┼────────────┼────────────────┼─────────┼─────────┼─────┤ │
│ │ 27/3  │ 🎵 TikTok  │ Serum VitC     │ #TK-1234│ 598K    │ 🟢  │ │
│ │ 27/3  │ 🛒 Shopee  │ Kem chống nắng │ #SP-5678│ 199K    │ 🟢  │ │
│ │ 26/3  │ 🔗 Aff     │ Combo set     │ #AF-9012│ 549K    │ 🟡  │ │
│ │ 26/3  │ 🎵 TikTok  │ Serum VitC     │ #TK-1233│ 299K    │ 🟢  │ │
│ │ ...                                                          │ │
│ └──────────────────────────────────────────────────────────┘ │
│                                                                  │
│ Source class legend: 🟢 Official · 🔵 Imported · 🟡 Estimated     │
│ Click row → order detail · [📥 Export CSV] [📥 Export PDF]       │
└──────────────────────────────────────────────────────────────────┘
```

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Filter by platform | Platform dropdown | Refetch | Table updates |
| Filter by source | Source class dropdown | Refetch | Shows only Official/Imported/Estimated |
| View order | Click row | — | → `/orders/[id]` |
| Export CSV | "📥 Export CSV" | Client-side gen | Download |
| Export PDF | "📥 Export PDF" | Client-side gen | Download |
| Toggle chart | Revenue/Orders/AOV | — (client) | Chart updates |

---

## 72. Cost Manager

**Route**: `/profit/costs`
**Purpose**: Track all business costs — COGS, shipping, ads, AI credits, platform fees.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Profit   📉 Chi phí                         [+ Thêm chi phí] │
├──────────────────────────────────────────────────────────────────┤
│ Period: [30d ▾] · Total: 18.3M VND                              │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Category: COGS (12.1M) ───────────────────────────────────┐ │
│ │ Serum Vitamin C     150,000đ × 89 = 13.35M   [Auto-calc]  │ │
│ │ Kem chống nắng      80,000đ × 45 = 3.6M      [Auto-calc]  │ │
│ │ Setup cost COGS: [✏️ Edit unit costs]                       │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Category: Advertising (3.2M) ─────────────────────────────┐ │
│ │ TikTok Ads        2.1M   [Synced from platform]            │ │
│ │ Facebook Ads       0.8M   [Manual entry]                    │ │
│ │ Google Ads         0.3M   [Manual entry]                    │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Category: Operations (2.4M) ──────────────────────────────┐ │
│ │ Shipping           1.8M   [Imported from orders]           │ │
│ │ AI Credits         0.6M   [Auto-tracked]                   │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Category: Manual (0.6M) ──────────────────────────────────┐ │
│ │ + Add manual cost: [Name    ] [Amount    ] [Category ▾]     │ │
│ └──────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

---

## 73. Reconciliation Center

**Route**: `/profit/reconciliation`
**Purpose**: Reconcile financial data across platforms. Match orders ↔ settlements ↔ payouts.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Profit   🔍 Reconciliation Center                             │
├──────────────────────────────────────────────────────────────────┤
│ Status: ✅ 85% reconciled · ⚠️ 15% pending                     │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Pending Reconciliation ────────────────────────────────────┐ │
│ │ ▣ Settlement #S-001 · TikTok · 2.5M VND · 3d ago           │ │
│ │   Matched orders: 15/18 · Unmatched: 3 (450K VND)          │ │
│ │   [🔍 Review matches] [✅ Approve] [📋 Flag dispute]       │ │
│ │                                                              │ │
│ │ ▣ Settlement #S-002 · Shopee · 1.8M VND · 5d ago           │ │
│ │   Matched orders: 22/22 · ✅ Fully matched                  │ │
│ │   [✅ One-click approve]                                     │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Conflicts ─────────────────────────────────────────────────┐ │
│ │ ❌ Order #TK-5678: Platform says 299K, our calc shows 319K │ │
│ │    Difference: 20K VND · Likely: platform fee not captured  │ │
│ │    [🔧 Resolve] [👤 Assign to team]                         │ │
│ └──────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

---

## 74. Proof Browser

**Route**: `/profit/proof`
**Purpose**: Browse and verify proof bundles — evidence supporting financial claims.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Profit   📋 Proof Bundles                                     │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Proof Bundle Card ─────────────────────────────────────────┐ │
│ │ 📋 March 2026 Revenue · Coverage: 85%                       │ │
│ │ Evidence: 45 items (34 official, 8 imported, 3 estimated)  │ │
│ │ Gaps: 3 settlements pending, 2 unlinked orders              │ │
│ │ [🔍 Open bundle] [📥 Export]                                │ │
│ └──────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

### Proof Bundle Detail
- List all evidence objects with source class badges
- Show claim → evidence mapping
- Highlight gaps and missing evidence
- Export as PDF for accounting

---

## 75. Settlement Tracker

**Route**: `/profit/settlements`
**Purpose**: Track platform payouts/settlements from e-commerce platforms. Match settlements to orders.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Profit   💳 Settlements               [Platform ▾] [Status ▾] │
├──────────────────────────────────────────────────────────────────┤
│ Summary: Pending: 3.2M VND · Matched: 85% · Next payout: 30/3  │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Settlement Row ──────────────────────────────────────────┐ │
│ │ 💳 #S-042 · 🎵 TikTok Shop · 2.5M VND    [✅ Matched]      │ │
│ │ Settlement date: 25/3/2026 · Payout: 27/3/2026              │ │
│ │ Orders matched: 18/18 · ✅ Fully reconciled                  │ │
│ │ Source: [🟢 Official] · Bank ref: VCB-2026-0342             │ │
│ │ [🔍 View orders] [📋 Proof bundle] [📥 Export]              │ │
│ └──────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Settlement Row ──────────────────────────────────────────┐ │
│ │ 💳 #S-041 · 🛒 Shopee · 1.8M VND           [⚠️ Partial]     │ │
│ │ Settlement date: 22/3/2026 · Payout: pending                │ │
│ │ Orders matched: 20/22 · Unmatched: 2 (180K VND)             │ │
│ │ Source: [🟡 Imported] · Difference: -45K platform fee          │ │
│ │ [🔍 View orders] [🔧 Resolve] [📎 Flag dispute]              │ │
│ └──────────────────────────────────────────────────────────┘ │
│                                                                  │
│ [Tải thêm ↓]                                                    │
└──────────────────────────────────────────────────────────────────┘
```

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| View orders | "🔍 View orders" | — | Drawer with matched order list |
| Resolve mismatch | "🔧 Resolve" | `ReconciliationService/Resolve` | Mark as resolved with explanation |
| Flag dispute | "📎 Flag" | `ReconciliationService/FlagDispute` | Creates dispute case |
| Export | "📥 Export" | Client-side | CSV/PDF download |
| Filter | Platform/Status dropdowns | Refetch | List updates |

---

## 76. Financial Reports

**Route**: `/profit/reports`
**Purpose**: Generate P&L, cash flow, and custom financial reports with trust annotations.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Profit   📊 Báo cáo tài chính                [+ Tạo báo cáo]  │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Report Templates ────────────────────────────────────────┐ │
│ │ ┌────────────┐ ┌────────────┐ ┌────────────┐ ┌─────────┐ │ │
│ │ │ 📊 P&L    │ │ 💰 Revenue │ │ 📉 Cost    │ │ 📈 Margin│ │ │
│ │ │ Statement │ │ by Channel│ │ Analysis │ │ Trend  │ │ │
│ │ └────────────┘ └────────────┘ └────────────┘ └─────────┘ │ │
│ └──────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Custom Report Builder ───────────────────────────────────┐ │
│ │ Date range: [01/03/2026] → [31/03/2026]                      │ │
│ │ Group by:  [● Daily] [○ Weekly] [○ Monthly]                   │ │
│ │ Filters:   [Platform ▾] [Product ▾] [Category ▾]             │ │
│ │ Include:   [☑ Revenue] [☑ Costs] [☑ Net] [☐ Commission]      │ │
│ │ [📊 Generate report]                                          │ │
│ └──────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Generated Report Preview ───────────────────────────────┐ │
│ │ 📊 P&L Statement — March 2026                               │ │
│ │ Revenue:    45.2M VND  [Source: Mixed]                       │ │
│ │ COGS:      -12.1M VND                                       │ │
│ │ Gross:      33.1M VND  (73.2%)                               │ │
│ │ Operating: -6.2M VND                                        │ │
│ │ Net Profit: 26.9M VND  (59.5%)                               │ │
│ │ ⚠️ Trust note: 85% reconciled, 15% estimated                 │ │
│ │ [📥 CSV] [📥 PDF] [📥 Google Sheets]                          │ │
│ └──────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Select template | Click template card | — (client) | Pre-fills report builder |
| Generate report | "📊 Generate" | `ProfitService/GenerateReport` | Preview renders |
| Export CSV | "📥 CSV" | Client-side gen | Download |
| Export PDF | "📥 PDF" | Client-side gen | Download |
| Export Sheets | "📥 Google Sheets" | Google Sheets API | Opens in new tab |

---

## 77. AI Credit Usage

**Route**: `/settings/credits`
**Purpose**: Track AI credit consumption, purchase credits, view usage history.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 🪙 AI Credits                                                    │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Balance ───────────────────────────────────────────────────┐ │
│ │ Remaining: 🪙 320 / 500    ████████████░░░░░░ 64%           │ │
│ │ Resets: 1/4/2026 · Plan: Pro (500/month)                    │ │
│ │ [💳 Mua thêm credits] [📈 Nâng cấp gói]                    │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Usage This Month ─────────────────────────────────────────┐ │
│ │ [Bar chart: daily credit usage, colored by mode]            │ │
│ │ Quick Edit: 45cr · Clip Factory: 30cr · Showcase: 60cr     │ │
│ │ Remix: 35cr · Other: 10cr                                   │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Usage History (table) ─────────────────────────────────────┐ │
│ │ Date     │ Mode      │ Item               │ Credits │ Status│ │
│ │ 27/3     │ Showcase  │ "Serum VitC video"  │ -15      │ ✅    │ │
│ │ 27/3     │ Thumbnail │ "5 tips thumbnail"  │ -5       │ ✅    │ │
│ │ 26/3     │ Remix     │ "Cooking AI remix"  │ -35      │ ✅    │ │
│ │ 26/3     │ Remix     │ "Skincare remix"    │ -35      │ ❌ ref│ │
│ └──────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

---

## Mobile Screens

### M7. Mobile Profit Summary

**Route**: `/finance` (mobile)
**Purpose**: Simplified financial KPIs with AI explanations and trust panel.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ 💰 Profit                                    [Period: 7d ▾]     │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ KPI Cards (horizontal scroll) ────────────────────────────┐  │
│ │ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐       │  │
│ │ │ 📈 Rev.  │ │ 💰 Profit│ │ 📉 Costs │ │ 🔄 Recon │       │  │
│ │ │ 12.5M    │ │ 3.2M     │ │ 9.3M     │ │ 97%      │       │  │
│ │ │ ▲18%     │ │ ▲12%     │ │ ▲22%     │ │ matched  │       │  │
│ │ │ [Why? ▾] │ │ [Why? ▾] │ │ [Why? ▾] │ │ [View ▾] │       │  │
│ │ └──────────┘ └──────────┘ └──────────┘ └──────────┘       │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Revenue Chart (landscape-friendly) ───────────────────────┐  │
│ │ [Bar chart: daily revenue, 7 days]                         │  │
│ │ Tap bar → tooltip with breakdown                            │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Reconciliation (donut chart) ─────────────────────────────┐  │
│ │ [🟢 Matched: 97%] [🟡 Pending: 2%] [🔴 Mismatched: 1%]  │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Trust Panel (collapsible) ─── [▾] ────────────────────────┐  │
│ │ Source: Shopee API + Manual · Last sync: 5 min ago         │  │
│ │ Confidence: 95% · [📊 Full report →]                       │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ [+ Nhập chi phí]                                                 │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M7 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Why explanation | "Why?" on KPI | — | Bottom sheet with AI explanation |
| View chart detail | Tap chart bar | — | Tooltip with daily breakdown |
| Full report | "Full report" | — | → Web deep link to finance detail |
| Add cost | "+ Nhập chi phí" | — | → M34 Cost Entry |
| Change period | Period dropdown | `FinanceService/Summary` | KPIs refresh |

---

### M34. Mobile Cost Entry

**Route**: `/finance/costs/new` (mobile)
**Purpose**: Quick cost logging with receipt scanning.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Nhập chi phí                                                   │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Cost Form ────────────────────────────────────────────────┐  │
│ │ Tên chi phí: [Ads Facebook tháng 3          ]              │  │
│ │ Số tiền:     [2,500,000                   đ]               │  │
│ │ Danh mục:    [📢 Quảng cáo ▾]                              │  │
│ │ Ngày:        [27/03/2026 ▾]                                 │  │
│ │ Ghi chú:     [Campaign Spring Sale          ]              │  │
│ │                                                              │  │
│ │ [📷 Quét hóa đơn] (future — camera OCR)                    │  │
│ │ [🔄 Recurring: Off ▾]                                      │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ── Recent Costs ──                                               │
│ ┌────────────────────────────────────────────────────────────┐  │
│ │ 25/3 · Ads Google · 1,800,000đ · Quảng cáo                │  │
│ │ 22/3 · Packaging · 500,000đ · Vật liệu                    │  │
│ │ 20/3 · Shipping fee · 350,000đ · Vận chuyển               │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ [💾 Lưu chi phí]                                                 │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M34 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Save | "Lưu chi phí" | `FinanceService/CreateCost` | Cost saved, toast |
| Category select | Tap dropdown | — | Bottom sheet picker |
| Scan receipt | "Quét hóa đơn" | Camera → OCR | Auto-fill form fields |
| Edit recent | Tap recent cost | — | Form pre-filled for editing |

---

## Empty States (Finance Module)

| Screen | Empty State | CTA |
|---|---|---|
| §70 Profit Dashboard | "💰 Dữ liệu tài chính sẽ hiển thị khi có đơn hàng đầu tiên. Kết nối cửa hàng để bắt đầu." | [🔗 Kết nối cửa hàng] |
| §71 Revenue Details | "💰 Chưa có doanh thu. Kết nối platform bán hàng." | [🔗 Kết nối] |
| §72 Cost Manager | "📉 Chưa ghi nhận chi phí nào. Thêm chi phí đầu tiên hoặc kết nối track tự động." | [+ Thêm chi phí] |
| §73 Reconciliation | "🔍 Chưa có giao dịch cần đối soát." | — |
| §74 Proof Browser | "📋 Proof bundle sẽ tự tạo khi dữ liệu tài chính đủ." | — |
| §75 Settlement Tracker | "💳 Chưa có settlement. Dữ liệu sẽ đồng bộ từ platform bán hàng." | — |
| §76 Financial Reports | "📊 Cần ít nhất 7 ngày dữ liệu để tạo báo cáo." | — |
| §77 AI Credit Usage | "🪙 Credits sẽ hiển thị khi bạn bắt đầu tạo nội dung AI." | [🎬 Tạo nội dung AI đầu tiên] |

