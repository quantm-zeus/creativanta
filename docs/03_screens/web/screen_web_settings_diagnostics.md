# Screen: Web — Diagnostics Center

> **Screen ID**: W125
> **Module**: M23 — Settings
> **Route**: `/settings/diagnostics`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 10, A1 Schema (diagnostics_records, service_health), B5 RBAC §2.9

---

## 1. Purpose & Context

System health overview — all active issues, warnings, degraded services with 4-step repair wizard. Monitors platform connectors, AI providers, database, cache, and search services.

### User Goals
- See overall system health at a glance
- Identify and resolve issues with guided repair wizard
- View service-by-service latency and status
- Get proactive warnings before issues impact work

### Entry Points
- Sidebar: Settings → "🔧 Diagnostics"
- Status bar: "🟡 Degraded" indicator → click

### Exit Points
- "🔧 Repair" → step-by-step repair wizard
- "📋 Details" → drill into issue
- "📧 Notify team" → email alert

---

## 2. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 🔧 Diagnostics Center              Overall: [🟡 Degraded]          │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Quick Stats ─────────────────────────────────────────────────┐   │
│ │ 🔴 2 Critical · 🟡 3 Warnings · 🟢 12 Healthy              │   │
│ │ Last full check: 30s ago · Auto-check interval: 60s          │   │
│ │ [🔄 Run full check now]                                       │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Issue: Critical ─────────────────────────────────────────────┐   │
│ │ 🔴 Shopee Order Sync Failed                                   │   │
│ │ Affected: Order data · Since: 2h ago · Impact: Revenue data   │   │
│ │ Root cause: API rate limit exceeded                            │   │
│ │ Auto-retry: 3 attempts failed                                  │   │
│ │ [🔧 Repair wizard] [📋 Details] [📧 Notify team]            │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Issue: Warning ──────────────────────────────────────────────┐   │
│ │ 🟡 TikTok Token Expiring Soon                                 │   │
│ │ Expires: 25/6/2026 (89 days) · Action: Re-authorize          │   │
│ │ [🔄 Re-authorize now]                                         │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Issue: Warning ──────────────────────────────────────────────┐   │
│ │ 🟡 AI Credit Usage High                                       │   │
│ │ Remaining: 120/500 (24%) · Projected depletion: 8 days        │   │
│ │ [💳 Top up] [📊 Usage detail]                                 │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Health Grid ─────────────────────────────────────────────────┐   │
│ │ Service        │ Status   │ Last Check │ Latency │ Uptime     │   │
│ │ TikTok API     │ 🟢 OK   │ 1m ago     │ 120ms   │ 99.8%     │   │
│ │ Instagram API  │ 🟢 OK   │ 2m ago     │ 180ms   │ 99.5%     │   │
│ │ Shopee API     │ 🔴 Error│ 2h ago     │ timeout │ 95.2%     │   │
│ │ YouTube API    │ 🟢 OK   │ 1m ago     │ 200ms   │ 99.9%     │   │
│ │ AI Provider    │ 🟢 OK   │ 30s ago    │ 450ms   │ 99.1%     │   │
│ │ Database       │ 🟢 OK   │ 10s ago    │ 3ms     │ 100%      │   │
│ │ Search (Meili) │ 🟢 OK   │ 15s ago    │ 8ms     │ 100%      │   │
│ │ Cache (Dragon) │ 🟢 OK   │ 10s ago    │ 1ms     │ 100%      │   │
│ │ File Storage   │ 🟢 OK   │ 30s ago    │ 45ms    │ 99.9%     │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Repair Wizard (4-step drawer) ──────────────────────────────┐   │
│ │ Step 1: Issue Summary → Step 2: Root Cause Analysis          │   │
│ │ Step 3: Fix Options (auto/manual) → Step 4: Verify Fix       │   │
│ └────────────────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Running checks | Shimmer on health grid |
| ALL_HEALTHY | Everything green | "🟢 All systems operational" |
| DEGRADED | Warnings present | "🟡 Degraded — {n} warnings" |
| CRITICAL | Critical issues | "🔴 Critical — {n} issues require attention" |
| REPAIRING | Repair wizard open | Side drawer with 4-step wizard |
| CHECK_RUNNING | Manual full check | Progress bar through services |
| ERROR | Diagnostics API failed | Error with retry |

---

## 9. Permission Matrix

Only Owner and Admin can access Diagnostics.

---

## 10. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached health data | Retry online |
| Health check timeout | Service check >30s | Row shows "⏰ Timeout" instead of status | Auto-retry next cycle |
| Repair wizard fail | Auto-fix step fails | Step shows "❌ Fix failed. [🔧 Manual fix]" | Manual instructions |
| Full check fail | API error | Toast: "Không chạy được full check. [Thử lại]" | Retry |
| Notification fail | Email send error | Toast: "Không gửi được thông báo." | Retry |

---

## 11. Accessibility

| Element | Requirement |
|---|---|
| Quick stats | `role="status"`, `aria-label="2 critical, 3 warnings, 12 healthy"` |
| Issue cards | `role="alert"`, `aria-label="{severity}: {title}"` |
| Health grid | `role="table"`, `aria-label="Service health status"`, sortable by status |
| Repair wizard | `role="dialog"`, step progress via `aria-label="Step {n} of 4"` |
| Status badges | Text + icon (🟢/🟡/🔴), not color alone |

---

## 12. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Stats bar + issue card skeletons |
| Quick stats | 100-300ms | Counts populate |
| Issue cards | 200-500ms | Cards appear with severity sort |
| Health grid | 300-800ms | Rows populate with latency data |
| Full check | 5-30s | Progress bar through services |

---

## 13. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `diagnostics.viewed` | Page load | `critical_count`, `warning_count`, `healthy_count` |
| `diagnostics.full_check` | "🔄 Run full check" | `service_count`, `duration_ms` |
| `diagnostics.repair_started` | "🔧 Repair wizard" | `issue_id`, `severity`, `service` |
| `diagnostics.repair_completed` | Step 4 verify success | `issue_id`, `fix_type` (auto/manual), `duration_ms` |
| `diagnostics.repair_failed` | Repair step failed | `issue_id`, `failed_step` |
| `diagnostics.detail_viewed` | "📋 Details" | `issue_id` |
| `diagnostics.team_notified` | "📧 Notify team" | `issue_id`, `recipients_count` |
| `diagnostics.issue_resolved` | Issue auto-resolves | `issue_id`, `resolution_time_min` |

---

## 14. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/settings/diagnostics/+page.svelte`
- **Server load**: `+page.server.ts` → `DiagnosticsService/GetOverview` + `DiagnosticsService/ListIssues` + `DiagnosticsService/GetHealthGrid`
- **Real-time**: SSE `/events/diagnostics` → updates issue status, health grid in real-time
- **Full check**: `DiagnosticsService/RunFullCheck` → SSE progress per service → grid updates
- **Repair wizard**: 4-step drawer component, each step calls `DiagnosticsService/ExecuteRepairStep(issue_id, step)`
- **Auto-retry**: Background job retries failed services every 60s
- **Health grid sort**: Client-side sort by status (critical first) or by service name
- **Notify team**: `NotificationService/SendAlert(issue_id, recipients)` → email + in-app

---

## 15. Localization Notes

- Status: "🟢 Bình thường", "🟡 Suy giảm", "🔴 Lỗi"
- Overall: "🟢 Tất cả hệ thống hoạt động bình thường"
- Latency: "120ms", "timeout"
- Uptime: "99.8%"
- Issues: Vietnamese descriptions with technical context
- Tone: Technical, actionable, calm

---

## 16. Design Tokens

| Token | Usage |
|---|---|
| `--color-diag-healthy` | 🟢 Healthy (green) |
| `--color-diag-warning` | 🟡 Warning (amber) |
| `--color-diag-critical` | 🔴 Critical (red) |
| `--color-accent` | CTA buttons |
| `--color-surface-elevated` | Issue cards, health grid |
| `--color-border` | Table rows |
| `--color-text-secondary` | Timestamps, latency values |
| `--font-mono` | Latency values, uptime |
| `--color-repair-progress` | Repair wizard step indicator |

---

## 17. Related Screens

| Screen | Relationship |
|---|---|
| [W117] Connectors | Platform connections |
| [W127] Connected Account Detail | Per-platform settings |
| [M059] Mobile Diagnostics | Mobile equivalent |

---

## 18. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 errors (repair fail, health timeout), health grid a11y, 8 analytics, SvelteKit impl (SSE, repair wizard), localization, 9 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
