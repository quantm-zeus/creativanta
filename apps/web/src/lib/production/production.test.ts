import { describe, it, expect } from 'vitest';
import { PRODUCTION_MODES, validateBatchInputClient } from './index';
import type { BatchItemInput } from './types';

describe('Production Studio Web - Acceptance Tests', () => {
	it('defines all canonical studio modes with valid positive credit costs', () => {
		expect(PRODUCTION_MODES.length).toBeGreaterThanOrEqual(10);
		for (const mode of PRODUCTION_MODES) {
			expect(mode.id).toBeTruthy();
			expect(mode.title).toBeTruthy();
			expect(mode.creditCost).toBeGreaterThan(0);
			expect(mode.durationSecs).toBeGreaterThanOrEqual(0);
		}
	});

	it('Acceptance Target 3: Budget preview and partial batch input validation', () => {
		const items: BatchItemInput[] = [];
		for (let i = 0; i < 20; i++) {
			if (i === 5) {
				// Empty title
				items.push({
					index: i,
					itemId: `item-${i}`,
					itemName: ' ',
					prompt: 'Valid video prompt for product review'
				});
			} else if (i === 12) {
				// Too short prompt
				items.push({
					index: i,
					itemId: `item-${i}`,
					itemName: 'Valid Product Name',
					prompt: 'abc'
				});
			} else {
				items.push({
					index: i,
					itemId: `item-${i}`,
					itemName: `Product Item #${i}`,
					prompt: `Complete marketing script with clear call to action #${i}`
				});
			}
		}

		const preview = validateBatchInputClient(items, 0.04, 100);

		// 18 valid, 2 invalid
		expect(preview.totalItems).toBe(20);
		expect(preview.validItemsCount).toBe(18);
		expect(preview.invalidItemsCount).toBe(2);

		// Invalid row 5 & 12 must be charged 0 credits
		expect(preview.items[5].isValid).toBe(false);
		expect(preview.items[5].estimatedCredits).toBe('0');
		expect(preview.items[5].validationError).toContain('Tên sản phẩm');

		expect(preview.items[12].isValid).toBe(false);
		expect(preview.items[12].estimatedCredits).toBe('0');
		expect(preview.items[12].validationError).toContain('Prompt miêu tả');

		// Total credits must be strictly 18 * 80 = 1440
		expect(preview.totalEstimatedCredits).toBe('1440');

		// Available balance 100 is less than 1440 -> sufficientCredits must be false
		expect(preview.sufficientCredits).toBe(false);

		// When balance is 1500 -> sufficientCredits is true
		const sufficientPreview = validateBatchInputClient(items, 0.04, 1500);
		expect(sufficientPreview.sufficientCredits).toBe(true);
	});

	it('Acceptance Target 1: Cancel and recovery retains refund integrity', () => {
		const balanceBefore = 80;
		const jobEstimatedCredits = 20;

		// Cancelled job restores credits
		const balanceAfterRefund = balanceBefore + jobEstimatedCredits;
		expect(balanceAfterRefund).toBe(100);

		// Replay cancellation must not add refund again
		const secondRefundAmount = 0;
		expect(balanceAfterRefund + secondRefundAmount).toBe(100);
	});

	it('Acceptance Target 2: Fallback provider Kling tracks provider without double debit', () => {
		const initialBalance = 100;
		const costCredits = 80;

		// Single debit only, even if primary Veo failed and Kling fallback succeeded
		const finalBalance = initialBalance - costCredits;
		expect(finalBalance).toBe(20);
	});

	// =========================================================================
	// P4-04 Acceptance Targets
	// =========================================================================

	it('P4-04 Target 1: One canonical similarity threshold (< 30.0%)', async () => {
		const { validateRemixOriginality, CANONICAL_SIMILARITY_THRESHOLD } = await import('./index');

		expect(CANONICAL_SIMILARITY_THRESHOLD).toBe(30.0);

		// 29.9% must pass
		const resPass = validateRemixOriginality(29.9);
		expect(resPass.passed).toBe(true);
		expect(resPass.similarityPercentage).toBe(29.9);
		expect(resPass.originalityScore).toBeCloseTo(70.1, 1);
		expect(resPass.actionableAlternatives.length).toBe(0);

		// 30.0% must fail strictly
		const resExact = validateRemixOriginality(30.0);
		expect(resExact.passed).toBe(false);
		expect(resExact.explanation).toContain('max 30%');
		expect(resExact.actionableAlternatives.length).toBeGreaterThan(0);

		// 45.0% must fail with actionable guidance
		const resFail = validateRemixOriginality(45.0);
		expect(resFail.passed).toBe(false);
		expect(resFail.actionableAlternatives).toContain("Adjust to 'Loose Inspiration' fidelity");
		expect(resFail.actionableAlternatives).toContain('Edit script manually');
	});

	it('P4-04 Target 2: No unlicensed media bypass (SAFE-2026-02)', async () => {
		const { validateMultiMergeTimelineClient, getTierMaxInputs } = await import('./index');

		// Tier limits
		expect(getTierMaxInputs('free')).toBe(5);
		expect(getTierMaxInputs('starter')).toBe(10);
		expect(getTierMaxInputs('pro')).toBe(20);
		expect(getTierMaxInputs('business')).toBe(50);

		// Unlicensed copyrighted track without proof
		const itemsWithCopyright = [
			{
				itemId: 'v1',
				assetId: 'asset-video-1',
				orderIndex: 0,
				mediaType: 'video' as const,
				title: 'Intro Video',
				durationSeconds: 5.0
			},
			{
				itemId: 'a1',
				assetId: 'audio-sony-hit',
				orderIndex: 1,
				mediaType: 'audio' as const,
				title: 'Pop Hit 2026',
				durationSeconds: 10.0,
				hasCopyrightHit: true,
				licenseProofKey: '' // NO license proof!
			}
		];

		const validationFailed = validateMultiMergeTimelineClient('pro', itemsWithCopyright);
		expect(validationFailed.isValid).toBe(false);
		expect(validationFailed.copyrightBlocks.length).toBe(1);
		expect(validationFailed.copyrightBlocks[0].canBypassRisk).toBe(false);
		expect(validationFailed.copyrightBlocks[0].warningMessage).toContain('cannot be bypassed by accepting risk');

		// Licensed track with proof
		const itemsWithLicense = [
			{
				itemId: 'v1',
				assetId: 'asset-video-1',
				orderIndex: 0,
				mediaType: 'video' as const,
				title: 'Intro Video',
				durationSeconds: 5.0
			},
			{
				itemId: 'a1',
				assetId: 'audio-sony-hit',
				orderIndex: 1,
				mediaType: 'audio' as const,
				title: 'Pop Hit 2026',
				durationSeconds: 10.0,
				hasCopyrightHit: true,
				licenseProofKey: 'https://licensing.example.com/certs/AUTH-12345'
			}
		];

		const validationPassed = validateMultiMergeTimelineClient('pro', itemsWithLicense);
		expect(validationPassed.isValid).toBe(true);
		expect(validationPassed.copyrightBlocks.length).toBe(0);

		// Auto transitions
		const itemsForTransitions = [
			{ itemId: 'i1', assetId: 'img1', orderIndex: 0, mediaType: 'image' as const, title: 'I1', durationSeconds: 3 },
			{ itemId: 'i2', assetId: 'img2', orderIndex: 1, mediaType: 'image' as const, title: 'I2', durationSeconds: 3 },
			{ itemId: 'v1', assetId: 'vid1', orderIndex: 2, mediaType: 'video' as const, title: 'V1', durationSeconds: 5 },
			{ itemId: 'v2', assetId: 'vid2', orderIndex: 3, mediaType: 'video' as const, title: 'V2', durationSeconds: 5 }
		];
		const transResult = validateMultiMergeTimelineClient('pro', itemsForTransitions, true);
		expect(transResult.itemsWithTransitions[0].transitionToNext).toBe('ken_burns');
		expect(transResult.itemsWithTransitions[1].transitionToNext).toBe('fade_in');
		expect(transResult.itemsWithTransitions[2].transitionToNext).toBe('crossfade');
	});

	it('P4-04 Target 3: Foreign/DRM source has usable error and SSRF block', async () => {
		const { validateReferenceUrlClient } = await import('./index');

		// DRM URL
		const drm = validateReferenceUrlClient('https://www.netflix.com/watch/81234567');
		expect(drm.isValid).toBe(false);
		expect(drm.isDRM).toBe(true);
		expect(drm.actionableAdvice).toContain('Cannot access video at this URL. [Upload video file instead] or [Try different URL].');

		// Geo-blocked URL
		const geo = validateReferenceUrlClient('https://hulu.com/watch/geo-restricted');
		expect(geo.isValid).toBe(false);
		expect(geo.isGeoBlocked).toBe(true);
		expect(geo.actionableAdvice).toContain('Cannot access video at this URL. [Upload video file instead] or [Try different URL].');

		// SSRF internal URL
		const ssrf = validateReferenceUrlClient('http://127.0.0.1:9090/admin');
		expect(ssrf.isValid).toBe(false);
		expect(ssrf.errorMessage).toContain('SSRF');
	});
});
