<script lang="ts">
  import type { AccessProofRecord, SourceVerificationStatus } from './access_proof';

  let { proof, onReconnect = undefined }: {
    proof: AccessProofRecord;
    onReconnect?: () => void;
  } = $props();

  let showDetails = $state(false);

  const statusConfigs: Record<
    SourceVerificationStatus,
    { label: string; bg: string; text: string; border: string; icon: string }
  > = {
    verified: {
      label: 'Xác minh chính thức',
      bg: 'bg-emerald-50',
      text: 'text-emerald-700',
      border: 'border-emerald-200',
      icon: '🛡️'
    },
    imported: {
      label: 'Dữ liệu nhập thủ công',
      bg: 'bg-blue-50',
      text: 'text-blue-700',
      border: 'border-blue-200',
      icon: '📥'
    },
    degraded: {
      label: 'Cảnh báo: Suy thoái kết nối',
      bg: 'bg-amber-50',
      text: 'text-amber-700',
      border: 'border-amber-200',
      icon: '⚠️'
    },
    unsupported: {
      label: 'Chưa xác thực quyền',
      bg: 'bg-rose-50',
      text: 'text-rose-700',
      border: 'border-rose-200',
      icon: '🔒'
    }
  };

  let cfg = $derived(statusConfigs[proof.status] || statusConfigs.unsupported);
</script>

<div class="inline-flex flex-col gap-1 text-xs">
  <div class="inline-flex items-center gap-2 rounded-lg border {cfg.border} {cfg.bg} px-2.5 py-1 font-semibold {cfg.text}">
    <span>{cfg.icon}</span>
    <span>{cfg.label}</span>
    <button
      type="button"
      onclick={() => showDetails = !showDetails}
      class="ml-1 text-[11px] underline opacity-80 hover:opacity-100"
      title="Xem bằng chứng truy cập"
    >
      {showDetails ? 'Ẩn chi tiết' : 'Bằng chứng'}
    </button>
  </div>

  {#if showDetails}
    <div class="mt-1 max-w-sm rounded-lg border border-slate-200 bg-white p-3 text-slate-700 shadow-sm">
      <div class="font-bold text-slate-900 flex justify-between">
        <span>Nguồn: {proof.platform} ({proof.actionKey})</span>
        <span class="text-[10px] text-slate-500 uppercase">{proof.sourceClass}</span>
      </div>
      {#if proof.evidenceRef}
        <div class="mt-1 text-[11px] font-mono text-slate-600 truncate" title={proof.evidenceRef}>
          Bằng chứng: {proof.evidenceRef}
        </div>
      {/if}
      {#if proof.endpoint}
        <div class="mt-1 text-[11px] font-mono text-slate-500 truncate" title={proof.endpoint}>
          Endpoint: {proof.endpoint}
        </div>
      {/if}
      {#if proof.degradedReason}
        <div class="mt-2 rounded bg-amber-50 p-1.5 text-[11px] text-amber-800">
          ⚠️ {proof.degradedReason}
        </div>
      {/if}
      {#if proof.fallbackNote}
        <div class="mt-1 text-[11px] text-slate-500">
          ℹ️ {proof.fallbackNote}
        </div>
      {/if}
      {#if proof.reconnectRequired && onReconnect}
        <button
          type="button"
          onclick={onReconnect}
          class="mt-2 w-full rounded bg-indigo-600 px-2 py-1 text-xs font-semibold text-white hover:bg-indigo-700"
        >
          🔄 Kết nối lại tài khoản
        </button>
      {/if}
    </div>
  {/if}
</div>
