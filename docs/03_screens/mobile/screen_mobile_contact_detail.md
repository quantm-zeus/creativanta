# Screen: Mobile — Contact Detail

> **Screen ID**: M022
> **Module**: M13 — Engagement & CRM
> **Route**: `/contacts/[id]` (mobile)
> **Platform**: Mobile (Flutter)
> **Upstream**: A1 Schema (contacts, engagement_events, orders), B5 RBAC §2.7

---

## 1. Purpose & Context
Mobile contact detail — full profile with engagement history, purchase timeline, AI-detected attributes, and quick actions (call, message, tag).
### Entry Points - Contact List (M048): tap row / Thread Detail (M008): "👤 Profile"
### Exit Points - "💬 Message" → thread / "📞 Call" → phone

---

## 2. Screen Layout
### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Contacts   @skincare_queen                    [📞] [💬] [📝]   │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Profile ─────────────────────────────────────────────────────┐   │
│ │ [Avatar] Nguyễn A · ⭐ VIP                                   │   │
│ │ 🎵 TikTok · @skincare_queen · 45K followers                 │   │
│ │ Tags: [repeat-buyer] [skincare] [+ Add]                      │   │
│ │ First contact: 3 months ago · Source: TikTok comment          │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ ┌─ KPIs ────────────────────────────────────────────────────────┐   │
│ │ Orders: 5 · LTV: 1.2M · Avg cart: 240K · Last: 3d ago       │   │
│ │ Engagement: 23 interactions · Sentiment: 😊 Positive          │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ ┌─ Timeline ────────────────────────────────────────────────────┐   │
│ │ 3d ago · 📦 Ordered Serum HA × 2 (500K)                     │   │
│ │ 1w ago · 💬 "Sản phẩm tuyệt vời!"                          │   │
│ │ 2w ago · ❤ Liked your video "5 tips"                         │   │
│ │ 1mo ago · 📦 Ordered Mask × 1 (120K)                        │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ ┌─ AI Notes ────────────────────────────────────────────────────┐   │
│ │ 🤖 "Khách VIP — order mỗi 2 tuần, thích skincare tự nhiên" │   │
│ └────────────────────────────────────────────────────────────────┘   │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                          │
└──────────────────────────────────────────────────────────────────────┘
```
## 7. States
| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Shimmer |
| LOADED | Profile ready | Full contact detail |
| MERGED | Multi-platform profiles | "Merged from: TikTok + Shopee" label |
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
ContactDetailScreen
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
| [W049] Web Contact Detail | Web equivalent |
| [M021] Contact List | Parent |
| [M020] Thread Detail | Conversations |
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
