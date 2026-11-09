export * from './types';
export * from './clipfactory';
export * from './showcase_link_thumb';
export { default as BatchBudgetPreviewModal } from './BatchBudgetPreviewModal.svelte';
export { default as ActiveJobsBanner } from './ActiveJobsBanner.svelte';
export { default as LineageInspectionDrawer } from './LineageInspectionDrawer.svelte';
export { default as RemixOriginalityGate } from './RemixOriginalityGate.svelte';

import type {
	ProductionMode,
	BatchItemInput,
	BatchRowValidation,
	BatchBudgetPreview,
	OriginalityCheckResult,
	MultiMergeTimelineItem,
	CopyrightCheckResult,
	CharacterPreviewQuote,
	DriftEvaluationResult
} from './types';

export const PRODUCTION_MODES: ProductionMode[] = [
	{
		id: 'video_gen',
		title: 'AI Video Studio',
		description: 'Tạo video bán hàng và giới thiệu sản phẩm từ kịch bản hoặc văn bản',
		icon: '🎬',
		creditCost: 80,
		durationSecs: 15,
		route: '/studio',
		badge: 'Veo 2.0'
	},
	{
		id: 'image_gen',
		title: 'AI Image Studio',
		description: 'Tạo ảnh sản phẩm chuẩn studio thương mại điện tử',
		icon: '🖼️',
		creditCost: 20,
		durationSecs: 0,
		route: '/studio',
		badge: 'Imagen 3'
	},
	{
		id: 'remix',
		title: 'Video Remix & Multi-Angle',
		description: 'Tái phối hợp video sẵn có thành các biến thể góc quay mới',
		icon: '🔄',
		creditCost: 40,
		durationSecs: 15,
		route: '/studio'
	},
	{
		id: 'clip_factory',
		title: 'Clip Factory (1→N)',
		description: 'Phân tích video dài, tự động trích xuất các clip ngắn viral đa tỷ lệ và bọc CTA',
		icon: '✂️',
		creditCost: 15,
		durationSecs: 60,
		route: '/studio/clip-factory',
		badge: 'W023'
	},
	{
		id: 'avatar',
		title: 'AI Avatar Host',
		description: 'Người dẫn ảo đọc thoại tự nhiên chuẩn khẩu hình và biểu cảm',
		icon: '👤',
		creditCost: 60,
		durationSecs: 15,
		route: '/studio'
	},
	{
		id: 'voiceover',
		title: 'AI Voiceover & Dubbing',
		description: 'Giọng đọc AI lồng tiếng đa ngôn ngữ và cảm xúc chân thực',
		icon: '🎙️',
		creditCost: 15,
		durationSecs: 30,
		route: '/studio'
	},
	{
		id: 'music',
		title: 'AI Sound & BGM Studio',
		description: 'Soạn nhạc nền và hiệu ứng âm thanh bản quyền độc quyền',
		icon: '🎵',
		creditCost: 8,
		durationSecs: 30,
		route: '/studio/sound',
		badge: 'W028'
	},
	{
		id: 'translation',
		title: 'AI Translation & Localization',
		description: 'Dịch thuật video đa ngôn ngữ, khớp khẩu hình lip-sync và thích ứng văn hóa',
		icon: '🌐',
		creditCost: 35,
		durationSecs: 60,
		route: '/studio/translate',
		badge: 'W033'
	},
	{
		id: 'subtitles',
		title: 'AI Subtitle & Caption',
		description: 'Tự động tạo phụ đề động bắt tai và chuẩn thời gian',
		icon: '💬',
		creditCost: 10,
		durationSecs: 60,
		route: '/studio'
	},
	{
		id: 'thumbnail',
		title: 'AI Thumbnail Creator',
		description: 'Thiết kế ảnh bìa tỉ lệ click cao dựa trên dữ liệu ngành và tính điểm CTR 5 nhân tố',
		icon: '✨',
		creditCost: 10,
		durationSecs: 0,
		route: '/studio/thumbnail',
		badge: 'W026 · EF-03'
	},
	{
		id: 'product_showcase',
		title: 'AI Product Showcase',
		description: 'Tạo video giới thiệu sản phẩm 8 phong cách chuẩn e-commerce từ ảnh',
		icon: '🛍️',
		creditCost: 10,
		durationSecs: 15,
		route: '/studio/product-showcase',
		badge: 'W024 · EF-01'
	},
	{
		id: 'image_to_video',
		title: 'Image to Video Studio',
		description: 'Biến ảnh tĩnh thành cảnh quay video sống động với 6 hiệu ứng chuyển động',
		icon: '📸',
		creditCost: 10,
		durationSecs: 10,
		route: '/studio/image-to-video',
		badge: 'W035 · EF-02'
	},
	{
		id: 'link_to_video',
		title: 'Link to Video Studio',
		description: 'Trích xuất tự động sản phẩm từ URL và tạo kịch bản 5 mẫu video viral',
		icon: '🔗',
		creditCost: 15,
		durationSecs: 15,
		route: '/studio/link-to-video',
		badge: 'W036 · EF-04'
	},
	{
		id: 'broll',
		title: 'AI B-Roll Insertion',
		description: 'Chèn cảnh đệm minh họa tự động khớp nội dung thoại',
		icon: '🎞️',
		creditCost: 35,
		durationSecs: 15,
		route: '/studio'
	},
	{
		id: 'batch_gen',
		title: 'Tạo hàng loạt (Batch Studio)',
		description: 'Xử lý danh sách nhiều sản phẩm cùng lúc với kiểm duyệt ngân sách',
		icon: '📦',
		creditCost: 80,
		durationSecs: 15,
		route: '/studio',
		badge: 'Tiết kiệm thời gian'
	},
	{
		id: 'style_learning',
		title: 'AI Style Learning & Transfer',
		description: 'Trích xuất 7 tham số phong cách từ 1-5 video mẫu và tái áp dụng cho dự án (EF-07)',
		icon: '🎨',
		creditCost: 15,
		durationSecs: 0,
		route: '/studio/style-learning',
		badge: 'W032 · EF-07'
	}
];

export function validateBatchInputClient(
	items: BatchItemInput[],
	rateUSD: number = 0.04,
	availableCredits: number = 100
): BatchBudgetPreview {
	const rows: BatchRowValidation[] = items.map((item, idx) => {
		const titleValid = !!item.itemName && item.itemName.trim().length >= 2;
		const promptValid = !!item.prompt && item.prompt.trim().length >= 5;

		let error = '';
		if (!titleValid) {
			error = 'Tên sản phẩm phải có ít nhất 2 ký tự';
		} else if (!promptValid) {
			error = 'Prompt miêu tả phải có ít nhất 5 ký tự';
		}

		const isValid = titleValid && promptValid;
		const costUSD = isValid ? 15 * rateUSD : 0;
		// 80 credits per 15s standard item
		const credits = isValid ? 80 : 0;

		return {
			index: idx,
			itemId: item.itemId || `item-${idx + 1}`,
			itemName: item.itemName,
			isValid,
			validationError: error || undefined,
			estimatedCredits: credits.toString(),
			estimatedCostUSD: costUSD.toFixed(6)
		};
	});

	const validCount = rows.filter((r) => r.isValid).length;
	const invalidCount = rows.filter((r) => !r.isValid).length;
	const totalCreditsNum = validCount * 80;
	const totalCostNum = validCount * 15 * rateUSD;

	return {
		quoteId: `quote-${Date.now()}`,
		quoteExpiresAt: new Date(Date.now() + 5 * 60 * 1000).toISOString(),
		totalItems: items.length,
		validItemsCount: validCount,
		invalidItemsCount: invalidCount,
		totalEstimatedCredits: totalCreditsNum.toString(),
		totalCostCeilingUSD: totalCostNum.toFixed(6),
		currentAvailableCredits: availableCredits.toString(),
		sufficientCredits: availableCredits >= totalCreditsNum,
		items: rows
	};
}

/**
 * Calculates translation quote with multi-language volume discount formula.
 * Formula per screen_web_studio_translation.md §5:
 * base = 20 cr/lang, lip_sync = +10 cr/lang, cultural = +5 cr/lang
 * discount = 10% per additional language (max 30%)
 * total = round(languages * (base + lip_sync + cultural) * (1 - discount))
 */
export function calculateTranslationQuoteClient(
	langsCount: number,
	lipSync: boolean,
	cultural: boolean
): { totalCredits: string; discountPct: number; costPerLanguage: number } {
	if (langsCount <= 0) {
		return { totalCredits: '0', discountPct: 0, costPerLanguage: 0 };
	}

	let costPerLang = 20;
	if (lipSync) costPerLang += 10;
	if (cultural) costPerLang += 5;

	let discountPct = 0;
	if (langsCount > 1) {
		discountPct = (langsCount - 1) * 0.1;
		if (discountPct > 0.3) {
			discountPct = 0.3;
		}
	}

	const gross = langsCount * costPerLang;
	const net = gross * (1.0 - discountPct);
	const total = Math.round(net);

	return {
		totalCredits: total.toString(),
		discountPct,
		costPerLanguage: costPerLang
	};
}

// ----------------------------------------------------------------------------
// Multi-Merge and AI Remix Client Utilities (P4-04)
// ----------------------------------------------------------------------------

export const CANONICAL_SIMILARITY_THRESHOLD = 30.0; // Strictly < 30% per RULE-M07-003

export function validateRemixOriginality(similarityPercentage: number): OriginalityCheckResult {
	const passed = similarityPercentage < CANONICAL_SIMILARITY_THRESHOLD;
	const originalityScore = Math.max(0, 100 - similarityPercentage);

	if (!passed) {
		return {
			similarityPercentage,
			canonicalThresholdPercentage: CANONICAL_SIMILARITY_THRESHOLD,
			originalityScore,
			passed: false,
			explanation: `Remix is too similar to reference (${similarityPercentage.toFixed(1)}% similarity, max ${CANONICAL_SIMILARITY_THRESHOLD}%). [Adjust to 'Loose Inspiration' fidelity] or [Edit script manually].`,
			actionableAlternatives: [
				"Adjust to 'Loose Inspiration' fidelity",
				'Edit script manually',
				'Focus on a different angle or product benefit'
			]
		};
	}

	return {
		similarityPercentage,
		canonicalThresholdPercentage: CANONICAL_SIMILARITY_THRESHOLD,
		originalityScore,
		passed: true,
		explanation: `Passed originality check: ${similarityPercentage.toFixed(1)}% similarity (threshold: <${CANONICAL_SIMILARITY_THRESHOLD}%).`,
		actionableAlternatives: []
	};
}

export function validateReferenceUrlClient(rawUrl: string): {
	isValid: boolean;
	isDRM: boolean;
	isGeoBlocked: boolean;
	errorMessage?: string;
	actionableAdvice?: string;
} {
	const trimmed = (rawUrl || '').trim();
	if (!trimmed) {
		return {
			isValid: false,
			isDRM: false,
			isGeoBlocked: false,
			errorMessage: 'Video URL cannot be empty.',
			actionableAdvice: 'Please paste a valid video URL or upload a file directly.'
		};
	}

	try {
		const u = new URL(trimmed);
		if (u.protocol !== 'http:' && u.protocol !== 'https:') {
			return {
				isValid: false,
				isDRM: false,
				isGeoBlocked: false,
				errorMessage: 'Invalid protocol. Must be HTTP or HTTPS.',
				actionableAdvice: 'Cannot access video at this URL. [Upload video file instead] or [Try different URL].'
			};
		}

		const host = u.hostname.toLowerCase();
		if (
			host === 'localhost' ||
			host === '127.0.0.1' ||
			host.startsWith('10.') ||
			host.startsWith('192.168.') ||
			host.startsWith('169.254.') ||
			host === '::1' ||
			host.endsWith('.local')
		) {
			return {
				isValid: false,
				isDRM: false,
				isGeoBlocked: false,
				errorMessage: 'Access to internal network destinations is forbidden (SSRF protection).',
				actionableAdvice: 'Cannot access video at this URL. [Upload video file instead] or [Try different URL].'
			};
		}

		const lower = trimmed.toLowerCase();
		if (
			lower.includes('drm-protected') ||
			lower.includes('widevine') ||
			lower.includes('fairplay') ||
			lower.includes('playready') ||
			lower.includes('netflix.com') ||
			lower.includes('disneyplus.com') ||
			lower.includes('drm=')
		) {
			return {
				isValid: false,
				isDRM: true,
				isGeoBlocked: false,
				errorMessage: 'Reference video is protected by Digital Rights Management (DRM).',
				actionableAdvice: 'Cannot access video at this URL. [Upload video file instead] or [Try different URL].'
			};
		}

		if (
			lower.includes('geo-blocked') ||
			lower.includes('georestricted') ||
			lower.includes('geo-restricted') ||
			lower.includes('hulu.com') ||
			lower.includes('restricted-region') ||
			lower.includes('blocked-in-country')
		) {
			return {
				isValid: false,
				isDRM: false,
				isGeoBlocked: true,
				errorMessage: 'Reference video is restricted or geo-blocked in the server region.',
				actionableAdvice: 'Cannot access video at this URL. [Upload video file instead] or [Try different URL].'
			};
		}

		return {
			isValid: true,
			isDRM: false,
			isGeoBlocked: false
		};
	} catch {
		return {
			isValid: false,
			isDRM: false,
			isGeoBlocked: false,
			errorMessage: 'Invalid URL format.',
			actionableAdvice: 'Cannot access video at this URL. [Upload video file instead] or [Try different URL].'
		};
	}
}

export function getTierMaxInputs(tier: string): number {
	const t = (tier || '').toLowerCase();
	if (t === 'business' || t === 'enterprise') return 50;
	if (t === 'pro') return 20;
	if (t === 'starter') return 10;
	return 5;
}

export function validateMultiMergeTimelineClient(
	tier: string,
	items: MultiMergeTimelineItem[],
	autoTransitions: boolean = true
): {
	isValid: boolean;
	errors: string[];
	itemsWithTransitions: MultiMergeTimelineItem[];
	copyrightBlocks: CopyrightCheckResult[];
} {
	const errors: string[] = [];
	const copyrightBlocks: CopyrightCheckResult[] = [];

	if (items.length < 2) {
		errors.push(`Multi-merge requires at least 2 media files to merge (received ${items.length}).`);
	}

	const maxInputs = getTierMaxInputs(tier);
	if (items.length > maxInputs) {
		errors.push(`Media count (${items.length}) exceeds workspace tier limit of ${maxInputs} files.`);
	}

	const processed = items.map((item, i) => {
		const copy = { ...item };
		if (!copy.durationSeconds || copy.durationSeconds <= 0) {
			copy.durationSeconds = copy.mediaType === 'image' ? 3.0 : 5.0;
		}

		// Auto-transition logic
		if (autoTransitions && i < items.length - 1) {
			const next = items[i + 1];
			if (!copy.transitionToNext || copy.transitionToNext === 'auto') {
				if (copy.mediaType === 'image' && next.mediaType === 'image') {
					copy.transitionToNext = 'ken_burns';
					copy.transitionDurationSeconds = 0.8;
				} else if (copy.mediaType === 'video' && next.mediaType === 'video') {
					copy.transitionToNext = 'crossfade';
					copy.transitionDurationSeconds = 0.5;
				} else if (copy.mediaType === 'image' && next.mediaType === 'video') {
					copy.transitionToNext = 'fade_in';
					copy.transitionDurationSeconds = 0.5;
				} else {
					copy.transitionToNext = 'cut';
					copy.transitionDurationSeconds = 0.0;
				}
			}
		}

		// Copyright scan (EC-M07-M01, RULE-M07-008, SAFE-2026-02)
		if (copy.hasCopyrightHit || copy.licenseStatus === 'copyrighted_unverified') {
			const hasProof = !!copy.licenseProofKey && copy.licenseProofKey.trim().length > 0;
			if (!hasProof) {
				const block: CopyrightCheckResult = {
					mediaId: copy.assetId,
					mediaTitle: copy.title || 'Copyrighted Audio Track',
					isCopyrighted: true,
					licenseVerified: false,
					passed: false,
					warningMessage: `⚠️ Track "${copy.title}" detected as copyrighted. Confirmed rights violations cannot be bypassed by accepting risk (SAFE-2026-02). [Provide proof of license] or [Replace track].`,
					canBypassRisk: false
				};
				copyrightBlocks.push(block);
				errors.push(block.warningMessage!);
			}
		}

		return copy;
	});

	return {
		isValid: errors.length === 0,
		errors,
		itemsWithTransitions: processed,
		copyrightBlocks
	};
}

/**
 * Calculates a bounded quote for a 15-second character test video preview (Acceptance Target 1).
 */
export function quoteCharacterPreview(
	balance: number,
	durationSeconds: number = 15
): CharacterPreviewQuote {
	const duration = durationSeconds > 0 ? durationSeconds : 15;
	const creditsRequired = '5.000000';
	const cost = 5.0;
	return {
		quoteId: `quote-preview-${Date.now()}`,
		creditsRequired,
		durationSeconds: duration,
		provider: 'veo-preview-fast',
		canAfford: balance >= cost
	};
}

/**
 * Evaluates asset deviation against canonical references (Acceptance Target 2).
 */
export function evaluateDrift(
	assetId: string,
	packId: string,
	driftScore: number
): DriftEvaluationResult {
	let severity: 'none' | 'low_drift' | 'moderate_drift' | 'high_drift' = 'none';
	let isBlocked = false;
	const violationReasons: string[] = [];

	if (driftScore <= 15.0) {
		severity = 'none';
	} else if (driftScore <= 35.0) {
		severity = 'low_drift';
	} else if (driftScore <= 60.0) {
		severity = 'moderate_drift';
	} else {
		severity = 'high_drift';
		isBlocked = true;
		violationReasons.push(`Face similarity index falls below 0.85 threshold (measured score ${driftScore})`);
		violationReasons.push('Style and voice parameters exceed allowable drift tolerance (+14%)');
	}

	return {
		assetId,
		packId,
		packVersion: 1,
		driftScore,
		driftSeverity: severity,
		isBlocked,
		violationReasons,
		violationId: isBlocked ? `viol-${Date.now()}` : undefined
	};
}

/**
 * Enforces high drift readiness blocking gate (Acceptance Target 2 & RULE-M08-005).
 */
export function canApproveAsset(
	driftSeverity: string,
	hasUnresolvedBlockingViolation: boolean
): { canApprove: boolean; blockerMessage?: string } {
	if (driftSeverity === 'high_drift' && hasUnresolvedBlockingViolation) {
		return {
			canApprove: false,
			blockerMessage:
				'Độ lệch chuẩn cao (High drift) chặn xuất bản (RULE-M08-005, AC 4). Cần Quản lý (Manager+) ghi rõ lý do ghi đè để mở khóa.'
		};
	}
	return { canApprove: true };
}

/**
 * Validates style extraction inputs and computes bounded credit quote (EF-07).
 */
export function calculateStyleExtractionQuote(videoCount: number): {
	creditsRequired: number;
	isValid: boolean;
	errorMessage?: string;
} {
	if (videoCount < 1 || videoCount > 5) {
		return {
			creditsRequired: 0,
			isValid: false,
			errorMessage: 'Yêu cầu tải lên từ 1 đến 5 video tham chiếu để trích xuất phong cách (Screen W032).'
		};
	}
	return {
		creditsRequired: 15,
		isValid: true
	};
}

import { callCanonicalRpc, generateIdempotencyKey, type CanonicalRpcOptions } from '$lib/api/client';

function toProtoImageMotionStyle(styleId?: string): string {
	switch ((styleId || '').toLowerCase().trim()) {
		case 'cinematic_pan':
			return 'IMAGE_MOTION_STYLE_CINEMATIC_PAN';
		case 'product_rotate':
			return 'IMAGE_MOTION_STYLE_PRODUCT_ROTATE';
		case 'parallax_3d':
			return 'IMAGE_MOTION_STYLE_PARALLAX_3D';
		case 'subtle_movement':
			return 'IMAGE_MOTION_STYLE_SUBTLE_MOVEMENT';
		case 'zoom_in':
			return 'IMAGE_MOTION_STYLE_ZOOM_IN';
		case 'custom_prompt':
			return 'IMAGE_MOTION_STYLE_CUSTOM_PROMPT';
		case 'ken_burns':
			return 'IMAGE_MOTION_STYLE_KEN_BURNS';
		case 'morph':
			return 'IMAGE_MOTION_STYLE_MORPH';
		case 'random':
			return 'IMAGE_MOTION_STYLE_RANDOM';
		default:
			return 'IMAGE_MOTION_STYLE_CINEMATIC_PAN';
	}
}

export interface ImageToVideoGenerationInput {
	workspaceId?: string;
	title?: string;
	images: Array<{
		id: string;
		url: string;
		name: string;
		durationSeconds: number;
		customMotionStyle?: string;
	}>;
	selectedMotionStyleId: string;
	motionIntensity: number;
	aspectRatio: '9:16' | '16:9' | '1:1';
	selectedTransitionId: string;
	customPrompt?: string;
	qualityTier?: 'draft' | 'standard' | 'premium';
	isLoop?: boolean;
	durationSeconds?: number;
	attachBgm?: boolean;
	quoteCredits: number;
	availableBalance: number;
	quoteId?: string;
	quoteExpiresAt?: string;
	confirmedCredits?: string;
	requirePreflightQuote?: boolean;
}

export interface ImageToVideoQuoteResult {
	ok: boolean;
	quoteId?: string;
	quotedCredits?: string;
	availableCredits?: string;
	sufficientCredits?: boolean;
	quoteExpiresAt?: string;
	error?: string;
}

export interface ImageToVideoGenerationResult {
	ok: boolean;
	jobId?: string;
	quoteId?: string;
	quotedCredits?: string;
	availableCredits?: string;
	quoteExpiresAt?: string;
	requiresConfirmation?: boolean;
	reservedCredits?: number;
	remainingBalance?: number;
	error?: string;
}

function buildImageToVideoGenerateRequest(
	input: ImageToVideoGenerationInput,
	params: {
		idempotencyKey: string;
		dryRun: boolean;
		quoteId?: string;
		confirmedCredits?: string;
	}
): Record<string, unknown> {
	const resolvedTitle =
		(input.title || input.images[0]?.name || 'Image-to-Video Studio').trim() ||
		'Image-to-Video Studio';
	const resolvedPrompt =
		input.customPrompt && input.customPrompt.trim().length >= 5
			? input.customPrompt.trim()
			: `Image-to-Video (${input.selectedMotionStyleId || 'cinematic_pan'}) — ${input.images
					.map((i) => i.name || i.id)
					.join(', ')}`;
	const totalDuration = input.images.reduce((sum, img) => sum + (img.durationSeconds || 0), 0);
	const effectiveDuration =
		typeof input.durationSeconds === 'number' && input.durationSeconds > 0
			? input.durationSeconds
			: totalDuration;

	return {
		context: {
			workspace_id: { value: input.workspaceId || '' },
			idempotency_key: params.idempotencyKey
		},
		title: resolvedTitle,
		mode: 'PRODUCTION_MODE_IMAGE_TO_VIDEO',
		prompt: resolvedPrompt,
		post_production: {
			aspect_ratio: input.aspectRatio,
			normalize_audio: true,
			target_lufs: -14
		},
		dry_run: params.dryRun,
		quote_id: params.quoteId || '',
		confirmed_credits: params.confirmedCredits || String(input.quoteCredits),
		image_to_video_config: {
			image_urls: input.images.map((img) => img.url),
			per_image_settings: input.images.map((img) => ({
				image_url: img.url,
				duration_seconds: img.durationSeconds,
				motion_style: toProtoImageMotionStyle(img.customMotionStyle || input.selectedMotionStyleId),
				focal_point: 'center'
			})),
			default_motion_style: toProtoImageMotionStyle(input.selectedMotionStyleId),
			duration_seconds: effectiveDuration,
			loop_friendly: Boolean(input.isLoop),
			auto_music_sync: input.attachBgm ?? true,
			transition_type: input.selectedTransitionId,
			transition_duration: 0.5,
			aspect_ratio: input.aspectRatio,
			quality_tier: input.qualityTier || 'standard'
		}
	};
}

/**
 * Requests a bounded server quote for Image-to-Video via
 * `creativanta.production.v1.AssetService/Generate` (`dry_run: true`).
 */
export async function requestImageToVideoQuoteRemote(
	input: ImageToVideoGenerationInput,
	options: CanonicalRpcOptions = {}
): Promise<ImageToVideoQuoteResult> {
	const idemKey = options.idempotencyKey || generateIdempotencyKey('i2v-quote');
	const rpcRes = await callCanonicalRpc<
		Record<string, unknown>,
		{
			is_dry_run?: boolean;
			isDryRun?: boolean;
			budget_preview?: Record<string, any>;
			budgetPreview?: Record<string, any>;
		}
	>(
		'creativanta.production.v1.AssetService/Generate',
		buildImageToVideoGenerateRequest(input, {
			idempotencyKey: idemKey,
			dryRun: true
		}),
		{
			...options,
			idempotencyKey: idemKey,
			workspaceId: options.workspaceId ?? input.workspaceId
		}
	);

	if (!rpcRes.ok) {
		return {
			ok: false,
			error: rpcRes.error.message
		};
	}

	const preview = rpcRes.data?.budget_preview || rpcRes.data?.budgetPreview;
	const quoteId = String(preview?.quote_id || preview?.quoteId || '').trim();
	const rawQuotedCredits = String(
		preview?.total_estimated_credits ??
			preview?.totalEstimatedCredits ??
			preview?.quoted_credits ??
			preview?.quotedCredits ??
			''
	).trim();
	const availableCredits = String(
		preview?.current_available_credits ??
			preview?.currentAvailableCredits ??
			preview?.available_credits ??
			preview?.availableCredits ??
			''
	).trim();
	const sufficient = preview?.sufficient_credits ?? preview?.sufficientCredits ?? true;

	if (!quoteId) {
		return {
			ok: false,
			error: 'Phản hồi báo giá từ máy chủ thiếu quote_id hợp lệ (fail-closed).'
		};
	}

	const quotedCreditsNum = Number(rawQuotedCredits);
	if (!rawQuotedCredits || !Number.isFinite(quotedCreditsNum) || quotedCreditsNum <= 0) {
		return {
			ok: false,
			quoteId,
			error: 'Phản hồi báo giá từ máy chủ thiếu total_estimated_credits hợp lệ (fail-closed).'
		};
	}

	const availableCreditsNum = availableCredits !== '' ? Number(availableCredits) : NaN;
	if (
		sufficient === false ||
		(Number.isFinite(availableCreditsNum) && quotedCreditsNum > availableCreditsNum)
	) {
		return {
			ok: false,
			quoteId,
			quotedCredits: rawQuotedCredits,
			availableCredits,
			sufficientCredits: false,
			error: 'Số dư credits trên máy chủ không đủ để thực hiện tác vụ này (fail-closed).'
		};
	}

	return {
		ok: true,
		quoteId,
		quotedCredits: rawQuotedCredits,
		availableCredits,
		sufficientCredits: true,
		quoteExpiresAt: String(preview?.quote_expires_at ?? preview?.quoteExpiresAt ?? '')
	};
}

/**
 * Dispatches an Image-to-Video generation request to canonical
 * `creativanta.production.v1.AssetService/Generate` (UF-05).
 * Never subtracts credits locally or invents a fake job ID when unauthenticated
 * or when backend reservation/dispatch fails.
 */
export async function requestImageToVideoGenerationRemote(
	input: ImageToVideoGenerationInput,
	options: CanonicalRpcOptions = {}
): Promise<ImageToVideoGenerationResult> {
	if (!input.images || input.images.length === 0) {
		return {
			ok: false,
			error: 'Vui lòng thêm ít nhất 1 ảnh'
		};
	}

	if (input.images.length > 10) {
		return {
			ok: false,
			error: 'Tối đa 10 ảnh cho mỗi lần tạo Image-to-Video (Screen W035)'
		};
	}

	if (input.availableBalance < input.quoteCredits) {
		return {
			ok: false,
			error: 'Số dư credits không đủ'
		};
	}

	let activeQuoteId = (input.quoteId || '').trim();
	let activeConfirmedCredits = (input.confirmedCredits || String(input.quoteCredits)).trim();
	const consentedCreditsNum = Number(activeConfirmedCredits);

	if (!Number.isFinite(consentedCreditsNum) || consentedCreditsNum <= 0) {
		return {
			ok: false,
			error: 'Mức credits xác nhận không hợp lệ (fail-closed).'
		};
	}

	if (consentedCreditsNum > input.availableBalance) {
		return {
			ok: false,
			error: 'Số dư credits không đủ'
		};
	}

	if (consentedCreditsNum < input.quoteCredits) {
		return {
			ok: false,
			requiresConfirmation: true,
			quoteId: activeQuoteId || undefined,
			quotedCredits: String(input.quoteCredits),
			quoteExpiresAt: input.quoteExpiresAt,
			error: `Mức credits xác nhận (${consentedCreditsNum} cr) thấp hơn báo giá yêu cầu (${input.quoteCredits} cr). Vui lòng xác nhận lại trước khi tiếp tục.`
		};
	}

	if (input.quoteExpiresAt && input.quoteExpiresAt.trim().length > 0) {
		const expMs = Date.parse(input.quoteExpiresAt.trim());
		if (Number.isFinite(expMs) && expMs < Date.now()) {
			return {
				ok: false,
				error: 'Báo giá từ máy chủ đã hết hạn. Vui lòng lấy báo giá mới trước khi tạo video (fail-closed).'
			};
		}
	}

	if (!activeQuoteId && input.requirePreflightQuote) {
		const quoteRes = await requestImageToVideoQuoteRemote(input, {
			...options,
			idempotencyKey: generateIdempotencyKey('i2v-quote')
		});
		if (!quoteRes.ok || !quoteRes.quoteId || !quoteRes.quotedCredits) {
			return {
				ok: false,
				quoteId: quoteRes.quoteId,
				quotedCredits: quoteRes.quotedCredits,
				availableCredits: quoteRes.availableCredits,
				error: quoteRes.error || 'Không thể lấy báo giá (quote_id) từ máy chủ (fail-closed).'
			};
		}

		const serverQuotedNum = Number(quoteRes.quotedCredits);
		if (!Number.isFinite(serverQuotedNum) || serverQuotedNum <= 0) {
			return {
				ok: false,
				quoteId: quoteRes.quoteId,
				error: 'Báo giá từ máy chủ không hợp lệ (fail-closed).'
			};
		}

		if (serverQuotedNum > input.availableBalance) {
			return {
				ok: false,
				quoteId: quoteRes.quoteId,
				quotedCredits: quoteRes.quotedCredits,
				availableCredits: quoteRes.availableCredits,
				error: 'Số dư credits không đủ theo báo giá từ máy chủ (fail-closed).'
			};
		}

		if (serverQuotedNum > consentedCreditsNum) {
			return {
				ok: false,
				requiresConfirmation: true,
				quoteId: quoteRes.quoteId,
				quotedCredits: quoteRes.quotedCredits,
				availableCredits: quoteRes.availableCredits,
				quoteExpiresAt: quoteRes.quoteExpiresAt,
				error: `Báo giá thực tế từ máy chủ (${quoteRes.quotedCredits} cr) cao hơn mức dự kiến (${consentedCreditsNum} cr). Vui lòng xác nhận trước khi trừ credits.`
			};
		}

		activeQuoteId = quoteRes.quoteId;
		activeConfirmedCredits = quoteRes.quotedCredits;
	}

	const idemKey = options.idempotencyKey || generateIdempotencyKey('i2v-gen');
	const rpcRes = await callCanonicalRpc<
		Record<string, unknown>,
		{
			job_id?: string;
			jobId?: string;
			job?: Record<string, any>;
			reserved_credits?: number | string;
			reservedCredits?: number | string;
			remaining_balance?: number | string;
			remainingBalance?: number | string;
		}
	>(
		'creativanta.production.v1.AssetService/Generate',
		buildImageToVideoGenerateRequest(input, {
			idempotencyKey: idemKey,
			dryRun: false,
			quoteId: activeQuoteId,
			confirmedCredits: activeConfirmedCredits
		}),
		{
			...options,
			idempotencyKey: idemKey,
			workspaceId: options.workspaceId ?? input.workspaceId
		}
	);

	if (!rpcRes.ok) {
		return {
			ok: false,
			error: rpcRes.error.message
		};
	}

	const jobObj = rpcRes.data?.job;
	const jobId = String(
		rpcRes.data?.job_id ||
			rpcRes.data?.jobId ||
			jobObj?.job_id ||
			jobObj?.jobId ||
			''
	).trim();
	if (!jobId) {
		return {
			ok: false,
			error: 'Phản hồi từ máy chủ thiếu mã tác vụ job_id (fail-closed). Không trừ credits.'
		};
	}

	const rawReserved =
		rpcRes.data?.reserved_credits ??
		rpcRes.data?.reservedCredits ??
		jobObj?.reserved_credits ??
		jobObj?.reservedCredits ??
		jobObj?.estimated_credits ??
		jobObj?.estimatedCredits ??
		activeConfirmedCredits;
	const parsedReserved = Number(rawReserved);
	const reserved = Number.isFinite(parsedReserved) && parsedReserved > 0 ? parsedReserved : input.quoteCredits;

	const rawRemaining = rpcRes.data?.remaining_balance ?? rpcRes.data?.remainingBalance;
	const parsedRemaining = rawRemaining !== undefined ? Number(rawRemaining) : NaN;
	const remaining = Number.isFinite(parsedRemaining)
		? parsedRemaining
		: Math.max(0, input.availableBalance - reserved);

	return {
		ok: true,
		jobId,
		quoteId: activeQuoteId || String(jobObj?.quote_id || jobObj?.quoteId || ''),
		reservedCredits: reserved,
		remainingBalance: remaining
	};
}

export interface CancelStudioJobResult {
	ok: boolean;
	jobId?: string;
	status?: string;
	creditsRefunded?: boolean;
	refundedCredits?: number;
	error?: string;
}

/**
 * Cancels an in-flight studio job via `creativanta.production.v1.StudioService/Cancel`.
 * Fails closed without mutating local job status or credit balance when backend fails
 * or does not confirm cancellation.
 */
export async function cancelStudioJobRemote(
	params: { workspaceId?: string; jobId: string },
	options: CanonicalRpcOptions = {}
): Promise<CancelStudioJobResult> {
	const jobId = (params.jobId || '').trim();
	if (!jobId) {
		return {
			ok: false,
			error: 'Thiếu mã tiến trình (job_id) cần hủy.'
		};
	}

	const idemKey = options.idempotencyKey || generateIdempotencyKey('studio-cancel');
	const rpcRes = await callCanonicalRpc<
		Record<string, unknown>,
		{
			job?: Record<string, any>;
			credits_refunded?: boolean;
			creditsRefunded?: boolean;
			refunded_credits?: string | number;
			refundedCredits?: string | number;
		}
	>(
		'creativanta.production.v1.StudioService/Cancel',
		{
			context: {
				workspace_id: { value: params.workspaceId || '' },
				idempotency_key: idemKey
			},
			job_id: jobId
		},
		{
			...options,
			idempotencyKey: idemKey,
			workspaceId: options.workspaceId ?? params.workspaceId
		}
	);

	if (!rpcRes.ok) {
		return {
			ok: false,
			error: rpcRes.error.message
		};
	}

	const jobObj = rpcRes.data?.job;
	const confirmedJobId = String(jobObj?.job_id || jobObj?.jobId || '').trim();
	const confirmedStatus = String(jobObj?.status || '')
		.trim()
		.toLowerCase();

	if (!confirmedJobId || (confirmedStatus && !confirmedStatus.includes('cancel'))) {
		return {
			ok: false,
			error: 'Phản hồi từ máy chủ không xác nhận trạng thái đã hủy (fail-closed).'
		};
	}

	const creditsRefunded = Boolean(
		rpcRes.data?.credits_refunded ?? rpcRes.data?.creditsRefunded ?? false
	);
	const rawRefunded = rpcRes.data?.refunded_credits ?? rpcRes.data?.refundedCredits ?? 0;
	const parsedRefunded = Number(rawRefunded);
	const refundedCredits =
		creditsRefunded && Number.isFinite(parsedRefunded) && parsedRefunded > 0 ? parsedRefunded : 0;

	return {
		ok: true,
		jobId: confirmedJobId,
		status: 'cancelled',
		creditsRefunded,
		refundedCredits
	};
}

export interface RetryStudioJobResult {
	ok: boolean;
	jobId?: string;
	status?: 'queued' | 'processing' | 'completed' | 'failed' | 'cancelled';
	provider?: 'veo' | 'kling';
	stage?: string;
	progressPct?: number;
	message?: string;
	error?: string;
}

/**
 * Retries a failed studio job via `creativanta.production.v1.StudioService/Retry`.
 * Fails closed without mutating local job status when the backend call fails.
 */
export async function retryStudioJobRemote(
	params: { workspaceId?: string; jobId: string; useFallbackProvider?: boolean },
	options: CanonicalRpcOptions = {}
): Promise<RetryStudioJobResult> {
	const jobId = (params.jobId || '').trim();
	if (!jobId) {
		return {
			ok: false,
			error: 'Thiếu mã tiến trình (job_id) cần thử lại.'
		};
	}

	const idemKey = options.idempotencyKey || generateIdempotencyKey('studio-retry');
	const rpcRes = await callCanonicalRpc<
		Record<string, unknown>,
		{
			job?: Record<string, any>;
			message?: string;
		}
	>(
		'creativanta.production.v1.StudioService/Retry',
		{
			context: {
				workspace_id: { value: params.workspaceId || '' },
				idempotency_key: idemKey
			},
			job_id: jobId,
			use_fallback_provider: params.useFallbackProvider ?? true
		},
		{
			...options,
			idempotencyKey: idemKey,
			workspaceId: options.workspaceId ?? params.workspaceId
		}
	);

	if (!rpcRes.ok) {
		return {
			ok: false,
			error: rpcRes.error.message
		};
	}

	const jobObj = rpcRes.data?.job;
	const confirmedJobId = String(jobObj?.job_id || jobObj?.jobId || '').trim();
	if (!confirmedJobId) {
		return {
			ok: false,
			error: 'Phản hồi từ máy chủ thiếu thông tin tiến trình thử lại (job_id, fail-closed).'
		};
	}

	const rawStatus = String(jobObj?.status || 'processing').toLowerCase();
	const status: RetryStudioJobResult['status'] = rawStatus.includes('queue')
		? 'queued'
		: rawStatus.includes('complete')
			? 'completed'
			: rawStatus.includes('fail')
				? 'failed'
				: 'processing';
	const provider: 'veo' | 'kling' =
		String(jobObj?.provider || '').toLowerCase() === 'veo' ? 'veo' : 'kling';

	return {
		ok: true,
		jobId: confirmedJobId,
		status,
		provider,
		stage: String(jobObj?.current_step || jobObj?.currentStep || 'Submitting to provider'),
		progressPct: Number(jobObj?.progress_pct ?? jobObj?.progressPct ?? 15),
		message: rpcRes.data?.message
	};
}
