import { describe, it, expect } from 'vitest';
import {
	analyzeTranscriptClient,
	buildCutIntervals,
	calculateQuickEditCredits,
	computeRetainedTimeline,
	isFillerWord,
	repairWordTranscript,
	SAMPLE_SMART_HOOKS,
	type QuickEditAddons,
	type TranscriptWord
} from './quickedit';

describe('Quick Edit Web (W022) - Acceptance Targets', () => {
	// ========================================================================
	// Target 1: Poor ASR can be repaired (EC-M07-Q01)
	// ========================================================================
	it('Acceptance Target 1: Tags Vietnamese fillers, detects dead pauses, and allows ASR repair', () => {
		const rawWords: TranscriptWord[] = [
			{ wordId: 'w1', text: 'Ừm', startMs: 500, endMs: 900, confidence: 0.95, isFiller: false, isDeleted: false },
			{ wordId: 'w2', text: 'xin', startMs: 1000, endMs: 1300, confidence: 0.98, isFiller: false, isDeleted: false },
			{ wordId: 'w3', text: 'chào', startMs: 1350, endMs: 1650, confidence: 0.99, isFiller: false, isDeleted: false },
			// Dead pause: 1650 -> 3500 (1850ms silence > 1500ms)
			{ wordId: 'w4', text: 'kiểu', startMs: 3500, endMs: 3900, confidence: 0.90, isFiller: false, isDeleted: false },
			{ wordId: 'w5', text: 'sản', startMs: 4000, endMs: 4300, confidence: 0.60, isFiller: false, isDeleted: false },
			{ wordId: 'w6', text: 'phẩm', startMs: 4350, endMs: 4600, confidence: 0.60, isFiller: false, isDeleted: false }
		];

		const { taggedWords, analysis } = analyzeTranscriptClient(rawWords, 1500);

		// Fillers detected
		expect(analysis.fillerCount).toBe(2);
		expect(taggedWords[0].isFiller).toBe(true); // "Ừm"
		expect(taggedWords[3].isFiller).toBe(true); // "kiểu"

		// Dead pauses detected
		expect(analysis.pauseCount).toBe(1);
		expect(analysis.deadPauses[0].durationMs).toBe(1850);

		// Successful manual ASR repair
		const repaired = repairWordTranscript(taggedWords, 'w5', 'siêu sản phẩm', 4000, 4300);
		expect(repaired.error).toBeUndefined();
		expect(repaired.fallbackMode).toBe(false);
		expect(repaired.words.find((w) => w.wordId === 'w5')?.text).toBe('siêu sản phẩm');

		// Edge Case EC-M07-Q01: Invalid temporal alignment triggers manual fallback
		const invalidRepair = repairWordTranscript(taggedWords, 'w2', 'lỗi thời gian', 5000, 2000);
		expect(invalidRepair.fallbackMode).toBe(true);
		expect(invalidRepair.error).toBe('Auto-alignment failed. [Try segment mode] or [Manual cut].');
	});

	// ========================================================================
	// Target 2: Correct ratio/audio/subtitles and credit calculation
	// ========================================================================
	it('Acceptance Target 2: Calculates accurate credit quote for Quick Edit and addons', () => {
		const baseOnlyAddons: QuickEditAddons = {
			autoCaptions: true,
			captionStyle: 'bounce',
			addHook: false,
			hookType: 'question',
			beatSync: false,
			soundGenre: 'chill',
			bRoll: false,
			platformPreset: 'none',
			audioEnhancement: false,
			targetLufs: -14.0,
			reframeRatio: '9:16'
		};

		// Base edit only = 15 credits
		const baseQuote = calculateQuickEditCredits(baseOnlyAddons);
		expect(baseQuote.baseCredits).toBe(15);
		expect(baseQuote.addonCredits).toBe(0);
		expect(baseQuote.totalCredits).toBe(15);

		// Add-ons selected: hook (+3), beat sync (+5), b-roll (+10), preset (+3), audio (+3)
		const fullAddons: QuickEditAddons = {
			...baseOnlyAddons,
			addHook: true,
			beatSync: true,
			bRoll: true,
			platformPreset: 'tiktok',
			audioEnhancement: true
		};

		// Total: 15 + 3 + 5 + 10 + 3 + 3 = 39 credits
		const fullQuote = calculateQuickEditCredits(fullAddons);
		expect(fullQuote.baseCredits).toBe(15);
		expect(fullQuote.addonCredits).toBe(24);
		expect(fullQuote.totalCredits).toBe(39);

		// Smart hook samples verified
		expect(SAMPLE_SMART_HOOKS.length).toBeGreaterThanOrEqual(6);
		const hookCategories = new Set(SAMPLE_SMART_HOOKS.map((h) => h.hookType));
		expect(hookCategories.has('question')).toBe(true);
		expect(hookCategories.has('shock')).toBe(true);
		expect(hookCategories.has('story')).toBe(true);
	});

	// ========================================================================
	// Target 3: Deleted text maps to intended segment and zero cumulative drift
	// ========================================================================
	it('Acceptance Target 3: Strikethrough words map to cut intervals with adjacent coalescing and zero drift', () => {
		const totalDurationMs = 12000;

		const words: TranscriptWord[] = [
			{ wordId: 'w1', text: 'Xin chào', startMs: 0, endMs: 1500, confidence: 0.99, isFiller: false, isDeleted: false },
			{ wordId: 'w2', text: 'ừm', startMs: 1600, endMs: 2000, confidence: 0.95, isFiller: true, isDeleted: false },
			{ wordId: 'w3', text: 'à', startMs: 2050, endMs: 2400, confidence: 0.92, isFiller: true, isDeleted: false }, // 50ms gap -> coalesce!
			{ wordId: 'w4', text: 'hôm nay mình sẽ giới thiệu', startMs: 2800, endMs: 5000, confidence: 0.98, isFiller: false, isDeleted: false },
			{ wordId: 'w5', text: 'đoạn này bị thừa', startMs: 5500, endMs: 7000, confidence: 0.97, isFiller: false, isDeleted: true }, // Deleted text
			{ wordId: 'w6', text: 'kết thúc video', startMs: 8000, endMs: 12000, confidence: 0.99, isFiller: false, isDeleted: false }
		];

		const pauses = [
			{ startMs: 7000, endMs: 8000, durationMs: 1000 } // Pause right after deletion
		];

		// Build cuts removing fillers, pauses and deleted words
		const cuts = buildCutIntervals(words, pauses, true, true, 80);

		// Coalesced cut 1: w2 (1600-2000) and w3 (2050-2400) -> [1600, 2400]
		expect(cuts.some((c) => c.startMs === 1600 && c.endMs === 2400)).toBe(true);

		// Compute retained playback segments
		const timeline = computeRetainedTimeline(totalDurationMs, cuts);

		// Proves zero cumulative drift
		expect(timeline.hasZeroDrift).toBe(true);

		// Sum of retained segments + total time saved = total source duration
		const sumRetained = timeline.retainedSegments.reduce((acc, s) => acc + s.durationMs, 0);
		expect(sumRetained).toBe(timeline.finalDurationMs);
		expect(sumRetained + timeline.timeSavedMs).toBe(totalDurationMs);
	});
});
