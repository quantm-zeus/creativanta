# Screen: Web — Opportunity Detail

> **Screen ID**: W15
> **Module**: M02 — Opportunity Engine
> **Route**: `/intelligence/opportunities/[id]`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4, Product Freeze §10/§11, A1 Schema (opportunities, trends, competitors)

---

## 1. Purpose & Context

Full detail view of a single AI-generated opportunity. Shows the complete analysis, supporting evidence, action history, and conversion path. This is the "intelligence brief" that justifies why this opportunity is worth pursuing.

### User Story
> As a creator, I want to understand the full reasoning behind an AI-suggested opportunity so I can make an informed decision about pursuing it.

### Entry Points
- Opportunity Board: click card
- Direct URL: `/intelligence/opportunities/[id]`

### Exit Points
- "💡 Tạo ý tưởng" → `/ideas/new?opp_id=[id]`
- "📝 Viết script" → `/scripts/new?opp_id=[id]`
- Evidence links → respective trend/competitor pages
- "← Quay lại" → `/intelligence/opportunities`

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Cơ hội   "Morning skincare routine"          ⭐ 89/100  [⋮]     │
├──────────────────────────────────┬───────────────────────────────────┤
│ Main Content (65%)               │ Side Panel (35%)                   │
│                                  │                                    │
│ ┌─ AI Analysis ──────────────┐  │ ┌─ Quick Info ──────────────────┐│
│ │ 🤖 Phân tích chi tiết:      │  │ │ Type: Content Gap            ││
│ │                              │  │ │ Score: ⭐ 89/100              ││
│ │ "Hiện chỉ có 3 video VN    │  │ │ Status: 🟢 Active            ││
│ │  về morning routine trên    │  │ │ Created: 25/03/2026          ││
│ │  TikTok. Trong khi đó,     │  │ │ Updated: 27/03/2026 (2h ago) ││
│ │  keyword 'morning skincare' │  │ │ Expires: ~30 ngày            ││
│ │  trending +200% globally..."│  │ └──────────────────────────────┘│
│ │                              │  │                                  │
│ │ Audience match: 92%          │  │ ┌─ Actions ─────────────────────┐│
│ │ Competition level: Low       │  │ │ [💡 Tạo ý tưởng]             ││
│ │ Time sensitivity: High       │  │ │ [📝 Viết script ngay]        ││
│ │ First mover: Very likely    │  │ │ [📌 Lưu]                     ││
│ └────────────────────────────┘  │ │ [⏭ Bỏ qua]                   ││
│                                  │ │ [📤 Chia sẻ cho team]         ││
│ ┌─ Score Breakdown ──────────┐  │ └──────────────────────────────┘│
│ │ Demand      ████████░░ 85  │  │                                  │
│ │ Competition ████████░░ 90  │  │ ┌─ Scoring Factors ────────────┐│
│ │ Audience    █████████░ 92  │  │ │ ✅ Low competition (3 VN)    ││
│ │ Timeliness  ████████░░ 88  │  │ │ ✅ High demand (+200%)       ││
│ │ Product fit ████████░░ 82  │  │ │ ✅ Audience match 92%        ││
│ └────────────────────────────┘  │ │ 🟡 Product fit moderate      ││
│                                  │ │ ✅ First mover advantage     ││
│ ┌─ Evidence ─────────────────┐  │ └──────────────────────────────┘│
│ │ Supporting Data:             │  │                                  │
│ │ 🔥 [Trend: "morning routine"│  │ ┌─ Related Opportunities ─────┐│
│ │     → score 78, +200%]      │  │ │ 💎 Evening routine (⭐72)   ││
│ │ 🏆 [Gap: @skincare_queen   │  │ │ 💎 Korean skincare (⭐68)   ││
│ │     hasn't covered this]     │  │ │ 💎 Sunscreen myths (⭐65)   ││
│ │ 📊 [Audience: 18-25F VN    │  │ └──────────────────────────────┘│
│ │     overlap 92%]             │  │                                  │
│ │ 🔗 [TikTok: top 5 global   │  │                                  │
│ │     videos for reference]    │  │                                  │
│ └────────────────────────────┘  │                                  │
│                                  │                                    │
│ ┌─ Content Suggestions ──────┐  │                                    │
│ │ AI đề xuất:                 │  │                                    │
│ │ 1. "Morning routine step-  │  │                                    │
│ │    by-step" · TikTok 30s   │  │                                    │
│ │ 2. "3 sai lầm buổi sáng"  │  │                                    │
│ │    · TikTok 45s · Hook     │  │                                    │
│ │ 3. "POV morning glow"      │  │                                    │
│ │    · IG Reels 15s          │  │                                    │
│ │ [→ Chọn và tạo ý tưởng]    │  │                                    │
│ └────────────────────────────┘  │                                    │
└──────────────────────────────────┴───────────────────────────────────┘
```

---

## 3. Component Hierarchy

```
OpportunityDetailPage
├── AppShell (shared)
├── PageHeader
│   ├── BackButton
│   ├── OpportunityTitle
│   ├── ScoreBadge
│   └── MoreMenu (share, export, report)
├── SplitView
│   ├── MainPanel (65%)
│   │   ├── AIAnalysisCard
│   │   │   ├── AnalysisText (markdown)
│   │   │   ├── AudienceMatchMetric
│   │   │   ├── CompetitionLevel
│   │   │   ├── TimeSensitivity
│   │   │   └── FirstMoverIndicator
│   │   ├── ScoreBreakdownChart
│   │   │   └── ScoreBar[] (demand, competition, audience, timeliness, product_fit)
│   │   ├── EvidenceSection
│   │   │   └── EvidenceItem[]
│   │   │       ├── EvidenceIcon (trend/gap/audience/reference)
│   │   │       ├── EvidenceDescription
│   │   │       └── EvidenceLink (clickable)
│   │   └── ContentSuggestionsCard
│   │       ├── SuggestionItem[] (title, format, duration)
│   │       └── SelectAndCreateButton
│   └── SidePanel (35%)
│       ├── QuickInfoCard (type, score, dates, expiry)
│       ├── ActionsCard (create idea, script, save, skip, share)
│       ├── ScoringFactorsCard (checkmarks list)
│       └── RelatedOpportunitiesCard (top 3 related)
```

---

## 4. Data Binding & Display Format

| UI Element | Source | API | Display |
|---|---|---|---|
| Title | `opportunities.title` | `OpportunityService/Get(id)` | H1 |
| Score | `opportunities.score` | same | Badge "⭐ 89/100" |
| Type | `opportunities.type` | same | Chip |
| Analysis | `opportunities.analysis_text` | same | Markdown |
| Score breakdown | `opportunities.score_breakdown` (JSON) | same | Horizontal bar chart |
| Evidence | `opportunities.evidence_links` (JSON) | same | Linked list |
| Suggestions | `opportunities.content_suggestions` (JSON) | same | Numbered list |
| Related | `OpportunityService/ListRelated(id)` | Computed by embedding | Card list |

---

## 5. Actions Table

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Create idea | "💡 Tạo ý tưởng" | `IdeaService/Create(from_opp_id)` | Navigate → `/ideas/[new_id]` | `idea:create` |
| 2 | Create from suggestion | Click suggestion → "Chọn" | `IdeaService/Create(title, format)` | Navigate → idea | `idea:create` |
| 3 | Write script | "📝 Viết script" | — | → `/scripts/new?opp_id=[id]` | `script:create` |
| 4 | Save | "📌 Lưu" | `OpportunityService/Save(id)` | Bookmark filled | Any |
| 5 | Skip | "⏭ Bỏ qua" | `OpportunityService/Dismiss(id)` | Navigate back | Any |
| 6 | Share | "📤 Chia sẻ" | `NotificationService/Send(team)` | Toast | Any |
| 7 | View evidence | Click evidence link | — | Navigate to trend/competitor | Varies |
| 8 | View related | Click related opportunity | — | Navigate to opp detail | `opportunity:read` |
| 9 | Back | "← Cơ hội" | — | → `/intelligence/opportunities` | Any |

---

## 6. Edge Cases

| Edge Case | Handling |
|---|---|
| Opportunity expired (> 30d) | Gray overlay: "Cơ hội đã hết hạn" — content read-only, actions disabled |
| Evidence link dead (trend removed) | Link disabled: "Xu hướng không còn khả dụng" |
| No content suggestions | Section hidden: "AI chưa có đề xuất cho cơ hội này" |
| Opportunity already converted to 3+ ideas | Info banner: "Đã tạo 3 ý tưởng từ cơ hội này. [Xem →]" |
| Related opportunities empty | Section hidden (no placeholder needed) |

---

## 7. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached detail | Auto-retry online |
| Opportunity not found | 404 | Full-page: "Cơ hội không tồn tại hoặc đã bị xóa. [← Quay lại]" | Back to board |
| Idea creation fail | IdeaService error | Toast: "Không tạo ý tưởng. [Thử lại]" | Retry |
| Share fail | NotificationService error | Toast: "Không chia sẻ được. [Thử lại]" | Retry |
| Related load fail | API error | Section hidden (non-critical) | Next page load |

---

## 8. Accessibility

| Element | Requirement |
|---|---|
| Split view | Main panel `role="main"`, side panel `role="complementary"` |
| Score breakdown bars | `role="img"`, `aria-label="{dimension}: {score}/100"` |
| Scoring factors | List with `aria-label="Yếu tố chấm điểm"`, ✅/🟡 not color-only |
| Evidence items | Standard links with descriptive text, `aria-label` for icon links |
| Content suggestions | `role="list"`, numbered items with `aria-label="Đề xuất {n}: {title}"` |

---

## 9. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Split-view skeleton (main + side) |
| Main content | 300-600ms | AI analysis + score breakdown populate |
| Score bars | 500ms after data | Bars animate width from 0 → value (500ms ease-out) |
| Side panel | 200-400ms | Quick info + actions populate |
| Related | 500-800ms | Bottom of side panel fades in |

---

## 10. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `opportunity_detail.viewed` | Page load | `opportunity_id`, `score`, `type`, `source` |
| `opportunity_detail.idea_created` | "💡 Tạo ý tưởng" | `opportunity_id`, `score` |
| `opportunity_detail.script_created` | "📝 Viết script" | `opportunity_id`, `score` |
| `opportunity_detail.suggestion_selected` | Click suggestion | `suggestion_index`, `title` |
| `opportunity_detail.saved` | "📌 Lưu" | `opportunity_id` |
| `opportunity_detail.dismissed` | "⏭ Bỏ qua" | `opportunity_id`, `score` |
| `opportunity_detail.shared` | "📤 Chia sẻ" | `opportunity_id`, `team_size` |
| `opportunity_detail.evidence_clicked` | Evidence link | `evidence_type`, `source_id` |

---

## 11. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/intelligence/opportunities/[id]/+page.svelte`
- **Server load**: `+page.server.ts` → `OpportunityService/Get(id)` + `OpportunityService/ListRelated(id)`
- **Score breakdown**: Custom SVG horizontal bars (`ScoreBar.svelte`)
- **Score animation**: CSS `width` transition 500ms ease-out on mount
- **Content suggestions**: Pre-generated in daily cron, stored as JSON in `opportunities.content_suggestions`
- **Evidence links**: Resolved to trend/competitor URLs server-side
- **Share**: `NotificationService/Send({ type: 'opportunity_share', recipients: team, opp_id })`

---

## 12. Localization Notes

- Analysis: Full Vietnamese AI-generated text
- Score dimensions: "Nhu cầu", "Cạnh tranh", "Khán giả", "Thời điểm", "Phù hợp sản phẩm"
- Scoring factors: "✅ Cạnh tranh thấp", "✅ Nhu cầu cao", "🟡 Phù hợp sản phẩm trung bình"
- Actions: "Tạo ý tưởng", "Viết script ngay", "Lưu", "Bỏ qua", "Chia sẻ cho team"
- Expired: "Cơ hội đã hết hạn", "Hết hạn khoảng 30 ngày sau khi phát hiện"

---

## 13. Design Tokens

| Token | Usage |
|---|---|
| `--color-score-high` | Score ≥ 80 bar + badge (green) |
| `--color-score-medium` | Score 50-79 (amber) |
| `--color-score-low` | Score < 50 (red) |
| `--color-score-bar-bg` | Score bar background (gray track) |
| `--color-opp-expired` | Expired opportunity overlay |
| `--color-evidence-trend` | 🔥 trend evidence icon |
| `--color-evidence-competitor` | 🏆 competitor evidence icon |
| `--color-accent` | Primary CTAs |
| `--color-surface-elevated` | Cards, panels |

---

## 14. Related Screens

| Screen | Relationship |
|---|---|
| [W014] Opportunity Board | Parent list |
| [W016] Opportunity Convert | Conversion wizard |
| [W009] Trend Radar | Evidence source |
| [W012] Competitor Registry | Evidence source |
| [W017] Idea Board | Target after conversion |

---

## 15. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 edge cases (expired, dead link), 5 errors, score bar a11y, 8 analytics, SvelteKit impl (SVG score bars), 9 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
