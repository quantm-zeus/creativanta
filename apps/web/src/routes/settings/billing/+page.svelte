<script lang="ts">
  import type { WorkspaceRole } from '$lib/auth';
  import UnavailableNotice from '$lib/components/UnavailableNotice.svelte';
  import {
    BIZ_007_TAX_RESPONSIBILITY_DISCLAIMER,
    CANONICAL_ADDONS,
    CANONICAL_PAYMENT_METHOD_GATES,
    CANONICAL_PLANS,
    PRICEBOOK_VERSION,
    computeAddonProration,
    computeMeasuredCohortEconomics,
    evaluateBillingPermission,
    evaluateLastPaymentMethodRemoval,
    evaluatePaymentMethodAccessGate,
    evaluateReportExportQuota,
    evaluateRestoreExportAndErasureEvidence,
    evaluateTrialDunningPauseAndCancellationLifecycle,
    type LifecycleScenarioKind,
    type PaymentMethodType,
    type PlanTierCode
  } from '$lib/billing';

  let selectedRole = $state<WorkspaceRole>('owner');
  let selectedPlan = $state<PlanTierCode>('pro');
  let billingCurrency = $state<'USD' | 'VND'>('VND');
  let paymentMethodCount = $state<number>(1);
  let subscriptionActive = $state<boolean>(true);
  let selectedPaymentMethod = $state<PaymentMethodType>('momo');
  let selectedGateOpened = $state<boolean>(false);
  let selectedLifecycleScenario = $state<LifecycleScenarioKind>('cancel_phase_1_quarantine_0_30d');
  let purchasedCreditsBalance = $state<string>('500');
  let activeMemberCount = $state<number>(2);
  let ownershipTransferred = $state<boolean>(false);
  let monthlyExportsUsed = $state<number>(3);

  let readPerm = $derived(evaluateBillingPermission(selectedRole, 'read_billing'));
  let managePerm = $derived(evaluateBillingPermission(selectedRole, 'manage_billing'));
  let pmRemovalVerdict = $derived(
    evaluateLastPaymentMethodRemoval(selectedPlan, subscriptionActive, paymentMethodCount)
  );
  let pmGateVerdict = $derived(
    evaluatePaymentMethodAccessGate(
      selectedPaymentMethod,
      selectedPlan,
      selectedGateOpened ? [selectedPaymentMethod] : []
    )
  );
  let lifecycleVerdict = $derived(
    evaluateTrialDunningPauseAndCancellationLifecycle(
      selectedLifecycleScenario,
      selectedPlan,
      purchasedCreditsBalance
    )
  );
  let dunningComparisonVerdict = $derived(
    evaluateTrialDunningPauseAndCancellationLifecycle(
      'dunning_downgrade_day_14',
      selectedPlan,
      purchasedCreditsBalance
    )
  );
  let restoreEraseVerdict = $derived(
    evaluateRestoreExportAndErasureEvidence({
      actionType: 'erase_right_to_erasure',
      workspaceId: '00000000-0000-4000-8000-000000000001',
      activeMemberCount,
      ownershipTransferredOrMembersRemoved: ownershipTransferred,
      hasValidPaymentMethod: true,
      supportTicketId: 'SUP-2026-9001',
      purchasedCredits: purchasedCreditsBalance
    })
  );
  let exportQuotaVerdict = $derived(evaluateReportExportQuota(selectedPlan, monthlyExportsUsed));
  let sampleAddonProration = $derived(
    computeAddonProration('commerce_intelligence', billingCurrency, 'monthly', 15, 30)
  );
  let sampleCohortEconomics = $derived(
    computeMeasuredCohortEconomics({
      cohortMonth: '2026-11',
      planTier: selectedPlan,
      activeWorkspaces: 100,
      subscriptionRevenueUsd: '6000',
      creditPackRevenueUsd: '2000',
      addonRevenueUsd: '2000',
      aiProviderCostUsd: '2000',
      cloudInfraCostUsd: '700',
      paymentProcessingFeeUsd: '300',
      startingMrrUsd: '8000',
      expansionMrrUsd: '1600',
      contractionMrrUsd: '400',
      churnedMrrUsd: '400',
      salesAndMarketingSpendUsd: '2800',
      newPaidWorkspacesAcquired: 20,
      monthlyLogoChurnRatePct: '5'
    })
  );
</script>

<svelte:head>
  <title>Thanh toán &amp; Gói cước — Creativanta (W119)</title>
</svelte:head>

<div class="max-w-5xl mx-auto space-y-6 py-4">
  <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 border-b border-[#e7e2d7] pb-5">
    <div>
      <div class="flex items-center gap-2">
        <span class="rounded bg-[#274333] px-2 py-0.5 text-xs font-semibold text-[#fbf9f5]">
          Màn hình W119 (M23)
        </span>
        <h1 class="text-2xl font-bold tracking-tight text-[#242924]">
          Quản lý Gói cước, Add-on &amp; Thanh toán
        </h1>
      </div>
      <p class="text-xs text-[#616c63] mt-1">
        Bảng giá có phiên bản ({PRICEBOOK_VERSION}), phân quyền Owner-only và khóa bảo vệ phương thức thanh toán cuối cùng (EC-M23-001).
      </p>
    </div>

    <div class="flex flex-wrap items-center gap-2">
      <a
        href="/settings/credits/purchase"
        class="rounded-lg border border-[#e7e2d7] bg-[#ffffff] px-3 py-2 text-xs font-semibold text-[#242924] hover:border-[#8a968c] transition-colors"
      >
        Mua thêm Credits (W120/W128) →
      </a>
      <a
        href="/settings/credits/usage"
        class="rounded-lg border border-[#e7e2d7] bg-[#ffffff] px-3 py-2 text-xs font-semibold text-[#242924] hover:border-[#8a968c] transition-colors"
      >
        Sổ cái Lots &amp; Báo giá (W121) →
      </a>
    </div>
  </div>

  <UnavailableNotice
    title="Dịch vụ Thanh toán &amp; Sổ cái Credits (P0-06 Backend Slice Ready — Transport Unmounted)"
    domain="Credit Lots, Cost-Based Quotes &amp; Billing Foundations (P0-06)"
    requires="Mounting of AdminBillingService / BillingService / CreditService ConnectRPC Handlers &amp; Live Stripe Webhook"
    message="Lược đồ PostgreSQL 00004_p0_06_credit_lots_quotes_and_billing.sql (ai_provider_rates, ai_credit_quotes, ai_credit_lots, ai_credit_reservations, ai_credit_reservation_allocations, invoices, payment_methods) và gói apps/api/internal/billing đã được triển khai và kiểm thử. Giao diện chỉ hiển thị bảng giá chuẩn có phiên bản, không giả lập giao dịch thanh toán."
  />

  <div class="flex items-center justify-between">
    <h2 class="text-sm font-bold text-[#242924]">
      5 Gói cước Chuẩn (Pricebook {PRICEBOOK_VERSION})
    </h2>
    <div class="flex items-center gap-2">
      <button
        type="button"
        onclick={() => (billingCurrency = 'VND')}
        class="rounded px-2.5 py-1 text-xs font-bold {billingCurrency === 'VND'
          ? 'bg-[#274333] text-[#fbf9f5]'
          : 'bg-[#f4f0e8] text-[#242924]'}"
      >
        VND (₫)
      </button>
      <button
        type="button"
        onclick={() => (billingCurrency = 'USD')}
        class="rounded px-2.5 py-1 text-xs font-bold {billingCurrency === 'USD'
          ? 'bg-[#274333] text-[#fbf9f5]'
          : 'bg-[#f4f0e8] text-[#242924]'}"
      >
        USD ($)
      </button>
    </div>
  </div>

  <div class="grid grid-cols-1 md:grid-cols-5 gap-3">
    {#each CANONICAL_PLANS as plan (plan.tierCode)}
      <div class="rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-4 shadow-xs space-y-2">
        <div class="flex items-center justify-between">
          <span class="text-sm font-bold text-[#242924]">{plan.displayName}</span>
          <span class="rounded bg-[#f4f0e8] px-1.5 py-0.5 font-mono text-[10px] font-semibold text-[#274333]">
            {plan.tierCode}
          </span>
        </div>
        <div class="text-base font-bold text-[#d94a31] font-mono">
          {billingCurrency === 'VND' ? `₫${plan.monthlyPriceVnd}/th` : `$${plan.monthlyPriceUsd}/mo`}
        </div>
        <div class="text-[11px] text-[#616c63] space-y-1">
          <div>Credits/tháng: <strong class="text-[#242924]">{plan.monthlyCredits}</strong></div>
          <div>Rollover: <strong class="text-[#242924]">{plan.rolloverPercentLabel}</strong></div>
          <div>Thành viên: {plan.maxSeats} · Kênh: {plan.maxChannels}</div>
          <div>Lưu trữ: {plan.maxStorageGb} GB</div>
        </div>
      </div>
    {/each}
  </div>

  <div class="rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-4 shadow-xs space-y-3">
    <div class="flex items-center justify-between">
      <h2 class="text-sm font-bold text-[#242924]">
        4 Module Add-ons (Starter / Pro / Business / Enterprise — P8-02 Proration)
      </h2>
      <span class="font-mono text-xs text-[#274333]">
        Prorate giữa kỳ (15/30 ngày, commerce_intelligence): {billingCurrency === 'VND'
          ? `₫${sampleAddonProration}`
          : `$${sampleAddonProration}`}
      </span>
    </div>
    <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
      {#each CANONICAL_ADDONS as addon (addon.addonCode)}
        <div class="rounded-lg border border-[#f4f0e8] bg-[#fbf9f5] p-3 flex items-center justify-between">
          <div>
            <div class="text-xs font-bold text-[#242924]">{addon.displayName}</div>
            <div class="font-mono text-[10px] text-[#616c63]">
              {addon.addonCode} · Gói hợp lệ: {addon.eligibleTiers.join(', ')}
            </div>
          </div>
          <div class="font-mono text-xs font-bold text-[#274333] text-right">
            <div>{billingCurrency === 'VND' ? `₫${addon.monthlyPriceVnd}/th` : `$${addon.monthlyPriceUsd}/mo`}</div>
            <div class="text-[10px] text-[#616c63]">
              {billingCurrency === 'VND' ? `₫${addon.annualPriceVnd}/năm` : `$${addon.annualPriceUsd}/yr`}
            </div>
          </div>
        </div>
      {/each}
    </div>
  </div>

  <div class="rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-5 shadow-xs space-y-4">
    <h2 class="text-sm font-bold text-[#242924]">
      P8-02: Cổng Phương thức Thanh toán, Vòng đời Dunning ≠ Hủy gói, Bảo toàn Credits &amp; Kinh tế Cohort
    </h2>
    <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
      <label class="block space-y-1">
        <span class="text-xs font-semibold text-[#242924]">Phương thức Thanh toán (Access Gates)</span>
        <select
          bind:value={selectedPaymentMethod}
          class="w-full rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] px-3 py-2 text-xs text-[#242924]"
        >
          {#each CANONICAL_PAYMENT_METHOD_GATES as gate (gate.methodType)}
            <option value={gate.methodType}>{gate.displayName} ({gate.methodType})</option>
          {/each}
        </select>
      </label>

      <label class="block space-y-1">
        <span class="text-xs font-semibold text-[#242924]">Trạng thái Cổng truy cập (Feature Gate)</span>
        <select
          bind:value={selectedGateOpened}
          class="w-full rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] px-3 py-2 text-xs text-[#242924]"
        >
          <option value={false}>Mặc định (chỉ mở thẻ quốc tế card)</option>
          <option value={true}>Đã cấp quyền cổng truy cập (Gate Granted)</option>
        </select>
      </label>

      <label class="block space-y-1">
        <span class="text-xs font-semibold text-[#242924]">Kịch bản Vòng đời (Trial / Dunning / Pause / Cancel)</span>
        <select
          bind:value={selectedLifecycleScenario}
          class="w-full rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] px-3 py-2 text-xs text-[#242924]"
        >
          <option value="trial_active">Dùng thử Pro 14 ngày (200 promotional credits)</option>
          <option value="trial_expired_no_payment">Hết dùng thử không thẻ → hạ về Free</option>
          <option value="dunning_retry_day_3">Dunning Ngày 3 (past_due, full quyền)</option>
          <option value="dunning_grace_day_7">Dunning Ngày 7–14 (read-only grace)</option>
          <option value="dunning_downgrade_day_14">Dunning Ngày 14 (hạ về Free, giữ nguyên dữ liệu)</option>
          <option value="pause_active">Tạm dừng gói Business/Enterprise (≤90 ngày, read-only)</option>
          <option value="cancel_scheduled_before_period_end">Hủy chủ động trước hạn (full quyền tới cuối kỳ)</option>
          <option value="cancel_phase_1_quarantine_0_30d">Hủy Giai đoạn 1: 0–30 ngày (cách ly chỉ đọc, tự khôi phục)</option>
          <option value="cancel_phase_2_soft_delete_30_90d">Hủy Giai đoạn 2: 30–90 ngày (xóa mềm, hỗ trợ khôi phục)</option>
          <option value="cancel_phase_3_hard_delete_90d_plus">Hủy Giai đoạn 3: 90+ ngày / Right to Erasure</option>
        </select>
      </label>
    </div>

    <div class="rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] p-4 space-y-2 text-xs">
      <div>
        <strong>Kiểm tra Cổng thanh toán ({pmGateVerdict.accessGateKey}):</strong>
        {pmGateVerdict.allowed ? 'MỞ CỔNG' : `ĐÓNG CỔNG (${pmGateVerdict.errorCode})`} — {pmGateVerdict.reason}
      </div>
      <div>
        <strong>Trạng thái Vòng đời ({lifecycleVerdict.retentionPhase}):</strong>
        Gói hiệu lực: <span class="font-mono">{lifecycleVerdict.effectiveTier}</span> ·
        Chỉ đọc: <span class="font-mono">{lifecycleVerdict.readOnlyMode ? 'CÓ' : 'KHÔNG'}</span> ·
        Credits đã mua được bảo toàn: <span class="font-mono font-bold text-[#274333]">{lifecycleVerdict.preservedPurchasedCredits}</span>
      </div>
      <div class="text-[#616c63]">
        <strong>So sánh Hủy gói ≠ Dunning:</strong> {lifecycleVerdict.differsFromDunningSummary}
        (Đối chiếu Dunning Ngày 14: gói={dunningComparisonVerdict.effectiveTier}, readOnly={dunningComparisonVerdict.readOnlyMode ? 'true' : 'false'}, credits mua giữ nguyên={dunningComparisonVerdict.preservedPurchasedCredits}).
      </div>
      <div>
        <strong>Bằng chứng Xuất / Khôi phục / Xóa &amp; EC-M23-002:</strong>
        {restoreEraseVerdict.allowed ? 'CHO PHÉP' : `CHẶN (${restoreEraseVerdict.errorCode})`} —
        {restoreEraseVerdict.anonymizedRetentionSummary} (TTL liên kết xuất: {restoreEraseVerdict.exportUrlTtlDays} ngày).
      </div>
      <div>
        <strong>Hạn mức Xuất báo cáo Tài chính ({selectedPlan}):</strong>
        {exportQuotaVerdict.reason} · {BIZ_007_TAX_RESPONSIBILITY_DISCLAIMER}
      </div>
      <div class="pt-2 border-t border-[#e7e2d7] font-mono text-[11px] text-[#274333]">
        <strong>Kinh tế Cohort Đo lường ({sampleCohortEconomics.cohortMonth}):</strong>
        Gross Margin={sampleCohortEconomics.grossMarginPct}% ·
        NRR={sampleCohortEconomics.netRevenueRetentionPct}% ·
        CAC=${sampleCohortEconomics.blendedCacUsd} ·
        LTV=${sampleCohortEconomics.ltvUsd} ·
        LTV:CAC={sampleCohortEconomics.ltvToCacRatio}x ·
        Payback={sampleCohortEconomics.cacPaybackMonths} tháng ·
        AI Cost/WS=${sampleCohortEconomics.aiCostPerActiveWorkspaceUsd}
      </div>
    </div>
  </div>

  <div class="rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-5 shadow-xs space-y-4">
    <h2 class="text-sm font-bold text-[#242924]">
      Trình kiểm tra Phân quyền Owner-only &amp; Quy tắc EC-M23-001
    </h2>
    <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
      <label class="block space-y-1">
        <span class="text-xs font-semibold text-[#242924]">Vai trò (RBAC)</span>
        <select
          bind:value={selectedRole}
          class="w-full rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] px-3 py-2 text-xs text-[#242924]"
        >
          <option value="owner">owner</option>
          <option value="admin">admin</option>
          <option value="manager">manager</option>
          <option value="editor">editor</option>
          <option value="viewer">viewer</option>
        </select>
      </label>

      <label class="block space-y-1">
        <span class="text-xs font-semibold text-[#242924]">Gói cước hiện tại</span>
        <select
          bind:value={selectedPlan}
          class="w-full rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] px-3 py-2 text-xs text-[#242924]"
        >
          {#each CANONICAL_PLANS as p (p.tierCode)}
            <option value={p.tierCode}>{p.displayName} ({p.tierCode})</option>
          {/each}
        </select>
      </label>

      <label class="block space-y-1">
        <span class="text-xs font-semibold text-[#242924]">Số thẻ thanh toán đã lưu</span>
        <select
          bind:value={paymentMethodCount}
          class="w-full rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] px-3 py-2 text-xs text-[#242924]"
        >
          <option value={1}>1 phương thức (duy nhất)</option>
          <option value={2}>2 phương thức</option>
        </select>
      </label>
    </div>

    <div class="rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] p-4 space-y-2 text-xs">
      <div>
        <strong>Quyền xem hóa đơn ({readPerm.permissionKey}):</strong>
        {readPerm.allowed ? 'CHO PHÉP' : 'TỪ CHỐI'} — {readPerm.reason}
      </div>
      <div>
        <strong>Quyền thay đổi gói / thẻ ({managePerm.permissionKey}):</strong>
        {managePerm.allowed ? 'CHO PHÉP' : 'TỪ CHỐI'} — {managePerm.reason}
      </div>
      <div class="pt-2 border-t border-[#e7e2d7] font-semibold {pmRemovalVerdict.allowed ? 'text-[#274333]' : 'text-[#d94a31]'}">
        Kiểm tra xóa thẻ (EC-M23-001): {pmRemovalVerdict.reason}
      </div>
    </div>
  </div>
</div>
