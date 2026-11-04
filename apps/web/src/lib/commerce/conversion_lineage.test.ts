import { describe, it, expect } from 'vitest';
import {
  evaluateConversionPermissions,
  executeCrossDomainConversion,
  resolveTargetRoute,
  type ConversionSourceItem,
  type SourceType,
  type TargetType,
  type WorkspaceRole,
} from './conversion_lineage';

describe('P6-08 Cross-Domain Commerce Conversions Suite', () => {
  const wsId = 'ws-commerce-001';
  const userId = 'user-test-001';

  // --------------------------------------------------------------------------
  // ACCEPTANCE TARGET 1: EACH TARGET PERMISSION RECHECKED
  // --------------------------------------------------------------------------
  describe('Acceptance Target 1: Target Permission Rechecking', () => {
    it('allows Editor to convert Opportunity to Campaign (campaign:manage)', () => {
      const res = evaluateConversionPermissions('editor', 'opportunity', 'campaign');
      expect(res.allowed).toBe(true);
      expect(res.error).toBeUndefined();
    });

    it('DENIES Editor converting Opportunity to Brand Deal because brand_deal:manage requires Manager+', () => {
      const res = evaluateConversionPermissions('editor', 'opportunity', 'deal');
      expect(res.allowed).toBe(false);
      expect(res.missingPermission).toBe('brand_deal:manage');
      expect(res.error).toContain('brand_deal:manage');
      expect(res.error).toContain('không đủ quyền');
    });

    it('allows Manager to convert Opportunity to Brand Deal', () => {
      const res = evaluateConversionPermissions('manager', 'opportunity', 'deal');
      expect(res.allowed).toBe(true);
    });

    it('allows Editor to convert Idea to Offer (offer:manage)', () => {
      const res = evaluateConversionPermissions('editor', 'idea', 'offer');
      expect(res.allowed).toBe(true);
    });

    it('DENIES Editor converting Idea to Brand Deal', () => {
      const res = evaluateConversionPermissions('editor', 'idea', 'deal');
      expect(res.allowed).toBe(false);
      expect(res.missingPermission).toBe('brand_deal:manage');
    });

    it('allows Editor to convert Thread to Seeding (sample:manage)', () => {
      const res = evaluateConversionPermissions('editor', 'thread', 'seeding');
      expect(res.allowed).toBe(true);
    });

    it('DENIES Contributor from converting any source to Campaign (lacks opportunity:convert / campaign:manage)', () => {
      const res = evaluateConversionPermissions('contributor', 'opportunity', 'campaign');
      expect(res.allowed).toBe(false);
    });

    it('DENIES Viewer from converting any source to any target', () => {
      const res = evaluateConversionPermissions('viewer', 'thread', 'deal');
      expect(res.allowed).toBe(false);
    });
  });

  // --------------------------------------------------------------------------
  // ACCEPTANCE TARGET 2: FAILED CONVERSION ATOMIC
  // --------------------------------------------------------------------------
  describe('Acceptance Target 2: Failed Conversion Atomic', () => {
    const oppSource: ConversionSourceItem = {
      id: 'opp-atomic-101',
      type: 'opportunity',
      title: 'Trending Beauty Product Opportunity',
      status: 'in_progress',
    };

    it('keeps source completely untouched when target creation fails', () => {
      const result = executeCrossDomainConversion({
        workspaceId: wsId,
        role: 'editor',
        userId,
        source: oppSource,
        targetType: 'campaign',
        simulateFailureStage: 'target_creation',
      });

      expect(result.success).toBe(false);
      expect(result.sourceSurvives).toBe(true);
      expect(result.updatedSource).toEqual(oppSource);
      expect(result.updatedSource?.status).toBe('in_progress');
      expect(result.updatedSource?.convertedToType).toBeUndefined();
      expect(result.lineageRecord).toBeUndefined();
      expect(result.error).toContain('kết nối cơ sở dữ liệu gián đoạn');
    });

    it('rolls back target and keeps source status untouched when source update fails', () => {
      const result = executeCrossDomainConversion({
        workspaceId: wsId,
        role: 'editor',
        userId,
        source: oppSource,
        targetType: 'campaign',
        simulateFailureStage: 'source_update',
      });

      expect(result.success).toBe(false);
      expect(result.sourceSurvives).toBe(true);
      expect(result.updatedSource?.status).toBe('in_progress');
      expect(result.updatedSource?.convertedToType).toBeUndefined();
      expect(result.error).toContain('Đã hoàn tác và xoá bản ghi đích');
    });

    it('reverts source state to original when lineage persistence fails', () => {
      const result = executeCrossDomainConversion({
        workspaceId: wsId,
        role: 'editor',
        userId,
        source: oppSource,
        targetType: 'campaign',
        simulateFailureStage: 'lineage_save',
      });

      expect(result.success).toBe(false);
      expect(result.sourceSurvives).toBe(true);
      expect(result.updatedSource?.status).toBe('in_progress');
      expect(result.lineageRecord).toBeUndefined();
      expect(result.error).toContain('Đã khôi phục đối tượng nguồn');
    });
  });

  // --------------------------------------------------------------------------
  // ACCEPTANCE TARGET 3: SOURCE SURVIVES CONVERSION
  // --------------------------------------------------------------------------
  describe('Acceptance Target 3: Source Survives Conversion', () => {
    it('Opportunity converted to Campaign survives with converted status and target pointer', () => {
      const source: ConversionSourceItem = {
        id: 'opp-survive-01',
        type: 'opportunity',
        title: 'Skincare Livestream Opportunity',
        status: 'in_progress',
      };

      const result = executeCrossDomainConversion({
        workspaceId: wsId,
        role: 'editor',
        userId,
        source,
        targetType: 'campaign',
        targetTitle: 'Chiến dịch Q4 Skincare',
      });

      expect(result.success).toBe(true);
      expect(result.sourceSurvives).toBe(true);
      expect(result.updatedSource).toBeDefined();
      expect(result.updatedSource?.id).toBe(source.id);
      expect(result.updatedSource?.title).toBe(source.title);
      expect(result.updatedSource?.status).toBe('converted');
      expect(result.updatedSource?.convertedToType).toBe('campaign');
      expect(result.updatedSource?.convertedToId).toBe(result.targetId);

      // Verify Shared Lineage Record
      expect(result.lineageRecord).toBeDefined();
      expect(result.lineageRecord?.sourceId).toBe(source.id);
      expect(result.lineageRecord?.targetId).toBe(result.targetId);
      expect(result.lineageRecord?.targetType).toBe('campaign');
      expect(result.targetRoute).toBe(`/campaigns/${result.targetId}`);
    });

    it('Idea converted to Seeding Sample Request survives with converted status', () => {
      const source: ConversionSourceItem = {
        id: 'idea-survive-02',
        type: 'idea',
        title: 'Review 5 Mẫu Thử Mỹ Phẩm Mùa Thu',
        status: 'selected',
      };

      const result = executeCrossDomainConversion({
        workspaceId: wsId,
        role: 'editor',
        userId,
        source,
        targetType: 'seeding',
      });

      expect(result.success).toBe(true);
      expect(result.sourceSurvives).toBe(true);
      expect(result.updatedSource?.status).toBe('converted');
      expect(result.updatedSource?.convertedToType).toBe('seeding');
      expect(result.targetRoute).toBe(`/seeding/samples/${result.targetId}`);
    });

    it('Thread converted to Brand Deal by Manager survives with converted_to_task status', () => {
      const source: ConversionSourceItem = {
        id: 'thread-survive-03',
        type: 'thread',
        title: 'Tin nhắn ngỏ ý tài trợ từ nhãn hàng NatureCare',
        status: 'active',
      };

      const result = executeCrossDomainConversion({
        workspaceId: wsId,
        role: 'manager',
        userId,
        source,
        targetType: 'deal',
        targetTitle: 'Thỏa thuận hợp tác NatureCare',
      });

      expect(result.success).toBe(true);
      expect(result.sourceSurvives).toBe(true);
      expect(result.updatedSource?.status).toBe('converted_to_task');
      expect(result.updatedSource?.convertedToType).toBe('deal');
      expect(result.targetRoute).toBe(`/brand-deals/${result.targetId}`);
    });

    it('forbids re-converting an already converted source', () => {
      const alreadyConverted: ConversionSourceItem = {
        id: 'opp-converted-already',
        type: 'opportunity',
        title: 'Đã hoàn tất chuyển đổi',
        status: 'converted',
        convertedToType: 'campaign',
        convertedToId: 'target-campaign-001',
      };

      const result = executeCrossDomainConversion({
        workspaceId: wsId,
        role: 'editor',
        userId,
        source: alreadyConverted,
        targetType: 'live',
      });

      expect(result.success).toBe(false);
      expect(result.error).toContain('đã được chuyển đổi trước đó');
    });
  });

  describe('Route Resolver', () => {
    it('resolves correct URL routes for all 6 target types', () => {
      expect(resolveTargetRoute('campaign', '123')).toBe('/campaigns/123');
      expect(resolveTargetRoute('live', '456')).toBe('/live/sessions/456');
      expect(resolveTargetRoute('offer', '789')).toBe('/offers/789');
      expect(resolveTargetRoute('seeding', 'abc')).toBe('/seeding/samples/abc');
      expect(resolveTargetRoute('deal', 'def')).toBe('/brand-deals/def');
      expect(resolveTargetRoute('script', 'ghi')).toBe('/scripts/ghi');
    });
  });
});
