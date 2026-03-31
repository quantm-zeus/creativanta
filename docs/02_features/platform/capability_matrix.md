---
layer: features
module: M22
canonical: true
domain: platform
status: DRAFT
last_updated: 2026-03-30
---

# Feature: Capability Matrix (M22)

## Purpose

Creativanta operates across multiple platforms (TikTok, Facebook, Instagram, Shopee, YouTube, Lazada), each with different API capabilities, rate limits, feature availability, and stability characteristics. A publish action available on TikTok may not exist on Shopee. A feature that worked yesterday may be degraded today. Without a structured capability layer, operators encounter silent failures, broken workflows, and confusion about what they can and cannot do.

M22 exists as the **platform capability truth layer** — maintaining a real-time capability snapshot per platform per connected account, surfacing what actions are available/degraded/unsupported, and providing policy notes and fallback paths accessible from any action context. Every module that touches external platforms (M07, M11, M12, M13, M16, M17, M20) MUST query M22 before executing platform-dependent actions.

## Scope

### Covers (M22 owns capability awareness)
- Capability snapshots per platform: feature availability, API status, rate limits
- Platform health scoring: 0–100 composite score per platform per connected account
- Capability states per action: `supported`, `degraded`, `unsupported`, `unknown`
- Policy notes: human-readable explanations for why an action is unavailable or degraded
- Fallback paths: alternative actions when primary path is unavailable
- Connector health monitoring: periodic health checks, degradation detection, recovery detection
- Capability history: track when capabilities changed (for debugging and trend analysis)

### Does NOT cover (M22 boundaries)
- **M11 owns**: publish execution (M22 provides capability data; M11 decides based on it)
- **M20 owns**: workflow execution decisions (M20 queries M22 for capability checks)
- Platform API integration logic: connector implementation is in the platform adapter layer
- OAuth token management: handled by the connector authentication layer

## Actors

| Actor | Role | Primary Actions |
|---|---|---|
| Operator | Contributor+ | View capability matrix, check action availability, read policy notes |
| Manager | Manager+ | Configure fallback preferences, review capability history |
| System (Monitor) | System | Periodic capability checks, health score calculation, degradation/recovery detection |
| System (Notifier) | System | Emit `connector.degraded` / `connector.recovered` events |
| M20/M11/M07 (Consumers) | System | Query capability before action execution |

## Business Rules

1. **RULE-M22-001 (CRITICAL)**: **Every unsupported or degraded action MUST open a user-facing explanation.** When an operator encounters an unsupported action, the UI MUST NOT show a generic "unavailable" error. Instead, it MUST show: (a) what action is unavailable, (b) why (platform limitation, API change, degradation), (c) when it was last available (if applicable), (d) fallback path if one exists. Policy notes are the mechanism for this explanation (PRD §23.22 AC, Pack 05 §capability).
2. **RULE-M22-002**: Capability states: `supported` (fully functional), `degraded` (partially working, may fail), `unsupported` (not available on this platform), `unknown` (status cannot be determined — treated as `degraded` for safety). State transitions emit events: `connector.degraded`, `connector.recovered`, `capability.snapshot_captured` (Domain events §6).
3. **RULE-M22-003**: Platform health score (0–100) composites: API availability (40%), error rate (25%), latency (20%), rate limit remaining (15%). Score thresholds: ≥80 = healthy, 50–79 = degraded, <50 = critical. Score calculated per connected account, not globally (Pack 05, API map §9).
4. **RULE-M22-004**: Fallback paths MUST be accessible from action context. When a primary action is unavailable, the system MUST suggest alternatives. Example: "TikTok direct publish unavailable → Manual upload fallback: download video + upload manually. [Download video] [View platform status]" — fallback paths are defined per action and configurable per workspace (PRD §23.22 AC).
5. **RULE-M22-005**: Capability snapshots are captured periodically (default: 30s polling for health, 5-minute full capability refresh) AND on-demand when modules query before action execution. Stale snapshots (>10 min old) trigger a forced refresh before returning capability status to the consumer (API map §9, Pack 03 §11A.2).
6. **RULE-M22-006**: Capability data feeds into multiple modules: M11 (publish — can this content type be published to this platform?), M20 (workflow — can this action execute?), M07 (production — can this AI feature work with this platform's output format?), M12 (inbox — can DMs be sent via this platform?). Each module queries M22 via `PlatformHealthService/GetScores` or `CapabilityService/Check` (API map §9).

## Main Flow

1. **Capability monitoring**: System performs periodic health checks
   - Per-platform API health: connectivity, error rates, latency
   - Per-connected-account checks: OAuth token validity, rate limit status
   - Results compute health score (RULE-M22-003)
   - `capability.snapshot_captured` event emitted periodically
2. **Status change detection**: System detects capability changes
   - Platform goes from healthy → degraded: `connector.degraded` event
   - Platform recovers: `connector.recovered` event
   - New capability discovered (API update): capability matrix updated
   - Capability removed (API deprecation): action marked `unsupported` + policy note
3. **Action context query**: Module checks capability before action
   - M11: "Can I publish a video to TikTok right now?" → M22 returns supported/degraded/unsupported + policy note
   - M20: "Can this workflow action execute?" → M22 returns capability status + fallback
   - If degraded: calling module decides (proceed with warning, wait, fallback)
   - If unsupported: calling module MUST NOT attempt the action
4. **Dashboard view**: Operator views capability matrix
   - Grid: platforms × action categories (publish, inbox, commerce, analytics sync)
   - Per-cell: status badge (green/yellow/red/grey) + policy note on click
   - Health score trend chart per platform
   - Connected account health per workspace
5. **Fallback presentation**: System shows alternatives for unavailable actions
   - Contextual fallback: appears next to blocked action in UI
   - Options: manual workaround, alternative platform, retry later, contact support
   - Fallback actions trackable in analytics

## Alternate Flows

### A1: Platform API Breaking Change Detected
- Trigger: Platform API returns new error codes or deprecation headers
- Steps: System detects breaking change → affected capabilities marked `unsupported` → policy note auto-generated: "Platform updated their API. This feature requires adapter update. [ETA: investigating]" → `connector.degraded` event → Tech Admin alerted
- Result: Users see clear explanation, not cryptic errors

### A2: Connected Account Token Expired
- Trigger: OAuth refresh token fails
- Steps: Account-level health drops to 0 → all capabilities for this account marked `degraded` → user notified: "Your [Platform] connection needs reconnection. [Reconnect now]" → M22 returns `degraded` for all actions on this account
- Result: Clear action required from user, no silent failures

## Edge Cases

### EC-M22-001: Capability Check During Network Partition
- Condition: M22 cannot reach platform API to verify capability
- Expected behavior: Capability status = `unknown` → treated as `degraded` for safety. Policy note: "Platform status could not be verified. [Retry check] [Proceed with caution]." Actions that require `supported` status will not execute. Cached last-known status shown with staleness indicator.
- Reference: RULE-M22-002, RULE-M22-005

### EC-M22-002: Platform Partially Supporting a Feature
- Condition: TikTok supports video publish but not carousel publish
- Expected behavior: Capability matrix shows per-action-type granularity. "TikTok: Video Publish = supported, Carousel Publish = unsupported." Policy note for carousel: "TikTok API does not support carousel posts via API. Upload manually via TikTok app." Content creation (M07/M10) shows this constraint when selecting publish targets.
- Reference: RULE-M22-001, RULE-M22-004

### EC-M22-003: All Platforms Degraded Simultaneously
- Condition: All connected platforms show degraded status
- Expected behavior: Dashboard shows global degradation alert. System checks: is this a Creativanta infrastructure issue or platform-side? If Creativanta-side: incident triggered (M23/S26). If platform-side: each platform's specific issue shown. Workflows with platform actions auto-pause with explanation.
- Reference: RULE-M22-003

## State Machine

### Capability State Per Action

| State | Badge | Meaning | Module Behavior |
|---|---|---|---|
| supported | 🟢 | Fully functional | Execute normally |
| degraded | 🟡 | Partially working, may fail | Execute with warning OR use fallback |
| unsupported | 🔴 | Not available on this platform | MUST NOT execute; show fallback |
| unknown | ⚪ | Status cannot be determined | Treat as degraded; forced refresh |

### Health Score Thresholds

| Score | Status | Dashboard Color | auto-Action |
|---|---|---|---|
| 80–100 | Healthy | Green | None |
| 50–79 | Degraded | Yellow | `connector.degraded` event, operator notification |
| 0–49 | Critical | Red | `connector.degraded` event, urgent notification, workflow auto-pause suggested |

## Related Contracts

| Topic | File | Section |
|---|---|---|
| API | [04_contracts/api_endpoint_map.md](../04_contracts/api_endpoint_map.md) | §9 (PlatformHealthService/GetScores, GetHistory; LinkHealthService — 5 RPCs), §2.8 (Capability — ~5 RPCs) |
| Events | [04_contracts/domain_event_catalog.md](../04_contracts/domain_event_catalog.md) | §6 (capability.snapshot_captured, connector.degraded, connector.recovered) |
| RBAC | [04_contracts/rbac_permission_matrix.md](../04_contracts/rbac_permission_matrix.md) | §2.8 (capability — Viewer+ for read, Manager+ for configuration) |
| Connector Specs | [04_contracts/connector_specs.md](../04_contracts/connector_specs.md) | per-platform capability definitions |
| Real-time | Pack 03 §11A | Connector health uses polling (30s interval) |
| Consumers | M11, M20, M07, M12 | All query M22 before platform-dependent actions |

## Related Screens

| Platform | Screen | Notes |
|---|---|---|
| Web | Capability matrix | Grid: platforms × action types with status badges, policy notes on click |
| Web | Platform health dashboard | Per-platform health score trend, connected account status, degradation history |
| Web | Action context tooltip | In-context capability check: "This action is [status] because [policy note]. [Fallback]" |
| Mobile | Platform status | Compact health scores per platform, connection status |
| Mobile | Action guards | Pre-action capability check inline with action buttons |

## Acceptance Criteria

1. **Given** a platform action is `'unsupported'`, **when** the operator encounters this action in the UI (publish, workflow, etc.), **then** the UI MUST show: what action is unavailable, why (policy note text), and a fallback path (if defined) — NOT a generic "unavailable" error.

2. **Given** a connected platform's health score drops below 50, **when** the system detects this, **then** a `connector.degraded` event MUST fire, the operator MUST be notified, and the platform MUST show a red status badge on the capability matrix.

3. **Given** M20 queries M22 before executing a workflow action, **when** M22 returns `'degraded'` for the action's required capability, **then** M20 MUST receive the degradation context including: current status, policy note, and available fallback path — enabling M20 to make an informed execution decision.

4. **Given** M22 cannot reach a platform API for capability verification, **when** a module queries that capability, **then** M22 MUST return `'unknown'` status (treated as degraded), show staleness indicator for cached data, and trigger a forced refresh — the system MUST NOT return stale `'supported'` status as fresh.

5. **Given** TikTok supports video publish but not carousel publish, **when** the operator views the capability matrix, **then** the matrix MUST show per-action-type granularity: "Video Publish: 🟢 Supported" and "Carousel Publish: 🔴 Unsupported — [policy note]" — capabilities are NOT all-or-nothing per platform.

## Open Questions / Blockers

- [NONE] — No critical blockers specific to M22. Platform health RPCs defined in API map §9 (~5 RPCs).
