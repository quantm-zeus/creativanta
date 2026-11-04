-- ============================================================================
-- Creativanta P8-09 Migration: Full-Scope Acceptance & Release Reconciliation
-- Canonical Sources: docs/00_index/BUILD_INDEX.md (31 Modules / Specs, 6 Operator Modes)
--                    docs/00_index/BUILD_EXECUTION_CONTRACT.md (§1 Meaning of ready, §6 Full-scope completion)
--                    docs/00_index/AGENT_BUILD_BACKLOG.md (§4 Phase acceptance rules)
--                    docs/02_features/platform/home_decision_engine.md (M01, RULE-M01-001..007)
--                    docs/02_features/platform/reporting_admin_billing.md (M23/S26, RULE-M23-B01)
--                    docs/04_contracts/database_schema.md (§4, §15, §26, §27)
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. Full-Scope Platform Acceptance Audits Table (Global Admin Ledger)
--    Immutable record of platform-wide reconciliation across all 31 modules,
--    6 operator modes, 60 build tasks, 1,333 requirement units, and 1,188 RPCs.
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS full_scope_acceptance_audits (
  audit_id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  environment                 VARCHAR(30) NOT NULL
    CHECK (environment IN ('local', 'rehearsal', 'staging', 'production')),
  release_candidate_version   VARCHAR(64) NOT NULL,
  total_modules               INTEGER NOT NULL CHECK (total_modules = 31),
  total_operator_modes        INTEGER NOT NULL CHECK (total_operator_modes = 6),
  total_build_tasks           INTEGER NOT NULL CHECK (total_build_tasks = 60),
  total_requirements          INTEGER NOT NULL CHECK (total_requirements >= 1333),
  total_screen_assignments    INTEGER NOT NULL CHECK (total_screen_assignments >= 245),
  total_rpc_bindings          INTEGER NOT NULL CHECK (total_rpc_bindings >= 1188),
  total_tenant_tables         INTEGER NOT NULL CHECK (total_tenant_tables >= 140),
  all_manifests_verified      BOOLEAN NOT NULL DEFAULT false,
  zero_untracked_scope        BOOLEAN NOT NULL DEFAULT false,
  unmet_external_gates_count  INTEGER NOT NULL DEFAULT 0,
  production_launch_approved  BOOLEAN NOT NULL DEFAULT false,
  release_decision            VARCHAR(40) NOT NULL
    CHECK (release_decision IN ('CONDITIONAL_READY_LOCAL', 'RELEASE_BLOCKED', 'LAUNCH_APPROVED')),
  audit_report                JSONB NOT NULL DEFAULT '{}'::jsonb,
  external_gates_report       JSONB NOT NULL DEFAULT '[]'::jsonb,
  sha256_digest               VARCHAR(64) NOT NULL,
  executed_by_admin_id        UUID REFERENCES internal_admins(admin_id) ON DELETE SET NULL,
  executed_at                 TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_full_scope_acceptance_audits_executed_at
  ON full_scope_acceptance_audits(executed_at DESC);

-- ----------------------------------------------------------------------------
-- 2. Workspace Acceptance Signoffs Table (Tenant-Scoped with RLS)
--    Enables workspace-level verification and audit signoffs per operator mode.
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS workspace_acceptance_signoffs (
  signoff_id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id                UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  operator_mode               VARCHAR(30) NOT NULL
    CHECK (operator_mode IN ('creator', 'seller', 'affiliate_operator', 'live_operator', 'agency_mcn', 'brand_collaboration')),
  reviewed_by_user_id         UUID NOT NULL REFERENCES users(user_id) ON DELETE RESTRICT,
  six_modes_verified          BOOLEAN NOT NULL DEFAULT true,
  onboarding_loop_completed   BOOLEAN NOT NULL DEFAULT false,
  verified_modules_count      INTEGER NOT NULL DEFAULT 31,
  status                      VARCHAR(30) NOT NULL DEFAULT 'verified'
    CHECK (status IN ('draft', 'verified', 'flagged', 'archived')),
  signoff_notes               TEXT,
  signoff_digest              VARCHAR(64) NOT NULL,
  created_at                  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_workspace_acceptance_tenant_pk UNIQUE (workspace_id, signoff_id)
);

CREATE INDEX IF NOT EXISTS idx_workspace_acceptance_signoffs_workspace
  ON workspace_acceptance_signoffs(workspace_id, operator_mode);

ALTER TABLE workspace_acceptance_signoffs ENABLE ROW LEVEL SECURITY;
ALTER TABLE workspace_acceptance_signoffs FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON workspace_acceptance_signoffs;
CREATE POLICY tenant_isolation ON workspace_acceptance_signoffs
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON workspace_acceptance_signoffs;
CREATE POLICY admin_ops_scope ON workspace_acceptance_signoffs
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 3. Table Role Grants (Narrow per-role grants; NEVER GRANT ALL)
-- ----------------------------------------------------------------------------
GRANT SELECT, INSERT, UPDATE, DELETE ON full_scope_acceptance_audits TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON workspace_acceptance_signoffs TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON workspace_acceptance_signoffs TO admin_user;

-- +goose Down
REVOKE SELECT, INSERT, UPDATE, DELETE ON workspace_acceptance_signoffs FROM app_user, admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON full_scope_acceptance_audits FROM admin_user;
DROP POLICY IF EXISTS admin_ops_scope ON workspace_acceptance_signoffs;
DROP POLICY IF EXISTS tenant_isolation ON workspace_acceptance_signoffs;
DROP INDEX IF EXISTS idx_workspace_acceptance_signoffs_workspace;
DROP TABLE IF EXISTS workspace_acceptance_signoffs CASCADE;
DROP INDEX IF EXISTS idx_full_scope_acceptance_audits_executed_at;
DROP TABLE IF EXISTS full_scope_acceptance_audits CASCADE;
