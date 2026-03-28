# Shared: Loading States

> **Screen ID**: S01
> **Module**: Shared — UI States
> **Platform**: All (Web + Mobile)
> **Upstream**: Design Tokens (D1)

---

## 1. Purpose & Context

Standardized loading patterns used across all screens. AI never needs to guess loading behavior — follow these deterministic rules.

---

## 2. Loading Patterns

### Skeleton Loading (Default)
Used for: Lists, cards, tables, dashboards

```
Web Skeleton:
┌──────────────────────────────────────────────┐
│ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░ (title shimmer)      │
│ ▓▓▓▓▓▓▓▓▓▓░░░ (subtitle)                    │
│ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░ (body)          │
│ ▓▓▓▓▓░░ [▓▓▓]  [▓▓▓] (actions)              │
└──────────────────────────────────────────────┘

Mobile Skeleton:
┌──────────────────────────┐
│ [▓▓▓] ▓▓▓▓▓▓▓░░ (row)   │
│ [▓▓▓] ▓▓▓▓▓▓▓░░ (row)   │
│ [▓▓▓] ▓▓▓▓▓▓▓░░ (row)   │
└──────────────────────────┘
```

### Rules by Screen Type
| Type | Skeleton Count | Animation |
|---|---|---|
| Dashboard KPIs | 4 metric cards | Shimmer left →right |
| List / Table | 6 rows | Shimmer left →right |
| Kanban | 3 columns × 2 cards | Fade in |
| Full-page editor | Content area + sidebar | Pulse |
| Chart | Placeholder rectangle | Pulse |
| Detail page | Header + 3 sections | Shimmer |

### Spinner (Secondary)
Used for: Button actions, inline refreshes, AI generation
- Button: Replace text with spinner, disabled state
- Inline: Small spinner next to element

### Progress Bar (Long)
Used for: AI generation, file uploads, bulk operations
- Determinate: Show percentage when known
- Indeterminate: Pulsing bar when unknown
- Time estimate: "~30s remaining"

### Pull-to-Refresh (Mobile Only)
- Trigger at 60px overscroll
- Custom branded spinner
- Release-to-refresh at 120px

---

## 3. Timing Rules

| Duration | Pattern | Example |
|---|---|---|
| <300ms | No indicator | API fetch with cache |
| 300ms-2s | Skeleton/Spinner | Standard page load |
| 2s-30s | Progress bar + estimate | AI generation |
| 30s+ | Background task + notification | Video rendering |

---

## 4. Accessibility
- `aria-busy="true"` on loading containers
- `aria-label="Loading"` on skeletons
- Reduced motion: Replace shimmer with fade

### Revision History
| Date | Version | Change |
|---|---|---|
| 2026-03-28 | 1.0 | Initial specification |

---

## 2. Preconditions / Postconditions
### Preconditions
- User authenticated with valid session
- Required module permissions granted
### Postconditions
- User actions persisted to backend
- Analytics events dispatched

---

## 4. Component Hierarchy
```
LoadingStatesPage
├── AppShell (shared)
├── PageHeader (Breadcrumb + Title + Actions)
├── ContentArea
│   ├── PrimarySection
│   │   └── [Items per wireframe]
│   └── SecondarySection
└── AppFooter
```

---

## 5. Data Binding & Display Format
| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Primary data | Backend table | `Service/Get` | Formatted display | 15m TTL |
| List items | Backend query | `Service/List(page)` | Card/row list | Based on criticality |
| Summary stats | Aggregation | `Service/GetStats` | Count/percentage | 5m TTL |
| User-facing text | i18n keys | — | Vietnamese | Static |

---
## Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached data | Pull-to-refresh when online |
| API error | Server 5xx | Toast: "Không tải được dữ liệu. [Thử lại]" | Retry |
| Not found | 404 | "Không tìm thấy" → navigate back | Back |
| Permission denied | 403 | "Không có quyền truy cập" | Contact admin |

---
## Localization Notes

- Primary language: Vietnamese
- Currency: VND (no decimals, dot separator: "1.200.000đ")
- Date: DD/MM/YYYY
- Numbers: dot separator (1.234)
- Relative time: "2 giờ trước", "1 ngày trước"
- Tone: Friendly, action-oriented

---
## Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-accent` | Primary actions, CTAs |
| `--color-success` | Positive states, confirmations |
| `--color-warning` | Warning indicators |
| `--color-danger` | Error states, destructive actions |
| `--color-surface-elevated` | Cards, elevated surfaces |
