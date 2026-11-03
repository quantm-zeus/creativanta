<script lang="ts">
  import { validateRejectionReason } from './index';

  interface Props {
    isOpen: boolean;
    scriptTitle: string;
    onConfirm: (reason: string) => void;
    onCancel: () => void;
  }

  let { isOpen, scriptTitle, onConfirm, onCancel }: Props = $props();

  let reason = $state('');
  let validation = $derived(validateRejectionReason(reason));

  function handleConfirm() {
    if (validation.valid) {
      onConfirm(reason.trim());
      reason = '';
    }
  }

  function handleCancel() {
    reason = '';
    onCancel();
  }
</script>

{#if isOpen}
  <div
    class="fixed inset-0 z-50 flex items-center justify-center bg-black/50 p-4 backdrop-blur-sm"
    data-testid="rejection-modal"
  >
    <div
      class="w-full max-w-lg rounded-xl bg-white p-6 shadow-2xl border border-rose-200"
      role="dialog"
      aria-modal="true"
      aria-labelledby="modal-title"
    >
      <div class="flex items-center gap-3 text-rose-700">
        <span class="text-2xl">⚠️</span>
        <h2 id="modal-title" class="text-lg font-bold">
          Yêu cầu chỉnh sửa kịch bản
        </h2>
      </div>

      <p class="mt-2 text-sm text-gray-600">
        Bạn đang từ chối phê duyệt kịch bản <strong class="text-gray-900">{scriptTitle}</strong>.
        Theo quy định kiểm duyệt (RULE-M06-002), bạn cần cung cấp lý do cụ thể để tác giả chỉnh sửa.
      </p>

      <div class="mt-4">
        <label for="rejection-reason" class="block text-xs font-semibold uppercase tracking-wider text-gray-700">
          Lý do từ chối & Hướng dẫn sửa đổi *
        </label>
        <textarea
          id="rejection-reason"
          rows={4}
          bind:value={reason}
          placeholder="Ví dụ: Đoạn mở đầu hook quá dài (7s), cần rút gọn thành 3s nêu thẳng vấn đề mụn lưng trước khi giới thiệu sản phẩm..."
          class="mt-1 w-full rounded-lg border border-gray-300 p-3 text-sm focus:border-rose-500 focus:outline-none focus:ring-1 focus:ring-rose-500"
        ></textarea>

        <div class="mt-1.5 flex items-center justify-between text-xs">
          {#if !validation.valid && reason.trim().length > 0}
            <span class="font-medium text-rose-600">
              {validation.error}
            </span>
          {:else if validation.valid}
            <span class="font-medium text-emerald-600">
              ✓ Lý do hợp lệ ({validation.characterCount} ký tự)
            </span>
          {:else}
            <span class="text-gray-500">Yêu cầu tối thiểu 10 ký tự</span>
          {/if}

          <span class="font-mono text-gray-400">
            {reason.trim().length} / 10 ký tự tối thiểu
          </span>
        </div>
      </div>

      <div class="mt-6 flex justify-end gap-3">
        <button
          type="button"
          onclick={handleCancel}
          class="rounded-lg border border-gray-300 px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none"
        >
          Hủy bỏ
        </button>
        <button
          type="button"
          disabled={!validation.valid}
          onclick={handleConfirm}
          class="rounded-lg bg-rose-600 px-4 py-2 text-sm font-semibold text-white shadow-sm hover:bg-rose-700 disabled:cursor-not-allowed disabled:bg-rose-300 focus:outline-none"
          data-testid="confirm-rejection-btn"
        >
          Xác nhận từ chối (≥10 ký tự)
        </button>
      </div>
    </div>
  </div>
{/if}
