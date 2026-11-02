<script lang="ts">
  import {
    canAccessAdmin,
    evaluateAdminListenerAccess,
    evaluateImpersonationAction,
    evaluateKillSwitchToggle,
    evaluateModerationDecision
  } from '$lib/access';

  const nowMs = Date.parse('2026-11-02T09:00:00Z');
  let selectedRole = $state('owner');
  let vpnVerified = $state(true);
  let mfaVerified = $state(true);
  let impersonationAction = $state<'read_query' | 'mutating_command'>('mutating_command');
  let killSwitchReason = $state('Sự cố khẩn cấp TikTok API INC-2026-042');

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
  </div>
</section>
