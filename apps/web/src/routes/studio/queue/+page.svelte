<script lang="ts">
	import {
		LineageInspectionDrawer,
		cancelStudioJobRemote,
		retryStudioJobRemote
	} from '$lib/production';
	import type { GenerationJobItem, AssetLineage } from '$lib/production';
	import { authStore } from '$lib/auth';

	let jobs: GenerationJobItem[] = [
		{
			jobId: 'job-q-101',
			workspaceId: 'ws-demo',
			assetId: 'asset-q-101',
			mode: 'video_gen',
			title: 'Video giới thiệu Serum Niacinamide 10%',
			prompt: 'Quay cận cảnh chai serum thủy tinh ánh sáng tự nhiên với giọt tinh chất nhỏ xuống',
			provider: 'veo',
			status: 'processing',
			stage: 'Tạo visuals khung cảnh (Scene 3/4)',
			progressPct: 75,
			estimatedCredits: '80',
			actualCredits: '80',
			estimatedCostUSD: '0.600000',
			createdAt: new Date(Date.now() - 3 * 60 * 1000).toISOString(),
			updatedAt: new Date().toISOString()
		},
		{
			jobId: 'job-q-102',
			workspaceId: 'ws-demo',
			assetId: 'asset-q-102',
			mode: 'video_gen',
			title: 'Clip ngắn hướng dẫn sử dụng máy tăm nước',
			prompt: 'Người dùng thao tác bấm nút khởi động tia nước mạnh mẽ làm sạch kẽ răng',
			provider: 'kling',
			status: 'completed',
			stage: 'Hoàn tất kết xuất',
			progressPct: 100,
			estimatedCredits: '80',
			actualCredits: '80',
			estimatedCostUSD: '0.600000',
			resultUrl: 'https://cdn.creativanta.test/outputs/asset-q-102.mp4',
			createdAt: new Date(Date.now() - 25 * 60 * 1000).toISOString(),
			updatedAt: new Date(Date.now() - 20 * 60 * 1000).toISOString()
		},
		{
			jobId: 'job-q-103',
			workspaceId: 'ws-demo',
			assetId: 'asset-q-103',
			mode: 'video_gen',
			title: 'Animation logo mở màn kênh YouTube',
			prompt: 'Hiệu ứng ánh kim neon tỏa sáng rực rỡ với âm thanh chuyển động mạnh mẽ',
			provider: 'veo',
			status: 'failed',
			stage: 'Lỗi bộ nhớ nhà cung cấp',
			progressPct: 30,
			estimatedCredits: '80',
			estimatedCostUSD: '0.600000',
			errorMessage: 'Primary provider Veo reported 503 Capacity Limit. Ready for retry.',
			createdAt: new Date(Date.now() - 40 * 60 * 1000).toISOString(),
			updatedAt: new Date(Date.now() - 38 * 60 * 1000).toISOString()
		},
		{
			jobId: 'job-q-104',
			workspaceId: 'ws-demo',
			assetId: 'asset-q-104',
			mode: 'video_gen',
			title: 'Quảng cáo giày thể thao chạy bộ',
			prompt: 'Vận động viên bứt tốc trên đường chạy hoàng hôn',
			provider: 'veo',
			status: 'cancelled',
			stage: 'Đã hủy bởi người dùng',
			progressPct: 10,
			estimatedCredits: '80',
			estimatedCostUSD: '0.600000',
			createdAt: new Date(Date.now() - 60 * 60 * 1000).toISOString(),
			updatedAt: new Date(Date.now() - 58 * 60 * 1000).toISOString()
		}
	];

	let currentFilter: 'all' | 'active' | 'completed' | 'failed' | 'cancelled' = 'all';
	let selectedAsset: AssetLineage | null = null;
	let isLineageOpen = false;
	let refundNotice: string | null = null;
	let errorNotice: string | null = null;
	let isMutatingJob = false;

	$: filteredJobs = jobs.filter((j) => {
		if (currentFilter === 'all') return true;
		if (currentFilter === 'active') return j.status === 'processing' || j.status === 'queued';
		return j.status === currentFilter;
	});

	$: activeCount = jobs.filter((j) => j.status === 'processing' || j.status === 'queued').length;
	$: completedCount = jobs.filter((j) => j.status === 'completed').length;
	$: failedCount = jobs.filter((j) => j.status === 'failed').length;

	async function cancelJob(jobId: string) {
		const job = jobs.find((j) => j.jobId === jobId);
		if (!job || job.status === 'completed' || job.status === 'cancelled' || isMutatingJob) {
			return;
		}
		refundNotice = null;
		errorNotice = null;
		isMutatingJob = true;
		try {
			const res = await cancelStudioJobRemote({
				workspaceId: $authStore.activeWorkspace?.id || job.workspaceId,
				jobId
			});
			if (!res.ok) {
				errorNotice =
					res.error ||
					`Không thể hủy tiến trình ${jobId} trên máy chủ (StudioService/Cancel). Trạng thái tác vụ và số dư credits được giữ nguyên.`;
				return;
			}
			job.status = 'cancelled';
			job.stage = 'Đã hủy bởi người dùng (xác nhận từ máy chủ)';
			jobs = [...jobs];
			if (res.creditsRefunded && (res.refundedCredits ?? 0) > 0) {
				refundNotice = `Đã hủy tiến trình ${jobId} và hoàn trả ${res.refundedCredits} credits vào ví!`;
			} else {
				refundNotice = `Đã hủy tiến trình ${jobId} theo xác nhận từ máy chủ.`;
			}
		} finally {
			isMutatingJob = false;
		}
	}

	async function retryJob(jobId: string) {
		const job = jobs.find((j) => j.jobId === jobId);
		if (!job || isMutatingJob) {
			return;
		}
		refundNotice = null;
		errorNotice = null;
		isMutatingJob = true;
		try {
			const res = await retryStudioJobRemote({
				workspaceId: $authStore.activeWorkspace?.id || job.workspaceId,
				jobId,
				useFallbackProvider: true
			});
			if (!res.ok) {
				errorNotice =
					res.error ||
					`Không thể thử lại tiến trình ${jobId} trên máy chủ (StudioService/Retry). Trạng thái hiện tại được giữ nguyên.`;
				return;
			}
			job.status = res.status || 'processing';
			job.provider = res.provider || 'kling';
			job.stage = res.stage || 'Đang xếp lịch chạy lại với Kling Fallback';
			job.progressPct = res.progressPct ?? 15;
			job.errorMessage = undefined;
			jobs = [...jobs];
		} finally {
			isMutatingJob = false;
		}
	}

	function viewLineage(job: GenerationJobItem) {
		selectedAsset = {
			assetId: job.assetId,
			title: job.title,
			assetType: 'video',
			generationState: job.status,
			qualityState: job.status === 'completed' ? 'approved' : 'draft',
			sourceProvider: job.provider,
			sourceModel: job.provider === 'kling' ? 'kling-video-v1.5' : 'veo-2.0-generate-001',
			durationSeconds: 15,
			resolution: '1080x1920',
			storageUrl: job.resultUrl || '',
			costUSD: job.estimatedCostUSD,
			continuityScore: 0.92
		};
		isLineageOpen = true;
	}
</script>

<svelte:head>
	<title>Hàng đợi sản xuất (Studio Queue W030) — Creativanta</title>
</svelte:head>

<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-6">
	<!-- Page Header -->
	<div class="flex items-center justify-between border-b border-gray-800 pb-4">
		<div>
			<div class="flex items-center gap-2 mb-1">
				<a href="/studio" class="text-gray-400 hover:text-white transition-colors text-sm">
					← AI Studio
				</a>
				<span class="text-gray-600">/</span>
				<h1 class="text-xl font-bold text-white tracking-tight">Hàng đợi sản xuất (Generation Queue)</h1>
				<span class="text-xs px-2 py-0.5 rounded-full bg-blue-950 text-blue-300 border border-blue-800 font-mono">
					W030
				</span>
			</div>
			<p class="text-xs text-gray-400">
				Theo dõi thời gian thực, hủy/hoàn credit an toàn, chạy lại và xem kết quả xuất xưởng.
			</p>
		</div>

		<a
			href="/studio"
			class="px-3.5 py-1.5 text-xs font-semibold rounded-lg bg-blue-600 hover:bg-blue-500 text-white transition-colors">
			+ Tạo mới
		</a>
	</div>

	<!-- Refund Toast Notice -->
	{#if refundNotice}
		<div class="bg-emerald-950/60 border border-emerald-600/50 rounded-lg p-3 text-xs text-emerald-200 flex items-center justify-between shadow-lg">
			<div class="flex items-center gap-2">
				<span>✅</span>
				<span>{refundNotice}</span>
			</div>
			<button on:click={() => (refundNotice = null)} class="text-emerald-400 hover:text-emerald-100">
				✕
			</button>
		</div>
	{/if}

	{#if errorNotice}
		<div
			role="alert"
			class="bg-rose-950/60 border border-rose-600/50 rounded-lg p-3 text-xs text-rose-200 flex items-center justify-between shadow-lg">
			<div class="flex items-center gap-2">
				<span>⚠️</span>
				<span>{errorNotice}</span>
			</div>
			<button on:click={() => (errorNotice = null)} class="text-rose-400 hover:text-rose-100">
				✕
			</button>
		</div>
	{/if}

	<!-- Summary Bar -->
	<div class="bg-gray-900 border border-gray-800 rounded-xl p-4 grid grid-cols-2 sm:grid-cols-4 gap-4 text-center">
		<div>
			<div class="text-xs text-gray-400">Đang thực hiện</div>
			<div class="text-lg font-bold text-amber-400 mt-0.5">{activeCount}</div>
		</div>
		<div>
			<div class="text-xs text-gray-400">Hoàn thành hôm nay</div>
			<div class="text-lg font-bold text-emerald-400 mt-0.5">{completedCount}</div>
		</div>
		<div>
			<div class="text-xs text-gray-400">Thất bại cần xử lý</div>
			<div class="text-lg font-bold text-rose-400 mt-0.5">{failedCount}</div>
		</div>
		<div>
			<div class="text-xs text-gray-400">Credits đã tiêu thụ</div>
			<div class="text-lg font-bold text-blue-400 mt-0.5 font-mono">{completedCount * 80} cr</div>
		</div>
	</div>

	<!-- Filter Tabs -->
	<div class="flex items-center gap-2 border-b border-gray-800 pb-2 overflow-x-auto text-xs">
		<button
			type="button"
			on:click={() => (currentFilter = 'all')}
			class="px-3 py-1.5 rounded-lg transition-colors font-medium {currentFilter === 'all' ? 'bg-gray-800 text-white' : 'text-gray-400 hover:text-white'}">
			Tất cả ({jobs.length})
		</button>
		<button
			type="button"
			on:click={() => (currentFilter = 'active')}
			class="px-3 py-1.5 rounded-lg transition-colors font-medium {currentFilter === 'active' ? 'bg-gray-800 text-amber-300' : 'text-gray-400 hover:text-white'}">
			Đang chạy ({activeCount})
		</button>
		<button
			type="button"
			on:click={() => (currentFilter = 'completed')}
			class="px-3 py-1.5 rounded-lg transition-colors font-medium {currentFilter === 'completed' ? 'bg-gray-800 text-emerald-300' : 'text-gray-400 hover:text-white'}">
			Đã xong ({completedCount})
		</button>
		<button
			type="button"
			on:click={() => (currentFilter = 'failed')}
			class="px-3 py-1.5 rounded-lg transition-colors font-medium {currentFilter === 'failed' ? 'bg-gray-800 text-rose-300' : 'text-gray-400 hover:text-white'}">
			Thất bại ({failedCount})
		</button>
		<button
			type="button"
			on:click={() => (currentFilter = 'cancelled')}
			class="px-3 py-1.5 rounded-lg transition-colors font-medium {currentFilter === 'cancelled' ? 'bg-gray-800 text-gray-300' : 'text-gray-400 hover:text-white'}">
			Đã hủy ({jobs.filter((j) => j.status === 'cancelled').length})
		</button>
	</div>

	<!-- Jobs List -->
	<div class="space-y-3">
		{#if filteredJobs.length === 0}
			<div class="bg-gray-900 border border-gray-800 rounded-xl p-12 text-center text-gray-400 text-xs">
				Không có tiến trình nào phù hợp với bộ lọc hiện tại.
			</div>
		{:else}
			{#each filteredJobs as job (job.jobId)}
				<div class="bg-gray-900 border border-gray-800 rounded-xl p-4 text-white hover:border-gray-700 transition-colors">
					<div class="flex flex-col lg:flex-row lg:items-center justify-between gap-4">
						<!-- Job Info -->
						<div class="flex-1 min-w-0">
							<div class="flex flex-wrap items-center gap-2 mb-1.5">
								<h3 class="font-bold text-sm text-white truncate">{job.title}</h3>
								<span class="text-[10px] px-2 py-0.5 rounded-full font-mono {job.status === 'completed' ? 'bg-emerald-950 text-emerald-300 border border-emerald-800' : job.status === 'processing' ? 'bg-amber-950 text-amber-300 border border-amber-800' : job.status === 'failed' ? 'bg-rose-950 text-rose-300 border border-rose-800' : 'bg-gray-800 text-gray-400'}">
									{job.status.toUpperCase()}
								</span>
								<span class="text-[10px] px-2 py-0.5 rounded-full font-mono {job.provider === 'kling' ? 'bg-amber-950 text-amber-300 border border-amber-800' : 'bg-blue-950 text-blue-300 border border-blue-800'}">
									{job.provider === 'kling' ? 'Kling (Fallback)' : 'Veo (Primary)'}
								</span>
								<span class="text-[11px] text-gray-400 font-mono">ID: {job.jobId}</span>
							</div>

							<p class="text-xs text-gray-400 line-clamp-1 mb-2">{job.prompt}</p>

							<!-- Progress or Error -->
							{#if job.status === 'processing' || job.status === 'queued'}
								<div class="flex items-center gap-3">
									<div class="flex-1 bg-gray-800 rounded-full h-2 overflow-hidden">
										<div class="bg-blue-500 h-2 rounded-full transition-all duration-300" style="width: {job.progressPct}%"></div>
									</div>
									<span class="text-xs font-mono text-gray-300 w-10 text-right">{job.progressPct}%</span>
									<span class="text-xs text-gray-400">· {job.stage}</span>
								</div>
							{:else if job.status === 'failed'}
								<div class="bg-rose-950/30 border border-rose-800/40 rounded p-2 text-xs text-rose-300">
									⚠️ {job.errorMessage || 'Lỗi xử lý'}
								</div>
							{:else if job.status === 'completed'}
								<div class="text-xs text-emerald-400 font-medium">
									✓ Đã hoàn tất và kiểm tra chất lượng (Quality State: Approved)
								</div>
							{/if}
						</div>

						<!-- Actions -->
						<div class="flex items-center gap-2 shrink-0 self-end lg:self-center">
							<span class="text-xs font-mono text-gray-400 mr-2">{job.estimatedCredits} cr</span>

							<button
								type="button"
								on:click={() => viewLineage(job)}
								class="px-2.5 py-1.5 text-xs rounded bg-gray-800 hover:bg-gray-700 text-gray-300 transition-colors">
								Lineage
							</button>

							{#if job.status === 'processing' || job.status === 'queued'}
								<button
									type="button"
									on:click={() => cancelJob(job.jobId)}
									class="px-2.5 py-1.5 text-xs rounded bg-rose-950/50 hover:bg-rose-900 border border-rose-800 text-rose-300 transition-colors">
									Hủy & Hoàn
								</button>
							{/if}

							{#if job.status === 'failed' || job.status === 'cancelled'}
								<button
									type="button"
									on:click={() => retryJob(job.jobId)}
									class="px-3 py-1.5 text-xs rounded bg-blue-600 hover:bg-blue-500 text-white font-medium transition-colors">
									🔄 Chạy lại (Fallback)
								</button>
							{/if}

							{#if job.status === 'completed' && job.resultUrl}
								<a
									href={job.resultUrl}
									target="_blank"
									rel="noreferrer"
									class="px-3 py-1.5 text-xs rounded bg-emerald-600 hover:bg-emerald-500 text-white font-medium transition-colors">
									📥 Tải MP4
								</a>
							{/if}
						</div>
					</div>
				</div>
			{/each}
		{/if}
	</div>
</div>

<LineageInspectionDrawer
	isOpen={isLineageOpen}
	asset={selectedAsset}
	onClose={() => (isLineageOpen = false)}
/>
