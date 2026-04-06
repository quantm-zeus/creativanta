# Screen: Web — Global Search

> **Screen ID**: W004
> **Module**: M01 — Home & Decision
> **Route**: `/search` (also: Cmd+K overlay)
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4, Meilisearch integration

---

## 1. Purpose & Context

Global Search provides instant cross-entity search across ideas, scripts, trends, products, orders, contacts, and asset files. Powered by Meilisearch for typo-tolerant, sub-50ms results. Accessible via Cmd+K shortcut anywhere in the app.

### User Story
> As a creator, I want to quickly find any item in my workspace by name, tag, or content.

### Entry Points
- TopBar: 🔍 Search icon
- Keyboard shortcut: Cmd+K (Mac) / Ctrl+K (Windows)
- Direct URL: `/search?q=...`

---

## 2. Layout Structure

### Cmd+K Overlay Mode
```
┌─ Overlay (centered, 600px wide) ────────────────────────────────────┐
│ 🔍 [Tìm kiếm ý tưởng, script, xu hướng, sản phẩm...         ]   │
├──────────────────────────────────────────────────────────────────────┤
│ Gần đây:                                                            │
│ 💡 "5 sai lầm skincare"      Idea · 2h ago                        │
│ 📝 "Serum review script"     Script · 1d ago                       │
│ 🔥 "AI cooking"              Trend · 3h ago                        │
├──────────────────────────────────────────────────────────────────────┤
│ When typing:                                                         │
│ Result: "skin" → 12 kết quả                                        │
│ 💡 "5 sai lầm skincare"      Idea · ⭐88                          │
│ 📝 "Skincare review"         Script · Draft                        │
│ 🔥 "Minimalist skincare"     Trend · ⭐78                         │
│ 🛍 "Serum VitC"              Product · 299K                       │
│ 👤 "Skincare Queen"          Competitor                             │
│ [↵ Enter to open] [↑↓ Navigate] [→ Full results]                  │
└──────────────────────────────────────────────────────────────────────┘
```

### Full Page Mode (`/search?q=...`)
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 🔍 Tìm kiếm: "skincare"                     12 kết quả            │
├──────────────────────────────────────────────────────────────────────┤
│ Filter: [Tất cả] [💡 Ideas] [📝 Scripts] [🔥 Trends]              │
│         [🛍 Products] [📦 Orders] [👤 Contacts]                    │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ── 💡 Ideas (3) ──                                                   │
│ 💡 "5 sai lầm **skin**care"     ⭐88 · Evaluating · 2h ago         │
│ 💡 "**Skin** glass routine"     ⭐72 · Inbox · 1d ago              │
│ 💡 "Budget **skin**care"        ⭐65 · Done · 5d ago               │
│                                                                      │
│ ── 📝 Scripts (2) ──                                                 │
│ 📝 "**Skin**care review"        Draft · 134 words · 3h ago         │
│ 📝 "Morning **skin** routine"   Approved · 98 words · 2d ago       │
│                                                                      │
│ ── 🔥 Trends (2) ──                                                 │
│ ... grouped by entity type ...                                       │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3. Component Hierarchy

```
GlobalSearch
├── SearchOverlay (Cmd+K mode)
│   ├── SearchInput (auto-focus, debounced)
│   ├── RecentSearches (when empty query)
│   │   └── RecentItem[] (icon + title + type + time)
│   └── SearchResults (when query)
│       └── ResultItem[] (icon + title + type + meta)
└── SearchPage (full page mode)
    ├── SearchInput (URL-synced)
    ├── FilterChips (entity type filter)
    └── GroupedResults
        └── ResultGroup[] (grouped by entity type)
            ├── GroupHeader (icon + type + count)
            └── ResultRow[]
                ├── EntityIcon
                ├── HighlightedTitle (bold matched text)
                ├── EntityType
                ├── MetadataSnippet
                └── ClickTarget
```

---

## 4-5. Data & Actions

| UI Element | Source | API |
|---|---|---|
| Results | Meilisearch multi-index | `SearchService/Query(q, filters)` |
| Recent | localStorage | Client-side |
| Highlights | Meilisearch `_highlightResult` | Auto |

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Search | Type in input (300ms debounce) | `SearchService/Query(q)` | Results update | Any |
| 2 | Open result | Click or Enter | — | Navigate to entity page | Varies |
| 3 | Filter by type | Click filter chip | Refetch with type | Filtered results | Any |
| 4 | Close overlay | Esc or click outside | — | Overlay closes | Any |
| 5 | Navigate results | ↑↓ arrow keys | — (client) | Highlight moves | Any |
| 6 | Full results | "→ Full results" | — | Navigate to `/search?q=...` | Any |

---

## 6-20. Standard Sections

### States
| State | Visual |
|---|---|
| EMPTY_QUERY | Recent searches shown |
| LOADING | "Đang tìm..." spinner |
| RESULTS | Grouped results with highlights |
| NO_RESULTS | "Không tìm thấy kết quả cho '[query]'" |

### Performance
- Meilisearch: < 50ms response time
- Debounce: 300ms
- Overlay render: < 100ms
- Max 10 results in overlay, 50 in full page

### Accessibility
- `role="combobox"` on search input
- `role="listbox"` on results
- `aria-activedescendant` for keyboard navigation
- Cmd+K: announce "Search opened" to screen reader

### Technical Notes
- Overlay: Svelte component in `AppShell/SearchOverlay.svelte`
- Full page: `src/routes/(app)/search/+page.svelte`
- Meilisearch indexes: ideas, scripts, trends, products, orders, contacts
- Recent: localStorage `recent_searches`, max 10 items

### Related Screens
Every screen in the app (accessible from topbar Cmd+K)

### Revision History
| Date | Version | Change |
|---|---|---|
| 2026-03-28 | 1.0 | Initial specification |
