# Screen: Web — Competitor Registry

> **Screen ID**: W12
> **Module**: M03 — Competitive Intelligence
> **Route**: `/intelligence/competitors`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4, Product Freeze §11, A1 Schema (competitors, competitor_snapshots, benchmarks)

---

## 1. Purpose & Context

The Competitor Registry lets creators track competitor accounts across platforms. AI scores each competitor for relevance, monitors posting patterns, and feeds into the Benchmark View for comparative analysis.

### User Story
> As a creator, I want to track my competitors' performance and content patterns so I can benchmark my growth and find content gaps to exploit.

### Entry Points
- Sidebar: "🏆 Đối thủ" under Intelligence
- Benchmark View: "Quản lý đối thủ"
- Direct URL: `/intelligence/competitors`

### Exit Points
- Click competitor → `/intelligence/competitors/[id]` (Competitor Profile)
- Click "Benchmark" → `/intelligence/benchmarks`

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 🏆 Đối thủ                    [+ Thêm đối thủ] [📊 Benchmark →]   │
├──────────────────────────────────────────────────────────────────────┤
│ Filter: [Platform ▾] [Category ▾]  Search: [🔍              ]     │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ Competitor Card ──────────────────────────────────────────────┐  │
│ │ [Avatar] @skincare_queen · 🎵 TikTok         [🟢 Tracking]   │  │
│ │ 245K followers · 89 videos (30d) · Avg views: 120K            │  │
│ │ Growth: +12% followers (30d) · Eng rate: 9.5%                 │  │
│ │ AI Relevance: ⭐ 88/100 "Same niche, similar audience"        │  │
│ │ Last post: 6h ago · Posting freq: 2.3/day                     │  │
│ │ [📊 Benchmark] [📈 Profile] [🔔 Alert settings] [❌ Gỡ]     │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Competitor Card ──────────────────────────────────────────────┐  │
│ │ [Avatar] @beauty_guru99 · 📸 Instagram        [🟢 Tracking]   │  │
│ │ 180K followers · 45 posts (30d) · Avg reach: 85K              │  │
│ │ Growth: +8% followers (30d) · Eng rate: 5.2%                  │  │
│ │ AI Relevance: ⭐ 72/100 "Similar products, different style"   │  │
│ │ [📊 Benchmark] [📈 Profile] [🔔 Alert settings] [❌ Gỡ]     │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ── AI Suggested Competitors ──                                       │
│ ┌─ Suggestion Card ──────────────────────────────────────────────┐  │
│ │ [Avatar] @cooking_vn · TikTok · 89K followers                  │  │
│ │ AI: "Cùng lĩnh vực, cùng tệp audience 18-25 VN"              │  │
│ │ [➕ Thêm vào tracking] [❌ Bỏ qua]                            │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3. Component Hierarchy

```
CompetitorRegistryPage
├── AppShell (shared)
├── PageHeader
│   ├── Title
│   ├── AddCompetitorButton
│   └── BenchmarkLink
├── FilterBar
│   ├── PlatformFilter
│   ├── CategoryFilter
│   └── SearchInput
├── CompetitorList
│   └── CompetitorCard[]
│       ├── Avatar
│       ├── Handle + Platform
│       ├── TrackingStatus
│       ├── MetricsRow (followers, videos, avg views)
│       ├── GrowthRow (follower growth, engagement)
│       ├── AIRelevanceScore + Explanation
│       ├── PostingFrequency
│       └── ActionButtons (benchmark, profile, alert, remove)
├── AISuggestionsSection
│   └── SuggestionCard[]
│       ├── Avatar + Handle + Platform
│       ├── AIExplanation
│       └── AddButton / DismissButton
└── AddCompetitorModal
    ├── PlatformSelector
    ├── HandleInput (with live preview)
    ├── AIRelevancePreview
    └── ConfirmButton
```

---

## 4. Data Binding & Display Format

| UI Element | Data Source | API | Display Format |
|---|---|---|---|
| Handle | `competitors.platform_handle` | `CompetitorService/List` | "@handle" |
| Platform | `competitors.platform` | same | Platform icon + name |
| Followers | `competitor_snapshots.followers` (latest) | same | Compact number "245K" |
| Videos (30d) | `COUNT(competitor_posts WHERE date > -30d)` | same | Integer |
| Growth | `((current - 30d_ago) / 30d_ago) * 100` | same | "+12%" with color |
| Engagement | `competitor_snapshots.avg_engagement` | same | "9.5%" |
| AI Relevance | `competitors.relevance_score` | same | Badge "⭐ 88/100" |
| AI Explanation | `competitors.relevance_reason` | same | Italic text snippet |
| Last post | `competitor_posts.max(created_at)` | same | Relative time |
| Posting freq | Computed | same | "2.3/day" |

---

## 5. Actions Table

| # | Action | Trigger | API | UI Result | Permission |
|---|---|---|---|---|---|
| 1 | Add competitor | Modal form → submit | `CompetitorService/Add(platform, handle)` | New card + AI scores | `competitor:manage` |
| 2 | Remove | "❌ Gỡ" → confirm | `CompetitorService/Remove(id)` | Card fades out | `competitor:manage` |
| 3 | View profile | "📈 Profile" | — | → `/intelligence/competitors/[id]` | `competitor:read` |
| 4 | Benchmark | "📊 Benchmark" | — | → `/intelligence/benchmarks?vs=[id]` | `benchmark:read` |
| 5 | Set alerts | "🔔 Alert settings" | Modal: threshold config | Notification rules saved | `competitor:manage` |
| 6 | Accept suggestion | "➕ Thêm" on suggestion | `CompetitorService/Add` | Card moves to main list | `competitor:manage` |
| 7 | Dismiss suggestion | "❌ Bỏ qua" | `CompetitorService/DismissSuggestion` | Card fades | `competitor:manage` |

---

## 6. Edge Cases

| Edge Case | Handling |
|---|---|
| 50/50 competitor limit reached | "Đạt giới hạn 50. [Gỡ bớt để thêm]" — add button disabled |
| Duplicate handle | Modal validation: "Đã theo dõi @{handle}. [Xem →]" |
| Handle not found on platform | Modal error: "Không tìm thấy @{handle} trên {platform}" |
| Scraper delay (new competitor) | Card shows: "Đang thu thập dữ liệu... (5-10 phút)" skeleton |
| All suggestions dismissed | Section hidden: "Gợi ý mới sẽ có vào tuần tới" |

---

## 7. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached cards | Auto-retry online |
| Add competitor fail | Handle unresolvable | Modal: "Không thêm được. Handle có thể không tồn tại." | Edit + retry |
| Scraper unavailable | Platform blocked | Card: "⚠️ Dữ liệu chưa sẵn sàng" | Auto-retry on next sync |
| Remove fail | API error | Toast: "Không gỡ được. [Thử lại]" | Retry |
| Suggestion load fail | CopilotService error | Section hidden silently (non-critical) | Next page load |

---

## 8. Accessibility

| Element | Requirement |
|---|---|
| Competitor card list | `role="list"`, cards as `role="listitem"` |
| Competitor card | `aria-label="@{handle}, {platform}, {followers} followers, relevance {score}/100"` |
| Relevance badge | `aria-label="AI Relevance: {score}/100 — {explanation}"` (not color-only) |
| Tracking status | `aria-label="Trạng thái: Đang theo dõi"` (not color-only) |
| Add competitor modal | `role="dialog"`, `aria-modal="true"`, focus trap |

---

## 9. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Page header + filter bar |
| Competitor cards | 300-600ms | 3 skeleton cards → populated cards |
| AI suggestions | 500-1000ms | Section fades in below tracked list |
| Add modal preview | 2-5s | Live handle lookup with loading spinner |
| After add | 0ms card + 5-10min data | Card appears immediately (skeleton), data fills on sync |

---

## 10. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `competitor.viewed` | Page load | `competitor_count`, `source` |
| `competitor.added` | Add complete | `handle`, `platform`, `relevance_score` |
| `competitor.removed` | Remove + confirm | `competitor_id`, `handle` |
| `competitor.benchmark_clicked` | Benchmark CTA | `competitor_id` |
| `competitor.profile_clicked` | Profile CTA | `competitor_id` |
| `competitor.alert_set` | Alert config saved | `competitor_id`, `thresholds` |
| `competitor.suggestion_accepted` | AI suggestion added | `handle`, `relevance_score` |
| `competitor.suggestion_dismissed` | AI suggestion dismissed | `handle` |

---

## 11. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/intelligence/competitors/+page.svelte`
- **Server load**: `+page.server.ts` → `CompetitorService/List` + `CompetitorService/GetSuggestions`
- **Add modal**: Live handle validation via `CompetitorService/ValidateHandle(platform, handle)`
- **AI relevance**: Computed by embedding `cos_similarity(user_profile, competitor_profile)`
- **Snapshots**: Refreshed every 6h via cron (`CompetitorSync` worker)
- **Alert config**: `CompetitorService/SetAlerts(id, thresholds)` → notification on threshold cross

---

## 12. Localization Notes

- Status: "🟢 Đang theo dõi", "⏳ Đang thu thập"
- Metrics: "{followers} theo dõi", "{videos} video (30 ngày)", "Lượt xem TB: {n}"
- Growth: "+12% followers (30 ngày)"
- Relevance: "⭐ 88/100", "Cùng lĩnh vực, cùng đối tượng"
- Suggestions: "AI gợi ý đối thủ phù hợp"

---

## 13. Design Tokens

| Token | Usage |
|---|---|
| `--color-relevance-high` | Score ≥ 80 badge (green) |
| `--color-relevance-medium` | Score 50-79 badge (amber) |
| `--color-relevance-low` | Score < 50 badge (red) |
| `--color-tracking-active` | 🟢 tracking status |
| `--color-tracking-pending` | ⏳ collecting status |
| `--color-suggestion-bg` | AI suggestion section bg |
| `--color-accent` | Primary CTAs |
| `--color-surface-elevated` | Cards |

---

## 14. Related Screens

| Screen | Relationship |
|---|---|
| [W013] Benchmark View | Comparative analysis |
| [W010] Trend Detail | May link to competitor examples |
| [M017] Mobile Competitor | Mobile equivalent |

---

## 15. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 edge cases (50 limit, duplicate), 5 errors, competitor card a11y, 8 analytics, SvelteKit impl (embedding similarity), 8 design tokens. | System |
| 2026-03-27 | 1.0 | Initial specification | System |
