---
layer: system
canonical: true
created: 2026-04-01
status: READY
---

# Observability & Monitoring Architecture

> **Stack**: Sentry (errors) + Grafana/Prometheus (metrics) + Jaeger (tracing) + PostHog (product analytics)
> **Upstream**: `05_system/tech_stack_adr.md` §12 Observability, `06_quality_ops/performance_benchmarks.md`
> **Resolves**: Review §9 finding "Observability mapping: partial"

---

## 1. Three Pillars

| Pillar | Tool | Self-hosted | Purpose |
|---|---|---|---|
| **Metrics** | Prometheus + Grafana | Yes (Docker) | Infrastructure + business KPIs |
| **Tracing** | Jaeger (OpenTelemetry) | Yes (Docker) | Distributed request tracing |
| **Errors** | Sentry | Cloud (free tier) | Error tracking, crash reports |
| **Logs** | `tracing` + `tracing-subscriber` | Local (stdout → Grafana Loki) | Structured JSON logging |
| **Product** | PostHog | Self-hosted or Cloud | User behavior, funnels, feature flags |

---

## 2. Metrics — Prometheus Targets

### 2.1 Infrastructure Metrics (auto-scraped)

| Metric | Type | Source | Alert Threshold |
|---|---|---|---|
| `cpu_usage_percent` | Gauge | Node Exporter | > 85% for 5min |
| `memory_usage_percent` | Gauge | Node Exporter | > 90% for 5min |
| `disk_usage_percent` | Gauge | Node Exporter | > 85% |
| `postgres_connections_active` | Gauge | pg_exporter | > 80% of pool |
| `postgres_replication_lag_seconds` | Gauge | pg_exporter | > 30s |
| `dragonfly_memory_usage_bytes` | Gauge | Redis exporter | > 80% maxmemory |
| `dragonfly_connected_clients` | Gauge | Redis exporter | > 500 |
| `redis_stream_pending` | Gauge | Redis exporter / app metrics | > 10000 |
| `redis_stream_publish_rate` | Gauge | App metrics | — (baseline) |

### 2.2 Application Metrics (custom)

| Metric | Type | Labels | Module |
|---|---|---|---|
| `http_request_duration_seconds` | Histogram | `method`, `path`, `status` | All |
| `http_requests_total` | Counter | `method`, `path`, `status` | All |
| `grpc_request_duration_seconds` | Histogram | `service`, `method`, `status` | All |
| `grpc_requests_total` | Counter | `service`, `method`, `status` | All |
| `auth_login_total` | Counter | `method` (password/oauth/magic) | M01 Auth |
| `auth_session_active` | Gauge | `workspace_id` | M01 Auth |
| `credits_deducted_total` | Counter | `workspace_id`, `job_type` | M23 Billing |
| `credits_balance` | Gauge | `workspace_id` | M23 Billing |
| `ai_generation_duration_seconds` | Histogram | `provider`, `model`, `type` | M08 AI Studio |
| `ai_generation_total` | Counter | `provider`, `status` | M08 AI Studio |
| `ai_generation_active` | Gauge | `provider` | M08 AI Studio |
| `publish_job_duration_seconds` | Histogram | `platform`, `status` | M11 Publish |
| `publish_jobs_total` | Counter | `platform`, `status` | M11 Publish |
| `queue_depth` | Gauge | `queue_name` | Queue system |
| `queue_processing_duration_seconds` | Histogram | `queue_name` | Queue system |
| `dlq_items_total` | Counter | `queue_name` | Queue system |
| `circuit_breaker_state` | Gauge | `provider` (0=closed,1=half,2=open) | Queue system |
| `outbox_pending_count` | Gauge | — | Event outbox |
| `outbox_publish_lag_seconds` | Gauge | — | Event outbox |
| `thread_response_time_seconds` | Histogram | `workspace_id`, `priority` | M12 Inbox |
| `sla_breaches_total` | Counter | `workspace_id` | M12 Inbox |
| `order_revenue_total` | Counter | `workspace_id`, `platform`, `currency` | M13 Commerce |
| `settlement_pending_amount` | Gauge | `workspace_id`, `currency` | M19 Finance |
| `workflow_runs_total` | Counter | `status` | M20 Workflow |
| `connector_sync_duration_seconds` | Histogram | `platform`, `sync_type` | Connectors |
| `connector_sync_failures_total` | Counter | `platform`, `error_type` | Connectors |

### 2.3 SLA Metrics (Alerting Thresholds — NOT SLA targets)

> ⚠️ **CANONICAL CLARIFICATION**: The values below are **Grafana alert thresholds**, intentionally set 5-10x looser than the actual SLA targets in `performance_benchmarks.md` to avoid alert fatigue during normal variance.
> - **SLA targets** (canonical, for implementation): `performance_benchmarks.md` → P50 ≤ 10ms, P99 ≤ 50ms
> - **Alert thresholds** (monitoring, below): P50 < 100ms, P99 < 2000ms
> - If an alert fires here, the system is already **far beyond** SLA and needs immediate investigation.

| Metric | Alert Threshold | Fires When |
|---|---|---|
| P50 API latency | < 100ms | — |
| P95 API latency | < 500ms | > 500ms for 5min |
| P99 API latency | < 2000ms | > 2s for 1min |
| Error rate (5xx) | < 0.1% | > 1% for 1min |
| Uptime | 99.9% | Any downtime |

---

## 3. Tracing — OpenTelemetry Integration

### 3.1 Trace Propagation

```
Client (web/mobile)
  → [X-Trace-Id header]
    → Axum middleware (create/continue span)
      → Service layer (child span)
        → DB query (child span, query text)
        → Redis call (child span)
        → Redis Stream publish (propagate trace context in payload metadata)
          → Worker (continue trace)
            → External API call (child span)
```

### 3.2 Key Trace Spans

| Span Name | Attributes | Module |
|---|---|---|
| `http.request` | method, path, status, user_id, workspace_id | All |
| `grpc.call` | service, method, status | All |
| `db.query` | db.system, db.statement (first 200 chars), db.operation | All |
| `cache.operation` | cache.type, cache.key_prefix, cache.hit | All |
| `ai.generate` | ai.provider, ai.model, ai.prompt_tokens, ai.completion_tokens | M08 |
| `publish.execute` | platform, content_type, retry_count | M11 |
| `queue.process` | queue.name, message.id, processing_time | Queue |
| `outbox.poll` | batch_size, published_count | Events |
| `connector.sync` | platform, sync_type, records_count | Connectors |

### 3.3 Sampling Strategy

| Environment | Sample Rate | Head-based | Reason |
|---|---|---|---|
| Dev | 100% | Yes | Full visibility |
| Staging | 100% | Yes | Pre-prod debugging |
| Production | 10% | Yes | Cost management |
| Production (errors) | 100% | Tail-based | Always capture errors |
| Production (slow > 2s) | 100% | Tail-based | Always capture slow |

---

## 4. Error Tracking — Sentry

### 4.1 Sentry Projects

| Project | Platform | DSN Env Var |
|---|---|---|
| `creativanta-api` | Rust (sentry-rust) | `SENTRY_DSN_API` |
| `creativanta-web` | SvelteKit (sentry-svelte) | `SENTRY_DSN_WEB` |
| `creativanta-mobile` | Flutter (sentry_flutter) | `SENTRY_DSN_MOBILE` |
| `creativanta-admin` | SvelteKit | `SENTRY_DSN_ADMIN` |

### 4.2 Error Context

Every Sentry error includes:
- `user.id` — clerk user ID
- `workspace.id` — active workspace
- `workspace.tier` — subscription tier
- `tags.module` — which module (M01-M23)
- `tags.environment` — dev/staging/prod
- Breadcrumbs from `tracing` spans

### 4.3 Alert Rules

| Rule | Condition | Channel |
|---|---|---|
| New error spike | > 10 new errors in 5min | Telegram + Email |
| P0 error | 5xx rate > 1% for 1min | Telegram (immediate) |
| Unhandled exception | Any unhandled panic | Telegram |
| Performance regression | P95 > 500ms for 10min | Email |

---

## 5. Logging — Structured JSON

### 5.1 Log Format

```json
{
  "timestamp": "2026-04-01T13:00:00.000Z",
  "level": "INFO",
  "target": "creativanta_api::publish::executor",
  "span": {"name": "publish.execute", "trace_id": "abc123", "span_id": "def456"},
  "fields": {
    "workspace_id": "22222222-...",
    "platform": "tiktok",
    "item_id": "33333333-...",
    "duration_ms": 1234
  },
  "message": "Publish job completed successfully"
}
```

### 5.2 Log Levels

| Level | Usage | Retention |
|---|---|---|
| `ERROR` | Errors requiring attention | 90 days |
| `WARN` | Degraded but functional | 30 days |
| `INFO` | Key business operations | 14 days |
| `DEBUG` | Detailed flow (dev only) | 1 day |
| `TRACE` | Very detailed (never in prod) | — |

### 5.3 Sensitive Data

| Field | Treatment |
|---|---|
| `email` | Hash or mask (`u***@example.com`) |
| `api_key` | Last 4 chars only (`****abcd`) |
| `password` | NEVER log |
| `token` | NEVER log |
| `credit_card` | NEVER log |

---

## 6. Grafana Dashboards

### 6.1 Dashboard Catalog

| Dashboard | Panels | Audience |
|---|---|---|
| **System Overview** | CPU, memory, disk, containers, DB connections | DevOps |
| **API Performance** | RPS, latency percentiles, error rate, top endpoints | DevOps + Dev |
| **AI Pipeline** | Generation queue depth, provider latency, success rate, cost | Dev + Product |
| **Publishing** | Jobs/min, per-platform success rate, DLQ depth | Dev + Product |
| **Commerce** | Orders/hour, GMV, settlement lag, connector sync status | Product + Biz |
| **Credits & Billing** | Credits consumed/granted per day, low-balance alerts | Product + Biz |
| **Queue Health** | Per-queue depth, processing time, DLQ count, circuit breakers | DevOps |
| **Inbox SLA** | Response times, SLA breach count, urgent thread backlog | Product |

### 6.2 Docker Compose Services

```yaml
# Added to existing docker-compose.yml
prometheus:
  image: prom/prometheus:latest
  volumes:
    - ./infra/prometheus.yml:/etc/prometheus/prometheus.yml
  ports: ["9090:9090"]

grafana:
  image: grafana/grafana:latest
  volumes:
    - grafana-data:/var/lib/grafana
    - ./infra/grafana/dashboards:/etc/grafana/provisioning/dashboards
  ports: ["3001:3000"]
  environment:
    GF_SECURITY_ADMIN_PASSWORD: ${GRAFANA_PASSWORD}

jaeger:
  image: jaegertracing/all-in-one:latest
  ports: ["16686:16686", "4317:4317"]  # UI + OTLP gRPC
  environment:
    COLLECTOR_OTLP_ENABLED: true

loki:
  image: grafana/loki:latest
  ports: ["3100:3100"]
```

---

## 7. Alerting Escalation

| Severity | Condition | Response | Channel |
|---|---|---|---|
| **P0 Critical** | Service down, error > 5%, data loss | 15min response | Telegram → Phone |
| **P1 Major** | Core feature degraded, P95 > 2s | 30min response | Telegram |
| **P2 Minor** | Non-core issue, DLQ growing | 4h response | Email |
| **P3 Low** | Warning threshold, trend anomaly | Next business day | Dashboard only |

> See `06_quality_ops/runbook.md` for incident response procedures.

## 8. SLO / SLI Framework

> ✅ **Added 2026-04-01** — Resolves review finding §13 "No SLO mapping"

### 8.1 Service Level Objectives

| SLO | SLI (Metric) | Target | Measurement Window | Alert |
|---|---|---|---|---|
| **Availability** | `1 - (5xx / total_requests)` | ≥ 99.9% | Rolling 30 days | < 99.5% triggers P0 |
| **Latency (API)** | P95 `http_request_duration_seconds` | ≤ 500ms | Rolling 7 days | > 500ms for 10min |
| **Latency (AI gen)** | P95 `ai_generation_duration_seconds` | ≤ 30s | Rolling 7 days | > 60s for 5min |
| **Publish success** | `publish_success / publish_total` | ≥ 95% | Rolling 7 days | < 90% triggers P1 |
| **Queue freshness** | `max(queue_depth) age` | ≤ 5 min | Continuous | > 15min triggers P2 |
| **Inbox SLA** | `sla_met / total_threads` | ≥ 90% | Rolling 30 days | < 85% triggers P2 |

### 8.2 Error Budget

| SLO | Budget (30 days) | Burn Rate Alert |
|---|---|---|
| 99.9% availability | ~43 min downtime/month | > 1% budget/hour = fast burn alert |
| 95% publish success | 5% failure allowed | > 10% failure/hour = fast burn alert |

---

## 9. Backup & Disaster Recovery

> ✅ **Added 2026-04-01** — Resolves review finding §13 "Backup strategy absent"

### 9.1 Backup Schedule

| Component | Method | Frequency | Retention | Storage |
|---|---|---|---|---|
| PostgreSQL | `pg_dump` compressed | Daily 02:00 UTC | 30 days | Off-VPS (S3-compatible / Hetzner Storage Box) |
| PostgreSQL WAL | Continuous WAL archiving | Continuous | 7 days | Same off-VPS storage |
| ClickHouse | `clickhouse-backup` | Daily 03:00 UTC | 14 days | Off-VPS |
| Meilisearch | Snapshot API | Daily 04:00 UTC | 7 days | Off-VPS |
| File uploads | Rsync to backup volume | Daily 05:00 UTC | 30 days | Off-VPS |
| Docker volumes | Volume snapshot | Weekly | 4 weeks | Off-VPS |
| Config / secrets | Encrypted archive | On change | 90 days | Off-VPS |

### 9.2 Point-in-Time Recovery

- PostgreSQL: WAL replay to any point within 7-day window
- Command: `pg_restore --target-time='2026-04-01 12:00:00'`
- RTO (Recovery Time Objective): ≤ 1 hour
- RPO (Recovery Point Objective): ≤ 5 minutes (WAL-based)

### 9.3 Disaster Recovery Plan

| Scenario | Procedure | RTO |
|---|---|---|
| Single service crash | Docker auto-restart (`restart: unless-stopped`) | < 1 min |
| VPS unresponsive | SSH → `docker compose restart` or hard reboot via Contabo panel | < 15 min |
| Data corruption | Restore from latest backup + WAL replay | < 1 hour |
| Full VPS loss | Provision new VPS → restore from off-VPS backups → DNS update | < 4 hours |
| Region outage | No multi-region in v1. Failover to backup VPS in different DC | < 8 hours |

### 9.4 Backup Verification

- **Monthly**: Restore backup to staging environment and run health checks
- **Automated**: `pg_restore --list` validation after each backup (exit code check)
- **Alerting**: Backup job failure → P1 alert via Telegram

---

## Cross-references

- **Tech stack**: `05_system/tech_stack_adr.md` §12 (tool selection rationale)
- **Performance**: `06_quality_ops/performance_benchmarks.md` (SLA targets)
- **Queue health**: `05_system/queue_retry_design.md` §6 (circuit breaker metrics)
- **Docker**: `06_quality_ops/docker_dev_environment.md` (service definitions)
- **Runbook**: `06_quality_ops/runbook.md` (incident response)
- **Analytics**: `06_quality_ops/analytics_event_taxonomy.md` (PostHog events)
