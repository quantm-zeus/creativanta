<script lang="ts">
	import type { GenerationJobItem } from './types';

	export let jobs: GenerationJobItem[] = [];
	export let onCancelJob: (jobId: string) => void = () => {};

	$: activeJobs = jobs.filter((j) => j.status === 'processing' || j.status === 'queued');
</script>

{#if activeJobs.length > 0}
	<div class="bg-gradient-to-r from-gray-900 to-gray-800 border border-amber-600/30 rounded-xl p-4 shadow-lg mb-6 text-white">
		<div class="flex items-center justify-between mb-3">
			<div class="flex items-center gap-2">
				<span class="inline-block w-2.5 h-2.5 bg-amber-400 rounded-full animate-pulse"></span>
				<span class="font-semibold text-sm">Đang thực hiện ({activeJobs.length} tiến trình AI)</span>
			</div>
			<a href="/studio/queue" class="text-xs text-blue-400 hover:text-blue-300 font-medium">
				Xem toàn bộ hàng đợi →
			</a>
		</div>

		<div class="space-y-3">
			{#each activeJobs as job (job.jobId)}
				<div class="bg-black/30 rounded-lg p-3 border border-gray-700/60 flex flex-col sm:flex-row sm:items-center justify-between gap-3">
					<div class="flex-1 min-w-0">
						<div class="flex items-center gap-2 mb-1">
							<span class="text-xs font-semibold truncate text-white">{job.title}</span>
							<span class="text-[10px] px-2 py-0.5 rounded-full font-mono {job.provider === 'kling' ? 'bg-amber-950 text-amber-300 border border-amber-800' : 'bg-blue-950 text-blue-300 border border-blue-800'}">
								{job.provider === 'kling' ? 'Kling (Fallback)' : 'Veo (Primary)'}
							</span>
							<span class="text-[10px] text-gray-400">· {job.stage || 'Đang kết xuất'}</span>
						</div>

						<div class="flex items-center gap-3">
							<div class="flex-1 bg-gray-700 rounded-full h-2 overflow-hidden">
								<div class="bg-blue-500 h-2 rounded-full transition-all duration-300" style="width: {job.progressPct}%"></div>
							</div>
							<span class="text-xs font-mono text-gray-300 w-10 text-right">{job.progressPct}%</span>
						</div>
					</div>

					<div class="flex items-center gap-3">
						<span class="text-xs text-gray-400 font-mono">{job.estimatedCredits} cr</span>
						<button
							type="button"
							on:click={() => onCancelJob(job.jobId)}
							class="text-xs px-2.5 py-1 rounded bg-rose-950/50 hover:bg-rose-900 border border-rose-800/60 text-rose-300 hover:text-rose-100 transition-colors">
							Hủy & Hoàn
						</button>
					</div>
				</div>
			{/each}
		</div>
	</div>
{/if}
