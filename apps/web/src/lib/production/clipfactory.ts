// Creativanta - Clip Factory (1→N Mode 2, M07 — AI Video Studio)
// Canonical Source: docs/02_features/production/ai_video_studio.md §Mode 2
//                   docs/04_contracts/database_schema.md §22.3
//                   docs/04_contracts/api_endpoint_map.md §7.3

export interface ViralityScoreBreakdown {
	engagementPrediction: number; // 0.0 - 100.0
	hookStrength: number;         // 0.0 - 100.0
	pacingScore: number;          // 0.0 - 100.0
	audioEnergy: number;          // 0.0 - 100.0
	contentRelevance: number;     // 0.0 - 100.0 (0.0 if missing trend data)
	compositeScore: number;       // Weighted score 0.0 - 100.0
	hasTrendData: boolean;
	scoreBadge: string;           // "⚠️ Pattern-only" when hasTrendData is false
}

export type HookType = 'speech_hook' | 'visual_hook';

export interface ClipProposal {
	clipId: string;
	startS: number;
	endS: number;
	durationS: number;
	title: string;
	hookType: HookType;
	hookDescription: string;
	viralityScore: ViralityScoreBreakdown;
	transcriptSnippet?: string;
	thumbnailUrl?: string;
	selected?: boolean;
}

export interface ClipVariantConfig {
	clipId: string;
	targetRatios: string[];       // e.g. ['9:16', '16:9', '1:1']
	subtitleFirst: boolean;
	ctaText?: string;
	generateHighlightReel: boolean;
	targetPlatforms: string[];    // e.g. ['tiktok', 'reels', 'shorts']
}

export interface ProcessedClipOutput {
	outputAssetId: string;
	clipId: string;
	ratio: string;
	title: string;
	durationS: number;
	videoUrl: string;
	lineageJson: string;
	isHighlightReel: boolean;
	ctaApplied: boolean;
	audioLufs: number;            // Must be -14.0 LUFS
}

export interface ClipCollection {
	collectionId: string;
	workspaceId: string;
	sourceAssetId: string;
	sourceTitle: string;
	clips: ClipProposal[];
	status: 'analyzing' | 'ready' | 'processing' | 'completed' | 'failed';
	totalDurationS: number;
	createdAt: string;
}

export const CANONICAL_PATTERN_ONLY_BADGE = '⚠️ Pattern-only';
export const CANONICAL_AUDIO_LUFS = -14.0;

/**
 * Calculates virality score with 5-dimension weights per Mode 2 spec:
 * Composite = 0.30*engagement + 0.25*hook + 0.20*pacing + 0.15*audio + 0.10*relevance.
 *
 * Acceptance Target 2: If trend data is missing or unverified,
 * contentRelevance is set to 0.0 and score badge MUST be labeled "⚠️ Pattern-only".
 */
export function calculateViralityScore(
	engagement: number,
	hook: number,
	pacing: number,
	audio: number,
	relevance: number,
	hasTrendData: boolean
): ViralityScoreBreakdown {
	const clampedEngagement = Math.max(0, Math.min(100, engagement));
	const clampedHook = Math.max(0, Math.min(100, hook));
	const clampedPacing = Math.max(0, Math.min(100, pacing));
	const clampedAudio = Math.max(0, Math.min(100, audio));
	const clampedRelevance = hasTrendData ? Math.max(0, Math.min(100, relevance)) : 0.0;

	const composite =
		0.3 * clampedEngagement +
		0.25 * clampedHook +
		0.2 * clampedPacing +
		0.15 * clampedAudio +
		0.1 * clampedRelevance;

	const roundedComposite = Math.round(composite * 10) / 10;

	let badge: string;
	if (!hasTrendData) {
		badge = CANONICAL_PATTERN_ONLY_BADGE;
	} else if (roundedComposite >= 85) {
		badge = '🔥 Viral Candidate';
	} else if (roundedComposite >= 70) {
		badge = '⚡ High Potential';
	} else {
		badge = 'Standard';
	}

	return {
		engagementPrediction: clampedEngagement,
		hookStrength: clampedHook,
		pacingScore: clampedPacing,
		audioEnergy: clampedAudio,
		contentRelevance: clampedRelevance,
		compositeScore: roundedComposite,
		hasTrendData,
		scoreBadge: badge
	};
}

/**
 * Acceptance Target 1 (EC-M07-C01):
 * When video has no speech or transcript is empty, fallback to visual scene
 * detection + beat analysis. Hook strength uses visual hook pattern instead of speech.
 */
export function deriveHookStrategy(
	hasSpeech: boolean,
	transcriptSnippet: string | undefined,
	visualBeatPattern: string = 'Dynamic motion & scene cut beat'
): { hookType: HookType; hookDescription: string; hookStrengthScore: number } {
	const cleaned = (transcriptSnippet || '').trim();
	if (!hasSpeech || cleaned.length === 0) {
		return {
			hookType: 'visual_hook',
			hookDescription: `Visual hook: ${visualBeatPattern}`,
			hookStrengthScore: 82.0
		};
	}

	return {
		hookType: 'speech_hook',
		hookDescription: `Speech hook: "${cleaned.length > 50 ? cleaned.slice(0, 47) + '...' : cleaned}"`,
		hookStrengthScore: 88.0
	};
}

/**
 * Acceptance Target 3: Source lineage builder.
 * Every extracted clip records parent source asset ID, timecodes, aspect ratio,
 * -14.0 LUFS audio normalization compliance, and JSON provenance.
 */
export function buildClipLineagePayload(
	sourceAssetId: string,
	clipId: string,
	startS: number,
	endS: number,
	ratio: string,
	hasTrendData: boolean,
	ctaText?: string
): Record<string, unknown> {
	return {
		parent_id: sourceAssetId,
		source_asset_id: sourceAssetId,
		clip_id: clipId,
		derivative_type: 'clip',
		aspect_ratio: ratio,
		timecodes: {
			start_s: startS,
			end_s: endS,
			duration_s: Math.round((endS - startS) * 100) / 100
		},
		audio_lufs: CANONICAL_AUDIO_LUFS,
		audio_normalized: true,
		trend_data_included: hasTrendData,
		cta_overlay: ctaText && ctaText.trim().length > 0 ? ctaText.trim() : null,
		extracted_at: new Date().toISOString()
	};
}

/**
 * Concurrency limits by workspace tier per EC-M07-004
 */
export function getTierMaxConcurrentClipJobs(tier: string): number {
	switch (tier.toLowerCase()) {
		case 'free':
			return 1;
		case 'starter':
			return 2;
		case 'pro':
			return 5;
		case 'business':
		case 'enterprise':
			return 10;
		default:
			return 2;
	}
}
