# Screen: Mobile — Home Dashboard

> **Screen ID**: M001
> **Module**: M01 — Home & Decision Engine
> **Route**: `/` (mobile app — default tab)
> **Platform**: Mobile (Flutter)
> **Upstream**: Pack 01 §4, Product Freeze §8/§9, Home projections + `ai_credit_transactions`, B5 RBAC §2.7

---
## 1. Purpose & Context

The Mobile Home Dashboard is the app's primary landing screen — a vertical scroll-feed of **today's priorities** optimized for quick glance and one-thumb operation. Unlike the web dashboard (3-column grid), mobile uses a single-column card stack with swipe interactions, haptic feedback, and intelligent content ordering based on user behavior and pending actions.

### User Goals
- See today's key numbers at a glance (revenue, orders, views, unread, engagement, credits)
- Identify and act on urgent items (pending orders, failing publishes, breached SLA)
- Discover trending topics for next content
- Check content pipeline status (ideas → scripts → production → publish)
- review upcoming publish schedule and take quick actions

### Business Goals
- Drive daily active engagement through addictive morning check habit
- Reduce time-to-action on urgent items (target: <5m from alert to action)
- Cross-promote all platform features through quick action chips
- Surface AI value (trends, insights) to increase perceived platform intelligence

### When This Screen Is Used
- **App launch**: First screen seen every time (default tab)
- **Morning ritual**: Creator checks priorities before starting content production
- **Throughout day**: Quick periodic checks between activities
- **On notification**: Push notification → app opens → home with relevant alert

### Entry Points
- App launch (cold start — default tab 🏠)
- Bottom nav: "🏠 Home" tab (from any other tab)
- Background to foreground (resume from background)
- Push notification tap (with contextual alert highlighted)
- Universal link / deep link: `/`

### Exit Points
- Tap KPI → Analytics (M011)
- Tap alert → relevant action screen (Orders, Inbox, Publish, etc.)
- Tap AI Pulse → Trend List (M014)
- Tap pipeline chip → Ideas (M008) / Scripts (M013) / Studio (M021)
- Tap schedule item → Publish Detail
- Quick action chips → respective screens
- Bottom nav tabs → other major sections

---
## 2. Preconditions / Postconditions

### Preconditions
- User authenticated (Clerk auth token valid)
- User has at least one workspace membership
- Active workspace selected (persisted in local storage)

### Postconditions
- Dashboard viewed event logged for engagement analytics
- Smart alerts dismissed → persist in server (not shown again)
- Platform token refresh → update in connector service
- Pull-to-refresh → all data re-fetched with fresh timestamps

---
## 3. Screen Layout

### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ Creativanta                     🔔(3) [🏢 Studio ▾]                 │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ Chào buổi sáng, Quân 👋                                             │
│ Hôm nay: Thứ 5, 27/03/2026                                          │
│                                                                      │
│ ┌─ Smart Alert Carousel ──────────────────────────────────────────┐ │
│ │ 🔴 3 đơn hàng mới cần xác nhận               [ Xem ngay → ]   │ │
│ │                                          ← swipe to dismiss → │ │
│ ├────────────────────────────────────────────────────────────────┤ │
│ │ 🟡 2 bài đăng cần review trước 18:00          [ Xem → ]       │ │
│ │ •  •  ○                                       (page indicator) │ │
│ └────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ┌─ Today's KPIs (2×3 grid) ──────────────────────────────────────┐ │
│ │ ┌───────────┐ ┌───────────┐ ┌───────────┐                     │ │
│ │ │ 💰 2.4M   │ │ 📦 12 (+3)│ │ 👁 45.2K  │                     │ │
│ │ │ Doanh thu │ │ Đơn hàng  │ │ Lượt xem  │                     │ │
│ │ │ ↑+15%     │ │ ↑+3 today │ │ ↑+12%     │                     │ │
│ │ └───────────┘ └───────────┘ └───────────┘                     │ │
│ │ ┌───────────┐ ┌───────────┐ ┌───────────┐                     │ │
│ │ │ 💬 23     │ │ ❤️ 8.2%   │ │ 🤖 12/100 │                     │ │
│ │ │ Chưa đọc  │ │ Tương tác │ │ AI Credit │                     │ │
│ │ │ 🔴 5 high │ │ ↑+0.5pp  │ │ còn 88    │                     │ │
│ │ └───────────┘ └───────────┘ └───────────┘                     │ │
│ └────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ┌─ AI Pulse Card ─────────────────────────────────────────────────┐│
│ │ 🔥 3 xu hướng mới phù hợp profile bạn                          ││
│ │ 1. "AI cooking tips" ⭐92 · 🎵 TikTok trending                ││
│ │ 2. "Retinol 2026" ⭐87 · 📸 IG viral                           ││
│ │ 3. "Budget skincare" ⭐78 · 🎵 TikTok rising                  ││
│ │ [🤖 Tạo ý tưởng từ trend →] [Xem tất cả →]                    ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ┌─ Content Pipeline (horizontal scroll) ──────────────────────────┐│
│ │ ← [💡 Ideas: 5] [📝 Scripts: 3] [🎬 Producing: 2]            ││
│ │    [📋 QA: 1]   [📤 Scheduled: 3] [✅ Published: 24] →        ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ┌─ Upcoming Schedule ─────────────────────────────────────────────┐│
│ │ 📅 Hôm nay                                                      ││
│ │ 18:00 [🎬] "5 tips nấu ăn" → 🎵 TikTok          [⏰ Sẵn sàng]││
│ │ 20:00 [📸] "Serum review" → 📺 YouTube            [✍ Cần edit] ││
│ │                                                                    ││
│ │ 📅 Ngày mai                                                       ││
│ │ 10:00 [📸] "Haul tháng 3" → 📸 Instagram          [📤 Ready]  ││
│ │ 14:00 [🎬] "Cooking tutorial" → 🎵 TikTok        [⏰ Sẵn sàng]││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ┌─ Quick Actions (horizontal scroll) ─────────────────────────────┐│
│ │ [🤖 Copilot] [✨ Ý tưởng] [📝 Script] [🔥 Trends] [📦 Orders]││
│ │ [📊 Analytics] [⚙ Settings]                                     ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ┌─ Platform Status ───────────────────────────────────────────────┐│
│ │ 🎵 TikTok 🟢  📸 IG 🟢  📺 YT 🟡  🛍 Shopee 🟢              ││
│ │ [⚠ YouTube token hết hạn sớm — tap để refresh]                  ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠•] [💡] [🎬] [💬(23)] [📊]                                      │
└──────────────────────────────────────────────────────────────────────┘
```

---
## 4. Component Hierarchy

```
MobileHomePage
├── AppBar
│   ├── AppLogo ("Creativanta")
│   ├── NotificationBell (badge count, tap → M002 Notifications)
│   └── WorkspaceDropdown (tap → bottom sheet workspace picker)
├── ScrollableContent (pull-to-refresh with branded indicator)
│   ├── GreetingSection
│   │   ├── TimeGreeting ("Chào buổi sáng/chiều/tối, {name} 👋")
│   │   └── DateDisplay ("Hôm nay: Thứ 5, 27/03/2026")
│   ├── SmartAlertCarousel (PageView — horizontal swipe)
│   │   └── AlertCard[] (priority-sorted: 🔴 > 🟡 > 🟢)
│   │       ├── SeverityIndicator (🔴 Critical / 🟡 Warning / 🟢 Info)
│   │       ├── AlertMessage (concise, action-oriented)
│   │       ├── ActionButton ("Xem ngay →" → navigates to relevant screen)
│   │       ├── SwipeToDismiss (left/right gesture + haptic)
│   │       └── PageIndicator (dots: current/total)
│   ├── KPIGrid (2×3 grid layout)
│   │   └── KPIMiniCard[] (6 cards, tappable → relevant detail screen)
│   │       ├── MetricIcon (💰/📦/👁/💬/❤️/🤖)
│   │       ├── MetricValue (AnimatedCount — counts up from 0)
│   │       ├── MetricLabel
│   │       ├── TrendDelta (↑↓ with percentage or absolute, color-coded)
│   │       └── SubDetail (optional — "🔴 5 high" for inbox, "còn 88" for credits)
│   ├── AIPulseCard
│   │   ├── SectionHeader ("🔥 Xu hướng mới")
│   │   ├── TrendRow[] (top 3 — rank, title, score badge, platform badge)
│   │   ├── CreateIdeaFromTrendButton ("🤖 Tạo ý tưởng từ trend →")
│   │   └── ViewAllButton ("Xem tất cả →" → M014)
│   ├── ContentPipelineScroller (horizontal ListView)
│   │   └── PipelineStageChip[] (6 stages — tappable → filtered list)
│   │       ├── StageIcon (💡/📝/🎬/📋/📤/✅)
│   │       ├── StageLabel
│   │       ├── Count (highlight if > 0 in actionable stages)
│   │       └── ActiveIndicator (bold when count > 0)
│   ├── UpcomingScheduleSection
│   │   ├── SectionHeader ("📅 Sắp tới")
│   │   └── DayGroup[] (Today, Tomorrow)
│   │       ├── DayLabel ("Hôm nay" / "Ngày mai")
│   │       └── ScheduleRow[] (tappable → publish detail)
│   │           ├── TimeLabel ("18:00")
│   │           ├── ContentThumbnail (small)
│   │           ├── ContentTitle
│   │           ├── PlatformIcon + ArrowIcon
│   │           └── StatusBadge (⏰ Sẵn sàng / ✍ Cần edit / 📤 Ready)
│   ├── QuickActionScroller (horizontal chips)
│   │   └── QuickActionChip[] (tappable → respective screen)
│   │       ├── ActionIcon
│   │       └── ActionLabel
│   └── PlatformStatusBar
│       ├── PlatformDot[] (icon + status color)
│       └── WarningBanner (conditional — e.g., token expiring)
└── BottomNavBar
    └── NavTab[] (🏠 Home, 💡 Ideas, 🎬 Studio, 💬 Inbox, 📊 Analytics)
        └── Badge (on Inbox tab — unread count)
```

---
## 5. Displayed Data

| Element | Source | API | Display Format | Cache |
|---|---|---|---|---|
| Greeting | User's `first_name` + current time zone | Client-side | "Chào buổi sáng, Quân 👋" | — |
| Smart alerts | `dashboards.alerts` (priority-sorted) | `DashboardService/GetMobileHome` | Alert cards with severity | 2m |
| Revenue (today) | `ClickHouse: revenue_daily` | same | "2.4M" (compact VND) | 5m |
| Orders (today) | `COUNT(orders) WHERE date=today` | same | "12 (+3)" with delta vs yesterday | 5m |
| Views (today) | `SUM(content_performance.views)` | same | "45.2K" (compact) | 5m |
| Unread threads | `COUNT(threads WHERE unread=true)` | same | "23" with high-priority indicator | 2m |
| Engagement rate | `SUM(engagements)/SUM(views)×100` | same | "8.2%" with trend | 5m |
| AI credits | `ai_credit_transactions` balance projection / `plan.credits_total` | same | "12/100" with remaining count | 5m |
| Trending topics | `trends` top 3 by AI relevance score | `TrendService/GetTop(3)` | Title + score + platform badge | 30m |
| Content pipeline | `COUNT(content) GROUP BY status/stage` | same | Stage chip with count | 5m |
| Upcoming schedule | `publish_jobs WHERE scheduled >= now ORDER BY scheduled LIMIT 5` | same | Time + title + platform | 5m |
| Platform status | `connectors.health_status` per platform | same | Status dots (🟢/🟡/🔴) | 5m |
| Workspace | `workspace_members.workspace_id` → `workspaces.name` | Cached locally | Dropdown label | Session |

---
## 6. User Actions

| # | Action | Trigger | Type | API Call | System Response | Permission |
|---|---|---|---|---|---|---|
| 1 | Pull to refresh | Pull-down gesture | Refresh | `DashboardService/GetMobileHome` | All widgets refresh. Haptic light. Branded indicator. | Any |
| 2 | View alert detail | Tap alert card CTA | Navigate | — | → relevant screen (Orders/Inbox/Publish/etc.) | Varies |
| 3 | Dismiss alert | Swipe alert card | Dismiss | `AlertService/Dismiss(id)` | Card slides away. Haptic medium. Next alert shown. | Any |
| 4 | Tap KPI | Tap any KPI card | Navigate | — | → respective analytics detail screen | `report:read` |
| 5 | Tap revenue KPI | Tap 💰 card | Navigate | — | → Mobile Profit Summary (M034) | `profit:read` |
| 6 | Tap orders KPI | Tap 📦 card | Navigate | — | → Mobile Order List (M024) | `order:read` |
| 7 | Tap unread KPI | Tap 💬 card | Navigate | — | → Mobile Inbox (M004) | `thread:read` |
| 8 | View trends | Tap "Xem tất cả →" on AI Pulse | Navigate | — | → Trend List (M014) | `trend:read` |
| 9 | Create idea from trend | Tap "🤖 Tạo ý tưởng từ trend →" | Navigate | — | → Copilot with trend context (M060) | `idea:create` |
| 10 | Tap pipeline stage | Tap pipeline chip | Navigate | — | → respective list (Ideas/Scripts/Studio/Publish...) | Varies |
| 11 | Tap schedule item | Tap schedule row | Navigate | — | → Publish Item Detail | `publish:read` |
| 12 | Quick action chip | Tap any chip | Navigate | — | → respective screen | Varies |
| 13 | Refresh platform token | Tap "refresh" on platform warning | Action | `ConnectorService/RefreshToken(platform)` | Dot turns 🟢. Toast: "Token đã cập nhật." | `account:connect` |
| 14 | Open notifications | Tap 🔔 bell | Navigate | — | → Notifications (M002) | Any |
| 15 | Switch workspace | Tap workspace dropdown → select | Switch | `WorkspaceService/SetActive(ws_id)` | Bottom sheet → select → all data reloads | Any member |

---
## 7. Validation Rules

N/A — Read-only dashboard with navigation actions only.

---
## 8. States

| State | Condition | Visual | User Action |
|---|---|---|---|
| LOADING | App cold start | Shimmer skeletons for all sections. AppBar visible with logo. | Wait (< 3s target) |
| LOADED | All data received | Full dashboard. KPI numbers animate up (800ms). | Normal interactions |
| REFRESHING | Pull-to-refresh | Branded refresh indicator at top. Existing data stays visible. | Wait (< 2s target) |
| ONBOARDING | New user, no platform connected | Dashboard replaced by onboarding checklist: 1) Connect platform 2) Set brand voice 3) Create first idea | Follow onboarding steps |
| EMPTY | Platforms connected but no content yet | Slim dashboard (KPIs all 0) + prominent CTA: "Bắt đầu bằng việc tạo ý tưởng đầu tiên! [✨ Tạo ý tưởng →]" | Create first content |
| NO_ALERTS | No urgent items | Alert carousel hidden (section collapsed, more space for KPIs) | Normal dashboard |
| WORKSPACE_SWITCHING | Changing workspace | Brief shimmer overlay while data reloads for new workspace | Wait (< 1s) |
| ERROR | API failed | "❌ Không tải được dữ liệu. Kéo xuống để thử lại." | Pull-to-refresh |
| OFFLINE | No network | Banner: "📡 Ngoại tuyến — hiển thị dữ liệu cached" + cached data shown | Read cached data |

---
## 9. Permissions & Role-based Behavior

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View dashboard | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| Revenue KPI visible | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Order KPI visible | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Unread inbox KPI | ✅ | ✅ | ✅ | ✅ | ✅ (assigned) | ❌ | ❌ |
| AI credits visible | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| AI Pulse (trends) | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Content pipeline | ✅ | ✅ | ✅ | ✅ | ✅ (own) | ✅ | ❌ |
| Schedule | ✅ | ✅ | ✅ | ✅ | ✅ (own) | ✅ | ❌ |
| Quick actions | ✅ | ✅ | ✅ | ✅ | ✅ (limited) | ❌ | ❌ |
| Platform status | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Switch workspace | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |

### Visibility Rules
- **Editor**: Revenue KPI hidden. Shows 5-card grid (2+3) instead of 6. Platform status hidden.
- **Contributor**: Revenue + Orders hidden. Shows 4 cards. AI Pulse hidden. Pipeline shows only own items.
- **Viewer**: Revenue + Orders + Credits hidden. Shows 3 cards (Views, Engagement, Inbox count). Quick actions hidden. Read-only dashboard.
- **External**: No access to mobile app. Redirect to limited web view.

### KPI Grid Adaptation
The 2×3 grid adapts based on visible metrics:
- 6 metrics (Owner/Admin/Manager): 2×3 grid
- 5 metrics (Editor): 2+3 layout (2 on top, 3 below)
- 4 metrics (Contributor): 2×2 grid
- 3 metrics (Viewer): 3×1 row

---
## 10. Mobile-specific UX

### Gestures & Haptics
| Gesture | Target | Haptic | Result |
|---|---|---|---|
| Pull down | Whole page | Light | Refresh all data |
| Swipe L/R on alert | Alert card | Medium | Dismiss alert |
| Tap KPI card | KPI mini card | Light | Navigate to detail |
| Tap + hold KPI | KPI mini card | Heavy | Bottom sheet with detailed breakdown |
| Swipe on pipeline | Pipeline scroller | — | Scroll horizontally |
| Tap quick action | Chip | Light | Navigate to action |

### Smart Greeting Logic
| Time Range | Greeting |
|---|---|
| 05:00 - 11:59 | "Chào buổi sáng, {name} 👋" |
| 12:00 - 17:59 | "Chào buổi chiều, {name} 🌞" |
| 18:00 - 22:59 | "Chào buổi tối, {name} 🌙" |
| 23:00 - 04:59 | "Làm việc khuya, {name} 🦉" |

### Dark Mode
- Full dark mode support (system-driven or manual toggle)
- KPI cards use elevated surface colors
- Charts/sparklines adapt contrast

### Offline Behavior
- **Cached**: Last fetched KPIs, schedule, pipeline counts, platform status
- **Not cached**: Smart alerts (always fresh), AI Pulse trends
- **Behavior**: Show cached data with yellow banner, disable refresh actions

### iOS vs Android
| Feature | iOS | Android |
|---|---|---|
| App bar | Large title, blur background | Material 3, elevation |
| Back gesture | Swipe from edge | System back button |
| Pull-to-refresh | Custom indicator | Material refresh |
| Haptics | `UIImpactFeedbackGenerator` | `HapticFeedback.vibrate` |
| Home indicator | Bottom safe area | N/A |

---
## 11. Edge Cases

| Edge Case | Handling |
|---|---|
| New user (no data) | Show ONBOARDING state with checklist |
| All KPIs = 0 | Show EMPTY state with first-content CTA |
| 10+ smart alerts | Show first 5 most critical. "Xem tất cả (10) →" link. |
| No pending schedule | Schedule section shows: "📅 Không có lịch đăng bài. [Tạo lịch mới →]" |
| AI credits depleted | Credit KPI turns red: "🤖 0/100 🔴". Quick action "🤖 Copilot" shows "Hết credits". |
| Platform token expired | Red dot + banner: "🔴 TikTok ngắt kết nối. [Kết nối lại →]" |
| Very long content title in schedule | Truncate with ellipsis after 30 chars |
| Workspace with 0 members (owner-only) | Show normal dashboard, no team-related features |
| Multiple workspaces (>5) | Workspace picker bottom sheet with search |
| Push notification while on home | Alert highlights + bounce animation. If new order alert, order KPI pulses. |

---
## 12. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| Smart alerts | Push notification → SSE fallback | Real-time |
| Order count (today) | SSE `/events/orders` | Real-time (increments on new order) |
| Unread inbox | SSE `/events/inbox` | Real-time (badge updates) |
| Views/engagement | Polling | Every 5 minutes |
| Revenue | Polling | Every 5 minutes |
| Schedule | Polling | Every 5 minutes |
| Platform status | Polling | Every 5 minutes |
| AI Pulse trends | Background refresh | Every 30 minutes |

### Real-time UX
- **New order**: Order KPI "pulses" (scale 1.0→1.1→1.0, 300ms). Count increments with animation.
- **New unread message**: Inbox KPI badge increments. Bottom nav 💬 badge updates.
- **Alert arrives**: New alert slides in with push animation (from right).

---
## 13. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `home.viewed` | Page load / tab return | `workspace_id`, `session_type` (cold/warm/resume), `alert_count` |
| `home.kpi.tapped` | KPI card tap | `kpi_type` (revenue/orders/views/inbox/engagement/credits) |
| `home.kpi.longpress` | KPI card long press | `kpi_type` |
| `home.alert.viewed` | Alert card shown in carousel | `alert_type`, `severity`, `position` |
| `home.alert.actioned` | Alert CTA tapped | `alert_type`, `destination_screen` |
| `home.alert.dismissed` | Alert swiped away | `alert_type`, `severity`, `time_visible` |
| `home.trend.tapped` | AI Pulse trend tapped | `trend_title`, `score`, `position` |
| `home.pipeline.tapped` | Pipeline chip tapped | `stage` (ideas/scripts/producing/qa/scheduled/published) |
| `home.schedule.tapped` | Schedule row tapped | `publish_id`, `platform`, `status` |
| `home.quick_action.tapped` | Quick action chip tapped | `action` (copilot/ideas/script/trends/orders/analytics/settings) |
| `home.workspace.switched` | Workspace switched | `old_workspace_id`, `new_workspace_id` |
| `home.refreshed` | Pull-to-refresh | `time_since_last_refresh` |

---
## 14. Performance Requirements

| Metric | Target |
|---|---|
| Cold start to interactive | < 2.5s (app launch → home interactive) |
| Hot reload (tab switch) | < 500ms |
| Pull-to-refresh | < 2s |
| KPI animation | 800ms (counter), 60fps |
| Scroll performance | 60fps with all widgets rendered |
| Memory usage | < 50MB for home screen |
| Workspace switch | < 1s (full data reload) |
| Offline cache load | < 500ms |
| Alert carousel render | < 100ms per card swap |

---
## 15. Flutter Implementation Notes

### Widget Structure
- **Route**: `/` → `HomePage extends ConsumerStatefulWidget`
- **State management**: Riverpod `dashboardProvider` (auto-refresh, stale-while-revalidate)
- **Pull-to-refresh**: Custom `RefreshIndicator` with Creativanta branding
- **Horizontal scrollers**: `ListView.builder(scrollDirection: Axis.horizontal)`
- **KPI animation**: Custom `AnimatedCount` widget with `Tween<num>`, duration 800ms
- **Alert carousel**: `PageView.builder` with `PageController` + dot indicator
- **Bottom nav badge**: `badges` package on 💬 tab

### Data Fetching Strategy
```
onInit:
  // Single API call for dashboard (optimized backend endpoint)
  dashboardService.getMobileHome() → {
    alerts, kpis, trends, pipeline, schedule, platformStatus
  }

onRefresh:
  // Same call, forced fresh
  dashboardService.getMobileHome(forceRefresh: true)

onWorkspaceSwitch(ws_id):
  workspaceService.setActive(ws_id)
  dashboardService.getMobileHome() // re-fetch for new workspace
```

### Offline Strategy
```dart
// CacheFirst strategy
Future<DashboardData> getMobileHome({bool forceRefresh = false}) async {
  if (!forceRefresh) {
    final cached = await cacheStore.get('dashboard_home');
    if (cached != null && !cached.isStale(maxAge: 5.minutes)) {
      return cached;
    }
  }
  try {
    final fresh = await api.getDashboard();
    await cacheStore.set('dashboard_home', fresh);
    return fresh;
  } catch (e) {
    final cached = await cacheStore.get('dashboard_home');
    if (cached != null) return cached; // return stale cache
    throw e;
  }
}
```

---
## 16. Navigation Map

```
Mobile Home (/)
├── → /notifications (via 🔔 bell)
├── → /orders (via Order KPI or alert)
├── → /inbox (via Inbox KPI or bottom nav)
├── → /analytics (via Analytics KPI or bottom nav)
├── → /finance (via Revenue KPI)
├── → /intelligence/trends (via AI Pulse)
├── → /copilot (via Quick Action or trend CTA)
├── → /ideas (via Pipeline → Ideas chip)
├── → /scripts (via Pipeline → Scripts chip)
├── → /studio (via Pipeline → Production chip or bottom nav)
├── → /publish/[id] (via Schedule item)
├── → /settings (via Quick Action → Settings)
```
---
## 17. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Cold start network fail | No connectivity at launch | Cached data shown (if available) + "📡 Ngoại tuyến" banner | Pull-to-refresh when online |
| API error (5xx) | Server failure | Toast: "Không tải được dữ liệu. Kéo xuống để thử lại." | Pull-to-refresh |
| Partial API failure | Some endpoints fail | Failed sections show inline "Không tải được. [Thử lại]" + other sections intact | Per-section retry |
| Auth expired | 401 | Redirect to login screen | Re-authenticate |
| Workspace not found | Deleted/removed workspace | Toast: "Workspace không còn tồn tại. Chuyển sang workspace khác." | Auto-switch to first available |
| SSE disconnected | WebSocket drop | "🔄 Đang kết nối lại..." indicator in app bar | Auto-reconnect with backoff |
| Platform token expired | OAuth token invalid | Red dot on platform + banner: "🔴 [Platform] ngắt kết nối. [Kết nối lại →]" | Tap → re-auth flow |

---
## 18. Accessibility

| Element | Requirement |
|---|---|
| KPI cards | `Semantics(label: "Doanh thu hôm nay: 2 triệu 4 trăm nghìn đồng, tăng 15 phần trăm")` |
| Alert carousel | `Semantics(liveRegion: true)` + announce alert count on page load |
| Smart alert cards | Full label: severity + message + action hint |
| Pipeline chips | `Semantics(label: "Ý tưởng: 5 mục, chạm để xem danh sách")` |
| Schedule rows | `Semantics(label: "18 giờ, 5 tips nấu ăn, TikTok, trạng thái sẵn sàng")` |
| Quick actions | Minimum 48×48dp tap targets with descriptive labels |
| Bottom nav | `Semantics(selected:)` on active tab, badge announced |
| Status dots | `Semantics(label: "TikTok: kết nối tốt")` — not color-only |
| Pull-to-refresh | Announce "Đang tải lại dữ liệu" on activation |
| Contrast | All text meets WCAG 2.1 AA (4.5:1 ratio), dark mode included |

---
## 19. Localization Notes

- Primary language: Vietnamese
- Currency: VND (no decimals, dot separator: "2.400.000")
- Compact format: "2.4M" for dashboard, full format in detail
- Date: DD/MM/YYYY
- Day names: "Thứ 2" through "Chủ nhật"
- Time: 24h format ("18:00")
- Numbers: dot separator (1.234)
- Relative time: "2 phút trước", "1 giờ trước", "Hôm qua"
- Tone: Friendly, conversational, action-oriented

---
## 20. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-accent` | Primary CTAs, active tab, trend scores |
| `--color-success` | Positive KPI trends (↑), healthy platform status (🟢) |
| `--color-warning` | Warning alerts (🟡), degraded status, token expiring |
| `--color-danger` | Critical alerts (🔴), failed/disconnected, out-of-stock |
| `--color-surface-elevated` | KPI cards, alert cards, schedule cards |
| `--color-surface-primary` | Page background |
| `--color-text-primary` | KPI values, titles |
| `--color-text-secondary` | Labels, timestamps, descriptions |
| `--font-metric` | KPI numbers (tabular-nums for alignment) |

---
## 21. Related Screens

| Screen | Relationship |
|---|---|
| [W001] Web Home Dashboard | Web equivalent (3-column grid layout) |
| [M002] Mobile Notifications | Notification list (🔔 bell) |
| [M019] Mobile Inbox | Bottom nav → Inbox |
| [M008] Mobile Idea Board | Pipeline → Ideas |
| [M035] Mobile Analytics | Bottom nav → Analytics / KPI tap |
| [M017] Mobile Trend List | AI Pulse → trends |
| [M013] Mobile Studio Launcher | Bottom nav → Studio |
| [M027] Mobile Orders | Order KPI → orders |
| [M041] Mobile Finance Summary | Revenue KPI → finance |
| [M060] Mobile Copilot | Quick Action → Copilot |

---
## 22. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 3.0 | **Structure fix**: Removed duplicate template placeholder sections (§6/§11/§12/§13/§16/§18) that contradicted detailed custom content. Renumbered to 22-point sequential structure. Added detailed Error Handling with 7 specific cases, enhanced Accessibility with semantic labels, expanded Localization notes with formatting rules. | System |
| 2026-03-28 | 2.0 | **Major revision**: Full Tier A rewrite from 259-line Tier B. Added complete structure with Smart Alert carousel, adaptive KPI grid, gestures/haptics/greeting logic, offline strategy, Flutter implementation. | System |
| 2026-03-27 | 1.0 | Initial specification | System |
