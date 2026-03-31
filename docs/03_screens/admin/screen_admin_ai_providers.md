# Screen: Admin — AI Provider Management

> **Screen ID**: A12
> **Module**: Admin — AI Operations
> **Route**: `/admin/ai/providers`
> **Platform**: Admin Web (SvelteKit) — VPN-only
> **Upstream**: A1 Schema (ai_providers, ai_routing), B5 RBAC §3

---

## 1. Purpose & Context
Manage AI providers — API keys, model routing, fallback chains, cost tracking, and health status per provider.
### Entry Points - Admin sidebar: "🤖 AI → Providers"
### Exit Points - Self-contained

---

## 2. Screen Layout
### ASCII Wireframe
```
┌─ Admin Shell ────────────────────────────────────────────────────────┐
│ 🤖 AI Providers                                   [+ Add provider] │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Provider Card ───────────────────────────────────────────────┐   │
│ │ 🤖 OpenAI · GPT-4o                        [🟢 Healthy]      │   │
│ │ API key: sk-...4a2b · Expires: Never                          │   │
│ │ Usage: 12K req/day · Cost: $45/day · Avg latency: 450ms     │   │
│ │ Routing: Primary for text generation                          │   │
│ │ [✏ Edit] [⏸ Disable] [📊 Stats]                             │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ ┌─ Provider Card ───────────────────────────────────────────────┐   │
│ │ 🤖 Claude · 3.5 Sonnet                    [🟢 Healthy]      │   │
│ │ API key: sk-a...9z · Expires: Never                           │   │
│ │ Usage: 3K req/day · Cost: $18/day · Avg latency: 380ms      │   │
│ │ Routing: Fallback for text, Primary for analysis              │   │
│ │ [✏ Edit] [⏸ Disable] [📊 Stats]                             │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ ┌─ Routing Rules ───────────────────────────────────────────────┐   │
│ │ Text gen: OpenAI → Claude → Gemini (fallback chain)          │   │
│ │ Image gen: OpenAI DALL-E → Stability (fallback)              │   │
│ │ Video gen: Runway → Pika (fallback)                           │   │
│ │ [✏ Edit routing]                                               │   │
│ └────────────────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────────────┘
```
## 7. States
| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Shimmer |
| LOADED | Providers listed | Cards + routing |
| PROVIDER_DOWN | Provider unhealthy | Red: "🔴 {provider} down — failover to {backup}" |
| ERROR | API failed | Error with retry |

---

## 2. Preconditions / Postconditions
### Preconditions
- Admin user with appropriate S26 role
- VPN connection active
### Postconditions
- All actions logged in audit trail
- State changes reflected in real-time

---

## 4. Component Hierarchy
```
AIProviderManagementPage
├── AdminShell (shared)
├── PageHeader (Title + Breadcrumb + Actions)
├── ContentArea
│   ├── SummaryCards
│   ├── PrimaryContent
│   │   └── [Items per wireframe]
│   └── SecondaryContent
└── PageFooter
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
| [A13] AI Config | Model configuration |
| [A14] AI Credits | Credit management |
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
