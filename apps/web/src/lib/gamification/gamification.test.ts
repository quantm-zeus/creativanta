import { describe, it, expect } from 'vitest';
import {
  calculateLevelProgress,
  getXPForLevel,
  getTitleForLevel,
  evaluateStreakStatus,
  STREAK_MILESTONES,
  shouldCancelZeroParticipantChallenge,
  CANONICAL_ACHIEVEMENTS,
  evaluateRewardReplay,
  validateStyleTemplatePayload,
  cloneStyleTemplateToTenant,
  type CommunityChallenge,
  type RewardEvent,
  type StyleTemplatePayload
} from './index';

describe('P8-06: Gamification and Style-Template Sharing', () => {
  // -------------------------------------------------------------------------
  // Acceptance Target 1: Per-user progress (Levels 1–50, XP, Titles)
  // -------------------------------------------------------------------------
  describe('Acceptance Target 1: Per-User Progress & Level Thresholds (EF-11)', () => {
    it('matches exact canonical milestone XP thresholds', () => {
      expect(getXPForLevel(1)).toBe(0);
      expect(getXPForLevel(5)).toBe(100);
      expect(getXPForLevel(10)).toBe(500);
      expect(getXPForLevel(20)).toBe(2000);
      expect(getXPForLevel(50)).toBe(25000);
    });

    it('calculates correct level and progress for fresh creator (0 XP)', () => {
      const progress = calculateLevelProgress(0);
      expect(progress.currentLevel).toBe(1);
      expect(progress.totalXP).toBe(0);
      expect(progress.progressPercent).toBe(0);
      expect(progress.title).toBe('Tập sự (Novice Creator)');
      expect(progress.isMaxLevel).toBe(false);
    });

    it('calculates intermediate level progression (Level 12 Content Pro)', () => {
      // Level 10: 500 XP, Level 11: 650 XP, Level 12: 800 XP, Level 13: 950 XP
      const progress = calculateLevelProgress(875);
      expect(progress.currentLevel).toBe(12);
      expect(progress.title).toBe('Content Pro');
      expect(progress.currentLevelBaseXP).toBe(800);
      expect(progress.nextLevelXP).toBe(950);
      expect(progress.xpInCurrentLevel).toBe(75);
      expect(progress.xpNeededForNextLevel).toBe(150);
      expect(progress.progressPercent).toBe(50);
    });

    it('handles Level 50 max level without overflowing percentage', () => {
      const progress = calculateLevelProgress(30000);
      expect(progress.currentLevel).toBe(50);
      expect(progress.progressPercent).toBe(100);
      expect(progress.title).toBe('Huyền thoại sáng tạo (Creative Legend)');
      expect(progress.isMaxLevel).toBe(true);
      expect(progress.xpNeededForNextLevel).toBe(0);
    });
  });

  // -------------------------------------------------------------------------
  // Acceptance Target 2: Reward event replay once
  // -------------------------------------------------------------------------
  describe('Acceptance Target 2: Reward Event Replay Once (RULE-GAM-006)', () => {
    it('deposits reward on first occurrence and ignores duplicate replayed event', () => {
      const processedEventIds = new Set<string>();

      const event: RewardEvent = {
        eventId: 'evt-reward-daily-01',
        workspaceId: 'ws-creator-01',
        userId: 'user-01',
        sourceType: 'streak_milestone_7',
        sourceId: 'streak-7',
        creditsEarned: 10,
        xpEarned: 100
      };

      // First time processing
      const firstResult = evaluateRewardReplay(event, processedEventIds);
      expect(firstResult.isDuplicate).toBe(false);
      expect(firstResult.creditsAwarded).toBe(10);
      expect(firstResult.xpAwarded).toBe(100);
      processedEventIds.add(event.eventId);

      // Duplicate delivery / webhook replay
      const replayResult = evaluateRewardReplay(event, processedEventIds);
      expect(replayResult.isDuplicate).toBe(true);
      expect(replayResult.creditsAwarded).toBe(0);
      expect(replayResult.xpAwarded).toBe(0);
      expect(replayResult.message).toContain('already processed');
    });
  });

  // -------------------------------------------------------------------------
  // Acceptance Target 3: Licensed template install clones tenant-owned pack
  // -------------------------------------------------------------------------
  describe('Acceptance Target 3: Licensed Template Install Clones Tenant-Owned Pack', () => {
    it('clones style template into tenant-owned pack with immutable audit and no source-tenant IDs', () => {
      const authorRecipeId = 'rec-cinematic-style-01';
      const templateVersion = 2;
      const sourceSettings = {
        color_grade: 'teal_orange_film',
        pacing: 'dynamic_cut_120bpm',
        text_overlay: 'clean_sans'
      };
      const buyerWorkspace = 'ws-buyer-studio';

      const cloned = cloneStyleTemplateToTenant(
        authorRecipeId,
        templateVersion,
        sourceSettings,
        buyerWorkspace,
        'Imported Cinematic Vlog'
      );

      // Cloned pack must belong to buyer workspace
      expect(cloned.destinationWorkspaceId).toBe(buyerWorkspace);
      expect(cloned.clonedPackId).toMatch(/^sp-cloned-/);
      expect(cloned.clonedStyleSettings).toEqual(sourceSettings);

      // Immutable install audit must reference recipe identity and version
      expect(cloned.immutableInstallAudit.recipeId).toBe(authorRecipeId);
      expect(cloned.immutableInstallAudit.templateVersion).toBe(templateVersion);
      expect(cloned.immutableInstallAudit.destinationWorkspaceId).toBe(buyerWorkspace);

      // Verify no leak of author internal workspace ID
      expect(JSON.stringify(cloned.immutableInstallAudit)).not.toContain('authorWorkspaceId');
    });
  });

  // -------------------------------------------------------------------------
  // Acceptance Target 4: No private source media in shared style template
  // -------------------------------------------------------------------------
  describe('Acceptance Target 4: No Private Source Media in Shared Style Template', () => {
    const validCleanPayload: StyleTemplatePayload = {
      schemaVersion: 1,
      title: 'Neon Cyberpunk Style Pack',
      licenseNotice: 'Creativanta Community Style License v1.0',
      styleSettings: {
        color_grade: 'neon_cyan_magenta_high_contrast',
        transitions: 'glitch_whip_pan',
        pacing: 'fast_cut_120bpm',
        caption_font: 'orbitron_bold'
      }
    };

    it('approves clean style template with parameterised settings', () => {
      const res = validateStyleTemplatePayload(validCleanPayload);
      expect(res.isValid).toBe(true);
      expect(res.issues).toHaveLength(0);
    });

    it('rejects private media URL and local file paths', () => {
      const payload: StyleTemplatePayload = {
        ...validCleanPayload,
        styleSettings: {
          ...validCleanPayload.styleSettings,
          sample_source: 'file:///var/data/private_renders/my_raw_footage.mp4'
        }
      };
      const res = validateStyleTemplatePayload(payload);
      expect(res.isValid).toBe(false);
      expect(res.issues.some((i) => i.code === 'PRIVATE_MEDIA_FORBIDDEN')).toBe(true);
    });

    it('rejects raw footage keywords in style parameters', () => {
      const payload: StyleTemplatePayload = {
        ...validCleanPayload,
        styleSettings: {
          ...validCleanPayload.styleSettings,
          clip_reference: 'https://cdn.example.com/assets/raw_footage_clip01.mov'
        }
      };
      const res = validateStyleTemplatePayload(payload);
      expect(res.isValid).toBe(false);
      expect(res.issues.some((i) => i.code === 'PRIVATE_MEDIA_FORBIDDEN')).toBe(true);
    });

    it('rejects presigned AWS credentials in template payload', () => {
      const payload: StyleTemplatePayload = {
        ...validCleanPayload,
        styleSettings: {
          ...validCleanPayload.styleSettings,
          thumbnail: 'https://s3.amazonaws.com/bucket/thumb.jpg?X-Amz-Credential=AKIAIOSFODNN7EXAMPLE'
        }
      };
      const res = validateStyleTemplatePayload(payload);
      expect(res.isValid).toBe(false);
      expect(res.issues.some((i) => i.code === 'PRIVATE_MEDIA_FORBIDDEN')).toBe(true);
    });

    it('rejects voice sample and voice clone biometrics', () => {
      const payload: StyleTemplatePayload = {
        ...validCleanPayload,
        styleSettings: {
          ...validCleanPayload.styleSettings,
          voice_clone_embedding: [0.12, 0.85, 0.44, 0.99]
        }
      };
      const res = validateStyleTemplatePayload(payload);
      expect(res.isValid).toBe(false);
      expect(res.issues.some((i) => i.code === 'BIOMETRICS_FORBIDDEN')).toBe(true);
    });

    it('rejects face mesh / facial feature biometric embeddings', () => {
      const payload: StyleTemplatePayload = {
        ...validCleanPayload,
        styleSettings: {
          ...validCleanPayload.styleSettings,
          face_embedding: 'vector-face-data-xyz'
        }
      };
      const res = validateStyleTemplatePayload(payload);
      expect(res.isValid).toBe(false);
      expect(res.issues.some((i) => i.code === 'BIOMETRICS_FORBIDDEN')).toBe(true);
    });

    it('rejects API keys and Bearer authentication credentials', () => {
      const payload: StyleTemplatePayload = {
        ...validCleanPayload,
        styleSettings: {
          ...validCleanPayload.styleSettings,
          auth: 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.credentials'
        }
      };
      const res = validateStyleTemplatePayload(payload);
      expect(res.isValid).toBe(false);
      expect(res.issues.some((i) => i.code === 'CREDENTIALS_FORBIDDEN')).toBe(true);
    });

    it('rejects empty license notice', () => {
      const payload: StyleTemplatePayload = {
        ...validCleanPayload,
        licenseNotice: '   '
      };
      const res = validateStyleTemplatePayload(payload);
      expect(res.isValid).toBe(false);
      expect(res.issues.some((i) => i.code === 'LICENSE_NOTICE_EMPTY')).toBe(true);
    });
  });

  // -------------------------------------------------------------------------
  // Streaks, Downtime Grace Period, Challenges, Achievements
  // -------------------------------------------------------------------------
  describe('Streak Progression & Downtime Grace Period (RULE-GAM-001..003, EC-GAM-001)', () => {
    it('maintains active streak when activity happened today', () => {
      const now = new Date('2026-11-04T15:00:00Z');
      const lastActivity = '2026-11-04T08:30:00Z';
      const status = evaluateStreakStatus(6, 12, lastActivity, null, now);

      expect(status.isActive).toBe(true);
      expect(status.todayCompleted).toBe(true);
      expect(status.currentStreak).toBe(6);
      expect(status.nextMilestone?.dayCount).toBe(7);
      expect(status.daysToNextMilestone).toBe(1);
    });

    it('protects broken streak using downtime grace period (EC-GAM-001)', () => {
      const now = new Date('2026-11-04T15:00:00Z');
      // Last activity 3 days ago (would be broken normally)
      const lastActivity = '2026-11-01T10:00:00Z';
      // Grace period active until 2026-11-05
      const graceUntil = '2026-11-05T00:00:00Z';

      const status = evaluateStreakStatus(14, 21, lastActivity, graceUntil, now);
      expect(status.isActive).toBe(true);
      expect(status.isGraceActive).toBe(true);
      expect(status.currentStreak).toBe(14);
    });
  });

  describe('Zero-Participant Challenge Cancellation (EC-GAM-003)', () => {
    it('cancels challenge if 0 participants after 24 hours', () => {
      const now = new Date('2026-11-04T12:00:00Z');
      const challenge: CommunityChallenge = {
        challengeId: 'ch-zero-part',
        title: 'Empty Challenge',
        description: 'No one joined',
        xpReward: 200,
        creditReward: 25,
        participantCount: 0,
        status: 'active',
        createdAt: '2026-11-03T10:00:00Z', // 26 hours ago
        endsAt: '2026-11-10T00:00:00Z'
      };

      expect(shouldCancelZeroParticipantChallenge(challenge, now)).toBe(true);
    });

    it('does not cancel challenge if participants joined or under 24 hours', () => {
      const now = new Date('2026-11-04T12:00:00Z');
      const challengeWithUsers: CommunityChallenge = {
        challengeId: 'ch-popular',
        title: 'Popular Challenge',
        description: 'Creators joining',
        xpReward: 200,
        creditReward: 25,
        participantCount: 8,
        status: 'active',
        createdAt: '2026-11-03T10:00:00Z',
        endsAt: '2026-11-10T00:00:00Z'
      };

      expect(shouldCancelZeroParticipantChallenge(challengeWithUsers, now)).toBe(false);
    });
  });
});
