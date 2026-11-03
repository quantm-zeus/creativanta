import { describe, it, expect } from 'vitest';
import {
  checkDuplicateIdea,
  calculateTextSimilarity,
  validateConversionEligibility,
  validateStateTransition,
  formatSourceLabel,
  type Idea,
  type IdeaSourceRef,
} from './index';

describe('M05 Idea Engine Frontend Unit Tests', () => {
  const mockExistingIdeas: Idea[] = [
    {
      ideaId: 'idea-101',
      workspaceId: 'ws-1',
      title: 'Hướng dẫn skincare mùa hè cho da dầu',
      description: 'Quy trình dưỡng ẩm kiềm dầu 3 bước mùa nóng',
      audienceIntent: 'Da dầu mụn',
      creatorIntent: 'Review kem chống nắng',
      suggestedFormat: 'short_form',
      suggestedDirection: 'Pacing nhanh',
      status: 'selected',
      ideaScore: 90,
      createdBy: 'user-1',
      sources: [
        {
          sourceType: 'trend',
          sourceId: 'trend-summer-1',
          sourceTitle: 'Trend dưỡng da mùa hè 2026',
        }
      ],
      hooks: [],
      createdAt: '2026-06-01T00:00:00Z',
      updatedAt: '2026-06-01T00:00:00Z',
    },
    {
      ideaId: 'idea-102',
      workspaceId: 'ws-1',
      title: 'Top 5 son dưỡng chống khô môi',
      description: 'Đánh giá son dưỡng giá hạt dẻ',
      audienceIntent: 'Sinh viên',
      creatorIntent: 'Gắn affiliate link',
      suggestedFormat: 'listicle',
      suggestedDirection: 'Swatch trên tay',
      status: 'draft',
      ideaScore: 75,
      createdBy: 'user-2',
      sources: [
        {
          sourceType: 'manual',
          sourceId: 'user-2',
          sourceTitle: 'Manual Idea',
        }
      ],
      hooks: [],
      createdAt: '2026-06-01T00:00:00Z',
      updatedAt: '2026-06-01T00:00:00Z',
    }
  ];

  // ==========================================================================
  // Acceptance Target 1: Duplicate idea warns without silent merge (>0.85)
  // ==========================================================================
  describe('Acceptance Target 1: Duplicate Idea Detection (>0.85 threshold)', () => {
    it('detects high similarity (>0.85) and warns user without auto-merging', () => {
      // Substring containment or lexical overlap
      const newTitle = 'Hướng dẫn skincare mùa hè';
      const warning = checkDuplicateIdea(newTitle, mockExistingIdeas, 0.85);

      expect(warning).not.toBeNull();
      expect(warning?.isDuplicate).toBe(true);
      expect(warning?.similarityScore).toBeGreaterThanOrEqual(0.85);
      expect(warning?.existingIdeaId).toBe('idea-101');
      expect(warning?.existingIdeaTitle).toBe('Hướng dẫn skincare mùa hè cho da dầu');
      expect(warning?.warningMessage).toContain('Đã có ý tưởng tương tự');
    });

    it('returns null when new title has low similarity (<0.85)', () => {
      const distinctTitle = 'Chiến lược livestream bán đồ gia dụng thông minh';
      const warning = checkDuplicateIdea(distinctTitle, mockExistingIdeas, 0.85);

      expect(warning).toBeNull();
    });

    it('calculates identical strings as 1.0 similarity', () => {
      const sim = calculateTextSimilarity('Skincare mùa hè', 'skincare mùa hè');
      expect(sim).toBe(1.0);
    });
  });

  // ==========================================================================
  // Acceptance Target 2: Source lineage retained
  // ==========================================================================
  describe('Acceptance Target 2: Source Lineage & Expired Sources (RULE-M05-001, EC-M05-002)', () => {
    it('formats active trend source with correct label and link', () => {
      const activeSource: IdeaSourceRef = {
        sourceType: 'trend',
        sourceId: 'trend-99',
        sourceTitle: 'Kem chống nắng nâng tone hot trend',
        sourceUrl: 'https://creativanta.app/trends/trend-99',
        isArchived: false,
      };

      const formatted = formatSourceLabel(activeSource);
      expect(formatted.typeLabel).toBe('Xu hướng (Trend)');
      expect(formatted.title).toBe('Kem chống nắng nâng tone hot trend');
      expect(formatted.url).toBe('https://creativanta.app/trends/trend-99');
      expect(formatted.isArchived).toBe(false);
      expect(formatted.archiveNotice).toBeUndefined();
    });

    it('retains lineage and displays archived notice when source expires (EC-M05-002)', () => {
      const expiredSource: IdeaSourceRef = {
        sourceType: 'opportunity',
        sourceId: 'opp-old',
        sourceTitle: 'Cơ hội mùa tết cũ',
        isArchived: true,
        archiveNotice: 'Source opportunity has expired — view archived data',
      };

      const formatted = formatSourceLabel(expiredSource);
      expect(formatted.isArchived).toBe(true);
      expect(formatted.archiveNotice).toBe('Source opportunity has expired — view archived data');
      expect(formatted.typeLabel).toBe('Cơ hội (Opportunity)');
    });

    it('formats manual source link properly', () => {
      const manualSource: IdeaSourceRef = {
        sourceType: 'manual',
        sourceId: 'user-123',
        sourceTitle: 'Ý tưởng tự do',
      };

      const formatted = formatSourceLabel(manualSource);
      expect(formatted.typeLabel).toBe('Ghi chú thủ công (Manual)');
      expect(formatted.title).toBe('Ý tưởng tự do');
    });
  });

  // ==========================================================================
  // Acceptance Target 3: Mobile title-only draft works
  // ==========================================================================
  describe('Acceptance Target 3: Mobile Title-Only Draft Works', () => {
    it('allows idea creation in draft state with title only', () => {
      const titleOnlyIdea: Idea = {
        ideaId: 'idea-mobile-1',
        workspaceId: 'ws-1',
        title: 'Review phấn phủ kiềm dầu',
        description: '',
        audienceIntent: '',
        creatorIntent: '',
        suggestedFormat: '',
        suggestedDirection: '',
        status: 'draft',
        ideaScore: 70,
        createdBy: 'user-1',
        sources: [
          {
            sourceType: 'manual',
            sourceId: 'user-1',
            sourceTitle: 'Quick capture',
          }
        ],
        hooks: [],
        createdAt: '2026-06-01T00:00:00Z',
        updatedAt: '2026-06-01T00:00:00Z',
      };

      expect(titleOnlyIdea.title).toBe('Review phấn phủ kiềm dầu');
      expect(titleOnlyIdea.status).toBe('draft');
      expect(titleOnlyIdea.description).toBe('');
      expect(titleOnlyIdea.suggestedFormat).toBe('');
      expect(titleOnlyIdea.sources.length).toBe(1);
    });
  });

  // ==========================================================================
  // Canonical State Machine Progression (RULE-M05-002)
  // ==========================================================================
  describe('Canonical State Machine (RULE-M05-002)', () => {
    it('allows valid progression: draft -> candidate -> selected -> converted', () => {
      expect(validateStateTransition('draft', 'candidate').valid).toBe(true);
      expect(validateStateTransition('candidate', 'selected').valid).toBe(true);
      expect(validateStateTransition('selected', 'converted').valid).toBe(true);
    });

    it('allows archiving from draft, candidate, or selected', () => {
      expect(validateStateTransition('draft', 'archived').valid).toBe(true);
      expect(validateStateTransition('candidate', 'archived').valid).toBe(true);
      expect(validateStateTransition('selected', 'archived').valid).toBe(true);
    });

    it('allows un-archiving back to draft only', () => {
      expect(validateStateTransition('archived', 'draft').valid).toBe(true);
      expect(validateStateTransition('archived', 'selected').valid).toBe(false);
      expect(validateStateTransition('archived', 'converted').valid).toBe(false);
    });

    it('forbids state skipping: draft directly to converted or selected', () => {
      const skipToConverted = validateStateTransition('draft', 'converted');
      expect(skipToConverted.valid).toBe(false);
      expect(skipToConverted.error).toContain("Không thể chuyển trực tiếp từ 'draft' sang 'converted'");

      const skipToSelected = validateStateTransition('draft', 'selected');
      expect(skipToSelected.valid).toBe(false);
    });

    it('forbids modifying converted terminal state', () => {
      expect(validateStateTransition('converted', 'draft').valid).toBe(false);
      expect(validateStateTransition('converted', 'selected').valid).toBe(false);
      expect(validateStateTransition('converted', 'archived').valid).toBe(false);
    });
  });

  // ==========================================================================
  // Conversion Eligibility Validation (EC-M05-004)
  // ==========================================================================
  describe('Conversion Eligibility Validation (EC-M05-004)', () => {
    it('blocks conversion when description or suggested format is missing', () => {
      const incompleteIdea: Idea = {
        ideaId: 'idea-inc',
        workspaceId: 'ws-1',
        title: 'Ý tưởng chưa hoàn thiện',
        description: '', // missing
        audienceIntent: '',
        creatorIntent: '',
        suggestedFormat: '', // missing
        suggestedDirection: '',
        status: 'draft',
        ideaScore: 60,
        createdBy: 'user-1',
        sources: [],
        hooks: [],
        createdAt: '',
        updatedAt: '',
      };

      const result = validateConversionEligibility(incompleteIdea);
      expect(result.eligible).toBe(false);
      expect(result.missingFields).toContain('mô tả nội dung (description)');
      expect(result.missingFields).toContain('định dạng đề xuất (suggested_format)');
      expect(result.message).toContain('Ý tưởng cần bổ sung');
    });

    it('approves conversion when description and suggested format are present', () => {
      const readyIdea: Idea = {
        ideaId: 'idea-ready',
        workspaceId: 'ws-1',
        title: 'Ý tưởng đã hoàn chỉnh',
        description: 'Mô tả chi tiết 3 phân cảnh hành động',
        audienceIntent: 'Người xem muốn học hỏi',
        creatorIntent: 'Xây dựng thương hiệu',
        suggestedFormat: 'short_form',
        suggestedDirection: 'Pacing nhanh',
        status: 'selected',
        ideaScore: 88,
        createdBy: 'user-1',
        sources: [],
        hooks: [],
        createdAt: '',
        updatedAt: '',
      };

      const result = validateConversionEligibility(readyIdea);
      expect(result.eligible).toBe(true);
      expect(result.missingFields.length).toBe(0);
    });
  });
});
