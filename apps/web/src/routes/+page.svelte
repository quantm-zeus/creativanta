<script lang="ts">
  import UnavailableNotice from '$lib/components/UnavailableNotice.svelte';
  import JobCard from '$lib/components/JobCard.svelte';
  import WhyThisNumberModal, { type MetricBreakdown } from '$lib/components/WhyThisNumberModal.svelte';
  import { P0_UNSUPPORTED_FEATURES } from '$lib/constants/navigation';
  import { modeStore, type OperatorModeId } from '$lib/constants/modes';
  import { helpStore } from '$lib/help/store';

  type UIState = 'normal' | 'loading' | 'empty' | 'error' | 'repair';
  let activeUIState = $state<UIState>('normal');

  let currentMode = $derived($modeStore);
  let modeDef = $derived(modeStore.getModeDef(currentMode));

  let selectedBreakdown = $state<MetricBreakdown | null>(null);

  // Onboarding steps progress
  let onboardingSteps = $state([
    { id: 'step-1', label: '1. Chọn vai trò vận hành phù hợp (6 chế độ)', completed: true },
    { id: 'step-2', label: '2. Kết nối kênh TikTok Shop / Shopee', completed: false },
    { id: 'step-3', label: '3. Khám phá 3 xu hướng ngành hàng nổi bật', completed: false },
    { id: 'step-4', label: '4. Tạo kịch bản video AI đầu tiên', completed: false },
    { id: 'step-5', label: '5. Cài đặt thông báo SLA và nhịp việc', completed: false }
  ]);

  let completedStepsCount = $derived(onboardingSteps.filter((s) => s.completed).length);

  function toggleOnboardingStep(id: string) {
    onboardingSteps = onboardingSteps.map((s) =>
      s.id === id ? { ...s, completed: !s.completed } : s
    );
  }

  // Pre-configured "Why This Number" breakdowns
  const BREAKDOWNS: Record<string, MetricBreakdown> = {
    revenue_demo: {
      metricKey: 'revenue_demo',
      metricTitle: 'Doanh thu mẫu minh họa (Demo GMV)',
      displayValue: '48.500.000 ₫',
      rawCents: 4850000000,
      dataSourceBadge: 'DEMO',
      confidenceLevel: 'LOW',
      calculationFormula: 'SUM(demo_fixture_orders.amount) WHERE status = "completed"',
      caveats: [
        'Dữ liệu mẫu fixture tĩnh nhằm trực quan hóa giao diện báo cáo.',
        'Tuyệt đối không cộng gộp vào tổng doanh thu thực tế của tài khoản (Acceptance Target 3).',
        'Sẽ tự động ẩn đi khi bạn kết nối tài khoản bán hàng chính thức đầu tiên.'
      ],
      nextSteps: [
        'Kết nối tài khoản TikTok Shop hoặc Shopee trong phần Kênh kết nối.',
        'Đồng bộ đơn hàng thực tế qua giao thức OAuth.'
      ],
      isCustomerVerified: false
    },
    customer_verified: {
      metricKey: 'customer_verified',
      metricTitle: 'Doanh thu thực tế của khách hàng (Verified GMV)',
      displayValue: '0 ₫',
      rawCents: 0,
      dataSourceBadge: 'OFFICIAL',
      confidenceLevel: 'HIGH',
      calculationFormula: 'SUM(verified_orders.final_amount) WHERE workspace_id = current_tenant',
      caveats: [
        'Chưa có đơn hàng nào phát sinh từ kênh bán hàng thực tế.',
        'Chỉ phản ánh đơn hàng đã được sàn đối soát hợp lệ.'
      ],
      nextSteps: [
        'Đăng sản phẩm hoặc liên kết giỏ hàng tiếp thị.',
        'Thực hiện xuất bản video gắn link sản phẩm để kích hoạt doanh số.'
      ],
      isCustomerVerified: true
    },
    completion_rate: {
      metricKey: 'completion_rate',
      metricTitle: 'Tỷ lệ xem hết video (Completion Rate)',
      displayValue: '68.4%',
      dataSourceBadge: 'INFERRED',
      confidenceLevel: 'MEDIUM',
      calculationFormula: 'COUNT(video_views >= 100%) / TOTAL_IMPRESSIONS * 100',
      caveats: [
        'Dữ liệu suy luận từ mẫu thử nghiệm A/B nội bộ trên 500 người dùng.',
        'Độ chính xác phụ thuộc vào việc cập nhật định kỳ từ webhook phân phối.'
      ],
      nextSteps: [
        'Tối ưu hóa 3 giây mở đầu của kịch bản video để tăng độ giữ chân khán giả.'
      ],
      isCustomerVerified: false
    }
  };

  function openWhyNumber(key: string) {
    selectedBreakdown = BREAKDOWNS[key] || BREAKDOWNS.revenue_demo;
  }
</script>

<svelte:head>
  <title>Tổng quan — Daily Decision Engine ({modeDef.shortLabel}) — Creativanta</title>
</svelte:head>

<div class="space-y-6">
  <!-- Mode Identity & Header Banner -->
  <div class="rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-5 shadow-xs">
    <div class="flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
      <div class="space-y-1">
        <div class="flex items-center gap-2">
          <span class="rounded bg-[#274333] px-2.5 py-0.5 text-xs font-bold text-[#ffffff] uppercase tracking-wider">
            {modeDef.name}
          </span>
          <span class="rounded bg-[#f4f0e8] px-2 py-0.5 font-mono text-xs font-medium text-[#274333]">
            Phân hệ: {modeDef.primaryModule}
          </span>
        </div>
        <h1 class="text-xl font-bold tracking-tight text-[#242924] sm:text-2xl">
          {modeDef.tagline}
        </h1>
        <p class="text-xs text-[#616c63] max-w-2xl">
          {modeDef.description}
        </p>
      </div>

      <!-- Priority Brief Box -->
      <div class="rounded-lg border border-[#274333]/20 bg-[#fbf9f5] p-3 max-w-md">
        <span class="text-[10px] font-bold uppercase tracking-wider text-[#274333] block">
          Nhịp việc ưu tiên hôm nay
        </span>
        <p class="mt-1 text-xs font-medium text-[#242924]">
          {modeDef.priorityBrief}
        </p>
      </div>
    </div>

    <!-- Focus Metrics Ribbon -->
    <div class="mt-4 pt-3 border-t border-[#f4f0e8] flex flex-wrap items-center gap-2 sm:gap-6 text-xs text-[#616c63]">
      <span class="font-semibold text-[#242924]">Chỉ số trọng tâm:</span>
      {#each modeDef.focusMetrics as metric}
        <span class="flex items-center gap-1.5 rounded-full bg-[#fbf9f5] border border-[#e7e2d7] px-3 py-1 text-xs font-medium text-[#274333]">
          <span class="h-1.5 w-1.5 rounded-full bg-[#274333]"></span>
          {metric}
        </span>
      {/each}
    </div>
  </div>

  <!-- UI State Switcher Bar (Acceptance Target: 4 UI States Tested) -->
  <div class="rounded-lg border border-[#e7e2d7] bg-[#ffffff] p-3 flex flex-wrap items-center justify-between gap-3 shadow-2xs">
    <div class="flex items-center gap-2 text-xs">
      <span class="font-semibold text-[#616c63]">Kiểm thử 4 trạng thái giao diện:</span>
      <div class="flex flex-wrap items-center gap-1">
        <button
          type="button"
          onclick={() => activeUIState = 'normal'}
          class="rounded px-2.5 py-1 text-xs font-medium transition-colors {activeUIState === 'normal' ? 'bg-[#274333] text-[#ffffff]' : 'text-[#616c63] hover:bg-[#f4f0e8]'}"
        >
          1. Chuẩn (Normal)
        </button>
        <button
          type="button"
          onclick={() => activeUIState = 'loading'}
          class="rounded px-2.5 py-1 text-xs font-medium transition-colors {activeUIState === 'loading' ? 'bg-[#274333] text-[#ffffff]' : 'text-[#616c63] hover:bg-[#f4f0e8]'}"
        >
          2. Đang tải (Loading)
        </button>
        <button
          type="button"
          onclick={() => activeUIState = 'empty'}
          class="rounded px-2.5 py-1 text-xs font-medium transition-colors {activeUIState === 'empty' ? 'bg-[#274333] text-[#ffffff]' : 'text-[#616c63] hover:bg-[#f4f0e8]'}"
        >
          3. Trống (Empty)
        </button>
        <button
          type="button"
          onclick={() => activeUIState = 'error'}
          class="rounded px-2.5 py-1 text-xs font-medium transition-colors {activeUIState === 'error' ? 'bg-[#d94a31] text-[#ffffff]' : 'text-[#d94a31] hover:bg-[#fbeee9]'}"
        >
          4. Lỗi (Error)
        </button>
        <button
          type="button"
          onclick={() => activeUIState = 'repair'}
          class="rounded px-2.5 py-1 text-xs font-medium transition-colors {activeUIState === 'repair' ? 'bg-[#854d0e] text-[#ffffff]' : 'text-[#854d0e] hover:bg-[#fef9c3]'}"
        >
          5. Sửa lỗi (Repair)
        </button>
      </div>
    </div>

    <span class="text-[11px] text-[#616c63]">
      Trạng thái hiện tại: <strong class="uppercase text-[#274333]">{activeUIState}</strong>
    </span>
  </div>

  <!-- State 4: Error Banner -->
  {#if activeUIState === 'error'}
    <div
      role="alert"
      class="rounded-xl border border-[#d94a31]/30 bg-[#fbeee9] p-4 text-[#d94a31] shadow-xs"
    >
      <div class="flex items-start justify-between gap-3">
        <div class="flex items-start gap-3">
          <svg class="h-5 w-5 mt-0.5 shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
          </svg>
          <div>
            <h3 class="text-sm font-bold">Lỗi đồng bộ dữ liệu quyết định (M01-E-503)</h3>
            <p class="mt-1 text-xs leading-relaxed text-[#242924]">
              Hệ thống không thể kết nối tới máy chủ phân tích tín hiệu thời gian thực. Đang tạm thời hiển thị dữ liệu lưu cục bộ gần nhất.
            </p>
            <div class="mt-3 flex items-center gap-3">
              <button
                type="button"
                onclick={() => activeUIState = 'normal'}
                class="rounded bg-[#d94a31] px-3 py-1.5 text-xs font-semibold text-[#ffffff] hover:bg-[#b83b24] transition-colors"
              >
                Thử lại kết nối
              </button>
              <button
                type="button"
                onclick={() => helpStore.isOpen.open('M01')}
                class="text-xs font-semibold text-[#274333] underline hover:no-underline"
              >
                Xem tài liệu khắc phục sự cố →
              </button>
            </div>
          </div>
        </div>
        <button
          type="button"
          onclick={() => activeUIState = 'normal'}
          class="text-[#616c63] hover:text-[#242924]"
          aria-label="Đóng cảnh báo lỗi"
        >
          ✕
        </button>
      </div>
    </div>
  {/if}

  <!-- State 5: Repair Card -->
  {#if activeUIState === 'repair'}
    <div class="rounded-xl border border-[#854d0e]/30 bg-[#fef9c3]/50 p-4 shadow-xs">
      <div class="flex items-center justify-between">
        <div class="flex items-center gap-3">
          <span class="flex h-8 w-8 items-center justify-center rounded-full bg-[#854d0e] text-sm text-[#ffffff]">
            ⚠️
          </span>
          <div>
            <h3 class="text-sm font-bold text-[#854d0e]">
              Cần sửa chữa: Tài khoản TikTok Shop bị ngắt kết nối (M11)
            </h3>
            <p class="text-xs text-[#242924]">
              Quyền truy cập API đã hết hạn sau 30 ngày. Cần cấp lại quyền để tiếp tục đồng bộ đơn hàng và kịch bản.
            </p>
          </div>
        </div>

        <a
          href="/settings/connections"
          class="rounded-md bg-[#854d0e] px-3 py-1.5 text-xs font-bold text-[#ffffff] hover:bg-[#713f12] transition-colors"
        >
          Cấp lại quyền ngay (1 CTA)
        </a>
      </div>
    </div>
  {/if}

  <!-- Onboarding 5-Step Checklist (M01 Pack 01 §S05.1) -->
  <div class="rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-5 shadow-xs">
    <div class="flex items-center justify-between border-b border-[#f4f0e8] pb-3 mb-3">
      <div>
        <h3 class="text-sm font-bold text-[#242924]">
          Lộ trình làm quen hệ thống (5 Bước khởi đầu)
        </h3>
        <span class="text-xs text-[#616c63]">
          Tiến độ: {completedStepsCount}/5 bước hoàn tất
        </span>
      </div>
      <div class="w-32 bg-[#f4f0e8] rounded-full h-2 overflow-hidden">
        <div
          class="bg-[#274333] h-full transition-all duration-300"
          style="width: {(completedStepsCount / 5) * 100}%"
        ></div>
      </div>
    </div>

    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-2.5">
      {#each onboardingSteps as step}
        <button
          type="button"
          onclick={() => toggleOnboardingStep(step.id)}
          class="flex items-center gap-2.5 rounded-lg border p-2.5 text-left text-xs transition-colors {step.completed ? 'border-[#274333]/20 bg-[#fbf9f5] text-[#274333]' : 'border-[#e7e2d7] bg-[#ffffff] text-[#616c63] hover:border-[#274333]'}"
        >
          <span class="flex h-5 w-5 shrink-0 items-center justify-center rounded-full {step.completed ? 'bg-[#274333] text-[#ffffff]' : 'border border-[#e7e2d7] text-transparent'}">
            ✓
          </span>
          <span class="font-medium {step.completed ? 'line-through opacity-80' : ''}">
            {step.label}
          </span>
        </button>
      {/each}
    </div>
  </div>

  <!-- State 2: Loading Skeleton -->
  {#if activeUIState === 'loading'}
    <div aria-busy="true" class="space-y-4 animate-pulse">
      <div class="h-6 w-48 bg-[#e7e2d7] rounded"></div>
      <div class="grid grid-cols-1 gap-5 md:grid-cols-2 lg:grid-cols-3">
        <div class="h-48 bg-[#e7e2d7] rounded-xl"></div>
        <div class="h-48 bg-[#e7e2d7] rounded-xl"></div>
        <div class="h-48 bg-[#e7e2d7] rounded-xl"></div>
      </div>
      <p class="text-center text-xs text-[#616c63]">Đang tải dữ liệu quyết định theo vai trò...</p>
    </div>

  <!-- State 3: Empty State -->
  {:else if activeUIState === 'empty'}
    <div class="rounded-xl border border-dashed border-[#e7e2d7] bg-[#ffffff] p-12 text-center">
      <div class="mx-auto flex h-12 w-12 items-center justify-center rounded-full bg-[#f4f0e8] text-[#274333]">
        ✓
      </div>
      <h3 class="mt-3 text-base font-bold text-[#242924]">
        Tất cả quyết định hôm nay đã được xử lý xong
      </h3>
      <p class="mt-1 text-xs text-[#616c63] max-w-sm mx-auto">
        Không có cảnh báo tồn kho, vi phạm SLA hay bất thường thanh toán nào cần can thiệp.
      </p>
      <div class="mt-4">
        <button
          type="button"
          onclick={() => activeUIState = 'normal'}
          class="rounded-md bg-[#274333] px-4 py-2 text-xs font-semibold text-[#ffffff] hover:bg-[#1f3629]"
        >
          Làm mới dữ liệu nhịp việc
        </button>
      </div>
    </div>

  <!-- State 1: Normal Decision Grid with Mode-Specific Cards -->
  {:else}
    <!-- Financial & Data Separation Banner (Acceptance Target 3: No Demo in Customer Totals) -->
    <div class="rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-5 shadow-xs">
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <div class="flex items-center gap-2">
            <h3 class="text-sm font-bold text-[#242924]">
              Tổng hợp doanh số & Minh bạch dữ liệu khách hàng
            </h3>
            <span class="rounded bg-[#eaf4ed] px-2 py-0.5 text-[10px] font-semibold text-[#274333] border border-[#274333]/20">
              Nguyên tắc Target 3
            </span>
          </div>
          <p class="text-xs text-[#616c63] mt-1">
            Cách ly tuyệt đối số liệu mẫu demo fixture khỏi tổng doanh thu thực tế được đối soát.
          </p>
        </div>

        <button
          type="button"
          onclick={() => openWhyNumber('revenue_demo')}
          class="rounded-md border border-[#e7e2d7] bg-[#fbf9f5] px-3 py-1.5 text-xs font-semibold text-[#274333] hover:bg-[#f4f0e8] transition-colors"
        >
          🔍 Tại sao có số này?
        </button>
      </div>

      <!-- Verified vs Demo Totals -->
      <div class="mt-4 grid grid-cols-1 gap-4 sm:grid-cols-2">
        <!-- Customer Verified Total -->
        <div class="rounded-lg border border-[#274333]/30 bg-[#fbf9f5] p-4">
          <div class="flex items-center justify-between">
            <span class="text-[11px] font-bold uppercase tracking-wider text-[#274333]">
              Doanh thu thực tế khách hàng
            </span>
            <span class="rounded bg-[#274333] px-2 py-0.5 text-[10px] font-semibold text-[#ffffff]">
              Xác thực (Verified)
            </span>
          </div>
          <div class="mt-2 flex items-baseline gap-2">
            <span class="text-2xl font-bold font-mono text-[#242924]">0 ₫</span>
            <span class="text-[11px] text-[#616c63]">(Chưa kết nối kênh chính thức)</span>
          </div>
          <p class="mt-2 text-[11px] text-[#616c63] border-t border-[#e7e2d7] pt-2">
            Số tiền thực nhận sau đối soát. Tuyệt đối không cộng dồn dữ liệu mẫu.
          </p>
        </div>

        <!-- Demo Fixture Card (Strictly Isolated) -->
        <div class="rounded-lg border border-[#d94a31]/30 bg-[#fbeee9]/40 p-4">
          <div class="flex items-center justify-between">
            <span class="text-[11px] font-bold uppercase tracking-wider text-[#d94a31]">
              Dữ liệu mẫu trải nghiệm (Fixture)
            </span>
            <span class="rounded bg-[#d94a31] px-2 py-0.5 text-[10px] font-semibold text-[#ffffff]">
              DEMO (Cách ly)
            </span>
          </div>
          <div class="mt-2 flex items-baseline gap-2">
            <span class="text-2xl font-bold font-mono text-[#d94a31]">48.500.000 ₫</span>
            <span class="text-[11px] text-[#d94a31] font-medium">[Không tính vào tổng]</span>
          </div>
          <p class="mt-2 text-[11px] text-[#616c63] border-t border-[#d94a31]/20 pt-2">
            Chỉ phục vụ minh họa giao diện. Không phát sinh quyền rút tiền hay nghĩa vụ thuế.
          </p>
        </div>
      </div>
    </div>

    <!-- Mode-Specific Decision Grid -->
    <div class="grid grid-cols-1 gap-5 md:grid-cols-2 lg:grid-cols-3">
      <!-- Card 1: Mode Core Priority -->
      <JobCard
        title="Quyết định trọng tâm ({modeDef.shortLabel})"
        moduleTag={modeDef.primaryModule}
        description={modeDef.priorityBrief}
      >
        <div class="space-y-3">
          <div class="rounded bg-[#fbf9f5] p-3 border border-[#e7e2d7]">
            <span class="text-[11px] font-semibold text-[#274333] uppercase tracking-wider block">
              Gợi ý hành động tiếp theo
            </span>
            <p class="text-xs text-[#242924] mt-1 font-medium">
              {#if currentMode === 'creator'}
                Render 2 video AI từ kịch bản top xu hướng tiêu dùng nhanh.
              {:else if currentMode === 'seller'}
                Xác nhận 12 đơn hàng Shopee trước 16:00 để tránh điểm phạt SLA.
              {:else if currentMode === 'affiliate_operator'}
                Thay thế 1 link affiliate Shopee bị lỗi 404 bằng deal hoa hồng 18%.
              {:else if currentMode === 'live_operator'}
                Xếp lại thứ tự 8 deal flash sale cho phiên live 20:00 tối nay.
              {:else if currentMode === 'agency_mcn'}
                Gửi nhắc nhở nghiệm thu KPI cho 5 creator giai đoạn 1.
              {:else}
                Duyệt 6 kịch bản video từ KOC trước 15:00 để kịp lịch phát sóng.
              {/if}
            </p>
          </div>

          <!-- Unbuilt Action Button with Explanation (Target 2) -->
          <div class="space-y-1">
            <button
              type="button"
              disabled
              title="Chức năng thuộc Module {modeDef.primaryModule} (Giai đoạn P1) — Hiện tại chưa kết nối backend live"
              class="w-full cursor-not-allowed rounded-md bg-[#e7e2d7] py-2 px-3 text-xs font-medium text-[#616c63] transition-colors"
            >
              Thực thi hành động (Chưa kết nối live)
            </button>
            <span class="text-[10px] text-[#616c63] block text-center">
              Khóa an toàn: Module {modeDef.primaryModule} chưa kết nối connector sàn
            </span>
          </div>
        </div>
      </JobCard>

      <!-- Card 2: Operating Pulse & SLA -->
      <JobCard
        title="Nhịp vận hành & SLA (M12/M19)"
        moduleTag="M12/M19"
        description="Giám sát cảnh báo SLA phản hồi khách hàng và phát hiện bất thường tài chính."
      >
        <div class="space-y-3">
          <div class="flex items-center justify-between text-xs py-1 border-b border-[#f4f0e8]">
            <span class="text-[#616c63]">Đơn chờ xử lý:</span>
            <span class="font-mono font-semibold text-[#242924]">3 đơn (Cảnh báo SLA)</span>
          </div>
          <div class="flex items-center justify-between text-xs py-1 border-b border-[#f4f0e8]">
            <span class="text-[#616c63]">Thời hạn phản hồi còn lại:</span>
            <span class="font-mono font-semibold text-[#d94a31]">02:14:30</span>
          </div>

          <div class="space-y-1">
            <button
              type="button"
              disabled
              class="w-full cursor-not-allowed rounded-md bg-[#e7e2d7] py-2 px-3 text-xs font-medium text-[#616c63]"
            >
              Mở hàng đợi phản hồi (Chưa khả dụng)
            </button>
            <span class="text-[10px] text-[#616c63] block text-center">
              Yêu cầu quyền Order Management (M19)
            </span>
          </div>
        </div>
      </JobCard>

      <!-- Card 3: AI Credit Quota (M23) -->
      <JobCard
        title="Hạn mức AI Credit (M23)"
        moduleTag="M23"
        description="Quản lý và đối soát số dư lot tín dụng sử dụng cho các tác vụ AI Studio."
      >
        <div class="space-y-3">
          <div class="flex items-center justify-between text-xs py-1 border-b border-[#f4f0e8]">
            <span class="text-[#616c63]">Credit khả dụng:</span>
            <span class="font-mono font-bold text-[#274333]">150 Credits</span>
          </div>
          <div class="flex items-center justify-between text-xs py-1 border-b border-[#f4f0e8]">
            <span class="text-[#616c63]">Số dư lot kế toán:</span>
            <span class="font-mono text-[#616c63]">Lot #2026-P0</span>
          </div>

          <div class="space-y-1">
            <button
              type="button"
              disabled
              class="w-full cursor-not-allowed rounded-md bg-[#e7e2d7] py-2 px-3 text-xs font-medium text-[#616c63]"
            >
              Nạp thêm tín dụng (Cổng thanh toán tắt)
            </button>
            <span class="text-[10px] text-[#616c63] block text-center">
              Bảo vệ: Tuyệt đối không giả lập giao dịch tiền tệ
            </span>
          </div>
        </div>
      </JobCard>
    </div>
  {/if}

  <!-- P0 Architectural Status Table -->
  <div class="rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-5 shadow-xs">
    <h3 class="text-sm font-bold tracking-tight text-[#242924] mb-3">
      Trạng thái ranh giới thực thi P0
    </h3>
    <div class="overflow-x-auto">
      <table class="w-full text-left text-xs">
        <thead class="border-b border-[#e7e2d7] text-[#616c63]">
          <tr>
            <th class="py-2 font-medium">Hạng mục</th>
            <th class="py-2 font-medium">Trạng thái hiện tại</th>
            <th class="py-2 font-medium">Ràng buộc thực thi</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-[#f4f0e8]">
          {#each P0_UNSUPPORTED_FEATURES as item}
            <tr>
              <td class="py-2.5 font-medium text-[#242924]">{item.domain} — {item.feature}</td>
              <td class="py-2.5">
                <span class="rounded bg-[#fbeee9] px-2 py-0.5 font-mono text-[10px] font-semibold text-[#d94a31]">
                  {item.status}
                </span>
              </td>
              <td class="py-2.5 text-[#616c63]">{item.explanation}</td>
            </tr>
          {/each}
        </tbody>
      </table>
    </div>
  </div>
</div>

<!-- "Why This Number" Modal -->
<WhyThisNumberModal
  breakdown={selectedBreakdown}
  onclose={() => selectedBreakdown = null}
/>
