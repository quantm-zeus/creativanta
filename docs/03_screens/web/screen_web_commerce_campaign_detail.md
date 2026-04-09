# Screen: Web — Campaign Detail

> **Screen ID**: W065
> **Module**: M14 — Monetization & Campaigns
> **Route**: `/campaigns/[id]`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 06 §7-8 (Commerce/Campaigns), campaigns schema + CampaignService projections, B5 RBAC §2.7

---

## 1. Purpose & Context

The Campaign Detail screen is a real-time performance dashboard for a specific marketing campaign. It shows revenue attribution, a multi-stage conversion funnel, linked content and offers, cost analysis with ROAS calculation, and per-platform breakdown. This is where sellers evaluate whether promotions are profitable and decide to extend, pause, or replicate campaigns.

### User Goals
- Monitor campaign performance in real-time (revenue, orders, ROAS)
- Understand the conversion funnel (views → clicks → cart → orders → revenue)
- See which content and offers are driving the most conversions
- Track campaign costs and measure profitability
- Make data-driven decisions on campaign management (extend, pause, increase budget)

### Business Goals
- Drive campaign optimization through real-time attribution data
- Connect promotions to the Proof Graph — every campaign revenue is traceable
- Enable budget accountability through cost tracking and ROAS
- Support multi-platform campaign measurement (TikTok, Shopee, Instagram, YouTube)

### When This Screen Is Used
- Active campaign: Daily monitoring of real-time performance
- Ending campaign: Final review before stopping
- Post-campaign: Analyzing ROI to decide replication
- Planning: Reviewing past campaigns to inform future strategy

### Entry Points
- Campaign List (W064): Click campaign row
- Home Dashboard (W001): Active campaign widget
- Offer Detail (W067): "Xem campaign gắn" link
- AI Copilot: "Campaign Spring Sale đang chạy thế nào?"
- Notification: "📊 Campaign 'Spring Sale' đã đạt 100 đơn!"

### Exit Points
- Click content item → Publish Item Detail (W049)
- Click offer → Offer Detail (W067)
- Click "Chỉnh sửa" → Campaign Edit (W065/edit)
- "📤 Export báo cáo" → PDF/CSV download
- Back → Campaign List (W064)

---

## 2. Preconditions / Postconditions

### Preconditions
- User authenticated with valid workspace session
- User has `campaign:manage` permission (Owner/Admin/Manager/Editor)
- Campaign `campaign_id` exists and belongs to current workspace
- At least some UTM-tagged events exist for attribution data

### Postconditions
- Page view logged: `campaign.detail.viewed`
- Campaign data freshness checked on load
- Export actions logged in audit trail

---

## 3. Screen Layout

### Responsive Behavior
| Breakpoint | Layout |
|---|---|
| Desktop (≥1280px) | App Shell + header bar + 2-column charts + tab content |
| Tablet (768-1279px) | App Shell (collapsed) + stacked sections |
| Mobile (≤767px) | Redirect to Mobile Campaign Detail (M025) |

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Campaigns   "Spring Sale 2026"       [🟢 Live] [✏ Sửa] [⋮]      │
├──────────────────────────────────────────────────────────────────────┤
│ 📅 25/03 — 31/03/2026 · Ngày 5/7 · Budget: 2M/5M (40%)            │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ Metrics Bar (6 KPIs) ───────────────────────────────────────────┐│
│ │ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌─────────┐││
│ │ │ Revenue  │ │ Orders   │ │ ROAS     │ │ Conv %   │ │ Budget  │││
│ │ │ 45M VND  │ │ 234      │ │ 7.2x     │ │ 3.4%     │ │ 62%     │││
│ │ │ ↑+23%    │ │ ↑+18%    │ │ ↑+1.2x   │ │ →        │ │ used    │││
│ │ └──────────┘ └──────────┘ └──────────┘ └──────────┘ └─────────┘││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ Tabs: [📊 Overview] [📝 Content (8)] [🏷 Offers (3)] [🔄 Funnel] [💰 Costs]│
│                                                                      │
│ ── 📊 Overview Tab ──                                                │
│ ┌─ Revenue Over Time ──────────────────────────────────────────────┐│
│ │ [Line chart: daily revenue over campaign period]                  ││
│ │ ███▂▃▅▆████▇▅▃▄▆████                                             ││
│ │ Mar 25   Mar 26   Mar 27   Mar 28   Mar 29                       ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ┌─ Platform Breakdown ──────────┐ ┌─ Top Products ─────────────────┐│
│ │ 🎵 TikTok   25M (55%) ██████│ │ 1. Serum VitC    12M  ████████ ││
│ │ 🛍 Shopee   12M (27%) ███   │ │ 2. Sunscreen     8M   █████    ││
│ │ 📸 Instagram 5M (11%) █     │ │ 3. Toner AHA     5M   ███      ││
│ │ 💬 Direct    3M (7%)  █     │ │ 4. Others        20M  ████████ ││
│ └──────────────────────────────┘ └─────────────────────────────────┘│
│                                                                      │
│ ── 🔄 Funnel Tab ──                                                  │
│ ┌─ Attribution Funnel ─────────────────────────────────────────────┐│
│ │ Impressions (120K) │ Clicks (8.5K) │ Add to Cart (2.1K) │       ││
│ │ ████████████████   │ ████████      │ ████                │       ││
│ │        ↓ 7.1%           ↓ 24.7%         ↓ 11.1%                 ││
│ │ Orders (234)       │ Revenue (45M)                                ││
│ │ ████                │ ████                                        ││
│ │                                                                    ││
│ │ Per-platform funnel breakdown:                                     ││
│ │ 🎵 TikTok: 80K → 5.2K → 1.4K → 156 → 25M                       ││
│ │ 🛍 Shopee: 30K → 2.1K → 500 → 55 → 12M                         ││
│ │ 📸 Instagram: 10K → 1.2K → 200 → 23 → 5M                        ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ── 📝 Content Tab ──                                                 │
│ ┌─ Linked Content ────────────────────────────────────────────────┐ │
│ │ Title           │ Platform │ Views  │ Clicks │ Orders │ Revenue │ │
│ │ Review Serum    │ TikTok   │ 45K    │ 2.1K   │ 89     │ 12M    │ │
│ │ Skincare AM     │ TikTok   │ 35K    │ 1.8K   │ 67     │ 8M     │ │
│ │ Honest review   │ Instagram│ 10K    │ 1.2K   │ 23     │ 5M     │ │
│ │ [+ Gắn thêm nội dung]                                           │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ── 💰 Costs Tab ──                                                   │
│ ┌─ Cost Breakdown ────────────────────────────────────────────────┐ │
│ │ Category        │ Amount │ % Budget │ Proof Status              │ │
│ │ Ad spend        │ 3M     │ 60%      │ 🟢 Platform-tracked      │ │
│ │ Sample costs    │ 1.5M   │ 30%      │ 🟡 Manual entry          │ │
│ │ Affiliate comm  │ 500K   │ 10%      │ 🟢 Auto-calculated       │ │
│ │ Total: 5M       │        │ 100%     │                           │ │
│ │ ROAS: 45M / 5M = 9.0x                                           │ │
│ │ [+ Thêm chi phí]                                                │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ [📤 Export báo cáo]                                                  │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
CampaignDetailPage
├── AppShell (shared)
├── PageHeader
│   ├── BackLink ("← Campaigns" → /campaigns)
│   ├── CampaignName ("Spring Sale 2026")
│   ├── StatusBadge (🟢 Live / ⏸ Paused / ✅ Completed / 📝 Ready)
│   ├── EditButton ("✏ Sửa" → edit mode)
│   └── OverflowMenu ("⋮" → Duplicate, End campaign, Delete)
├── CampaignMetaBar
│   ├── DateRange ("📅 25/03 — 31/03/2026")
│   ├── DayProgress ("Ngày 5/7")
│   └── BudgetUsage ("Budget: 2M/5M (40%)" with mini progress bar)
├── MetricsBar (6 KPIs)
│   └── MetricCard[] (repeating)
│       ├── MetricLabel ("Revenue", "Orders", etc.)
│       ├── MetricValue (animated counter)
│       ├── TrendIndicator (↑↓→ with %)
│       └── ProofBadge (optional — S009 for verified data)
├── TabContainer
│   ├── OverviewTab
│   │   ├── RevenueTimeChart (line chart — daily revenue over campaign period)
│   │   │   ├── LineChart (interactive — hover for daily values)
│   │   │   ├── XAxisLabels (campaign dates)
│   │   │   └── Tooltip (date + revenue + orders)
│   │   ├── ChartsRow (side-by-side on desktop)
│   │   │   ├── PlatformBreakdownChart (horizontal bar — revenue by platform)
│   │   │   │   └── PlatformBar[] (icon + name + amount + percentage)
│   │   │   └── TopProductsChart (horizontal bar — revenue by product)
│   │   │       └── ProductBar[] (name + amount + bar)
│   │   └── UTMSourcesTable (referral sources breakdown)
│   ├── ContentTab
│   │   ├── ContentTable
│   │   │   ├── TableHeader (Title, Platform, Views, Clicks, Orders, Revenue)
│   │   │   ├── ContentRow[] (sortable by any column)
│   │   │   │   ├── ContentTitle (clickable → W049)
│   │   │   │   ├── PlatformIcon
│   │   │   │   ├── Views (formatted number)
│   │   │   │   ├── Clicks
│   │   │   │   ├── Orders
│   │   │   │   └── Revenue (VND)
│   │   │   └── TotalRow (sum of all columns)
│   │   └── LinkContentButton ("+ Gắn thêm nội dung" → content selector modal)
│   ├── OffersTab
│   │   ├── OfferCard[] (linked offers with redemption stats)
│   │   │   ├── OfferName + DiscountBadge
│   │   │   ├── CouponCode (copyable)
│   │   │   ├── RedemptionProgress
│   │   │   └── RevenueAttribution
│   │   └── LinkOfferButton ("+ Gắn offer" → offer selector modal)
│   ├── FunnelTab
│   │   ├── AttributionFunnel (progressive bar chart)
│   │   │   ├── FunnelStage[] (Impressions → Clicks → Add Cart → Orders → Revenue)
│   │   │   │   ├── StageName
│   │   │   │   ├── StageValue
│   │   │   │   ├── StageBar (proportional width)
│   │   │   │   └── ConversionRate (% drop between stages)
│   │   └── PlatformFunnelBreakdown
│   │       └── PlatformFunnelRow[] (per-platform stage breakdown)
│   └── CostsTab
│       ├── CostTable
│       │   ├── TableHeader (Category, Amount, % of Budget, Proof Status)
│       │   ├── CostRow[]
│       │   │   ├── CategoryName
│       │   │   ├── Amount (VND)
│       │   │   ├── BudgetPercent
│       │   │   └── ProofBadge (🟢/🟡/🔴)
│       │   └── TotalRow
│       ├── ROASIndicator ("ROAS: 9.0x" — large, prominent)
│       └── AddCostButton ("+ Thêm chi phí")
├── ExportButton ("📤 Export báo cáo" → dropdown: PDF, CSV)
└── FloatingActionBar (shows on scroll — Edit, Pause/End, Export)
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Campaign metadata | `campaigns` table | `CampaignService/Get(campaign_id)` | Title, dates, status, budget | No cache (fresh) |
| Revenue total | Campaign metrics projection | `CampaignService/GetMetrics(campaign_id)` | Compact VND ("45M VND") | 5m |
| Orders count | Campaign metrics projection | Same above | Integer ("234") | 5m |
| ROAS | Revenue / Total costs | Computed client-side | Decimal + "x" ("7.2x") | — |
| Conversion rate | Orders / Clicks × 100 | Computed from funnel data | Percentage ("3.4%") | — |
| Budget usage | `SUM(cost_items.amount) / campaigns.budget` for campaign-scoped costs | Included in metadata | Percentage + progress bar | 5m |
| Revenue over time | Revenue timeline projection | `CampaignService/GetRevenueTimeline(campaign_id, granularity='day')` | Line chart data points | 15m |
| Platform breakdown | Platform-breakdown projection | `CampaignService/GetPlatformBreakdown(campaign_id)` | Bar chart | 15m |
| Top products | Top-products projection | `CampaignService/GetTopProducts(campaign_id)` | Bar chart | 15m |
| Funnel stages | Funnel projection | `CampaignService/GetFunnel(campaign_id)` | Funnel visualization | 15m |
| Linked content | Campaign-linked content projection | `CampaignService/GetLinkedContent(campaign_id)` | Table rows | 5m |
| Linked offers | Campaign-linked offer projection + redemption stats | `CampaignService/GetLinkedOffers(campaign_id)` | Offer cards | 5m |
| Cost items | `cost_items` scoped to the campaign | `CampaignService/GetCosts(campaign_id)` | Table rows (VND) | 5m |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | View campaign | Page load | `CampaignService/Get + GetMetrics + GetFunnel` | — | Full dashboard renders | `campaign:manage` |
| 2 | Edit campaign | Click "✏ Sửa" | — | — | Navigate → `/campaigns/[id]/edit` | `campaign:manage` |
| 3 | Pause campaign | "⋮" → "Tạm dừng" | `CampaignService/Pause(id)` | `campaigns.status = 'paused'` | Status badge → ⏸. Toast "Campaign đã tạm dừng" | `campaign:manage` |
| 4 | Resume campaign | "⋮" → "Tiếp tục" (paused) | `CampaignService/Resume(id)` | `campaigns.status = 'live'` | Status badge → 🟢. Toast "Campaign đang chạy" | `campaign:manage` |
| 5 | End campaign | "⋮" → "Kết thúc" → confirm | `CampaignService/End(id)` | `campaigns.status = 'completed'` | Confirmation → Status → ✅. All offers paused. | `campaign:manage` |
| 6 | Duplicate | "⋮" → "Nhân bản" | `CampaignService/Duplicate(id)` | New draft campaign | Toast → navigate to new campaign | `campaign:manage` |
| 7 | Delete | "⋮" → "Xóa" → confirm | `CampaignService/Delete(id)` | Soft delete | Confirmation → redirect to `/campaigns` | `campaign:manage` |
| 8 | Switch tab | Click tab | Client-side tab switch (data lazy-loaded) | — | Tab content updates, URL: `?tab=content` | `campaign:manage` |
| 9 | Sort content table | Click column header | Client-side sort | — | Table rows re-order | `campaign:manage` |
| 10 | Link content | "+ Gắn thêm nội dung" | `CampaignService/LinkContent(campaign_id, content_ids[])` | Campaign-linked content projection refreshed | Modal → content selector → linked items appear in table | `campaign:manage` |
| 11 | Unlink content | "⋮" → "Bỏ liên kết" on content row | `CampaignService/UnlinkContent(campaign_id, content_id)` | Campaign-linked content projection refreshed | Row removed with animation | `campaign:manage` |
| 12 | Link offer | "+ Gắn offer" | `CampaignService/LinkOffer(campaign_id, offer_id)` | `campaigns.related_offer_ids` updated + linked-offer projection refreshed | Modal → offer selector → card appears | `campaign:manage` |
| 13 | Add cost | "+ Thêm chi phí" | `CampaignService/AddCost(campaign_id, data)` | `cost_items` insert scoped to campaign | Modal with form → row added. ROAS recalculated. | `campaign:manage` |
| 14 | Export PDF | "📤 Export" → PDF | `CampaignService/ExportReport(campaign_id, 'pdf')` | — | PDF download: campaign report with charts | `campaign:manage` |
| 15 | Export CSV | "📤 Export" → CSV | `CampaignService/ExportReport(campaign_id, 'csv')` | — | CSV download: raw data tables | `campaign:manage` |

---

## 7. Validation Rules

### Add Cost Entry (Modal)
| Field | Rule | Error |
|---|---|---|
| Category | Required, select from: Ad spend, Sample costs, Affiliate commission, Creative costs, Other | "Chọn danh mục chi phí" |
| Amount | Required, > 0, ≤ 10B VND | "Số tiền phải lớn hơn 0" |
| Date | Required, within campaign period | "Ngày phải trong thời gian campaign" |
| Description | Required for "Other" category, min 5 chars | "Mô tả chi phí" |
| Receipt/proof | Optional but encouraged | Warning: "Nên đính kèm chứng từ" |

### Link Content (Modal)
| Check | Rule | Error |
|---|---|---|
| Content exists | Must be published or scheduled content | "Chỉ liên kết nội dung đã xuất bản hoặc đã lên lịch" |
| No duplicate | Content not already linked to this campaign | "Nội dung này đã được liên kết" |
| UTM tracking | Content should have UTM params for attribution | Warning: "Nội dung chưa có UTM tracking. Attribution sẽ không chính xác." |

---

## 8. States

| State | Condition | Visual | User Action |
|---|---|---|---|
| LOADING | Initial page load | Metrics shimmer + tab skeletons | Wait |
| LOADED | All data received | Full dashboard with animated counters | Interact |
| PLANNED | `campaigns.status = 'planned'` | 📝 badge, setup in progress | Prepare structure |
| READY | `campaigns.status = 'ready'` | ⏳ badge, metrics show "Chưa bắt đầu". Content/offers can be linked. | Prepare launch |
| LIVE | `campaigns.status = 'live'` | 🟢 badge, metrics updating, all actions available | Monitor/edit |
| PAUSED | Manually paused | ⏸ badge, metrics frozen at pause time. "Tiếp tục" action available. | Resume or end |
| COMPLETED | Campaign concluded | ✅ badge, metrics final, "Nhân bản" prominent. Cost tab editable. | Review/export |
| CANCELLED | Campaign cancelled before completion | 🚫 badge, metrics frozen, mutation actions hidden | Review/export |
| NO_DATA | Campaign running but no UTM events yet | Metrics show "0", funnel empty. Message: "Dữ liệu sẽ xuất hiện khi có lượt xem đầu tiên." | Wait for traffic |
| NO_CONTENT | Content tab empty | "Chưa có nội dung liên kết. [+ Gắn nội dung]" | Link content |
| NO_OFFERS | Offers tab empty | "Chưa có offer liên kết. [+ Gắn offer]" | Link offer |
| OVER_BUDGET | Costs exceed budget | Budget bar shows red, warning: "⚠️ Chi phí đã vượt ngân sách!" | Adjust budget or end |
| EXPORT_GENERATING | Report being generated | Export button shows spinner | Wait |
| ERROR | API load failed | "Không tải được campaign. [Thử lại]" | Retry |
| NOT_FOUND | Campaign doesn't exist | "Campaign không tồn tại." → redirect to `/campaigns` after 3s | Navigate |

---

## 9. Permission Matrix

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View campaign detail | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| View funnel/analytics | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Edit campaign | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Pause/Resume/End | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Link/unlink content | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Link/unlink offers | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Add costs | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Delete campaign | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Export report | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |

### Visibility Rules
- **Editor**: Can view all tabs and link content. Cannot manage campaign lifecycle or costs.
- **Contributor**: No access on this screen; campaign detail remains limited to `campaign:manage` roles per canonical RBAC.
- **Viewer/External**: No access. Sidebar item hidden.

---

## 10. Navigation Map

```
Campaign Detail (/campaigns/[id])
├── ← /campaigns                          (Back button)
├── → /campaigns/[id]/edit                 (Edit button)
├── → /publish/items/[content_id]          (Click content row → W049)
├── → /offers/[offer_id]                   (Click offer card → W067)
├── → /campaigns                           (After delete → redirect)
├── → /campaigns/[new_id]                  (After duplicate → new campaign)
│
│ URL parameters:
├── ?tab=overview|content|offers|funnel|costs   (tab selection)
└── ?period=7d|30d|all                          (time filter for metrics)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Offline — hiển thị dữ liệu cached." | Auto-refresh on reconnect |
| API error (load) | Server 5xx on campaign fetch | Full-page: "Không tải được campaign. [Thử lại]" | Retry button |
| API error (action) | Server 5xx on pause/end/delete | Toast: "❌ Không thể {action}. Thử lại." | Retry |
| Campaign not found | 404 | "Campaign không tồn tại hoặc đã bị xóa." → redirect after 3s | Navigate to list |
| Funnel data lag | UTM events delayed | Banner on funnel tab: "⏳ Dữ liệu attribution có thể chậm 1-2 giờ." | Wait |
| Export failed | PDF/CSV generation error | Toast: "❌ Không tạo được báo cáo. Thử lại sau." | Retry |
| Concurrent edit | Another user modified campaign | Toast: "Campaign đã được cập nhật. [Tải lại]" | Refresh page |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Metrics cards | `role="status"`, `aria-label` includes label + value + trend |
| Tab bar | `role="tablist"`, `aria-selected` on active tab |
| Funnel chart | Alt text: "Conversion funnel: 120K impressions, 8.5K clicks (7.1%), 2.1K add to cart (24.7%), 234 orders (11.1%), 45M revenue" |
| Revenue chart | `aria-label` with data summary + data table fallback via `<details>` |
| Content table | Standard table ARIA with sortable column headers (`aria-sort`) |
| Status badge | `aria-label="Campaign status: Running"` (not relying on color/emoji) |
| Progress bar (budget) | `role="progressbar"`, `aria-valuenow`, `aria-valuemax`, `aria-label="Budget usage"` |
| Export button | `aria-label="Export campaign report as PDF or CSV"` |
| Keyboard | Tab navigates between tabs + interactive elements. Arrow keys switch tabs. |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Screen mount | 0ms | App Shell + PageHeader with campaign name. MetricsBar shows 6 shimmer cards. |
| Campaign metadata | 100-200ms | Name, status, dates populate. |
| Metrics | 200-500ms | Shimmer → animated counter roll-up (numbers animate from 0). |
| Active tab data | 300-600ms | Tab content area: skeleton → content populates. |
| Charts | 400-800ms | Chart containers show loading spinner → charts render with animation. |
| Lazy tabs | On tab switch | 200-400ms fetch + 150ms transition animation. |

---

## 14. Performance Requirements

| Metric | Target |
|---|---|
| LCP | < 2.0s (metrics bar — complex data aggregation) |
| FID | < 100ms |
| CLS | < 0.05 (fixed chart container heights) |
| TTI | < 2.5s |
| Metrics fetch | < 500ms (pre-aggregated in ClickHouse) |
| Chart render | < 500ms (layerchart library) |
| Tab switch | < 300ms (lazy-loaded data) |
| Export PDF | < 5s |
| Export CSV | < 2s |

---

## 15. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| Metrics (revenue, orders) | Polling | Every 5 minutes (running campaigns) |
| Funnel data | Polling | Every 15 minutes (UTM aggregation lag) |
| Linked content performance | Polling | Every 5 minutes |
| Cost entries | On-demand | Refetch after add/edit cost |
| Campaign status | SSE `/events/campaigns/{id}` | Real-time (paused by another user) |

---

## 16. Localization Notes

- Primary language: Vietnamese (vi-VN)
- Currency: VND compact ("45M VND", "500K", "2M/5M")
- ROAS: Decimal + "x" suffix ("7.2x", "9.0x")
- Percentages: Vietnamese format ("3.4%", "↑+23%")
- Dates: `dd/MM/yyyy` or `dd/MM` (same year)
- Day counter: "Ngày 5/7" (day 5 of 7 total)
- Countdown: "Còn 3 ngày" (time remaining)
- Funnel labels: Vietnamese ("Lượt xem", "Lượt click", "Thêm giỏ hàng", "Đơn hàng", "Doanh thu")

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `campaign.detail.viewed` | Page load | `campaign_id`, `status`, `tab`, `days_active` |
| `campaign.tab.switched` | Tab change | `from_tab`, `to_tab` |
| `campaign.chart.interacted` | Click/hover chart element | `chart_type`, `element`, `value` |
| `campaign.content.linked` | Link content to campaign | `campaign_id`, `content_id`, `content_count` |
| `campaign.content.unlinked` | Unlink content | `campaign_id`, `content_id` |
| `campaign.offer.linked` | Link offer | `campaign_id`, `offer_id` |
| `campaign.cost.added` | Add cost entry | `campaign_id`, `category`, `amount` |
| `campaign.paused` | Pause campaign | `campaign_id`, `revenue_at_pause`, `days_active` |
| `campaign.ended` | End campaign | `campaign_id`, `final_revenue`, `final_roas` |
| `campaign.exported` | Export report | `campaign_id`, `format` (pdf/csv) |
| `campaign.duplicated` | Duplicate campaign | `source_campaign_id` |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-surface-primary` | Page background |
| `--color-surface-elevated` | Metric cards, chart containers, tables |
| `--color-accent` | Active tab indicator, edit button |
| `--color-success` | 🟢 Running badge, positive ROAS (> 1x), revenue trend ↑ |
| `--color-warning` | ⏳ Scheduled badge, over-budget warning |
| `--color-danger` | Negative ROAS (< 1x), delete action |
| `--color-neutral` | ⏸ Paused badge, ⏹ Ended badge |
| `--color-chart-primary` | Revenue line in time chart |
| `--color-chart-secondary` | Orders line overlay |
| `--color-funnel-gradient` | Funnel stage bars (gradient: blue → green) |
| `--color-platform-tiktok` | TikTok breakdown bar/chip |
| `--color-platform-shopee` | Shopee breakdown bar/chip |
| `--color-platform-instagram` | Instagram breakdown bar/chip |
| `--font-metric-lg` | KPI values (32px, bold) |
| `--font-metric-sm` | Trend indicators (14px) |
| `--spacing-section-gap` | Gap between dashboard sections (24px) |
| `--radius-card` | Card/chart container radius (12px) |

---

## 19. Technical Implementation Notes

### SvelteKit Specifics
- **Route**: `src/routes/(app)/campaigns/[id]/+page.svelte`
- **Server load**: `+page.server.ts` → fetch campaign + metrics + active tab data
- **Charts**: `layerchart` library (SvelteKit-optimized, SSR-friendly)
- **Funnel**: Custom SVG funnel component with progressive widths
- **Tab lazy-loading**: Each tab fetches data on first visit via `$effect` or `load` function
- **Export PDF**: Client-side `pdf-lib` with chart screenshots via `html2canvas`
- **Export CSV**: Server-side generation via `CampaignService/ExportReport`

### Data Fetching Strategy
```
+page.server.ts:
  const tab = url.searchParams.get('tab') ?? 'overview';

  const [campaign, metrics] = await Promise.all([
    campaignService.get(params.id),
    campaignService.getMetrics(params.id),
  ]);

  // Lazy-load tab data based on active tab
  let tabData;
  switch(tab) {
    case 'overview': tabData = await campaignService.getOverviewData(params.id); break;
    case 'content': tabData = await campaignService.getLinkedContent(params.id); break;
    case 'offers': tabData = await campaignService.getLinkedOffers(params.id); break;
    case 'funnel': tabData = await campaignService.getFunnel(params.id); break;
    case 'costs': tabData = await campaignService.getCosts(params.id); break;
  }
```

### Attribution Model
- **UTM-based**: `utm_campaign`, `utm_source`, `utm_medium`, `utm_content`
- **First-touch**: Attribution to first campaign touchpoint
- **Window**: 7-day attribution window (configurable per workspace)
- **Deduplication**: Same user counted once per funnel stage

---

## 20. Related Screens & Revision History

### Related Screens
| Screen | Relationship |
|---|---|
| [W064] Campaign List | Parent — navigates here on row click |
| [W067] Offer Detail | Linked — offers associated with campaigns |
| [W057] Publish Item Detail | Linked — content performance drill-down |
| [W082] Revenue Detail | Linked — revenue attributed to campaigns |
| [W083] Cost Detail | Sibling — cost entries flow into campaign costs |
| [M031] Mobile Campaigns | Mobile equivalent |

### Revision History
| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A upgrade**: Full 20-point rewrite. Added: real APIs (CampaignService), attribution funnel (5-stage), per-platform breakdown, content/offer linking, cost tracking with ROAS, 15 actions, 13 states, lazy-loaded tabs, ClickHouse aggregation patterns, chart specifications, and comprehensive error handling. | System |
| 2026-03-28 | 1.0 | Initial specification (Tier C — template-based) | System |
