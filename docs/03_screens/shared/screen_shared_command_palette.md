# Shared: Command Palette (⌘K)

> **Screen ID**: S008
> **Module**: Shared — Platform Navigation
> **Platform**: Web only (SvelteKit)
> **Upstream**: Pack 01 §9D (Search UX), A1 Schema (search via Meilisearch), B5 RBAC

---

## 1. Purpose & Context

Universal command palette overlay for power users — fuzzy search across all entities, navigation shortcuts, action commands, and Copilot access. Provides instant access to any screen, object, or action in the system. Inspired by VS Code / Linear / Notion command palettes.

### User Story
> As a power user, I want to press ⌘K and instantly search, navigate, or trigger any action without touching the mouse.

### Business Goal
- Reduce time-to-action for experienced users
- Provide keyboard-first workflow alternative
- Surface less-discovered features through command registry
- Reduce navigational friction in deep module hierarchies

### When to Use
- Quick navigation to any screen
- Finding specific content (scripts, ideas, products)
- Executing actions without navigating to the source screen
- Accessing Copilot inline

### Entry Points
- Keyboard: `⌘K` (Mac) / `Ctrl+K` (Windows)
- Top nav search icon click
- Any "Search" placeholder focus → opens palette

### Exit Points
- Select result → navigate or execute action
- Press `Escape` → close
- Click outside → close

---

## 2. Preconditions / Postconditions

### Preconditions
- User is authenticated
- Web app loaded
- Meilisearch index available for entity search

### Postconditions
- Selected action executed (navigation, create, or search)
- Recent commands persisted (session storage)
- Analytics event logged

---

## 3. Layout Structure

### ASCII Wireframe — Idle State (no query)
```
┌─ Overlay (dimmed background) ─────────────────────────────────────────┐
│                                                                        │
│   ┌─ Command Palette (centered, 600px wide max) ──────────────────┐  │
│   │ [🔍 Nhập lệnh hoặc tìm kiếm...                        ⌘K]   │  │
│   ├────────────────────────────────────────────────────────────────┤  │
│   │ ── Gần đây ──                                                  │  │
│   │  📝 "5 tips nấu ăn" · Script                            ↵     │  │
│   │  🛍 "Serum Vitamin C" · Product                          ↵     │  │
│   │  📦 "#12345" · Order                                     ↵     │  │
│   │                                                                │  │
│   │ ── Điều hướng ──                                               │  │
│   │  🏠 Đi đến Dashboard                                    ↵     │  │
│   │  💡 Đi đến Ideas                                        ↵     │  │
│   │  📅 Đi đến Calendar                                     ↵     │  │
│   │  📊 Đi đến Analytics                                    ↵     │  │
│   │                                                                │  │
│   │ ── Hành động ──                                                │  │
│   │  ➕ Tạo script mới                                      ↵     │  │
│   │  ➕ Tạo ý tưởng mới                                     ↵     │  │
│   │  📤 Quick publish                                        ↵     │  │
│   │  🤖 Hỏi Copilot                                         ↵     │  │
│   │  ⚙️ Mở Cài đặt                                          ↵     │  │
│   │                                                                │  │
│   │ ── Context (current page) ──                                   │  │
│   │  📝 Tạo script từ xu hướng này                          ↵     │  │
│   │  📊 Xem analytics cho bài đang mở                       ↵     │  │
│   ├────────────────────────────────────────────────────────────────┤  │
│   │ ↑↓ Navigate · ↵ Select · Esc Close · Tab Switch Section      │  │
│   └────────────────────────────────────────────────────────────────┘  │
│                                                                        │
└────────────────────────────────────────────────────────────────────────┘
```

### ASCII Wireframe — Search State (query typed)
```
┌─ Command Palette ──────────────────────────────────────────────────────┐
│ [🔍 serum|                                                    ⌘K]    │
├────────────────────────────────────────────────────────────────────────┤
│ ▶ 📝 "**Serum** review script" · Script · Draft           ↵         │
│   🛍 "**Serum** Vitamin C 30ml" · Product · 🟢 In stock   ↵         │
│   📦 "#12345 — **Serum** HA" · Order · Pending             ↵         │
│   👤 "**Serum** Beauty KOC" · Contact · TikTok             ↵         │
│   📖 "Cách bán **serum** trên TikTok" · Help              ↵         │
│                                                                        │
│ ── Hành động ──                                                        │
│   ➕ Tạo script về "serum"                                  ↵         │
│   💡 Tạo ý tưởng về "serum"                                ↵         │
│   🔍 Tìm sâu hơn "serum" trong toàn bộ workspace          ↵         │
├────────────────────────────────────────────────────────────────────────┤
│ ↑↓ Navigate · ↵ Select · Esc Close                                    │
└────────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
CommandPalette (modal overlay)
├── BackdropOverlay (click → close)
├── PaletteContainer (centered, max-width: 600px, max-height: 70vh)
│   ├── SearchInput
│   │   ├── SearchIcon
│   │   ├── TextInput (auto-focus, placeholder: "Nhập lệnh hoặc tìm kiếm...")
│   │   ├── ShortcutBadge ("⌘K")
│   │   └── ClearButton (✕, when text present)
│   ├── ResultsContainer (scrollable)
│   │   ├── IdleView (no query — shown by default)
│   │   │   ├── RecentSection
│   │   │   │   ├── SectionHeader ("Gần đây")
│   │   │   │   └── RecentItem[] (icon + title + type + Enter icon)
│   │   │   ├── NavigationSection
│   │   │   │   ├── SectionHeader ("Điều hướng")
│   │   │   │   └── NavigationItem[] (icon + label)
│   │   │   ├── ActionsSection
│   │   │   │   ├── SectionHeader ("Hành động")
│   │   │   │   └── ActionItem[] (icon + label)
│   │   │   └── ContextSection (conditional — based on current page)
│   │   │       ├── SectionHeader ("Context")
│   │   │       └── ContextAction[]
│   │   ├── SearchView (has query)
│   │   │   ├── EntityResults (Meilisearch instant)
│   │   │   │   └── SearchResultItem[]
│   │   │   │       ├── TypeIcon
│   │   │   │       ├── HighlightedTitle
│   │   │   │       ├── TypeLabel + StatusBadge
│   │   │   │       └── SelectIndicator (↵)
│   │   │   └── ActionResults (query-derived actions)
│   │   │       ├── CreateActionItem ("Tạo script về '{query}'")
│   │   │       ├── IdeaActionItem ("Tạo ý tưởng về '{query}'")
│   │   │       └── DeepSearchItem ("Tìm sâu hơn")
│   │   └── NoResultsView
│   │       ├── Message ("Không tìm thấy kết quả")
│   │       └── SuggestionActions
│   └── FooterBar
│       ├── KeyBindings ("↑↓ Navigate · ↵ Select · Esc Close")
│       └── TabHint ("Tab → Switch section")
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Recent items | Session storage (client) | — | Icon + title + type (last 10) | Session-persistent |
| Navigation items | Static registry | — | Icon + Vietnamese label | Static |
| Action items | Static registry + context | — | Icon + label | Static |
| Context actions | Current page metadata | — | Icon + contextual label | On-render |
| Search results | Meilisearch | `SearchService/Query(q)` | Highlighted title + type badge | No cache |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | Open palette | ⌘K / Ctrl+K / search icon | — | — | Modal opens with focus on input | Any |
| 2 | Type query | Start typing | `SearchService/Query(q)` (debounced 100ms) | — | Instant results appear | Any |
| 3 | Navigate (↑↓) | Arrow keys | — | — | Selection highlight moves | Any |
| 4 | Select result | Enter key or click | — | — | Navigate to item or execute action | Based on result type |
| 5 | Navigate to page | Select navigation item | — | — | Route change + palette closes | Any |
| 6 | Execute action | Select action item | — | — | Action executed + palette closes | Based on action |
| 7 | Create from query | Select "Tạo script về '{query}'" | — | — | Navigate to create screen with pre-filled title | `content:create` |
| 8 | Ask Copilot | Select "🤖 Hỏi Copilot" | — | — | Open Copilot sidebar with query | Any |
| 9 | Deep search | Select "Tìm sâu hơn" | — | — | Navigate to full search page | Any |
| 10 | Close palette | Escape / click backdrop | — | — | Modal closes, return to previous state | Any |
| 11 | Clear query | Click ✕ or select all + delete | — | — | Reset to idle view | Any |
| 12 | Remove recent | Right-click or ⌫ on recent item | — (local) | Remove from session | Item removed | Any |

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| IDLE | Opened, no query | Recent + navigation + actions + context |
| SEARCHING | Query typed, debounce window | Brief loading indicator (100ms) |
| RESULTS | Query returned results | Entity results + action results |
| NO_RESULTS | Query returned 0 | "Không tìm thấy" + suggestion actions |
| ERROR | Search service error | "Tìm kiếm tạm thời lỗi. Thử lại." |
| CLOSED | Not visible | Hidden |

---

## 8. Validation Rules

| Field | Rule | Error Message |
|---|---|---|
| Query | Min 1 character to trigger search | — (no error, just don't search) |
| Query | Max 100 characters | Silent truncation |
| Recent items | Max 10 stored | FIFO — oldest removed |

---

## 9. Permission Matrix

Search results are permission-filtered server-side. Users only see objects they have access to.

| Object/Action Type | Shown to |
|---|---|
| Own scripts/ideas | All roles |
| Products/orders | Manager+ |
| Financial data | Admin+ |
| Settings actions | Admin+ |
| "Create" actions | Editor+ |

---

## 10. Navigation Map

```
Command Palette (⌘K — overlay)
├── → /dashboard                    (via "Go to Dashboard")
├── → /ideas                       (via "Go to Ideas")
├── → /calendar                    (via "Go to Calendar")
├── → /analytics                   (via "Go to Analytics")
├── → /scripts/new                 (via "Create script")
├── → /ideas/new                   (via "Create idea")
├── → /publish/quick               (via "Quick publish")
├── → /copilot                     (via "Ask Copilot")
├── → /settings                    (via "Settings")
├── → /scripts/[id]                (via script search result)
├── → /products/[id]               (via product search result)
├── → /orders/[id]                 (via order search result)
├── → /contacts/[id]               (via contact search result)
├── → /help/[article]              (via help search result)
├── → /search?q={query}            (via "Deep search")
└── ← Previous state               (via Escape/backdrop)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Search service down | Meilisearch unavailable | "Tìm kiếm tạm thời lỗi. Navigation vẫn hoạt động." | Navigation still works |
| Network error | No connectivity | "Offline — chỉ hiển thị navigation" | Navigation static items work |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Modal | `role="dialog"`, `aria-modal="true"`, `aria-label="Command palette"` |
| Input | `role="combobox"`, `aria-expanded`, `aria-controls="results"` |
| Results | `role="listbox"`, each item `role="option"` |
| Selected item | `aria-selected="true"`, visual highlight |
| Focus management | Focus trapped in modal, auto-focus input on open |
| Keyboard | Full keyboard navigation: ↑↓ (move), Enter (select), Escape (close), Tab (section) |
| Screen reader | Selected item announced: "Serum review script, Script, Draft" |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Modal open | <100ms | Fade-in overlay + scale-up dialog |
| Idle content | Instant | Static content from registry |
| Search (Meilisearch) | <50ms | Results appear instantly |
| Navigation | Instant | Route change after selection |
| Modal close | <100ms | Fade-out + scale-down |

---

## 14. Performance Requirements

| Metric | Target |
|---|---|
| Open latency | <100ms (⌘K → visible) |
| Keystroke to results | <150ms (100ms debounce + 50ms Meilisearch) |
| Modal render | <16ms (60fps animation) |
| Memory | No DOM leaks on open/close cycles |

---

## 15. Real-time Updates

N/A — Command palette fetches fresh on each open. No persistent connection.

---

## 16. Localization Notes

- Labels: Vietnamese (navigation, actions, sections)
- Shortcut display: Platform-specific ("⌘K" on Mac, "Ctrl+K" on Windows)
- Search: supports Vietnamese diacritics (Meilisearch handles this)

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `command_palette.opened` | ⌘K pressed | `source` (keyboard/icon) |
| `command_palette.searched` | Query typed | `query_length`, `result_count` |
| `command_palette.selected` | Item selected | `item_type` (navigation/action/search), `item_id`, `position` |
| `command_palette.closed` | Dismissed | `had_query`, `had_selection` |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-surface-overlay` | Backdrop dimming |
| `--color-surface-dialog` | Palette background |
| `--color-accent` | Selected item highlight |
| `--color-text-primary` | Item labels |
| `--color-text-secondary` | Type badges, section headers |
| `--radius-dialog` | Palette border radius (12px) |
| `--shadow-large` | Palette drop shadow |

---

## 19. Related Screens

| Screen | Relationship |
|---|---|
| [W004] Web Global Search | Full search page (deep search link) |
| [M005] Mobile Search | Mobile equivalent (full-screen overlay) |
| [S005] Navigation | Shared navigation patterns |

---

## 20. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 3.0 | Full 20-point upgrade from 51-line Tier C. Added idle state with 4 sections, search state with fuzzy results, context-aware actions, keyboard navigation spec, full accessibility (combobox pattern), Meilisearch integration, performance targets (<100ms open). Fixed Screen ID (S08→S008). | System |
