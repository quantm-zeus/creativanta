# Screen: Web — Home Dashboard

> **Screen ID**: W001
> **Module**: M01 — Home & Decision
> **Route**: `/`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4, Product Freeze §8/§9, A1 Schema, B4 Connectors

---

## 1. Purpose & Context

The Home Dashboard is the primary landing page after workspace selection. It serves as the **decision cockpit** — an intelligence-first overview showing what's happening now, what needs attention, and what to do next. It is NOT a generic dashboard with static metrics; it is dynamically personalized based on the user's active operator mode(s) and connected platforms.

### User Story
> As a creator, I want to see my most important metrics, actions, and alerts immediately after login so I can decide what to prioritize today.

### Entry Points
- Direct URL: `/`
- After login via Clerk → workspace selection → redirect to `/`
- Sidebar: "🏠 Home" (always first item)

### Exit Points
- Click any card → respective module detail page
- Click sidebar items → module pages
- Click notification → respective item

---

## 2. Layout Structure

### Responsive Behavior
| Breakpoint | Layout |
|---|---|
| Desktop (≥1280px) | App Shell (sidebar 240px) + Main Content (3-column grid) |
| Tablet (768-1279px) | App Shell (collapsed sidebar 64px) + Main Content (2-column grid) |
| Mobile (≤767px) | Redirect to Mobile App download prompt or `/m/` mobile web |

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 🏠 Creativanta   [Workspace ▾]                    🔔(3) 👤 Avatar  │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ Chào buổi sáng, Quân 👋            Hôm nay: Thứ 5, 27/03/2026      │
│ [Mode: Creator + Seller active]                                      │
│                                                                      │
│ ┌─ Smart Alerts (full width) ────────────────────────────────────┐  │
│ │ 🔴 3 đơn hàng mới cần xác nhận                   [Xem ngay →] │  │
│ │ 🟡 Credit AI còn 12/100 — sắp hết               [Nạp thêm →] │  │
│ │ 🟢 Video "5 tips" đạt 10K views sau 2h           [Xem stats →]│  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Today's KPIs ─────────┐  ┌─ AI Pulse ──────────────────────┐   │
│ │ 💰 Revenue    2.4M VND │  │ 🔥 3 trending topics phù hợp   │   │
│ │ 📦 Orders     12 (+3)  │  │ · "AI cooking" ⭐92 [Xem →]    │   │
│ │ 👁 Views      45.2K    │  │ · "Retinol 2026" ⭐87 [Xem →]  │   │
│ │ 💬 Unread     23       │  │ · "Budget skincare" ⭐78        │   │
│ │ ❤️ Eng Rate   8.2%     │  │                                  │   │
│ │ 🤖 AI Credit  12/100   │  │ 💡 2 opportunities scored >80   │   │
│ │                         │  │ [Xem Opportunity Board →]       │   │
│ │ Period: [Today ▾]      │  │                                  │   │
│ └─────────────────────────┘  └──────────────────────────────────┘   │
│                                                                      │
│ ┌─ Content Pipeline ─────────────────────────────────────────────┐  │
│ │ IDEAS (5)        SCRIPTS (3)      IN PRODUCTION (2)            │  │
│ │ ┌────────┐       ┌────────┐       ┌────────┐                  │  │
│ │ │ 💡 Tip │       │ 📝 Rev │       │ 🎬 Ser │                  │  │
│ │ │ skincar│       │ iew se │       │ um vid │                  │  │
│ │ │ ⭐ 82  │→      │ ⭐ 88  │→      │ 45% ██ │                  │  │
│ │ └────────┘       └────────┘       └────────┘                  │  │
│ │ [→ Full Pipeline]                                              │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Upcoming Schedule ────┐  ┌─ Quick Actions ──────────────────┐   │
│ │ 📅 Hôm nay              │  │ [🤖 Hỏi AI Copilot]             │   │
│ │ 18:00 📤 "5 tips" → TT │  │ [✨ Tạo ý tưởng mới]            │   │
│ │ 20:00 📤 "Review" → YT │  │ [📝 Viết script]                │   │
│ │ 📅 Ngày mai              │  │ [🔥 Xem xu hướng]              │   │
│ │ 10:00 📤 "Haul" → IG   │  │ [📦 Kiểm tra đơn hàng]         │   │
│ │ [→ Lịch đăng bài]       │  │ [📊 Báo cáo tuần]              │   │
│ └──────────────────────────┘  └──────────────────────────────────┘   │
│                                                                      │
│ ┌─ Platform Health ──────────────────────────────────────────────┐  │
│ │ 🎵 TikTok [🟢 Connected] 125K followers · token valid 28d    │  │
│ │ 📸 Instagram [🟢 Connected] 45K followers · synced 30m ago   │  │
│ │ 📺 YouTube [🟡 Token expiring in 2d — Refresh →]              │  │
│ │ 🛍 Shopee [🟢 Connected] 234 products synced                  │  │
│ │ ⚫ Lazada [Not connected — Connect →]                          │  │
│ └────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3. Component Hierarchy

```
HomePage
├── AppShell (shared)
│   ├── Sidebar
│   │   ├── WorkspaceSelector
│   │   ├── NavigationMenu
│   │   └── SidebarFooter (credits, help)
│   └── TopBar
│       ├── SearchGlobal
│       ├── NotificationBell (badge count)
│       └── UserMenu (avatar, dropdown)
├── GreetingHeader
│   ├── TimeBasedGreeting ("Chào buổi sáng")
│   ├── UserName
│   ├── DateDisplay
│   └── ActiveModeBadges
├── SmartAlertBanner
│   ├── AlertItem[] (priority-sorted)
│   │   ├── SeverityIcon (🔴/🟡/🟢/🔵)
│   │   ├── AlertMessage
│   │   └── ActionLink
│   └── DismissButton
├── MainGrid (3-column responsive)
│   ├── KPIPanel
│   │   ├── KPICard[] (6 cards)
│   │   │   ├── MetricIcon
│   │   │   ├── MetricValue (animated counter)
│   │   │   ├── MetricLabel
│   │   │   ├── TrendIndicator (↑/↓ + percentage)
│   │   │   └── Sparkline (7-day mini chart)
│   │   └── PeriodSelector (Today/7d/30d)
│   ├── AIPulseCard
│   │   ├── TrendingTopics[]
│   │   │   ├── TrendTitle
│   │   │   ├── TrendScore (badge)
│   │   │   └── ViewLink
│   │   └── OpportunitySummary
│   ├── ContentPipelineWidget
│   │   ├── PipelineStage[] (Ideas → Scripts → Production → Published)
│   │   │   ├── StageHeader (name + count)
│   │   │   └── MiniCard[] (top 3 items)
│   │   └── ViewAllLink
│   ├── UpcomingScheduleWidget
│   │   ├── DayGroup[]
│   │   │   ├── DayLabel
│   │   │   └── ScheduleItem[]
│   │   │       ├── TimeLabel
│   │   │       ├── ContentTitle
│   │   │       ├── PlatformIcon
│   │   │       └── StatusBadge
│   │   └── ViewCalendarLink
│   ├── QuickActionsPanel
│   │   └── ActionButton[] (icon + label)
│   └── PlatformHealthWidget
│       └── PlatformRow[]
│           ├── PlatformIcon
│           ├── PlatformName
│           ├── StatusBadge (🟢/🟡/🔴/⚫)
│           ├── MetricSnippet
│           └── ActionLink (if needed)
```

---

## 4. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Revenue | `ClickHouse: content_performance` | `AnalyticsService/GetDashboard` | `Intl.NumberFormat('vi-VN')` + "VND" | 5m TTL |
| Orders | `orders` table aggregation | `OrderService/GetTodayStats` | Integer + delta badge "(+3)" | 5m TTL |
| Views | `ClickHouse: content_performance` | `AnalyticsService/GetDashboard` | Compact format (45.2K) | 5m TTL |
| Unread | `threads WHERE unread = true` | `ThreadService/GetUnreadCount` | Integer | Real-time SSE |
| Engagement Rate | Computed (interactions/views) | `AnalyticsService/GetDashboard` | Percentage "8.2%" | 5m TTL |
| AI Credits | `ai_credit_transactions` balance projection | `CreditService/GetBalance` | "12/100" (used/total) | Real-time |
| Trending Topics | `trends` top by score | `TrendService/ListTop(limit=3)` | Title + score badge | 10m TTL |
| Pipeline Counts | `ideas`, `scripts`, `assets` | `DashboardService/GetPipeline` | Count per stage | 5m TTL |
| Schedule | `publish_jobs` upcoming | `PublishService/ListUpcoming(limit=5)` | Time + title + platform icon | 5m TTL |
| Platform Health | `connectors` status | `ConnectorService/GetAllStatus` | Status badge + metric | 15m TTL |
| Alerts | Multiple sources (orders, credits, perf) | `AlertService/GetActive` | Priority-sorted list | Real-time SSE |

---

## 5. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | View order alerts | Click "Xem ngay" on order alert | — | — | Navigate → `/orders?status=pending` | `order:read` |
| 2 | Top-up credits | Click "Nạp thêm" on credit alert | — | — | Navigate → `/settings/billing/credits` | `credits:top_up` |
| 3 | View content stats | Click "Xem stats" on performance alert | — | — | Navigate → `/analytics/content/[id]` | `report:read` |
| 4 | Dismiss alert | Click "✕" on alert | `AlertService/Dismiss(id)` | `alerts.dismissed_at = now` | Alert fades out | Any role |
| 5 | Change KPI period | Select from period dropdown | `AnalyticsService/GetDashboard(period)` | — | KPI values animate to new values | `report:read` |
| 6 | View trend | Click trend item "Xem →" | — | — | Navigate → `/intelligence/trends/[id]` | `trend:read` |
| 7 | View opportunity board | Click "Xem Opportunity Board" | — | — | Navigate → `/intelligence/opportunities` | `opportunity:read` |
| 8 | Open pipeline item | Click mini card in pipeline | — | — | Navigate → respective item | Varies |
| 9 | Open copilot | Click "Hỏi AI Copilot" | — | — | Open Copilot sidebar/dialog | `copilot:use_help` |
| 10 | Create idea | Click "Tạo ý tưởng mới" | — | — | Navigate → `/ideas/new` | `idea:create` |
| 11 | Write script | Click "Viết script" | — | — | Navigate → `/scripts/new` | `script:create` |
| 12 | View trends | Click "Xem xu hướng" | — | — | Navigate → `/intelligence/trends` | `trend:read` |
| 13 | Check orders | Click "Kiểm tra đơn hàng" | — | — | Navigate → `/orders` | `order:read` |
| 14 | View weekly report | Click "Báo cáo tuần" | — | — | Navigate → `/analytics/weekly` | `report:read` |
| 15 | View schedule | Click "Lịch đăng bài" | — | — | Navigate → `/publish/calendar` | `publish:read` |
| 16 | Connect platform | Click "Connect →" on disconnected platform | — | — | Open connector setup flow | `account:connect` |
| 17 | Refresh token | Click "Refresh →" on expiring token | `ConnectorService/RefreshToken` | Token refreshed | Status → 🟢 | `account:connect` |
| 18 | Switch workspace | Click workspace selector | — | — | Workspace switch, full page reload | Any role |

---

## 6. State Machine

```
┌─────────────┐
│   LOADING   │ ← Initial page load
└──────┬──────┘
       │ All API responses received
       ▼
┌─────────────┐
│   LOADED    │ ← Normal state with all widgets populated
└──────┬──────┘
       │
       ├── Some API fails → PARTIAL_DEGRADED
       ├── All APIs fail → ERROR
       ├── No platforms connected → ONBOARDING
       └── User has 0 content → EMPTY_STATE
       
┌───────────────────┐
│ PARTIAL_DEGRADED  │ ← Show available widgets + error cards for failed ones
│ "Retry" per widget│
└───────────────────┘

┌─────────────┐
│    ERROR    │ ← Full page error with retry button
└─────────────┘

┌───────────────┐
│  ONBOARDING   │ ← First-time user: show setup checklist instead of dashboard
└───────────────┘

┌───────────────┐
│  EMPTY_STATE  │ ← Connected but no content yet: guided CTAs
└───────────────┘
```

### State Descriptions

| State | Visual | User Action |
|---|---|---|
| LOADING | All widgets show skeleton loaders (shimmer effect). Greeting header visible. | Wait |
| LOADED | Full dashboard rendered. KPI counters animate in. Alerts slide down. | Interact normally |
| PARTIAL_DEGRADED | Failed widget shows: "Không tải được [widget]. [Thử lại]". Other widgets work. | Retry specific widget |
| ERROR | Full-page: "Đã xảy ra lỗi khi tải Dashboard. [Thử lại] [Liên hệ hỗ trợ]" | Retry or contact support |
| ONBOARDING | Setup checklist replaces dashboard: 1. Connect platform 2. Create first idea 3. Set up products | Follow checklist |
| EMPTY_STATE | "Bạn đã kết nối TikTok 🎉 Hãy bắt đầu tạo nội dung!" + prominent CTAs | Create first content |

---

## 7. Validation Rules

N/A — This is a read-only dashboard. No form inputs.

---

## 8. Permission Matrix

| Widget/Action | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View dashboard | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| KPI panel | ✅ Full | ✅ Full | ✅ Full | ✅ Views+Eng only | ✅ Views only | ✅ Views only | ❌ |
| Revenue metrics | ✅ | ✅ | ✅ | ❌ Hidden | ❌ Hidden | ❌ Hidden | ❌ |
| Order count | ✅ | ✅ | ✅ | ❌ Hidden | ❌ Hidden | ❌ Hidden | ❌ |
| AI Pulse | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| Content Pipeline | ✅ | ✅ | ✅ | ✅ | ✅ Own items | ✅ Read | ❌ |
| Quick Actions | ✅ All | ✅ All | ✅ All | ✅ Content only | ✅ Create only | ❌ Hidden | ❌ |
| Platform Health | ✅ | ✅ | ✅ | ✅ View | ❌ Hidden | ❌ Hidden | ❌ |
| Connect platform | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Credit top-up | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |

---

## 9. Navigation Map

```
Home Dashboard (/)
├── → /orders?status=pending          (via Order alert)
├── → /settings/billing/credits        (via Credit alert)
├── → /analytics/content/[id]          (via Performance alert)
├── → /intelligence/trends/[id]        (via AI Pulse trend item)
├── → /intelligence/opportunities      (via Opportunity summary)
├── → /ideas (or /ideas/new)           (via Quick Action)
├── → /scripts (or /scripts/new)       (via Quick Action)
├── → /intelligence/trends             (via Quick Action)
├── → /orders                          (via Quick Action)
├── → /analytics/weekly                (via Quick Action)
├── → /publish/calendar                (via Schedule widget)
├── → /settings/connectors             (via Platform Health "Connect")
└── → Copilot Sidebar                  (via Quick Action "Hỏi AI")
```

---

## 10. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network error (all APIs) | No internet / server down | Full page error state with retry | "Thử lại" button → reload all |
| Single widget API fail | One API returns 5xx | Widget shows inline error + retry | Per-widget "Thử lại" |
| Auth expired | 401 response | Redirect to `/auth/login` | Re-authenticate via Clerk |
| Workspace not found | 404 on workspace | "Workspace không tồn tại" → workspace selector | Select different workspace |
| Rate limited | 429 response | Toast "Quá nhiều yêu cầu. Thử lại sau 30s" | Auto-retry after backoff |
| Connector degraded | Platform token invalid | Yellow banner on Platform Health widget | "Kết nối lại" link |

---

## 11. Accessibility

| Element | Requirement |
|---|---|
| KPI Cards | `role="status"`, `aria-label="Doanh thu hôm nay: 2.4 triệu VND"` |
| Alert banner | `role="alert"`, `aria-live="polite"` |
| Navigation | Full keyboard navigation (Tab order: greeting → alerts → KPIs → AI Pulse → Pipeline → Schedule → Quick Actions → Platform Health) |
| Color contrast | All text meets WCAG 2.1 AA (4.5:1 ratio) |
| Screen reader | All icons have `aria-label` or `sr-only` text |
| Focus management | Skip-to-content link at top of page |
| Reduced motion | `prefers-reduced-motion: reduce` → disable sparkline animations and counter animations |

---

## 12. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | App Shell renders immediately (SSR). Sidebar + topbar visible. |
| Skeleton phase | 0-500ms | All widget areas show shimmer skeletons matching final layout size |
| Progressive hydration | 100-800ms | Widgets hydrate in priority order: Alerts → KPIs → Pipeline → Schedule → AI Pulse → Platform Health |
| Counter animation | 800-1200ms | KPI values animate from 0 to actual value (ease-out curve) |
| Stale-while-revalidate | Background | After initial load, cache serves stale data while fresh data loads in background |

---

## 13. Performance Requirements

| Metric | Target | Measurement |
|---|---|---|
| LCP | < 1.5s | Largest KPI card or Alert banner |
| FID | < 100ms | First interaction with any button |
| CLS | < 0.05 | No layout shifts after skeleton → content transition |
| TTI | < 2.0s | All interactive elements functional |
| API calls | ≤ 5 parallel | Batch dashboard data into single RPC when possible |
| Bundle size | < 50KB (page-specific JS) | Code-split per page, lazy-load charts |

---

## 14. Real-time Updates

| Data | Channel | Method | Frequency |
|---|---|---|---|
| Unread count | SSE `/events/inbox` | Server-Sent Events | Real-time |
| Alert new | SSE `/events/alerts` | Server-Sent Events | Real-time |
| Order count | SSE `/events/orders` | Server-Sent Events | Real-time |
| KPI metrics | Polling | Fetch every 5 min | 5 min |
| Platform health | Polling | Fetch every 15 min | 15 min |
| AI Pulse | Polling | Fetch every 10 min | 10 min |

---

## 15. Localization Notes

- All UI text in Vietnamese (primary market)
- Date format: `dd/MM/yyyy` (Vietnamese standard)
- Currency: VND with dot separator (2.400.000đ)
- Number format: dot for thousands (45.200)
- Greeting is time-based: `Chào buổi sáng` (5-11), `Chào buổi chiều` (12-17), `Chào buổi tối` (18-4)

---

## 16. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `dashboard.viewed` | Page load complete | `workspace_id`, `role`, `active_modes[]`, `platforms_connected` |
| `dashboard.alert.clicked` | Click alert action link | `alert_type`, `alert_id` |
| `dashboard.alert.dismissed` | Dismiss alert | `alert_type`, `alert_id` |
| `dashboard.kpi.period_changed` | Change KPI period | `period`, `previous_period` |
| `dashboard.quick_action.clicked` | Click quick action | `action_type` |
| `dashboard.trend.clicked` | Click trend in AI Pulse | `trend_id`, `score` |
| `dashboard.pipeline.item_clicked` | Click pipeline item | `item_type`, `item_id` |
| `dashboard.platform.action` | Click connect/refresh | `platform`, `action` |

---

## 17. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-surface-primary` | Card backgrounds |
| `--color-surface-elevated` | Alert banner background |
| `--color-text-primary` | Main text |
| `--color-text-secondary` | Labels, descriptions |
| `--color-accent` | CTA buttons, active states |
| `--color-success` | 🟢 Connected, positive trends |
| `--color-warning` | 🟡 Token expiring, low credits |
| `--color-danger` | 🔴 Disconnected, errors, urgent |
| `--spacing-card` | Padding inside cards (16px) |
| `--spacing-grid-gap` | Grid gap between widgets (24px) |
| `--radius-card` | Card border radius (12px) |
| `--shadow-card` | Card elevation shadow |
| `--font-heading` | Dashboard title, greeting |
| `--font-metric` | KPI numbers (tabular-nums) |

---

## 18. Technical Implementation Notes

### SvelteKit Specifics
- **Route**: `src/routes/(app)/+page.svelte`
- **Server load**: `+page.server.ts` → parallel fetch all dashboard data
- **SSR**: Full SSR for greeting + skeleton layout; client-side hydration for dynamic data
- **State**: Dashboard `$state` rune for each widget section

### Data Fetching Strategy
```
+page.server.ts:
  Promise.all([
    dashboardService.getKPIs(period),
    alertService.getActive(),
    trendService.getTop(3),
    pipelineService.getSummary(),
    publishService.getUpcoming(5),
    connectorService.getAllStatus()
  ])
```

### Real-time Setup
```
+page.svelte onMount:
  setupSSE('/events/inbox', (data) => updateUnreadCount(data))
  setupSSE('/events/orders', (data) => updateOrderCount(data))
  setupSSE('/events/alerts', (data) => addAlert(data))
```

---
## 19. Preconditions / Postconditions
### Preconditions
- User authenticated with valid session
- Required module permissions granted
### Postconditions
- User actions persisted to backend
- Analytics events dispatched

---

## 20. Related Screens

| Screen | Relationship |
|---|---|
| [W002] Workspace Selector | Parent (selects which workspace to show) |
| [M001] Mobile Home | Mobile equivalent of this screen |
| [W008] Copilot Dialog | Opens from Quick Action |
| [W038] Trend Radar | Linked from AI Pulse |
| [W053] Publish Queue | Linked from Schedule widget |
| [W062] Order List | Linked from Order alerts |

---

## 21. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-27 | 1.0 | Initial screen specification | System |

## Progressive first-value layout

Follow M01's progressive first-value flow: show “Connect or import” and currently available next steps; future-phase steps explain availability. Imported data can populate authorized cards before full onboarding. Data-repair cards open the owning object/action, with source/freshness and permission-filtered gaps; personal completion never changes workspace settings.
