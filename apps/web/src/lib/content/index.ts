// Content Handoffs, Source Chain Lineage, and Acceptance Utilities for Phase P3 (M06 Script Lab).

export interface LineageNode {
  id: string;
  type: 'trend' | 'opportunity' | 'idea' | 'script' | 'asset_brief';
  title: string;
  state: string;
  confidence?: string;
  sourceClass?: string;
  routeUrl: string;
  createdAt: string;
  updatedAt: string;
}

export interface SourceChainLineage {
  workspaceId: string;
  scriptId: string;
  trend?: LineageNode;
  opportunity?: LineageNode;
  idea?: LineageNode;
  script: LineageNode;
  assetBrief?: LineageNode;
  isComplete: boolean;
  isProductionReady: boolean;
  lineageHash: string;
  emittedEvents: string[];
}

export interface ConcurrentReviewCheck {
  isStale: boolean;
  reason?: string;
  diffSeconds?: number;
}

/**
 * Checks if a reviewer's open snapshot is stale compared to the latest script update (EC-M06-003).
 */
export function isReviewStale(scriptUpdatedAt: string | Date, reviewerSnapshotAt: string | Date): ConcurrentReviewCheck {
  const scriptTime = new Date(scriptUpdatedAt).getTime();
  const snapshotTime = new Date(reviewerSnapshotAt).getTime();

  if (scriptTime > snapshotTime) {
    const diffSec = Math.round((scriptTime - snapshotTime) / 1000);
    return {
      isStale: true,
      reason: `Tác giả đã cập nhật kịch bản cách đây ${diffSec > 0 ? diffSec : 1}s. Vui lòng tải lại để xem thay đổi trước khi duyệt.`,
      diffSeconds: diffSec
    };
  }

  return { isStale: false };
}

/**
 * Validates that an Asset Brief meets all required conditions for ready_for_production (RULE-M06-005).
 */
export function isAssetBriefComplete(brief: {
  outputType?: string;
  targetFormat?: string;
  targetDurationSeconds?: number;
  continuityRequirementsJson?: string;
}): boolean {
  if (!brief) return false;
  if (!brief.outputType || brief.outputType.trim() === '') return false;
  if (!brief.targetFormat || brief.targetFormat.trim() === '') return false;
  if (!brief.targetDurationSeconds || brief.targetDurationSeconds <= 0) return false;
  if (!brief.continuityRequirementsJson || brief.continuityRequirementsJson.trim() === '' || brief.continuityRequirementsJson === '{}') return false;
  return true;
}

/**
 * Detects publish intent in creative assistant queries to prevent publish side effects (Phase P5 gate).
 */
export function hasPublishIntent(query: string): boolean {
  const lower = query.toLowerCase();
  const publishKeywords = [
    'publish',
    'xuất bản',
    'xuat ban',
    'đăng video',
    'dang video',
    'đăng bài',
    'dang bai',
    'đăng lên',
    'dang len',
    'schedule',
    'lên lịch',
    'len lich',
    'post to',
    'post to tiktok',
    'post to youtube',
    'upload to',
    'upload to tiktok',
    'upload to youtube',
    'phát hành'
  ];
  return publishKeywords.some(kw => lower.includes(kw));
}
