-- ============================================================================
-- Creativanta P8-02 Migration: Full Billing, Retention, Data Exports & Cohort Economics
-- Canonical Sources:
--   - docs/04_contracts/database_schema.md (§11.6, §13.1, §14.3, §18.7, §18.8, §19.1, §22.8)
--   - docs/01_business/pricing_and_credits.md (§1–§6)
--   - docs/01_business/business_rules.md (BIZ-002, BIZ-007, BIZ-009, BIZ-010, BIZ-013, BIZ-014)
--   - docs/01_business/legal_compliance.md (§3 Data Retention, §4 GDPR/PDPA)
--   - docs/06_quality_ops/analytics_event_taxonomy.md (§6 Cohort Economics)
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. export_jobs (§18.8 GDPR/PDPA Data Exports & Financial Report Exports)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS export_jobs (
  export_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id    UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  user_id         UUID NOT NULL REFERENCES users(user_id),
  export_type     VARCHAR(50) NOT NULL, -- data_export, tax_report, gdpr_export, analytics_export, media_export
  format          VARCHAR(20) NOT NULL DEFAULT 'csv', -- csv, xlsx, pdf, json, zip
  filters         JSONB DEFAULT '{}'::jsonb,
  status          VARCHAR(20) NOT NULL DEFAULT 'queued'
                  CHECK (status IN ('queued', 'processing', 'completed', 'failed', 'expired')),
  progress_pct    SMALLINT DEFAULT 0,
  file_url        TEXT,
  file_size_bytes BIGINT,
  expires_at      TIMESTAMPTZ,
  completed_at    TIMESTAMPTZ,
  error_message   TEXT,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_export_jobs_tenant_pk UNIQUE (workspace_id, export_id)
);

CREATE INDEX IF NOT EXISTS idx_ej_workspace_status
  ON export_jobs(workspace_id, status, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_ej_workspace_type
  ON export_jobs(workspace_id, export_type, created_at DESC);

ALTER TABLE export_jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE export_jobs FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON export_jobs;
CREATE POLICY tenant_isolation ON export_jobs
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON export_jobs;
CREATE POLICY admin_ops_scope ON export_jobs
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 2. referral_records (§18.7 Referral Program Credits)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS referral_records (
  referral_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id             UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  referee_workspace_id     UUID REFERENCES workspaces(workspace_id),
  referrer_user_id         UUID NOT NULL REFERENCES users(user_id),
  referee_user_id          UUID NOT NULL REFERENCES users(user_id),
  referral_code            VARCHAR(20) NOT NULL,
  status                   VARCHAR(20) NOT NULL DEFAULT 'pending'
                           CHECK (status IN ('pending', 'qualified', 'rewarded', 'revoked')),
  referrer_credits_awarded NUMERIC(18,6) NOT NULL DEFAULT 0,
  referee_credits_awarded  NUMERIC(18,6) NOT NULL DEFAULT 0,
  qualified_at             TIMESTAMPTZ,
  rewarded_at              TIMESTAMPTZ,
  created_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_referral_records_tenant_pk UNIQUE (workspace_id, referral_id)
);

CREATE INDEX IF NOT EXISTS idx_rr_workspace
  ON referral_records(workspace_id, status);

ALTER TABLE referral_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE referral_records FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON referral_records;
CREATE POLICY tenant_isolation ON referral_records
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON referral_records;
CREATE POLICY admin_ops_scope ON referral_records
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 3. api_call_logs (§14.3 Provider Call Cost Telemetry for Unit Economics)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS api_call_logs (
  time          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  workspace_id  UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  provider      VARCHAR(50) NOT NULL,
  model         VARCHAR(100),
  operation     VARCHAR(50) NOT NULL,
  input_tokens  INTEGER,
  output_tokens INTEGER,
  cost_usd      NUMERIC(18,6),
  latency_ms    INTEGER,
  status        VARCHAR(20) NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_acl_workspace_time
  ON api_call_logs(workspace_id, time DESC);

ALTER TABLE api_call_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE api_call_logs FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON api_call_logs;
CREATE POLICY tenant_isolation ON api_call_logs
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON api_call_logs;
CREATE POLICY admin_ops_scope ON api_call_logs
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 4. chargebacks (§21.2 Dispute & Chargeback Cost Economics)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS chargebacks (
  chargeback_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id              UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  order_id                  UUID NOT NULL REFERENCES orders(order_id),
  external_chargeback_id    VARCHAR(255),
  amount                    NUMERIC(18,6) NOT NULL,
  currency                  VARCHAR(5) DEFAULT 'VND',
  reason                    VARCHAR(100),
  lifecycle_state           VARCHAR(20) NOT NULL DEFAULT 'opened'
                            CHECK (lifecycle_state IN ('opened', 'evidence_submitted', 'won', 'lost')),
  evidence_submitted_at     TIMESTAMPTZ,
  resolved_at               TIMESTAMPTZ,
  financial_impact_recorded BOOLEAN DEFAULT false,
  created_at                TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at                TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_chargebacks_tenant_pk UNIQUE (workspace_id, chargeback_id),
  CONSTRAINT fk_chargebacks_order_id_tenant
    FOREIGN KEY (workspace_id, order_id)
    REFERENCES orders(workspace_id, order_id)
);

CREATE INDEX IF NOT EXISTS idx_cb_workspace_state
  ON chargebacks(workspace_id, lifecycle_state);

ALTER TABLE chargebacks ENABLE ROW LEVEL SECURITY;
ALTER TABLE chargebacks FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON chargebacks;
CREATE POLICY tenant_isolation ON chargebacks
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON chargebacks;
CREATE POLICY admin_ops_scope ON chargebacks
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 5. platform_fee_schedules (§21.4 Official Marketplace Fee Schedules)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS platform_fee_schedules (
  fee_schedule_id  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  platform         VARCHAR(50) NOT NULL,
  region           VARCHAR(50) NOT NULL DEFAULT 'VN',
  category         VARCHAR(100),
  fee_type         VARCHAR(50) NOT NULL,
  fee_pct          NUMERIC(5,4),
  fee_fixed        NUMERIC(18,6),
  fee_currency     VARCHAR(5) DEFAULT 'VND',
  effective_from   DATE NOT NULL,
  effective_until  DATE,
  source_url       TEXT,
  last_verified_at TIMESTAMPTZ,
  notes            TEXT,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_pfs_platform_region
  ON platform_fee_schedules(platform, region, effective_from DESC);

-- ----------------------------------------------------------------------------
-- 6. performance_reports (§22.8 Periodic Performance & Cohort Reports)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS performance_reports (
  report_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id           UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  period                 VARCHAR(10) NOT NULL,
  period_start           DATE NOT NULL,
  period_end             DATE NOT NULL,
  publish_items_analyzed UUID[] DEFAULT '{}',
  metrics                JSONB NOT NULL DEFAULT '{}'::jsonb,
  suggestions            JSONB DEFAULT '[]'::jsonb,
  generated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_performance_reports_tenant_pk UNIQUE (workspace_id, report_id)
);

CREATE INDEX IF NOT EXISTS idx_pr_workspace_period
  ON performance_reports(workspace_id, period_start DESC);

ALTER TABLE performance_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE performance_reports FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON performance_reports;
CREATE POLICY tenant_isolation ON performance_reports
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON performance_reports;
CREATE POLICY admin_ops_scope ON performance_reports
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 7. Narrow Role Grants (§26.12 — NEVER GRANT ALL)
-- ----------------------------------------------------------------------------
GRANT SELECT, INSERT, UPDATE, DELETE ON export_jobs TO app_user, admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON referral_records TO app_user, admin_user;
GRANT SELECT, INSERT ON api_call_logs TO app_user, admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON chargebacks TO app_user, admin_user;
GRANT SELECT ON platform_fee_schedules TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON platform_fee_schedules TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON performance_reports TO app_user, admin_user;

-- +goose Down
REVOKE SELECT, INSERT, UPDATE, DELETE ON performance_reports FROM app_user, admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON platform_fee_schedules FROM admin_user;
REVOKE SELECT ON platform_fee_schedules FROM app_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON chargebacks FROM app_user, admin_user;
REVOKE SELECT, INSERT ON api_call_logs FROM app_user, admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON referral_records FROM app_user, admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON export_jobs FROM app_user, admin_user;

DROP TABLE IF EXISTS performance_reports CASCADE;
DROP TABLE IF EXISTS platform_fee_schedules CASCADE;
DROP TABLE IF EXISTS chargebacks CASCADE;
DROP TABLE IF EXISTS api_call_logs CASCADE;
DROP TABLE IF EXISTS referral_records CASCADE;
DROP TABLE IF EXISTS export_jobs CASCADE;
