-- ============================================================================
-- Creativanta P8-03 Migration: Admin Ops, Hard-Block Appeal Audit & Proactive Coaching
-- Canonical Sources:
--   - docs/04_contracts/database_schema.md (§17.4 moderation_cases, §17.5 fraud_cases, §17.8 support_tickets, §18.2, §22.15)
--   - docs/02_features/platform/internal_admin.md (S26)
--   - docs/02_features/platform/capability_matrix.md (M22)
--   - docs/06_quality_ops/moderation_rules_engine.md (SAFE-2026-02, EC-S26-002)
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. Enhance moderation_cases with Appeal Audit lifecycle (§17.4, SAFE-2026-02)
-- ----------------------------------------------------------------------------
ALTER TABLE moderation_cases
  ADD COLUMN IF NOT EXISTS appeal_status VARCHAR(20) NOT NULL DEFAULT 'none'
    CHECK (appeal_status IN ('none', 'pending', 'reviewing', 'upheld', 'overturned')),
  ADD COLUMN IF NOT EXISTS appeal_reason TEXT,
  ADD COLUMN IF NOT EXISTS appeal_evidence JSONB NOT NULL DEFAULT '{}'::jsonb,
  ADD COLUMN IF NOT EXISTS appealed_by UUID REFERENCES users(user_id),
  ADD COLUMN IF NOT EXISTS appealed_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS appeal_reviewed_by UUID REFERENCES internal_admins(admin_id),
  ADD COLUMN IF NOT EXISTS appeal_resolution_notes TEXT,
  ADD COLUMN IF NOT EXISTS appeal_resolved_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS false_positive_cleared BOOLEAN NOT NULL DEFAULT false;

CREATE INDEX IF NOT EXISTS idx_mc_appeal_status
  ON moderation_cases(appeal_status)
  WHERE appeal_status != 'none';

-- ----------------------------------------------------------------------------
-- 2. moderation_appeals (§17.4 Hard-Block Appeal & False Positive Audit Trail)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS moderation_appeals (
  appeal_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  case_id                UUID NOT NULL REFERENCES moderation_cases(case_id) ON DELETE CASCADE,
  workspace_id           UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  user_id                UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  appeal_reason          TEXT NOT NULL,
  evidence_reference     TEXT,
  evidence_details       JSONB NOT NULL DEFAULT '{}'::jsonb,
  status                 VARCHAR(20) NOT NULL DEFAULT 'pending'
                           CHECK (status IN ('pending', 'reviewing', 'upheld', 'overturned')),
  reviewer_admin_id      UUID REFERENCES internal_admins(admin_id),
  resolution_reason      TEXT,
  is_hard_block          BOOLEAN NOT NULL DEFAULT false,
  false_positive_cleared BOOLEAN NOT NULL DEFAULT false,
  created_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  resolved_at            TIMESTAMPTZ,
  CONSTRAINT uq_moderation_appeals_tenant_pk UNIQUE (workspace_id, appeal_id)
);

CREATE INDEX IF NOT EXISTS idx_ma_case
  ON moderation_appeals(case_id, status);

CREATE INDEX IF NOT EXISTS idx_ma_workspace
  ON moderation_appeals(workspace_id, created_at DESC);

ALTER TABLE moderation_appeals ENABLE ROW LEVEL SECURITY;
ALTER TABLE moderation_appeals FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON moderation_appeals;
CREATE POLICY tenant_isolation ON moderation_appeals
  FOR SELECT
  TO app_user
  USING (workspace_id = COALESCE(NULLIF(current_setting('app.current_tenant_id', true), ''), NULLIF(current_setting('app.current_workspace_id', true), ''))::uuid);

DROP POLICY IF EXISTS tenant_insert ON moderation_appeals;
CREATE POLICY tenant_insert ON moderation_appeals
  FOR INSERT
  TO app_user
  WITH CHECK (workspace_id = COALESCE(NULLIF(current_setting('app.current_tenant_id', true), ''), NULLIF(current_setting('app.current_workspace_id', true), ''))::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON moderation_appeals;
CREATE POLICY admin_ops_scope ON moderation_appeals
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 3. proactive_coaching_snapshots (PRD §36B Proactive Coaching Snapshots)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS proactive_coaching_snapshots (
  snapshot_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id         UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  connected_account_id UUID NOT NULL REFERENCES connected_accounts(connected_account_id) ON DELETE CASCADE,
  platform             VARCHAR(30) NOT NULL,
  metric_key           VARCHAR(50) NOT NULL,
  observed_value       VARCHAR(50) NOT NULL,
  threshold_value      VARCHAR(50) NOT NULL,
  numerator            BIGINT NOT NULL DEFAULT 0,
  denominator          BIGINT NOT NULL DEFAULT 0,
  window_label         VARCHAR(50) NOT NULL,
  coaching_message     TEXT NOT NULL,
  action_url           VARCHAR(200) NOT NULL,
  captured_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_proactive_coaching_snapshots_tenant_pk UNIQUE (workspace_id, snapshot_id)
);

CREATE INDEX IF NOT EXISTS idx_pcs_account_metric
  ON proactive_coaching_snapshots(connected_account_id, metric_key, captured_at DESC);

CREATE INDEX IF NOT EXISTS idx_pcs_workspace
  ON proactive_coaching_snapshots(workspace_id, captured_at DESC);

ALTER TABLE proactive_coaching_snapshots ENABLE ROW LEVEL SECURITY;
ALTER TABLE proactive_coaching_snapshots FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON proactive_coaching_snapshots;
CREATE POLICY tenant_isolation ON proactive_coaching_snapshots
  FOR ALL
  TO app_user
  USING (workspace_id = COALESCE(NULLIF(current_setting('app.current_tenant_id', true), ''), NULLIF(current_setting('app.current_workspace_id', true), ''))::uuid)
  WITH CHECK (workspace_id = COALESCE(NULLIF(current_setting('app.current_tenant_id', true), ''), NULLIF(current_setting('app.current_workspace_id', true), ''))::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON proactive_coaching_snapshots;
CREATE POLICY admin_ops_scope ON proactive_coaching_snapshots
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 4. Role grants and permissions
-- ----------------------------------------------------------------------------
REVOKE ALL ON
  moderation_appeals,
  proactive_coaching_snapshots
FROM PUBLIC;

GRANT SELECT, INSERT ON moderation_appeals TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON proactive_coaching_snapshots TO app_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON
  moderation_appeals,
  proactive_coaching_snapshots
TO admin_user;

-- +goose Down
REVOKE ALL PRIVILEGES ON
  moderation_appeals,
  proactive_coaching_snapshots
FROM app_user, admin_user;

DROP TABLE IF EXISTS proactive_coaching_snapshots;
DROP TABLE IF EXISTS moderation_appeals;

ALTER TABLE moderation_cases
  DROP COLUMN IF EXISTS false_positive_cleared,
  DROP COLUMN IF EXISTS appeal_resolved_at,
  DROP COLUMN IF EXISTS appeal_resolution_notes,
  DROP COLUMN IF EXISTS appeal_reviewed_by,
  DROP COLUMN IF EXISTS appealed_at,
  DROP COLUMN IF EXISTS appealed_by,
  DROP COLUMN IF EXISTS appeal_evidence,
  DROP COLUMN IF EXISTS appeal_reason,
  DROP COLUMN IF EXISTS appeal_status;
