# Shared Component: Upsell Banner

> **Component ID**: S11
> **Type**: Shared UI Component
> **Used across**: All platforms — Web, Mobile, Admin

---

## 1. Purpose

Contextual upgrade prompts shown when user hits plan limits (credits, storage, members) or discovers a Pro-only feature. Non-intrusive but compelling.

---

## 2. Variants

### 2a. Inline Banner (within page)
```
┌─ Upsell Banner ──────────────────────────────────────────────┐
│ ⭐ Nâng cấp lên Pro để mở khóa tính năng này                 │
│ AI Video Agent, Brand Deal Manager, và 400 credits thêm/tháng│
│ [Xem gói Pro →]                                  [✕ Dismiss] │
└───────────────────────────────────────────────────────────────┘
```

### 2b. Contextual Nudge (bottom bar)
```
┌─ Nudge Bar ──────────────────────────────────────────────────┐
│ 🪙 Còn 15 credits. [Mua thêm →]                             │
└───────────────────────────────────────────────────────────────┘
```

### 2c. Feature Gate Modal
```
┌─ Feature Gate ───────────────────────────────────────────────┐
│ 🔒 Brand Deal Manager                                        │
│ Quản lý pipeline brand deal, deliverables, và thanh toán.     │
│ Tính năng này có trong gói Pro.                               │
│ [Nâng cấp gói Pro — 499K/tháng] [← Quay lại]               │
└───────────────────────────────────────────────────────────────┘
```

## 3. Trigger Conditions

| Trigger | Variant | Location |
|---|---|---|
| Feature locked | Modal (2c) | Any Pro-only screen |
| Credits < 20% | Nudge (2b) | Studio, Copilot |
| Storage > 80% | Banner (2a) | Asset Library |
| Members at limit | Banner (2a) | Workspace Members |
| First 7 days on Free | Banner (2a) | Dashboard |

## 4. Behavior Rules

- **Dismiss**: User can dismiss banner; reappears after 7 days
- **Conversion tracking**: All CTAs track `upsell_source`, `upsell_trigger`
- **A/B testable**: Copy, CTA color, timing are configurable
- **No harassment**: Max 1 upsell per session across all surfaces

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
UnknownPage
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
