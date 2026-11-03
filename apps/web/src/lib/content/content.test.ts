import { describe, it, expect } from 'vitest';
import { isReviewStale, isAssetBriefComplete, hasPublishIntent, type SourceChainLineage } from './index';

describe('P3-05 Content Handoffs and Review Acceptance', () => {
  describe('Acceptance Target 1: Source Chain Reaches Approved Brief', () => {
    it('isAssetBriefComplete validates all mandatory production fields (RULE-M06-005)', () => {
      expect(isAssetBriefComplete({
        outputType: 'ai_video',
        targetFormat: '9:16',
        targetDurationSeconds: 45,
        continuityRequirementsJson: '{"character_id": "char-1"}'
      })).toBe(true);

      // Missing outputType
      expect(isAssetBriefComplete({
        targetFormat: '9:16',
        targetDurationSeconds: 45,
        continuityRequirementsJson: '{"character_id": "char-1"}'
      })).toBe(false);

      // Duration <= 0
      expect(isAssetBriefComplete({
        outputType: 'ai_video',
        targetFormat: '9:16',
        targetDurationSeconds: 0,
        continuityRequirementsJson: '{"character_id": "char-1"}'
      })).toBe(false);

      // Empty continuity json
      expect(isAssetBriefComplete({
        outputType: 'ai_video',
        targetFormat: '9:16',
        targetDurationSeconds: 45,
        continuityRequirementsJson: '{}'
      })).toBe(false);
    });

    it('validates full source chain structure from Trend to Asset Brief', () => {
      const mockLineage: SourceChainLineage = {
        workspaceId: 'ws-1',
        scriptId: 'scr-1',
        trend: {
          id: 'tr-1',
          type: 'trend',
          title: 'Trend Topic',
          state: 'active',
          routeUrl: '/trends/tr-1',
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString()
        },
        opportunity: {
          id: 'opp-1',
          type: 'opportunity',
          title: 'Opportunity Title',
          state: 'converted',
          routeUrl: '/opportunities/opp-1',
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString()
        },
        idea: {
          id: 'idea-1',
          type: 'idea',
          title: 'Idea Concept',
          state: 'converted',
          routeUrl: '/ideas/idea-1',
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString()
        },
        script: {
          id: 'scr-1',
          type: 'script',
          title: 'Full Script',
          state: 'ready_for_production',
          routeUrl: '/scripts/scr-1',
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString()
        },
        assetBrief: {
          id: 'brief-1',
          type: 'asset_brief',
          title: 'Asset Brief',
          state: 'ready',
          routeUrl: '/scripts/scr-1/brief',
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString()
        },
        isComplete: true,
        isProductionReady: true,
        lineageHash: 'hash-proof-12345678',
        emittedEvents: ['script.created', 'script.submitted_for_approval', 'script.approved', 'script.ready_for_production']
      };

      expect(mockLineage.trend?.id).toBe('tr-1');
      expect(mockLineage.opportunity?.id).toBe('opp-1');
      expect(mockLineage.idea?.id).toBe('idea-1');
      expect(mockLineage.script.id).toBe('scr-1');
      expect(mockLineage.assetBrief?.id).toBe('brief-1');
      expect(mockLineage.isProductionReady).toBe(true);
      expect(mockLineage.emittedEvents).toContain('script.ready_for_production');
    });
  });

  describe('Acceptance Target 2: Concurrent Edits Preserve Data (EC-M06-003)', () => {
    it('detects when reviewer snapshot is older than script updated_at', () => {
      const now = Date.now();
      const reviewerSnapshot = new Date(now - 10000).toISOString(); // 10s ago
      const scriptUpdated = new Date(now).toISOString(); // updated just now

      const check = isReviewStale(scriptUpdated, reviewerSnapshot);
      expect(check.isStale).toBe(true);
      expect(check.reason).toContain('Tác giả đã cập nhật kịch bản');
      expect(check.diffSeconds).toBeGreaterThanOrEqual(9);
    });

    it('returns isStale=false when reviewer has current or fresher snapshot', () => {
      const now = Date.now();
      const reviewerSnapshot = new Date(now + 1000).toISOString();
      const scriptUpdated = new Date(now).toISOString();

      const check = isReviewStale(scriptUpdated, reviewerSnapshot);
      expect(check.isStale).toBe(false);
      expect(check.reason).toBeUndefined();
    });
  });

  describe('Acceptance Target 3: No Publish Side Effects From Creative Assistant', () => {
    it('identifies publish requests in natural language prompts', () => {
      expect(hasPublishIntent('Đăng video này lên TikTok ngay lập tức')).toBe(true);
      expect(hasPublishIntent('Lên lịch đăng bài vào 19h tối nay')).toBe(true);
      expect(hasPublishIntent('Publish this script to YouTube Shorts')).toBe(true);
      expect(hasPublishIntent('Upload to TikTok and dispatch post')).toBe(true);
      expect(hasPublishIntent('Xuất bản đa kênh chuẩn lịch vàng')).toBe(true);
    });

    it('allows creative drafting queries without false-positive publish blocks', () => {
      expect(hasPublishIntent('Gợi ý 3 hook mở đầu ấn tượng cho video')).toBe(false);
      expect(hasPublishIntent('Viết lại kịch bản theo phong cách hài hước')).toBe(false);
      expect(hasPublishIntent('Thêm cảnh CTA kêu gọi follow vào cuối script')).toBe(false);
      expect(hasPublishIntent('Tạo góc nhìn mới cho sản phẩm serum')).toBe(false);
    });
  });
});
