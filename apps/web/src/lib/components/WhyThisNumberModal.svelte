<script lang="ts">
  import { activateModalFocusSession, handleModalKeydown } from '$lib/a11y';

  export interface MetricBreakdown {
    metricKey: string;
    metricTitle: string;
    displayValue: string;
    rawCents?: number;
    dataSourceBadge: 'OFFICIAL' | 'IMPORTED' | 'INFERRED' | 'DEMO';
    confidenceLevel: 'HIGH' | 'MEDIUM' | 'LOW';
    calculationFormula: string;
    caveats: string[];
    nextSteps: string[];
    isCustomerVerified: boolean;
  }

  interface Props {
    breakdown: MetricBreakdown | null;
    onclose: () => void;
  }

  let { breakdown, onclose }: Props = $props();
  let dialogElement = $state<HTMLElement | null>(null);
  let cleanupFocusSession: (() => void) | null = null;

  function closeModal() {
    if (cleanupFocusSession) {
      cleanupFocusSession();
      cleanupFocusSession = null;
    }
    onclose();
  }

  $effect(() => {
    if (breakdown && dialogElement) {
      cleanupFocusSession = activateModalFocusSession(dialogElement);
      return () => {
        if (cleanupFocusSession) {
          cleanupFocusSession();
          cleanupFocusSession = null;
        }
      };
    }
  });

  function handleKeydown(event: KeyboardEvent) {
    if (breakdown && dialogElement) {
      handleModalKeydown(event, dialogElement, closeModal);
    }
  }

  function getBadgeConfig(badge: string) {
    switch (badge) {
      case 'OFFICIAL':
        return { label: 'Chính thức (Official API)', class: 'bg-[#eaf4ed] text-[#274333] border border-[#274333]/20' };
      case 'IMPORTED':
        return { label: 'Nhập liệu (Imported CSV)', class: 'bg-[#edf4fb] text-[#1e40af] border border-[#1e40af]/20' };
      case 'INFERRED':
        return { label: 'Suy luận AI (Inferred ML)', class: 'bg-[#fef9c3] text-[#854d0e] border border-[#854d0e]/20' };
      case 'DEMO':
      default:
        return { label: 'Dữ liệu mẫu (Demo Fixture)', class: 'bg-[#fbeee9] text-[#d94a31] border border-[#d94a31]/30' };
    }
  }

  function getConfidenceConfig(level: string) {
    switch (level) {
      case 'HIGH':
        return { label: 'Độ tin cậy Cao (99%+)', class: 'text-[#274333]' };
      case 'MEDIUM':
        return { label: 'Độ tin cậy Trung bình (85%-98%)', class: 'text-[#854d0e]' };
      case 'LOW':
      default:
        return { label: 'Độ tin cậy Ước tính (<85%)', class: 'text-[#d94a31]' };
    }
  }
</script>

<svelte:window onkeydown={handleKeydown} />

{#if breakdown}
  {@const badgeConfig = getBadgeConfig(breakdown.dataSourceBadge)}
  {@const confConfig = getConfidenceConfig(breakdown.confidenceLevel)}

  <!-- Modal Backdrop & Dialog Container -->
  <div
    class="fixed inset-0 z-50 flex items-center justify-center p-4 sm:p-6 bg-black/50 backdrop-blur-xs transition-opacity"
    onclick={(e) => { if (e.target === e.currentTarget) closeModal(); }}
    role="presentation"
  >
    <div
      bind:this={dialogElement}
      role="dialog"
      aria-modal="true"
      aria-labelledby="why-number-title"
      tabindex="-1"
      class="w-full max-w-lg rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-6 shadow-2xl transition-all"
    >
      <!-- Header -->
      <div class="flex items-start justify-between border-b border-[#e7e2d7] pb-4">
        <div>
          <div class="flex items-center gap-2 mb-1">
            <span class="rounded px-2 py-0.5 text-[11px] font-semibold {badgeConfig.class}">
              {badgeConfig.label}
            </span>
            {#if !breakdown.isCustomerVerified}
              <span class="rounded bg-[#fbeee9] px-2 py-0.5 text-[11px] font-bold text-[#d94a31]">
                CÁCH LY: KHÔNG CỘNG DỒN
              </span>
            {/if}
          </div>
          <h3 id="why-number-title" class="text-lg font-bold text-[#242924]">
            {breakdown.metricTitle}
          </h3>
        </div>

        <button
          type="button"
          onclick={closeModal}
          class="rounded-md p-1.5 text-[#616c63] hover:bg-[#f4f0e8] hover:text-[#242924]"
          aria-label="Đóng"
        >
          <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>
      </div>

      <!-- Content -->
      <div class="mt-4 space-y-4 text-xs">
        <!-- Big Number -->
        <div class="rounded-lg bg-[#fbf9f5] border border-[#e7e2d7] p-4 text-center">
          <span class="text-[11px] uppercase tracking-wider text-[#616c63] font-semibold block">
            Giá trị hiển thị trên bảng tin
          </span>
          <span class="mt-1 text-2xl font-mono font-bold text-[#274333] block">
            {breakdown.displayValue}
          </span>
          <span class="mt-1 text-[11px] {confConfig.class} font-medium block">
            {confConfig.label}
          </span>
        </div>

        <!-- Strict Demo Isolation Banner (if DEMO) -->
        {#if breakdown.dataSourceBadge === 'DEMO'}
          <div class="rounded-lg border border-[#d94a31]/40 bg-[#fbeee9] p-3 text-[#d94a31]">
            <strong class="font-bold block">Nguyên tắc bảo vệ dữ liệu khách hàng (Acceptance Target 3)</strong>
            <p class="mt-1 text-[11px] leading-relaxed">
              Dữ liệu mẫu demo fixture được tạo ra nhằm minh họa giao diện khi bạn chưa kết nối kênh bán hàng thực tế. Hệ thống kế toán và sổ cái (M19/M23) tuyệt đối <strong>không cộng gộp</strong> số tiền này vào tổng doanh thu, lợi nhuận hay số dư của tài khoản.
            </p>
          </div>
        {/if}

        <!-- Formula -->
        <div>
          <span class="font-bold text-[#242924] block mb-1">Công thức tính toán (Formula):</span>
          <div class="rounded bg-[#f4f0e8] p-2.5 font-mono text-[11px] text-[#242924] border border-[#e7e2d7]">
            {breakdown.calculationFormula}
          </div>
        </div>

        <!-- Caveats -->
        {#if breakdown.caveats.length > 0}
          <div>
            <span class="font-bold text-[#242924] block mb-1">Lưu ý & Điểm nghẽn cần chú ý:</span>
            <ul class="list-disc pl-4 space-y-1 text-[#616c63]">
              {#each breakdown.caveats as caveat}
                <li>{caveat}</li>
              {/each}
            </ul>
          </div>
        {/if}

        <!-- Next Steps -->
        {#if breakdown.nextSteps.length > 0}
          <div>
            <span class="font-bold text-[#242924] block mb-1">Hành động khuyến nghị tiếp theo:</span>
            <ul class="list-disc pl-4 space-y-1 text-[#274333] font-medium">
              {#each breakdown.nextSteps as step}
                <li>{step}</li>
              {/each}
            </ul>
          </div>
        {/if}
      </div>

      <!-- Footer -->
      <div class="mt-6 flex justify-end border-t border-[#e7e2d7] pt-4">
        <button
          type="button"
          onclick={closeModal}
          class="rounded-md bg-[#274333] px-4 py-2 text-xs font-semibold text-[#ffffff] hover:bg-[#1f3629] transition-colors"
        >
          Đã hiểu giải trình
        </button>
      </div>
    </div>
  </div>
{/if}
