-- +goose Up
-- Security Remediation Migration:
-- 1. TENANT-01: Restrict workspace_members RLS so cross-workspace self-discovery is SELECT-only
--    and initial owner membership bootstrap is permitted only for workspaces owned by app.current_user_id.
-- 2. TENANT-02: Add workspace_id, composite tenant FKs, and FORCE ROW LEVEL SECURITY to affiliate_statement_items.
-- 3. R05: Ensure workspaces.display_name and workspaces.default_operator_mode are backfilled from name/default_mode.

-- =============================================================================
-- 1. TENANT-01: workspace_members RLS remediation
-- =============================================================================

DROP POLICY IF EXISTS tenant_isolation ON workspace_members;
DROP POLICY IF EXISTS workspace_members_self_discovery ON workspace_members;
DROP POLICY IF EXISTS workspace_members_owner_bootstrap ON workspace_members;
DROP POLICY IF EXISTS admin_ops_scope ON workspace_members;

-- Tenant-scoped access (SELECT, INSERT, UPDATE, DELETE) requires matching app.current_tenant_id
CREATE POLICY tenant_isolation ON workspace_members
  FOR ALL TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

-- Cross-workspace self-discovery is strictly read-only (SELECT only)
CREATE POLICY workspace_members_self_discovery ON workspace_members
  FOR SELECT TO app_user
  USING (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
    OR user_id = NULLIF(current_setting('app.current_user_id', true), '')::uuid
  );

-- Initial workspace owner bootstrap inside WithUserBootstrapTx is INSERT-only for the workspace owner
CREATE POLICY workspace_members_owner_bootstrap ON workspace_members
  FOR INSERT TO app_user
  WITH CHECK (
    user_id = NULLIF(current_setting('app.current_user_id', true), '')::uuid
    AND role = 'owner'
    AND status = 'active'
    AND EXISTS (
      SELECT 1
      FROM workspaces w
      WHERE w.workspace_id = workspace_members.workspace_id
        AND w.owner_user_id = NULLIF(current_setting('app.current_user_id', true), '')::uuid
    )
  );

-- Admin operations scope
CREATE POLICY admin_ops_scope ON workspace_members
  FOR ALL TO admin_user
  USING (true)
  WITH CHECK (true);

-- =============================================================================
-- 2. TENANT-02: affiliate_statement_items tenant isolation, composite FKs & RLS
-- =============================================================================

ALTER TABLE affiliate_statement_items
  ADD COLUMN IF NOT EXISTS workspace_id UUID;

-- Backfill existing rows from parent affiliate_statements
UPDATE affiliate_statement_items asi
SET workspace_id = s.workspace_id
FROM affiliate_statements s
WHERE s.statement_id = asi.statement_id
  AND asi.workspace_id IS NULL;

ALTER TABLE affiliate_statement_items
  ALTER COLUMN workspace_id SET DEFAULT NULLIF(current_setting('app.current_tenant_id', true), '')::uuid,
  ALTER COLUMN workspace_id SET NOT NULL;

-- Non-SECURITY-DEFINER trigger to populate workspace_id from parent statement when omitted,
-- while still enforcing caller RLS policies on affiliate_statements and affiliate_statement_items.
-- +goose StatementBegin
CREATE OR REPLACE FUNCTION fill_affiliate_statement_item_workspace_id()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.workspace_id IS NULL THEN
    SELECT s.workspace_id INTO NEW.workspace_id
    FROM affiliate_statements s
    WHERE s.statement_id = NEW.statement_id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
-- +goose StatementEnd

DROP TRIGGER IF EXISTS trg_affiliate_statement_items_fill_workspace ON affiliate_statement_items;
CREATE TRIGGER trg_affiliate_statement_items_fill_workspace
  BEFORE INSERT ON affiliate_statement_items
  FOR EACH ROW
  EXECUTE FUNCTION fill_affiliate_statement_item_workspace_id();

ALTER TABLE affiliate_statement_items
  DROP CONSTRAINT IF EXISTS fk_affiliate_statement_items_workspace,
  DROP CONSTRAINT IF EXISTS uq_affiliate_statement_items_tenant_pk,
  DROP CONSTRAINT IF EXISTS fk_affiliate_statement_items_statement_tenant,
  DROP CONSTRAINT IF EXISTS fk_affiliate_statement_items_order_tenant,
  DROP CONSTRAINT IF EXISTS fk_affiliate_statement_items_commission_tenant;

ALTER TABLE affiliate_statement_items
  ADD CONSTRAINT fk_affiliate_statement_items_workspace
    FOREIGN KEY (workspace_id) REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  ADD CONSTRAINT uq_affiliate_statement_items_tenant_pk
    UNIQUE (workspace_id, item_id),
  ADD CONSTRAINT fk_affiliate_statement_items_statement_tenant
    FOREIGN KEY (workspace_id, statement_id) REFERENCES affiliate_statements(workspace_id, statement_id) ON DELETE CASCADE,
  ADD CONSTRAINT fk_affiliate_statement_items_order_tenant
    FOREIGN KEY (workspace_id, matched_order_id) REFERENCES orders(workspace_id, order_id),
  ADD CONSTRAINT fk_affiliate_statement_items_commission_tenant
    FOREIGN KEY (workspace_id, matched_commission_id) REFERENCES affiliate_commissions(workspace_id, commission_id);

CREATE INDEX IF NOT EXISTS idx_affiliate_statement_items_workspace
  ON affiliate_statement_items(workspace_id, statement_id);

ALTER TABLE affiliate_statement_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE affiliate_statement_items FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON affiliate_statement_items;
CREATE POLICY tenant_isolation ON affiliate_statement_items
  FOR ALL TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON affiliate_statement_items;
CREATE POLICY admin_ops_scope ON affiliate_statement_items
  FOR ALL TO admin_user
  USING (true)
  WITH CHECK (true);

-- =============================================================================
-- 3. R05: Backfill canonical workspaces.display_name & default_operator_mode
-- =============================================================================

UPDATE workspaces
SET display_name = name
WHERE (display_name IS NULL OR display_name = '')
  AND name IS NOT NULL
  AND name <> '';

UPDATE workspaces
SET default_operator_mode = default_mode::text
WHERE (default_operator_mode IS NULL OR default_operator_mode = '')
  AND default_mode IS NOT NULL;

-- +goose Down
DROP POLICY IF EXISTS admin_ops_scope ON affiliate_statement_items;
DROP POLICY IF EXISTS tenant_isolation ON affiliate_statement_items;
ALTER TABLE affiliate_statement_items NO FORCE ROW LEVEL SECURITY;
ALTER TABLE affiliate_statement_items DISABLE ROW LEVEL SECURITY;

DROP INDEX IF EXISTS idx_affiliate_statement_items_workspace;

ALTER TABLE affiliate_statement_items
  DROP CONSTRAINT IF EXISTS fk_affiliate_statement_items_commission_tenant,
  DROP CONSTRAINT IF EXISTS fk_affiliate_statement_items_order_tenant,
  DROP CONSTRAINT IF EXISTS fk_affiliate_statement_items_statement_tenant,
  DROP CONSTRAINT IF EXISTS uq_affiliate_statement_items_tenant_pk,
  DROP CONSTRAINT IF EXISTS fk_affiliate_statement_items_workspace;

DROP TRIGGER IF EXISTS trg_affiliate_statement_items_fill_workspace ON affiliate_statement_items;
DROP FUNCTION IF EXISTS fill_affiliate_statement_item_workspace_id();

ALTER TABLE affiliate_statement_items
  DROP COLUMN IF EXISTS workspace_id;

DROP POLICY IF EXISTS admin_ops_scope ON workspace_members;
DROP POLICY IF EXISTS workspace_members_owner_bootstrap ON workspace_members;
DROP POLICY IF EXISTS workspace_members_self_discovery ON workspace_members;
DROP POLICY IF EXISTS tenant_isolation ON workspace_members;

CREATE POLICY tenant_isolation ON workspace_members
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
    OR user_id = NULLIF(current_setting('app.current_user_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
    OR user_id = NULLIF(current_setting('app.current_user_id', true), '')::uuid);
