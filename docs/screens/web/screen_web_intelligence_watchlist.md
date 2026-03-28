# Screen: Web — Watchlist Manager

> **Screen ID**: W11
> **Module**: M02 — Trend Radar
> **Route**: `/intelligence/watchlist`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4, Product Freeze §10, A1 Schema (watchlists, watchlist_items)

---

## 1. Purpose & Context

Watchlists allow creators to organize and track trends they're interested in. Users can create multiple named watchlists (e.g., "Beauty Trends", "Food Content Ideas") and receive notifications when watched trends change significantly.

### User Story
> As a creator, I want to organize interesting trends into themed watchlists so I can track them over time and get notified when they peak.

### Entry Points
- Sidebar: "📌 Watchlist" under Intelligence
- Trend Radar: "📌 Lưu watchlist" on trend card
- Direct URL: `/intelligence/watchlist`

### Exit Points
- Click watched trend → `/intelligence/trends/[id]`
- Create idea from watched trend → `/ideas/new?trend_id=[id]`

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 📌 Watchlist                            [+ Tạo watchlist mới]       │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ Watchlist Tabs ───────────────────────────────────────────────┐  │
│ │ [📌 Tất cả (23)] [🧴 Skincare (8)] [🍳 Food (10)] [👗 Fashion (5)]│
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Watched Trend Row ────────────────────────────────────────────┐ │
│ │ 🔥 "AI cooking assistant"        ⭐ 92 ↑+12   [📈 Sparkline] │ │
│ │ TikTok · 1.2M views · Added 3d ago                             │ │
│ │ 🔔 Alert: Score crossed 90 threshold                           │ │
│ │ [💡 Tạo ý tưởng] [→ Chi tiết] [🔕 Tắt thông báo] [❌ Xóa]  │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ┌─ Watched Trend Row ────────────────────────────────────────────┐ │
│ │ 📊 "Retinol routine 2026"       ⭐ 87 ↑+5    [📈 Sparkline] │ │
│ │ Instagram · 450K posts · Added 5d ago                           │ │
│ │ [💡 Tạo ý tưởng] [→ Chi tiết] [🔕 Tắt] [❌ Xóa]             │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ┌─ Watched Trend Row (declining) ────────────────────────────────┐ │
│ │ 📉 "Glass skin tutorial"        ⭐ 45 ↓-20   [📉 Sparkline] │ │
│ │ TikTok · 800K views · Added 14d ago                             │ │
│ │ ⚠️ Declining trend — consider creating content soon or remove  │ │
│ │ [💡 Tạo ý tưởng] [→ Chi tiết] [❌ Xóa]                       │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ [Tải thêm ↓]                                                        │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3. Component Hierarchy

```
WatchlistPage
├── AppShell (shared)
├── PageHeader
│   ├── Title ("📌 Watchlist")
│   └── CreateWatchlistButton
├── WatchlistTabs
│   └── TabItem[] (tab per watchlist + "Tất cả" tab)
├── WatchedTrendList
│   └── WatchedTrendRow[]
│       ├── TrendTitle
│       ├── ScoreBadge + ScoreDelta (↑/↓)
│       ├── Sparkline (inline)
│       ├── PlatformInfo
│       ├── AddedDate
│       ├── AlertBanner (if threshold crossed)
│       └── ActionButtons
│           ├── CreateIdeaButton
│           ├── ViewDetailLink
│           ├── MuteButton
│           └── RemoveButton
└── CreateWatchlistModal
    ├── NameInput
    ├── DescriptionInput
    ├── AlertThresholdInput (score threshold)
    └── ConfirmButton
```

---

## 4. Data Binding & Display Format

| UI Element | Data Source | API | Display Format |
|---|---|---|---|
| Watchlist name | `watchlists.name` | `WatchlistService/List` | Tab label |
| Trend title | `trends.title` via `watchlist_items` | `WatchlistService/GetItems(id)` | Row title |
| Score | `trends.strength_score` | same | Badge with color |
| Score delta | Computed (current - 7d ago) | same | ↑+12 green or ↓-20 red |
| Sparkline | `trend_snapshots` 7-day | same | Inline SVG |
| Alert | If score crossed `watchlists.alert_threshold` | Computed | Yellow banner |

---

## 5. Actions Table

| # | Action | Trigger | API | UI Result | Permission |
|---|---|---|---|---|---|
| 1 | Create watchlist | "Tạo mới" → form | `WatchlistService/Create` | New tab appears | `trend:watchlist:manage` |
| 2 | Create idea | "Tạo ý tưởng" | `IdeaService/Create(from_trend_id)` | Navigate → idea | `idea:create` |
| 3 | View detail | "Chi tiết" | — | Navigate → trend detail | `trend:read` |
| 4 | Mute notifications | "Tắt thông báo" | `WatchlistService/MuteItem` | Icon toggles | `trend:watchlist:manage` |
| 5 | Remove from watchlist | "❌ Xóa" → confirm | `WatchlistService/RemoveItem` | Row fades out | `trend:watchlist:manage` |
| 6 | Delete watchlist | Tab ⋮ → "Xóa" → confirm | `WatchlistService/Delete` | Tab removed | `trend:watchlist:manage` |
| 7 | Edit watchlist | Tab ⋮ → "Sửa" | `WatchlistService/Update` | Name updates | `trend:watchlist:manage` |
| 8 | Switch tab | Click tab | Refetch items | List updates | `trend:read` |

---

## 6. State Machine

| State | Visual |
|---|---|
| LOADING | Skeleton rows |
| LOADED | Watchlist tabs + trend rows |
| EMPTY_WATCHLIST | "Watchlist trống. Thêm xu hướng từ Trend Radar → [Khám phá xu hướng →]" |
| NO_WATCHLISTS | "Chưa có watchlist. Tạo watchlist đầu tiên!" + CTA |
| ERROR | Error message + retry |

---

## 7. Validation Rules

### Create Watchlist Form
| Field | Rule | Error Message |
|---|---|---|
| Name | Required, 3-50 chars | "Tên phải từ 3-50 ký tự" |
| Alert threshold | Optional, 0-100 number | "Ngưỡng phải từ 0-100" |

---

## 8. Edge Cases

| Edge Case | Handling |
|---|---|
| Max 50 items per watchlist | "Đạt giới hạn 50. [Xóa bớt xu hướng cũ]" — add disabled |
| Declining trend (score drop > 30%) | Warning banner: "⚠️ Xu hướng đang giảm — cân nhắc tạo nội dung sớm" |
| Trend removed from platform | Row shows: "❌ Xu hướng đã bị xóa. [Gỡ khỏi watchlist]" |
| Max 10 watchlists per workspace | Create button disabled: "Tối đa 10 watchlist" |
| All items muted | Info: "Đã tắt thông báo tất cả. [Bật lại?]" |

---

## 9. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached list | Auto-retry online |
| Watchlist load fail | API error | Full-page: "Không tải được watchlist. [Thử lại]" | Retry |
| Remove item fail | Network error | Toast: "Không gỡ được. [Thử lại]" | Retry (row stays) |
| Mute fail | API error | Toast: "Không tắt được. [Thử lại]" | Retry |
| Create watchlist fail | Validation/API | Modal error: "Không tạo được. [Thử lại]" | Retry |

---

## 10. Accessibility

| Element | Requirement |
|---|---|
| Watchlist tabs | `role="tablist"`, tabs as `role="tab"` with `aria-selected` |
| Tab panel | `role="tabpanel"`, `aria-labelledby` matching tab |
| Trend row | `aria-label="{title}, điểm {score}, {delta}, {platform}"` |
| Score delta | `aria-label="↑+12 so với tuần trước"` or `"↓-20"` (not color-only) |
| Alert banner | `role="alert"` for threshold notifications |

---

## 11. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Tabs + skeleton rows |
| Tab data | 200-500ms | Rows populate with stagger |
| Sparklines | 500ms after rows | Inline SVG draws left→right |
| Tab switch | 100-300ms | Instant if cached, shimmer if not |

---

## 12. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `watchlist.viewed` | Page load | `watchlist_count`, `total_items`, `source` |
| `watchlist.tab_switched` | Tab click | `watchlist_id`, `watchlist_name`, `item_count` |
| `watchlist.idea_created` | "Tạo ý tưởng" | `trend_id`, `watchlist_id` |
| `watchlist.item_removed` | "❌ Xóa" | `trend_id`, `watchlist_id` |
| `watchlist.item_muted` | "🔕 Tắt thông báo" | `trend_id` |
| `watchlist.created` | New watchlist | `watchlist_name`, `threshold` |
| `watchlist.deleted` | Delete watchlist | `watchlist_id`, `item_count` |
| `watchlist.detail_clicked` | "→ Chi tiết" | `trend_id`, `score` |

---

## 13. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/intelligence/watchlist/+page.svelte`
- **Server load**: `+page.server.ts` → `WatchlistService/List` + `WatchlistService/GetItems(active_list)`
- **Active tab**: URL param `?list={watchlist_slug}` — shareable, persistent
- **Sparklines**: Pre-computed in API response (7-day snapshots)
- **Create modal**: `WatchlistService/Create({ name, alert_threshold })` → optimistic tab add
- **Mute**: `WatchlistService/MuteItem(item_id)` → toggle icon
- **Alert threshold**: Score-based — notification when watched trend crosses threshold

---

## 14. Localization Notes

- Tabs: "📌 Tất cả ({n})", plus watchlist names (user-defined)
- Status: "🔔 Thông báo bật", "🔕 Đã tắt"
- Alert: "🔔 Score vượt ngưỡng {threshold}"
- Declining: "⚠️ Xu hướng đang giảm — cân nhắc tạo nội dung sớm"
- Create: "Tên watchlist", "Ngưỡng cảnh báo (tùy chọn)"

---

## 15. Design Tokens

| Token | Usage |
|---|---|
| `--color-score-high` | Score ≥ 80 (green) |
| `--color-score-medium` | Score 50-79 (amber) |
| `--color-score-low` | Score < 50 (red) |
| `--color-delta-positive` | ↑ positive delta (green) |
| `--color-delta-negative` | ↓ negative delta (red) |
| `--color-alert-banner` | Alert threshold banner bg |
| `--color-accent` | Primary CTAs |
| `--color-surface-elevated` | Cards, rows |

---

## 16. Related Screens

| Screen | Relationship |
|---|---|
| [W009] Trend Radar | Source for adding items |
| [W010] Trend Detail | Target after clicking item |
| [M018] Mobile Watchlist | Mobile equivalent |

---

## 17. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 edge cases (max items, declining trend), 5 errors, tab a11y, 8 analytics, SvelteKit impl (URL param tabs), 8 design tokens. | System |
| 2026-03-27 | 1.0 | Initial specification | System |
