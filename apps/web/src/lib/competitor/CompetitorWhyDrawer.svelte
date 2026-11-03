<script lang="ts">
  import type { WhyExplanation, ConfidenceBand, SourceClass } from './index';

  interface Props {
    isOpen: boolean;
    title: string;
    sourceClass?: SourceClass;
    confidence?: ConfidenceBand;
    whyExplanation: WhyExplanation | null;
    onclose: () => void;
  }

  let {
    isOpen = false,
    title,
    sourceClass = 'inferred',
    confidence = 'high',
    whyExplanation,
    onclose
  }: Props = $props();

  function handleKeydown(event: KeyboardEvent) {
    if (event.key === 'Escape' && isOpen) {
      onclose();
    }
  }

  function getConfidenceBadge(conf: ConfidenceBand) {
    switch (conf) {
      case 'high':
        return { label: 'Độ tin cậy Cao (85-95%)', class: 'bg-[#eaf4ed] text-[#274333] border-[#274333]/20' };
      case 'medium':
        return { label: 'Độ tin cậy Trung bình (60-84%)', class: 'bg-[#fef9c3] text-[#854d0e] border-[#854d0e]/20' };
      case 'low':
      default:
        return { label: 'Độ tin cậy Ước tính (<60%)', class: 'bg-[#fdf5f3] text-[#d94a31] border-[#d94a31]/20' };
    }
  }
</script>

<svelte:window onkeydown={handleKeydown} />

{#if isOpen && whyExplanation}
  {@const confBadge = getConfidenceBadge(confidence)}

  <!-- Drawer Backdrop -->
  <div
    class="fixed inset-0 z-50 bg-black/40 backdrop-blur-xs transition-opacity"
    onclick={onclose}
    onkeydown={(e) => e.key === 'Escape' && onclose()}
    role="presentation"
  ></div>

  <!-- Slide-over Drawer Panel -->
  <div
    class="fixed inset-y-0 right-0 z-50 w-full max-w-md bg-[#ffffff] shadow-2xl border-l border-[#e7e2d7] flex flex-col transform transition-transform duration-300 ease-in-out"
    role="dialog"
    aria-modal="true"
    aria-labelledby="why-drawer-title"
    data-testid="why-drawer"
  >
    <!-- Header -->
    <div class="p-5 border-b border-[#e7e2d7] bg-[#fbf9f5] flex items-center justify-between">
      <div class="flex flex-col gap-1">
        <div class="flex items-center gap-2">
          <span class="inline-flex items-center px-2 py-0.5 rounded text-[11px] font-semibold bg-[#fef9c3] text-[#854d0e] border border-[#854d0e]/20" data-testid="why-drawer-source-badge">
            🏷️ {sourceClass.toUpperCase()} (Suy luận)
          </span>
          <span class="inline-flex items-center px-2 py-0.5 rounded text-[11px] font-semibold border {confBadge.class}" data-testid="why-drawer-confidence-badge">
            {confBadge.label}
          </span>
        </div>
        <h2 id="why-drawer-title" class="text-base font-bold text-[#242924] mt-1">
          {title}
        </h2>
      </div>

      <button
        type="button"
        onclick={onclose}
        class="rounded-lg p-1.5 text-[#616c63] hover:bg-[#e7e2d7] hover:text-[#242924] transition-colors"
        aria-label="Đóng ngăn giải thích"
        data-testid="why-drawer-close"
      >
        ✕
      </button>
    </div>

    <!-- Body Content -->
    <div class="flex-1 overflow-y-auto p-6 space-y-6 text-sm">
      <!-- Section 1: Basis Summary -->
      <div>
        <h3 class="text-xs font-bold uppercase tracking-wider text-[#616c63] mb-2">
          📌 Cơ sở suy luận
        </h3>
        <p class="text-[#242924] bg-[#f4f0e8]/50 p-3 rounded-lg border border-[#e7e2d7] text-xs leading-relaxed" data-testid="why-basis-summary">
          {whyExplanation.basisSummary}
        </p>
      </div>

      <!-- Section 2: Data Sources Used -->
      <div>
        <h3 class="text-xs font-bold uppercase tracking-wider text-[#274333] flex items-center gap-1.5 mb-2">
          <span>✅</span> Nguồn dữ liệu sử dụng ({whyExplanation.dataSources.length})
        </h3>
        <ul class="space-y-2" data-testid="why-data-sources">
          {#each whyExplanation.dataSources as src}
            <li class="flex items-start gap-2 text-xs text-[#242924] bg-[#eef3f0]/50 p-2.5 rounded border border-[#274333]/15">
              <span class="text-[#274333] font-bold">•</span>
              <span>{src}</span>
            </li>
          {/each}
        </ul>
      </div>

      <!-- Section 3: Limitations -->
      <div>
        <h3 class="text-xs font-bold uppercase tracking-wider text-[#854d0e] flex items-center gap-1.5 mb-2">
          <span>⚠️</span> Hạn chế thuật toán ({whyExplanation.limitations.length})
        </h3>
        <ul class="space-y-2" data-testid="why-limitations">
          {#each whyExplanation.limitations as lim}
            <li class="flex items-start gap-2 text-xs text-[#854d0e] bg-[#fef9c3]/30 p-2.5 rounded border border-[#854d0e]/20">
              <span class="font-bold">•</span>
              <span>{lim}</span>
            </li>
          {/each}
        </ul>
      </div>

      <!-- Section 4: Data Gaps -->
      <div>
        <h3 class="text-xs font-bold uppercase tracking-wider text-[#d94a31] flex items-center gap-1.5 mb-2">
          <span>🚫</span> Khoảng trống dữ liệu ({whyExplanation.dataGaps.length})
        </h3>
        <ul class="space-y-2" data-testid="why-data-gaps">
          {#each whyExplanation.dataGaps as gap}
            <li class="flex items-start gap-2 text-xs text-[#d94a31] bg-[#fdf5f3] p-2.5 rounded border border-[#d94a31]/20">
              <span class="font-bold">•</span>
              <span>{gap}</span>
            </li>
          {/each}
        </ul>
      </div>

      <!-- Invariant reminder -->
      <div class="rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] p-3 text-[11px] text-[#616c63]">
        <p class="font-semibold text-[#242924] mb-0.5">Quy tắc minh bạch thuật toán Creativanta:</p>
        <p>Mọi kết luận suy luận đều được gắn nhãn INFERRED kèm khoảng tin cậy. Dữ liệu đối thủ chỉ mang tính quan sát và không bao giờ được coi là sự thật kế toán hoặc tự động điền vào sổ cái kinh doanh.</p>
      </div>
    </div>

    <!-- Footer -->
    <div class="p-4 border-t border-[#e7e2d7] bg-[#fbf9f5] flex justify-end">
      <button
        type="button"
        onclick={onclose}
        class="rounded-lg bg-[#274333] px-4 py-2 text-xs font-semibold text-[#fbf9f5] hover:bg-[#1f3529] transition-colors"
      >
        Đã hiểu
      </button>
    </div>
  </div>
{/if}
