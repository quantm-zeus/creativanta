# Screen: Web — Publish Diagnostics

> **Screen ID**: W058
> **Module**: M11 — Publish Hub (Diagnostics)
> **Route**: `/publish/[id]/diagnostics`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 04 §Publish, PRD §23.11, A1 Schema (publish_items, publish_logs, capability_snapshots), B5 RBAC §2.7

---
## 1. Purpose & Context

Deep technical diagnostics for a publish item — API call logs, platform capability state at publish time, error traces, retry history, and actionable recommendations. This is the debugging surface when a publish fails or partially succeeds.

### User Goals
- Understand why a publish failed or was partially successful
- See exact API errors and platform responses
- Know if the issue is on Creativanta's side or platform's side
- Retry failed publishes with one click

### Business Goals
- Reduce support tickets by self-service diagnostics
- Track platform reliability (uptime, error rates)
- Enable fast resolution of publishing issues

### Entry Points
- Publish Calendar (W041): failed publish item → "🔧 Diagnostics" button
- Publish Queue (W042): error item → "View diagnostics"
- Notification: "Publish failed for {title}" → deep link
- Channel Posts (W043): "Failed to publish" status → diagnostics

### Exit Points
- "🔄 Retry now" → Re-triggers publish
- "← Publish Item" → Back to publish item detail
- "📋 Copy error" → Clipboard for support ticket
- "→ Connector Settings" → Fix connection issues

---
## 2. Preconditions / Postconditions

### Preconditions
- Publish item exists (any status: published, failed, partially_published)
- User has `publish:manage` or `publish:read` permission

### Postconditions
- Retry creates new publish attempt entry in logs
- Error resolution tracked for pattern analysis

---
## 3. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Publish Item   🔧 Diagnostics for "5 tips nấu ăn"               │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Status Overview ─────────────────────────────────────────────┐   │
│ │ Overall: 🟡 Partially published (2/3 platforms)               │   │
│ │ ✅ TikTok: Published · ✅ Instagram: Published                │   │
│ │ 🔴 YouTube: Failed (RATE_LIMIT_EXCEEDED)                      │   │
│ │ Attempt: 3/3 exhausted · Last attempt: 19:15:23 (12m ago)     │   │
│ │ [🔄 Retry YouTube] [📋 Copy error for support]               │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Capability Snapshot at Publish Time ─────────────────────────┐   │
│ │ Platform   │ Token  │ Rate  │ Publish │ Notes                 │   │
│ │ 🎵 TikTok  │ ✅ Valid│ 145/600│ 🟢 OK  │ Published in 1.2s    │   │
│ │ 📸 IG      │ ✅ Valid│ 89/200 │ 🟢 OK  │ Published in 2.1s    │   │
│ │ ▶️ YouTube │ ✅ Valid│ 198/200│ 🔴 FAIL│ Rate limit at 198/200│   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ API Call Log (chronological) ────────────────────────────────┐   │
│ │ 19:05:234 │ POST /v1/tiktok/publish                          │   │
│ │           │ → 200 OK (1.2s)                                   │   │
│ │           │ Response: {video_id: "abc123", status: "ok"}     │   │
│ │ 19:05:235 │ POST /v1/instagram/publish                       │   │
│ │           │ → 200 OK (2.1s)                                   │   │
│ │           │ Response: {media_id: "xyz789", status: "ok"}     │   │
│ │ 19:05:236 │ POST /v1/youtube/upload                          │   │
│ │           │ → 429 RATE_LIMIT_EXCEEDED (0.3s)                  │   │
│ │           │ Response: {error: "quotaExceeded", retry: 600}   │   │
│ │ 19:10:001 │ RETRY POST /v1/youtube/upload (attempt 2)       │   │
│ │           │ → 429 RATE_LIMIT_EXCEEDED (0.2s)                  │   │
│ │ 19:15:001 │ RETRY POST /v1/youtube/upload (attempt 3)       │   │
│ │           │ → 429 RATE_LIMIT_EXCEEDED (0.2s)                  │   │
│ │           │ ❌ Max retries exhausted                           │   │
│ │ [📋 Copy full log] [📥 Export log]                            │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Error Analysis & Recommendations ────────────────────────────┐   │
│ │ 🔍 Root cause: YouTube API rate limit exceeded (429)          │   │
│ │ 📊 At publish time: 198/200 daily quota used                  │   │
│ │                                                                │   │
│ │ 💡 Recommendations:                                            │   │
│ │ 1. Wait 10 minutes and retry (rate limit resets hourly)       │   │
│ │ 2. Schedule YouTube publishes at off-peak times (6-8 AM)      │   │
│ │ 3. Consider spreading content across multiple time slots      │   │
│ │                                                                │   │
│ │ 📈 Platform reliability (30d):                                 │   │
│ │ TikTok: 99.2% success · IG: 98.5% · YouTube: 94.1% (↓)     │   │
│ │                                                                │   │
│ │ [🔄 Retry now] [⏰ Schedule retry in 10m] [→ Connector Settings]│ │
│ └────────────────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────────────┘
```

---
## 4. Component Hierarchy

```
PublishDiagnosticsPage
├── AppShell (shared)
├── PageHeader
│   ├── BackLink ("← Publish Item")
│   └── PageTitle ("🔧 Diagnostics for {title}")
├── StatusOverview
│   ├── OverallStatus (fully published / partially / failed)
│   ├── PlatformStatusList
│   │   └── PlatformStatusItem[] (icon, status, error code if failed)
│   ├── AttemptInfo (attempt count / max, last attempt timestamp)
│   ├── RetryButton
│   └── CopyErrorButton
├── CapabilitySnapshot
│   ├── CapabilityTable
│   │   └── PlatformRow[]
│   │       ├── PlatformIcon
│   │       ├── TokenStatus (valid/expired)
│   │       ├── RateLimit (used/total)
│   │       ├── PublishResult (OK/FAIL)
│   │       └── Notes (response time, specific error)
├── APICallLog
│   ├── LogEntry[] (chronological)
│   │   ├── Timestamp
│   │   ├── Method + Endpoint
│   │   ├── ResponseStatus (color-coded)
│   │   ├── ResponseTime
│   │   ├── ResponseBody (collapsible JSON)
│   │   └── RetryBadge (if retry attempt)
│   ├── CopyLogButton
│   └── ExportLogButton
├── ErrorAnalysis
│   ├── RootCause
│   ├── ContextInfo (rate limit state, token state at time)
│   ├── Recommendations[]
│   │   ├── RecommendationText
│   │   └── ActionLink (if applicable)
│   ├── PlatformReliability (30d success rates per platform)
│   └── ActionBar
│       ├── RetryNowButton
│       ├── ScheduleRetryButton (with time picker)
│       └── ConnectorSettingsLink
```

---
## 5. Displayed Data

| Field | Source | Format |
|---|---|---|
| Publish status per platform | `publish_logs.status` grouped by platform | Badge per platform |
| Token validity | `capability_snapshots.token_valid` at publish time | ✅/❌ |
| Rate limit state | `capability_snapshots.rate_used` / `rate_total` | "198/200" |
| API logs | `publish_logs.api_calls[]` | Timestamped log entries |
| Response body | `publish_logs.response_body` | JSON (collapsible) |
| Retry count | `publish_logs.retry_count` | "3/3" |
| Error code | `publish_logs.error_code` | "RATE_LIMIT_EXCEEDED" |
| Root cause | AI-analyzed or pattern-matched | Text description |
| Recommendations | AI-generated or rule-based | Numbered list |
| Platform reliability | Aggregated publish success rate (30d) | "99.2%" per platform |

---
## 6. User Actions

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Retry now | "🔄 Retry now" | `PublishService/Retry(item_id, platform)` | New publish attempt, spinner | `publish:manage` |
| 2 | Schedule retry | "⏰ Schedule" → time | `PublishService/ScheduleRetry(item_id, platform, time)` | Scheduled, toast | `publish:manage` |
| 3 | Copy error | "📋 Copy error" | — (clipboard) | Formatted error text for support | Any |
| 4 | Copy full log | "📋 Copy full log" | — (clipboard) | Full API log copied | `publish:manage` |
| 5 | Export log | "📥 Export" | — | JSON log file download | `publish:manage` |
| 6 | Go to connector | "→ Connector Settings" | — | → W117 Connected Accounts | `settings:manage` |

---
## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching diagnostics | Skeleton sections |
| LOADED_SUCCESS | All platforms published OK | Green overview: "✅ Tất cả nền tảng publish thành công!" |
| LOADED_PARTIAL | Some platforms failed | Yellow overview with per-platform status |
| LOADED_FAILED | All platforms failed | Red overview with error analysis |
| RETRYING | Retry in progress | Spinner on retry button, "Đang thử lại..." |
| RETRY_SCHEDULED | Retry scheduled | "⏰ Retry scheduled at {time}" banner |
| ERROR | Diagnostics API failed | Error with retry |

---
## 8. Error Taxonomy

| Error Category | Common Codes | Recommendation Template |
|---|---|---|
| Rate Limit | 429, RATE_LIMIT_EXCEEDED | "Wait {time} and retry. Consider scheduling." |
| Auth | 401, TOKEN_EXPIRED | "Token expired. [→ Reconnect platform]" |
| Permission | 403, INSUFFICIENT_SCOPE | "Platform needs additional permissions. [→ Reconnect with full scope]" |
| Content | CONTENT_POLICY, NSFW | "Content flagged by platform. Review content guidelines." |
| Server | 500, 502, 503 | "Platform server error. Try again in a few minutes." |
| Network | TIMEOUT, ECONNREFUSED | "Network issue. Check internet connection." |
| Format | INVALID_VIDEO, DURATION_EXCEEDED | "Content format not supported. Check platform requirements." |

---
---

## 9. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached diagnostics | Retry online |
| Retry fails mid-process | Platform rejects during retry | New log entry: "❌ Retry failed: {error}" | Show diagnostics |
| Scheduled retry conflicts | Another retry already scheduled | Toast: "Đã có retry lên lịch lúc {time}. [Hủy cũ & lên lịch mới?]" | Choose |
| Diagnostics load fail | API error | "Không tải được diagnostics. [Thử lại]" | Retry |
| Log export fail | Large log / timeout | Toast: "Không xuất được. [Thử lại]" | Retry |

---

## 10. Accessibility

| Element | Requirement |
|---|---|
| Status overview | `role="status"`, `aria-label="Partially published: 2 of 3 platforms"` |
| Capability table | `role="table"`, columns `aria-label` with platform context |
| API log entries | `role="log"`, `aria-live="polite"`, each entry `aria-label="{time}: {endpoint} → {status}"` |
| Error analysis | `role="alert"` for root cause section |
| Retry button | `aria-label="Retry publishing to {platform}"` |

---

## 11. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Section skeletons |
| Status overview | 200-400ms | Platform badges populate |
| Capability table | 300-600ms | Table rows fill |
| API log | 400-800ms | Log entries stagger in |
| Error analysis | 500-1000ms | Root cause + recommendations appear |
| Retry | 2-30s | Button spinner → new log entries stream |

---

## 12. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `publish_diagnostics.viewed` | Page load | `publish_item_id`, `overall_status`, `failed_platforms` |
| `publish_diagnostics.retry_now` | "Retry now" | `platform`, `error_code`, `retry_count` |
| `publish_diagnostics.retry_scheduled` | "Schedule retry" | `platform`, `scheduled_time` |
| `publish_diagnostics.error_copied` | "Copy error" | `error_code` |
| `publish_diagnostics.log_copied` | "Copy full log" | `log_entry_count` |
| `publish_diagnostics.log_exported` | "Export log" | `format` |
| `publish_diagnostics.connector_navigated` | "→ Connector Settings" | `platform` |
| `publish_diagnostics.recommendation_followed` | Click recommendation link | `recommendation_type` |

---

## 13. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/publish/[id]/diagnostics/+page.svelte`
- **Server load**: `+page.server.ts` → `PublishService/GetDiagnostics(id)` includes logs, capability, reliability
- **SSE**: During retry → `/events/publish/{id}` streams new log entries in real-time
- **Capability snapshot**: Frozen at publish time (historical, not current)
- **Reliability stats**: `AnalyticsService/GetPlatformReliability(30d)` — aggregated
- **Error taxonomy**: Pattern-matched server-side against known error codes
- **Recommendations**: AI-generated if no pattern match, cached per error code
- **Copy to clipboard**: `navigator.clipboard.writeText()` with formatted output

---

## 14. Localization Notes

- Timestamps: "19:05:234" (HH:mm:ss.ms) for API logs
- Status: "✅ Thành công", "🔴 Thất bại", "🟡 Một phần"
- Error codes: English (HTTP/API codes: "429 RATE_LIMIT_EXCEEDED")
- Reliability: "99.2% thành công trong 30 ngày"
- Recommendations: Vietnamese
- Tone: Technical, diagnostic — clear cause → action

---

## 15. Design Tokens

| Token | Usage |
|---|---|
| `--color-status-success` | ✅ Published platform (green) |
| `--color-status-failed` | 🔴 Failed platform (red) |
| `--color-status-partial` | 🟡 Partially published (amber) |
| `--color-reliability-high` | >98% success (green) |
| `--color-reliability-medium` | 94-98% success (amber) |
| `--color-reliability-low` | <94% success (red) |
| `--color-log-request` | API request text |
| `--color-log-response-ok` | 200 response (green) |
| `--color-log-response-error` | 4xx/5xx response (red) |

---

## 16. Related Screens

| Screen | Relationship |
|---|---|
| [W045] Publish Item Detail | Parent: publish overview |
| [W044] Publish Queue | Failed items queue |
| [W117] Connected Accounts | Fix connector issues |
| [W119] Diagnostics Center | System-wide diagnostics |

---

## 17. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 errors (retry fail, scheduled conflict), log/table a11y, 8 analytics, SvelteKit impl (SSE retry, log stream), localization, 9 design tokens (reliability colors). | System |
| 2026-03-28 | 1.0 | Initial specification | System |
