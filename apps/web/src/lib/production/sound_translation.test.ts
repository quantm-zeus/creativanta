import { describe, it, expect } from 'vitest';
import { calculateTranslationQuoteClient, PRODUCTION_MODES } from './index';

describe('Sound & Translation Studio Web - Acceptance Tests (P4-06)', () => {
	it('Acceptance Target 3: Measured quote with multi-language volume discount formula', () => {
		// Formula: base = 20, lip_sync = +10, cultural = +5 -> 35 cr/lang
		// 1 language: 1 * 35 = 35 credits (0% discount)
		const q1 = calculateTranslationQuoteClient(1, true, true);
		expect(q1.totalCredits).toBe('35');
		expect(q1.discountPct).toBe(0);
		expect(q1.costPerLanguage).toBe(35);

		// 2 languages: 2 * 35 * (1 - 0.10) = 63 credits (10% discount)
		const q2 = calculateTranslationQuoteClient(2, true, true);
		expect(q2.totalCredits).toBe('63');
		expect(q2.discountPct).toBe(0.10);

		// 3 languages: 3 * 35 * (1 - 0.20) = 84 credits (20% discount)
		const q3 = calculateTranslationQuoteClient(3, true, true);
		expect(q3.totalCredits).toBe('84');
		expect(q3.discountPct).toBe(0.20);

		// 4 languages: 4 * 35 * (1 - 0.30) = 98 credits (30% discount)
		const q4 = calculateTranslationQuoteClient(4, true, true);
		expect(q4.totalCredits).toBe('98');
		expect(q4.discountPct).toBe(0.30);

		// 5 languages: 5 * 35 * (1 - 0.30 max) = 122 credits (30% max discount)
		const q5 = calculateTranslationQuoteClient(5, true, true);
		expect(q5.totalCredits).toBe('122');
		expect(q5.discountPct).toBe(0.30);

		// Without cultural adaptation: base (20) + lipSync (10) = 30 cr/lang
		const qNoCultural = calculateTranslationQuoteClient(1, true, false);
		expect(qNoCultural.totalCredits).toBe('30');
		expect(qNoCultural.costPerLanguage).toBe(30);

		// Base translation only: base (20) = 20 cr/lang
		const qBaseOnly = calculateTranslationQuoteClient(1, false, false);
		expect(qBaseOnly.totalCredits).toBe('20');
		expect(qBaseOnly.costPerLanguage).toBe(20);
	});

	it('registers Sound Studio (/studio/sound) and Translation Studio (/studio/translate) routes', () => {
		const soundMode = PRODUCTION_MODES.find((m) => m.id === 'music');
		expect(soundMode).toBeDefined();
		expect(soundMode?.route).toBe('/studio/sound');
		expect(soundMode?.creditCost).toBe(8);

		const transMode = PRODUCTION_MODES.find((m) => m.id === 'translation');
		expect(transMode).toBeDefined();
		expect(transMode?.route).toBe('/studio/translate');
		expect(transMode?.creditCost).toBe(35);
	});
});
