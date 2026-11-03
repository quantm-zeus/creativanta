-- ============================================================================
-- Creativanta P4-05 Migration: Showcase, Link-to-Video & Thumbnail Jobs
-- Canonical Sources: docs/04_contracts/database_schema.md (§22.4, §22.5, §32, §34)
--                    docs/02_features/production/ai_video_studio.md (EF-01, EF-02, EF-03, EF-04)
--                    docs/04_contracts/domain_event_catalog.md (§5, §15B)
--                    docs/04_contracts/rbac_permission_matrix.md (§2.4)
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. product_showcase_jobs Table (§22.4)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS product_showcase_jobs (
  showcase_job_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id            UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  video_edit_job_id       UUID,
  product_id              UUID,
  style                   VARCHAR(30) NOT NULL,
  customization           JSONB NOT NULL DEFAULT '{}',
  batch_id                UUID,
  output_asset_id         UUID,
  character_id            UUID,
  status                  VARCHAR(20) NOT NULL DEFAULT 'queued',
  credits_used            NUMERIC(18,6),
  created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at              TIMESTAMPTZ,
  CONSTRAINT uq_product_showcase_jobs_tenant_pk UNIQUE (workspace_id, showcase_job_id),
  CONSTRAINT fk_product_showcase_jobs_video_edit_job_id_tenant
    FOREIGN KEY (workspace_id, video_edit_job_id) REFERENCES video_edit_jobs(workspace_id, job_id) ON DELETE SET NULL,
  CONSTRAINT fk_product_showcase_jobs_product_id_tenant
    FOREIGN KEY (workspace_id, product_id) REFERENCES products(workspace_id, product_id) ON DELETE SET NULL,
  CONSTRAINT fk_product_showcase_jobs_output_asset_id_tenant
    FOREIGN KEY (workspace_id, output_asset_id) REFERENCES assets(workspace_id, asset_id) ON DELETE SET NULL,
  CONSTRAINT fk_product_showcase_jobs_character_id_tenant
    FOREIGN KEY (workspace_id, character_id) REFERENCES characters(workspace_id, character_id) ON DELETE SET NULL,
  CONSTRAINT chk_product_showcase_jobs_status
    CHECK (status IN ('queued', 'processing', 'completed', 'failed')),
  CONSTRAINT chk_product_showcase_jobs_style
    CHECK (style IN ('spin_360', '360_spin', 'tabletop', 'tabletop_demo', 'flip_reveal', 'virtual_tryon', 'virtual_try_on', 'lifestyle', 'lifestyle_context', 'unboxing', 'unboxing_simulation', 'before_after', 'review_style'))
);

CREATE INDEX IF NOT EXISTS idx_psj_workspace ON product_showcase_jobs(workspace_id);
CREATE INDEX IF NOT EXISTS idx_psj_product ON product_showcase_jobs(product_id);
CREATE INDEX IF NOT EXISTS idx_psj_batch ON product_showcase_jobs(batch_id);
CREATE INDEX IF NOT EXISTS idx_psj_status ON product_showcase_jobs(status);

ALTER TABLE product_showcase_jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_showcase_jobs FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON product_showcase_jobs;
CREATE POLICY tenant_isolation ON product_showcase_jobs
  FOR ALL
  TO app_user
  USING (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  )
  WITH CHECK (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  );

DROP POLICY IF EXISTS admin_ops_scope ON product_showcase_jobs;
CREATE POLICY admin_ops_scope ON product_showcase_jobs
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON product_showcase_jobs TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON product_showcase_jobs TO admin_user;

-- ----------------------------------------------------------------------------
-- 2. link_to_video_jobs Table (§22.5)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS link_to_video_jobs (
  ltv_job_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id            UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  video_edit_job_id       UUID,
  source_url              TEXT NOT NULL,
  platform_detected       VARCHAR(30) NOT NULL DEFAULT 'generic',
  scraped_data            JSONB NOT NULL DEFAULT '{}',
  script_template         VARCHAR(30) NOT NULL DEFAULT 'problem_solution',
  generated_script        TEXT,
  output_asset_id         UUID,
  character_id            UUID,
  status                  VARCHAR(20) NOT NULL DEFAULT 'scraping',
  credits_used            NUMERIC(18,6),
  created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at              TIMESTAMPTZ,
  CONSTRAINT uq_link_to_video_jobs_tenant_pk UNIQUE (workspace_id, ltv_job_id),
  CONSTRAINT fk_link_to_video_jobs_video_edit_job_id_tenant
    FOREIGN KEY (workspace_id, video_edit_job_id) REFERENCES video_edit_jobs(workspace_id, job_id) ON DELETE SET NULL,
  CONSTRAINT fk_link_to_video_jobs_output_asset_id_tenant
    FOREIGN KEY (workspace_id, output_asset_id) REFERENCES assets(workspace_id, asset_id) ON DELETE SET NULL,
  CONSTRAINT fk_link_to_video_jobs_character_id_tenant
    FOREIGN KEY (workspace_id, character_id) REFERENCES characters(workspace_id, character_id) ON DELETE SET NULL,
  CONSTRAINT chk_link_to_video_jobs_status
    CHECK (status IN ('scraping', 'scripting', 'generating', 'completed', 'failed')),
  CONSTRAINT chk_link_to_video_jobs_script_template
    CHECK (script_template IN ('problem_solution', 'listicle', 'listicle_review', 'testimonial', 'flash_sale', 'comparison')),
  CONSTRAINT chk_link_to_video_jobs_platform
    CHECK (platform_detected IN ('shopee', 'lazada', 'tiktok_shop', 'amazon', 'shopify', 'generic'))
);

CREATE INDEX IF NOT EXISTS idx_ltv_workspace ON link_to_video_jobs(workspace_id);
CREATE INDEX IF NOT EXISTS idx_ltv_status ON link_to_video_jobs(status);

ALTER TABLE link_to_video_jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE link_to_video_jobs FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON link_to_video_jobs;
CREATE POLICY tenant_isolation ON link_to_video_jobs
  FOR ALL
  TO app_user
  USING (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  )
  WITH CHECK (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  );

DROP POLICY IF EXISTS admin_ops_scope ON link_to_video_jobs;
CREATE POLICY admin_ops_scope ON link_to_video_jobs
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON link_to_video_jobs TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON link_to_video_jobs TO admin_user;

-- +goose Down
REVOKE SELECT, INSERT, UPDATE, DELETE ON link_to_video_jobs FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON link_to_video_jobs FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON link_to_video_jobs;
DROP POLICY IF EXISTS tenant_isolation ON link_to_video_jobs;
DROP TABLE IF EXISTS link_to_video_jobs CASCADE;

REVOKE SELECT, INSERT, UPDATE, DELETE ON product_showcase_jobs FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON product_showcase_jobs FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON product_showcase_jobs;
DROP POLICY IF EXISTS tenant_isolation ON product_showcase_jobs;
DROP TABLE IF EXISTS product_showcase_jobs CASCADE;
