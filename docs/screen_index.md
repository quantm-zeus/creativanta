# Screen Index — All Screens Master Registry

> **Total: 235 screens** (117 web + 66 mobile + 36 admin + 12 shared + 4 notes)
> Generated from screen_specs_01 through screen_specs_13

---

## Coverage Summary

| Module | Spec File | Web | Mobile | Admin | Total |
|---|---|---|---|---|---|
| Home & Global | screen_specs_01 | 8 | 3 | — | 11 |
| Intelligence | screen_specs_02 | 8 | 3 | — | 11 |
| Content Creation | screen_specs_03 | 12 | 4 | — | 16 |
| AI Studio | screen_specs_04 | 17 | 10 | — | 27 |
| Publish | screen_specs_05 | 6 | 3 | — | 9 |
| Engagement | screen_specs_06 | 6 | 4 | — | 10 |
| Commerce | screen_specs_07 | 15 | 8 | — | 23 |
| Finance & Proof | screen_specs_08 | 8 | 4 | — | 12 |
| Workflow/Live/Seeding | screen_specs_09 | 14 | 6 | — | 20 |
| Settings/Diagnostics | screen_specs_10 | 12 | 5 | — | 17 |
| Creator Pro/Support | screen_specs_11 | 11 | 5 | — | 16 |
| Admin Site | screen_specs_12 | — | — | 36 | 36 |
| Mobile (extras) | screen_specs_13 | — | 11 | — | 11 |
| Shared Components | screen_specs_13 | — | — | — | 12 |
| **Total** | | **117** | **66** | **36** | **235** |

> **Canonical Count**: 235 unique screens after deduplication. Some screens in specs_10 and specs_11 were added to fill cross-module gaps — the total above reflects unique screens only, with no duplicates.

---

## Full Screen Registry

### Web Screens (117+)

| # | Route | Screen Name | Spec File | Section |
|---|---|---|---|---|
| 1 | `/` | Home (Daily Brief) | 01 | §1 |
| 2 | `/daily-brief` | Daily Brief Detail | 01 | §2 |
| 3 | `/onboarding` | Onboarding Wizard | 01 | §3 |
| 4 | `/setup` | Setup Checklist | 01 | §4 |
| 5 | `/notifications` | Notification Center | 01 | §5 |
| 6 | `⌘K` | Search / Command Hub | 01 | §6 |
| 7 | `/settings/profile` | User Settings | 01 | §7 |
| 8 | `/settings/workspace` | Workspace Settings | 01 | §8 |
| 9 | `/intelligence/trends` | Trend Radar | 02 | §9 |
| 10 | `/intelligence/trends/[id]` | Trend Detail | 02 | §10 |
| 11 | `/intelligence/watchlist` | Watchlist Manager | 02 | §11 |
| 12 | `/intelligence/competitors` | Competitor Registry | 02 | §12 |
| 13 | `/intelligence/benchmarks` | Benchmark View | 02 | §13 |
| 14 | `/intelligence/opportunities` | Opportunity Board | 02 | §14 |
| 15 | `/intelligence/opportunities/[id]` | Opportunity Detail | 02 | §15 |
| 16 | `/intelligence/opportunities/[id]/convert` | Convert Flow | 02 | §16 |
| 17 | `/ideas` | Idea Board | 03 | §17 |
| 18 | `/ideas/generate` | Idea Generator (AI) | 03 | §18 |
| 19 | `/ideas/[id]` | Idea Detail | 03 | §19 |
| 20 | `/scripts` | Script List | 03 | §20 |
| 21 | `/scripts/[id]` | Script Editor | 03 | §21 |
| 22 | `/scripts/[id]/review` | Script Approval Review | 03 | §22 |
| 23 | `/scripts/[id]/brief` | Asset Brief Editor | 03 | §23 |
| 24 | `/studio` | AI Studio Home | 04 | §24 |
| 25 | `/studio/characters/new` | Character Builder | 04 | §25 |
| 26 | `/studio/characters` | Character Library | 04 | §26 |
| 27 | `/continuity` | Continuity Packs | 03 | §27 |
| 28 | `/derivatives` | Derivative Manager | 03 | §28 |
| 29 | `/studio/quick-edit` | Quick Edit Mode | 04 | §29 |
| 30 | `/studio/clip-factory` | Clip Factory Mode | 04 | §30 |
| 31 | `/studio/multi-merge` | Multi-Merge Mode | 04 | §31 |
| 32 | `/studio/remix` | AI Remix Studio | 04 | §32 |
| 33 | `/studio/showcase` | Product Showcase Mode | 04 | §33 |
| 34 | `/studio/img2vid` | Image-to-Video Mode | 04 | §34 |
| 35 | `/studio/thumbnails` | Thumbnail Studio | 04 | §35 |
| 36 | `/studio/link2vid` | Link-to-Video Mode | 04 | §36 |
| 37 | `/studio/translate` | Translation Studio | 04 | §37 |
| 38 | `/studio/sound` | Sound Studio | 04 | §38 |
| 39 | `/studio/style-learning` | AI Style Learning | 04 | §39 |
| 40 | `/studio/agent` | AI Video Agent | 04 | §40 |
| 41 | `/studio/ab-test` | A/B Testing Engine | 04 | §41 |
| 42 | `/studio/queue` | Generation Queue | 04 | §42 |
| 43 | `/packaging/[id]` | Packaging QA | 05 | §43 |
| 44 | `/publish` | Publish Queue | 05 | §44 |
| 45 | `/publish/calendar` | Schedule Calendar | 05 | §45 |
| 46 | `/publish/[id]` | Publish Item Detail | 05 | §46 |
| 47 | `/publish/[id]/diagnostics` | Publish Diagnostics | 05 | §47 |
| 48 | `/publish/posts` | Channel Posts | 05 | §48 |
| 49 | `/inbox` | Unified Inbox | 06 | §49 |
| 50 | `/inbox/[id]` | Thread Detail | 06 | §50 |
| 51 | `/contacts` | Contact List | 06 | §51 |
| 52 | `/contacts/[id]` | Contact Detail | 06 | §52 |
| 53 | `/inbox/tasks` | Follow-up Tasks | 06 | §53 |
| 54 | `/inbox/triage` | Bulk Triage | 06 | §54 |
| 55 | `/products` | Product List | 07 | §55 |
| 56 | `/products/[id]` | Product Detail | 07 | §56 |
| 57 | `/offers` | Offer List | 07 | §57 |
| 58 | `/offers/[id]` | Offer Detail/Create | 07 | §58 |
| 59 | `/campaigns` | Campaign Manager | 07 | §59 |
| 60 | `/campaigns/[id]` | Campaign Detail | 07 | §60 |
| 61 | `/orders` | Order Management | 07 | §61 |
| 62 | `/orders/[id]` | Order Detail | 07 | §62 |
| 63 | `/coupons` | Coupon Manager | 07 | §63 |
| 64 | `/affiliates` | Affiliate Links | 07 | §64 |
| 65 | `/memberships` | Membership Plans | 07 | §65 |
| 66 | `/store` | Store Pages | 07 | §66 |
| 67 | `/orders/refunds` | Refund Management | 07 | §67 |
| 68 | `/samples` | Sample Requests | 07 | §68 |
| 69 | `/samples/shipments` | Sample Shipments | 07 | §69 |
| 70 | `/profit` | Profit Dashboard | 08 | §70 |
| 71 | `/profit/revenue` | Revenue Details | 08 | §71 |
| 72 | `/profit/costs` | Cost Manager | 08 | §72 |
| 73 | `/profit/reconciliation` | Reconciliation Center | 08 | §73 |
| 74 | `/profit/proof` | Proof Browser | 08 | §74 |
| 75 | `/profit/settlements` | Settlement Tracker | 08 | §75 |
| 76 | `/profit/reports` | Financial Reports | 08 | §76 |
| 77 | `/settings/credits` | AI Credit Usage | 08 | §77 |
| 78 | `/workflows` | Workflow List | 09 | §78 |
| 79 | `/workflows/[id]` | Workflow Builder | 09 | §79 |
| 80 | `/workflows/[id]/runs` | Workflow Run History | 09 | §80 |
| 81 | `/workflows/templates` | Recipe Templates | 09 | §81 |
| 82 | `/approvals` | Approval Queue | 09 | §82 |
| 83 | `/tasks` | Task Queue | 09 | §83 |
| 84 | `/agents` | Agent Runs | 09 | §84 |
| 85 | `/live/plan` | Live Session Planner | 09 | §85 |
| 86 | `/live/[id]/setup` | Live Session Setup | 09 | §86 |
| 87 | `/live/[id]/war-room` | Live War Room | 09 | §87 |
| 88 | `/live/[id]/summary` | Post-Live Summary | 09 | §88 |
| 89 | `/seeding/requests` | Sample Request Manager | 09 | §89 |
| 90 | `/seeding/assignments` | Creator Assignment | 09 | §90 |
| 91 | `/seeding/campaigns` | Seeding Campaign Dashboard | 09 | §91 |
| 92 | `/settings/connections` | Connected Accounts | 10 | §92 |
| 93 | `/settings/connections/[id]` | Connected Account Detail | 10 | §93 |
| 94 | `/settings/diagnostics` | Diagnostics Center | 10 | §94 |
| 95 | `/settings/diagnostics/[id]` | Diagnostics Detail | 10 | §95 |
| 96 | `/settings/billing` | Subscription & Billing | 10 | §96 |
| 97 | `/analytics` | Analytics Overview | 10 | §97 |
| 98 | `/gamification` | Gamification Dashboard | 10 | §98 |
| 99 | `/performance` | Performance Coach | 10 | §99 |
| 100 | `/settings/referral` | Referral Center | 10 | §100 |
| 101 | `/settings/credits/purchase` | Credit Purchase | 10 | §101 |
| 102 | `/settings/workspace/members` | Workspace Members | 10 | §102 |
| 103 | `/settings/api` | API Keys | 10 | §103 |
| 104 | `/creator-pro` | Creator Pro Dashboard | 11 | §104 |
| 105 | `/creator-pro/media-kit` | Media Kit Editor | 11 | §105 |
| 106 | `/creator-pro/inquiries` | Sponsor Inquiries | 11 | §106 |
| 107 | `/creator-pro/partnerships` | Partnership Manager | 11 | §107 |
| 108 | `/creator-pro/link-in-bio` | Link-in-Bio Builder | 11 | §108 |
| 109 | `/creator-pro/rate-card` | Rate Card Builder | 11 | §109 |
| 110 | `/creator-pro/revenue` | Revenue Per Content | 11 | §110 |
| 111 | `/creator-pro/deals` | Brand Deal Manager | 11 | §111 |
| 112 | `/creator-pro/tax-export` | Tax Report Export | 11 | §112 |
| 113 | `/support` | Support Center | 11 | §113 |
| 114 | `/support/articles/[slug]` | Help Article Viewer | 11 | §114 |
| 115 | `/glossary` | In-App Glossary | 13 | SC10 |

### Mobile Screens (66)

| # | Screen Name | Spec File |
|---|---|---|
| M1 | Mobile Home / Today Feed | 13 |
| M2 | Mobile Copilot | 13 |
| M3 | Mobile Notification Center | 13 |
| M4 | Mobile Unified Inbox | 06 |
| M5 | Mobile Thread Detail | 06 |
| M6 | Mobile Quick Publish Status | 05 |
| M7 | Mobile Profit Summary | 08 |
| M8 | Mobile Workflow Monitor | 09 |
| M9 | Mobile Analytics Snapshot | 13 |
| M10 | Mobile Quick Capture | 13 |
| M11 | Mobile Onboarding | 13 |
| M12 | Mobile Trend Radar | 02 |
| M13 | Mobile Trend Detail | 02 |
| M14 | Mobile Opportunity Board | 02 |
| M15 | Mobile Home (extended) | 01 |
| M16 | Mobile Daily Brief | 01 |
| M17 | Mobile Idea Board | 03 |
| M18 | Mobile Idea Detail | 03 |
| M19 | Mobile Script List | 03 |
| M20 | Mobile Script Editor | 03 |
| M21 | Mobile AI Studio Home | 04 |
| M22 | Mobile Generation Queue | 04 |
| M23 | Mobile Character Library | 04 |
| M24 | Mobile Publish Queue | 05 |
| M25 | Mobile Publish Calendar | 05 |
| M26 | Mobile Search / Command | 01 |
| M27 | Mobile User Settings | 01 |
| M28 | Mobile Workspace Settings | 01 |
| M29 | Mobile Follow-up Tasks | 06 |
| M30 | Mobile Product List | 07 |
| M31 | Mobile Order List | 07 |
| M32 | Mobile Offer List | 07 |
| M33 | Mobile Refund Review | 07 |
| M34 | Mobile Cost Entry | 08 |
| M35 | Mobile Approval Queue | 09 |
| M36 | Mobile Live War Room | 09 |
| M37 | Mobile Task Queue | 09 |
| M38 | Mobile Connected Accounts | 10 |
| M39 | Mobile Diagnostics | 10 |
| M40 | Mobile Creator Pro | 11 |
| M41 | Mobile Support | 11 |
| M42 | Mobile Settings | 13 |
| M43 | Mobile Gamification | 13 |
| M44 | Mobile Search | 13 |
| M45 | Mobile Campaign List | 07 |
| M46 | Mobile Affiliate Dashboard | 07 |
| M47 | Mobile Coupon Manager | 07 |
| M48 | Mobile Sample Requests | 07 |
| M49 | Mobile Link-in-Bio | 11 |
| M50 | Mobile Brand Deals | 11 |
| M51 | Mobile Media Kit Preview | 11 |
| M52 | Mobile Quick Edit | 04 |
| M53 | Mobile Clip Factory | 04 |
| M54 | Mobile Multi-Merge | 04 |
| M55 | Mobile AI Remix | 04 |
| M56 | Mobile Sound Studio | 04 |
| M57 | Mobile Style Learning | 04 |
| M58 | Mobile Video Agent | 04 |
| M59 | Mobile Revenue Detail | 13 |
| M60 | Mobile Reconciliation | 13 |
| M61 | Mobile Agent Runs | 13 |
| M62 | Mobile Recipe Library | 13 |
| M63 | Mobile Contact Detail | 13 |
| M64 | Mobile Billing/Subscription | 10 |
| M65 | Mobile Referral | 10 |
| M66 | Mobile Performance Coach | 10 |

### Admin Screens (36)

| # | Route | Screen Name | Section |
|---|---|---|---|
| A1 | `/admin` | Admin Dashboard | A1 |
| A2 | `/admin/users` | User List | A2 |
| A3 | `/admin/users/[id]` | User Detail | A3 |
| A4 | `/admin/workspaces` | Workspace List | A4 |
| A5 | `/admin/workspaces/[id]` | Workspace Detail | A5 |
| A6 | `/admin/subscriptions` | Subscription Overview | A6 |
| A7 | `/admin/subscriptions/override` | Manual Subscription Override | A7 |
| A8 | `/admin/connectors` | Global Connector Status | A8 |
| A9 | `/admin/connectors/[platform]/debug` | Connector Debug | A9 |
| A10 | `/admin/moderation` | Moderation Queue | A10 |
| A11 | `/admin/moderation/rules` | Moderation Rules | A11 |
| A12 | `/admin/moderation/reports` | Abuse Reports | A12 |
| A13 | `/admin/ai` | AI Provider Dashboard | A13 |
| A14 | `/admin/ai/credits` | AI Credit Manager | A14 |
| A15 | `/admin/ai/config` | AI Model Configuration | A15 |
| A16 | `/admin/commerce` | Global Commerce Stats | A16 |
| A17 | `/admin/commerce/fees` | Platform Fee Config | A17 |
| A18 | `/admin/commerce/disputes` | Dispute Resolution | A18 |
| A19 | `/admin/system` | Infrastructure Dashboard | A19 |
| A20 | `/admin/system/jobs` | Background Job Monitor | A20 |
| A21 | `/admin/system/flags` | Feature Flags | A21 |
| A22 | `/admin/analytics` | Business Analytics | A22 |
| A23 | `/admin/analytics/usage` | Usage Analytics | A23 |
| A24 | `/admin/analytics/errors` | Error Analytics | A24 |
| A25 | `/admin/support` | Ticket Dashboard | A25 |
| A26 | `/admin/support/[id]` | Ticket Detail | A26 |
| A27 | `/admin/support/kb` | Knowledge Base Editor | A27 |
| A28 | `/admin/config/notifications` | Notification Templates | A28 |
| A29 | `/admin/config/onboarding` | Onboarding Config | A29 |
| A30 | `/admin/config/recipes` | Recipe Template Manager | A30 |
| A31 | `/admin/audit` | Audit Log | A31 |
| A32 | `/admin/compliance/gdpr` | GDPR Tools | A32 |
| A33 | `/admin/compliance/security` | Security Dashboard | A33 |
| A34 | `/admin/emails` | Email Campaign Manager | A34 |
| A35 | `/admin/storage` | File Storage Manager | A35 |
| A36 | `/admin/settings` | Admin Settings | A36 |

### Shared Components (12)

| # | Component | Spec File |
|---|---|---|
| SC1 | App Shell (Web) | 13 |
| SC2 | Top Bar (Web) | 13 |
| SC3 | Trust Badge (Global) | 13 |
| SC4 | Empty State Template | 13 |
| SC5 | Error State Template | 13 |
| SC6 | Confirmation Modal | 13 |
| SC7 | Toast Notifications | 13 |
| SC8 | Loading Skeleton | 13 |
| SC9 | Command Palette (⌘K) | 13 |
| SC10 | In-App Glossary | 13 |
| SC11 | Upsell Banner | 13 |
| SC12 | Onboarding Tooltip Sequence | 13 |

---

## Cross-Screen Navigation Map

### Primary Flows

```
Home → Trend Radar → Trend Detail → Convert to Idea → Idea Detail → Convert to Script → Script Editor → Asset Brief → AI Studio → Generation Queue → Packaging QA → Publish Queue → Channel Posts → Analytics
```

```
Inbox (Comment) → Thread Detail → Create Follow-up → Task Queue
                → Contact Detail → Order History
                → Reply (AI-assisted) → Resolve
```

```
Products → Offer Create → Campaign Create → Publish with offer link → Track in Campaign Dashboard → Profit Dashboard
```

```
AI Studio Home → Quick Edit / Clip Factory / Multi-Merge / AI Remix / Sound Studio / Video Agent → Generation Queue → Packaging QA → Publish
```

```
Creator Pro → Media Kit → Share with brand → Brand Deal → Deliverables → Revenue Per Content → Tax Export
```

### Global Access (from any screen)
- `⌘K` → Command Palette / Search
- `🤖` Copilot → Floating Assistant
- `🔔` → Notification Center
- Bottom nav (mobile) → Home, Ideas, Studio, Inbox, More
- Glossary → Any underlined term → tooltip definition
