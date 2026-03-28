# Screen: Mobile — Universal Search

> **Screen ID**: M005
> **Module**: M01 — Home / Daily Decision Engine
> **Route**: `/m/search` (full-screen overlay)
> **Platform**: Mobile (Flutter)
> **Upstream**: Pack 01 §9D (Search UX Contract), A1 Schema (search via Meilisearch), B5 RBAC

---

## 1. Purpose & Context

Full-screen universal search overlay that searches across all workspace objects — ideas, scripts, assets, products, orders, contacts, threads, workflows, and help articles. Powered by Meilisearch with <50ms instant results, typo tolerance, and faceted grouping.

### User Story
> As a creator on mobile, I want to quickly find any item in my workspace by typing a few characters so I can take action immediately.

### Business Goal
- Reduce time-to-object (find anything in <3 taps)
- Accelerator for power users who know what they want
- Reduce navigation friction in deep module structures

### When to Use
- Finding specific content (scripts, ideas, contacts)
- Navigating to a specific order or product by name/ID
- Searching help articles for guidance
- Quick access to recently viewed items

### Entry Points
- Home screen: 🔍 search icon in top bar
- Pull-down gesture from Home
- Any screen: search icon in app bar (if present)
- Global shortcut (shake device — optional, configurable)

### Exit Points
- Tap search result → navigate to item detail
- Tap "✕" → dismiss overlay, return to previous screen
- System back → dismiss overlay
- Tap recent search → re-execute search

---

## 2. Preconditions / Postconditions

### Preconditions
- User is authenticated
- Meilisearch index populated with workspace data

### Postconditions
- Search query logged for recent searches (local storage)
- Navigation to selected result
- Analytics event tracked

---

## 3. Layout Structure

### ASCII Wireframe — Idle State
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ [🔍 Tìm kiếm mọi thứ...                                    ] [✕]  │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│ ── Tìm kiếm gần đây ──                                              │
│ 🕐 serum review                                               [✕]  │
│ 🕐 order #12345                                               [✕]  │
│ 🕐 skincare tips                                               [✕]  │
│ [Xóa lịch sử tìm kiếm]                                             │
│                                                                       │
│ ── Hành động nhanh ──                                                │
│ [✨ Tạo ý tưởng] [📝 Viết script] [📤 Đăng bài] [🔥 Xu hướng]    │
│                                                                       │
│ ── Đã xem gần đây ──                                                │
│ 📝 "5 tips nấu ăn" · Script · 30m ago                               │
│ 🛍 "Serum HA" · Product · 1h ago                                    │
│ 📦 "#12345" · Order · 2h ago                                         │
│                                                                       │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [📋] [➕] [💬] [👤]                                            │
└──────────────────────────────────────────────────────────────────────┘
```

### ASCII Wireframe — Results State
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ [🔍 serum|                                                   ] [✕]  │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│ ── 📝 Scripts (3) ──────────────────────────────────────────────     │
│ ┌─────────────────────────────────────────────────────────────────┐  │
│ │ 📝 "**Serum** review script"                                    │  │
│ │    Draft · M06 · 5 ngày trước                                   │  │
│ │    [▶ Preview]                                                   │  │
│ ├─────────────────────────────────────────────────────────────────┤  │
│ │ 📝 "Top 5 **serum** cho da dầu"                                │  │
│ │    Approved · M06 · 2 tuần trước                                │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│ [→ Xem tất cả 3 scripts]                                            │
│                                                                       │
│ ── 🛍 Products (2) ─────────────────────────────────────────────     │
│ ┌─────────────────────────────────────────────────────────────────┐  │
│ │ 🛍 "**Serum** HA 100ml"                                        │  │
│ │    🟢 In stock · 250.000đ                                       │  │
│ ├─────────────────────────────────────────────────────────────────┤  │
│ │ 🛍 "**Serum** Vitamin C 30ml"                                  │  │
│ │    🟡 Low stock (3) · 180.000đ                                  │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ── 📦 Orders (1) ──────────────────────────────────────────────      │
│ │ 📦 "#12345" · **Serum** HA · Chờ xử lý · 350.000đ             │  │
│                                                                       │
│ ── 👤 Contacts (1) ────────────────────────────────────────────      │
│ │ 👤 "Nguyễn A" · ⭐ VIP · "**serum** inquiry"                  │  │
│                                                                       │
│ ── 📖 Help (2) ────────────────────────────────────────────────      │
│ │ 📖 "Cách bán **serum** trên TikTok Shop"                      │  │
│                                                                       │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [📋] [➕] [💬] [👤]                                            │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
SearchOverlay (full-screen)
├── SearchHeader
│   ├── SearchInput (auto-focus, clearable)
│   │   ├── SearchIcon prefix
│   │   ├── TextInput (placeholder "Tìm kiếm mọi thứ...")
│   │   └── ClearButton (✕ — appears when text entered)
│   └── CloseButton (✕ — dismisses overlay)
├── SearchContent (conditional by state)
│   ├── IdleView (no query)
│   │   ├── RecentSearchesList
│   │   │   ├── RecentSearchItem[]
│   │   │   │   ├── ClockIcon
│   │   │   │   ├── SearchText
│   │   │   │   └── RemoveButton (✕)
│   │   │   └── ClearAllLink
│   │   ├── QuickActionsRow
│   │   │   └── QuickActionChip[] (scrollable horizontal)
│   │   └── RecentlyViewedList
│   │       └── RecentViewedItem[]
│   │           ├── ObjectTypeIcon
│   │           ├── ObjectTitle
│   │           ├── ObjectMeta (type, time)
│   │           └── TapAction → navigate
│   ├── ResultsView (has query + has results)
│   │   └── ResultGroup[]
│   │       ├── GroupHeader (icon + type + count)
│   │       ├── SearchResultCard[] (max 3 per group)
│   │       │   ├── ObjectTypeIcon
│   │       │   ├── HighlightedTitle (bold matched text)
│   │       │   ├── StateBadge
│   │       │   ├── MetaLine (module, date, price, etc.)
│   │       │   └── QuickActionButton (optional — inline action)
│   │       └── ViewAllLink (if more than 3)
│   ├── NoResultsView (has query + no results)
│   │   ├── EmptyIllustration
│   │   ├── Message ("Không tìm thấy kết quả cho '{query}'")
│   │   └── Suggestions
│   │       ├── "Thử từ khóa khác"
│   │       ├── "Kiểm tra chính tả"
│   │       └── QuickActionChips (create new items)
│   └── SearchingView (debounce loading)
│       └── ShimmerResultGroups
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Recent searches | Local storage (device) | — | Plain text list | Persistent |
| Recently viewed | Local storage + `recent_views` | — | Object card list (max 10) | Persistent |
| Search results | Meilisearch | `SearchService/Query(q, filters)` | Grouped by type, max 3/group | No cache |
| Result highlight | Meilisearch `_matchesPosition` | same | **Bold** matched substring | No cache |
| Object state | Included in search index | same | State badge (🟢/🟡/🔴) | No cache |
| Object price | Included in search index | same | VND formatted (250.000đ) | No cache |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | Type search query | Start typing in search input | `SearchService/Query(q)` (debounced 150ms) | — | Results appear instantly (<50ms from Meilisearch) | Any role |
| 2 | Open result | Tap search result card | — | — | Navigate to object detail screen | Based on object type |
| 3 | Re-execute recent search | Tap recent search item | `SearchService/Query(q)` | — | Populate input + show results | Any role |
| 4 | Remove recent search | Tap ✕ on recent search | — (local) | Remove from local storage | Item fades out | Any role |
| 5 | Clear all recent | Tap "Xóa lịch sử" | — (local) | Clear local storage | List clears | Any role |
| 6 | View all in group | Tap "Xem tất cả 3 scripts" | `SearchService/Query(q, type_filter)` | — | Navigate to filtered list | Based on type |
| 7 | Quick action | Tap quick action chip | — | — | Navigate to create screen | Based on action |
| 8 | Dismiss search | Tap ✕ or system back | — | — | Overlay animates out, return to previous screen | Any role |
| 9 | Clear query | Tap ✕ in search input | — | — | Input clears, show Idle view | Any role |
| 10 | Voice search | Tap 🎤 (if available) | Platform speech-to-text | — | Transcript fills search input | Any role |

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| IDLE | Overlay opened, no query typed | Recent searches + quick actions + recently viewed |
| SEARCHING | User typing, debounce in progress | Brief shimmer below input (150ms debounce window) |
| RESULTS | Query returned results | Grouped result cards |
| NO_RESULTS | Query returned 0 results | Empty illustration + suggestions |
| ERROR | Search service error | "Không thể tìm kiếm. [Thử lại]" |
| OFFLINE | No network | "Đang offline. Hiển thị kết quả đã lưu." + cached recent items only |

---

## 8. Validation Rules

| Field | Rule | Error Message |
|---|---|---|
| Search query | Min 1 character to trigger search | — (no error, just don't search) |
| Search query | Max 100 characters | Silent truncation |
| Recent searches | Max 20 items stored | FIFO — oldest removed |
| Recently viewed | Max 10 items stored | FIFO |

---

## 9. Permission Matrix

| Object Type | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| Search (all types) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| See scripts | ✅ | ✅ | ✅ | ✅ | ✅ Own | ✅ Read | ❌ |
| See products | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| See orders | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| See financial data | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |

> **Note**: Search results are permission-filtered server-side. Users only see objects they have access to.

---

## 10. Navigation Map

```
Search (/m/search — overlay)
├── → /m/scripts/[id]     (via script result)
├── → /m/ideas/[id]       (via idea result)
├── → /m/products/[id]    (via product result)
├── → /m/orders/[id]      (via order result)
├── → /m/contacts/[id]    (via contact result)
├── → /m/threads/[id]     (via thread result)
├── → /m/help/[article]   (via help result)
├── → /m/ideas/new        (via quick action)
├── → /m/scripts/new      (via quick action)
├── → /m/publish/quick     (via quick action)
├── → /m/trends            (via quick action)
└── ← Previous screen      (via dismiss)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Search service down | Meilisearch unavailable | "Tìm kiếm tạm thời không khả dụng. Thử lại sau." | Auto-retry after 5s |
| Network error | No connectivity | "Đang offline" + show only recent items | Auto-search when reconnected |
| Timeout | Search > 3s | "Tìm kiếm mất quá lâu. [Thử lại]" | Manual retry |
| Rate limited | Too many queries | Silent — debounce handles this | Built-in debounce |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Search input | `semanticsLabel: "Tìm kiếm mọi thứ"`, auto-focus on open |
| Results | Each result is focusable with clear label |
| Groups | Group headers use `Semantics(header: true)` |
| Empty state | `Semantics(liveRegion: true)` for dynamic result changes |
| Dismiss | Close button has `semanticsLabel: "Đóng tìm kiếm"` |
| Keyboard | Soft keyboard auto-opens, search on "done" key |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Overlay open | 200ms | Slide-up animation + auto-focus input |
| Debounce | 150ms | No visual indicator (too fast) |
| Search execution | <50ms (Meilisearch) | Results appear instantly |
| Slow connection | 50-500ms | Shimmer result groups |
| Overlay close | 150ms | Slide-down animation |

---

## 14. Performance Requirements

| Metric | Target |
|---|---|
| Overlay render | <200ms |
| Search response (Meilisearch) | <50ms |
| Total type-to-result | <200ms (150ms debounce + 50ms search) |
| Max results per group | 3 (expandable) |
| Max total results | ~20 on screen (8 groups × 3 items) |

---

## 15. Real-time Updates

N/A — Search results are fetched on demand. No real-time push to search.

---

## 16. Localization Notes

- Placeholder: Vietnamese ("Tìm kiếm mọi thứ...")
- Results: Display in user's language
- Prices: VND formatted
- Dates: Relative time (30m trước, 2 ngày trước)

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `search.opened` | Overlay opens | `source` (home_icon, pull_down, etc.) |
| `search.queried` | Query executed (debounced) | `query_length`, `result_count`, `latency_ms` |
| `search.result_tapped` | Tap result | `object_type`, `object_id`, `position` |
| `search.no_results` | Empty results | `query` |
| `search.recent_tapped` | Tap recent search | `query` |
| `search.quick_action` | Tap quick action | `action_type` |
| `search.dismissed` | Close overlay | `had_query`, `had_results` |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-surface-overlay` | Search overlay background (semi-transparent) |
| `--color-text-primary` | Result titles |
| `--color-text-secondary` | Meta text (dates, module) |
| `--color-accent` | Highlighted match text |
| `--color-surface-elevated` | Result cards |
| `--radius-card` | Result card radius |

---

## 19. Related Screens

| Screen | Relationship |
|---|---|
| [W004] Web Global Search | Web equivalent |
| [S008] Command Palette | Web command palette (⌘K) |
| [M001] Mobile Home | Parent — search icon in app bar |

---

## 20. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 3.0 | Full 20-point upgrade from 62-line Tier C. Added idle state wireframe, component hierarchy, 10 actions, permission-filtered results, voice search, recently viewed, quick actions, full accessibility spec, performance requirements (<50ms search), analytics tracking. Fixed Screen ID (M006→M005). | System |
| 2026-03-28 | 2.0 | Expanded from sparse | System |
| 2026-03-28 | 1.0 | Initial specification | System |
