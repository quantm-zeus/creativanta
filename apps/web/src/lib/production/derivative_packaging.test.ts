import { describe, it, expect } from 'vitest';
import {
	executeBatchTag,
	validateLineageForPackaging,
	calculatePackagingScore,
	applyWorkspaceOverride,
	evaluateABExperiment,
	LineageError,
	OverridePolicyError
} from './derivative_packaging';
import type { DerivativeItem } from './types';

describe('P4-08: Derivative Library & Packaging QA Frontend Tests', () => {
	// =========================================================================
	// Acceptance Target 1: 150-item partial batch results
	// =========================================================================
	describe('Acceptance Target 1: 150-item partial batch results', () => {
		it('processes 150 items with 147 successes and 3 failures reporting exact partial summary', () => {
			const existingItems = new Map<string, DerivativeItem>();
			const assetIds: string[] = [];

			// 147 valid items
			for (let i = 1; i <= 147; i++) {
				const id = `asset-deriv-${i.toString().padStart(3, '0')}`;
				assetIds.push(id);
				existingItems.set(id, {
					assetId: id,
					parentAssetId: 'master-source-001',
					title: `Variant ${i}`,
					derivativeType: 'clip',
					targetChannel: 'tiktok',
					aspectRatio: '9:16',
					durationSeconds: 30,
					resolution: '1080x1920',
					qualityState: 'ready',
					generationState: 'completed',
					tags: ['v1'],
					views: 500,
					engagementRate: 0.05,
					ctr: 0.03,
					createdAt: new Date().toISOString(),
					updatedAt: new Date().toISOString()
				});
			}

			// 3 invalid/missing items to make exactly 150
			assetIds.push('invalid-asset-991');
			assetIds.push('missing-asset-992');
			assetIds.push('err-asset-993');

			expect(assetIds.length).toBe(150);

			const result = executeBatchTag(
				assetIds,
				['campaign-fall-2026', 'featured'],
				['v1'],
				existingItems
			);

			expect(result.totalItems).toBe(150);
			expect(result.succeededCount).toBe(147);
			expect(result.failedCount).toBe(3);
			expect(result.succeededAssetIds.length).toBe(147);
			expect(result.failures.length).toBe(3);
			expect(result.summary).toBe('147/150 succeeded. 3 failed: [view details].');

			// Verify tags on an updated item
			const sampleItem = existingItems.get('asset-deriv-001')!;
			expect(sampleItem.tags).toContain('campaign-fall-2026');
			expect(sampleItem.tags).toContain('featured');
			expect(sampleItem.tags).not.toContain('v1');
		});
	});

	// =========================================================================
	// Acceptance Target 2: No lineage -> routing denied
	// =========================================================================
	describe('Acceptance Target 2: No lineage -> routing denied', () => {
		it('strictly throws LineageError when an asset has empty or missing parentAssetId', () => {
			const orphanAsset = {
				assetId: 'orphan-asset-001',
				parentAssetId: '',
				title: 'Unattributed Clip'
			};

			expect(() => validateLineageForPackaging(orphanAsset)).toThrowError(LineageError);
			expect(() => validateLineageForPackaging(orphanAsset)).toThrowError(
				/Missing source lineage.*RULE-M09-001/
			);

			const undefinedParentAsset = {
				assetId: 'orphan-asset-002',
				title: 'Undefined Parent Asset'
			};

			expect(() => validateLineageForPackaging(undefinedParentAsset)).toThrowError(LineageError);
		});

		it('allows routing when asset has valid source parentAssetId', () => {
			const validAsset = {
				assetId: 'valid-deriv-001',
				parentAssetId: 'master-source-001',
				title: 'Properly Attributed Clip'
			};

			expect(validateLineageForPackaging(validAsset)).toBe(true);
		});
	});

	// =========================================================================
	// Acceptance Target 3: Hard blocks cannot be workspace-overridden
	// =========================================================================
	describe('Acceptance Target 3: Hard blocks cannot be workspace-overridden', () => {
		it('generates a hard block on commercial content without disclosure that cannot be overridden by anyone', () => {
			const report = calculatePackagingScore({
				assetId: 'promo-video-001',
				publishItemId: 'pub-001',
				targetPlatform: 'tiktok',
				title: 'Bí quyết giảm giá 50% hôm nay',
				caption: 'Đừng bỏ lỡ ưu đãi cực khủng trong mùa hè này',
				hashtags: ['khuyenmai', 'giamgia'],
				cta: 'Mua ngay tại bio',
				disclosure: '', // MISSING DISCLOSURE
				isCommercial: true
			});

			expect(report.hasHardBlocks).toBe(true);
			expect(report.scoreStatus).toBe('critical');
			expect(report.readyForPackaging).toBe(false);
			expect(report.readyToPublish).toBe(false);

			const disclosureComp = report.components.find((c) => c.componentName === 'disclosure');
			expect(disclosureComp?.isHardBlocked).toBe(true);
			expect(disclosureComp?.canOverride).toBe(false);

			// Manager attempts to override hard block -> MUST FAIL
			expect(() =>
				applyWorkspaceOverride(
					report,
					'disclosure',
					'We are authorized by client to skip disclosure',
					'Manager',
					'usr-mgr-01'
				)
			).toThrowError(/Hard block.*cannot be workspace-overridden/);

			// Owner attempts to override hard block -> MUST FAIL
			expect(() =>
				applyWorkspaceOverride(
					report,
					'disclosure',
					'Owner level executive directive to proceed',
					'Owner',
					'usr-owner-01'
				)
			).toThrowError(/Hard block.*cannot be workspace-overridden/);
		});

		it('allows Manager+ to override reviewable warnings with reason >= 10 characters', () => {
			const report = calculatePackagingScore({
				assetId: 'regular-video-001',
				publishItemId: 'pub-002',
				targetPlatform: 'tiktok',
				title: 'Bật mí mẹo hay',
				caption: 'Short', // Weak caption produces warning
				hashtags: [],
				cta: 'Xem thêm',
				disclosure: '',
				isCommercial: false
			});

			expect(report.hasHardBlocks).toBe(false);
			const captionComp = report.components.find((c) => c.componentName === 'caption');
			expect(captionComp?.status).toBe('warning');
			expect(captionComp?.isHardBlocked).toBe(false);
			expect(captionComp?.canOverride).toBe(true);

			// Editor attempt -> fails with permission error
			expect(() =>
				applyWorkspaceOverride(
					report,
					'caption',
					'Short caption intentional for visual minimalism',
					'Editor',
					'usr-ed-01'
				)
			).toThrowError(/Permission denied.*Manager.*or higher required/i);

			// Manager attempt with reason < 10 characters -> fails with validation error
			expect(() =>
				applyWorkspaceOverride(report, 'caption', 'too short', 'Manager', 'usr-mgr-01')
			).toThrowError(/Override reason must be at least 10 characters/);

			// Manager attempt with valid reason -> SUCCEEDS
			const updated = applyWorkspaceOverride(
				report,
				'caption',
				'Minimalist branding requested by client creative director',
				'Manager',
				'usr-mgr-01'
			);

			expect(updated.appliedOverrides.length).toBe(1);
			expect(updated.appliedOverrides[0].actorRole).toBe('Manager');
			expect(updated.appliedOverrides[0].checkIdOrCategory).toBe('caption');
			expect(captionComp?.status).toBe('pass');
		});
	});

	// =========================================================================
	// A/B Experiment Evidence Gate (RULE-M10-006)
	// =========================================================================
	describe('A/B Experiment Evidence Gate (RULE-M10-006)', () => {
		it('marks experiment inconclusive when impressions are under 1,000 threshold', () => {
			const result = evaluateABExperiment(
				{ id: 'var-a', views: 400, clicks: 40 },
				{ id: 'var-b', views: 500, clicks: 75 }
			);

			expect(result.status).toBe('inconclusive');
			expect(result.resultStatus).toBe('inconclusive');
			expect(result.winningVariantId).toBeNull();
			expect(result.reason).toContain('Insufficient impressions (<1000 per variant)');
		});

		it('determines conclusive winner when impressions >= 1,000 and lift >= 1.2x', () => {
			const result = evaluateABExperiment(
				{ id: 'var-a', views: 2000, clicks: 100 }, // CTR = 5%
				{ id: 'var-b', views: 2500, clicks: 250 } // CTR = 10% (100% lift)
			);

			expect(result.status).toBe('completed');
			expect(result.resultStatus).toBe('conclusive');
			expect(result.winningVariantId).toBe('var-b');
			expect(result.reason).toContain('Statistically significant lift achieved');
		});
	});
});
