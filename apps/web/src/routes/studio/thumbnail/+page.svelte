<script lang="ts">
	import {
		THUMBNAIL_TEMPLATES,
		calculateCTRPrediction,
		type ThumbnailTemplateOption,
		type CTRPredictionResult,
		type CTRFactorScores
	} from '$lib/production';

	interface ThumbnailVariantCard {
		id: string;
		title: string;
		templateStyle: string;
		headline: string;
		imageUrl: string;
		factorScores: CTRFactorScores;
		ctrPrediction: CTRPredictionResult;
		selected: boolean;
	}

	let sourceImage = 'https://cdn.example.com/thumbnails/source_frame_4k.jpg';
	let headlineText = 'BÍ QUYẾT BÁN 1000 ĐƠN TRONG 24H';
	let fontFamily = 'Anton';
	let fontSize = 'large';
	let textColor = '#FACC15'; // Yellow
	let outlineColor = '#000000';
	let textPosition = 'bottom';
	let hasDropShadow = true;
	let userBalance = 240;
	let quoteCredits = 10;
	let isGenerating = false;
	let successNotification = '';

	// 3 thumbnail variants generated
	let variants: ThumbnailVariantCard[] = [
		{
			id: 'var-01',
			title: 'Biến thể A: Gương mặt biểu cảm cao',
			templateStyle: 'face_reaction',
			headline: 'BÍ QUYẾT BÁN 1000 ĐƠN!',
			imageUrl: 'https://cdn.example.com/thumbnails/variant_face_a.jpg',
			factorScores: {
				faceProminence: 0.95, // 0.95 * 0.30 = 0.285
				textLegibility: 0.88, // 0.88 * 0.25 = 0.220
				colorVibrance: 0.82,  // 0.82 * 0.20 = 0.164
				composition: 0.85,    // 0.85 * 0.15 = 0.1275
				trendAlignment: 0.80  // 0.80 * 0.10 = 0.080 -> total = 0.8765 ~ 88% (High Green)
			},
			ctrPrediction: calculateCTRPrediction({
				faceProminence: 0.95,
				textLegibility: 0.88,
				colorVibrance: 0.82,
				composition: 0.85,
				trendAlignment: 0.80
			}),
			selected: true
		},
		{
			id: 'var-02',
			title: 'Biến thể B: Tiêu điểm sản phẩm & Chữ đậm',
			templateStyle: 'product_focus',
			headline: '1000 ĐƠN / 24 GIỜ?',
			imageUrl: 'https://cdn.example.com/thumbnails/variant_product_b.jpg',
			factorScores: {
				faceProminence: 0.20, // 0.20 * 0.30 = 0.060
				textLegibility: 0.92, // 0.92 * 0.25 = 0.230
				colorVibrance: 0.75,  // 0.75 * 0.20 = 0.150
				composition: 0.80,    // 0.80 * 0.15 = 0.120
				trendAlignment: 0.65  // 0.65 * 0.10 = 0.065 -> total = 0.625 ~ 63% (Medium Yellow)
			},
			ctrPrediction: calculateCTRPrediction({
				faceProminence: 0.20,
				textLegibility: 0.92,
				colorVibrance: 0.75,
				composition: 0.80,
				trendAlignment: 0.65
			}),
			selected: false
		},
		{
			id: 'var-03',
			title: 'Biến thể C: Khoảng trống tò mò (Dấu hỏi)',
			templateStyle: 'curiosity_gap',
			headline: 'ĐỪNG XEM NẾU CHƯA BIẾT ĐIỀU NÀY',
			imageUrl: 'https://cdn.example.com/thumbnails/variant_curiosity_c.jpg',
			factorScores: {
				faceProminence: 0.10, // 0.10 * 0.30 = 0.030
				textLegibility: 0.45, // 0.45 * 0.25 = 0.1125
				colorVibrance: 0.35,  // 0.35 * 0.20 = 0.070
				composition: 0.40,    // 0.40 * 0.15 = 0.060
				trendAlignment: 0.50  // 0.50 * 0.10 = 0.050 -> total = 0.3225 ~ 32% (Low Red)
			},
			ctrPrediction: calculateCTRPrediction({
				faceProminence: 0.10,
				textLegibility: 0.45,
				colorVibrance: 0.35,
				composition: 0.40,
				trendAlignment: 0.50
			}),
			selected: false
		}
	];

	let selectedTemplateId = 'face_reaction';

	function handleGenerateThumbnails() {
		if (userBalance < quoteCredits) return;
		isGenerating = true;
		setTimeout(() => {
			isGenerating = false;
			userBalance -= quoteCredits;
			successNotification = `Đã tạo thành công bộ 3 biến thể Thumbnail với tính điểm CTR 5 nhân tố! Trừ ${quoteCredits} credits.`;
		}, 700);
	}

	function selectVariant(id: string) {
		variants = variants.map((v) => ({ ...v, selected: v.id === id }));
	}

	function updateFactorScore(variantIdx: number, factor: keyof CTRFactorScores, value: number) {
		const v = variants[variantIdx];
		const updatedScores = { ...v.factorScores, [factor]: value };
		v.factorScores = updatedScores;
		v.ctrPrediction = calculateCTRPrediction(updatedScores);
		variants = [...variants];
	}
</script>

<svelte:head>
	<title>AI Thumbnail Creator & CTR Studio (W026) — Creativanta</title>
</svelte:head>

<div class="min-h-screen bg-zinc-950 text-zinc-100 p-6 max-w-7xl mx-auto space-y-6">
	<!-- Header -->
	<div class="flex flex-col md:flex-row md:items-center justify-between gap-4 border-b border-zinc-800 pb-5">
		<div>
			<div class="flex items-center gap-2 text-sm text-zinc-400 mb-1">
				<a href="/studio" class="hover:text-emerald-400 transition-colors">AI Video Studio</a>
				<span>/</span>
				<span class="text-zinc-200">Thumbnail Creator & CTR Studio (W026 · EF-03)</span>
			</div>
			<h1 class="text-2xl font-bold tracking-tight text-white flex items-center gap-3">
				<span>✨ AI Thumbnail Creator</span>
				<span class="text-xs px-2.5 py-0.5 rounded-full bg-amber-950/80 text-amber-300 border border-amber-800">
					5-Factor CTR Prediction Formula · 5 Templates
				</span>
			</h1>
			<p class="text-sm text-zinc-400 mt-1">
				Thiết kế ảnh bìa tỉ lệ nhấp cao với 5 phong cách mẫu và công thức toán học dự đoán CTR 5 thành phần chuẩn khoa học.
			</p>
		</div>

		<div class="bg-zinc-900 border border-zinc-800 px-4 py-2 rounded-xl text-right">
			<div class="text-xs text-zinc-400">Số dư khả dụng</div>
			<div class="text-lg font-bold text-emerald-400">{userBalance} credits</div>
		</div>
	</div>

	{#if successNotification}
		<div class="p-4 rounded-xl bg-emerald-950/40 border border-emerald-800 text-emerald-300 text-sm flex items-center justify-between">
			<div class="flex items-center gap-2">
				<span>✅</span>
				<span>{successNotification}</span>
			</div>
			<button type="button" class="text-xs underline hover:text-white" on:click={() => (successNotification = '')}>
				Đóng
			</button>
		</div>
	{/if}

	<!-- Top Bar: 5 Template Styles Selector -->
	<div class="bg-zinc-900/90 border border-zinc-800 rounded-2xl p-6 space-y-4">
		<div class="flex items-center justify-between">
			<h2 class="text-base font-semibold text-white flex items-center gap-2">
				<span>1. Chọn phong cách ảnh bìa ({THUMBNAIL_TEMPLATES.length} mẫu)</span>
			</h2>
			<span class="text-xs text-zinc-400">Được tinh chỉnh cho YouTube Shorts, TikTok & Facebook Reels</span>
		</div>

		<div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-5 gap-3">
			{#each THUMBNAIL_TEMPLATES as template}
				<div
					role="button"
					tabindex="0"
					class="p-3.5 rounded-xl border text-left cursor-pointer transition-all {selectedTemplateId === template.id
						? 'bg-amber-950/40 border-amber-500 shadow-md ring-1 ring-amber-500/50'
						: 'bg-zinc-950/60 border-zinc-800 hover:border-zinc-700'}"
					on:click={() => (selectedTemplateId = template.id)}
					on:keydown={(e) => e.key === 'Enter' && (selectedTemplateId = template.id)}
				>
					<div class="flex items-center gap-2">
						<span class="text-xl">{template.icon}</span>
						<span class="text-xs font-semibold text-white leading-tight">{template.name}</span>
					</div>
					<p class="text-[11px] text-zinc-400 mt-2 line-clamp-2">{template.description}</p>
					<div class="mt-2 text-[10px] text-amber-300 bg-amber-950/60 px-1.5 py-0.5 rounded border border-amber-800/80 inline-block">
						{template.recommendedFor}
					</div>
				</div>
			{/each}
		</div>
	</div>

	<!-- Text Overlay Editor & Source Frame -->
	<div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
		<div class="bg-zinc-900/90 border border-zinc-800 rounded-2xl p-6 space-y-4">
			<h3 class="text-sm font-semibold text-white flex items-center gap-2">
				<span>2. Tùy biến chữ & Lớp phủ (Text Overlay)</span>
			</h3>

			<div class="space-y-3.5 text-xs">
				<div>
					<label for="tb-headline" class="block font-medium text-zinc-300 mb-1">
						Dòng chữ tiêu đề thu hút:
					</label>
					<input
						id="tb-headline"
						type="text"
						bind:value={headlineText}
						class="w-full bg-zinc-950 border border-zinc-800 rounded-xl px-3 py-2 text-xs text-white focus:outline-none focus:border-amber-500"
						placeholder="Nhập tiêu đề ngắn gọn..."
					/>
				</div>

				<div class="grid grid-cols-2 gap-3">
					<div>
						<label for="tb-font" class="block text-zinc-400 mb-1">Font chữ:</label>
						<select
							id="tb-font"
							bind:value={fontFamily}
							class="w-full bg-zinc-950 border border-zinc-800 rounded-xl px-2.5 py-1.5 text-xs text-white"
						>
							<option value="Anton">Anton (Bold & Impact)</option>
							<option value="Montserrat">Montserrat (Hiện đại)</option>
							<option value="Bebas Neue">Bebas Neue (Điện ảnh)</option>
							<option value="Inter">Inter (Tối giản)</option>
						</select>
					</div>

					<div>
						<label for="tb-pos" class="block text-zinc-400 mb-1">Vị trí đặt chữ:</label>
						<select
							id="tb-pos"
							bind:value={textPosition}
							class="w-full bg-zinc-950 border border-zinc-800 rounded-xl px-2.5 py-1.5 text-xs text-white"
						>
							<option value="bottom">Dưới đáy (Bottom)</option>
							<option value="center">Chính giữa (Center)</option>
							<option value="top">Phía trên (Top)</option>
						</select>
					</div>
				</div>

				<div class="grid grid-cols-2 gap-3">
					<div>
						<label for="tb-color" class="block text-zinc-400 mb-1">Màu chữ:</label>
						<div class="flex items-center gap-2">
							<input
								id="tb-color"
								type="color"
								bind:value={textColor}
								class="w-8 h-8 rounded bg-zinc-950 border border-zinc-800 cursor-pointer"
							/>
							<span class="font-mono text-zinc-300">{textColor}</span>
						</div>
					</div>

					<div class="flex items-center gap-2 pt-4">
						<input
							type="checkbox"
							id="tb-shadow"
							bind:checked={hasDropShadow}
							class="w-4 h-4 accent-amber-500 rounded bg-zinc-950"
						/>
						<label for="tb-shadow" class="text-zinc-300 cursor-pointer">Bóng viền đậm (Strokes)</label>
					</div>
				</div>

				<div class="pt-3 border-t border-zinc-800">
					<button
						type="button"
						disabled={isGenerating || userBalance < quoteCredits}
						on:click={handleGenerateThumbnails}
						class="w-full py-2.5 rounded-xl font-semibold text-xs transition-all {userBalance >= quoteCredits && !isGenerating
							? 'bg-amber-600 hover:bg-amber-500 text-white shadow-lg shadow-amber-900/30 cursor-pointer'
							: 'bg-zinc-800 text-zinc-500 cursor-not-allowed'}"
					>
						{isGenerating ? 'Đang tạo 3 biến thể...' : `Tạo 3 biến thể AI (${quoteCredits} cr)`}
					</button>
				</div>
			</div>
		</div>

		<!-- CTR Mathematical Formula Explanation Card -->
		<div class="lg:col-span-2 bg-zinc-900/90 border border-zinc-800 rounded-2xl p-6 space-y-4">
			<div class="flex items-center justify-between">
				<h3 class="text-sm font-semibold text-white flex items-center gap-2">
					<span>Công thức toán học dự đoán CTR 5 thành phần (EF-03)</span>
				</h3>
				<span class="text-xs font-mono text-zinc-400">Total = Σ(Trọng số × Điểm)</span>
			</div>

			<p class="text-xs text-zinc-400 leading-relaxed">
				Mô hình toán học độc quyền của Creativanta phân tích khung hình theo 5 chiều kích thước:
			</p>

			<div class="grid grid-cols-1 sm:grid-cols-5 gap-2 text-center text-xs">
				<div class="bg-zinc-950 p-2.5 rounded-xl border border-zinc-800">
					<div class="font-bold text-amber-400">30%</div>
					<div class="text-[11px] text-zinc-300 font-medium mt-0.5">Biểu cảm mặt</div>
					<div class="text-[10px] text-zinc-500">Face Prominence</div>
				</div>
				<div class="bg-zinc-950 p-2.5 rounded-xl border border-zinc-800">
					<div class="font-bold text-amber-400">25%</div>
					<div class="text-[11px] text-zinc-300 font-medium mt-0.5">Độ rõ chữ</div>
					<div class="text-[10px] text-zinc-500">Text Legibility</div>
				</div>
				<div class="bg-zinc-950 p-2.5 rounded-xl border border-zinc-800">
					<div class="font-bold text-amber-400">20%</div>
					<div class="text-[11px] text-zinc-300 font-medium mt-0.5">Độ rực màu</div>
					<div class="text-[10px] text-zinc-500">Color Vibrance</div>
				</div>
				<div class="bg-zinc-950 p-2.5 rounded-xl border border-zinc-800">
					<div class="font-bold text-amber-400">15%</div>
					<div class="text-[11px] text-zinc-300 font-medium mt-0.5">Bố cục 1/3</div>
					<div class="text-[10px] text-zinc-500">Composition</div>
				</div>
				<div class="bg-zinc-950 p-2.5 rounded-xl border border-zinc-800">
					<div class="font-bold text-amber-400">10%</div>
					<div class="text-[11px] text-zinc-300 font-medium mt-0.5">Xu hướng</div>
					<div class="text-[10px] text-zinc-500">Trend Alignment</div>
				</div>
			</div>

			<div class="flex items-center gap-4 text-xs pt-1 border-t border-zinc-800 text-zinc-400">
				<span class="flex items-center gap-1.5">
					<span class="w-2.5 h-2.5 rounded-full bg-emerald-500 inline-block"></span>
					<span>🟢 >70% (Tiềm năng cao)</span>
				</span>
				<span class="flex items-center gap-1.5">
					<span class="w-2.5 h-2.5 rounded-full bg-amber-500 inline-block"></span>
					<span>🟡 40-70% (Đạt chuẩn)</span>
				</span>
				<span class="flex items-center gap-1.5">
					<span class="w-2.5 h-2.5 rounded-full bg-red-500 inline-block"></span>
					<span>🔴 &lt;40% (Cần sửa đổi)</span>
				</span>
			</div>
		</div>
	</div>

	<!-- 3 Thumbnail Variant Comparison Cards -->
	<div class="space-y-4">
		<div class="flex items-center justify-between">
			<h2 class="text-base font-semibold text-white flex items-center gap-2">
				<span>3. Bảng so sánh 3 biến thể Thumbnail & Điểm số CTR chi tiết</span>
			</h2>
			<span class="text-xs text-zinc-400">Nhấp chọn biến thể để xuất bản</span>
		</div>

		<div class="grid grid-cols-1 md:grid-cols-3 gap-6">
			{#each variants as variant, vIdx}
				<div
					role="button"
					tabindex="0"
					class="bg-zinc-900/90 border rounded-2xl p-5 space-y-4 transition-all cursor-pointer {variant.selected
						? 'border-amber-500 shadow-xl ring-1 ring-amber-500/50 bg-amber-950/10'
						: 'border-zinc-800 hover:border-zinc-700'}"
					on:click={() => selectVariant(variant.id)}
					on:keydown={(e) => e.key === 'Enter' && selectVariant(variant.id)}
				>
					<!-- Header & Score Badge -->
					<div class="flex items-start justify-between gap-2">
						<div>
							<span class="text-xs font-semibold text-white">{variant.title}</span>
							<div class="text-[11px] text-zinc-400 font-mono mt-0.5">{variant.templateStyle}</div>
						</div>

						<div class="text-right">
							<div class="text-xl font-bold font-mono {variant.ctrPrediction.grade === 'high' ? 'text-emerald-400' : variant.ctrPrediction.grade === 'medium' ? 'text-amber-400' : 'text-red-400'}">
								{variant.ctrPrediction.overallScore}%
							</div>
							<div class="text-[10px] px-2 py-0.5 rounded border {variant.ctrPrediction.gradeColor}">
								{variant.ctrPrediction.gradeLabel}
							</div>
						</div>
					</div>

					<!-- Thumbnail Visual Mockup -->
					<div class="relative aspect-video rounded-xl bg-zinc-950 border border-zinc-800 overflow-hidden flex items-center justify-center p-3">
						<div class="absolute inset-0 bg-gradient-to-t from-black/80 via-black/30 to-transparent"></div>
						<div class="relative z-10 text-center space-y-1">
							<div class="text-[10px] text-zinc-400 uppercase tracking-widest">{variant.templateStyle}</div>
							<div
								class="font-black text-sm drop-shadow-md tracking-tight px-2 py-1 rounded"
								style="color: {textColor}; font-family: {fontFamily}; text-shadow: {hasDropShadow ? '2px 2px 0 #000' : 'none'};"
							>
								{variant.headline}
							</div>
						</div>
					</div>

					<!-- 5-Factor Sliders -->
					<div class="space-y-2.5 pt-2 border-t border-zinc-800/80 text-xs">
						<div class="text-[11px] font-semibold text-zinc-300">Chi tiết 5 thành phần (Weights):</div>

						<!-- Face: 30% -->
						<div>
							<div class="flex justify-between text-[11px] text-zinc-400 mb-1">
								<span>Gương mặt (30%)</span>
								<span class="font-mono text-zinc-200">{Math.round(variant.factorScores.faceProminence * 100)}%</span>
							</div>
							<input
								type="range"
								min="0"
								max="1"
								step="0.05"
								value={variant.factorScores.faceProminence}
								on:input={(e) => updateFactorScore(vIdx, 'faceProminence', parseFloat(e.currentTarget.value))}
								class="w-full h-1.5 accent-amber-500 bg-zinc-800 rounded-lg cursor-pointer"
							/>
						</div>

						<!-- Text: 25% -->
						<div>
							<div class="flex justify-between text-[11px] text-zinc-400 mb-1">
								<span>Độ rõ chữ (25%)</span>
								<span class="font-mono text-zinc-200">{Math.round(variant.factorScores.textLegibility * 100)}%</span>
							</div>
							<input
								type="range"
								min="0"
								max="1"
								step="0.05"
								value={variant.factorScores.textLegibility}
								on:input={(e) => updateFactorScore(vIdx, 'textLegibility', parseFloat(e.currentTarget.value))}
								class="w-full h-1.5 accent-amber-500 bg-zinc-800 rounded-lg cursor-pointer"
							/>
						</div>

						<!-- Color: 20% -->
						<div>
							<div class="flex justify-between text-[11px] text-zinc-400 mb-1">
								<span>Độ rực màu (20%)</span>
								<span class="font-mono text-zinc-200">{Math.round(variant.factorScores.colorVibrance * 100)}%</span>
							</div>
							<input
								type="range"
								min="0"
								max="1"
								step="0.05"
								value={variant.factorScores.colorVibrance}
								on:input={(e) => updateFactorScore(vIdx, 'colorVibrance', parseFloat(e.currentTarget.value))}
								class="w-full h-1.5 accent-amber-500 bg-zinc-800 rounded-lg cursor-pointer"
							/>
						</div>

						<!-- Composition: 15% -->
						<div>
							<div class="flex justify-between text-[11px] text-zinc-400 mb-1">
								<span>Bố cục 1/3 (15%)</span>
								<span class="font-mono text-zinc-200">{Math.round(variant.factorScores.composition * 100)}%</span>
							</div>
							<input
								type="range"
								min="0"
								max="1"
								step="0.05"
								value={variant.factorScores.composition}
								on:input={(e) => updateFactorScore(vIdx, 'composition', parseFloat(e.currentTarget.value))}
								class="w-full h-1.5 accent-amber-500 bg-zinc-800 rounded-lg cursor-pointer"
							/>
						</div>

						<!-- Trend: 10% -->
						<div>
							<div class="flex justify-between text-[11px] text-zinc-400 mb-1">
								<span>Xu hướng (10%)</span>
								<span class="font-mono text-zinc-200">{Math.round(variant.factorScores.trendAlignment * 100)}%</span>
							</div>
							<input
								type="range"
								min="0"
								max="1"
								step="0.05"
								value={variant.factorScores.trendAlignment}
								on:input={(e) => updateFactorScore(vIdx, 'trendAlignment', parseFloat(e.currentTarget.value))}
								class="w-full h-1.5 accent-amber-500 bg-zinc-800 rounded-lg cursor-pointer"
							/>
						</div>
					</div>

					<button
						type="button"
						class="w-full py-2 rounded-xl text-xs font-semibold transition-all {variant.selected
							? 'bg-amber-600 hover:bg-amber-500 text-white'
							: 'bg-zinc-800 hover:bg-zinc-700 text-zinc-300'}"
					>
						{variant.selected ? '✓ Đang chọn biến thể này' : 'Chọn biến thể này'}
					</button>
				</div>
			{/each}
		</div>
	</div>
</div>
