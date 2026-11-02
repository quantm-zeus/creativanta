<script lang="ts">
  import type { WorkspaceRole } from '$lib/auth';
  import UnavailableNotice from '$lib/components/UnavailableNotice.svelte';
  import {
    evaluateAuthorizedP1Import,
    filterRepairCardsForRole,
    resolveUnderlyingRepairGap,
    type AuthorizedImportInput,
    type LabeledProfitAndRepairProjection
  } from '$lib/p1_first_value';

  let selectedRole = $state<WorkspaceRole>('owner');
  const initialBatch: AuthorizedImportInput = {
    workspaceId: 'ws-p1-commerce',
    userId: 'user-owner-p1',
    role: 'owner',
    connectedAccountsCount: 0,
    productsCount: 12,
    ordersCount: 84,
    costsCount: 6,
    settlementsCount: 1,
    grossRevenueVnd: '24500000',
    knownCostsVnd: '9200000',
    isDemoFixture: false,
    repairGaps: [
      {
        gapId: 'gap-missing-cogs-sku-a1',
        gapKind: 'missing_cogs',
        title: 'Thiếu giá vốn (COGS) cho 2 SKU vừa nhập CSV',
        reason: '2 SKU chưa khai báo giá vốn trong Sổ cái, lợi nhuận ròng đang tạm tính.',
        repairCtaLabel: 'Bổ sung giá vốn (COGS)',
        repairRoute: '/kinh-doanh',
        affectedAmountVnd: '2800000',
        resolved: false
      },
      {
        gapId: 'gap-missing-evidence-settle-01',
        gapKind: 'missing_evidence',
        title: 'Thiếu chứng từ phí vận chuyển kỳ đối soát #01',
        reason: 'Khoản khấu trừ phí vận chuyển chưa đính kèm chứng từ đối soát.',
        repairCtaLabel: 'Đính kèm chứng từ đối soát',
        repairRoute: '/kinh-doanh',
        affectedAmountVnd: '650000',
        resolved: false
      }
    ]
  };

  let projection = $state<LabeledProfitAndRepairProjection>(
    evaluateAuthorizedP1Import(initialBatch)
  );
  let visibleRepairCards = $derived(
    filterRepairCardsForRole(projection.activeRepairCards, selectedRole)
  );

  function handleResolveGap(gapId: string, addedCostVnd: string) {
    if (selectedRole === 'viewer') return;
    projection = resolveUnderlyingRepairGap(projection, gapId, addedCostVnd, selectedRole);
  }
</script>

<svelte:head><title>Kinh doanh — Creativanta</title></svelte:head>

<section class="space-y-6" aria-labelledby="commerce-title">
  <div class="flex flex-col gap-3">
    <p class="text-xs font-bold uppercase tracking-[0.15em] text-[#ad6047]">
      COMMERCE &amp; OPERATING LEDGER · P1-05 FIRST-VALUE LOOP
    </p>
    <h1 id="commerce-title" class="text-3xl font-bold tracking-tight text-[#242924]">Kinh doanh</h1>
    <p class="max-w-2xl text-sm leading-7 text-[#7d837b]">
      Theo dõi sản phẩm, đơn hàng, đối soát chứng từ và biên lợi nhuận ròng từ dữ liệu nhập CSV được ủy quyền ngay cả khi chưa kết nối API sàn (0 connected accounts).
    </p>
  </div>

  <UnavailableNotice
    title="Dịch vụ Kinh doanh &amp; Sổ cái Vận hành (P1-01..P1-05 Slice Ready — Live Connector Optional)"
    domain="Kinh doanh &amp; đối soát lợi nhuận (M13 / M19)"
    requires="Authorized CSV/File Import hoặc Live Connector (Phase P5)"
    message="Trong Phase P1, bạn có thể nhập dữ liệu sản phẩm, đơn hàng, chi phí và kỳ đối soát hợp lệ mà không cần kết nối tài khoản API sàn (Acceptance Target #1: No connector required for authorized import). Tuyệt đối không trộn dữ liệu demo vào doanh thu hoặc lợi nhuận khách hàng."
  />

  <!-- P1-05 Import-to-Profit & Data Repair Loop -->
  <div class="rounded-2xl border border-[#e8e5dc] bg-[#fffefa] p-6 shadow-sm space-y-5">
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 border-b border-[#f4f0e8] pb-4">
      <div>
        <div class="flex items-center gap-2">
          <span class="rounded bg-[#274333] px-2 py-0.5 text-[11px] font-bold text-[#ffffff]">
            P1-05 First-Value Loop
          </span>
          <span class="rounded bg-[#eaf4ed] px-2 py-0.5 font-mono text-[11px] font-semibold text-[#274333]">
            source_class: {projection.sourceClass}
          </span>
          <span class="rounded bg-[#fef9c3] px-2 py-0.5 font-mono text-[11px] font-semibold text-[#854d0e]">
            confidence_band: {projection.confidenceBand}
          </span>
        </div>
        <h2 class="mt-2 text-base font-bold text-[#242924]">
          Báo cáo Lợi nhuận Dữ liệu Nhập &amp; Hàng đợi Bổ sung Chứng từ (M19)
        </h2>
        <p class="text-xs text-[#616c63]">
          Tài khoản kết nối: <strong>{projection.connectedAccountsCount}</strong> (Không bắt buộc connector trong P1) · Thành phần chưa xác minh: <strong>{projection.unknownRequiredComponentsCount}</strong>
        </p>
      </div>

      <label class="flex items-center gap-2 text-xs">
        <span class="font-semibold text-[#242924]">Vai trò kiểm tra RBAC:</span>
        <select
          bind:value={selectedRole}
          class="rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] px-2.5 py-1.5 text-xs text-[#242924]"
        >
          <option value="owner">owner (Full Finance)</option>
          <option value="manager">manager</option>
          <option value="viewer">viewer (Ẩn số tiền nhạy cảm)</option>
        </select>
      </label>
    </div>

    {#if selectedRole !== 'viewer'}
      <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
        <div class="rounded-xl border border-[#e8e5dc] bg-[#fbf9f5] p-4">
          <div class="text-xs font-semibold text-[#616c63]">Doanh thu gộp (Gross Revenue)</div>
          <div class="mt-1 font-mono text-xl font-bold text-[#242924]">
            {Number(projection.grossRevenueVnd).toLocaleString('vi-VN')} ₫
          </div>
          <div class="mt-1 text-[11px] text-[#616c63]">
            Từ {initialBatch.ordersCount} đơn hàng &amp; {initialBatch.productsCount} sản phẩm nhập hợp lệ
          </div>
        </div>

        <div class="rounded-xl border border-[#e8e5dc] bg-[#fbf9f5] p-4">
          <div class="text-xs font-semibold text-[#616c63]">Chi phí đã xác minh (Known Costs)</div>
          <div class="mt-1 font-mono text-xl font-bold text-[#242924]">
            {Number(projection.knownCostsVnd).toLocaleString('vi-VN')} ₫
          </div>
          <div class="mt-1 text-[11px] text-[#616c63]">
            {initialBatch.costsCount} khoản chi phí &amp; {initialBatch.settlementsCount} kỳ đối soát
          </div>
        </div>

        <div class="rounded-xl border border-[#274333]/30 bg-[#eaf4ed]/40 p-4">
          <div class="text-xs font-semibold text-[#274333]">Lợi nhuận ròng tạm tính (Net Profit)</div>
          <div class="mt-1 font-mono text-xl font-bold text-[#274333]">
            {Number(projection.netProfitVnd).toLocaleString('vi-VN')} ₫
          </div>
          <div class="mt-1 text-[11px] text-[#274333]">
            {projection.isIncomplete
              ? `Độ tin cậy THẤP — Còn ${projection.unknownRequiredComponentsCount} khoản thiếu chứng từ/giá vốn`
              : 'Đã hoàn tất bổ sung chứng từ & giá vốn (Độ tin cậy TRUNG BÌNH)'}
          </div>
        </div>
      </div>
    {:else}
      <div class="rounded-xl border border-[#e8e5dc] bg-[#fbf9f5] p-4 text-xs text-[#616c63]">
        Vai trò <strong>viewer</strong> không có quyền <code>finance:transactions:read</code>: ẩn toàn bộ số tiền doanh thu, giá vốn và giá trị chênh lệch nhạy cảm.
      </div>
    {/if}

    <div class="space-y-3">
      <h3 class="text-xs font-bold uppercase tracking-wider text-[#274333]">
        Danh sách cần bổ sung dữ liệu &amp; chứng từ ({visibleRepairCards.length} mục đang mở)
      </h3>

      {#if visibleRepairCards.length === 0}
        <div class="rounded-xl border border-[#274333]/20 bg-[#eaf4ed]/50 p-4 text-xs font-medium text-[#274333]">
          {selectedRole === 'viewer'
            ? 'Vai trò viewer không hiển thị thẻ cảnh báo tài chính nhạy cảm.'
            : '✓ Tất cả lỗ hổng giá vốn và chứng từ đối soát đã được xử lý trong Sổ cái. Thẻ cảnh báo trên Trang chủ (M01) đã tự động gỡ bỏ.'}
        </div>
      {:else}
        <div class="grid grid-cols-1 gap-3">
          {#each visibleRepairCards as card (card.gapId)}
            <div class="rounded-xl border border-[#854d0e]/30 bg-[#fef9c3]/40 p-4 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
              <div class="space-y-1">
                <div class="flex items-center gap-2">
                  <span class="rounded bg-[#854d0e] px-2 py-0.5 font-mono text-[10px] font-bold text-[#ffffff]">
                    {card.gapKind}
                  </span>
                  <span class="text-xs font-bold text-[#242924]">{card.title}</span>
                </div>
                <p class="text-xs text-[#616c63]">{card.reason}</p>
                <p class="font-mono text-[11px] font-semibold text-[#854d0e]">
                  Giá trị ảnh hưởng: {Number(card.affectedAmountVnd).toLocaleString('vi-VN')} ₫
                </p>
              </div>

              {#if selectedRole !== 'viewer'}
                <button
                  type="button"
                  onclick={() =>
                    handleResolveGap(
                      card.gapId,
                      card.gapKind === 'missing_cogs' ? '2800000' : '0'
                    )}
                  class="shrink-0 rounded-lg bg-[#274333] px-3.5 py-2 text-xs font-semibold text-[#ffffff] hover:bg-[#1f3629] transition-colors"
                >
                  {card.repairCtaLabel} (Hoàn tất gốc)
                </button>
              {/if}
            </div>
          {/each}
        </div>
      {/if}
    </div>
  </div>
</section>
