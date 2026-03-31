# Screen: Web — Post-Live Summary

> **Screen ID**: W110
> **Module**: M17 — Live Commerce War Room
> **Route**: `/live/[id]/summary`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 05, PRD §23.17, A1 Schema (live_sessions, live_orders, live_chat_analytics, live_highlights), B5 RBAC §2.7

---

## 1. Purpose & Context

Post-session analytics with AI-generated improvement suggestions — session KPIs, viewer engagement timeline, per-product performance, chat pattern analysis, and highlight clips. This is the "learn & improve" step of the Live Commerce flow: Plan → Setup → War Room → **Post-Live Summary**.

### User Goals
- Review session performance (revenue, orders, viewers)
- Understand viewer behavior timeline (when they joined, when they bought)
- Identify best-performing products and peak moments
- Get AI-powered suggestions for improving next session

### Business Goals
- Track live commerce channel ROI
- Optimize session timing, product order, and flash sale placement
- Build a knowledge base of what works in live selling
- Enable session-to-session comparison for continuous improvement

### Entry Points
- Live Planner (W107): "📊 Post-Live Summary" on completed sessions
- Notification: "Post-Live Summary ready for {session_name}"
- Live War Room (W109): auto-redirect after session ends
- Sidebar: Live Commerce → past sessions → summary

### Exit Points
- "📋 Duplicate session" → Live Planner (W107) with pre-filled data
- "→ Source content" → Highlight clips in Asset Manager
- "← Live" → Live Planner

---

## 2. Preconditions / Postconditions

### Preconditions
- Live session completed (status: "completed")
- Analytics job has finished processing (usually 5-15 min post-session)
- User has `live_session:manage` permission

### Postconditions
- Export creates shareable PDF report
- AI insights stored for cross-session optimization

---

## 3. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Live   📊 Post-Live: "Spring Sale"          [📥 Export Report]   │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Session KPIs ────────────────────────────────────────────────┐   │
│ │ ⏱ Duration: 1h 45m │ 👁 Peak viewers: 1,890 │ Avg: 1,120    │   │
│ │ 📦 78 orders │ 💰 Revenue: 18.5M VND │ Conv rate: 6.3%      │   │
│ │ 💬 1,234 chat messages │ 🛒 Cart/viewer: 0.8                 │   │
│ │ vs Previous: Revenue ↑25% · Orders ↑18% · Viewers ↑12%      │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Viewer & Order Timeline ─────────────────────────────────────┐   │
│ │ [Dual Y-axis chart: viewer count (area) + orders (bar)]        │   │
│ │                                                                  │   │
│ │  1,890 ┤          ╭──╮                                         │   │
│ │        │       ╭──╯  │  ╭──╮                                   │   │
│ │  1,200 ┤    ╭──╯     ╰──╯  ╰──╮                               │   │
│ │        │ ╭──╯                   ╰──╮                           │   │
│ │    600 ┤─╯                         ╰──╮                       │   │
│ │        │                               ╰──                     │   │
│ │        ├───┼────┼────┼────┼────┼────┼────┤                    │   │
│ │       0:00 0:15 0:30 0:45 1:00 1:15 1:30 1:45                 │   │
│ │                                                                  │   │
│ │ Markers: 🔥 Flash Sale (0:45) · 📦 Order cluster (0:25, 0:50)│   │
│ │ 🎤 Product demo (0:15) · 📣 Q&A Session (1:15)               │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ Tabs: [📊 Performance] [📦 Products] [💬 Chat] [💡 AI Insights]  │
│                                                                      │
│ ── 📦 Products ──────────────────────────────────────────────────    │
│ ┌─ Product Performance Table ───────────────────────────────────┐   │
│ │ # │ Product     │ Orders │ Revenue│ Peak time   │ Conv rate  │   │
│ │ 1 │ Serum VitC  │ 34     │ 8.5M   │ 0:15-0:25  │ 8.2%      │   │
│ │ 2 │ Combo set   │ 22     │ 5.8M   │ 0:45 (flash)│ 12.1%    │   │
│ │ 3 │ Toner AHA   │ 12     │ 2.4M   │ 1:00-1:10  │ 3.5%      │   │
│ │ 4 │ Sunscreen   │ 10     │ 1.8M   │ 1:20-1:30  │ 2.8%      │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ── 💬 Chat Analytics ────────────────────────────────────────────    │
│ ┌─ Chat Insights ───────────────────────────────────────────────┐   │
│ │ 💬 Total messages: 1,234 · Active chatters: 312               │   │
│ │ 🏷 Top intents: Price inquiry (34%) · Product Q (28%) · Hype (22%)│
│ │ 🔥 Peak chat: 0:45 (flash sale) · 156 msg/min                │   │
│ │ ❓ Unanswered questions: 45 (18%)                              │   │
│ │ 📊 Sentiment: 🟢 Positive 68% · 🟡 Neutral 24% · 🔴 Neg 8% │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ── 💡 AI Insights ────────────────────────────────────────────────   │
│ ┌─ Improvement Suggestions ─────────────────────────────────────┐   │
│ │ 💡 "Flash sale tạo viewer spike +58% & order spike +340%      │   │
│ │    → Thử 2 flash sales/session thay vì 1"                     │   │
│ │ 💡 "34% tin nhắn hỏi giá → Pin giá ngay đầu session"         │   │
│ │ 💡 "Combo demo → AOV ↑25%. Tăng thời lượng demo 5→10 min"    │   │
│ │ 💡 "Viewers ↓30% sau 1h15 → Rút duration xuống 1h30 max"     │   │
│ │ 💡 "18% questions unanswered → Cần 1 người hỗ trợ chat"      │   │
│ │                                                                │   │
│ │ Session score: ⭐⭐⭐⭐ (4/5) — "Excellent conversion, room     │   │
│ │ to improve viewer retention"                                   │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ── 🎬 Highlight Clips (auto-generated) ──────────────────────────   │
│ ┌─ Highlights ──────────────────────────────────────────────────┐   │
│ │ [Thumb] Flash Sale moment (0:45-0:48) · [📤 Share] [✏ Edit]  │   │
│ │ [Thumb] Best product demo (0:15-0:22) · [📤 Share] [✏ Edit]  │   │
│ │ [Thumb] Viewer peak (0:40-0:42) · [📤 Share] [✏ Edit]        │   │
│ │ [+ Extract more clips]                                         │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ [📋 Duplicate session for next live] [📥 Export Full Report]        │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
PostLiveSummaryPage
├── AppShell (shared)
├── PageHeader
│   ├── BackLink ("← Live")
│   ├── PageTitle ("📊 Post-Live: {session_name}")
│   └── ExportButton
├── SessionKPIs
│   ├── Duration
│   ├── PeakViewers + AvgViewers
│   ├── OrderCount
│   ├── Revenue
│   ├── ConversionRate
│   ├── ChatMessages
│   ├── CartPerViewer
│   └── PreviousSessionComparison (↑↓ per metric)
├── ViewerOrderTimeline
│   ├── DualAxisChart (viewers area + orders bar)
│   ├── EventMarkers[] (flash sales, demos, Q&A)
│   └── PeakAnnotations
├── AnalysisTabs
│   ├── PerformanceTab (overview)
│   ├── ProductsTab
│   │   └── ProductPerformanceTable
│   │       └── ProductRow[] (product, orders, revenue, peak_time, conv_rate)
│   ├── ChatTab
│   │   ├── ChatSummary (total msgs, active chatters)
│   │   ├── IntentBreakdown (pie chart)
│   │   ├── PeakChatMoment
│   │   ├── UnansweredQuestions
│   │   └── SentimentBreakdown
│   └── AIInsightsTab
│       ├── SuggestionCard[] (insight + action)
│       └── SessionScore (1-5 stars + summary)
├── HighlightClips
│   └── ClipCard[]
│       ├── Thumbnail + timestamp range
│       ├── ShareButton
│       └── EditButton
├── ActionBar
│   ├── DuplicateSessionButton
│   └── ExportFullReportButton
```

---

## 5. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching analytics | KPI shimmer + chart skeleton |
| PROCESSING | Session ended, analytics generating | "⏳ Đang phân tích dữ liệu session... (~5 phút)" progress bar |
| LOADED | Analytics ready | Full post-live dashboard |
| LOW_DATA | Very short session (< 10 min) | Warning: "Session ngắn — metrics có thể không đại diện" |
| ERROR | Analytics job failed | Error with retry trigger |

---

## 6. Permissions

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer |
|---|---|---|---|---|---|---|
| View summary | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| View revenue | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Export report | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Share highlights | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Duplicate session | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |

---

## 7. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached summary | Retry online |
| Analytics processing | Job still running >15min | "⏳ Phân tích chưa hoàn tất. Quay lại sau vài phút." | Auto-poll |
| Export fail | PDF generation error | Toast: "Không tạo được báo cáo. [Thử lại]" | Retry |
| AI insights fail | AI generation error | Section: "💡 AI insights chưa sẵn sàng. [Thử lại]" | Retry |
| Chart render fail | Data malformed | Fallback: table view of data | N/A |

---

## 8. Accessibility

| Element | Requirement |
|---|---|
| KPI row | `role="status"`, each KPI with `aria-label="{metric}: {value}"` |
| Timeline chart | `role="img"`, `aria-label="Viewer and order timeline for {session}"` + data table fallback |
| Product table | `role="table"`, sortable headers with `aria-sort` |
| Analysis tabs | `role="tablist"`, `aria-selected` |
| AI suggestions | `role="list"`, items with `aria-label="Suggestion: {summary}"` |

---

## 9. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | KPI shimmer + chart skeleton |
| KPIs | 200-400ms | Numbers animate with trend arrows |
| Timeline chart | 500-1000ms | Chart renders with event markers |
| Product table | 300-600ms | Rows populate |
| Chat analytics | 300-600ms | Stats + sentiment populate |
| AI insights | 1-3s | Suggestions appear |
| Highlights | 500-1000ms | Thumbnails lazy-load |

---

## 10. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `live.summary_viewed` | Page load | `session_id`, `revenue`, `orders`, `peak_viewers` |
| `live.tab_switched` | Tab change | `tab` (performance/products/chat/insights) |
| `live.insight_opened` | AI suggestion expanded | `session_id`, `suggestion_idx` |
| `live.highlight_shared` | "📤 Share" on highlight | `session_id`, `clip_id` |
| `live.highlight_edited` | "✏ Edit" on highlight | `session_id`, `clip_id` |
| `live.report_exported` | "📥 Export Full Report" | `session_id`, `format` |
| `live.session_duplicated` | "📋 Duplicate" | `session_id` |
| `live.comparison_viewed` | "vs Previous" comparison | `session_id`, `previous_id` |

---

## 11. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/live/[id]/summary/+page.svelte`
- **Server load**: `+page.server.ts` → `LiveAnalyticsService/GetSummary(session_id)` → KPIs, timeline, products, chat, AI insights
- **Processing state**: Polls `LiveAnalyticsService/GetStatus(session_id)` every 10s until "ready"
- **Timeline chart**: Chart.js with dual Y-axes (viewers area + orders bar) + event markers
- **Product table**: Sortable by orders, revenue, conv rate
- **Chat analytics**: Server-side NLP: intent classification, sentiment analysis
- **AI insights**: `AIService/GenerateLiveInsights(session_id)` → cached after first generation
- **Highlights**: Auto-generated during session via peak detection → extractable clips
- **Export**: Server-side PDF with charts as canvas images

---

## 12. Localization Notes

- KPIs: "Thời lượng", "Người xem đỉnh điểm", "Đơn hàng", "Doanh thu"
- Comparison: "vs Phiên trước: Doanh thu ↑25%"
- Chat: "Tin nhắn", "Người chat tích cực", "Câu hỏi chưa trả lời"
- Sentiment: "🟢 Tích cực", "🟡 Trung lập", "🔴 Tiêu cực"
- Tone: Analytical, improvement-oriented

---

## 13. Design Tokens

| Token | Usage |
|---|---|
| `--color-live-kpi-positive` | ↑ positive trends |
| `--color-live-kpi-negative` | ↓ negative trends |
| `--color-chart-viewers` | Viewer area fill |
| `--color-chart-orders` | Order bar fill |
| `--color-sentiment-positive` | 🟢 Positive |
| `--color-sentiment-negative` | 🔴 Negative |
| `--color-accent` | Export CTA, share |
| `--color-surface-elevated` | Section cards |
| `--font-metric` | KPI numbers (tabular-nums) |

---

## 14. Related Screens

| Screen | Relationship |
|---|---|
| [W107] Live Planner | Session list |
| [W109] Live War Room | Real-time control center (previous step) |
| [W108] Live Setup | Session preparation |
| [M058] Mobile Post-Live | Mobile equivalent |

---

## 15. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 errors (analytics processing, chart render), chart/table a11y, 8 analytics, SvelteKit impl (Chart.js, AI insights), localization, 9 design tokens (chart+sentiment). | System |
| 2026-03-28 | 1.0 | Initial specification | System |
