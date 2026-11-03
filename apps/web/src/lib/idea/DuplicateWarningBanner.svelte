<script lang="ts">
  import type { DuplicateWarning } from './index';

  interface Props {
    warning: DuplicateWarning;
    onProceedAnyway?: () => void;
    onViewExisting?: (id: string) => void;
    onDismiss?: () => void;
  }

  let {
    warning,
    onProceedAnyway = () => {},
    onViewExisting = () => {},
    onDismiss = () => {}
  }: Props = $props();
</script>

<div
  class="rounded-lg border-2 border-amber-400 bg-amber-50 p-4 shadow-sm"
  role="alert"
  aria-live="polite"
>
  <div class="flex items-start gap-3">
    <div class="mt-0.5 rounded-full bg-amber-100 p-1.5 text-amber-700">
      <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          stroke-width="2"
          d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"
        />
      </svg>
    </div>

    <div class="flex-1 space-y-1">
      <h4 class="text-sm font-semibold text-amber-900">
        Cảnh báo ý tưởng tương tự (Trùng lặp &gt; 85%)
      </h4>
      <p class="text-xs text-amber-800">
        {warning.warningMessage}
      </p>
      <div class="mt-2 text-xs font-medium text-amber-900 bg-amber-100/70 rounded p-2 border border-amber-200">
        Ý tưởng đã có: <span class="font-bold">"{warning.existingIdeaTitle}"</span>
        (Độ tương đồng: {Math.round(warning.similarityScore * 100)}%)
      </div>

      <div class="mt-3 flex flex-wrap gap-2">
        <button
          type="button"
          onclick={() => onViewExisting(warning.existingIdeaId)}
          class="rounded-md bg-white px-3 py-1.5 text-xs font-semibold text-amber-900 shadow-sm border border-amber-300 hover:bg-amber-50 focus:outline-none focus:ring-2 focus:ring-amber-500"
        >
          🔍 Xem ý tưởng đã có
        </button>

        <button
          type="button"
          onclick={onProceedAnyway}
          class="rounded-md bg-amber-600 px-3 py-1.5 text-xs font-semibold text-white shadow-sm hover:bg-amber-700 focus:outline-none focus:ring-2 focus:ring-amber-500"
        >
          ⚠️ Vẫn tạo (Không gộp tự động)
        </button>

        <button
          type="button"
          onclick={onDismiss}
          class="rounded-md px-3 py-1.5 text-xs font-medium text-amber-700 hover:text-amber-900"
        >
          Đổi tiêu đề
        </button>
      </div>
    </div>
  </div>
</div>
