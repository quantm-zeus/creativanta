# Screen: Mobile — Finance Summary

> **Screen ID**: M041
> **Module**: M19 — Finance
> **Route**: `/finance/summary` (mobile)
> **Platform**: Mobile (Flutter)
> **Upstream**: A1 Schema (financial_snapshots, p_and_l), S009 Trust Badge, B5 RBAC §2.9

---

## 1. Purpose & Context
Detailed mobile P&L summary — revenue vs cost by category, margin analysis, AI-generated financial insights, and export option.
### Entry Points - Finance Hub (M034b) → "📊 Reports" / Morning Brief CTA
### Exit Points - "📥 Export" → PDF / "🔄 Reconcile" → Reconciliation

---

## 2. Screen Layout
### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Finance Summary                          [Period: T3 ▾] [📥]    │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ P&L Overview ────────────────────────────────────────────────┐   │
│ │ Revenue: 45.2M · Costs: 18.5M · Net: 26.7M                  │   │
│ │ Margin: 59% (↑3pp vs T2) · Trust: [🟢 82%]                  │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Revenue Breakdown ──────────────────────────────────────────┐    │
│ │ 🛍 Products:  28.5M ████████████████████ 63%  [🟢]          │    │
│ │ 🤝 Affiliate: 8.2M ██████ 18%                [🟢]           │    │
│ │ 📺 Platform:  5.5M ████ 12%                  [🟡]           │    │
│ │ 🤝 Sponsors:  3.0M ██ 7%                     [🟡]            │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Cost Breakdown ─────────────────────────────────────────────┐    │
│ │ 📦 COGS:      8.2M ████████████ 44%                          │    │
│ │ 📦 Shipping:  4.5M ██████ 24%                                │    │
│ │ 📢 Marketing: 3.8M █████ 21%                                 │    │
│ │ 🤖 AI Credits:1.2M ██ 6%                                     │    │
│ │ 📎 Other:     0.8M █ 5%                                      │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ AI Insight ──────────────────────────────────────────────────┐   │
│ │ 💡 "Margin cải thiện nhờ giảm shipping cost 15%.              │   │
│ │    Consider negotiating better GHTK rate — projected          │   │
│ │    savings: 500K/month." [🔍 Details →]                      │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ Pull-to-refresh                                                      │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                          │
└──────────────────────────────────────────────────────────────────────┘
```
## 7. States
| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Shimmer |
| LOADED | Data ready | Full P&L view |
| NO_DATA | No transactions | "Chưa có dữ liệu tài chính kỳ này." |
| LOW_MARGIN | Margin < 40% | Red: "⚠️ Margin thấp. Xem chi tiết chi phí." |
| EXPORTING | Generating PDF | Spinner |
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
FinanceSummaryScreen
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
| [W080] Web Finance Dashboard | Web equivalent |
| [M042] Revenue Detail | Revenue detail |
| [M044] Reconciliation | Trust improvement |
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
