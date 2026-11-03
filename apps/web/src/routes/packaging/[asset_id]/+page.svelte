<script lang="ts">
	import { page } from '$app/stores';
	import { calculatePackagingScore } from '$lib/production/derivative_packaging';
	import type { PackagingReport } from '$lib/production/types';
	import PackagingQAPanel from '$lib/production/PackagingQAPanel.svelte';

	const assetId = $page.params.asset_id || 'asset-demo-001';

	// Packaging form state
	let targetPlatform = 'tiktok';
	let title = 'Bật mí mẹo tăng view tự nhiên với kịch bản chuyển đổi cao';
	let caption = 'Chia sẻ cách tối ưu 3 giây đầu tiên cho video ngắn của bạn. Xem chi tiết tại link bio!';
	let hashtagsInput = '#xuhuong, #kinhdoanh, #marketing';
	let cta = 'Lưu lại và áp dụng ngay hôm nay!';
	let disclosure = '';
	let isCommercial = false;
	let hasCopyrightViolation = false;
	let userRole = 'Manager'; // Simulates current workspace role

	// Presets
	const presets = [
		{ id: 'custom', name: 'Tùy chỉnh (Custom)' },
		{ id: 'tiktok_commerce', name: 'TikTok Shop / Affiliate' },
		{ id: 'yt_shorts_viral', name: 'YouTube Shorts Viral' },
		{ id: 'reels_branding', name: 'Reels Aesthetic Branding' }
	];
	let selectedPreset = 'custom';

	function applyPreset(presetId: string) {
		selectedPreset = presetId;
		if (presetId === 'tiktok_commerce') {
			targetPlatform = 'tiktok';
			isCommercial = true;
			disclosure = '#ad #affiliate';
			cta = 'Nhấn vào giỏ hàng vàng góc trái';
			hashtagsInput = '#tiktokshop, #muataitiktok, #review';
		} else if (presetId === 'yt_shorts_viral') {
			targetPlatform = 'youtube_shorts';
			isCommercial = false;
			disclosure = '';
			cta = 'Đăng ký kênh để xem phần 2';
			hashtagsInput = '#shorts, #viral, #trending';
		} else if (presetId === 'reels_branding') {
			targetPlatform = 'instagram_reels';
			isCommercial = false;
			disclosure = '';
			cta = 'Follow @creativanta để nhận tài liệu';
			hashtagsInput = '#reels, #business, #growth';
		}
	}

	// Live calculated packaging report
	$: hashtags = hashtagsInput.split(',').map((h) => h.trim().replace(/^#/, '')).filter((h) => h.length > 0);

	$: report = calculatePackagingScore({
		assetId,
		publishItemId: `pub-${assetId}`,
		targetPlatform,
		title,
		caption,
		hashtags,
		cta,
		disclosure,
		isCommercial,
		hasCopyrightViolation
	});

	function handleReportUpdated(updated: PackagingReport) {
		report = updated;
	}
</script>

<svelte:head>
	<title>Packaging QA & Pre-publish Scorecard | Creativanta</title>
</svelte:head>

<div class="min-h-screen bg-gray-950 text-white p-6 md:p-8 space-y-6">
	<!-- Page Header -->
	<div class="flex flex-col md:flex-row md:items-center justify-between gap-4 border-b border-gray-800 pb-6">
		<div>
			<div class="flex items-center gap-2 text-xs text-gray-400">
				<a href="/studio/derivatives" class="hover:text-blue-400">Thư viện phái sinh</a>
				<span>/</span>
				<span>Packaging QA</span>
			</div>
			<h1 class="text-2xl font-bold flex items-center gap-3 mt-1">
				<span>📦</span>
				<span>Kiểm định đóng gói trước xuất bản (Packaging QA)</span>
			</h1>
			<p class="text-sm text-gray-400 mt-1">
				Mã tài nguyên: <strong class="text-blue-400 font-mono">{assetId}</strong> • Nền tảng: <strong class="capitalize text-white">{targetPlatform}</strong>
			</p>
		</div>

		<!-- Simulation Role Switcher for Testing -->
		<div class="flex items-center gap-2 bg-gray-900 border border-gray-800 p-2 rounded-lg text-xs">
			<span class="text-gray-400">Vai trò thử nghiệm:</span>
			<select
				bind:value={userRole}
				class="bg-gray-800 border border-gray-700 rounded px-2 py-1 text-white focus:outline-none"
			>
				<option value="Editor">Editor (Không có quyền Override)</option>
				<option value="Manager">Manager (Có quyền Override cảnh báo)</option>
				<option value="Owner">Owner (Không thể Override lỗi chặn cứng)</option>
			</select>
		</div>
	</div>

	<!-- Two Column Layout: Form Inputs on Left, Live Scorecard on Right -->
	<div class="grid grid-cols-1 lg:grid-cols-12 gap-6 items-start">
		<!-- Left: Packaging Customization Editor (5 Cols) -->
		<div class="lg:col-span-5 bg-gray-900/60 border border-gray-800 rounded-xl p-6 space-y-5 text-xs">
			<div class="flex items-center justify-between border-b border-gray-800 pb-3">
				<h2 class="font-bold text-sm text-white">Thiết lập gói nội dung (Packaging Metadata)</h2>
				<select
					bind:value={selectedPreset}
					on:change={() => applyPreset(selectedPreset)}
					class="bg-gray-800 border border-gray-700 rounded px-2 py-1 text-xs text-blue-400"
				>
					{#each presets as p}
						<option value={p.id}>{p.name}</option>
					{/each}
				</select>
			</div>

			<!-- Title -->
			<div class="space-y-1.5">
				<div class="flex justify-between items-center">
					<label for="titleInput" class="font-semibold text-gray-300">Tiêu đề / Hook văn bản (Title):</label>
					<span class="text-gray-500 text-[10px]">{title.length} ký tự</span>
				</div>
				<input
					id="titleInput"
					type="text"
					bind:value={title}
					placeholder="Tiêu đề gợi mở tò mò hoặc chứa từ khóa hấp dẫn..."
					class="w-full bg-gray-800 border border-gray-700 rounded-lg p-2.5 text-white placeholder-gray-500 focus:outline-none focus:border-blue-500"
				/>
			</div>

			<!-- Caption -->
			<div class="space-y-1.5">
				<div class="flex justify-between items-center">
					<label for="captionInput" class="font-semibold text-gray-300">Mô tả bài đăng (Caption):</label>
					<span class="text-gray-500 text-[10px]">{caption.length} ký tự</span>
				</div>
				<textarea
					id="captionInput"
					bind:value={caption}
					rows="3"
					placeholder="Nội dung mô tả chi tiết thu hút tương tác..."
					class="w-full bg-gray-800 border border-gray-700 rounded-lg p-2.5 text-white placeholder-gray-500 focus:outline-none focus:border-blue-500"
				></textarea>
			</div>

			<!-- Hashtags -->
			<div class="space-y-1.5">
				<label for="hashtagsInput" class="font-semibold text-gray-300">Hashtags (phân cách bằng dấu phẩy):</label>
				<input
					id="hashtagsInput"
					type="text"
					bind:value={hashtagsInput}
					placeholder="#xuhuong, #trending, #marketing"
					class="w-full bg-gray-800 border border-gray-700 rounded-lg p-2.5 text-white placeholder-gray-500 focus:outline-none focus:border-blue-500"
				/>
			</div>

			<!-- CTA -->
			<div class="space-y-1.5">
				<label for="ctaInput" class="font-semibold text-gray-300">Lời kêu gọi hành động (Call To Action):</label>
				<input
					id="ctaInput"
					type="text"
					bind:value={cta}
					placeholder="Lưu lại video, Follow ngay..."
					class="w-full bg-gray-800 border border-gray-700 rounded-lg p-2.5 text-white placeholder-gray-500 focus:outline-none focus:border-blue-500"
				/>
			</div>

			<!-- Commercial & Compliance Toggles -->
			<div class="pt-2 border-t border-gray-800 space-y-3">
				<div class="flex items-center justify-between p-3 bg-gray-800/40 rounded-lg border border-gray-800">
					<div>
						<div class="font-medium text-white">Nội dung thương mại / Tài trợ</div>
						<div class="text-[11px] text-gray-400">Yêu cầu gắn nhãn hợp tác #ad hoặc tài trợ</div>
					</div>
					<input
						type="checkbox"
						bind:checked={isCommercial}
						class="rounded bg-gray-800 border-gray-700 text-blue-600 focus:ring-0 w-4 h-4"
					/>
				</div>

				{#if isCommercial}
					<div class="space-y-1.5">
						<label for="disclosureInput" class="font-semibold text-amber-300">Nhãn tài trợ bắt buộc (Disclosure tag):</label>
						<input
							id="disclosureInput"
							type="text"
							bind:value={disclosure}
							placeholder="#ad, #sponsored, #paid_partnership"
							class="w-full bg-gray-800 border {disclosure.trim() ? 'border-gray-700' : 'border-rose-600'} rounded-lg p-2.5 text-white placeholder-gray-500 focus:outline-none focus:border-blue-500"
						/>
						{#if !disclosure.trim()}
							<div class="text-[11px] text-rose-400 font-semibold">
								⚠️ Bắt buộc điền nhãn tài trợ khi bật chế độ thương mại (Tránh Hard Block).
							</div>
						{/if}
					</div>
				{/if}

				<!-- Copyright Violation Fixture Toggle -->
				<div class="flex items-center justify-between p-3 bg-gray-800/40 rounded-lg border border-gray-800">
					<div>
						<div class="font-medium text-white">Thử nghiệm vi phạm bản quyền</div>
						<div class="text-[11px] text-gray-400">Kích hoạt kịch bản Hard Block bản quyền âm nhạc</div>
					</div>
					<input
						type="checkbox"
						bind:checked={hasCopyrightViolation}
						class="rounded bg-gray-800 border-gray-700 text-rose-600 focus:ring-0 w-4 h-4"
					/>
				</div>
			</div>
		</div>

		<!-- Right: Live Packaging QA Scorecard Panel (7 Cols) -->
		<div class="lg:col-span-7">
			<PackagingQAPanel
				{report}
				{userRole}
				userId="usr-author"
				onReportUpdated={handleReportUpdated}
			/>
		</div>
	</div>
</div>
