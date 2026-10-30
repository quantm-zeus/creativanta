---
layer: system
canonical: true
source_file: creativanta_tech_stack_adr_v3.md
last_updated: 2026-10-30
purpose: Architecture decisions, full tech stack, monorepo structure, performance benchmarks, cost estimation, and PRD mapping
---

# Creativanta — Tech Stack ADR v4 (Go Backend)

> **Architecture Decision Record v4**
> **Date**: 2026-10-30
> **Philosophy**: Incremental delivery, explicit contracts, production correctness and measured performance
> **Core Stack**: SvelteKit 2 + Svelte 5 + Flutter 3.41 + Go (net/http + ConnectRPC) + PostgreSQL + gRPC
> **Migration**: v3 → v4: Go replaces the previous Rust API/worker implementation choice by explicit product-owner instruction (ADR-015). All 31 feature/spec entries, six modes, four production modes, 11 extended features and P0–P8 acceptance gates are retained. SvelteKit, Flutter and canonical business contracts keep their existing roles.

---

## 🏗️ Architecture Overview

```text
SvelteKit web ── ConnectRPC ─┐
Flutter mobile ─ gRPC/H2 ───┼── Go API (net/http + ConnectRPC)
Platform callbacks ─ REST ──┘       │
                                   ├─ domain modules / authorization
SvelteKit admin ─ VPN/MFA ─ Go admin-api (separate identity + credential)
                                   │
                 PostgreSQL (RLS, transactions, ledger, outbox/inbox)
                                   │
                   Go outbox poller → Redis-compatible Streams
                                   │
                      Go workers / durable workflow executor
                      ├─ AI and platform HTTP/gRPC adapters
                      ├─ isolated FFmpeg/ffprobe subprocesses
                      ├─ Revideo TypeScript rendering service
                      └─ Python analysis/model services where required

S3-compatible storage, search and analytics remain separate adapters.
Web/mobile/admin retain all specified surfaces and mode behavior.
```

P0 starts with a modular backend in one Go module, separate process entrypoints and shared domain packages. A module is not automatically a separate network service. Deploy public API, internal admin API, outbox dispatcher and workers as separate processes with distinct credentials/resources. Network/process boundaries do not grant authorization or exactly-once execution; the existing permission, tenant and async contracts remain mandatory.

## 📋 Full Tech Stack

### 🖥️ Layer 1: Web Frontend

| Component | Choice | Version | Rationale |
|---|---|---|---|
| **Framework** | **SvelteKit 2** | 2.x | Compile-time optimization, SSR/SSG/hybrid, adapter system, ~42KB bundle (vs ~120KB Next.js) |
| **UI Library** | **Svelte 5** (Runes) | 5.x | $state/$derived/$effect runes, fine-grained reactivity, no virtual DOM, 30-40% less code than React |
| **Styling** | **Tailwind CSS v4** | 4.x | CSS-first config, oxide engine (10x faster), native cascade layers |
| **Component Library** | **shadcn-svelte** + **Bits UI** | latest | Accessible (WCAG 2.1 AA), Radix-inspired primitives, full design control, no vendor lock |
| **State Management** | **Svelte 5 Runes** ($state) + **TanStack Query** (Svelte adapter) | latest | Runes: fine-grained client state. TanStack: server state cache |
| **Charts** | **Apache ECharts** (echarts-svelte) | 5.x | 40+ chart types, Canvas+SVG, 3.5M downloads/week, financial charts built-in, i18n |
| **Forms** | **Superforms** + **Formsnap** + **Zod** | latest | SvelteKit-native, progressive enhancement, client validation plus generated Protobuf types; server validation remains explicit |
| **Animations** | **svelte/motion** + **GSAP** | latest | Svelte built-in transitions/animations, GSAP for complex sequences |
| **Rich Text** | **Tiptap** | latest | Official Svelte support, extensible, collaborative editing (Yjs) |
| **i18n** | **Paraglide.js** (Inlang) | latest | Compiled i18n (tree-shakeable), Vietnamese-first, type-safe messages |
| **Bundler** | **Vite** (built-in) | latest | Built into SvelteKit, ~50ms HMR, ESM-native |
| **Tables** | **SVAR DataGrid** | latest | Enterprise-grade, sort/filter/virtual scroll, Svelte-native |
| **Video Player** | **Vidstack Player** | latest | Svelte-native, SSR-compatible, full playback controls |

### 📱 Layer 2: Mobile (Flutter)

| Component | Choice | Version | Rationale |
|---|---|---|---|
| **Framework** | **Flutter** | 3.41+ | Impeller engine: 120 FPS, AOT compiled, near-native performance |
| **Language** | **Dart** | 3.11+ | Sound null safety, records, patterns, sealed classes |
| **Rendering** | **Impeller** | default | Pre-compiled shaders (zero jank), Metal (iOS) + Vulkan (Android), 50% faster rasterization |
| **State Management** | **Riverpod** | 2.x | Compile-safe, testable, async-first, provider model |
| **Navigation** | **go_router** | latest | Declarative routing, deep linking, guard support |
| **UI Design** | **Material 3** + **Cupertino** adaptive | built-in | Platform-adaptive UI (iOS looks iOS, Android looks Android) |
| **API Communication** | **gRPC** (grpc-dart) + **Protobuf** | latest | Type-safe binary protocol, typed binary transport; measure workload performance |
| **Local Storage** | **Drift** (SQLite) + **Hive** | latest | Drift: relational offline sync. Hive: key-value fast access |
| **Push Notifications** | **firebase_messaging** + APNs | latest | Morning Brief delivery, cross-platform |
| **Camera/Media** | **camera** + **video_player** | latest | Video recording for user uploads |
| **Image Caching** | **cached_network_image** | latest | Efficient memory management |
| **Charts** | **fl_chart** | latest | High-performance native-rendered charts |
| **Animations** | **Flutter built-in** + **rive** | latest | Impeller-optimized, 120 FPS animation |

### ⚙️ Layer 3: Backend (Go)

| Component | Choice | Implementation rule |
|---|---|---|
| Language/toolchain | Supported stable Go release, exact patch pinned at P0 | Commit go.mod/go.sum and toolchain manifest; never use an unpinned auto-download in CI |
| HTTP/RPC | Standard net/http + ConnectRPC for Go | One generated handler set serves Connect, gRPC and gRPC-Web; REST for specified webhooks/public HTTP routes |
| Concurrency | Goroutines, context.Context, bounded worker pools | Propagate deadlines/cancellation; backpressure, graceful shutdown and joining are required |
| PostgreSQL | pgx/v5 + sqlc-generated queries | Parameterized SQL and typed results; all tenant queries use the validated transaction via WithTx |
| Migrations | Goose versioned SQL | SQL contract drives migrations; migration executable alone receives migration credential |
| Decimal arithmetic | shopspring/decimal + explicit pgtype.Numeric conversion | Parse decimal strings exactly; no float conversion for money/credits; financial contract owns rounding |
| Serialization | encoding/json; google.golang.org/protobuf | Explicit JSON tags/unknown-field validation; protojson for generated messages |
| Auth/authorization | HTTP middleware + Connect interceptors | Verify Clerk/JWKS/webhooks, then current membership, binding, object/tier/approval/capability checks |
| HTTP client | net/http with bounded timeout/transport settings | Request context, response-body closure, bounded reads, verified retry/reconciliation behavior |
| Error handling | errors.Is/As, fmt.Errorf with %w, canonical Connect errors | Do not expose internal errors/secrets or panic on expected failures |
| Logging/tracing | log/slog + OpenTelemetry + sentry-go | Correlation IDs, secret redaction and safe audit; no provider payload dump |
| Tests | testing, httptest, go test -race | Real PostgreSQL isolation/replay/concurrency fixtures; mocks alone do not pass D2/D3 |

Dependency major/API compatibility and exact tool versions are verified and locked in P0; this document selects the stack, not an unverified version list.

### 📡 Layer 4: Communication Protocol

| Component | Choice | Rationale |
|---|---|---|
| **Mobile ↔ API** | **gRPC + Protobuf** | Binary protocol, typed binary transport; measure workload performance, type-safe code generation, streaming for real-time |
| **Web ↔ API** | **ConnectRPC** (Protobuf over HTTP) via SvelteKit server routes | Same .proto contracts as mobile, type-safe end-to-end, no REST/JSON translation, SSR-compatible (Connect-ES 2.0) |
| **Internal services** | **gRPC** | Service-to-service communication, low latency |
| **Webhooks** | **REST (JSON)** | Platform compatibility (Stripe, TikTok, Shopee all use REST webhooks) |
| **Real-time** | **gRPC Streaming** + **WebSocket** (Go WebSocket adapter) | Bidirectional streaming for live data, WebSocket fallback for web browsers |
| **Contract** | **Protobuf (.proto files)** | Single source of truth, generates Dart + Go + TypeScript code |

```
 ┌─────────────────────────────────────────────────────┐
 │              Shared .proto definitions               │
 │   /protos/                                          │
 │   ├── user.proto                                    │
 │   ├── workspace.proto                               │
 │   ├── content.proto                                 │
 │   ├── commerce.proto                                │
 │   ├── profit.proto                                  │
 │   ├── copilot.proto                                 │
 │   └── ...                                           │
 │                                                     │
 │   Generates:                                        │
 │   ├── Dart (Flutter)  → grpc-dart codegen           │
 │   ├── Go (API)      → protoc-gen-go + protoc-gen-connect-go         │
 │   └── TypeScript (Web) → Connect-ES 2.0 (protoc-gen-es + @connectrpc/connect) │
 └─────────────────────────────────────────────────────┘
```

### 🗄️ Layer 5: Data

| Component | Choice | Version | Rationale |
|---|---|---|---|
| **Primary DB** | **PostgreSQL** | 17 | ACID, RLS for multi-tenant, pgvector for AI, JSON support, extensions |
| **Hosting** | **Self-hosted** (candidate VPS) | Pin deployment topology/resource budget and verify current price during release planning |
| **DB access** | **pgx/v5 + sqlc** | pinned P0 | Typed SQL access; Goose versioned SQL migrations |
| **Search** | **Meilisearch** | 1.x | Vietnamese diacritics tokenizer, typo-tolerant, fast |
| **Vector DB** | **pgvector** (in PostgreSQL) | latest | No extra infra, AI embeddings for Trend/Copilot |
| **Analytics OLAP** | **ClickHouse** | latest | Profit OS: 100x faster aggregations, columnar |
| **Cache** | **Dragonfly** (Redis-compatible) | latest | 25x faster than Redis, multi-threaded, drop-in compatible |
| **Message Queue** | **Redis Streams** (via Dragonfly) | latest | Low-latency job queue with explicit stream routing via PostgreSQL outbox |
| **Time-series** | **TimescaleDB** (PG extension) | latest | Platform health scores, performance metrics over time |
| **Real-time sync** | **PostgreSQL LISTEN/NOTIFY** + custom | — | Change notification for real-time dashboards |

### 🔄 Layer 5A: Internal Workflow & Jobs (System-level)

| Component | Choice | Correctness boundary |
|---|---|---|
| Job delivery | Go workers + Redis-compatible Streams | Canonical PostgreSQL outbox/inbox and effect identities; at-least-once delivery |
| Scheduler | Go due-record scheduler with bounded tick loop | Persist due work; claim/lease and dedup in PostgreSQL; workspace timezone and six-field cron semantics from queue contract |
| Durable workflows | Owned Go executor over canonical run/step state | Persist waits, approvals, budget and transitions; recover after restart; never depend on a sleeping goroutine |
| Optional external engine | Verified adapter only | Requires separate compatibility/license decision; no automatic engine replacement in P0 |

Internal content repurpose, Morning Brief, dunning and achievements retain their existing flows. User-defined M20/M21 node types remain complete. See [queue/retry](queue_retry_design.md), [workflow runtime](runtime_workflow.md) and [workflow integration](../06_quality_ops/activepieces_integration.md).

### Layer 5B: User-Facing Workflow Studio (M20/M21)

Workflow architecture, engine/edition boundaries, all required node types and budgets are owned by [Workflow integration](../06_quality_ops/activepieces_integration.md). Creativanta owns the canvas and durable runtime baseline; verified core integrations or licensed Activepieces embedding are optional adapters. No automatic right to Enterprise SDK/white-labeling is inferred from MIT core. Commercial plan limits come from pricing_and_credits.md.

**Activepieces ↔ Creativanta Node Mapping (Pack 03 §4.2):**

| Pack 03 Node Type | Activepieces Implementation |
|---|---|
| Trigger node | Activepieces Trigger piece (webhook, cron, event) |
| Condition node | Activepieces Branch / Router pieces |
| Transform node | Activepieces Code / Data Mapper pieces |
| Action node | Custom Creativanta pieces (publish, generate, commerce) |
| Approval node | Custom piece → pushes to approval queue → waits |
| Wait node | Activepieces Delay piece (time-based or event-based) |
| Fallback node | Activepieces Error Handler + fallback branch |
| Diagnostics node | Custom piece → emit diagnostics event |
| Handoff node | Custom piece → assign to human + pause |
| Terminal node | Flow end |

**Default Recipes (PRD §21.4):**

| Recipe | Activepieces Flow Template |
|---|---|
| Trend → Idea | Trigger: TrendDetected → AI Generate Ideas → Create Idea objects |
| Idea → Script | Trigger: IdeaApproved → Copilot generate script → Create Script draft |
| Script → Publish | Trigger: ScriptApproved → Generate assets → Queue publish |
| Comment → Commerce | Trigger: ThreadIntentUpdated(purchase) → Create offer link → Reply |
| Profit Anomaly Follow-up | Trigger: Profit below threshold → Alert → Suggest actions |
| Live Follow-up | Trigger: LiveSessionEnded → Generate summary → Follow-up tasks |
| Affiliate Push | Trigger: New product → Generate affiliate links → Distribute |
| Sponsor Proofing | Trigger: DeliverableDue → Collect evidence → Bundle proof |

### 🤖 Layer 6: AI / Media — Adapter Pattern (Multi-Provider)

> ⚡ **Architecture**: Interface-based adapter pattern. Mỗi provider implement cùng 1 interface.
> Swap provider = thay config, KHÔNG thay code. Mix providers per task to optimize cost.

**AI Provider Adapter Architecture:**

```go
// LLMProvider is owned by ai_provider_guide.md §6; import that interface.
// Provider implementations: Gemini, OpenAI, Claude, Qwen, DeepSeek, Mistral.
type AIRouter struct {
    Providers map[string]LLMProvider
    TaskRouting TaskRoutingConfig
    FallbackChain []string
    CircuitBreaker *CircuitBreaker
    CostTracker *CostTracker
}
// Router calls are context-aware. Unknown submitted effects reconcile before
// fallback; provider switching remains inside the confirmed quote ceiling.
```

**Provider Registry & Cost:**

| Provider | Model | Input $/1M tokens | Output $/1M tokens | Default For | Strengths |
|---|---|---|---|---|---|
| **🔵 Gemini** (DEFAULT) | 2.5 Flash | **$0.075** | **$0.30** | General, Vietnamese, Copilot queries | Cheapest, fast, 1M context, excellent Vietnamese |
| **🔵 Gemini** | 2.5 Pro | $1.25 | $10.00 | Complex reasoning, long analysis | Best quality/price for complex tasks |
| OpenAI | GPT-4o | $2.50 | $10.00 | Function calling fallback | Best function calling, structured output |
| OpenAI | GPT-4o-mini | $0.15 | $0.60 | Budget fallback | Cheap OpenAI option |
| Anthropic | Claude 3.5 Sonnet | $3.00 | $15.00 | Long-form content, creative writing | Best creative quality |
| Qwen | Qwen2.5-72B | $0.16 | $0.16 | SEA language processing | Excellent Vietnamese/Chinese |
| DeepSeek | DeepSeek-V3 | $0.27 | $1.10 | Code generation, reasoning | Strong reasoning, cheap |
| Mistral | Mistral Large | $2.00 | $6.00 | European compliance tasks | EU-hosted, GDPR native |

**Task-Based Smart Routing (config-driven, changeable without code):**

| Task Category | Default Provider | Fallback 1 | Fallback 2 | Rationale |
|---|---|---|---|---|
| Copilot queries (§34) | **Gemini 2.5 Flash** | Qwen | GPT-4o-mini | Cheapest, fast response, good Vietnamese |
| Script generation (M06) | **Gemini 2.5 Pro** | Claude 3.5 | GPT-4o | Quality matters, complex creative |
| Caption/hashtag (M08) | **Gemini 2.5 Flash** | GPT-4o-mini | Qwen | Simple, high volume, cost-sensitive |
| Trend analysis (M02) | **Gemini 2.5 Flash** | GPT-4o-mini | DeepSeek | Batch processing, cost-sensitive |
| Content Repurpose (§36) | **Gemini 2.5 Flash** | GPT-4o | Claude | High volume, cost-sensitive |
| Long-form blog (§36) | **Claude 3.5 Sonnet** | Gemini Pro | GPT-4o | Best creative writing quality |
| Function calling (M20) | **GPT-4o** | Gemini Pro | Claude | Best structured output |
| Embeddings | **Gemini embedding** | OpenAI small | — | Free tier available, multilingual |
| Moderation | **OpenAI Moderation** | Gemini safety | — | Free, comprehensive |
| Vietnamese NLP | **Gemini 2.5 Flash** | Qwen | GPT-4o | Native Vietnamese understanding |

**Failover & Circuit Breaker:**

```
Request → Router → Primary Provider
                        ↓ (if error/timeout/rate-limit)
                   Fallback 1
                        ↓ (if error)
                   Fallback 2
                        ↓ (if all fail)
                   Queue for retry + notify user
```

- **Circuit breaker**: 3 failures in 60s → provider marked unhealthy for 5 min
- **Rate limit aware**: pre-check provider quota before routing
- **Cost budget**: per-workspace daily/monthly AI spend cap → reject if exceeded
- **Latency routing**: pick fastest healthy provider when quality is equal

**Media & Specialized AI — Multi-Provider Stack (ADR-010):**

| Component | Primary | Secondary | Budget/Fallback | Rationale |
|---|---|---|---|---|
| **Video Processing** | **FFmpeg** | — | — | Isolated FFmpeg/ffprobe, clip extraction, transcoding, reframing, final mix |
| **Template Video** | **Revideo** (TypeScript sidecar) | — | — | Framework-agnostic programmatic video (text overlays, transitions, template-based); verify pinned runtime/license and measure rendering |
| **AI Video Generation** | **Google Veo 3.1** (Gemini API) | **Kling 3.0** (official API) | **Runway Gen-4 Turbo** | Multi-provider: Veo (4K+native audio), Kling (2min+lip-sync), Runway (character consistency) |
| **AI Image Generation** | **Flux 2 Pro** (via Replicate/Fal.ai) | **GPT Image** (OpenAI) | **SDXL** (Replicate) | Flux (best realism, $0.04/img), GPT Image (text rendering), SDXL (budget) |
| **Text-to-Speech** | **ElevenLabs** | **Google Cloud TTS** | **OpenAI TTS** | ElevenLabs (best Vietnamese + voice clone), Google (cheapest volume), OpenAI (balance) |
| **Voice Cloning** | **ElevenLabs** (Pro feature) | — | — | Ultra-realistic clone, Vietnamese tonal accuracy |
| **Speech-to-Text** | **Gemini 2.5 Flash** | **Whisper** (OpenAI) | — | Gemini natively supports audio input; Whisper as fallback |
| **AI Lip-Sync** | **SyncLabs (Sync.so)** | **Wav2Lip** (via Replicate) | — | Post-production lip-sync for video+audio merge. SyncLabs (zero-shot, multi-lang), Wav2Lip (budget) |
| **AI Avatar** | **HeyGen** | **D-ID** | — | Character Builder digital twin + talking head (Pack 04 §12B) |
| **Music / SFX** | **Royalty-free library** (Pixabay/Pexels) | **Suno** (via third-party API) | **Google MusicFX** (P2) | No official API for Suno/Udio → royalty-free primary, Suno via MusicAPI |
| **Image Optimization** | **Cloudinary** | — | — | Auto-format, responsive, CDN |
| **Content Moderation** | **OpenAI Moderation API** (free) | **Gemini Safety** | — | Multi-layer, free tier |

> Provider/model status and commercial API rights must be reverified before activation. Historical availability/shutdown claims are not deployment inputs. Preserve multiple verified adapters to reduce provider outage risk.

### 💰 Layer 7: Payments

| Component | Choice | Rationale |
|---|---|---|
| **International** | **Stripe** | Subscription billing, metered (AI credits), dunning, webhooks |
| **Vietnam** | **VNPay** | Domestic bank transfer, QR codes, local cards |
| **Invoice** | Custom (Go PDF generation) | Branded invoices, export-ready |

### 🔐 Layer 8: Auth & Security

| Component | Choice | Rationale |
|---|---|---|
| **Identity Provider** | **Clerk** (via webhook + JWT) | Prebuilt UI (web), Organizations for multi-tenant, 50K MAU free |
| **Flutter Auth** | Custom flow + Clerk API | Clerk REST API for mobile auth flows |
| **RBAC** | Go middleware/interceptors + verified Clerk identity and current workspace membership | HTTP middleware/Connect interceptors verify identity → membership → binding → object/tier/approval/capability |
| **Multi-tenant** | PostgreSQL **RLS** + Go middleware | Transaction-local app.current_tenant_id + app.current_user_id, defense-in-depth |
| **WAF** | **Cloudflare WAF** (DNS proxy mode) | DDoS + bot protection, Cloudflare sits in front of Contabo VPS |
| **Rate Limiting** | Go middleware + **Dragonfly** | Custom sliding window, per-tenant, per-endpoint |
| **Encryption** | **AES-256-GCM** (Go crypto/aes + cipher.AEAD) | OAuth tokens encrypted at rest |
| **Hashing** | **Argon2id** | Provider/API token hashing where specified; Clerk owns customer passwords |
| **TLS** | **Caddy** auto-TLS or Cloudflare SSL | End-to-end encryption |

### 📊 Layer 9: Observability

| Component | Choice | Rationale |
|---|---|---|
| **Product Analytics** | **PostHog** (self-hosted) | Event tracking, session replay, feature flags, A/B testing |
| **Error Tracking** | **Sentry** (Go + Flutter + SvelteKit SDKs) | Cross-platform error tracking |
| **APM / Monitoring** | **Grafana** + **Prometheus** | Infrastructure metrics, custom dashboards |
| **Distributed Tracing** | **Jaeger** (via OpenTelemetry) | End-to-end request tracing across services |
| **Logging** | **Grafana Loki** | Structured log aggregation from `log/slog` JSON stdout |
| **Uptime** | **BetterUptime** | Status page, incident SLA compliance |

### 🚀 Layer 10: Hosting and delivery

| Component | Choice | Rationale |
|---|---|---|
| **Web + API Hosting** | **Self-hosted VPS** | Docker Compose, SvelteKit adapter-node, separate Go entrypoints; measure capacity/cost |
| **Reverse Proxy** | **Caddy** or **Nginx** | Auto TLS, reverse proxy for SvelteKit + Go API |
| **DNS + CDN** | **Cloudflare** (Free/Pro) | DNS only + CDN caching + WAF/DDoS protection |
| **WAF / DDoS** | **Cloudflare WAF** | Bot protection, rate limiting, geo-blocking |
| **Storage** | **Cloudflare R2** | S3-compatible, zero egress fees |
| **CI/CD** | **GitHub Actions** | Go module/build caching, Flutter build, SvelteKit build + deploy to VPS |
| **IaC** | **Docker Compose** + **Pulumi** (optional) | Simple VPS management, Docker Compose for all services |
| **Secrets** | **Infisical** (staging/prod) + **dotenv** (local dev only) | Secret management |
| **Container** | **Docker** + multi-stage Go builds | Separate runtime/media images; measure size and resources |

### 🧪 Layer 11: Testing

| Component | Choice | Rationale |
|---|---|---|
| **Go Unit/Integration** | **testing** + **go test -race** | Domain, decimal and concurrent integration tests |
| **Go API Testing** | **httptest** + **net/http** | HTTP mock, integration tests |
| **Flutter Unit** | **flutter_test** | Built-in, widget testing |
| **Flutter Integration** | **integration_test** + **patrol** | E2E native testing |
| **Web E2E** | **Playwright** | Multi-browser, parallel, auto-wait |
| **Load Testing** | **k6** | JavaScript-based, cloud execution |
| **Contract Testing** | **Protobuf schema validation** | .proto = contract, breaking changes detected at build |

### 📬 Layer 12: Communications & Collaboration

| Component | Choice | Rationale |
|---|---|---|
| **Email Transactional** | **Resend** | Developer-friendly, React Email templates, high deliverability |
| **Email Marketing** | **Resend Broadcasts** or **Loops** | Morning Brief email digest, onboarding drip campaigns |
| **SMS / OTP** | **Twilio** + **SpeedSMS** (VN backup) | OTP verification, VN local SMS fallback |
| **Push Notifications** | **Firebase Cloud Messaging** (FCM) + APNs | Flutter + Web push, Morning Brief delivery |
| **In-App Notifications** | Custom (PostgreSQL + WebSocket) | Notification center, read/unread, deep links |
| **WebSocket (Web)** | **Go WebSocket adapter** (server) + native browser WS | Real-time collaboration, presence awareness. _Liveblocks and Partykit were evaluated but rejected in favor of self-hosted Go WebSocket adapter for consistency with Go backend (ADR-003)._ |
| **Collaborative Editing** | **Yjs** + **Tiptap Collaboration** | Script co-editing, concurrent workflow editing, CRDT-based |
| **File Preview** | **pdfjs-dist** + custom | Invoice preview, report export |
| **Export** | **xlsx** (SheetJS) + **jspdf** | Excel/PDF export cho reports, ledger, profit statements |
| **Zalo Integration** | **Zalo OA API** | Vietnam messenger notifications (optional channel) |

---

## 🏗️ Monorepo Structure

TypeScript uses pnpm. Backend uses one Go module at apps/api; commands share internal domain packages. Paths below are planned P0 artifacts, not files already built by this docs migration.

```text
creativanta/
├── protos/                       # Canonical domain folders from protobuf_contracts.md
├── apps/
│   ├── web/                      # SvelteKit customer app
│   ├── admin/                    # Separate SvelteKit internal-admin app
│   ├── mobile/                   # Flutter; lib/generated is grpc-dart output
│   └── api/
│       ├── go.mod
│       ├── go.sum
│       ├── cmd/
│       │   ├── api/main.go        # Public HTTP/RPC; app_user only
│       │   ├── admin-api/main.go  # Internal trust boundary; admin_user only
│       │   ├── worker/main.go     # Canonical jobs; app_user per tenant command
│       │   ├── outbox/main.go     # Narrow dispatcher; outbox_poller only
│       │   └── migrate/main.go    # Goose wrapper; migration role only
│       ├── gen/                  # Generated Protobuf messages + Connect handlers
│       ├── sqlc.yaml
│       ├── queries/              # Named parameterized SQL, organized by domain
│       ├── internal/
│       │   ├── domain/           # All 23 modules + supplementary feature contexts
│       │   │   ├── identity/     # Auth/workspace; no custom Clerk token issuer
│       │   │   ├── home/         # M01
│       │   │   ├── intelligence/ # M02/M03/M04
│       │   │   ├── content/      # M05/M06/M08
│       │   │   ├── production/   # M07; M10 packaging
│       │   │   ├── assets/       # M09
│       │   │   ├── publish/      # M11
│       │   │   ├── engagement/   # M12
│       │   │   ├── commerce/     # M13–M16; S16 creator tools
│       │   │   ├── live/         # M17
│       │   │   ├── seeding/      # M18
│       │   │   ├── finance/      # M19, exact ledger/proof calculations
│       │   │   ├── workflow/     # M20 owned durable runtime
│       │   │   ├── recipe/       # M21 recipes/agents/templates
│       │   │   ├── capability/   # M22
│       │   │   ├── billing/      # M23
│       │   │   └── supplemental/ # Copilot, referral, help, gamification, S24/S26
│       │   ├── transport/        # Connect handlers, REST/webhooks, WebSocket
│       │   ├── auth/             # Identity, action binding, authorization
│       │   ├── tenant/           # Validated transaction scope
│       │   ├── db/               # sqlc generated queries + exact type adapters
│       │   ├── queue/            # Streams/outbox/inbox/recovery
│       │   └── adapters/         # AI/platform/storage/mail/search/analytics/media
│       └── Dockerfile            # Separate minimal targets; measured resource use
├── services/
│   ├── media/                    # FFmpeg/ffprobe worker image, pinned codecs/fonts
│   ├── revideo/                  # TypeScript rendering runtime where required
│   ├── analysis/                 # Python audio/video/model adapters where required
│   └── activepieces/             # Optional verified edition/adapter, not baseline engine
├── packages/shared-types/src/    # Generated TypeScript Protobuf output
├── infra/migrations/             # Canonical versioned Goose SQL migrations
└── tooling/                      # Existing docs tools + planned P0 build/codegen scripts
```

Transport routes call domain use cases; workers reuse the same use cases. Domain packages never depend on generated HTTP handlers. Keep the internal-admin and directory-reader processes/credentials isolated even when sharing build packages. Process boundaries and concurrency limits are deployment choices recorded per slice.

## 🔑 Key Architecture Decisions

### ADR-001: Polyglot Monorepo (TypeScript + Dart + Go)

**Decision**: Single repo with 3 languages sharing Protobuf contracts
**Trade-off**: Complexity vs consistency
**Mitigation**: 
- Canonical API authoring source during docs phase = `api_endpoint_map.md` + `api_examples.md`; `.proto` transport contracts are generated from that source at implementation kickoff
- `proto-gen.sh` generates Dart, Go, TypeScript in one command
- CI validates all generated code is up-to-date

### ADR-002: gRPC + Protobuf as Primary Protocol

**Decision**: gRPC for mobile ↔ API, ConnectRPC (Protobuf) for web ↔ API, REST for webhooks only
**Performance**: typed binary transport; measure workload performance (binary serialization, HTTP/2 multiplexing)
**Type safety**: Breaking changes caught at compile time across all 3 platforms
**Why ConnectRPC for web**: Connect protocol = Protobuf over HTTP/1.1 (browser-compatible), same .proto contracts as mobile, no REST translation layer. Connect-ES 2.0 supports SSR (plain JS objects, not ES6 classes)

### ADR-003: Go for API (superseded implementation choice)

**Current decision**: net/http + ConnectRPC, pgx/v5 + sqlc, Goose SQL migrations, context-aware adapters and bounded workers, as specified by ADR-015 below. The original Rust/Axum choice is superseded by the owner's 2026-10-30 instruction. There is no measured Creativanta throughput/RAM comparison establishing a Rust requirement.

### ADR-004: Flutter for Mobile (Impeller Engine)

**Decision**: Flutter 3.41 + Dart 3.11 over React Native/Expo
**Performance**:
- Impeller engine: pre-compiled shaders, zero jank, Metal (iOS) + Vulkan (Android)
- 120 FPS sustained on modern devices
- 58-60 FPS on complex UIs (vs React Native's 51 FPS)
- 50% faster rasterization with Impeller
- AOT compilation → predictable, near-native performance
- **Not React Native**: because user explicitly requires native-like smoothness

### ADR-005: PostgreSQL RLS + Go Middleware for Multi-Tenant

```go
// Illustrative repository helper; imports context and pgx/v5/pgxpool.
// Caller has already verified session, active membership and action authority.
func WithTenantTx(ctx context.Context, pool *pgxpool.Pool, tenantID, userID string,
    work func(pgx.Tx) error) error {
    tx, err := pool.Begin(ctx)
    if err != nil { return err }
    defer func() {
        cleanupCtx, cancel := context.WithTimeout(context.WithoutCancel(ctx), 5*time.Second)
        defer cancel()
        _ = tx.Rollback(cleanupCtx) // No-op after commit.
    }()
    if _, err := tx.Exec(ctx,
        "SELECT set_config('app.current_tenant_id', $1, true)", tenantID); err != nil {
        return err
    }
    if _, err := tx.Exec(ctx,
        "SELECT set_config('app.current_user_id', $1, true)", userID); err != nil {
        return err
    }
    // work must use sqlcQueries.WithTx(tx), never an unscoped pool query.
    if err := work(tx); err != nil { return err }
    return tx.Commit(ctx)
}
// Membership checks and commit errors are part of the complete
// P0 helper. A transaction is not shared concurrently across goroutines.
```

**Decision**: Shared database + RLS + transaction-scoped tenant isolation
**Why**: Cost-effective, defense-in-depth, tenant isolation depends on explicit authorization, grants, policies and tests

### ADR-006: Dragonfly over Redis

**Decision**: Dragonfly as Redis replacement
**Rationale**:
- 25x faster than Redis (multi-threaded)
- Redis-compatible operations must be verified against the pinned Dragonfly release
- Lower memory usage
- Perfect for: job queues, caching, rate limiting, session store

### ADR-007: SvelteKit 2 with Server Routes Pattern

**Decision**: SvelteKit server routes (+page.server.ts / +server.ts) as Backend-for-Frontend
**Architecture**:
```
Browser → SvelteKit 2 (ConnectRPC client, Connect-ES 2.0) → Protobuf → Go API (deployment-specific)
Flutter → gRPC (direct) → Go API (deployment-specific)
```
**Rationale**:
- SvelteKit SSR + prerender = optimal SEO + performance
- Svelte 5 compile-time optimization: ~42KB bundle (vs ~120KB Next.js)
- Vite: ~50ms HMR (ESM-native)
- Server routes pattern: SvelteKit handles SSR, auth cookies, then proxies to Go
- Self-hosted on **Contabo VPS** (€40/mo) via adapter-node + Docker
- Cloudflare DNS proxy for CDN caching + WAF/DDoS protection

### ADR-012: SvelteKit 2 over Next.js 16 (Migration v2→v3)

**Decision**: Migrate web frontend from Next.js 16 to SvelteKit 2 + Svelte 5
**Date**: 2026-03-25
**Context**: Team = 1 developer + AI assistant. Performance and SEO are top priorities.
**Rationale**:
- **Bundle size**: ~42KB vs ~120KB gzip = **65% reduction** → faster mobile UX
- **TTI**: ~1.0s vs ~2.8s = **64% faster**
- **INP**: Excellent (Google 2026 SEO-critical metric) due to minimal JS
- **Server RPS**: ~1,200 vs ~850 = **41% more throughput** → lower server cost
- **DX**: 30-40% less code, simpler mental model ($state vs useState/useEffect)
- **License**: No vendor lock-in (fully self-hosted)
- **Hosting**: Contabo VPS €40/mo (fixed cost) vs Vercel/Cloudflare (metered billing)
**Trade-off accepted**: Smaller Svelte developer pool — mitigated by AI-assisted development and Svelte's low learning curve (2-4 weeks for React developer)

### ADR-013: Revideo + isolated FFmpeg media pipeline

**Decision**: Go orchestrates pinned FFmpeg/ffprobe subprocesses in isolated media workers. Revideo remains a TypeScript rendering service for template/animated compositions where required. All mix, normalization, ducking, captions, aspect ratio, clipping, merging, translation and remix behavior remains owned by M07 and ai_media_continuity.md.

Revideo's runtime/build dependencies and commercial rights must be verified at P4. No assertion that it removes Node.js, is universally faster, or is automatically licensed for every deployment is accepted. FFmpeg image/build flags/codecs/fonts/licenses are pinned and reviewed. See ADR-015 for process isolation, cancellation and output validation.

### ADR-014: Apache ECharts over Recharts/Tremor

**Decision**: Replace Recharts + Tremor with Apache ECharts (echarts-svelte)
**Date**: 2026-03-25
**Rationale**:
- **Chart types**: 40+ vs 15 (Recharts) — includes financial charts (candlestick, K-line)
- **Rendering**: Canvas + SVG (ECharts) vs SVG-only (Recharts) → better perf for large datasets
- **Scale**: 3.5M npm downloads/week (vs 1.8M Recharts) — used by Alibaba, Baidu, Apple
- **i18n**: Built-in Vietnamese support
- **Svelte-native**: echarts-svelte wrapper, SSR-compatible
- **Real-time**: Built-in dynamic data support (vs manual in Recharts)

---

## ⚡ Performance and capacity evidence

No Creativanta API throughput, memory, image-size or language-speed comparison has been measured. Earlier 150K req/s, 20MB RAM and 10–50× language multipliers are withdrawn as sizing/acceptance evidence. Protocol serialization efficiency is not an end-to-end latency guarantee.

[Performance benchmarks](../06_quality_ops/performance_benchmarks.md) owns targets and representative load scenarios. Record machine/container limits, dataset, tenant mix, cache state, concurrency, p50/p95/p99, errors, allocations/GC, DB pool saturation and worker backlog. Separate queue admission time from provider/encode completion. Optimize queries, indexes, batching and worker concurrency based on profiles before adding another backend language.

## 💲 Capacity and operating cost planning

A single self-hosted VPS is a candidate development/early deployment shape, not evidence it can host the entire product at a specified user count or price. The backend language does not establish a 20MB process budget or guaranteed hosting saving. Release packets must verify current infrastructure prices, measured process footprints and backup/restore/resource isolation.

Phase budgets include API/admin/outbox/worker resources, PostgreSQL, Redis-compatible queue/cache, search, analytics, storage/egress/backups, rendering/model compute, AI-provider usage/retries, auth, monitoring, payment fees, workflow licenses and support. Media workers need separate admission limits and resource controls so encoding cannot starve API/database. The pricing/credit contracts continue to own customer charges, quote floors and exact accounting; infrastructure estimates cannot alter them.

## ✅ Stack ↔ PRD Full Mapping (All 23 Modules + Strategic Features)

### Module → Tech Mapping

| Module | Description | Tech Solution |
|---|---|---|
| **M01** | Home / Daily Decision Engine | SvelteKit SSR + gRPC → Morning Brief aggregation service |
| **M02** | Trend Fusion Radar | Go crawler + Meilisearch + pgvector embeddings |
| **M03** | Research & Competitor Intelligence | ClickHouse trend aggregation + SvelteKit SSR dashboards |
| **M04** | Opportunity Board | Go domain service + Riverpod state (mobile) |
| **M05** | Idea Engine | Go domain + LLM ideation (Gemini) |
| **M06** | Script Lab | Tiptap (web) + Yjs collab + Copilot (LLM) |
| **M07** | AI Video Studio (Production Modes + Extended Features + Character Builder) | Multi-provider AI video (Veo 3.1 / Kling 3.0 / Runway Gen-4) + Flux 2/GPT Image + Kolors (Virtual Try-On) + SAM2 (segmentation) + rembg (bg removal) + SyncLabs lip-sync + ElevenLabs TTS + HeyGen/D-ID (avatar) + Stable Audio/MusicGen (music gen) + FFmpeg (final mix) + Google Video Intelligence + Whisper ASR + ACRCloud + Librosa + product URL scraper (Go) |
| **M08** | Continuity OS | Continuity packs + drift detection + voice/brand/character consistency engine |
| **M09** | Asset Derivative Manager / Repurpose Hub | Derivative lifecycle manager + clip/variant organizer + lineage inspector |
| **M10** | Packaging QA / Upload Copilot / Experiment Lab | Go scoring engine + LLM hook/title/caption analysis |
| **M11** | Publish Hub | Go saga workflow + platform API connectors + queue/schedule |
| **M12** | Unified Inbox & Engagement Center | WebSocket (pinned Go adapter) + thread management |
| **M13** | Product Hub / Inventory / Order Truth | sqlc entities + stock movement ledger |
| **M14** | Monetization OS | Go domain + conversion tracking |
| **M15** | Creator Store / Offers / Membership | Go API + SvelteKit SSR storefront |
| **M16** | In-Product Affiliate Network | Go link generator + attribution engine |
| **M17** | Live Commerce War Room | WebSocket real-time + Flutter live UI |
| **M18** | Seeding / Sample CRM | Go CRM domain + sample shipment tracking |
| **M19** | Operating Ledger / Profit Graph / Proof Center | ClickHouse OLAP + TimescaleDB + Apache ECharts dashboards |
| **M20** | **Workflow Studio** | Owned canvas + durable Go executor; optional verified adapter |
| **M21** | **Recipe Marketplace / Agent Center** | Activepieces flow templates + Custom recipe store (Go + PG) |
| **M22** | Capability Matrix & Policy Center | Go capability registry + policy engine |
| **M23** | Reporting / Admin / Billing / Diagnostics | Go admin API + Stripe billing + diagnostics + **S26 Internal Admin Site** (separate SvelteKit app, VPN-only, internal auth) |

### Strategic Features → Tech Mapping

| Feature | Tech Solution |
|---|---|
| Profit OS (§33) | ClickHouse aggregations + Go profit calculator + fee database |
| Copilot (§34) | **AI Adapter** → Gemini Flash (default) + gRPC streaming + function calling |
| Morning Brief (§35) | Go due-record scheduler + FCM/APNs + Resend email |
| Content Repurpose (§36) | Saga: Go worker + FFmpeg + Gemini audio + adapter routing |
| Content ROI (§37.1) | ClickHouse per-content attribution |
| Smart Scheduling (§37.2) | ML model (Python sidecar) + Go scheduler |
| Achievement System (§37.3) | Event-driven Go handlers + PostgreSQL |
| Platform Health (§37.4) | Cron poller + composite score + TimescaleDB |
| Contextual Learning (§37.5) | Content delivery via Go API + PostHog events |
| Product Showcase (Pack04 §9.6) | rembg/SAM2 + Veo/Kling (img-to-video) + Kolors (try-on) + FFmpeg (assembly) |
| Image-to-Video (Pack04 §9.7) | Veo 3.1 / Kling 3.0 image-to-video API |
| Thumbnail Studio (Pack04 §9.8) | Flux 2 / GPT Image + mediapipe face detection + Revideo text overlay |
| Link-to-Video (Pack04 §9.9) | Go product scraper (Shopee/Lazada/Amazon API) + LLM script gen + M07 video pipeline |
| Translation Studio (Pack04 §9.10) | Whisper ASR + Gemini translate + ElevenLabs multilingual + SyncLabs lip-sync |
| Sound Studio (Pack04 §9.11) | Stable Audio Open / MusicGen + Librosa beat detection + ElevenLabs SFX |
| Style Learning (Pack04 §9.12) | Google Video Intelligence (style analysis) + Continuity OS (M08) storage |
| Video Agent (Pack04 §9.13) | Activepieces workflow + Go orchestrator + all M07 sub-services |
| Performance Coach (Pack04 §9.14) | Platform analytics API + Trend Engine (M02) + Gemini analysis |
| A/B Testing (Pack04 §9.15) | M10 Experiment Lab + analytics comparison + PostHog events |
| Gamification (Pack04 §9.16) | Event-driven Go XP handler + PostgreSQL + Push notifications (FCM/APNs) |

### Cross-Cutting Requirements → Tech

| Requirement | Tech Solution |
|---|---|
| 120 FPS mobile | Flutter Impeller engine |
| LCP ≤ 1.5s | SvelteKit compile-time optimization + prerender + CDN |
| Real-time (≤ 500ms) | gRPC Streaming + WebSocket (pinned Go adapter) |
| EU AI Act (C2PA) | Go metadata injection in video pipeline |
| WCAG 2.1 AA | shadcn-svelte (Bits UI accessible) + Flutter Semantics |
| Vietnamese search | Meilisearch (Vietnamese tokenizer) |
| Multi-tenant isolation | PostgreSQL RLS + Go HTTP middleware / Connect interceptors |
| Visual workflow builder (M20) | Owned drag-drop canvas; optional licensed embedded builder |
| Recipe library (M21) | Activepieces flow templates + custom marketplace |
| Offline mobile | Drift SQLite + background sync |
| Collaborative editing | Yjs CRDT + Tiptap Collaboration |
| Email notifications | Resend transactional + broadcast |
| SMS / OTP | Twilio + SpeedSMS |
| Push notifications | FCM + APNs |
| Export (Excel/PDF) | SheetJS + jspdf |

---

## ⚠️ Trade-offs & Mitigations

| Trade-off | Impact | Mitigation |
|---|---|---|
| Go GC and goroutine/resource pressure | Tail latency under load | Bound queues, memory/connection pools; profile and measure p99/GC |
| Flutter ≠ shared code with web | Separate mobile codebase | Shared .proto contracts, shared business logic via gRPC |
| 3 languages in monorepo | Build complexity | proto-gen.sh automation, GitHub Actions matrix builds |
| No Clerk SDK for Flutter | Custom auth flow | Clerk REST API + JWT validation in Go middleware |
| Smaller Svelte talent pool | Mitigated | AI-assisted dev (1 dev + AI), Svelte 2-4 week learning curve, 30-40% less code |
| Media runtime dependencies | Encoding/rendering resource use | Isolated FFmpeg workers and verified Revideo service; pin runtime/license |
| Activepieces adds Node.js dependency | Extra container | Isolated Docker, Go API controls lifecycle, edition/license access reviewed before enabling |
| Multi-AI provider complexity | Config management | YAML-driven routing config, provider health dashboard, cost alerts |

---

### ADR-008: Owned workflow contract with optional verified engine adapter

**Decision (2026-10-29)**: Creativanta owns the complete M20/M21 canvas/runtime and domain contracts. Activepieces core integration or Enterprise embedding can be enabled only after version/edition/license and isolation verification. The [integration spec](../06_quality_ops/activepieces_integration.md) owns architecture and acceptance. This supersedes blanket MIT embedding and zero-license-cost assumptions; no feature scope is removed.

---

### ADR-009: AI Adapter Pattern — Multi-Provider with Gemini Default

**Decision**: Build a interface-based AI adapter layer in Go with **Gemini 2.5 Flash as default provider**

**Context**: AI model landscape changes rapidly. Vendor lock-in = death. User requests explicitly demand flexibility to swap GPT ↔ Gemini ↔ Claude ↔ Qwen without code changes.

**Architecture**:
```
                    ┌──────────────────────────────────────┐
                    │         AI Router (Go)              │
                    │  ┌──────────────────────────────┐    │
                    │  │    TaskRoutingConfig (YAML)   │    │
                    │  │  copilot: gemini-flash        │    │
                    │  │  script_gen: gemini-pro        │    │
                    │  │  long_form: claude-sonnet      │    │
                    │  │  function_call: gpt-4o          │    │
                    │  └──────────────────────────────┘    │
                    │              ↓                        │
                    │  ┌──────────────────────────────┐    │
                    │  │    Provider Adapters           │    │
                    │  │  ┌────────┐ ┌────────┐        │    │
                    │  │  │ Gemini │ │ OpenAI │        │    │
                    │  │  └────────┘ └────────┘        │    │
                    │  │  ┌────────┐ ┌────────┐        │    │
                    │  │  │ Claude │ │  Qwen  │        │    │
                    │  │  └────────┘ └────────┘        │    │
                    │  │  ┌─────────┐ ┌────────┐       │    │
                    │  │  │DeepSeek │ │Mistral │       │    │
                    │  │  └─────────┘ └────────┘       │    │
                    │  └──────────────────────────────┘    │
                    │              ↓                        │
                    │  Circuit Breaker + Cost Tracker       │
                    └──────────────────────────────────────┘
```

**Key design decisions**:
1. **Interface-based**: All providers implement `LLMProvider` interface — compiler-enforced contract
2. **Config-driven routing**: YAML/env config maps task → provider, no code change needed
3. **Safe failover**: Circuit breaker plus durable unknown-effect reconciliation and confirmed quote ceiling before switching
4. **Cost tracking**: Per-workspace, per-task cost budget with real-time alerts
5. **Gemini default**: 33x cheaper input tokens than GPT-4o, excellent Vietnamese, 1M context window
6. **No vendor lock**: Every provider is a verified pluggable adapter; integration size is not guaranteed

**Cost impact of Gemini default vs OpenAI-only:**

| Scenario (10K users, 1M API calls/mo) | OpenAI-only | Gemini default + mix | Savings |
|---|---|---|---|
| Copilot queries (80% of calls) | $2,000/mo | $60/mo | **97%** |
| Script gen (10% of calls) | $250/mo | $125/mo (Gemini Pro) | **50%** |
| Long-form (5%) | $375/mo | $375/mo (Claude) | 0% |
| Function calling (5%) | $125/mo | $125/mo (GPT-4o) | 0% |
| **TOTAL** | **$2,750/mo** | **$685/mo** | **75%** |

---

> Performance multipliers, cost comparisons and model names in historical rationale are hypotheses, not measured guarantees. Phase release gates use performance_benchmarks.md, current provider rate cards and deployment fixtures. The VPS estimate excludes provider usage, backup/storage/egress, authentication, monitoring, payment fees, workflow licenses and support labor; validate a phase-specific budget before launch.

---

## ADR-010: Multi-Provider Media Routing & Video Production Pipeline

> **Status**: Accepted | **Date**: 2026-03-25

### Context
Creativanta's AI Studio generates video, images, audio, and avatars. Single-provider dependency is a critical risk — OpenAI Sora shutdown (24/03/2026) proves this. We need multi-provider media routing with smart pipeline selection.

### Decision

#### 10.1 Video Production: 4 Strategies (Smart Pipeline Router)

The system automatically selects the optimal strategy based on character type, voice settings, and content type:

**Strategy 1 — Native Audio (90% of cases, fastest)**
```
Script → Veo 3.1 / Kling 3.0 → Video + Audio (already synced) ✅
```
- When: User wants quick "1-click generate", no voice clone needed
- Providers: Veo 3.1 (best quality), Kling 3.0 (longest duration)
- Lip-sync: Built-in

**Strategy 2 — Audio-First Pipeline (Digital Twin / voice clone)**
```
Script → ElevenLabs TTS (cloned voice) → Audio → HeyGen/Kling audio-to-video → Lip-synced video
       → FFmpeg → Merge + background music + SFX → Final output ✅
```
- When: User needs cloned voice (Digital Twin character) or premium voice quality
- Voice: ElevenLabs (Vietnamese, clone, expressive)
- Video: HeyGen (avatar) or Kling Motion Control (audio-driven)

**Strategy 3 — Post-Production Lip-Sync (dubbing / multi-language)**
```
[Parallel]
├─ Video gen (any provider, no audio) 
└─ ElevenLabs TTS → Audio
          ↓
   SyncLabs Lip-Sync (video + audio → synced video)
          ↓
   FFmpeg → Final mix (music + SFX + subtitles) → Output ✅
```
- When: Provider lacks native audio, or dubbing to another language
- Lip-sync: SyncLabs (Sync.so) API — zero-shot, multi-language
- Fallback: Wav2Lip via Replicate

**Strategy 4 — Simple Voice-Over (B-roll / product showcase)**
```
Video gen (any) + TTS voice-over → FFmpeg overlay → Output ✅
```
- When: No talking head, just narration over visuals
- No lip-sync needed — just audio track merge

#### 10.2 Smart Pipeline Router Logic

```go
func SelectPipeline(ctx VideoGenContext) PipelineStrategy {
    switch {
    case ctx.VoiceSetting == VoiceCloned:
        return AudioFirst
    case ctx.ContentType == BRoll || ctx.ContentType == ProductShowcase:
        return SimpleVoiceOver
    case ctx.Provider.SupportsNativeAudio():
        return NativeAudio
    default:
        return PostProductionLipSync
    }
}
```

#### 10.3 Media Provider Adapter (extends LLM Adapter Pattern)

```go
// Internal interfaces; decimal.Decimal prices never use floating point.
type VideoGenProvider interface {
    Name() string
    SupportsNativeAudio() bool
    MaxDurationSecs() uint32
    MaxResolution() Resolution
    CostPerSecond(Quality) decimal.Decimal
    Generate(context.Context, VideoGenRequest) (VideoGenResult, error)
    HealthCheck(context.Context) error
}
type TTSProvider interface {
    Name() string
    SupportsVoiceClone() bool
    SupportsLanguage(string) bool
    CostPer1MChars() decimal.Decimal
    Synthesize(context.Context, TTSRequest) (AudioBuffer, error)
}
type LipSyncProvider interface {
    Sync(ctx context.Context, video, audio []byte) ([]byte, error)
}
// Adapters preserve Veo/Kling/Runway, ElevenLabs/Google/OpenAI TTS,
// SyncLabs/Wav2Lip and every additional provider in the verified registry.
```

#### 10.4 Provider Comparison (decision factors)

| | Veo 3.1 | Kling 3.0 | Runway Gen-4 |
|---|---|---|---|
| Max resolution | 4K | 4K | 4K (2026) |
| Max duration | 60s | 2min | 60s |
| Native audio | ✅ | ✅ | 🔜 2026 |
| API | Gemini/Vertex AI | Official + Fal.ai | Official REST |
| Cost/5s | $0.75-2.00 (std), $0.075-0.75 (fast) | $0.26-0.96 | $0.50-1.50 |
| Best for | Cinematic quality | Duration + cost | Character consistency |

| | ElevenLabs | Google Cloud TTS | OpenAI TTS |
|---|---|---|---|
| Vietnamese | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| Voice clone | ✅ | ❌ | ❌ |
| Cost/1M chars | $6-60 | $4-30 | $15-30 |

### Consequences
- (+) User gets model choice → competitive advantage
- (+) Provider failure → automatic fallback, no downtime
- (+) Cost optimization via smart routing per task
- (-) More infrastructure complexity (multiple API keys, adapters)
- (-) Quality inconsistency between providers (mitigated by Continuity OS drift detection)

---

## ADR-011: AI Video Production Modes — Editing, Clip Factory, Merge, Remix

> **Status**: Accepted | **Date**: 2026-03-25

### Context
Beyond AI generation, creators need comprehensive video production tools: editing uploaded videos, repurposing long-form to short-form, merging multiple sources, and remixing viral content. Competitors (Opus Clip, Pippit AI, Descript, CloneViral) have proven market demand. Creativanta's Trend Intelligence Engine (M02/M03) + Continuity OS (M08) create a unique moat for these features.

### Decision

#### 11.1 Four Production Modes

| Mode | Pipeline | Key Differentiator |
|---|---|---|
| **Quick Edit** (1→1) | Upload → ASR → AI suggest edits → FFmpeg execute | Text-based editing (edit transcript = edit video) |
| **Clip Factory** (1→N) | Upload → Scene detect → Clip propose → Virality Score → Export | Virality Score uses REAL trend data from M02/M03 |
| **Multi-Merge** (N→1) | Multi-upload → Reorder → AI transitions → Voice-over → Render | Character Pack integration for voice-over |
| **AI Remix** (ref→new) | Upload/URL → 8-layer analysis → Creative DNA → Gen new video | Trend→Remix→Publish closed loop (no competitor has this) |

#### 11.2 Video Analysis Provider Stack (NEW)

| Provider | Purpose | Cost/min video | Notes |
|---|---|---|---|
| **Google Video Intelligence API** | Scene detection, object tracking, shot detection, face detection | ~$0.10/min | Best accuracy for scene boundaries |
| **OpenAI Whisper** (via API or self-hosted) | Speech-to-text, speaker diarization | ~$0.006/min | Best multilingual ASR, Vietnamese support |
| **ACRCloud** | Audio fingerprinting, copyright detection | ~$0.01/query | Essential for copyright-safe audio |
| **Librosa** (self-hosted) | BPM detection, beat tracking, audio analysis | Free (compute cost) | Beat-sync music feature |
| **mediapipe** (self-hosted) | Face mesh, active speaker detection | Free (compute cost) | Active speaker reframing |

#### 11.3 Video Analysis Adapter Pattern

```go
type VideoAnalysisProvider interface {
    Name() string
    DetectScenes(context.Context, VideoInput) ([]SceneBoundary, error)
    DetectFaces(context.Context, VideoInput) ([]FaceDetection, error)
    DetectObjects(context.Context, VideoInput) ([]ObjectDetection, error)
    ExtractTextOverlays(context.Context, VideoInput) ([]TextOverlay, error)
}
type ASRProvider interface {
    Name() string
    SupportsLanguage(string) bool
    Transcribe(context.Context, AudioInput) (TimedTranscript, error)
    DiarizeSpeakers(context.Context, AudioInput) ([]SpeakerSegment, error)
}
type AudioAnalysisProvider interface {
    DetectBPM(context.Context, AudioInput) (BPMInfo, error)
    DetectBeats(context.Context, AudioInput) ([]BeatTimestamp, error)
    Fingerprint(context.Context, AudioInput) (AudioFingerprint, error)
    CheckCopyright(context.Context, AudioFingerprint) (CopyrightResult, error)
}
// Google Video Intelligence, Whisper, Python Librosa and ACRCloud remain adapters.
```

#### 11.4 AI Remix Pipeline Architecture

```
                    ┌─────────────────────┐
                    │  User Input          │
                    │  (URL or upload)     │
                    └────────┬────────────┘
                             │
                    ┌────────▼────────────┐
                    │  PHASE 1: ANALYZE    │
                    │  ├─ VideoIntelligence│
                    │  ├─ Whisper ASR      │
                    │  ├─ Librosa/ACRCloud │
                    │  └─ LLM (structure)  │
                    └────────┬────────────┘
                             │
                    ┌────────▼────────────┐
                    │  Creative DNA        │
                    │  Blueprint (JSON)    │
                    └────────┬────────────┘
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
  ┌─────▼─────┐       ┌─────▼─────┐       ┌─────▼─────┐
  │ User Input │       │ Brand Pack│       │ Character │
  │ (topic)    │       │           │       │ Pack      │
  └─────┬─────┘       └─────┬─────┘       └─────┬─────┘
        │                    │                    │
        └────────────────────┼────────────────────┘
                             │
                    ┌────────▼────────────┐
                    │  PHASE 2: REMIX      │
                    │  ├─ LLM script write │
                    │  ├─ TTS (ElevenLabs) │
                    │  ├─ Video gen (Veo/  │
                    │  │   Kling/HeyGen)   │
                    │  └─ FFmpeg assembly  │
                    └────────┬────────────┘
                             │
                    ┌────────▼────────────┐
                    │  PHASE 3: POLISH     │
                    │  ├─ Compliance scan  │
                    │  ├─ Originality check│
                    │  ├─ Virality score   │
                    │  └─ Platform export  │
                    └─────────────────────┘
```

#### 11.5 Virality Score — Trend Engine Integration

```go
// Nonfinancial scores may use floating point; money/credits must not.
type ViralityScoreInput struct {
    ClipAnalysis ClipAnalysis
    TrendData TrendEngineData
    Platform PlatformTarget
}
type ViralityScore struct {
    Total uint8
    EngagementPattern float32 // 30%
    HookStrength float32      // 25%
    PacingScore float32       // 20%
    AudioQuality float32      // 15%
    ContentRelevance float32  // 10%; mark unavailable trend input explicitly.
    Explanation string
}
```

### Consequences
- (+) "Trend → Remix → Publish" closed loop — no competitor has this end-to-end workflow
- (+) Virality Score uses real trend data (vs Opus Clip's generic pattern matching)
- (+) Character/Brand Pack integration ensures brand consistency across remixes
- (+) Text-based editing dramatically lowers editing barrier for non-technical users
- (-) Video analysis pipeline adds infrastructure cost (~$0.15/min video analyzed)
- (-) AI Remix requires careful legal safeguards (originality score, abuse detection)
- (-) Multiple analysis providers increase ops complexity (mitigated by adapter pattern)


## ADR-015: Product-owner migration to Go — 2026-10-30

**Status: Accepted for specification; runtime not implemented.** The owner explicitly requested changing the project to Go. This supersedes the previous Rust implementation choice, its ORM/middleware/codegen/tooling examples and claimed language performance advantages. It changes implementation technology, not product scope, permission keys, event names, persisted states, pricing or acceptance gates. Archives and historical evidence remain historical.

### Runtime and transaction rules

- One Go module at apps/api, multiple credential-isolated commands, modular domain packages. No mandatory microservice per module and no Rust component in the baseline. Any later native optimization requires profiling and a separate decision.
- net/http + generated Connect handlers serve web ConnectRPC and Flutter gRPC with HTTP/2 verified through the deployment proxy. Internal admin routes are on the isolated admin process; public listeners never register admin handlers. REST webhooks preserve raw-body signature validation and replay protections.
- Tenant transactions use app_user, validate membership/action authority and set both app.current_tenant_id and app.current_user_id with transaction-local set_config. All repositories use sqlc WithTx on that same transaction. Commit domain, audit, ledger and outbox together; rollback on any error/panic. Never set session-global tenant state on a pooled connection. Cross-tenant jobs enumerate through narrowly authorized dispatch and re-enter an authorized tenant transaction for each unit.
- pgx Numeric and shopspring/decimal conversions must be exact. Decimal-string wire values and NUMERIC schema fields stay authoritative; JSON/provider parsing never passes monetary values through float64. Financial contract owns rounding, FX and independent golden fixtures. sqlc typing does not prove permission, isolation or SQL runtime correctness.
- Bound goroutines, pending work, DB pools and provider concurrency. Propagate context deadlines to DB/HTTP; cancellation after submission means unknown provider outcome until reconciled. Join goroutines, stop admissions and drain/lease-recover on shutdown. Workers cannot acknowledge a job before its durable commit.
- Versioned Goose SQL migrations live in infra/migrations; cmd/migrate reads only its separately injected migration credential. Commands support up/status and local-only reviewed down. Production rollback follows expand-compatible forward repair, never automatic destructive reversal. No ORM auto-migration.
- API/worker processes receive only their role-specific credentials. Migration/admin/outbox/directory-reader credentials are not available to public API or ordinary workers. Logging uses slog/OTel with field redaction and canonical errors; callbacks and streaming preserve cancellation/backpressure.

### Media execution rules

Use exec.CommandContext with a fixed pinned executable and separately constructed allowlisted argument array, never a shell command assembled from user content. ffprobe validates input/output metadata. Stage authorized assets in job-specific scratch directories, use server-owned paths, disallow arbitrary protocol/network inputs and enforce fetch/SSRF rules before media execution. Set duration/dimensions/size/time/CPU/memory/disk limits; drop privileges, restrict network and use containers/process-group cleanup so cancellation terminates child processes too. Bound stdout/stderr and remove scratch files after terminal recovery. Validate final playable output and checksums before marking generation complete and registering lineage. Failed/unknown provider jobs keep durable identities and follow existing refund/reconciliation rules.

Revideo runs with the actual verified TypeScript/rendering dependencies in a separate service. Python remains an optional analysis/model adapter where already specified. Go coordinates these components; it does not replace encoders or AI models. FFmpeg distribution/codecs/fonts and provider rights require the existing license gates.

### P0 acceptance and sources

P0 pins the supported Go patch, module/dependency/tool/plugin versions and container digests; commits go.mod/go.sum, SQL queries/migrations, sqlc config and generated bindings. CI checks gofmt, go vet, govulncheck, go test -race, generated diff and real PostgreSQL/transport fixtures. Record a browser Connect request and Flutter gRPC request against the same Go handler, authorization denial, deadline/stream cancellation, transaction rollback and request-context isolation. Existing D0–D5 and all P0–P8 tasks still apply; this ADR is not evidence they passed.

Technical references checked for this decision: [Connect Go](https://connectrpc.com/docs/go/getting-started/), [sqlc with pgx](https://docs.sqlc.dev/en/stable/guides/using-go-and-pgx.html), [sqlc transactions](https://docs.sqlc.dev/en/stable/howto/transactions.html), [Goose commands](https://pressly.github.io/goose/documentation/cli-commands/), [Go modules](https://go.dev/doc/modules/gomod-ref). P0 must verify the exact pinned releases rather than treating moving documentation as a lockfile.
