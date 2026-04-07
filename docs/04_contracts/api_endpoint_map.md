---
layer: contracts
canonical: true
source_file: api_endpoint_map.md  # was impl_a3_api_endpoint_map.md (legacy name)
last_verified: 2026-04-02
resolved_issues:
  - API-C-001  # PerformanceCoachService defined (§2.8.8)
  - API-H-001  # VoiceCloneService defined (§2.8.9)
  - API-H-002  # SoundStudioService defined (§2.8.10)
  - API-M-001  # Commerce/Finance/Other Domains fully expanded
  - API-M-002  # JSON examples added to api_examples.md (24 examples, 2026-04-02)
  - API-M-002b # ReferralService + PromotionalService defined (§2.8.11-12)
do_not_edit_without: Đọc 00_index/OPEN_BLOCKERS.md trước khi sửa
---

## Quick Navigation

| Section | Content |
|---|---|
| §1 Endpoint Naming Convention | ConnectRPC, gRPC, REST patterns |
| §2.1 Identity & Workspace | ~16 RPCs: Auth, Workspace, Connector, User services |
| §2.2 Intelligence | ~12 RPCs: Trend, Competitor, Opportunity services |
| §2.3 Content | ~25 RPCs: Idea, Script, Asset, Character, Continuity, Derivative services |
| §2.4 Publish | ~15 RPCs: Packaging, Publish, Approval services |
| §2.5 Engagement | ~18 RPCs: Thread, Entity, Suggestion, FollowUp services |
| §2.6 Commerce | 43 RPCs: Product (8), Offer (9), Order (5), Campaign (7), Affiliate (6), Store (5), Coupon (7) |
| §2.7 Finance | 26 RPCs: Profit (5), Settlement (3), Cost (4), Reconciliation (5), Evidence (3), Proof (3), Refund (3) |
| §2.8 Other Domains | 87 RPCs: Workflow (13), Recipe (8), LiveCommerce (11), Seeding (9), Copilot (5), AdminBilling (14), Capability (5), PerformanceCoach (5), VoiceClone (6), SoundStudio (6), Referral (5), Promotional (3), Notification (5) |
| §3 Webhook Endpoints | Clerk, Stripe, TikTok, Shopee, Lazada, Activepieces |
| **Appendix A** | **[api_examples.md](./api_examples.md)** — 24 JSON request/response examples covering all domains |
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

### 2.1 Identity & Workspace (~16 RPCs)

| RPC | Method | Auth | Rate Limit |
|---|---|---|---|
| `AuthService/Login` | POST | Public | 20/min/IP |
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
| `DerivativeService/Create` | Editor+ | Create derivative from source asset |
| `DerivativeService/BatchTag` | Editor+ | Batch operations |
| `DerivativeService/GetLineage` | Member | Source → derivative chain |
| `DerivativeService/Delete` | Manager+ | Delete derivative (soft) |
| `DerivativeService/Promote` | Editor+ | Promote derivative to primary asset |
| `DerivativeService/GetStats` | Member | Derivative performance vs source |

### 2.4 Publish (~15 RPCs)

| RPC | Auth | Description |
|---|---|---|
| `PackagingService/Score` | Editor+ | Run QA checks |
| `PackagingService/ScanCompliance` | Editor+ | Compliance scan |
| `PackagingService/GetReport` | Member | View QA report for content item |
| `PackagingService/BatchScore` | Editor+ | Batch QA for multiple items |
| `PackagingService/OverrideResult` | Manager+ | Override QA result with reason |
| `PackagingService/GetHistory` | Member | QA score history for asset |
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

### 2.6 Commerce (42 RPCs)

#### 2.6.1 ProductService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `ProductService/Create` | POST | Editor+ | 30/min | Create new product |
| `ProductService/Get` | POST | Member | 120/min | Get product detail |
| `ProductService/List` | POST | Member | 60/min | Paginated product list with filters |
| `ProductService/Update` | POST | Editor+ | 30/min | Update product fields |
| `ProductService/Delete` | POST | Admin+ | 10/min | Soft delete product |
| `ProductService/Archive` | POST | Editor+ | 30/min | Archive product (set catalog_status=archived) |
| `ProductService/BatchTag` | POST | Editor+ | 10/min | Batch add/remove tags on products |
| `ProductService/Import` | POST | Admin+ | 5/min | Import products from CSV/platform |

#### 2.6.2 OfferService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `OfferService/Create` | POST | Editor+ | 30/min | Create new offer |
| `OfferService/Get` | POST | Member | 120/min | Get offer detail |
| `OfferService/List` | POST | Member | 60/min | Paginated offer list with filters |
| `OfferService/Update` | POST | Editor+ | 30/min | Update offer fields |
| `OfferService/Activate` | POST | Manager+ | 20/min | Transition lifecycle_state to active |
| `OfferService/Pause` | POST | Manager+ | 20/min | Transition lifecycle_state to paused |
| `OfferService/Resume` | POST | Manager+ | 20/min | Transition lifecycle_state from paused to active |
| `OfferService/Expire` | POST | Manager+ | 10/min | Transition lifecycle_state to expired |
| `OfferService/Retire` | POST | Admin+ | 10/min | Transition lifecycle_state to retired (terminal) |

#### 2.6.3 OrderService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `OrderService/List` | POST | Editor+ | 60/min | Paginated order list with filters |
| `OrderService/Get` | POST | Editor+ | 120/min | Get order detail + fee_breakdown |
| `OrderService/Import` | POST | Admin+ | 5/min | Import orders from platform CSV/API |
| `OrderService/Export` | POST | Manager+ | 5/min | Export orders to CSV/XLSX |
| `OrderService/UpdateStatus` | POST | Admin+ | 20/min | Update lifecycle_state with audit log |

#### 2.6.4 CampaignService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `CampaignService/Create` | POST | Editor+ | 20/min | Create new campaign |
| `CampaignService/Get` | POST | Member | 120/min | Get campaign detail |
| `CampaignService/List` | POST | Member | 60/min | Paginated campaign list |
| `CampaignService/Update` | POST | Editor+ | 30/min | Update campaign fields |
| `CampaignService/Activate` | POST | Manager+ | 10/min | Transition status to live |
| `CampaignService/Pause` | POST | Manager+ | 10/min | Transition status to paused |
| `CampaignService/End` | POST | Manager+ | 10/min | Transition status to completed |

#### 2.6.5 AffiliateService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `AffiliateService/CreateLink` | POST | Editor+ | 30/min | Create tracked affiliate link |
| `AffiliateService/Get` | POST | Member | 120/min | Get affiliate link detail |
| `AffiliateService/List` | POST | Member | 60/min | Paginated affiliate link list |
| `AffiliateService/UpdateLink` | POST | Editor+ | 30/min | Update affiliate link |
| `AffiliateService/GetAnalytics` | POST | Editor+ | 30/min | Get click/conversion analytics |
| `AffiliateService/BulkCheck` | POST | Manager+ | 5/min | Bulk health check all affiliate links |

#### 2.6.6 StoreService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `StoreService/CreatePage` | POST | Manager+ | 10/min | Create store page |
| `StoreService/Get` | POST | Member | 120/min | Get store page detail |
| `StoreService/List` | POST | Member | 60/min | List store pages |
| `StoreService/UpdatePage` | POST | Manager+ | 30/min | Update store page layout/content |
| `StoreService/PublishPage` | POST | Manager+ | 10/min | Publish store page (set status=published) |

#### 2.6.7 CouponService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `CouponService/Create` | POST | Manager+ | 20/min | Create coupon code |
| `CouponService/Get` | POST | Editor+ | 60/min | Get coupon detail |
| `CouponService/List` | POST | Editor+ | 60/min | List coupons |
| `CouponService/ValidateCoupon` | POST | Member | 60/min | Validate coupon against order context |
| `CouponService/Update` | POST | Manager+ | 20/min | Update coupon |
| `CouponService/Activate` | POST | Manager+ | 20/min | Activate coupon |
| `CouponService/Revoke` | POST | Admin+ | 10/min | Revoke coupon |

### 2.7 Finance (26 RPCs)

#### 2.7.1 ProfitService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `ProfitService/GetSummary` | POST | Manager+ | 30/min | Profit overview for workspace or scope |
| `ProfitService/DrillDown` | POST | Manager+ | 30/min | Drill down by scope (product, platform, campaign, content, period) |
| `ProfitService/GetAnomalies` | POST | Manager+ | 20/min | List detected profit anomalies |
| `ProfitService/GetSnapshot` | POST | Manager+ | 30/min | Get specific profit_snapshot record |
| `ProfitService/RefreshSnapshot` | POST | Admin+ | 5/min | Force refresh profit snapshot computation |

#### 2.7.2 SettlementService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `SettlementService/Import` | POST | Admin+ | 5/min | Import settlements from platform |
| `SettlementService/List` | POST | Manager+ | 60/min | Paginated settlement list |
| `SettlementService/Get` | POST | Manager+ | 60/min | Get settlement detail |

#### 2.7.3 CostService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `CostService/Create` | POST | Manager+ | 20/min | Create cost item |
| `CostService/List` | POST | Manager+ | 60/min | List cost items with filters |
| `CostService/Update` | POST | Manager+ | 20/min | Update cost item |
| `CostService/Delete` | POST | Admin+ | 10/min | Delete cost item |

#### 2.7.4 ReconciliationService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `ReconciliationService/Queue` | POST | Admin+ | 10/min | Queue reconciliation batch |
| `ReconciliationService/Match` | POST | Admin+ | 10/min | Auto-match orders to settlements |
| `ReconciliationService/Override` | POST | Admin+ | 10/min | Manual override with reason + audit |
| `ReconciliationService/GetRecord` | POST | Manager+ | 30/min | Get reconciliation record detail |
| `ReconciliationService/ListRecords` | POST | Manager+ | 30/min | List reconciliation records |

#### 2.7.5 EvidenceService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `EvidenceService/Submit` | POST | Editor+ | 20/min | Submit evidence object (screenshot, receipt, etc.) |
| `EvidenceService/List` | POST | Editor+ | 60/min | List evidence objects |
| `EvidenceService/Get` | POST | Editor+ | 60/min | Get evidence detail |

#### 2.7.6 ProofService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `ProofService/Assemble` | POST | Manager+ | 10/min | Auto-assemble proof bundle from evidence |
| `ProofService/Get` | POST | Manager+ | 30/min | Get proof bundle detail |
| `ProofService/List` | POST | Manager+ | 30/min | List proof bundles |

#### 2.7.7 RefundService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `RefundService/Create` | POST | Manager+ | 10/min | Initiate refund for order |
| `RefundService/Get` | POST | Editor+ | 60/min | Get refund detail |
| `RefundService/List` | POST | Editor+ | 60/min | List refunds |

### 2.8 Other Domains (87 RPCs)

#### 2.8.1 WorkflowService (M20)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `WorkflowService/Create` | POST | Editor+ | 20/min | Create new workflow |
| `WorkflowService/Get` | POST | Member | 60/min | Get workflow detail |
| `WorkflowService/List` | POST | Member | 60/min | List workflows |
| `WorkflowService/Update` | POST | Editor+ | 20/min | Update workflow config |
| `WorkflowService/Activate` | POST | Manager+ | 10/min | Activate workflow (status=active) |
| `WorkflowService/Deactivate` | POST | Manager+ | 10/min | Deactivate workflow (status=paused) |
| `WorkflowService/Run` | POST | Editor+ | 10/min | Manually trigger workflow run |
| `WorkflowService/InspectRun` | POST | Member | 60/min | Get workflow_run detail + execution_log |
| `WorkflowService/GetRunLogs` | POST | Member | 60/min | Get paginated run logs |
| `WorkflowService/ListRuns` | POST | Member | 60/min | List workflow runs with filters |
| `WorkflowService/Clone` | POST | Editor+ | 10/min | Clone workflow |
| `WorkflowService/Export` | POST | Manager+ | 5/min | Export workflow definition |
| `WorkflowService/Import` | POST | Manager+ | 5/min | Import workflow definition |

#### 2.8.2 RecipeService (M21)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `RecipeService/Install` | POST | Editor+ | 10/min | Install recipe from marketplace |
| `RecipeService/Uninstall` | POST | Manager+ | 10/min | Uninstall recipe |
| `RecipeService/List` | POST | Member | 60/min | List available/installed recipes |
| `RecipeService/Get` | POST | Member | 60/min | Get recipe detail + parameters |
| `RecipeService/Run` | POST | Editor+ | 10/min | Execute recipe with params |
| `RecipeService/GetRunStatus` | POST | Member | 60/min | Get agent_run status |
| `RecipeService/ListRuns` | POST | Member | 60/min | List recipe execution history |
| `RecipeService/Configure` | POST | Manager+ | 20/min | Configure recipe parameters |

#### 2.8.3 LiveCommerceService (M17)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `LiveCommerceService/CreateSession` | POST | Editor+ | 10/min | Create live session |
| `LiveCommerceService/Get` | POST | Member | 60/min | Get session detail + run_of_show |
| `LiveCommerceService/List` | POST | Member | 60/min | List live sessions |
| `LiveCommerceService/StartSession` | POST | Editor+ | 5/min | Start live session (status=live) |
| `LiveCommerceService/EndSession` | POST | Editor+ | 5/min | End live session (status=ended) |
| `LiveCommerceService/AddCue` | POST | Editor+ | 60/min | Add cue card to session |
| `LiveCommerceService/RemoveCue` | POST | Editor+ | 30/min | Remove cue card |
| `LiveCommerceService/HighlightProduct` | POST | Editor+ | 30/min | Pin product highlight |
| `LiveCommerceService/GetAnalytics` | POST | Member | 30/min | Get session metrics_snapshot |
| `LiveCommerceService/UpdateRunOfShow` | POST | Editor+ | 30/min | Update run of show items |
| `LiveCommerceService/CreateHighlight` | POST | Editor+ | 30/min | Mark/create highlight clip |

#### 2.8.4 SeedingService (M18)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `SeedingService/CreateSample` | POST | Editor+ | 20/min | Create sample request |
| `SeedingService/Get` | POST | Member | 60/min | Get sample request detail |
| `SeedingService/List` | POST | Member | 60/min | List sample requests |
| `SeedingService/Approve` | POST | Manager+ | 20/min | Approve sample request |
| `SeedingService/Ship` | POST | Editor+ | 20/min | Mark as shipped + tracking |
| `SeedingService/TrackDelivery` | POST | Member | 30/min | Get shipment tracking status |
| `SeedingService/GetReport` | POST | Manager+ | 10/min | Get seeding campaign report |
| `SeedingService/CreateCampaign` | POST | Manager+ | 10/min | Create seeding campaign |
| `SeedingService/ListCampaigns` | POST | Member | 30/min | List seeding campaigns |

#### 2.8.5 CopilotService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `CopilotService/Query` | POST | Contributor+ | 20/min | Streaming AI query (SSE) |
| `CopilotService/GetSuggestions` | POST | Contributor+ | 30/min | Context-aware action suggestions |
| `CopilotService/GetContextualActions` | POST | Contributor+ | 30/min | Contextual actions for current screen |
| `CopilotService/SetContext` | POST | Contributor+ | 30/min | Set copilot context scope |
| `CopilotService/GetHistory` | POST | Contributor+ | 30/min | Get copilot session history |

#### 2.8.6 AdminBillingService (M23)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `AdminBillingService/GetBillingSummary` | POST | Manager+ | 30/min | Get workspace billing summary |
| `AdminBillingService/ListSubscriptions` | POST | Manager+ | 30/min | List subscription history |
| `AdminBillingService/GetCreditBalance` | POST | Member | 60/min | Get current credit balance + usage |
| `AdminBillingService/GetCreditLedger` | POST | Manager+ | 30/min | Get credit transaction history |
| `AdminBillingService/PurchaseCredits` | POST | Admin+ | 5/min | Purchase additional credit pack |
| `AdminBillingService/ChangePlan` | POST | Admin+ | 5/min | Upgrade/downgrade subscription tier |
| `AdminBillingService/CancelSubscription` | POST | Admin+ | 5/min | Cancel subscription |
| `AdminBillingService/GetUsageReport` | POST | Manager+ | 10/min | Get AI credit usage breakdown |
| `AdminBillingService/GetInvoiceHistory` | POST | Manager+ | 30/min | List invoices (via Stripe) |
| `AdminBillingService/DownloadInvoice` | POST | Manager+ | 10/min | Download specific invoice PDF |
| `AdminBillingService/UpdatePaymentMethod` | POST | Admin+ | 5/min | Update payment method (Stripe redirect) |
| `AdminBillingService/GetPaymentMethod` | POST | Admin+ | 30/min | Get current payment method info |
| `AdminBillingService/ListBillingEvents` | POST | Manager+ | 30/min | List billing events |
| `AdminBillingService/EstimateCost` | POST | Member | 30/min | Estimate credit cost for operation |

#### 2.8.7 CapabilityService (M22)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `CapabilityService/GetMatrix` | POST | Member | 30/min | Get platform capability matrix |
| `CapabilityService/GetHealthScores` | POST | Member | 30/min | Get platform health scores |
| `CapabilityService/GetHistory` | POST | Manager+ | 30/min | Get health score history |
| `CapabilityService/ListPolicyNotes` | POST | Member | 30/min | List policy notes for platform/scope |
| `CapabilityService/ListFallbackPaths` | POST | Member | 30/min | List fallback paths for degraded capabilities |

#### 2.8.8 PerformanceCoachService (M07 EF-09)

> Resolves API-C-001. Required for M07 performance coaching features.

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `PerformanceCoachService/GetInsights` | POST | Member | 30/min | Get AI-powered performance insights for workspace |
| `PerformanceCoachService/GetVideoScorecard` | POST | Member | 30/min | Get performance scorecard for specific video asset |
| `PerformanceCoachService/GetImprovementPlan` | POST | Editor+ | 10/min | Generate AI improvement plan based on recent content |
| `PerformanceCoachService/ListBenchmarks` | POST | Member | 30/min | List industry/niche benchmarks |
| `PerformanceCoachService/CompareToIndustry` | POST | Member | 20/min | Compare workspace metrics to industry averages |

#### 2.8.9 VoiceCloneService (M08)

> Resolves API-H-001. Required for M08 voice clone features. Provider: ElevenLabs.

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `VoiceCloneService/Create` | POST | Manager+ | 5/min | Create voice clone from audio samples |
| `VoiceCloneService/Get` | POST | Member | 60/min | Get voice clone detail + status |
| `VoiceCloneService/List` | POST | Member | 60/min | List voice clones for workspace |
| `VoiceCloneService/Delete` | POST | Admin+ | 5/min | Delete voice clone (revoke consent) |
| `VoiceCloneService/GenerateVoiceover` | POST | Editor+ | 10/min | Generate voiceover with cloned voice |
| `VoiceCloneService/GetConsentStatus` | POST | Member | 30/min | Check voice clone consent record status |

#### 2.8.10 SoundStudioService (M07 EF-06)

> Resolves API-H-002. Required for M07 sound design features. Providers: Stable Audio, MusicGen, Librosa.

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `SoundStudioService/GenerateMusic` | POST | Editor+ | 10/min | Generate background music track |
| `SoundStudioService/GenerateSFX` | POST | Editor+ | 10/min | Generate sound effects |
| `SoundStudioService/AnalyzeBeat` | POST | Editor+ | 20/min | Analyze beat/tempo of audio track |
| `SoundStudioService/ListSoundLibrary` | POST | Member | 60/min | List available sounds in library |
| `SoundStudioService/GetSound` | POST | Member | 60/min | Get sound asset detail |
| `SoundStudioService/PreviewSound` | POST | Member | 30/min | Preview sound before applying |

#### 2.8.11 ReferralService

> Resolves API-M-002b. Cross-ref: referral_growth.md feature doc.

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `ReferralService/GetMyReferralCode` | POST | Contributor+ | 30/min | Get user's referral code |
| `ReferralService/GetReferralStats` | POST | Contributor+ | 30/min | Get referral statistics |
| `ReferralService/ListReferrals` | POST | Contributor+ | 30/min | List referred users + status |
| `ReferralService/ClaimReward` | POST | Contributor+ | 5/min | Claim referral credits reward |
| `ReferralService/ValidateCode` | POST | Public | 30/min | Validate referral code during signup |

#### 2.8.12 PromotionalService

> Resolves API-M-002b. Cross-ref: referral_growth.md feature doc.

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `PromotionalService/RedeemPromoCode` | POST | Contributor+ | 10/min | Redeem promotional credit code |
| `PromotionalService/GetActivePromotions` | POST | Member | 30/min | List active promotions for workspace tier |
| `PromotionalService/GetPromotionDetail` | POST | Member | 30/min | Get promotion detail + eligibility |

#### 2.8.13 NotificationService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `NotificationService/List` | POST | Self | 60/min | List user notifications |
| `NotificationService/MarkRead` | POST | Self | 60/min | Mark notification as read |
| `NotificationService/MarkAllRead` | POST | Self | 10/min | Mark all notifications as read |
| `NotificationService/UpdatePreferences` | POST | Self | 10/min | Update notification preferences |
| `NotificationService/Dismiss` | POST | Self | 60/min | Dismiss notification |

---

## 3. Webhook Endpoints (REST)

| Endpoint | Provider | Method | Signature Header | Verification | Events Handled |
|---|---|---|---|---|---|
| `POST /webhooks/clerk` | Clerk | svix | `svix-signature` | HMAC-SHA256 via Svix SDK | `user.created`, `user.updated`, `user.deleted`, `organization.created` |
| `POST /webhooks/stripe` | Stripe | stripe-signature | `stripe-signature` | `stripe.webhooks.constructEvent()` | `invoice.paid`, `invoice.payment_failed`, `customer.subscription.updated`, `customer.subscription.deleted`, `charge.refunded` |
| `POST /webhooks/tiktok` | TikTok | tiktok | `X-TikTok-Signature` | HMAC-SHA256 with app secret | `video.published`, `video.deleted`, `shop.order.created`, `shop.order.status_changed`, `comment.created` |
| `POST /webhooks/shopee` | Shopee | shopee | `Authorization` | HMAC-SHA256 with partner key | `order.status_update`, `item.stock_changed`, `chat.new_message`, `return.request_created` |
| `POST /webhooks/lazada` | Lazada | lazada | `X-Lazada-Signature` | HMAC-SHA256 with app secret | `order.status_change`, `order.item_shipped`, `return.requested` |
| `POST /webhooks/activepieces` | Activepieces | activepieces | `X-AP-Signature` | Shared secret verification | `flow.completed`, `flow.failed`, `flow.timeout` |

Each webhook: signature verification → event parsing → idempotency check (`webhook_events.idempotency_key`) → domain event emission → 200 OK within 5s (async processing).

**Webhook Processing Rules:**
- All webhooks return 200 within 5s regardless of processing status (async via queue)
- Idempotency: duplicate events (same provider event ID) silently ignored
- Failed processing: retried 3× via `webhook_retry_queue` with exponential backoff
- Audit: all webhook payloads logged to `webhook_events` table for 90 days

---

## 4. Public API v1 (REST, S24)

| Endpoint | Method | Auth | Rate Limit | Request/Response |
|---|---|---|---|---|
| `/api/v1/products` | GET | API Key | 100/min | List products. Query: `?status=active&page_size=25&page_token=`. Response: paginated array |
| `/api/v1/products` | POST | API Key | 30/min | Create product. Body: same as ProductService/Create. Response: 201 + product object |
| `/api/v1/products/{id}` | GET | API Key | 100/min | Get single product by ID. Response: product object |
| `/api/v1/products/{id}` | PATCH | API Key | 30/min | Update product fields. Body: partial product fields. Response: 200 + updated product |
| `/api/v1/orders` | GET | API Key | 100/min | List orders. Query: `?status=confirmed&from=2026-03-01&to=2026-03-31`. Response: paginated array |
| `/api/v1/orders/{id}` | GET | API Key | 100/min | Get single order. Response: order object with items |
| `/api/v1/offers` | GET | API Key | 100/min | List offers. Query: `?lifecycle_state=active`. Response: paginated array |
| `/api/v1/offers` | POST | API Key | 30/min | Create offer. Body: same as OfferService/Create. Response: 201 |
| `/api/v1/offers/{id}` | PATCH | API Key | 30/min | Update offer. Body: partial fields. Response: 200 |
| `/api/v1/analytics/content` | GET | API Key | 30/min | Content metrics. Query: `?period=30d&platform=tiktok`. Response: views, engagement, top posts |
| `/api/v1/analytics/profit` | GET | API Key | 30/min | Profit summary. Query: `?period=30d`. Response: same as ProfitService/GetSnapshot |
| `/api/v1/webhooks` | POST | API Key | 10/min | Register outbound webhook. Body: `{url, events[], secret}`. Response: 201 + webhook_id |
| `/api/v1/webhooks` | GET | API Key | 30/min | List registered webhooks. Response: array of webhook configs |
| `/api/v1/webhooks/{id}` | DELETE | API Key | 10/min | Delete webhook registration. Response: 204 |

Rate limit: 100 req/min (read), 30 req/min (write) per API key. IP-based secondary limit: 1000/min. Tier differences are enforced by access mode + monthly quota (`Starter` read-only 10k/mo, `Pro` 100k/mo, `Business` 1M/mo, `Enterprise` custom), not by different per-minute limits. OAuth2 for third-party apps (Phase 2).

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

## 10. Extended Identity & Platform RPCs

> Canonical promotion of screen-referenced RPCs (2026-04-06). These RPCs are required by screen specifications and are now fully canonical.

### 10.1 WorkspaceService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `WorkspaceService/AcceptInvite` | POST | Contributor+ | 10/min | Accept workspace invitation |
| `WorkspaceService/DeclineInvite` | POST | Contributor+ | 10/min | Decline workspace invitation |
| `WorkspaceService/CancelInvite` | POST | Manager+ | 20/min | Cancel pending invitation |
| `WorkspaceService/ResendInvite` | POST | Manager+ | 10/min | Resend invitation email |
| `WorkspaceService/ListInvites` | POST | Manager+ | 60/min | List pending invitations |
| `WorkspaceService/GetInviteLink` | POST | Manager+ | 30/min | Get shareable invite link |
| `WorkspaceService/ListMy` | POST | Self | 60/min | List workspaces user belongs to |
| `WorkspaceService/Switch` | POST | Member | 30/min | Switch active workspace context |
| `WorkspaceService/SetActive` | POST | Member | 30/min | Set active workspace |
| `WorkspaceService/SetCurrent` | POST | Member | 30/min | Set current workspace in session |
| `WorkspaceService/Delete` | POST | Owner | 1/min | Soft-delete workspace |
| `WorkspaceService/InitiateDeletion` | POST | Owner | 1/min | Initiate workspace deletion with grace period |
| `WorkspaceService/TransferOwnership` | POST | Owner | 1/min | Transfer workspace ownership |
| `WorkspaceService/GetMemberCount` | POST | Member | 60/min | Get workspace member count |
| `WorkspaceService/GetPreferences` | POST | Member | 60/min | Get workspace preferences |
| `WorkspaceService/UpdatePreferences` | POST | Admin+ | 30/min | Update workspace preferences |
| `WorkspaceService/GetUsage` | POST | Manager+ | 30/min | Get workspace resource usage |
| `WorkspaceService/UpdateMemberRole` | POST | Admin+ | 20/min | Update member role |
| `WorkspaceService/CompleteOnboarding` | POST | Admin+ | 5/min | Mark onboarding as complete |
| `WorkspaceService/SetDefaultCharacter` | POST | Editor+ | 10/min | Set default brand character |
| `WorkspaceService/SetModes` | POST | Admin+ | 10/min | Set workspace operation modes |
| `WorkspaceService/UpdateProfile` | POST | Admin+ | 30/min | Update workspace profile info |
| `WorkspaceService/UploadLogo` | POST | Admin+ | 10/min | Upload workspace logo |

### 10.2 ConnectorService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `ConnectorService/Get` | POST | Member | 60/min | Get connector detail |
| `ConnectorService/Check` | POST | Editor+ | 10/min | Check connector status |
| `ConnectorService/CheckRequirements` | POST | Editor+ | 10/min | Check platform connection requirements |
| `ConnectorService/CountActive` | POST | Member | 60/min | Count active connectors |
| `ConnectorService/ListActive` | POST | Member | 60/min | List active connectors only |
| `ConnectorService/ListConnected` | POST | Member | 60/min | List connected platforms |
| `ConnectorService/GetAllStatus` | POST | Member | 30/min | Get status of all connectors |
| `ConnectorService/GetSyncStatus` | POST | Member | 60/min | Get sync status for connector |
| `ConnectorService/GetTokenStatus` | POST | Member | 30/min | Check OAuth token health |
| `ConnectorService/GetDebugLog` | POST | Admin+ | 30/min | Get connector debug timeline + last errors |
| `ConnectorService/ListWebhookDeliveries` | POST | Admin+ | 30/min | List webhook deliveries for connector/account |
| `ConnectorService/ReplayWebhookDelivery` | POST | Admin+ | 5/min | Replay last inbound webhook delivery |
| `ConnectorService/TestConnection` | POST | Manager+ | 10/min | Execute non-mutating connector connectivity check |
| `ConnectorService/RefreshToken` | POST | Manager+ | 5/min | Force OAuth token refresh |
| `ConnectorService/ForceSync` | POST | Manager+ | 5/min | Force immediate sync |
| `ConnectorService/TriggerSync` | POST | Manager+ | 5/min | Trigger platform data sync |
| `ConnectorService/SyncProducts` | POST | Manager+ | 5/min | Sync products from platform |
| `ConnectorService/SyncProduct` | POST | Manager+ | 10/min | Sync single product |
| `ConnectorService/SyncOrders` | POST | Manager+ | 5/min | Sync orders from platform |
| `ConnectorService/SyncOrder` | POST | Manager+ | 10/min | Sync single order |
| `ConnectorService/Reply` | POST | Editor+ | 30/min | Reply to platform comment/message |
| `ConnectorService/ReplyComment` | POST | Editor+ | 30/min | Reply to specific comment |
| `ConnectorService/UpdateSyncConfig` | POST | Admin+ | 10/min | Update sync configuration |
| `ConnectorService/UpdateRetentionPolicy` | POST | Admin+ | 5/min | Update data retention policy |

### 10.3 UserService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `UserService/InitiateAccountDeletion` | POST | Self | 1/min | Initiate account deletion with grace period |

### 10.4 AuthService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `AuthService/Register` | POST | Public | 5/min | Register new user account |
| `AuthService/RequestPasswordReset` | POST | Public | 5/min | Request password reset email |

### 10.5 AccountService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `AccountService/GetStatus` | POST | Member | 60/min | Get connected platform account status |

### 10.6 ConsentService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `ConsentService/Grant` | POST | Self | 10/min | Grant user consent (GDPR/privacy) |
| `ConsentService/Revoke` | POST | Self | 10/min | Revoke user consent |

### 10.7 SettingsService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `SettingsService/Update` | POST | Admin+ | 20/min | Update workspace settings |

### 10.8 RBACService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `RBACService/GetPermissionMatrix` | POST | Admin+ | 30/min | Get full RBAC permission matrix |
| `RBACService/CreateCustomRole` | POST | Owner | 5/min | Create custom workspace role |

### 10.9 TokenService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `TokenService/GetStatus` | POST | Member | 30/min | Get OAuth token expiry/health status |

### 10.10 TierService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `TierService/GetFeatureGates` | POST | Member | 60/min | Get feature availability for current tier |

---

## 11. Extended Intelligence & Content RPCs

### 11.1 TrendService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `TrendService/GetTop` | POST | Member | 60/min | Get top trending items |
| `TrendService/ListTop` | POST | Member | 60/min | List top trends with filters |
| `TrendService/ListRelated` | POST | Member | 60/min | List trends related to a topic |
| `TrendService/GetTimeSeries` | POST | Member | 30/min | Get trend volume over time |
| `TrendService/GetSparklines` | POST | Member | 60/min | Get mini trend sparkline data |
| `TrendService/GetStats` | POST | Member | 60/min | Get trend statistics summary |
| `TrendService/GetExamples` | POST | Member | 30/min | Get example content for trend |
| `TrendService/GetAudienceFit` | POST | Member | 30/min | Get audience fit score for trend |

### 11.2 CompetitorService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `CompetitorService/Add` | POST | Editor+ | 10/min | Add competitor to watch list |
| `CompetitorService/Remove` | POST | Editor+ | 10/min | Remove competitor |
| `CompetitorService/GetSuggestions` | POST | Member | 30/min | Get AI-suggested competitors |
| `CompetitorService/DismissSuggestion` | POST | Editor+ | 30/min | Dismiss competitor suggestion |
| `CompetitorService/SetAlerts` | POST | Editor+ | 10/min | Configure competitor alerts |
| `CompetitorService/ValidateHandle` | POST | Editor+ | 20/min | Validate social media handle |

### 11.3 OpportunityService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `OpportunityService/Save` | POST | Editor+ | 30/min | Save/bookmark opportunity |
| `OpportunityService/Dismiss` | POST | Editor+ | 30/min | Dismiss opportunity |
| `OpportunityService/ListRelated` | POST | Member | 30/min | List related opportunities |

### 11.4 WatchlistService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `WatchlistService/Create` | POST | Editor+ | 10/min | Create new watchlist |
| `WatchlistService/List` | POST | Member | 60/min | List watchlists |
| `WatchlistService/Delete` | POST | Editor+ | 10/min | Delete watchlist |
| `WatchlistService/Update` | POST | Editor+ | 20/min | Update watchlist metadata |
| `WatchlistService/AddItem` | POST | Editor+ | 30/min | Add item to watchlist |
| `WatchlistService/RemoveItem` | POST | Editor+ | 30/min | Remove item from watchlist |
| `WatchlistService/GetItems` | POST | Member | 60/min | Get watchlist items |
| `WatchlistService/MuteItem` | POST | Editor+ | 30/min | Mute watchlist item notifications |

### 11.5 IdeaService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `IdeaService/Get` | POST | Member | 120/min | Get idea detail |
| `IdeaService/Update` | POST | Editor+ | 30/min | Update idea fields |
| `IdeaService/Delete` | POST | Editor+ | 10/min | Soft-delete idea |
| `IdeaService/Search` | POST | Member | 60/min | Search ideas (full-text + semantic) |
| `IdeaService/Clone` | POST | Editor+ | 10/min | Clone existing idea |
| `IdeaService/AddReference` | POST | Editor+ | 30/min | Add reference media/link to idea |
| `IdeaService/AddTag` | POST | Editor+ | 30/min | Add tag to idea |
| `IdeaService/RemoveTag` | POST | Editor+ | 30/min | Remove tag from idea |
| `IdeaService/UpdateTags` | POST | Editor+ | 20/min | Bulk update idea tags |
| `IdeaService/GetTags` | POST | Member | 60/min | Get available idea tags |
| `IdeaService/UpdateStatus` | POST | Editor+ | 30/min | Update idea status |
| `IdeaService/GetStatusCounts` | POST | Member | 60/min | Get idea count by status |
| `IdeaService/GetPipelineCounts` | POST | Member | 60/min | Get idea pipeline counts |
| `IdeaService/Reorder` | POST | Editor+ | 20/min | Reorder ideas in list |
| `IdeaService/ResScore` | POST | Editor+ | 10/min | Re-score idea with AI |
| `IdeaService/Rescore` | POST | Editor+ | 10/min | Re-score idea (alias) |
| `IdeaService/BulkCreate` | POST | Editor+ | 5/min | Bulk create ideas |
| `IdeaService/BulkDelete` | POST | Editor+ | 5/min | Bulk delete ideas |
| `IdeaService/BulkUpdateStatus` | POST | Editor+ | 5/min | Bulk update idea status |
| `IdeaService/CreateFromTrend` | POST | Editor+ | 10/min | Create idea from trend data |
| `IdeaService/ListMobile` | POST | Member | 60/min | List ideas (mobile-optimized payload) |

### 11.6 ScriptService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `ScriptService/List` | POST | Member | 60/min | List scripts with filters |
| `ScriptService/Delete` | POST | Editor+ | 10/min | Soft-delete script |
| `ScriptService/Duplicate` | POST | Editor+ | 10/min | Duplicate script |
| `ScriptService/GetStats` | POST | Member | 60/min | Get script statistics |
| `ScriptService/GetBrief` | POST | Member | 60/min | Get production brief for script |
| `ScriptService/GetReview` | POST | Member | 60/min | Get review status/comments |
| `ScriptService/SubmitReview` | POST | Editor+ | 10/min | Submit script for review |
| `ScriptService/RequestChanges` | POST | Manager+ | 20/min | Request changes on script |
| `ScriptService/AddSection` | POST | Editor+ | 20/min | Add section to script |
| `ScriptService/UpdateSection` | POST | Editor+ | 30/min | Update script section |
| `ScriptService/DeleteSection` | POST | Editor+ | 20/min | Delete script section |
| `ScriptService/ReorderSections` | POST | Editor+ | 20/min | Reorder script sections |
| `ScriptService/AddComment` | POST | Contributor+ | 30/min | Add inline comment |
| `ScriptService/ResolveComment` | POST | Editor+ | 30/min | Resolve comment |
| `ScriptService/GetVersion` | POST | Member | 60/min | Get specific version |
| `ScriptService/ListVersions` | POST | Member | 60/min | List version history |
| `ScriptService/RestoreVersion` | POST | Editor+ | 5/min | Restore previous version |
| `ScriptService/update` | POST | Editor+ | 30/min | Update script (legacy alias) |

### 11.7 AssetService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `AssetService/Get` | POST | Member | 120/min | Get asset detail |
| `AssetService/Upload` | POST | Editor+ | 20/min | Upload asset file |
| `AssetService/Export` | POST | Editor+ | 10/min | Export asset to format |
| `AssetService/BatchExport` | POST | Editor+ | 5/min | Batch export assets |
| `AssetService/FetchReference` | POST | Editor+ | 10/min | Fetch reference from URL |
| `AssetService/AnalyzeCreativeDNA` | POST | Editor+ | 5/min | AI creative DNA analysis |
| `AssetService/ListMusicGenres` | POST | Member | 60/min | List available music genres |

### 11.8 CharacterService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `CharacterService/Get` | POST | Member | 120/min | Get character detail |
| `CharacterService/Delete` | POST | Editor+ | 10/min | Soft-delete character |

### 11.9 ContinuityService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `ContinuityService/Create` | POST | Editor+ | 10/min | Create new continuity pack |
| `ContinuityService/Get` | POST | Member | 60/min | Get continuity pack detail |
| `ContinuityService/Clone` | POST | Editor+ | 10/min | Clone continuity pack |
| `ContinuityService/Delete` | POST | Manager+ | 5/min | Delete continuity pack |
| `ContinuityService/GetUsageStats` | POST | Member | 30/min | Get pack usage statistics |
| `ContinuityService/ListBrandPacks` | POST | Member | 60/min | List brand packs |
| `ContinuityService/ListCharacters` | POST | Member | 60/min | List characters in pack |
| `ContinuityService/ListVoices` | POST | Member | 60/min | List voices in pack |

### 11.10 ContentService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `ContentService/AttachMedia` | POST | Editor+ | 20/min | Attach media to content item |
| `ContentService/FindMentions` | POST | Member | 30/min | Find brand/keyword mentions |
| `ContentService/GetCaptionStyles` | POST | Member | 60/min | Get available caption styles |
| `ContentService/GetHookTemplates` | POST | Member | 60/min | Get hook/intro templates |

### 11.11 BriefService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `BriefService/Get` | POST | Member | 60/min | Get production brief |
| `BriefService/GetBrief` | POST | Member | 60/min | Get brief detail (alias) |
| `BriefService/Update` | POST | Editor+ | 20/min | Update brief fields |
| `BriefService/AddShot` | POST | Editor+ | 20/min | Add shot to brief |
| `BriefService/DeleteShot` | POST | Editor+ | 20/min | Delete shot from brief |
| `BriefService/UpdateShot` | POST | Editor+ | 20/min | Update shot details |
| `BriefService/ReorderShots` | POST | Editor+ | 20/min | Reorder shots |
| `BriefService/GetSuggestedActions` | POST | Member | 30/min | Get AI suggested actions |
| `BriefService/GetWarnings` | POST | Member | 30/min | Get brief quality warnings |
| `BriefService/GetMorningBrief` | POST | Member | 10/min | Get daily morning brief |
| `BriefService/RegenerateBrief` | POST | Editor+ | 5/min | Regenerate AI brief content |
| `BriefService/EmailBrief` | POST | Editor+ | 10/min | Email brief to team |

### 11.12 BrandPackService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `BrandPackService/Create` | POST | Editor+ | 10/min | Create brand pack |
| `BrandPackService/Get` | POST | Member | 60/min | Get brand pack detail |
| `BrandPackService/GetActive` | POST | Member | 60/min | Get active brand pack |
| `BrandPackService/List` | POST | Member | 60/min | List brand packs |
| `BrandPackService/Update` | POST | Editor+ | 20/min | Update brand pack |
| `BrandPackService/UploadLogo` | POST | Editor+ | 10/min | Upload brand logo |

### 11.13 ReferenceService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `ReferenceService/Save` | POST | Editor+ | 20/min | Save reference material |

### 11.14 GlossaryService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `GlossaryService/ListTerms` | POST | Member | 60/min | List glossary terms |
| `GlossaryService/GetTerm` | POST | Member | 60/min | Get glossary term detail |

---

## 12. Extended Publish & Engagement RPCs

### 12.1 PublishService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `PublishService/Get` | POST | Member | 120/min | Get publish item detail |
| `PublishService/List` | POST | Member | 60/min | List all publish items |
| `PublishService/GetDraft` | POST | Member | 60/min | Get draft publish item |
| `PublishService/SaveDraft` | POST | Editor+ | 30/min | Save draft publish item |
| `PublishService/UpdateDraft` | POST | Editor+ | 30/min | Update draft content |
| `PublishService/ListDrafts` | POST | Member | 60/min | List draft items |
| `PublishService/PublishNow` | POST | Manager+ | 10/min | Publish immediately |
| `PublishService/Reschedule` | POST | Editor+ | 20/min | Reschedule publish time |
| `PublishService/Delete` | POST | Manager+ | 10/min | Delete publish item |
| `PublishService/Duplicate` | POST | Editor+ | 10/min | Duplicate publish item |
| `PublishService/Pause` | POST | Editor+ | 20/min | Pause scheduled publish |
| `PublishService/CheckCompatibility` | POST | Editor+ | 30/min | Check platform compatibility |
| `PublishService/UpdateMetadata` | POST | Editor+ | 30/min | Update publish metadata |
| `PublishService/GetCalendar` | POST | Member | 30/min | Get calendar view data |
| `PublishService/ListByDateRange` | POST | Member | 30/min | List items by date range |
| `PublishService/ListUpcoming` | POST | Member | 60/min | List upcoming scheduled |
| `PublishService/ListPublished` | POST | Member | 60/min | List published items |
| `PublishService/ListPosts` | POST | Member | 60/min | List published posts |
| `PublishService/GetPlatformStatus` | POST | Member | 30/min | Get platform publish status |
| `PublishService/GetCrossPostInsights` | POST | Member | 30/min | Get cross-post performance |
| `PublishService/PublishVariants` | POST | Editor+ | 5/min | Publish A/B test variants |
| `PublishService/HoldSchedule` | POST | Editor+ | 20/min | Hold scheduled publish |
| `PublishService/ScheduleRetry` | POST | Editor+ | 10/min | Schedule retry for failed |
| `PublishService/TagProduct` | POST | Editor+ | 30/min | Tag product in content |
| `PublishService/UntagProduct` | POST | Editor+ | 30/min | Remove product tag |

### 12.2 PackagingService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `PackagingService/RunQA` | POST | Editor+ | 10/min | Run full QA check on content |

### 12.3 ApprovalService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `ApprovalService/ListPending` | POST | Member | 60/min | List pending approvals |
| `ApprovalService/GetQueueStats` | POST | Member | 30/min | Get approval queue statistics |

### 12.4 ThreadService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `ThreadService/GetMessages` | POST | Member | 60/min | Get thread messages |
| `ThreadService/GetUnreadCount` | POST | Member | 60/min | Get unread thread count |
| `ThreadService/MarkRead` | POST | Member | 60/min | Mark thread as read |
| `ThreadService/Update` | POST | Editor+ | 30/min | Update thread metadata |
| `ThreadService/AddTag` | POST | Editor+ | 30/min | Add tag to thread |
| `ThreadService/Mute` | POST | Member | 30/min | Mute thread notifications |
| `ThreadService/Snooze` | POST | Member | 30/min | Snooze thread |
| `ThreadService/ListMobile` | POST | Member | 60/min | List threads (mobile payload) |

### 12.5 EntityService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `EntityService/AddNote` | POST | Editor+ | 30/min | Add note to contact |
| `EntityService/AddTag` | POST | Editor+ | 30/min | Add tag to contact |

### 12.6 FollowUpTaskService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `FollowUpTaskService/Create` | POST | Editor+ | 20/min | Create follow-up task |
| `FollowUpTaskService/Complete` | POST | Editor+ | 30/min | Mark follow-up complete |
| `FollowUpTaskService/Reschedule` | POST | Editor+ | 20/min | Reschedule follow-up |

### 12.7 ContactService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `ContactService/List` | POST | Member | 60/min | List contacts |
| `ContactService/Search` | POST | Member | 60/min | Search contacts |
| `ContactService/GetSummary` | POST | Member | 30/min | Get contact summary stats |
| `ContactService/Export` | POST | Manager+ | 5/min | Export contacts to CSV |
| `ContactService/UpdateVIP` | POST | Editor+ | 20/min | Update contact VIP status |

### 12.8 ReviewService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `ReviewService/AddComment` | POST | Contributor+ | 30/min | Add review comment |
| `ReviewService/ReplyComment` | POST | Contributor+ | 30/min | Reply to review comment |

---

## 13. Extended Commerce RPCs

### 13.1 ProductService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `ProductService/Search` | POST | Member | 60/min | Search products |
| `ProductService/GetStats` | POST | Member | 60/min | Get product statistics |
| `ProductService/GetSalesStats` | POST | Member | 30/min | Get product sales stats |
| `ProductService/GetSalesChart` | POST | Member | 30/min | Get sales chart data |
| `ProductService/GetReviews` | POST | Member | 60/min | Get product reviews |
| `ProductService/GetRank` | POST | Member | 30/min | Get product ranking |
| `ProductService/GetLinkedContent` | POST | Member | 30/min | Get content linked to product |
| `ProductService/LinkContent` | POST | Editor+ | 20/min | Link content to product |
| `ProductService/UpdateStock` | POST | Editor+ | 20/min | Update stock level |
| `ProductService/SetAlertThreshold` | POST | Editor+ | 10/min | Set stock alert threshold |
| `ProductService/BulkArchive` | POST | Manager+ | 5/min | Bulk archive products |

### 13.2 OfferService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `OfferService/GetPerformance` | POST | Member | 30/min | Get offer performance metrics |
| `OfferService/GetRedemptionStats` | POST | Member | 30/min | Get redemption statistics |
| `OfferService/GetStatusCounts` | POST | Member | 60/min | Get offer count by status |
| `OfferService/GetTabSummary` | POST | Member | 60/min | Get tab summary counts |
| `OfferService/Duplicate` | POST | Editor+ | 10/min | Duplicate offer |
| `OfferService/Delete` | POST | Manager+ | 10/min | Soft-delete offer |
| `OfferService/BulkPause` | POST | Manager+ | 5/min | Bulk pause offers |

### 13.3 OrderService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `OrderService/Search` | POST | Editor+ | 60/min | Search orders |
| `OrderService/Confirm` | POST | Editor+ | 20/min | Confirm order |
| `OrderService/GetTodayStats` | POST | Member | 60/min | Get today's order stats |
| `OrderService/GetDailyStats` | POST | Member | 30/min | Get daily order stats |
| `OrderService/GetLabel` | POST | Editor+ | 30/min | Get shipping label |
| `OrderService/ListRecent` | POST | Member | 60/min | List recent orders |
| `OrderService/BulkCancel` | POST | Manager+ | 5/min | Bulk cancel orders |
| `OrderService/BulkUpdateStatus` | POST | Manager+ | 5/min | Bulk update order status |

### 13.4 CampaignService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `CampaignService/Duplicate` | POST | Editor+ | 10/min | Duplicate campaign |
| `CampaignService/ExportReport` | POST | Manager+ | 5/min | Export campaign report |

### 13.5 AffiliateService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `AffiliateService/DeleteLink` | POST | Editor+ | 10/min | Delete affiliate link |
| `AffiliateService/RenewLink` | POST | Editor+ | 10/min | Renew expired affiliate link |
| `AffiliateService/RunHealthCheck` | POST | Editor+ | 5/min | Run health check on link |

### 13.6 CouponService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `CouponService/Delete` | POST | Admin+ | 10/min | Delete coupon |
| `CouponService/Pause` | POST | Manager+ | 20/min | Pause coupon |
| `CouponService/Resume` | POST | Manager+ | 20/min | Resume paused coupon |
| `CouponService/Deactivate` | POST | Manager+ | 10/min | Deactivate coupon |
| `CouponService/CheckAvailability` | POST | Member | 60/min | Check coupon availability |

### 13.7 StoreService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `StoreService/GetPage` | POST | Member | 60/min | Get store page detail |
| `StoreService/ListPages` | POST | Member | 60/min | List all store pages |
| `StoreService/DeletePage` | POST | Admin+ | 5/min | Delete store page |
| `StoreService/DuplicatePage` | POST | Manager+ | 10/min | Duplicate store page |
| `StoreService/Publish` | POST | Manager+ | 10/min | Publish store page |
| `StoreService/Unpublish` | POST | Manager+ | 10/min | Unpublish store page |
| `StoreService/GetPageStats` | POST | Member | 30/min | Get page visit/conversion stats |
| `StoreService/GetThemes` | POST | Member | 60/min | Get available store themes |

### 13.8 InventoryService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `InventoryService/GetSummary` | POST | Member | 60/min | Get inventory summary |
| `InventoryService/ListStock` | POST | Member | 60/min | List stock levels |
| `InventoryService/ListMovements` | POST | Member | 60/min | List stock movements |
| `InventoryService/CreateStockMovement` | POST | Editor+ | 20/min | Create stock movement |
| `InventoryService/BulkStockIn` | POST | Editor+ | 5/min | Bulk stock in |
| `InventoryService/GetAlerts` | POST | Member | 60/min | Get stock alerts |
| `InventoryService/UpdateThresholds` | POST | Editor+ | 10/min | Update alert thresholds |
| `InventoryService/Export` | POST | Manager+ | 5/min | Export inventory data |

### 13.9 ShipmentService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `ShipmentService/AddTracking` | POST | Editor+ | 20/min | Add tracking number |
| `ShipmentService/GetTrackingStatus` | POST | Member | 60/min | Get shipment tracking status |

### 13.10 ShippingService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `ShippingService/GetTracking` | POST | Member | 60/min | Get shipping tracking info |

### 13.11 CommerceService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `CommerceService/GetDashboard` | POST | Member | 30/min | Get commerce dashboard data |
| `CommerceService/GetTopProducts` | POST | Member | 30/min | Get top selling products |

---

## 14. Extended Finance RPCs

### 14.1 ProfitService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `ProfitService/GetTrend` | POST | Manager+ | 30/min | Get profit trend over time |
| `ProfitService/GetCostBreakdown` | POST | Manager+ | 30/min | Get cost breakdown by category |
| `ProfitService/GetRevenueByPlatform` | POST | Manager+ | 30/min | Get revenue by platform |
| `ProfitService/GetRevenueByProduct` | POST | Manager+ | 30/min | Get revenue by product |
| `ProfitService/ExportReport` | POST | Manager+ | 5/min | Export profit report |
| `ProfitService/ExportTaxReport` | POST | Manager+ | 5/min | Export tax report |
| `ProfitService/ExportToSheets` | POST | Manager+ | 5/min | Export to Google Sheets |
| `ProfitService/GenerateReport` | POST | Manager+ | 5/min | Generate custom profit report |
| `ProfitService/GetReportTemplates` | POST | Manager+ | 30/min | Get report templates |
| `ProfitService/GetSavedReports` | POST | Manager+ | 30/min | Get saved custom reports |

### 14.2 CostService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `CostService/GetBreakdown` | POST | Manager+ | 30/min | Get cost breakdown |
| `CostService/CreateEntry` | POST | Manager+ | 20/min | Create cost entry |
| `CostService/UpdateEntry` | POST | Manager+ | 20/min | Update cost entry |
| `CostService/DeleteEntry` | POST | Admin+ | 10/min | Delete cost entry |
| `CostService/CreateCostItem` | POST | Manager+ | 20/min | Create cost item (alias) |

### 14.3 ReconciliationService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `ReconciliationService/GetStatus` | POST | Manager+ | 30/min | Get reconciliation status |
| `ReconciliationService/GetBatches` | POST | Manager+ | 30/min | List reconciliation batches |
| `ReconciliationService/ListPending` | POST | Manager+ | 30/min | List pending reconciliation items |
| `ReconciliationService/GetSuggestions` | POST | Manager+ | 30/min | Get AI match suggestions |
| `ReconciliationService/ManualMatch` | POST | Admin+ | 10/min | Manual match order to settlement |
| `ReconciliationService/ApproveMatched` | POST | Admin+ | 10/min | Approve matched items |
| `ReconciliationService/ApproveAll` | POST | Admin+ | 5/min | Approve all matched in batch |
| `ReconciliationService/RejectMatch` | POST | Admin+ | 10/min | Reject match suggestion |
| `ReconciliationService/Confirm` | POST | Admin+ | 10/min | Confirm reconciliation |
| `ReconciliationService/ConfirmWithDiscrepancy` | POST | Admin+ | 10/min | Confirm with noted discrepancy |
| `ReconciliationService/FlagDispute` | POST | Admin+ | 10/min | Flag for dispute |
| `ReconciliationService/Resolve` | POST | Admin+ | 10/min | Resolve dispute |
| `ReconciliationService/Assign` | POST | Admin+ | 10/min | Assign reconciliation task |
| `ReconciliationService/Skip` | POST | Admin+ | 10/min | Skip reconciliation item |
| `ReconciliationService/stream` | POST | Manager+ | 10/min | Stream reconciliation updates |

### 14.4 SettlementService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `SettlementService/Upload` | POST | Admin+ | 5/min | Upload settlement file |
| `SettlementService/stream` | POST | Manager+ | 10/min | Stream settlement updates |

### 14.5 RefundService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `RefundService/Approve` | POST | Manager+ | 10/min | Approve refund request |
| `RefundService/Reject` | POST | Manager+ | 10/min | Reject refund request |
| `RefundService/GetStats` | POST | Manager+ | 30/min | Get refund statistics |

### 14.6 ProofService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `ProofService/UploadEvidence` | POST | Editor+ | 20/min | Upload evidence to proof bundle |
| `ProofService/ExportBundle` | POST | Manager+ | 5/min | Export proof bundle |
| `ProofService/ExportFull` | POST | Manager+ | 5/min | Export full proof package |
| `ProofService/GetBundles` | POST | Manager+ | 30/min | List proof bundles |

### 14.7 ExchangeRateService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `ExchangeRateService/GetRates` | POST | Member | 30/min | Get current exchange rates |

### 14.8 RevenueService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `RevenueService/GetRevenue` | POST | Manager+ | 30/min | Get revenue summary |
| `RevenueService/ExportPDF` | POST | Manager+ | 5/min | Export revenue report as PDF |

### 14.9 TaxReportService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `TaxReportService/GetReport` | POST | Manager+ | 10/min | Get tax report data |

### 14.10 CreditService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `CreditService/GetBalance` | POST | Member | 60/min | Get credit balance |
| `CreditService/GetUsageStats` | POST | Member | 30/min | Get credit usage statistics |
| `CreditService/GetMonthlyUsage` | POST | Member | 30/min | Get monthly usage breakdown |
| `CreditService/ListTransactions` | POST | Member | 60/min | List credit transactions |
| `CreditService/ListRecentUsage` | POST | Member | 60/min | List recent credit usage |
| `CreditService/ListPackages` | POST | Member | 60/min | List available credit packages |
| `CreditService/Purchase` | POST | Admin+ | 5/min | Purchase credit package |
| `CreditService/GetCheckoutStatus` | POST | Member | 30/min | Get purchase checkout status |
| `CreditService/GetAutoRefillConfig` | POST | Admin+ | 30/min | Get auto-refill configuration |
| `CreditService/UpdateAutoRefill` | POST | Admin+ | 5/min | Update auto-refill settings |

### 14.11 BillingService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `BillingService/GetCurrentPlan` | POST | Member | 60/min | Get current subscription plan |
| `BillingService/ListPlans` | POST | Member | 60/min | List available plans |
| `BillingService/GetSubscription` | POST | Member | 60/min | Get subscription detail |
| `BillingService/GetPaymentMethods` | POST | Admin+ | 30/min | Get payment methods |
| `BillingService/ChangePlan` | POST | Admin+ | 5/min | Change subscription plan |
| `BillingService/CancelPlan` | POST | Admin+ | 5/min | Cancel subscription |
| `BillingService/Cancel` | POST | Admin+ | 5/min | Cancel subscription (alias) |
| `BillingService/ListInvoices` | POST | Manager+ | 30/min | List invoices |
| `BillingService/GetInvoiceUrl` | POST | Manager+ | 30/min | Get invoice download URL |
| `BillingService/GetCheckoutStatus` | POST | Member | 30/min | Get checkout status |
| `BillingService/ListCreditPackages` | POST | Member | 60/min | List credit packages |
| `BillingService/ListCreditPurchases` | POST | Manager+ | 30/min | List credit purchase history |
| `BillingService/ApplyRetentionDiscount` | POST | Admin+ | 5/min | Apply retention discount |

---

## 15. Extended AI & Production RPCs

### 15.1 AIService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `AIService/GenerateScript` | POST | Editor+ | 10/min | AI script generation |
| `AIService/GenerateThumbnails` | POST | Editor+ | 10/min | AI thumbnail generation |
| `AIService/GenerateVoice` | POST | Editor+ | 10/min | AI voiceover generation |
| `AIService/GenerateMusic` | POST | Editor+ | 10/min | AI music generation |
| `AIService/GenerateCharacterPreview` | POST | Editor+ | 5/min | AI character preview |
| `AIService/GenerateVariants` | POST | Editor+ | 5/min | AI content variant generation |
| `AIService/GenerateLiveCueCards` | POST | Editor+ | 10/min | AI live cue card generation |
| `AIService/GenerateLiveInsights` | POST | Editor+ | 10/min | AI live stream insights |
| `AIService/SuggestReply` | POST | Contributor+ | 30/min | AI suggested reply |
| `AIService/BatchSuggestReplies` | POST | Editor+ | 10/min | Batch AI reply suggestions |
| `AIService/SuggestRates` | POST | Editor+ | 10/min | AI rate card suggestions |
| `AIService/SuggestDerivatives` | POST | Editor+ | 10/min | AI derivative suggestions |
| `AIService/AnalyzeVideo` | POST | Editor+ | 5/min | AI video analysis |
| `AIService/AnalyzeClips` | POST | Editor+ | 10/min | AI clip analysis |
| `AIService/AnalyzeStyle` | POST | Editor+ | 5/min | AI style analysis |
| `AIService/AnalyzeScenes` | POST | Editor+ | 5/min | AI scene detection |
| `AIService/AnalyzeTranscript` | POST | Editor+ | 10/min | AI transcript analysis |
| `AIService/Transcribe` | POST | Editor+ | 10/min | Audio/video transcription |
| `AIService/TranslateScript` | POST | Editor+ | 10/min | AI script translation |
| `AIService/Rephrase` | POST | Editor+ | 20/min | AI text rephrasing |
| `AIService/ExtractKeyPoints` | POST | Editor+ | 10/min | Extract key points from content |
| `AIService/AddSFX` | POST | Editor+ | 10/min | AI sound effects addition |
| `AIService/BeatSync` | POST | Editor+ | 10/min | AI beat synchronization |
| `AIService/SpeechToSong` | POST | Editor+ | 5/min | AI speech to song conversion |
| `AIService/ScrapeURL` | POST | Editor+ | 10/min | Scrape product/content URL |
| `AIService/ScanReceipt` | POST | Editor+ | 10/min | AI receipt scanning/OCR |
| `AIService/ScanBankStatement` | POST | Editor+ | 5/min | AI bank statement scanning |
| `AIService/GetPricingIntelligence` | POST | Member | 10/min | AI pricing intelligence |
| `AIService/GetProviderStatus` | POST | Member | 30/min | Get AI provider status |

### 15.2 CopilotService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `CopilotService/Chat` | POST | Contributor+ | 20/min | Copilot chat message |
| `CopilotService/SendMessage` | POST | Contributor+ | 20/min | Send message (alias) |
| `CopilotService/GetSession` | POST | Contributor+ | 30/min | Get copilot session |
| `CopilotService/ClearSession` | POST | Contributor+ | 10/min | Clear copilot session |
| `CopilotService/Feedback` | POST | Contributor+ | 30/min | Submit feedback on response |
| `CopilotService/GenerateIdeas` | POST | Contributor+ | 10/min | Generate content ideas |
| `CopilotService/GenerateCaption` | POST | Contributor+ | 20/min | Generate social caption |
| `CopilotService/GenerateReply` | POST | Contributor+ | 20/min | Generate reply draft |
| `CopilotService/GenerateAvatar` | POST | Contributor+ | 5/min | Generate AI avatar |
| `CopilotService/ShortenCaption` | POST | Contributor+ | 20/min | Shorten caption text |
| `CopilotService/SuggestHashtags` | POST | Contributor+ | 20/min | Suggest hashtags |
| `CopilotService/DismissReply` | POST | Contributor+ | 30/min | Dismiss suggested reply |
| `CopilotService/RegenerateSection` | POST | Contributor+ | 10/min | Regenerate content section |
| `CopilotService/ScoreIdea` | POST | Contributor+ | 10/min | Score idea quality |
| `CopilotService/CheckBrandVoice` | POST | Contributor+ | 10/min | Check brand voice consistency |
| `CopilotService/AnalyzeAnalytics` | POST | Contributor+ | 10/min | AI analytics analysis |
| `CopilotService/AnalyzePipeline` | POST | Contributor+ | 10/min | AI pipeline analysis |
| `CopilotService/AnalyticsInsights` | POST | Contributor+ | 10/min | Get analytics insights |
| `CopilotService/FinanceInsight` | POST | Contributor+ | 10/min | Get finance insight |
| `CopilotService/TrendInsight` | POST | Contributor+ | 10/min | Get trend insight |
| `CopilotService/GetContentOptimization` | POST | Contributor+ | 10/min | Get content optimization tips |
| `CopilotService/GetCostOptimization` | POST | Contributor+ | 10/min | Get cost optimization tips |
| `CopilotService/GetOptimalTimes` | POST | Contributor+ | 10/min | Get optimal posting times |

### 15.3 StudioService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `StudioService/GetModes` | POST | Member | 60/min | Get available studio modes |
| `StudioService/GetActiveJobs` | POST | Member | 60/min | Get active generation jobs |
| `StudioService/GetRecentAssets` | POST | Member | 60/min | Get recently generated assets |
| `StudioService/Cancel` | POST | Editor+ | 10/min | Cancel generation job |
| `StudioService/Retry` | POST | Editor+ | 10/min | Retry failed job |

### 15.4 StylePackService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `StylePackService/Create` | POST | Editor+ | 10/min | Create style pack from scratch |

### 15.5 VoiceService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `VoiceService/UploadSample` | POST | Editor+ | 10/min | Upload voice sample |
| `VoiceService/TestVoice` | POST | Editor+ | 10/min | Test voice clone preview |

### 15.6 GenerationService

> `GenerationService` is an active-job projection surface only. Canonical create/status asset lifecycle RPCs remain under `AssetService` (`Generate`, `GetStatus`, `List`, etc.). Do not use `GenerationService` as the write-path service name for new generation clients.

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `GenerationService/ListActive` | POST | Member | 60/min | List active generation jobs |
| `GenerationService/StreamActiveJobs` | POST | Member | 30/min | Stream active job status |

### 15.7 ModelService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `ModelService/ListAvailable` | POST | Member | 60/min | List available AI models |

### 15.8 AIPreferenceService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `AIPreferenceService/Get` | POST | Member | 60/min | Get AI preferences |
| `AIPreferenceService/ResetDefaults` | POST | Editor+ | 5/min | Reset AI preferences to defaults |

---

## 16. Analytics & Dashboard RPCs

### 16.1 AnalyticsService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `AnalyticsService/GetDashboard` | POST | Member | 30/min | Get analytics dashboard data |
| `AnalyticsService/GetOverview` | POST | Member | 30/min | Get analytics overview |
| `AnalyticsService/GetTimeSeries` | POST | Member | 30/min | Get time series metrics |
| `AnalyticsService/GetGrowthSeries` | POST | Member | 30/min | Get growth series data |
| `AnalyticsService/GetTopContent` | POST | Member | 30/min | Get top performing content |
| `AnalyticsService/GetTopPerformer` | POST | Member | 30/min | Get top performer details |
| `AnalyticsService/GetPostMetrics` | POST | Member | 60/min | Get post-level metrics |
| `AnalyticsService/GetPostDetail` | POST | Member | 60/min | Get detailed post analytics |
| `AnalyticsService/BatchGetPostMetrics` | POST | Member | 10/min | Batch get post metrics |
| `AnalyticsService/GetBenchmarkData` | POST | Member | 30/min | Get benchmark comparison data |
| `AnalyticsService/GetBestPostingTimes` | POST | Member | 30/min | Get optimal posting times |
| `AnalyticsService/GetBestPostingTime` | POST | Member | 30/min | Get best posting time (alias) |
| `AnalyticsService/GetPlatformBreakdown` | POST | Member | 30/min | Get platform breakdown |
| `AnalyticsService/GetPlatformKPIs` | POST | Member | 30/min | Get platform KPIs |
| `AnalyticsService/GetPlatformReliability` | POST | Member | 30/min | Get platform reliability |
| `AnalyticsService/GetChannelsSummary` | POST | Member | 30/min | Get channels summary |
| `AnalyticsService/GetContentTypeBreakdown` | POST | Member | 30/min | Get content type breakdown |
| `AnalyticsService/GetDemographics` | POST | Member | 30/min | Get audience demographics |
| `AnalyticsService/GetAggregateMetrics` | POST | Member | 30/min | Get aggregate metrics |
| `AnalyticsService/GetWeeklySummary` | POST | Member | 30/min | Get weekly summary |
| `AnalyticsService/GetIdeaOutcome` | POST | Member | 30/min | Get idea-to-outcome tracking |
| `AnalyticsService/ExportCSV` | POST | Manager+ | 5/min | Export analytics as CSV |
| `AnalyticsService/ExportPDF` | POST | Manager+ | 5/min | Export analytics as PDF |

### 16.2 DashboardService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `DashboardService/GetMobileHome` | POST | Member | 30/min | Get mobile home dashboard |
| `DashboardService/GetPipeline` | POST | Member | 30/min | Get content pipeline dashboard |

### 16.3 ContentPerformanceService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `ContentPerformanceService/GetStats` | POST | Member | 30/min | Get content performance stats |

### 16.4 ContentRevenueService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `ContentRevenueService/GetAttribution` | POST | Member | 30/min | Get content revenue attribution |

### 16.5 AttributionService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `AttributionService/GetByContent` | POST | Member | 30/min | Get attribution by content |

### 16.6 BenchmarkService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `BenchmarkService/Compare` | POST | Member | 20/min | Compare against benchmarks |
| `BenchmarkService/GetTimeSeries` | POST | Member | 30/min | Get benchmark time series |

### 16.7 PerformanceService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `PerformanceService/GetWeeklyReport` | POST | Member | 10/min | Get weekly performance report |

### 16.8 PlatformService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `PlatformService/GetAggregatedStats` | POST | Member | 30/min | Get aggregated platform stats |
| `PlatformService/SyncStats` | POST | Manager+ | 5/min | Force sync platform statistics |

### 16.9 PlatformRulesService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `PlatformRulesService/Get` | POST | Member | 60/min | Get platform content rules |

---

## 17. Extended Other Domain RPCs

### 17.1 LiveService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `LiveService/CreateSession` | POST | Editor+ | 10/min | Create live session |
| `LiveService/GetSession` | POST | Member | 60/min | Get session detail |
| `LiveService/ListSessions` | POST | Member | 60/min | List live sessions |
| `LiveService/StartSession` | POST | Editor+ | 5/min | Start live session |
| `LiveService/EndSession` | POST | Editor+ | 5/min | End live session |
| `LiveService/DeleteSession` | POST | Manager+ | 5/min | Delete session |
| `LiveService/DuplicateSession` | POST | Editor+ | 10/min | Duplicate session |
| `LiveService/SaveSetup` | POST | Editor+ | 20/min | Save session setup |
| `LiveService/AddProduct` | POST | Editor+ | 30/min | Add product to live session |
| `LiveService/AddOffer` | POST | Editor+ | 30/min | Add offer to live session |
| `LiveService/NextProduct` | POST | Editor+ | 30/min | Switch to next product |
| `LiveService/ReorderProducts` | POST | Editor+ | 20/min | Reorder product queue |
| `LiveService/TriggerFlashSale` | POST | Manager+ | 5/min | Trigger flash sale |
| `LiveService/CreateHighlight` | POST | Editor+ | 20/min | Create highlight clip |
| `LiveService/Reply` | POST | Editor+ | 30/min | Reply in live chat |
| `LiveService/GetLiveStats` | POST | Member | 30/min | Get live statistics |
| `LiveService/StreamStats` | POST | Member | 10/min | Stream live statistics |

### 17.2 LiveAnalyticsService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `LiveAnalyticsService/GetSummary` | POST | Member | 30/min | Get live analytics summary |
| `LiveAnalyticsService/GetStatus` | POST | Member | 60/min | Get live session status |

### 17.3 SeedingService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `SeedingService/CreateAssignment` | POST | Editor+ | 20/min | Create seeding assignment |
| `SeedingService/RemoveAssignment` | POST | Editor+ | 20/min | Remove assignment |
| `SeedingService/ListAssignments` | POST | Member | 60/min | List assignments |
| `SeedingService/ListRequests` | POST | Member | 60/min | List sample requests |
| `SeedingService/MarkReceived` | POST | Editor+ | 20/min | Mark sample as received |
| `SeedingService/MarkShipped` | POST | Editor+ | 20/min | Mark sample as shipped |
| `SeedingService/SendReminder` | POST | Editor+ | 10/min | Send reminder to creator |
| `SeedingService/UpdateStatus` | POST | Editor+ | 20/min | Update seeding status |
| `SeedingService/Duplicate` | POST | Editor+ | 10/min | Duplicate sample request |
| `SeedingService/DuplicateCampaign` | POST | Manager+ | 10/min | Duplicate seeding campaign |
| `SeedingService/Launch` | POST | Manager+ | 5/min | Launch seeding campaign |
| `SeedingService/LinkContent` | POST | Editor+ | 20/min | Link content to seeding |

### 17.4 SampleService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `SampleService/Create` | POST | Editor+ | 20/min | Create sample request |
| `SampleService/List` | POST | Member | 60/min | List sample requests |
| `SampleService/Approve` | POST | Manager+ | 20/min | Approve sample request |
| `SampleService/Decline` | POST | Manager+ | 20/min | Decline sample request |
| `SampleService/Cancel` | POST | Editor+ | 20/min | Cancel sample request |
| `SampleService/MarkShipped` | POST | Editor+ | 20/min | Mark sample shipped |
| `SampleService/MarkReceived` | POST | Editor+ | 20/min | Mark sample received |
| `SampleService/UpdateStatus` | POST | Editor+ | 20/min | Update sample status |
| `SampleService/GetSummary` | POST | Member | 30/min | Get sample summary |
| `SampleService/GetStats` | POST | Member | 30/min | Get sample statistics |
| `SampleService/LinkReview` | POST | Editor+ | 20/min | Link review to sample |
| `SampleService/RateCreator` | POST | Manager+ | 10/min | Rate creator performance |
| `SampleService/GetReviewRevenue` | POST | Member | 30/min | Get review revenue |
| `SampleService/ExtendDeadline` | POST | Manager+ | 10/min | Extend sample deadline |
| `SampleService/ExportReport` | POST | Manager+ | 5/min | Export sample report |

### 17.5 WorkflowService (Extended)

> Core lifecycle RPCs remain canonical in §2.8.1 (`Create`, `Get`, `List`, `Update`, `Activate`, `Deactivate`, `Run`, `InspectRun`, `GetRunLogs`, `ListRuns`, `Clone`, `Export`, `Import`). This section lists only additional workflow-runtime RPCs beyond that core set.

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `WorkflowService/Test` | POST | Editor+ | 10/min | Test workflow execution |
| `WorkflowService/GetRunStats` | POST | Member | 30/min | Get run statistics |
| `WorkflowService/CancelRun` | POST | Editor+ | 10/min | Cancel running workflow |
| `WorkflowService/RetryRun` | POST | Editor+ | 10/min | Retry failed run |
| `WorkflowService/DismissRun` | POST | Editor+ | 30/min | Dismiss run notification |
| `WorkflowService/SkipStep` | POST | Editor+ | 10/min | Skip workflow step |
| `WorkflowService/ProvideInput` | POST | Editor+ | 20/min | Provide input for waiting step |
| `WorkflowService/ExportRuns` | POST | Manager+ | 5/min | Export run history |

### 17.6 AgentService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `AgentService/LaunchAgent` | POST | Editor+ | 10/min | Launch AI agent |
| `AgentService/ListRuns` | POST | Member | 60/min | List agent runs |
| `AgentService/CancelRun` | POST | Editor+ | 10/min | Cancel agent run |
| `AgentService/StreamRun` | POST | Member | 10/min | Stream agent run output |
| `AgentService/ProvideInput` | POST | Editor+ | 20/min | Provide input to agent |

### 17.7 TemplateService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `TemplateService/ListTemplates` | POST | Member | 60/min | List templates |
| `TemplateService/GetTemplate` | POST | Member | 60/min | Get template detail |
| `TemplateService/SearchTemplates` | POST | Member | 60/min | Search templates |
| `TemplateService/GetFeatured` | POST | Member | 60/min | Get featured templates |
| `TemplateService/GetReviews` | POST | Member | 60/min | Get template reviews |
| `TemplateService/Deploy` | POST | Editor+ | 10/min | Deploy template |

### 17.8 CapabilityService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `CapabilityService/GetRecentIssues` | POST | Member | 30/min | Get recent capability issues |
| `CapabilityService/GetSnapshots` | POST | Member | 30/min | Get capability snapshots |
| `CapabilityService/GetSystemStatus` | POST | Member | 30/min | Get overall system status |

### 17.9 GamificationService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `GamificationService/GetDashboard` | POST | Contributor+ | 30/min | Get gamification dashboard |
| `GamificationService/GetAchievements` | POST | Contributor+ | 30/min | Get achievements list |
| `GamificationService/GetActiveQuests` | POST | Contributor+ | 30/min | Get active quests |
| `GamificationService/GetLeaderboard` | POST | Contributor+ | 30/min | Get leaderboard |
| `GamificationService/GetStreak` | POST | Contributor+ | 60/min | Get current streak |

### 17.10 NotificationService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `NotificationService/GetPreferences` | POST | Self | 30/min | Get notification preferences |
| `NotificationService/SavePreferences` | POST | Self | 10/min | Save notification preferences |
| `NotificationService/ResetPreferences` | POST | Self | 5/min | Reset to default preferences |
| `NotificationService/GetUnreadCount` | POST | Self | 60/min | Get unread notification count |
| `NotificationService/GetQuietHours` | POST | Self | 30/min | Get quiet hours config |
| `NotificationService/UpdateQuietHours` | POST | Self | 10/min | Update quiet hours |
| `NotificationService/UpdateDigestFrequency` | POST | Self | 10/min | Update digest frequency |
| `NotificationService/Delete` | POST | Self | 60/min | Delete notification |
| `NotificationService/Send` | POST | Editor+ | 20/min | Send notification |
| `NotificationService/SendAlert` | POST | Manager+ | 10/min | Send alert notification |
| `NotificationService/SendReminder` | POST | Editor+ | 20/min | Send reminder |
| `NotificationService/SendBriefEmail` | POST | Editor+ | 10/min | Send brief via email |
| `NotificationService/ShareBrief` | POST | Editor+ | 10/min | Share brief with team |

### 17.11 LinkInBioService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `LinkInBioService/Save` | POST | Editor+ | 20/min | Save link-in-bio page |
| `LinkInBioService/Reorder` | POST | Editor+ | 20/min | Reorder links |
| `LinkInBioService/ToggleLink` | POST | Editor+ | 30/min | Toggle link visibility |
| `LinkInBioService/UpdateTheme` | POST | Editor+ | 10/min | Update page theme |

### 17.12 MediaKitService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `MediaKitService/GetKit` | POST | Member | 60/min | Get media kit details |

### 17.13 RateCardService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `RateCardService/GetRateCard` | POST | Manager+ | 60/min | Get rate card detail |
| `RateCardService/Save` | POST | Manager+ | 20/min | Save rate card |
| `RateCardService/DeleteItem` | POST | Manager+ | 20/min | Delete rate card item |
| `RateCardService/Reorder` | POST | Manager+ | 20/min | Reorder items |
| `RateCardService/CompareScope` | POST | Manager+ | 10/min | Compare rate across scopes |

### 17.14 BrandDealService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `BrandDealService/GetPipelineStats` | POST | Manager+ | 30/min | Get pipeline statistics |
| `BrandDealService/GetSummary` | POST | Manager+ | 30/min | Get deal summary |

### 17.15 SponsorInquiryService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `SponsorInquiryService/ListInquiries` | POST | Manager+ | 60/min | List sponsor inquiries |
| `SponsorInquiryService/Accept` | POST | Manager+ | 10/min | Accept inquiry |
| `SponsorInquiryService/Decline` | POST | Manager+ | 10/min | Decline inquiry |
| `SponsorInquiryService/Flag` | POST | Manager+ | 10/min | Flag inquiry |
| `SponsorInquiryService/GetStats` | POST | Manager+ | 30/min | Get inquiry statistics |

### 17.16 MembershipService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `MembershipService/CreatePlan` | POST | Manager+ | 10/min | Create membership plan |
| `MembershipService/ListPlans` | POST | Member | 60/min | List membership plans |
| `MembershipService/UpdatePlan` | POST | Manager+ | 20/min | Update membership plan |
| `MembershipService/DuplicatePlan` | POST | Manager+ | 10/min | Duplicate plan |
| `MembershipService/Delete` | POST | Admin+ | 5/min | Delete plan |
| `MembershipService/Archive` | POST | Manager+ | 10/min | Archive plan |
| `MembershipService/Publish` | POST | Manager+ | 10/min | Publish plan |
| `MembershipService/Pause` | POST | Manager+ | 10/min | Pause plan |
| `MembershipService/Resume` | POST | Manager+ | 10/min | Resume plan |
| `MembershipService/GetMRRSummary` | POST | Manager+ | 30/min | Get MRR summary |
| `MembershipService/GetMRRTrend` | POST | Manager+ | 30/min | Get MRR trend |

### 17.17 CreatorProService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `CreatorProService/GetDashboard` | POST | Member | 30/min | Get Creator Pro dashboard |

### 17.18 CreatorProfileService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `CreatorProfileService/GetStats` | POST | Member | 30/min | Get creator profile stats |

### 17.19 ReferralService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `ReferralService/GetDashboard` | POST | Contributor+ | 30/min | Get referral dashboard |
| `ReferralService/GetReferralLink` | POST | Contributor+ | 30/min | Get referral link |
| `ReferralService/GetStats` | POST | Contributor+ | 30/min | Get referral stats |
| `ReferralService/SendReminder` | POST | Contributor+ | 10/min | Send referral reminder |

### 17.20 ReportService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `ReportService/ExportPartnershipReport` | POST | Manager+ | 5/min | Export partnership report |

---

## 18. Extended Internal Admin RPCs

### 18.1 AdminService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `AdminService/GetDashboard` | POST | All | 30/min | Get admin dashboard |
| `AdminService/GetSystemHealth` | POST | All | 30/min | Get system health |
| `AdminService/GetRecentActivity` | POST | All | 30/min | Get recent admin activity |
| `AdminService/GetRevenueSummary` | POST | Super/Finance | 30/min | Get revenue summary |
| `AdminService/GetSupportSummary` | POST | Super/Ops | 30/min | Get support summary |
| `AdminService/GetAIOps` | POST | Super/Tech | 30/min | Get AI ops dashboard |
| `AdminService/GetWorkspaceStats` | POST | All | 30/min | Get workspace stats |
| `AdminService/ListWorkspaces` | POST | All | 30/min | List all workspaces |
| `AdminService/GetUser` | POST | All | 60/min | Get user detail |
| `AdminService/GetUserActivity` | POST | All | 30/min | Get user activity |
| `AdminService/GetUserContentStats` | POST | All | 30/min | Get user content stats |
| `AdminService/GetUserCredits` | POST | Super/Finance | 30/min | Get user credit info |
| `AdminService/GetUserSecurity` | POST | Super/Ops | 30/min | Get user security info |
| `AdminService/GetUserWorkspaces` | POST | All | 30/min | Get user workspaces |
| `AdminService/SuspendUser` | POST | Super/Ops | 5/min | Suspend user |
| `AdminService/UnsuspendUser` | POST | Super/Ops | 5/min | Unsuspend user |
| `AdminService/BulkSuspend` | POST | Super/Ops | 2/min | Bulk suspend users |
| `AdminService/DeleteUser` | POST | Super/Ops | 2/min | Delete user |
| `AdminService/ResetPassword` | POST | Super/Ops | 5/min | Reset user password |
| `AdminService/ForceLogout` | POST | Super/Ops | 5/min | Force user logout |
| `AdminService/Impersonate` | POST | Super/Ops | 2/min | Start impersonation |
| `AdminService/AdjustCredits` | POST | Super/Finance | 5/min | Adjust credits |
| `AdminService/GrantCredits` | POST | Super/Finance | 5/min | Grant credits |
| `AdminService/OverridePlan` | POST | Super/Ops | 2/min | Override plan tier |
| `AdminService/DeleteWorkspace` | POST | Super/Ops | 2/min | Delete workspace |
| `AdminService/SuspendWorkspace` | POST | Super/Ops | 5/min | Suspend workspace |
| `AdminService/UnsuspendWorkspace` | POST | Super/Ops | 5/min | Unsuspend workspace |
| `AdminService/ExportWorkspaces` | POST | Super/Ops | 2/min | Export workspace data |
| `AdminService/GetRelatedTickets` | POST | Super/Ops | 30/min | Get related support tickets |

### 18.2 AdminUserService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `AdminUserService/Invite` | POST | Super/Ops | 5/min | Invite admin user |
| `AdminUserService/Suspend` | POST | Super/Ops | 5/min | Suspend admin user |
| `AdminUserService/Reactivate` | POST | Super/Ops | 5/min | Reactivate admin user |
| `AdminUserService/ResetPassword` | POST | Super/Ops | 5/min | Reset admin password |

### 18.3 AdminManagementService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `AdminManagementService/ListAdmins` | POST | Super/Ops | 30/min | List admin users |
| `AdminManagementService/CreateAdmin` | POST | Super/Ops | 5/min | Create admin account |
| `AdminManagementService/UpdateRole` | POST | Super/Ops | 5/min | Update admin role |
| `AdminManagementService/Deactivate` | POST | Super/Ops | 5/min | Deactivate admin |
| `AdminManagementService/Reactivate` | POST | Super/Ops | 5/min | Reactivate admin |
| `AdminManagementService/GetAdminActivity` | POST | Super/Ops | 30/min | Get admin activity log |
| `AdminManagementService/GetSecurityOverview` | POST | Super/Ops | 30/min | Get security overview |
| `AdminManagementService/KillSessions` | POST | Super/Ops | 5/min | Kill all admin sessions |
| `AdminManagementService/ResetMFA` | POST | Super/Ops | 5/min | Reset admin MFA |

### 18.4 AdminAbuseService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `AdminAbuseService/ListReports` | POST | Super/Content | 30/min | List abuse reports |
| `AdminAbuseService/GetFullReport` | POST | Super/Content | 30/min | Get full report detail |
| `AdminAbuseService/GetEvidence` | POST | Super/Content | 30/min | Get report evidence |
| `AdminAbuseService/GetUserHistory` | POST | Super/Content | 30/min | Get user abuse history |
| `AdminAbuseService/GetStats` | POST | Super/Content | 30/min | Get abuse statistics |
| `AdminAbuseService/GetSLACompliance` | POST | Super/Content | 30/min | Get SLA compliance |
| `AdminAbuseService/ActionReport` | POST | Super/Content | 10/min | Take action on report |
| `AdminAbuseService/Dismiss` | POST | Super/Content | 10/min | Dismiss report |
| `AdminAbuseService/Escalate` | POST | Super/Content | 10/min | Escalate report |
| `AdminAbuseService/WarnUser` | POST | Super/Content | 10/min | Warn user |
| `AdminAbuseService/SuspendUser` | POST | Super/Content | 5/min | Suspend user for abuse |
| `AdminAbuseService/BanUser` | POST | Super/Content | 2/min | Ban user |
| `AdminAbuseService/RemoveContent` | POST | Super/Content | 10/min | Remove abusive content |
| `AdminAbuseService/BulkAction` | POST | Super/Content | 5/min | Bulk action on reports |

### 18.5 AdminFraudService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `AdminFraudService/ListCases` | POST | Super/Content | 30/min | List fraud cases |
| `AdminFraudService/SearchCases` | POST | Super/Content | 30/min | Search fraud cases |
| `AdminFraudService/CreateCase` | POST | Super/Content | 10/min | Create fraud case |
| `AdminFraudService/GetSignals` | POST | Super/Content | 30/min | Get fraud signals |
| `AdminFraudService/GetDeviceIntel` | POST | Super/Content | 30/min | Get device intelligence |
| `AdminFraudService/GetImpact` | POST | Super/Content | 30/min | Get fraud impact analysis |
| `AdminFraudService/GetMetrics` | POST | Super/Content | 30/min | Get fraud metrics |
| `AdminFraudService/ExportReport` | POST | Super/Content | 5/min | Export fraud report |
| `AdminFraudService/BulkAction` | POST | Super/Content | 5/min | Bulk action on fraud cases |

### 18.6 AdminIncidentService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `AdminIncidentService/Create` | POST | Super/Tech | 5/min | Create incident |
| `AdminIncidentService/List` | POST | Super/Tech | 30/min | List incidents |
| `AdminIncidentService/GetActive` | POST | Super/Tech | 30/min | Get active incidents |
| `AdminIncidentService/Update` | POST | Super/Tech | 10/min | Update incident |
| `AdminIncidentService/Resolve` | POST | Super/Tech | 5/min | Resolve incident |
| `AdminIncidentService/Escalate` | POST | Super/Tech | 5/min | Escalate incident |
| `AdminIncidentService/CreatePostMortem` | POST | Super/Tech | 5/min | Create post-mortem |
| `AdminIncidentService/GetMetrics` | POST | Super/Tech | 30/min | Get incident metrics |

### 18.7 AdminAIService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `AdminAIService/ListModels` | POST | Super/Tech | 30/min | List AI models |
| `AdminAIService/GetConfig` | POST | Super/Tech | 30/min | Get AI configuration |
| `AdminAIService/UpdateConfig` | POST | Super/Tech | 5/min | Update AI configuration |
| `AdminAIService/GetPrompts` | POST | Super/Tech | 30/min | Get AI prompts |
| `AdminAIService/GetPromptHistory` | POST | Super/Tech | 30/min | Get prompt version history |
| `AdminAIService/ResetPrompts` | POST | Super/Tech | 5/min | Reset prompts to defaults |
| `AdminAIService/GetRateLimits` | POST | Super/Tech | 30/min | Get AI rate limits |
| `AdminAIService/UpdateRateLimits` | POST | Super/Tech | 5/min | Update AI rate limits |
| `AdminAIService/EstimateCost` | POST | Super/Tech | 30/min | Estimate AI operation cost |
| `AdminAIService/ListABTests` | POST | Super/Tech | 30/min | List AI A/B tests |
| `AdminAIService/StopABTest` | POST | Super/Tech | 5/min | Stop A/B test |

### 18.8 AdminAnalyticsService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `AdminAnalyticsService/GetInsights` | POST | All | 30/min | Get admin analytics insights |
| `AdminAnalyticsService/GetConversionFunnel` | POST | All | 30/min | Get conversion funnel |
| `AdminAnalyticsService/GetComparison` | POST | All | 30/min | Get period comparison |
| `AdminAnalyticsService/GetCohortRetention` | POST | All | 30/min | Get cohort retention |
| `AdminAnalyticsService/GetBusinessMetrics` | POST | All | 30/min | Get business metrics |
| `AdminAnalyticsService/GetMRRTrend` | POST | Super/Finance | 30/min | Get MRR trend |
| `AdminAnalyticsService/Export` | POST | All | 5/min | Export analytics |

### 18.9 AdminRevenueService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `AdminRevenueService/GetSummary` | POST | Super/Finance | 30/min | Get revenue summary |
| `AdminRevenueService/GetTrend` | POST | Super/Finance | 30/min | Get revenue trend |
| `AdminRevenueService/GetComparison` | POST | Super/Finance | 30/min | Get revenue comparison |
| `AdminRevenueService/GetPaymentHealth` | POST | Super/Finance | 30/min | Get payment health |
| `AdminRevenueService/ListTransactions` | POST | Super/Finance | 30/min | List transactions |
| `AdminRevenueService/RetryPayment` | POST | Super/Finance | 5/min | Retry failed payment |
| `AdminRevenueService/Export` | POST | Super/Finance | 5/min | Export revenue data |

### 18.10 AdminCreditService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `AdminCreditService/GetPoolStatus` | POST | Super/Finance | 30/min | Get credit pool status |
| `AdminCreditService/GetPlanAllocations` | POST | Super/Finance | 30/min | Get plan allocations |
| `AdminCreditService/GetConsumptionTrend` | POST | Super/Finance | 30/min | Get consumption trend |
| `AdminCreditService/ListTransactions` | POST | Super/Finance | 30/min | List credit transactions |
| `AdminCreditService/Grant` | POST | Super/Finance | 5/min | Grant credits to user |
| `AdminCreditService/BulkGrant` | POST | Super/Finance | 2/min | Bulk grant credits |
| `AdminCreditService/Revoke` | POST | Super/Finance | 5/min | Revoke credits |
| `AdminCreditService/UpdateAllocations` | POST | Super/Finance | 5/min | Update allocations |
| `AdminCreditService/Export` | POST | Super/Finance | 5/min | Export credit data |

### 18.11 AdminFeeService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `AdminFeeService/ListRules` | POST | Super/Finance | 30/min | List fee rules |
| `AdminFeeService/CreateRule` | POST | Super/Finance | 5/min | Create fee rule |
| `AdminFeeService/UpdateRule` | POST | Super/Finance | 5/min | Update fee rule |
| `AdminFeeService/DeactivateRule` | POST | Super/Finance | 5/min | Deactivate fee rule |
| `AdminFeeService/DeleteRule` | POST | Super/Finance | 2/min | Delete fee rule |
| `AdminFeeService/GetHistory` | POST | Super/Finance | 30/min | Get fee history |
| `AdminFeeService/GetRevenueStats` | POST | Super/Finance | 30/min | Get fee revenue stats |
| `AdminFeeService/SimulateImpact` | POST | Super/Finance | 10/min | Simulate fee impact |

### 18.12 AdminConfigService (Extended)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `AdminConfigService/GetPricing` | POST | Super/Finance | 30/min | Get pricing config |
| `AdminConfigService/GetAIRates` | POST | Super/Tech | 30/min | Get AI credit rates |
| `AdminConfigService/GetRateLimits` | POST | Super/Tech | 30/min | Get rate limits |
| `AdminConfigService/GetMaintenance` | POST | Super/Tech | 30/min | Get maintenance config |
| `AdminConfigService/GetChangeHistory` | POST | All | 30/min | Get config change history |
| `AdminConfigService/UpdateTier` | POST | Super/Finance | 5/min | Update tier configuration |
| `AdminConfigService/UpdateCreditRate` | POST | Super/Finance | 5/min | Update credit rate |
| `AdminConfigService/UpdateRateLimit` | POST | Super/Tech | 5/min | Update rate limit |
| `AdminConfigService/UpdateEmailTemplate` | POST | Super/Ops | 5/min | Update email template |

### 18.13 AdminBroadcastService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `AdminBroadcastService/Send` | POST | Super/Ops | 5/min | Send broadcast |
| `AdminBroadcastService/SendNow` | POST | Super/Ops | 5/min | Send immediately |
| `AdminBroadcastService/SendTest` | POST | Super/Ops | 10/min | Send test broadcast |
| `AdminBroadcastService/Schedule` | POST | Super/Ops | 5/min | Schedule broadcast |
| `AdminBroadcastService/Cancel` | POST | Super/Ops | 10/min | Cancel scheduled |
| `AdminBroadcastService/PreviewEmail` | POST | Super/Ops | 30/min | Preview email |
| `AdminBroadcastService/EstimateReach` | POST | Super/Ops | 30/min | Estimate reach |
| `AdminBroadcastService/ListScheduled` | POST | Super/Ops | 30/min | List scheduled |
| `AdminBroadcastService/ListHistory` | POST | Super/Ops | 30/min | List broadcast history |

### 18.14 AdminCommerceService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `AdminCommerceService/AddNote` | POST | Super/Ops | 20/min | Add note to case |
| `AdminCommerceService/EscalateDispute` | POST | Super/Ops | 10/min | Escalate dispute |
| `AdminCommerceService/ResolveDispute` | POST | Super/Ops | 10/min | Resolve dispute |

### 18.15 AdminComplianceService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `AdminComplianceService/GetStats` | POST | Super/Ops | 30/min | Get compliance stats |
| `AdminComplianceService/ListRequests` | POST | Super/Ops | 30/min | List compliance requests (GDPR) |
| `AdminComplianceService/GetRequest` | POST | Super/Ops | 30/min | Get request detail |
| `AdminComplianceService/ApproveDeletion` | POST | Super/Ops | 5/min | Approve data deletion |
| `AdminComplianceService/RejectRequest` | POST | Super/Ops | 5/min | Reject request |
| `AdminComplianceService/GenerateExport` | POST | Super/Ops | 5/min | Generate data export |
| `AdminComplianceService/GetUserConsents` | POST | Super/Ops | 30/min | Get user consents |
| `AdminComplianceService/GetBreaches` | POST | Super/Ops | 30/min | List data breaches |
| `AdminComplianceService/CreateBreach` | POST | Super/Ops | 5/min | Create breach report |
| `AdminComplianceService/GetDPALog` | POST | Super/Ops | 30/min | Get DPA audit log |
| `AdminComplianceService/ExportDPA` | POST | Super/Ops | 5/min | Export DPA report |

### 18.16 AdminJobService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `AdminJobService/GetQueueStats` | POST | Super/Tech | 30/min | Get queue statistics |
| `AdminJobService/GetQueueHistory` | POST | Super/Tech | 30/min | Get queue history |
| `AdminJobService/ListJobs` | POST | Super/Tech | 30/min | List jobs |
| `AdminJobService/GetJob` | POST | Super/Tech | 60/min | Get job detail |
| `AdminJobService/PauseJob` | POST | Super/Tech | 10/min | Pause job |
| `AdminJobService/KillJob` | POST | Super/Tech | 5/min | Kill job |
| `AdminJobService/RetryJob` | POST | Super/Tech | 10/min | Retry failed job |
| `AdminJobService/RetryAllFailed` | POST | Super/Tech | 2/min | Retry all failed |
| `AdminJobService/ListDLQ` | POST | Super/Tech | 30/min | List dead-letter queue items |
| `AdminJobService/GetDLQItem` | POST | Super/Tech | 60/min | Get DLQ item detail + retry history |
| `AdminJobService/RetryDLQItem` | POST | Super/Tech | 10/min | Retry a dead-lettered job |
| `AdminJobService/PurgeDLQItem` | POST | Super/Tech | 5/min | Discard a DLQ item after review |
| `AdminJobService/ClearCompleted` | POST | Super/Tech | 5/min | Clear completed jobs |
| `AdminJobService/StreamLogs` | POST | Super/Tech | 10/min | Stream job logs |

### 18.17 AdminAlertService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `AdminAlertService/GetActive` | POST | All | 30/min | Get active alerts |
| `AdminAlertService/Dismiss` | POST | All | 30/min | Dismiss alert |

### 18.18 AdminEmailService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `AdminEmailService/Send` | POST | Super/Ops | 10/min | Send admin email |

---

## 19. Operational & Utility Services

### 19.1 TaskService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `TaskService/CreateTask` | POST | Contributor+ | 20/min | Create task |
| `TaskService/ListTasks` | POST | Member | 60/min | List tasks |
| `TaskService/GetTaskDetail` | POST | Member | 60/min | Get task detail |
| `TaskService/GetTaskComments` | POST | Member | 60/min | Get task comments |
| `TaskService/AddComment` | POST | Contributor+ | 30/min | Add comment to task |
| `TaskService/UpdateStatus` | POST | Editor+ | 30/min | Update task status |
| `TaskService/UpdateSubtask` | POST | Editor+ | 30/min | Update subtask |
| `TaskService/Complete` | POST | Editor+ | 30/min | Complete task |
| `TaskService/Uncomplete` | POST | Editor+ | 30/min | Un-complete task |
| `TaskService/Reassign` | POST | Manager+ | 10/min | Reassign task |
| `TaskService/Delete` | POST | Manager+ | 10/min | Delete task |
| `TaskService/Snooze` | POST | Editor+ | 20/min | Snooze task |
| `TaskService/GetSummary` | POST | Member | 30/min | Get task summary |

### 19.2 QueueService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `QueueService/GetSummary` | POST | Member | 30/min | Get queue summary |
| `QueueService/List` | POST | Member | 60/min | List queue items |
| `QueueService/ListActive` | POST | Member | 60/min | List active items |
| `QueueService/ListCompleted` | POST | Member | 60/min | List completed items |
| `QueueService/ListFailed` | POST | Member | 60/min | List failed items |
| `QueueService/ListHistory` | POST | Member | 60/min | List queue history |
| `QueueService/Cancel` | POST | Editor+ | 10/min | Cancel queued item |
| `QueueService/Retry` | POST | Editor+ | 10/min | Retry failed item |
| `QueueService/Pause` | POST | Editor+ | 10/min | Pause queue item |
| `QueueService/Resume` | POST | Editor+ | 10/min | Resume paused item |

### 19.3 DiagnosticsService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `DiagnosticsService/GetOverview` | POST | Admin+ | 30/min | Get diagnostics overview |
| `DiagnosticsService/GetHealthGrid` | POST | Admin+ | 30/min | Get health grid |
| `DiagnosticsService/ListIssues` | POST | Admin+ | 30/min | List diagnostic issues |
| `DiagnosticsService/RunFullCheck` | POST | Admin+ | 5/min | Run full diagnostic check |
| `DiagnosticsService/ExecuteRepairStep` | POST | Admin+ | 5/min | Execute repair step |

### 19.4 SupportService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `SupportService/CreateTicket` | POST | Contributor+ | 10/min | Create support ticket |
| `SupportService/GetMyTickets` | POST | Contributor+ | 60/min | Get my support tickets |
| `SupportService/GetTicket` | POST | Contributor+ | 60/min | Get ticket detail for owner/admin |
| `SupportService/ListMessages` | POST | Contributor+ | 60/min | List ticket conversation messages |
| `SupportService/Reply` | POST | Contributor+ | 20/min | Reply to ticket conversation |
| `SupportService/Assign` | POST | Manager+ | 10/min | Assign ticket |
| `SupportService/Escalate` | POST | Manager+ | 10/min | Escalate ticket |
| `SupportService/Close` | POST | Manager+ | 10/min | Close ticket with resolution summary |
| `SupportService/UploadAttachment` | POST | Contributor+ | 20/min | Upload attachment |

### 19.5 KBService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `KBService/Search` | POST | Member | 60/min | Full-text search KB articles |
| `KBService/GetCategories` | POST | Member | 60/min | Get KB categories |
| `KBService/GetCategoryCounts` | POST | Member | 60/min | Get article counts |
| `KBService/GetPopularArticles` | POST | Member | 60/min | Get popular articles |
| `KBService/ListRecent` | POST | Member | 60/min | Get recently viewed or recently updated articles |
| `KBService/GetArticle` | POST | Member | 120/min | Get article detail |
| `KBService/GetRelated` | POST | Member | 60/min | Get related KB articles |
| `KBService/RateArticle` | POST | Member | 30/min | Rate article |

### 19.5A KBAdminService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `KBAdminService/ListArticles` | POST | Super/Support | 30/min | List KB articles including drafts |
| `KBAdminService/GetArticle` | POST | Super/Support | 60/min | Get editable KB article detail |
| `KBAdminService/CreateArticle` | POST | Super/Support | 10/min | Create KB article draft |
| `KBAdminService/UpdateArticle` | POST | Super/Support | 10/min | Update KB article draft |
| `KBAdminService/PublishArticle` | POST | Super/Support | 5/min | Publish KB article |
| `KBAdminService/ArchiveArticle` | POST | Super/Support | 5/min | Archive KB article |
| `KBAdminService/ListStaleArticles` | POST | Super/Support | 30/min | List articles needing 90-day review |
| `KBAdminService/GetVersionHistory` | POST | Super/Support | 30/min | Get article version history |

### 19.6 FileService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `FileService/Upload` | POST | Editor+ | 20/min | Upload file |
| `FileService/GetMetadata` | POST | Member | 60/min | Get file metadata |

### 19.7 UploadService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `UploadService/Upload` | POST | Editor+ | 20/min | Upload file (generic) |

### 19.8 SearchService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `SearchService/Query` | POST | Member | 60/min | Global search query |

### 19.9 ShortUrlService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `ShortUrlService/Generate` | POST | Editor+ | 20/min | Generate short URL |

### 19.10 DataService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `DataService/RequestExport` | POST | Manager+ | 5/min | Request data export |
| `DataService/GetExportUrl` | POST | Manager+ | 30/min | Get export download URL |

### 19.11 UsageService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `UsageService/GetBreakdown` | POST | Member | 30/min | Get usage breakdown |
| `UsageService/GetStorageUsage` | POST | Member | 30/min | Get storage usage |

### 19.12 SyncService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `SyncService/GetHistory` | POST | Member | 60/min | Get sync history |

### 19.13 AlertService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `AlertService/GetActive` | POST | Member | 60/min | Get active alerts |
| `AlertService/Dismiss` | POST | Member | 60/min | Dismiss alert |

### 19.14 ErrorLogService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `ErrorLogService/GetRecent` | POST | Admin+ | 30/min | Get recent error logs |

### 19.15 EventService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `EventService/create` | POST | Editor+ | 30/min | Create calendar event |

### 19.16 FeatureFlagService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `FeatureFlagService/Create` | POST | Admin+ | 5/min | Create feature flag |
| `FeatureFlagService/Update` | POST | Admin+ | 10/min | Update feature flag |
| `FeatureFlagService/Toggle` | POST | Admin+ | 10/min | Toggle feature flag |
| `FeatureFlagService/Archive` | POST | Admin+ | 5/min | Archive feature flag |

### 19.17 TrustService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `TrustService/GetScore` | POST | Member | 30/min | Get workspace trust score |

### 19.18 UserPreferencesService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `UserPreferencesService/Update` | POST | Self | 20/min | Update user preferences |

### 19.19 NavigationService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `NavigationService/pushThread` | POST | Member | 60/min | Push thread to navigation |

### 19.20 QuickEditService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `QuickEditService/SaveDraft` | POST | Editor+ | 30/min | Save quick edit draft |

---

## 20. Final Coverage RPCs

> Last batch of screen-referenced RPCs promoted to canonical status (2026-04-06). These close the remaining 44-RPC gap.

### 20.1 ABTestService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `ABTestService/EvaluateTest` | POST | Manager+ | 10/min | Evaluate A/B test results |
| `ABTestService/GetMetrics` | POST | Member | 30/min | Get A/B test metrics |

### 20.2 APIKeyService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `APIKeyService/Create` | POST | Admin+ | 5/min | Create API key |
| `APIKeyService/List` | POST | Admin+ | 30/min | List API keys |
| `APIKeyService/Revoke` | POST | Admin+ | 10/min | Revoke API key |
| `APIKeyService/Rotate` | POST | Admin+ | 5/min | Rotate API key |
| `APIKeyService/GetUsage` | POST | Admin+ | 30/min | Get API key usage |
| `APIKeyService/GetUsageStats` | POST | Admin+ | 30/min | Get API key usage statistics |
| `APIKeyService/UpdateScopes` | POST | Admin+ | 10/min | Update API key scopes |

### 20.3 ActivityService

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `ActivityService/List` | POST | Member | 60/min | List workspace activity feed |

### 20.4 AffiliateService (Extended — Final)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `AffiliateService/Create` | POST | Editor+ | 10/min | Create affiliate link |
| `AffiliateService/Delete` | POST | Editor+ | 10/min | Delete affiliate link |
| `AffiliateService/ListLinks` | POST | Member | 60/min | List affiliate links |
| `AffiliateService/Pause` | POST | Editor+ | 20/min | Pause affiliate link |
| `AffiliateService/Resume` | POST | Editor+ | 20/min | Resume affiliate link |
| `AffiliateService/GetKPIs` | POST | Member | 30/min | Get affiliate KPIs |
| `AffiliateService/GetSourceContent` | POST | Member | 30/min | Get content linked to affiliate |
| `AffiliateService/ExportReport` | POST | Manager+ | 5/min | Export affiliate report |

### 20.5 ApprovalService (Extended — Final)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `ApprovalService/BatchApprove` | POST | Manager+ | 5/min | Batch approve items |
| `ApprovalService/UndoApprove` | POST | Manager+ | 10/min | Undo approval |
| `ApprovalService/UndoReject` | POST | Manager+ | 10/min | Undo rejection |

### 20.6 AssetService (Extended — Final)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `AssetService/AutoCrop` | POST | Editor+ | 10/min | Auto-crop asset to platform specs |
| `AssetService/ExtractFrames` | POST | Editor+ | 10/min | Extract frames from video |
| `AssetService/GetDownloadURL` | POST | Member | 60/min | Get signed download URL |
| `AssetService/GetPreview` | POST | Member | 120/min | Get asset preview |
| `AssetService/ListRecent` | POST | Member | 60/min | List recently uploaded assets |

### 20.7 BrandDealService (Extended — Final)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `BrandDealService/ListDeals` | POST | Manager+ | 60/min | List brand deals |
| `BrandDealService/ListPartnerships` | POST | Manager+ | 60/min | List partnerships |
| `BrandDealService/UpdateDeliverable` | POST | Editor+ | 20/min | Update deal deliverable |
| `BrandDealService/UpdatePayment` | POST | Manager+ | 10/min | Update deal payment status |

### 20.8 CampaignService (Extended — Final)

| RPC | Method | Auth | Rate Limit | Description |
|---|---|---|---|---|
| `CampaignService/Delete` | POST | Manager+ | 5/min | Delete campaign |
| `CampaignService/Resume` | POST | Manager+ | 10/min | Resume paused campaign |
| `CampaignService/AddCost` | POST | Editor+ | 20/min | Add cost to campaign |
| `CampaignService/GetCosts` | POST | Member | 30/min | Get campaign costs |
| `CampaignService/GetFunnel` | POST | Member | 30/min | Get campaign funnel data |
| `CampaignService/GetMetrics` | POST | Member | 30/min | Get campaign metrics |
| `CampaignService/GetLinkedContent` | POST | Member | 30/min | Get content linked to campaign |
| `CampaignService/GetLinkedOffers` | POST | Member | 30/min | Get offers linked to campaign |
| `CampaignService/GetPlatformBreakdown` | POST | Member | 30/min | Get platform breakdown |
| `CampaignService/GetRevenueTimeline` | POST | Member | 30/min | Get revenue timeline |
| `CampaignService/GetTopProducts` | POST | Member | 30/min | Get top products in campaign |
| `CampaignService/LinkContent` | POST | Editor+ | 20/min | Link content to campaign |
| `CampaignService/LinkOffer` | POST | Editor+ | 20/min | Link offer to campaign |
| `CampaignService/UnlinkContent` | POST | Editor+ | 20/min | Unlink content from campaign |

---

**Total: ~1,160 canonical RPC definitions** across all sections (§2-§20) + 6 webhook endpoints + 14 public API endpoints.

> **Note**: This document is the canonical API contract for Creativanta. All screen-referenced RPCs have been promoted to canonical status with method, auth, rate limit, and description. The `screen_api_reconciliation.md` document should be updated to reflect this closure.

> **JSON Examples**: See companion file [`api_examples.md`](./api_examples.md) for 24 concrete request/response payloads covering Auth, Trends, Scripts, Generation, Publish, Threads, Products, Orders, Offers, Coupons, Profit, Reconciliation, Workflows, LiveCommerce, Seeding, Credits, Admin, Capability, Referral, VoiceClone, Error responses, and Pagination conventions.
