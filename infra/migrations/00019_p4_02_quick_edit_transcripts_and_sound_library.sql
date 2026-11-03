-- ============================================================================
-- Creativanta P4-02 Migration: Quick Edit Transcripts, Drafts, and Sound Library
-- Canonical Sources: docs/02_features/production/ai_video_studio.md (§Mode 1: Quick Edit, EC-M07-Q01, RULE-M07-005)
--                    docs/03_screens/web/screen_web_studio_quick_edit.md (W022)
--                    docs/03_screens/mobile/screen_mobile_studio_quick_edit.md (M014)
--                    docs/04_contracts/database_schema.md (§7.3, §7.4, §22.1)
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. transcripts Table
--    Stores Whisper ASR transcriptions with word-level timestamps, fillers,
--    pauses, and alignment repair status per EC-M07-Q01.
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS transcripts (
  transcript_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id             UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  asset_id                 UUID NOT NULL,
  language                 VARCHAR(10) NOT NULL DEFAULT 'vi',
  raw_text                 TEXT NOT NULL,
  words                    JSONB NOT NULL DEFAULT '[]',
  segments                 JSONB NOT NULL DEFAULT '[]',
  filler_count             INT NOT NULL DEFAULT 0,
  pause_count              INT NOT NULL DEFAULT 0,
  alignment_status         VARCHAR(20) NOT NULL DEFAULT 'auto_aligned',
  alignment_error          TEXT,
  created_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at               TIMESTAMPTZ,
  CONSTRAINT uq_transcripts_tenant_pk UNIQUE (workspace_id, transcript_id),
  CONSTRAINT fk_transcripts_asset_tenant
    FOREIGN KEY (workspace_id, asset_id) REFERENCES assets(workspace_id, asset_id) ON DELETE CASCADE,
  CONSTRAINT chk_transcripts_alignment_status
    CHECK (alignment_status IN ('auto_aligned', 'repaired', 'manual_fallback', 'failed'))
);

CREATE INDEX IF NOT EXISTS idx_transcripts_workspace ON transcripts(workspace_id);
CREATE INDEX IF NOT EXISTS idx_transcripts_asset ON transcripts(workspace_id, asset_id);
CREATE INDEX IF NOT EXISTS idx_transcripts_status ON transcripts(alignment_status);

ALTER TABLE transcripts ENABLE ROW LEVEL SECURITY;
ALTER TABLE transcripts FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON transcripts;
CREATE POLICY tenant_isolation ON transcripts
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON transcripts;
CREATE POLICY admin_ops_scope ON transcripts
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON transcripts TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON transcripts TO admin_user;

-- ----------------------------------------------------------------------------
-- 2. quick_edit_drafts Table
--    Persists creator drafts, strikethrough cut intervals, add-on configurations,
--    and estimated credits (strictly NUMERIC(18,6) per DB-H-001).
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS quick_edit_drafts (
  draft_id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id             UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  asset_id                 UUID NOT NULL,
  transcript_id            UUID NOT NULL,
  name                     VARCHAR(255) NOT NULL DEFAULT 'Quick Edit Draft',
  cuts                     JSONB NOT NULL DEFAULT '[]',
  addons                   JSONB NOT NULL DEFAULT '{}',
  estimated_credits        NUMERIC(18,6) NOT NULL DEFAULT 15.000000,
  created_by               UUID REFERENCES users(user_id),
  created_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at               TIMESTAMPTZ,
  CONSTRAINT uq_quick_edit_drafts_tenant_pk UNIQUE (workspace_id, draft_id),
  CONSTRAINT fk_quick_edit_drafts_asset_tenant
    FOREIGN KEY (workspace_id, asset_id) REFERENCES assets(workspace_id, asset_id) ON DELETE CASCADE,
  CONSTRAINT fk_quick_edit_drafts_transcript_tenant
    FOREIGN KEY (workspace_id, transcript_id) REFERENCES transcripts(workspace_id, transcript_id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_qed_workspace ON quick_edit_drafts(workspace_id);
CREATE INDEX IF NOT EXISTS idx_qed_asset ON quick_edit_drafts(workspace_id, asset_id);
CREATE INDEX IF NOT EXISTS idx_qed_transcript ON quick_edit_drafts(workspace_id, transcript_id);

ALTER TABLE quick_edit_drafts ENABLE ROW LEVEL SECURITY;
ALTER TABLE quick_edit_drafts FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON quick_edit_drafts;
CREATE POLICY tenant_isolation ON quick_edit_drafts
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON quick_edit_drafts;
CREATE POLICY admin_ops_scope ON quick_edit_drafts
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON quick_edit_drafts TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON quick_edit_drafts TO admin_user;

-- ----------------------------------------------------------------------------
-- 3. sound_library Table
--    Royalty-free background music and audio assets with ACRCloud fingerprints
--    and beat sync metadata. Allows global sound catalog and workspace sounds.
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS sound_library (
  sound_id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id             UUID REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  title                    VARCHAR(255) NOT NULL,
  artist                   VARCHAR(255) NOT NULL,
  genre                    VARCHAR(50) NOT NULL,
  bpm                      INT NOT NULL DEFAULT 120,
  duration_seconds         NUMERIC(12,2) NOT NULL,
  audio_url                TEXT NOT NULL,
  is_royalty_free          BOOLEAN NOT NULL DEFAULT true,
  acrcloud_cleared         BOOLEAN NOT NULL DEFAULT true,
  acrcloud_fingerprint     TEXT,
  license_type             VARCHAR(50) NOT NULL DEFAULT 'commercial_royalty_free',
  tags                     TEXT[] DEFAULT '{}',
  created_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at               TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_sound_lib_workspace ON sound_library(workspace_id);
CREATE INDEX IF NOT EXISTS idx_sound_lib_genre ON sound_library(genre);

ALTER TABLE sound_library ENABLE ROW LEVEL SECURITY;
ALTER TABLE sound_library FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS sound_library_select ON sound_library;
CREATE POLICY sound_library_select ON sound_library
  FOR SELECT
  TO app_user
  USING (
    workspace_id IS NULL OR
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  );

DROP POLICY IF EXISTS sound_library_modify ON sound_library;
CREATE POLICY sound_library_modify ON sound_library
  FOR ALL
  TO app_user
  USING (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  )
  WITH CHECK (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  );

DROP POLICY IF EXISTS admin_ops_scope ON sound_library;
CREATE POLICY admin_ops_scope ON sound_library
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON sound_library TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON sound_library TO admin_user;

-- ----------------------------------------------------------------------------
-- 4. Seed Data: Global Royalty-Free Sound Tracks
-- ----------------------------------------------------------------------------
INSERT INTO sound_library (
  sound_id, workspace_id, title, artist, genre, bpm, duration_seconds,
  audio_url, is_royalty_free, acrcloud_cleared, license_type, tags
) VALUES
  ('11111111-aaaa-1111-aaaa-111111111101', NULL, 'Midnight Chill Lo-Fi', 'Nova Beats', 'chill', 85, 145.0, 'https://cdn.creativanta.com/audio/lofi_chill_01.mp3', true, true, 'commercial_royalty_free', ARRAY['chill', 'lofi', 'focus', 'relax']),
  ('11111111-aaaa-1111-aaaa-111111111102', NULL, 'Neon Electric Pulse', 'CyberSynth', 'electronic', 128, 180.0, 'https://cdn.creativanta.com/audio/electronic_pulse_02.mp3', true, true, 'commercial_royalty_free', ARRAY['electronic', 'upbeat', 'tech', 'cyber']),
  ('11111111-aaaa-1111-aaaa-111111111103', NULL, 'Upbeat Viral Groove', 'Sunlight Trio', 'upbeat', 120, 155.0, 'https://cdn.creativanta.com/audio/viral_groove_03.mp3', true, true, 'commercial_royalty_free', ARRAY['upbeat', 'tiktok', 'trending', 'happy']),
  ('11111111-aaaa-1111-aaaa-111111111104', NULL, 'Cinematic Horizon', 'Epic Soundscapes', 'dramatic', 90, 210.0, 'https://cdn.creativanta.com/audio/cinematic_horizon_04.mp3', true, true, 'commercial_royalty_free', ARRAY['dramatic', 'trailer', 'epic', 'story']),
  ('11111111-aaaa-1111-aaaa-111111111105', NULL, 'Warm Acoustic Morning', 'Elena Wood', 'acoustic', 105, 165.0, 'https://cdn.creativanta.com/audio/acoustic_morning_05.mp3', true, true, 'commercial_royalty_free', ARRAY['acoustic', 'guitar', 'vlog', 'warm']),
  ('11111111-aaaa-1111-aaaa-111111111106', NULL, 'Tech Minimal Flow', 'Circuit Lab', 'tech_pulse', 124, 190.0, 'https://cdn.creativanta.com/audio/tech_minimal_06.mp3', true, true, 'commercial_royalty_free', ARRAY['minimal', 'tech', 'modern', 'clean'])
ON CONFLICT (sound_id) DO NOTHING;

-- +goose Down
DELETE FROM sound_library WHERE sound_id IN (
  '11111111-aaaa-1111-aaaa-111111111101',
  '11111111-aaaa-1111-aaaa-111111111102',
  '11111111-aaaa-1111-aaaa-111111111103',
  '11111111-aaaa-1111-aaaa-111111111104',
  '11111111-aaaa-1111-aaaa-111111111105',
  '11111111-aaaa-1111-aaaa-111111111106'
);

REVOKE SELECT, INSERT, UPDATE, DELETE ON sound_library FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON sound_library FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON sound_library;
DROP POLICY IF EXISTS sound_library_modify ON sound_library;
DROP POLICY IF EXISTS sound_library_select ON sound_library;
DROP TABLE IF EXISTS sound_library CASCADE;

REVOKE SELECT, INSERT, UPDATE, DELETE ON quick_edit_drafts FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON quick_edit_drafts FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON quick_edit_drafts;
DROP POLICY IF EXISTS tenant_isolation ON quick_edit_drafts;
DROP TABLE IF EXISTS quick_edit_drafts CASCADE;

REVOKE SELECT, INSERT, UPDATE, DELETE ON transcripts FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON transcripts FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON transcripts;
DROP POLICY IF EXISTS tenant_isolation ON transcripts;
DROP TABLE IF EXISTS transcripts CASCADE;
