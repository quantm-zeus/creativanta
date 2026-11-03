<script lang="ts">
	interface LibraryAsset {
		id: string;
		title: string;
		assetType: 'video' | 'audio' | 'image';
		isDerivative: boolean;
		parentAssetId?: string;
		channel?: string;
		durationSeconds: number;
		createdAt: string;
		thumbnailUrl?: string;
	}

	let activeFilter: 'all' | 'sources' | 'derivatives' = 'all';
	let searchQuery = '';

	const assets: LibraryAsset[] = [
		{
			id: 'master-src-001',
			title: 'Original 4K Master - AI Technology Keynote 2026',
			assetType: 'video',
			isDerivative: false,
			durationSeconds: 1800,
			createdAt: new Date(Date.now() - 604800000).toISOString()
		},
		{
			id: 'deriv-001',
			title: 'Mẹo tối ưu kịch bản AI trong 30 giây',
			assetType: 'video',
			isDerivative: true,
			parentAssetId: 'master-src-001',
			channel: 'TikTok',
			durationSeconds: 28,
			createdAt: new Date(Date.now() - 86400000).toISOString()
		},
		{
			id: 'deriv-002',
			title: 'Bí quyết kịch bản AI (Shorts Version)',
			assetType: 'video',
			isDerivative: true,
			parentAssetId: 'master-src-001',
			channel: 'YouTube Shorts',
			durationSeconds: 45,
			createdAt: new Date(Date.now() - 172800000).toISOString()
		},
		{
			id: 'master-src-002',
			title: 'Full Product Demo - Skincare Collection 2026',
			assetType: 'video',
			isDerivative: false,
			durationSeconds: 900,
			createdAt: new Date(Date.now() - 1209600000).toISOString()
		}
	];

	$: filteredAssets = assets.filter((a) => {
		if (activeFilter === 'sources' && a.isDerivative) return false;
		if (activeFilter === 'derivatives' && !a.isDerivative) return false;
		if (searchQuery.trim() && !a.title.toLowerCase().includes(searchQuery.toLowerCase())) return false;
		return true;
	});
</script>

<svelte:head>
	<title>Thư viện tài nguyên (Asset Library) | Creativanta</title>
</svelte:head>

<div class="min-h-screen bg-gray-950 text-white p-6 md:p-8 space-y-6">
	<!-- Header -->
	<div class="flex flex-col md:flex-row md:items-center justify-between gap-4 border-b border-gray-800 pb-6">
		<div>
			<h1 class="text-2xl font-bold flex items-center gap-3">
				<span>🗂️</span>
				<span>Thư viện tài nguyên (Studio Asset Library)</span>
			</h1>
			<p class="text-sm text-gray-400 mt-1">
				Xem toàn bộ tài nguyên gốc và biến thể phái sinh với liên kết phả hệ nguồn (Lineage Attribution).
			</p>
		</div>

		<div class="flex items-center gap-3">
			<a
				href="/studio/derivatives"
				class="px-4 py-2 bg-blue-600 hover:bg-blue-500 text-white rounded-lg text-xs font-semibold transition-colors"
			>
				Đi tới Repurpose Hub →
			</a>
		</div>
	</div>

	<!-- Filter Chips & Search -->
	<div class="flex flex-wrap items-center justify-between gap-4 bg-gray-900/60 border border-gray-800 p-4 rounded-xl text-xs">
		<div class="flex items-center gap-2">
			<button
				on:click={() => (activeFilter = 'all')}
				class="px-3 py-1.5 rounded-lg font-medium transition-colors {activeFilter === 'all' ? 'bg-blue-600 text-white' : 'bg-gray-800 text-gray-400 hover:text-white'}"
			>
				Tất cả tài nguyên ({assets.length})
			</button>
			<button
				on:click={() => (activeFilter = 'sources')}
				class="px-3 py-1.5 rounded-lg font-medium transition-colors {activeFilter === 'sources' ? 'bg-blue-600 text-white' : 'bg-gray-800 text-gray-400 hover:text-white'}"
			>
				Tài nguyên gốc (Sources)
			</button>
			<button
				on:click={() => (activeFilter = 'derivatives')}
				class="px-3 py-1.5 rounded-lg font-medium transition-colors {activeFilter === 'derivatives' ? 'bg-blue-600 text-white' : 'bg-gray-800 text-gray-400 hover:text-white'}"
			>
				Phái sinh (Derivatives)
			</button>
		</div>

		<input
			type="text"
			bind:value={searchQuery}
			placeholder="Tìm kiếm tài nguyên..."
			class="bg-gray-800 border border-gray-700 rounded-lg px-3 py-1.5 text-white placeholder-gray-500 focus:outline-none focus:border-blue-500 w-64"
		/>
	</div>

	<!-- Asset Cards Grid -->
	<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
		{#each filteredAssets as asset}
			<div class="bg-gray-900/40 border border-gray-800 rounded-xl p-4 space-y-3 flex flex-col justify-between hover:border-gray-700 transition-colors">
				<div class="space-y-2">
					<div class="flex items-center justify-between">
						<span class="px-2 py-0.5 rounded text-[10px] font-semibold {asset.isDerivative ? 'bg-blue-900/40 text-blue-300 border border-blue-800' : 'bg-purple-900/40 text-purple-300 border border-purple-800'}">
							{asset.isDerivative ? 'Phái sinh (Derivative)' : 'Gốc (Source Master)'}
						</span>
						{#if asset.channel}
							<span class="text-[11px] text-gray-400 font-medium">{asset.channel}</span>
						{/if}
					</div>

					<h3 class="font-bold text-sm text-white line-clamp-2">{asset.title}</h3>
					<div class="text-[11px] text-gray-500 font-mono">{asset.id}</div>
				</div>

				<div class="space-y-2 pt-2 border-t border-gray-800/80">
					{#if asset.parentAssetId}
						<div class="text-[11px] text-gray-400 flex items-center gap-1">
							<span>Nguồn:</span>
							<span class="font-mono text-blue-400">{asset.parentAssetId}</span>
						</div>
					{/if}

					<div class="flex items-center justify-between text-[11px] text-gray-500">
						<span>Thời lượng: {asset.durationSeconds}s</span>
						<span>{new Date(asset.createdAt).toLocaleDateString()}</span>
					</div>

					{#if asset.isDerivative}
						<a
							href="/packaging/{asset.id}"
							class="block text-center w-full py-1.5 bg-blue-600/30 hover:bg-blue-600/50 text-blue-300 border border-blue-500/40 rounded-lg text-xs font-semibold transition-colors"
						>
							Kiểm định Packaging QA →
						</a>
					{/if}
				</div>
			</div>
		{/each}
	</div>
</div>
