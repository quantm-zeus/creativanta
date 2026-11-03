<script lang="ts">
	import type { AssetLineage } from './types';

	export let isOpen = false;
	export let asset: AssetLineage | null = null;
	export let onClose: () => void = () => {};
</script>

{#if isOpen && asset}
	<div class="fixed inset-0 z-50 flex justify-end bg-black/60 backdrop-blur-sm">
		<div class="bg-gray-900 border-l border-gray-800 w-full max-w-md h-full flex flex-col shadow-2xl text-white">
			<!-- Header -->
			<div class="px-6 py-4 border-b border-gray-800 flex items-center justify-between">
				<div class="flex items-center gap-2">
					<span class="text-xl">🧬</span>
					<h2 class="text-sm font-bold truncate">Nguồn gốc & Tham chiếu (Lineage)</h2>
				</div>
				<button on:click={onClose} class="text-gray-400 hover:text-white transition-colors" aria-label="Đóng">
					✕
				</button>
			</div>

			<!-- Content -->
			<div class="p-6 overflow-y-auto space-y-6 flex-1 text-xs">
				<!-- Title & Basic Info -->
				<div>
					<div class="text-[11px] text-gray-400 uppercase tracking-wider mb-1">Tên tài sản</div>
					<div class="text-sm font-semibold text-white">{asset.title}</div>
					<div class="text-[10px] text-gray-500 font-mono mt-0.5">{asset.assetId}</div>
				</div>

				<!-- Provider & Engine -->
				<div class="bg-gray-800/40 p-3 rounded-lg border border-gray-800 space-y-2">
					<div class="flex justify-between items-center">
						<span class="text-gray-400">Nhà cung cấp thực tế:</span>
						<span class="font-semibold text-blue-400 uppercase">{asset.sourceProvider}</span>
					</div>
					<div class="flex justify-between items-center">
						<span class="text-gray-400">Mô hình AI:</span>
						<span class="font-mono text-gray-200">{asset.sourceModel || 'veo-2.0-generate-001'}</span>
					</div>
					<div class="flex justify-between items-center">
						<span class="text-gray-400">Thời lượng:</span>
						<span class="font-mono text-gray-200">{asset.durationSeconds}s</span>
					</div>
					<div class="flex justify-between items-center">
						<span class="text-gray-400">Độ phân giải:</span>
						<span class="font-mono text-gray-200">{asset.resolution || '1080x1920 (9:16)'}</span>
					</div>
					<div class="flex justify-between items-center">
						<span class="text-gray-400">Chi phí kết xuất USD:</span>
						<span class="font-mono text-emerald-400 font-semibold">${asset.costUSD}</span>
					</div>
				</div>

				<!-- Upstream Lineage Links -->
				<div>
					<div class="text-[11px] text-gray-400 uppercase tracking-wider mb-2">Liên kết thượng nguồn (Upstream Chain)</div>
					<div class="space-y-2">
						{#if asset.upstreamScriptId}
							<div class="bg-gray-800/30 p-2.5 rounded-lg border border-gray-800 flex items-center justify-between">
								<span class="text-gray-300">📜 Kịch bản gốc (Script)</span>
								<a href="/scripts/{asset.upstreamScriptId}" class="text-blue-400 hover:underline font-mono">
									{asset.upstreamScriptId}
								</a>
							</div>
						{/if}
						{#if asset.upstreamCharacterId}
							<div class="bg-gray-800/30 p-2.5 rounded-lg border border-gray-800 flex items-center justify-between">
								<span class="text-gray-300">👤 Nhân vật (Character Pack)</span>
								<a href="/studio/characters" class="text-blue-400 hover:underline font-mono">
									{asset.upstreamCharacterId}
								</a>
							</div>
						{/if}
					</div>
				</div>

				<!-- Continuity Consistency -->
				{#if asset.continuityScore !== undefined}
					<div class="bg-purple-950/20 border border-purple-800/40 p-3 rounded-lg">
						<div class="flex items-center justify-between mb-1">
							<span class="text-purple-300 font-semibold">Chỉ số nhất quán (Continuity Score)</span>
							<span class="font-mono text-sm text-purple-200 font-bold">{Math.round(asset.continuityScore * 100)}%</span>
						</div>
						<div class="text-[11px] text-purple-300/80">
							Đã kiểm tra đối chiếu đặc trưng khuôn mặt và trang phục theo bộ mẫu chuẩn.
						</div>
					</div>
				{/if}

				<!-- Output File -->
				<div>
					<div class="text-[11px] text-gray-400 uppercase tracking-wider mb-1">Tệp kết quả</div>
					<div class="bg-black/40 p-2.5 rounded border border-gray-800 font-mono text-[11px] text-gray-300 break-all select-all">
						{asset.storageUrl || 'https://cdn.creativanta.test/outputs/' + asset.assetId + '.mp4'}
					</div>
				</div>
			</div>

			<!-- Footer -->
			<div class="px-6 py-4 border-t border-gray-800 bg-gray-900/60 flex justify-end">
				<button
					type="button"
					on:click={onClose}
					class="px-4 py-2 text-xs font-medium text-gray-300 bg-gray-800 hover:bg-gray-700 rounded-lg transition-colors">
					Đóng
				</button>
			</div>
		</div>
	</div>
{/if}
