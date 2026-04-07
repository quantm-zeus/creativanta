---
layer: system
canonical: true
source_file: creativanta_tech_stack_adr_v3.md
last_verified: 2026-03-30
purpose: Architecture decisions, full tech stack, monorepo structure, performance benchmarks, cost estimation, and PRD mapping
---

# Creativanta — Tech Stack ADR v3 (Performance-First Edition)

> **Architecture Decision Record v3**  
> **Date**: 2026-03-25  
> **Philosophy**: Maximum performance, native-like smoothness, production stability, extreme scalability  
> **Core Stack**: SvelteKit 2 + Svelte 5 + Flutter 3.41 + Rust (Axum) + PostgreSQL + gRPC  
> **Migration**: v2 → v3: Next.js 16 → SvelteKit 2 (ADR-012), Remotion → Revideo + rust-ffmpeg (ADR-013), Recharts → Apache ECharts (ADR-014)

---

## 🏗️ Architecture Overview

```
┌──────────────────────────────────────────────────────────────────────────────────────────┐
│                                     CLIENT LAYER                                          │
├──────────────────┬─────────────────────────┬─────────────────────────────────────────────┤
│  Web Application │   Mobile Application    │      🔒 Internal Admin Site (S26)            │
│  SvelteKit 2     │   Flutter 3.41+Dart 3.11│      SvelteKit 2 (separate app)             │
│  Svelte 5 (Runes)│   Impeller Engine       │      admin.creativanta.app                  │
│  Vite            │   120 FPS native perf   │      VPN / Cloudflare Access only           │
│  Tailwind CSS v4 │   Material 3+Cupertino  │      MFA mandatory + Internal Auth          │
│  SSR + Prerender │   AOT compiled          │      8 internal roles (Super Admin → Audit) │
└──────┬───────────┴──────────┬──────────────┴────────────────┬────────────────────────────┘
       │                      │                               │
       │ ConnectRPC (Proto)   │ gRPC+Protobuf (binary)       │ ConnectRPC (Internal endpoints)
       ▼                      ▼                               ▼
┌──────────────────────────────────────────────────────────────────────────────────────────┐
│                              API LAYER (RUST)                                             │
│                                                                                          │
│  ┌───────────────────────┐  ┌──────────────────────┐  ┌────────────────────────────────┐│
│  │  Axum HTTP Server     │  │  Tonic gRPC Server   │  │  Internal Admin API Layer      ││
│  │  ConnectRPC + REST    │  │  Binary protocol     │  │  /internal/admin/v1/*          ││
│  │  + Webhooks           │  │  7-10x faster JSON   │  │  InternalAdminAuthMiddleware   ││
│  │  + Public API (S24)   │  │                      │  │  Audit log on all writes       ││
│  └─────────┬─────────────┘  └────────┬─────────────┘  └──────────┬─────────────────────┘│
│            │                         │                           │                       │
│            └─────────────┬───────────┘                           │                       │
│                          │                                       │                       │
│  ┌───────────────────────┴───────────────────────────────────────┴─────┐                 │
│  │                   Core Services (Rust)                              │                 │
│  │  SeaORM 2.0 + SQLx (async PostgreSQL)                              │                 │
│  │  Tower middleware (auth, tenant, rate limit)                        │                 │
│  │  Tokio async runtime                                                │                 │
│  └────────────────────────────────────────────────────────────────────-┘                 │
└─────────────────────────────┬────────────────────────────────────────────────────────────┘
                              │
       ┌──────────────────────┼──────────────────┐
       ▼                      ▼                  ▼
┌────────────────┐ ┌────────────────┐ ┌────────────────────────┐
│  PostgreSQL 17 │ │ Redis 7+       │ │  S3-Compatible Storage │
│  (Self-hosted) │ │ (Dragonfly)    │ │  (Cloudflare R2)       │
│  + pgvector    │ │ Job queues     │ │  Videos, images, assets│
│  + RLS         │ │ Cache, Pub/Sub │ │  Zero egress fees      │
│  + TimescaleDB │ │                │ │                        │
└────────────────┘ └────────────────┘ └────────────────────────┘
       │                  │
       ▼                  ▼
┌──────────────────────────────────────────────────────────────────────────────────────────┐
│                      WORKER / AI LAYER (RUST)                                             │
│                                                                                          │
│  ┌───────────────────────────────────────────┐                                           │
│  │  Rust Worker Service (Tokio-based)        │                                           │
│  │  Durable workflow engine (custom)         │                                           │
│  │  Job scheduling (tokio-cron-scheduler)    │                                           │
│  └───────────────────┬───────────────────────┘                                           │
│                      │                                                                   │
│       ┌──────────────┼──────────────────┐                                                │
│       ▼              ▼                  ▼                                                │
│  ┌──────────┐  ┌──────────────┐  ┌────────────────┐                                     │
│  │ AI Gate  │  │ Video/Media  │  │ Platform APIs  │                                     │
│  │ (Adapter)│  │ FFmpeg       │  │ TikTok Shop    │                                     │
│  │ Gemini   │  │ (rust-ffmpeg)│  │ Shopee         │                                     │
│  │ GPT/Clan │  │ Revideo      │  │ Lazada, YouTube│                                     │
│  │ Qwen/etc │  └──────────────┘  └────────────────┘                                     │
│  └──────────┘                                                                            │
└──────────────────────────────────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌──────────────────────────────────────────────────────────────────────────────────────────┐
│                      ANALYTICS / OBSERVABILITY                                            │
│  PostHog + Sentry + Grafana/Prometheus + Jaeger (distributed trace)                      │
│  ClickHouse (analytics OLAP)                                                             │
│  → Feeds into Admin Site dashboards (S26 §3, §9, §10)                                   │
└──────────────────────────────────────────────────────────────────────────────────────────┘
```

---

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
| **Forms** | **Superforms** + **Formsnap** + **Zod** | latest | SvelteKit-native, progressive enhancement, Zod shared with Rust via .proto |
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
| **API Communication** | **gRPC** (grpc-dart) + **Protobuf** | latest | Type-safe binary protocol, 7-10x faster than REST/JSON |
| **Local Storage** | **Drift** (SQLite) + **Hive** | latest | Drift: relational offline sync. Hive: key-value fast access |
| **Push Notifications** | **firebase_messaging** + APNs | latest | Morning Brief delivery, cross-platform |
| **Camera/Media** | **camera** + **video_player** | latest | Video recording for user uploads |
| **Image Caching** | **cached_network_image** | latest | Efficient memory management |
| **Charts** | **fl_chart** | latest | High-performance native-rendered charts |
| **Animations** | **Flutter built-in** + **rive** | latest | Impeller-optimized, 120 FPS animation |

### ⚙️ Layer 3: Backend (Rust)

| Component | Choice | Version | Rationale |
|---|---|---|---|
| **HTTP Framework** | **Axum** | 0.8+ | Tokio team, type-safe extractors, Tower middleware, modern async, near Actix-Web performance with better DX |
| **gRPC Framework** | **Tonic** | 0.13+ | Rust gRPC standard, Prost for protobuf, streaming support, interceptors |
| **Async Runtime** | **Tokio** | 1.x | Industry standard async runtime, work-stealing scheduler |
| **ORM** | **SeaORM** | 2.0+ | Async-native, ActiveRecord pattern, entity generation CLI, flexible dynamic queries for multi-tenant |
| **SQL Toolkit** | **SQLx** | 0.8+ | Compile-time SQL verification, async, pure Rust, used under SeaORM |
| **Serialization** | **serde** + **Prost** (protobuf) | latest | serde for JSON (webhooks), Prost for gRPC binary |
| **Auth Middleware** | **Tower** layers + JWT (jsonwebtoken crate) | latest | Custom auth middleware, Clerk webhook validation, tenant extraction |
| **Validation** | **validator** crate + Protobuf schemas | latest | Struct-level validation, .proto as source of truth |
| **Password/Token** | **argon2** + **aes-gcm** | latest | Argon2id for hashing, AES-256-GCM for OAuth token encryption |
| **HTTP Client** | **reqwest** | latest | Async HTTP for platform API calls (TikTok, Shopee) |
| **Error Handling** | **thiserror** + **anyhow** | latest | thiserror for library errors, anyhow for application |
| **Logging** | **tracing** + **tracing-subscriber** | latest | Structured logging, span-based tracing, OpenTelemetry export |
| **Config** | **config** crate | latest | Multi-source config (env, file, defaults) |
| **Testing** | **tokio::test** + **mockall** + **wiremock** | latest | Async test runtime, mocking, HTTP mock server |

### 📡 Layer 4: Communication Protocol

| Component | Choice | Rationale |
|---|---|---|
| **Mobile ↔ API** | **gRPC + Protobuf** | Binary protocol, 7-10x faster than REST/JSON, type-safe code generation, streaming for real-time |
| **Web ↔ API** | **ConnectRPC** (Protobuf over HTTP) via SvelteKit server routes | Same .proto contracts as mobile, type-safe end-to-end, no REST/JSON translation, SSR-compatible (Connect-ES 2.0) |
| **Internal services** | **gRPC** | Service-to-service communication, low latency |
| **Webhooks** | **REST (JSON)** | Platform compatibility (Stripe, TikTok, Shopee all use REST webhooks) |
| **Real-time** | **gRPC Streaming** + **WebSocket** (tokio-tungstenite) | Bidirectional streaming for live data, WebSocket fallback for web browsers |
| **Contract** | **Protobuf (.proto files)** | Single source of truth, generates Dart + Rust + TypeScript code |

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
 │   ├── Rust (API)      → tonic-build + prost         │
 │   └── TypeScript (Web) → Connect-ES 2.0 (protoc-gen-es + @connectrpc/connect) │
 └─────────────────────────────────────────────────────┘
```

### 🗄️ Layer 5: Data

| Component | Choice | Version | Rationale |
|---|---|---|---|
| **Primary DB** | **PostgreSQL** | 17 | ACID, RLS for multi-tenant, pgvector for AI, JSON support, extensions |
| **Hosting** | **Self-hosted** (Contabo VPS) | Full control, fixed cost €40/mo, all services on one VPS |
| **ORM** | **SeaORM 2.0** (Rust) | 2.0+ | Async, entity loader, migration CLI |
| **Search** | **Meilisearch** | 1.x | Vietnamese diacritics tokenizer, typo-tolerant, fast |
| **Vector DB** | **pgvector** (in PostgreSQL) | latest | No extra infra, AI embeddings for Trend/Copilot |
| **Analytics OLAP** | **ClickHouse** | latest | Profit OS: 100x faster aggregations, columnar |
| **Cache** | **Dragonfly** (Redis-compatible) | latest | 25x faster than Redis, multi-threaded, drop-in compatible |
| **Message Queue** | **Redis Streams** (via Dragonfly) | latest | Low-latency job queue with explicit stream routing via PostgreSQL outbox |
| **Time-series** | **TimescaleDB** (PG extension) | latest | Platform health scores, performance metrics over time |
| **Real-time sync** | **PostgreSQL LISTEN/NOTIFY** + custom | — | Change notification for real-time dashboards |

### 🔄 Layer 5A: Internal Workflow & Jobs (System-level)

| Component | Choice | Rationale |
|---|---|---|
| **Job Queue** | **Rust custom** (Tokio + Redis Streams) | Zero-overhead, async, Rust-native, priority queues |
| **Cron Scheduler** | **tokio-cron-scheduler** | Morning Brief (daily 6:30 AM), fee sync, health check |
| **Durable Workflows** | **Custom** (Saga pattern + event sourcing) | Content repurpose pipeline, dunning flow, achievement checks |
| **Alternative** | **Temporal** (Rust SDK) | If workflow complexity grows beyond custom solution |

**Internal workflow mapping (system-driven, not user-configurable):**

| Creativanta Feature | Pattern |
|---|---|
| Content Repurpose | Saga: upload → extract → clips → thumbnails → schedule → publish |
| Morning Brief | Cron → aggregate data → generate brief → push |
| Dunning Flow | Event: payment.failed → 5 retry steps (saga with timers) |
| Achievement Check | Event: content.published → evaluate all conditions → award |
| Platform Fee Sync | Cron: daily → crawl → update Fee Schedule table |
| Health Score | Cron: hourly → poll APIs → calculate composite → store |
| AI Pipeline | Saga: prompt → route provider → generate → quality check → review |

### 🔄 Layer 5B: User-Facing Workflow Studio (M20/M21) — Activepieces

> **Đây là tính năng user tự thiết kế workflow automation** — không phải system internal jobs.
> PRD M20 (Workflow Studio) + M21 (Recipe Marketplace) yêu cầu **visual workflow builder** cho user.

| Component | Choice | Rationale |
|---|---|---|
| **Workflow Engine** | **Activepieces** (self-hosted, **MIT License**) | Fully open-source, commercial-safe, visual drag-drop canvas, 200+ integrations, webhook triggers |
| **Deployment** | Activepieces Docker container, managed by Rust API | Isolated per-workspace execution, resource limits per tier |
| **Visual Canvas (web)** | Activepieces UI embedded via iframe + API | Full workflow builder: trigger → condition → action → approval → fallback |
| **Visual Canvas (mobile)** | Custom Flutter UI → Activepieces API | Simplified mobile view: run/inspect/approve workflows, not full editor |
| **Node Types** | Activepieces built-in + custom Creativanta pieces | Custom pieces: Publish, Trend Query, Copilot Action, Profit Alert, Commerce Action, Approval Gate |
| **Recipe Marketplace** | Custom (Rust API + PostgreSQL) | Recipe = Activepieces flow template + metadata + install/clone logic |
| **Execution** | Activepieces worker orchestrated by Rust | Rust triggers via REST API, receives webhook callbacks on completion |
| **Audit Trail** | Activepieces execution logs → synced to PostgreSQL | Immutable audit, correlatable with domain events |
| **Tier Limits** | Rust middleware enforces | Free: 5 workflows/3 runs per day. Starter: 20/50. Pro: ∞/500. Business: ∞/∞ |

**Why Activepieces over alternatives:**

| Option | Verdict | Reason |
|---|---|---|
| **Activepieces** ✅ | **Selected** | **MIT License** (core) — fully legal for SaaS embedding, no revenue share, no restrictions. Visual builder, 200+ integrations, AI-forward, active community |
| n8n | ⛔ **REJECTED** | **Fair-code SUL license PROHIBITS**: embedding in SaaS, white-labeling, charging users for access. Embed license ~$50K/year. **Legal risk too high.** |
| Windmill | Rejected | AGPLv3 — copyleft forces open-sourcing our code. Developer-focused, not for non-tech users |
| Temporal | For internal only | No visual builder for end-users, developer tool |
| Custom from scratch | Too expensive | Building visual canvas + integrations = 6+ months |

> ⚠️ **CRITICAL LICENSE NOTE**: n8n's Sustainable Use License (SUL) explicitly prohibits:
> - Selling products where value derives from n8n functionality
> - White-labeling n8n for customers
> - Hosting n8n and charging for access
> - Using n8n as SaaS backend collecting user credentials
> Activepieces MIT core has **zero restrictions** for commercial SaaS use.

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

> ⚡ **Architecture**: Trait-based adapter pattern. Mỗi provider implement cùng 1 trait.
> Swap provider = thay config, KHÔNG thay code. Mix providers per task to optimize cost.

**AI Provider Adapter Architecture:**

```rust
// Core trait — mọi provider phải implement
#[async_trait]
pub trait LlmProvider: Send + Sync {
    fn name(&self) -> &str;
    async fn complete(&self, req: CompletionRequest) -> Result<CompletionResponse>;
    async fn stream(&self, req: CompletionRequest) -> Result<StreamResponse>;
    async fn embed(&self, texts: Vec<String>) -> Result<Vec<Vec<f32>>>;
    fn supports_function_calling(&self) -> bool;
    fn cost_per_1m_input(&self) -> f64;
    fn cost_per_1m_output(&self) -> f64;
}

// Concrete adapters
pub struct GeminiAdapter { /* Gemini API client */ }
pub struct OpenAiAdapter { /* OpenAI API client */ }
pub struct ClaudeAdapter { /* Anthropic API client */ }
pub struct QwenAdapter { /* Alibaba Qwen API client */ }
pub struct DeepSeekAdapter { /* DeepSeek API client */ }
pub struct MistralAdapter { /* Mistral API client */ }

// Smart Router — chọn provider tối ưu theo tác vụ
pub struct AiRouter {
    providers: HashMap<String, Box<dyn LlmProvider>>,
    task_routing: TaskRoutingConfig,  // config-driven
    fallback_chain: Vec<String>,      // ["gemini", "openai", "claude"]
    circuit_breaker: CircuitBreaker,  // auto-failover
    cost_tracker: CostTracker,        // per-workspace budget
}
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
| **Video Processing** | **rust-ffmpeg** | — | — | Native Rust FFmpeg, clip extraction, transcoding, reframing, final mix |
| **Template Video** | **Revideo** (TypeScript sidecar) | — | — | Framework-agnostic programmatic video (text overlays, transitions, template-based), 70x faster than Remotion, MIT license |
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

> **Note**: Sora (OpenAI) đã ngừng hoạt động 24/03/2026. Midjourney không có public API. Grok (xAI) chưa có video gen API.
> Multi-provider là BẮT BUỘC — Sora shutdown chứng minh single-provider risk.

### 💰 Layer 7: Payments

| Component | Choice | Rationale |
|---|---|---|
| **International** | **Stripe** | Subscription billing, metered (AI credits), dunning, webhooks |
| **Vietnam** | **VNPay** | Domestic bank transfer, QR codes, local cards |
| **Invoice** | Custom (Rust PDF generation) | Branded invoices, export-ready |

### 🔐 Layer 8: Auth & Security

| Component | Choice | Rationale |
|---|---|---|
| **Identity Provider** | **Clerk** (via webhook + JWT) | Prebuilt UI (web), Organizations for multi-tenant, 50K MAU free |
| **Flutter Auth** | Custom flow + Clerk API | Clerk REST API for mobile auth flows |
| **RBAC** | Custom Rust middleware + Clerk roles | Tower layer extracts JWT → workspace_id → role → permission check |
| **Multi-tenant** | PostgreSQL **RLS** + Rust middleware | SET LOCAL tenant_id per transaction, defense-in-depth |
| **WAF** | **Cloudflare WAF** (DNS proxy mode) | DDoS + bot protection, Cloudflare sits in front of Contabo VPS |
| **Rate Limiting** | Rust middleware + **Dragonfly** | Custom sliding window, per-tenant, per-endpoint |
| **Encryption** | **AES-256-GCM** (aes-gcm crate) | OAuth tokens encrypted at rest |
| **Hashing** | **Argon2id** | Password + token hashing |
| **TLS** | **Caddy** auto-TLS or Cloudflare SSL | End-to-end encryption |

### 📊 Layer 9: Observability

| Component | Choice | Rationale |
|---|---|---|
| **Product Analytics** | **PostHog** (self-hosted) | Event tracking, session replay, feature flags, A/B testing |
| **Error Tracking** | **Sentry** (Rust + Flutter + SvelteKit SDKs) | Cross-platform error tracking |
| **APM / Monitoring** | **Grafana** + **Prometheus** | Infrastructure metrics, custom dashboards |
| **Distributed Tracing** | **Jaeger** (via OpenTelemetry) | End-to-end request tracing across services |
| **Logging** | **Grafana Loki** | Self-hosted structured log aggregation from `tracing` JSON stdout |
| **Uptime** | **BetterUptime** | Status page, incident SLA compliance |

| **Web + API Hosting** | **Contabo VPS** (self-hosted) | €40/mo VPS, full control, Docker Compose, SvelteKit adapter-node, Rust binary |
| **Reverse Proxy** | **Caddy** or **Nginx** | Auto TLS, reverse proxy for SvelteKit + Rust API |
| **DNS + CDN** | **Cloudflare** (Free/Pro) | DNS only + CDN caching + WAF/DDoS protection |
| **WAF / DDoS** | **Cloudflare WAF** | Bot protection, rate limiting, geo-blocking |
| **Storage** | **Cloudflare R2** | S3-compatible, zero egress fees |
| **CI/CD** | **GitHub Actions** | Rust build caching, Flutter build, SvelteKit build + deploy to VPS |
| **IaC** | **Docker Compose** + **Pulumi** (optional) | Simple VPS management, Docker Compose for all services |
| **Secrets** | **Infisical** (staging/prod) + **dotenv** (local dev only) | Secret management |
| **Container** | **Docker** + multi-stage Rust builds | Minimal images (~20MB Rust binary) |

### 🧪 Layer 11: Testing

| Component | Choice | Rationale |
|---|---|---|
| **Rust Unit/Integration** | **tokio::test** + **mockall** | Async test runtime, compile-time verified |
| **Rust API Testing** | **wiremock** + **reqwest** | HTTP mock, integration tests |
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
| **WebSocket (Web)** | **Liveblocks** or **Partykit** | Real-time collaboration, presence awareness |
| **Collaborative Editing** | **Yjs** + **Tiptap Collaboration** | Script co-editing, concurrent workflow editing, CRDT-based |
| **File Preview** | **pdfjs-dist** + custom | Invoice preview, report export |
| **Export** | **xlsx** (SheetJS) + **jspdf** | Excel/PDF export cho reports, ledger, profit statements |
| **Zalo Integration** | **Zalo OA API** | Vietnam messenger notifications (optional channel) |

---

## 🏗️ Monorepo Structure

```
creativanta/
├── protos/                    # 📡 Shared Protobuf definitions (source of truth)
│   ├── user.proto
│   ├── workspace.proto
│   ├── content.proto
│   ├── commerce.proto
│   ├── profit.proto
│   ├── copilot.proto
│   ├── achievement.proto
│   └── health.proto
│
├── apps/
│   ├── web/                   # 🖥️ SvelteKit 2 web app
│   │   ├── src/
│   │   │   ├── routes/        # SvelteKit file-based routing
│   │   │   ├── lib/           # Shared components, utils, stores
│   │   │   └── app.html       # HTML shell
│   │   ├── static/
│   │   └── svelte.config.js
│   │
│   ├── mobile/                # 📱 Flutter app
│   │   ├── lib/
│   │   │   ├── features/      # Feature-first architecture
│   │   │   ├── core/          # Shared core (API, auth, theme)
│   │   │   ├── generated/     # Protobuf generated code
│   │   │   └── main.dart
│   │   ├── ios/
│   │   ├── android/
│   │   └── pubspec.yaml
│   │
│   ├── admin/                # 🔒 Internal Admin Site (S26) — SvelteKit 2 (separate app)
│   │   ├── src/
│   │   │   ├── routes/        # Admin-specific routes (dashboard, users, billing, fraud, incidents...)
│   │   │   ├── lib/           # Admin components, stores, utils
│   │   │   │   ├── components/ # Admin-specific UI (data tables, charts, audit viewers)
│   │   │   │   ├── stores/    # Admin auth, RBAC state, impersonation session
│   │   │   │   └── utils/     # Admin API client (calls /internal/admin/v1/*)
│   │   │   └── app.html
│   │   ├── static/
│   │   └── svelte.config.js   # VPN-only deployment, no public indexing
│   │
│   └── api/                   # ⚙️ Rust API server
│       ├── src/
│       │   ├── main.rs
│       │   ├── config/
│       │   ├── domain/        # Bounded contexts (matches Pack 02, ALL 23 modules)
│       │   │   ├── identity/      # M23: Auth, Workspace, User, Role, Team
│       │   │   ├── trend/         # M02+M03: Trend Discovery, Intelligence
│       │   │   ├── opportunity/   # M04: Opportunity & Decision
│       │   │   ├── content/       # M05+M06+M07: Idea, Script, AI Production
│       │   │   ├── publish/       # M08+M11: Publish Queue, Distribution
│       │   │   ├── engagement/    # M09+M10+M12: Thread, Inbox, Engagement
│       │   │   ├── commerce/      # M13+M14+M15+M16: Product, Order, Offer, Affiliate
│       │   │   ├── live/          # M17: Live Commerce War Room
│       │   │   ├── proof/         # M18: Evidence, Proof, Sponsor
│       │   │   ├── profit/        # M19+§33: Revenue, Cost, Profit OS
│       │   │   ├── workflow/      # M20: Workflow Studio (Activepieces orchestration)
│       │   │   ├── recipe/        # M21: Recipe Marketplace, Agent Center
│       │   │   ├── capability/    # M22: Capability Matrix, Policy Center
│       │   │   ├── copilot/       # §34: AI Copilot conversational assistant
│       │   │   ├── achievement/   # §37.3: Achievement & Gamification
│       │   │   ├── health/        # §37.4: Platform Health Score
│       │   │   ├── repurpose/     # §36: Content Repurpose Engine
│       │   │   └── admin/         # S26: Internal Admin (RBAC, Fraud, Incident, Audit)
│       │   ├── infrastructure/
│       │   │   ├── db/        # SeaORM entities, migrations
│       │   │   ├── grpc/      # Tonic service implementations
│       │   │   ├── http/      # Axum REST routes (webhooks) + ConnectRPC handlers
│       │   │   ├── queue/     # Job processing (Redis Streams)
│       │   │   ├── ai/        # LLM adapter (trait-based, multi-provider)
│       │   │   ├── activepieces/ # Activepieces API client (workflow orchestration)
│       │   │   ├── email/     # Resend client
│       │   │   ├── sms/       # Twilio/SpeedSMS client
│       │   │   └── storage/   # Cloudflare R2 client
│       │   ├── middleware/    # Tower layers (auth, tenant, rate-limit, capability)
│       │   └── proto/        # Generated Rust protobuf code
│       ├── build.rs          # tonic-build protobuf codegen
│       ├── Cargo.toml
│       └── Dockerfile        # Multi-stage (~20MB final image)
│
├── services/
│   ├── activepieces/           # 🔄 Activepieces workflow engine (Docker, MIT License)
│   │   ├── docker-compose.yml
│   │   ├── custom-pieces/     # Creativanta-specific Activepieces pieces
│   │   │   ├── creativanta-publish/
│   │   │   ├── creativanta-copilot/
│   │   │   ├── creativanta-commerce/
│   │   │   ├── creativanta-approval/
│   │   │   └── creativanta-diagnostics/
│   │   └── recipes/           # Default recipe templates (JSON)
│   │
│   └── revideo/              # 🎬 Video generation sidecar (TypeScript, framework-agnostic)
│       ├── Dockerfile
│       └── src/
│
├── packages/
│   ├── shared-types/          # TypeScript types for web (generated from .proto)
│   └── config/                # ESLint, Prettier, Tailwind config
│
├── infra/                     # Infrastructure as Code
│   ├── docker-compose.yml     # Local dev (API + Activepieces + PG + Dragonfly + Meilisearch)
│   ├── pulumi/                # Cloud infrastructure
│   └── migrations/            # Database migrations (SeaORM)
│
└── tooling/                   # ⚠️ PLANNED — scripts to be created during implementation Phase 1
    ├── proto-gen.sh           # Generate code from .proto for all platforms
    ├── pieces-sync.sh         # Sync custom pieces + recipes to Activepieces
    └── scripts/
```

---

## 🔑 Key Architecture Decisions

### ADR-001: Polyglot Monorepo (TypeScript + Dart + Rust)

**Decision**: Single repo with 3 languages sharing Protobuf contracts
**Trade-off**: Complexity vs consistency
**Mitigation**: 
- Canonical API authoring source during docs phase = `api_endpoint_map.md` + `api_examples.md`; `.proto` transport contracts are generated from that source at implementation kickoff
- `proto-gen.sh` generates Dart, Rust, TypeScript in one command
- CI validates all generated code is up-to-date

### ADR-002: gRPC + Protobuf as Primary Protocol

**Decision**: gRPC for mobile ↔ API, ConnectRPC (Protobuf) for web ↔ API, REST for webhooks only
**Performance**: 7-10x faster than REST/JSON (binary serialization, HTTP/2 multiplexing)
**Type safety**: Breaking changes caught at compile time across all 3 platforms
**Why ConnectRPC for web**: Connect protocol = Protobuf over HTTP/1.1 (browser-compatible), same .proto contracts as mobile, no REST translation layer. Connect-ES 2.0 supports SSR (plain JS objects, not ES6 classes)

### ADR-003: Rust for API (Axum + SeaORM)

**Decision**: Axum over Actix-Web or Loco
**Rationale**:
- Axum: Tokio team, modern API, Tower middleware ecosystem, type-safe extractors
- Actix-Web slightly faster (10-15%) but Axum has better DX
- Loco too immature for our scale
- SeaORM 2.0: async-native, Entity Loader, flexible for multi-tenant dynamic queries
- **Performance**: Rust API handles 10-50x more requests/sec than Node.js with 80% less memory

### ADR-004: Flutter for Mobile (Impeller Engine)

**Decision**: Flutter 3.41 + Dart 3.11 over React Native/Expo
**Performance**:
- Impeller engine: pre-compiled shaders, zero jank, Metal (iOS) + Vulkan (Android)
- 120 FPS sustained on modern devices
- 58-60 FPS on complex UIs (vs React Native's 51 FPS)
- 50% faster rasterization with Impeller
- AOT compilation → predictable, near-native performance
- **Not React Native**: because user explicitly requires native-like smoothness

### ADR-005: PostgreSQL RLS + Rust Middleware for Multi-Tenant

```rust
// Axum middleware: extract tenant, set PostgreSQL session
async fn tenant_middleware(
    State(pool): State<PgPool>,
    headers: HeaderMap,
    mut request: Request,
    next: Next,
) -> Response {
    let tenant_id = extract_tenant_from_jwt(&headers);
    
    // SET LOCAL scoped to transaction
    let mut tx = pool.begin().await?;
    sqlx::query("SET LOCAL app.current_tenant_id = $1")
        .bind(&tenant_id)
        .execute(&mut *tx)
        .await?;
    
    request.extensions_mut().insert(TenantContext { tenant_id, tx });
    next.run(request).await
}
```

**Decision**: Shared database + RLS + transaction-scoped tenant isolation
**Why**: Cost-effective, defense-in-depth, Rust's memory safety prevents data leaks

### ADR-006: Dragonfly over Redis

**Decision**: Dragonfly as Redis replacement
**Rationale**:
- 25x faster than Redis (multi-threaded)
- 100% Redis protocol compatible (drop-in replacement)
- Lower memory usage
- Perfect for: job queues, caching, rate limiting, session store

### ADR-007: SvelteKit 2 with Server Routes Pattern

**Decision**: SvelteKit server routes (+page.server.ts / +server.ts) as Backend-for-Frontend
**Architecture**:
```
Browser → SvelteKit 2 (ConnectRPC client, Connect-ES 2.0) → Protobuf → Rust API (same VPS)
Flutter → gRPC (direct) → Rust API (same VPS)
```
**Rationale**:
- SvelteKit SSR + prerender = optimal SEO + performance
- Svelte 5 compile-time optimization: ~42KB bundle (vs ~120KB Next.js)
- Vite: ~50ms HMR (ESM-native)
- Server routes pattern: SvelteKit handles SSR, auth cookies, then proxies to Rust
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

### ADR-013: Revideo + rust-ffmpeg over Remotion

**Decision**: Replace Remotion (Node.js sidecar) with Revideo + rust-ffmpeg
**Date**: 2026-03-25
**Rationale**:
- **Framework-agnostic**: Revideo = TypeScript, no React dependency
- **Performance**: WebCodecs rendering = **70x faster** than Remotion frame capture
- **License**: MIT (free) vs Remotion commercial license for SaaS
- **Stack alignment**: rust-ffmpeg already in stack → drawtext/subtitle burn = zero new dependency
- **Simpler infra**: Can run without Node.js sidecar (Revideo + FFmpeg = sufficient)
**Migration**: Remotion compositions → Revideo generator functions (TypeScript, similar paradigm)

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

## ⚡ Performance Comparison

| Metric | v1 (TypeScript) | v3 (Rust + Flutter + SvelteKit) | Improvement |
|---|---|---|---|
| API Throughput | ~15K req/s (NestJS) | ~150K+ req/s (Axum) | **~10x** |
| API Latency p99 | ~50ms | ~5ms | **~10x** |
| API Memory | ~200MB (Node.js) | ~20MB (Rust) | **~10x** |
| Mobile FPS (complex UI) | 51 FPS (React Native) | 58-60 FPS (Flutter) | **~15%** |
| Mobile jank | Occasional (JS bridge) | Zero (AOT + Impeller) | **Eliminated** |
| Mobile animation | 60 FPS target | **120 FPS** sustained | **2x** |
| Web builds (dev) | ~3s HMR (webpack) | ~50ms HMR (Vite) | **~60x** |
| Web bundle (gzip) | ~120KB (React) | ~42KB (Svelte) | **~65% smaller** |
| Web TTI | ~2.8s | ~1.0s | **~64% faster** |
| Docker image | ~200MB (Node.js) | ~20MB (Rust binary) | **~10x** |
| Protocol overhead | JSON (text) | Protobuf (binary) | **7-10x smaller** |
| Cold start | ~2s (Node.js) | ~100ms (Rust) | **~20x** |

---

## 💲 Cost Estimation (Monthly)

### Phase 1: Launch (0-1K users)

| Service | Cost |
|---|---|
| **Contabo VPS** (Cloud VPS L, 10 vCPU, 32GB RAM, 400GB SSD) | **€40/mo** (~$43) |
| └── SvelteKit (adapter-node) | included |
| └── Rust API (Axum binary, ~20MB) | included |
| └── PostgreSQL 17 (self-hosted) | included |
| └── Dragonfly (self-hosted, Redis-compatible) | included |
| └── Meilisearch (self-hosted) | included |
| └── Revideo worker (Docker) | included |
| └── Activepieces (Docker, MIT) | included |
| Cloudflare (Free: DNS + CDN + WAF) | $0 |
| Cloudflare R2 (storage) | ~$5/mo |
| Clerk (Free, 50K MAU) | $0 |
| **Gemini API** (Flash default) | **$20-80/mo** |
| PostHog/Sentry (Free tiers, self-hosted option) | $0 |
| Domain | ~$12/year |
| **TOTAL** | **~$70-130/mo** |

> 💡 Self-hosted trên Contabo = **tất cả services trên 1 VPS** với €40/mo.
> So với Vercel + Fly.io + Neon + Dragonfly Cloud = ~$95-170/mo riêng infra.
> **Tiết kiệm 40-50% chi phí hosting** + full control.

### Phase 2: Growth (1K-10K users)

| Service | Cost |
|---|---|
| **Contabo VPS x2** (scale: separate DB + API) | €80/mo (~$86) |
| Cloudflare Pro (advanced WAF) | $20/mo |
| Cloudflare R2 (storage, increased) | $10-30/mo |
| ClickHouse (self-hosted on VPS or Altinity Cloud) | $0-100/mo |
| Clerk Pro | $25-100/mo |
| **AI APIs** (Gemini + fallbacks) | **$100-400/mo** |
| **TOTAL** | **~$250-750/mo** |

### Phase 3: Scale (10K-100K)
| | **~$800-3,000/mo** |

> Cost is **50-70% lower** than cloud-hosted alternatives because:
> - Self-hosted on Contabo VPS (fixed cost, no metered billing)
> - Rust needs minimal resources (~20MB RAM per service)
> - Gemini Flash is 33x cheaper than GPT-4o for most tasks
> - Cloudflare R2 = zero egress fees
> - No Vercel/AWS/GCP markup on compute

---

## ✅ Stack ↔ PRD Full Mapping (All 23 Modules + Strategic Features)

### Module → Tech Mapping

| Module | Description | Tech Solution |
|---|---|---|
| **M01** | Home / Daily Decision Engine | SvelteKit SSR + gRPC → Morning Brief aggregation service |
| **M02** | Trend Fusion Radar | Rust crawler + Meilisearch + pgvector embeddings |
| **M03** | Research & Competitor Intelligence | ClickHouse trend aggregation + SvelteKit SSR dashboards |
| **M04** | Opportunity Board | Rust domain service + Riverpod state (mobile) |
| **M05** | Idea Engine | Rust domain + LLM ideation (Gemini) |
| **M06** | Script Lab | Tiptap (web) + Yjs collab + Copilot (LLM) |
| **M07** | AI Video Studio (Production Modes + Extended Features + Character Builder) | Multi-provider AI video (Veo 3.1 / Kling 3.0 / Runway Gen-4) + Flux 2/GPT Image + Kolors (Virtual Try-On) + SAM2 (segmentation) + rembg (bg removal) + SyncLabs lip-sync + ElevenLabs TTS + HeyGen/D-ID (avatar) + Stable Audio/MusicGen (music gen) + rust-ffmpeg (final mix) + Google Video Intelligence + Whisper ASR + ACRCloud + Librosa + product URL scraper (Rust) |
| **M08** | Continuity OS | Continuity packs + drift detection + voice/brand/character consistency engine |
| **M09** | Asset Derivative Manager / Repurpose Hub | Derivative lifecycle manager + clip/variant organizer + lineage inspector |
| **M10** | Packaging QA / Upload Copilot / Experiment Lab | Rust scoring engine + LLM hook/title/caption analysis |
| **M11** | Publish Hub | Rust saga workflow + platform API connectors + queue/schedule |
| **M12** | Unified Inbox & Engagement Center | WebSocket (tokio-tungstenite) + thread management |
| **M13** | Product Hub / Inventory / Order Truth | SeaORM entities + stock movement ledger |
| **M14** | Monetization OS | Rust domain + conversion tracking |
| **M15** | Creator Store / Offers / Membership | Rust API + SvelteKit SSR storefront |
| **M16** | In-Product Affiliate Network | Rust link generator + attribution engine |
| **M17** | Live Commerce War Room | WebSocket real-time + Flutter live UI |
| **M18** | Seeding / Sample CRM | Rust CRM domain + sample shipment tracking |
| **M19** | Operating Ledger / Profit Graph / Proof Center | ClickHouse OLAP + TimescaleDB + Apache ECharts dashboards |
| **M20** | **Workflow Studio** | **Activepieces embedded** (visual builder) + Rust orchestration |
| **M21** | **Recipe Marketplace / Agent Center** | Activepieces flow templates + Custom recipe store (Rust + PG) |
| **M22** | Capability Matrix & Policy Center | Rust capability registry + policy engine |
| **M23** | Reporting / Admin / Billing / Diagnostics | Rust admin API + Stripe billing + diagnostics + **S26 Internal Admin Site** (separate SvelteKit app, VPN-only, internal auth) |

### Strategic Features → Tech Mapping

| Feature | Tech Solution |
|---|---|
| Profit OS (§33) | ClickHouse aggregations + Rust profit calculator + fee database |
| Copilot (§34) | **AI Adapter** → Gemini Flash (default) + gRPC streaming + function calling |
| Morning Brief (§35) | tokio-cron-scheduler + FCM/APNs + Resend email |
| Content Repurpose (§36) | Saga: Rust worker + rust-ffmpeg + Gemini audio + adapter routing |
| Content ROI (§37.1) | ClickHouse per-content attribution |
| Smart Scheduling (§37.2) | ML model (Python sidecar) + Rust scheduler |
| Achievement System (§37.3) | Event-driven Rust handlers + PostgreSQL |
| Platform Health (§37.4) | Cron poller + composite score + TimescaleDB |
| Contextual Learning (§37.5) | Content delivery via Rust API + PostHog events |
| Product Showcase (Pack04 §9.6) | rembg/SAM2 + Veo/Kling (img-to-video) + Kolors (try-on) + rust-ffmpeg (assembly) |
| Image-to-Video (Pack04 §9.7) | Veo 3.1 / Kling 3.0 image-to-video API |
| Thumbnail Studio (Pack04 §9.8) | Flux 2 / GPT Image + mediapipe face detection + Revideo text overlay |
| Link-to-Video (Pack04 §9.9) | Rust product scraper (Shopee/Lazada/Amazon API) + LLM script gen + M07 video pipeline |
| Translation Studio (Pack04 §9.10) | Whisper ASR + Gemini translate + ElevenLabs multilingual + SyncLabs lip-sync |
| Sound Studio (Pack04 §9.11) | Stable Audio Open / MusicGen + Librosa beat detection + ElevenLabs SFX |
| Style Learning (Pack04 §9.12) | Google Video Intelligence (style analysis) + Continuity OS (M08) storage |
| Video Agent (Pack04 §9.13) | Activepieces workflow + Rust orchestrator + all M07 sub-services |
| Performance Coach (Pack04 §9.14) | Platform analytics API + Trend Engine (M02) + Gemini analysis |
| A/B Testing (Pack04 §9.15) | M10 Experiment Lab + analytics comparison + PostHog events |
| Gamification (Pack04 §9.16) | Event-driven Rust XP handler + PostgreSQL + Push notifications (FCM/APNs) |

### Cross-Cutting Requirements → Tech

| Requirement | Tech Solution |
|---|---|
| 120 FPS mobile | Flutter Impeller engine |
| LCP ≤ 1.5s | SvelteKit compile-time optimization + prerender + CDN |
| Real-time (≤ 500ms) | gRPC Streaming + WebSocket (tokio-tungstenite) |
| EU AI Act (C2PA) | Rust metadata injection in video pipeline |
| WCAG 2.1 AA | shadcn-svelte (Bits UI accessible) + Flutter Semantics |
| Vietnamese search | Meilisearch (Vietnamese tokenizer) |
| Multi-tenant isolation | PostgreSQL RLS + Rust Tower middleware |
| Visual workflow builder (M20) | **Activepieces embedded** (MIT) → drag-drop canvas for non-tech users |
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
| Rust learning curve | Higher initial dev time | Use SeaORM (familiar ORM patterns), Loco-inspired structure |
| Flutter ≠ shared code with web | Separate mobile codebase | Shared .proto contracts, shared business logic via gRPC |
| 3 languages in monorepo | Build complexity | proto-gen.sh automation, GitHub Actions matrix builds |
| No Clerk SDK for Flutter | Custom auth flow | Clerk REST API + JWT validation in Rust middleware |
| Smaller Svelte talent pool | Mitigated | AI-assisted dev (1 dev + AI), Svelte 2-4 week learning curve, 30-40% less code |
| Remotion needs Node.js sidecar | Eliminated | Replaced with Revideo + rust-ffmpeg: framework-agnostic, MIT license, 70x faster |
| Activepieces adds Node.js dependency | Extra container | Isolated Docker, Rust API controls lifecycle, MIT license = zero legal risk |
| Multi-AI provider complexity | Config management | YAML-driven routing config, provider health dashboard, cost alerts |

---

### ADR-008: Activepieces for User-Facing Workflow Studio (M20/M21)

**Decision**: Embed Activepieces (self-hosted, **MIT License**) as the workflow engine for M20 Workflow Studio + M21 Recipe Marketplace

**Context**: PRD M20 requires a **visual workflow builder**. Originally evaluated n8n but discovered **critical license risk**:
- n8n's fair-code SUL **explicitly prohibits** embedding in commercial SaaS, white-labeling, or charging users for access
- n8n Embed license costs ~$50K/year
- Activepieces core is **MIT licensed** — zero restrictions for commercial use

**Architecture**:
```
User → Web (SvelteKit) → Activepieces Canvas (embedded iframe/API) → Activepieces Engine
                                                                    ↕
                                                          Rust API (via webhooks)
                                                                    ↕
                                                          PostgreSQL + Dragonfly
```

**Tier enforcement**: Rust middleware validates workflow count + run limits before allowing execution.

---

### ADR-009: AI Adapter Pattern — Multi-Provider with Gemini Default

**Decision**: Build a trait-based AI adapter layer in Rust with **Gemini 2.5 Flash as default provider**

**Context**: AI model landscape changes rapidly. Vendor lock-in = death. User requests explicitly demand flexibility to swap GPT ↔ Gemini ↔ Claude ↔ Qwen without code changes.

**Architecture**:
```
                    ┌──────────────────────────────────────┐
                    │         AI Router (Rust)              │
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
1. **Trait-based**: All providers implement `LlmProvider` trait — compiler-enforced contract
2. **Config-driven routing**: YAML/env config maps task → provider, no code change needed
3. **Automatic failover**: Circuit breaker pattern, 3 failures → switch to next provider
4. **Cost tracking**: Per-workspace, per-task cost budget with real-time alerts
5. **Gemini default**: 33x cheaper input tokens than GPT-4o, excellent Vietnamese, 1M context window
6. **No vendor lock**: Every provider is a pluggable adapter, add new providers in ~100 lines of code

**Cost impact of Gemini default vs OpenAI-only:**

| Scenario (10K users, 1M API calls/mo) | OpenAI-only | Gemini default + mix | Savings |
|---|---|---|---|
| Copilot queries (80% of calls) | $2,000/mo | $60/mo | **97%** |
| Script gen (10% of calls) | $250/mo | $125/mo (Gemini Pro) | **50%** |
| Long-form (5%) | $375/mo | $375/mo (Claude) | 0% |
| Function calling (5%) | $125/mo | $125/mo (GPT-4o) | 0% |
| **TOTAL** | **$2,750/mo** | **$685/mo** | **75%** |

---

> **Bottom line**: Stack v3 (Performance-First) delivers maximum perf: (1) 🚀 SvelteKit 2 replaces Next.js 16 — 65% smaller bundle, 64% faster TTI, LCP ≤1.5s (ADR-012), (2) 🎬 Revideo + rust-ffmpeg replaces Remotion — 70x faster rendering, MIT license, framework-agnostic (ADR-013), (3) 📊 Apache ECharts replaces Recharts — 40+ chart types, Canvas rendering, 3.5M downloads/week (ADR-014), (4) 🤖 AI adapter pattern with Gemini default cuts AI costs 60-75%, (5) ⚙️ Multi-provider media stack (Veo 3.1 + Kling 3.0 + Runway Gen-4) eliminates single-provider risk. Rust API (10x throughput), Flutter (120 FPS), SvelteKit 2 (~50ms HMR, ~42KB bundle), gRPC (7-10x faster). **Self-hosted on Contabo VPS €40/mo** + Cloudflare DNS/R2/WAF. Platform **scales tới hàng triệu users**, chi phí thấp nhất thị trường nhờ smart routing + self-hosted infra.

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
       → rust-ffmpeg → Merge + background music + SFX → Final output ✅
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
   rust-ffmpeg → Final mix (music + SFX + subtitles) → Output ✅
```
- When: Provider lacks native audio, or dubbing to another language
- Lip-sync: SyncLabs (Sync.so) API — zero-shot, multi-language
- Fallback: Wav2Lip via Replicate

**Strategy 4 — Simple Voice-Over (B-roll / product showcase)**
```
Video gen (any) + TTS voice-over → rust-ffmpeg overlay → Output ✅
```
- When: No talking head, just narration over visuals
- No lip-sync needed — just audio track merge

#### 10.2 Smart Pipeline Router Logic

```rust
fn select_pipeline(ctx: &VideoGenContext) -> PipelineStrategy {
    match (ctx.character_type, ctx.voice_setting, ctx.content_type) {
        // Digital Twin with cloned voice → Audio-First
        (CharacterType::DigitalTwin, VoiceSetting::Cloned, _) => Strategy::AudioFirst,
        
        // Any character, user selected specific voice clone → Audio-First
        (_, VoiceSetting::Cloned, _) => Strategy::AudioFirst,
        
        // B-roll, product, no talking head → Simple Voice-Over
        (_, _, ContentType::BRoll | ContentType::ProductShowcase) => Strategy::SimpleVoiceOver,
        
        // Provider supports native audio → Native (fastest)
        _ if ctx.provider.supports_native_audio() => Strategy::NativeAudio,
        
        // Provider lacks native audio → Post-Production Lip-Sync
        _ => Strategy::PostProductionLipSync,
    }
}
```

#### 10.3 Media Provider Adapter (extends LLM Adapter Pattern)

```rust
// Trait for video generation providers
#[async_trait]
pub trait VideoGenProvider: Send + Sync {
    fn name(&self) -> &str;
    fn supports_native_audio(&self) -> bool;
    fn max_duration_secs(&self) -> u32;
    fn max_resolution(&self) -> Resolution;
    fn cost_per_second(&self, quality: Quality) -> f64;
    async fn generate(&self, req: VideoGenRequest) -> Result<VideoGenResult>;
    async fn health_check(&self) -> bool;
}

pub struct Veo31Provider { /* Google Vertex AI / Gemini API */ }
pub struct Kling30Provider { /* Kling official API */ }
pub struct RunwayGen4Provider { /* Runway REST API */ }

// Trait for TTS providers
#[async_trait]
pub trait TtsProvider: Send + Sync {
    fn name(&self) -> &str;
    fn supports_voice_clone(&self) -> bool;
    fn supports_language(&self, lang: &str) -> bool;
    fn cost_per_1m_chars(&self) -> f64;
    async fn synthesize(&self, req: TtsRequest) -> Result<AudioBuffer>;
}

pub struct ElevenLabsProvider { /* ElevenLabs REST API */ }
pub struct GoogleCloudTtsProvider { /* Google Cloud gRPC */ }
pub struct OpenAiTtsProvider { /* OpenAI REST API */ }

// Trait for lip-sync providers  
#[async_trait]
pub trait LipSyncProvider: Send + Sync {
    async fn sync(&self, video: &[u8], audio: &[u8]) -> Result<Vec<u8>>;
}

pub struct SyncLabsProvider { /* Sync.so REST API */ }
pub struct Wav2LipProvider { /* Replicate API */ }
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

```rust
// Trait for video analysis providers
#[async_trait]
pub trait VideoAnalysisProvider: Send + Sync {
    fn name(&self) -> &str;
    async fn detect_scenes(&self, video: &VideoInput) -> Result<Vec<SceneBoundary>>;
    async fn detect_faces(&self, video: &VideoInput) -> Result<Vec<FaceDetection>>;
    async fn detect_objects(&self, video: &VideoInput) -> Result<Vec<ObjectDetection>>;
    async fn extract_text_overlays(&self, video: &VideoInput) -> Result<Vec<TextOverlay>>;
}

pub struct GoogleVideoIntelligenceProvider { /* Vertex AI */ }

// Trait for speech-to-text
#[async_trait]
pub trait AsrProvider: Send + Sync {
    fn name(&self) -> &str;
    fn supports_language(&self, lang: &str) -> bool;
    async fn transcribe(&self, audio: &AudioInput) -> Result<TimedTranscript>;
    async fn diarize_speakers(&self, audio: &AudioInput) -> Result<Vec<SpeakerSegment>>;
}

pub struct WhisperProvider { /* OpenAI API or self-hosted */ }

// Trait for audio analysis
#[async_trait]
pub trait AudioAnalysisProvider: Send + Sync {
    async fn detect_bpm(&self, audio: &AudioInput) -> Result<BpmInfo>;
    async fn detect_beats(&self, audio: &AudioInput) -> Result<Vec<BeatTimestamp>>;
    async fn fingerprint(&self, audio: &AudioInput) -> Result<AudioFingerprint>;
    async fn check_copyright(&self, fingerprint: &AudioFingerprint) -> Result<CopyrightResult>;
}

pub struct LibrosaAnalyzer { /* Local Python service via gRPC */ }
pub struct AcrCloudProvider { /* ACRCloud REST API */ }
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

```rust
pub struct ViralityScoreInput {
    pub clip_analysis: ClipAnalysis,      // from video analysis
    pub trend_data: TrendEngineData,       // from M02/M03 — THIS IS THE MOAT
    pub platform: PlatformTarget,
}

pub struct ViralityScore {
    pub total: u8,                        // 0-100
    pub engagement_pattern: f32,          // 30% weight
    pub hook_strength: f32,               // 25% weight
    pub pacing_score: f32,                // 20% weight
    pub audio_quality: f32,               // 15% weight
    pub content_relevance: f32,           // 10% weight — from Trend Engine
    pub explanation: String,              // Human-readable reasoning
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
