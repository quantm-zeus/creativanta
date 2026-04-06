---
layer: contracts
canonical: true
source_file: protobuf_contracts.md  # was impl_a2_protobuf_contracts.md (legacy name)
last_verified: 2026-04-06
known_issues: []  # API-C-001, API-H-001, API-H-002 all RESOLVED 2026-04-02
do_not_edit_without: Đọc 00_index/OPEN_BLOCKERS.md trước khi sửa
---

## Quick Navigation

| Section | Content |
|---|---|
| §1 Proto File Structure | Directory layout: common, identity, intelligence, content, publish, engagement, commerce, finance, workflow, live, seeding, copilot, admin, gamification, connector, creator_pro, internal_admin |
| §2 Common Types | UUID, Money, Timestamp, Pagination, SourceClass, ConfidenceBand, OperatorMode |
| §3 Key Service Definitions | WorkspaceService, IdeaService, ScriptService, AssetService, PublishService, CopilotService, ProfitService |
| §4 Code Generation | proto-gen.sh script for Rust, TypeScript, Dart |
| §5 Service Count Summary | ~52 services, ~310 RPCs (this doc covers key services only; full count is ~346 canonical RPC definitions in `api_endpoint_map.md`; screen-derived RPCs relocated to `screen_api_reconciliation.md` §5) |

# A2 — Protobuf Contract Definitions (Overview & Key Services)

> **Upstream**: Tech Stack ADR v3 (ADR-002, ADR-005), Product Freeze
> **Protocol**: gRPC (mobile↔API) + ConnectRPC (web↔API) + REST (webhooks only)
> **Location**: `/protos/` — generated in implementation Phase 1 from the canonical contract authoring set (`api_endpoint_map.md` + `api_examples.md`), then used as the transport/codegen source for Dart + Rust + TypeScript

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

```bash
#!/bin/bash
# tooling/proto-gen.sh

PROTO_DIR="./protos"
OUT_RUST="./apps/api/src/proto"
OUT_TS="./packages/shared-types/src"
OUT_DART="./apps/mobile/lib/generated"

# Rust (tonic-build via build.rs)
echo "Rust: Generated via build.rs (tonic-build + prost)"

# TypeScript (ConnectRPC)
npx buf generate --template buf.gen.yaml

# Dart (grpc-dart)
protoc --dart_out=grpc:$OUT_DART \
  -I$PROTO_DIR \
  $(find $PROTO_DIR -name '*.proto')

echo "✅ Proto generation complete for Rust, TypeScript, Dart"
```

---

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
| **TOTAL** | **~52 services** | **~310 RPCs** |

> **Note**: Internal Admin protos are NOT exposed via public ConnectRPC gateway. They use a separate admin-only gRPC endpoint protected by VPN + admin MFA.
> **Audit v7 — I-7 fix**: Total updated from ~270 to ~310 to include Extended Production RPCs (Pack 04 §9.6-9.16) and Platform Health RPCs (M22) added in Audit v5. A3 (API Endpoint Map) is the authoritative count source.

Actual `.proto` files will be created during implementation Phase 1 (foundation setup).
