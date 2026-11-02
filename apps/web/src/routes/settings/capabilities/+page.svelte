<script lang="ts">
  import {
    CANONICAL_CAPABILITY_MATRIX,
    CAPABILITY_STATE_META,
    evaluateActionCapability,
    type ActionAccessVerificationInput,
    type CapabilityMatrixEntry
  } from '$lib/capability';

  let selectedIndex = $state(0);
  let targetMarket = $state('VN');
  let verificationMode = $state<'unverified' | 'fresh_post' | 'get_only' | 'stale'>('unverified');
  let killSwitchActive = $state(false);

  const nowMs = Date.parse('2026-11-02T08:00:00Z');
  const selectedEntry: CapabilityMatrixEntry = $derived(
    CANONICAL_CAPABILITY_MATRIX[selectedIndex] ?? CANONICAL_CAPABILITY_MATRIX[0]
  );

  const activeVerification: ActionAccessVerificationInput | null = $derived.by(() => {
    if (verificationMode === 'unverified') {
      return null;
    }
    return {
      platform: selectedEntry.platform,
      product: selectedEntry.platformDisplayName,
      actionKey: selectedEntry.actionKey,
      appApprovalStatus: 'approved',
      requiredScopes: selectedEntry.requiredScopes,
      grantedScopes: selectedEntry.requiredScopes,
      accountEligible: true,
      marketEligibility: selectedEntry.supportedMarkets,
      probeEndpoint: '/v2/probe/verify',
      probeMethod: verificationMode === 'get_only' ? 'GET' : 'POST',
      probeStatus: 'passed',
      checkedAtMs:
        verificationMode === 'stale' ? nowMs - 15 * 60 * 1000 : nowMs - 2 * 60 * 1000,
      validUntilMs: nowMs + 24 * 60 * 60 * 1000
    };
  });

  const evaluation = $derived(
    evaluateActionCapability(selectedEntry, activeVerification, {
      nowMs,
      targetMarket,
      killSwitchActive,
      killSwitchReason: 'Công tắc ngắt khẩn cấp (Kill Switch) đang kích hoạt từ Admin Nội bộ.'
    })
  );
</script>

<svelte:head>
  <title>Ma trận Năng lực Nền tảng (W130) · Creativanta</title>
</svelte:head>

<div class="mx-auto max-w-6xl px-4 py-8">
  <div class="flex flex-wrap items-start justify-between gap-4 border-b border-[#e8e5dc] pb-6">
    <div>
      <p class="text-xs font-bold uppercase tracking-[0.14em] text-[#b44833]">
        M22 · W130 · ACCOUNT & ACTION VERIFICATION REGISTRY
      </p>
      <h1 class="mt-2 text-3xl font-bold text-[#242924]">
        Ma trận Năng lực Nền tảng &amp; Ghi chú Chính sách
      </h1>
      <p class="mt-2 max-w-3xl text-sm text-[#5d635b]">
        Mọi tác vụ kết nối ngoài đều mặc định ở trạng thái <strong>Thủ công (manual)</strong> hoặc
        <strong>Không hỗ trợ (unsupported)</strong> cho đến khi hoàn tất hồ sơ
        <code>ActionAccessVerification</code> trong vòng 10 phút. Tuyến chưa xác minh không bao giờ được tự động thực thi.
      </p>
    </div>
    <a
      href="/settings/connections"
      class="rounded-xl border border-[#d6d1c4] bg-white px-4 py-2.5 text-xs font-semibold text-[#242924] hover:bg-[#f6f4ee]"
    >
      Quản lý Tài khoản Kết nối &amp; Điểm Sức khỏe (W117) →
    </a>
  </div>

  <div class="mt-6 grid gap-3 sm:grid-cols-5">
    {#each Object.entries(CAPABILITY_STATE_META) as [stateKey, meta] (stateKey)}
      <div class="rounded-xl border border-[#e8e5dc] bg-[#fffefa] p-3.5">
        <span class="inline-block rounded-full border px-2.5 py-0.5 text-xs font-semibold {meta.badgeClass}">
          {meta.labelVi}
        </span>
        <p class="mt-2 text-xs leading-5 text-[#5d635b]">{meta.descriptionVi}</p>
      </div>
    {/each}
  </div>

  <div class="mt-8 grid gap-6 lg:grid-cols-3">
    <div class="lg:col-span-2 rounded-2xl border border-[#e8e5dc] bg-white p-6">
      <h2 class="text-base font-bold text-[#242924]">Danh mục Tác vụ theo Nền tảng</h2>
      <div class="mt-4 divide-y divide-[#eeeae0]">
        {#each CANONICAL_CAPABILITY_MATRIX as item, idx (item.platform + ':' + item.actionKey)}
          <button
            type="button"
            onclick={() => (selectedIndex = idx)}
            class="flex w-full items-center justify-between gap-4 py-3.5 text-left transition hover:bg-[#faf8f2] px-3 rounded-lg {selectedIndex === idx ? 'bg-[#f5f2e8]' : ''}"
          >
            <div>
              <div class="text-xs font-bold uppercase tracking-wider text-[#7d837b]">
                {item.platformDisplayName} · <code>{item.actionKey}</code>
              </div>
              <div class="mt-0.5 text-sm font-semibold text-[#242924]">{item.displayName}</div>
            </div>
            <span
              class="rounded-full border px-3 py-1 text-xs font-semibold {CAPABILITY_STATE_META[item.defaultState].badgeClass}"
            >
              Mặc định: {CAPABILITY_STATE_META[item.defaultState].labelVi}
            </span>
          </button>
        {/each}
      </div>
    </div>

    <div class="rounded-2xl border border-[#e8e5dc] bg-[#fffefa] p-6">
      <h2 class="text-base font-bold text-[#242924]">Bộ kiểm tra Cổng Thực thi (P0-07 Gate)</h2>
      <p class="mt-1 text-xs text-[#6c726a]">
        Đang chọn: <strong>{selectedEntry.displayName}</strong> (<code>{selectedEntry.platform}/{selectedEntry.actionKey}</code>)
      </p>

      <div class="mt-4 space-y-3 text-xs">
        <label class="block">
          <span class="font-semibold text-[#242924]">Trạng thái Hồ sơ Xác minh</span>
          <select
            bind:value={verificationMode}
            class="mt-1 w-full rounded-lg border border-[#d6d1c4] bg-white px-3 py-2 text-xs"
          >
            <option value="unverified">Chưa xác minh (Unverified)</option>
            <option value="fresh_post">Đã xác minh POST Probe (&lt;10 phút)</option>
            <option value="get_only">Chỉ kiểm tra GET Probe (Read-only probe)</option>
            <option value="stale">Ảnh chụp quá hạn 15 phút (Stale &gt;10m)</option>
          </select>
        </label>

        <label class="block">
          <span class="font-semibold text-[#242924]">Thị trường mục tiêu</span>
          <select
            bind:value={targetMarket}
            class="mt-1 w-full rounded-lg border border-[#d6d1c4] bg-white px-3 py-2 text-xs"
          >
            <option value="VN">Việt Nam (VN)</option>
            <option value="SG">Singapore (SG)</option>
            <option value="JP">Nhật Bản (JP - ngoài phạm vi)</option>
          </select>
        </label>

        <label class="flex items-center gap-2 pt-1">
          <input type="checkbox" bind:checked={killSwitchActive} class="rounded border-[#d6d1c4]" />
          <span class="font-semibold text-[#b44833]">Kích hoạt Kill Switch từ Admin Nội bộ</span>
        </label>
      </div>

      <div class="mt-5 rounded-xl border border-[#e8e5dc] bg-white p-4">
        <div class="flex items-center justify-between">
          <span class="text-xs font-semibold text-[#5d635b]">Kết quả đánh giá:</span>
          <span
            class="rounded-full border px-2.5 py-0.5 text-xs font-semibold {CAPABILITY_STATE_META[evaluation.state].badgeClass}"
          >
            {CAPABILITY_STATE_META[evaluation.state].labelVi}
          </span>
        </div>
        <p class="mt-2 text-xs font-semibold {evaluation.executable ? 'text-emerald-700' : 'text-[#b44833]'}">
          {evaluation.executable
            ? 'Cho phép thực thi tự động qua API'
            : 'Chặn thực thi tự động — bắt buộc dùng phương án dự phòng'}
        </p>
        <p class="mt-1.5 text-xs leading-5 text-[#5d635b]">{evaluation.reason}</p>

        <div class="mt-4 border-t border-[#eeeae0] pt-3 text-xs">
          <div class="font-bold text-[#242924]">Ghi chú chính sách (Policy Note):</div>
          <p class="mt-1 leading-5 text-[#5d635b]">{evaluation.policyNote.summary}</p>
          <div class="mt-3 font-bold text-[#242924]">
            Phương án dự phòng ({evaluation.fallbackPath.fallbackType}):
          </div>
          <p class="mt-1 leading-5 text-[#5d635b]">{evaluation.fallbackPath.instructions}</p>
        </div>
      </div>
    </div>
  </div>
</div>
