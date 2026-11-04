-- ============================================================================
-- Creativanta P7-01 Migration: Workflows, Workflow Runs & Complete Node Model
-- Canonical Sources: docs/04_contracts/database_schema.md (§12.2, §12.3, §12.3A, §25.4, §25.7, §27.4)
--                    docs/02_features/automation/workflow_studio.md (RULE-M20-001, RULE-M20-002, RULE-M20-004, RULE-M20-007)
--                    docs/05_system/runtime_workflow.md (§4)
--                    docs/04_contracts/domain_event_catalog.md (§11)
--                    docs/04_contracts/rbac_permission_matrix.md (§2.9)
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. workflows Table (§12.2)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS workflows (
  workflow_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id           UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  title                  VARCHAR(500) NOT NULL,
  workflow_type          VARCHAR(30) NOT NULL DEFAULT 'custom', -- custom, recipe_installed, agent
  trigger_config         JSONB NOT NULL, -- see §25.4 TriggerConfig
  action_chain           JSONB NOT NULL, -- canonical WorkflowGraph (§25.7), adapter-independent
  approval_requirements  JSONB DEFAULT '[]',
  status                 VARCHAR(20) NOT NULL DEFAULT 'draft', -- draft, active, paused, error, archived
  version                INTEGER NOT NULL DEFAULT 1,
  activepieces_flow_id   VARCHAR(255),
  tier_limit_check       BOOLEAN DEFAULT true,
  run_count              INTEGER DEFAULT 0,
  created_by             UUID REFERENCES users(user_id) ON DELETE SET NULL,
  created_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at             TIMESTAMPTZ, -- soft delete (DB-H-003)
  CONSTRAINT uq_workflows_tenant_pk
    UNIQUE (workspace_id, workflow_id),
  CONSTRAINT chk_workflows_status
    CHECK (status IN ('draft', 'active', 'paused', 'error', 'archived')),
  CONSTRAINT chk_workflows_type
    CHECK (workflow_type IN ('custom', 'recipe_installed', 'agent')),
  CONSTRAINT chk_workflows_version
    CHECK (version >= 1)
);

CREATE INDEX IF NOT EXISTS idx_workflows_workspace ON workflows(workspace_id);
CREATE INDEX IF NOT EXISTS idx_workflows_status ON workflows(workspace_id, status);
CREATE INDEX IF NOT EXISTS idx_workflows_created_at ON workflows(workspace_id, created_at DESC);

ALTER TABLE workflows ENABLE ROW LEVEL SECURITY;
ALTER TABLE workflows FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON workflows;
CREATE POLICY tenant_isolation ON workflows
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

GRANT SELECT, INSERT, UPDATE, DELETE ON workflows TO app_user;

-- ----------------------------------------------------------------------------
-- 2. workflow_runs Table (§12.3)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS workflow_runs (
  run_id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id           UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  workflow_id            UUID NOT NULL,
  trigger_event          JSONB NOT NULL,
  status                 VARCHAR(30) NOT NULL DEFAULT 'queued', -- queued, running, waiting_approval, waiting_external_condition, succeeded, partially_succeeded, failed, cancelled, requires_manual_intervention
  current_node           VARCHAR(100),
  result_summary         JSONB,
  execution_log          JSONB DEFAULT '[]', -- per-node execution trace — see §25.4 ExecutionLogEntry
  affected_object_refs   JSONB DEFAULT '[]',
  side_effects_summary   JSONB DEFAULT '[]',
  activepieces_run_id    VARCHAR(255),
  started_at             TIMESTAMPTZ,
  completed_at           TIMESTAMPTZ,
  created_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at             TIMESTAMPTZ, -- soft delete (DB-H-003)
  CONSTRAINT uq_workflow_runs_tenant_pk
    UNIQUE (workspace_id, run_id),
  CONSTRAINT fk_workflow_runs_workflow_id_tenant
    FOREIGN KEY (workspace_id, workflow_id) REFERENCES workflows(workspace_id, workflow_id) ON DELETE CASCADE,
  CONSTRAINT chk_workflow_runs_status
    CHECK (status IN ('queued', 'running', 'waiting_approval', 'waiting_external_condition', 'succeeded', 'partially_succeeded', 'failed', 'cancelled', 'requires_manual_intervention'))
);

CREATE INDEX IF NOT EXISTS idx_wr_workspace ON workflow_runs(workspace_id);
CREATE INDEX IF NOT EXISTS idx_wr_workflow ON workflow_runs(workspace_id, workflow_id);
CREATE INDEX IF NOT EXISTS idx_wr_status ON workflow_runs(workspace_id, status);
CREATE INDEX IF NOT EXISTS idx_wr_created_at ON workflow_runs(workspace_id, created_at DESC);

ALTER TABLE workflow_runs ENABLE ROW LEVEL SECURITY;
ALTER TABLE workflow_runs FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON workflow_runs;
CREATE POLICY tenant_isolation ON workflow_runs
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

GRANT SELECT, INSERT, UPDATE, DELETE ON workflow_runs TO app_user;

-- ----------------------------------------------------------------------------
-- 3. workflow_run_steps Table (§12.3A)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS workflow_run_steps (
  step_id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id           UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  run_id                 UUID NOT NULL,
  node_id                VARCHAR(100) NOT NULL,
  node_type              VARCHAR(30) NOT NULL, -- trigger, condition, transform, action, approval, wait, fallback, diagnostics, handoff, terminal
  step_order             SMALLINT NOT NULL,
  status                 VARCHAR(30) NOT NULL DEFAULT 'queued', -- queued, running, waiting_approval, waiting_external_condition, succeeded, skipped, failed, cancelled
  input_snapshot         JSONB DEFAULT '{}',
  output_snapshot        JSONB DEFAULT '{}',
  diagnostics_ref        UUID,
  side_effect_refs       JSONB DEFAULT '[]',
  started_at             TIMESTAMPTZ,
  completed_at           TIMESTAMPTZ,
  created_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at             TIMESTAMPTZ, -- soft delete (DB-H-003)
  CONSTRAINT uq_workflow_run_steps_tenant_pk
    UNIQUE (workspace_id, step_id),
  CONSTRAINT fk_workflow_run_steps_run_id_tenant
    FOREIGN KEY (workspace_id, run_id) REFERENCES workflow_runs(workspace_id, run_id) ON DELETE CASCADE,
  CONSTRAINT chk_workflow_run_steps_node_type
    CHECK (node_type IN ('trigger', 'condition', 'transform', 'action', 'approval', 'wait', 'fallback', 'diagnostics', 'handoff', 'terminal')),
  CONSTRAINT chk_workflow_run_steps_status
    CHECK (status IN ('queued', 'running', 'waiting_approval', 'waiting_external_condition', 'succeeded', 'skipped', 'failed', 'cancelled')),
  CONSTRAINT chk_workflow_run_steps_step_order
    CHECK (step_order >= 0)
);

CREATE INDEX IF NOT EXISTS idx_wrs_workspace ON workflow_run_steps(workspace_id);
CREATE INDEX IF NOT EXISTS idx_wrs_run ON workflow_run_steps(workspace_id, run_id);
CREATE INDEX IF NOT EXISTS idx_wrs_node ON workflow_run_steps(workspace_id, node_id);

ALTER TABLE workflow_run_steps ENABLE ROW LEVEL SECURITY;
ALTER TABLE workflow_run_steps FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON workflow_run_steps;
CREATE POLICY tenant_isolation ON workflow_run_steps
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

GRANT SELECT, INSERT, UPDATE, DELETE ON workflow_run_steps TO app_user;

-- +goose Down
DROP POLICY IF EXISTS tenant_isolation ON workflow_run_steps;
DROP TABLE IF EXISTS workflow_run_steps;
DROP POLICY IF EXISTS tenant_isolation ON workflow_runs;
DROP TABLE IF EXISTS workflow_runs;
DROP POLICY IF EXISTS tenant_isolation ON workflows;
DROP TABLE IF EXISTS workflows;
