<script lang="ts">
	import {
		SCRIPT_TEMPLATES,
		checkUrlSafetyClient,
		validateProductAttributes,
		type ScriptTemplateOption,
		type SSRFCheckResult
	} from '$lib/production';

	let inputUrl = 'https://shopee.vn/product/skincare-serum-b5-restorative-hydrating-i.12345.67890';
	let isScraping = false;
	let isGenerating = false;
	let userBalance = 180;
	let quoteCredits = 15;

	// Safety & Error states
	let safetyCheck: SSRFCheckResult | null = null;
	let errorMessage = '';
	let actionableMessage = '';
	let successMessage = '';

	// Scraped Data State
	interface ScrapedContent {
		title: string;
		description: string;
		price: number;
		currency: string;
		images: string[];
		rating: number;
		reviewCount: number;
		scrapedAt: string;
	}

	let scrapedData: ScrapedContent | null = {
		title: 'Serum Phục Hồi Da B5 Centella Hydra Calming 50ml',
		description: 'Tinh chất dưỡng da phục hồi chuyên sâu chứa chiết xuất rau má tươi và vitamin B5 5% làm dịu da nhạy cảm cấp tốc.',
		price: 299000,
		currency: 'VND',
		images: [
			'https://cdn.example.com/shopee/b5_serum_hero.jpg',
			'https://cdn.example.com/shopee/b5_serum_details.jpg',
			'https://cdn.example.com/shopee/b5_serum_reviews.jpg'
		],
		rating: 4.9,
		reviewCount: 1420,
		scrapedAt: new Date().toISOString()
	};

	let selectedTemplateId = 'problem_solution';
	$: selectedTemplate = SCRIPT_TEMPLATES.find((t) => t.id === selectedTemplateId) || SCRIPT_TEMPLATES[0];

	// Generated script components
	let generatedHook = '';
	let generatedBody = '';
	let generatedCTA = '';

	$: if (scrapedData && selectedTemplate) {
		updateScriptFromTemplate(selectedTemplate, scrapedData);
	}

	function updateScriptFromTemplate(template: ScriptTemplateOption, data: ScrapedContent) {
		const priceStr = data.price ? `${data.price.toLocaleString('vi-VN')} đ` : 'ưu đãi tốt';
		if (template.id === 'problem_solution') {
			generatedHook = `Da bạn đang ửng đỏ, khô rát sau một ngày dài làm việc ngoài trời nắng gắt?`;
			generatedBody = `Chỉ với 2 giọt ${data.title}, phức hợp Centella và B5 làm dịu tức thì cảm giác châm chích và khóa ẩm căng mọng.`;
			generatedCTA = `Bấm ngay vào giỏ hàng Shopee để sở hữu giá sốc chỉ ${priceStr}!`;
		} else if (template.id === 'feature_roundup') {
			generatedHook = `Top 3 lý do chai ${data.title} này cháy hàng liên tục:`;
			generatedBody = `1. Cấp ẩm đa tầng tức thì.\n2. Phục hồi màng bảo vệ da chỉ sau 7 ngày.\n3. Kết cấu lỏng nhẹ thấm nhanh không nhờn dính.`;
			generatedCTA = `Chốt đơn ngay trước khi hết hàng đợt khuyến mãi này nhé!`;
		} else if (template.id === 'unboxing_review') {
			generatedHook = `Cùng mình unbox chai serum cứu tinh cho làn da nhạy cảm xem thực tế thế nào nha!`;
			generatedBody = `Thiết kế vòi drop thủy tinh sang trọng, chất gel trong veo thơm mùi thảo mộc dịu mát. Giá chỉ ${priceStr} quá hời cho một sản phẩm đỉnh.`;
			generatedCTA = `Link mua chính hãng mình gắn ngay góc trái màn hình, nhấn xem ngay!`;
		} else if (template.id === 'urgency_promo') {
			generatedHook = `Tin chấn động: ${data.title} đang sale sốc chưa từng có chỉ còn ${priceStr}!`;
			generatedBody = `Duy nhất 50 chai cuối cùng được áp mã giảm thêm 20%. Ai đang lăn tăn phục hồi da thì hốt liền!`;
			generatedCTA = `Số lượng có hạn, đặt mua ngay trước khi về giá gốc!`;
		} else {
			generatedHook = `Một làn da khỏe mạnh bắt đầu từ sự lắng nghe và yêu thương từng tế bào nhỏ.`;
			generatedBody = `Với ${data.title}, chúng tôi gửi gắm cả thiên nhiên dịu lành để đồng hành cùng vẻ đẹp tự nhiên của bạn mỗi sớm mai.`;
			generatedCTA = `Hãy bắt đầu hành trình nuôi dưỡng làn da khỏe mạnh ngay hôm nay.`;
		}
	}

	$: attributeValidation = scrapedData
		? validateProductAttributes({
				name: scrapedData.title,
				description: scrapedData.description,
				price: scrapedData.price,
				imageUrls: scrapedData.images
		  })
		: null;

	function handleScrape() {
		errorMessage = '';
		actionableMessage = '';
		successMessage = '';

		// Run client-side SSRF & DRM check
		const check = checkUrlSafetyClient(inputUrl);
		safetyCheck = check;

		if (!check.isSafe) {
			if (check.isDRM) {
				errorMessage = check.errorMessage || 'Nội dung bị bảo vệ bản quyền DRM';
				actionableMessage = check.actionableMessage || 'Cannot access video at this URL. [Upload video file instead] or [Try different URL].';
			} else {
				errorMessage = check.errorMessage || 'URL không an toàn (SSRF Protection)';
			}
			scrapedData = null;
			return;
		}

		// Simulate scraping valid or edge cases
		isScraping = true;
		setTimeout(() => {
			isScraping = false;
			if (inputUrl.includes('no-image')) {
				scrapedData = {
					title: 'Sản phẩm thử nghiệm thiếu hình ảnh',
					description: 'Mô tả chi tiết sản phẩm thử nghiệm.',
					price: 150000,
					currency: 'VND',
					images: [],
					rating: 0,
					reviewCount: 0,
					scrapedAt: new Date().toISOString()
				};
			} else if (inputUrl.includes('no-desc')) {
				scrapedData = {
					title: 'Sản phẩm thử nghiệm thiếu phần mô tả',
					description: '',
					price: 200000,
					currency: 'VND',
					images: ['https://cdn.example.com/p1.jpg', 'https://cdn.example.com/p2.jpg'],
					rating: 4.5,
					reviewCount: 12,
					scrapedAt: new Date().toISOString()
				};
			} else {
				scrapedData = {
					title: 'Serum Phục Hồi Da B5 Centella Hydra Calming 50ml',
					description: 'Tinh chất dưỡng da phục hồi chuyên sâu chứa chiết xuất rau má tươi và vitamin B5 5% làm dịu da nhạy cảm cấp tốc.',
					price: 299000,
					currency: 'VND',
					images: [
						'https://cdn.example.com/shopee/b5_serum_hero.jpg',
						'https://cdn.example.com/shopee/b5_serum_details.jpg',
						'https://cdn.example.com/shopee/b5_serum_reviews.jpg'
					],
					rating: 4.9,
					reviewCount: 1420,
					scrapedAt: new Date().toISOString()
				};
			}
			successMessage = 'Trích xuất dữ liệu sản phẩm thành công!';
		}, 700);
	}

	function handleGenerate() {
		if (!scrapedData) return;
		if (userBalance < quoteCredits) {
			errorMessage = 'Số dư credits không đủ để tạo video';
			return;
		}

		isGenerating = true;
		errorMessage = '';
		setTimeout(() => {
			isGenerating = false;
			userBalance -= quoteCredits;
			successMessage = `Đã tạo tác vụ Link-to-Video thành công! Mã tác vụ: job-l2v-${Date.now().toString().slice(-6)}. Trừ ${quoteCredits} credits.`;
		}, 800);
	}
</script>

<svelte:head>
	<title>Link to Video Studio (W036) — Creativanta</title>
</svelte:head>

<div class="min-h-screen bg-zinc-950 text-zinc-100 p-6 max-w-7xl mx-auto space-y-6">
	<!-- Header -->
	<div class="flex flex-col md:flex-row md:items-center justify-between gap-4 border-b border-zinc-800 pb-5">
		<div>
			<div class="flex items-center gap-2 text-sm text-zinc-400 mb-1">
				<a href="/studio" class="hover:text-emerald-400 transition-colors">AI Video Studio</a>
				<span>/</span>
				<span class="text-zinc-200">Link to Video Studio (W036 · EF-04)</span>
			</div>
			<h1 class="text-2xl font-bold tracking-tight text-white flex items-center gap-3">
				<span>🔗 Link to Video Studio</span>
				<span class="text-xs px-2.5 py-0.5 rounded-full bg-violet-950/80 text-violet-300 border border-violet-800">
					5 Script Templates · SSRF Protected
				</span>
			</h1>
			<p class="text-sm text-zinc-400 mt-1">
				Dán đường dẫn sản phẩm Shopee, TikTok Shop, Lazada hoặc website để AI tự động trích xuất và biến thành video chuyển đổi cao.
			</p>
		</div>

		<div class="bg-zinc-900 border border-zinc-800 px-4 py-2 rounded-xl text-right">
			<div class="text-xs text-zinc-400">Số dư khả dụng</div>
			<div class="text-lg font-bold text-emerald-400">{userBalance} credits</div>
		</div>
	</div>

	<!-- Error / DRM / SSRF Banner -->
	{#if errorMessage}
		<div class="p-4 rounded-xl bg-red-950/40 border border-red-800 text-red-300 text-sm space-y-2">
			<div class="flex items-center gap-2 font-semibold">
				<span>⛔ Lỗi truy cập liên kết:</span>
				<span>{errorMessage}</span>
			</div>
			{#if actionableMessage}
				<div class="p-3 bg-red-950/80 border border-red-700/60 rounded-lg text-xs font-mono text-red-200">
					{actionableMessage}
				</div>
			{/if}
			{#if safetyCheck && safetyCheck.errorCode === 'ERR_SSRF_BLOCKED'}
				<p class="text-xs text-zinc-400">
					Hệ thống tự động ngăn chặn truy cập vào dải mạng nội bộ, cloud metadata (169.254.169.254) hoặc địa chỉ cục bộ nhằm đảm bảo an toàn tuyệt đối.
				</p>
			{/if}
		</div>
	{/if}

	{#if successMessage}
		<div class="p-4 rounded-xl bg-emerald-950/40 border border-emerald-800 text-emerald-300 text-sm flex items-center justify-between">
			<div class="flex items-center gap-2">
				<span>✅</span>
				<span>{successMessage}</span>
			</div>
			<button type="button" class="text-xs underline hover:text-white" on:click={() => (successMessage = '')}>
				Đóng
			</button>
		</div>
	{/if}

	<!-- URL Input Card -->
	<div class="bg-zinc-900/90 border border-zinc-800 rounded-2xl p-6 space-y-4">
		<h2 class="text-base font-semibold text-white flex items-center gap-2">
			<span>1. Nhập đường dẫn liên kết sản phẩm (URL)</span>
		</h2>

		<div class="flex flex-col sm:flex-row gap-3">
			<input
				type="url"
				bind:value={inputUrl}
				placeholder="https://shopee.vn/... hoặc https://tiktok.com/..."
				class="flex-1 bg-zinc-950 border border-zinc-800 rounded-xl px-4 py-3 text-sm text-white focus:outline-none focus:border-violet-500"
			/>
			<button
				type="button"
				disabled={isScraping}
				on:click={handleScrape}
				class="px-6 py-3 rounded-xl bg-violet-600 hover:bg-violet-500 text-white font-semibold text-sm transition-all disabled:opacity-50 disabled:cursor-not-allowed shadow-lg shadow-violet-900/30 flex items-center justify-center gap-2"
			>
				{#if isScraping}
					<span>Đang phân tích...</span>
				{:else}
					<span>Trích xuất nội dung</span>
				{/if}
			</button>
		</div>

		<!-- Quick Test URLs helper -->
		<div class="flex flex-wrap items-center gap-2 pt-1 text-xs text-zinc-400">
			<span>Thử nghiệm nhanh:</span>
			<button
				type="button"
				class="underline hover:text-white"
				on:click={() => { inputUrl = 'https://shopee.vn/product/skincare-serum-b5'; handleScrape(); }}
			>
				Shopee Hợp Lệ
			</button>
			<span>•</span>
			<button
				type="button"
				class="underline hover:text-red-400 text-red-300"
				on:click={() => { inputUrl = 'http://169.254.169.254/latest/meta-data/'; handleScrape(); }}
			>
				Thử SSRF Cloud Metadata (Chặn)
			</button>
			<span>•</span>
			<button
				type="button"
				class="underline hover:text-red-400 text-red-300"
				on:click={() => { inputUrl = 'https://netflix.com/watch/12345'; handleScrape(); }}
			>
				Thử DRM Protected URL (Chặn)
			</button>
			<span>•</span>
			<button
				type="button"
				class="underline hover:text-amber-400 text-amber-300"
				on:click={() => { inputUrl = 'https://example.com/product/no-desc'; handleScrape(); }}
			>
				Thử Thiếu Mô Tả (Cảnh báo)
			</button>
		</div>
	</div>

	<!-- Main Workspace when Scraped -->
	{#if scrapedData}
		<div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
			<!-- Left: Scraped Info & Attribute Warnings -->
			<div class="space-y-6">
				<div class="bg-zinc-900/90 border border-zinc-800 rounded-2xl p-6 space-y-4">
					<div class="flex items-center justify-between">
						<h3 class="text-sm font-semibold text-white">Dữ liệu bóc tách được</h3>
						<span class="text-[11px] text-zinc-500 font-mono">
							{new Date(scrapedData.scrapedAt).toLocaleTimeString()}
						</span>
					</div>

					<div class="space-y-3 text-xs">
						<div>
							<div class="text-zinc-400 text-[11px]">Tên sản phẩm:</div>
							<div class="font-medium text-white mt-0.5">{scrapedData.title}</div>
						</div>

						<div>
							<div class="text-zinc-400 text-[11px]">Giá niêm yết:</div>
							<div class="font-bold text-emerald-400 text-sm mt-0.5">
								{scrapedData.price ? `${scrapedData.price.toLocaleString('vi-VN')} ${scrapedData.currency}` : 'Chưa rõ giá'}
							</div>
						</div>

						<div>
							<div class="text-zinc-400 text-[11px]">Mô tả tóm tắt:</div>
							<p class="text-zinc-300 mt-0.5 line-clamp-3">
								{scrapedData.description || '(Không tìm thấy mô tả chi tiết)'}
							</p>
						</div>

						<div>
							<div class="text-zinc-400 text-[11px] mb-1.5">Ảnh sản phẩm thu thập ({scrapedData.images.length}):</div>
							<div class="flex flex-wrap gap-1.5">
								{#each scrapedData.images as imgUrl, idx}
									<span class="bg-zinc-950 px-2 py-1 rounded text-[10px] text-zinc-300 border border-zinc-800">
										Ảnh #{idx + 1}
									</span>
								{/each}
								{#if scrapedData.images.length === 0}
									<span class="text-red-400 text-xs">Không tìm thấy ảnh sản phẩm nào</span>
								{/if}
							</div>
						</div>
					</div>

					<!-- Attribute Validation Warnings -->
					{#if attributeValidation}
						<div class="pt-2 border-t border-zinc-800/80 space-y-2">
							{#if attributeValidation.hasErrors}
								<div class="p-3 rounded-xl bg-red-950/40 border border-red-800 text-xs text-red-300 space-y-1">
									<div class="font-semibold">⛔ Thiếu thông tin thiết yếu:</div>
									{#each attributeValidation.errors as err}
										<div>• {err}</div>
									{/each}
								</div>
							{/if}
							{#if attributeValidation.hasWarnings}
								<div class="p-3 rounded-xl bg-amber-950/30 border border-amber-800 text-xs text-amber-300 space-y-1">
									<div class="font-semibold">⚠️ Cảnh báo chất lượng dữ liệu:</div>
									{#each attributeValidation.warnings as warn}
										<div>• {warn}</div>
									{/each}
								</div>
							{/if}
						</div>
					{/if}
				</div>
			</div>

			<!-- Middle & Right: 5 Script Templates & Editor -->
			<div class="lg:col-span-2 space-y-6">
				<!-- Script Template Selector (5 Templates) -->
				<div class="bg-zinc-900/90 border border-zinc-800 rounded-2xl p-6 space-y-4">
					<div class="flex items-center justify-between">
						<h2 class="text-base font-semibold text-white flex items-center gap-2">
							<span>2. Mẫu kịch bản chuyển đổi ({SCRIPT_TEMPLATES.length} mẫu)</span>
						</h2>
						<span class="text-xs text-zinc-400">Chọn cấu trúc kịch bản phù hợp tệp khách hàng</span>
					</div>

					<div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-2.5">
						{#each SCRIPT_TEMPLATES as template}
							<div
								role="button"
								tabindex="0"
								class="p-3 rounded-xl border text-left cursor-pointer transition-all {selectedTemplateId === template.id
									? 'bg-violet-950/40 border-violet-500 shadow-md ring-1 ring-violet-500/50'
									: 'bg-zinc-950/60 border-zinc-800 hover:border-zinc-700'}"
								on:click={() => (selectedTemplateId = template.id)}
								on:keydown={(e) => e.key === 'Enter' && (selectedTemplateId = template.id)}
							>
								<div class="flex items-center justify-between">
									<span class="text-xs font-semibold text-white">{template.name}</span>
									<span class="text-[10px] px-1.5 py-0.5 rounded bg-zinc-900 text-violet-300 border border-zinc-800">
										{template.category}
									</span>
								</div>
								<p class="text-[11px] text-zinc-400 mt-1.5 line-clamp-2">{template.description}</p>
							</div>
						{/each}
					</div>
				</div>

				<!-- Script Editor & Video Generator -->
				<div class="bg-zinc-900/90 border border-zinc-800 rounded-2xl p-6 space-y-4">
					<h3 class="text-sm font-semibold text-white flex items-center gap-2">
						<span>3. Soạn thảo kịch bản thoại (Hook - Body - CTA)</span>
					</h3>

					<div class="space-y-3">
						<div>
							<label for="sc-hook" class="block text-xs font-medium text-violet-400 mb-1">
								Hook (3 giây đầu tiên giữ chân):
							</label>
							<textarea
								id="sc-hook"
								rows="2"
								bind:value={generatedHook}
								class="w-full bg-zinc-950 border border-zinc-800 rounded-xl p-3 text-xs text-white focus:outline-none focus:border-violet-500"
							></textarea>
						</div>

						<div>
							<label for="sc-body" class="block text-xs font-medium text-zinc-300 mb-1">
								Nội dung chính (Body):
							</label>
							<textarea
								id="sc-body"
								rows="3"
								bind:value={generatedBody}
								class="w-full bg-zinc-950 border border-zinc-800 rounded-xl p-3 text-xs text-white focus:outline-none focus:border-violet-500"
							></textarea>
						</div>

						<div>
							<label for="sc-cta" class="block text-xs font-medium text-emerald-400 mb-1">
								Kêu gọi hành động (Call To Action):
							</label>
							<textarea
								id="sc-cta"
								rows="2"
								bind:value={generatedCTA}
								class="w-full bg-zinc-950 border border-zinc-800 rounded-xl p-3 text-xs text-white focus:outline-none focus:border-violet-500"
							></textarea>
						</div>
					</div>

					<div class="flex items-center justify-between pt-3 border-t border-zinc-800">
						<div class="text-xs text-zinc-400">
							Chi phí tạo video: <span class="font-bold text-emerald-400">{quoteCredits} credits</span> (15s video AI)
						</div>

						<button
							type="button"
							disabled={isGenerating || userBalance < quoteCredits}
							on:click={handleGenerate}
							class="px-6 py-2.5 rounded-xl font-semibold text-sm transition-all {userBalance >= quoteCredits && !isGenerating
								? 'bg-violet-600 hover:bg-violet-500 text-white shadow-lg shadow-violet-900/30 cursor-pointer'
								: 'bg-zinc-800 text-zinc-500 cursor-not-allowed'}"
						>
							{isGenerating ? 'Đang kết xuất video...' : `Tạo Video từ Link (${quoteCredits} cr)`}
						</button>
					</div>
				</div>
			</div>
		</div>
	{/if}
</div>
