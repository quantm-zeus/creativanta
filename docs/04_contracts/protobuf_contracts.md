---
layer: contracts
canonical: true
source_file: protobuf_contracts.md  # was impl_a2_protobuf_contracts.md (legacy name)
last_verified: 2026-04-06
known_issues: []  # API-C-001, API-H-001, API-H-002 all RESOLVED 2026-04-02
do_not_edit_without: Đọc 00_index/OPEN_BLOCKERS.md trước khi sửa
last_updated: 2026-10-30
---

## Quick Navigation

| Section | Content |
|---|---|
| §1 Proto File Structure | Directory layout: common, identity, intelligence, content, publish, engagement, commerce, finance, workflow, live, seeding, copilot, admin, gamification, connector, creator_pro, internal_admin |
| §2 Common Types | UUID, Money, Timestamp, Pagination, SourceClass, ConfidenceBand, OperatorMode |
| §3 Key Service Definitions | WorkspaceService, IdeaService, ScriptService, AssetService, PublishService, CopilotService, ProfitService |
| §4 Code Generation | proto-gen.sh script for Go, TypeScript, Dart |
| §5 Service Count Summary | Overview only. `api_endpoint_map.md` is the authoritative RPC inventory; actual `.proto` files are not committed yet. |

# A2 — Protobuf Contract Definitions (Overview & Key Services)

> **Upstream**: Tech Stack ADR v4 (ADR-002, ADR-005), Product Freeze
> **Protocol**: gRPC (mobile↔API) + ConnectRPC (web↔API) + REST (webhooks/public API)
> **Location**: `/protos/` — authored incrementally from implementation P0. No actual `.proto` files are committed in the repository yet; this document is the transport/codegen overview derived from the canonical authoring set (`api_endpoint_map.md` + `api_examples.md`).

---

## 1. Proto File Structure

```
protos/
├── common/
│   ├── types.proto          # UUID, Timestamp, Money, Pagination, SourceClass
│   └── errors.proto         # Error codes, ErrorDetail
├── identity/
│   ├── auth.proto           # Login, Session, TokenRefresh
│   ├── workspace.proto      # Workspace CRUD, Settings, Members
│   └── user.proto           # UserProfile, Preferences
├── intelligence/
│   ├── trend.proto          # Trend, Signal, Watchlist
│   ├── competitor.proto     # Competitor, Benchmark
│   └── opportunity.proto    # Opportunity CRUD, Convert
├── content/
│   ├── idea.proto           # Idea CRUD, Generate, Convert
│   ├── script.proto         # Script CRUD, Approve, AssetBrief
│   ├── asset.proto          # Asset CRUD, Generation, Approve
│   ├── character.proto      # Character, ContinuityPack
│   └── derivative.proto     # Derivative management (M09)
├── publish/
│   ├── packaging.proto      # PackagingScore, ComplianceScan
│   ├── publish.proto        # PublishItem, PublishJob, Schedule
│   └── queue.proto          # QueueItem, QueueManagement
├── engagement/
│   ├── thread.proto         # Thread, Message, FollowUpTask
│   ├── entity.proto         # Person/Entity, Relationship
│   └── suggestion.proto     # SuggestedReply, IntentClassification
├── commerce/
│   ├── product.proto        # Product, SKU, Inventory
│   ├── offer.proto          # Offer, Coupon, Bundle
│   ├── order.proto          # Order, Refund, Return
│   ├── campaign.proto       # Campaign CRUD
│   ├── affiliate.proto      # AffiliateLink, Commission
│   └── store.proto          # StorePage, Membership
├── finance/
│   ├── settlement.proto     # Settlement, Reconciliation
│   ├── cost.proto           # CostItem, ProfitSnapshot
│   ├── evidence.proto       # Evidence, ProofBundle
│   └── profit.proto         # ProfitQuery, ProfitDrilldown
├── workflow/
│   ├── workflow.proto       # Workflow CRUD, Trigger
│   ├── workflow_run.proto   # Run, Approve, Inspect
│   ├── recipe.proto         # RecipeTemplate, Install
│   └── agent.proto          # AgentRun, Plan, Handoff
├── live/
│   └── live.proto           # LiveSession, CueCard, Highlight
├── seeding/
│   └── sample.proto         # SampleRequest, Shipment, CreatorAssign
├── copilot/
│   └── copilot.proto        # CopilotQuery, StreamResponse
├── admin/
│   ├── billing.proto        # BillingEvent, CreditTransaction
│   ├── diagnostics.proto    # DiagnosticsRecord, RepairAction
│   ├── report.proto         # ReportDefinition, ReportOutput
│   ├── notification.proto   # Notification CRUD
│   └── capability.proto     # CapabilitySnapshot, PolicyNote
├── gamification/
│   └── achievement.proto    # Progress, Achievement, XP
├── connector/
│   └── connector.proto      # ConnectedAccount, SyncStatus, CapabilityCheck
├── creator_pro/
│   ├── link_in_bio.proto    # Page CRUD, LinkItem, Analytics
│   ├── media_kit.proto      # MediaKit Generate, Export
│   ├── rate_card.proto      # RateCard CRUD, AI Suggest
│   └── brand_deal.proto     # BrandDeal CRUD, Status, Deadline
└── internal_admin/          # admin.creativanta.app only
    ├── admin_auth.proto      # AdminLogin, MFA, Impersonation
    ├── user_mgmt.proto       # UserSuspend, CreditAdjust, PlanOverride
    ├── moderation.proto      # ModerationCase CRUD, Actions
    ├── fraud.proto           # FraudCase, Investigation, Resolution
    ├── support_admin.proto   # TicketQueue, Assign, Escalate
    ├── incident.proto        # Incident CRUD, PostMortem
    └── system_config.proto   # FeatureFlags, Announcements, Maintenance
```

---

## 2. Common Types

```protobuf
syntax = "proto3";
package creativanta.common;

message UUID {
  string value = 1;
}

message Money {
  string amount = 1;       // Decimal as string "1234567.89"
  string currency = 2;     // "VND", "USD"
}

message Timestamp {
  int64 seconds = 1;
  int32 nanos = 2;
}

message Pagination {
  int32 page_size = 1;     // max 100
  string page_token = 2;   // cursor-based
}

message PaginatedResponse {
  string next_page_token = 1;
  int32 total_count = 2;
  bool has_more = 3;
}

enum SourceClass {
  SOURCE_CLASS_UNSPECIFIED = 0;
  OFFICIAL = 1;
  IMPORTED = 2;
  INFERRED = 3;
  ESTIMATED = 4;
  UNRECONCILED = 5;
}

enum ConfidenceBand {
  CONFIDENCE_UNSPECIFIED = 0;
  HIGH = 1;
  MEDIUM_HIGH = 2;
  MEDIUM = 3;
  LOW_MEDIUM = 4;
  LOW = 5;
}

enum OperatorMode {
  MODE_UNSPECIFIED = 0;
  CREATOR = 1;
  SELLER = 2;
  AFFILIATE_OPERATOR = 3;
  LIVE_OPERATOR = 4;
  AGENCY_MCN = 5;
  BRAND_COLLABORATION = 6;
}
```

---

## 3. Key Service Definitions (Examples)

### 3.1 WorkspaceService
```protobuf
service WorkspaceService {
  rpc CreateWorkspace(CreateWorkspaceRequest) returns (Workspace);
  rpc GetWorkspace(GetWorkspaceRequest) returns (Workspace);
  rpc UpdateWorkspace(UpdateWorkspaceRequest) returns (Workspace);
  rpc ListMembers(ListMembersRequest) returns (ListMembersResponse);
  rpc InviteMember(InviteMemberRequest) returns (WorkspaceMember);
  rpc UpdateMemberRole(UpdateMemberRoleRequest) returns (WorkspaceMember);
  rpc RemoveMember(RemoveMemberRequest) returns (google.protobuf.Empty);
  rpc ConnectAccount(ConnectAccountRequest) returns (ConnectedAccount);
  rpc DisconnectAccount(DisconnectAccountRequest) returns (google.protobuf.Empty);
  rpc ListConnectedAccounts(ListAccountsRequest) returns (ListAccountsResponse);
}
```

### 3.2 ContentService
```protobuf
service IdeaService {
  rpc CreateIdea(CreateIdeaRequest) returns (Idea);
  rpc ListIdeas(ListIdeasRequest) returns (ListIdeasResponse);
  rpc GenerateIdeas(GenerateIdeasRequest) returns (stream Idea);
  rpc ConvertIdea(ConvertIdeaRequest) returns (ConvertIdeaResponse);
}

service ScriptService {
  rpc CreateScript(CreateScriptRequest) returns (Script);
  rpc GetScript(GetScriptRequest) returns (Script);
  rpc UpdateScript(UpdateScriptRequest) returns (Script);
  rpc SubmitForApproval(SubmitApprovalRequest) returns (Script);
  rpc ApproveScript(ApproveScriptRequest) returns (Script);
  rpc RejectScript(RejectScriptRequest) returns (Script);
}

service AssetService {
  rpc GenerateAsset(GenerateAssetRequest) returns (GenerationJob);
  rpc GetGenerationStatus(GetStatusRequest) returns (GenerationJob);
  rpc ListAssets(ListAssetsRequest) returns (ListAssetsResponse);
  rpc ApproveAsset(ApproveAssetRequest) returns (Asset);
  rpc PromoteCanonical(PromoteRequest) returns (Asset);
}
```

### 3.3 PublishService
```protobuf
service PublishService {
  rpc CreatePublishItem(CreatePublishItemRequest) returns (PublishItem);
  rpc SchedulePublish(ScheduleRequest) returns (PublishItem);
  rpc ExecutePublish(ExecuteRequest) returns (PublishJob);
  rpc RetryPublish(RetryRequest) returns (PublishJob);
  rpc CancelPublish(CancelRequest) returns (PublishItem);
  rpc GetPublishLogs(GetLogsRequest) returns (ListPublishLogsResponse);
}
```

### 3.4 CopilotService (Streaming)
```protobuf
service CopilotService {
  rpc Query(CopilotQueryRequest) returns (stream CopilotChunk);
  rpc SuggestActions(SuggestRequest) returns (ActionSuggestions);
}

message CopilotQueryRequest {
  string query = 1;
  string mode = 2;            // creative, analytics, action, help
  string context_scope = 3;   // current page/module context
  repeated string context_ids = 4;
}

message CopilotChunk {
  string text = 1;
  bool is_final = 2;
  repeated SuggestedAction actions = 3;
  int32 credits_used = 4;
}
```

### 3.5 ProfitService
```protobuf
service ProfitService {
  rpc GetProfitSummary(ProfitSummaryRequest) returns (ProfitSnapshot);
  rpc DrillDown(ProfitDrilldownRequest) returns (ProfitDrilldownResponse);
  rpc GetAnomalies(GetAnomaliesRequest) returns (ListAnomaliesResponse);
  rpc GetReconciliationQueue(ReconciliationQueueRequest) returns (ReconciliationQueueResponse);
}
```

---

## 4. Code Generation

P0 extracts this configuration to root `buf.gen.yaml`, pins each local plugin executable in the tool manifest and commits matching `go_package` options in each project proto. Dependency proto modules keep their own package options. Do not install `@latest` during generation.

```yaml
version: v2
plugins:
  - local: protoc-gen-go
    out: apps/api/gen
    opt: paths=source_relative
  - local: protoc-gen-connect-go
    out: apps/api/gen
    opt: paths=source_relative
  - local: protoc-gen-es
    out: packages/shared-types/src
    opt: target=ts
  - local: protoc-gen-dart
    out: apps/mobile/lib/generated
    opt: grpc
```

```bash
#!/usr/bin/env bash
# tooling/proto-gen.sh — P0 must create the executable and pinned buf config.
set -euo pipefail
cd "$(dirname "$0")/.."
buf lint
buf generate --template buf.gen.yaml
# buf.gen.yaml invokes ALL pinned generators: protoc-gen-go,
# protoc-gen-connect-go, protoc-gen-es, and protoc-gen-dart (grpc option).
# Outputs: apps/api/gen, packages/shared-types/src, apps/mobile/lib/generated.
(cd apps/api && go test ./gen/...)
pnpm --dir packages/shared-types check
(cd apps/mobile && dart analyze lib/generated)
git diff --exit-code -- apps/api/gen packages/shared-types/src apps/mobile/lib/generated
test -z "$(git ls-files --others --exclude-standard -- apps/api/gen packages/shared-types/src apps/mobile/lib/generated)"
```

---

P0 pins module import path `github.com/quantm-zeus/creativanta/apps/api` and sets matching `go_package` options under `/gen`. `protoc-gen-go` generates messages; `protoc-gen-connect-go` generates handlers and clients. The Go Connect handlers serve Connect, gRPC and gRPC-Web; Flutter keeps grpc-dart over HTTP/2. Do not generate a second parallel server stack for the same service. Test a TS Connect request and a Dart gRPC request against the same Go service, including errors, metadata, deadlines and streaming. Infrastructure must preserve HTTP/2 for mobile gRPC; proxy/CORS/auth rules remain explicit.

Generators are pinned in a committed Buf/tool manifest, including plugin version/revision and the Dart gRPC option. The script runs after current-slice generated outputs are committed; CI also rejects untracked generated files. Initial authoring creates and reviews the output before accepting D1. Buf generation does not generate application validation, authorization or domain logic automatically.

## 5. Service Count Summary

| Domain | Services | Key RPCs |
|---|---|---|
| Identity | 3 | ~15 |
| Intelligence | 3 | ~12 |
| Content | 5 | ~25 |
| Publish | 3 | ~15 |
| Engagement | 3 | ~18 |
| Commerce | 6 | ~30 |
| Finance | 4 | ~20 |
| Workflow | 4 | ~18 |
| Live | 1 | ~10 |
| Seeding | 1 | ~8 |
| Copilot | 1 | ~5 |
| Admin | 5 | ~25 |
| Gamification | 1 | ~6 |
| Connector | 1 | ~8 |
| Creator Pro (S16) | 4 | ~20 |
| Internal Admin (S26) | 7 | ~35 |
| Extended Production (M07) | — (in Content) | ~40 |
| Platform Health (M22) | — (in Admin) | ~8 |
| **TOTAL** | **Implementation-generated** | **See `api_endpoint_map.md` for the authoritative current RPC inventory** |

> **Note**: Internal Admin protos are NOT exposed via public ConnectRPC gateway. They use a separate admin-only gRPC endpoint protected by VPN + admin MFA.
> **Truthfulness rule**: This section is illustrative only. Until `.proto` files are generated, implementers MUST treat `api_endpoint_map.md` as the authoritative RPC count and `api_examples.md` as the authoritative payload companion.

---

## 6. Phase-Gated `.proto` Authoring & Service Consolidation Contract

To prevent contract bloat when generating physical `.proto` files from `api_endpoint_map.md`:

1. **Phase-gated contract authoring**:
   - Follow [Implementation Order](../00_index/IMPLEMENTATION_ORDER.md), not historical phase labels. P0: common/identity + credit/capability/admin-auth core; P1: commerce/finance core; P2: intelligence; P3: content/continuity; P4: production; P5: publish/engagement; P6: remaining commerce/live/seeding/creator-pro; P7: workflows/agents/public API; P8: remaining projections/admin/help/referral/gamification.
   - A module starting early receives incremental message additions in later phases. Commit and compile the current slice's `.proto` files before implementing endpoints or screens; do not generate the whole inventory in advance.
2. **Merging Split Service Sections**:
   - Services that appear in both Core (`§2–§9`) and Extended/Final sections (`§10–§20`) of `api_endpoint_map.md` (e.g., `WorkspaceService`, `IdeaService`, `ScriptService`, `AssetService`, `PublishService`, `ProductService`, `OfferService`, `OrderService`, `CampaignService`, `AffiliateService`, `ProfitService`, `ReconciliationService`, `WorkflowService`, `SeedingService`, `BrandDealService`) MUST be consolidated into **a single `service <Name> { ... }` block** inside their canonical `.proto` file. Never create separate `*ExtendedService` definitions.
3. **Canonical Service Alias Consolidation**:
   - Where screen-derived services in `§10–§20` overlap with canonical core services in `§2–§9`, route or alias them to the canonical `.proto` service below rather than spawning duplicate backend services:
     - `LiveService` / `LiveAnalyticsService` (§17.1–17.2) → consolidate under `LiveCommerceService` (`live/live.proto`)
     - `SampleService` (§17.4) → consolidate under `SeedingService` (`seeding/sample.proto`)
     - `SettingsService` (§10.7) / `UserPreferencesService` (§19.18) → consolidate under `UserService` & `WorkspaceService` (`identity/`)
     - `TemplateService` (§17.7) → consolidate under `RecipeService` (`workflow/recipe.proto`)
     - `BillingService` (§14.11) / `CreditService` (§14.10) → consolidate under `AdminBillingService` (`admin/billing.proto`)
4. **Typed request/response authoring rule**:
   - [API behavior contracts](api_behavior_contracts.md) owns transport fields, critical command inputs, idempotency, validation and failure semantics. [RPC bindings](rpc_permission_bindings.csv) covers every inventory operation.
   - Derive persistence-backed **response** types from authorized schema projections, excluding secrets/server internals. Never derive writable command fields by copying a DB row.
   - Each implemented RPC must have exact compiled request/response messages and tests recorded in its phase packet. State-changing operations use the feature transition tables and specific action permissions. An illustrative service declaration or JSON example alone is not executable contract completion.
