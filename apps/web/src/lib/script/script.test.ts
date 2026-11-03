import { describe, it, expect } from 'vitest';
import {
  validateScenesForSubmission,
  validateRejectionReason,
  isAssetBriefComplete,
  isReadyForProductionEligible,
  isReviewStale,
  calculateTotalDuration,
  calculateWordCount,
  suggestDisclosureForHooks,
  type Script,
  type Scene,
  type AssetBrief
} from './index';

describe('M06 Script Lab Business Rules & Acceptance Targets', () => {
  // Acceptance Target 1: Stale approval detection (EC-M06-003)
  describe('Acceptance Target 1: Stale approval fails (EC-M06-003)', () => {
    it('detects stale review when current version differs from reviewer expected version', () => {
      expect(isReviewStale(2, 1)).toBe(true);
      expect(isReviewStale(3, 2)).toBe(true);
      expect(isReviewStale(2, 2)).toBe(false);
      expect(isReviewStale(1, 1)).toBe(false);
    });

    it('does not flag staleness when expected version is not set', () => {
      expect(isReviewStale(2, 0)).toBe(false);
    });
  });

  // Acceptance Target 2: Rejection reason validated (RULE-M06-002, EC-M06-002)
  describe('Acceptance Target 2: Rejection reason validated (RULE-M06-002, EC-M06-002)', () => {
    it('rejects feedback with fewer than 10 characters', () => {
      const shortReasons = ['', 'bad', 'fix it', '   ', '123456789'];
      for (const reason of shortReasons) {
        const result = validateRejectionReason(reason);
        expect(result.valid).toBe(false);
        expect(result.error).toContain('ít nhất 10 ký tự');
      }
    });

    it('accepts feedback with 10 or more characters', () => {
      const validReason = 'Mở đầu quá chậm, cần cắt bớt 3 giây đầu.';
      const result = validateRejectionReason(validReason);
      expect(result.valid).toBe(true);
      expect(result.characterCount).toBeGreaterThanOrEqual(10);
      expect(result.error).toBeUndefined();
    });
  });

  // Acceptance Target 3: Ready-for-production requires approval and complete brief
  // (RULE-M06-005, RULE-M06-006, AC-2)
  describe('Acceptance Target 3: Ready-for-production requires approval and complete brief', () => {
    const baseScript: Script = {
      scriptId: 'scr-1',
      workspaceId: 'ws-1',
      title: 'Serum Video Ad',
      formatType: '9:16 vertical short',
      scenes: [],
      ctaBlocks: [],
      disclosureBlocks: [],
      durationTargetSeconds: 30,
      lifecycleState: 'draft',
      approvalState: 'not_submitted',
      publishTargetProfiles: [],
      continuityRefs: [],
      offerProductHooks: [],
      versionIndex: 1,
      createdBy: 'user-1',
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    };

    const completeBrief: AssetBrief = {
      assetBriefId: 'brief-1',
      workspaceId: 'ws-1',
      scriptId: 'scr-1',
      outputType: 'video',
      targetFormat: '9:16 vertical short',
      targetDurationSeconds: 30,
      targetPlatforms: ['tiktok', 'reels'],
      continuityRequirementsJson: '{"lighting": "natural", "model": "female 20s"}',
      brandVoiceRequirementsJson: '{"tone": "confident, friendly"}',
      productionInstructions: 'Capture close-up application texture.',
      status: 'ready',
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    };

    it('validates complete asset brief correctly', () => {
      expect(isAssetBriefComplete(completeBrief)).toBe(true);

      // Incomplete cases
      expect(isAssetBriefComplete(null)).toBe(false);
      expect(isAssetBriefComplete({ ...completeBrief, outputType: '' })).toBe(false);
      expect(isAssetBriefComplete({ ...completeBrief, targetFormat: '  ' })).toBe(false);
      expect(isAssetBriefComplete({ ...completeBrief, targetDurationSeconds: 0 })).toBe(false);
      expect(isAssetBriefComplete({ ...completeBrief, continuityRequirementsJson: '{}' })).toBe(false);
      expect(isAssetBriefComplete({ ...completeBrief, continuityRequirementsJson: '' })).toBe(false);
    });

    it('denies ready_for_production if script is not approved', () => {
      const unapprovedScript: Script = {
        ...baseScript,
        approvalState: 'pending_approval'
      };
      const result = isReadyForProductionEligible(unapprovedScript, completeBrief);
      expect(result.eligible).toBe(false);
      expect(result.reasons.some((r) => r.includes('chưa được người quản lý duyệt'))).toBe(true);
    });

    it('denies ready_for_production if brief is missing or incomplete', () => {
      const approvedScript: Script = {
        ...baseScript,
        approvalState: 'approved',
        lifecycleState: 'approved'
      };

      const resultMissing = isReadyForProductionEligible(approvedScript, null);
      expect(resultMissing.eligible).toBe(false);
      expect(resultMissing.reasons.some((r) => r.includes('Chưa tạo'))).toBe(true);

      const incompleteBrief = { ...completeBrief, continuityRequirementsJson: '{}' };
      const resultIncomplete = isReadyForProductionEligible(approvedScript, incompleteBrief);
      expect(resultIncomplete.eligible).toBe(false);
      expect(resultIncomplete.reasons.some((r) => r.includes('chưa hoàn chỉnh'))).toBe(true);
    });

    it('allows ready_for_production when both approved and complete brief exist', () => {
      const approvedScript: Script = {
        ...baseScript,
        approvalState: 'approved',
        lifecycleState: 'approved'
      };
      const result = isReadyForProductionEligible(approvedScript, completeBrief);
      expect(result.eligible).toBe(true);
      expect(result.reasons).toHaveLength(0);
    });
  });

  // Empty scenes block submission (EC-M06-001)
  describe('EC-M06-001: Empty scenes block submission', () => {
    it('fails when scenes array is empty', () => {
      const result = validateScenesForSubmission([]);
      expect(result.valid).toBe(false);
      expect(result.error).toContain('ít nhất 1 phân cảnh');
    });

    it('fails when any scene has empty or whitespace-only content', () => {
      const scenes: Scene[] = [
        {
          sceneId: 'sc-1',
          scriptId: 'scr-1',
          workspaceId: 'ws-1',
          sceneIndex: 0,
          description: 'Opening',
          content: 'Hook: Do not scroll past this.',
          durationSeconds: 5,
          visualNotes: '',
          audioNotes: '',
          shotList: [],
          createdAt: ''
        },
        {
          sceneId: 'sc-2',
          scriptId: 'scr-1',
          workspaceId: 'ws-1',
          sceneIndex: 1,
          description: 'Problem',
          content: '   ', // whitespace only
          durationSeconds: 10,
          visualNotes: '',
          audioNotes: '',
          shotList: [],
          createdAt: ''
        }
      ];
      const result = validateScenesForSubmission(scenes);
      expect(result.valid).toBe(false);
      expect(result.error).toContain('Phân cảnh #2 chưa có nội dung');
    });

    it('succeeds when all scenes have non-empty content', () => {
      const scenes: Scene[] = [
        {
          sceneId: 'sc-1',
          scriptId: 'scr-1',
          workspaceId: 'ws-1',
          sceneIndex: 0,
          description: 'Opening',
          content: 'Hook: Do not scroll past this.',
          durationSeconds: 5,
          visualNotes: '',
          audioNotes: '',
          shotList: [],
          createdAt: ''
        }
      ];
      const result = validateScenesForSubmission(scenes);
      expect(result.valid).toBe(true);
      expect(result.error).toBeUndefined();
    });
  });

  // Disclosure auto-suggestion (RULE-M06-007)
  describe('RULE-M06-007: Commercial Offer Hooks Auto-Disclosure', () => {
    it('suggests disclosure when offer hooks are present', () => {
      const disc = suggestDisclosureForHooks(['hook-promo-20']);
      expect(disc).not.toBeNull();
      expect(disc?.text).toContain('tài trợ');
      expect(disc?.isDismissed).toBe(false);
    });

    it('returns null when no offer hooks exist', () => {
      expect(suggestDisclosureForHooks([])).toBeNull();
    });
  });

  // Calculations
  describe('Duration and Word Count Metrics', () => {
    const scenes: Scene[] = [
      {
        sceneId: 'sc-1',
        scriptId: 'scr-1',
        workspaceId: 'ws-1',
        sceneIndex: 0,
        description: 'Hook',
        content: 'Hello everyone today we review something special',
        durationSeconds: 6,
        visualNotes: '',
        audioNotes: '',
        shotList: [],
        createdAt: ''
      },
      {
        sceneId: 'sc-2',
        scriptId: 'scr-1',
        workspaceId: 'ws-1',
        sceneIndex: 1,
        description: 'Body',
        content: 'It works amazingly well on sensitive skin',
        durationSeconds: 14,
        visualNotes: '',
        audioNotes: '',
        shotList: [],
        createdAt: ''
      }
    ];

    it('calculates total duration in seconds', () => {
      expect(calculateTotalDuration(scenes)).toBe(20);
    });

    it('calculates total words count across scenes', () => {
      // 7 words in sc-1 + 7 words in sc-2 = 14 words
      expect(calculateWordCount(scenes)).toBe(14);
    });
  });
});
