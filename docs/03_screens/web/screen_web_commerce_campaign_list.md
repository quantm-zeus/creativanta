# Screen: Web — Campaign Manager

> **Screen ID**: W064
> **Module**: M14 — Monetization OS (Campaigns)
> **Route**: `/campaigns`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 06 §Commerce, Product Freeze §23, A1 Schema (campaigns, campaign_products, campaign_content, campaign_offers), B5 RBAC §2.7

---

## 1. Purpose & Context

Marketing campaign manager — the umbrella entity that groups products, offers, content, and affiliate links with unified performance tracking, ROI attribution, and budget control. Campaigns connect the content pipeline to commerce outcomes.

### User Goals
- Create and manage marketing campaigns with clear budget, timeline, and goals
- Track campaign ROI (Return on Ad Spend / Return on Investment)
- Monitor which content drives the most sales per campaign
- Pause/resume campaigns based on performance data

### Business Goals
- Enable structured marketing operations with budget accountability
- Track full-funnel attribution: content → clicks → orders → revenue → profit
- Compare campaign effectiveness across platforms

### Entry Points
- Sidebar: Commerce → "📊 Campaigns"
- Home Dashboard: campaign performance card
- Publish Composer: "Link to campaign" option
- Copilot: "Campaign nào hiệu quả nhất?" → navigate with sort

### Exit Points
- Click campaign card → Campaign Detail (W065)
- "+ Tạo campaign" → Campaign creation flow
- Click linked content → Content detail page

---

## 2. Preconditions / Postconditions

### Preconditions
- User has `campaign:manage` permission (Owner, Admin, Manager, Editor)
- At least one product or offer exists (campaigns need things to promote)

### Postconditions
- Campaign creation logged in audit trail
- Pausing a campaign deactivates all linked offers automatically
- ROAS and revenue metrics update every 5 minutes

---

## 3. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 📊 Campaigns (8)                    [+ Tạo campaign] [📤 Export]   │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Summary Bar ─────────────────────────────────────────────────┐   │
│ │ 🟢 3 running · ⏳ 2 scheduled · ⏸ 1 paused · ✅ 2 completed │   │
│ │ Total spend: 28M VND · Total revenue: 203M VND · Avg ROAS: 7.2x│  │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ Filter: [Status ▾] [Platform ▾] [Period ▾] Sort: [ROAS cao nhất ▾] │
│                                                                      │
│ ┌─ Campaign Card ────────────────────────────────────────────────┐  │
│ │ 📊 "Spring Sale 2026"                           [🟢 Running]  │  │
│ │ Period: 15/3 - 30/3 · Day 13 of 16                             │  │
│ │ Budget: 10M VND · Spent: 6.2M (62%) [████████░░░░]            │  │
│ │                                                                  │  │
│ │ 📦 Products: 5 · 🏷 Offers: 3 · 📤 Content: 12 posts         │  │
│ │ 🔗 Affiliate links: 8                                          │  │
│ │                                                                  │  │
│ │ Results (to date):                                               │  │
│ │ 👁 Views: 234K · 🛒 Orders: 234 · 💰 Revenue: 45M VND        │  │
│ │ 📈 ROAS: 7.2x · Conv rate: 3.2% · Profit: 18.5M              │  │
│ │ Source: [🟢 Official] [🟣 Inferred attribution]                │  │
│ │                                                                  │  │
│ │ [📊 Dashboard] [✏️ Edit] [⏸ Pause] [📋 Duplicate]            │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Campaign Card ────────────────────────────────────────────────┐  │
│ │ 📊 "Tết Sale 2026"                             [✅ Completed]  │  │
│ │ Period: 1/2 - 15/2 · Ended 40 days ago                         │  │
│ │ Budget: 15M VND · Spent: 14.8M (99%)                           │  │
│ │ Results: 🛒 456 orders · 💰 72M · 📈 ROAS: 4.9x             │  │
│ │ [📊 Report] [📋 Duplicate for next year]                      │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ Pagination: [← Trước] Page 1/2 [Tiếp →]                           │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
CampaignListPage
├── AppShell (shared)
├── PageHeader
│   ├── PageTitle ("📊 Campaigns" + count)
│   ├── CreateButton ("+ Tạo campaign", primary CTA)
│   └── ExportButton ("📤 Export")
├── SummaryBar
│   ├── StatusCounts (running, scheduled, paused, completed)
│   ├── TotalSpend
│   ├── TotalRevenue
│   └── AvgROAS
├── FilterBar
│   ├── StatusFilter (Running, Scheduled, Paused, Completed, All)
│   ├── PlatformFilter
│   ├── PeriodFilter
│   └── SortSelector (ROAS, Revenue, Recent, Budget)
├── CampaignList
│   └── CampaignCard[]
│       ├── CardHeader
│       │   ├── CampaignName
│       │   ├── StatusBadge (🟢 Running / ⏳ Scheduled / ⏸ Paused / ✅ Completed)
│       │   └── PeriodLabel
│       ├── BudgetBar
│       │   ├── BudgetAmount
│       │   ├── SpentAmount + Percentage
│       │   └── ProgressBar (color-coded: green < 80%, yellow 80-95%, red > 95%)
│       ├── LinkedEntities
│       │   ├── ProductCount
│       │   ├── OfferCount
│       │   ├── ContentCount
│       │   └── LinkCount
│       ├── ResultsGrid
│       │   ├── Views
│       │   ├── Orders
│       │   ├── Revenue (formatted VND)
│       │   ├── ROAS (multiplier badge)
│       │   ├── ConversionRate
│       │   ├── Profit
│       │   └── TrustBadges[] (S009 — source class per metric)
│       └── ActionBar
│           ├── DashboardButton ("📊 Dashboard" → detail)
│           ├── EditButton ("✏" — only for draft/scheduled/running)
│           ├── PauseResumeButton ("⏸"/"▶")
│           └── DuplicateButton ("📋")
├── Pagination
└── CreateCampaignModal (or separate page)
    ├── CampaignName (required)
    ├── PeriodPicker (start_date, end_date)
    ├── BudgetInput (optional)
    ├── GoalSelector (Awareness, Engagement, Conversion, Revenue)
    ├── PlatformSelector (multi-select)
    ├── ProductPicker (multi-select)
    ├── OfferPicker (multi-select)
    └── CreateButton
```

---

## 5. Displayed Data

| Field | Source | Format | Source Class |
|---|---|---|---|
| Campaign name | `campaigns.name` | String | — |
| Status | `campaigns.status` | Color badge | — |
| Period | `campaigns.start_date` + `end_date` | "15/3 – 30/3" + day count | — |
| Budget | `campaigns.budget_amount` | VND "10M" | Imported |
| Spent | `campaigns.spent_amount` (aggregated) | VND "6.2M" + % | Official (if ad API) / Imported |
| Products | `campaign_products` count | "5" | — |
| Offers | `campaign_offers` count | "3" | — |
| Content | `campaign_content` count | "12 posts" | — |
| Views | `content_performance` sum for campaign content | "234K" | Official |
| Orders | `orders` attributed to campaign | "234" | Official / Inferred |
| Revenue | `orders.total_amount` sum | VND "45M" | Official |
| ROAS | Computed: revenue / spent | "7.2x" | Computed |
| Conv rate | Computed: orders / clicks × 100 | "3.2%" | Computed |
| Profit | Revenue - costs - fees | VND "18.5M" | Computed |

---

## 6. User Actions

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Create campaign | "+ Tạo" → modal/page | `CampaignService/Create` | New campaign card appears | `campaign:manage` |
| 2 | View dashboard | "📊 Dashboard" | — | → `/campaigns/[id]` | `campaign:manage` |
| 3 | Edit | "✏ Edit" | — | Edit modal or → `/campaigns/[id]/edit` | `campaign:manage` |
| 4 | Pause | "⏸ Pause" → confirm | `CampaignService/Update(status=paused)` | Confirmation: "Tạm dừng sẽ vô hiệu hóa tất cả offer liên quan. Tiếp tục?" → offers deactivated | `campaign:manage` |
| 5 | Resume | "▶ Resume" | `CampaignService/Update(status=running)` | Offers reactivated, campaign resumes | `campaign:manage` |
| 6 | Duplicate | "📋 Duplicate" | `CampaignService/Duplicate` | New draft campaign pre-filled from source | `campaign:manage` |
| 7 | Export | "📤 Export" | Client-side CSV/PDF | Campaign performance report download | `report:export` |
| 8 | Filter/Sort | Filter/sort controls | Refetch | List updates | `campaign:manage` |

---

## 7. Validation Rules (Create/Edit)

| Field | Rule | Error |
|---|---|---|
| Name | Required, 3-200 chars | "Tên campaign phải từ 3-200 ký tự" |
| Start date | Required, today or future (for new) | "Ngày bắt đầu phải từ hôm nay" |
| End date | Required, after start date | "Ngày kết thúc phải sau ngày bắt đầu" |
| Budget | Optional, if set must be > 0 | "Ngân sách phải lớn hơn 0" |
| At least 1 platform | Required | "Chọn ít nhất 1 nền tảng" |

---

## 8. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial fetch | Summary shimmer + 3 card skeletons |
| LOADED | Data received | Campaign cards with full data |
| EMPTY | No campaigns | "Chưa có campaign nào. Tạo campaign đầu tiên để theo dõi hiệu quả marketing. [+ Tạo campaign]" |
| ERROR | API failed | Error banner with retry |
| BUDGET_WARNING | Campaign > 90% budget spent | Card shows red budget bar + "⚠️ Sắp hết ngân sách" |
| EXPIRED_PENDING | Campaign period ended but not marked completed | "⏰ Campaign đã hết hạn. [✅ Đánh dấu hoàn thành]" |

---

## 9. Permissions

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer |
|---|---|---|---|---|---|---|
| View campaigns | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| View revenue/ROAS | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Create campaign | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Pause/resume | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Delete campaign | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Export report | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |

---

## 10. Edge Cases

| Edge Case | Handling |
|---|---|
| Campaign with no linked content | Show "Chưa có nội dung. [+ Thêm content]" in card |
| All offers expired within campaign | Badge: "⚠️ Tất cả offer đã hết hạn" |
| ROAS = 0 (no revenue) | Show "—" instead of "0x" |
| Campaign spans > 90 days | Normal — show day progress counter |
| Platform connector disconnected during campaign | Warning badge: "⚫ TikTok không kết nối — dữ liệu có thể không đầy đủ" |

---
## 11. SvelteKit Implementation Notes

### Route & Server Load
- **Route**: `src/routes/(app)/campaigns/+page.svelte`
- **Server load**: `+page.server.ts` → fetch campaigns + summary stats
- **SSR**: Server renders first page of campaign cards for fast LCP
- **Real-time**: SSE on `/events/campaigns` for status changes and metric updates

### Data Fetching Strategy
```
+page.server.ts:
  Promise.all([
    campaignService.list({ status, sort, page, limit: 10 }),
    campaignService.getSummary()
  ])

Client-side:
  onFilterChange(params) → campaignService.list(params)
  onPause(id) → campaignService.update(id, { status: 'paused' })
  onDuplicate(id) → campaignService.duplicate(id)
```

### ROAS Calculation
- `ROAS = revenue_attributed / spent_amount`
- Revenue attribution uses UTM tracking + platform order API
- ROAS updates every 5 minutes via ClickHouse aggregation job
- Spent amount: from platform ad API (Official) or manual entry (Imported)

---
## 12. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `campaigns.list.viewed` | Page load | `total_count`, `running_count`, `avg_roas` |
| `campaigns.created` | New campaign created | `campaign_id`, `goal`, `budget`, `platforms` |
| `campaigns.paused` | Campaign paused | `campaign_id`, `days_running`, `current_roas` |
| `campaigns.resumed` | Campaign resumed | `campaign_id`, `days_paused` |
| `campaigns.duplicated` | Campaign duplicated | `source_campaign_id`, `new_campaign_id` |
| `campaigns.filtered` | Filter/sort applied | `filter_type`, `filter_value` |
| `campaigns.exported` | Export report | `format`, `count` |
| `campaigns.detail_viewed` | Click campaign card | `campaign_id`, `status` |

---
## 13. Performance Requirements

| Metric | Target |
|---|---|
| LCP | < 1.5s (first campaign card) |
| TTI | < 2.0s |
| Summary bar render | < 200ms |
| Filter change | < 500ms |
| ROAS calculation | Server-side, < 300ms per campaign |
| Export generation | < 5s for < 100 campaigns |

---
## 14. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến — hiển thị dữ liệu cached" + stale campaigns visible | Auto-retry when online |
| API error (5xx) | Server failure | Error banner: "Không tải được danh sách campaign. [Thử lại]" | Retry button |
| Pause failed | Linked offers cannot be deactivated | Toast: "Không tạm dừng được. {count} offer đang hoạt động. [Xem chi tiết]" | View offers first |
| Create failed | Validation error | Modal shows inline field errors | Fix and retry |
| ROAS data stale | ClickHouse lag > 30min | Badge on ROAS: "⏰ Cập nhật 45 phút trước" | Auto-refresh |
| Export failed | Large dataset timeout | Toast: "Xuất dữ liệu thất bại. Thử thu hẹp bộ lọc." | Apply filters + retry |

---
## 15. Accessibility

| Element | Requirement |
|---|---|
| Campaign cards | `role="article"`, `aria-label="Campaign {name}, trạng thái {status}, ROAS {value}"` |
| Budget progress bar | `role="progressbar"`, `aria-valuenow`, `aria-valuemax`, `aria-label="Ngân sách đã dùng {percent}%"` |
| Status badges | Color + icon + text (never color-only) |
| Filter dropdowns | `aria-expanded`, `aria-haspopup="listbox"` |
| Summary bar | `aria-label="Tổng quan: {running} đang chạy, ROAS trung bình {value}"` |
| Pagination | `aria-label="Trang {current} trên {total}"` |

---
## 16. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | App Shell + summary bar shimmer + card skeletons |
| Summary stats | 200-300ms | Counters animate in with number transition |
| Campaign cards | 300-500ms | Cards populate with staggered fade-in |
| ROAS badges | 400-600ms | Revenue/ROAS numbers animate up |
| Filter change | < 500ms | Cards crossfade to new results |

---
## 17. Localization Notes

- Primary language: Vietnamese
- Currency: VND (no decimals, dot separator: "28.000.000đ")
- Compact format: "28M VND", "203M VND" in summary
- ROAS: "7.2x" (multiplier format)
- Conversion rate: "3.2%"
- Date range: "15/3 – 30/3"
- Day counter: "Ngày 13 trên 16"
- Budget: "10M VND · Đã dùng: 6.2M (62%)"
- Status: "Đang chạy", "Đã lên lịch", "Tạm dừng", "Hoàn thành"

---
## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-campaign-running` | Running status badge (🟢 green) |
| `--color-campaign-scheduled` | Scheduled status badge (⏳ blue) |
| `--color-campaign-paused` | Paused status badge (⏸ gray) |
| `--color-campaign-completed` | Completed status badge (✅ teal) |
| `--color-budget-safe` | Budget < 80% used (green progress) |
| `--color-budget-warning` | Budget 80-95% used (yellow progress) |
| `--color-budget-danger` | Budget > 95% used (red progress) |
| `--color-roas-high` | ROAS > 5x (green badge) |
| `--color-roas-medium` | ROAS 2-5x (amber badge) |
| `--color-roas-low` | ROAS < 2x (red badge) |
| `--color-accent` | Primary CTAs |
| `--color-surface-elevated` | Campaign cards |

---
## 19. Related Screens

| Screen | Relationship |
|---|---|
| [W065] Campaign Detail | Full campaign analytics dashboard |
| [W066] Offer List | Offers linked to campaigns |
| [W060] Product List | Products in campaign |
| [W069] Affiliate Links | Links attributed to campaign |
| [M031] Mobile Campaigns | Mobile equivalent |
| [S009] Trust Badge | Source/confidence display |

---
## 20. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A standardization**: Fixed section numbering (1-20 sequential). Removed duplicate §5 and generic boilerplate. Added SvelteKit Implementation Notes (ROAS calculation logic), 8 Analytics Events, Performance Requirements, screen-specific Error Handling (6 scenarios), Accessibility with progress bar ARIA, Loading Behavior (5 stages), Localization with campaign-specific formats, Design Tokens with budget-threshold and ROAS-tier colors. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
