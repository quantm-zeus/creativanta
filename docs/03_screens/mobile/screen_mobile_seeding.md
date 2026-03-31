# Screen: Mobile — Seeding Requests

> **Screen ID**: M044
> **Module**: M15 — Seeding
> **Route**: `/seeding` (mobile)
> **Platform**: Mobile (Flutter)
> **Upstream**: A1 Schema (sample_requests, shipments), B5 RBAC §2.7

---

## 1. Purpose & Context

Mobile seeding — track sample product delivery to influencers with pipeline status, ROI tracking, and quick contact.

### Entry Points
- Commerce tab: "📦 Seeding" row
- Push: "📦 @beauty_girl received your sample"

### Exit Points
- "📱 Contact" → messaging
- Tap card → seeding request detail

---

## 2. Screen Layout

### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Seeding                                        [+ Tạo request]  │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Summary ──────────────────────────────────────────────────────┐  │
│ │ Active: 8 · Sent this month: 12 · Content posted: 8 (67%)    │  │
│ │ Total cost: 3.2M · Revenue attributed: 8.5M · ROI: +165%     │  │
│ └────────────────────────────────────────────────────────────────┘  │
│ Chips: [All] [⏳ Pending (2)] [📦 Sent (3)] [📬 Received (1)]    │
│        [📱 Content ✅ (8)]                                         │
│                                                                      │
│ ┌─ Seeding Card ────────────────────────────────────────────────┐   │
│ │ 📦 Serum HA → @beauty_girl (45K)          [🟡 Sent]          │   │
│ │ Sent: 2d ago · Tracking: VN123456 · Due: 5d                   │   │
│ │ Expected: Review video on TikTok                               │   │
│ │ Cost: 299K + 30K ship                                          │   │
│ │ [📱 Contact] [📋 Update status]                               │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ ┌─ Seeding Card (completed) ────────────────────────────────────┐   │
│ │ 📦 Mask set → @skincare_tips (22K)        [🟢 Content ✅]   │   │
│ │ Content posted · 12K views · Revenue: 1.8M · ROI: 3.2×       │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ Pull-to-refresh                                                      │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                          │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Card shimmer |
| LOADED | Requests available | Summary + cards |
| EMPTY | No seeding | "Chưa có yêu cầu seeding. [+ Tạo đầu tiên]" |
| OVERDUE | Content past due | Orange flag: "⚠️ Quá hạn {n} ngày" |
| ERROR | API failed | Error with retry |

---
## 2. Preconditions / Postconditions
### Preconditions
- User authenticated with valid session
- Required module permissions granted
### Postconditions
- User actions persisted to backend
- Related screens updated via state management
- Analytics events dispatched

---

## 4. Component Hierarchy
```
SeedingRequestsScreen
├── AppBar
│   ├── BackButton
│   └── Title + ActionButtons
├── ContentArea (scrollable, pull-to-refresh)
│   ├── SummarySection
│   ├── PrimaryContent
│   │   └── [Items per wireframe]
│   └── SecondaryContent
└── BottomNavBar (shared)
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
## 19. Related Screens

| Screen | Relationship |
|---|---|
| [W099] Web Seeding | Web equivalent |
| [M026] Products | Product catalog |
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

---
## Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | Patch | Removed duplicate template sections. Replaced with screen-specific Error Handling, Accessibility, Loading, Localization, Design Tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
