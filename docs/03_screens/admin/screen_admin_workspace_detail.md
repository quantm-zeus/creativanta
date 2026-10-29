# Screen: Admin — Workspace Detail

> **Screen ID**: A005
> **Module**: Admin — Workspace Management
> **Route**: `/admin/workspaces/[id]`
> **Platform**: Admin Web (SvelteKit) — VPN-only
> **Upstream**: A1 Schema (workspaces, subscriptions, connected_accounts), B5 RBAC §3

---

## 1. Purpose & Context
Deep workspace inspection — configuration, members, connections, usage, billing, content stats, and admin actions (suspend, upgrade, grant, delete).
### Entry Points - Workspace List (A04): click row
### Exit Points - Actions → audit logged

---

## 2. Screen Layout
### ASCII Wireframe
```
┌─ Admin Shell ────────────────────────────────────────────────────────┐
│ ← Workspaces   🏢 Creativanta Studio         [⋮ Actions ▾]        │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Header ──────────────────────────────────────────────────────┐   │
│ │ [Logo] Creativanta Studio · Pro plan · 🟢 Active              │   │
│ │ Created: Jan 2026 · Owner: quanng@email.com · Region: VN     │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ Tabs: [Overview] [Members (3)] [Connections (5)] [Usage] [Billing] │
│ ── Overview ──                                                       │
│ │ Content: 156 │ Videos: 45 │ Orders: 1,200 │ Revenue: 28.5M    │
│ │ AI credits: 180/500 │ Storage: 2.3/10 GB │ API: 12K calls/day │
│ ── Members ──                                                        │
│ │ quanng (Owner) · minh (Editor) · linh (Viewer)                 │
│ │ [📧 Invite] [🗑 Remove]                                        │
│ ── Connections ──                                                    │
│ │ TikTok 🟢 · Shopee 🟡 (token in 25d) · Instagram ❌           │
│ │ YouTube 🟢 · Facebook 🟢                                       │
│ ── Usage (30d) ──                                                    │
│ │ API calls: [Mini chart 30d] · AI credits: [Consumption chart]  │
│ ── Billing ──                                                        │
│ │ Plan: Pro (299K/mo) · Next: Apr 1 · Stripe ID: cus_xxx        │
│ │ Invoice history: [3 invoices] · Payment status: ✅              │
│ ── Actions ──                                                        │
│ │ [📧 Contact] [⏸ Suspend] [📈 Upgrade] [💰 Credits] [🗑 Delete]│
│ │ [👤 Impersonate] ← OTP required · audit logged                │
└──────────────────────────────────────────────────────────────────────┘
```
## 3. States
| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Shimmer |
| LOADED | Data ready | Tabbed detail |
| SUSPENDED | Workspace frozen | "⏸ Suspended — {reason}" banner |
| OVER_LIMIT | Usage exceeds plan | "⚠️ Over plan limits" warning |
| ERROR | API failed | Error with retry |

---

## 4. Preconditions / Postconditions
### Preconditions
- Admin user with appropriate S26 role
- VPN connection active
### Postconditions
- All actions logged in audit trail
- State changes reflected in real-time

---

## 5. Component Hierarchy
```
WorkspaceDetailPage
├── AdminShell (shared)
├── PageHeader (Title + Breadcrumb + Actions)
├── ContentArea
│   ├── SummaryCards
│   ├── PrimaryContent
│   │   └── Screen-specific regions defined by the ASCII wireframe and interaction states
│   └── SecondaryContent
└── PageFooter
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
## 7. Related Screens
| Screen | Relationship |
|---|---|
| [A004] Workspace List | Parent |
| [A003] User Detail | Owner profile |
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
