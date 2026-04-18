---
layer: quality_ops
canonical: true
source_file: impl_c3_performance_benchmarks.md
status: READY
last_verified: 2026-04-11
---

# C3 — Performance Benchmark Specification

> **Upstream**: Tech Stack ADR v3

---

## 1. SLA Targets

| Metric | Target | Measurement |
|---|---|---|
| API Latency p50 | ≤ 10ms | Rust Axum response time |
| API Latency p99 | ≤ 20ms | Rust Axum response time (ADR baseline ~5ms; 20ms includes DB + cache overhead) |
| Web LCP | ≤ 1.5s | Lighthouse, SvelteKit SSR |
| Web FID/INP | ≤ 100ms | Core Web Vitals |
| Web CLS | ≤ 0.1 | Core Web Vitals |
| Web Bundle (gzip) | ≤ 120KB initial route | Vite build analysis — full SvelteKit app with shadcn-svelte + ECharts; 50KB unrealistic. Code-split per route. |
| Mobile FPS | ≥ 60 FPS (120 FPS on modern devices) | Flutter Impeller performance overlay |
| Mobile cold start | ≤ 2s | First frame render |
| Real-time latency | ≤ 500ms | WebSocket/gRPC streaming |
| Search response | ≤ 50ms | Meilisearch query |
| AI response (streaming) | First token ≤ 1s | Gemini Flash TTFT |
| Uptime | 99.9% | BetterUptime SLA |

---

## 2. Load Test Scenarios (k6)

| Scenario | VUs | Duration | Success Criteria |
|---|---|---|---|
| Homepage load | 100 | 5min | p99 < 200ms, 0 errors |
| API CRUD mix | 200 | 10min | p99 < 100ms, 0 errors |
| Publish flow | 50 | 5min | p99 < 500ms, 0 errors |
| Inbox query | 100 | 5min | p99 < 150ms |
| AI generation queue | 20 | 5min | Queue acceptance < 1s |
| Concurrent search | 100 | 5min | p99 < 100ms |
| Spike test | 0→500 | 2min ramp | No 5xx errors |
| Soak test | 50 | 1h | Memory stable, no leaks |

---

## 3. Database Performance

| Query Type | Target | Index Strategy |
|---|---|---|
| Single record by PK | ≤ 1ms | Primary key |
| List (paginated, 50 items) | ≤ 10ms | Composite index + cursor |
| Filtered list (3 conditions) | ≤ 20ms | Partial index |
| Full-text search | ≤ 50ms | Meilisearch (not PG) |
| Profit aggregation | ≤ 100ms | ClickHouse materialized view |
| Join (2 tables) | ≤ 15ms | FK indexes |
| Time-series query (30 days) | ≤ 50ms | TimescaleDB hypertable |

---

## 4. Resource Budgets

| Resource | Dev (Docker) | Prod Phase 1 |
|---|---|---|
| CPU (API) | 2 cores | 4 cores |
| RAM (API) | 256MB | 512MB |
| CPU (PG) | 2 cores | 4 cores |
| RAM (PG) | 2GB | 8GB |
| Dragonfly | 512MB | 2GB |
| ClickHouse | 1GB | 4GB |
| Meilisearch | 512MB | 2GB |
| Disk (total) | 50GB | 200GB |

---

## 5. Monitoring Alerts

| Alert | Condition | Channel |
|---|---|---|
| API error rate | > 1% for 5min | Sentry + Telegram |
| API latency p99 | > 200ms for 5min | Grafana → Telegram |
| DB connections | > 80% pool | Grafana → Telegram |
| Dragonfly memory | > 85% | Grafana → Telegram |
| Disk usage | > 80% | Grafana → email |
| Certificate expiry | < 14 days | BetterUptime |
| AI provider down | Circuit open | Sentry + Telegram |
| DLQ depth | > 100 items | Custom → Telegram |

> **Note**: Canonical alert channel is **Telegram** per `observability.md` §6. Alert thresholds here (e.g., p99 > 200ms) are intentionally looser than SLA targets (P99 ≤ 50ms) to avoid alert fatigue — see `observability.md` §7 for explanation.
