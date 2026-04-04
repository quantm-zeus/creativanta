# Screen: Web — Performance Coach

> **Screen ID**: W077
> **Module**: M23 — Analytics & Reporting
> **Route**: `/performance`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 02 §Analytics, PRD §23.23, A1 Schema (performance_reports, content_items, engagement_metrics), B5 RBAC §2.7

---

## 1. Purpose & Context

AI-powered content coaching — weekly report card with overall grade, post-by-post performance insights, strengths/weaknesses analysis, and strategic recommendations for content improvement. This is the "learn" feedback loop in the Trend-to-Profit pipeline.

### User Goals
- Get an actionable weekly performance summary (not just raw numbers)
- Understand what worked and what didn't for each piece of content
- Receive AI-generated strategy suggestions backed by data
- Track improvement week-over-week through grades and scores

### Business Goals
- Drive content quality improvement through data-driven coaching
- Increase engagement and conversion rates over time
- Reduce content production waste (stop repeating ineffective formats)
- Gamify improvement with grades and streaks

### Entry Points
- Sidebar: "🏆 Performance Coach"
- Home Dashboard: "Weekly report card ready" notification card
- Notification: "Your weekly performance report is ready"
- Copilot: "Nội dung nào perform tốt nhất tuần này?"

### Exit Points
- Click content → Content detail / analytics
- "→ Try suggestion" → relevant creation screen
- "📊 Full analytics" → Analytics Dashboard (W074)

---

## 2. Preconditions / Postconditions

### Preconditions
- User has published content (at least 1 piece with analytics)
- Performance report generated (weekly cron, usually Monday 6AM)

### Postconditions
- No data mutations (analytics view only)
- AI suggestions logged for weekly comparison tracking

---

## 3. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 🏆 Performance Coach                   [Week: 13 ▾] [📥 Export]    │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Weekly Report Card ──────────────────────────────────────────┐   │
│ │ 📅 Week 13 — Mar 24-30, 2026                                  │   │
│ │ Overall Grade: B+ (↑ from B last week) 🎯                    │   │
│ │                                                                │   │
│ │ ┌──────────┬──────────┬──────────┬──────────┐                 │   │
│ │ │ 📊 Consistency │ ✨ Quality │ 📈 Growth │ 🎯 Strategy │   │   │
│ │ │ ⭐⭐⭐⭐☆    │ ⭐⭐⭐⭐⭐  │ ⭐⭐⭐☆☆  │ ⭐⭐⭐⭐☆   │   │   │
│ │ │ 5/7 days      │ Excellent │ Moderate  │ Good       │        │   │
│ │ └──────────┴──────────┴──────────┴──────────┘                 │   │
│ │                                                                │   │
│ │ 📊 Posts: 5 (↑2 vs last week)                                 │   │
│ │ 👁 Total reach: 145K (↑18%)                                   │   │
│ │ 💬 Engagement: 6.2% avg (↑0.5%)                               │   │
│ │ 🛒 Conversions: 34 orders (↑12%)                              │   │
│ │                                                                │   │
│ │ Streak: 🔥 3 weeks improving · Best grade this month: B+     │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ── Post-by-Post Insights ────────────────────────────────────────    │
│ ┌─ Content Insight Card (Top Performer) ────────────────────────┐   │
│ │ ⭐ 🎬 "5 tips nấu ăn" · 🎵 TikTok · 25/3                    │   │
│ │ 👁 24.3K views · 💬 6.8% eng · 🛒 12 orders                  │   │
│ │ Grade: A                                                       │   │
│ │                                                                │   │
│ │ ✅ What worked:                                                │   │
│ │ • Hook trong 3 giây đầu → viewer retention 85%               │   │
│ │ • Trending sound → discovery boost ↑40%                       │   │
│ │ • Clear CTA "Link in bio" → 12 conversions                    │   │
│ │                                                                │   │
│ │ 💡 Could be better:                                            │   │
│ │ • Thêm text overlay cho mobile-first viewers                  │   │
│ │ • Shorten from 65s → 45-55s for better completion rate        │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Content Insight Card (Below Average) ────────────────────────┐   │
│ │ 📉 🎬 "Review serum" · 📸 IG Reel · 27/3                     │   │
│ │ 👁 3.2K views · 💬 2.1% eng · 🛒 0 orders                    │   │
│ │ Grade: D                                                       │   │
│ │                                                                │   │
│ │ ❌ What didn't work:                                           │   │
│ │ • Video quá dài (2:30) → completion rate chỉ 15%             │   │
│ │ • No hook → 60% dropped in first 3 seconds                   │   │
│ │ • Over-edited → mất authenticity                              │   │
│ │                                                                │   │
│ │ 💡 Try this instead:                                           │   │
│ │ • Giảm xuống 45-60s, thêm hook "1 thing you don't know..."   │   │
│ │ • Use before/after format (high performer in your niche)      │   │
│ │ • Cross-post to TikTok (your RPM is 40% higher there)        │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ── AI Strategy Recommendations ──────────────────────────────────    │
│ ┌─ Strategy Section ────────────────────────────────────────────┐   │
│ │ 📊 Data-backed suggestions for next week:                     │   │
│ │                                                                │   │
│ │ 1️⃣ "Tăng tần suất posting từ 5 → 7/tuần (daily posting     │   │
│ │     boost reach +25% cho accounts your size)"                 │   │
│ │     Impact: 🟢 High · Effort: 🟡 Medium                      │   │
│ │                                                                │   │
│ │ 2️⃣ "Đăng vào 19:00-21:00 thay vì 12:00 — your audience     │   │
│ │     active peak là 20:00 (reach ↑35%)"                        │   │
│ │     Impact: 🟢 High · Effort: 🟢 Low                          │   │
│ │                                                                │   │
│ │ 3️⃣ "Thử format 'list tips' — 3/5 top videos dùng format    │   │
│ │     này, avg engagement 8.5% vs 4.1% for other formats"      │   │
│ │     Impact: 🟡 Medium · Effort: 🟢 Low                        │   │
│ │                                                                │   │
│ │ 4️⃣ "Ưu tiên TikTok > IG — RPM cao hơn 40%, completion     │   │
│ │     rate cao hơn 20%"                                          │   │
│ │     Impact: 🟢 High · Effort: 🟢 Low                          │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ [📊 Full Analytics Dashboard →] [📥 Export Weekly Report PDF]       │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
PerformanceCoachPage
├── AppShell (shared)
├── PageHeader
│   ├── PageTitle ("🏆 Performance Coach")
│   ├── WeekSelector (dropdown of past weeks)
│   └── ExportButton
├── WeeklyReportCard
│   ├── WeekLabel (week number + date range)
│   ├── OverallGrade (letter grade + change indicator)
│   ├── CategoryGrades (4 categories with star ratings)
│   │   ├── Consistency (posting frequency score)
│   │   ├── Quality (engagement vs niche benchmark)
│   │   ├── Growth (follower/reach growth rate)
│   │   └── Strategy (trend alignment + optimization)
│   ├── WeeklyMetrics (posts, reach, engagement, conversions)
│   └── StreakBanner (improvement streak counter 🔥)
├── PostInsightsSection
│   └── ContentInsightCard[] (sorted by grade, best first)
│       ├── ContentBadge (⭐ top / 📉 below average)
│       ├── ContentThumbnail + Title + Platform + Date
│       ├── PerformanceMetrics (views, engagement, orders)
│       ├── Grade (A-F)
│       ├── WhatWorkedSection (✅ green items)
│       ├── WhatDidntWorkSection (❌ red items — only for below avg)
│       └── ImprovementSuggestions (💡 actionable tips)
├── StrategySection
│   └── StrategyCard[]
│       ├── NumberBadge (1️⃣2️⃣3️⃣4️⃣)
│       ├── Suggestion (actionable text with data backing)
│       ├── ImpactBadge (🟢 High / 🟡 Medium / 🔴 Low)
│       └── EffortBadge (🟢 Low / 🟡 Medium / 🔴 High)
└── ActionBar
    ├── FullAnalyticsLink ("📊 Full Analytics →")
    └── ExportPDFButton
```

---

## 5. Grading System

| Grade | Score | Description | Visual |
|---|---|---|---|
| A+ | 95-100 | Exceptional — outperforming niche benchmarks | ⭐ Gold |
| A | 85-94 | Excellent — strong performance | 🟢 |
| B+ | 75-84 | Good — above average | 🟢 |
| B | 65-74 | Average — meeting benchmarks | 🟡 |
| C | 50-64 | Below average — needs improvement | 🟡 |
| D | 30-49 | Poor — significant issues | 🔴 |
| F | 0-29 | Failed — fundamental problems | 🔴 |

Score = weighted average of:
- **Consistency** (25%): posting frequency vs target
- **Quality** (30%): engagement rate vs niche benchmark
- **Growth** (25%): reach/follower growth rate
- **Strategy** (20%): trend alignment, format optimization, timing

---

## 6. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching report | Report card shimmer |
| LOADED | Report ready | Full coaching dashboard |
| NOT_GENERATED | Report not yet generated (early in week) | "Report cho tuần này sẽ sẵn sàng vào Thứ Hai 6:00 AM." |
| NO_DATA | No content published this week | "Chưa publish content nào tuần này. Đăng ít nhất 1 bài để nhận coaching." |
| FIRST_WEEK | First week using feature | "Chào mừng! Đây là tuần đầu tiên. Coach sẽ so sánh với tuần sau." |
| ERROR | AI/API failed | Error with retry |

---

## 7. Permissions

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer |
|---|---|---|---|---|---|---|
| View coach | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| View per-content insights | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| View strategies | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Export report | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |

---
## 8. Edge Cases

| Edge Case | Handling |
|---|---|
| First week (no previous data) | Banner: "Chào mừng! Đây là tuần đầu. Coach sẽ so sánh bắt đầu từ tuần sau." |
| No content published this week | "Chưa publish content. Đăng ít nhất 1 bài để nhận coaching." |
| Streak breaks mid-page | Real-time update: streak counter resets, "😢 Streak gián đoạn" animation |
| All grades "A+" | 🎉 Celebration banner: "Tuần xuất sắc! Bạn dẫn đầu niche!" |
| Revenue data unavailable | Revenue metric hidden, grade weighted among 3 remaining categories |

---

## 9. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached report | Auto-retry online |
| Report not generated | Cron failed | "Report chưa sẵn sàng. Thử lại sau 1 giờ. [Thử lại]" | Retry |
| AI analysis fail | CopilotService error | Insight cards: "Phân tích không khả dụng" | Retry |
| Export fail | PDF generation error | Toast: "Không xuất được. [Thử lại]" | Retry |
| Week selector error | Invalid week param | Redirect to current week | Auto-redirect |

---

## 10. Accessibility

| Element | Requirement |
|---|---|
| Overall grade | `aria-label="Điểm tổng: B+, tăng từ B tuần trước"`, not color-only |
| Star ratings | `aria-label="Consistency: 4 trên 5 sao"`, `aria-valuemin/max/now` |
| Content insight cards | `role="article"`, `aria-label="Bài: {title}, điểm {grade}"` |
| Impact/effort badges | Text + icon (not color-only): "Impact: High", "Effort: Low" |
| XP progress bar | `role="progressbar"`, `aria-valuenow`, `aria-valuemin`, `aria-valuemax` |

---

## 11. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Report card shimmer |
| Report card | 300-600ms | Grade animates in (scale + fade), stars fill |
| Content insights | 500-1000ms | Cards stagger in (best first) |
| Strategy section | 800-1500ms | Cards slide in |
| Export | 1-3s | Button spinner |

---

## 12. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `performance_coach.viewed` | Page load | `week_number`, `grade`, `source` |
| `performance_coach.week_changed` | Week selector | `from_week`, `to_week` |
| `performance_coach.content_clicked` | Insight card click | `content_id`, `grade` |
| `performance_coach.strategy_viewed` | Strategy card scrolled into view | `strategy_index` |
| `performance_coach.strategy_cta_clicked` | Strategy CTA | `strategy_type`, `cta_target` |
| `performance_coach.exported` | Export PDF | `week_number`, `grade` |
| `performance_coach.streak_displayed` | Streak counter visible | `streak_days`, `bonus_multiplier` |
| `performance_coach.full_analytics_clicked` | Full analytics link | — |

---

## 13. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/performance/+page.svelte`
- **Server load**: `+page.server.ts` → `PerformanceService/GetWeeklyReport(week_number)`
- **Cron**: Weekly report generated Monday 6AM via `PerformanceReportGenerator` worker
- **Grading**: Server-computed weighted score (Consistency 25%, Quality 30%, Growth 25%, Strategy 20%)
- **AI insights**: Pre-generated in cron, stored in `performance_reports.ai_insights` (JSON)
- **Streak**: `GamificationService/GetStreak(user_id)` — computed from `xp_events`
- **Level-up animation**: Svelte transition + confetti.js (client-side only)
- **Export**: PDF via `pdf-lib` with grade badge SVG rendering

---

## 14. Localization Notes

- Grades: Vietnamese labels: "Xuất sắc" (A+/A), "Tốt" (B+/B), "Trung bình" (C), "Yếu" (D/F)
- Categories: "Tần suất", "Chất lượng", "Tăng trưởng", "Chiến lược"
- Streak: "🔥 14 ngày liên tục", "Kỷ lục: 21 ngày"
- Impact: "📊 Tác động: 🟢 Cao / 🟡 TB / 🔴 Thấp"
- Effort: "⚡ Công sức: 🟢 Ít / 🟡 TB / 🔴 Nhiều"

---

## 15. Design Tokens

| Token | Usage |
|---|---|
| `--color-grade-a` | A+/A grade badge (gold/green) |
| `--color-grade-b` | B+/B grade badge (green) |
| `--color-grade-c` | C grade badge (amber) |
| `--color-grade-d` | D grade badge (red) |
| `--color-grade-f` | F grade badge (dark red) |
| `--color-streak-active` | 🔥 active streak |
| `--color-streak-broken` | Broken streak gray |
| `--color-accent` | Primary CTAs |
| `--color-surface-elevated` | Cards |

---

## 16. Related Screens

| Screen | Relationship |
|---|---|
| [W075] Analytics Overview | Full analytics data |
| [W078] Post Detail Analytics | Per-content deep analytics |
| [W079] Gamification | Achievement system |
| [M039] Mobile Performance Coach | Mobile equivalent |

---

## 17. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 edge cases (first week, streak break), 5 errors, grade/star a11y, 8 analytics, SvelteKit impl (cron, confetti), 9 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
