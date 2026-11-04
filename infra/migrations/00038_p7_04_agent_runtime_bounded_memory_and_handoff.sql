-- ============================================================================
-- Creativanta P7-04 Migration: Agent Runtime, Bounded Memory & Audited Handoff
-- Canonical Sources: docs/04_contracts/database_schema.md (§12.4, §12.4A, §12.4B, §27.2)
--                    docs/02_features/automation/recipe_agent_center.md (RULE-M21-002, RULE-M21-003, RULE-M21-004, EC-M21-001, EC-M21-003)
--                    docs/02_features/production/ai_video_studio.md (EF-08)
--                    docs/02_features/platform/copilot.md (§5.2, §5.3, §8, EC-COP-002)
--                    docs/04_contracts/domain_event_catalog.md (§11)
--                    docs/04_contracts/rbac_permission_matrix.md (§2.9, §2.15)
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. agent_runs Table (§12.4)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS agent_runs (
  agent_run_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id            UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  recipe_id               UUID REFERENCES recipe_templates(recipe_id) ON DELETE SET NULL,
  workflow_id             UUID REFERENCES workflows(workflow_id) ON DELETE SET NULL,
  agent_type              VARCHAR(50) NOT NULL DEFAULT 'generic',
  plan_summary            TEXT NOT NULL,
  execution_scope         JSONB DEFAULT '{}', -- {scope_type, scope_refs[]}
  approval_state          VARCHAR(20) DEFAULT 'not_required', -- not_required, awaiting_approval, approved, rejected
  current_state           VARCHAR(30) NOT NULL DEFAULT 'planning', -- planning, awaiting_approval, executing, waiting_context, completed, partially_completed, failed, handed_off, cancelled
  side_effects_summary    JSONB DEFAULT '[]',
  handoff_target_user_id  UUID REFERENCES users(user_id) ON DELETE SET NULL,
  handoff_context         TEXT,
  diagnostics_ref         UUID,
  audit_ref               UUID,
  context_refs            JSONB DEFAULT '[]', -- [{type, id}]
  credits_used            NUMERIC(18,6) NOT NULL DEFAULT 0, -- DB-H-001: credit amount (not counter)
  budget_ceiling          NUMERIC(18,6) NOT NULL DEFAULT 0, -- DB-H-001: credit budget ceiling
  memory_snapshot         JSONB DEFAULT '{}', -- bounded session-scoped working memory
  started_at              TIMESTAMPTZ,
  completed_at            TIMESTAMPTZ,
  created_by              UUID REFERENCES users(user_id) ON DELETE SET NULL,
  created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at              TIMESTAMPTZ,
  CONSTRAINT uq_agent_runs_tenant_pk
    UNIQUE (workspace_id, agent_run_id),
  CONSTRAINT chk_agent_runs_current_state
    CHECK (current_state IN ('planning', 'awaiting_approval', 'executing', 'waiting_context', 'completed', 'partially_completed', 'failed', 'handed_off', 'cancelled')),
  CONSTRAINT chk_agent_runs_approval_state
    CHECK (approval_state IN ('not_required', 'awaiting_approval', 'approved', 'rejected')),
  CONSTRAINT chk_agent_runs_credits_used
    CHECK (credits_used >= 0),
  CONSTRAINT chk_agent_runs_budget_ceiling
    CHECK (budget_ceiling >= 0)
);

CREATE INDEX IF NOT EXISTS idx_ar_workspace ON agent_runs(workspace_id);
CREATE INDEX IF NOT EXISTS idx_ar_state ON agent_runs(current_state);
CREATE INDEX IF NOT EXISTS idx_ar_recipe ON agent_runs(recipe_id);
CREATE INDEX IF NOT EXISTS idx_ar_workflow ON agent_runs(workflow_id);
CREATE INDEX IF NOT EXISTS idx_ar_created_at ON agent_runs(workspace_id, created_at DESC);

ALTER TABLE agent_runs ENABLE ROW LEVEL SECURITY;
ALTER TABLE agent_runs FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON agent_runs;
CREATE POLICY tenant_isolation ON agent_runs
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON agent_runs;
CREATE POLICY admin_ops_scope ON agent_runs
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON agent_runs TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON agent_runs TO admin_user;

-- ----------------------------------------------------------------------------
-- 2. agent_run_steps Table (§12.4A)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS agent_run_steps (
  agent_step_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id            UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  agent_run_id            UUID NOT NULL REFERENCES agent_runs(agent_run_id) ON DELETE CASCADE,
  step_order              SMALLINT NOT NULL,
  phase                   VARCHAR(30) NOT NULL, -- planning, awaiting_approval, executing, waiting_context, completed
  title                   VARCHAR(255) NOT NULL,
  status                  VARCHAR(30) NOT NULL DEFAULT 'planning', -- planning, awaiting_approval, executing, waiting_context, completed, failed, skipped, cancelled
  expected_outcome        TEXT,
  observed_outcome        TEXT,
  required_permission     VARCHAR(100),
  required_capability     VARCHAR(100),
  is_high_risk            BOOLEAN NOT NULL DEFAULT false,
  estimated_credits       NUMERIC(18,6) NOT NULL DEFAULT 0, -- DB-H-001
  actual_credits          NUMERIC(18,6) NOT NULL DEFAULT 0, -- DB-H-001
  input_context           JSONB DEFAULT '{}',
  output_context          JSONB DEFAULT '{}',
  diagnostics_ref         UUID,
  started_at              TIMESTAMPTZ,
  completed_at            TIMESTAMPTZ,
  created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at              TIMESTAMPTZ,
  CONSTRAINT uq_agent_run_steps_tenant_pk
    UNIQUE (workspace_id, agent_step_id),
  CONSTRAINT fk_agent_run_steps_agent_run_id_tenant
    FOREIGN KEY (workspace_id, agent_run_id) REFERENCES agent_runs(workspace_id, agent_run_id) ON DELETE CASCADE,
  CONSTRAINT chk_agent_run_steps_status
    CHECK (status IN ('planning', 'awaiting_approval', 'executing', 'waiting_context', 'completed', 'failed', 'skipped', 'cancelled')),
  CONSTRAINT chk_agent_run_steps_estimated_credits
    CHECK (estimated_credits >= 0),
  CONSTRAINT chk_agent_run_steps_actual_credits
    CHECK (actual_credits >= 0)
);

CREATE INDEX IF NOT EXISTS idx_ars_run ON agent_run_steps(agent_run_id);
CREATE INDEX IF NOT EXISTS idx_ars_workspace ON agent_run_steps(workspace_id);
CREATE INDEX IF NOT EXISTS idx_ars_status ON agent_run_steps(status);

ALTER TABLE agent_run_steps ENABLE ROW LEVEL SECURITY;
ALTER TABLE agent_run_steps FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON agent_run_steps;
CREATE POLICY tenant_isolation ON agent_run_steps
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON agent_run_steps;
CREATE POLICY admin_ops_scope ON agent_run_steps
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON agent_run_steps TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON agent_run_steps TO admin_user;

-- ----------------------------------------------------------------------------
-- 3. agent_outputs Table (§12.4B)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS agent_outputs (
  output_id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id            UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  agent_run_id            UUID NOT NULL REFERENCES agent_runs(agent_run_id) ON DELETE CASCADE,
  output_type             VARCHAR(50) NOT NULL, -- text, asset, dataset, workflow_patch, recommendation, report, video
  title                   VARCHAR(255) NOT NULL,
  summary                 TEXT,
  object_refs             JSONB DEFAULT '[]', -- [{type, id}]
  downloadable_refs       JSONB DEFAULT '[]', -- [{label, url}]
  preview_payload         JSONB DEFAULT '{}',
  approval_state          VARCHAR(20) NOT NULL DEFAULT 'not_required', -- not_required, pending_approval, approved, rejected
  created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at              TIMESTAMPTZ,
  CONSTRAINT uq_agent_outputs_tenant_pk
    UNIQUE (workspace_id, output_id),
  CONSTRAINT fk_agent_outputs_agent_run_id_tenant
    FOREIGN KEY (workspace_id, agent_run_id) REFERENCES agent_runs(workspace_id, agent_run_id) ON DELETE CASCADE,
  CONSTRAINT chk_agent_outputs_approval_state
    CHECK (approval_state IN ('not_required', 'pending_approval', 'approved', 'rejected'))
);

CREATE INDEX IF NOT EXISTS idx_ao_run ON agent_outputs(agent_run_id);
CREATE INDEX IF NOT EXISTS idx_ao_workspace ON agent_outputs(workspace_id);
CREATE INDEX IF NOT EXISTS idx_ao_type ON agent_outputs(output_type);

ALTER TABLE agent_outputs ENABLE ROW LEVEL SECURITY;
ALTER TABLE agent_outputs FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON agent_outputs;
CREATE POLICY tenant_isolation ON agent_outputs
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON agent_outputs;
CREATE POLICY admin_ops_scope ON agent_outputs
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON agent_outputs TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON agent_outputs TO admin_user;

-- +goose Down
REVOKE SELECT, INSERT, UPDATE, DELETE ON agent_outputs FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON agent_outputs FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON agent_outputs;
DROP POLICY IF EXISTS tenant_isolation ON agent_outputs;
DROP TABLE IF EXISTS agent_outputs CASCADE;

REVOKE SELECT, INSERT, UPDATE, DELETE ON agent_run_steps FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON agent_run_steps FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON agent_run_steps;
DROP POLICY IF EXISTS tenant_isolation ON agent_run_steps;
DROP TABLE IF EXISTS agent_run_steps CASCADE;

REVOKE SELECT, INSERT, UPDATE, DELETE ON agent_runs FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON agent_runs FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON agent_runs;
DROP POLICY IF EXISTS tenant_isolation ON agent_runs;
DROP TABLE IF EXISTS agent_runs CASCADE;
