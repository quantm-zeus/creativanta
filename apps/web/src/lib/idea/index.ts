// Package idea provides frontend types, state transitions, duplicate detection,
// conversion validation, and source lineage tracking for M05 Idea Engine.
// Canonical source: docs/02_features/content/idea_engine.md
// and docs/04_contracts/database_schema.md §6.1, §6.2, §6.3.

export type IdeaStatus = 'draft' | 'candidate' | 'selected' | 'converted' | 'archived';

export type HookType = 'question' | 'shock' | 'story' | 'pov' | 'listicle' | 'contrast';

export type HookSource = 'manual' | 'ai_generated' | 'library';

export interface IdeaSourceRef {
  sourceType: string; // trend, opportunity, product, thread, comment_cluster, objection, offer, manual
  sourceId: string;
  sourceTitle: string;
  sourceUrl?: string;
  isArchived?: boolean;
  archiveNotice?: string;
}

export interface Hook {
  hookId: string;
  workspaceId: string;
  ideaId?: string;
  hookText: string;
  hookType: HookType;
  effectivenessScore: number;
  usageCount: number;
  source: HookSource;
  createdAt: string;
}

export interface DuplicateWarning {
  isDuplicate: boolean;
  similarityScore: number; // 0.0 - 1.0 (threshold 0.85)
  existingIdeaId: string;
  existingIdeaTitle: string;
  warningMessage: string;
}

export interface Idea {
  ideaId: string;
  workspaceId: string;
  title: string;
  description: string;
  audienceIntent: string;
  creatorIntent: string;
  suggestedFormat: string;
  suggestedDirection: string;
  status: IdeaStatus;
  ideaScore: number;
  convertedToType?: string;
  convertedToId?: string;
  createdBy: string;
  sources: IdeaSourceRef[];
  hooks: Hook[];
  embeddingVector?: number[];
  createdAt: string;
  updatedAt: string;
  sourceClass?: string;
  confidence?: string;
  recommendedFormats?: string[];
  recommendedPlatforms?: string[];
  angle?: string;
  hookSuggestion?: string;
}

/**
 * Validates canonical state machine transitions per RULE-M05-002:
 * draft → candidate → selected → converted | archived; archived → draft.
 * State skipping is strictly forbidden.
 */
export function validateStateTransition(
  current: IdeaStatus,
  target: IdeaStatus
): { valid: boolean; error?: string } {
  if (current === target) {
    return { valid: true };
  }

  switch (current) {
    case 'draft':
      if (target === 'candidate' || target === 'archived') {
        return { valid: true };
      }
      return {
        valid: false,
        error: `Không thể chuyển trực tiếp từ 'draft' sang '${target}'. Ý tưởng phải qua bước 'candidate' và 'selected'.`
      };

    case 'candidate':
      if (target === 'selected' || target === 'archived') {
        return { valid: true };
      }
      return {
        valid: false,
        error: `Không thể chuyển từ 'candidate' sang '${target}'. Chỉ có thể chọn (selected) hoặc lưu trữ (archived).`
      };

    case 'selected':
      if (target === 'converted' || target === 'archived') {
        return { valid: true };
      }
      return {
        valid: false,
        error: `Không thể chuyển từ 'selected' sang '${target}'. Chỉ có thể chuyển đổi (converted) hoặc lưu trữ (archived).`
      };

    case 'archived':
      if (target === 'draft') {
        return { valid: true };
      }
      return {
        valid: false,
        error: `Ý tưởng đã lưu trữ chỉ có thể khôi phục về trạng thái 'draft'.`
      };

    case 'converted':
      return {
        valid: false,
        error: `Ý tưởng đã chuyển đổi sang kịch bản (converted) là trạng thái kết thúc.`
      };

    default:
      return { valid: false, error: 'Trạng thái không hợp lệ.' };
  }
}

/**
 * Validates conversion eligibility per EC-M05-004:
 * Converting an idea to a script requires at least a description and suggested_format.
 */
export function validateConversionEligibility(idea: Idea): {
  eligible: boolean;
  missingFields: string[];
  message?: string;
} {
  const missing: string[] = [];

  if (!idea.description || idea.description.trim() === '') {
    missing.push('mô tả nội dung (description)');
  }
  if (!idea.suggestedFormat || idea.suggestedFormat.trim() === '') {
    missing.push('định dạng đề xuất (suggested_format)');
  }

  if (missing.length > 0) {
    return {
      eligible: false,
      missingFields: missing,
      message: `Ý tưởng cần bổ sung ${missing.join(' và ')} trước khi chuyển đổi sang kịch bản.`
    };
  }

  return { eligible: true, missingFields: [] };
}

/**
 * Calculates lexical / semantic text similarity between titles.
 */
export function calculateTextSimilarity(s1: string, s2: string): number {
  const clean1 = s1.toLowerCase().trim();
  const clean2 = s2.toLowerCase().trim();
  if (clean1 === clean2) return 1.0;
  if (!clean1 || !clean2) return 0.0;

  const tokens1 = clean1.split(/\s+/);
  const tokens2 = clean2.split(/\s+/);
  const set1 = new Set(tokens1);
  const set2 = new Set(tokens2);

  let intersection = 0;
  for (const t of set1) {
    if (set2.has(t)) {
      intersection++;
    }
  }

  const union = set1.size + set2.size - intersection;
  if (union === 0) return 0.0;

  let score = intersection / union;

  // Substring containment boost
  if (clean1.includes(clean2) || clean2.includes(clean1)) {
    if (score < 0.88) {
      score = 0.88;
    }
  }

  return Math.min(1.0, score);
}

/**
 * Checks for duplicate ideas above similarity threshold (default 0.85 per RULE-M05-005).
 */
export function checkDuplicateIdea(
  newTitle: string,
  existingIdeas: Idea[],
  threshold = 0.85
): DuplicateWarning | null {
  if (!newTitle || existingIdeas.length === 0) return null;

  let bestMatch: { idea: Idea; sim: number } | null = null;

  for (const existing of existingIdeas) {
    const sim = calculateTextSimilarity(newTitle, existing.title);
    if (sim >= threshold) {
      if (!bestMatch || sim > bestMatch.sim) {
        bestMatch = { idea: existing, sim };
      }
    }
  }

  if (bestMatch) {
    return {
      isDuplicate: true,
      similarityScore: Math.round(bestMatch.sim * 100) / 100,
      existingIdeaId: bestMatch.idea.ideaId,
      existingIdeaTitle: bestMatch.idea.title,
      warningMessage: `Đã có ý tưởng tương tự: "${bestMatch.idea.title}" (độ tương đồng: ${Math.round(bestMatch.sim * 100)}%) — Bạn có muốn xem lại hay vẫn tiếp tục tạo?`
    };
  }

  return null;
}

/**
 * Formats source ref information including expired/archived states (EC-M05-002).
 */
export function formatSourceLabel(source: IdeaSourceRef): {
  typeLabel: string;
  title: string;
  url?: string;
  isArchived: boolean;
  archiveNotice?: string;
} {
  const typeMap: Record<string, string> = {
    trend: 'Xu hướng (Trend)',
    opportunity: 'Cơ hội (Opportunity)',
    product: 'Sản phẩm (Product)',
    thread: 'Hội thoại (Thread)',
    comment_cluster: 'Nhóm bình luận (Comment Cluster)',
    objection: 'Góc phản biện (Objection)',
    offer: 'Ưu đãi / Affiliate',
    manual: 'Ghi chú thủ công (Manual)'
  };

  const typeLabel = typeMap[source.sourceType.toLowerCase()] || source.sourceType;
  const isArchived = Boolean(source.isArchived);

  return {
    typeLabel,
    title: source.sourceTitle || source.sourceId,
    url: source.sourceUrl,
    isArchived,
    archiveNotice: isArchived
      ? source.archiveNotice || `Nguồn ${typeLabel} đã hết hạn/lưu trữ — dữ liệu chỉ đọc.`
      : undefined
  };
}
