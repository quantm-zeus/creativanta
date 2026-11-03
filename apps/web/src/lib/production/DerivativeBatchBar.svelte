<script lang="ts">
	import type { BatchTagResult } from './types';

	export let selectedAssetIds: string[] = [];
	export let onClearSelection: () => void = () => {};
	export let onBatchTag: (addTags: string[], removeTags: string[]) => Promise<BatchTagResult>;
	export let onRouteToPackaging: () => Promise<void> = async () => {};
	export let onDelete: () => Promise<void> = async () => {};

	let tagModalOpen = false;
	let resultModalOpen = false;
	let addTagsInput = '';
	let removeTagsInput = '';
	let isProcessing = false;
	let batchResult: BatchTagResult | null = null;
	let errorMessage = '';

	async function handleExecuteTag() {
		const add = addTagsInput.split(',').map((t) => t.trim()).filter((t) => t.length > 0);
		const remove = removeTagsInput.split(',').map((t) => t.trim()).filter((t) => t.length > 0);

		isProcessing = true;
		errorMessage = '';
		try {
			batchResult = await onBatchTag(add, remove);
			tagModalOpen = false;
			resultModalOpen = true;
		} catch (err: unknown) {
			errorMessage = err instanceof Error ? err.message : 'Thao tác hàng loạt thất bại';
		} finally {
			isProcessing = false;
		}
	}
</script>

{#if selectedAssetIds.length > 0}
	<!-- Floating Bottom Action Bar -->
	<div class="fixed bottom-6 left-1/2 -translate-x-1/2 z-40 bg-gray-900/95 border border-gray-700/80 shadow-2xl rounded-2xl px-6 py-3.5 backdrop-blur-md flex items-center gap-6 text-white text-xs">
		<div class="flex items-center gap-2">
			<span class="inline-flex items-center justify-center bg-blue-600 text-white font-bold rounded-full w-6 h-6 text-xs">
				{selectedAssetIds.length}
			</span>
			<span class="font-medium text-gray-300">mục đã chọn</span>
		</div>

		<div class="h-4 w-px bg-gray-700"></div>

		<!-- Actions -->
		<div class="flex items-center gap-2">
			<button
				on:click={() => (tagModalOpen = true)}
				class="px-3 py-1.5 bg-blue-600 hover:bg-blue-500 font-semibold rounded-lg transition-colors flex items-center gap-1.5"
			>
				<span>🏷️</span>
				<span>Gắn thẻ hàng loạt (Batch Tag)</span>
			</button>

			<button
				on:click={onRouteToPackaging}
				class="px-3 py-1.5 bg-emerald-600 hover:bg-emerald-500 font-semibold rounded-lg transition-colors flex items-center gap-1.5"
			>
				<span>🚀</span>
				<span>Chuyển sang Packaging QA</span>
			</button>

			<button
				on:click={onDelete}
				class="px-3 py-1.5 bg-rose-600/30 hover:bg-rose-600/50 text-rose-300 border border-rose-500/40 rounded-lg transition-colors"
			>
				<span>🗑️ Xóa</span>
			</button>
		</div>

		<div class="h-4 w-px bg-gray-700"></div>

		<button
			on:click={onClearSelection}
			class="text-gray-400 hover:text-white underline text-xs"
		>
			Bỏ chọn
		</button>
	</div>
{/if}

<!-- Batch Tag Modal -->
{#if tagModalOpen}
	<div class="fixed inset-0 z-50 flex items-center justify-center bg-black/70 backdrop-blur-sm p-4">
		<div class="bg-gray-900 border border-gray-700 rounded-xl shadow-2xl max-w-md w-full p-6 text-white space-y-4">
			<div class="flex items-center justify-between border-b border-gray-800 pb-3">
				<h3 class="font-bold text-sm">Gắn thẻ cho {selectedAssetIds.length} mục</h3>
				<button on:click={() => (tagModalOpen = false)} class="text-gray-400 hover:text-white">✕</button>
			</div>

			{#if errorMessage}
				<div class="bg-rose-950/60 border border-rose-800 text-rose-200 p-2.5 rounded text-xs">
					{errorMessage}
				</div>
			{/if}

			<div class="space-y-3 text-xs">
				<div>
					<label for="addTagsInput" class="block font-medium text-gray-300 mb-1">Thẻ thêm vào (phân cách bằng dấu phẩy):</label>
					<input
						id="addTagsInput"
						bind:value={addTagsInput}
						type="text"
						placeholder="campaign-summer, featured, viral"
						class="w-full bg-gray-800 border border-gray-700 rounded p-2 text-white placeholder-gray-500 focus:outline-none focus:border-blue-500"
					/>
				</div>

				<div>
					<label for="removeTagsInput" class="block font-medium text-gray-300 mb-1">Thẻ gỡ bỏ (phân cách bằng dấu phẩy):</label>
					<input
						id="removeTagsInput"
						bind:value={removeTagsInput}
						type="text"
						placeholder="draft, archive"
						class="w-full bg-gray-800 border border-gray-700 rounded p-2 text-white placeholder-gray-500 focus:outline-none focus:border-blue-500"
					/>
				</div>
			</div>

			<div class="flex items-center justify-end gap-2 pt-2 border-t border-gray-800">
				<button
					on:click={() => (tagModalOpen = false)}
					class="px-4 py-2 bg-gray-800 hover:bg-gray-700 text-gray-300 rounded text-xs font-medium"
				>
					Hủy
				</button>
				<button
					on:click={handleExecuteTag}
					disabled={isProcessing || (!addTagsInput && !removeTagsInput)}
					class="px-4 py-2 bg-blue-600 hover:bg-blue-500 disabled:bg-gray-700 text-white rounded text-xs font-semibold transition-colors"
				>
					{isProcessing ? 'Đang thực hiện...' : 'Áp dụng thẻ'}
				</button>
			</div>
		</div>
	</div>
{/if}

<!-- Batch Result Partial Failure Modal -->
{#if resultModalOpen && batchResult}
	<div class="fixed inset-0 z-50 flex items-center justify-center bg-black/70 backdrop-blur-sm p-4">
		<div class="bg-gray-900 border border-gray-700 rounded-xl shadow-2xl max-w-lg w-full p-6 text-white space-y-4">
			<div class="flex items-center justify-between border-b border-gray-800 pb-3">
				<h3 class="font-bold text-sm">Kết quả xử lý hàng loạt (Batch Result)</h3>
				<button on:click={() => (resultModalOpen = false)} class="text-gray-400 hover:text-white">✕</button>
			</div>

			<!-- Summary line per AC 1: "147/150 succeeded. 3 failed: [view details]." -->
			<div class="p-3 rounded-lg border {batchResult.failedCount > 0 ? 'bg-amber-950/40 border-amber-800 text-amber-200' : 'bg-emerald-950/40 border-emerald-800 text-emerald-200'} text-xs font-semibold">
				{batchResult.summary}
			</div>

			<div class="grid grid-cols-3 gap-2 text-center text-xs">
				<div class="bg-gray-800 p-2.5 rounded border border-gray-700">
					<div class="text-gray-400">Tổng số</div>
					<div class="font-bold text-base text-white">{batchResult.totalItems}</div>
				</div>
				<div class="bg-gray-800 p-2.5 rounded border border-gray-700">
					<div class="text-gray-400">Thành công</div>
					<div class="font-bold text-base text-emerald-400">{batchResult.succeededCount}</div>
				</div>
				<div class="bg-gray-800 p-2.5 rounded border border-gray-700">
					<div class="text-gray-400">Thất bại</div>
					<div class="font-bold text-base text-rose-400">{batchResult.failedCount}</div>
				</div>
			</div>

			<!-- Failures list if partial failures occurred -->
			{#if batchResult.failures.length > 0}
				<div class="space-y-1.5 max-h-48 overflow-y-auto text-xs">
					<div class="text-gray-400 font-medium">Chi tiết lỗi ({batchResult.failures.length}):</div>
					{#each batchResult.failures as f}
						<div class="bg-gray-800/60 border border-gray-700/80 p-2 rounded flex justify-between items-center text-xs">
							<span class="font-mono text-gray-300">{f.assetId}</span>
							<span class="text-rose-400 font-semibold">[{f.errorCode}] {f.errorMessage}</span>
						</div>
					{/each}
				</div>
			{/if}

			<div class="flex justify-end pt-2 border-t border-gray-800">
				<button
					on:click={() => (resultModalOpen = false)}
					class="px-4 py-2 bg-blue-600 hover:bg-blue-500 text-white rounded text-xs font-semibold"
				>
					Đóng
				</button>
			</div>
		</div>
	</div>
{/if}
