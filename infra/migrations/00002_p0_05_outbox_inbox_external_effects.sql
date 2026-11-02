-- +goose Up
-- P0-05: Outbox, consumer inbox, unknown external effects, diagnostics records, DLQ, and audit immutability
-- Source of truth: docs/04_contracts/database_schema.md (§13.3, §13.4, §18.4A, §18.4D, §18.4G, §18.4H, §26.6, §26.8, §26.11–§26.13)

-- =============================================================================
-- 1. Durable Consumer Inbox (§26.6)
-- =============================================================================

CREATE TABLE consumer_inbox (
  inbox_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  consumer_name VARCHAR(100) NOT NULL,
  event_id UUID NOT NULL,
  processed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(workspace_id, consumer_name, event_id)
);
CREATE INDEX idx_ci_workspace_event ON consumer_inbox(workspace_id, event_id);
ALTER TABLE consumer_inbox ENABLE ROW LEVEL SECURITY;
ALTER TABLE consumer_inbox FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON consumer_inbox
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

-- =============================================================================
-- 2. Durable External Effects Registry (§26.8)
-- =============================================================================

CREATE TABLE external_effects (
  effect_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  operation_key VARCHAR(255) NOT NULL,
  provider VARCHAR(100) NOT NULL,
  connected_account_id UUID REFERENCES connected_accounts(connected_account_id),
  aggregate_type VARCHAR(100) NOT NULL,
  aggregate_id UUID NOT NULL,
  provider_request_id VARCHAR(255),
  status VARCHAR(20) NOT NULL CHECK (status IN ('prepared','submitted','succeeded','failed','unknown','cancelled')),
  result_payload JSONB,
  last_checked_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(workspace_id, operation_key)
);
CREATE INDEX idx_ee_workspace_status ON external_effects(workspace_id, status);
CREATE INDEX idx_ee_aggregate ON external_effects(workspace_id, aggregate_type, aggregate_id);
ALTER TABLE external_effects ENABLE ROW LEVEL SECURITY;
ALTER TABLE external_effects FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON external_effects
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

-- =============================================================================
-- 3. Diagnostics Records (§13.4, §26.13)
-- =============================================================================

CREATE TABLE diagnostics_records (
  diagnostics_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID REFERENCES workspaces(workspace_id),
  scope_type VARCHAR(50) NOT NULL,
  scope_id UUID,
  error_type VARCHAR(100) NOT NULL,
  severity VARCHAR(20) NOT NULL CHECK (severity IN ('info','warning','error','critical')),
  user_facing_explanation TEXT NOT NULL,
  operator_explanation TEXT,
  likely_causes JSONB DEFAULT '[]',
  suggested_actions JSONB DEFAULT '[]',
  repair_path TEXT,
  status VARCHAR(20) NOT NULL DEFAULT 'open' CHECK (status IN ('open','acknowledged','resolving','resolved','closed')),
  detected_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  resolved_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_dr_workspace ON diagnostics_records(workspace_id);
CREATE INDEX idx_dr_severity ON diagnostics_records(severity);
CREATE INDEX idx_dr_status ON diagnostics_records(status);
ALTER TABLE diagnostics_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE diagnostics_records FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON diagnostics_records
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
CREATE POLICY admin_ops_scope ON diagnostics_records TO admin_user USING (true) WITH CHECK (true);

-- =============================================================================
-- 4. Dead Letter Queue (§18.4G, §26.13)
-- =============================================================================

CREATE TABLE dead_letter_queue (
  dlq_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  queue_name VARCHAR(100) NOT NULL,
  original_message_id VARCHAR(255) NOT NULL,
  payload JSONB NOT NULL,
  error_class VARCHAR(50) NOT NULL,
  error_message TEXT,
  last_error_at TIMESTAMPTZ NOT NULL,
  attempt_count INTEGER NOT NULL,
  retry_history JSONB DEFAULT '[]',
  workspace_id UUID REFERENCES workspaces(workspace_id),
  status VARCHAR(20) NOT NULL DEFAULT 'pending',
  resolved_at TIMESTAMPTZ,
  resolved_by UUID REFERENCES internal_admins(admin_id),
  resolution_notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_dlq_queue ON dead_letter_queue(queue_name, status);
CREATE INDEX idx_dlq_workspace ON dead_letter_queue(workspace_id);
ALTER TABLE dead_letter_queue ADD CONSTRAINT chk_dead_letter_queue_status
  CHECK (status IN ('pending', 'retrying', 'resolved', 'discarded'));
ALTER TABLE dead_letter_queue ENABLE ROW LEVEL SECURITY;
ALTER TABLE dead_letter_queue FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON dead_letter_queue
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
CREATE POLICY admin_ops_scope ON dead_letter_queue TO admin_user USING (true) WITH CHECK (true);

-- =============================================================================
-- 5. Background Jobs (§18.4D, §26.13)
-- =============================================================================

CREATE TABLE background_jobs (
  job_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID REFERENCES workspaces(workspace_id),
  queue_name VARCHAR(100) NOT NULL,
  job_type VARCHAR(100) NOT NULL,
  status VARCHAR(30) NOT NULL DEFAULT 'queued',
  priority VARCHAR(10) NOT NULL DEFAULT 'normal',
  progress_percentage REAL NOT NULL DEFAULT 0,
  step_name VARCHAR(255),
  provider VARCHAR(50),
  payload JSONB NOT NULL DEFAULT '{}',
  result_summary JSONB NOT NULL DEFAULT '{}',
  error_class VARCHAR(50),
  error_message TEXT,
  attempt_count INTEGER NOT NULL DEFAULT 0,
  max_attempts INTEGER NOT NULL DEFAULT 3,
  requested_by UUID,
  scheduled_at TIMESTAMPTZ,
  started_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  last_heartbeat_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_bgj_queue_status ON background_jobs(queue_name, status, created_at DESC);
CREATE INDEX idx_bgj_workspace ON background_jobs(workspace_id, created_at DESC);
ALTER TABLE background_jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE background_jobs FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON background_jobs
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
CREATE POLICY admin_ops_scope ON background_jobs TO admin_user USING (true) WITH CHECK (true);
ALTER TABLE background_jobs ADD CONSTRAINT chk_background_jobs_status
  CHECK (status IN ('queued', 'running', 'paused', 'succeeded', 'failed', 'cancelled', 'dead_lettered'));
ALTER TABLE background_jobs ADD CONSTRAINT chk_background_jobs_priority
  CHECK (priority IN ('urgent', 'high', 'normal', 'low'));

-- =============================================================================
-- 6. Daily Public API Usage (§18.4A)
-- =============================================================================

CREATE TABLE api_usage_daily (
  usage_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  api_key_id UUID NOT NULL REFERENCES api_keys(api_key_id),
  usage_date DATE NOT NULL,
  read_requests INTEGER NOT NULL DEFAULT 0,
  write_requests INTEGER NOT NULL DEFAULT 0,
  error_4xx_count INTEGER NOT NULL DEFAULT 0,
  error_5xx_count INTEGER NOT NULL DEFAULT 0,
  outbound_webhook_deliveries INTEGER NOT NULL DEFAULT 0,
  billable_ai_credits NUMERIC(18,6) NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(api_key_id, usage_date)
);
CREATE INDEX idx_aud_workspace ON api_usage_daily(workspace_id);
CREATE INDEX idx_aud_key_date ON api_usage_daily(api_key_id, usage_date DESC);
ALTER TABLE api_usage_daily ENABLE ROW LEVEL SECURITY;
ALTER TABLE api_usage_daily FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON api_usage_daily
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

-- =============================================================================
-- 7. Same-Tenant Composite Foreign Keys (§26.11)
-- =============================================================================

ALTER TABLE external_effects
  ADD CONSTRAINT fk_external_effects_connected_account_id_tenant
  FOREIGN KEY (workspace_id, connected_account_id)
  REFERENCES connected_accounts(workspace_id, connected_account_id);

ALTER TABLE api_usage_daily
  ADD CONSTRAINT fk_api_usage_daily_api_key_id_tenant
  FOREIGN KEY (workspace_id, api_key_id)
  REFERENCES api_keys(workspace_id, api_key_id);

-- =============================================================================
-- 8. Audit Log Immutability Triggers (§13.3, §17.2, §26.12)
-- =============================================================================

-- +goose StatementBegin
CREATE OR REPLACE FUNCTION protect_audit_log_immutability() RETURNS trigger
LANGUAGE plpgsql AS $$
BEGIN
  RAISE EXCEPTION 'audit log records are immutable (% on % prohibited)', TG_OP, TG_TABLE_NAME;
END
$$;
-- +goose StatementEnd

CREATE TRIGGER audit_events_immutable
  BEFORE UPDATE OR DELETE ON audit_events
  FOR EACH ROW EXECUTE FUNCTION protect_audit_log_immutability();

CREATE TRIGGER internal_audit_logs_immutable
  BEFORE UPDATE OR DELETE ON internal_audit_logs
  FOR EACH ROW EXECUTE FUNCTION protect_audit_log_immutability();

-- =============================================================================
-- 9. Narrow Runtime Role Grants (§26.12)
-- =============================================================================

GRANT SELECT, INSERT, UPDATE, DELETE ON consumer_inbox TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON external_effects TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON api_usage_daily TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON diagnostics_records TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON dead_letter_queue TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON background_jobs TO app_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON diagnostics_records TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON dead_letter_queue TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON background_jobs TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON consumer_inbox TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON external_effects TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON api_usage_daily TO admin_user;

-- +goose Down
REVOKE ALL PRIVILEGES ON
  consumer_inbox,
  external_effects,
  diagnostics_records,
  dead_letter_queue,
  background_jobs,
  api_usage_daily
FROM app_user, admin_user, outbox_poller;

DROP TRIGGER IF EXISTS internal_audit_logs_immutable ON internal_audit_logs;
DROP TRIGGER IF EXISTS audit_events_immutable ON audit_events;
DROP FUNCTION IF EXISTS protect_audit_log_immutability();

ALTER TABLE api_usage_daily DROP CONSTRAINT IF EXISTS fk_api_usage_daily_api_key_id_tenant;
ALTER TABLE external_effects DROP CONSTRAINT IF EXISTS fk_external_effects_connected_account_id_tenant;

DROP TABLE IF EXISTS api_usage_daily;
DROP TABLE IF EXISTS background_jobs;
DROP TABLE IF EXISTS dead_letter_queue;
DROP TABLE IF EXISTS diagnostics_records;
DROP TABLE IF EXISTS external_effects;
DROP TABLE IF EXISTS consumer_inbox;
