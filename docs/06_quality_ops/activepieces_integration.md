---
layer: quality_ops
canonical: true
source_file: impl_c5_activepieces_integration.md
last_verified: 2026-03-30
---

# C5 — Activepieces Integration Specification

> **Upstream**: Pack 03 §4.2, Tech Stack ADR v3 (ADR-008)
> **License**: MIT (core) — zero restrictions for commercial SaaS

---

## 1. Architecture

```
User (Web) → SvelteKit → Activepieces Canvas (embedded) → Activepieces Engine
                                    ↕
                          Rust API (webhook callbacks)
                                    ↕
                          PostgreSQL + Dragonfly
```

### Embedding Strategy:
- **Web**: Activepieces UI loaded via iframe + API calls
- **Mobile**: Simplified Flutter UI → Activepieces REST API (run/inspect/approve only)

---

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

## 4. Tier Enforcement

| Tier | Max Workflows | Max Runs/Day | Custom Pieces | Approval Gates |
|---|---|---|---|---|
| Free | 5 | 3 | ❌ | ❌ |
| Starter | 20 | 50 | ❌ | ✅ |
| Pro | Unlimited | 500 | ✅ | ✅ |
| Business | Unlimited | Unlimited | ✅ | ✅ |

Enforcement: Rust middleware checks before triggering Activepieces flow.

---

## 5. Activepieces ↔ Rust API Communication

```
Trigger Event:
  Domain Event (Rust) → Redis Stream → Trigger Worker
    → HTTP POST to Activepieces API: /v1/flows/{flow_id}/runs
    → Activepieces executes flow
    → Custom piece actions call Rust API (HTTP/ConnectRPC)
    → On completion: webhook POST to /webhooks/activepieces
    → Rust records workflow_run + audit_event
```

### API Authentication:
- Activepieces → Rust: Service API key (workspace-scoped)
- Rust → Activepieces: Admin API key (stored in env)
