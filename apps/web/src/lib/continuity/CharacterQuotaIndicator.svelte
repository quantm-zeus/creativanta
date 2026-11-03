<script lang="ts">
  import { getSlotQuota } from './types';

  interface Props {
    activeCount?: number;
    tier?: string;
    onUpgradeClick?: () => void;
  }

  let { activeCount = 0, tier = 'free', onUpgradeClick }: Props = $props();

  let quota = $derived(getSlotQuota(tier));
  let isUnlimited = $derived(quota === -1);
  let isAtLimit = $derived(!isUnlimited && activeCount >= quota);
  let percentage = $derived(isUnlimited ? 0 : Math.min(100, Math.round((activeCount / quota) * 100)));
</script>

<div class="bg-white border rounded-xl p-4 shadow-sm">
  <div class="flex items-center justify-between gap-4 mb-2">
    <div>
      <span class="text-sm font-semibold text-gray-900">Giới hạn nhân vật (Character Slots)</span>
      <span class="ml-2 text-xs uppercase px-2 py-0.5 rounded font-mono font-medium bg-gray-100 text-gray-700">
        Gói {tier}
      </span>
    </div>
    <div class="text-sm font-medium text-gray-700">
      {#if isUnlimited}
        <span class="text-emerald-600 font-semibold">{activeCount} nhân vật (Không giới hạn)</span>
      {:else}
        <span class="{isAtLimit ? 'text-rose-600 font-bold' : 'text-gray-900 font-semibold'}">
          {activeCount} / {quota}
        </span>
        <span class="text-xs text-gray-500 ml-1">đang kích hoạt</span>
      {/if}
    </div>
  </div>

  {#if !isUnlimited}
    <div class="w-full bg-gray-100 rounded-full h-2 overflow-hidden mb-3">
      <div
        class="h-full rounded-full transition-all duration-300 {isAtLimit ? 'bg-rose-500' : 'bg-primary-600'}"
        style="width: {percentage}%"
        role="progressbar"
        aria-valuenow={activeCount}
        aria-valuemin={0}
        aria-valuemax={quota}
      ></div>
    </div>
  {/if}

  {#if isAtLimit}
    <div class="flex items-center justify-between gap-2 p-2.5 bg-amber-50 border border-amber-200 rounded-lg text-xs text-amber-800">
      <span>
        ⚠️ Đã đạt giới hạn số lượng nhân vật cho gói <strong>{tier}</strong> ({activeCount}/{quota}). Nâng cấp gói hoặc lưu trữ nhân vật cũ để tạo thêm.
      </span>
      {#if onUpgradeClick}
        <button
          type="button"
          onclick={onUpgradeClick}
          class="shrink-0 px-3 py-1 bg-amber-600 hover:bg-amber-700 text-white font-medium rounded shadow-sm transition-colors cursor-pointer"
        >
          Nâng cấp gói
        </button>
      {/if}
    </div>
  {/if}
</div>
