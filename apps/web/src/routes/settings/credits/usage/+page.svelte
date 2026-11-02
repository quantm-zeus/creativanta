<script lang="ts">
  import UnavailableNotice from '$lib/components/UnavailableNotice.svelte';
  import {
    DEFAULT_GROSS_MARGIN_FLOOR,
    DEFAULT_USD_PER_CREDIT_FLOOR,
    LOT_CONSUMPTION_PRIORITY,
    computeCostBasedQuoteCredits,
    evaluateConcurrentReservationHold,
    evaluatePaidRetryCommit
  } from '$lib/billing';

  let costCeilingUsd = $state<string>('0.600000');
  let availableCredits = $state<string>('10');
  let requestedCredits = $state<string>('8');
  let activeHolds = $state<number>(0);
  let measuredActualCredits = $state<string>('120');
  let attemptNumber = $state<number>(2);
  let maxAllowedAttempts = $state<number>(2);

  let quotedCredits = $derived.by(() => {
    try {
      return computeCostBasedQuoteCredits(
        costCeilingUsd,
        DEFAULT_USD_PER_CREDIT_FLOOR,
        DEFAULT_GROSS_MARGIN_FLOOR
      );
    } catch {
      return '80';
    }
  });

  let holdVerdict = $derived(
    evaluateConcurrentReservationHold(availableCredits, requestedCredits, activeHolds)
  );
  let retryCommitVerdict = $derived(
    evaluatePaidRetryCommit(quotedCredits, measuredActualCredits, attemptNumber, maxAllowedAttempts)
  );
</script>

<svelte:head>
  <title>Sổ cái Credit Lots, Giữ chỗ &amp; Báo giá — Creativanta (W121)</title>
</svelte:head>

<div class="max-w-5xl mx-auto space-y-6 py-4">
  <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 border-b border-[#e7e2d7] pb-5">
    <div>
      <div class="flex items-center gap-2">
        <span class="rounded bg-[#274333] px-2 py-0.5 text-xs font-semibold text-[#fbf9f5]">
          Màn hình W121 (M23)
        </span>
        <h1 class="text-2xl font-bold tracking-tight text-[#242924]">
          Sổ cái Credit Lots, Giữ chỗ Đồng thời &amp; Trần Báo giá
        </h1>
      </div>
      <p class="text-xs text-[#616c63] mt-1">
        Kiểm chứng thứ tự trừ Lots, chống chi vượt mức khi giữ chỗ đồng thời và khóa trần báo giá khi thử lại có phí.
      </p>
    </div>

    <div class="flex items-center gap-2">
      <a
        href="/settings/billing"
        class="rounded-lg border border-[#e7e2d7] bg-[#ffffff] px-3 py-2 text-xs font-semibold text-[#242924] hover:border-[#8a968c] transition-colors"
      >
        ← Thanh toán &amp; Gói cước (W119)
      </a>
    </div>
  </div>

  <UnavailableNotice
    title="Sổ cái Credit Lots &amp; Báo giá (P0-06 Backend Slice Ready — Transport Unmounted)"
    domain="Credit Accounting &amp; Cost-Based Quote Engine (P0-06)"
    requires="Mounting of AdminBillingService/GetCreditLedger &amp; EstimateCost ConnectRPC Handlers"
    message="Các thao tác nội bộ của worker (Reserve, MarkInFlight, Commit, Release, SweepExpiredHeld, RunCycleBoundary) không phơi bày ra RPC người dùng theo đúng api_behavior_contracts.md §4."
  />

  <div class="rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-4 shadow-xs space-y-2">
    <h2 class="text-sm font-bold text-[#242924]">
      Thứ tự Ưu tiên Tiêu thụ Credit Lots (credit_accounting_contract.md §1)
    </h2>
    <div class="flex flex-wrap gap-2">
      {#each LOT_CONSUMPTION_PRIORITY as source, idx (source)}
        <div class="rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] px-3 py-2 text-xs font-semibold text-[#242924]">
          {idx + 1}. <span class="font-mono text-[#274333]">{source}</span>
        </div>
      {/each}
    </div>
  </div>

  <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
    <div class="rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-4 shadow-xs space-y-3">
      <h3 class="text-xs font-bold text-[#242924]">
        1. Kiểm tra Giữ chỗ Đồng thời (Acceptance Target #1)
      </h3>
      <div class="grid grid-cols-3 gap-2">
        <label class="block space-y-1">
          <span class="text-[11px] font-semibold text-[#616c63]">Khả dụng</span>
          <input
            type="text"
            bind:value={availableCredits}
            class="w-full rounded border border-[#e7e2d7] bg-[#fbf9f5] px-2 py-1 text-xs font-mono"
          />
        </label>
        <label class="block space-y-1">
          <span class="text-[11px] font-semibold text-[#616c63]">Yêu cầu giữ</span>
          <input
            type="text"
            bind:value={requestedCredits}
            class="w-full rounded border border-[#e7e2d7] bg-[#fbf9f5] px-2 py-1 text-xs font-mono"
          />
        </label>
        <label class="block space-y-1">
          <span class="text-[11px] font-semibold text-[#616c63]">Holds đang mở</span>
          <input
            type="number"
            min="0"
            max="6"
            bind:value={activeHolds}
            class="w-full rounded border border-[#e7e2d7] bg-[#fbf9f5] px-2 py-1 text-xs font-mono"
          />
        </label>
      </div>
      <div class="rounded border p-3 text-xs {holdVerdict.allowed ? 'border-[#274333] bg-[#f4f0e8]' : 'border-[#d94a31] bg-[#fff5f2]'}">
        <div class="font-bold">
          {holdVerdict.allowed ? 'GIỮ CHỖ THÀNH CÔNG' : `TỪ CHỐI (${holdVerdict.errorCode})`}
        </div>
        <p class="mt-1 text-[#616c63]">{holdVerdict.reason}</p>
      </div>
    </div>

    <div class="rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-4 shadow-xs space-y-3">
      <h3 class="text-xs font-bold text-[#242924]">
        2. Trần Báo giá &amp; Thử lại Có phí (Acceptance Target #3)
      </h3>
      <div class="grid grid-cols-3 gap-2">
        <label class="block space-y-1">
          <span class="text-[11px] font-semibold text-[#616c63]">Trần USD</span>
          <input
            type="text"
            bind:value={costCeilingUsd}
            class="w-full rounded border border-[#e7e2d7] bg-[#fbf9f5] px-2 py-1 text-xs font-mono"
          />
        </label>
        <label class="block space-y-1">
          <span class="text-[11px] font-semibold text-[#616c63]">Đo thực tế</span>
          <input
            type="text"
            bind:value={measuredActualCredits}
            class="w-full rounded border border-[#e7e2d7] bg-[#fbf9f5] px-2 py-1 text-xs font-mono"
          />
        </label>
        <label class="block space-y-1">
          <span class="text-[11px] font-semibold text-[#616c63]">Lần thử / Tối đa</span>
          <input
            type="number"
            min="1"
            max="4"
            bind:value={attemptNumber}
            class="w-full rounded border border-[#e7e2d7] bg-[#fbf9f5] px-2 py-1 text-xs font-mono"
          />
        </label>
      </div>
      <div class="rounded border p-3 text-xs {retryCommitVerdict.allowed ? 'border-[#274333] bg-[#f4f0e8]' : 'border-[#d94a31] bg-[#fff5f2]'}">
        <div class="font-bold">
          Báo giá xác nhận: {quotedCredits} credits → Quyết toán: {retryCommitVerdict.chargedCredits} credits
        </div>
        <p class="mt-1 text-[#616c63]">{retryCommitVerdict.reason}</p>
      </div>
    </div>
  </div>
</div>
