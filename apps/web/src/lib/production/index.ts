export * from './types';
export { default as BatchBudgetPreviewModal } from './BatchBudgetPreviewModal.svelte';
export { default as ActiveJobsBanner } from './ActiveJobsBanner.svelte';
export { default as LineageInspectionDrawer } from './LineageInspectionDrawer.svelte';

import type { ProductionMode, BatchItemInput, BatchRowValidation, BatchBudgetPreview } from './types';

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
