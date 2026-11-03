<script lang="ts">
  import type { CreditQuotePreview } from './index';

  interface Props {
    quote: CreditQuotePreview;
    onConfirm: () => void;
    onCancel: () => void;
  }

  let { quote, onConfirm, onCancel }: Props = $props();

  let isPending = $derived(quote.status === 'pending');
  let isConfirmed = $derived(quote.status === 'confirmed');
  let isCancelled = $derived(quote.status === 'cancelled');
  let hasEnoughCredits = $derived(quote.currentBalance >= quote.costCredits);
</script>

<div
  class="my-3 p-4 rounded-xl border transition-all duration-200 shadow-sm {isPending
    ? 'bg-amber-50/70 border-amber-200'
    : isConfirmed
      ? 'bg-emerald-50/70 border-emerald-200'
      : 'bg-rose-50/70 border-rose-200'}"
  data-testid="quote-preview-card"
>
  <div class="flex items-start justify-between gap-3">
    <div class="flex items-center gap-2">
      <span class="text-xl">
        {#if isPending}💳{:else if isConfirmed}✅{:else}❌{/if}
      </span>
      <h4 class="text-sm font-semibold text-gray-900">
        {quote.title}
      </h4>
    </div>
    <span
      class="text-xs px-2.5 py-1 rounded-full font-medium {isPending
        ? 'bg-amber-100 text-amber-800'
        : isConfirmed
          ? 'bg-emerald-100 text-emerald-800'
          : 'bg-rose-100 text-rose-800'}"
    >
      {#if isPending}Chờ xác nhận{:else if isConfirmed}Đã xác nhận{:else}Đã hủy{/if}
    </span>
  </div>

  <p class="text-xs text-gray-600 mt-2 leading-relaxed">
    {quote.summary}
  </p>

  <div class="grid grid-cols-2 gap-2 my-3 text-xs bg-white/80 p-2.5 rounded-lg border border-gray-100">
    <div>
      <span class="text-gray-500 block">Chi phí:</span>
      <span class="font-bold text-amber-700" data-testid="quote-cost">
        {quote.costCredits} credits
      </span>
    </div>
    <div>
      <span class="text-gray-500 block">Số dư hiện tại:</span>
      <span class="font-medium text-gray-700">
        {quote.currentBalance} credits
      </span>
    </div>
  </div>

  {#if isPending}
    {#if !hasEnoughCredits}
      <div class="mb-3 text-xs text-rose-600 font-medium flex items-center gap-1.5">
        <span>⚠️</span> Số dư credits không đủ để thực hiện thao tác này.
      </div>
    {/if}

    <div class="flex items-center justify-end gap-2 pt-1">
      <button
        type="button"
        onclick={onCancel}
        class="px-3 py-1.5 text-xs font-medium text-gray-600 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 transition cursor-pointer"
        data-testid="quote-cancel-btn"
      >
        Hủy bỏ
      </button>
      <button
        type="button"
        onclick={onConfirm}
        disabled={!hasEnoughCredits}
        class="px-3 py-1.5 text-xs font-medium text-white bg-[#0e3a2f] rounded-lg hover:bg-[#134e3f] disabled:opacity-50 disabled:cursor-not-allowed transition cursor-pointer"
        data-testid="quote-confirm-btn"
      >
        Xác nhận & Tạo
      </button>
    </div>
  {/if}
</div>
