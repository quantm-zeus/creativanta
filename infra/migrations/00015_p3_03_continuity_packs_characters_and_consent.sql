-- ============================================================================
-- Creativanta P3-03 Migration: Continuity Packs, Characters & Consent (M08)
-- Canonical Sources: docs/04_contracts/database_schema.md (§7.1, §7.2, §18.3)
--                    docs/02_features/content/continuity_os.md (RULE-M08-001–008, EC-M08-001–004)
--                    docs/04_contracts/domain_event_catalog.md (§5, §18)
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. consent_records Table (§18.3)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS consent_records (
  consent_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  workspace_id UUID REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  consent_type VARCHAR(50) NOT NULL, -- tos, privacy, marketing, analytics, ai_processing, voice_clone, digital_twin
  version      VARCHAR(20) NOT NULL,
  granted      BOOLEAN NOT NULL,
  granted_at   TIMESTAMPTZ,
  revoked_at   TIMESTAMPTZ,
  ip_address   INET,
  user_agent   TEXT,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_consent_records_tenant_pk UNIQUE (workspace_id, consent_id)
);

CREATE INDEX IF NOT EXISTS idx_cr_workspace ON consent_records(workspace_id);
CREATE INDEX IF NOT EXISTS idx_cr_user ON consent_records(user_id);
CREATE INDEX IF NOT EXISTS idx_cr_type ON consent_records(consent_type);

ALTER TABLE consent_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE consent_records FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON consent_records;
CREATE POLICY tenant_isolation ON consent_records
  FOR ALL
  TO app_user
  USING (
    (workspace_id IS NOT NULL AND workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
    OR
    (workspace_id IS NULL AND user_id = NULLIF(current_setting('app.current_user_id', true), '')::uuid)
  )
  WITH CHECK (
    (workspace_id IS NOT NULL AND workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
    OR
    (workspace_id IS NULL AND user_id = NULLIF(current_setting('app.current_user_id', true), '')::uuid)
  );

DROP POLICY IF EXISTS admin_ops_scope ON consent_records;
CREATE POLICY admin_ops_scope ON consent_records
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON consent_records TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON consent_records TO admin_user;

-- ----------------------------------------------------------------------------
-- 2. characters Table (§7.1)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS characters (
  character_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id      UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  name              VARCHAR(255) NOT NULL,
  character_type    VARCHAR(20) NOT NULL, -- digital_twin, ai_generated, stock
  description       TEXT,
  reference_images  JSONB DEFAULT '[]', -- [{url, type}]
  voice_settings    JSONB DEFAULT '{}',
  visual_settings   JSONB DEFAULT '{}',
  consent_verified  BOOLEAN DEFAULT false,
  consent_record_id UUID,
  is_default        BOOLEAN DEFAULT false,
  status            VARCHAR(20) NOT NULL DEFAULT 'creating',
  character_pack_id UUID,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at        TIMESTAMPTZ, -- soft delete (DB-H-003)
  CONSTRAINT uq_characters_tenant_pk UNIQUE (workspace_id, character_id),
  CONSTRAINT fk_characters_consent_record_id_tenant
    FOREIGN KEY (workspace_id, consent_record_id) REFERENCES consent_records(workspace_id, consent_id) ON DELETE SET NULL,
  CONSTRAINT chk_characters_type
    CHECK (character_type IN ('digital_twin', 'ai_generated', 'stock')),
  CONSTRAINT chk_characters_status
    CHECK (status IN ('creating', 'ready', 'failed', 'archived'))
);

CREATE INDEX IF NOT EXISTS idx_characters_workspace ON characters(workspace_id);
CREATE INDEX IF NOT EXISTS idx_characters_status ON characters(workspace_id, status);
CREATE INDEX IF NOT EXISTS idx_characters_type ON characters(workspace_id, character_type);

-- Acceptance Target 3: Exactly one active default character per workspace
CREATE UNIQUE INDEX IF NOT EXISTS uq_characters_single_default
  ON characters (workspace_id)
  WHERE is_default = true AND deleted_at IS NULL;

ALTER TABLE characters ENABLE ROW LEVEL SECURITY;
ALTER TABLE characters FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON characters;
CREATE POLICY tenant_isolation ON characters
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON characters;
CREATE POLICY admin_ops_scope ON characters
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON characters TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON characters TO admin_user;

-- ----------------------------------------------------------------------------
-- 3. continuity_packs Table (§7.2)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS continuity_packs (
  pack_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id        UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  pack_type           VARCHAR(20) NOT NULL, -- character, brand, voice, style, lookbook, scene_memory
  name                VARCHAR(255) NOT NULL,
  character_id        UUID,
  approved_references JSONB DEFAULT '[]',
  rules_summary       TEXT,
  settings            JSONB NOT NULL DEFAULT '{}',
  allowed_use_scope   JSONB DEFAULT '{}',
  version             INTEGER NOT NULL DEFAULT 1,
  parent_pack_id      UUID,
  status              VARCHAR(20) NOT NULL DEFAULT 'draft', -- draft, active, deprecated, retired
  created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at          TIMESTAMPTZ, -- soft delete (DB-H-003)
  CONSTRAINT uq_continuity_packs_tenant_pk UNIQUE (workspace_id, pack_id),
  CONSTRAINT fk_continuity_packs_character_id_tenant
    FOREIGN KEY (workspace_id, character_id) REFERENCES characters(workspace_id, character_id) ON DELETE SET NULL,
  CONSTRAINT fk_continuity_packs_parent_pack_id_tenant
    FOREIGN KEY (workspace_id, parent_pack_id) REFERENCES continuity_packs(workspace_id, pack_id) ON DELETE SET NULL,
  CONSTRAINT chk_continuity_packs_type
    CHECK (pack_type IN ('character', 'brand', 'voice', 'style', 'lookbook', 'scene_memory')),
  CONSTRAINT chk_continuity_packs_status
    CHECK (status IN ('draft', 'active', 'deprecated', 'retired'))
);

CREATE INDEX IF NOT EXISTS idx_cp_workspace ON continuity_packs(workspace_id);
CREATE INDEX IF NOT EXISTS idx_cp_type ON continuity_packs(workspace_id, pack_type);
CREATE INDEX IF NOT EXISTS idx_cp_character ON continuity_packs(workspace_id, character_id);
CREATE INDEX IF NOT EXISTS idx_cp_status ON continuity_packs(workspace_id, status);

ALTER TABLE continuity_packs ENABLE ROW LEVEL SECURITY;
ALTER TABLE continuity_packs FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON continuity_packs;
CREATE POLICY tenant_isolation ON continuity_packs
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON continuity_packs;
CREATE POLICY admin_ops_scope ON continuity_packs
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON continuity_packs TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON continuity_packs TO admin_user;

-- Wire character -> character_pack_id FK now that continuity_packs exists
ALTER TABLE characters ADD CONSTRAINT fk_characters_character_pack_id_tenant
  FOREIGN KEY (workspace_id, character_pack_id) REFERENCES continuity_packs(workspace_id, pack_id) ON DELETE SET NULL;

-- ----------------------------------------------------------------------------
-- 4. continuity_pack_versions Table (Acceptance Target 2: Lineage retention)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS continuity_pack_versions (
  version_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id        UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  pack_id             UUID NOT NULL,
  version_index       INTEGER NOT NULL,
  name                VARCHAR(255) NOT NULL,
  pack_type           VARCHAR(20) NOT NULL,
  approved_references JSONB DEFAULT '[]',
  rules_summary       TEXT,
  settings            JSONB NOT NULL DEFAULT '{}',
  allowed_use_scope   JSONB DEFAULT '{}',
  status              VARCHAR(20) NOT NULL DEFAULT 'active',
  snapshot_reason     VARCHAR(100) DEFAULT 'update',
  created_by          UUID REFERENCES users(user_id),
  created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_continuity_pack_versions_tenant_pk UNIQUE (workspace_id, version_id),
  CONSTRAINT fk_continuity_pack_versions_pack_id_tenant
    FOREIGN KEY (workspace_id, pack_id) REFERENCES continuity_packs(workspace_id, pack_id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_cp_versions_pack ON continuity_pack_versions(workspace_id, pack_id, version_index);

ALTER TABLE continuity_pack_versions ENABLE ROW LEVEL SECURITY;
ALTER TABLE continuity_pack_versions FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON continuity_pack_versions;
CREATE POLICY tenant_isolation ON continuity_pack_versions
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON continuity_pack_versions;
CREATE POLICY admin_ops_scope ON continuity_pack_versions
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON continuity_pack_versions TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON continuity_pack_versions TO admin_user;

-- +goose Down
ALTER TABLE characters DROP CONSTRAINT IF EXISTS fk_characters_character_pack_id_tenant;
DROP TABLE IF EXISTS continuity_pack_versions CASCADE;
DROP TABLE IF EXISTS continuity_packs CASCADE;
DROP TABLE IF EXISTS characters CASCADE;
DROP TABLE IF EXISTS consent_records CASCADE;
