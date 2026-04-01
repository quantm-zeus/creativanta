---
layer: contracts
canonical: true
source_file: impl_a3_api_endpoint_map.md
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
| §2.1 Identity & Workspace | ~15 RPCs: Auth, Workspace, Connector, User services |
| §2.2 Intelligence | ~12 RPCs: Trend, Competitor, Opportunity services |
| §2.3 Content | ~25 RPCs: Idea, Script, Asset, Character, Continuity, Derivative services |
| §2.4 Publish | ~15 RPCs: Packaging, Publish, Approval services |
| §2.5 Engagement | ~18 RPCs: Thread, Entity, Suggestion, FollowUp services |
| §2.6 Commerce | 42 RPCs: Product (8), Offer (9), Order (5), Campaign (7), Affiliate (6), Store (5), Coupon (6) |
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
| `RecipeService/Install` | POST | Manager+ | 10/min | Install recipe from marketplace |
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

Rate limit: 100 req/min (read), 30 req/min (write) per API key. IP-based secondary limit: 1000/min. OAuth2 for third-party apps (Phase 2).

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

**Total: ~473 RPCs** (15 Identity + 12 Intelligence + 29 Content + 19 Publish + 18 Engagement + 42 Commerce + 26 Finance + 87 Other Domains + 40 Extended Production + 5 Gamification + 5 Platform Health + 28 Admin-Internal + 13 Creator Pro) + 6 webhook endpoints + 14 public API endpoints

> **JSON Examples**: See companion file [`api_examples.md`](./api_examples.md) for 24 concrete request/response payloads covering Auth, Trends, Scripts, Generation, Publish, Threads, Products, Orders, Offers, Coupons, Profit, Reconciliation, Workflows, LiveCommerce, Seeding, Credits, Admin, Capability, Referral, VoiceClone, Error responses, and Pagination conventions.
