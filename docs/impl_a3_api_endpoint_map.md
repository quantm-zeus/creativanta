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

---

**Total: ~270 RPCs + 6 webhook endpoints + 6 public API endpoints + 24 admin-only RPCs**
