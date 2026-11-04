<script lang="ts">
  import {
    buildShareLinks,
    calculateReferralTier,
    CANONICAL_GROWTH_PROMPTS,
    CANONICAL_REFERRAL_TIERS,
    evaluatePaymentQualificationGate,
    evaluateRefundReversalGate,
    evaluateSelfReferralGate,
    formatFunnelMetrics,
    type ReferralRecord,
    type ReferralStatus
  } from '$lib/referral';

  // Demo / Initial State for Screen W126 (Settings: Referral Center)
  let referralCode = $state<string>('QUANNG2026');
  let qualifiedCount = $state<number>(12);
  let clicksCount = $state<number>(45);
  let signupsCount = $state<number>(12);
  let paidCount = $state<number>(3);
  let copyFeedback = $state<string>('');
  let promoCodeInput = $state<string>('');
  let promoStatusMsg = $state<string>('');
  let promoStatusType = $state<'success' | 'error' | ''>('');

  // Interactive simulation states for testing acceptance criteria in UI
  let testPaymentStatus = $state<'paid' | 'pending' | 'unpaid'>('pending');
  let testSelfReferralUser = $state<boolean>(false);
  let testRefundTriggered = $state<boolean>(false);

  let tierProgress = $derived(calculateReferralTier(qualifiedCount));
  let shareLinks = $derived(buildShareLinks(referralCode));
  let funnel = $derived(
    formatFunnelMetrics(clicksCount, signupsCount, paidCount, '150.000000', '50.000000')
  );

  let paymentGateVerdict = $derived(
    evaluatePaymentQualificationGate(testPaymentStatus, 'pending')
  );
  let selfReferralVerdict = $derived(
    evaluateSelfReferralGate({
      referrerWorkspaceId: 'ws-self',
      refereeWorkspaceId: testSelfReferralUser ? 'ws-self' : 'ws-other',
      referrerUserId: 'usr-1',
      refereeUserId: testSelfReferralUser ? 'usr-1' : 'usr-2'
    })
  );
  let refundVerdict = $derived(
    evaluateRefundReversalGate(testRefundTriggered ? 'revoked' : 'rewarded')
  );

  let historyItems = $state<
    Array<{
      id: string;
      name: string;
      plan: string;
      status: ReferralStatus;
      paymentStatus: string;
      credits: string;
      timeAgo: string;
    }>
  >([
    {
      id: 'ref-1',
      name: 'Nguyễn Văn A',
      plan: 'Gói Pro',
      status: 'rewarded',
      paymentStatus: 'paid',
      credits: '+75 cr',
      timeAgo: '5 ngày trước'
    },
    {
      id: 'ref-2',
      name: 'Trần Thị B',
      plan: 'Gói Pro',
      status: 'rewarded',
      paymentStatus: 'paid',
      credits: '+75 cr',
      timeAgo: '8 ngày trước'
    },
    {
      id: 'ref-3',
      name: 'Lê Hoàng C',
      plan: 'Gói Starter',
      status: 'pending',
      paymentStatus: 'pending',
      credits: 'Chờ xử lý',
      timeAgo: '12 ngày trước'
    },
    {
      id: 'ref-4',
      name: 'Phạm Minh D',
      plan: 'Miễn phí',
      status: 'pending',
      paymentStatus: 'unpaid',
      credits: 'Chờ nâng cấp',
      timeAgo: '15 ngày trước'
    }
  ]);

  function handleCopy() {
    if (typeof navigator !== 'undefined' && navigator.clipboard) {
      navigator.clipboard.writeText(shareLinks.shareUrl);
      copyFeedback = 'Đã sao chép liên kết vào bộ nhớ tạm!';
      setTimeout(() => {
        copyFeedback = '';
      }, 3000);
    }
  }

  function handleRedeemPromo() {
    const code = promoCodeInput.trim().toUpperCase();
    if (!code) {
      promoStatusMsg = 'Vui lòng nhập mã khuyến mãi';
      promoStatusType = 'error';
      return;
    }
    if (code === 'WELCOME2026' || code === 'PROBOOST100') {
      promoStatusMsg = `Mã ${code} đã kích hoạt thành công! +50 credits thưởng.`;
      promoStatusType = 'success';
      promoCodeInput = '';
    } else {
      promoStatusMsg = `Mã ${code} không hợp lệ hoặc đã hết hạn.`;
      promoStatusType = 'error';
    }
  }
</script>

<svelte:head>
  <title>Referral Center — Giới thiệu bạn bè | Creativanta</title>
</svelte:head>

<main class="referral-page mx-auto max-w-5xl px-4 py-8 text-slate-100">
  <!-- Header -->
  <header class="mb-8 border-b border-slate-800 pb-4">
    <div class="flex items-center justify-between">
      <div>
        <div class="flex items-center gap-2 text-sm text-cyan-400">
          <a href="/settings" class="hover:underline">Cài đặt</a>
          <span>/</span>
          <span>Chương trình Giới thiệu</span>
        </div>
        <h1 class="mt-1 text-2xl font-bold tracking-tight text-white flex items-center gap-2">
          <span>🎁</span> Giới thiệu bạn bè & Nhận hoa hồng
        </h1>
        <p class="mt-1 text-sm text-slate-400">
          Chia sẻ Creativanta — Cả hai cùng nhận thưởng credits và thăng hạng nhận hoa hồng trọn đời.
        </p>
      </div>
      <div class="text-right">
        <span class="inline-flex items-center gap-1.5 rounded-full bg-cyan-950/80 px-3 py-1 text-xs font-semibold text-cyan-300 border border-cyan-800/60">
          Hạng hiện tại: {CANONICAL_REFERRAL_TIERS[tierProgress.currentTier].title}
        </span>
      </div>
    </div>
  </header>

  <div class="grid grid-cols-1 gap-6 lg:grid-cols-3">
    <!-- Left 2 Cols: Link, Funnel, Tiers, History -->
    <div class="space-y-6 lg:col-span-2">
      <!-- 1. Shareable Referral Link Card -->
      <section class="rounded-xl border border-slate-800 bg-slate-900/90 p-5 shadow-lg" aria-label="Liên kết giới thiệu">
        <h2 class="text-base font-semibold text-white flex items-center justify-between">
          <span>🔗 Liên kết giới thiệu của bạn</span>
          <span class="text-xs text-slate-400">Mã: <code class="text-cyan-400 font-mono">{referralCode}</code></span>
        </h2>
        <div class="mt-3 flex items-center gap-2">
          <input
            type="text"
            readonly
            value={shareLinks.shareUrl}
            class="w-full rounded-lg border border-slate-700 bg-slate-950 px-3 py-2 font-mono text-sm text-cyan-300 focus:outline-none focus:ring-1 focus:ring-cyan-500"
            aria-label="Referral link"
          />
          <button
            type="button"
            onclick={handleCopy}
            class="shrink-0 rounded-lg bg-cyan-600 px-4 py-2 text-sm font-semibold text-white transition hover:bg-cyan-500 active:scale-95"
          >
            📋 Sao chép
          </button>
        </div>
        {#if copyFeedback}
          <p class="mt-2 text-xs font-medium text-emerald-400 animate-pulse">{copyFeedback}</p>
        {/if}

        <!-- Social Share Channels -->
        <div class="mt-4 pt-3 border-t border-slate-800 flex flex-wrap items-center gap-2">
          <span class="text-xs text-slate-400 mr-2">Chia sẻ nhanh:</span>
          <a
            href={shareLinks.zaloUrl}
            target="_blank"
            rel="noopener noreferrer"
            class="inline-flex items-center gap-1 rounded bg-blue-900/60 hover:bg-blue-800/80 px-2.5 py-1 text-xs text-blue-200 border border-blue-700/50"
            aria-label="Chia sẻ qua Zalo"
          >
            📱 Zalo
          </a>
          <a
            href={shareLinks.facebookUrl}
            target="_blank"
            rel="noopener noreferrer"
            class="inline-flex items-center gap-1 rounded bg-blue-950/80 hover:bg-blue-900 px-2.5 py-1 text-xs text-blue-300 border border-blue-800/60"
            aria-label="Chia sẻ qua Facebook"
          >
            📘 Facebook
          </a>
          <a
            href={shareLinks.twitterUrl}
            target="_blank"
            rel="noopener noreferrer"
            class="inline-flex items-center gap-1 rounded bg-sky-950/80 hover:bg-sky-900 px-2.5 py-1 text-xs text-sky-300 border border-sky-800/60"
            aria-label="Chia sẻ qua Twitter / X"
          >
            🐦 X / Twitter
          </a>
          <a
            href={shareLinks.telegramUrl}
            target="_blank"
            rel="noopener noreferrer"
            class="inline-flex items-center gap-1 rounded bg-teal-950/80 hover:bg-teal-900 px-2.5 py-1 text-xs text-teal-300 border border-teal-800/60"
            aria-label="Chia sẻ qua Telegram"
          >
            ✈️ Telegram
          </a>
        </div>
      </section>

      <!-- 2. Conversion Funnel Card -->
      <section class="rounded-xl border border-slate-800 bg-slate-900/90 p-5 shadow-lg" aria-label="Phễu chuyển đổi tăng trưởng">
        <h2 class="text-base font-semibold text-white">📊 Phễu chuyển đổi (Growth Funnel)</h2>
        <div class="mt-4 grid grid-cols-3 gap-3 text-center">
          <div class="rounded-lg bg-slate-950 p-3 border border-slate-800">
            <div class="text-xs text-slate-400">👆 Lượt click</div>
            <div class="mt-1 text-xl font-bold text-white">{funnel.clicks}</div>
          </div>
          <div class="rounded-lg bg-slate-950 p-3 border border-slate-800">
            <div class="text-xs text-slate-400">📝 Đăng ký</div>
            <div class="mt-1 text-xl font-bold text-cyan-400">{funnel.signups}</div>
            <div class="text-[11px] text-slate-400">{funnel.clickToSignupPercent} chuyển đổi</div>
          </div>
          <div class="rounded-lg bg-slate-950 p-3 border border-slate-800">
            <div class="text-xs text-slate-400">💳 Nâng cấp trả phí</div>
            <div class="mt-1 text-xl font-bold text-emerald-400">{funnel.paid}</div>
            <div class="text-[11px] text-slate-400">{funnel.signupToPaidPercent} chuyển đổi</div>
          </div>
        </div>

        <div class="mt-4 flex items-center justify-between rounded-lg bg-cyan-950/30 px-3 py-2 border border-cyan-800/40 text-xs">
          <span>🪙 <strong>Đã nhận:</strong> {funnel.creditsEarned} credits</span>
          <span class="text-amber-400">⏳ <strong>Đang chờ:</strong> {funnel.creditsPending} credits</span>
        </div>
      </section>

      <!-- 3. Reward Tiers Card -->
      <section class="rounded-xl border border-slate-800 bg-slate-900/90 p-5 shadow-lg" aria-label="Các hạng phần thưởng">
        <div class="flex items-center justify-between">
          <h2 class="text-base font-semibold text-white">🏆 Hạng thành viên & Quyền lợi</h2>
          <span class="text-xs text-cyan-300 font-medium">{tierProgress.qualifiedCount} bạn bè trả phí</span>
        </div>

        <!-- Progress bar towards next tier -->
        {#if tierProgress.nextTier}
          <div class="mt-3">
            <div class="flex justify-between text-xs text-slate-400 mb-1">
              <span>Tiến trình lên hạng <strong>{CANONICAL_REFERRAL_TIERS[tierProgress.nextTier].title}</strong></span>
              <span>Còn <strong>{tierProgress.referralsToNextTier}</strong> lượt nữa</span>
            </div>
            <div class="h-2 w-full rounded-full bg-slate-800 overflow-hidden" role="progressbar" aria-valuenow={tierProgress.progressPercent} aria-valuemin={0} aria-valuemax={100}>
              <div
                class="h-full bg-gradient-to-r from-cyan-500 to-emerald-400 transition-all duration-500"
                style="width: {tierProgress.progressPercent}%"
              ></div>
            </div>
          </div>
        {:else}
          <p class="mt-2 text-xs text-emerald-400 font-semibold">
            🎉 Bạn đã đạt hạng cao nhất: Bạch Kim (15% hoa hồng trọn đời)!
          </p>
        {/if}

        <div class="mt-4 grid grid-cols-2 gap-3 text-xs sm:grid-cols-4">
          {#each Object.values(CANONICAL_REFERRAL_TIERS) as tier}
            <div
              class="rounded-lg p-3 border transition {tierProgress.currentTier === tier.tier
                ? 'border-cyan-500 bg-cyan-950/40'
                : 'border-slate-800 bg-slate-950'}"
            >
              <div class="font-bold text-white">{tier.title}</div>
              <div class="mt-1 text-slate-400">
                {tier.minReferrals}{tier.maxReferrals ? `–${tier.maxReferrals}` : '+'} ref
              </div>
              <div class="mt-1 font-semibold text-cyan-400">{tier.multiplier}x credits</div>
              {#if tier.recurringCommissionPercent > 0}
                <div class="mt-0.5 text-emerald-400 font-medium">+{tier.recurringCommissionPercent}% hoa hồng</div>
              {/if}
            </div>
          {/each}
        </div>
      </section>

      <!-- 4. Referral History -->
      <section class="rounded-xl border border-slate-800 bg-slate-900/90 p-5 shadow-lg" aria-label="Lịch sử giới thiệu">
        <h2 class="text-base font-semibold text-white">👥 Danh sách bạn bè đã giới thiệu</h2>
        <div class="mt-3 divide-y divide-slate-800/80">
          {#each historyItems as item}
            <div class="flex items-center justify-between py-2.5 text-xs">
              <div>
                <span class="font-medium text-white">{item.name}</span>
                <span class="ml-2 text-slate-400">· {item.plan}</span>
                <span class="ml-2 text-slate-500">· {item.timeAgo}</span>
              </div>
              <div class="flex items-center gap-2">
                <span class="font-semibold text-cyan-300">{item.credits}</span>
                {#if item.status === 'rewarded'}
                  <span class="rounded bg-emerald-950 px-2 py-0.5 font-semibold text-emerald-300 border border-emerald-800/50">
                    Đã nhận ✅
                  </span>
                {:else if item.status === 'pending' && item.paymentStatus === 'pending'}
                  <span class="rounded bg-amber-950 px-2 py-0.5 font-semibold text-amber-300 border border-amber-800/50">
                    Chờ thanh toán ⏳
                  </span>
                {:else if item.status === 'fraud_flagged'}
                  <span class="rounded bg-rose-950 px-2 py-0.5 font-semibold text-rose-300 border border-rose-800/50">
                    Tạm giữ xem xét ⚠️
                  </span>
                {:else if item.status === 'revoked'}
                  <span class="rounded bg-slate-800 px-2 py-0.5 text-slate-400">
                    Đã thu hồi ↩️
                  </span>
                {:else}
                  <span class="rounded bg-slate-800 px-2 py-0.5 text-slate-300">
                    Chờ kích hoạt
                  </span>
                {/if}
              </div>
            </div>
          {/each}
        </div>
      </section>
    </div>

    <!-- Right 1 Col: Anti-Fraud Gating Tests, Promo Redemption, Growth Prompts -->
    <div class="space-y-6">
      <!-- Target Verifications & Controls (Live Interactive State Checkers) -->
      <section class="rounded-xl border border-slate-800 bg-slate-900/90 p-5 shadow-lg">
        <h3 class="text-sm font-semibold text-cyan-400 uppercase tracking-wider">
          Kiểm chứng tiêu chí P8-05
        </h3>

        <!-- Target 1: Pending Payment Gate -->
        <div class="mt-4 rounded-lg bg-slate-950 p-3 border border-slate-800 text-xs">
          <div class="font-semibold text-white">Target 1: Chờ thanh toán</div>
          <p class="mt-1 text-slate-400">Không trao thưởng ngay khi thanh toán chưa hoàn tất.</p>
          <div class="mt-2 flex gap-2">
            <button
              class="px-2 py-1 rounded border {testPaymentStatus === 'pending' ? 'bg-amber-950 border-amber-500 text-amber-200' : 'bg-slate-900 border-slate-700 text-slate-400'}"
              onclick={() => (testPaymentStatus = 'pending')}
            >
              Pending
            </button>
            <button
              class="px-2 py-1 rounded border {testPaymentStatus === 'paid' ? 'bg-emerald-950 border-emerald-500 text-emerald-200' : 'bg-slate-900 border-slate-700 text-slate-400'}"
              onclick={() => (testPaymentStatus = 'paid')}
            >
              Paid
            </button>
          </div>
          <div class="mt-2 font-mono text-[11px] {paymentGateVerdict.canReward ? 'text-emerald-400' : 'text-amber-400'}">
            {#if paymentGateVerdict.canReward}
              ✅ Đủ điều kiện trao thưởng
            {:else}
              ⏳ {paymentGateVerdict.heldReason}
            {/if}
          </div>
        </div>

        <!-- Target 2: Self-Referral Hold -->
        <div class="mt-3 rounded-lg bg-slate-950 p-3 border border-slate-800 text-xs">
          <div class="font-semibold text-white">Target 2: Tự giới thiệu (Anti-Fraud)</div>
          <p class="mt-1 text-slate-400">Trùng IP/thiết bị/tài khoản bị tạm giữ để xem xét.</p>
          <label class="mt-2 flex items-center gap-2 cursor-pointer">
            <input
              type="checkbox"
              bind:checked={testSelfReferralUser}
              class="rounded border-slate-700 text-cyan-500"
            />
            <span>Mô phỏng tự giới thiệu bản thân</span>
          </label>
          <div class="mt-2 font-mono text-[11px] {selfReferralVerdict.isSelfReferral ? 'text-rose-400' : 'text-emerald-400'}">
            {#if selfReferralVerdict.isSelfReferral}
              ⚠️ Bị chặn: {selfReferralVerdict.reason}
            {:else}
              ✅ Hợp lệ (khác thực thể)
            {/if}
          </div>
        </div>

        <!-- Target 3: Replay / Refund Reversal -->
        <div class="mt-3 rounded-lg bg-slate-950 p-3 border border-slate-800 text-xs">
          <div class="font-semibold text-white">Target 3: Hoàn tiền & Replay an toàn</div>
          <p class="mt-1 text-slate-400">Replay webhook chỉ đảo ngược đúng 1 lần.</p>
          <button
            class="mt-2 px-2.5 py-1 rounded bg-slate-900 border border-slate-700 hover:bg-slate-800 text-slate-200 text-xs"
            onclick={() => (testRefundTriggered = !testRefundTriggered)}
          >
            {testRefundTriggered ? 'Kích hoạt lại lần 2 (Replay)' : 'Mô phỏng hoàn tiền'}
          </button>
          <div class="mt-2 font-mono text-[11px] {refundVerdict.isDuplicateReplay ? 'text-amber-400' : 'text-slate-300'}">
            ℹ️ {refundVerdict.message}
          </div>
        </div>
      </section>

      <!-- Promotional Code Redemption -->
      <section class="rounded-xl border border-slate-800 bg-slate-900/90 p-5 shadow-lg">
        <h3 class="text-sm font-semibold text-white">🎟️ Nhập mã khuyến mại</h3>
        <p class="mt-1 text-xs text-slate-400">
          Nhập mã voucher hoặc mã giới thiệu từ đối tác để nhận credits.
        </p>
        <div class="mt-3 flex gap-2">
          <input
            type="text"
            bind:value={promoCodeInput}
            placeholder="VD: WELCOME2026"
            class="w-full rounded-lg border border-slate-700 bg-slate-950 px-3 py-1.5 font-mono text-xs text-white uppercase focus:outline-none focus:ring-1 focus:ring-cyan-500"
          />
          <button
            type="button"
            onclick={handleRedeemPromo}
            class="shrink-0 rounded-lg bg-slate-800 px-3 py-1.5 text-xs font-semibold text-white hover:bg-slate-700 active:scale-95"
          >
            Áp dụng
          </button>
        </div>
        {#if promoStatusMsg}
          <p class="mt-2 text-xs {promoStatusType === 'success' ? 'text-emerald-400' : 'text-rose-400'} font-medium">
            {promoStatusMsg}
          </p>
        {/if}
      </section>

      <!-- Viral loop growth prompts -->
      <section class="rounded-xl border border-slate-800 bg-slate-900/90 p-5 shadow-lg">
        <h3 class="text-sm font-semibold text-white">⚡ Nhiệm vụ tăng trưởng</h3>
        <div class="mt-3 space-y-3">
          {#each CANONICAL_GROWTH_PROMPTS as prompt}
            <div class="rounded-lg bg-slate-950 p-3 border border-slate-800/80 text-xs">
              <div class="flex items-center justify-between">
                <span class="font-semibold text-slate-200">{prompt.title}</span>
                <span class="rounded bg-cyan-950 px-1.5 py-0.5 text-[11px] font-bold text-cyan-400 border border-cyan-800/50">
                  +{prompt.rewardCredits} cr
                </span>
              </div>
              <p class="mt-1 text-slate-400 text-[11px]">{prompt.description}</p>
              <button
                type="button"
                class="mt-2 text-xs text-cyan-400 hover:underline font-medium"
                onclick={handleCopy}
              >
                {prompt.actionText} →
              </button>
            </div>
          {/each}
        </div>
      </section>
    </div>
  </div>
</main>
