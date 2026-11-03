<script lang="ts">
	import {
		PRODUCTION_MODES,
		validateBatchInputClient,
		BatchBudgetPreviewModal,
		ActiveJobsBanner,
		LineageInspectionDrawer
	} from '$lib/production';
	import type { GenerationJobItem, AssetLineage, BatchBudgetPreview, BatchItemInput } from '$lib/production';

	// Mock state for interactive demonstration & SSR
	let activeJobs: GenerationJobItem[] = [
		{
			jobId: 'job-veo-01',
			workspaceId: 'ws-demo',
			assetId: 'asset-01',
			mode: 'video_gen',
			title: 'Video review kem chống nắng SPF50',
			prompt: 'Quay cận cảnh chất kem mịn, chuyển cảnh sang người mẫu thoa trên bãi biển',
			provider: 'veo',
			status: 'processing',
			stage: 'Kết xuất khung hình visual',
			progressPct: 75,
			estimatedCredits: '80',
			estimatedCostUSD: '0.600000',
			createdAt: new Date().toISOString(),
			updatedAt: new Date().toISOString()
		},
		{
			jobId: 'job-kling-02',
			workspaceId: 'ws-demo',
			assetId: 'asset-02',
			mode: 'video_gen',
			title: 'Banner động đồng hồ cơ bấm giờ',
			prompt: 'Chi tiết kim giây trôi mượt mà ánh sáng studio phản chiếu mặt kính sapphire',
			provider: 'kling',
			status: 'processing',
			stage: 'Xử lý chuyển động (Fallback)',
			progressPct: 40,
			estimatedCredits: '80',
			estimatedCostUSD: '0.600000',
			createdAt: new Date().toISOString(),
			updatedAt: new Date().toISOString()
		}
	];

	let recentAssets: AssetLineage[] = [
		{
			assetId: 'asset-rec-01',
			title: 'Video intro podcast công nghệ #42',
			assetType: 'video',
			generationState: 'completed',
			qualityState: 'approved',
			sourceProvider: 'veo',
			sourceModel: 'veo-2.0-generate-001',
			durationSeconds: 15,
			resolution: '1080x1920',
			storageUrl: 'https://cdn.creativanta.test/outputs/asset-rec-01.mp4',
			upstreamScriptId: 'script-402',
			upstreamCharacterId: 'char-host-an',
			costUSD: '0.600000',
			continuityScore: 0.94
		},
		{
			assetId: 'asset-rec-02',
			title: 'Remix clip TikTok giảm giá mùa hè',
			assetType: 'video',
			generationState: 'completed',
			qualityState: 'draft',
			sourceProvider: 'kling',
			sourceModel: 'kling-video-v1.5',
			durationSeconds: 15,
			resolution: '1080x1920',
			storageUrl: 'https://cdn.creativanta.test/outputs/asset-rec-02.mp4',
			costUSD: '0.600000',
			continuityScore: 0.88
		}
	];

	let selectedAssetForLineage: AssetLineage | null = null;
	let isLineageOpen = false;

	let isBatchModalOpen = false;
	let batchPreview: BatchBudgetPreview | null = null;
	let userBalance = 500;

	function handleCancelJob(jobId: string) {
		const job = activeJobs.find((j) => j.jobId === jobId);
		if (job) {
			userBalance += parseInt(job.estimatedCredits, 10);
		}
		activeJobs = activeJobs.filter((j) => j.jobId !== jobId);
	}

	function openLineage(asset: AssetLineage) {
		selectedAssetForLineage = asset;
		isLineageOpen = true;
	}

	function triggerBatchPreview() {
		// Sample 5-item batch with 1 invalid row for preview verification
		const sampleBatch: BatchItemInput[] = [
			{ index: 0, itemId: 'b-1', itemName: 'Son dưỡng ẩm Lip Glow', prompt: 'Video cận cảnh thoa son lên môi căng bóng tự nhiên' },
			{ index: 1, itemId: 'b-2', itemName: 'Sữa rửa mặt tạo bọt dịu nhẹ', prompt: 'Chất bọt dày mịn rửa sạch bụi bẩn' },
			{ index: 2, itemId: 'b-3', itemName: '', prompt: 'Prompt không có tên sản phẩm hợp lệ' },
			{ index: 3, itemId: 'b-4', itemName: 'Serum vitamin C sáng da', prompt: 'Từng giọt serum vàng óng thấm nhanh trên da' },
			{ index: 4, itemId: 'b-5', itemName: 'Kem chống nắng nâng tone', prompt: 'Lớp finish rạng rỡ không nhờn rít' }
		];
		batchPreview = validateBatchInputClient(sampleBatch, 0.04, userBalance);
		isBatchModalOpen = true;
	}

	function confirmBatchRun() {
		if (batchPreview && batchPreview.sufficientCredits) {
			userBalance -= parseInt(batchPreview.totalEstimatedCredits, 10);
			isBatchModalOpen = false;
			// Add placeholder active job
			activeJobs = [
				{
					jobId: `batch-job-${Date.now()}`,
					workspaceId: 'ws-demo',
					assetId: `batch-asset-${Date.now()}`,
					mode: 'batch_gen',
					title: `Mẻ sản xuất hàng loạt (${batchPreview.validItemsCount} sản phẩm)`,
					prompt: 'Xử lý tuần tự các sản phẩm hợp lệ trong mẻ',
					provider: 'veo',
					status: 'processing',
					stage: 'Đang xếp lịch render mẻ',
					progressPct: 5,
					estimatedCredits: batchPreview.totalEstimatedCredits,
					estimatedCostUSD: batchPreview.totalCostCeilingUSD,
					createdAt: new Date().toISOString(),
					updatedAt: new Date().toISOString()
				},
				...activeJobs
			];
		}
	}
</script>

<svelte:head>
	<title>AI Studio Launcher (W021) — Creativanta</title>
</svelte:head>

<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-8">
	<!-- Page Header -->
	<div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 border-b border-gray-800 pb-6">
		<div>
			<div class="flex items-center gap-2 mb-1">
				<span class="text-2xl">🎬</span>
				<h1 class="text-2xl font-bold text-white tracking-tight">AI Studio Launcher</h1>
				<span class="text-xs px-2 py-0.5 rounded-full bg-blue-950 text-blue-300 border border-blue-800 font-mono">
					W021 · M07
				</span>
			</div>
			<p class="text-sm text-gray-400">
				Cổng điều hướng tạo nội dung video, ảnh, âm thanh AI với kiểm duyệt ngân sách tự động.
			</p>
		</div>

		<div class="flex items-center gap-4">
			<div class="bg-gray-900 border border-gray-800 rounded-lg px-3 py-2 text-right">
				<div class="text-[11px] text-gray-400">Số dư Credits</div>
				<div class="text-sm font-bold font-mono text-emerald-400">{userBalance} credits</div>
			</div>
			<button
				type="button"
				on:click={triggerBatchPreview}
				class="px-4 py-2 text-xs font-semibold rounded-lg bg-blue-600 hover:bg-blue-500 text-white shadow-lg shadow-blue-600/20 transition-all flex items-center gap-2">
				<span>📦</span>
				<span>Chạy thử tạo hàng loạt (Batch Preview)</span>
			</button>
		</div>
	</div>

	<!-- Active Jobs Banner (Acceptance Target 1: Cancel/recovery & progress) -->
	<ActiveJobsBanner jobs={activeJobs} onCancelJob={handleCancelJob} />

	<!-- Production Modes Grid -->
	<div>
		<div class="flex items-center justify-between mb-4">
			<h2 class="text-base font-bold text-white flex items-center gap-2">
				<span>🛠️</span>
				<span>Chế độ sản xuất (Production Modes)</span>
			</h2>
			<span class="text-xs text-gray-400">{PRODUCTION_MODES.length} công cụ sẵn sàng</span>
		</div>

		<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
			{#each PRODUCTION_MODES as mode (mode.id)}
				<div class="bg-gray-900 border border-gray-800 hover:border-gray-700 rounded-xl p-5 flex flex-col justify-between transition-all hover:shadow-xl group">
					<div>
						<div class="flex items-start justify-between mb-3">
							<span class="text-3xl p-2.5 bg-gray-800/60 rounded-xl border border-gray-700/50 group-hover:scale-105 transition-transform">
								{mode.icon}
							</span>
							{#if mode.badge}
								<span class="text-[10px] font-semibold px-2 py-0.5 rounded-full bg-blue-950 text-blue-300 border border-blue-800">
									{mode.badge}
								</span>
							{/if}
						</div>
						<h3 class="font-bold text-sm text-white group-hover:text-blue-400 transition-colors">
							{mode.title}
						</h3>
						<p class="text-xs text-gray-400 mt-1.5 line-clamp-2">
							{mode.description}
						</p>
					</div>

					<div class="mt-4 pt-4 border-t border-gray-800/80 flex items-center justify-between">
						<span class="text-xs font-mono text-gray-400">
							<strong class="text-white">{mode.creditCost}</strong> credits
							{#if mode.durationSecs > 0}
								/ {mode.durationSecs}s
							{/if}
						</span>
						<button
							type="button"
							on:click={triggerBatchPreview}
							class="text-xs px-3 py-1.5 rounded-lg bg-gray-800 hover:bg-blue-600 text-gray-200 hover:text-white transition-colors">
							Khởi tạo →
						</button>
					</div>
				</div>
			{/each}
		</div>
	</div>

	<!-- Recent Generations (Lineage Inspection) -->
	<div>
		<div class="flex items-center justify-between mb-4">
			<h2 class="text-base font-bold text-white flex items-center gap-2">
				<span>🎞️</span>
				<span>Tài sản gần đây (Recent Assets)</span>
			</h2>
			<a href="/studio/queue" class="text-xs text-blue-400 hover:underline">
				Xem hàng đợi & lịch sử →
			</a>
		</div>

		<div class="grid grid-cols-1 md:grid-cols-2 gap-4">
			{#each recentAssets as asset (asset.assetId)}
				<div class="bg-gray-900 border border-gray-800 rounded-xl p-4 flex items-center justify-between gap-4">
					<div class="flex items-center gap-3 min-w-0">
						<div class="w-12 h-12 bg-gray-800 rounded-lg flex items-center justify-center text-xl shrink-0">
							🎬
						</div>
						<div class="min-w-0">
							<h4 class="text-xs font-bold text-white truncate">{asset.title}</h4>
							<div class="flex items-center gap-2 text-[11px] text-gray-400 mt-0.5">
								<span class="font-mono">{asset.durationSeconds}s</span>
								<span>·</span>
								<span class="uppercase font-semibold text-blue-400">{asset.sourceProvider}</span>
								<span>·</span>
								<span class="text-emerald-400 font-mono">${asset.costUSD}</span>
							</div>
						</div>
					</div>

					<button
						type="button"
						on:click={() => openLineage(asset)}
						class="text-xs px-3 py-1.5 rounded-lg border border-gray-700 hover:border-gray-600 bg-gray-800/80 hover:bg-gray-800 text-gray-300 transition-colors shrink-0">
						Xem Lineage
					</button>
				</div>
			{/each}
		</div>
	</div>
</div>

<!-- Modals & Drawers -->
<BatchBudgetPreviewModal
	isOpen={isBatchModalOpen}
	preview={batchPreview}
	onConfirm={confirmBatchRun}
	onClose={() => (isBatchModalOpen = false)}
/>

<LineageInspectionDrawer
	isOpen={isLineageOpen}
	asset={selectedAssetForLineage}
	onClose={() => (isLineageOpen = false)}
/>
