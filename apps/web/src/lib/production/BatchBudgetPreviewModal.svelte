<script lang="ts">
	import type { BatchBudgetPreview } from './types';

	export let isOpen = false;
	export let preview: BatchBudgetPreview | null = null;
	export let onConfirm: () => void = () => {};
	export let onClose: () => void = () => {};

	function formatTime(isoString: string): string {
		try {
			const d = new Date(isoString);
			return d.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', second: '2-digit' });
		} catch {
			return isoString;
		}
	}
</script>

{#if isOpen && preview}
	<div class="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm p-4">
		<div class="bg-gray-900 border border-gray-700 rounded-xl shadow-2xl max-w-2xl w-full max-h-[90vh] flex flex-col overflow-hidden text-white" role="dialog" aria-modal="true">
			<!-- Header -->
			<div class="px-6 py-4 border-b border-gray-800 flex items-center justify-between">
				<div class="flex items-center gap-2">
					<span class="text-xl">💰</span>
					<h2 class="text-lg font-bold">Xem trước ngân sách (Budget Preview)</h2>
				</div>
				<button on:click={onClose} class="text-gray-400 hover:text-white transition-colors" aria-label="Đóng">
					✕
				</button>
			</div>

			<!-- Body -->
			<div class="p-6 overflow-y-auto space-y-6 flex-1 text-sm">
				<!-- Quote banner -->
				<div class="flex items-center justify-between bg-gray-800/60 p-3 rounded-lg border border-gray-700">
					<div>
						<div class="text-xs text-gray-400">Mã báo giá (Quote ID)</div>
						<div class="font-mono text-xs text-blue-400">{preview.quoteId}</div>
					</div>
					<div class="text-right">
						<div class="text-xs text-gray-400">Hết hạn lúc</div>
						<div class="text-xs font-semibold text-amber-400">{formatTime(preview.quoteExpiresAt)}</div>
					</div>
				</div>

				<!-- Stats Grid -->
				<div class="grid grid-cols-2 sm:grid-cols-4 gap-3 text-center">
					<div class="bg-gray-800/40 p-3 rounded-lg border border-gray-800">
						<div class="text-xs text-gray-400">Tổng số mục</div>
						<div class="text-xl font-bold mt-1">{preview.totalItems}</div>
					</div>
					<div class="bg-emerald-950/30 p-3 rounded-lg border border-emerald-800/40">
						<div class="text-xs text-emerald-400">Hợp lệ</div>
						<div class="text-xl font-bold text-emerald-300 mt-1">{preview.validItemsCount}</div>
					</div>
					<div class="bg-rose-950/30 p-3 rounded-lg border border-rose-800/40">
						<div class="text-xs text-rose-400">Không hợp lệ</div>
						<div class="text-xl font-bold text-rose-300 mt-1">{preview.invalidItemsCount}</div>
					</div>
					<div class="bg-blue-950/30 p-3 rounded-lg border border-blue-800/40">
						<div class="text-xs text-blue-400">Ước tính (Credits)</div>
						<div class="text-xl font-bold text-blue-300 mt-1">{preview.totalEstimatedCredits}</div>
					</div>
				</div>

				<!-- Balance check notice -->
				{#if !preview.sufficientCredits}
					<div class="bg-amber-950/40 border border-amber-600/50 rounded-lg p-3 text-amber-200 flex items-start gap-2.5">
						<span class="text-lg">⚠️</span>
						<div class="text-xs">
							<div class="font-semibold text-amber-300">Số dư credits không đủ để chạy toàn bộ mẻ này</div>
							<div>Hiện có: <strong class="text-white">{preview.currentAvailableCredits} credits</strong> · Cần: <strong class="text-white">{preview.totalEstimatedCredits} credits</strong>. Vui lòng nạp thêm trước khi xác nhận.</div>
						</div>
					</div>
				{:else}
					<div class="bg-emerald-950/30 border border-emerald-600/40 rounded-lg p-3 text-emerald-200 flex items-center justify-between text-xs">
						<span>✅ Số dư khả dụng ({preview.currentAvailableCredits} credits) đủ để chạy {preview.validItemsCount} mục hợp lệ.</span>
						<span class="text-gray-400 font-mono">Trần USD: ${preview.totalCostCeilingUSD}</span>
					</div>
				{/if}

				<!-- Row by row validation table -->
				<div>
					<h3 class="font-semibold text-gray-300 mb-2 text-xs uppercase tracking-wider">Chi tiết kiểm duyệt từng dòng ({preview.items.length})</h3>
					<div class="border border-gray-800 rounded-lg divide-y divide-gray-800 max-h-56 overflow-y-auto">
						{#each preview.items as item (item.index)}
							<div class="p-3 flex items-center justify-between text-xs {item.isValid ? 'bg-gray-900/40' : 'bg-rose-950/10'}">
								<div class="flex items-center gap-2">
									<span class={item.isValid ? 'text-emerald-400' : 'text-rose-400'}>
										{item.isValid ? '✓' : '✗'}
									</span>
									<div>
										<div class="font-medium text-white">{item.itemName || `Mục #${item.index + 1}`}</div>
										{#if !item.isValid}
											<div class="text-rose-400 text-[11px] mt-0.5">{item.validationError}</div>
										{/if}
									</div>
								</div>
								<div class="text-right">
									<div class="font-mono {item.isValid ? 'text-blue-300 font-semibold' : 'text-gray-500'}">
										{item.estimatedCredits} credits
									</div>
									<div class="text-[10px] text-gray-500 font-mono">
										${item.estimatedCostUSD}
									</div>
								</div>
							</div>
						{/each}
					</div>
				</div>
			</div>

			<!-- Footer -->
			<div class="px-6 py-4 border-t border-gray-800 bg-gray-900/60 flex items-center justify-between">
				<button
					type="button"
					on:click={onClose}
					class="px-4 py-2 text-xs font-medium text-gray-400 hover:text-white rounded-lg hover:bg-gray-800 transition-colors">
					Hủy bỏ
				</button>
				<button
					type="button"
					on:click={onConfirm}
					disabled={!preview.sufficientCredits || preview.validItemsCount === 0}
					class="px-5 py-2 text-xs font-semibold rounded-lg bg-blue-600 text-white hover:bg-blue-500 disabled:opacity-50 disabled:cursor-not-allowed transition-all shadow-lg shadow-blue-600/30">
					Xác nhận chạy ({preview.validItemsCount} mục · {preview.totalEstimatedCredits} credits)
				</button>
			</div>
		</div>
	</div>
{/if}
