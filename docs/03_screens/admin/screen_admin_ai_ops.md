# Screen: Admin — AI Operations

> **Screen ID**: A011
> **Module**: Admin — AI Ops
> **Route**: `/admin/ai-ops`
> **Platform**: Web (SvelteKit) — VPN-only
> **Upstream**: Admin Spec, D1 AI Provider Guide

---

## 1. Purpose & Context

Monitor and manage AI provider integrations: credit consumption, provider health, model selection, cost tracking, and fallback configuration. Critical for managing multi-provider AI strategy.

### User Story
> As a sysadmin, I want to monitor AI credit consumption across providers and configure fallback strategies.

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ Admin Shell ────────────────────────────────────────────────────────┐
│ 🤖 AI Operations               [Period: 30d ▾] [🔔 Cost alerts]   │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ AI Cost Summary ──────────────────────────────────────────────┐  │
│ │ Total AI Cost (30d): $1,230                                     │  │
│ │ OpenAI: $450  Replicate: $380  ElevenLabs: $200  Suno: $200   │  │
│ │ Budget utilization: 62% of $2,000/month                        │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Provider Health ──────────────────────────────────────────────┐  │
│ │ 🟢 OpenAI GPT-4o    | Latency: 340ms | Errors: 0.1% | Active │  │
│ │ 🟢 Replicate Flux   | Latency: 1.2s  | Errors: 0.3% | Active │  │
│ │ 🟡 ElevenLabs TTS   | Latency: 890ms | Errors: 2.1% | ⚠     │  │
│ │ 🟢 Suno Music       | Latency: 2.5s  | Errors: 0.5% | Active │  │
│ │ 🟢 Whisper (local)  | Latency: 45ms  | Errors: 0%   | Active │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Consumption by Feature ───────────────────────────────────────┐  │
│ │ Feature          │ Requests │ Credits │ Cost   │ Avg Latency   │  │
│ │ Quick Edit       │ 1,234    │ 45,000  │ $180   │ 2.1s         │  │
│ │ Video Agent      │ 89       │ 22,500  │ $320   │ 180s         │  │
│ │ Clip Factory     │ 456      │ 15,000  │ $120   │ 45s          │  │
│ │ Copilot Chat     │ 5,678    │ 8,500   │ $85    │ 1.2s         │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Fallback Config ──────────────────────────────────────────────┐  │
│ │ ☑ Auto-fallback on provider failure                            │  │
│ │ LLM primary: [GPT-4o ▾] → fallback: [Claude 3.5 ▾]          │  │
│ │ Image: [Flux ▾] → fallback: [DALL-E 3 ▾]                     │  │
│ │ TTS: [ElevenLabs ▾] → fallback: [Google TTS ▾]               │  │
│ │ [💾 Save config]                                               │  │
│ └────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3-5. Component & Actions

```
AIOperationsPage
├── AdminShell
├── PageHeader (title, period, cost alert toggle)
├── CostSummary (total, per-provider, budget utilization bar)
├── ProviderHealthTable (status dot, name, latency, errors, actions)
├── ConsumptionByFeature (table with requests, credits, cost, latency)
└── FallbackConfig (primary/fallback selectors per capability)
```

| # | Action | Trigger | Result | Permission |
|---|---|---|---|---|
| 1 | View provider detail | Click provider row | → `/admin/ai-ops/[provider]` | `admin:analytics:read` |
| 2 | Disable provider | Toggle off | Provider disabled, fallback activates | `admin:queue:manage` |
| 3 | Set fallback | Dropdown change | Fallback updated | `admin:queue:manage` |
| 4 | Set cost alert | "🔔 Cost alerts" | Threshold config modal | `admin:analytics:read` |
| 5 | Save config | "💾 Save" | Config persisted | `admin:queue:manage` |

### Technical Notes
- Route: `src/routes/admin/ai-ops/+page.svelte`
- Cost tracking: per-request logging with provider cost rates
- Health check: periodic ping to all providers
- Fallback: automatic retry with next provider on failure

### Related Screens: [A01] Admin Dashboard, [A05] System Health

### Revision History
| Date | Version | Change |
|---|---|---|
| 2026-03-28 | 1.0 | Initial specification |

---

## 3. Preconditions / Postconditions
### Preconditions
- Admin user with appropriate S26 role
- VPN connection active
### Postconditions
- All actions logged in audit trail
- State changes reflected in real-time

---

## 4. Component Hierarchy
```
AIOperationsPage
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

## 5. Data Binding & Display Format
| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Primary data | Parent screen state or canonical contract object(s) | Resolve via owning feature doc + API/schema contracts | Exact DTO fields from canonical contracts | Per endpoint policy |
| List items | Parent screen list/query contract(s) | Resolve via API endpoint map before implementation | Card or row layout per wireframe | Per endpoint policy |
| Summary stats | Parent screen aggregates/projections | Resolve via feature rules + API contracts | Count / KPI / chip formatting per screen | Short-lived cache only if contract allows |
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
