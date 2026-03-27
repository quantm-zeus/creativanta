# B1 — Screen & UI Flow Map

> **Upstream**: Pack 01 (FE/UX), Product Freeze §35-37
> **Purpose**: Screen inventory for Google Stitch design generation
> **Tech**: SvelteKit 2 + Svelte 5 + shadcn-svelte

---

## 1. Global Navigation (Sidebar)

```
┌── Logo + Workspace Selector ──┐
│                                │
│  🏠 Home (M01)                 │
│  📊 Dashboard                  │
│  ─────────────────             │
│  🔥 Trends (M02)              │
│  🔍 Research (M03)             │
│  💡 Opportunities (M04)        │
│  ─────────────────             │
│  ✨ Ideas (M05)                │
│  📝 Scripts (M06)              │
│  🎬 AI Studio (M07)           │
│  🧬 Continuity (M08)          │
│  📦 Derivatives (M09)         │
│  ─────────────────             │
│  ✅ Packaging (M10)            │
│  📤 Publish (M11)             │
│  💬 Inbox (M12)               │
│  ─────────────────             │
│  🛍️ Products (M13)            │
│  💰 Monetization (M14)        │
│  🏪 Store (M15)               │
│  🤝 Affiliates (M16)          │
│  ─────────────────             │
│  🔴 Live (M17)                │
│  📬 Seeding (M18)             │
│  ─────────────────             │
│  📈 Profit OS (M19)           │
│  ⚡ Workflows (M20)           │
│  📚 Recipes (M21)             │
│  🔧 Capabilities (M22)        │
│  ⚙️ Settings (M23)            │
│  ─────────────────             │
│  🤖 Copilot (floating)        │
│  [Mode Selector]               │
└────────────────────────────────┘
```

---

## 2. Screen Inventory (Total: ~95 screens)

### 2.1 Home & Global (~8 screens)

| # | Screen | Route | Key Components |
|---|---|---|---|
| 1 | Home Dashboard | `/` | Action cards, risk alerts, profit mini, pending approvals |
| 2 | Morning Brief | `/brief` | Highlights, money summary, actions, suggestions |
| 3 | Onboarding Wizard | `/onboarding` | 5-step setup, connector guide, recipe start |
| 4 | Setup Checklist | `/setup` | Progress bar, pending connections, first actions |
| 5 | Notifications | `/notifications` | Notification list, filters, deep links |
| 6 | Global Search | Command bar (Cmd+K) | Universal search, quick actions |
| 7 | User Settings | `/settings/profile` | Profile, preferences, locale, theme |
| 8 | Workspace Settings | `/settings/workspace` | Team, billing, tier, danger zone |

### 2.2 Intelligence (~8 screens)

| # | Screen | Route |
|---|---|---|
| 9 | Trend Radar | `/trends` |
| 10 | Trend Detail | `/trends/[id]` |
| 11 | Watchlist Manager | `/trends/watchlists` |
| 12 | Competitor Registry | `/research/competitors` |
| 13 | Benchmark View | `/research/benchmarks` |
| 14 | Opportunity Board | `/opportunities` |
| 15 | Opportunity Detail | `/opportunities/[id]` |
| 16 | Opportunity Convert | `/opportunities/[id]/convert` |

### 2.3 Content Creation (~12 screens)

| # | Screen | Route |
|---|---|---|
| 17 | Idea Board | `/ideas` |
| 18 | Idea Generator (AI) | `/ideas/generate` |
| 19 | Idea Detail | `/ideas/[id]` |
| 20 | Script List | `/scripts` |
| 21 | Script Editor | `/scripts/[id]` |
| 22 | Script Approval Review | `/scripts/[id]/review` |
| 23 | Asset Brief Editor | `/scripts/[id]/brief` |
| 24 | AI Studio Home | `/studio` |
| 25 | Character Builder | `/studio/characters/new` |
| 26 | Character Library | `/studio/characters` |
| 27 | Continuity Packs | `/continuity` |
| 28 | Derivative Manager | `/derivatives` |

### 2.4 AI Video Production (~10 screens)

| # | Screen | Route |
|---|---|---|
| 29 | Quick Edit | `/studio/quick-edit` |
| 30 | Clip Factory | `/studio/clip-factory` |
| 31 | Multi-Merge | `/studio/multi-merge` |
| 32 | AI Remix Studio | `/studio/remix` |
| 33 | Product Showcase | `/studio/showcase` |
| 34 | Image-to-Video | `/studio/img2vid` |
| 35 | Thumbnail Studio | `/studio/thumbnails` |
| 36 | Link-to-Video | `/studio/link2vid` |
| 37 | Translation Studio | `/studio/translate` |
| 38 | Generation Queue | `/studio/queue` |

### 2.5 Publish (~6 screens)

| # | Screen | Route |
|---|---|---|
| 39 | Packaging QA | `/packaging/[id]` |
| 40 | Publish Queue | `/publish` |
| 41 | Schedule Calendar | `/publish/calendar` |
| 42 | Publish Item Detail | `/publish/[id]` |
| 43 | Publish Diagnostics | `/publish/[id]/diagnostics` |
| 44 | Channel Posts | `/publish/posts` |

### 2.6 Engagement (~6 screens)

| # | Screen | Route |
|---|---|---|
| 45 | Unified Inbox | `/inbox` |
| 46 | Thread Detail | `/inbox/[id]` |
| 47 | Contact List | `/contacts` |
| 48 | Contact Detail | `/contacts/[id]` |
| 49 | Follow-up Tasks | `/inbox/tasks` |
| 50 | Bulk Triage | `/inbox/triage` |

### 2.7 Commerce (~12 screens)

| # | Screen | Route |
|---|---|---|
| 51 | Product List | `/products` |
| 52 | Product Detail | `/products/[id]` |
| 53 | Offer List | `/offers` |
| 54 | Offer Editor | `/offers/[id]` |
| 55 | Order List | `/orders` |
| 56 | Order Detail | `/orders/[id]` |
| 57 | Campaign List | `/campaigns` |
| 58 | Campaign Detail | `/campaigns/[id]` |
| 59 | Affiliate Dashboard | `/affiliates` |
| 60 | Affiliate Link Manager | `/affiliates/links` |
| 61 | Store Page Editor | `/store` |
| 62 | Membership Manager | `/store/memberships` |

### 2.8 Live Commerce (~4 screens)

| # | Screen | Route |
|---|---|---|
| 63 | Live Session Planner | `/live` |
| 64 | Live War Room | `/live/[id]` |
| 65 | Post-Live Summary | `/live/[id]/summary` |
| 66 | Highlight Manager | `/live/[id]/highlights` |

### 2.9 Seeding/Sample (~3 screens)

| # | Screen | Route |
|---|---|---|
| 67 | Creator Roster | `/seeding` |
| 68 | Sample Requests | `/seeding/samples` |
| 69 | Shipment Tracking | `/seeding/shipments` |

### 2.10 Finance & Proof (~8 screens)

| # | Screen | Route |
|---|---|---|
| 70 | Profit Dashboard | `/profit` |
| 71 | Revenue Breakdown | `/profit/revenue` |
| 72 | Cost Manager | `/profit/costs` |
| 73 | Settlement List | `/profit/settlements` |
| 74 | Reconciliation Queue | `/profit/reconciliation` |
| 75 | Proof Center | `/profit/proof` |
| 76 | Proof Bundle Detail | `/profit/proof/[id]` |
| 77 | Anomaly Inspector | `/profit/anomalies` |

### 2.11 Workflow & Agent (~5 screens)

| # | Screen | Route |
|---|---|---|
| 78 | Workflow List | `/workflows` |
| 79 | Workflow Builder | `/workflows/[id]` (Activepieces embed) |
| 80 | Workflow Run History | `/workflows/[id]/runs` |
| 81 | Recipe Marketplace | `/recipes` |
| 82 | Agent Run Inspector | `/agents/[id]` |

### 2.12 Admin & Settings (~8 screens)

| # | Screen | Route |
|---|---|---|
| 83 | Billing & Plan | `/settings/billing` |
| 84 | AI Credit Usage | `/settings/credits` |
| 85 | Connected Accounts | `/settings/accounts` |
| 86 | Capability Matrix | `/settings/capabilities` |
| 87 | Report Builder | `/reports` |
| 88 | Audit Log | `/settings/audit` |
| 89 | Diagnostics Console | `/settings/diagnostics` |
| 90 | API Keys (Public API) | `/settings/api` |

### 2.13 Copilot (~2 screens)

| # | Screen | Route |
|---|---|---|
| 91 | Copilot Chat Panel | Floating sidebar | 
| 92 | Command Bar | Cmd+K overlay |

### 2.14 Empty/Error States (~3 patterns)

| # | Pattern | Usage |
|---|---|---|
| 93 | Empty State | Every list/board has guided empty state |
| 94 | Broken State | Connector error with repair wizard |
| 95 | Partial Setup | Missing data with next-step guidance |

### 2.15 Creator Pro Tools / S16 (~6 screens)

| # | Screen | Route | Key Components |
|---|---|---|---|
| 96 | Link-in-Bio Editor | `/link-in-bio` | Drag-drop link builder, theme picker, preview |
| 97 | Link-in-Bio Analytics | `/link-in-bio/analytics` | Views, clicks, CTR per link |
| 98 | Media Kit Generator | `/media-kit` | Template select, section editor, PDF export |
| 99 | Rate Card Builder | `/rate-card` | Service types, AI pricing suggestions |
| 100 | Brand Deal Manager | `/brand-deals` | Deal pipeline (kanban), deliverable tracking |
| 101 | Tax Report Export | `/reports/tax` | Period selector, format picker, download |

---

## 3. Admin Site Screen Map (admin.creativanta.app — ~35 screens)

> Completely separate app: SvelteKit 2, own auth (MFA), VPN-only access.

### 3.1 Admin Navigation (Sidebar)

```
┌── CREATIVANTA OPS CENTER ──────┐
│                                 │
│  🏠 Dashboard                   │
│  ─────────────────              │
│  👤 Users                       │
│  🏢 Workspaces                  │
│  ─────────────────              │
│  💳 Billing & Revenue           │
│  📊 AI Cost Control             │
│  ─────────────────              │
│  🛡️ Moderation                  │
│  🔍 Fraud & Abuse               │
│  ─────────────────              │
│  🎫 Support Tickets             │
│  ─────────────────              │
│  🖥️ System Health               │
│  🚩 Feature Flags               │
│  🔧 Jobs & Queues               │
│  🔗 Webhooks & Connectors       │
│  ─────────────────              │
│  📋 Audit Logs                  │
│  📢 Announcements               │
│  ⚙️ System Config               │
│  📈 Reports                     │
│  ─────────────────              │
│  🚨 Incidents                   │
│  🔑 API Key Admin               │
│  ─────────────────              │
│  👥 Admin Management            │
└─────────────────────────────────┘
```

### 3.2 Admin Screens

| # | Screen | Route | Key Components |
|---|---|---|---|
| A1 | Admin Dashboard | `/admin` | Live metrics bar, widget grid (revenue, AI cost, alerts, signups, churn, health) |
| A2 | Alert Center | `/admin/alerts` | Active alerts, severity filters, acknowledge/resolve |
| A3 | User Explorer | `/admin/users` | Search/filter, user list, quick stats |
| A4 | User Detail | `/admin/users/[id]` | Tabs: Account, Workspaces, Billing, AI Usage, Support, Activity, Security, Notes |
| A5 | User Actions Panel | `/admin/users/[id]/actions` | Impersonate, adjust credits, change plan, suspend, reset password |
| A6 | Workspace Explorer | `/admin/workspaces` | Search, health scores, subscription status |
| A7 | Workspace Detail | `/admin/workspaces/[id]` | Members, usage, financials, connector health |
| A8 | Billing Dashboard | `/admin/billing` | MRR/ARR chart, revenue waterfall, ARPU, LTV |
| A9 | Payment Management | `/admin/billing/payments` | Invoices, retry, refund, credit, void |
| A10 | Dunning Console | `/admin/billing/dunning` | Stage tracker, grace period management |
| A11 | AI Cost Control | `/admin/ai-costs` | System-wide costs, per-workspace, per-operation, margin analysis |
| A12 | Provider Health | `/admin/ai-costs/providers` | Circuit breaker status, latency, error rates |
| A13 | Rate Card Management | `/admin/ai-costs/rates` | Edit credit costs per operation |
| A14 | Moderation Queue | `/admin/moderation` | Case list, filters (severity, type, status) |
| A15 | Moderation Case Detail | `/admin/moderation/[id]` | Evidence view, action buttons, resolution log |
| A16 | Fraud Dashboard | `/admin/fraud` | Fraud signals, linked accounts map, device intel |
| A17 | Fraud Case Detail | `/admin/fraud/[id]` | Evidence, implicated users, resolution actions |
| A18 | Support Queue | `/admin/support` | Ticket list, SLA timers, assignment |
| A19 | Support Ticket Detail | `/admin/support/[id]` | Conversation thread, internal notes, impersonate, diagnostics |
| A20 | Support Analytics | `/admin/support/analytics` | CSAT, resolution time, volume, top categories |
| A21 | System Health Dashboard | `/admin/health` | Service status grid (API, DB, Cache, Search, Queue, CDN, Providers) |
| A22 | Feature Flag Manager | `/admin/flags` | Toggle, rollout %, targeting, history |
| A23 | Job Queue Monitor | `/admin/queues` | Queue depth, processing rates, DLQ management |
| A24 | DLQ Inspector | `/admin/queues/dlq` | View, retry, purge dead letters |
| A25 | Scheduled Jobs | `/admin/queues/scheduled` | Cron jobs list, manual trigger, pause/resume |
| A26 | Webhook Monitor | `/admin/webhooks` | Outbound delivery, inbound health, platform matrix |
| A27 | Connector Health Matrix | `/admin/connectors` | Platform status grid (TikTok, FB, Shopee, etc.) |
| A28 | Audit Log Explorer | `/admin/audit` | Search by actor/action/target/date, export |
| A29 | GDPR Compliance | `/admin/compliance` | Data subject requests, consent dashboard, breach notification |
| A30 | System Announcements | `/admin/announcements` | Create/schedule announcements, targeting |
| A31 | System Configuration | `/admin/config` | Pricing, rate limits, storage limits, SLA config, maintenance mode |
| A32 | Report Builder | `/admin/reports` | Drag-drop custom reports, scheduled delivery |
| A33 | Incident Manager | `/admin/incidents` | Incident list, timeline, resolution |
| A34 | Post-Mortem Editor | `/admin/incidents/[id]/postmortem` | Root cause, action items, lessons |
| A35 | API Key Admin | `/admin/api-keys` | All keys, usage analytics, suspend/revoke |
| A36 | Admin Management | `/admin/team` | Internal admin CRUD, role assignment (Super Admin only) |

---

## 4. Mobile Screen Map (Flutter — ~50 key screens)

### 4.1 Priority Mobile Screens (Phase 1)

| # | Screen | Platform Priority | Key Interaction |
|---|---|---|---|
| M1 | Home Dashboard | Both | Action cards, profit mini, quick actions |
| M2 | Morning Brief | Both | Push → in-app, swipeable briefing |
| M3 | Notifications | Both | Push notification center |
| M4 | Unified Inbox | Both | Thread list, swipe gestures (triage, reply) |
| M5 | Thread Detail | Both | Messages, AI suggestions, reply |
| M6 | Quick Publish Status | Both | Active publish queue, retry |
| M7 | Script Review | Both | Read script, approve/reject |
| M8 | Asset Review | Both | Gallery, approve/reject, zoom |
| M9 | Profit Mini Dashboard | Both | Today's P&L, trend chart |
| M10 | Live War Room | Both | Cue cards, real-time metrics, highlights |

### 4.2 Full Mobile Screen Inventory

| # | Screen | Group |
|---|---|---|
| M11 | Onboarding Wizard | Setup |
| M12 | Workspace Switcher | Nav |
| M13 | Global Search | Nav |
| M14 | Trend List | Intelligence |
| M15 | Trend Detail | Intelligence |
| M16 | Opportunity Board | Intelligence |
| M17 | Idea Board | Content |
| M18 | Idea Detail | Content |
| M19 | Script List | Content |
| M20 | Script Editor (simplified) | Content |
| M21 | AI Studio Home | AI |
| M22 | Generation Queue | AI |
| M23 | Character Library | AI |
| M24 | Publish Queue | Publish |
| M25 | Publish Calendar | Publish |
| M26 | Publish Item Detail | Publish |
| M27 | Contact List | Engagement |
| M28 | Contact Detail | Engagement |
| M29 | Follow-up Tasks | Engagement |
| M30 | Product List | Commerce |
| M31 | Product Detail | Commerce |
| M32 | Order List | Commerce |
| M33 | Order Detail | Commerce |
| M34 | Offer List | Commerce |
| M35 | Affiliate Links | Commerce |
| M36 | Revenue Dashboard | Finance |
| M37 | Cost Manager | Finance |
| M38 | Settlement List | Finance |
| M39 | Anomaly Alerts | Finance |
| M40 | Proof Center | Finance |
| M41 | Workflow List | Workflow |
| M42 | Workflow Run History | Workflow |
| M43 | Recipe List | Workflow |
| M44 | Live Session Planner | Live |
| M45 | Post-Live Summary | Live |
| M46 | Copilot Chat | AI |
| M47 | Connected Accounts | Settings |
| M48 | Billing & Plan | Settings |
| M49 | User Profile | Settings |
| M50 | Capability Status | Settings |

---

## 5. Per-Screen Component Briefs (for Google Stitch)

> Each design prompt should include: screen purpose, key components, data displayed, actions available, design tokens reference, and empty/error states.

### 5.1 Example Stitch Prompt Template
```
Screen: {Screen Name}
Route: {Route}
Purpose: {1-2 sentence functional description}
Design System: Use tokens from impl_a5_design_system_tokens.md

Layout:
- {layout type: sidebar + main, full-width, modal, etc.}
- {responsive behavior}

Key Components:
1. {Component name} — {what it shows, what it does}
2. {Component name} — ...

Data Fields:
- {field1}: {type} — {example value}
- {field2}: ...

Actions:
- Primary: {main CTA}
- Secondary: {other buttons/actions}

States:
- Loaded: {normal state}
- Empty: {what to show when no data}
- Error: {what to show on error}
- Loading: {skeleton pattern}

Operator Mode Variations:
- Creator: {differences}
- Seller: {differences}
```

### 5.2 Google Stitch Design Phases

| Phase | Sites | Screens | Priority |
|---|---|---|---|
| **Phase 1** | Web | Home, Onboarding, Script Editor, AI Studio Home, Publish Queue, Inbox | Critical path |
| **Phase 2** | Web | Profit Dashboard, Products, Offers, Campaigns, Trend Radar | Core commerce |
| **Phase 3** | Web | Workflow Builder, Live War Room, Settings, Packaging QA | Operations |
| **Phase 4** | Web | All remaining web screens (~40) | Complete web |
| **Phase 5** | Admin | Admin Dashboard, User Explorer, Billing, Moderation, System Health | Admin MVP |
| **Phase 6** | Admin | All remaining admin screens (~20) | Complete admin |
| **Phase 7** | Mobile | Home, Inbox, Quick Publish, Script/Asset Review, Profit Mini | Mobile MVP |
| **Phase 8** | Mobile | All remaining mobile screens (~40) | Complete mobile |

Each design should use tokens from `impl_a5_design_system_tokens.md`.

---

## 6. Total Screen Count Summary

| Site | Screens |
|---|---|
| Web (creativanta.app) | ~101 |
| Admin (admin.creativanta.app) | ~36 |
| Mobile (iOS + Android) | ~50 |
| **Total** | **~187 screens** |

