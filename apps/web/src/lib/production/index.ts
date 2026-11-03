export * from './types';
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
	CopyrightCheckResult
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
		creditCost: 15,
		durationSecs: 30,
		route: '/studio'
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
		description: 'Thiết kế ảnh bìa tỉ lệ click cao dựa trên dữ liệu ngành',
		icon: '✨',
		creditCost: 10,
		durationSecs: 0,
		route: '/studio'
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
