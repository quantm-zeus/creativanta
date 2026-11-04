-- ============================================================================
-- Creativanta P7-03 Migration: Recipe Marketplace Templates & Governance
-- Canonical Sources: docs/04_contracts/database_schema.md (§12.3B, §25.7, §27.4, §21, §25.4)
--                    docs/02_features/automation/recipe_agent_center.md (RULE-M21-001, RULE-M21-002, RULE-M21-005, RULE-M21-006)
--                    docs/05_system/runtime_workflow.md
--                    docs/04_contracts/domain_event_catalog.md (§11)
--                    docs/04_contracts/rbac_permission_matrix.md (§2.9)
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. recipe_templates Table (§12.3B)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS recipe_templates (
  recipe_id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title                    VARCHAR(500) NOT NULL,
  description              TEXT,
  category                 VARCHAR(50),
  workspace_id             UUID REFERENCES workspaces(workspace_id) ON DELETE CASCADE, -- nullable for system recipes
  author_workspace_id      UUID REFERENCES workspaces(workspace_id) ON DELETE SET NULL, -- original author; workspace_id used for RLS
  activepieces_template_id VARCHAR(255),
  template_kind            VARCHAR(20) NOT NULL DEFAULT 'workflow' CHECK (template_kind IN ('workflow','style_workflow')),
  template_version         INTEGER NOT NULL DEFAULT 1 CHECK (template_version > 0),
  template_payload         JSONB NOT NULL DEFAULT '{}', -- portable snapshot, §27.4
  parameters               JSONB DEFAULT '[]', -- [{name, type, default, required}]
  required_capabilities    JSONB DEFAULT '[]',
  install_count            INTEGER DEFAULT 0,
  rating_avg               REAL DEFAULT 0, -- 0-5 non-financial rating
  review_count             INTEGER DEFAULT 0,
  price                    NUMERIC(18,6) DEFAULT 0, -- 0 = free (DB-H-001)
  status                   VARCHAR(20) NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'review_required', 'published', 'deprecated', 'retired', 'taken_down')),
  created_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at               TIMESTAMPTZ,
  CONSTRAINT uq_recipe_templates_tenant_pk
    UNIQUE (workspace_id, recipe_id)
);

CREATE INDEX IF NOT EXISTS idx_recipe_templates_workspace ON recipe_templates(workspace_id);
CREATE INDEX IF NOT EXISTS idx_recipe_templates_category ON recipe_templates(category);
CREATE INDEX IF NOT EXISTS idx_recipe_templates_status ON recipe_templates(status);
CREATE INDEX IF NOT EXISTS idx_recipe_templates_created_at ON recipe_templates(created_at DESC);

ALTER TABLE recipe_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE recipe_templates FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON recipe_templates;
CREATE POLICY tenant_isolation ON recipe_templates
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS system_recipe_read ON recipe_templates;
CREATE POLICY system_recipe_read ON recipe_templates
  FOR SELECT
  TO app_user
  USING (workspace_id IS NULL AND status = 'published');

GRANT SELECT, INSERT, UPDATE, DELETE ON recipe_templates TO app_user;

-- ----------------------------------------------------------------------------
-- 2. recipe_installations Table (RULE-M21-001)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS recipe_installations (
  installation_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id             UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  recipe_id                UUID NOT NULL REFERENCES recipe_templates(recipe_id) ON DELETE CASCADE,
  workflow_id              UUID NOT NULL REFERENCES workflows(workflow_id) ON DELETE CASCADE,
  installed_version        INTEGER NOT NULL DEFAULT 1,
  status                   VARCHAR(30) NOT NULL DEFAULT 'installed' CHECK (status IN ('installed', 'customized', 'update_available', 'pinned', 'deprecated', 'workflow_deleted')),
  parameter_values         JSONB DEFAULT '{}',
  installed_by             UUID REFERENCES users(user_id) ON DELETE SET NULL,
  created_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at               TIMESTAMPTZ,
  CONSTRAINT uq_recipe_installations_tenant_pk
    UNIQUE (workspace_id, installation_id)
);

CREATE INDEX IF NOT EXISTS idx_ri_workspace ON recipe_installations(workspace_id);
CREATE INDEX IF NOT EXISTS idx_ri_recipe ON recipe_installations(recipe_id);
CREATE INDEX IF NOT EXISTS idx_ri_workflow ON recipe_installations(workflow_id);

ALTER TABLE recipe_installations ENABLE ROW LEVEL SECURITY;
ALTER TABLE recipe_installations FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON recipe_installations;
CREATE POLICY tenant_isolation ON recipe_installations
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

GRANT SELECT, INSERT, UPDATE, DELETE ON recipe_installations TO app_user;

-- ----------------------------------------------------------------------------
-- 3. recipe_reviews Table (Marketplace Reviews & Ratings)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS recipe_reviews (
  review_id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  recipe_id                UUID NOT NULL REFERENCES recipe_templates(recipe_id) ON DELETE CASCADE,
  workspace_id             UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  user_id                  UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  rating                   INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  review_text              TEXT,
  author_name              VARCHAR(255),
  created_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_recipe_reviews_user
    UNIQUE (recipe_id, workspace_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_rr_recipe ON recipe_reviews(recipe_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_rr_workspace ON recipe_reviews(workspace_id);

ALTER TABLE recipe_reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE recipe_reviews FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON recipe_reviews;
CREATE POLICY tenant_isolation ON recipe_reviews
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS public_recipe_reviews_read ON recipe_reviews;
CREATE POLICY public_recipe_reviews_read ON recipe_reviews
  FOR SELECT
  TO app_user
  USING (EXISTS (SELECT 1 FROM recipe_templates rt WHERE rt.recipe_id = recipe_reviews.recipe_id AND rt.status = 'published'));

GRANT SELECT, INSERT, UPDATE, DELETE ON recipe_reviews TO app_user;

-- ----------------------------------------------------------------------------
-- 4. recipe_submissions Table (RULE-M21-006, S22 Governance & Takedowns)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS recipe_submissions (
  submission_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  recipe_id                UUID NOT NULL REFERENCES recipe_templates(recipe_id) ON DELETE CASCADE,
  author_workspace_id      UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  submitted_version        INTEGER NOT NULL DEFAULT 1,
  status                   VARCHAR(30) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected', 'changes_requested', 'taken_down')),
  review_notes             TEXT,
  reviewed_by              UUID REFERENCES users(user_id) ON DELETE SET NULL,
  reviewed_at              TIMESTAMPTZ,
  takedown_reason          TEXT,
  takedown_ticket_ref      VARCHAR(100),
  created_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_recipe_submissions_tenant_pk
    UNIQUE (author_workspace_id, submission_id)
);

CREATE INDEX IF NOT EXISTS idx_rsub_recipe ON recipe_submissions(recipe_id);
CREATE INDEX IF NOT EXISTS idx_rsub_status ON recipe_submissions(status);
CREATE INDEX IF NOT EXISTS idx_rsub_author ON recipe_submissions(author_workspace_id);

ALTER TABLE recipe_submissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE recipe_submissions FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON recipe_submissions;
CREATE POLICY tenant_isolation ON recipe_submissions
  FOR ALL
  TO app_user
  USING (author_workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

GRANT SELECT, INSERT, UPDATE, DELETE ON recipe_submissions TO app_user;

-- ----------------------------------------------------------------------------
-- 5. recipe_revenue_shares Table (RULE-M21-006 70/30 Split & 7-Day Refund Window)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS recipe_revenue_shares (
  revenue_share_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  recipe_id                UUID NOT NULL REFERENCES recipe_templates(recipe_id) ON DELETE CASCADE,
  author_workspace_id      UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  purchaser_workspace_id  UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  gross_amount             NUMERIC(18,6) NOT NULL CHECK (gross_amount >= 0),
  creator_amount           NUMERIC(18,6) NOT NULL CHECK (creator_amount >= 0), -- 70%
  platform_amount          NUMERIC(18,6) NOT NULL CHECK (platform_amount >= 0), -- 30%
  currency                 VARCHAR(10) NOT NULL DEFAULT 'USD',
  status                   VARCHAR(20) NOT NULL DEFAULT 'settled' CHECK (status IN ('settled', 'refunded', 'disputed')),
  refund_eligible_until    TIMESTAMPTZ NOT NULL, -- 7-day refund window (Pack 06 §S22, RULE-M21-006)
  created_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at               TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_rrev_recipe ON recipe_revenue_shares(recipe_id);
CREATE INDEX IF NOT EXISTS idx_rrev_author ON recipe_revenue_shares(author_workspace_id);
CREATE INDEX IF NOT EXISTS idx_rrev_purchaser ON recipe_revenue_shares(purchaser_workspace_id);

ALTER TABLE recipe_revenue_shares ENABLE ROW LEVEL SECURITY;
ALTER TABLE recipe_revenue_shares FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON recipe_revenue_shares;
CREATE POLICY tenant_isolation ON recipe_revenue_shares
  FOR ALL
  TO app_user
  USING (
    author_workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid OR
    purchaser_workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  );

GRANT SELECT, INSERT, UPDATE, DELETE ON recipe_revenue_shares TO app_user;

-- +goose Down
DROP POLICY IF EXISTS tenant_isolation ON recipe_revenue_shares;
DROP TABLE IF EXISTS recipe_revenue_shares;
DROP POLICY IF EXISTS tenant_isolation ON recipe_submissions;
DROP TABLE IF EXISTS recipe_submissions;
DROP POLICY IF EXISTS public_recipe_reviews_read ON recipe_reviews;
DROP POLICY IF EXISTS tenant_isolation ON recipe_reviews;
DROP TABLE IF EXISTS recipe_reviews;
DROP POLICY IF EXISTS tenant_isolation ON recipe_installations;
DROP TABLE IF EXISTS recipe_installations;
DROP POLICY IF EXISTS system_recipe_read ON recipe_templates;
DROP POLICY IF EXISTS tenant_isolation ON recipe_templates;
DROP TABLE IF EXISTS recipe_templates;
