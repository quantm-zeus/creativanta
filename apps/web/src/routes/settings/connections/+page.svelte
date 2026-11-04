<script lang="ts">
  import type { WorkspaceRole } from '$lib/auth';
  import {
    computeCompositeHealthScore,
    evaluateConnectorMutationAccess,
    validateExplicitScopes
  } from '$lib/capability';

  let activeRole = $state<WorkspaceRole>('admin');
  let isImpersonation = $state(false);
  let availabilityPct = $state(74);
  let errorRatePct = $state(7);
  let latencyP95Ms = $state(1150);
  let rateLimitRemainingPct = $state(42);
  let scopeInput = $state('video.publish, video.upload, user.info.basic');

  // P8-03 PRD §36B Proactive Coaching Input Signals
  let shopResponseRateNumerator = $state(82);
  let shopResponseRateDenom = $state(100);
  let listingQualityNumerator = $state(74);
  let listingQualityDenom = $state(100);
  let delayedFulfillmentCount = $state(3);
  let engagementDropPct = $state(26);
  let connectorAuthExpiresInDays = $state(2);

  const healthSummary = $derived(
    computeCompositeHealthScore({
      availabilityPct,
      errorRatePct,
      latencyP95Ms,
      rateLimitRemainingPct,
      shopResponseRateNumerator,
      shopResponseRateDenom,
      listingQualityNumerator,
      listingQualityDenom,
      delayedFulfillmentCount,
      engagementDropPct,
      connectorAuthExpiresInDays
    })
  );

  const parsedScopes = $derived(
    scopeInput
      .split(',')
      .map((s) => s.trim())
      .filter(Boolean)
  );
  const scopeValidation = $derived(validateExplicitScopes(parsedScopes));
  const disconnectAccess = $derived(
    evaluateConnectorMutationAccess(activeRole, 'disconnect', isImpersonation)
  );
</script>

<svelte:head>
  <title>Tài khoản Kết nối &amp; Điểm Sức khỏe (W117) · Creativanta</title>
</svelte:head>

<div class="mx-auto max-w-6xl px-4 py-8">
  <div class="flex flex-wrap items-start justify-between gap-4 border-b border-[#e8e5dc] pb-6">
    <div>
      <p class="text-xs font-bold uppercase tracking-[0.14em] text-[#b44833]">
        M22 · W117 · CONNECTED ACCOUNTS &amp; COMPOSITE HEALTH SCORE
      </p>
      <h1 class="mt-2 text-3xl font-bold text-[#242924]">
        Tài khoản Kết nối &amp; Giám sát Sức khỏe Nền tảng
      </h1>
      <p class="mt-2 max-w-3xl text-sm text-[#5d635b]">
        Điểm sức khỏe tổng hợp (0–100) tính theo tỷ trọng 40% Độ sẵn sàng, 25% Tỷ lệ lỗi, 20% Độ trễ P95 và 15% Hạn mức Rate Limit. Token OAuth được mã hóa AES-256-GCM và tuyệt đối không trả về giao diện.
      </p>
    </div>
    <a
      href="/settings/capabilities"
      class="rounded-xl border border-[#d6d1c4] bg-white px-4 py-2.5 text-xs font-semibold text-[#242924] hover:bg-[#f6f4ee]"
    >
      ← Xem Ma trận Năng lực Nền tảng (W130)
    </a>
  </div>

  {#if healthSummary.proactiveCoachingAlert}
    <div class="mt-6 rounded-2xl border border-amber-300 bg-amber-50 p-5">
      <div class="flex items-center justify-between">
        <h2 class="text-sm font-bold text-amber-900">
          Cảnh báo Huấn luyện Chủ động (Điểm sức khỏe {healthSummary.overallScore}/100 &lt; 80)
        </h2>
        <span class="rounded-full bg-amber-200 px-3 py-0.5 text-xs font-bold text-amber-900">
          {healthSummary.statusBand.toUpperCase()}
        </span>
      </div>
      <ul class="mt-2 list-disc pl-5 text-xs leading-6 text-amber-900">
        {#each healthSummary.recommendedActions as action (action)}
          <li>{action}</li>
        {/each}
      </ul>
    </div>
  {/if}

  <div class="mt-6 grid gap-6 lg:grid-cols-2">
    <div class="rounded-2xl border border-[#e8e5dc] bg-white p-6">
      <h2 class="text-base font-bold text-[#242924]">Bộ tính Điểm Sức khỏe (40/25/20/15)</h2>
      <div class="mt-4 grid grid-cols-2 gap-4 text-xs">
        <label class="block">
          <span class="font-semibold">Độ sẵn sàng API (%): {availabilityPct}%</span>
          <input type="range" min="0" max="100" bind:value={availabilityPct} class="mt-1 w-full" />
        </label>
        <label class="block">
          <span class="font-semibold">Tỷ lệ lỗi (%): {errorRatePct}%</span>
          <input type="range" min="0" max="20" bind:value={errorRatePct} class="mt-1 w-full" />
        </label>
        <label class="block">
          <span class="font-semibold">Độ trễ P95 (ms): {latencyP95Ms}ms</span>
          <input type="range" min="100" max="3500" step="50" bind:value={latencyP95Ms} class="mt-1 w-full" />
        </label>
        <label class="block">
          <span class="font-semibold">Hạn mức Rate Limit còn lại (%): {rateLimitRemainingPct}%</span>
          <input type="range" min="0" max="100" bind:value={rateLimitRemainingPct} class="mt-1 w-full" />
        </label>
      </div>

      <div class="mt-5 grid grid-cols-4 gap-2 text-center text-xs">
        <div class="rounded-xl border border-[#eeeae0] p-3">
          <div class="text-[#7d837b]">Availability (40%)</div>
          <div class="mt-1 text-lg font-bold">{healthSummary.availabilityScore}</div>
        </div>
        <div class="rounded-xl border border-[#eeeae0] p-3">
          <div class="text-[#7d837b]">Error Rate (25%)</div>
          <div class="mt-1 text-lg font-bold">{healthSummary.errorRateScore}</div>
        </div>
        <div class="rounded-xl border border-[#eeeae0] p-3">
          <div class="text-[#7d837b]">Latency (20%)</div>
          <div class="mt-1 text-lg font-bold">{healthSummary.latencyScore}</div>
        </div>
        <div class="rounded-xl border border-[#eeeae0] p-3">
          <div class="text-[#7d837b]">Rate Limit (15%)</div>
          <div class="mt-1 text-lg font-bold">{healthSummary.rateLimitScore}</div>
        </div>
      </div>
    </div>

    <div class="rounded-2xl border border-[#e8e5dc] bg-[#fffefa] p-6">
      <h2 class="text-base font-bold text-[#242924]">Kiểm soát Scope &amp; Chế độ Impersonation Chỉ đọc</h2>
      <div class="mt-4 space-y-3 text-xs">
        <label class="block">
          <span class="font-semibold">Danh sách OAuth Scopes (cấm ký tự đại diện <code>*</code>)</span>
          <input
            type="text"
            bind:value={scopeInput}
            class="mt-1 w-full rounded-lg border border-[#d6d1c4] bg-white px-3 py-2"
          />
        </label>
        <p class={scopeValidation.valid ? 'text-emerald-700 font-semibold' : 'text-[#b44833] font-semibold'}>
          {scopeValidation.valid
            ? 'Danh sách Scope tường minh hợp lệ.'
            : `Từ chối Scope chứa ký tự đại diện không hợp lệ: ${scopeValidation.invalidScope}`}
        </p>

        <div class="grid grid-cols-2 gap-3 pt-2">
          <label class="block">
            <span class="font-semibold">Vai trò Workspace</span>
            <select
              bind:value={activeRole}
              class="mt-1 w-full rounded-lg border border-[#d6d1c4] bg-white px-3 py-2"
            >
              <option value="owner">Owner</option>
              <option value="admin">Admin</option>
              <option value="manager">Manager</option>
              <option value="editor">Editor</option>
              <option value="viewer">Viewer</option>
            </select>
          </label>
          <label class="flex items-center gap-2 pt-5">
            <input type="checkbox" bind:checked={isImpersonation} />
            <span class="font-semibold text-[#b44833]">Đang trong phiên Admin Impersonation (Read-Only)</span>
          </label>
        </div>

        <div class="mt-3 rounded-xl border border-[#e8e5dc] bg-white p-3.5">
          <div class="font-bold text-[#242924]">Quyền Ngắt kết nối (<code>{disconnectAccess.permissionKey}</code>):</div>
          <p class="mt-1 {disconnectAccess.allowed ? 'text-emerald-700' : 'text-[#b44833]'} font-semibold">
            {disconnectAccess.reason}
          </p>
        </div>
      </div>
    </div>
  </div>

  {#if healthSummary.proactiveCoachingCards.length > 0}
    <div class="mt-8 rounded-2xl border border-[#e8e5dc] bg-white p-6">
      <div class="flex items-center justify-between border-b border-[#eeeae0] pb-4">
        <div>
          <h2 class="text-base font-bold text-[#242924]">
            Huấn luyện Năng lực Chủ động (PRD §36B Proactive Coaching)
          </h2>
          <p class="mt-1 text-xs text-[#5d635b]">
            Hệ thống phát hiện {healthSummary.proactiveCoachingCards.length} cơ hội cải thiện năng lực kinh doanh &amp; vận hành.
            Các thẻ gợi ý này hoàn toàn độc lập với điểm kỹ thuật 40/25/20/15.
          </p>
        </div>
        <span class="rounded-full bg-indigo-50 border border-indigo-200 px-3 py-1 text-xs font-bold text-indigo-700">
          {healthSummary.proactiveCoachingCards.length} THẺ HUẤN LUYỆN
        </span>
      </div>

      <div class="mt-4 grid gap-4 md:grid-cols-2 lg:grid-cols-3">
        {#each healthSummary.proactiveCoachingCards as card (card.id)}
          <div class="rounded-xl border border-[#e8e5dc] bg-[#faf8f2] p-4 flex flex-col justify-between">
            <div>
              <div class="flex items-center justify-between">
                <span class="text-[10px] font-mono uppercase tracking-wider text-slate-500">{card.rule}</span>
                <span class="text-[10px] font-bold uppercase px-2 py-0.5 rounded {card.severity === 'high' ? 'bg-rose-100 text-rose-800' : 'bg-amber-100 text-amber-800'}">
                  {card.severity}
                </span>
              </div>
              <h3 class="mt-2 text-sm font-bold text-[#242924]">{card.title}</h3>
              <p class="mt-1 text-xs leading-5 text-[#5d635b]">{card.summary}</p>
            </div>
            <div class="mt-4 pt-3 border-t border-[#eeeae0] flex justify-end">
              <a
                href={card.actionCta}
                class="rounded-lg bg-[#242924] px-3 py-1.5 text-xs font-semibold text-white transition hover:bg-[#3f463f]"
              >
                Khắc phục ngay ({card.actionCta}) →
              </a>
            </div>
          </div>
        {/each}
      </div>
    </div>
  {/if}
</div>
