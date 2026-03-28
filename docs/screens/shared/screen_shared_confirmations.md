# Shared: Confirmation Dialogs

> **Screen ID**: S04
> **Module**: Shared — UI Patterns
> **Platform**: All (Web + Mobile)

---

## 1. Purpose & Context

Standardized confirmation/destructive action dialogs — prevent accidental data loss and provide clear escape hatches.

---

## 2. Dialog Types

### Simple Confirm
```
┌──────────────────────────────────────────┐
│ ⚠️ Xác nhận xóa                         │
│                                          │
│ Bạn có chắc muốn xóa "5 tips nấu ăn"? │
│ Hành động này không thể hoàn tác.        │
│                                          │
│ [Hủy]                      [🗑 Xóa]    │
└──────────────────────────────────────────┘
```

### Type-to-Confirm (Dangerous)
```
┌──────────────────────────────────────────┐
│ 🔴 Xóa workspace                        │
│                                          │
│ Gõ "XÓA WORKSPACE" để xác nhận:         │
│ [________________________]               │
│                                          │
│ [Hủy]                   [🗑 Xóa vĩnh viễn]│
└──────────────────────────────────────────┘
```

### OTP Confirm (Admin)
```
┌──────────────────────────────────────────┐
│ 🔐 Xác thực OTP                         │
│                                          │
│ Nhập mã OTP từ Authenticator:           │
│ [_ _ _ _ _ _]                            │
│                                          │
│ [Hủy]                   [✅ Xác nhận]   │
└──────────────────────────────────────────┘
```

---

## 3. When to Use

| Risk Level | Dialog Type | Examples |
|---|---|---|
| Low | None (undo toast) | Archive, mark read |
| Medium | Simple confirm | Delete content, remove member |
| High | Type-to-confirm | Delete workspace, disconnect platform |
| Critical (Admin) | OTP confirm | Grant credits, purge DLQ, change fees |

### Mobile: Bottom sheet instead of centered modal

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
ConfirmationDialogsPage
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
