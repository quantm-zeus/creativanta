<script lang="ts">
	import {
		validateMultiMergeTimelineClient,
		getTierMaxInputs
	} from '$lib/production';
	import type { MultiMergeTimelineItem, MultiMergeSettings, CopyrightCheckResult } from '$lib/production';

	let workspaceTier = 'Pro'; // Free | Starter | Pro | Business
	$: maxAllowedInputs = getTierMaxInputs(workspaceTier);

	let timelineItems: MultiMergeTimelineItem[] = [
		{
			itemId: 'item-1',
			assetId: 'asset-v1',
			orderIndex: 0,
			mediaType: 'video',
			title: 'Mở đầu giới thiệu bộ sưu tập',
			durationSeconds: 5.0,
			thumbnailUrl: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=200&q=80',
			licenseStatus: 'royalty_free'
		},
		{
			itemId: 'item-2',
			assetId: 'asset-i1',
			orderIndex: 1,
			mediaType: 'image',
			title: 'Chi tiết chất liệu sản phẩm',
			durationSeconds: 3.0,
			thumbnailUrl: 'https://images.unsplash.com/photo-1598440947619-2c35fc9aa908?w=200&q=80',
			licenseStatus: 'royalty_free'
		},
		{
			itemId: 'item-3',
			assetId: 'asset-i2',
			orderIndex: 2,
			mediaType: 'image',
			title: 'Bảng màu son tự nhiên',
			durationSeconds: 3.0,
			thumbnailUrl: 'https://images.unsplash.com/photo-1512496015851-a90fb38ba796?w=200&q=80',
			licenseStatus: 'royalty_free'
		},
		{
			itemId: 'item-4',
			assetId: 'asset-v2',
			orderIndex: 3,
			mediaType: 'video',
			title: 'Người mẫu thoa son thực tế',
			durationSeconds: 6.0,
			thumbnailUrl: 'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?w=200&q=80',
			licenseStatus: 'royalty_free'
		}
	];

	let autoTransitions = true;
	let settings: MultiMergeSettings = {
		targetDurationSec: 60,
		autoTransitions: true,
		aspectRatio: '9:16',
		pacing: 'medium'
	};

	let selectedItemForLicense: MultiMergeTimelineItem | null = null;
	let licenseProofInput = '';

	let isSubmitting = false;
	let submitSuccessMessage = '';

	// Run client timeline validation
	$: validation = validateMultiMergeTimelineClient(workspaceTier, timelineItems, autoTransitions);
	$: totalTimelineDuration = timelineItems.reduce((acc, curr) => acc + (curr.durationSeconds || 0), 0);

	function removeItem(index: number) {
		timelineItems = timelineItems.filter((_, i) => i !== index);
	}

	function moveItem(index: number, direction: 'up' | 'down') {
		const targetIndex = direction === 'up' ? index - 1 : index + 1;
		if (targetIndex < 0 || targetIndex >= timelineItems.length) return;

		const updated = [...timelineItems];
		const temp = updated[index];
		updated[index] = updated[targetIndex];
		updated[targetIndex] = temp;
		timelineItems = updated;
	}

	function addSampleCopyrightedTrack() {
		const newTrack: MultiMergeTimelineItem = {
			itemId: `item-${Date.now()}`,
			assetId: 'audio-copyrighted-sony',
			orderIndex: timelineItems.length,
			mediaType: 'audio',
			title: 'Commercial Hit #1 (Major Label)',
			durationSeconds: 15.0,
			hasCopyrightHit: true,
			licenseStatus: 'copyrighted_unverified'
		};
		timelineItems = [...timelineItems, newTrack];
	}

	function addSampleValidImage() {
		if (timelineItems.length >= maxAllowedInputs) return;
		const newItem: MultiMergeTimelineItem = {
			itemId: `item-${Date.now()}`,
			assetId: `asset-img-${Date.now()}`,
			orderIndex: timelineItems.length,
			mediaType: 'image',
			title: `Hình ảnh bổ sung #${timelineItems.length + 1}`,
			durationSeconds: 3.0,
			licenseStatus: 'royalty_free'
		};
		timelineItems = [...timelineItems, newItem];
	}

	function openLicenseModal(item: MultiMergeTimelineItem) {
		selectedItemForLicense = item;
		licenseProofInput = item.licenseProofKey || '';
	}

	function saveLicenseProof() {
		if (!selectedItemForLicense) return;
		const targetId = selectedItemForLicense.itemId;
		timelineItems = timelineItems.map((item) => {
			if (item.itemId === targetId) {
				return {
					...item,
					licenseProofKey: licenseProofInput,
					licenseStatus: licenseProofInput.trim() ? 'licensed' : 'copyrighted_unverified',
					hasCopyrightHit: !licenseProofInput.trim()
				};
			}
			return item;
		});
		selectedItemForLicense = null;
	}

	async function handleCreateMerge() {
		if (!validation.isValid) return;
		isSubmitting = true;
		submitSuccessMessage = '';

		setTimeout(() => {
			isSubmitting = false;
			submitSuccessMessage = '🎉 Đã tạo lệnh ghép video thành công! Chi phí: 20 credits.';
		}, 500);
	}
</script>

<div class="mx-auto max-w-6xl px-4 py-8 text-neutral-100">
	<!-- Page Header -->
	<div class="mb-6 flex items-center justify-between">
		<div class="flex items-center gap-3">
			<a href="/studio" class="rounded-lg bg-neutral-800 p-2 text-neutral-400 hover:text-white transition-colors">
				←
			</a>
			<div>
				<h1 class="text-2xl font-bold flex items-center gap-2">
					<span>🔀</span> Multi-Merge Video Studio
				</h1>
				<p class="text-sm text-neutral-400">
					Ghép nối nhiều video và hình ảnh với chuyển cảnh tự động thông minh và rào cản bản quyền âm nhạc.
				</p>
			</div>
		</div>

		<!-- Tier Limits & Media Count Badge -->
		<div class="flex items-center gap-3">
			<span class="rounded-full bg-neutral-800 px-3 py-1 text-xs font-mono text-neutral-300">
				Gói hiện tại: <strong class="text-primary-400">{workspaceTier}</strong>
			</span>
			<span
				class="rounded-full px-3 py-1 text-xs font-mono font-semibold {timelineItems.length > maxAllowedInputs
					? 'bg-rose-900/40 text-rose-300 border border-rose-600'
					: 'bg-primary-950 text-primary-300 border border-primary-700'}"
			>
				Số tệp: {timelineItems.length} / {maxAllowedInputs} max
			</span>
		</div>
	</div>

	<!-- Copyright Infringement Hard Block Alert Banner (RULE-M07-008, SAFE-2026-02) -->
	{#if validation.copyrightBlocks.length > 0}
		<div
			class="mb-6 rounded-xl border border-rose-500/50 bg-rose-950/40 p-4 text-rose-200"
			data-testid="copyright-block-banner"
		>
			<div class="flex items-center gap-2 font-bold text-rose-300">
				<span class="text-xl">⛔</span> Rào cản bản quyền (RULE-M07-008, SAFE-2026-02)
			</div>
			<p class="mt-1 text-xs text-neutral-300">
				Phát hiện âm thanh hoặc video có bản quyền chưa được cấp phép. <strong>Quy định nghiêm ngặt: Không được phép bỏ qua rủi ro bằng cách xác nhận chấp nhận rủi ro (No risk bypass).</strong>
			</p>
			<ul class="mt-2 list-disc list-inside space-y-1 text-xs text-rose-300">
				{#each validation.copyrightBlocks as block}
					<li>
						{block.warningMessage}
					</li>
				{/each}
			</ul>
		</div>
	{/if}

	<!-- Media Drop Zone -->
	<div class="mb-6 rounded-xl border-2 border-dashed border-neutral-700 bg-neutral-900/40 p-6 text-center">
		<div class="text-3xl mb-1">📥</div>
		<p class="text-sm font-medium text-neutral-200">Kéo thả video hoặc hình ảnh vào đây để bổ sung</p>
		<p class="text-xs text-neutral-500 mt-1">Hỗ trợ MP4, MOV, JPG, PNG | Tối thiểu 2 tệp | Tối đa {maxAllowedInputs} tệp ({workspaceTier})</p>
		<div class="mt-3 flex justify-center gap-3">
			<button
				type="button"
				on:click={addSampleValidImage}
				disabled={timelineItems.length >= maxAllowedInputs}
				class="rounded-lg bg-neutral-800 px-3.5 py-1.5 text-xs font-medium text-neutral-200 hover:bg-neutral-700 disabled:opacity-40 transition-colors"
			>
				+ Thêm ảnh mẫu
			</button>
			<button
				type="button"
				on:click={addSampleCopyrightedTrack}
				class="rounded-lg bg-amber-950 border border-amber-800 px-3.5 py-1.5 text-xs font-medium text-amber-200 hover:bg-amber-900 transition-colors"
			>
				⚠️ Thêm track nhạc bản quyền (Test Safeguard)
			</button>
		</div>
	</div>

	<!-- Timeline Editor -->
	<div class="mb-6 rounded-xl border border-neutral-800 bg-neutral-900/60 p-6">
		<div class="flex items-center justify-between mb-4">
			<div>
				<h2 class="text-base font-semibold flex items-center gap-2">
					<span>🎞️</span> Trình dựng Timeline nối ghép
				</h2>
				<span class="text-xs text-neutral-400">Tổng thời lượng: {totalTimelineDuration.toFixed(1)}s</span>
			</div>

			<label class="flex items-center gap-2 cursor-pointer text-xs text-neutral-300">
				<input type="checkbox" bind:checked={autoTransitions} class="rounded text-primary-600" />
				<span>Tự động gán chuyển cảnh AI (Ken Burns cho Ảnh, Crossfade cho Video)</span>
			</label>
		</div>

		<!-- Horizontal Timeline Items Strip -->
		<div class="flex gap-3 overflow-x-auto pb-4 pt-2">
			{#each validation.itemsWithTransitions as item, idx}
				<div class="relative flex-shrink-0 w-44 rounded-lg border bg-neutral-950 p-2.5 flex flex-col justify-between {item.hasCopyrightHit ? 'border-rose-500 shadow-rose-950/50 shadow-md' : 'border-neutral-800'}">
					<!-- Header info -->
					<div class="flex items-center justify-between text-xs mb-1.5">
						<span class="font-mono text-neutral-400">#{idx + 1}</span>
						<span class="rounded px-1.5 py-0.5 text-[10px] uppercase font-bold {item.mediaType === 'video' ? 'bg-indigo-950 text-indigo-300' : item.mediaType === 'image' ? 'bg-amber-950 text-amber-300' : 'bg-rose-950 text-rose-300'}">
							{item.mediaType}
						</span>
					</div>

					<!-- Thumbnail placeholder -->
					<div class="aspect-video w-full rounded bg-neutral-900 mb-2 flex items-center justify-center overflow-hidden border border-neutral-800">
						{#if item.thumbnailUrl}
							<img src={item.thumbnailUrl} alt={item.title} class="h-full w-full object-cover" />
						{:else}
							<span class="text-2xl">{item.mediaType === 'video' ? '🎥' : item.mediaType === 'image' ? '🖼️' : '🎵'}</span>
						{/if}
					</div>

					<div class="text-xs font-semibold truncate text-neutral-200" title={item.title}>
						{item.title}
					</div>
					<div class="text-[11px] text-neutral-400 mt-0.5">
						{item.durationSeconds}s
					</div>

					<!-- Copyright Hit Indicator -->
					{#if item.hasCopyrightHit}
						<div class="mt-2 rounded bg-rose-950/80 border border-rose-600/50 p-1.5 text-[10px] text-rose-200">
							<div class="font-bold flex items-center gap-1">
								<span>⛔</span> Bản quyền
							</div>
							<button
								type="button"
								on:click={() => openLicenseModal(item)}
								class="mt-1 w-full rounded bg-rose-600 px-2 py-0.5 text-[10px] font-semibold text-white hover:bg-rose-500"
							>
								Gắn mã bản quyền
							</button>
						</div>
					{/if}

					<!-- Transition Badge to next item -->
					{#if item.transitionToNext && idx < validation.itemsWithTransitions.length - 1}
						<div class="mt-2 text-center">
							<span class="rounded-full bg-neutral-800 px-2 py-0.5 text-[10px] font-mono text-primary-300 border border-neutral-700">
								→ {item.transitionToNext} ({item.transitionDurationSeconds}s)
							</span>
						</div>
					{/if}

					<!-- Reorder & Delete controls -->
					<div class="mt-3 flex items-center justify-between border-t border-neutral-800 pt-2 text-xs">
						<div class="flex gap-1">
							<button
								type="button"
								on:click={() => moveItem(idx, 'up')}
								disabled={idx === 0}
								class="rounded p-1 text-neutral-400 hover:text-white disabled:opacity-20"
								title="Di chuyển sang trái"
							>
								◀
							</button>
							<button
								type="button"
								on:click={() => moveItem(idx, 'down')}
								disabled={idx === validation.itemsWithTransitions.length - 1}
								class="rounded p-1 text-neutral-400 hover:text-white disabled:opacity-20"
								title="Di chuyển sang phải"
							>
								▶
							</button>
						</div>
						<button
							type="button"
							on:click={() => removeItem(idx)}
							class="text-neutral-500 hover:text-rose-400 transition-colors"
							title="Xóa khỏi timeline"
						>
							🗑️
						</button>
					</div>
				</div>
			{/each}
		</div>
	</div>

	<!-- Multi-Merge Settings & Action Bar -->
	<div class="rounded-xl border border-neutral-800 bg-neutral-900/60 p-6">
		<h3 class="text-base font-semibold mb-4 flex items-center gap-2">
			<span>⚙️</span> Tuỳ chọn hợp nhất & Xuất bản
		</h3>

		<div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6 text-xs">
			<div>
				<label for="merge-aspect-ratio" class="block font-medium text-neutral-400 mb-1">Tỷ lệ khung hình:</label>
				<select id="merge-aspect-ratio" bind:value={settings.aspectRatio} class="w-full rounded bg-neutral-950 border border-neutral-700 p-2 text-white">
					<option value="9:16">9:16 (TikTok, Reels, Shorts)</option>
					<option value="16:9">16:9 (YouTube, TV)</option>
					<option value="1:1">1:1 (Instagram Feed)</option>
				</select>
			</div>

			<div>
				<label for="merge-pacing" class="block font-medium text-neutral-400 mb-1">Nhịp độ chuyển cảnh:</label>
				<select id="merge-pacing" bind:value={settings.pacing} class="w-full rounded bg-neutral-950 border border-neutral-700 p-2 text-white">
					<option value="fast">Nhanh & Sôi động (Fast cuts)</option>
					<option value="medium">Tự nhiên & Cân bằng (Medium)</option>
					<option value="slow">Nhẹ nhàng & Điện ảnh (Slow fade)</option>
				</select>
			</div>

			<div>
				<label for="merge-target-duration" class="block font-medium text-neutral-400 mb-1">Thời lượng mục tiêu:</label>
				<select id="merge-target-duration" bind:value={settings.targetDurationSec} class="w-full rounded bg-neutral-950 border border-neutral-700 p-2 text-white">
					<option value={30}>30 giây (Quảng cáo ngắn)</option>
					<option value={60}>60 giây (Tiêu chuẩn)</option>
					<option value={90}>90 giây (Kể chuyện chi tiết)</option>
				</select>
			</div>
		</div>

		<!-- Action CTA Bar -->
		<div class="flex items-center justify-between border-t border-neutral-800 pt-4">
			<div class="text-xs text-neutral-400">
				💳 Chi phí dựng Multi-Merge: <strong>20 credits</strong>
			</div>

			<button
				type="button"
				on:click={handleCreateMerge}
				disabled={!validation.isValid || isSubmitting}
				class="rounded-lg bg-primary-600 px-6 py-2.5 text-sm font-semibold text-white shadow-lg hover:bg-primary-500 disabled:opacity-40 disabled:cursor-not-allowed transition-all flex items-center gap-2"
			>
				{#if isSubmitting}
					<span>⏳ Đang kết xuất video...</span>
				{:else}
					<span>🚀 Ghép video (20 cr)</span>
				{/if}
			</button>
		</div>

		{#if submitSuccessMessage}
			<div class="mt-4 rounded-lg bg-emerald-950/60 border border-emerald-600 p-3 text-xs text-emerald-200">
				{submitSuccessMessage}
			</div>
		{/if}
	</div>

	<!-- License Proof Attachment Modal -->
	{#if selectedItemForLicense}
		<div class="fixed inset-0 z-50 flex items-center justify-center bg-black/70 backdrop-blur-sm p-4">
			<div class="w-full max-w-md rounded-xl border border-neutral-800 bg-neutral-900 p-6 text-neutral-100 shadow-2xl">
				<h3 class="text-base font-bold mb-2 flex items-center gap-2">
					<span>📜</span> Cung cấp chứng minh bản quyền
				</h3>
				<p class="text-xs text-neutral-300 mb-4">
					Bản nhạc <strong>"{selectedItemForLicense.title}"</strong> được phát hiện thuộc danh mục có bản quyền. Để sử dụng, bạn phải nhập mã chứng chỉ bản quyền hợp lệ.
				</p>

				<label for="license-proof-input" class="block text-xs font-semibold text-neutral-400 mb-1">
					Mã chứng chỉ hoặc URL chứng minh bản quyền:
				</label>
				<input
					id="license-proof-input"
					type="text"
					bind:value={licenseProofInput}
					placeholder="https://licensing.example.com/certs/AUTH-12345"
					class="w-full rounded border border-neutral-700 bg-neutral-950 px-3 py-2 text-xs text-white focus:border-primary-500 focus:outline-none mb-4"
				/>

				<div class="flex justify-end gap-2">
					<button
						type="button"
						on:click={() => selectedItemForLicense = null}
						class="rounded px-4 py-2 text-xs font-medium text-neutral-400 hover:text-white"
					>
						Hủy bỏ
					</button>
					<button
						type="button"
						on:click={saveLicenseProof}
						class="rounded bg-primary-600 px-4 py-2 text-xs font-semibold text-white hover:bg-primary-500"
					>
						Xác nhận chứng minh
					</button>
				</div>
			</div>
		</div>
	{/if}
</div>
