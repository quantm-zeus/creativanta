<script lang="ts">
	import { onDestroy } from 'svelte';
	import {
		MOTION_STYLES,
		MOTION_PRESETS,
		estimateImageToVideoCredits,
		requestImageToVideoGenerationRemote,
		type MotionStyleOption,
		type MotionPresetOption
	} from '$lib/production';
	import { authStore, registerAuthResetHook } from '$lib/auth';

	interface StudioImage {
		id: string;
		url: string;
		name: string;
		durationSeconds: number;
		customMotionStyle?: string;
	}

	let images: StudioImage[] = [
		{
			id: 'img-1',
			url: 'https://cdn.example.com/assets/sneaker_hero.jpg',
			name: 'sneaker_hero.jpg',
			durationSeconds: 4,
			customMotionStyle: 'parallax_3d'
		},
		{
			id: 'img-2',
			url: 'https://cdn.example.com/assets/sneaker_side.jpg',
			name: 'sneaker_side.jpg',
			durationSeconds: 3,
			customMotionStyle: 'orbit_3d'
		},
		{
			id: 'img-3',
			url: 'https://cdn.example.com/assets/sneaker_sole.jpg',
			name: 'sneaker_sole.jpg',
			durationSeconds: 3,
			customMotionStyle: 'dolly_zoom'
		}
	];

	let newImageUrl = '';
	let selectedMotionStyleId = 'parallax_3d';
	let selectedPresetId = 'product_focus';
	let qualityTier: 'draft' | 'standard' | 'premium' = 'standard';
	let isLoop = false;
	let durationSeconds = 10;
	let motionIntensity = 75;
	let transitionType = 'crossfade';
	let attachBgm = true;

	let userBalance = 320;
	let isGenerating = false;
	let successMessage = '';
	let validationError = '';
	let pendingServerQuote: {
		quoteId: string;
		quotedCredits: string;
		quoteExpiresAt?: string;
		userId?: string;
		workspaceId?: string;
	} | null = null;
	let lastSessionKey = '';

	const unregisterResetHook = registerAuthResetHook(() => {
		pendingServerQuote = null;
		validationError = '';
		successMessage = '';
	});

	onDestroy(() => {
		unregisterResetHook();
	});

	$: currentSessionKey =
		$authStore.state === 'authenticated' && $authStore.user?.id && $authStore.activeWorkspace?.id
			? `${$authStore.user.id}::${$authStore.activeWorkspace.id}`
			: '';

	$: {
		if (!currentSessionKey || (lastSessionKey && lastSessionKey !== currentSessionKey)) {
			pendingServerQuote = null;
		}
		lastSessionKey = currentSessionKey;
	}

	$: totalCalculatedDuration = images.reduce((sum, img) => sum + img.durationSeconds, 0);

	$: quoteCredits = estimateImageToVideoCredits(qualityTier, isLoop);

	$: {
		images;
		selectedMotionStyleId;
		selectedPresetId;
		qualityTier;
		isLoop;
		durationSeconds;
		motionIntensity;
		transitionType;
		attachBgm;
		pendingServerQuote = null;
	}

	function applyPreset(presetId: string) {
		const preset = MOTION_PRESETS.find((p) => p.id === presetId);
		if (!preset) return;
		selectedPresetId = preset.id;
		selectedMotionStyleId = preset.motionStyle;
		durationSeconds = preset.durationSeconds;
		isLoop = preset.loopable;
	}

	function addImage() {
		if (!newImageUrl.trim()) return;
		if (images.length >= 20) {
			validationError = 'Tối đa 20 ảnh trong một dự án Image-to-Video';
			return;
		}
		validationError = '';
		const newId = `img-${Date.now().toString().slice(-4)}`;
		images = [
			...images,
			{
				id: newId,
				url: newImageUrl.trim(),
				name: `image_${images.length + 1}.jpg`,
				durationSeconds: 3,
				customMotionStyle: selectedMotionStyleId
			}
		];
		newImageUrl = '';
	}

	function removeImage(id: string) {
		if (images.length <= 1) {
			validationError = 'Cần ít nhất 1 ảnh để tạo Image-to-Video';
			return;
		}
		validationError = '';
		images = images.filter((img) => img.id !== id);
	}

	async function generateVideo() {
		if (images.length === 0) {
			validationError = 'Vui lòng thêm ít nhất 1 ảnh';
			return;
		}
		if (userBalance < quoteCredits) {
			validationError = 'Số dư credits không đủ';
			return;
		}

		isGenerating = true;
		validationError = '';
		successMessage = '';
		pendingServerQuote = null;
		try {
			const res = await requestImageToVideoGenerationRemote({
				workspaceId: $authStore.activeWorkspace?.id,
				images,
				selectedMotionStyleId,
				motionIntensity,
				aspectRatio: '9:16',
				selectedTransitionId: transitionType,
				customPrompt: `${selectedPresetId} (${qualityTier}, ${durationSeconds}s, loop=${isLoop}, bgm=${attachBgm})`,
				qualityTier,
				isLoop,
				durationSeconds,
				attachBgm,
				quoteCredits,
				availableBalance: userBalance,
				requirePreflightQuote: true
			});

			if (res.requiresConfirmation && res.quoteId && res.quotedCredits) {
				pendingServerQuote = {
					quoteId: res.quoteId,
					quotedCredits: res.quotedCredits,
					quoteExpiresAt: res.quoteExpiresAt,
					userId: $authStore.user?.id,
					workspaceId: $authStore.activeWorkspace?.id
				};
				validationError =
					res.error ||
					`Báo giá thực tế từ máy chủ (${res.quotedCredits} cr) cao hơn mức dự toán (${quoteCredits} cr). Vui lòng xác nhận trước khi tiếp tục.`;
				return;
			}

			if (!res.ok || !res.jobId) {
				validationError =
					res.error ||
					'Không thể khởi tạo tác vụ Image-to-Video trên máy chủ. Số dư credits và cấu hình ảnh được giữ nguyên.';
				return;
			}

			userBalance = res.remainingBalance ?? userBalance;
			successMessage = `Đã gửi tác vụ Image-to-Video thành công! Mã tác vụ: ${res.jobId}. Đã tạm giữ ${res.reservedCredits ?? quoteCredits} credits.`;
		} finally {
			isGenerating = false;
		}
	}

	async function confirmServerQuoteAndGenerate() {
		if (!pendingServerQuote) return;
		if (
			(pendingServerQuote.userId && pendingServerQuote.userId !== $authStore.user?.id) ||
			(pendingServerQuote.workspaceId &&
				pendingServerQuote.workspaceId !== $authStore.activeWorkspace?.id)
		) {
			pendingServerQuote = null;
			validationError = 'Ngữ cảnh phiên hoặc workspace đã thay đổi. Vui lòng lấy báo giá mới (fail-closed).';
			return;
		}
		const confirmedNum = Number(pendingServerQuote.quotedCredits);
		if (!Number.isFinite(confirmedNum) || userBalance < confirmedNum) {
			validationError = 'Số dư credits không đủ cho báo giá máy chủ';
			return;
		}

		const activePending = pendingServerQuote;
		isGenerating = true;
		validationError = '';
		successMessage = '';
		try {
			const res = await requestImageToVideoGenerationRemote({
				workspaceId: $authStore.activeWorkspace?.id,
				images,
				selectedMotionStyleId,
				motionIntensity,
				aspectRatio: '9:16',
				selectedTransitionId: transitionType,
				customPrompt: `${selectedPresetId} (${qualityTier}, ${durationSeconds}s, loop=${isLoop}, bgm=${attachBgm})`,
				qualityTier,
				isLoop,
				durationSeconds,
				attachBgm,
				quoteCredits: confirmedNum,
				availableBalance: userBalance,
				quoteId: activePending.quoteId,
				quoteExpiresAt: activePending.quoteExpiresAt,
				confirmedCredits: activePending.quotedCredits,
				requirePreflightQuote: false
			});

			if (!res.ok || !res.jobId) {
				validationError =
					res.error ||
					'Không thể khởi tạo tác vụ Image-to-Video trên máy chủ sau khi xác nhận báo giá.';
				return;
			}

			pendingServerQuote = null;
			userBalance = res.remainingBalance ?? userBalance;
			successMessage = `Đã gửi tác vụ Image-to-Video thành công! Mã tác vụ: ${res.jobId}. Đã tạm giữ ${res.reservedCredits ?? confirmedNum} credits.`;
		} finally {
			isGenerating = false;
		}
	}
</script>

<svelte:head>
	<title>Image to Video Studio (W035) — Creativanta</title>
</svelte:head>

<div class="min-h-screen bg-zinc-950 text-zinc-100 p-6 max-w-7xl mx-auto space-y-6">
	<!-- Breadcrumbs & Header -->
	<div class="flex flex-col md:flex-row md:items-center justify-between gap-4 border-b border-zinc-800 pb-5">
		<div>
			<div class="flex items-center gap-2 text-sm text-zinc-400 mb-1">
				<a href="/studio" class="hover:text-emerald-400 transition-colors">AI Video Studio</a>
				<span>/</span>
				<span class="text-zinc-200">Image to Video Studio (W035 · EF-02)</span>
			</div>
			<h1 class="text-2xl font-bold tracking-tight text-white flex items-center gap-3">
				<span>📸 Image to Video Studio</span>
				<span class="text-xs px-2.5 py-0.5 rounded-full bg-blue-950/80 text-blue-300 border border-blue-800">
					6 Chuyển Động · Đa Khung Hình
				</span>
			</h1>
			<p class="text-sm text-zinc-400 mt-1">
				Thổi bùng sức sống cho ảnh tĩnh với chuyển động máy quay 3D, dolly zoom và hiệu ứng chuyển cảnh điện ảnh.
			</p>
		</div>

		<div class="bg-zinc-900 border border-zinc-800 px-4 py-2 rounded-xl text-right">
			<div class="text-xs text-zinc-400">Số dư khả dụng</div>
			<div class="text-lg font-bold text-emerald-400">{userBalance} credits</div>
		</div>
	</div>

	<!-- Notifications -->
	{#if successMessage}
		<div class="p-4 rounded-xl bg-emerald-950/40 border border-emerald-800 text-emerald-300 text-sm flex items-center justify-between">
			<div class="flex items-center gap-2">
				<span>🎉</span>
				<span>{successMessage}</span>
			</div>
			<button type="button" class="text-xs underline hover:text-white" on:click={() => (successMessage = '')}>
				Đóng
			</button>
		</div>
	{/if}

	{#if validationError}
		<div class="p-4 rounded-xl bg-red-950/40 border border-red-800 text-red-300 text-sm flex items-center justify-between">
			<div class="flex items-center gap-2">
				<span>⚠️</span>
				<span>{validationError}</span>
			</div>
			<button type="button" class="text-xs underline hover:text-white" on:click={() => (validationError = '')}>
				Đóng
			</button>
		</div>
	{/if}

	<div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
		<!-- Left & Middle: Image list & Motion Settings -->
		<div class="lg:col-span-2 space-y-6">
			<!-- Image Sequencer -->
			<div class="bg-zinc-900/90 border border-zinc-800 rounded-2xl p-6 space-y-4">
				<div class="flex items-center justify-between">
					<h2 class="text-base font-semibold text-white flex items-center gap-2">
						<span>1. Danh sách ảnh chuỗi chuyển động ({images.length}/20 ảnh)</span>
					</h2>
					<span class="text-xs text-zinc-400">Thời lượng dự tính: {totalCalculatedDuration}s</span>
				</div>

				<!-- Image cards -->
				<div class="space-y-3">
					{#each images as img, idx}
						<div class="bg-zinc-950 border border-zinc-800 rounded-xl p-3.5 flex flex-col sm:flex-row sm:items-center justify-between gap-3">
							<div class="flex items-center gap-3">
								<span class="text-xs font-mono text-zinc-500 bg-zinc-900 px-2 py-1 rounded">#{idx + 1}</span>
								<div>
									<div class="text-xs font-medium text-white max-w-[200px] truncate">{img.name}</div>
									<div class="text-[11px] text-zinc-500 truncate max-w-[240px]">{img.url}</div>
								</div>
							</div>

							<div class="flex items-center gap-3">
								<div class="flex items-center gap-1.5 text-xs text-zinc-400">
									<label for="dur-{img.id}" class="text-[11px]">Thời lượng:</label>
									<select
										id="dur-{img.id}"
										bind:value={img.durationSeconds}
										class="bg-zinc-900 border border-zinc-800 rounded-lg px-2 py-1 text-xs text-white"
									>
										<option value={2}>2s</option>
										<option value={3}>3s</option>
										<option value={4}>4s</option>
										<option value={5}>5s</option>
									</select>
								</div>

								<div class="flex items-center gap-1.5 text-xs text-zinc-400">
									<label for="mot-{img.id}" class="text-[11px]">Chuyển động:</label>
									<select
										id="mot-{img.id}"
										bind:value={img.customMotionStyle}
										class="bg-zinc-900 border border-zinc-800 rounded-lg px-2 py-1 text-xs text-white"
									>
										{#each MOTION_STYLES as s}
											<option value={s.id}>{s.name}</option>
										{/each}
									</select>
								</div>

								<button
									type="button"
									class="text-zinc-500 hover:text-red-400 p-1 text-xs transition-colors"
									on:click={() => removeImage(img.id)}
									title="Xóa ảnh này"
								>
									✕
								</button>
							</div>
						</div>
					{/each}
				</div>

				<!-- Add image -->
				<div class="flex gap-2 pt-2">
					<input
						type="text"
						bind:value={newImageUrl}
						placeholder="Nhập URL ảnh tiếp theo (https://...)"
						class="flex-1 bg-zinc-950 border border-zinc-800 rounded-xl px-3.5 py-2 text-xs text-white focus:outline-none focus:border-blue-500"
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

			<!-- Presets Selection -->
			<div class="bg-zinc-900/90 border border-zinc-800 rounded-2xl p-6 space-y-4">
				<h2 class="text-base font-semibold text-white flex items-center gap-2">
					<span>2. Cài đặt sẵn (Presets)</span>
				</h2>

				<div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
					{#each MOTION_PRESETS as preset}
						<div
							role="button"
							tabindex="0"
							class="p-3.5 rounded-xl border text-left cursor-pointer transition-all {selectedPresetId === preset.id
								? 'bg-blue-950/40 border-blue-500 shadow-md ring-1 ring-blue-500/50'
								: 'bg-zinc-950/60 border-zinc-800 hover:border-zinc-700'}"
							on:click={() => applyPreset(preset.id)}
							on:keydown={(e) => e.key === 'Enter' && applyPreset(preset.id)}
						>
							<div class="flex items-center justify-between">
								<span class="text-sm font-semibold text-white">{preset.name}</span>
								<span class="text-xs font-mono text-zinc-400">{preset.durationSeconds}s</span>
							</div>
							<p class="text-xs text-zinc-400 mt-1.5">{preset.description}</p>
							<div class="mt-2 text-[11px] text-blue-400 flex items-center gap-2">
								<span>Hiệu ứng: {preset.motionStyle}</span>
								{#if preset.loopable}
									<span class="bg-blue-950 px-1.5 py-0.5 rounded border border-blue-800 text-[10px]">Lặp vô tận</span>
								{/if}
							</div>
						</div>
					{/each}
				</div>
			</div>

			<!-- 6 Motion Styles Grid -->
			<div class="bg-zinc-900/90 border border-zinc-800 rounded-2xl p-6 space-y-4">
				<h2 class="text-base font-semibold text-white flex items-center gap-2">
					<span>3. Kiểu chuyển động mặc định ({MOTION_STYLES.length} kiểu)</span>
				</h2>

				<div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-3">
					{#each MOTION_STYLES as style}
						<div
							role="button"
							tabindex="0"
							class="p-3 rounded-xl border text-left cursor-pointer transition-all {selectedMotionStyleId === style.id
								? 'bg-blue-950/40 border-blue-500 shadow-md ring-1 ring-blue-500/50'
								: 'bg-zinc-950/60 border-zinc-800 hover:border-zinc-700'}"
							on:click={() => (selectedMotionStyleId = style.id)}
							on:keydown={(e) => e.key === 'Enter' && (selectedMotionStyleId = style.id)}
						>
							<div class="flex items-center gap-2">
								<span class="text-xl">{style.icon}</span>
								<span class="text-xs font-semibold text-white">{style.name}</span>
							</div>
							<p class="text-[11px] text-zinc-400 mt-1.5 line-clamp-2">{style.description}</p>
						</div>
					{/each}
				</div>
			</div>
		</div>

		<!-- Right Sidebar: Configuration, Tiers & Credits -->
		<div class="space-y-6">
			<div class="bg-zinc-900/90 border border-zinc-800 rounded-2xl p-6 space-y-5">
				<h3 class="text-sm font-semibold text-white">Tùy biến & Báo giá chi tiết</h3>

				<!-- Quality Tiers -->
				<div class="space-y-2">
					<span class="text-xs font-medium text-zinc-300">Phân hạng chất lượng:</span>
					<div class="grid grid-cols-3 gap-2">
						<button
							type="button"
							class="py-2 px-2 rounded-xl text-xs font-semibold border transition-all {qualityTier === 'draft'
								? 'bg-blue-600 text-white border-blue-500 shadow'
								: 'bg-zinc-950 border-zinc-800 text-zinc-400 hover:text-white'}"
							on:click={() => (qualityTier = 'draft')}
						>
							Draft (5 cr)
						</button>
						<button
							type="button"
							class="py-2 px-2 rounded-xl text-xs font-semibold border transition-all {qualityTier === 'standard'
								? 'bg-blue-600 text-white border-blue-500 shadow'
								: 'bg-zinc-950 border-zinc-800 text-zinc-400 hover:text-white'}"
							on:click={() => (qualityTier = 'standard')}
						>
							Standard (10 cr)
						</button>
						<button
							type="button"
							class="py-2 px-2 rounded-xl text-xs font-semibold border transition-all {qualityTier === 'premium'
								? 'bg-blue-600 text-white border-blue-500 shadow'
								: 'bg-zinc-950 border-zinc-800 text-zinc-400 hover:text-white'}"
							on:click={() => (qualityTier = 'premium')}
						>
							Premium (25 cr)
						</button>
					</div>
				</div>

				<!-- Duration -->
				<div class="space-y-2">
					<div class="flex justify-between text-xs">
						<span class="text-zinc-300">Thời lượng video tổng:</span>
						<span class="text-white font-mono">{durationSeconds}s</span>
					</div>
					<div class="grid grid-cols-4 gap-2">
						{#each [3, 5, 10, 15] as dur}
							<button
								type="button"
								class="py-1.5 rounded-lg text-xs font-medium border {durationSeconds === dur
									? 'bg-zinc-800 border-zinc-600 text-white'
									: 'bg-zinc-950 border-zinc-800 text-zinc-400 hover:text-white'}"
								on:click={() => (durationSeconds = dur)}
							>
								{dur}s
							</button>
						{/each}
					</div>
				</div>

				<!-- Loop toggle -->
				<div class="flex items-center justify-between pt-1">
					<div>
						<div class="text-xs font-medium text-white">Vòng lặp liền mạch (Loopable)</div>
						<div class="text-[11px] text-zinc-400">Khớp khung hình đầu và cuối (+5 cr)</div>
					</div>
					<input
						type="checkbox"
						bind:checked={isLoop}
						class="w-4 h-4 accent-blue-600 rounded bg-zinc-950 border-zinc-800"
					/>
				</div>

				<!-- Motion intensity slider -->
				<div class="space-y-1.5 pt-1">
					<div class="flex justify-between text-xs">
						<span class="text-zinc-300">Cường độ chuyển động:</span>
						<span class="text-white font-mono">{motionIntensity}%</span>
					</div>
					<input
						type="range"
						min="10"
						max="100"
						bind:value={motionIntensity}
						class="w-full accent-blue-600 bg-zinc-950"
					/>
				</div>

				<!-- Transition type -->
				<div class="space-y-1.5 pt-1">
					<label for="trans-select" class="text-xs text-zinc-300 block">Hiệu ứng chuyển cảnh giữa ảnh:</label>
					<select
						id="trans-select"
						bind:value={transitionType}
						class="w-full bg-zinc-950 border border-zinc-800 rounded-xl px-3 py-2 text-xs text-white"
					>
						<option value="crossfade">Crossfade (Hòa tan dịu nhẹ)</option>
						<option value="cut">Hard Cut (Cắt trực diện)</option>
						<option value="morph">Fluid Morph (Biến dạng hình khối)</option>
						<option value="glitch">Glitch (Nhiễu sóng hiện đại)</option>
					</select>
				</div>

				<!-- Quote summary -->
				<div class="border-t border-zinc-800 pt-4 space-y-2 text-xs">
					<div class="flex justify-between text-zinc-400">
						<span>Phân hạng:</span>
						<span class="font-medium text-white uppercase">{qualityTier}</span>
					</div>
					<div class="flex justify-between text-zinc-400">
						<span>Vòng lặp (Loop):</span>
						<span class="text-zinc-200">{isLoop ? '+5 credits' : 'Tắt (0 cr)'}</span>
					</div>
					<div class="flex justify-between text-zinc-400 pt-2 border-t border-zinc-800/80">
						<span class="font-semibold text-zinc-200">Chi phí dự toán:</span>
						<span class="text-base font-bold text-emerald-400">{quoteCredits} credits</span>
					</div>
				</div>

				{#if pendingServerQuote}
					<div class="p-3.5 rounded-xl bg-amber-950/50 border border-amber-700 space-y-2.5 text-xs">
						<div class="font-semibold text-amber-300">
							Yêu cầu xác nhận báo giá máy chủ ({pendingServerQuote.quotedCredits} credits)
						</div>
						<p class="text-amber-200/90 leading-relaxed">
							Báo giá thực tế từ máy chủ cho cấu hình hiện tại là <strong>{pendingServerQuote.quotedCredits} credits</strong> (dự toán cục bộ: {quoteCredits} credits). Hệ thống chưa trừ credits của bạn.
						</p>
						<div class="flex gap-2 pt-1">
							<button
								type="button"
								disabled={isGenerating || userBalance < Number(pendingServerQuote.quotedCredits)}
								on:click={confirmServerQuoteAndGenerate}
								class="flex-1 py-2 px-3 rounded-lg bg-amber-600 hover:bg-amber-500 text-white font-semibold transition-colors cursor-pointer disabled:opacity-50"
							>
								Xác nhận & Tạo ({pendingServerQuote.quotedCredits} cr)
							</button>
							<button
								type="button"
								disabled={isGenerating}
								on:click={() => {
									pendingServerQuote = null;
									validationError = '';
								}}
								class="py-2 px-3 rounded-lg bg-zinc-800 hover:bg-zinc-700 text-zinc-200 transition-colors cursor-pointer"
							>
								Hủy bỏ
							</button>
						</div>
					</div>
				{/if}

				<button
					type="button"
					disabled={isGenerating || userBalance < quoteCredits}
					on:click={generateVideo}
					class="w-full py-3 rounded-xl font-semibold text-sm transition-all {userBalance >= quoteCredits && !isGenerating
						? 'bg-blue-600 hover:bg-blue-500 text-white shadow-lg shadow-blue-900/40 cursor-pointer'
						: 'bg-zinc-800 text-zinc-500 cursor-not-allowed'}"
				>
					{isGenerating ? 'Đang kết xuất chuyển động...' : `Tạo Video (${quoteCredits} cr)`}
				</button>
			</div>
		</div>
	</div>
</div>
