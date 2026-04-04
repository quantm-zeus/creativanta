---
layer: quality_ops
canonical: true
created: 2026-04-01
---

# Surface Parity Specification — Web, Mobile, Admin

> **Purpose**: Documents which features are available on each platform (web, mobile, admin), their parity level, and intentional differences.
> **Resolves**: Review §7 finding "Multi-surface parity: 2/3 — no parity spec"

---

## 1. Platform Overview

| Platform | Tech | Screen Count | Audience |
|---|---|---|---|
| **Web** (SvelteKit) | SvelteKit 2 + Svelte 5 | 133 screens | Primary workspace for creators/operators |
| **Mobile** (Flutter) | Flutter 3.41 + Impeller | 61 screens | On-the-go management + consumption |
| **Admin** (SvelteKit) | SvelteKit (separate app) | 32 screens | Internal operations team only |
| **Shared** | Component library | 12 shared specs | Cross-platform components |

---

## 2. Feature Parity Matrix

### Legend
- 🟢 **Full**: All features available
- 🟡 **Partial**: Core features available, advanced features web-only
- 🔴 **None**: Not available on this platform
- ⚪ **N/A**: Not applicable to this platform

| Module | Web | Mobile | Admin | Notes |
|---|---|---|---|---|
| **Auth & Onboarding** | 🟢 Full | 🟢 Full | 🟢 Full (separate) | Mobile uses biometric + deep links |
| **M01 Home Dashboard** | 🟢 Full | 🟢 Full | ⚪ N/A | Mobile = simplified card layout |
| **M02 Trend Radar** | 🟢 Full | 🟡 Partial | ⚪ N/A | Mobile: view-only, no bulk actions |
| **M03 Competitor Intel** | 🟢 Full | 🟡 Partial | ⚪ N/A | Mobile: view competitors, no watchlist editing |
| **M04 Opportunity Board** | 🟢 Full | 🟡 Partial | ⚪ N/A | Mobile: browse only, convert on web |
| **M05 Idea Engine** | 🟢 Full | 🟢 Full | ⚪ N/A | Mobile: quick capture + swipe UI |
| **M06 Script Lab** | 🟢 Full | 🟡 Partial | ⚪ N/A | Mobile: review + comment, no Tiptap editor |
| **M07 AI Video Studio** | 🟢 Full | 🟡 Partial | ⚪ N/A | Mobile: trigger + monitor, no timeline editor |
| **M08 Continuity OS** | 🟢 Full | 🟡 Partial | ⚪ N/A | Mobile: browse packs, no deep editing |
| **M09 Derivatives** | 🟢 Full | 🔴 None | ⚪ N/A | Desktop-only workflow |
| **M10 Packaging QA** | 🟢 Full | 🟡 Partial | ⚪ N/A | Mobile: approve/reject only |
| **M11 Publish Hub** | 🟢 Full | 🟢 Full | ⚪ N/A | Mobile: quick publish + schedule |
| **M12 Unified Inbox** | 🟢 Full | 🟢 Full | ⚪ N/A | Mobile: full chat + suggested replies |
| **M13 Product Hub** | 🟢 Full | 🟡 Partial | ⚪ N/A | Mobile: browse + quick edit, no bulk ops |
| **M14 Monetization OS** | 🟢 Full | 🟡 Partial | ⚪ N/A | Mobile: view memberships, no creation |
| **M15 Store** | 🟢 Full | 🔴 None | ⚪ N/A | Store editor is desktop-only |
| **M16 Affiliate Network** | 🟢 Full | 🟡 Partial | ⚪ N/A | Mobile: view links + earnings |
| **M17 Live War Room** | 🟢 Full | 🟡 Partial | ⚪ N/A | Mobile: monitor KPIs, no cue card editing |
| **M18 Seeding CRM** | 🟢 Full | 🟡 Partial | ⚪ N/A | Mobile: approve/track shipments |
| **M19 Finance Ledger** | 🟢 Full | 🟡 Partial | ⚪ N/A | Mobile: summary + profit alerts |
| **M20 Workflow Studio** | 🟢 Full | 🔴 None | ⚪ N/A | Visual editor is desktop-only |
| **M21 Agent Center** | 🟢 Full | 🟡 Partial | ⚪ N/A | Mobile: monitor runs, no config |
| **M22 Capability Matrix** | 🟢 Full | 🔴 None | ⚪ N/A | Admin tool, desktop-only |
| **M23 Billing & Admin** | 🟢 Full | 🟡 Partial | 🟢 Full | Mobile: view plan, no admin functions |
| **S16 Creator Pro** | 🟢 Full | 🟡 Partial | ⚪ N/A | Mobile: view media kit, no editor |
| **S26 Internal Admin** | ⚪ N/A | ⚪ N/A | 🟢 Full | Admin-only |
| **Gamification** | 🟢 Full | 🟢 Full | ⚪ N/A | Mobile: achievements + streaks |
| **Analytics** | 🟢 Full | 🟡 Partial | 🟢 Full | Mobile: key metrics only |
| **Settings** | 🟢 Full | 🟢 Full | ⚪ N/A | Mobile: core settings only |

---

## 3. Intentional Platform Differences

### 3.1 Mobile Exclusions (by design)

| Feature | Reason |
|---|---|
| Script rich-text editing | Tiptap editor not practical on mobile |
| Workflow visual builder | Drag-and-drop requires desktop |
| Store page editor | Layout editor requires desktop |
| Asset derivative management | Complex multi-panel workflow |
| Capability matrix | Admin tool, not needed on mobile |
| Bulk operations (any module) | Too complex for mobile UX |

### 3.2 Mobile Additions (not on web)

| Feature | Reason |
|---|---|
| Biometric authentication | Mobile-native security |
| Push notification management | Mobile notification center |
| Quick capture (Ideas) | Camera + voice memo |
| Swipe-to-archive (Ideas) | Touch-native gesture |
| Workspace quick-switch | Bottom sheet selector |

### 3.3 Admin Exclusions

| Feature | Reason |
|---|---|
| All user-facing features | Admin is for operations only |
| Mobile access | Security policy: VPN + MFA, no mobile |

---

## 4. Parity Enforcement Rules

| Rule | Description |
|------|-------------|
| PARITY-001 | All modules with 🟢 on mobile MUST share the same API service (no mobile-specific endpoints) |
| PARITY-002 | Mobile 🟡 partial features MUST be a strict subset of web features (no mobile-only business logic) |
| PARITY-003 | Data created on mobile MUST be fully visible/editable on web (no mobile-only data) |
| PARITY-004 | Notification triggers are platform-agnostic (event-driven, not platform-driven) |
| PARITY-005 | Mobile quick-publish uses the same `PublishService/Execute` RPC as web |

---

## 5. Parity Score

| Metric | Value |
|---|---|
| Modules with full parity (🟢 on both) | 8/28 (29%) |
| Modules with partial mobile (🟡) | 16/28 (57%) |
| Modules with no mobile (🔴) | 4/28 (14%) |
| Admin-only modules | — |

> **Target for v1**: All 🟢 modules functional on both platforms. 🟡 modules have core CRU (no delete/bulk) on mobile. 🔴 modules are intentionally desktop-only.

## Cross-references

- **Screens**: `03_screens/` (web/, mobile/, admin/, shared/)
- **Tech stack**: `05_system/tech_stack_adr.md` (ADR-001 SvelteKit, ADR-008 Flutter)
- **API**: `04_contracts/api_endpoint_map.md` (shared API surface)
