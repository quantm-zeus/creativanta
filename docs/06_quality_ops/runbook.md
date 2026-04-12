---
layer: quality_ops
canonical: true
created: 2026-03-31
status: READY
---

# Runbook — Incident Response & Operations

> **Infra**: Single Contabo VPS (10 vCPU, 32GB RAM, 400GB SSD)
> **Stack**: Docker Compose, PostgreSQL 17, Dragonfly, ClickHouse

---

## 1. Incident Severity Levels

| Level | Name | Definition | Response Time | Escalation |
|---|---|---|---|---|
| **P0** | Critical | Service fully down, data loss risk | 15 min | Immediate owner notification |
| **P1** | Major | Core feature degraded (publish, orders, AI gen) | 30 min | Within 1 hour |
| **P2** | Minor | Non-core feature issue, workaround available | 4 hours | Next business day |
| **P3** | Low | Cosmetic, documentation, minor UX | 24 hours | Backlog |

---

## 2. Health Check Endpoints

| Service | Endpoint | Expected | Check Interval |
|---|---|---|---|
| API (Axum) | `/health` | `200 OK` + `{"status": "healthy"}` | 30s |
| API (deep) | `/health/ready` | `200` + DB + Redis connected | 60s |
| Web (SvelteKit) | `/` | `200` | 60s |
| PostgreSQL | Port 5432 | `pg_isready` returns 0 | 30s |
| Dragonfly | Port 6379 | `PING` → `PONG` | 30s |
| ClickHouse | Port 8123 | `/ping` → `Ok.` | 60s |

---

## 3. Common Failure Scenarios

### 3.1 Database Connection Pool Exhausted

**Symptoms**: API returns 503, logs show `connection pool timeout`
**Diagnosis**:
```bash
docker exec creativanta-db psql -U creativanta -c "SELECT count(*) FROM pg_stat_activity;"
docker exec creativanta-db psql -U creativanta -c "SELECT state, count(*) FROM pg_stat_activity GROUP BY state;"
```
**Remediation**:
1. Check for long-running queries: `SELECT pid, now() - query_start AS duration, query FROM pg_stat_activity WHERE state = 'active' ORDER BY duration DESC LIMIT 10;`
2. Kill idle-in-transaction: `SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE state = 'idle in transaction' AND now() - state_change > interval '5 minutes';`
3. If persistent: restart API service `docker compose restart api`
4. Long-term: increase pool size in `DATABASE_URL` connection string

### 3.2 AI Provider Rate Limited / Down

**Symptoms**: Generation jobs failing, circuit breaker tripping
**Diagnosis**: Check `diagnostics_records` for error_type containing `ProviderDown` or `QuotaExceeded`
**Remediation**:
1. Circuit breaker (§6 of queue_retry_design) will auto-recover after reset timeout
2. If persistent: switch to fallback provider via feature flag `ai_provider_fallback`
3. Notify users via system announcement

### 3.3 Disk Space Critical

**Symptoms**: Docker logs show `no space left on device`
**Diagnosis**: `df -h` and `docker system df`
**Remediation**:
1. `docker system prune -f` (remove stopped containers, dangling images)
2. Clean old outbox: `DELETE FROM event_outbox WHERE published = true AND created_at < NOW() - INTERVAL '7 days';`
3. Clean old audit events: Check partition strategy
4. Archive old DLQ items

### 3.4 Redis/Dragonfly OOM

**Symptoms**: Cache misses, rate limiter failures
**Diagnosis**: `docker exec dragonfly redis-cli INFO memory`
**Remediation**:
1. Check maxmemory policy: should be `allkeys-lru`
2. Flush non-critical caches: `redis-cli FLUSHDB` (only cache DB, not streams)
3. Increase Docker memory limit

### 3.5 Publish Job Stuck

**Symptoms**: Publishing to platforms hangs, DLQ growing
**Diagnosis**: Check `dead_letter_queue` table for `queue_name = 'publish_jobs'`
**Remediation**:
1. Check platform API status (TikTok, Shopee status pages)
2. Review DLQ error messages
3. If token expired: refresh via `connected_accounts` re-auth flow
4. Manual retry: Update DLQ status to `retrying`

---

## 4. Deployment Rollback

```bash
# Identify previous working image tag
docker images creativanta-api --format "{{.Tag}}" | head -5

# Rollback to previous tag
export ROLLBACK_TAG=<previous_sha>
docker compose down api
IMAGE_TAG=$ROLLBACK_TAG docker compose up -d api

# Verify
curl -f https://app.creativanta.app/health
```

**Database rollback**:
```bash
# SeaORM migration down (last N migrations)
sea-orm-cli migrate down -n 1 -d ./migration
```

---

## 5. On-Call Rotation

> Pre-launch phase: founder handles all incidents. Scale to rotation when team grows.

| Role | Responsibility | Contact |
|---|---|---|
| Primary on-call | First responder for P0/P1 | Founder (default until team > 3) |
| Secondary on-call | Backup if primary unavailable | Co-founder / Senior Dev |
| Escalation manager | For incidents > 1 hour unresolved | Founder (always) |

**Post-launch scaling**:
- Team ≤ 3: Founder on-call 24/7 with PagerDuty/Opsgenie
- Team 4-8: Weekly rotation, 2 engineers on-call
- Team 8+: Standard rotation (1 primary + 1 secondary per week)

---

## 6. Post-Mortem Template

After every P0/P1 incident, create a post-mortem within 48 hours:

```markdown
# Post-Mortem: [Incident Title]

**Date**: YYYY-MM-DD
**Duration**: X hours Y minutes
**Severity**: P0/P1
**Author**: [Name]

## Summary
[1-2 sentence summary]

## Timeline
- HH:MM — [Event]
- HH:MM — [Event]

## Root Cause
[Technical root cause]

## Impact
- Users affected: X
- Revenue impact: $Y
- Data loss: None/Details

## Resolution
[What fixed it]

## Action Items
| # | Action | Owner | Due Date | Status |
|---|--------|-------|----------|--------|
| 1 | [Action] | [Name] | YYYY-MM-DD | Open |

## Lessons Learned
1. [Lesson]
2. [Lesson]
```

---

## 7. Database Recovery Procedures

### 7.1 Point-in-Time Recovery
```bash
# Stop application
docker compose stop api worker

# Restore from backup
pg_restore -U postgres -d creativanta_restore /backups/daily/creativanta_YYYYMMDD.dump

# Replay WAL to specific point
pg_restore --target-time='2026-04-01 12:00:00' -d creativanta

# Verify data integrity
psql -U postgres -d creativanta -c "SELECT count(*) FROM workspaces;"

# Restart application
docker compose up -d api worker
```

### 7.2 Table-Level Recovery
```bash
# Restore single table from backup
pg_restore -U postgres -d creativanta -t <table_name> /backups/daily/creativanta_YYYYMMDD.dump
```

---

## 8. Cache Flush Procedures

### 8.1 Full Cache Flush (Dragonfly)
```bash
# Connect to Dragonfly
docker exec -it dragonfly redis-cli

# Flush specific module cache
DEL creativanta:cache:publish:*
DEL creativanta:cache:analytics:*

# Nuclear option: flush all
FLUSHDB
```

### 8.2 Meilisearch Index Rebuild
```bash
# Delete and recreate index
curl -X DELETE http://localhost:7700/indexes/content
# Re-index from PostgreSQL
docker exec api creativanta-cli reindex --index content
```

---

## 9. Credential Rotation

### 9.1 Database Password
```bash
# 1. Generate new password
NEW_PASS=$(openssl rand -base64 32)
# 2. Update PostgreSQL
docker exec postgres psql -U postgres -c "ALTER USER app_user PASSWORD '$NEW_PASS';"
# 3. Update .env
sed -i "s/DATABASE_PASSWORD=.*/DATABASE_PASSWORD=$NEW_PASS/" .env
# 4. Restart API
docker compose restart api worker
```

### 9.2 API Key Rotation (External Providers)
| Provider | Rotation Location | Impact During Rotation |
|---|---|---|
| Clerk | Dashboard → API Keys | 0 downtime (overlapping keys) |
| Sentry | Settings → Auth Tokens | 0 downtime (new DSN) |
| ElevenLabs | Profile → API Keys | Brief AI gen pause |
| TikTok/Meta | Developer Portal | OAuth re-auth required |

### 9.3 Internal Secrets
```bash
# Rotate JWT signing key (will invalidate all sessions)
openssl rand -base64 64 > /secrets/jwt_signing_key
docker compose restart api
# Note: All users will need to re-authenticate
```

---

## 10. Disaster Recovery & Backup

> Source: Pricing/Credits/Growth Contract §9B

### 10.1 RPO/RTO Targets

| Data Category | RPO (Recovery Point Objective) | RTO (Recovery Time Objective) | Backup Method |
|---|---|---|---|
| **Financial** (orders, settlements, credits, invoices) | 0 (zero data loss) | 1 hour | Synchronous WAL replication |
| **Content** (assets, scripts, ideas, derivatives) | 1 hour | 4 hours | Hourly incremental backup |
| **Analytics** (metrics, reports, trends) | 4 hours | 8 hours | Daily backup, ClickHouse snapshots |
| **Audit** (audit_events, compliance logs) | 0 (zero data loss) | 1 hour | Synchronous WAL, immutable store |
| **User data** (profiles, settings, preferences) | 1 hour | 2 hours | Hourly incremental backup |

### 10.2 Backup Strategy

| Backup Type | Frequency | Retention | Storage |
|---|---|---|---|
| WAL streaming | Continuous | 7 days | R2 (SG region) |
| Incremental | Hourly | 30 days | R2 (SG region) |
| Full backup | Daily (2:00 AM ICT) | 90 days | R2 (SG + backup region) |
| Monthly archive | Monthly | 1 year | R2 cold storage (3 regions) |

### 10.3 Immutable Backup Rules
- Audit event backups: immutable (cannot be deleted or modified by any role)
- Financial backups: immutable retention for 7 years (legal/tax compliance)
- All backups encrypted at rest (AES-256)
- Backup integrity: SHA-256 checksum verified on each write and periodic spot-check

### 10.4 Backup Verification
- **Weekly**: Automated restore test to staging environment
  - Restore latest daily backup
  - Run data integrity checks (row counts, checksum sampling)
  - Verify within RPO/RTO targets
  - Report: pass/fail + restore duration
- **Monthly**: Full disaster simulation
  - Failover to backup infrastructure
  - Verify all services functional
  - Measure actual RTO
  - Document lessons learned

### 10.5 Cross-Region Replication

```
Primary: Singapore (Contabo SG)
├── PostgreSQL (WAL streaming to R2 SG)
├── ClickHouse (daily snapshot to R2 SG)
└── R2 Object Storage (primary media)

Backup: Vietnam / Japan (future scaling)
├── R2 replication (automatic)
└── Cold storage monthly archives
```

### 10.6 Failover Architecture

> Phase 1 (single server): Manual failover with automated backup restore
> Phase 2 (scaling): Active-Passive warm standby with DNS failover

**Phase 1 Failover Procedure** (current):
1. Detect: health check fails for > 5 minutes
2. Assess: determine if recoverable (restart) or requires restore
3. If restart: `docker compose restart` → verify health endpoints
4. If restore: provision new server → restore from latest backup → update DNS
5. Verify: run data integrity checks → confirm RTO met
6. Notify: update public status page → email affected users

**Phase 2 Failover Procedure** (future):
1. DNS failover (automatic, TTL: 60s)
2. Warm standby promotes to primary
3. WAL replay catches up (RPO: ~0 for financial)
4. Health checks confirm new primary
5. Post-failover: investigate root cause of primary failure

### 10.7 P0 Incident Protocol
- Status page updated within **15 minutes** of detection
- Ongoing updates every **30 minutes** until resolution
- Post-mortem published within **5 business days**
- Affected users notified via email with impact summary

---

## Cross-references

- **Backup schedule**: `05_system/observability.md` §9 (Backup & Disaster Recovery)
- **Incident management**: `02_features/platform/internal_admin.md` §3.4
- **Security**: `06_quality_ops/security_threat_model.md`
- **Status page**: `02_features/platform/help_center.md` §5

