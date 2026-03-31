# Screen: Web — Seeding Campaign Dashboard

> **Screen ID**: W098
> **Module**: M18 — Seeding / Sample CRM
> **Route**: `/seeding/campaigns`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 08 §Seeding, PRD §23.18, A1 Schema (seeding_campaigns, seeding_assignments, sample_shipments), B5 RBAC §2.7

---

## 1. Purpose & Context

Campaign-level view of seeding effectiveness — products seeded to creators, content output tracking, reach measurement, and ROI calculation. Seeding campaigns are the systematic outreach programs where brands send free products to KOLs/creators in exchange for content creation.

### User Goals
- Create and manage seeding campaigns with clear goals and timelines
- Track which creators received products and produced content
- Measure real ROI: (attributed revenue) / (sample costs + shipping)
- View a gallery of all content produced from a seeding campaign

### Business Goals
- Structured seeding operations with clear budget accountability
- Track conversion: seeded products → content published → revenue generated
- Compare seeding ROI across campaigns to optimize budget allocation
- Build creator relationships through organized sample management

### Entry Points
- Sidebar: "🌱 Seeding" (Seeding module)
- Home Dashboard: seeding performance card
- Copilot: "ROI seeding campaign tháng này"

### Exit Points
- Click campaign → Campaign Detail dashboard
- "+ Tạo campaign mới" → Campaign creation flow
- "🎥 Content gallery" → Gallery view of seeded content

---

## 2. Preconditions / Postconditions

### Preconditions
- User has `seeding:manage` permission (Owner, Admin, Manager)
- At least one product exists (seeding needs products to send)

### Postconditions
- Launched campaigns activate creator assignment workflow
- Content produced by seeded creators is attributed to campaign for ROI tracking

---

## 3. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 🌱 Seeding Campaigns                        [+ Tạo campaign mới]   │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Summary Bar ─────────────────────────────────────────────────┐   │
│ │ 🟢 2 running · 📋 1 draft · ✅ 3 completed                  │   │
│ │ Total seeded: 45 creators · Total cost: 12M VND               │   │
│ │ Attributed revenue: 85M VND · Avg ROI: 7.1x                  │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ Filter: [Status ▾] [Period ▾] Sort: [ROI cao nhất ▾]               │
│                                                                      │
│ ┌─ Campaign Card ────────────────────────────────────────────────┐  │
│ │ 🌱 "Spring Skincare Seeding"                 [🟢 Running]     │  │
│ │ Period: 1/3 - 30/3 · Day 28 of 30                             │  │
│ │                                                                  │  │
│ │ Pipeline:                                                        │  │
│ │ 📦 3 products seeded                                            │  │
│ │ 👥 8 creators assigned · 7 accepted · 6 shipped · 5 published  │  │
│ │ [████████████████████████████████████████████████████░░░]       │  │
│ │                                                                  │  │
│ │ Results:                                                         │  │
│ │ 🎬 5 videos published · 📊 Total reach: 234K views             │  │
│ │ 💰 Cost: 2.4M (samples + shipping)                             │  │
│ │ 💵 Revenue attributed: 18.5M VND · ROI: 7.7x                  │  │
│ │                                                                  │  │
│ │ [📊 Dashboard] [🎥 Content gallery] [👥 Creators] [✏️ Edit]  │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Campaign Card ────────────────────────────────────────────────┐  │
│ │ 🌱 "Summer Food Festival"                    [📋 Draft]       │  │
│ │ Products: 5 planned · Creators: 0 assigned                     │  │
│ │ Budget: 5M VND estimated                                        │  │
│ │ [✏️ Chỉnh sửa] [🚀 Launch campaign]                          │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Campaign Card (completed) ────────────────────────────────────┐  │
│ │ 🌱 "Tết Gift Box"                           [✅ Completed]    │  │
│ │ Period: 15/1 - 28/2 · Ended 28 days ago                        │  │
│ │ 👥 12 creators · 🎬 10 published · 💰 ROI: 5.2x              │  │
│ │ [📊 Final Report] [📋 Duplicate for next campaign]            │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ Pagination: [← Trước] Page 1/1 [Tiếp →]                           │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
SeedingCampaignsPage
├── AppShell (shared)
├── PageHeader
│   ├── PageTitle ("🌱 Seeding Campaigns")
│   └── CreateCampaignButton ("+ Tạo campaign mới", primary CTA)
├── SummaryBar
│   ├── StatusCounts (running, draft, completed)
│   ├── TotalSeededCreators
│   ├── TotalCost
│   ├── TotalAttributedRevenue
│   └── AvgROI
├── FilterBar
│   ├── StatusFilter (Running, Draft, Completed, All)
│   ├── PeriodFilter
│   └── SortSelector (ROI, Recent, Cost, Revenue)
├── CampaignList
│   └── CampaignCard[]
│       ├── CampaignTitle
│       ├── StatusBadge
│       ├── PeriodLabel + DayProgress
│       ├── PipelineProgress
│       │   ├── ProductsSeeded (count)
│       │   ├── CreatorsAssigned / Accepted / Shipped / Published
│       │   └── ProgressBar (multi-stage)
│       ├── ResultsSection
│       │   ├── ContentPublished (count)
│       │   ├── TotalReach (views)
│       │   ├── Cost (samples + shipping)
│       │   ├── Revenue (attributed)
│       │   └── ROI (multiplier badge)
│       └── ActionBar
│           ├── DashboardButton ("📊 Dashboard")
│           ├── ContentGalleryButton ("🎥 Content gallery")
│           ├── CreatorsButton ("👥 Creators")
│           ├── EditButton ("✏️ Edit")
│           ├── LaunchButton ("🚀 Launch" — for drafts)
│           ├── DuplicateButton ("📋 Duplicate" — for completed)
│           └── FinalReportButton ("📊 Final Report" — for completed)
├── Pagination
└── CreateCampaignModal
    ├── CampaignNameInput (required)
    ├── PeriodPicker (start, end)
    ├── ProductPicker (multi-select from products)
    ├── BudgetInput (estimated total)
    ├── GoalInput (target creator count, target content count)
    └── CreateButton
```

---

## 5. Seeding Pipeline Stages

| Stage | Status | Description |
|---|---|---|
| 📦 Seeded | Product selected | Product added to campaign |
| 👥 Assigned | Creator selected | Creator invited/assigned to campaign |
| ✅ Accepted | Creator confirms | Creator agrees to participate |
| 📬 Shipped | Sample sent | Physical product shipped to creator |
| 📥 Received | Creator confirms receipt | Creator acknowledges receiving sample |
| 🎬 Published | Content live | Creator published content about product |
| 📊 Measured | Performance tracked | Content performance data collected |

---

## 6. User Actions

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Create campaign | "+ Tạo" → modal | `SeedingService/CreateCampaign` | New draft campaign | `seeding:manage` |
| 2 | View dashboard | "📊 Dashboard" | — | → `/seeding/campaigns/[id]` | `seeding:manage` |
| 3 | Launch | "🚀 Launch" → confirm | `SeedingService/Launch(id)` | Status → Running, assignments activated | `seeding:manage` |
| 4 | View content | "🎥 Content gallery" | — | Gallery of all content from seeded creators | `seeding:manage` |
| 5 | View creators | "👥 Creators" | — | → Creator assignment view | `seeding:manage` |
| 6 | Duplicate | "📋 Duplicate" | `SeedingService/Duplicate(id)` | New draft pre-filled from source | `seeding:manage` |
| 7 | Edit | "✏️" | — | → Edit modal/page | `seeding:manage` |
| 8 | Final report | "📊 Final Report" | — | → Report export (PDF) | `seeding:manage` |

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial fetch | Card skeletons |
| LOADED | Data received | Campaign cards |
| EMPTY | No seeding campaigns | "Chưa có seeding campaign. Gửi sản phẩm mẫu cho KOL/creator để tạo content chất lượng! [+ Tạo campaign đầu tiên]" |
| ALL_PUBLISHED | All seeded creators published | Green celebration on campaign card |
| OVERDUE | Creators haven't published past deadline | Orange warning: "⚠️ 3 creators chưa publish content" |
| ERROR | API failed | Error with retry |

---

## 8. Permissions

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer |
|---|---|---|---|---|---|---|
| View campaigns | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Create campaign | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Launch campaign | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| View ROI/costs | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Export report | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |

---

## 9. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached campaigns | Retry online |
| Create fail | API error | Toast: "Không tạo được campaign. [Thử lại]" | Retry |
| Launch fail | No products/creators assigned | Alert: "Chưa có sản phẩm hoặc creator. Cần ít nhất 1 sản phẩm và 1 creator." | Add items |
| Duplicate fail | API error | Toast: "Không duplicate được. [Thử lại]" | Retry |
| ROI calc fail | Revenue attribution error | Inline: "⚠️ Doanh thu chưa cập nhật" | Auto-retry |

---

## 10. Accessibility

| Element | Requirement |
|---|---|
| Campaign cards | `role="article"`, `aria-label="{title}, {status}, ROI: {roi}x"` |
| Pipeline progress | `role="progressbar"`, `aria-valuenow`, `aria-label="{published}/{total} creators published"` |
| Summary bar | `role="status"`, `aria-label="Total: {count} campaigns, avg ROI: {roi}x"` |
| Status badge | Color + text + icon (Running/Draft/Completed) |
| ROI multiplier | `aria-label="Return on investment: {roi} times"` |

---

## 11. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Summary bar shimmer + card skeletons |
| Summary stats | 100-300ms | Aggregate counts populate |
| Campaign cards | 300-600ms | Cards stagger in |
| ROI calculations | 500-1000ms | Revenue + ROI fill in |

---

## 12. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `seeding.campaigns_viewed` | Page load | `running`, `draft`, `completed`, `avg_roi` |
| `seeding.campaign_created` | "+ Tạo" confirmed | `name`, `product_count`, `budget` |
| `seeding.campaign_launched` | "🚀 Launch" confirmed | `campaign_id`, `creator_count` |
| `seeding.campaign_duplicated` | "📋 Duplicate" | `source_id` |
| `seeding.dashboard_opened` | "📊 Dashboard" | `campaign_id` |
| `seeding.gallery_opened` | "🎥 Content gallery" | `campaign_id` |
| `seeding.report_exported` | "📊 Final Report" | `campaign_id`, `format` |
| `seeding.filter_applied` | Filter changed | `filter_type`, `value` |

---

## 13. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/seeding/+page.svelte`
- **Server load**: `+page.server.ts` → `SeedingService/ListCampaigns(workspace_id)` + `GetSeedingStats`
- **ROI calculation**: Server-side: `attributed_revenue / (sample_cost + shipping_cost)` per campaign
- **Pipeline progress**: Multi-stage progress bar from assignment statuses
- **Content gallery**: Lazy-loaded modal with content produced by seeded creators
- **Launch**: Validates ≥1 product + ≥1 creator before transitioning to "Running"
- **Duplicate**: `SeedingService/DuplicateCampaign(id)` → pre-fills products but clears creators

---

## 14. Localization Notes

- Status: "🟢 Đang chạy", "📋 Nháp", "✅ Hoàn thành"
- Metrics: "Tổng chi phí", "Doanh thu quy thuộc", "ROI trung bình"
- Pipeline: "đã gán", "đã chấp nhận", "đã gửi", "đã publish"
- Tone: Strategic, ROI-focused

---

## 15. Design Tokens

| Token | Usage |
|---|---|
| `--color-seeding-running` | 🟢 Running status |
| `--color-seeding-draft` | 📋 Draft status |
| `--color-seeding-completed` | ✅ Completed status |
| `--color-roi-positive` | ROI > 1x (green) |
| `--color-roi-negative` | ROI < 1x (red) |
| `--color-accent` | Create CTA, launch |
| `--color-surface-elevated` | Campaign cards |
| `--font-metric` | ROI, revenue (tabular-nums) |

---

## 16. Related Screens

| Screen | Relationship |
|---|---|
| [W099] Sample Requests | Individual sample request management |
| [W100] Creator Assignments | Creator assignment flow |
| [W060] Product List | Products selected for seeding |
| [M056] Mobile Seeding | Mobile equivalent |

---

## 17. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 errors (launch fail, ROI calc), card/pipeline a11y, 8 analytics, SvelteKit impl (ROI, gallery, duplicate), localization, 8 design tokens (seeding+ROI). | System |
| 2026-03-28 | 1.0 | Initial specification | System |
