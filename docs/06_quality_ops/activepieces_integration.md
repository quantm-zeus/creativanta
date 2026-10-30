---
layer: quality_ops
canonical: true
source_file: impl_c5_activepieces_integration.md
last_verified: 2026-03-30
---

# C5 — Activepieces Integration Specification

> **Upstream**: Pack 03 §4.2, Tech Stack ADR v3 (ADR-008)
> **License boundary (verified 2026-10-29)**: MIT core does not imply free enterprise embedding/white-labeling. [Official embedding documentation](https://www.activepieces.com/docs/embedding/overview) requires Enterprise; [repository license](https://github.com/activepieces/activepieces/blob/main/LICENSE) separates enterprise directories. No license is assumed purchased.

## 1. Canonical workflow architecture and engine boundary

Creativanta owns the workflow graph, visual editor, validation, permission checks, step state and audit contract. The baseline P7 implementation is a Creativanta canvas with the Rust durable executor described in runtime_workflow.md. This keeps every M20/M21 node, recipe, agent and mobile operation deliverable without assuming an enterprise license. Activepieces is an optional adapter for verified core integrations or a licensed embedded builder; it never becomes a second business source of truth.

- Baseline web: canvas edits the canonical graph through WorkflowService; mobile provides the specified run/inspect/approve surface.
- Executor implements trigger, condition, transform, action, approval, wait, fallback, diagnostics, handoff and terminal nodes. Graph validation rejects unknown types, dangling edges and unbounded cycles; cascade depth default five. Persist steps and waits before acknowledging work; restart resumes conditional state, never replays a completed side effect.
- Every action calls its canonical domain command with a workspace-scoped, revocable delegated identity. Effective permissions are the intersection of current activating user's permissions, declared workflow scope and tier; never an engine-wide admin key.
- Activepieces adapter is enabled only for a pinned release/edition whose required API, authentication, isolation and node support have passed a compatibility probe and license review. API paths/SDK JWT provisioning are taken from that edition's docs, not a guessed universal endpoint. If a node is unsupported, route it through the canonical Rust executor, preserving the same run/step IDs and approvals.
- Enterprise embed requires recorded license/entitlement and a verified SDK/iframe CSP/SSO/tenant-isolation test. It is an external gate on that adapter, not a deletion of the visual-builder feature.
- All runs are inspectable through the same workflow_runs/workflow_run_steps. Adapter logs are supporting diagnostics, not canonical completion evidence. Webhooks are authenticated, replay protected and idempotent.

## 2. Custom Creativanta Pieces

Each piece = npm package in `services/activepieces/custom-pieces/`

| Piece Name | Category | Actions | Triggers |
|---|---|---|---|
| `creativanta-publish` | Content | Publish, Schedule, Cancel | PublishSucceeded, PublishFailed |
| `creativanta-content` | Content | GenerateIdea, CreateScript, GenerateAsset | ScriptApproved, AssetReady |
| `creativanta-copilot` | AI | CopilotQuery, GenerateText, AnalyzeTrend | — |
| `creativanta-commerce` | Commerce | CreateOffer, UpdateProduct, GenerateLink | OrderReceived, OfferExpired |
| `creativanta-engagement` | Engagement | AssignThread, SendReply, CreateTask | NewThread, IntentDetected, SLABreached |
| `creativanta-approval` | Workflow | RequestApproval, WaitForApproval | ApprovalGranted, ApprovalRejected |
| `creativanta-diagnostics` | System | EmitDiagnostics, CheckCapability | CapabilityChanged, ErrorDetected |
| `creativanta-profit` | Finance | GetProfitSummary, CheckAnomaly | ProfitAnomalyDetected, MarginBelowThreshold |
| `creativanta-notification` | Comms | SendPush, SendEmail, SendInApp | — |

### Piece Implementation Pattern:
```typescript
// services/activepieces/custom-pieces/creativanta-publish/src/index.ts
import { createPiece } from '@activepieces/pieces-framework';
import { publishAction } from './actions/publish';
import { scheduleAction } from './actions/schedule';
import { publishSucceededTrigger } from './triggers/publish-succeeded';

export const creativantaPublish = createPiece({
  displayName: 'Creativanta Publish',
  logoUrl: 'https://...',
  auth: creativantaAuth, // API key auth to Rust API
  actions: [publishAction, scheduleAction],
  triggers: [publishSucceededTrigger],
});
```

---

## 3. Default Recipe Templates (JSON)

| Recipe | Trigger → Actions | Tier |
|---|---|---|
| Trend → Idea | `TrendSpike` → AI Generate 3 Ideas → Create Idea objects | Starter+ |
| Idea → Script | `IdeaApproved` → Copilot gen script → Create Script draft | Starter+ |
| Script → Publish | `ScriptApproved` → Generate asset → QA → Queue publish | Pro+ |
| Comment → Commerce | `IntentDetected(purchase)` → Gen offer link → Auto-reply | Pro+ |
| Profit Anomaly | `MarginBelow(threshold)` → Alert → Suggest actions | Starter+ |
| Live Follow-up | `LiveEnded` → Gen summary → Create tasks → Notify | Pro+ |
| Affiliate Push | `ProductCreated` → Gen affiliate links → Distribute | Pro+ |
| Sponsor Proofing | `DeliverableDue` → Collect evidence → Bundle proof | Pro+ |

---

## 4. Tier enforcement

Workflow count and add-on entitlements are owned solely by [Pricing](../01_business/pricing_and_credits.md). Runtime concurrency/run budgets are explicit platform config, initially Free=3 runs/day, Starter=50, Pro=500, Business=5,000 (Enterprise contractual); "unlimited workflows" does not mean unbounded concurrent execution. Each workflow's rate limits, maximum steps (100), run duration (24h excluding persisted waits), cascade depth (5), and paid AI budget must be validated before activation. Pro/Business plan workflow counts remain 100/500 unless the Workflow/Agent Pro add-on lifts that count; it does not waive safety limits or AI credits.

## 5. Adapter acceptance

Both baseline executor and any enabled adapter must pass the complete M20/M21 feature ACs, tenant isolation, dry-run, approval expiry/revocation, duplicate trigger, restart during wait, unknown external outcome, partial failure/compensation and bounded-budget tests. Preserve the nine domain integration pieces and eight recipe functions above; baseline implementations call the same domain actions directly. A licensed adapter may supply equivalent behavior, with no omitted node/function.
