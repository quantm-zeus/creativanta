import { describe, it, expect } from 'vitest';
import {
	calculateViralityScore,
	deriveHookStrategy,
	buildClipLineagePayload,
	getTierMaxConcurrentClipJobs,
	CANONICAL_PATTERN_ONLY_BADGE,
	CANONICAL_AUDIO_LUFS
} from './clipfactory';

describe('Clip Factory Web (W023) - Acceptance Targets', () => {
	// ========================================================================
	// Acceptance Target 1: No speech uses visual path (EC-M07-C01)
	// ========================================================================
	it('Acceptance Target 1: Falls back to visual scene detection and beat pattern when speech is absent', () => {
		// Case A: No speech at all (music or silent video)
		const visualResult1 = deriveHookStrategy(false, '', 'Fast cut intro with bass drop');
		expect(visualResult1.hookType).toBe('visual_hook');
		expect(visualResult1.hookDescription).toContain('Fast cut intro with bass drop');
		expect(visualResult1.hookStrengthScore).toBeGreaterThan(70);

		// Case B: hasSpeech is true but transcript is empty or whitespace
		const visualResult2 = deriveHookStrategy(true, '   ', 'Dynamic product reveal motion');
		expect(visualResult2.hookType).toBe('visual_hook');
		expect(visualResult2.hookDescription).toContain('Dynamic product reveal motion');

		// Case C: Real speech present
		const speechResult = deriveHookStrategy(true, 'Bí quyết giúp bạn nhân 10 doanh số bán hàng trong 30 ngày');
		expect(speechResult.hookType).toBe('speech_hook');
		expect(speechResult.hookDescription).toContain('Bí quyết giúp bạn nhân 10');
	});

	// ========================================================================
	// Acceptance Target 2: Missing trend data labeled
	// ========================================================================
	it('Acceptance Target 2: Labels virality scores without trend data as "⚠️ Pattern-only" badge', () => {
		// Case A: Missing trend data
		const scoreNoTrend = calculateViralityScore(90, 85, 80, 75, 95, false);
		expect(scoreNoTrend.hasTrendData).toBe(false);
		expect(scoreNoTrend.contentRelevance).toBe(0.0);
		expect(scoreNoTrend.scoreBadge).toBe(CANONICAL_PATTERN_ONLY_BADGE);
		expect(scoreNoTrend.scoreBadge).toBe('⚠️ Pattern-only');

		// Case B: With verified trend data from M02/M03
		const scoreWithTrend = calculateViralityScore(90, 85, 80, 75, 95, true);
		expect(scoreWithTrend.hasTrendData).toBe(true);
		expect(scoreWithTrend.contentRelevance).toBe(95);
		expect(scoreWithTrend.scoreBadge).not.toBe(CANONICAL_PATTERN_ONLY_BADGE);
		expect(scoreWithTrend.scoreBadge).toBe('🔥 Viral Candidate');
	});

	// ========================================================================
	// Acceptance Target 3: Each clip has source lineage
	// ========================================================================
	it('Acceptance Target 3: Builds robust source lineage payload referencing parent asset and audio standard', () => {
		const sourceAssetId = 'asset-long-interview-1080p';
		const clipId = 'clip-part-1';
		const startS = 42.5;
		const endS = 98.2;
		const ratio = '9:16';
		const ctaText = 'Follow để xem phần tiếp theo!';

		const lineage = buildClipLineagePayload(sourceAssetId, clipId, startS, endS, ratio, true, ctaText);

		// Lineage checks
		expect(lineage.parent_id).toBe(sourceAssetId);
		expect(lineage.source_asset_id).toBe(sourceAssetId);
		expect(lineage.clip_id).toBe(clipId);
		expect(lineage.derivative_type).toBe('clip');
		expect(lineage.aspect_ratio).toBe('9:16');
		expect((lineage.timecodes as { start_s: number }).start_s).toBe(42.5);
		expect((lineage.timecodes as { end_s: number }).end_s).toBe(98.2);
		expect((lineage.timecodes as { duration_s: number }).duration_s).toBe(55.7);

		// Audio normalization check (-14.0 LUFS per AC-5)
		expect(lineage.audio_lufs).toBe(CANONICAL_AUDIO_LUFS);
		expect(lineage.audio_lufs).toBe(-14.0);
		expect(lineage.audio_normalized).toBe(true);

		// CTA check
		expect(lineage.cta_overlay).toBe('Follow để xem phần tiếp theo!');
		expect(typeof lineage.extracted_at).toBe('string');
	});

	// ========================================================================
	// Tier Concurrency Limits (EC-M07-004)
	// ========================================================================
	it('Enforces tier-based concurrent clip extraction limits', () => {
		expect(getTierMaxConcurrentClipJobs('Free')).toBe(1);
		expect(getTierMaxConcurrentClipJobs('Starter')).toBe(2);
		expect(getTierMaxConcurrentClipJobs('Pro')).toBe(5);
		expect(getTierMaxConcurrentClipJobs('Business')).toBe(10);
		expect(getTierMaxConcurrentClipJobs('Enterprise')).toBe(10);
	});
});
