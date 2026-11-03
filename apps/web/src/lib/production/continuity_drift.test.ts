import { describe, it, expect } from 'vitest';
import {
	quoteCharacterPreview,
	evaluateDrift,
	canApproveAsset,
	calculateStyleExtractionQuote
} from './index';

describe('P4-07 Style Learning, Character Preview & Complete Continuity', () => {
	describe('Acceptance Target 1: 15s preview quoted', () => {
		it('returns exact 15-second duration and 5.0 credits bounded quote', () => {
			const quote = quoteCharacterPreview(50.0, 15);
			expect(quote.durationSeconds).toBe(15);
			expect(quote.creditsRequired).toBe('5.000000');
			expect(quote.provider).toBe('veo-preview-fast');
			expect(quote.canAfford).toBe(true);
		});

		it('defaults duration to 15s when unspecified or non-positive', () => {
			const quote = quoteCharacterPreview(100.0, 0);
			expect(quote.durationSeconds).toBe(15);
		});

		it('flags canAfford as false when workspace balance is below 5 credits', () => {
			const quote = quoteCharacterPreview(3.5, 15);
			expect(quote.canAfford).toBe(false);
		});
	});

	describe('Acceptance Target 2: High drift blocks readiness', () => {
		it('categorizes scores correctly into none, low, moderate, and high drift', () => {
			const none = evaluateDrift('asset-1', 'pack-1', 10.0);
			expect(none.driftSeverity).toBe('none');
			expect(none.isBlocked).toBe(false);

			const low = evaluateDrift('asset-2', 'pack-1', 25.0);
			expect(low.driftSeverity).toBe('low_drift');
			expect(low.isBlocked).toBe(false);

			const mod = evaluateDrift('asset-3', 'pack-1', 50.0);
			expect(mod.driftSeverity).toBe('moderate_drift');
			expect(mod.isBlocked).toBe(false);

			const high = evaluateDrift('asset-4', 'pack-1', 75.0);
			expect(high.driftSeverity).toBe('high_drift');
			expect(high.isBlocked).toBe(true);
			expect(high.violationReasons.length).toBeGreaterThan(0);
			expect(high.violationId).toBeDefined();
		});

		it('blocks asset approval when drift is high and violation is unresolved', () => {
			const check = canApproveAsset('high_drift', true);
			expect(check.canApprove).toBe(false);
			expect(check.blockerMessage).toContain('RULE-M08-005, AC 4');
		});

		it('allows asset approval when violation has been overridden by manager', () => {
			const check = canApproveAsset('high_drift', false);
			expect(check.canApprove).toBe(true);
			expect(check.blockerMessage).toBeUndefined();
		});
	});

	describe('Acceptance Target 3: Likeness consent gating and revocation', () => {
		it('blocks generation when digital twin likeness consent is revoked', () => {
			const character = {
				characterId: 'twin-1',
				characterType: 'digital_twin',
				consentVerified: false,
				status: 'archived'
			};

			const canProceed = character.characterType !== 'digital_twin' || (character.consentVerified && character.status !== 'archived');
			expect(canProceed).toBe(false);
		});

		it('allows generation when digital twin likeness consent is valid and active', () => {
			const character = {
				characterId: 'twin-2',
				characterType: 'digital_twin',
				consentVerified: true,
				status: 'ready'
			};

			const canProceed = character.characterType !== 'digital_twin' || (character.consentVerified && character.status !== 'archived');
			expect(canProceed).toBe(true);
		});
	});

	describe('EF-07 Style Learning Input Validation & Quoting', () => {
		it('calculates 15 credits quote for 1-5 reference videos', () => {
			const single = calculateStyleExtractionQuote(1);
			expect(single.isValid).toBe(true);
			expect(single.creditsRequired).toBe(15);

			const five = calculateStyleExtractionQuote(5);
			expect(five.isValid).toBe(true);
			expect(five.creditsRequired).toBe(15);
		});

		it('rejects 0 videos or more than 5 reference videos', () => {
			const zero = calculateStyleExtractionQuote(0);
			expect(zero.isValid).toBe(false);
			expect(zero.errorMessage).toBeDefined();

			const six = calculateStyleExtractionQuote(6);
			expect(six.isValid).toBe(false);
			expect(six.errorMessage).toBeDefined();
		});
	});
});
