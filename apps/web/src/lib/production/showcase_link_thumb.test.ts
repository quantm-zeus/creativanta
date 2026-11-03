import { describe, it, expect } from 'vitest';
import {
	SHOWCASE_STYLES,
	MOTION_STYLES,
	MOTION_PRESETS,
	SCRIPT_TEMPLATES,
	THUMBNAIL_TEMPLATES,
	calculateCTRPrediction,
	validateProductAttributes,
	checkUrlSafetyClient,
	estimateImageToVideoCredits,
	validateShowcaseBatch
} from './showcase_link_thumb';

describe('Acceptance Target 1: All Listed Styles and Options', () => {
	it('EF-01: supports exactly 8 Showcase styles with credit quotes and minimum image rules', () => {
		expect(SHOWCASE_STYLES).toHaveLength(8);
		const styleIds = SHOWCASE_STYLES.map((s) => s.id);
		expect(styleIds).toEqual([
			'lifestyle',
			'studio_clean',
			'unboxing',
			'spin_360',
			'exploded_view',
			'macro_detail',
			'comparison',
			'ugc_hands_on'
		]);

		const spinStyle = SHOWCASE_STYLES.find((s) => s.id === 'spin_360');
		expect(spinStyle?.minImages).toBe(8);
		expect(spinStyle?.creditCost).toBe(20);
	});

	it('EF-02: supports 6 motion styles + presets and tier credit calculations', () => {
		expect(MOTION_STYLES).toHaveLength(6);
		const motionIds = MOTION_STYLES.map((m) => m.id);
		expect(motionIds).toEqual([
			'pan_zoom',
			'orbit_3d',
			'dolly_zoom',
			'dynamic_action',
			'fluid_morph',
			'parallax_3d'
		]);

		expect(MOTION_PRESETS.length).toBeGreaterThanOrEqual(4);
		expect(estimateImageToVideoCredits('draft', false)).toBe(5);
		expect(estimateImageToVideoCredits('standard', false)).toBe(10);
		expect(estimateImageToVideoCredits('premium', false)).toBe(25);
		expect(estimateImageToVideoCredits('premium', true)).toBe(30);
	});

	it('EF-03: supports 5 thumbnail template styles and 5-factor mathematical CTR prediction breakdown', () => {
		expect(THUMBNAIL_TEMPLATES).toHaveLength(5);
		const templateIds = THUMBNAIL_TEMPLATES.map((t) => t.id);
		expect(templateIds).toEqual([
			'split_screen',
			'face_reaction',
			'product_focus',
			'curiosity_gap',
			'bold_typography'
		]);

		// Test exact mathematical formula: 0.30*face + 0.25*text + 0.20*color + 0.15*comp + 0.10*trend
		// Case A: High CTR > 70%
		// 0.30*0.9 + 0.25*0.8 + 0.20*0.8 + 0.15*0.7 + 0.10*0.7 = 0.27 + 0.20 + 0.16 + 0.105 + 0.07 = 0.805 -> 81%
		const highRes = calculateCTRPrediction({
			faceProminence: 0.9,
			textLegibility: 0.8,
			colorVibrance: 0.8,
			composition: 0.7,
			trendAlignment: 0.7
		});
		expect(highRes.overallScore).toBe(81);
		expect(highRes.grade).toBe('high');
		expect(highRes.gradeColor).toContain('emerald');

		// Case B: Medium CTR 40-70%
		// 0.30*0.5 + 0.25*0.6 + 0.20*0.5 + 0.15*0.5 + 0.10*0.5 = 0.15 + 0.15 + 0.10 + 0.075 + 0.05 = 0.525 -> 53%
		const medRes = calculateCTRPrediction({
			faceProminence: 0.5,
			textLegibility: 0.6,
			colorVibrance: 0.5,
			composition: 0.5,
			trendAlignment: 0.5
		});
		expect(medRes.overallScore).toBe(53);
		expect(medRes.grade).toBe('medium');
		expect(medRes.gradeColor).toContain('amber');

		// Case C: Low CTR < 40%
		// 0.30*0.1 + 0.25*0.2 + 0.20*0.2 + 0.15*0.2 + 0.10*0.2 = 0.03 + 0.05 + 0.04 + 0.03 + 0.02 = 0.17 -> 17%
		const lowRes = calculateCTRPrediction({
			faceProminence: 0.1,
			textLegibility: 0.2,
			colorVibrance: 0.2,
			composition: 0.2,
			trendAlignment: 0.2
		});
		expect(lowRes.overallScore).toBe(17);
		expect(lowRes.grade).toBe('low');
		expect(lowRes.gradeColor).toContain('red');
	});

	it('EF-04: supports 5 link-to-video script templates', () => {
		expect(SCRIPT_TEMPLATES).toHaveLength(5);
		const scriptIds = SCRIPT_TEMPLATES.map((s) => s.id);
		expect(scriptIds).toEqual([
			'problem_solution',
			'feature_roundup',
			'unboxing_review',
			'urgency_promo',
			'story_driven'
		]);
	});
});

describe('Acceptance Target 2: SSRF and Unsafe Source Blocked', () => {
	it('blocks localhost, loopback, private IPs (RFC 1918), and cloud metadata', () => {
		const blockedUrls = [
			'http://localhost:8080/secret',
			'http://127.0.0.1:3000/api',
			'http://10.0.0.1/admin',
			'http://172.16.0.1/dashboard',
			'http://192.168.1.1/router',
			'http://169.254.169.254/latest/meta-data/',
			'ftp://ftp.example.com/file.mp4',
			'file:///etc/passwd'
		];

		for (const u of blockedUrls) {
			const res = checkUrlSafetyClient(u);
			expect(res.isSafe).toBe(false);
		}
	});

	it('detects DRM and geo-blocked domains with actionable error copy per EC-M07-R01', () => {
		const drmUrls = [
			'https://netflix.com/watch/123456',
			'https://disneyplus.com/video/abcdef',
			'https://hulu.com/watch/999'
		];

		for (const u of drmUrls) {
			const res = checkUrlSafetyClient(u);
			expect(res.isSafe).toBe(false);
			expect(res.isDRM).toBe(true);
			expect(res.errorCode).toBe('ERR_DRM_PROTECTED');
			expect(res.actionableMessage).toBe(
				'Cannot access video at this URL. [Upload video file instead] or [Try different URL].'
			);
		}
	});

	it('allows legitimate public e-commerce and web URLs', () => {
		const validUrls = [
			'https://shopee.vn/product/skincare-serum-b5-i.1234.5678',
			'https://tiki.vn/dien-thoai-thong-minh-p12345.html',
			'https://shop.tiktok.com/view/product/123456789'
		];

		for (const u of validUrls) {
			const res = checkUrlSafetyClient(u);
			expect(res.isSafe).toBe(true);
			expect(res.isDRM).toBe(false);
		}
	});
});

describe('Acceptance Target 3: Missing Product Attributes Explained', () => {
	it('explains missing images (< 2 warn, < 8 for 360 spin blocks), missing description, missing price', () => {
		// 1 image, lifestyle style: warns < 2 images, warns missing description, warns missing price
		const res1 = validateProductAttributes({
			name: 'Kem dưỡng ẩm',
			imageUrls: ['https://cdn.example.com/p1.jpg']
		});
		expect(res1.hasErrors).toBe(false);
		expect(res1.hasWarnings).toBe(true);
		expect(res1.warnings.some((w) => w.includes('tối thiểu 2 ảnh'))).toBe(true);
		expect(res1.warnings.some((w) => w.includes('mô tả'))).toBe(true);
		expect(res1.warnings.some((w) => w.includes('giá'))).toBe(true);

		// 360 spin style with 4 images (< 8 images): blocks with error
		const res2 = validateProductAttributes({
			name: 'Đồng hồ cơ',
			style: 'spin_360',
			imageUrls: [
				'https://cdn.example.com/p1.jpg',
				'https://cdn.example.com/p2.jpg',
				'https://cdn.example.com/p3.jpg',
				'https://cdn.example.com/p4.jpg'
			],
			description: 'Đồng hồ cao cấp',
			price: 1500000
		});
		expect(res2.hasErrors).toBe(true);
		expect(res2.isSpin360Blocked).toBe(true);
		expect(res2.errors.some((e) => e.includes('yêu cầu tối thiểu 8 ảnh'))).toBe(true);

		// 360 spin with 8 images: valid
		const res3 = validateProductAttributes({
			name: 'Đồng hồ cơ',
			style: 'spin_360',
			imageUrls: Array.from({ length: 8 }, (_, i) => `https://cdn.example.com/p${i}.jpg`),
			description: 'Đồng hồ cơ chính hãng',
			price: 1500000
		});
		expect(res3.hasErrors).toBe(false);
		expect(res3.isSpin360Blocked).toBe(false);
	});

	it('batch mode validates up to 20 products and flags invalid rows with 0 credit deduction', () => {
		const items = [
			{
				name: 'Sản phẩm 1',
				style: 'studio_clean',
				imageUrls: ['https://cdn.example.com/1.jpg'],
				description: 'Mô tả 1',
				price: 100000
			},
			{
				name: 'Sản phẩm 2 (Lỗi: 360 spin thiếu ảnh)',
				style: 'spin_360',
				imageUrls: ['https://cdn.example.com/2.jpg'],
				description: 'Mô tả 2',
				price: 200000
			},
			{
				name: 'Sản phẩm 3',
				style: 'lifestyle',
				imageUrls: ['https://cdn.example.com/3-1.jpg', 'https://cdn.example.com/3-2.jpg'],
				description: 'Mô tả 3',
				price: 300000
			}
		];

		const batchRes = validateShowcaseBatch(items);
		expect(batchRes.totalItems).toBe(3);
		expect(batchRes.validCount).toBe(2);
		expect(batchRes.invalidCount).toBe(1);
		// Row 1 (studio_clean): 10 credits
		// Row 2 (spin_360 invalid): 0 credits
		// Row 3 (lifestyle): 12 credits
		// Total: 22 credits
		expect(batchRes.totalCredits).toBe(22);
		expect(batchRes.items[1].isValid).toBe(false);
		expect(batchRes.items[1].creditCost).toBe(0);
	});
});
