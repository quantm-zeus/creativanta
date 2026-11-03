<script lang="ts">
	import {
		SHOWCASE_STYLES,
		validateProductAttributes,
		validateShowcaseBatch,
		type ShowcaseStyleOption
	} from '$lib/production';

	type ShowcaseMode = 'single' | 'batch';
	let mode: ShowcaseMode = 'single';

	// Single product form state
	let productName = 'Serum Phục Hồi Da B5 Centella 50ml';
	let productDescription = 'Tinh chất cô đặc rau má và panthenol 5% làm dịu mẩn đỏ, phục hồi hàng rào ẩm tự nhiên.';
	let productPrice: number | string = 320000;
	let selectedStyleId = 'lifestyle';
	let imageUrls: string[] = [
		'https://cdn.example.com/products/serum-front.jpg',
		'https://cdn.example.com/products/serum-texture.jpg',
		'https://cdn.example.com/products/serum-lifestyle.jpg'
	];
	let newImageUrl = '';
	let userBalance = 250;
	let isSubmitting = false;
	let submissionSuccess = '';

	function addImage() {
		if (newImageUrl.trim()) {
			imageUrls = [...imageUrls, newImageUrl.trim()];
			newImageUrl = '';
		}
	}

	function removeImage(index: number) {
		imageUrls = imageUrls.filter((_, i) => i !== index);
	}

	$: selectedStyle = SHOWCASE_STYLES.find((s) => s.id === selectedStyleId) || SHOWCASE_STYLES[0];

	$: validation = validateProductAttributes({
		name: productName,
		description: productDescription,
		price: productPrice,
		imageUrls,
		style: selectedStyleId
	});

	$: quoteCredits = selectedStyle.creditCost;
	$: canSubmitSingle = !validation.hasErrors && userBalance >= quoteCredits;

	// Batch Mode State (up to 20 products)
	interface BatchRow {
		id: string;
		name: string;
		style: string;
		description: string;
		price: number;
		imageUrls: string[];
	}

	let batchRows: BatchRow[] = [
		{
			id: 'b-01',
			name: 'Kem chống nắng nâng tone kiềm dầu',
			style: 'studio_clean',
			description: 'Chống nắng quang phổ rộng SPF 50+ PA++++ kiềm dầu 8 giờ.',
			price: 280000,
			imageUrls: ['https://cdn.example.com/p1-1.jpg', 'https://cdn.example.com/p1-2.jpg']
		},
		{
			id: 'b-02',
			name: 'Sữa rửa mặt tạo bọt dịu nhẹ',
			style: 'lifestyle',
			description: 'Độ pH 5.5 cân bằng ẩm, làm sạch sâu lỗ chân lông.',
			price: 190000,
			imageUrls: ['https://cdn.example.com/p2-1.jpg', 'https://cdn.example.com/p2-2.jpg']
		},
		{
			id: 'b-03',
			name: 'Đồng hồ thông minh thể thao GPS (Lỗi: thiếu ảnh cho 360 spin)',
			style: 'spin_360',
			description: 'Chống nước 5ATM, pin 14 ngày.',
			price: 1500000,
			imageUrls: ['https://cdn.example.com/p3-1.jpg', 'https://cdn.example.com/p3-2.jpg'] // <8 images => invalid
		},
		{
			id: 'b-04',
			name: 'Tai nghe chụp tai chống ồn chủ động ANC',
			style: 'exploded_view',
			description: 'Driver titan 40mm tách lớp linh kiện âm học chuyên nghiệp.',
			price: 2490000,
			imageUrls: ['https://cdn.example.com/p4-1.jpg', 'https://cdn.example.com/p4-2.jpg', 'https://cdn.example.com/p4-3.jpg', 'https://cdn.example.com/p4-4.jpg']
		}
	];

	$: batchAnalysis = validateShowcaseBatch(
		batchRows.map((r) => ({
			name: r.name,
			style: r.style,
			imageUrls: r.imageUrls,
			description: r.description,
			price: r.price
		}))
	);

	function addBatchRow() {
		if (batchRows.length >= 20) return;
		const nextIdx = batchRows.length + 1;
		batchRows = [
			...batchRows,
			{
				id: `b-0${nextIdx}`,
				name: `Sản phẩm mẫu #${nextIdx}`,
				style: 'lifestyle',
				description: 'Mô tả chi tiết sản phẩm và tính năng chính.',
				price: 100000 * nextIdx,
				imageUrls: ['https://cdn.example.com/img1.jpg', 'https://cdn.example.com/img2.jpg']
			}
		];
	}

	function removeBatchRow(index: number) {
		batchRows = batchRows.filter((_, i) => i !== index);
	}

	function submitSingle() {
		if (!canSubmitSingle) return;
		isSubmitting = true;
		setTimeout(() => {
			isSubmitting = false;
			userBalance -= quoteCredits;
			submissionSuccess = `Đã khởi tạo tác vụ AI Product Showcase (${selectedStyle.name}) thành công! Mã tác vụ: job-sc-${Date.now().toString().slice(-6)}`;
		}, 600);
	}

	function submitBatch() {
		if (batchAnalysis.validCount === 0) return;
		isSubmitting = true;
		setTimeout(() => {
			isSubmitting = false;
			userBalance -= batchAnalysis.totalCredits;
			submissionSuccess = `Đã xác nhận tạo thành công ${batchAnalysis.validCount} sản phẩm hợp lệ (tổng ${batchAnalysis.totalCredits} credits). Đã miễn trừ ${batchAnalysis.invalidCount} sản phẩm lỗi không trừ phí.`;
		}, 600);
	}
</script>

<svelte:head>
	<title>AI Product Showcase (W024) — Creativanta Studio</title>
</svelte:head>

<div class="min-h-screen bg-zinc-950 text-zinc-100 p-6 max-w-7xl mx-auto space-y-6">
	<!-- Breadcrumbs & Header -->
	<div class="flex flex-col md:flex-row md:items-center justify-between gap-4 border-b border-zinc-800 pb-5">
		<div>
			<div class="flex items-center gap-2 text-sm text-zinc-400 mb-1">
				<a href="/studio" class="hover:text-emerald-400 transition-colors">AI Video Studio</a>
				<span>/</span>
				<span class="text-zinc-200">AI Product Showcase (W024 · EF-01)</span>
			</div>
			<h1 class="text-2xl font-bold tracking-tight text-white flex items-center gap-3">
				<span>🛍️ AI Product Showcase Studio</span>
				<span class="text-xs px-2.5 py-0.5 rounded-full bg-emerald-950/80 text-emerald-300 border border-emerald-800">
					8 Styles · E-commerce Ready
				</span>
			</h1>
			<p class="text-sm text-zinc-400 mt-1">
				Tạo video giới thiệu sản phẩm chân thực từ hình ảnh tĩnh với 8 phong cách thương mại điện tử chuyên nghiệp.
			</p>
		</div>

		<!-- Credits & Mode Switcher -->
		<div class="flex items-center gap-4">
			<div class="bg-zinc-900 border border-zinc-800 px-4 py-2 rounded-xl text-right">
				<div class="text-xs text-zinc-400">Số dư khả dụng</div>
				<div class="text-lg font-bold text-emerald-400">{userBalance} credits</div>
			</div>

			<div class="flex bg-zinc-900 p-1 rounded-xl border border-zinc-800">
				<button
					type="button"
					class="px-3 py-1.5 rounded-lg text-sm font-medium transition-all {mode === 'single' ? 'bg-emerald-600 text-white shadow' : 'text-zinc-400 hover:text-white'}"
					on:click={() => (mode = 'single')}
				>
					Đơn lẻ
				</button>
				<button
					type="button"
					class="px-3 py-1.5 rounded-lg text-sm font-medium transition-all {mode === 'batch' ? 'bg-emerald-600 text-white shadow' : 'text-zinc-400 hover:text-white'}"
					on:click={() => (mode = 'batch')}
				>
					Hàng loạt (Batch)
				</button>
			</div>
		</div>
	</div>

	<!-- Notification Banner -->
	{#if submissionSuccess}
		<div class="p-4 rounded-xl bg-emerald-950/40 border border-emerald-800 text-emerald-300 text-sm flex items-center justify-between">
			<div class="flex items-center gap-2">
				<span class="text-lg">✅</span>
				<span>{submissionSuccess}</span>
			</div>
			<button
				type="button"
				class="text-xs underline hover:text-white"
				on:click={() => (submissionSuccess = '')}
			>
				Đóng
			</button>
		</div>
	{/if}

	{#if mode === 'single'}
		<div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
			<!-- Form Left & Middle (2 cols) -->
			<div class="lg:col-span-2 space-y-6">
				<!-- Product Details Card -->
				<div class="bg-zinc-900/90 border border-zinc-800 rounded-2xl p-6 space-y-5">
					<h2 class="text-base font-semibold text-white flex items-center gap-2">
						<span>1. Thông tin sản phẩm</span>
					</h2>

					<div class="space-y-4">
						<div>
							<label for="prod-name" class="block text-xs font-medium text-zinc-300 mb-1">
								Tên sản phẩm <span class="text-red-400">*</span>
							</label>
							<input
								id="prod-name"
								type="text"
								bind:value={productName}
								class="w-full bg-zinc-950 border border-zinc-800 rounded-xl px-3.5 py-2.5 text-sm text-white focus:outline-none focus:border-emerald-500"
								placeholder="VD: Serum Phục Hồi Da B5 Centella 50ml"
							/>
						</div>

						<div class="grid grid-cols-1 md:grid-cols-2 gap-4">
							<div>
								<label for="prod-price" class="block text-xs font-medium text-zinc-300 mb-1">
									Giá bán (VND)
								</label>
								<input
									id="prod-price"
									type="number"
									bind:value={productPrice}
									class="w-full bg-zinc-950 border border-zinc-800 rounded-xl px-3.5 py-2.5 text-sm text-white focus:outline-none focus:border-emerald-500"
									placeholder="VD: 320000"
								/>
							</div>
							<div>
								<label for="prod-desc" class="block text-xs font-medium text-zinc-300 mb-1">
									Mô tả chi tiết sản phẩm
								</label>
								<input
									id="prod-desc"
									type="text"
									bind:value={productDescription}
									class="w-full bg-zinc-950 border border-zinc-800 rounded-xl px-3.5 py-2.5 text-sm text-white focus:outline-none focus:border-emerald-500"
									placeholder="Thành phần chính, công dụng, đối tượng sử dụng..."
								/>
							</div>
						</div>

						<!-- Photos list -->
						<div>
							<div class="flex items-center justify-between mb-2">
								<span class="block text-xs font-medium text-zinc-300">
									Hình ảnh sản phẩm ({imageUrls.length} ảnh) <span class="text-red-400">*</span>
								</span>
								<span class="text-xs text-zinc-400">Tối thiểu 2 ảnh (riêng 360° Spin cần ≥8 ảnh)</span>
							</div>

							<!-- Image tags -->
							<div class="flex flex-wrap gap-2 mb-3">
								{#each imageUrls as url, idx}
									<div class="flex items-center gap-2 bg-zinc-950 border border-zinc-800 px-3 py-1.5 rounded-lg text-xs">
										<span class="text-zinc-400 font-mono">#{idx + 1}</span>
										<span class="max-w-[200px] truncate text-zinc-300">{url}</span>
										<button
											type="button"
											class="text-zinc-500 hover:text-red-400 transition-colors"
											on:click={() => removeImage(idx)}
											title="Xóa ảnh"
										>
											×
										</button>
									</div>
								{/each}
							</div>

							<!-- Add image input -->
							<div class="flex gap-2">
								<input
									type="text"
									bind:value={newImageUrl}
									placeholder="Nhập URL ảnh sản phẩm (https://...)"
									class="flex-1 bg-zinc-950 border border-zinc-800 rounded-xl px-3.5 py-2 text-xs text-white focus:outline-none focus:border-emerald-500"
									on:keydown={(e) => e.key === 'Enter' && addImage()}
								/>
								<button
									type="button"
									on:click={addImage}
									class="px-4 py-2 bg-zinc-800 hover:bg-zinc-700 text-zinc-200 rounded-xl text-xs font-medium transition-colors"
								>
									+ Thêm ảnh
								</button>
							</div>
						</div>
					</div>
				</div>

				<!-- Style Selection Grid (8 Styles) -->
				<div class="bg-zinc-900/90 border border-zinc-800 rounded-2xl p-6 space-y-4">
					<div class="flex items-center justify-between">
						<h2 class="text-base font-semibold text-white flex items-center gap-2">
							<span>2. Chọn phong cách video ({SHOWCASE_STYLES.length} phong cách)</span>
						</h2>
						<span class="text-xs text-zinc-400">Được tối ưu cho thuật toán TikTok & Reels</span>
					</div>

					<div class="grid grid-cols-1 md:grid-cols-2 gap-3">
						{#each SHOWCASE_STYLES as style}
							<div
								role="button"
								tabindex="0"
								class="p-4 rounded-xl border text-left cursor-pointer transition-all {selectedStyleId === style.id
									? 'bg-emerald-950/30 border-emerald-500 shadow-md ring-1 ring-emerald-500/50'
									: 'bg-zinc-950/60 border-zinc-800 hover:border-zinc-700'}"
								on:click={() => (selectedStyleId = style.id)}
								on:keydown={(e) => e.key === 'Enter' && (selectedStyleId = style.id)}
							>
								<div class="flex items-start justify-between gap-2">
									<div class="flex items-center gap-2">
										<span class="text-xl">{style.icon}</span>
										<span class="font-medium text-sm text-white">{style.name}</span>
									</div>
									<div class="flex items-center gap-1.5">
										{#if style.badge}
											<span class="text-[10px] px-1.5 py-0.5 rounded bg-amber-950 text-amber-300 border border-amber-800">
												{style.badge}
											</span>
										{/if}
										<span class="text-xs font-bold text-emerald-400">{style.creditCost} cr</span>
									</div>
								</div>
								<p class="text-xs text-zinc-400 mt-2 line-clamp-2">{style.description}</p>
								<div class="mt-2 text-[11px] text-zinc-500 flex items-center gap-1">
									<span>Yêu cầu: ≥{style.minImages} ảnh</span>
								</div>
							</div>
						{/each}
					</div>
				</div>
			</div>

			<!-- Right Sidebar: Validation & Quote -->
			<div class="space-y-6">
				<!-- Validation Card -->
				<div class="bg-zinc-900/90 border border-zinc-800 rounded-2xl p-6 space-y-4">
					<h3 class="text-sm font-semibold text-white flex items-center gap-2">
						<span>Kiểm định thuộc tính sản phẩm</span>
					</h3>

					<!-- Errors Banner -->
					{#if validation.hasErrors}
						<div class="p-3.5 rounded-xl bg-red-950/40 border border-red-800 text-xs text-red-300 space-y-1.5">
							<div class="font-semibold flex items-center gap-1.5 text-red-200">
								<span>⛔ Phát hiện lỗi cần khắc phục:</span>
							</div>
							{#each validation.errors as err}
								<div class="flex items-start gap-1.5 pl-1">
									<span>•</span>
									<span>{err}</span>
								</div>
							{/each}
						</div>
					{/if}

					<!-- Warnings Banner -->
					{#if validation.hasWarnings}
						<div class="p-3.5 rounded-xl bg-amber-950/30 border border-amber-800 text-xs text-amber-300 space-y-1.5">
							<div class="font-semibold flex items-center gap-1.5 text-amber-200">
								<span>⚠️ Lưu ý & Khuyến nghị chất lượng:</span>
							</div>
							{#each validation.warnings as warn}
								<div class="flex items-start gap-1.5 pl-1">
									<span>•</span>
									<span>{warn}</span>
								</div>
							{/each}
						</div>
					{/if}

					{#if !validation.hasErrors && !validation.hasWarnings}
						<div class="p-3 rounded-xl bg-emerald-950/30 border border-emerald-800 text-xs text-emerald-300 flex items-center gap-2">
							<span>✨</span>
							<span>Dữ liệu sản phẩm đầy đủ và đạt chuẩn 100%!</span>
						</div>
					{/if}

					<div class="border-t border-zinc-800 pt-4 space-y-2 text-xs">
						<div class="flex justify-between text-zinc-400">
							<span>Phong cách đã chọn:</span>
							<span class="font-medium text-white">{selectedStyle.name}</span>
						</div>
						<div class="flex justify-between text-zinc-400">
							<span>Thời lượng video:</span>
							<span class="text-zinc-200">15 giây (Chuẩn)</span>
						</div>
						<div class="flex justify-between text-zinc-400">
							<span>Số lượng ảnh sử dụng:</span>
							<span class="text-zinc-200">{imageUrls.length} ảnh</span>
						</div>
						<div class="flex justify-between text-zinc-400 pt-2 border-t border-zinc-800/80">
							<span class="font-semibold text-zinc-200">Chi phí dự toán:</span>
							<span class="text-base font-bold text-emerald-400">{quoteCredits} credits</span>
						</div>
					</div>

					<button
						type="button"
						disabled={!canSubmitSingle || isSubmitting}
						on:click={submitSingle}
						class="w-full py-3 rounded-xl font-semibold text-sm transition-all {canSubmitSingle && !isSubmitting
							? 'bg-emerald-600 hover:bg-emerald-500 text-white shadow-lg shadow-emerald-900/40 cursor-pointer'
							: 'bg-zinc-800 text-zinc-500 cursor-not-allowed'}"
					>
						{isSubmitting ? 'Đang khởi tạo tác vụ...' : `Tạo Showcase ngay (${quoteCredits} cr)`}
					</button>
				</div>
			</div>
		</div>
	{:else}
		<!-- Batch Mode (Up to 20 products) -->
		<div class="bg-zinc-900/90 border border-zinc-800 rounded-2xl p-6 space-y-6">
			<div class="flex flex-col md:flex-row md:items-center justify-between gap-4 border-b border-zinc-800 pb-4">
				<div>
					<h2 class="text-lg font-bold text-white flex items-center gap-2">
						<span>📦 Chế độ tạo hàng loạt (Batch Studio)</span>
						<span class="text-xs px-2 py-0.5 rounded-full bg-zinc-800 text-zinc-300">
							Tối đa 20 sản phẩm
						</span>
					</h2>
					<p class="text-xs text-zinc-400 mt-0.5">
						Hệ thống tự động phát hiện hàng hợp lệ/không hợp lệ. Chỉ thu phí các hàng hợp lệ, hàng lỗi được đánh dấu đỏ và 0 credit.
					</p>
				</div>

				<div class="flex items-center gap-4">
					<div class="flex items-center gap-3 text-xs">
						<span class="text-emerald-400 font-medium">✓ {batchAnalysis.validCount} hợp lệ</span>
						<span class="text-red-400 font-medium">✕ {batchAnalysis.invalidCount} lỗi</span>
						<span class="text-zinc-200 font-bold bg-zinc-950 px-2.5 py-1 rounded-lg border border-zinc-800">
							Tổng: {batchAnalysis.totalCredits} credits
						</span>
					</div>
					<button
						type="button"
						disabled={batchRows.length >= 20}
						on:click={addBatchRow}
						class="px-3.5 py-1.5 rounded-xl bg-zinc-800 hover:bg-zinc-700 text-zinc-200 text-xs font-medium transition-colors"
					>
						+ Thêm hàng ({batchRows.length}/20)
					</button>
				</div>
			</div>

			<!-- Batch Table -->
			<div class="overflow-x-auto">
				<table class="w-full text-left text-xs border-collapse">
					<thead>
						<tr class="border-b border-zinc-800 text-zinc-400">
							<th class="py-2.5 px-3">#</th>
							<th class="py-2.5 px-3">Tên sản phẩm</th>
							<th class="py-2.5 px-3">Phong cách</th>
							<th class="py-2.5 px-3">Số ảnh</th>
							<th class="py-2.5 px-3">Giá bán</th>
							<th class="py-2.5 px-3">Trạng thái & Lỗi giải thích</th>
							<th class="py-2.5 px-3 text-right">Chi phí</th>
							<th class="py-2.5 px-2"></th>
						</tr>
					</thead>
					<tbody class="divide-y divide-zinc-800/60">
						{#each batchAnalysis.items as row, idx}
							<tr class="{row.isValid ? 'hover:bg-zinc-800/30' : 'bg-red-950/20 hover:bg-red-950/30'}">
								<td class="py-3 px-3 font-mono text-zinc-500">{idx + 1}</td>
								<td class="py-3 px-3 font-medium text-white max-w-[220px] truncate">
									{batchRows[idx].name}
								</td>
								<td class="py-3 px-3">
									<select
										bind:value={batchRows[idx].style}
										class="bg-zinc-950 border border-zinc-800 rounded-lg px-2 py-1 text-xs text-zinc-200 focus:outline-none focus:border-emerald-500"
									>
										{#each SHOWCASE_STYLES as s}
											<option value={s.id}>{s.name} ({s.creditCost} cr)</option>
										{/each}
									</select>
								</td>
								<td class="py-3 px-3 text-zinc-300 font-mono">
									{batchRows[idx].imageUrls.length} ảnh
								</td>
								<td class="py-3 px-3 text-zinc-300 font-mono">
									{batchRows[idx].price.toLocaleString('vi-VN')} đ
								</td>
								<td class="py-3 px-3">
									{#if row.isValid}
										<div class="flex items-center gap-1.5 text-emerald-400 font-medium">
											<span>✓ Hợp lệ</span>
											{#if row.validation.hasWarnings}
												<span class="text-[10px] text-amber-400 font-normal">({row.validation.warnings.length} lưu ý)</span>
											{/if}
										</div>
									{:else}
										<div class="text-red-400 space-y-0.5">
											<span class="font-medium">✕ Không hợp lệ:</span>
											{#each row.validation.errors as err}
												<div class="text-[11px] text-red-300">{err}</div>
											{/each}
										</div>
									{/if}
								</td>
								<td class="py-3 px-3 text-right font-mono font-bold {row.isValid ? 'text-emerald-400' : 'text-zinc-600'}">
									{row.creditCost} cr
								</td>
								<td class="py-3 px-2 text-right">
									<button
										type="button"
										on:click={() => removeBatchRow(idx)}
										class="text-zinc-600 hover:text-red-400 transition-colors p-1"
										title="Xóa hàng"
									>
										✕
									</button>
								</td>
							</tr>
						{/each}
					</tbody>
				</table>
			</div>

			<!-- Batch Confirmation Footer -->
			<div class="flex flex-col md:flex-row md:items-center justify-between gap-4 pt-4 border-t border-zinc-800">
				<div class="text-xs text-zinc-400">
					Hàng có lỗi sẽ được tự động bỏ qua khi xác nhận tạo. Bạn có thể sửa trực tiếp hoặc xóa hàng trước khi gửi.
				</div>

				<div class="flex items-center gap-3">
					<button
						type="button"
						disabled={batchAnalysis.validCount === 0 || isSubmitting || userBalance < batchAnalysis.totalCredits}
						on:click={submitBatch}
						class="px-6 py-2.5 rounded-xl font-semibold text-sm transition-all {batchAnalysis.validCount > 0 && userBalance >= batchAnalysis.totalCredits && !isSubmitting
							? 'bg-emerald-600 hover:bg-emerald-500 text-white shadow-lg shadow-emerald-900/40 cursor-pointer'
							: 'bg-zinc-800 text-zinc-500 cursor-not-allowed'}"
					>
						{isSubmitting ? 'Đang xử lý batch...' : `Xác nhận tạo ${batchAnalysis.validCount} sản phẩm (${batchAnalysis.totalCredits} cr)`}
					</button>
				</div>
			</div>
		</div>
	{/if}
</div>
