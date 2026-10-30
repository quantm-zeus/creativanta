---
layer: index
canonical: true
last_updated: 2026-10-30
---

# Decision Log — Architecture Decision Records

> Runtime architecture: [Tech stack ADR](../05_system/tech_stack_adr.md). Product scope and delivery: [Implementation Order](IMPLEMENTATION_ORDER.md). Performance figures in older rationale are unverified targets, not release evidence.

---

## ADR-001: SvelteKit 2 + Svelte 5 for Web Frontend (replacing Next.js 16)

- Date: 2026-03-25
- Status: Accepted
- Context: Team = 1 developer + AI assistant. Performance, SEO (INP metric), and bundle size are critical. Hosting on self-managed Contabo VPS (no Vercel).
- Decision: Migrate from Next.js 16 to SvelteKit 2 + Svelte 5 Runes
- Consequences: ~42KB bundle (vs ~120KB), 64% faster TTI, 41% more server RPS. Smaller Svelte talent pool.
- Must not reverse because: Svelte's compile-time optimization gives INP advantage critical for Google 2026 SEO ranking

## ADR-002: Flutter 3.41 + Impeller for Mobile

- Date: 2026-03-25
- Status: Accepted
- Context: User requires native-like smoothness, 120 FPS, zero jank across iOS + Android simultaneously.
- Decision: Flutter 3.41 + Dart 3.11 with Impeller rendering engine
- Consequences: 120 FPS sustained, pre-compiled shaders, AOT compilation. Separate codebase from web (shared via .proto contracts).
- Must not reverse because: Real-device frame budgets and traces must demonstrate acceptable smoothness; no engine guarantees zero jank for live commerce real-time UX

## ADR-003: Backend API implementation — superseded by ADR-015

- Original date: 2026-03-25
- Original choice: Rust/Axum; superseded on 2026-10-30 by explicit owner instruction.
- Current decision: Go net/http + ConnectRPC; see [ADR-015](../05_system/tech_stack_adr.md#adr-015-product-owner-migration-to-go--2026-10-30).
- Rationale: Reduce implementation/integration complexity for the full phased product. Earlier 150K req/s, 20MB RAM and language speed multipliers were not measured on Creativanta and are withdrawn as evidence.
- Consequences: Re-author Go codegen, DB access, workers, media orchestration, CI/dev and agent rules. Product behavior and quality gates remain unchanged.

## ADR-004: ConnectRPC (web) + gRPC binary (mobile)

- Date: 2026-03-25
- Status: Accepted
- Context: Need type-safe API contracts across 3 platforms (web TS, mobile Dart, backend Go) from single .proto source.
- Decision: gRPC + Protobuf for mobile ↔ API, ConnectRPC (Protobuf over HTTP) for web ↔ API, REST only for webhooks
- Consequences: Shared generated types and compatibility checks; serialized size and latency must be measured. Browser requires ConnectRPC (no native gRPC).
- Must not reverse because: Single .proto source prevents API contract drift across 3 codebases

## ADR-005: Protobuf as Single Source of Truth for API contracts

- Date: 2026-03-25
- Status: Accepted
- Context: 3 platforms consuming same API — contract drift is inevitable with manual OpenAPI/Swagger.
- Decision: Transport contracts are protobuf-first at runtime, but during the docs phase the canonical authoring source is `04_contracts/api_endpoint_map.md` + `04_contracts/api_examples.md`. `.proto` files in `/protos/` are generated from that canonical contract set at implementation kickoff, then become the transport/codegen source for Dart (grpc-dart), Go (protoc-gen-go + protoc-gen-connect-go), and TypeScript (Connect-ES 2.0).
- Consequences: One contract authoring surface exists before codegen. Implementation Phase 1 begins by generating `/protos/` from the canonical API map, after which `proto-gen.sh` becomes the source for generated client/server bindings. CI validates generated code is current once `/protos/` exists.
- Must not reverse because: Any alternative requires manual sync across 3 codegen targets

## ADR-006: Self-hosted on Contabo VPS

- Date: 2026-03-25
- Status: Accepted
- Context: Budget constraint: €40/mo fixed cost for all services. Need full control, no metered billing surprises.
- Decision: Self-hosted on Contabo VPS (10 vCPU, 32GB RAM, 400GB SSD) via Docker Compose
- Consequences: All services on 1 VPS at launch. 50-70% cheaper than cloud alternatives. Requires ops responsibility.
- Must not reverse because: Metered cloud billing at scale would 3-5x infrastructure costs

## ADR-007: Dragonfly replacing Redis

- Date: 2026-03-25
- Status: Accepted
- Context: Need Redis-compatible cache/queue with better performance on single VPS.
- Decision: Dragonfly as drop-in Redis replacement
- Consequences: 25x faster than Redis (multi-threaded), 100% protocol compatible, lower memory.
- Must not reverse because: Performance gains are critical for single-VPS deployment

## ADR-008: Workflow ownership and adapter license boundary

- Date: 2026-10-29 (supersedes 2026-03-25)
- Status: Accepted engineering default under the full-scope phased-delivery instruction
- Decision: Own the canonical M20/M21 canvas/runtime baseline. Activepieces core integration or Enterprise embedded builder is optional and requires edition/license/isolation verification. No Enterprise entitlement is assumed.
- Consequences: All nodes/recipes/agent/mobile functions remain scope. Baseline implementation effort is explicit P7 work; licensed embedding is separately budgeted.
- Canonical runtime/acceptance: [Workflow integration](../06_quality_ops/activepieces_integration.md).

## ADR-009: pgvector in PostgreSQL for AI embeddings

- Date: 2026-03-25
- Status: Accepted
- Context: Need vector similarity search for trend/copilot AI features without adding separate vector DB infrastructure.
- Decision: pgvector extension in PostgreSQL 17
- Consequences: No extra infra. Shared ACID guarantees with relational data. May need dedicated vector DB at extreme scale.
- Must not reverse because: Separate vector DB on single VPS would increase operational complexity without benefit at launch scale

## ADR-010: Revideo + isolated FFmpeg media execution

- Date: 2026-03-25; implementation updated 2026-10-30 under ADR-015.
- Decision: Go orchestrates FFmpeg/ffprobe subprocesses in resource-limited media workers; Revideo keeps its TypeScript rendering service where required.
- Consequences: Preserve all video modes, post-production and analysis operations. Verify actual renderer runtime and codec/license requirements; no universal 70× rendering or Node.js-removal claim.
- Canonical execution/isolation rules: [Tech stack ADR-015](../05_system/tech_stack_adr.md#adr-015-product-owner-migration-to-go--2026-10-30).

## ADR-011: Database access — superseded implementation under ADR-015

- Original date: 2026-03-25; updated 2026-10-30.
- Original SeaORM/SQLx choice is superseded by Go pgx/v5 + sqlc and Goose SQL migrations.
- Consequences: Canonical schema owns DDL; generated queries use the validated tenant transaction. Exact decimal arithmetic, RLS/grants/FK and real PostgreSQL fixtures remain mandatory. No ORM auto-migration.
- Source of implementation rules: [Tech stack ADR](../05_system/tech_stack_adr.md).

## ADR-012: Multi-tenant via workspace_id + RLS

- Date: 2026-03-25
- Status: Accepted
- Context: Shared database for cost efficiency at launch. Must prevent cross-tenant data access.
- Decision: PostgreSQL RLS + `SET LOCAL app.current_tenant_id` per transaction + Go HTTP middleware / Connect interceptors
- Consequences: Defense-in-depth: middleware enforces tenant, RLS is safety net. Shared schema = simpler ops.
- Must not reverse because: Per-tenant database isolation would 10-50x infrastructure costs at launch

## ADR-013: ClickHouse for OLAP Analytics

- Date: 2026-03-25
- Status: Accepted
- Context: Profit OS (M19) needs complex aggregations across revenue/cost/margin — PostgreSQL OLTP is too slow for dashboard queries.
- Decision: ClickHouse for analytics OLAP, synced from PostgreSQL via CDC
- Consequences: 100x faster aggregations for profit dashboards. Extra infrastructure component.
- Must not reverse because: PostgreSQL cannot sustain sub-second P99 for complex profit aggregation queries at scale

## ADR-014: Apache ECharts replacing Recharts/Tremor

- Date: 2026-03-25
- Status: Accepted
- Context: SvelteKit migration removed React dependency. Need 40+ chart types including financial (candlestick, K-line) for Profit OS.
- Decision: Apache ECharts via echarts-svelte wrapper
- Consequences: Canvas + SVG rendering, built-in i18n (Vietnamese), 3.5M npm downloads/week. SSR-compatible.
- Must not reverse because: No Svelte-native alternative has equivalent financial chart support

## ADR-015: UUID v7 for Application-Generated IDs, DB UUID v4 Fallback

- Date: 2026-04-06
- Status: Accepted
- Context: Docs referenced both UUID v7 examples and `gen_random_uuid()` DB defaults, leaving ID policy ambiguous.
- Decision: Application-generated external/public IDs MUST use UUID v7. Database defaults may continue using `gen_random_uuid()` as a fallback for seeds, backfills, and internal records when the application layer does not pre-supply an ID.
- Consequences: Sortable IDs for APIs and event streams without blocking local seeding or migration ergonomics. Schema docs must state the dual rule explicitly.
- Must not reverse because: Time-sortable IDs materially simplify pagination, event ordering, and debugging across web/mobile/admin surfaces

## ADR-016: Full scope delivered incrementally

- Date: 2026-10-29
- Authority: Explicit product-owner instruction to keep every function and complete by phase.
- Decision: P0–P8 and their full-scope ownership/acceptance matrix replace simultaneous Day-1 availability and old phase labels.
- Consequences: No removed modules/modes/ACs. Partial slices expose honest availability, and P8 must reconcile every original scope item. See IMPLEMENTATION_ORDER.md.

## ADR-017: Durable money and side-effect authority

- Date: 2026-10-29
- Decision: PostgreSQL credit lots/reservations/ledger and financial postings are authoritative; cache and analytics are projections. Cost-based quotes cap the customer charge. Outbox/inbox and external-effect records handle replay/unknown results.
- Consequences: Tenant runtime has no bypass/DDL/TRUNCATE access. Financial and async fixtures gate release. Details remain in the owning contract/runtime docs.

## DEC-2026-10-30 — Review corrections and full-scope agent backlog

The owner requested a complete docs review, repairs, improvements and phased AI-agent tasks while retaining every function. Keep all 31 entries and six modes. Correct completion phases where a module depends on later publish/agent/commerce/growth work; retain previously deferred competitor monitoring, brand CRM/templates/discovery and style sharing as explicit P8 tasks. Implement the improvements through existing module owners and canonical contracts, without creating extra top-level modules.

[CONFLICT: earlier feature/quality examples used nonexistent stock columns, non-schema capability states, unconditional experiment winners and phishing/rights overrides; canonical schema/API/security contracts require scoped identities, five-state capability, evidence gates and non-overridable hard blocks — using the canonical contracts and correcting affected examples.]

This resolves downstream documentation contradictions under the existing precedence rule; it does not amend archived PRD §23 or waive any external approval. Decision scope, tradeoffs and validation are linked from [Build Readiness](BUILD_READINESS.md), [Product Strategy](../01_business/product_strategy_validation.md), and [Agent Build Backlog](AGENT_BUILD_BACKLOG.md).


## ADR-015: Go backend and worker baseline

- Date: 2026-10-30
- Status: OWNER_AUTHORIZED / SPECIFIED
- Decision owner: Product owner explicitly requested switching to Go in this session.
- Canonical decision: [Tech stack ADR-015](../05_system/tech_stack_adr.md#adr-015-product-owner-migration-to-go--2026-10-30).
- [CONFLICT: Prior ADR-003/ADR-011 and their downstream examples prescribed Rust implementation tooling; the owner now explicitly authorizes Go — use Go per this decision. This does not change PRD product behavior or §23 acceptance scope.]
- Scope preserved: all 31 feature/spec entries, six modes, 60 P0–P8 tasks, all screen requirements and domain contracts. Archived files and previous check artifacts remain historical.
- Acceptance: docs/codegen/CI/agent-rule consistency checks now; compiled Go/TS/Dart and PostgreSQL/process recovery remain implementation-phase evidence.
