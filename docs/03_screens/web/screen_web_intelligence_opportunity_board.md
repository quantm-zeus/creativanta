# Screen: Web — Opportunity Board

> **Screen ID**: W043
> **Module**: M04 — Opportunity Board
> **Route**: `/intelligence/opportunities`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4, Product Freeze §10/§11, A1 Schema (opportunities)

---

## 1. Purpose & Context

The Opportunity Board surfaces AI-scored opportunities — content gaps, trending topics the user hasn't covered, under-served niches, and content types with high potential. Opportunities are generated daily by the AI Copilot from trend data, competitor analysis, and audience signals.

### User Story
> As a creator, I want AI to tell me where the untapped opportunities are so I can focus on content with the highest chance of growth.

### Entry Points
- Sidebar: "💎 Cơ hội" under Intelligence
- Home Dashboard: "Xem Opportunity Board →"
- Direct URL: `/intelligence/opportunities`

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 💎 Cơ hội                    [Sort ▾] [Filter: Score ≥ ▾]          │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ Summary: 12 opportunities · Avg score: 76 · 3 new today             │
│                                                                      │
│ ┌─ Opportunity Card ─────────────────────────────────────────────┐  │
│ │ 💎 "Morning skincare routine — chưa có trên TikTok VN"         │  │
│ │ Score: ⭐ 89/100 · Type: Content Gap · Updated: 2h ago        │  │
│ │                                                                  │  │
│ │ 🤖 AI Analysis:                                                │  │
│ │ "Hiện chỉ có 3 video VN về morning routine. Trending +200%    │  │
│ │  globally nhưng VN market chưa khai thác. Audience 18-25      │  │
│ │  match 92%. First mover advantage rất cao."                    │  │
│ │                                                                  │  │
│ │ Evidence: [🔗 TikTok global trend] [📊 Audience data]        │  │
│ │ Related: [🔥 Trend: "morning routine"] [🏆 Gap vs @queen]     │  │
│ │                                                                  │  │
│ │ [💡 Tạo ý tưởng] [📝 Viết script ngay] [⏭ Bỏ qua] [📌 Lưu]│  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Opportunity Card ─────────────────────────────────────────────┐  │
│ │ 💎 "Review serum retinol — competitor giảm tần suất"           │  │
│ │ Score: ⭐ 74/100 · Type: Competitor Weakness · Updated: 1d     │  │
│ │                                                                  │  │
│ │ 🤖 AI Analysis:                                                │  │
│ │ "@skincare_queen chưa post về retinol 2 tuần nay. Keyword    │  │
│ │  vẫn trending. Cơ hội lấp khoảng trống."                      │  │
│ │                                                                  │  │
│ │ [💡 Tạo ý tưởng] [📝 Viết script] [⏭ Bỏ qua] [📌 Lưu]     │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ [Tải thêm ↓]                                                        │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3. Component Hierarchy

```
OpportunityBoardPage
├── AppShell (shared)
├── PageHeader
│   ├── Title
│   ├── SortDropdown (score, recency, type)
│   └── ScoreFilterSlider (min threshold)
├── SummaryBar
│   ├── TotalCount
│   ├── AvgScore
│   └── NewTodayCount
├── OpportunityList
│   └── OpportunityCard[]
│       ├── OpportunityTitle
│       ├── ScoreBadge
│       ├── TypeChip (Content Gap / Competitor Weakness / Trending / Niche)
│       ├── UpdatedTime
│       ├── AIAnalysisText
│       ├── EvidenceLinks[]
│       │   ├── TrendLink
│       │   ├── AudienceDataLink
│       │   └── CompetitorGapLink
│       └── ActionButtons
│           ├── CreateIdeaButton
│           ├── WriteScriptButton
│           ├── SkipButton
│           └── SaveButton
└── LoadMore
```

---

## 4. Data Binding & Display Format

| UI Element | Data Source | API | Display Format |
|---|---|---|---|
| Title | `opportunities.title` | `OpportunityService/List` | H3 text |
| Score | `opportunities.score` | same | Badge "⭐ 89/100" |
| Type | `opportunities.type` | same | Chip: "Content Gap" / "Competitor Weakness" / "Trending" / "Niche" |
| AI Analysis | `opportunities.analysis_text` | same | Markdown paragraph |
| Evidence | `opportunities.evidence_links` (JSON array) | same | Clickable link list |
| Updated | `opportunities.updated_at` | same | Relative time |

---

## 5. Actions Table

| # | Action | Trigger | API | UI Result | Permission |
|---|---|---|---|---|---|
| 1 | Create idea | "💡 Tạo ý tưởng" | `IdeaService/Create(from_opportunity_id)` | Navigate → `/ideas/[new_id]` | `idea:create` |
| 2 | Write script | "📝 Viết script" | — | Navigate → `/scripts/new?opp_id=[id]` | `script:create` |
| 3 | Skip | "⏭ Bỏ qua" | `OpportunityService/Dismiss(id)` | Card fades out | Any |
| 4 | Save | "📌 Lưu" | `OpportunityService/Save(id)` | Pin icon fills | Any |
| 5 | Sort | Change sort | Refetch | List reorders | `opportunity:read` |
| 6 | Filter by score | Change threshold | Refetch | List filters | `opportunity:read` |
| 7 | View evidence | Click evidence link | — | Navigate to trend/competitor | `trend:read` |

---

## 6. Edge Cases

| Edge Case | Handling |
|---|---|
| No connectors + no competitors | "Kết nối nền tảng và theo dõi đối thủ để AI phát hiện cơ hội. [Kết nối →]" |
| All opportunities dismissed | "Bạn đã xem hết! Quay lại sau. [↩ Xem lại đã bỏ qua]" |
| Score tie between opportunities | Secondary sort by recency (newest first) |
| New opportunity arrives via SSE | Card slides in at correct position + "🆕 NEW" badge + green glow 3s |
| Opportunity expires (30d old) | Card dims with "Hết hạn" badge — still visible but de-prioritized |

---

## 7. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached cards | Auto-retry online |
| List API fail | Server 5xx | Full-page: "Không tải được cơ hội. [Thử lại]" | Retry |
| Dismiss fail | Network error | Toast: "Không bỏ qua được. [Thử lại]" | Retry (card stays) |
| Idea creation fail | IdeaService error | Toast: "Không tạo ý tưởng. [Thử lại]" | Retry |
| SSE connection lost | Network issue | Silent reconnect 3x, then banner | Auto-reconnect |

---

## 8. Accessibility

| Element | Requirement |
|---|---|
| Opportunity list | `role="feed"`, cards as `role="article"` |
| Opportunity card | `aria-label="Cơ hội: {title}, điểm {score}, loại {type}"` |
| Score badge | `aria-label="Điểm cơ hội: {score}/100"` (not color-only) |
| Type chip | `aria-label="Loại: {type}"` |
| Evidence links | Standard link with descriptive text, not icon-only |

---

## 9. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Summary bar shimmer + 3 card skeletons |
| Summary bar | 100-300ms | Counts animate |
| Cards populate | 300-800ms | Cards fade in by score (highest first) |
| Evidence links | 500ms after card | Links appear (lazy) |
| Load more | 200-500ms | Next page appends |

---

## 10. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `opportunity.viewed` | Page load | `total_count`, `avg_score`, `new_today`, `source` |
| `opportunity.card_clicked` | Card → detail | `opportunity_id`, `score`, `type` |
| `opportunity.idea_created` | "💡 Tạo ý tưởng" | `opportunity_id`, `score`, `type` |
| `opportunity.script_created` | "📝 Viết script" | `opportunity_id`, `score` |
| `opportunity.dismissed` | "⏭ Bỏ qua" | `opportunity_id`, `score` |
| `opportunity.saved` | "📌 Lưu" | `opportunity_id` |
| `opportunity.filtered` | Filter/sort change | `filter_type`, `value`, `result_count` |
| `opportunity.evidence_clicked` | Evidence link click | `evidence_type`, `opportunity_id` |

---

## 11. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/intelligence/opportunities/+page.svelte`
- **Server load**: `+page.server.ts` → `OpportunityService/List(filters, cursor)` with SSR
- **SSE**: `/events/opportunities` → new opportunities push into feed in real-time
- **Cron**: Opportunities pre-generated daily by AI cron (`OpportunityGenerator` worker)
- **Dismiss**: Soft delete — `OpportunityService/Dismiss(id)` sets `dismissed_at`
- **Restore**: "Xem lại đã bỏ qua" → `OpportunityService/List(include_dismissed=true)`
- **Pagination**: Cursor-based, 12 per page, infinite scroll

---

## 12. Localization Notes

- Types: "🕳️ Khoảng trống nội dung", "🏆 Điểm yếu đối thủ", "🔥 Đang tăng", "🎯 Thị trường ngách"
- Score: "⭐ 89/100", "Điểm cơ hội"
- Evidence: "Dựa trên xu hướng", "Dựa trên đối thủ", "Dựa trên khán giả"
- Actions: "Tạo ý tưởng", "Viết script ngay", "Bỏ qua", "Lưu"
- Summary: "12 cơ hội · TB: 76 · 3 mới hôm nay"

---

## 13. Design Tokens

| Token | Usage |
|---|---|
| `--color-opp-content-gap` | Content Gap type chip |
| `--color-opp-competitor` | Competitor Weakness type chip |
| `--color-opp-trending` | Trending type chip |
| `--color-opp-niche` | Niche type chip |
| `--color-score-high` | Score ≥ 80 (green) |
| `--color-score-medium` | Score 50-79 (amber) |
| `--color-score-low` | Score < 50 (red) |
| `--color-surface-elevated` | Cards |

---

## 14. Related Screens

| Screen | Relationship |
|---|---|
| [W044] Opportunity Detail | Full detail view |
| [W038] Trend Radar | Evidence source |
| [W040] Competitor Registry | Evidence source |
| [W045] Opportunity Convert | Conversion wizard |
| [M017] Mobile Trend List | Mobile equivalent (opportunities via trends) |

---

## 15. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 edge cases (all dismissed, SSE push), 5 errors, opportunity card a11y, 8 analytics, SvelteKit impl (SSE, soft delete), 8 design tokens. | System |
| 2026-03-27 | 1.0 | Initial specification | System |
