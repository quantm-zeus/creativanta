# Screen: Web — Live Session Planner

> **Screen ID**: W107
> **Module**: M17 — Live Commerce War Room
> **Route**: `/live/plan`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 05, PRD §23.17, A1 Schema (live_sessions, live_cue_cards, live_products, live_highlights), B5 RBAC §2.7

---

## 1. Purpose & Context

Plan and manage live selling sessions — view upcoming, active, and past sessions with quick access to setup, war room, and post-live analytics. The planner follows the PRD live commerce flow: **Plan → Setup → War Room → Post-Live Summary**.

### User Goals
- Schedule upcoming live sessions with product lineup and cue cards
- Enter the War Room when a session starts
- Review post-live performance summaries
- Compare session performance over time

### Business Goals
- Structure live selling operations for consistency
- Track live commerce contribution to total revenue
- Optimize timing, product selection, and cue card effectiveness
- Enable quick re-scheduling from past templates

### Entry Points
- Sidebar: "🔴 Live Commerce"
- Home Dashboard: "Next live session in X hours" card
- Notification: "Live session starting in 30 minutes"
- Calendar (W054): Live session event

### Exit Points
- "→ Prepare" → Live Setup (W108) for session preparation
- "→ War Room" → Live War Room (W109) during active session
- "📊 Post-Live Summary" → Post-Live Summary (W110)
- "+ Tạo phiên live" → Create session flow

---

## 2. Preconditions / Postconditions

### Preconditions
- User has `live_session:manage` permission (Owner, Admin, Manager)
- At least one platform connector supports live (TikTok Live, Shopee Live)

### Postconditions
- Created sessions have status "planned" and appear in calendar
- Starting a session transitions status to "live" and opens War Room
- Ended sessions transition to "completed" and trigger post-live analytics generation

---

## 3. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 🔴 Live Commerce                        [+ Tạo phiên live]         │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Summary Bar ─────────────────────────────────────────────────┐   │
│ │ 📅 1 upcoming · 🔴 0 live now · ✅ 12 completed this month  │   │
│ │ Revenue (30d): 85M VND from live · Avg orders/session: 65    │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ── 🔴 Active Session (if any) ──────────────────────────────────     │
│ ┌─ Live Now Card (red border, pulsing) ──────────────────────────┐  │
│ │ 🔴 LIVE NOW — "Flash Sale Friday"         Duration: 45m       │  │
│ │ Platform: TikTok Live · Viewers: 1,234 · Orders: 23 · 4.5M   │  │
│ │ [→ ENTER WAR ROOM >>>]                                        │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ── 📅 Upcoming Sessions ─────────────────────────────────────────    │
│ ┌─ Session Card ─────────────────────────────────────────────────┐  │
│ │ 📅 "Spring Sale Live — Skincare Edition"    Tối nay 19:00     │  │
│ │ Platform: 🎵 TikTok Live · Planned duration: 2h               │  │
│ │ Products: 8 items · Cue cards: 12 · Offers: 3 active          │  │
│ │ Countdown: Bắt đầu trong 5 giờ 23 phút                       │  │
│ │                                                                  │  │
│ │ Preparation checklist:                                           │  │
│ │ ☑ Product list finalized · ☑ Cue cards created                 │  │
│ │ ☐ Offers configured · ☐ Run-of-show reviewed                  │  │
│ │                                                                  │  │
│ │ [📋 Chuẩn bị] [→ War Room] [✏️ Chỉnh sửa] [📋 Duplicate]   │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ── ✅ Past Sessions (This Month) ────────────────────────────────    │
│ ┌─ Past Session Row ─────────────────────────────────────────────┐  │
│ │ ✅ "Beauty Weekend" · 26/3 · 1h45m                             │  │
│ │ 👁 1.8K peak viewers · 🛒 78 orders · 💰 18.5M VND           │  │
│ │ Highlights: 5 clips created · Best product: Serum VitC (30 sold)│ │
│ │ [📊 Post-Live Summary] [📋 Duplicate Session]                 │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Past Session Row ─────────────────────────────────────────────┐  │
│ │ ✅ "Mid-Week Quick" · 23/3 · 45m                               │  │
│ │ 👁 800 peak · 🛒 32 orders · 💰 6.2M                          │  │
│ │ [📊 Post-Live Summary] [📋 Duplicate]                         │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ [📅 Xem lịch sử đầy đủ →]                                         │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
LivePlannerPage
├── AppShell (shared)
├── PageHeader
│   ├── PageTitle ("🔴 Live Commerce")
│   └── CreateButton ("+ Tạo phiên live", primary CTA)
├── SummaryBar
│   ├── UpcomingCount
│   ├── LiveNowCount
│   ├── CompletedCount (this month)
│   ├── LiveRevenue (30d)
│   └── AvgOrdersPerSession
├── ActiveSessionCard (conditional — only if session is live)
│   ├── LiveBadge (pulsing red dot)
│   ├── SessionTitle
│   ├── Duration (elapsed)
│   ├── LiveMetrics (viewers, orders, revenue — real-time)
│   └── EnterWarRoomButton (primary, attention-grabbing)
├── UpcomingSection
│   └── UpcomingSessionCard[]
│       ├── SessionTitle
│       ├── ScheduledTime
│       ├── PlatformBadge
│       ├── PlannedDuration
│       ├── ProductCount + CueCardCount + OfferCount
│       ├── CountdownTimer
│       ├── PreparationChecklist (mini — key items)
│       └── ActionBar
│           ├── PrepareButton ("📋 Chuẩn bị" → W108)
│           ├── WarRoomButton ("→ War Room" → W109)
│           ├── EditButton
│           └── DuplicateButton
├── PastSessionsSection
│   └── PastSessionRow[]
│       ├── SessionTitle + Date
│       ├── Duration
│       ├── PeakViewers
│       ├── OrderCount
│       ├── Revenue
│       ├── HighlightsSnippet
│       └── ActionBar
│           ├── SummaryButton ("📊 Post-Live Summary" → W110)
│           └── DuplicateButton
└── FullHistoryLink
```

---

## 5. Displayed Data

| Field | Source | Format |
|---|---|---|
| Session title | `live_sessions.title` | String |
| Scheduled time | `live_sessions.scheduled_at` | "Tối nay 19:00" or "28/3 14:00" |
| Platform | `live_sessions.platform` | Platform icon + name |
| Duration | `live_sessions.planned_duration` or actual elapsed | "2h" or "1h45m" |
| Product count | `live_products WHERE session_id` count | "8 items" |
| Cue card count | `live_cue_cards WHERE session_id` count | "12" |
| Offer count | Active offers linked to session | "3 active" |
| Peak viewers | `live_sessions.peak_viewers` | "1.8K" |
| Orders (live) | `orders WHERE live_session_id` count | "78" |
| Revenue (live) | `orders WHERE live_session_id` sum | VND "18.5M" |
| Highlights | `live_highlights WHERE session_id` count | "5 clips created" |
| Preparation status | Computed from checklist items | ☑/☐ indicators |

---

## 6. User Actions

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Create session | "+ Tạo phiên live" | — | → Create session modal/page | `live_session:manage` |
| 2 | Prepare | "📋 Chuẩn bị" | — | → W108 Live Setup | `live_session:manage` |
| 3 | Enter War Room | "→ War Room" | `LiveService/StartSession` (if starting) | → W109 War Room | `live_session:manage` |
| 4 | Edit session | "✏️" | — | → Edit modal with pre-filled data | `live_session:manage` |
| 5 | Duplicate | "📋 Duplicate" | `LiveService/DuplicateSession` | New draft session pre-filled | `live_session:manage` |
| 6 | View post-live | "📊 Post-Live Summary" | — | → W110 Post-Live Summary | `live_session:manage` |
| 7 | Delete session | ⋮ → "Xóa" → confirm | `LiveService/DeleteSession` | Confirmation → removed | `live_session:manage` |

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial fetch | Section skeletons |
| LOADED | Data received | Full planner with sections |
| EMPTY | No sessions ever | "Chưa có phiên live nào. Bắt đầu live selling bằng cách tạo phiên đầu tiên! [+ Tạo phiên live]" |
| LIVE_NOW | Active session exists | Red pulsing Active Session card at top with real-time metrics |
| UPCOMING_SOON | Session within 1 hour | Orange countdown card with urgency styling |
| NO_CONNECTOR | No live-capable platform connected | "Kết nối TikTok Live hoặc Shopee Live để bắt đầu live selling. [→ Connectors]" |

---

## 8. Permissions

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer |
|---|---|---|---|---|---|---|
| View planner | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Create session | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Edit session | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Enter War Room | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| View past summaries | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| View revenue | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |

---

## 9. Create Session Modal

```
┌─ Tạo phiên live mới ──────────────────────────────────────┐
│ Tên phiên: [Flash Sale Friday                         ]    │
│ Platform:  [🎵 TikTok Live ▾]                             │
│ Ngày giờ:  [28/3/2026] [19:00]                            │
│ Thời lượng dự kiến: [2 giờ ▾]                             │
│ Sản phẩm:  [+ Chọn sản phẩm] (min 1)                    │
│ Ghi chú:   [Optional notes                           ]    │
│ [Hủy]                                    [Tạo phiên ✓]   │
└────────────────────────────────────────────────────────────┘
```

---

## 10. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached session data | Retry online |
| Session create fail | API error | Toast: "Không tạo được phiên live. [Thử lại]" | Retry |
| Duplicate fail | API error | Toast: "Không duplicate được. [Thử lại]" | Retry |
| Platform unreachable | Live platform API error | Alert: "⚠️ {platform} không khả dụng. Kiểm tra kết nối." | Reconnect |
| Start session fail | Platform can't start live | Alert: "Không bắt đầu được live. Kiểm tra {platform}." | Re-check setup |

---

## 11. Accessibility

| Element | Requirement |
|---|---|
| Live now card | `role="alert"`, `aria-label="Live now: {title}, {viewers} viewers, {duration}"` |
| Countdown timer | `role="timer"`, `aria-label="Session starts in {time}"` |
| Upcoming cards | `role="article"`, `aria-label="{title}, scheduled {datetime}"` |
| Preparation checklist | `role="list"`, items with `aria-checked` |
| Past session rows | `role="article"`, `aria-label="{title}, {date}, {revenue}"` |

---

## 12. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Summary bar + section skeletons |
| Summary stats | 100-300ms | Counts populate |
| Active session | 200-500ms | Live card appears with real-time data |
| Upcoming | 300-600ms | Cards stagger with countdown |
| Past sessions | 500-800ms | Rows populate with metrics |

---

## 13. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `live.planner_viewed` | Page load | `upcoming_count`, `completed_month`, `live_revenue_30d` |
| `live.session_created` | "+ Tạo phiên live" confirmed | `platform`, `scheduled_at`, `product_count` |
| `live.session_edited` | "✏️" saved | `session_id`, `changes` |
| `live.session_duplicated` | "📋 Duplicate" confirmed | `source_session_id` |
| `live.setup_started` | "📋 Chuẩn bị" clicked | `session_id`, `time_until_live` |
| `live.war_room_entered` | "→ War Room" clicked | `session_id`, `is_starting` |
| `live.post_live_viewed` | "📊 Post-Live" clicked | `session_id` |
| `live.session_deleted` | "Xóa" confirmed | `session_id` |

---

## 14. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/live/+page.svelte`
- **Server load**: `+page.server.ts` → `LiveService/ListSessions(workspace_id)` + `LiveService/GetLiveStats`
- **Active session**: SSE for real-time viewer/order updates → auto-refreshes every 5s
- **Countdown**: Client-side computed from `scheduled_at - now()`, updates every second
- **Create modal**: `LiveService/CreateSession(data)` → adds to calendar
- **Duplicate**: `LiveService/DuplicateSession(id)` → creates draft with same products/cue cards
- **Past sessions**: Cursor-paginated, lazy-loaded on scroll

---

## 15. Localization Notes

- Sections: "📅 Sắp tới", "🔴 Đang live", "✅ Đã hoàn thành"
- Countdown: "Bắt đầu trong 5 giờ 23 phút"
- Metrics: "Đỉnh điểm người xem", "Đơn hàng", "Doanh thu"
- Revenue: VND "18.5M" or "18.500.000đ"
- Tone: Energetic, action-oriented

---

## 16. Design Tokens

| Token | Usage |
|---|---|
| `--color-live-active` | 🔴 Live now pulsing indicator |
| `--color-live-upcoming` | 📅 Upcoming session card |
| `--color-live-completed` | ✅ Past session row |
| `--color-success` | Revenue, positive metrics |
| `--color-warning` | Countdown <1h urgency |
| `--color-danger` | Session issue alerts |
| `--color-accent` | Create CTA, War Room button |
| `--color-surface-elevated` | Session cards |
| `--font-metric` | Revenue, viewer counts (tabular-nums) |

---

## 17. Related Screens

| Screen | Relationship |
|---|---|
| [W108] Live Setup | Detailed session preparation |
| [W109] Live War Room | Real-time live selling control center |
| [W110] Post-Live Summary | Post-session analytics |
| [W054] Publish Calendar | Sessions shown in calendar |
| [M055] Mobile Live War Room | Mobile equivalent |

---

## 18. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 errors (session start, platform), session/countdown a11y, 8 analytics, SvelteKit impl (SSE real-time, countdown), localization, 9 design tokens (live-specific). | System |
| 2026-03-28 | 1.0 | Initial specification | System |
