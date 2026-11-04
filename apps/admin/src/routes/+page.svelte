<script lang="ts">
  import {
    canAccessAdmin,
    evaluateAdminListenerAccess,
    evaluateAppealReviewAction,
    evaluateImpersonationAction,
    evaluateKillSwitchToggle,
    evaluateModerationDecision,
    evaluateOperationalHealthSeparation,
    evaluateSupportTicketAccess,
    evaluateBackupRestoreAndSmokeRehearsal,
    evaluateProviderAndLicenseFreshnessGate,
    evaluateAdminComplianceAndSecurityGuards,
    evaluateFullScopeAcceptanceAndReleaseDecision,
    CANONICAL_31_MODULES,
    CANONICAL_6_MODES
  } from '$lib/access';

  // P8-09: Full-Scope Acceptance & Release Decision State
  let assertProductionLaunch = $state(false);
  const fullScopeVerdict = $derived(
    evaluateFullScopeAcceptanceAndReleaseDecision({
      adminRole: 'super_admin',
      auditedModuleIds: [...CANONICAL_31_MODULES],
      auditedModeIds: [...CANONICAL_6_MODES],
      verifiedTaskCount: 60,
      untrackedRemainingScopeCount: 0,
      assertProductionLaunch,
      legalSignoffGranted: false, // LEG-H-001
      liveProviderApproved: false, // EXT-GATE
      stagingDrRehearsalPassed: false // EXT-GATE
    })
  );

  const nowMs = Date.parse('2026-11-02T09:00:00Z');
  let selectedRole = $state('owner');
  let vpnVerified = $state(true);
  let mfaVerified = $state(true);
  let impersonationAction = $state<'read_query' | 'mutating_command'>('mutating_command');
  let killSwitchReason = $state('Sự cố khẩn cấp TikTok API INC-2026-042');

  // P8-03: Appeal Audit State
  let appealCategory = $state('phishing_malware');
  let appealResolution = $state<'upheld' | 'overturned'>('overturned');
  let appealEvidenceRef = $state('https://security.creativanta.internal/ev/FP-2026-8812.pdf');
  let appealJustification = $state('Tên miền đối tác được xác thực qua báo cáo bảo mật bên thứ ba');
  let appealAdminRole = $state('content_admin');

  // P8-03: Support Desk State
  let supportViewerRole = $state('owner');
  let isInternalAdminCaller = $state(false);

  // P8-03: Operational Health State
  let availabilityPct = $state(99.9);
  let errorRatePct = $state(0.08);
  let p95LatencyMs = $state(180);
  let rateLimitUsagePct = $state(60);
  let shopResponseRatePct = $state(85);
  let listingQualityPct = $state(75);
  let delayedFulfillmentCount = $state(2);
  let engagementDropPct = $state(25);
  let connectorAuthExpiresInDays = $state(2);

  const listenerVerdict = $derived(
    evaluateAdminListenerAccess(
      {
        sessionId: '90000000-0000-4000-8000-000000000010',
        adminId: '90000000-0000-4000-8000-000000000001',
        role: selectedRole,
        internalAdmin: true,
        vpnVerified,
        mfaVerified,
        status: 'active',
        expiresAtMs: nowMs + 8 * 60 * 60 * 1000
      },
      nowMs
    )
  );

  const impersonationVerdict = $derived(
    evaluateImpersonationAction({
      adminRole: 'support_admin',
      startedAtMs: nowMs,
      nowMs: nowMs + 10 * 60 * 1000,
      reason: 'Kiểm tra phiếu hỗ trợ SUP-2026-991',
      supportTicketId: 'SUP-2026-991',
      attemptedActionType: impersonationAction
    })
  );

  const moderationVerdict = $derived(
    evaluateModerationDecision({
      adminRole: 'content_admin',
      adminLinkedUserId: 'user-admin-1',
      flaggedUserId: 'user-flagged-2',
      category: 'revoked_clone_consent',
      riskScore: 95,
      decision: 'approve',
      auditReason: 'Kiểm tra khóa cứng SAFE-2026-02'
    })
  );

  const killSwitchVerdict = $derived(
    evaluateKillSwitchToggle({
      adminRole: 'tech_admin',
      mfaVerified,
      flagKey: 'kill_switch:tiktok',
      auditReason: killSwitchReason
    })
  );

  const appealVerdict = $derived(
    evaluateAppealReviewAction({
      adminRole: appealAdminRole,
      adminLinkedUserId: 'user-admin-99',
      appealedByUserId: 'user-app-creator-1',
      category: appealCategory,
      resolution: appealResolution,
      resolutionNotes: 'Đánh giá hồ sơ khiếu nại kiểm duyệt P8-03',
      evidenceRef: appealEvidenceRef,
      falsePositiveJustification: appealJustification
    })
  );

  const sampleSupportMessages = [
    { id: 'm-1', senderRole: 'creator', internalOnly: false, content: 'Tài khoản không kết nối được TikTok Shop.' },
    { id: 'm-2', senderRole: 'support_admin', internalOnly: true, content: 'Ghi chú nội bộ: Phát hiện lỗi 401 token OAuth quá hạn. Cần tech_admin kiểm tra key rotation.' },
    { id: 'm-3', senderRole: 'support_admin', internalOnly: false, content: 'Chúng tôi đang kiểm tra phiên kết nối của bạn và sẽ phản hồi trong 2 giờ.' }
  ];

  const supportVerdict = $derived(
    evaluateSupportTicketAccess({
      callerRole: supportViewerRole,
      isInternalAdmin: isInternalAdminCaller,
      messages: sampleSupportMessages
    })
  );

  const healthSeparation = $derived(
    evaluateOperationalHealthSeparation({
      availabilityPct,
      errorRatePct,
      p95LatencyMs,
      rateLimitUsagePct,
      mrrCents: 45000000,
      activeWorkspaces: 1240,
      churnRatePct: 0.8,
      coachingInputs: {
        shopResponseRatePct,
        listingQualityPct,
        delayedFulfillmentCount,
        engagementDropPct,
        connectorAuthExpiresInDays
      }
    })
  );

  // P8-08: Restore, Smoke, Provider Freshness & Compliance Rehearsal State
  let smokePassedState = $state(true);
  let checksumValidState = $state(true);
  let providerRateFresh = $state(true);
  let auditSequenceGap = $state(false);
  let overrides24hCount = $state(11);
  let concurrentImpersonationTry = $state(false);

  const restoreSmokeVerdict = $derived(
    evaluateBackupRestoreAndSmokeRehearsal({
      expectedSha256: 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
      actualSha256: checksumValidState
        ? 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
        : '0000000000000000000000000000000000000000000000000000000000000000',
      debitMicroUnits: 15000000000,
      creditMicroUnits: 15000000000,
      rpoSeconds: 0,
      rtoSeconds: 420,
      previousSlot: 'blue',
      candidateSlot: 'green',
      healthzOk: true,
      readyzReady: true,
      businessSmokePassed: smokePassedState,
      auditSequenceIntact: !auditSequenceGap
    })
  );

  const providerFreshnessVerdict = $derived(
    evaluateProviderAndLicenseFreshnessGate({
      nowMs,
      rateCardVerifiedAtMs: providerRateFresh ? nowMs - 2 * 86400000 : nowMs - 45 * 86400000,
      rateCardValidUntilMs: providerRateFresh ? nowMs + 28 * 86400000 : nowMs - 1000,
      rateCardEnabled: true,
      connectorClaimedState: 'native_now',
      connectorScopeGranted: true,
      connectorAppReviewApproved: providerRateFresh,
      connectorValidUntilMs: nowMs + 28 * 86400000,
      workflowRuntimeMode: 'owned_go_runtime',
      workflowEnterpriseLicenseVerified: false,
      legalDocsPublished: true,
      externalLegalCounselSignoff: false
    })
  );

  const complianceSecurityVerdict = $derived(
    evaluateAdminComplianceAndSecurityGuards({
      adminRole: 'ops_admin',
      activeImpersonationExistsForTargetUser: true,
      attemptConcurrentImpersonation: concurrentImpersonationTry,
      overridesInLast24h: overrides24hCount,
      auditSequenceGapDetected: auditSequenceGap,
      breachElapsedHours: 12
    })
  );
</script>

<svelte:head>
  <title>Admin · Access Restricted · Creativanta</title>
  <meta name="robots" content="noindex, nofollow" />
</svelte:head>

<section aria-labelledby="restricted-title" class="max-w-5xl space-y-8">
  <div>
    <p class="text-xs font-bold uppercase tracking-[0.16em] text-[#bb5b3f]">
      P0-01 / P0-07 · INTERNAL TRUST BOUNDARY &amp; ISOLATED ADMIN FOUNDATION (S26)
    </p>
    <h1 id="restricted-title" class="mt-4 text-4xl font-bold tracking-tight text-[#242924]">
      Khu vực vận hành nội bộ
    </h1>
    <p class="mt-4 max-w-2xl text-sm leading-7 text-[#7d837b]">
      Cổng quản trị nội bộ chạy trên listener cô lập (<code>ModeAdminAPI</code>), tách biệt hoàn toàn với phiên Clerk của Workspace. Mọi vai trò Workspace (<code>owner..external</code>) đều bị từ chối ở tầng transport.
    </p>

    <div class="mt-6 rounded-2xl border border-[#e8e5dc] bg-[#fffefa] p-6">
      <div class="flex items-center gap-3">
        <span
          class="inline-flex h-11 w-11 items-center justify-center rounded-xl bg-[#fff0e7] text-[#d94a31] text-2xl"
          aria-hidden="true">!</span
        >
        <div>
          <h2 class="text-base font-bold">Chưa cấp quyền truy cập</h2>
          <p class="mt-1 text-xs leading-6 text-[#7d837b]">
            P0-03 / P0-07: identity, role, capability, audit.
          </p>
        </div>
      </div>
      <div class="mt-5 border-t border-[#e8e5dc] pt-4 text-xs text-[#7d837b]">
        Admin UI enabled (unauthenticated SSR):
        <strong class="text-[#b44833]">{canAccessAdmin() ? 'yes' : 'no'}</strong>. Yêu cầu xác thực
        <code>internal_admins</code> + VPN (Tailscale/WireGuard) + TOTP MFA 6 số (TTL 8 giờ).
      </div>
    </div>
  </div>

  <div class="grid gap-6 md:grid-cols-2">
    <div class="rounded-2xl border border-[#e8e5dc] bg-white p-6">
      <h3 class="text-sm font-bold text-[#242924]">
        1. Cổng Cô lập Listener Admin (A001 · P0-07 Target #2)
      </h3>
      <div class="mt-3 space-y-2 text-xs">
        <label class="block">
          <span class="font-semibold">Vai trò thử nghiệm gọi Admin Listener:</span>
          <select
            bind:value={selectedRole}
            class="mt-1 w-full rounded-lg border border-[#d6d1c4] bg-white px-3 py-1.5"
          >
            <option value="owner">Workspace Owner (Bị từ chối)</option>
            <option value="admin">Workspace Admin (Bị từ chối)</option>
            <option value="super_admin">Internal Super Admin (Cho phép)</option>
            <option value="tech_admin">Internal Tech Admin (Cho phép)</option>
            <option value="analyst">Internal Analyst (Read-only)</option>
          </select>
        </label>
        <div class="flex gap-4 pt-1">
          <label class="flex items-center gap-1.5">
            <input type="checkbox" bind:checked={vpnVerified} />
            <span>VPN Mesh Verified</span>
          </label>
          <label class="flex items-center gap-1.5">
            <input type="checkbox" bind:checked={mfaVerified} />
            <span>TOTP MFA Verified</span>
          </label>
        </div>
        <p class="mt-2 font-semibold {listenerVerdict.allowed ? 'text-emerald-700' : 'text-[#b44833]'}">
          [{listenerVerdict.errorCode}] {listenerVerdict.reason}
        </p>
      </div>
    </div>

    <div class="rounded-2xl border border-[#e8e5dc] bg-white p-6">
      <h3 class="text-sm font-bold text-[#242924]">
        2. Phiên Impersonation Chỉ đọc 30 phút (A003 · P0-07 Target #3)
      </h3>
      <div class="mt-3 space-y-2 text-xs">
        <label class="block">
          <span class="font-semibold">Loại thao tác trong phiên Impersonation:</span>
          <select
            bind:value={impersonationAction}
            class="mt-1 w-full rounded-lg border border-[#d6d1c4] bg-white px-3 py-1.5"
          >
            <option value="mutating_command">Thao tác Ghi / Mutating RPC (Bị chặn)</option>
            <option value="read_query">Truy vấn Chỉ đọc / Read Query (Cho phép)</option>
          </select>
        </label>
        <p class="mt-2 font-semibold {impersonationVerdict.allowed ? 'text-emerald-700' : 'text-[#b44833]'}">
          [{impersonationVerdict.errorCode} · mode={impersonationVerdict.mode}] {impersonationVerdict.reason}
        </p>
      </div>
    </div>

    <div class="rounded-2xl border border-[#e8e5dc] bg-white p-6">
      <h3 class="text-sm font-bold text-[#242924]">
        3. Hàng đợi Kiểm duyệt &amp; Khóa Cứng SAFE-2026-02 (A015)
      </h3>
      <p class="mt-2 text-xs leading-5 text-[#5d635b]">
        Danh mục cấm tuyệt đối (<code>revoked_clone_consent</code>, <code>sexual_minors</code>,
        <code>phishing_malware</code>) không thể bị ghi đè bởi quyền <code>packaging:override</code> của Workspace hoặc phê duyệt nhầm.
      </p>
      <p class="mt-2 text-xs font-semibold text-[#b44833]">
        [SLA {moderationVerdict.slaHours}h · Band={moderationVerdict.riskBand}] {moderationVerdict.reason}
      </p>
    </div>

    <div class="rounded-2xl border border-[#e8e5dc] bg-white p-6">
      <h3 class="text-sm font-bold text-[#242924]">
        4. Công tắc Ngắt khẩn cấp Kill Switch &amp; Nhật ký Kiểm toán (A009 / A010)
      </h3>
      <div class="mt-3 space-y-2 text-xs">
        <input
          type="text"
          bind:value={killSwitchReason}
          class="w-full rounded-lg border border-[#d6d1c4] bg-white px-3 py-1.5"
        />
        <p class="font-semibold {killSwitchVerdict.allowed ? 'text-emerald-700' : 'text-[#b44833]'}">
          {killSwitchVerdict.reason}
        </p>
      </div>
    </div>

    <div class="rounded-2xl border border-[#e8e5dc] bg-white p-6">
      <h3 class="text-sm font-bold text-[#242924]">
        5. Xử lý Kháng cáo Kiểm duyệt &amp; False-Positive Hard-Block (P8-03 · SAFE-2026-02)
      </h3>
      <div class="mt-3 space-y-2 text-xs">
        <div class="grid grid-cols-2 gap-2">
          <label class="block">
            <span class="font-semibold">Vai trò xem xét:</span>
            <select
              bind:value={appealAdminRole}
              class="mt-1 w-full rounded-lg border border-[#d6d1c4] bg-white px-2 py-1"
            >
              <option value="content_admin">Content Admin (Cho phép)</option>
              <option value="super_admin">Super Admin (Cho phép)</option>
              <option value="ops_admin">Ops Admin (Bị từ chối)</option>
            </select>
          </label>
          <label class="block">
            <span class="font-semibold">Quyết định xử lý:</span>
            <select
              bind:value={appealResolution}
              class="mt-1 w-full rounded-lg border border-[#d6d1c4] bg-white px-2 py-1"
            >
              <option value="overturned">Chấp thuận khiếu nại (Overturned)</option>
              <option value="upheld">Bác bỏ khiếu nại (Upheld)</option>
            </select>
          </label>
        </div>
        <label class="block">
          <span class="font-semibold">Danh mục vi phạm:</span>
          <select
            bind:value={appealCategory}
            class="mt-1 w-full rounded-lg border border-[#d6d1c4] bg-white px-2 py-1"
          >
            <option value="phishing_malware">phishing_malware (Hard-block)</option>
            <option value="revoked_clone_consent">revoked_clone_consent (Hard-block)</option>
            <option value="medical_claim_warning">medical_claim_warning (Tiêu chuẩn)</option>
          </select>
        </label>
        <label class="block">
          <span class="font-semibold">Đường dẫn bằng chứng kiểm toán (Bắt buộc cho Hard-block):</span>
          <input
            type="text"
            bind:value={appealEvidenceRef}
            class="mt-1 w-full rounded-lg border border-[#d6d1c4] bg-white px-2 py-1"
          />
        </label>
        <label class="block">
          <span class="font-semibold">Giải trình sai lệch (False-positive justification):</span>
          <input
            type="text"
            bind:value={appealJustification}
            class="mt-1 w-full rounded-lg border border-[#d6d1c4] bg-white px-2 py-1"
          />
        </label>
        <p class="mt-2 font-semibold {appealVerdict.allowed ? 'text-emerald-700' : 'text-[#b44833]'}">
          [{appealVerdict.errorCode}{appealVerdict.falsePositiveCleared ? ' · FP_CLEARED' : ''}] {appealVerdict.reason}
        </p>
      </div>
    </div>

    <div class="rounded-2xl border border-[#e8e5dc] bg-white p-6">
      <h3 class="text-sm font-bold text-[#242924]">
        6. Phân tách Ghi chú Nội bộ Hỗ trợ Support Desk (P8-03 · RULE-S26-003)
      </h3>
      <div class="mt-3 space-y-2 text-xs">
        <div class="flex gap-4 items-center">
          <label class="flex items-center gap-1.5">
            <input type="radio" bind:group={isInternalAdminCaller} value={false} />
            <span>Người dùng Creator (Ẩn ghi chú nội bộ)</span>
          </label>
          <label class="flex items-center gap-1.5">
            <input type="radio" bind:group={isInternalAdminCaller} value={true} />
            <span>Support Admin Nội bộ (Hiện đầy đủ)</span>
          </label>
        </div>
        <p class="font-medium text-[#7d837b]">{supportVerdict.reason}</p>
        <div class="mt-2 space-y-1.5 border border-[#e8e5dc] rounded-lg p-2.5 bg-[#fdfdfa]">
          {#each supportVerdict.visibleMessages as msg}
            <div class="p-2 rounded {msg.internalOnly ? 'bg-amber-50 border border-amber-200' : 'bg-white border border-[#e8e5dc]'}">
              <span class="font-semibold uppercase tracking-wider text-[10px] {msg.internalOnly ? 'text-amber-800' : 'text-slate-600'}">
                {msg.senderRole} {msg.internalOnly ? '[GHI CHÚ NỘI BỘ]' : ''}
              </span>
              <p class="mt-0.5 text-xs text-[#242924]">{msg.content}</p>
            </div>
          {/each}
        </div>
      </div>
    </div>

    <div class="rounded-2xl border border-[#e8e5dc] bg-white p-6 md:col-span-2">
      <h3 class="text-sm font-bold text-[#242924]">
        7. Sức khỏe Vận hành Độc lập &amp; Huấn luyện Năng lực Chủ động (P8-03 · PRD §36B)
      </h3>
      <div class="mt-3 grid gap-4 md:grid-cols-2 text-xs">
        <div class="space-y-2 rounded-xl border border-[#e8e5dc] bg-[#faf9f5] p-4">
          <h4 class="font-bold text-[#242924]">Chỉ số Kỹ thuật Vận hành (Composite 0-100)</h4>
          <p class="text-[#7d837b]">Công thức: 40% Khả dụng + 25% Tỷ lệ lỗi + 20% Độ trễ + 15% Rate Limit</p>
          <div class="mt-2 text-2xl font-black {healthSeparation.technicalStatus === 'healthy' ? 'text-emerald-700' : 'text-amber-600'}">
            {healthSeparation.technicalScore} / 100 [{healthSeparation.technicalStatus.toUpperCase()}]
          </div>
          <p class="text-[11px] text-emerald-800 font-medium">✓ Độc lập hoàn toàn với MRR ($450,000), Workspaces (1,240), Churn (0.8%)</p>
        </div>

        <div class="space-y-2 rounded-xl border border-[#e8e5dc] bg-[#faf9f5] p-4">
          <h4 class="font-bold text-[#242924]">Thẻ Huấn luyện Năng lực Chủ động ({healthSeparation.coachingCount} phát hiện)</h4>
          <p class="text-[#7d837b]">Các khuyến nghị hành động không can thiệp vào quyền kỹ thuật hay điểm vận hành.</p>
          <div class="space-y-1.5 mt-2">
            {#each healthSeparation.coachingCards as card}
              <div class="flex items-center justify-between rounded bg-white p-2 border border-[#e8e5dc]">
                <div>
                  <span class="font-semibold text-slate-800">{card.title}</span>
                  <span class="block text-[10px] text-slate-400 font-mono">{card.rule}</span>
                </div>
                <a href={card.targetCta} class="px-2 py-1 text-[11px] font-semibold bg-[#242924] text-white rounded hover:bg-[#3d443d]">
                  Xử lý ({card.targetCta})
                </a>
              </div>
            {/each}
          </div>
        </div>
      </div>
    </div>

    <div class="rounded-2xl border border-[#e8e5dc] bg-white p-6 md:col-span-2" role="region" aria-labelledby="p808-rehearsal-heading">
      <h3 id="p808-rehearsal-heading" class="text-sm font-bold text-[#242924]">
        8. Diễn tập Khôi phục Sao lưu, Kiểm thử Khói (Smoke Rollback), Độ tươi Nhà cung cấp &amp; Tuân thủ GDPR/PDPA (P8-08)
      </h3>
      <div class="mt-3 grid gap-4 md:grid-cols-3 text-xs">
        <div class="space-y-2 rounded-xl border border-[#e8e5dc] bg-[#faf9f5] p-4">
          <h4 class="font-bold text-[#242924]">Target 1 · Khôi phục &amp; Smoke Gate</h4>
          <label class="flex items-center gap-1.5">
            <input type="checkbox" bind:checked={checksumValidState} />
            <span>SHA-256 Checksum hợp lệ (.sha256)</span>
          </label>
          <label class="flex items-center gap-1.5">
            <input type="checkbox" bind:checked={smokePassedState} />
            <span>Business Smoke Probe đạt chuẩn</span>
          </label>
          <p class="font-semibold {restoreSmokeVerdict.allowed ? 'text-emerald-700' : 'text-[#b44833]'}" role="status">
            [{restoreSmokeVerdict.errorCode} · Slot={restoreSmokeVerdict.activeSlot}] {restoreSmokeVerdict.reason}
          </p>
        </div>

        <div class="space-y-2 rounded-xl border border-[#e8e5dc] bg-[#faf9f5] p-4">
          <h4 class="font-bold text-[#242924]">Target 2 · Bằng chứng Provider &amp; Pháp lý</h4>
          <label class="flex items-center gap-1.5">
            <input type="checkbox" bind:checked={providerRateFresh} />
            <span>Bảng giá AI &amp; Connector còn hạn (&lt;30 ngày)</span>
          </label>
          <p class="font-semibold {providerFreshnessVerdict.noStaleEvidence ? 'text-emerald-700' : 'text-[#b44833]'}" role="status">
            [{providerFreshnessVerdict.errorCode} · Max={providerFreshnessVerdict.maxEvidenceState}] {providerFreshnessVerdict.reason}
          </p>
        </div>

        <div class="space-y-2 rounded-xl border border-[#e8e5dc] bg-[#faf9f5] p-4">
          <h4 class="font-bold text-[#242924]">Target 3 · Chuỗi Kiểm toán &amp; GDPR/PDPA</h4>
          <label class="flex items-center gap-1.5">
            <input type="checkbox" bind:checked={concurrentImpersonationTry} />
            <span>Thử Impersonate trùng người dùng (EC-M23-003)</span>
          </label>
          <label class="flex items-center gap-1.5">
            <input type="checkbox" bind:checked={auditSequenceGap} />
            <span>Giả lập hổng chuỗi Audit (EC-M23-005)</span>
          </label>
          <p class="font-semibold {complianceSecurityVerdict.allowed ? 'text-emerald-700' : 'text-[#b44833]'}" role="status">
            [{complianceSecurityVerdict.errorCode} · 72h Breach còn {complianceSecurityVerdict.breachRemainingHours}h] {complianceSecurityVerdict.reason}
          </p>
        </div>
      </div>
    </div>

    <div class="rounded-2xl border border-[#e8e5dc] bg-white p-6 md:col-span-2" role="region" aria-labelledby="p809-acceptance-heading">
      <h3 id="p809-acceptance-heading" class="text-sm font-bold text-[#242924]">
        9. Nghiệm thu Toàn diện Nền tảng (31 Modules / 6 Modes / 60 Tasks) &amp; Quyết định Phát hành (P8-09)
      </h3>
      <div class="mt-3 space-y-3 text-xs">
        <div class="flex flex-wrap items-center justify-between gap-3 rounded-xl border border-[#e8e5dc] bg-[#faf9f5] p-4">
          <div class="space-y-1">
            <span class="inline-flex items-center gap-1.5 rounded-md bg-[#274333]/10 px-2 py-0.5 font-mono text-[11px] font-bold text-[#274333]">
              ✓ Đối soát thành công: 31/31 Module • 6/6 Chế độ • 60/60 Task • 0 Tồn đọng
            </span>
            <p class="text-[#7d837b]">
              Bảo lưu nguyên vẹn 6 chế độ vận hành (RULE-M01-006) và không greenwashing cổng đối tác/pháp lý.
            </p>
          </div>
          <div class="flex items-center gap-3">
            <label class="flex items-center gap-1.5 font-semibold text-[#242924]">
              <input type="checkbox" bind:checked={assertProductionLaunch} />
              <span>Yêu cầu phát hành sản xuất</span>
            </label>
            <span class="rounded px-2.5 py-1 font-mono font-bold {fullScopeVerdict.allowed ? 'bg-emerald-100 text-emerald-800' : 'bg-rose-100 text-rose-800'}">
              {fullScopeVerdict.releaseDecision}
            </span>
          </div>
        </div>

        <div class="rounded-xl border border-[#e8e5dc] bg-white p-3 space-y-2">
          <div class="flex items-center justify-between">
            <span class="font-bold text-[#242924]">Các cổng bên ngoài bắt buộc (Chưa đóng):</span>
            <span class="font-mono text-amber-700 bg-amber-50 px-2 py-0.5 rounded border border-amber-200">
              {fullScopeVerdict.unmetExternalGatesCount} cổng ngoại vi
            </span>
          </div>
          <ul class="list-disc list-inside space-y-1 text-slate-600">
            {#each fullScopeVerdict.externalGates as gate}
              <li class="font-mono text-[11px]">{gate}</li>
            {/each}
          </ul>
          <p class="mt-2 font-semibold {fullScopeVerdict.allowed ? 'text-emerald-700' : 'text-[#b44833]'}" role="status">
            [{fullScopeVerdict.errorCode}] {fullScopeVerdict.reason}
          </p>
        </div>
      </div>
    </div>
  </div>
</section>
