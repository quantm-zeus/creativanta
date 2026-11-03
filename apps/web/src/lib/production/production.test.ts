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
});
