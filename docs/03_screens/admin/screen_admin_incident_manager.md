# Screen: Admin — Incident Manager

> **Screen ID**: A031
> **Module**: Admin — System Operations
> **Route**: `/admin/incidents`
> **Platform**: Admin Web (SvelteKit) — VPN-only access
> **Upstream**: S26 §9 (System Health), B5 RBAC §3, PRD §32G.5 (SLA)

---

## 1. Purpose & Context

The Incident Manager tracks system incidents, outages, and service degradations. It provides a structured workflow from detection through resolution, including post-mortem documentation and action item tracking.

### User Goals
- View active and historical incidents
- Create/update incident records during outages
- Document resolution and post-mortem analysis
- Track action items from post-mortems

### Entry Points
- Admin Dashboard alerts (system health degraded)
- Admin Navigation: "🚨 Incidents"
- PagerDuty/Slack alert links

### Exit Points
- Click related system health → A006
- Click post-mortem detail → inline expansion

---

## 2. Preconditions / Postconditions

### Preconditions
- Admin authenticated via VPN + MFA
- Role: Super Admin, Tech Admin (full), Operations Admin (view), Analyst (view)

### Postconditions
- Incident records logged in `admin_audit_log`
- Post-mortem action items tracked to completion
- Service level credits calculated if outage > 4h (PRD §32G.5)

---

## 3. Screen Layout

### ASCII Wireframe
```
┌─ Admin Shell ────────────────────────────────────────────────────────┐
│ 🏢 Creativanta Admin  [Incidents]   [Tech Admin] 👤 admin@...      │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ Active Incidents ─────────────────────────────────────────┐      │
│ │ 🔴 INC-0045 | API latency spike (p99 > 3s)                 │      │
│ │    Severity: Critical | Duration: 2h 15m | Lead: @techad1   │      │
│ │    Status: ⚡ Investigating | Affected: API, Publish Queue  │      │
│ │    [Update] [Resolve] [Escalate]                             │      │
│ │                                                              │      │
│ │ 🟡 INC-0044 | TikTok API intermittent errors                │      │
│ │    Severity: Medium | Duration: 4h | Lead: @techad2          │      │
│ │    Status: ⚡ Monitoring | Affected: TikTok Connector        │      │
│ │    [Update] [Resolve]                                        │      │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Recent (30d) ────────────────────────────────────────────────┐   │
│ │ [Severity ▾] [Status ▾] [Service ▾] [🔍 Search...]           │   │
│ │ ✅ INC-0043 | DB connection pool exhaustion | Resolved 12h ago│   │
│ │    Duration: 45m | Severity: Critical | [View Post-Mortem]    │   │
│ │ ✅ INC-0042 | CDN cache invalidation delay | Resolved 3d ago  │   │
│ │    Duration: 2h | Severity: Low | [View Post-Mortem]          │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Incident Metrics (90d) ────────────────────┐                     │
│ │ Total incidents: 12 | Avg resolution: 2.5h   │                     │
│ │ Uptime: 99.7% | SLA violated: 1 incident     │                     │
│ │ Open action items: 4 | Completed: 18          │                     │
│ └───────────────────────────────────────────────┘                     │
│                                                                      │
│ [+ Create Incident]                                                  │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
IncidentManagerPage
├── AdminShell (shared)
├── ActiveIncidentsPanel
│   └── IncidentCard[]
│       ├── SeverityBadge (🔴 Critical / 🟡 Medium / 🔵 Low)
│       ├── IncidentID + Title
│       ├── DurationTimer (live counting)
│       ├── LeadAssignment
│       ├── StatusBadge (Detected / Investigating / Monitoring / Mitigated / Resolved)
│       ├── AffectedServices tags
│       └── ActionButtons (Update, Resolve, Escalate)
├── RecentIncidentsPanel
│   ├── FilterBar (severity, status, service, search)
│   └── IncidentRow[]
│       ├── StatusIcon (✅ resolved / ⚠️ post-mortem pending)
│       ├── ID + Title
│       ├── Duration + Severity
│       └── PostMortemLink
├── MetricsPanel
│   ├── TotalIncidents
│   ├── AvgResolutionTime
│   ├── Uptime
│   ├── SLAViolations
│   └── ActionItems (open/completed)
└── CreateIncidentButton → Modal
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Active incidents | `incidents WHERE status != 'resolved'` | `AdminIncidentService/GetActive` | Sorted by severity then duration | Real-time (SSE) |
| Recent incidents | `incidents` with filters | `AdminIncidentService/List(filters, page)` | Paginated list | 5m TTL |
| Metrics | Aggregated from incidents + uptime monitor | `AdminIncidentService/GetMetrics(period)` | Stats | 15m TTL |
| Duration timer | Computed from `started_at` | Client-side | Live: "2h 15m" | Real-time |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | Create incident | Click "+ Create" | `AdminIncidentService/Create(data)` | New incident created | Modal form → toast "Incident created" | Super Admin, Tech Admin |
| 2 | Update incident | Click "Update" | `AdminIncidentService/Update(id, update)` | Timeline entry added | Update modal → new timeline entry visible | Super Admin, Tech Admin |
| 3 | Resolve incident | Click "Resolve" | `AdminIncidentService/Resolve(id, resolution)` | Status → resolved, duration computed | Confirmation + toast "Incident resolved" | Super Admin, Tech Admin |
| 4 | Create post-mortem | Click "Write Post-Mortem" | `AdminIncidentService/CreatePostMortem(incidentId, data)` | Post-mortem created | Rich text editor → save | Super Admin, Tech Admin |
| 5 | Escalate | Click "Escalate" | `AdminIncidentService/Escalate(id, channel)` | Alert sent to PagerDuty/Slack | Toast "Escalated to on-call" | Super Admin, Tech Admin |
| 6 | Filter/search | Filter controls | `AdminIncidentService/List(filters)` | — | List updates | Any viewing role |

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Skeleton |
| LOADED_ACTIVE | Active incidents exist | Red highlight header, active incidents panel prominent |
| LOADED_CLEAR | No active incidents | Green banner: "🟢 All systems operational. No active incidents." |
| ERROR | API failure | Error with retry |

---

## 8. Permission Matrix (Admin RBAC)

| Feature | Super Admin | Operations | Finance | Content | Support | Tech | Analyst | Auditor |
|---|---|---|---|---|---|---|---|---|
| View incidents | ✅ | ✅ | ❌ | ❌ | ❌ | ✅ | ✅ | ❌ |
| Create/update | ✅ | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ |
| Resolve | ✅ | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ |
| Write post-mortem | ✅ | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ |
| Escalate | ✅ | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ |

---

## 9. Navigation Map

```
Incident Manager (/admin/incidents)
├── → /admin/incidents/[id]/postmortem  (Post-mortem detail)
├── → /admin/system                      (System health detail)
├── → /admin/audit                       (Incident audit trail)
└── ← /admin                             (Dashboard)
```

---

## 10. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| VPN disconnected | Network down | Full-page VPN error | Reconnect |
| Save failed | Server error | Toast "Failed to save" + retry | Retry |
| Concurrent edit | Another admin editing | "Incident updated by @admin2. Reload." | Reload |

---

## 11. Accessibility

| Element | Requirement |
|---|---|
| Active incidents | `role="alert"` for critical, `aria-live="polite"` |
| Duration timer | `aria-label` with full duration text |
| Status badges | Color + text (not color-only) |

---

## 12. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| Active incidents | SSE | Real-time |
| Duration timers | Client-side | Every second |
| Metrics | Polling | Every 5 minutes |

---

## 13. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-admin-danger` | Critical severity, active incidents |
| `--color-admin-warning` | Medium severity |
| `--color-admin-success` | Resolved, "all clear" |
| `--color-admin-surface` | Card backgrounds |

---

## 14. Related Screens

| Screen | Relationship |
|---|---|
| [A001] Admin Dashboard | System health alerts → incidents |
| [A006] System Health | Detailed system diagnostics |
| [A010] Audit Log | Incident action history |
| [A008] Job Monitor | Queue-related incidents |

---

## 15. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 1.0 | Initial specification — aligned to S26 §9, PRD §32G.5 SLA | System |
