---
paths:
  - "**/*.rs"
  - "**/migrations/**"
description: Security and data integrity rules for Rust backend and DB migrations
---
# Security Rules

## Multi-tenant isolation (CRITICAL)
- Every query on tenant-scoped tables MUST have WHERE workspace_id = current_tenant_id
- New tables MUST have: ALTER TABLE <t> ENABLE ROW LEVEL SECURITY;
- New tables MUST have: ALTER TABLE <t> FORCE ROW LEVEL SECURITY; (see DB-C-001)
- Create policy: CREATE POLICY tenant_isolation ON <t> USING (workspace_id = ...)

## Data types
- Money fields: NUMERIC(18,6) ONLY — never REAL, FLOAT, DOUBLE (see DB-H-001)
- Credit fields: NUMERIC(18,6) ONLY
- Score fields (0-100): NUMERIC(5,2) preferred over REAL for sort consistency

## Audit requirements
- Every write action must emit an audit event
- State transitions must have audit trail
- Business-critical side effects must be fully logged

## Soft delete
- Production tables (ideas, scripts, assets, offers, orders) need deleted_at TIMESTAMPTZ
- See DB-H-003 in OPEN_BLOCKERS.md
