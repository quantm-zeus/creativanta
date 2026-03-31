---
layer: contracts
canonical: true
source_file: impl_a3_api_endpoint_map.md
last_verified: 2026-03-30
known_issues:
  - API-C-001
  - API-H-001
  - API-H-002
  - API-M-001
do_not_edit_without: Đọc 00_index/OPEN_BLOCKERS.md trước khi sửa
---

## Quick Navigation

| Section | Content |
|---|---|
| §1 Endpoint Naming Convention | ConnectRPC, gRPC, REST patterns |
| §2.1 Identity & Workspace | ~15 RPCs: Auth, Workspace, Connector, User services |
| §2.2 Intelligence | ~12 RPCs: Trend, Competitor, Opportunity services |
| §2.3 Content | ~25 RPCs: Idea, Script, Asset, Character, Continuity, Derivative services |
| §2.4 Publish | ~15 RPCs: Packaging, Publish, Approval services |
| §2.5 Engagement | ~18 RPCs: Thread, Entity, Suggestion, FollowUp services |
| §2.6 Commerce | ~30 RPCs: Product, Offer, Order, Campaign, Affiliate, Store services |
| §2.7 Finance | ~20 RPCs: Profit, Settlement, Cost, Reconciliation, Evidence, Proof services |
| §2.8 Other Domains | Workflow, Recipe/Agent, Live, Seeding, Copilot, Admin, Gamification, Capability |
| §3 Webhook Endpoints | Clerk, Stripe, TikTok, Shopee, Lazada, Activepieces |
| §4 Public API v1 | REST endpoints for products, orders, offers, analytics, webhooks |
| §5 Creator Pro (S16) | LinkInBio, MediaKit, RateCard, BrandDeal services |
| §6 Internal Admin (S26) | VPN-only admin endpoints: AdminAuth, UserMgmt, Moderation, Fraud, Support, Incident, SystemConfig, FeeSchedule |
| §7 AI Production Extended | VideoEditJob, Remix, ClipFactory, ProductShowcase, LinkToVideo, Translation, StylePack, ABTest, Repurpose |
| §8 Gamification | GamificationService RPCs |
| §9 Platform Health | PlatformHealth, LinkHealth services |

# A3 — API Endpoint Map

> **Upstream**: A2 Protobuf, Pack 02, S24 Public API
> **Protocol**: ConnectRPC (web), gRPC (mobile), REST (webhooks/public API)

---

## 1. Endpoint Naming Convention

| Protocol | Pattern | Example |
|---|---|---|
| ConnectRPC | `POST /creativanta.{domain}.v1.{Service}/{Rpc}` | `POST /creativanta.content.v1.ScriptService/CreateScript` |
| gRPC | `creativanta.{domain}.v1.{Service}/{Rpc}` | Same Protobuf |
| REST (webhooks) | `POST /webhooks/{provider}` | `POST /webhooks/stripe` |
| REST (Public API) | `GET/POST /api/v1/{resource}` | `GET /api/v1/products` |

---

## 2. Service Endpoint Map by Domain

### 2.1 Identity & Workspace (~15 RPCs)

| RPC | Method | Auth | Rate Limit |
|---|---|---|---|
| `AuthService/ValidateSession` | POST | JWT | 100/min |
| `WorkspaceService/Create` | POST | Owner | 5/min |
| `WorkspaceService/Get` | POST | Member | 120/min |
| `WorkspaceService/Update` | POST | Admin+ | 30/min |
| `WorkspaceService/ListMembers` | POST | Member | 60/min |
| `WorkspaceService/InviteMember` | POST | Manager+ | 20/min |
| `WorkspaceService/UpdateRole` | POST | Admin+ | 20/min |
| `WorkspaceService/RemoveMember` | POST | Admin+ | 10/min |
| `ConnectorService/Connect` | POST | Manager+ | 10/min |
| `ConnectorService/Disconnect` | POST | Admin+ | 10/min |
| `ConnectorService/List` | POST | Member | 60/min |
| `ConnectorService/CheckHealth` | POST | Member | 30/min |
| `ConnectorService/SyncNow` | POST | Manager+ | 5/min |
| `UserService/GetProfile` | POST | Self | 120/min |
| `UserService/UpdatePreferences` | POST | Self | 30/min |

### 2.2 Intelligence (~12 RPCs)

| RPC | Auth | Description |
|---|---|---|
| `TrendService/List` | Member | Paginated trend list |
| `TrendService/Get` | Member | Trend detail + signals |
| `TrendService/Search` | Member | Semantic search |
| `TrendService/ManageWatchlist` | Editor+ | CRUD watchlist |
| `CompetitorService/List` | Member | Competitor registry |
| `CompetitorService/AnalyzeBenchmark` | Editor+ | AI benchmark analysis |
| `OpportunityService/List` | Member | Board view |
| `OpportunityService/Create` | Contributor+ | New opportunity |
| `OpportunityService/UpdateState` | Editor+ | State transition |
| `OpportunityService/Assign` | Manager+ | Assign owner |
| `OpportunityService/Convert` | Editor+ | → Idea/Script/Campaign |
| `OpportunityService/Get` | Member | Detail view |

### 2.3 Content (~25 RPCs)

| RPC | Auth | Description |
|---|---|---|
| `IdeaService/Create` | Contributor+ | New idea |
| `IdeaService/List` | Member | Paginated list |
| `IdeaService/Generate` | Editor+ | AI generate ideas (streaming) |
| `IdeaService/Convert` | Editor+ | → Script |
| `ScriptService/Create` | Contributor+ | New script |
| `ScriptService/Get` | Member | Detail |
| `ScriptService/Update` | Editor+ | Edit body |
| `ScriptService/SubmitApproval` | Editor+ | Submit for review |
| `ScriptService/Approve` | Manager+ | Approve script |
| `ScriptService/Reject` | Manager+ | Reject with reason |
| `AssetService/Generate` | Editor+ | Trigger AI generation |
| `AssetService/GetStatus` | Member | Job status polling |
| `AssetService/List` | Member | Asset library |
| `AssetService/Approve` | Manager+ | Approve asset |
| `AssetService/PromoteCanonical` | Manager+ | Set as canonical |
| `CharacterService/Create` | Editor+ | New character |
| `CharacterService/List` | Member | Character library |
| `CharacterService/Update` | Editor+ | Edit character |
| `ContinuityService/GetPack` | Member | Pack details |
| `ContinuityService/UpdatePack` | Manager+ | Edit pack |
| `DerivativeService/List` | Member | Clip/variant library |
| `DerivativeService/BatchTag` | Editor+ | Batch operations |
| `DerivativeService/GetLineage` | Member | Source → derivative chain |

### 2.4 Publish (~15 RPCs)

| RPC | Auth | Description |
|---|---|---|
| `PackagingService/Score` | Editor+ | Run QA checks |
| `PackagingService/ScanCompliance` | Editor+ | Compliance scan |
| `PublishService/CreateItem` | Editor+ | New publish item |
| `PublishService/Schedule` | Editor+ | Set schedule |
| `PublishService/Execute` | Manager+ | Immediate publish |
| `PublishService/Retry` | Editor+ | Retry failed |
| `PublishService/Cancel` | Manager+ | Cancel queued |
| `PublishService/ListQueue` | Member | Queue view |
| `PublishService/GetLogs` | Member | Publish history |
| `PublishService/GetDiagnostics` | Member | Diagnostics |
| `ApprovalService/List` | Member | Pending approvals |
| `ApprovalService/Approve` | by policy | Approve action |
| `ApprovalService/Reject` | by policy | Reject action |

### 2.5 Engagement (~18 RPCs)

| RPC | Auth | Description |
|---|---|---|
| `ThreadService/List` | Member | Inbox view |
| `ThreadService/Get` | Member | Thread detail |
| `ThreadService/Triage` | Editor+ | Set intent/priority |
| `ThreadService/Assign` | Manager+ | Assign owner |
| `ThreadService/Reply` | Contributor+ | Send reply |
| `ThreadService/Resolve` | Editor+ | Mark resolved |
| `ThreadService/BulkTriage` | Editor+ | Batch operations |
| `EntityService/List` | Member | Contact list |
| `EntityService/Get` | Member | Contact detail |
| `EntityService/Create` | Editor+ | Manual create |
| `EntityService/Merge` | Manager+ | Merge duplicates |
| `SuggestionService/GetReply` | Member | AI suggested reply |
| `SuggestionService/GetActions` | Member | Suggested business actions |
| `FollowUpService/Create` | Editor+ | New follow-up |
| `FollowUpService/List` | Member | Task list |
| `FollowUpService/Update` | Editor+ | Update status |

### 2.6 Commerce (~30 RPCs)

| RPC | Auth | Description |
|---|---|---|
| `ProductService/CRUD` | Editor+ | Product management (5 RPCs) |
| `OfferService/CRUD` | Editor+ | Offer management (6 RPCs) |
| `OrderService/List,Get,Import` | Editor+ | Order views (4 RPCs) |
| `CampaignService/CRUD` | Editor+ | Campaign management (5 RPCs) |
| `AffiliateService/CRUD` | Editor+ | Link management (5 RPCs) |
| `StoreService/CRUD` | Manager+ | Store pages (5 RPCs) |

### 2.7 Finance (~20 RPCs)

| RPC | Auth | Description |
|---|---|---|
| `ProfitService/GetSummary` | Manager+ | Profit overview |
| `ProfitService/DrillDown` | Manager+ | By scope drill |
| `ProfitService/GetAnomalies` | Manager+ | Anomaly list |
| `SettlementService/Import` | Admin+ | Import settlements |
| `SettlementService/List` | Manager+ | Settlement list |
| `CostService/Create,List,Update` | Manager+ | Cost management (3 RPCs) |
| `ReconciliationService/Queue,Match,Override` | Admin+ | Reconciliation (4 RPCs) |
| `EvidenceService/Submit,List` | Editor+ | Evidence management (3 RPCs) |
| `ProofService/Assemble,Get` | Manager+ | Proof bundles (3 RPCs) |

### 2.8 Other Domains

| Domain | RPCs | Key Operations |
|---|---|---|
| Workflow (M20) | ~12 | CRUD, Activate, Run, Inspect |
| Recipe/Agent (M21) | ~8 | Install, Run, Inspect |
| Live (M17) | ~10 | Session, Cue, Highlight |
| Seeding (M18) | ~8 | Sample CRUD, Shipment |
| Copilot (§34) | ~5 | Query (stream), Suggest |
| Admin/Billing (M23) | ~15 | Credits, Diagnostics, Reports |
| Gamification (§37) | ~6 | Progress, Achievements |
| Capability (M22) | ~5 | Matrix, PolicyNotes |

---

## 3. Webhook Endpoints (REST)

| Endpoint | Provider | Method |
|---|---|---|
| `POST /webhooks/clerk` | Clerk | User/Org events |
| `POST /webhooks/stripe` | Stripe | Payment events |
| `POST /webhooks/tiktok` | TikTok | Content/Shop events |
| `POST /webhooks/shopee` | Shopee | Order/Chat events |
| `POST /webhooks/lazada` | Lazada | Order events |
| `POST /webhooks/activepieces` | Activepieces | Flow completion |

Each webhook: signature verification → event parsing → domain event emission.

---

## 4. Public API v1 (REST, S24)

| Endpoint | Method | Auth | Description |
|---|---|---|---|
| `/api/v1/products` | GET, POST | API Key | Product CRUD |
| `/api/v1/orders` | GET | API Key | Order listing |
| `/api/v1/offers` | GET, POST | API Key | Offer management |
| `/api/v1/analytics/content` | GET | API Key | Content metrics |
| `/api/v1/analytics/profit` | GET | API Key | Profit summary |
| `/api/v1/webhooks` | POST | API Key | Register webhooks |

Rate limit: 100 req/min per API key. OAuth2 for third-party apps (P2).

---

## 5. S16 Creator Pro Endpoints

| RPC | Auth | Description |
|---|---|---|
| `LinkInBioService/CreatePage` | Editor+ | New link-in-bio page |
| `LinkInBioService/GetPage` | Member | Page details |
| `LinkInBioService/UpdatePage` | Editor+ | Edit page/links |
| `LinkInBioService/GetAnalytics` | Member | Click stats |
| `MediaKitService/Generate` | Editor+ | AI generate media kit |
| `MediaKitService/Get` | Member | Media kit details |
| `MediaKitService/Export` | Editor+ | Export PDF/link |
| `RateCardService/Create` | Manager+ | Create rate card |
| `RateCardService/AISuggest` | Editor+ | AI-suggested rates |
| `RateCardService/List` | Manager+ | Rate card list |
| `BrandDealService/Create` | Manager+ | New brand deal |
| `BrandDealService/UpdateStatus` | Manager+ | Status change |
| `BrandDealService/List` | Manager+ | Deal pipeline |

---

## 6. Internal Admin Endpoints (S26 — VPN-only)

> **Note**: All admin endpoints require VPN access + admin MFA + admin JWT. Completely separate from workspace auth.

| RPC | Admin Role | Description |
|---|---|---|
| `AdminAuthService/Login` | All | Admin login + MFA |
| `AdminAuthService/Impersonate` | Super/Ops | Start impersonation |
| `AdminAuthService/EndImpersonation` | Super/Ops | End impersonation |
| `UserMgmtService/ListUsers` | All | Search/filter users |
| `UserMgmtService/SuspendUser` | Super/Ops | Suspend account |
| `UserMgmtService/UnsuspendUser` | Super/Ops | Reactivate account |
| `UserMgmtService/AdjustCredits` | Super/Ops | Credit adjustment |
| `UserMgmtService/OverridePlan` | Super/Ops | Plan tier override |
| `UserMgmtService/IssueRefund` | Super/Ops | Manual refund |
| `ModerationService/ListCases` | Super/Content | Case queue |
| `ModerationService/ActOnCase` | Super/Content | Take action |
| `FraudService/ListCases` | Super/Content | Fraud queue |
| `FraudService/Investigate` | Super/Content | Investigation |
| `FraudService/Resolve` | Super/Content | Confirm/dismiss |
| `SupportAdminService/ListTickets` | Super/Ops | Support queue |
| `SupportAdminService/AssignTicket` | Super/Ops | Assign to agent |
| `SupportAdminService/EscalateTicket` | Super/Ops | Escalate |
| `IncidentService/Create` | Super/Tech | New incident |
| `IncidentService/Resolve` | Super/Tech | Resolve incident |
| `IncidentService/CreatePostMortem` | Super/Tech | Post-mortem |
| `SystemConfigService/ToggleFlag` | Super/Tech | Feature flag |
| `SystemConfigService/PublishAnnouncement` | Super/Ops | System announcement |
| `SystemConfigService/ToggleMaintenance` | Super/Tech | Maintenance mode |
| `SystemConfigService/GetDashboard` | All | Admin dashboard |
| `FeeScheduleService/List` | Super/Finance | List fee schedules |
| `FeeScheduleService/Create` | Super/Finance | Add fee schedule |
| `FeeScheduleService/Update` | Super/Finance | Update fee schedule |
| `FeeScheduleService/Verify` | Super/Finance | Mark fee as verified |

---

## 7. AI Production Extended RPCs (Audit v5 — H3: Pack 02 §3.4)

> **Ref**: Pack 02 §3.4 domain objects, Pack 04 §9.6-9.16.

### 7.1 Video Edit Job Service

| RPC | Auth | Description |
|---|---|---|
| `VideoEditJobService/Create` | Editor+ | Start new production job (any mode) |
| `VideoEditJobService/Get` | Contributor+ | Get job status + metadata |
| `VideoEditJobService/List` | Contributor+ | List jobs (filter by mode, status) |
| `VideoEditJobService/Cancel` | Editor+ | Cancel processing job |
| `VideoEditJobService/Retry` | Editor+ | Retry failed job |

### 7.2 Remix Service

| RPC | Auth | Description |
|---|---|---|
| `RemixService/Analyze` | Editor+ | Start remix analysis (Phase 1) |
| `RemixService/GetBlueprint` | Editor+ | Get remix blueprint + Creative DNA |
| `RemixService/Generate` | Editor+ | Start remix generation (Phase 2) |
| `RemixService/Regenerate` | Editor+ | Regenerate with adjustments |

### 7.3 Clip Factory Service

| RPC | Auth | Description |
|---|---|---|
| `ClipFactoryService/Analyze` | Editor+ | Analyze video for clips |
| `ClipFactoryService/GetCollection` | Editor+ | Get clip proposals |
| `ClipFactoryService/ProcessClips` | Editor+ | Process selected clips |

### 7.4 Product Showcase Service

| RPC | Auth | Description |
|---|---|---|
| `ProductShowcaseService/Create` | Editor+ | Single product showcase |
| `ProductShowcaseService/CreateBatch` | Editor+ | Batch processing |
| `ProductShowcaseService/Get` | Contributor+ | Get job status |
| `ProductShowcaseService/List` | Contributor+ | List showcase jobs |

### 7.5 Link-to-Video Service

| RPC | Auth | Description |
|---|---|---|
| `LinkToVideoService/Scrape` | Editor+ | Scrape product URL |
| `LinkToVideoService/Generate` | Editor+ | Generate video from scraped data |
| `LinkToVideoService/Get` | Contributor+ | Get job status |

### 7.6 Translation Service

| RPC | Auth | Description |
|---|---|---|
| `TranslationService/Create` | Editor+ | Start translation job |
| `TranslationService/Get` | Contributor+ | Get job + per-language status |
| `TranslationService/List` | Contributor+ | List translation jobs |

### 7.7 Style Pack Service

| RPC | Auth | Description |
|---|---|---|
| `StylePackService/Extract` | Editor+ | Analyze video + extract style |
| `StylePackService/Get` | Contributor+ | Get style pack details |
| `StylePackService/List` | Contributor+ | List style packs |
| `StylePackService/Apply` | Editor+ | Apply style to job |
| `StylePackService/Delete` | Manager+ | Delete style pack |

### 7.8 AB Test Service

| RPC | Auth | Description |
|---|---|---|
| `ABTestService/Create` | Editor+ | Start AB test experiment |
| `ABTestService/Get` | Contributor+ | Get experiment details |
| `ABTestService/List` | Contributor+ | List experiments |
| `ABTestService/DeclareWinner` | Editor+ | Manually declare winner |
| `ABTestService/Cancel` | Editor+ | Cancel running experiment |

### 7.9 Repurpose Service

| RPC | Auth | Description |
|---|---|---|
| `RepurposeService/Create` | Editor+ | Start 1→50 repurpose pipeline |
| `RepurposeService/Get` | Contributor+ | Get repurpose status |
| `RepurposeService/List` | Contributor+ | List repurpose jobs |

---

## 8. Gamification RPCs (Audit v5 — H3: PRD §37.3)

| RPC | Auth | Description |
|---|---|---|
| `GamificationService/GetProgress` | Contributor+ | Get workspace progress (level, XP, streak) |
| `GamificationService/ListAchievements` | Contributor+ | List all achievements + unlock status |
| `GamificationService/ListChallenges` | Contributor+ | List active weekly challenges |
| `GamificationService/GetChallengeProgress` | Contributor+ | Get progress for specific challenge |
| `GamificationService/ShareAchievement` | Contributor+ | Share achievement to social |

---

## 9. Platform Health RPCs (Audit v5 — H3: M22)

| RPC | Auth | Description |
|---|---|---|
| `PlatformHealthService/GetScores` | Viewer+ | Get health scores for all connected platforms |
| `PlatformHealthService/GetHistory` | Manager+ | Get health score history |
| `LinkHealthService/GetReport` | Editor+ | Get affiliate link health report |
| `LinkHealthService/CheckNow` | Editor+ | Trigger immediate health check |
| `LinkHealthService/BulkCheck` | Manager+ | Bulk check all affiliate links |

---

**Total: ~310 RPCs + 6 webhook endpoints + 6 public API endpoints + 28 admin-only RPCs (incl. fee schedule management) + ~40 extended production/gamification/health RPCs (Audit v5)**
