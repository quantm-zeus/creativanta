# Screen: Mobile — Morning Brief

> **Screen ID**: M003
> **Module**: M01 — Home & Decision
> **Route**: `/morning-brief` (mobile)
> **Platform**: Mobile (Flutter)
> **Upstream**: Pack 01 §4, Product Freeze §6, A1 Schema (daily_briefs, metrics_daily), S009 Trust Badge, B5 RBAC §2.7

---

## 1. Purpose & Context

AI-generated daily briefing — a single-scroll page with collapsible card sections covering yesterday's performance, financial summary, trending topics, and priority action items. Delivered via push notification at 6:30 AM, this is the creator's "first look" of the day.

### User Goals
- Get a 30-second overview of yesterday's performance before checking each module
- Identify urgent action items requiring attention (refunds, urgent threads, failed publishes)
- Discover trending topics aligned with their niche
- Share the brief via email to team or stakeholders

### Business Goals
- Drive daily active engagement (morning brief → 70%+ DAU retention target)
- Reduce time-to-first-action by surfacing priority items
- Increase trend-to-idea conversion by embedding CTAs in trend section
- Build trust in AI through Trust Badge certification (§S009)

### When This Screen Is Used
- **Morning ritual**: Push notification at 6:30 AM → tap to read brief
- **Catch-up**: After being away for a day → review yesterday's brief
- **Team sharing**: Email brief to team for alignment

### Entry Points
- Push notification: "☀️ Morning brief sẵn sàng! 12 đơn mới, 3 video trending."
- Home Dashboard (M001): "☀️ Brief" widget card → tap
- Settings: Scheduled delivery preference

### Exit Points
- CTA links → relevant module screens (P&L, Trends, Scripts, Inbox, Diagnostics)
- "📧 Email" → send brief to team email
- "← Home" → back to dashboard

---

## 2. Preconditions / Postconditions

### Preconditions
- User has `report:read` permission (all roles except External)
- At least 1 day of workspace activity for meaningful brief
- AI brief generated (computed at 5:30 AM daily, cached)

### Postconditions
- Brief marked as read (`daily_briefs.read_at` updated)
- CTA navigation logged for AI quality improvement
- Email sent if user taps "📧 Email"

---

## 3. Screen Layout

### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Home   ☀️ Briefing 28/03                       [📧 Email] [⋮]    │
├──────────────────────────────────────────────────────────────────────┤
│ "Chào buổi sáng, Quân! 👋"                                          │
│                                                                      │
│ ┌─ 📊 Tóm tắt hiệu suất (collapsible, default open) ────────────┐ │
│ │ "Hôm qua: 12 đơn (+30%), 3 video >10K views.                   │ │
│ │  Lợi nhuận ước tính 2.1M VND." {🟢 Verified — Official Data}   │ │
│ │                                                                  │ │
│ │ 📈 Revenue: 5.2M ↑18%    📦 Đơn: 12 ↑30%                      │ │
│ │ 👁 Views: 45K ↑12%       💬 Comments: 234 ↑8%                   │ │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ 💰 Tài chính (collapsible, default open) ─────────────────────┐ │
│ │ Revenue: 5.2M ↑18% · Chi phí: 1.8M · Net: 3.4M (65% margin)   │ │
│ │ ⚠️ 2 refunds đang chờ (150K VND)                               │ │
│ │ [Xem P&L chi tiết →]                                             │ │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ 🔥 Xu hướng hôm nay (collapsible, default open) ──────────────┐│
│ │ 1. "AI cooking" 🎵 TikTok +340% ⭐87  [💡 Tạo ý tưởng →]     ││
│ │ 2. "Minimalist skincare" 📸 IG +180% ⭐82  [💡 Tạo ý tưởng →] ││
│ │ 3. "Budget haul" 🎵 TikTok +120% ⭐75                          ││
│ │ [Xem thêm xu hướng →]                                           ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ┌─ ✅ Hành động ưu tiên (collapsible, default open) ─────────────┐ │
│ │ 📝 Duyệt 3 script chờ phê duyệt [→ Scripts]                   │ │
│ │ 💬 5 thread VIP chưa trả lời (>4h) [→ Inbox]                   │ │
│ │ 📤 2 bài lên lịch hôm nay (19:00, 21:00) [→ Queue]            │ │
│ │ ⚠️ Shopee sync chậm 2h [→ Diagnostics]                         │ │
│ │ 💳 AI credits còn 8/100 [→ Billing]                             │ │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ 🧠 AI Insights (collapsible, default collapsed) ──────────────┐ │
│ │ "Video dạng Q&A có engagement cao nhất tuần qua (+45%).          │ │
│ │  Nên ưu tiên format Q&A cho nội dung TikTok."                   │ │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ Pull-to-refresh (regenerate brief)                                   │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                          │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
MorningBriefPage
├── AppBar
│   ├── BackButton ("← Home")
│   ├── Title ("☀️ Briefing" + date)
│   ├── EmailButton ("📧" → share brief via email)
│   └── MoreMenu ("⋮" → settings, regenerate, archive)
├── GreetingHeader ("Chào buổi sáng, {name}! 👋")
├── ScrollableContent (pull-to-refresh)
│   ├── PerformanceSummaryCard (collapsible)
│   │   ├── NarrativeText (AI-generated natural language summary)
│   │   ├── TrustBadge ("🟢 Verified — Official Data" per §S009)
│   │   └── MetricGrid (4 KPI cards: Revenue, Orders, Views, Comments)
│   │       └── MetricCard
│   │           ├── Icon
│   │           ├── Value
│   │           └── Trend (↑↓ + color)
│   ├── FinanceSummaryCard (collapsible)
│   │   ├── RevenueRow ("Revenue: 5.2M ↑18%")
│   │   ├── CostRow ("Chi phí: 1.8M")
│   │   ├── NetRow ("Net: 3.4M (65% margin)")
│   │   ├── RefundWarning (conditional — "⚠️ 2 refunds đang chờ")
│   │   └── PLDetailLink ("Xem P&L chi tiết →")
│   ├── TrendsSummaryCard (collapsible)
│   │   └── TrendRow[] (max 3, sorted by relevance score)
│   │       ├── TrendTitle
│   │       ├── PlatformBadge
│   │       ├── GrowthRate ("+340%")
│   │       ├── AIScore ("⭐87")
│   │       └── CreateIdeaCTA ("💡 Tạo ý tưởng →")
│   ├── ActionItemsCard (collapsible)
│   │   └── ActionRow[] (sorted by priority)
│   │       ├── ActionIcon (📝/💬/📤/⚠️/💳)
│   │       ├── ActionText
│   │       └── NavigationLink ("→ {module}")
│   └── AIInsightsCard (collapsible, default collapsed)
│       └── InsightText (AI strategic recommendation)
└── BottomNavBar
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Brief content | `daily_briefs WHERE date=yesterday` | `BriefService/GetMorningBrief(date)` | Pre-computed narrative sections | Until next brief |
| Performance KPIs | `metrics_daily` aggregation | Included in brief | Value + trend arrow + percentage | Until next brief |
| Finance summary | `revenue_daily`, `cost_daily` | Included in brief | "5.2M ↑18%", margin percentage | Until next brief |
| Refund alerts | `orders WHERE status='refund_pending'` | Included in brief | Count + total VND | Real-time check |
| Trends | `trends` filtered by relevance | Included in brief | Top 3 with growth + AI score | Until next brief |
| Action items | Multi-source aggregation | Included in brief | Priority-ordered list | Until next brief |
| AI insights | AI strategic analysis | Included in brief | Natural language paragraph | Until next brief |
| Trust badge | §S009 verification | Included in brief | "🟢 Verified" or "⚠️ Estimated" | Static |

---

## 6. Actions Table

| # | Action | Trigger | Type | API Call | System Response | Permission |
|---|---|---|---|---|---|---|
| 1 | Toggle section | Tap section header | UI | — | Section expands/collapses with animation | Any |
| 2 | Navigate to P&L | "Xem P&L →" CTA | Navigate | — | Push → Finance P&L (M050) | `profit:read` |
| 3 | Create idea from trend | "💡 Tạo ý tưởng →" | Navigate | `IdeaService/CreateFromTrend(trend_id)` | Idea created → push to Idea Board (M017) | `idea:create` |
| 4 | View more trends | "Xem thêm xu hướng →" | Navigate | — | Push → Trend List (M014) | `trend:read` |
| 5 | Navigate to action item | Tap action row CTA | Navigate | — | Push → respective module screen | Varies |
| 6 | Email brief | Tap "📧" | Action | `BriefService/EmailBrief(date, email)` | Bottom sheet: "Gửi đến email?" → Toast "📧 Đã gửi!" | `report:read` |
| 7 | Pull refresh | Pull-down | Refresh | `BriefService/RegenerateBrief(date)` | Brief re-generated with latest data. 2-3s delay. | `report:read` |
| 8 | View brief settings | ⋮ → "Cài đặt" | Navigate | — | Push → Brief settings (push time, sections, recipients) | `report:read` |

---

## 7. States

| State | Condition | Visual | User Action |
|---|---|---|---|
| LOADING | Generating/fetching brief | "🤖 Đang phân tích dữ liệu..." + shimmer cards | Wait |
| LOADED | Brief ready | 4 collapsible sections with data | Read and navigate |
| NO_DATA | No activity yesterday | "😴 Hôm qua không có hoạt động. Kết nối platform để AI theo dõi!" | Connect platforms |
| PARTIAL | Some data sources unavailable | Brief shows available data + "⚠️ Dữ liệu {source} tạm thời không khả dụng" | View partial |
| REFRESHING | Pull-to-refresh | Refresh indicator + "🤖 Đang tạo lại brief..." | Wait |
| ERROR | Brief generation failed | "Không tạo được brief hôm nay. [Thử lại]" | Retry |
| OFFLINE | No network | Cached brief (if available) or "📡 Ngoại tuyến" | View cached |

---

## 8. Permissions & Role-based Behavior

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View brief | ✅ | ✅ | ✅ | ✅ | ✅ (limited) | ✅ (limited) | ❌ |
| Finance section | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Email brief | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Create idea from trend | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Regenerate brief | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |

### Visibility Rules
- **Editor/Contributor**: Finance section hidden. Performance and action items scoped to own content.
- **Viewer**: Read-only. No CTAs except "Xem thêm →" links to allowed screens.

---

## 9. Mobile-specific UX

### Collapsible Sections
- Default: all sections expanded on first view
- Tap header → smooth collapse/expand animation (300ms)
- Section state persisted per session (not long-term)
- Chevron icon rotates on toggle

### Push Notification Integration
- 6:30 AM daily: "☀️ Morning brief: 12 đơn, 3 video trending. [Xem →]"
- Tap → deep link to `/morning-brief`
- If brief not yet generated (edge case) → show LOADING state

### Offline Behavior
- **Available offline**: Last cached brief (if viewed previously)
- **Not available**: Regenerate, email, CTA navigation to server-dependent screens
- Banner: "📡 Ngoại tuyến — đang hiển thị brief đã lưu"

---

## 10. Edge Cases

| Edge Case | Handling |
|---|---|
| First day (no data) | "🎉 Chào mừng! Brief sẽ bắt đầu từ ngày mai khi có dữ liệu." |
| Platform disconnect | Affected metrics show "⚠️" with "Dữ liệu {platform} chưa khả dụng" |
| Revenue = 0 yesterday | "Revenue: 0 VND" (not hidden — transparent) |
| >10 action items | Show top 5 by priority + "Xem thêm {n} hành động →" |
| Brief generation timeout | Show partial brief with available data + retry CTA |
| Weekend/holiday | Brief still generated but notes "📅 Cuối tuần — hoạt động thường thấp hơn" |

---

## 11. Navigation Map

```
Morning Brief (/morning-brief)
├── ← /home (back → M001 Home Dashboard)
├── → /finance/pnl (Xem P&L → Finance P&L)
├── → /intelligence/trends/[id] (Tạo ý tưởng → creates idea + opens board)
├── → /intelligence/trends (Xem thêm xu hướng)
├── → /scripts (Duyệt scripts → Script List)
├── → /inbox?filter=urgent (Thread VIP → Inbox filtered)
├── → /publish (Bài lên lịch → Publish Queue)
├── → /diagnostics (Platform sync issue → Diagnostics)
├── → /settings/billing (AI credits → Billing)
```

---

## 12. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `brief.viewed` | Page load | `source` (push/home/manual), `brief_date`, `sections_count` |
| `brief.section_toggled` | Section expanded/collapsed | `section_name`, `action` (expand/collapse) |
| `brief.cta_clicked` | Any CTA tapped | `section`, `cta_type` (trend_idea/pnl/inbox/etc), `item_id` |
| `brief.emailed` | Email sent | `recipient_count` |
| `brief.regenerated` | Pull-to-refresh | `previous_brief_age_hours` |
| `brief.push_opened` | Opened from push notification | `notification_sent_at`, `open_delay_minutes` |

---

## 13. Performance Requirements

| Metric | Target |
|---|---|
| Screen render | <1s (brief is pre-computed) |
| Section toggle animation | <300ms |
| Brief regeneration | <5s |
| Push → screen load | <2s |

---

## 14. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Show cached brief or "📡 Ngoại tuyến" | Pull-to-refresh when online |
| Brief generation failed | AI service error | "Không tạo được brief. [Thử lại]" | Retry |
| Partial data | Some sources failed | Brief shows available data + "⚠️" per affected section | Auto-resolves next day |
| Email failed | SMTP error | Toast: "Gửi email thất bại. [Thử lại]" | Retry |

---

## 15. Accessibility

| Element | Requirement |
|---|---|
| Greeting | `Semantics(header: true, label: "Chào buổi sáng Quân")` |
| Section headers | `Semantics(header: true, button: true, label: "Tóm tắt hiệu suất, mở rộng")` |
| Trust badge | `Semantics(label: "Dữ liệu chính thức, đã xác minh")` |
| KPI values | `Semantics(label: "Doanh thu 5.2 triệu, tăng 18 phần trăm")` |
| Action items | `Semantics(label: "Duyệt 3 script chờ phê duyệt, tap để đi đến scripts")` |
| Trend CTAs | `Semantics(button: true, label: "Tạo ý tưởng từ xu hướng AI cooking")` |

---

## 16. Localization Notes

- Primary language: Vietnamese
- Greeting: Time-based ("Chào buổi sáng!", "Chào buổi chiều!" if opened later)
- Currency: VND abbreviated ("5.2M VND", "1.8M")
- Percentages: "↑18%", "↓5%"
- Date header: "Briefing DD/MM"
- Trust badge: "Dữ liệu chính thức" / "Dữ liệu ước tính"
- Tone: Warm, encouraging, actionable

---

## 17. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-morning-gradient` | Background gradient (dawn amber → light) |
| `--color-accent` | CTA links, trend scores |
| `--color-success` | Positive trends (↑), trust badge verified |
| `--color-warning` | Refund alerts, platform sync warnings |
| `--color-danger` | Negative trends (↓), urgent action items |
| `--color-surface-elevated` | Collapsible section cards |
| `--color-text-primary` | Section text |
| `--color-text-secondary` | Timestamps, secondary metrics |

---

## 18. Related Screens

| Screen | Relationship |
|---|---|
| [W009] Web Morning Brief | Web equivalent (side panel) |
| [M001] Mobile Home Dashboard | Entry point via brief widget |
| [M041] Mobile Finance Summary | P&L CTA destination |
| [M017] Mobile Trend List | Trends CTA destination |

---

## 19. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 2.0 | **Full Tier A rewrite** from 216-line Tier C. Added 19-section structure: AI insights card, trust badge integration (§S009), expanded wireframe with 5 collapsible sections, full component hierarchy, specific data binding (8 fields), 8 user actions, 7 states, full RBAC matrix with finance gating, mobile UX with push integration/offline, 6 edge cases, navigation map (9 destinations), 6 tracking events, performance targets, error handling, accessibility with Vietnamese labels, localization, design tokens. Replaced ALL template placeholders. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
