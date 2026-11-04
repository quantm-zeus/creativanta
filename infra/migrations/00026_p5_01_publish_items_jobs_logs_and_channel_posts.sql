-- ============================================================================
-- Creativanta P5-01 Migration: Publish Hub, Jobs, Logs & Channel Posts
-- Canonical Sources: docs/04_contracts/database_schema.md (§8.1, §8.2, §8.3, §19.9D)
--                    docs/02_features/publish/publish_hub.md (RULE-M11-001..007)
--                    docs/04_contracts/domain_event_catalog.md (§6, §16.5)
--                    docs/04_contracts/rbac_permission_matrix.md (§2.5)
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. publish_items Table (§8.1)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS publish_items (
  publish_item_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id           UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  asset_id               UUID REFERENCES assets(asset_id),
  target_platform        VARCHAR(50) NOT NULL,
  target_account_id      UUID REFERENCES connected_accounts(connected_account_id),
  target_format          VARCHAR(20),
  publish_mode           VARCHAR(20) NOT NULL DEFAULT 'direct', -- direct, draft, export, manual
  title                  TEXT,
  description            TEXT,
  hashtags               JSONB DEFAULT '[]'::jsonb,
  schedule_at            TIMESTAMPTZ,
  capability_snapshot_id UUID,
  lifecycle_state        VARCHAR(30) NOT NULL DEFAULT 'draft',
  diagnostics_state      VARCHAR(20) DEFAULT 'healthy', -- healthy, warning, degraded, blocked
  linked_offer_ids       UUID[] DEFAULT '{}',
  linked_campaign_ids    UUID[] DEFAULT '{}',
  packaging_score        REAL, -- 0-100 non-financial score
  compliance_scan_result VARCHAR(20), -- pass, pass_with_warnings, review_required, blocked
  compliance_details     JSONB,
  metadata               JSONB DEFAULT '{}'::jsonb,
  created_by             UUID REFERENCES users(user_id),
  created_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at             TIMESTAMPTZ, -- soft delete (DB-H-003)
  CONSTRAINT uq_publish_items_tenant_pk UNIQUE (workspace_id, publish_item_id),
  CONSTRAINT chk_publish_items_lifecycle_state
    CHECK (lifecycle_state IN ('draft', 'queued', 'scheduled', 'ready_to_execute', 'executing', 'published', 'partially_published', 'failed', 'cancelled', 'requires_manual_fallback'))
);

CREATE INDEX IF NOT EXISTS idx_pi_workspace ON publish_items(workspace_id);
CREATE INDEX IF NOT EXISTS idx_pi_state ON publish_items(lifecycle_state);
CREATE INDEX IF NOT EXISTS idx_pi_schedule ON publish_items(schedule_at);
CREATE INDEX IF NOT EXISTS idx_pi_platform ON publish_items(target_platform);

ALTER TABLE publish_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE publish_items FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON publish_items;
CREATE POLICY tenant_isolation ON publish_items
  FOR ALL
  TO app_user
  USING (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  )
  WITH CHECK (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  );

DROP POLICY IF EXISTS admin_ops_scope ON publish_items;
CREATE POLICY admin_ops_scope ON publish_items
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 2. publish_jobs Table (§8.2)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS publish_jobs (
  publish_job_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id           UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  publish_item_id        UUID NOT NULL REFERENCES publish_items(publish_item_id) ON DELETE CASCADE,
  dispatch_strategy      VARCHAR(30),
  lifecycle_state        VARCHAR(30) NOT NULL DEFAULT 'created',
  attempt_count          INTEGER DEFAULT 0,
  max_attempts           INTEGER DEFAULT 3,
  current_worker_id      VARCHAR(100),
  last_execution_summary JSONB,
  approval_request_id    UUID,
  created_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at             TIMESTAMPTZ, -- soft delete (DB-H-003)
  CONSTRAINT uq_publish_jobs_tenant_pk UNIQUE (workspace_id, publish_job_id),
  CONSTRAINT fk_publish_jobs_publish_item_id_tenant
    FOREIGN KEY (workspace_id, publish_item_id)
    REFERENCES publish_items(workspace_id, publish_item_id) ON DELETE CASCADE,
  CONSTRAINT chk_publish_jobs_lifecycle_state
    CHECK (lifecycle_state IN ('created', 'queued', 'dispatched', 'executing', 'partially_succeeded', 'succeeded', 'failed', 'cancelled', 'requires_manual_fallback'))
);

CREATE INDEX IF NOT EXISTS idx_pj_item ON publish_jobs(publish_item_id);
CREATE INDEX IF NOT EXISTS idx_pj_state ON publish_jobs(lifecycle_state);

ALTER TABLE publish_jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE publish_jobs FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON publish_jobs;
CREATE POLICY tenant_isolation ON publish_jobs
  FOR ALL
  TO app_user
  USING (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  )
  WITH CHECK (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  );

DROP POLICY IF EXISTS admin_ops_scope ON publish_jobs;
CREATE POLICY admin_ops_scope ON publish_jobs
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 3. publish_logs Table (immutable, §8.3)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS publish_logs (
  publish_log_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id           UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  publish_job_id         UUID NOT NULL REFERENCES publish_jobs(publish_job_id) ON DELETE CASCADE,
  publish_item_id        UUID NOT NULL REFERENCES publish_items(publish_item_id) ON DELETE CASCADE,
  attempted_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  completed_at           TIMESTAMPTZ,
  failed_at              TIMESTAMPTZ,
  actor_user_id          UUID,
  acting_mode            operator_mode,
  execution_path         VARCHAR(50), -- native_api, manual_upload, export_package
  capability_snapshot_id UUID,
  result_status          VARCHAR(30) NOT NULL, -- success, partial_success, failed, timeout
  external_post_id       VARCHAR(255),
  external_post_url      TEXT,
  diagnostics_ref        UUID,
  evidence_ref           UUID,
  error_code             VARCHAR(50),
  error_message          TEXT,
  metadata               JSONB DEFAULT '{}'::jsonb,
  CONSTRAINT fk_publish_logs_publish_item_id_tenant
    FOREIGN KEY (workspace_id, publish_item_id)
    REFERENCES publish_items(workspace_id, publish_item_id) ON DELETE CASCADE,
  CONSTRAINT fk_publish_logs_publish_job_id_tenant
    FOREIGN KEY (workspace_id, publish_job_id)
    REFERENCES publish_jobs(workspace_id, publish_job_id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_pl_item ON publish_logs(publish_item_id);
CREATE INDEX IF NOT EXISTS idx_pl_time ON publish_logs(attempted_at DESC);

ALTER TABLE publish_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE publish_logs FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON publish_logs;
CREATE POLICY tenant_isolation ON publish_logs
  FOR ALL
  TO app_user
  USING (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  )
  WITH CHECK (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  );

DROP POLICY IF EXISTS admin_ops_scope ON publish_logs;
CREATE POLICY admin_ops_scope ON publish_logs
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 4. channel_posts Table (§19.9D)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS channel_posts (
  channel_post_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id           UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  publish_item_id        UUID REFERENCES publish_items(publish_item_id),
  connected_account_id   UUID REFERENCES connected_accounts(connected_account_id),
  external_post_id       VARCHAR(255),
  external_permalink     TEXT,
  title                  TEXT,
  thumbnail_url          TEXT,
  metrics                JSONB DEFAULT '{}'::jsonb,
  synced_at              TIMESTAMPTZ,
  metadata               JSONB DEFAULT '{}'::jsonb,
  created_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT fk_channel_posts_publish_item_id_tenant
    FOREIGN KEY (workspace_id, publish_item_id)
    REFERENCES publish_items(workspace_id, publish_item_id),
  CONSTRAINT fk_channel_posts_connected_account_id_tenant
    FOREIGN KEY (workspace_id, connected_account_id)
    REFERENCES connected_accounts(workspace_id, connected_account_id)
);

CREATE INDEX IF NOT EXISTS idx_channel_posts_workspace ON channel_posts(workspace_id);
CREATE INDEX IF NOT EXISTS idx_cp_publish ON channel_posts(publish_item_id);
CREATE UNIQUE INDEX IF NOT EXISTS idx_cp_external ON channel_posts(connected_account_id, external_post_id);

ALTER TABLE channel_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE channel_posts FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON channel_posts;
CREATE POLICY tenant_isolation ON channel_posts
  FOR ALL
  TO app_user
  USING (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  )
  WITH CHECK (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  );

DROP POLICY IF EXISTS admin_ops_scope ON channel_posts;
CREATE POLICY admin_ops_scope ON channel_posts
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 5. Role Grants
-- ----------------------------------------------------------------------------
GRANT SELECT, INSERT, UPDATE, DELETE ON publish_items TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON publish_items TO admin_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON publish_jobs TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON publish_jobs TO admin_user;

-- Immutable execution records: app_user has SELECT, INSERT only (RULE-M11-002, DB schema §8.3)
GRANT SELECT, INSERT ON publish_logs TO app_user;
GRANT SELECT ON publish_logs TO admin_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON channel_posts TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON channel_posts TO admin_user;

-- +goose Down
REVOKE SELECT, INSERT, UPDATE, DELETE ON channel_posts FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON channel_posts FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON channel_posts;
DROP POLICY IF EXISTS tenant_isolation ON channel_posts;
DROP TABLE IF EXISTS channel_posts CASCADE;

REVOKE SELECT ON publish_logs FROM admin_user;
REVOKE SELECT, INSERT ON publish_logs FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON publish_logs;
DROP POLICY IF EXISTS tenant_isolation ON publish_logs;
DROP TABLE IF EXISTS publish_logs CASCADE;

REVOKE SELECT, INSERT, UPDATE, DELETE ON publish_jobs FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON publish_jobs FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON publish_jobs;
DROP POLICY IF EXISTS tenant_isolation ON publish_jobs;
DROP TABLE IF EXISTS publish_jobs CASCADE;

REVOKE SELECT, INSERT, UPDATE, DELETE ON publish_items FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON publish_items FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON publish_items;
DROP POLICY IF EXISTS tenant_isolation ON publish_items;
DROP TABLE IF EXISTS publish_items CASCADE;
