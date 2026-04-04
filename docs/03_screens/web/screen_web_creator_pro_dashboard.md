# Screen: Web — Creator Pro Dashboard

> **Screen ID**: W088
> **Module**: S16 — Creator Pro Tools
> **Route**: `/creator-pro`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 05, S16 Creator Pro Spec, A1 Schema (creator_profiles, sponsor_inquiries, creator_deliverables), B5 RBAC §2.7

---

## 1. Purpose & Context

Creator-specific command center — engagement KPIs with cross-platform aggregation, active brand partnerships with deliverable tracking, real-time sponsor inquiry alerts, and quick access to Media Kit and Rate Card tools.

### User Goals
- Monitor overall creator performance (engagement, reach, growth)
- Track active partnerships and upcoming deliverables
- Respond to sponsor inquiries quickly (SLA tracking)
- Access Media Kit and Rate Card tools

### Business Goals
- Centralize creator-business management in one view
- Surface high-value sponsor inquiries before SLA expires
- Track sponsorship revenue as a distinct revenue stream
- Enable data-driven partnership decisions

### Entry Points
- Sidebar: "🌟 Creator Pro"
- Home Dashboard: "Creator Pro" card (if creator tier active)
- Notification: "New sponsor inquiry from Brand ABC"

### Exit Points
- Tab "Media Kit" → Media Kit Editor (W089)
- Tab "Partnerships" → Partnership detail
- Tab "Inquiries" → Sponsor Inquiries (W090)
- Deliverable "✏️ Start" → Content creation linked to deal
- KPI "📊" → Analytics Dashboard (W074)

---

## 2. Preconditions / Postconditions

### Preconditions
- Creator Pro subscription active (Starter / Pro / Business tier)
- At least one social platform connected

### Postconditions
- No data mutations (dashboard view only)

---

## 3. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 🌟 Creator Pro                                                      │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ KPI Row ─────────────────────────────────────────────────────┐   │
│ │ 📊 Avg Eng  │ 👥 Total Reach │ 💰 Sponsor Rev │ ⭐ Rating   │   │
│ │ 6.2%        │ 1.2M (30d)     │ 8.5M VND       │ 4.8/5      │   │
│ │ ↑0.5%       │ ↑18%           │ ↑35%            │ (12 reviews)│  │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ Tabs: [🏠 Overview] [📋 Media Kit] [🤝 Partnerships] [📩 Inquiries (3🔴)]│
│                                                                      │
│ ── 🏠 Overview Tab ──                                                │
│                                                                      │
│ ┌─ Platform Performance (30d) ──────────────────────────────────┐   │
│ │ 🎵 TikTok: 50K followers · 6.2% eng · RPM: 21.5K · ↑2.1K   │   │
│ │ 📸 Instagram: 25K followers · 4.1% eng · RPM: 15.2K · ↑800  │   │
│ │ ▶️ YouTube: 12K subs · 5.8% eng · RPM: 12.8K · ↑1.2K       │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Active Partnerships ─────────────────────────────────────────┐   │
│ │ 🤝 Brand ABC · "Summer Launch Campaign"   [🟢 Active]        │   │
│ │   3/5 deliverables done · Due: 30/3 · Value: 5M VND          │   │
│ │   [📋 View deliverables] [💬 Message brand]                   │   │
│ │ 🤝 Brand XYZ · Sponsorship package        [🟡 Negotiating]   │   │
│ │   Offer: 5M VND for 3 videos · Counter sent: 6.5M             │   │
│ │   [📋 View deal] [✅ Accept] [↩️ Counter]                     │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Upcoming Deliverables ───────────────────────────────────────┐   │
│ │ ☐ Brand ABC — Video review (due 28/3 · 2d left)  [✏️ Start] │   │
│ │ ☐ Brand ABC — Story mention (due 30/3)            [✏️ Start] │   │
│ │ ✅ Brand ABC — Reel (completed 25/3)    [📊 Stats] [📤 Send] │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Inquiry Alerts ──────────────────────────────────────────────┐   │
│ │ 🔴 3 new inquiries · Oldest: 2d ago (SLA: 3d)                │   │
│ │ 📩 Beauty Brand Co · Budget: 3-5M · "Looking for skincare..."│   │
│ │ [→ View all inquiries]                                         │   │
│ └────────────────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
CreatorProDashboardPage
├── AppShell (shared)
├── PageHeader
│   └── PageTitle ("🌟 Creator Pro")
├── KPIRow
│   ├── AvgEngagement (cross-platform average + trend)
│   ├── TotalReach (30d aggregate + trend)
│   ├── SponsorRevenue (total from partnerships + trend)
│   └── Rating (brand satisfaction score + review count)
├── CreatorProTabs
│   ├── OverviewTab
│   │   ├── PlatformPerformanceCard
│   │   │   └── PlatformRow[] (followers, engagement, RPM, growth)
│   │   ├── ActivePartnershipsSection
│   │   │   └── PartnershipCard[]
│   │   │       ├── BrandName + CampaignName + StatusBadge
│   │   │       ├── DeliverableProgress (N/total)
│   │   │       ├── DueDate + Value
│   │   │       └── ActionBar (View, Message, Accept, Counter)
│   │   ├── UpcomingDeliverablesSection
│   │   │   └── DeliverableItem[]
│   │   │       ├── BrandName + DeliverableType
│   │   │       ├── DueDate + DaysRemaining
│   │   │       ├── StatusCheckbox
│   │   │       └── ActionButton (Start / Stats / Send)
│   │   └── InquiryAlertCard
│   │       ├── NewInquiryCount + SLAWarning
│   │       ├── LatestInquiryPreview
│   │       └── ViewAllLink
│   ├── MediaKitTab → (renders W089 content inline or navigates)
│   ├── PartnershipsTab → Partnership list with filter/search
│   └── InquiriesTab → (renders W090 content inline)
```

---

## 5. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial fetch | KPI shimmer + card skeletons |
| LOADED | Data received | Full dashboard with KPIs and cards |
| NEW_CREATOR | No partnerships yet | "Chào mừng Creator Pro! Hoàn thiện Media Kit để nhận inquiry từ brands. [→ Tạo Media Kit]" |
| SLA_WARNING | Oldest inquiry approaching SLA | Pulsing red badge on Inquiries tab |
| DELIVERABLE_OVERDUE | Deliverable past due date | Red highlight on deliverable: "⚠️ Quá hạn {days} ngày" |
| NO_PLATFORMS | No social platform connected | "Kết nối ít nhất 1 nền tảng để xem metrics. [→ Kết nối]" |
| ERROR | API failed | Error with retry |

---

## 6. Tier Gating

| Feature | Free | Starter | Pro | Business |
|---|---|---|---|---|
| KPI overview | ❌ | ✅ (basic) | ✅ (full) | ✅ (full) |
| Partnerships | ❌ | ✅ (3 max) | ✅ (unlimited) | ✅ (unlimited) |
| Inquiries | ❌ | ❌ | ✅ | ✅ |
| Media Kit | ❌ | ✅ (basic) | ✅ (full) | ✅ (full + custom domain) |
| Rate Card | ❌ | View only | ✅ | ✅ |

---

## 7. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached dashboard data | Retry online |
| Platform sync fail | Platform API error | KPI shows stale data: "⚠️ {platform} chưa đồng bộ (6h trước)" | Manual refresh |
| SLA alert fail | Notification system error | Badge still shows count, toast suppressed | N/A |
| Deliverable load fail | API error | Section: "Không tải được deliverables. [Thử lại]" | Retry |
| Creator Pro not active | Subscription downgraded | Full-page upsell: "Creator Pro không khả dụng. [→ Nâng cấp]" | Navigate |

---

## 8. Accessibility

| Element | Requirement |
|---|---|
| KPI row | `role="status"`, each KPI `aria-label="{metric}: {value}, {trend}"` |
| Tabs | `role="tablist"`, `aria-selected`, inquiry tab has `aria-label="Inquiries, 3 new"` |
| Partnership cards | `role="article"`, `aria-label="{brand} — {status}"` |
| Deliverable list | `role="list"`, items with `aria-label="{task}: due {date}"` |
| SLA badge | `role="alert"`, `aria-label="3 new inquiries, oldest 2 days"` |

---

## 9. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | KPI shimmer + tab skeletons |
| KPIs | 200-400ms | Numbers animate with trend arrows |
| Platform stats | 300-600ms | Platform rows populate |
| Partnerships | 400-700ms | Cards stagger in |
| Deliverables | 500-800ms | Checklist items appear |
| Inquiry alerts | 300-500ms | Badge + preview populate |

---

## 10. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `creator_pro.viewed` | Page load | `tier`, `platforms_connected`, `active_partnerships` |
| `creator_pro.tab_switched` | Tab change | `tab` (overview/media_kit/partnerships/inquiries) |
| `creator_pro.kpi_expanded` | KPI click for detail | `metric` |
| `creator_pro.partnership_clicked` | Partnership card click | `partnership_id`, `status` |
| `creator_pro.deliverable_started` | "✏️ Start" | `partnership_id`, `deliverable_type` |
| `creator_pro.inquiry_viewed` | "→ View all inquiries" | `pending_count` |
| `creator_pro.media_kit_opened` | Media Kit tab | — |
| `creator_pro.platform_refreshed` | Manual platform refresh | `platform` |

---

## 11. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/creator-pro/+page.svelte`
- **Server load**: `+page.server.ts` → `CreatorProService/GetDashboard(workspace_id)` → aggregates KPIs, partnerships, deliverables, inquiry count
- **Tabs**: Client-side tab switching; Media Kit/Inquiries tabs lazy-load W089/W090 components
- **KPI aggregation**: Cross-platform stats from `PlatformService/GetAggregatedStats` (cached 1h)
- **SLA tracking**: `created_at + 48h - now()` computed client-side, red at <12h
- **Tier gating**: Server checks `subscription.tier` → returns `gated_features[]` → client shows locked UI
- **Real-time**: SSE for new inquiry notifications → badge updates

---

## 12. Localization Notes

- KPIs: "Tương tác TB", "Tổng tiếp cận", "Doanh thu tài trợ", "Đánh giá"
- Platform: "Người theo dõi", "Tương tác", "RPM"
- Partnerships: "Đang hoạt động", "Đang thương lượng"
- Deliverables: "còn 2 ngày", "Quá hạn 3 ngày"
- Tone: Motivational, data-driven

---

## 13. Design Tokens

| Token | Usage |
|---|---|
| `--color-accent` | CTAs, tab highlights |
| `--color-success` | ✅ Completed, positive trends |
| `--color-warning` | SLA warning, deadline approaching |
| `--color-danger` | SLA breach, overdue, negative trends |
| `--color-platform-tiktok` | TikTok row accent |
| `--color-platform-instagram` | Instagram row accent |
| `--color-platform-youtube` | YouTube row accent |
| `--color-surface-elevated` | KPI cards, partnership cards |
| `--font-metric` | KPI numbers, stats (tabular-nums) |

---

## 14. Related Screens

| Screen | Relationship |
|---|---|
| [W089] Media Kit Editor | Build shareable media kit |
| [W090] Sponsor Inquiries | Manage brand inquiries |
| [W093] Rate Card Builder | Pricing management |
| [W094] Revenue per Content | Content revenue tracking |
| [M045] Mobile Creator Pro | Mobile equivalent |

---

## 15. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 errors (platform sync, SLA), KPI/tab a11y, 8 analytics, SvelteKit impl (multi-platform aggregation, SLA tracking), localization, 9 design tokens (platform-specific). | System |
| 2026-03-28 | 1.0 | Initial specification | System |
