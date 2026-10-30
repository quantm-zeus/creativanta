---
layer: index
canonical: true
last_updated: 2026-03-30
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

## ADR-003: Rust (Axum 0.8+) for Backend API

- Date: 2026-03-25
- Status: Accepted
- Context: Need 10-50x throughput vs Node.js, memory safety for multi-tenant isolation, ~20MB Docker images.
- Decision: Rust + Axum + SeaORM 2.0 + Tonic gRPC + Tokio runtime
- Consequences: 150K+ req/s, ~5ms p99 latency, ~20MB memory. Higher initial learning curve.
- Must not reverse because: Memory safety does not establish authorization; grants, RLS, composite tenant FKs and isolation tests are mandatory

## ADR-004: ConnectRPC (web) + gRPC binary (mobile)

- Date: 2026-03-25
- Status: Accepted
- Context: Need type-safe API contracts across 3 platforms (web TS, mobile Dart, backend Rust) from single .proto source.
- Decision: gRPC + Protobuf for mobile ↔ API, ConnectRPC (Protobuf over HTTP) for web ↔ API, REST only for webhooks
- Consequences: 7-10x faster than REST/JSON, breaking changes caught at compile time. Browser requires ConnectRPC (no native gRPC).
- Must not reverse because: Single .proto source prevents API contract drift across 3 codebases

## ADR-005: Protobuf as Single Source of Truth for API contracts

- Date: 2026-03-25
- Status: Accepted
- Context: 3 platforms consuming same API — contract drift is inevitable with manual OpenAPI/Swagger.
- Decision: Transport contracts are protobuf-first at runtime, but during the docs phase the canonical authoring source is `04_contracts/api_endpoint_map.md` + `04_contracts/api_examples.md`. `.proto` files in `/protos/` are generated from that canonical contract set at implementation kickoff, then become the transport/codegen source for Dart (grpc-dart), Rust (tonic-build + prost), and TypeScript (Connect-ES 2.0).
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

## ADR-010: Revideo + rust-ffmpeg replacing Remotion

- Date: 2026-03-25
- Status: Accepted
- Context: Remotion requires commercial license for SaaS, depends on React/Node.js sidecar, frame capture is slow.
- Decision: Replace with Revideo (TypeScript, framework-agnostic) + rust-ffmpeg (native)
- Consequences: MIT license (free), 70x faster rendering via WebCodecs, no React dependency. Migration needed for composition format.
- Must not reverse because: Remotion commercial license cost + Node.js sidecar contradicts Rust-first architecture

## ADR-011: SeaORM 2.0 as Primary ORM

- Date: 2026-03-25
- Status: Accepted
- Context: Need async-native Rust ORM with entity generation, flexible dynamic queries for multi-tenant context.
- Decision: SeaORM 2.0 with SQLx underneath
- Consequences: ActiveRecord pattern familiar to most developers. Entity Loader for batch queries. Migration CLI.
- Must not reverse because: SeaORM's async-native design is required for Tokio runtime compatibility

## ADR-012: Multi-tenant via workspace_id + RLS

- Date: 2026-03-25
- Status: Accepted
- Context: Shared database for cost efficiency at launch. Must prevent cross-tenant data access.
- Decision: PostgreSQL RLS + `SET LOCAL app.current_tenant_id` per transaction + Rust Tower middleware
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
