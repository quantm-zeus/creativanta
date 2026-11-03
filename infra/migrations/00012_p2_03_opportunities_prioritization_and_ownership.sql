-- ============================================================================
-- Creativanta P2-03 Migration: Opportunity Prioritization & Ownership (M04)
-- Canonical Source: docs/04_contracts/database_schema.md (§5.4, §5.5, §26.11, §26.12, §27.2)
--                   docs/02_features/intelligence/opportunity_board.md (RULE-M04-001–006, EC-M04-001–004)
--                   docs/04_contracts/domain_event_catalog.md (§3)
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. Extend opportunities with Priority State, Ownership & Impact/Effort (§5.4)
-- ----------------------------------------------------------------------------
ALTER TABLE opportunities ADD COLUMN IF NOT EXISTS summary TEXT;
ALTER TABLE opportunities ADD COLUMN IF NOT EXISTS why_it_matters TEXT;
ALTER TABLE opportunities ADD COLUMN IF NOT EXISTS expected_impact JSONB DEFAULT '{}'::jsonb;
ALTER TABLE opportunities ADD COLUMN IF NOT EXISTS expected_effort JSONB DEFAULT '{}'::jsonb;
ALTER TABLE opportunities ADD COLUMN IF NOT EXISTS priority_state VARCHAR(20) NOT NULL DEFAULT 'draft';
ALTER TABLE opportunities ADD COLUMN IF NOT EXISTS priority_reason TEXT;
ALTER TABLE opportunities ADD COLUMN IF NOT EXISTS suggested_next_step TEXT;
ALTER TABLE opportunities ADD COLUMN IF NOT EXISTS owner_user_id UUID;

-- Priority state validation constraint matching canonical state machine (§5.4)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'chk_opportunities_priority_state'
  ) THEN
    ALTER TABLE opportunities ADD CONSTRAINT chk_opportunities_priority_state
      CHECK (priority_state IN ('draft', 'open', 'prioritized', 'assigned', 'in_progress', 'converted', 'parked', 'closed_won', 'closed_lost'));
  END IF;
END $$;

-- Owner user reference
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'fk_opportunities_owner_user_id'
  ) THEN
    ALTER TABLE opportunities ADD CONSTRAINT fk_opportunities_owner_user_id
      FOREIGN KEY (owner_user_id) REFERENCES users(user_id) ON DELETE SET NULL;
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS idx_opp_workspace_priority_state ON opportunities(workspace_id, priority_state);
CREATE INDEX IF NOT EXISTS idx_opp_workspace_owner ON opportunities(workspace_id, owner_user_id);
CREATE INDEX IF NOT EXISTS idx_opp_sources_lookup ON opportunity_sources(workspace_id, source_type, source_id);

-- ----------------------------------------------------------------------------
-- 2. Direct RLS Policies (§26.11)
-- ----------------------------------------------------------------------------
ALTER TABLE opportunities ENABLE ROW LEVEL SECURITY;
ALTER TABLE opportunities FORCE ROW LEVEL SECURITY;

ALTER TABLE opportunity_sources ENABLE ROW LEVEL SECURITY;
ALTER TABLE opportunity_sources FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS admin_ops_scope ON opportunities;
CREATE POLICY admin_ops_scope ON opportunities
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

DROP POLICY IF EXISTS admin_ops_scope ON opportunity_sources;
CREATE POLICY admin_ops_scope ON opportunity_sources
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 3. Narrow Role Grants (§26.12 — NEVER GRANT ALL)
-- ----------------------------------------------------------------------------
GRANT SELECT, INSERT, UPDATE, DELETE ON opportunities TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON opportunities TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON opportunity_sources TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON opportunity_sources TO admin_user;

-- +goose Down
REVOKE SELECT, INSERT, UPDATE, DELETE ON opportunities FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON opportunity_sources FROM admin_user;
DROP POLICY IF EXISTS admin_ops_scope ON opportunity_sources;
DROP POLICY IF EXISTS admin_ops_scope ON opportunities;
DROP INDEX IF EXISTS idx_opp_sources_lookup;
DROP INDEX IF EXISTS idx_opp_workspace_owner;
DROP INDEX IF EXISTS idx_opp_workspace_priority_state;
ALTER TABLE opportunities DROP CONSTRAINT IF EXISTS fk_opportunities_owner_user_id;
ALTER TABLE opportunities DROP CONSTRAINT IF EXISTS chk_opportunities_priority_state;
ALTER TABLE opportunities DROP COLUMN IF EXISTS owner_user_id;
ALTER TABLE opportunities DROP COLUMN IF EXISTS suggested_next_step;
ALTER TABLE opportunities DROP COLUMN IF EXISTS priority_reason;
ALTER TABLE opportunities DROP COLUMN IF EXISTS priority_state;
ALTER TABLE opportunities DROP COLUMN IF EXISTS expected_effort;
ALTER TABLE opportunities DROP COLUMN IF EXISTS expected_impact;
ALTER TABLE opportunities DROP COLUMN IF EXISTS why_it_matters;
ALTER TABLE opportunities DROP COLUMN IF EXISTS summary;
