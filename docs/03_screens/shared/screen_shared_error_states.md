# Shared: Error States

> **Screen ID**: S006
> **Module**: Shared — UI States
> **Platform**: All (Web + Mobile)
> **Upstream**: Design Tokens (D1)

---

## 1. Purpose & Context

Standardized error handling patterns — toast notifications, inline errors, full-page errors, and recovery flows.

---

## 2. Error Types

### Toast (Non-blocking)
```
┌──────────────────────────────────────────┐
│ ❌ "Lưu thất bại. Thử lại?"  [Retry]   │
└──────────────────────────────────────────┘
```
- Duration: 5s (dismissible)
- Position: Bottom-right (web), bottom-center (mobile)
- Types: Error (red), Warning (amber), Success (green), Info (blue)

### Inline Error (Field-level)
```
Email: [invalid_email    ]
       ❌ "Email không hợp lệ"
```
- Red border + red error text below field
- Show on blur or submit

### Banner Error (Section-level)
```
┌──────────────────────────────────────────┐
│ ⚠️ "Shopee đang gặp sự cố. Dữ liệu   │
│    có thể chưa cập nhật."  [🔄 Retry]  │
└──────────────────────────────────────────┘
```
- Yellow/red top banner
- Collapsible aftier acknowledge

### Full-Page Error
```
┌──────────────────────────────────────────┐
│              [⚠️ Icon]                   │
│        "Đã xảy ra lỗi"                  │
│     "Vui lòng thử lại sau"              │
│     Error code: ERR_500_abc              │
│     [🔄 Thử lại] [📧 Báo lỗi]          │
└──────────────────────────────────────────┘
```

### Network Error
```
┌──────────────────────────────────────────┐
│           [📡 No signal icon]            │
│      "Mất kết nối internet"             │
│  "Dữ liệu sẽ tự đồng bộ khi online"  │
│          [🔄 Thử lại]                   │
└──────────────────────────────────────────┘
```

---

## 3. Error Recovery
| Error Type | Recovery |
|---|---|
| Network | Auto-retry with exponential backoff |
| 401 | Redirect to login |
| 403 | Show "Không có quyền" + request access |
| 404 | Show "Không tìm thấy" + go back |
| 429 | Show cooldown timer |
| 500 | Show error code + report link |

### Revision History
| Date | Version | Change |
|---|---|---|
| 2026-03-28 | 1.0 | Initial specification |

---

## 4. Preconditions / Postconditions
### Preconditions
- User authenticated with valid session
- Required module permissions granted
### Postconditions
- User actions persisted to backend
- Analytics events dispatched

---

## 5. Component Hierarchy
```
ErrorStatesPage
├── AppShell (shared)
├── PageHeader (Breadcrumb + Title + Actions)
├── ContentArea
│   ├── PrimarySection
│   │   └── Screen-specific regions defined by the ASCII wireframe and interaction states
│   └── SecondarySection
└── AppFooter
```

---

## 6. Data Binding & Display Format
| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Primary data | Parent screen state or canonical contract object(s) | Resolve via owning feature doc + API/schema contracts | Exact DTO fields from canonical contracts | Per endpoint policy |
| List items | Parent screen list/query contract(s) | Resolve via API endpoint map before implementation | Card or row layout per wireframe | Per endpoint policy |
| Summary stats | Parent screen aggregates/projections | Resolve via feature rules + API contracts | Count / KPI / chip formatting per screen | Short-lived cache only if contract allows |
| User-facing text | i18n keys | — | Vietnamese | Static |

---
## Accessibility

| Element | Requirement |
|---|---|
| Interactive elements | Minimum 48×48dp tap targets |
| Icons with meaning | `Semantics(label:)` descriptive text |
| Status indicators | Color not sole indicator; text/icon also present |
| Dynamic content | `Semantics(liveRegion: true)` for updates |
| Contrast | 4.5:1 minimum ratio |

---
## Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Screen mount | 0ms | App bar + shimmer placeholders |
| Primary data | 200-500ms | Content populates progressively |
| User action | <1s | Inline spinner → result feedback |

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
