// Creativanta Studio — EF01–EF04 Showcase, Image-to-Video, Link-to-Video and Thumbnail helpers

export interface ShowcaseStyleOption {
	id: string;
	name: string;
	description: string;
	minImages: number;
	creditCost: number;
	icon: string;
	badge?: string;
}

export const SHOWCASE_STYLES: ShowcaseStyleOption[] = [
	{
		id: 'lifestyle',
		name: 'Lifestyle Context',
		description: 'Đặt sản phẩm trong bối cảnh đời thực sinh động và gần gũi',
		minImages: 2,
		creditCost: 12,
		icon: '🌿'
	},
	{
		id: 'studio_clean',
		name: 'Studio Clean',
		description: 'Nền studio tối giản, ánh sáng thương mại cao cấp làm nổi bật hình khối',
		minImages: 1,
		creditCost: 10,
		icon: '✨'
	},
	{
		id: 'unboxing',
		name: 'Unboxing Flow',
		description: 'Mô phỏng quy trình mở hộp tinh tế từng lớp bao bì và phụ kiện',
		minImages: 3,
		creditCost: 15,
		icon: '📦'
	},
	{
		id: 'spin_360',
		name: '360° Spin',
		description: 'Xoay toàn cảnh 360 độ mượt mà từ đa góc chụp chân thực',
		minImages: 8,
		creditCost: 20,
		icon: '🔄',
		badge: 'Cần ≥8 ảnh'
	},
	{
		id: 'exploded_view',
		name: 'Exploded View',
		description: 'Tách lớp cấu trúc kỹ thuật và linh kiện tinh xảo bên trong',
		minImages: 4,
		creditCost: 25,
		icon: '🔬',
		badge: 'Kỹ thuật'
	},
	{
		id: 'macro_detail',
		name: 'Macro Detail',
		description: 'Cận cảnh chất liệu vải, bề mặt kim loại hoặc đường may tỉ mỉ',
		minImages: 2,
		creditCost: 10,
		icon: '🔍'
	},
	{
		id: 'comparison',
		name: 'Comparison',
		description: 'So sánh tương phản hiệu năng hoặc trực quan trước và sau',
		minImages: 2,
		creditCost: 15,
		icon: '⚖️'
	},
	{
		id: 'ugc_hands_on',
		name: 'UGC Hands-on',
		description: 'Trải nghiệm cầm nắm thực tế tự nhiên như video người dùng thật',
		minImages: 2,
		creditCost: 12,
		icon: '🤳'
	}
];

export interface MotionStyleOption {
	id: string;
	name: string;
	description: string;
	icon: string;
}

export const MOTION_STYLES: MotionStyleOption[] = [
	{
		id: 'pan_zoom',
		name: 'Pan & Zoom (Ken Burns)',
		description: 'Chuyển động lia máy và phóng to cổ điển mềm mại',
		icon: '🔍'
	},
	{
		id: 'orbit_3d',
		name: '3D Orbit',
		description: 'Quỹ đạo xoay 3 chiều bao quanh chủ thể trung tâm',
		icon: '🪐'
	},
	{
		id: 'dolly_zoom',
		name: 'Dolly Zoom (Vertigo)',
		description: 'Hiệu ứng Vertigo kịch tính làm méo phối cảnh hậu cảnh',
		icon: '🎥'
	},
	{
		id: 'dynamic_action',
		name: 'Dynamic Action',
		description: 'Gia tốc nhanh, nhịp điệu dồn dập dành cho nội dung ngắn',
		icon: '⚡'
	},
	{
		id: 'fluid_morph',
		name: 'Fluid Morph',
		description: 'Biến đổi đường nét mềm mại giữa các khung hình',
		icon: '🌊'
	},
	{
		id: 'parallax_3d',
		name: 'Parallax 3D',
		description: 'Phân tách lớp chiều sâu tiền cảnh và hậu cảnh sống động',
		icon: '👓'
	}
];

export interface MotionPresetOption {
	id: string;
	name: string;
	motionStyle: string;
	durationSeconds: number;
	loopable: boolean;
	description: string;
}

export const MOTION_PRESETS: MotionPresetOption[] = [
	{
		id: 'cinematic',
		name: 'Điện ảnh (Cinematic)',
		motionStyle: 'pan_zoom',
		durationSeconds: 10,
		loopable: false,
		description: 'Lia máy êm ái, phóng to nhẹ nhàng tạo cảm giác cao cấp'
	},
	{
		id: 'social_viral',
		name: 'Viral TikTok / Reels',
		motionStyle: 'dynamic_action',
		durationSeconds: 5,
		loopable: true,
		description: 'Chuyển động giật gân, nhịp nhanh giữ chân người xem 3 giây đầu'
	},
	{
		id: 'product_focus',
		name: 'Tiêu điểm sản phẩm',
		motionStyle: 'parallax_3d',
		durationSeconds: 8,
		loopable: false,
		description: 'Tách chiều sâu làm sản phẩm nổi khối rõ rệt'
	},
	{
		id: 'ambient_loop',
		name: 'Vòng lặp thư thái',
		motionStyle: 'orbit_3d',
		durationSeconds: 6,
		loopable: true,
		description: 'Xoay tròn liền mạch 360 độ hoàn hảo cho ảnh bìa động'
	}
];

export interface ScriptTemplateOption {
	id: string;
	name: string;
	category: string;
	hookTemplate: string;
	bodyTemplate: string;
	ctaTemplate: string;
	description: string;
}

export const SCRIPT_TEMPLATES: ScriptTemplateOption[] = [
	{
		id: 'problem_solution',
		name: 'Vấn đề & Giải pháp',
		category: 'Chuyển đổi cao',
		hookTemplate: 'Bạn có đang gặp phiền toái với {problem} mỗi ngày?',
		bodyTemplate: 'Khám phá ngay {product_name} - cứu tinh giúp bạn khắc phục hoàn toàn với {features}.',
		ctaTemplate: 'Nhấn link ngay hôm nay để nhận ưu đãi đặc biệt {discount}!',
		description: 'Đánh trúng nỗi đau người tiêu dùng rồi đưa ra giải pháp giải tỏa.'
	},
	{
		id: 'feature_roundup',
		name: 'Tổng hợp tính năng',
		category: 'Chi tiết sản phẩm',
		hookTemplate: 'Top 3 điểm vượt trội trên {product_name} khiến ai cũng mê mẩn:',
		bodyTemplate: '1. {feature_1}\n2. {feature_2}\n3. {feature_3}. Tất cả tích hợp trong thiết kế siêu gọn nhẹ.',
		ctaTemplate: 'Trải nghiệm ngay tại giỏ hàng bên dưới!',
		description: 'Liệt kê các điểm ăn tiền nhất của sản phẩm một cách trực quan.'
	},
	{
		id: 'unboxing_review',
		name: 'Mở hộp & Đánh giá',
		category: 'Chân thực UGC',
		hookTemplate: 'Cùng mình unbox xem bên trong hộp {product_name} có gì nha!',
		bodyTemplate: 'Bao bì cực xịn, cầm đầm tay. Chất liệu {material} cùng độ hoàn thiện vượt ngoài mong đợi trong tầm giá {price}.',
		ctaTemplate: 'Xem chi tiết giá và đánh giá tại bio!',
		description: 'Mô phỏng phong cách review tự nhiên của các nhà sáng tạo nội dung.'
	},
	{
		id: 'urgency_promo',
		name: 'Ưu đãi có hạn (Flash Sale)',
		category: 'Thúc đẩy mua',
		hookTemplate: 'Cơ hội duy nhất tháng này: {product_name} đang giảm sốc chỉ còn {price}!',
		bodyTemplate: 'Số lượng chỉ còn đúng 50 suất cuối cùng. Đừng bỏ lỡ giải pháp nâng tầm {benefit}.',
		ctaTemplate: 'Mua ngay trước khi flash sale kết thúc trong 24h tới!',
		description: 'Kích thích tâm lý sợ bỏ lỡ (FOMO) với thời gian và số lượng giới hạn.'
	},
	{
		id: 'story_driven',
		name: 'Kể chuyện cảm xúc',
		category: 'Thương hiệu',
		hookTemplate: 'Có bao giờ bạn tự hỏi điều gì tạo nên sự khác biệt của một sản phẩm tinh tế?',
		bodyTemplate: 'Đó là hàng trăm giờ tâm huyết tỉ mỉ kiến tạo nên {product_name}, gửi gắm trọn vẹn tình yêu và giá trị bền lâu.',
		ctaTemplate: 'Đồng hành cùng hành trình của chúng tôi ngay hôm nay.',
		description: 'Gắn kết người dùng bằng câu chuyện hậu trường và triết lý sản phẩm.'
	}
];

export interface ThumbnailTemplateOption {
	id: string;
	name: string;
	description: string;
	icon: string;
	recommendedFor: string;
}

export const THUMBNAIL_TEMPLATES: ThumbnailTemplateOption[] = [
	{
		id: 'split_screen',
		name: 'Chia đôi khung hình (Split Screen)',
		description: 'So sánh tương phản Trước/Sau hoặc 2 góc nhìn đối nghịch',
		icon: '🌗',
		recommendedFor: 'Video so sánh, biến đổi'
	},
	{
		id: 'face_reaction',
		name: 'Gương mặt biểu cảm (Face Reaction)',
		description: 'Cận cảnh cảm xúc bất ngờ, ngạc nhiên tăng độ tin cậy và tò mò',
		icon: '😲',
		recommendedFor: 'Review, khám phá, thử thách'
	},
	{
		id: 'product_focus',
		name: 'Tiêu điểm sản phẩm (Product Focus)',
		description: 'Sản phẩm đặt giữa trung tâm với ánh sáng viền hào quang nổi bật',
		icon: '💎',
		recommendedFor: 'Bán hàng, giới thiệu công nghệ'
	},
	{
		id: 'curiosity_gap',
		name: 'Khoảng trống tò mò (Curiosity Gap)',
		description: 'Yếu tố che mờ hoặc dấu hỏi kích thích người xem click tìm câu trả lời',
		icon: '❓',
		recommendedFor: 'Bí mật, mẹo vặt, hé lộ'
	},
	{
		id: 'bold_typography',
		name: 'Chữ tiêu đề đậm (Bold Typography)',
		description: 'Chữ to bản tương phản mạnh đọc rõ ngay cả trên màn hình di động nhỏ',
		icon: '🔤',
		recommendedFor: 'Tin tức, hướng dẫn ngắn'
	}
];

export interface CTRFactorScores {
	faceProminence: number;   // 0.0 - 1.0 (weight 30%)
	textLegibility: number;   // 0.0 - 1.0 (weight 25%)
	colorVibrance: number;    // 0.0 - 1.0 (weight 20%)
	composition: number;      // 0.0 - 1.0 (weight 15%)
	trendAlignment: number;   // 0.0 - 1.0 (weight 10%)
}

export interface CTRPredictionResult {
	overallScore: number;     // 0 - 100
	grade: 'high' | 'medium' | 'low';
	gradeColor: string;       // green, yellow, red
	gradeLabel: string;
	breakdown: CTRFactorScores;
	weights: {
		face: number;
		text: number;
		color: number;
		composition: number;
		trend: number;
	};
}

/**
 * Calculates 5-factor mathematical CTR prediction breakdown
 * Weights: face 30%, text 25%, color 20%, composition 15%, trend 10%
 * Color codes: >70% High (Green), 40-70% Medium (Yellow), <40% Low (Red)
 */
export function calculateCTRPrediction(scores: CTRFactorScores): CTRPredictionResult {
	const face = Math.min(1, Math.max(0, scores.faceProminence));
	const text = Math.min(1, Math.max(0, scores.textLegibility));
	const color = Math.min(1, Math.max(0, scores.colorVibrance));
	const comp = Math.min(1, Math.max(0, scores.composition));
	const trend = Math.min(1, Math.max(0, scores.trendAlignment));

	const weighted = 0.30 * face + 0.25 * text + 0.20 * color + 0.15 * comp + 0.10 * trend;
	const overallScore = Math.round(weighted * 100);

	let grade: 'high' | 'medium' | 'low' = 'low';
	let gradeColor = 'text-red-400 bg-red-950/40 border-red-800';
	let gradeLabel = 'Cần cải thiện (<40%)';

	if (overallScore >= 70) {
		grade = 'high';
		gradeColor = 'text-emerald-400 bg-emerald-950/40 border-emerald-800';
		gradeLabel = 'CTR Tiềm năng cao (>70%)';
	} else if (overallScore >= 40) {
		grade = 'medium';
		gradeColor = 'text-amber-400 bg-amber-950/40 border-amber-800';
		gradeLabel = 'CTR Đạt chuẩn (40-70%)';
	}

	return {
		overallScore,
		grade,
		gradeColor,
		gradeLabel,
		breakdown: {
			faceProminence: face,
			textLegibility: text,
			colorVibrance: color,
			composition: comp,
			trendAlignment: trend
		},
		weights: {
			face: 0.30,
			text: 0.25,
			color: 0.20,
			composition: 0.15,
			trend: 0.10
		}
	};
}

export interface AttributeValidationResult {
	hasErrors: boolean;
	hasWarnings: boolean;
	errors: string[];
	warnings: string[];
	isSpin360Blocked: boolean;
}

/**
 * Validates product attributes for Showcase generation
 * Explains missing images (<2 warn, <8 for 360 spin blocks), missing description, missing price
 */
export function validateProductAttributes(product: {
	name?: string;
	description?: string;
	price?: string | number;
	imageUrls?: string[];
	style?: string;
}): AttributeValidationResult {
	const errors: string[] = [];
	const warnings: string[] = [];
	const images = product.imageUrls || [];
	let isSpin360Blocked = false;

	if (!product.name || product.name.trim().length === 0) {
		errors.push('Tên sản phẩm không được để trống');
	}

	if (images.length === 0) {
		errors.push('Chưa có ảnh sản phẩm nào được tải lên');
	} else if (images.length < 2) {
		warnings.push('Cần tối thiểu 2 ảnh sản phẩm chất lượng cao để AI tạo góc nhìn phong phú');
	}

	if (product.style === 'spin_360' && images.length < 8) {
		isSpin360Blocked = true;
		errors.push('Phong cách 360° Spin yêu cầu tối thiểu 8 ảnh từ các góc khác nhau (hiện có ' + images.length + ' ảnh)');
	}

	if (!product.description || product.description.trim().length === 0) {
		warnings.push('Thiếu mô tả sản phẩm: AI sẽ tự suy luận từ hình ảnh và tên, nhưng độ chính xác có thể giảm');
	}

	if (product.price === undefined || product.price === null || product.price === '' || Number(product.price) === 0) {
		warnings.push('Thiếu thông tin giá sản phẩm: Video sẽ không thể hiển thị huy hiệu giá hoặc ưu đãi hấp dẫn');
	}

	return {
		hasErrors: errors.length > 0,
		hasWarnings: warnings.length > 0,
		errors,
		warnings,
		isSpin360Blocked
	};
}

export interface SSRFCheckResult {
	isSafe: boolean;
	isDRM: boolean;
	errorCode?: string;
	errorMessage?: string;
	actionableMessage?: string;
}

/**
 * Client-side preliminary URL safety and DRM checker
 * Blocks SSRF (RFC1918, loopback, cloud metadata) and flags DRM/Geo-blocked domains (EC-M07-R01)
 */
export function checkUrlSafetyClient(urlStr: string): SSRFCheckResult {
	if (!urlStr || urlStr.trim() === '') {
		return {
			isSafe: false,
			isDRM: false,
			errorCode: 'ERR_EMPTY_URL',
			errorMessage: 'URL không được để trống'
		};
	}

	let parsed: URL;
	try {
		parsed = new URL(urlStr.trim());
	} catch {
		return {
			isSafe: false,
			isDRM: false,
			errorCode: 'ERR_INVALID_URL',
			errorMessage: 'Định dạng URL không hợp lệ (cần bắt đầu bằng http:// hoặc https://)'
		};
	}

	if (parsed.protocol !== 'http:' && parsed.protocol !== 'https:') {
		return {
			isSafe: false,
			isDRM: false,
			errorCode: 'ERR_UNSAFE_SCHEME',
			errorMessage: `Giao thức ${parsed.protocol} không được hỗ trợ vì lý do an toàn. Chỉ chấp nhận HTTP/HTTPS.`
		};
	}

	const hostname = parsed.hostname.toLowerCase();

	// Check DRM / Geo-blocked streaming platforms first per EC-M07-R01
	const drmHosts = [
		'netflix.com',
		'disneyplus.com',
		'hulu.com',
		'primevideo.com',
		'hbomax.com',
		'max.com',
		'apple.com/tv',
		'iq.com',
		'wetv.vip'
	];

	for (const drm of drmHosts) {
		if (hostname === drm || hostname.endsWith('.' + drm)) {
			return {
				isSafe: false,
				isDRM: true,
				errorCode: 'ERR_DRM_PROTECTED',
				errorMessage: 'Nội dung tại URL này được bảo vệ bản quyền DRM hoặc giới hạn vùng địa lý',
				actionableMessage: 'Cannot access video at this URL. [Upload video file instead] or [Try different URL].'
			};
		}
	}

	// Block SSRF: localhost, loopback, private networks, cloud metadata
	if (
		hostname === 'localhost' ||
		hostname === '127.0.0.1' ||
		hostname === '::1' ||
		hostname.startsWith('127.') ||
		hostname === '169.254.169.254' ||
		hostname === 'metadata.google.internal' ||
		hostname.endsWith('.localhost') ||
		hostname.endsWith('.internal') ||
		hostname.endsWith('.local')
	) {
		return {
			isSafe: false,
			isDRM: false,
			errorCode: 'ERR_SSRF_BLOCKED',
			errorMessage: 'Địa chỉ IP nội bộ hoặc metadata đám mây bị từ chối vì lý do an ninh (SSRF Protection).'
		};
	}

	// Check private IP IPv4 patterns: 10.x, 192.168.x, 172.16-31.x
	const ipMatch = hostname.match(/^(\d+)\.(\d+)\.(\d+)\.(\d+)$/);
	if (ipMatch) {
		const b0 = parseInt(ipMatch[1], 10);
		const b1 = parseInt(ipMatch[2], 10);
		if (
			b0 === 10 ||
			(b0 === 172 && b1 >= 16 && b1 <= 31) ||
			(b0 === 192 && b1 === 168) ||
			b0 === 127 ||
			(b0 === 169 && b1 === 254) ||
			b0 === 0
		) {
			return {
				isSafe: false,
				isDRM: false,
				errorCode: 'ERR_SSRF_BLOCKED',
				errorMessage: 'Địa chỉ mạng riêng tư bị từ chối truy cập (SSRF Protection).'
			};
		}
	}

	return {
		isSafe: true,
		isDRM: false
	};
}

/**
 * Calculates credit estimate for Image-to-Video
 * Draft: 5, Standard: 10, Premium: 25 (+5 if loopable = 30)
 */
export function estimateImageToVideoCredits(tier: 'draft' | 'standard' | 'premium', isLoop: boolean): number {
	let cost = 10;
	if (tier === 'draft') cost = 5;
	if (tier === 'premium') cost = 25;
	if (isLoop) cost += 5;
	return cost;
}

/**
 * Validates batch products for Showcase (up to 20 items)
 * Valid items are quoted; invalid items are flagged with 0 credit deduction
 */
export function validateShowcaseBatch(items: Array<{
	name: string;
	style: string;
	imageUrls: string[];
	description?: string;
	price?: number;
}>) {
	if (items.length > 20) {
		throw new Error('Số lượng sản phẩm trong một lượt tạo hàng loạt tối đa là 20');
	}

	let totalCredits = 0;
	let validCount = 0;
	let invalidCount = 0;

	const evaluated = items.map((item, index) => {
		const validation = validateProductAttributes(item);
		const styleObj = SHOWCASE_STYLES.find((s) => s.id === item.style) || SHOWCASE_STYLES[0];
		const isValid = !validation.hasErrors;

		const creditCost = isValid ? styleObj.creditCost : 0;
		if (isValid) {
			totalCredits += creditCost;
			validCount++;
		} else {
			invalidCount++;
		}

		return {
			index,
			name: item.name,
			style: item.style,
			isValid,
			creditCost,
			validation
		};
	});

	return {
		totalItems: items.length,
		validCount,
		invalidCount,
		totalCredits,
		items: evaluated
	};
}
