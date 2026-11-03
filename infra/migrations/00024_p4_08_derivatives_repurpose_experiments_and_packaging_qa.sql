-- ============================================================================
-- Creativanta P4-08 Migration: Derivatives, Repurpose, A/B Experiments & Packaging QA
-- Canonical Sources: docs/04_contracts/database_schema.md (§22.9, §22.13)
--                    docs/02_features/production/asset_derivatives.md (RULE-M09-001, RULE-M09-002)
--                    docs/02_features/production/packaging_qa.md (RULE-M10-001..005)
--                    docs/04_contracts/domain_event_catalog.md (§5, §6)
--                    docs/04_contracts/rbac_permission_matrix.md (§2.4, §2.5)
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. repurpose_jobs Table (§22.13)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS repurpose_jobs (
  repurpose_job_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id            UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  source_asset_id         UUID NOT NULL,
  pipeline_config         JSONB NOT NULL DEFAULT '{}',
  output_asset_ids        UUID[] DEFAULT '{}',
  status                  VARCHAR(20) NOT NULL DEFAULT 'queued',
  credits_used            NUMERIC(18,6) DEFAULT 0,
  created_by              UUID REFERENCES users(user_id),
  started_at              TIMESTAMPTZ,
  completed_at            TIMESTAMPTZ,
  created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at              TIMESTAMPTZ,
  CONSTRAINT uq_repurpose_jobs_tenant_pk UNIQUE (workspace_id, repurpose_job_id),
  CONSTRAINT fk_repurpose_jobs_source_asset_id_tenant
    FOREIGN KEY (workspace_id, source_asset_id) REFERENCES assets(workspace_id, asset_id) ON DELETE CASCADE,
  CONSTRAINT chk_repurpose_jobs_status
    CHECK (status IN ('queued', 'processing', 'completed', 'partially_completed', 'failed'))
);

CREATE INDEX IF NOT EXISTS idx_rj_workspace ON repurpose_jobs(workspace_id);
CREATE INDEX IF NOT EXISTS idx_rj_source ON repurpose_jobs(source_asset_id);
CREATE INDEX IF NOT EXISTS idx_rj_status ON repurpose_jobs(status);

ALTER TABLE repurpose_jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE repurpose_jobs FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON repurpose_jobs;
CREATE POLICY tenant_isolation ON repurpose_jobs
  FOR ALL
  TO app_user
  USING (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  )
  WITH CHECK (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  );

DROP POLICY IF EXISTS admin_ops_scope ON repurpose_jobs;
CREATE POLICY admin_ops_scope ON repurpose_jobs
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON repurpose_jobs TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON repurpose_jobs TO admin_user;

-- ----------------------------------------------------------------------------
-- 2. ab_test_experiments Table (§22.9)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS ab_test_experiments (
  experiment_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id            UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  source_asset_id         UUID NOT NULL,
  variants                JSONB NOT NULL DEFAULT '[]',
  metrics_snapshot        JSONB DEFAULT '{}',
  winner_asset_id         UUID,
  status                  VARCHAR(20) NOT NULL DEFAULT 'pending',
  result_status           VARCHAR(20) NOT NULL DEFAULT 'pending',
  started_at              TIMESTAMPTZ,
  completed_at            TIMESTAMPTZ,
  auto_winner_criteria    JSONB DEFAULT '{}',
  created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at              TIMESTAMPTZ,
  CONSTRAINT uq_ab_test_experiments_tenant_pk UNIQUE (workspace_id, experiment_id),
  CONSTRAINT fk_ab_test_experiments_source_asset_id_tenant
    FOREIGN KEY (workspace_id, source_asset_id) REFERENCES assets(workspace_id, asset_id) ON DELETE CASCADE,
  CONSTRAINT fk_ab_test_experiments_winner_asset_id_tenant
    FOREIGN KEY (workspace_id, winner_asset_id) REFERENCES assets(workspace_id, asset_id) ON DELETE SET NULL,
  CONSTRAINT chk_ab_test_experiments_status
    CHECK (status IN ('pending', 'running', 'completed', 'cancelled')),
  CONSTRAINT chk_ab_test_experiments_result_status
    CHECK (result_status IN ('pending', 'conclusive', 'inconclusive', 'scaled'))
);

CREATE INDEX IF NOT EXISTS idx_abt_workspace ON ab_test_experiments(workspace_id);
CREATE INDEX IF NOT EXISTS idx_abt_status ON ab_test_experiments(status);
CREATE INDEX IF NOT EXISTS idx_abt_source ON ab_test_experiments(source_asset_id);

ALTER TABLE ab_test_experiments ENABLE ROW LEVEL SECURITY;
ALTER TABLE ab_test_experiments FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON ab_test_experiments;
CREATE POLICY tenant_isolation ON ab_test_experiments
  FOR ALL
  TO app_user
  USING (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  )
  WITH CHECK (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  );

DROP POLICY IF EXISTS admin_ops_scope ON ab_test_experiments;
CREATE POLICY admin_ops_scope ON ab_test_experiments
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON ab_test_experiments TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ab_test_experiments TO admin_user;

-- ----------------------------------------------------------------------------
-- 3. packaging_qa_results Table (M10 QA Audit Trail)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS packaging_qa_results (
  qa_result_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id            UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  asset_id                UUID NOT NULL,
  publish_item_id         UUID,
  target_platform         VARCHAR(50) NOT NULL,
  overall_score           REAL NOT NULL,
  score_status            VARCHAR(30) NOT NULL,
  component_scores        JSONB NOT NULL DEFAULT '[]',
  readiness_checks        JSONB NOT NULL DEFAULT '[]',
  compliance_scan         JSONB NOT NULL DEFAULT '[]',
  compliance_result       VARCHAR(30) NOT NULL,
  has_hard_blocks         BOOLEAN NOT NULL DEFAULT false,
  hard_block_reasons      JSONB NOT NULL DEFAULT '[]',
  overrides               JSONB NOT NULL DEFAULT '[]',
  evaluated_by            UUID REFERENCES users(user_id),
  created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at              TIMESTAMPTZ,
  CONSTRAINT uq_packaging_qa_results_tenant_pk UNIQUE (workspace_id, qa_result_id),
  CONSTRAINT fk_packaging_qa_results_asset_id_tenant
    FOREIGN KEY (workspace_id, asset_id) REFERENCES assets(workspace_id, asset_id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_pqa_workspace ON packaging_qa_results(workspace_id);
CREATE INDEX IF NOT EXISTS idx_pqa_asset ON packaging_qa_results(asset_id);
CREATE INDEX IF NOT EXISTS idx_pqa_platform ON packaging_qa_results(target_platform);

ALTER TABLE packaging_qa_results ENABLE ROW LEVEL SECURITY;
ALTER TABLE packaging_qa_results FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON packaging_qa_results;
CREATE POLICY tenant_isolation ON packaging_qa_results
  FOR ALL
  TO app_user
  USING (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  )
  WITH CHECK (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  );

DROP POLICY IF EXISTS admin_ops_scope ON packaging_qa_results;
CREATE POLICY admin_ops_scope ON packaging_qa_results
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON packaging_qa_results TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON packaging_qa_results TO admin_user;

-- ----------------------------------------------------------------------------
-- 4. upload_presets Table (M10 Recurring Publish Presets)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS upload_presets (
  preset_id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id            UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  name                    VARCHAR(255) NOT NULL,
  target_platform         VARCHAR(50) NOT NULL,
  target_format           VARCHAR(30),
  hashtag_template        TEXT,
  disclosure_template     TEXT,
  cta_template            TEXT,
  default_aspect_ratio    VARCHAR(20),
  created_by              UUID REFERENCES users(user_id),
  created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at              TIMESTAMPTZ,
  CONSTRAINT uq_upload_presets_tenant_pk UNIQUE (workspace_id, preset_id)
);

CREATE INDEX IF NOT EXISTS idx_up_workspace ON upload_presets(workspace_id);
CREATE INDEX IF NOT EXISTS idx_up_platform ON upload_presets(target_platform);

ALTER TABLE upload_presets ENABLE ROW LEVEL SECURITY;
ALTER TABLE upload_presets FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON upload_presets;
CREATE POLICY tenant_isolation ON upload_presets
  FOR ALL
  TO app_user
  USING (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  )
  WITH CHECK (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  );

DROP POLICY IF EXISTS admin_ops_scope ON upload_presets;
CREATE POLICY admin_ops_scope ON upload_presets
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON upload_presets TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON upload_presets TO admin_user;

-- +goose Down
REVOKE SELECT, INSERT, UPDATE, DELETE ON upload_presets FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON upload_presets FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON upload_presets;
DROP POLICY IF EXISTS tenant_isolation ON upload_presets;
DROP TABLE IF EXISTS upload_presets CASCADE;

REVOKE SELECT, INSERT, UPDATE, DELETE ON packaging_qa_results FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON packaging_qa_results FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON packaging_qa_results;
DROP POLICY IF EXISTS tenant_isolation ON packaging_qa_results;
DROP TABLE IF EXISTS packaging_qa_results CASCADE;

REVOKE SELECT, INSERT, UPDATE, DELETE ON ab_test_experiments FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON ab_test_experiments FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON ab_test_experiments;
DROP POLICY IF EXISTS tenant_isolation ON ab_test_experiments;
DROP TABLE IF EXISTS ab_test_experiments CASCADE;

REVOKE SELECT, INSERT, UPDATE, DELETE ON repurpose_jobs FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON repurpose_jobs FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON repurpose_jobs;
DROP POLICY IF EXISTS tenant_isolation ON repurpose_jobs;
DROP TABLE IF EXISTS repurpose_jobs CASCADE;
