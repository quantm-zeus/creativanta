# Shared: Empty States

> **Screen ID**: S02
> **Module**: Shared — UI States
> **Platform**: All (Web + Mobile)
> **Upstream**: Design Tokens (D1)

---

## 1. Purpose & Context

Every list/table/board must have an empty state. These are standardized per module to ensure consistent UX and always provide a clear CTA.

---

## 2. Empty State by Module

| Module | Empty Illustration | Headline | Subtext | Primary CTA |
|---|---|---|---|---|
| Ideas | 💡 light bulb illustration | "Chưa có ý tưởng nào!" | "Bắt đầu bằng cách tạo ý tưởng hoặc dùng AI generate" | "+ Tạo ý tưởng" |
| Scripts | 📝 notepad illustration | "Chưa có kịch bản nào" | "Tạo kịch bản từ ý tưởng hoặc viết từ đầu" | "+ Tạo kịch bản" |
| Studio | 🎬 film slate illustration | "Chưa có video nào" | "Bắt đầu tạo video với AI Studio" | "→ AI Studio" |
| Inbox | 💬 speech bubbles | "Inbox trống!" | "Kết nối platform để nhận tin nhắn" | "🔗 Kết nối" |
| Calendar | 📅 calendar illustration | "Chưa có lịch đăng" | "Lên lịch đăng content đầu tiên" | "+ Lên lịch" |
| Orders | 📦 package illustration | "Chưa có đơn hàng" | "Kết nối shop để sync" | "🔗 Kết nối" |
| Products | 🛍 shopping bag | "Chưa có sản phẩm" | "Đồng bộ sản phẩm từ platform" | "→ Sync" |
| Trends | 📈 flat line chart | "Chưa theo dõi trends" | "Thêm niche để theo dõi" | "+ Thêm niche" |
| Competitors | 👥 silhouettes | "Chưa theo dõi ai" | "Thêm competitor để benchmark" | "+ Thêm" |
| Workflows | ⚙️ gears | "Chưa có workflow" | "Tự động hóa quy trình đầu tiên" | "+ Tạo workflow" |
| Analytics | 📊 flat chart | "Chưa có dữ liệu" | "Publish content để xem analytics" | "→ Publish" |

---

## 3. Layout Structure

### Web
```
┌─────────────────────────────────────────────┐
│          [illustration / icon 120×120]       │
│                                             │
│          Headline (h3, bold)                │
│          Subtext (body2, muted)             │
│                                             │
│          [Primary CTA Button]               │
│          [Secondary link (optional)]        │
└─────────────────────────────────────────────┘
```

### Mobile
```
┌─────────────────────────────┐
│   [illustration 80×80]      │
│   Headline (h4)             │
│   Subtext (body2)           │
│   [CTA Button]              │
└─────────────────────────────┘
```

---

## 4. Rules
- Center vertically in available space
- Use illustrations from brand pack (not emoji in prod)
- CTA must be the screen's primary creation action
- Filtered-empty differs: "Không tìm thấy kết quả cho bộ lọc" + "Xóa bộ lọc"

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
EmptyStatesPage
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
