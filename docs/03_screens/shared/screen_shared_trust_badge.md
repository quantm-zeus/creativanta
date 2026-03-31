# Shared: Trust Badge Component

> **Screen ID**: S009
> **Module**: Shared — UI Components
> **Platform**: All (Web + Mobile + Admin)
> **Upstream**: PRD §15 (Canonical Trust Taxonomy), Pack 06

---
## 1. Purpose & Context

Trust badges display data source reliability, confidence level, and freshness on any data surface. This component is the canonical implementation of PRD §15's trust model. Used extensively in Finance, Analytics, Commerce, and Engagement surfaces to ensure users always know the provenance and reliability of displayed data.

### When to Use
- Finance dashboard: Always visible on every KPI card and metric
- Analytics: Visible as icon + tooltip on data panels
- Commerce: Source badge on order, revenue, and profit data
- Engagement: Source badge on attributed data and intent scores
- Any surface showing aggregated, computed, or imported data

---
## 2. Component Specification

### Visual Variants

#### Inline Badge (compact — used in KPI cards, table cells)
```
[🟢 Official · High · Live]      ← full inline
[🟢 Official]                    ← minimal inline (space-constrained)
```

#### Tooltip Badge (hover/tap to expand — used in analytics, charts)
```
Hover → ┌─ Trust Info ────────────────┐
        │ Source: Official             │
        │ Confidence: High             │
        │ Freshness: Live (2m ago)     │
        │ [Why this number? →]         │
        └──────────────────────────────┘
```

#### Panel Badge (used in finance detail, proof views)
```
┌─ Data Trust ──────────────────────────┐
│ Source:     [🟢 Official]              │
│ Confidence: [High ████████░░]          │
│ Freshness:  [Live] · Synced 2m ago     │
│ Verified:   [✅ Verified]              │
│                                        │
│ [Why this number? ▾]                   │
│ ┌─ Explanation ──────────────────────┐ │
│ │ Data from TikTok Shop API.         │ │
│ │ Last full sync: 2 minutes ago.     │ │
│ │ Source: platform settlement file.  │ │
│ │ Reconciled against order records.  │ │
│ └────────────────────────────────────┘ │
└────────────────────────────────────────┘
```

---
## 3. Source Classes (PRD §15.1 — Canonical)

> **MANDATORY**: These 5 source classes are frozen in PRD. No downstream document may add, rename, or remove source classes.

| Class | Icon | Color | DB Value | Meaning |
|---|---|---|---|---|
| Official | 🟢 | `--color-trust-official` (Green) | `official` | Data from connected platform API or system-of-record |
| Imported | 🔵 | `--color-trust-imported` (Blue) | `imported` | Data from file import, external system, or manual entry |
| Inferred | 🟣 | `--color-trust-inferred` (Indigo) | `inferred` | Data derived from evidence, attribution logic, or graph reasoning |
| Estimated | 🟡 | `--color-trust-estimated` (Amber) | `estimated` | Data from models, forecasts, simulations, or estimate-based calculations |
| Unreconciled | ⚪ | `--color-trust-unreconciled` (Grey) | `unreconciled` | Data pending match, in conflict, or lacking coverage for clean truth |

### Display Rules
- Badge text MUST use canonical class name (localized via i18n)
- If data combines multiple source classes, show the **lowest-confidence** class as primary with "(Mixed sources)" tooltip
- Never display "Mixed" as a standalone source class — always clarify which classes are mixed

---
## 4. Confidence Bands (PRD §15.2 — Canonical)

| Band | Visual | Bar Fill | Meaning |
|---|---|---|---|
| High | `████████████` (100%) | Green | Strong evidence, reconciled, multiple confirming sources |
| Medium-High | `█████████░░░` (75%) | Teal | Good evidence, minor gaps or pending verification |
| Medium | `██████░░░░░░` (50%) | Amber | Moderate evidence, some assumptions or estimation |
| Low-Medium | `████░░░░░░░░` (33%) | Orange | Limited evidence, significant estimation or inference |
| Low | `██░░░░░░░░░░` (16%) | Red | Minimal evidence, heavy estimation, potentially unreliable |

### Confidence Display Rules
- Every confidence badge MUST explain: why this level, what's pulling it down, what to do to improve
- Low/Low-Medium confidence on financial data → show warning icon alongside
- Never show confidence as just a number — always show band name + progress bar

---
## 5. Freshness Levels

| Level | Icon | Threshold | Meaning |
|---|---|---|---|
| Live | 🟢 | Synced within 5 minutes | Real-time or near-real-time data |
| Recent | 🔵 | 5 min – 1 hour | Stale-while-revalidate window |
| Stale | 🟡 | 1 hour – 24 hours | Background refresh pending |
| Old | 🔴 | > 24 hours since last sync | Manual refresh recommended |

### Freshness Display
- Always show relative timestamp: "2 phút trước", "3 giờ trước", "2 ngày trước"
- "Stale" and "Old" levels show a subtle pulse animation to draw attention
- "Old" level shows: "Dữ liệu cũ. [Làm mới →]" with refresh action

---
## 6. Verification Status (PRD §15.3 — Canonical)

| Status | Icon | Meaning |
|---|---|---|
| Verified | ✅ | Data confirmed against authoritative source |
| Re-verify | 🔄 | Previously verified but source changed; needs re-check |
| Pending | ⏳ | Not yet verified; awaiting confirmation |

---
## 7. "Why This Number?" Drawer

The explanation drawer is the core trust mechanism. It opens on tap/click from any trust badge.

### Drawer Content Structure
```
┌─ Why This Number? ────────────────────────────────────┐
│                                                        │
│ 📊 Metric: Doanh thu hôm nay                          │
│ 💰 Value: 2,400,000 VND                               │
│                                                        │
│ 📝 Explanation:                                        │
│ Tổng doanh thu từ 12 đơn hàng trên TikTok Shop,      │
│ được lấy trực tiếp từ API kết toán TikTok.            │
│                                                        │
│ 📦 Data Sources:                                       │
│ · TikTok Shop Settlement API (Official) — 10 orders   │
│ · Manual entry (Imported) — 2 orders                   │
│                                                        │
│ ⚠️ Confidence Factors:                                 │
│ · ✅ 83% revenue from Official source                  │
│ · ⚠️ 17% from manual import (not yet reconciled)       │
│ · ⚠️ Platform fee schedule may be outdated (>7d)       │
│                                                        │
│ 🔧 To improve confidence:                              │
│ · Reconcile 2 imported orders [→ Reconciliation]       │
│ · Update fee schedule [→ Settings]                     │
│                                                        │
│ 🕐 Last sync: 2 phút trước                            │
│ [Làm mới dữ liệu] [Xem chi tiết reconciliation →]    │
└────────────────────────────────────────────────────────┘
```

---
## 8. Component Props (Implementation Reference)

```typescript
interface TrustBadgeProps {
  sourceClass: 'official' | 'imported' | 'inferred' | 'estimated' | 'unreconciled';
  confidence: 'high' | 'medium_high' | 'medium' | 'low_medium' | 'low';
  freshness: 'live' | 'recent' | 'stale' | 'old';
  lastSyncAt: Date;
  verificationStatus?: 'verified' | 're_verify' | 'pending';
  variant: 'inline' | 'tooltip' | 'panel';
  explanationData?: TrustExplanation;
}
```

---
## 9. Accessibility

| Element | Requirement |
|---|---|
| Badge | `role="status"`, `aria-label="Nguồn: Official, Độ tin cậy: Cao, Cập nhật: 2 phút trước"` |
| Color | Not sole information carrier — always includes text label and icon |
| Drawer | `role="dialog"`, `aria-modal="true"`, focus trapped, Escape to close |
| Contrast | All color combinations meet WCAG 2.1 AA (4.5:1 for text) |

---
## 10. Platform-Specific Behavior

| Platform | Behavior |
|---|---|
| Web | Hover shows tooltip variant. Click opens panel variant for finance screens. |
| Mobile | Tap shows bottom sheet with panel variant. Long-press not used. |
| Admin | Always shows panel variant inline. Admin sees additional technical metadata. |

---
## 11. Related Components

| Component | Relationship |
|---|---|
| [S004] Loading States | Trust badge shows "Loading..." placeholder during fetch |
| [S006] Error States | If trust data unavailable, badge shows "—" with "Không thể xác định nguồn" |
| Finance screens (W080-W087) | Primary consumer — every KPI card has trust badge |
| Analytics screens (W075-W079) | Secondary consumer — chart headers have trust tooltips |

---
## 12. Assumptions

1. **Source class is determined server-side** — frontend displays what API returns, doesn't compute source class.
2. **Confidence band is computed per-object** — complex metrics may have multiple sub-confidence scores aggregated.
3. **Freshness is based on `last_synced_at` field** from connector status or data pipeline timestamp.
4. **"Mixed sources" case**: When a metric aggregates Official + Imported data, primary badge shows the lower class (Imported) with tooltip listing all contributing classes.

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
TrustBadgeComponentPage
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
