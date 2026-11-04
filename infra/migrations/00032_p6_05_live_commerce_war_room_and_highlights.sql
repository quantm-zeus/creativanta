-- ============================================================================
-- Creativanta P6-05 Migration: Live Commerce War Room, Cues and Highlights
-- Canonical Sources: docs/04_contracts/database_schema.md (§12.1, §19.9, §19.9B, §19.9C, §25.2)
--                    docs/02_features/commerce/live_war_room.md (RULE-M17-001 to RULE-M17-006)
--                    docs/02_features/production/asset_derivatives.md (RULE-M09-001, RULE-M09-005)
--                    docs/04_contracts/domain_event_catalog.md (§9, §19)
--                    docs/04_contracts/rbac_permission_matrix.md (§2.11)
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. live_sessions Table (§12.1)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS live_sessions (
  session_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id         UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  title                VARCHAR(500) NOT NULL,
  platform             VARCHAR(50),
  connected_account_id UUID REFERENCES connected_accounts(connected_account_id),
  status               VARCHAR(20) NOT NULL DEFAULT 'planned',
  planned_start_at     TIMESTAMPTZ,
  actual_start_at      TIMESTAMPTZ,
  actual_end_at        TIMESTAMPTZ,
  run_of_show          JSONB DEFAULT '[]'::jsonb,
  metrics_snapshot     JSONB DEFAULT '{}'::jsonb,
  metadata             JSONB DEFAULT '{}'::jsonb,
  created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at           TIMESTAMPTZ,
  CONSTRAINT uq_live_sessions_tenant_pk
    UNIQUE (workspace_id, session_id),
  CONSTRAINT chk_live_sessions_status
    CHECK (status IN ('planned', 'ready', 'live', 'paused', 'ended', 'post_live_processing', 'closed'))
);

CREATE INDEX IF NOT EXISTS idx_live_sessions_workspace ON live_sessions(workspace_id);
CREATE INDEX IF NOT EXISTS idx_live_sessions_status ON live_sessions(status);
CREATE INDEX IF NOT EXISTS idx_live_sessions_platform ON live_sessions(platform);
CREATE INDEX IF NOT EXISTS idx_live_sessions_planned_start ON live_sessions(planned_start_at);

ALTER TABLE live_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE live_sessions FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON live_sessions;
CREATE POLICY tenant_isolation ON live_sessions
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

GRANT SELECT, INSERT, UPDATE, DELETE ON live_sessions TO app_user;

-- ----------------------------------------------------------------------------
-- 2. live_segments Table (§19.9)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS live_segments (
  segment_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id           UUID NOT NULL REFERENCES live_sessions(session_id) ON DELETE CASCADE,
  workspace_id         UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  segment_type         VARCHAR(30) NOT NULL, -- product_demo, qa, giveaway, flash_sale, intro, outro
  start_offset_seconds INTEGER NOT NULL,
  end_offset_seconds   INTEGER,
  title                VARCHAR(255),
  pinned_offer_id      UUID REFERENCES offers(offer_id),
  notes                TEXT,
  created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_live_segments_tenant_pk
    UNIQUE (workspace_id, segment_id),
  CONSTRAINT fk_live_segments_session_id_tenant
    FOREIGN KEY (workspace_id, session_id) REFERENCES live_sessions(workspace_id, session_id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_live_segments_session ON live_segments(session_id);
CREATE INDEX IF NOT EXISTS idx_live_segments_workspace ON live_segments(workspace_id);

ALTER TABLE live_segments ENABLE ROW LEVEL SECURITY;
ALTER TABLE live_segments FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON live_segments;
CREATE POLICY tenant_isolation ON live_segments
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

GRANT SELECT, INSERT, UPDATE, DELETE ON live_segments TO app_user;

-- ----------------------------------------------------------------------------
-- 3. cue_cards Table (§19.9B)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS cue_cards (
  cue_card_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id           UUID NOT NULL REFERENCES live_sessions(session_id) ON DELETE CASCADE,
  workspace_id         UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  segment_id           UUID REFERENCES live_segments(segment_id) ON DELETE SET NULL,
  cue_type             VARCHAR(30) NOT NULL, -- product_highlight, talking_point, price_drop, giveaway, qa_prompt, cta, transition
  title                VARCHAR(255) NOT NULL,
  body                 TEXT,
  pinned_product_id    UUID REFERENCES products(product_id),
  pinned_offer_id      UUID REFERENCES offers(offer_id),
  display_order        SMALLINT NOT NULL DEFAULT 0,
  triggered_at         TIMESTAMPTZ,
  status               VARCHAR(20) NOT NULL DEFAULT 'pending',
  created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_cue_cards_tenant_pk
    UNIQUE (workspace_id, cue_card_id),
  CONSTRAINT fk_cue_cards_session_id_tenant
    FOREIGN KEY (workspace_id, session_id) REFERENCES live_sessions(workspace_id, session_id) ON DELETE CASCADE,
  CONSTRAINT chk_cue_cards_status
    CHECK (status IN ('pending', 'active', 'used', 'skipped'))
);

CREATE INDEX IF NOT EXISTS idx_cue_cards_session ON cue_cards(session_id);
CREATE INDEX IF NOT EXISTS idx_cue_cards_workspace ON cue_cards(workspace_id);
CREATE INDEX IF NOT EXISTS idx_cue_cards_segment ON cue_cards(segment_id);

ALTER TABLE cue_cards ENABLE ROW LEVEL SECURITY;
ALTER TABLE cue_cards FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON cue_cards;
CREATE POLICY tenant_isolation ON cue_cards
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

GRANT SELECT, INSERT, UPDATE, DELETE ON cue_cards TO app_user;

-- ----------------------------------------------------------------------------
-- 4. highlights Table (§19.9C)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS highlights (
  highlight_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id           UUID NOT NULL REFERENCES live_sessions(session_id) ON DELETE CASCADE,
  workspace_id         UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  title                VARCHAR(255),
  start_offset_seconds INTEGER NOT NULL,
  end_offset_seconds   INTEGER NOT NULL,
  highlight_type       VARCHAR(30) NOT NULL, -- viral_moment, product_demo, best_sale, audience_peak, key_announcement, engagement_spike, conversion_moment, objection_handling, custom
  auto_detected        BOOLEAN DEFAULT false,
  asset_id             UUID REFERENCES assets(asset_id) ON DELETE SET NULL,
  engagement_score     NUMERIC(5,2), -- 0-100 composite non-financial score
  notes                TEXT,
  pinned_offer_id      UUID REFERENCES offers(offer_id),
  pinned_product_id    UUID REFERENCES products(product_id),
  created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_highlights_tenant_pk
    UNIQUE (workspace_id, highlight_id),
  CONSTRAINT fk_highlights_session_id_tenant
    FOREIGN KEY (workspace_id, session_id) REFERENCES live_sessions(workspace_id, session_id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_highlights_session ON highlights(session_id);
CREATE INDEX IF NOT EXISTS idx_highlights_workspace ON highlights(workspace_id);
CREATE INDEX IF NOT EXISTS idx_highlights_asset ON highlights(asset_id);

ALTER TABLE highlights ENABLE ROW LEVEL SECURITY;
ALTER TABLE highlights FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON highlights;
CREATE POLICY tenant_isolation ON highlights
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

GRANT SELECT, INSERT, UPDATE, DELETE ON highlights TO app_user;

-- ----------------------------------------------------------------------------
-- 5. Link orders.live_session_id composite tenant FK if not already existing
-- ----------------------------------------------------------------------------
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'fk_orders_live_session_id_tenant'
  ) THEN
    ALTER TABLE orders
      ADD CONSTRAINT fk_orders_live_session_id_tenant
      FOREIGN KEY (workspace_id, live_session_id)
      REFERENCES live_sessions(workspace_id, session_id)
      ON DELETE SET NULL;
  END IF;
END $$;

-- +goose Down
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'fk_orders_live_session_id_tenant'
  ) THEN
    ALTER TABLE orders DROP CONSTRAINT fk_orders_live_session_id_tenant;
  END IF;
END $$;

DROP TABLE IF EXISTS highlights CASCADE;
DROP TABLE IF EXISTS cue_cards CASCADE;
DROP TABLE IF EXISTS live_segments CASCADE;
DROP TABLE IF EXISTS live_sessions CASCADE;
