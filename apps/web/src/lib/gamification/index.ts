/**
 * Creativanta Gamification & Style-Template Sharing Engine (Web Client)
 * Upstream: docs/02_features/platform/gamification.md
 * EF-11: Creator Gamification System
 * EF-07A: Style Pack Marketplace & Recipe Governance
 * Screen: W079 (docs/03_screens/web/screen_web_analytics_gamification.md)
 */

// ---------------------------------------------------------------------------
// 1. Level Progression & Thresholds (EF-11)
// ---------------------------------------------------------------------------

export interface LevelThreshold {
  level: number;
  xpRequired: number;
  title: string;
}

// Canonical milestones: L1=0, L5=100, L10=500, L20=2,000, L50=25,000
export const LEVEL_MILESTONES: LevelThreshold[] = [
  { level: 1, xpRequired: 0, title: 'Tập sự (Novice Creator)' },
  { level: 5, xpRequired: 100, title: 'Sáng tạo trẻ (Rising Creator)' },
  { level: 10, xpRequired: 500, title: 'Content Pro' },
  { level: 20, xpRequired: 2000, title: 'Chuyên gia nội dung (Master Storyteller)' },
  { level: 50, xpRequired: 25000, title: 'Huyền thoại sáng tạo (Creative Legend)' }
];

/**
 * Returns exact XP threshold required to reach any level from 1 to 50.
 * Follows piecewise progression matching EF-11 milestone anchors.
 */
export function getXPForLevel(level: number): number {
  if (level <= 1) return 0;
  if (level > 50) level = 50;

  if (level <= 5) {
    // 0 to 100 XP over 4 level steps (25 XP/level)
    return (level - 1) * 25;
  }
  if (level <= 10) {
    // 100 to 500 XP over 5 level steps (80 XP/level)
    return 100 + (level - 5) * 80;
  }
  if (level <= 20) {
    // 500 to 2,000 XP over 10 level steps (150 XP/level)
    return 500 + (level - 10) * 150;
  }
  // 20 to 50: 2,000 to 25,000 XP over 30 level steps (approx ~766.67 XP/level)
  return Math.round(2000 + ((level - 20) * (25000 - 2000)) / 30);
}

export function getTitleForLevel(level: number): string {
  if (level >= 50) return 'Huyền thoại sáng tạo (Creative Legend)';
  if (level >= 35) return 'Đạo diễn kỹ thuật số (Digital Director)';
  if (level >= 20) return 'Chuyên gia nội dung (Master Storyteller)';
  if (level >= 10) return 'Content Pro';
  if (level >= 5) return 'Sáng tạo trẻ (Rising Creator)';
  return 'Tập sự (Novice Creator)';
}

export interface CalculatedLevelProgress {
  currentLevel: number;
  totalXP: number;
  currentLevelBaseXP: number;
  nextLevelXP: number;
  xpInCurrentLevel: number;
  xpNeededForNextLevel: number;
  progressPercent: number;
  title: string;
  isMaxLevel: boolean;
}

export function calculateLevelProgress(totalXP: number): CalculatedLevelProgress {
  const safeXP = Math.max(0, Math.floor(totalXP));

  let currentLevel = 1;
  while (currentLevel < 50 && getXPForLevel(currentLevel + 1) <= safeXP) {
    currentLevel++;
  }

  const currentLevelBaseXP = getXPForLevel(currentLevel);
  const isMaxLevel = currentLevel >= 50;
  const nextLevelXP = isMaxLevel ? getXPForLevel(50) : getXPForLevel(currentLevel + 1);

  const xpInCurrentLevel = safeXP - currentLevelBaseXP;
  const xpNeededForNextLevel = isMaxLevel ? 0 : nextLevelXP - currentLevelBaseXP;
  const progressPercent = isMaxLevel
    ? 100
    : xpNeededForNextLevel > 0
      ? Math.min(100, Math.max(0, Math.round((xpInCurrentLevel / xpNeededForNextLevel) * 100)))
      : 100;

  return {
    currentLevel,
    totalXP: safeXP,
    currentLevelBaseXP,
    nextLevelXP,
    xpInCurrentLevel,
    xpNeededForNextLevel,
    progressPercent,
    title: getTitleForLevel(currentLevel),
    isMaxLevel
  };
}

// ---------------------------------------------------------------------------
// 2. Streaks, Milestones & Downtime Grace Period (RULE-GAM-001..003, EC-GAM-001)
// ---------------------------------------------------------------------------

export interface StreakMilestone {
  dayCount: number;
  bonusCredits: number;
  bonusXP: number;
  badgeName: string;
}

export const STREAK_MILESTONES: StreakMilestone[] = [
  { dayCount: 7, bonusCredits: 10, bonusXP: 100, badgeName: 'streak_7_days' },
  { dayCount: 30, bonusCredits: 50, bonusXP: 500, badgeName: 'streak_30_days' },
  { dayCount: 90, bonusCredits: 200, bonusXP: 2000, badgeName: 'streak_90_days' }
];

export interface StreakStatus {
  currentStreak: number;
  bestStreak: number;
  lastActivityAt: string | null;
  streakGraceUntil: string | null;
  isActive: boolean;
  isGraceActive: boolean;
  nextMilestone: StreakMilestone | null;
  daysToNextMilestone: number;
  todayCompleted: boolean;
}

/**
 * Checks if a streak remains active considering the UTC midnight window
 * and platform downtime extension (EC-GAM-001).
 */
export function evaluateStreakStatus(
  currentStreak: number,
  bestStreak: number,
  lastActivityISO: string | null,
  streakGraceUntilISO: string | null,
  now: Date = new Date()
): StreakStatus {
  if (!lastActivityISO) {
    return {
      currentStreak: 0,
      bestStreak: Math.max(0, bestStreak),
      lastActivityAt: null,
      streakGraceUntil: null,
      isActive: false,
      isGraceActive: false,
      nextMilestone: STREAK_MILESTONES[0],
      daysToNextMilestone: 7,
      todayCompleted: false
    };
  }

  const lastActivity = new Date(lastActivityISO);
  const nowUTC = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate()));
  const lastActivityUTC = new Date(
    Date.UTC(lastActivity.getUTCFullYear(), lastActivity.getUTCMonth(), lastActivity.getUTCDate())
  );

  const diffDays = Math.floor((nowUTC.getTime() - lastActivityUTC.getTime()) / (1000 * 60 * 60 * 24));
  const todayCompleted = diffDays === 0;

  // Downtime grace period check (EC-GAM-001)
  let isGraceActive = false;
  if (streakGraceUntilISO) {
    const graceUntil = new Date(streakGraceUntilISO);
    if (now.getTime() <= graceUntil.getTime()) {
      isGraceActive = true;
    }
  }

  // Active if today or yesterday (or protected by grace period)
  const isActive = diffDays <= 1 || isGraceActive;
  const effectiveStreak = isActive ? currentStreak : 0;

  // Next milestone calculation
  let nextMilestone: StreakMilestone | null = null;
  for (const m of STREAK_MILESTONES) {
    if (effectiveStreak < m.dayCount) {
      nextMilestone = m;
      break;
    }
  }

  const daysToNextMilestone = nextMilestone ? Math.max(0, nextMilestone.dayCount - effectiveStreak) : 0;

  return {
    currentStreak: effectiveStreak,
    bestStreak: Math.max(effectiveStreak, bestStreak),
    lastActivityAt: lastActivityISO,
    streakGraceUntil: streakGraceUntilISO,
    isActive,
    isGraceActive,
    nextMilestone,
    daysToNextMilestone,
    todayCompleted
  };
}

// ---------------------------------------------------------------------------
// 3. Quests & Community Challenges (EC-GAM-003)
// ---------------------------------------------------------------------------

export type QuestType = 'daily' | 'weekly' | 'monthly' | 'special_event';
export type QuestStatus = 'not_started' | 'in_progress' | 'completed' | 'claimed' | 'expired';

export interface Quest {
  questId: string;
  title: string;
  description: string;
  questType: QuestType;
  targetCount: number;
  currentProgress: number;
  xpReward: number;
  creditReward: number;
  status: QuestStatus;
  expiresAt: string;
}

export interface CommunityChallenge {
  challengeId: string;
  title: string;
  description: string;
  xpReward: number;
  creditReward: number;
  participantCount: number;
  status: 'active' | 'completed' | 'expired' | 'cancelled';
  createdAt: string;
  endsAt: string;
}

/**
 * Checks zero-participant cancellation rule (EC-GAM-003):
 * If a challenge has 0 participants 24 hours after creation, it is automatically cancelled.
 */
export function shouldCancelZeroParticipantChallenge(
  challenge: CommunityChallenge,
  now: Date = new Date()
): boolean {
  if (challenge.status !== 'active') return false;
  if (challenge.participantCount > 0) return false;

  const createdAt = new Date(challenge.createdAt);
  const diffHours = (now.getTime() - createdAt.getTime()) / (1000 * 60 * 60);
  return diffHours >= 24;
}

// ---------------------------------------------------------------------------
// 4. Achievements & Badges (EC-GAM-002)
// ---------------------------------------------------------------------------

export type AchievementRarity = 'common' | 'rare' | 'epic' | 'legendary';

export interface AchievementBadge {
  badgeId: string;
  name: string;
  description: string;
  icon: string;
  rarity: AchievementRarity;
  xpReward: number;
  unlockedAt: string | null;
  isUnlocked: boolean;
  progressPercent: number;
}

export const CANONICAL_ACHIEVEMENTS: AchievementBadge[] = [
  {
    badgeId: 'first_render',
    name: '🌟 Khởi đầu sáng tạo (First Creation)',
    description: 'Tạo và hoàn tất render video AI đầu tiên',
    icon: 'sparkles',
    rarity: 'common',
    xpReward: 50,
    unlockedAt: null,
    isUnlocked: false,
    progressPercent: 0
  },
  {
    badgeId: 'streak_7_days',
    name: '🔥 Vua kiên trì (Consistency King)',
    description: 'Duy trì chuỗi hoạt động 7 ngày liên tục',
    icon: 'flame',
    rarity: 'rare',
    xpReward: 100,
    unlockedAt: null,
    isUnlocked: false,
    progressPercent: 0
  },
  {
    badgeId: 'recipe_creator',
    name: '🍳 Bếp trưởng kịch bản (Master Chef)',
    description: 'Đóng gói và xuất bản một style template / recipe cho cộng đồng',
    icon: 'recipe',
    rarity: 'rare',
    xpReward: 150,
    unlockedAt: null,
    isUnlocked: false,
    progressPercent: 0
  },
  {
    badgeId: 'trend_surfer',
    name: '🌊 Đón đầu xu hướng (Trendsetter)',
    description: 'Ứng dụng thành công 10 video từ Intelligence Trends',
    icon: 'trending-up',
    rarity: 'epic',
    xpReward: 300,
    unlockedAt: null,
    isUnlocked: false,
    progressPercent: 0
  },
  {
    badgeId: 'hundred_club',
    name: '💯 Câu lạc bộ trăm clip (Century Club)',
    description: 'Render thành công 100 video chuẩn thương mại',
    icon: 'award',
    rarity: 'epic',
    xpReward: 500,
    unlockedAt: null,
    isUnlocked: false,
    progressPercent: 0
  },
  {
    badgeId: 'legendary_viral',
    name: '👑 Siêu bão viral (Viral Sensation)',
    description: 'Đạt cấp độ 50 hoặc đạt 1 triệu lượt xem trên nền tảng tích hợp',
    icon: 'crown',
    rarity: 'legendary',
    xpReward: 2500,
    unlockedAt: null,
    isUnlocked: false,
    progressPercent: 0
  }
];

// ---------------------------------------------------------------------------
// 5. Target 2: Reward Event Replay Idempotency
// ---------------------------------------------------------------------------

export interface RewardEvent {
  eventId: string;
  workspaceId: string;
  userId: string;
  sourceType: string;
  sourceId: string;
  creditsEarned: number;
  xpEarned: number;
}

export interface ProcessedRewardResult {
  isDuplicate: boolean;
  creditsAwarded: number;
  xpAwarded: number;
  message: string;
}

/**
 * Pure client validation guaranteeing reward event replay once.
 */
export function evaluateRewardReplay(
  event: RewardEvent,
  processedEventIds: Set<string>
): ProcessedRewardResult {
  if (processedEventIds.has(event.eventId)) {
    return {
      isDuplicate: true,
      creditsAwarded: 0,
      xpAwarded: 0,
      message: `Reward event ${event.eventId} already processed. Replay ignored.`
    };
  }

  return {
    isDuplicate: false,
    creditsAwarded: event.creditsEarned,
    xpAwarded: event.xpEarned,
    message: `Reward event ${event.eventId} successfully deposited.`
  };
}

// ---------------------------------------------------------------------------
// 6. Target 4: Style Template Payload Governance Validation
// ---------------------------------------------------------------------------

export interface StyleTemplateValidationIssue {
  field: string;
  code: string;
  message: string;
}

export interface StyleTemplateValidationResult {
  isValid: boolean;
  issues: StyleTemplateValidationIssue[];
}

export interface StyleTemplatePayload {
  schemaVersion: number;
  templateKind?: string;
  title: string;
  styleSettings: Record<string, unknown>;
  licenseNotice: string;
  description?: string;
  graph?: Record<string, unknown>;
}

const PROHIBITED_MEDIA_PATTERNS = [
  /file:\/\//i,
  /http:\/\/localhost/i,
  /http:\/\/127\.0\.0\.1/i,
  /raw_footage/i,
  /private_media_url/i,
  /unedited_camera_roll/i,
  /X-Amz-Credential/i,
  /AWSAccessKeyId/i
];

const PROHIBITED_BIOMETRIC_PATTERNS = [
  /voice_sample_url/i,
  /voice_clone_embedding/i,
  /biometric_voice_data/i,
  /face_embedding/i,
  /biometric_face_mesh/i,
  /facial_feature_vector/i
];

const PROHIBITED_CREDENTIAL_PATTERNS = [
  /bearer\s+[A-Za-z0-9_\-\.]{15,}/i,
  /api[_\-]?key\s*[:=]\s*['"][A-Za-z0-9_\-]{15,}['"]/i,
  /secret[_\-]?key\s*[:=]\s*['"][A-Za-z0-9_\-]{15,}['"]/i,
  /sk-[A-Za-z0-9]{20,}/i
];

/**
 * Validates style template payload before publishing or sharing.
 * Strictly enforces Target 4:
 * - Rejects private source media URLs or raw footage references
 * - Rejects voice clone / face biometric embeddings
 * - Rejects private API keys, secrets or Bearer tokens
 * - Requires schemaVersion >= 1
 * - Requires non-empty license notice and style settings
 */
export function validateStyleTemplatePayload(payload: StyleTemplatePayload): StyleTemplateValidationResult {
  const issues: StyleTemplateValidationIssue[] = [];

  if (payload.schemaVersion < 1) {
    issues.push({
      field: 'schemaVersion',
      code: 'SCHEMA_VERSION_INVALID',
      message: 'schemaVersion must be >= 1 per database_schema.md §27.4'
    });
  }

  if (!payload.licenseNotice || !payload.licenseNotice.trim()) {
    issues.push({
      field: 'licenseNotice',
      code: 'LICENSE_NOTICE_EMPTY',
      message: 'Shared style template must declare an explicit community or commercial license notice'
    });
  }

  if (!payload.styleSettings || Object.keys(payload.styleSettings).length === 0) {
    issues.push({
      field: 'styleSettings',
      code: 'STYLE_SETTINGS_MISSING',
      message: 'Style template must declare parametric style settings (color grade, pacing, typography, etc.)'
    });
  }

  // Deep scan serialized payload for prohibited patterns
  const serialized = JSON.stringify(payload);

  for (const pattern of PROHIBITED_MEDIA_PATTERNS) {
    if (pattern.test(serialized)) {
      issues.push({
        field: 'styleSettings',
        code: 'PRIVATE_MEDIA_FORBIDDEN',
        message: 'Shared style templates must NOT contain private media URLs, local paths, or raw camera footage'
      });
      break;
    }
  }

  for (const pattern of PROHIBITED_BIOMETRIC_PATTERNS) {
    if (pattern.test(serialized)) {
      issues.push({
        field: 'styleSettings',
        code: 'BIOMETRICS_FORBIDDEN',
        message: 'Shared style templates must NOT contain face embeddings, voice clone samples, or biometric data'
      });
      break;
    }
  }

  for (const pattern of PROHIBITED_CREDENTIAL_PATTERNS) {
    if (pattern.test(serialized)) {
      issues.push({
        field: 'styleSettings',
        code: 'CREDENTIALS_FORBIDDEN',
        message: 'Shared style templates must NOT contain hardcoded API tokens or secret credentials'
      });
      break;
    }
  }

  return {
    isValid: issues.length === 0,
    issues
  };
}

// ---------------------------------------------------------------------------
// 7. Target 3: Licensed Template Install Cloner
// ---------------------------------------------------------------------------

export interface InstalledStylePackResult {
  clonedPackId: string;
  destinationWorkspaceId: string;
  stylePackName: string;
  clonedStyleSettings: Record<string, unknown>;
  immutableInstallAudit: {
    recipeId: string;
    templateVersion: number;
    installedAt: string;
    destinationWorkspaceId: string;
  };
}

/**
 * Simulates client-side verification for Target 3:
 * Licensed template install clones tenant-owned continuity style pack
 * without exposing source-tenant internal IDs.
 */
export function cloneStyleTemplateToTenant(
  authorRecipeId: string,
  templateVersion: number,
  sourceSettings: Record<string, unknown>,
  destinationWorkspaceId: string,
  packName: string
): InstalledStylePackResult {
  const clonedPackId = `sp-cloned-${Date.now().toString(36)}-${Math.random().toString(36).substring(2, 6)}`;

  return {
    clonedPackId,
    destinationWorkspaceId,
    stylePackName: packName || 'Cloned Style Pack',
    clonedStyleSettings: JSON.parse(JSON.stringify(sourceSettings)),
    immutableInstallAudit: {
      recipeId: authorRecipeId,
      templateVersion,
      installedAt: new Date().toISOString(),
      destinationWorkspaceId
    }
  };
}
