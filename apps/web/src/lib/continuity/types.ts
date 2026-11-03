// Frontend contracts and helpers for Module M08 — Continuity OS
// Canonical source: docs/02_features/content/continuity_os.md,
// docs/04_contracts/database_schema.md §7.1, §7.2, §18.3,
// and screen specifications W019 & W037.

export type CharacterType = 'digital_twin' | 'ai_generated' | 'stock';

export type CharacterStatus = 'creating' | 'ready' | 'failed' | 'archived';

export type PackType =
  | 'character'
  | 'brand'
  | 'voice'
  | 'style'
  | 'lookbook'
  | 'scene_memory';

export type PackStatus = 'draft' | 'active' | 'deprecated' | 'retired';

export type DriftSeverity = 'none' | 'low_drift' | 'moderate_drift' | 'high_drift';

export type SubscriptionTier = 'free' | 'starter' | 'pro' | 'business' | 'enterprise';

export interface ApprovedReference {
  referenceId: string;
  packId?: string;
  name: string;
  mediaUrl: string;
  referenceType: 'headshot' | 'full_body' | 'voice_sample' | 'style_keyframe' | 'brand_logo';
  sourceContext?: string;
  status: 'approved' | 'review_required' | 'superseded';
  createdAt?: string;
}

export interface PackVersion {
  versionId: string;
  workspaceId: string;
  packId: string;
  versionIndex: number;
  name: string;
  packType: PackType;
  approvedReferences: ApprovedReference[];
  rulesSummary: string;
  settingsJson?: string;
  allowedUseScopeJson?: string;
  status: PackStatus;
  snapshotReason: string;
  createdAt: string;
}

export interface ContinuityPack {
  packId: string;
  workspaceId: string;
  packType: PackType;
  name: string;
  characterId?: string;
  approvedReferences: ApprovedReference[];
  rulesSummary: string;
  settingsJson?: string;
  allowedUseScopeJson?: string;
  version: number;
  parentPackId?: string;
  status: PackStatus;
  createdAt: string;
  updatedAt: string;
}

export interface ConsentRecord {
  consentId: string;
  userId: string;
  workspaceId: string;
  consentType: string;
  version: string;
  granted: boolean;
  grantedAt?: string;
  revokedAt?: string;
  revokedReason?: string;
  sourceFootageUrl?: string;
  consentVideoUrl?: string;
  faceMatchVerified?: boolean;
  createdAt: string;
}

export interface Character {
  characterId: string;
  workspaceId: string;
  name: string;
  characterType: CharacterType;
  description: string;
  referenceImagesJson?: string;
  voiceSettingsJson?: string;
  visualSettingsJson?: string;
  consentVerified: boolean;
  consentRecordId?: string;
  isDefault: boolean;
  status: CharacterStatus;
  characterPackId?: string;
  avatarUrl?: string;
  speakingTone?: string;
  personalityTags?: string[];
  createdAt: string;
  updatedAt: string;
}

// Tier limits per RULE-M08-003 and AC-M08-008
export const TIER_SLOT_LIMITS: Record<SubscriptionTier, number> = {
  free: 1,
  starter: 2,
  pro: 5,
  business: 15,
  enterprise: -1, // Unlimited
};

export function getSlotQuota(tier: string): number {
  const norm = (tier || 'free').toLowerCase() as SubscriptionTier;
  return TIER_SLOT_LIMITS[norm] ?? 1;
}

export function isSlotQuotaExceeded(activeCount: number, tier: string): boolean {
  const quota = getSlotQuota(tier);
  if (quota === -1) return false;
  return activeCount >= quota;
}

export function validateWizardProgression(
  step: number,
  previewVerified: boolean,
  charType: CharacterType,
  consentVerified: boolean
): { valid: boolean; error?: string } {
  if (step === 4) {
    if (!previewVerified) {
      return { valid: false, error: 'Step 3 (Preview) must be verified before saving character.' };
    }
    if (charType === 'digital_twin' && !consentVerified) {
      return { valid: false, error: 'Digital Twin likeness consent must be verified before saving.' };
    }
  }
  return { valid: true };
}

export function getDriftSeverityBadgeInfo(severity: DriftSeverity): {
  label: string;
  badgeClass: string;
  blocksPublish: boolean;
  requiresWarning: boolean;
} {
  switch (severity) {
    case 'none':
      return { label: 'Nhất quán hoàn hảo (None)', badgeClass: 'bg-emerald-50 text-emerald-700 border-emerald-200', blocksPublish: false, requiresWarning: false };
    case 'low_drift':
      return { label: 'Độ lệch thấp (Low)', badgeClass: 'bg-blue-50 text-blue-700 border-blue-200', blocksPublish: false, requiresWarning: false };
    case 'moderate_drift':
      return { label: 'Độ lệch trung bình (Moderate)', badgeClass: 'bg-amber-50 text-amber-700 border-amber-200', blocksPublish: false, requiresWarning: true };
    case 'high_drift':
      return { label: 'Độ lệch cao — Bị chặn (High)', badgeClass: 'bg-rose-50 text-rose-700 border-rose-200', blocksPublish: true, requiresWarning: true };
    default:
      return { label: 'Chưa đánh giá', badgeClass: 'bg-gray-50 text-gray-700 border-gray-200', blocksPublish: false, requiresWarning: false };
  }
}
