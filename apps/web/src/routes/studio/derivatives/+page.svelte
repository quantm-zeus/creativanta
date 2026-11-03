<script lang="ts">
	import type { DerivativeItem, BatchTagResult, DerivativeLineageNode } from '$lib/production/types';
	import { executeBatchTag, validateLineageForPackaging, LineageError } from '$lib/production/derivative_packaging';
	import DerivativeBatchBar from '$lib/production/DerivativeBatchBar.svelte';

	// Filters
	let filterChannel = 'all';
	let filterType = 'all';
	let searchQuery = '';

	// Selected items for batch operations
	let selectedIds: string[] = [];
	let errorMessage = '';
	let successMessage = '';

	// Lineage drawer state
	let lineageDrawerOpen = false;
	let currentLineageNode: DerivativeLineageNode | null = null;

	// Mock seed dataset of derivatives (some with lineage, one orphan to demonstrate Acceptance Target 2)
	let derivatives: DerivativeItem[] = [
		{
			assetId: 'deriv-001',
			parentAssetId: 'master-src-001',
			title: 'Mẹo tối ưu kịch bản AI trong 30 giây (TikTok)',
			derivativeType: 'clip',
			targetChannel: 'tiktok',
			aspectRatio: '9:16',
			durationSeconds: 28,
			resolution: '1080x1920',
			qualityState: 'ready',
			generationState: 'completed',
			tags: ['campaign-spring', 'viral'],
			views: 12500,
			engagementRate: 0.082,
			ctr: 0.045,
			createdAt: new Date(Date.now() - 86400000).toISOString(),
			updatedAt: new Date().toISOString()
		},
		{
			assetId: 'deriv-002',
			parentAssetId: 'master-src-001',
			title: 'Bí quyết kịch bản AI (YouTube Shorts)',
			derivativeType: 'variant',
			targetChannel: 'youtube_shorts',
			aspectRatio: '9:16',
			durationSeconds: 45,
			resolution: '1080x1920',
			qualityState: 'ready',
			generationState: 'completed',
			tags: ['campaign-spring', 'educational'],
			views: 34000,
			engagementRate: 0.115,
			ctr: 0.088,
			createdAt: new Date(Date.now() - 172800000).toISOString(),
			updatedAt: new Date().toISOString()
		},
		{
			assetId: 'deriv-003',
			parentAssetId: 'master-src-002',
			title: 'Review sản phẩm mỹ phẩm GenZ (Instagram Reels)',
			derivativeType: 'repurpose',
			targetChannel: 'instagram_reels',
			aspectRatio: '9:16',
			durationSeconds: 32,
			resolution: '1080x1920',
			qualityState: 'ready',
			generationState: 'completed',
			tags: ['review', 'beauty'],
			views: 8900,
			engagementRate: 0.065,
			ctr: 0.038,
			createdAt: new Date(Date.now() - 259200000).toISOString(),
			updatedAt: new Date().toISOString()
		},
		{
			// Orphan derivative without parentAssetId (RULE-M09-001 violation fixture)
			assetId: 'deriv-orphan-004',
			parentAssetId: '',
			title: 'Video tải lên thủ công không rõ nguồn gốc (No lineage)',
			derivativeType: 'clip',
			targetChannel: 'tiktok',
			aspectRatio: '9:16',
			durationSeconds: 20,
			resolution: '1080x1920',
			qualityState: 'pending_lineage',
			generationState: 'completed',
			tags: ['unlinked'],
			views: 120,
			engagementRate: 0.01,
			ctr: 0.005,
			createdAt: new Date(Date.now() - 3600000).toISOString(),
			updatedAt: new Date().toISOString()
		}
	];

	// Filtered list
	$: filteredDerivatives = derivatives.filter((d) => {
		if (filterChannel !== 'all' && d.targetChannel !== filterChannel) return false;
		if (filterType !== 'all' && d.derivativeType !== filterType) return false;
		if (searchQuery.trim() && !d.title.toLowerCase().includes(searchQuery.toLowerCase())) return false;
		return true;
	});

	function toggleSelectAll() {
		if (selectedIds.length === filteredDerivatives.length) {
			selectedIds = [];
		} else {
			selectedIds = filteredDerivatives.map((d) => d.assetId);
		}
	}

	function toggleSelectItem(id: string) {
		if (selectedIds.includes(id)) {
			selectedIds = selectedIds.filter((item) => item !== id);
		} else {
			selectedIds = [...selectedIds, id];
		}
	}

	// Batch Tag execution
	async function handleBatchTag(addTags: string[], removeTags: string[]): Promise<BatchTagResult> {
		const itemsMap: Map<string, DerivativeItem> = new Map();
		derivatives.forEach((d) => itemsMap.set(d.assetId, d));
		const result = executeBatchTag(selectedIds, addTags, removeTags, itemsMap);
		derivatives = [...derivatives]; // trigger reactive update
		return result;
	}

	// Route to packaging with Acceptance Target 2 check
	async function handleRouteToPackaging() {
		errorMessage = '';
		successMessage = '';

		let blockedCount = 0;
		const allowedIds: string[] = [];

		for (const id of selectedIds) {
			const item = derivatives.find((d) => d.assetId === id);
			if (!item) continue;
			try {
				validateLineageForPackaging(item);
				allowedIds.push(id);
			} catch (err) {
				if (err instanceof LineageError) {
					blockedCount++;
				}
			}
		}

		if (blockedCount > 0) {
			errorMessage = `Từ chối định tuyến ${blockedCount} mục do thiếu nguồn gốc (No lineage -> routing denied per RULE-M09-001). Chỉ ${allowedIds.length} mục hợp lệ được chuyển sang Packaging QA.`;
		} else {
			successMessage = `Đã chuyển thành công ${allowedIds.length} mục sang quy trình Packaging QA.`;
		}
	}

	function viewLineage(item: DerivativeItem) {
		currentLineageNode = {
			assetId: item.assetId,
			parentAssetId: item.parentAssetId,
			title: item.title,
			derivativeType: item.derivativeType,
			assetType: 'video',
			qualityState: item.qualityState,
			depth: item.parentAssetId ? 1 : 0,
			views: item.views,
			engagementRate: item.engagementRate,
			ctr: item.ctr,
			isSourceDeleted: false
		};
		lineageDrawerOpen = true;
	}
</script>

<svelte:head>
	<title>Quản lý phái sinh & Repurpose Hub | Creativanta</title>
</svelte:head>

<div class="min-h-screen bg-gray-950 text-white p-6 md:p-8 space-y-6">
	<!-- Page Header -->
	<div class="flex flex-col md:flex-row md:items-center justify-between gap-4 border-b border-gray-800 pb-6">
		<div>
			<h1 class="text-2xl font-bold flex items-center gap-3">
				<span>📑</span>
				<span>Thư viện phái sinh (Derivative Library) & Repurpose Hub</span>
			</h1>
			<p class="text-sm text-gray-400 mt-1">
				Quản lý mối quan hệ gốc - phái sinh (Lineage), gắn thẻ hàng loạt (Batch Tagging) và kiểm định trước khi đóng gói phát hành.
			</p>
		</div>

		<div class="flex items-center gap-3">
			<a
				href="/studio/clip-factory"
				class="px-4 py-2 bg-gray-800 hover:bg-gray-700 text-gray-300 rounded-lg text-xs font-semibold border border-gray-700 transition-colors"
			>
				+ Trích xuất Clips mới
			</a>
		</div>
	</div>

	<!-- Notifications -->
	{#if errorMessage}
		<div class="bg-rose-950/70 border border-rose-800 text-rose-200 p-4 rounded-xl text-xs flex justify-between items-center">
			<div>⛔ {errorMessage}</div>
			<button on:click={() => (errorMessage = '')} class="text-gray-400 hover:text-white">✕</button>
		</div>
	{/if}

	{#if successMessage}
		<div class="bg-emerald-950/70 border border-emerald-800 text-emerald-200 p-4 rounded-xl text-xs flex justify-between items-center">
			<div>✓ {successMessage}</div>
			<button on:click={() => (successMessage = '')} class="text-gray-400 hover:text-white">✕</button>
		</div>
	{/if}

	<!-- Controls & Filter Bar -->
	<div class="flex flex-wrap items-center justify-between gap-4 bg-gray-900/60 border border-gray-800 p-4 rounded-xl text-xs">
		<div class="flex items-center gap-3">
			<input
				type="text"
				bind:value={searchQuery}
				placeholder="Tìm kiếm phái sinh..."
				class="bg-gray-800 border border-gray-700 rounded-lg px-3 py-1.5 text-white placeholder-gray-500 focus:outline-none focus:border-blue-500 w-64"
			/>

			<!-- Channel Filter -->
			<select
				bind:value={filterChannel}
				class="bg-gray-800 border border-gray-700 rounded-lg px-3 py-1.5 text-white focus:outline-none focus:border-blue-500"
			>
				<option value="all">Tất cả kênh (Channels)</option>
				<option value="tiktok">TikTok</option>
				<option value="youtube_shorts">YouTube Shorts</option>
				<option value="instagram_reels">Instagram Reels</option>
			</select>

			<!-- Type Filter -->
			<select
				bind:value={filterType}
				class="bg-gray-800 border border-gray-700 rounded-lg px-3 py-1.5 text-white focus:outline-none focus:border-blue-500"
			>
				<option value="all">Tất cả định dạng</option>
				<option value="clip">Clip ngắn</option>
				<option value="variant">Biến thể CTA/Hook</option>
				<option value="repurpose">Repurpose đa kênh</option>
			</select>
		</div>

		<div class="flex items-center gap-2">
			<button
				on:click={toggleSelectAll}
				class="px-3 py-1.5 bg-gray-800 hover:bg-gray-700 text-gray-300 rounded-lg font-medium border border-gray-700"
			>
				{selectedIds.length === filteredDerivatives.length ? 'Bỏ chọn tất cả' : 'Chọn tất cả'}
			</button>
		</div>
	</div>

	<!-- Derivatives Table / List -->
	<div class="bg-gray-900/40 border border-gray-800 rounded-xl overflow-hidden">
		<table class="w-full text-left text-xs">
			<thead class="bg-gray-900/80 text-gray-400 uppercase text-[11px] border-b border-gray-800">
				<tr>
					<th class="p-4 w-12 text-center">
						<input
							type="checkbox"
							checked={selectedIds.length === filteredDerivatives.length && filteredDerivatives.length > 0}
							on:change={toggleSelectAll}
							class="rounded bg-gray-800 border-gray-700 text-blue-600 focus:ring-0"
						/>
					</th>
					<th class="p-4">Tiêu đề phái sinh (Derivative)</th>
					<th class="p-4">Kênh & Định dạng</th>
					<th class="p-4">Nguồn gốc (Lineage)</th>
					<th class="p-4">Thẻ (Tags)</th>
					<th class="p-4 text-right">Lượt xem & CTR</th>
					<th class="p-4 text-center">Thao tác</th>
				</tr>
			</thead>
			<tbody class="divide-y divide-gray-800/60">
				{#each filteredDerivatives as item}
					<tr class="hover:bg-gray-800/30 transition-colors {selectedIds.includes(item.assetId) ? 'bg-blue-950/20' : ''}">
						<td class="p-4 text-center">
							<input
								type="checkbox"
								checked={selectedIds.includes(item.assetId)}
								on:change={() => toggleSelectItem(item.assetId)}
								class="rounded bg-gray-800 border-gray-700 text-blue-600 focus:ring-0"
							/>
						</td>
						<td class="p-4">
							<div class="font-semibold text-white">{item.title}</div>
							<div class="text-[11px] text-gray-500 font-mono mt-0.5">{item.assetId} • {item.durationSeconds}s • {item.aspectRatio}</div>
						</td>
						<td class="p-4">
							<div class="flex items-center gap-1.5">
								<span class="px-2 py-0.5 rounded bg-gray-800 text-gray-300 font-medium capitalize">
									{item.targetChannel.replace('_', ' ')}
								</span>
								<span class="px-1.5 py-0.5 rounded bg-blue-900/40 text-blue-300 border border-blue-800/40 uppercase text-[10px]">
									{item.derivativeType}
								</span>
							</div>
						</td>
						<td class="p-4">
							{#if item.parentAssetId}
								<button
									on:click={() => viewLineage(item)}
									class="flex items-center gap-1 text-blue-400 hover:text-blue-300 underline font-mono text-[11px]"
								>
									<span>🔗 {item.parentAssetId}</span>
								</button>
							{:else}
								<span class="px-2 py-0.5 rounded bg-rose-900/60 text-rose-300 border border-rose-800 text-[10px] font-semibold">
									⛔ Không có nguồn (Chặn QA)
								</span>
							{/if}
						</td>
						<td class="p-4">
							<div class="flex flex-wrap gap-1 max-w-xs">
								{#each item.tags as tag}
									<span class="px-1.5 py-0.5 rounded bg-gray-800 text-gray-400 text-[10px]">
										#{tag}
									</span>
								{/each}
							</div>
						</td>
						<td class="p-4 text-right">
							<div class="font-bold text-white">{item.views.toLocaleString()}</div>
							<div class="text-[11px] text-emerald-400 font-medium">CTR: {(item.ctr * 100).toFixed(1)}%</div>
						</td>
						<td class="p-4 text-center">
							<a
								href="/packaging/{item.assetId}"
								class="px-3 py-1.5 bg-blue-600/30 hover:bg-blue-600/50 text-blue-300 border border-blue-500/40 rounded-lg font-medium transition-colors"
							>
								QA Đóng gói
							</a>
						</td>
					</tr>
				{/each}
			</tbody>
		</table>
	</div>

	<!-- Floating Batch Bar (up to 150 items) -->
	<DerivativeBatchBar
		selectedAssetIds={selectedIds}
		onClearSelection={() => (selectedIds = [])}
		onBatchTag={handleBatchTag}
		onRouteToPackaging={handleRouteToPackaging}
	/>

	<!-- Lineage Inspection Drawer -->
	{#if lineageDrawerOpen && currentLineageNode}
		<div class="fixed inset-0 z-50 flex items-center justify-end bg-black/60 backdrop-blur-sm">
			<div class="w-full max-w-md h-full bg-gray-900 border-l border-gray-800 p-6 flex flex-col justify-between text-xs space-y-4">
				<div class="space-y-4">
					<div class="flex items-center justify-between border-b border-gray-800 pb-3">
						<h3 class="font-bold text-sm">Cây phả hệ tài nguyên (Lineage Tree)</h3>
						<button on:click={() => (lineageDrawerOpen = false)} class="text-gray-400 hover:text-white">✕</button>
					</div>

					<div class="space-y-3">
						<div class="p-3 bg-gray-800/60 rounded-lg border border-gray-700">
							<div class="text-gray-400 text-[11px]">Tài nguyên gốc (Root Source Master)</div>
							<div class="font-mono text-blue-400 font-bold mt-0.5">{currentLineageNode.parentAssetId || 'Không có nguồn (Orphan)'}</div>
						</div>

						<div class="flex justify-center text-gray-500">↓</div>

						<div class="p-3 bg-blue-950/40 rounded-lg border border-blue-800">
							<div class="text-blue-300 text-[11px]">Phái sinh hiện tại (Current Derivative)</div>
							<div class="font-bold text-white mt-0.5">{currentLineageNode.title}</div>
							<div class="font-mono text-gray-400 text-[11px] mt-1">{currentLineageNode.assetId}</div>
						</div>
					</div>
				</div>

				<div class="border-t border-gray-800 pt-4 flex justify-end">
					<button
						on:click={() => (lineageDrawerOpen = false)}
						class="px-4 py-2 bg-gray-800 hover:bg-gray-700 text-white rounded-lg font-semibold"
					>
						Đóng
					</button>
				</div>
			</div>
		</div>
	{/if}
</div>
