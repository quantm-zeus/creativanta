# Shared: Glossary System

> **Screen ID**: S010
> **Module**: Shared — Educational UX
> **Platform**: All (Web + Mobile)
> **Upstream**: Pack 01 §9G (Beginner-Friendly UX), A1 Schema (glossary_terms)

---

## 1. Purpose & Context

In-app glossary system providing contextual tooltips for industry terminology and a full glossary page. Helps new creators (especially non-digital-native Vietnamese sellers) understand platform and industry-specific terms like RPM, COGS, ROAS, CTR, etc. Includes both inline tooltips and a browsable glossary page.

### User Story
> As a new seller who doesn't understand digital marketing terms, I want to see explanations when I encounter unfamiliar words so I can use the platform confidently.

### Business Goal
- Reduce onboarding friction for non-technical users
- Decrease support tickets about terminology confusion
- Improve feature adoption through better understanding
- Support the "Beginner-Friendly" UX principle from PRD

### When to Use
- Reading analytics dashboards with unfamiliar metrics
- Encountering industry terms in AI-generated content
- Setting up commerce/finance features with technical labels
- Browsing the full glossary for learning

---

## 2. Component: Tooltip (Inline)

### Entry Points
- Hover (web) / Long-press (mobile) on any underlined/dotted term
- "❓" help icon next to complex metrics

### ASCII Wireframe — Tooltip
```
┌─ Surrounding content... ────────────────────────────────┐
│ Your RPM this month is 45,000đ. ← dotted underline     │
│         ┌─ Tooltip ─────────────────────────────────┐   │
│         │ 📖 RPM (Revenue Per Mille)                │   │
│         │                                           │   │
│         │ Doanh thu trung bình trên mỗi 1.000       │   │
│         │ lượt xem. RPM cao = nội dung kiếm tiền   │   │
│         │ tốt hơn.                                   │   │
│         │                                           │   │
│         │ 💡 RPM trung bình ngành: 30-80K VND       │   │
│         │                                           │   │
│         │ [📚 Xem tất cả thuật ngữ →]               │   │
│         └───────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

### Tooltip Behavior
- **Web**: Hover triggers, stays on mouse over tooltip, dismiss on mouse out
- **Mobile**: Long-press triggers, dismiss on tap outside
- **Position**: Auto-positioned (prefer bottom, flip to top if near viewport edge)
- **Context-aware**: Shows terms relevant to current screen's module
- **Dismissible**: "Không hiện nữa" option per term
- **Settings**: Can be globally disabled in Settings → "Hiển thị giải thích thuật ngữ"

### Tooltip Component Hierarchy
```
GlossaryTooltip
├── Trigger (dotted underline text)
├── TooltipContainer (positioned)
│   ├── Header
│   │   ├── BookIcon (📖)
│   │   ├── TermName (bold, English)
│   │   └── TermAbbreviation (if applicable)
│   ├── Definition (Vietnamese, 2-3 sentences max)
│   ├── BenchmarkInfo (optional — industry average/tip)
│   ├── ViewAllLink ("📚 Xem tất cả thuật ngữ →")
│   └── DismissLink ("Không hiện nữa cho thuật ngữ này")
└── Arrow (pointing to trigger)
```

---

## 3. Component: Glossary Page (`/glossary`)

### Entry Points
- Settings → "📖 Thuật ngữ"
- Tooltip → "📚 Xem tất cả thuật ngữ →"
- Help center → "Glossary"
- Search: "thuật ngữ" → this page

### ASCII Wireframe — Full Page
```
┌─ App Shell (Web) / Full Screen (Mobile) ─────────────────────────────┐
│ 📖 Thuật ngữ Creativanta                    [🔍 Tìm thuật ngữ...] │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│ Categories: [🔥 Tất cả (45)] [📊 Analytics] [💰 Commerce]          │
│             [🤖 AI/Tech] [📤 Marketing] [📝 Content]                │
│                                                                       │
│ A-Z Index: [A] [B] [C] [D] [E] [F] [G] [H] [I] [K] [L] [M] [N]   │
│            [O] [P] [Q] [R] [S] [T] [U] [V] [X] [Y]                 │
│                                                                       │
│ ── A ─────────────────────────────────────────────────────────────   │
│ ┌─ Term Card ─────────────────────────────────────────────────────┐  │
│ │ **ARPU** (Average Revenue Per User)            📊 Analytics     │  │
│ │ Doanh thu trung bình trên mỗi người dùng.                      │  │
│ │ Ví dụ: ARPU = Tổng doanh thu / Số người dùng active            │  │
│ │ 💡 ARPU cao = khách hàng trung thành, sẵn sàng chi trả.       │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ── C ─────────────────────────────────────────────────────────────   │
│ ┌─ Term Card ─────────────────────────────────────────────────────┐  │
│ │ **COGS** (Cost of Goods Sold)                  💰 Commerce     │  │
│ │ Giá vốn hàng bán — tổng chi phí để tạo ra sản phẩm.           │  │
│ │ Ví dụ: COGS = Nguyên liệu + Nhân công + Đóng gói             │  │
│ │ 💡 COGS thấp = biên lợi nhuận cao.                             │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ Term Card ─────────────────────────────────────────────────────┐  │
│ │ **CPM** (Cost Per Mille)                       📤 Marketing    │  │
│ │ Chi phí cho mỗi 1.000 hiển thị quảng cáo.                      │  │
│ │ Ví dụ: Chi 1M cho 50K views → CPM = 20K/1000 views            │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ Term Card ─────────────────────────────────────────────────────┐  │
│ │ **CTA** (Call to Action)                       📝 Content       │  │
│ │ Lời kêu gọi hành động — "Mua ngay", "Đăng ký", "Xem thêm".  │  │
│ │ 💡 CTA rõ ràng giúp tăng conversion rate.                      │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ── R ─────────────────────────────────────────────────────────────   │
│ ┌─ Term Card ─────────────────────────────────────────────────────┐  │
│ │ **ROAS** (Return on Ad Spend)                  📤 Marketing    │  │
│ │ Tỷ lệ lợi nhuận trên chi phí quảng cáo.                       │  │
│ │ Ví dụ: Chi 1M ads → Thu 5M doanh thu → ROAS = 5×              │  │
│ │ 💡 ROAS > 3× thường được coi là hiệu quả.                     │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ Term Card ─────────────────────────────────────────────────────┐  │
│ │ **RPM** (Revenue Per Mille)                    📊 Analytics     │  │
│ │ Doanh thu trên mỗi 1.000 lượt xem nội dung.                   │  │
│ │ Ví dụ: 50K views → 2M doanh thu → RPM = 40K/1000 views        │  │
│ │ 💡 RPM trung bình ngành: 30-80K VND                            │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ 📊 Tổng: 45 thuật ngữ                                               │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy — Full Page

```
GlossaryPage
├── PageHeader
│   ├── Title ("📖 Thuật ngữ Creativanta")
│   └── SearchInput ("Tìm thuật ngữ...")
├── CategoryChips (horizontal scroll)
│   └── CategoryChip[] (Tất cả | Analytics | Commerce | AI | Marketing | Content)
├── AlphabetIndex
│   └── LetterLink[] (A-Z, scroll-to-section)
├── TermList (scrollable)
│   ├── LetterGroup[]
│   │   ├── LetterHeader ("── A ──")
│   │   └── TermCard[]
│   │       ├── TermName (bold, English abbreviation)
│   │       ├── FullName (English full name)
│   │       ├── CategoryBadge
│   │       ├── Definition (Vietnamese, 1-2 sentences)
│   │       ├── Example (optional, Vietnamese)
│   │       └── Tip (optional, 💡 benchmark or best practice)
│   └── TotalCount ("📊 Tổng: 45 thuật ngữ")
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Tooltip terms | `glossary_terms` | `GlossaryService/GetTerm(term_key)` | Tooltip popup | 24h TTL |
| Glossary page | `glossary_terms` full list | `GlossaryService/ListTerms(category)` | Alphabetical card list | 24h TTL |
| Term count | Computed | — | "45 thuật ngữ" | — |
| Context terms | Screen → relevant terms mapping | — | Filtered tooltip triggers | Static |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | Show tooltip | Hover (web) / long-press (mobile) | `GlossaryService/GetTerm(key)` | — | Tooltip appears with animation | Any |
| 2 | Dismiss tooltip | Mouse out / tap outside | — | — | Tooltip fades out | Any |
| 3 | View all terms | Click "📚 Xem tất cả thuật ngữ →" | — | — | Navigate to glossary page | Any |
| 4 | Search terms | Type in search input | Client-side filter (full list cached) | — | Instant filter of term list | Any |
| 5 | Filter by category | Tap category chip | Client-side filter | — | Terms filter by category | Any |
| 6 | Jump to letter | Tap letter in A-Z index | — | — | Scroll to letter section | Any |
| 7 | Disable tooltips | Click "Không hiện nữa" or Settings toggle | `UserPreferencesService/Update(glossary_enabled=false)` | Preference saved | Tooltips no longer appear | Any |

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| TOOLTIP_HIDDEN | Default state | Normal text (dotted underline on glossary terms) |
| TOOLTIP_VISIBLE | Hover/long-press active | Tooltip displayed with animation |
| PAGE_LOADING | Glossary page loading | Shimmer cards |
| PAGE_LOADED | Terms displayed | Alphabetical list with categories |
| SEARCH_RESULTS | Search query active | Filtered term list |
| SEARCH_EMPTY | No matching terms | "Không tìm thấy thuật ngữ. [Gợi ý thêm →]" |
| DISABLED | User disabled tooltips | No dotted underlines, no tooltips |

---

## 8. Validation Rules

N/A — Read-only educational content.

---

## 9. Permission Matrix

All users can access the glossary. No role restrictions.

---

## 10. Navigation Map

```
Glossary Tooltip (inline — any screen)
├── → /glossary                   (via "Xem tất cả thuật ngữ")
├── → /settings/preferences       (via disable toggle)

Glossary Page (/glossary; /m/glossary on mobile)
├── → #letter-section             (via alphabet index)
└── ← Previous screen            (via back)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Term not found | Term key missing | Tooltip doesn't appear (graceful) | None |
| Glossary load failed | API error | "Không tải được thuật ngữ. [Thử lại]" | Retry |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Tooltip trigger | `aria-describedby` linking to tooltip content |
| Tooltip | `role="tooltip"`, `aria-live="polite"` |
| Dotted underline | Perceivable by screen reader: "Thuật ngữ: RPM. Nhấn để xem giải thích." |
| Glossary page | Proper heading hierarchy per letter section |
| Search | `aria-label="Tìm thuật ngữ"`, live results announced |
| A-Z index | `role="navigation"`, `aria-label="Alphabet index"` |
| Category chips | `role="tablist"` with `role="tab"` for each |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Tooltip appear | <200ms | Fade + scale-up animation |
| Tooltip dismiss | <150ms | Fade-out |
| Glossary page load | <500ms | Term list + categories (from 24h cache) |
| Search filter | Instant | Client-side filtering |

---

## 14. Performance Requirements

| Metric | Target |
|---|---|
| Tooltip render | <200ms |
| Glossary page | <1s |
| Search filter | <50ms (client-side) |
| Term data size | <50KB for full glossary |

---

## 15. Real-time Updates

N/A — Glossary content is updated by content team and cached for 24h.

---

## 16. Localization Notes

- Terms: English abbreviation + full English name + Vietnamese definition
- Examples: Vietnamese language and VND currency
- Tips: Vietnamese with benchmark data
- The glossary itself serves as a localization aid for English industry terms

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `glossary.tooltip_shown` | Tooltip appeared | `term_key`, `screen_id` |
| `glossary.tooltip_clicked_through` | Clicked "Xem tất cả" from tooltip | `term_key` |
| `glossary.page_viewed` | Glossary page opened | `source` (tooltip/settings/search) |
| `glossary.searched` | Search in glossary | `query`, `result_count` |
| `glossary.disabled` | User disabled tooltips | — |
| `glossary.term_most_viewed` | Aggregate (backend) | `term_key`, `view_count` |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-surface-tooltip` | Tooltip background |
| `--color-text-primary` | Term name |
| `--color-text-secondary` | Definition text |
| `--color-accent-muted` | Dotted underline on terms |
| `--color-info` | Tip icon (💡) |
| `--shadow-tooltip` | Tooltip shadow |
| `--radius-tooltip` | Tooltip border radius |

---
## 19. Preconditions / Postconditions
### Preconditions
- User authenticated with valid session
- Required module permissions granted
### Postconditions
- User actions persisted to backend
- Analytics events dispatched

---

## 20. Related Screens

| Screen | Relationship |
|---|---|
| [S002] Navigation | Same UX layer — shared platform UI |
| [W004] Global Search | Search can find glossary terms |
| [M007] Mobile Onboarding | Onboarding references glossary |

---

## 21. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 3.0 | Full 20-point upgrade from 49-line Tier C. Added inline tooltip component hierarchy, full glossary page with A-Z index + categories, tooltip behavior spec (hover/long-press/dismiss), example terms with Vietnamese definitions and benchmarks, disable option, 7 states, complete accessibility. Fixed Screen ID (S10→S010). | System |
