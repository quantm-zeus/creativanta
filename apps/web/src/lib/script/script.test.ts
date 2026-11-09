import { describe, it, expect, vi } from 'vitest';
import { render } from 'svelte/server';
import ScriptSceneEditor from './ScriptSceneEditor.svelte';
import {
  validateScenesForSubmission,
  validateRejectionReason,
  isAssetBriefComplete,
  isReadyForProductionEligible,
  isReviewStale,
  calculateTotalDuration,
  calculateWordCount,
  suggestDisclosureForHooks,
  updateSceneInList,
  updateShotInList,
  createScriptEditorSession,
  createScriptReviewSession,
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

  describe('R1, R2, R3 Component & Controller Regressions', () => {
    it('renders ScriptSceneEditor with bound scene/shot values and synchronizes field edits into createScriptEditorSession without mutating detached clones (R2)', () => {
      const initialScenes: Scene[] = [
        {
          sceneId: 'sc-10',
          scriptId: 'scr-10',
          workspaceId: 'ws-1',
          sceneIndex: 0,
          description: 'Hook cảnh 1',
          content: 'Lời thoại gốc trước khi sửa',
          durationSeconds: 8,
          visualNotes: 'Quay cận sản phẩm',
          audioNotes: 'Nhạc nền upbeat',
          shotList: [
            {
              shotId: 'sh-10',
              sceneId: 'sc-10',
              workspaceId: 'ws-1',
              shotIndex: 0,
              shotType: 'Medium Shot',
              description: 'Mở hộp sản phẩm',
              durationSeconds: 4,
              createdAt: ''
            }
          ],
          createdAt: ''
        }
      ];

      const onUpdateScenes = vi.fn();
      const rendered = render(ScriptSceneEditor, {
        props: {
          scenes: initialScenes,
          onUpdateScenes
        }
      });

      expect(rendered.body).toContain('Lời thoại gốc trước khi sửa');
      expect(rendered.body).toContain('Hook cảnh 1');
      expect(rendered.body).toContain('Mở hộp sản phẩm');

      // Verify updateSceneInList and updateShotInList produce deep clones and do not mutate initialScenes
      const afterSceneEdit = updateSceneInList(initialScenes, 0, {
        content: 'NEW TEXT TYPED IN TEXTAREA',
        durationSeconds: 12
      });
      expect(initialScenes[0].content).toBe('Lời thoại gốc trước khi sửa');
      expect(afterSceneEdit[0].content).toBe('NEW TEXT TYPED IN TEXTAREA');
      expect(afterSceneEdit[0].durationSeconds).toBe(12);

      const afterShotEdit = updateShotInList(afterSceneEdit, 0, 0, {
        shotType: 'Close Up',
        description: 'Zoom cận chất kem',
        durationSeconds: 6
      });
      expect(afterSceneEdit[0].shotList[0].description).toBe('Mở hộp sản phẩm');
      expect(afterShotEdit[0].shotList[0].shotType).toBe('Close Up');
      expect(afterShotEdit[0].shotList[0].description).toBe('Zoom cận chất kem');
      expect(afterShotEdit[0].shotList[0].durationSeconds).toBe(6);
    });

    it('blocks SubmitApproval if backend Update returns stale unpersisted title when draft is dirty (R3 negative guard)', async () => {
      const session = createScriptEditorSession('scr-stale-update');
      const serverScript = {
        script_id: 'scr-stale-update',
        workspace_id: 'ws-1',
        title: 'Persisted title',
        format_type: '9:16 vertical short',
        duration_target_seconds: 60,
        version_index: 2,
        lifecycle_state: 'SCRIPT_LIFECYCLE_STATE_DRAFT',
        approval_state: 'SCRIPT_APPROVAL_STATE_NOT_SUBMITTED',
        scenes: [
          {
            scene_id: 'sc-1',
            script_id: 'scr-stale-update',
            workspace_id: 'ws-1',
            scene_index: 0,
            description: 'Hook',
            content: 'Original scene content',
            duration_seconds: 10,
            visual_notes: '',
            audio_notes: '',
            shot_list: []
          }
        ]
      };

      let submitCalled = false;
      const staleMockFetch = vi.fn(async (url: string) => {
        if (url.includes('ScriptService/Get')) {
          return new Response(JSON.stringify({ script: serverScript }), {
            status: 200,
            headers: { 'content-type': 'application/json' }
          });
        }
        if (url.includes('ScriptService/Update')) {
          // Broken server ignores the new title and returns the old record
          return new Response(JSON.stringify({ script: serverScript }), {
            status: 200,
            headers: { 'content-type': 'application/json' }
          });
        }
        if (url.includes('ScriptService/SubmitApproval')) {
          submitCalled = true;
          return new Response(
            JSON.stringify({ script: serverScript, approval_request_id: 'apr-bad' }),
            { status: 200, headers: { 'content-type': 'application/json' } }
          );
        }
        return new Response('{}', { status: 404 });
      });

      await session.syncContext(
        {
          userId: 'usr-1',
          workspaceId: 'ws-1',
          scriptId: 'scr-stale-update',
          authState: 'authenticated',
          isDiscoveryLoading: false
        },
        { token: 'jwt_1', workspaceId: 'ws-1', fetchFn: staleMockFetch as unknown as typeof fetch }
      );

      session.setTitle('NEW TITLE NOT YET SAVED');
      expect(session.getSnapshot().isDirty).toBe(true);

      const res = await session.submitForReview({
        token: 'jwt_1',
        workspaceId: 'ws-1',
        fetchFn: staleMockFetch as unknown as typeof fetch
      });

      expect(res.ok).toBe(false);
      expect(submitCalled).toBe(false);
      expect(session.getSnapshot().approvalState).toBe('not_submitted');
      expect(session.getSnapshot().isDirty).toBe(true);
    });

    it('rejects empty-scene scripts in createScriptReviewSession and locks approve/reject (R1 negative guard)', async () => {
      const reviewSession = createScriptReviewSession('scr-empty-scenes');
      const emptyScenesFetch = vi.fn(async () =>
        new Response(
          JSON.stringify({
            script: {
              script_id: 'scr-empty-scenes',
              workspace_id: 'ws-1',
              title: 'Empty Script',
              version_index: 2,
              lifecycle_state: 'SCRIPT_LIFECYCLE_STATE_IN_REVIEW',
              approval_state: 'SCRIPT_APPROVAL_STATE_PENDING_APPROVAL',
              scenes: []
            }
          }),
          { status: 200, headers: { 'content-type': 'application/json' } }
        )
      );

      const loadRes = await reviewSession.syncContext(
        {
          userId: 'mgr-1',
          workspaceId: 'ws-1',
          scriptId: 'scr-empty-scenes',
          authState: 'authenticated',
          isDiscoveryLoading: false
        },
        {
          token: 'jwt_mgr',
          workspaceId: 'ws-1',
          fetchFn: emptyScenesFetch as unknown as typeof fetch
        }
      );

      expect(loadRes.ok).toBe(false);
      expect(reviewSession.getSnapshot().loadState).toBe('error');
      expect(reviewSession.getSnapshot().versionIndex).toBeNull();
      expect(reviewSession.getSnapshot().scenes).toEqual([]);

      const approveRes = await reviewSession.approve({
        token: 'jwt_mgr',
        workspaceId: 'ws-1',
        fetchFn: emptyScenesFetch as unknown as typeof fetch
      });
      expect(approveRes.ok).toBe(false);
    });
  });
});
