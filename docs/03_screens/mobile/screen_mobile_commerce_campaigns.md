# Screen: Mobile — Commerce Campaigns

> **Screen ID**: M031
> **Module**: M14 — Monetization & Campaigns
> **Route**: `/commerce/campaigns` (mobile)
> **Platform**: Mobile (Flutter)
> **Upstream**: Pack 06 §8, A1 Schema (campaigns, campaign_content, campaign_costs, orders, utm_events), B5 RBAC §2.7

---

## 1. Purpose & Context

Mobile campaign monitoring — at-a-glance campaign status, budget usage, ROAS metrics, and quick pause/resume. Designed for on-the-go performance monitoring with push alerts for budget milestones. Full campaign creation and content linking defers to web (W064/W065).

### User Goals
- Monitor active campaign performance (ROAS, budget usage, orders)
- Quickly pause campaigns if budget overspending
- Respond to push alerts ("Budget 80% spent", "Campaign ending")
- Check daily revenue and conversion metrics

### Business Goals
- Enable real-time budget control during active campaigns
- Reduce wasted ad spend through timely intervention
- Support mobile-first campaign monitoring

### When This Screen Is Used
- During campaigns: Daily performance check
- Budget alerts: Responding to push notifications
- Quick action: Pausing/resuming campaign from phone

### Entry Points
- Commerce tab → "📢 Campaigns"
- Push: "📢 Campaign 'Summer Sale' budget 80% spent"
- Push: "📢 Campaign ending tomorrow"
- Home (M001): Campaign widget tap

### Exit Points
- Tap campaign → Campaign Detail (M032-detail, mobile read-only)
- "+ Tạo" → redirect to web
- Back → Commerce hub

---

## 2. Preconditions / Postconditions

### Preconditions
- User authenticated, `campaign:manage` permission

### Postconditions
- Status changes persisted, analytics dispatched

---

## 3. Screen Layout

### Mobile Layout (Flutter)
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Campaigns (8)                                  [+ Tạo trên web]  │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Summary Bar ──────────────────────────────────────────────────┐  │
│ │ 🟢 Active: 2 · Total budget: 3.2M/5M (64%) · ROAS avg: 4.5× │  │
│ └──────────────────────────────────────────────────────────────────┘  │
│ Chips: [Tất cả] [🟢 Active (2)] [⏸ Paused (1)] [⏹ Ended (5)]    │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ Campaign Card ─────────────────────────────────────────────────┐ │
│ │ 📢 "Summer Sale Push"                         [🟢 Active]      │ │
│ │ TikTok Ads · 25/03 — 31/03 · Ngày 5/7                         │ │
│ │                                                                  │ │
│ │ ┌──────────────┐ ┌──────────────┐ ┌──────────────┐             │ │
│ │ │ Budget       │ │ ROAS         │ │ Orders       │             │ │
│ │ │ 2M/3M (67%) │ │ 5.2×         │ │ 45           │             │ │
│ │ │ ████████░░░░ │ │ 🟢 Great    │ │ ↑+12 today   │             │ │
│ │ └──────────────┘ └──────────────┘ └──────────────┘             │ │
│ │                                                                  │ │
│ │ Revenue: +15.6M · Impressions: 125K · Clicks: 4.5K            │ │
│ │                                                                  │ │
│ │ [⏸ Tạm dừng]  [📊 Chi tiết]                                   │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ┌─ Campaign Card ─────────────────────────────────────────────────┐ │
│ │ 📢 "Product Launch"                            [⏹ Ended]      │ │
│ │ Multi-platform · 15/03 — 22/03 · Completed                    │ │
│ │ Budget: 5M/5M (100%) · ROAS: 3.8× · Revenue: +19M            │ │
│ │ [📊 Xem kết quả] [🔄 Nhân bản]                                │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ Pull-to-refresh · Infinite scroll                                    │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠 Home] [💡 Ideas] [🎬 Studio] [💬 Inbox] [📊 Insights]        │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
CommerceCampaignsScreen (ConsumerStatefulWidget)
├── AppBar
│   ├── BackButton
│   ├── Title ("Campaigns" + count)
│   └── CreateButton ("+ Tạo trên web" → web redirect)
├── SummaryBar
│   ├── ActiveCount
│   ├── TotalBudgetProgress ("3.2M/5M (64%)")
│   └── AvgROAS ("4.5×")
├── StatusChipBar
│   ├── FilterChip("Tất cả")
│   ├── FilterChip("🟢 Active" + count)
│   ├── FilterChip("⏸ Paused" + count)
│   └── FilterChip("⏹ Ended" + count)
├── CampaignList (SliverList)
│   └── CampaignCard[] (repeating)
│       ├── CampaignHeader
│       │   ├── CampaignIcon ("📢")
│       │   ├── CampaignName
│       │   ├── StatusBadge
│       │   └── PlatformLabel
│       ├── DateInfo ("25/03 — 31/03 · Ngày 5/7")
│       ├── MetricCards (3 inline)
│       │   ├── BudgetCard (amount + progress bar)
│       │   ├── ROASCard (value + quality indicator 🟢/🟡/🔴)
│       │   └── OrdersCard (count + daily change)
│       ├── DetailMetrics
│       │   ├── Revenue (VND compact)
│       │   ├── Impressions
│       │   └── Clicks
│       └── ActionRow
│           ├── PauseButton / ResumeButton (active/paused)
│           ├── DetailButton ("📊 Chi tiết")
│           ├── ResultsButton ("📊 Xem kết quả" — ended)
│           └── DuplicateButton ("🔄 Nhân bản" — ended)
├── EmptyState
├── PullToRefresh
└── BottomNavBar (shared)
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Campaign list | `campaigns` + metrics | `CampaignService/List(workspace_id, status)` | Cards | 5m, Hive |
| Summary | Aggregation across active | Included in list header | Compact | 5m |
| Budget | `SUM(campaign_costs) / campaigns.budget` | Aggregated | "2M/3M (67%)" with progress | 5m |
| ROAS | `revenue / costs` | Computed | Decimal + "×" | 5m |
| Orders | `COUNT(orders WHERE utm_campaign)` | Aggregated | Integer + daily delta | 5m |
| Date info | `starts_at`, `ends_at` | — | "dd/MM — dd/MM · Ngày N/M" | — |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | Pause | Tap "⏸" → confirm | `CampaignService/Pause(id)` | `status='paused'` | Confirm → badge → ⏸. Haptic + snackbar. | `campaign:manage` |
| 2 | Resume | Tap "▶" | `CampaignService/Resume(id)` | `status='running'` | Badge → 🟢. | `campaign:manage` |
| 3 | View detail | Tap "📊" or card | — | — | Navigate → Campaign Detail (mobile) | `campaign:manage` |
| 4 | Duplicate | Tap "🔄 Nhân bản" | `CampaignService/Duplicate(id)` | New draft | Snackbar + web redirect | `campaign:manage` |
| 5 | Filter | Tap chip | Client-side | — | List filters | `campaign:manage` |
| 6 | Refresh | Pull down | Refetch | Cache invalidated | Updated | `campaign:manage` |

---

## 7. Validation Rules

- Pause confirm: "Tạm dừng campaign? Quảng cáo sẽ ngừng chạy."

---

## 8. States

| State | Condition | Visual | User Action |
|---|---|---|---|
| LOADING | Initial | Summary shimmer + card shimmers | Wait |
| LOADED | Data available | Summary + cards | Interact |
| EMPTY | No campaigns | "Chưa có campaign. [Tạo trên web →]" | Web redirect |
| BUDGET_HIGH | Budget > 80% spent | Orange budget bar + "⚠️ Budget gần hết" | Pause or increase (web) |
| LOW_ROAS | ROAS < 1.0× | 🔴 indicator + "ROAS thấp" warning | Review or pause |
| PAUSING | Pause in progress | Button spinner | Wait |
| OFFLINE | No network | Banner + cached | Refresh when online |
| ERROR | API failed | Retry | Retry |

---

## 9. Permission Matrix

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer |
|---|---|---|---|---|---|---|
| View campaigns | ✅ | ✅ | ✅ | ✅ | ✅ (no budget) | ❌ |
| View ROAS/budget | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Pause/resume | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Duplicate | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |

---

## 10-11. Navigation & Error Handling

### Navigation
```
Mobile Campaigns (/commerce/campaigns)
├── → /commerce/campaigns/[id]     (Detail)
├── → web://campaigns/new          (Create on web)
├── ← /commerce                    (Back)
```

### Errors
| Error | UI | Recovery |
|---|---|---|
| Offline | Banner + cached | Pull-to-refresh |
| API 5xx | Snackbar + retry | Retry |
| Pause failed | Snackbar + revert | Retry |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Campaign cards | `Semantics(label: "Summer Sale Push, đang hoạt động, budget 67 phần trăm, ROAS 5.2 lần")` |
| Budget progress | `Semantics(label: "Budget: 2 triệu trên 3 triệu, 67 phần trăm")` |
| ROAS indicator | Color + text + icon (🟢/🟡/🔴 + "Great"/"OK"/"Low") |
| Tap targets | 48×48dp minimum |

---

## 13-14. Loading & Performance

| Stage | Duration | Visual |
|---|---|---|
| Mount | 0ms | Shimmer |
| Data | 200-500ms | Cards stagger in |
| Action | 300-1000ms | Button spinner |

| Metric | Target |
|---|---|
| First paint | < 800ms |
| Scroll | 60fps |
| Offline load | < 200ms |

---

## 15-16. Updates & Localization

| Data | Method | Frequency |
|---|---|---|
| Metrics | Background sync | Every 5 minutes |
| Budget alerts | Push notification | At 50%, 80%, 100% |
| Campaign ended | Push notification | On end |

- Vietnamese: "📢 Campaigns", "Tạm dừng", "Tiếp tục"
- ROAS: Decimal + "×" ("5.2×")
- Budget: VND compact ("2M/3M")
- Date range: "dd/MM — dd/MM"

---

## 17-18. Analytics & Tokens

| Event | Trigger | Properties |
|---|---|---|
| `campaign.mobile.viewed` | Screen visible | `active_count`, `avg_roas` |
| `campaign.mobile.paused` | Pause | `campaign_id`, `budget_at_pause` |
| `campaign.mobile.resumed` | Resume | `campaign_id` |
| `campaign.mobile.detail_viewed` | Detail tap | `campaign_id` |

| Token (Flutter) | Usage |
|---|---|
| `AppColors.success` | 🟢 Active, ROAS > 3× |
| `AppColors.warning` | 🟡 ROAS 1-3×, budget high |
| `AppColors.danger` | 🔴 ROAS < 1×, over budget |

---

## 19. Technical Implementation Notes

### Flutter Specifics
- **Widget**: `CommerceCampaignsScreen extends ConsumerStatefulWidget`
- **State**: Riverpod `campaignListProvider`
- **ROAS indicators**: `> 3× = 🟢 Great`, `1-3× = 🟡 OK`, `< 1× = 🔴 Low`
- **Budget progress**: Custom `LinearProgressIndicator` with color gradient
- **Offline**: Campaign list + metrics cached in Hive
- **Push**: Deep link with campaign filter applied

---

## 20. Related Screens & Revision History

### Related Screens
| Screen | Relationship |
|---|---|
| [W064] Web Campaign List | Web equivalent (full CRUD) |
| [W065] Web Campaign Detail | Full analytics on web |
| [M029] Mobile Offers | Offers linked to campaigns |

### Revision History
| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A upgrade**: Full 20-point rewrite. Added: real APIs (CampaignService), Flutter widget tree, budget progress visualization, ROAS quality indicators, push notification deep links, 6 actions, 8 states, inline metric cards, and offline caching. | System |
| 2026-03-28 | 1.0 | Initial specification (Tier C) | System |
