<script lang="ts">
  /**
   * Forgot Password Screen (W003 /forgot-password)
   * Canonical spec: docs/03_screens/web/screen_web_auth_forgot_password.md
   * Implements Clerk password recovery (`reset_password_email_code` + `attemptFirstFactor`),
   * expired-code recovery handling, and fail-closed provider protection (UF-02).
   */
  import { onMount } from 'svelte';
  import { goto } from '$app/navigation';
  import {
    authStore,
    requestClerkPasswordResetCode,
    confirmClerkPasswordResetCode
  } from '$lib/auth';

  let email = $state('');
  let resetCode = $state('');
  let newPassword = $state('');
  let step = $state<'request_code' | 'confirm_reset' | 'expired'>('request_code');
  let isSubmitting = $state(false);
  let errorMessage = $state<string | null>(null);
  let statusNotice = $state<string | null>(null);

  onMount(() => {
    authStore.init();
  });

  async function handleRequestReset(e?: SubmitEvent) {
    if (e) e.preventDefault();
    errorMessage = null;
    statusNotice = null;

    if ($authStore.state === 'unconfigured') {
      errorMessage =
        'Dịch vụ khôi phục mật khẩu Clerk chưa được cấu hình (VITE_CLERK_PUBLISHABLE_KEY). Vui lòng cấu hình khóa Clerk hợp lệ.';
      return;
    }

    isSubmitting = true;
    try {
      const result = await requestClerkPasswordResetCode({ email });
      if (!result.ok) {
        errorMessage = result.error || 'Không thể gửi mã khôi phục mật khẩu.';
        return;
      }

      step = 'confirm_reset';
      statusNotice = `Mã khôi phục mật khẩu đã được gửi tới ${email} (hiệu lực 60 phút).`;
    } finally {
      isSubmitting = false;
    }
  }

  async function handleConfirmReset(e: SubmitEvent) {
    e.preventDefault();
    errorMessage = null;
    statusNotice = null;

    if ($authStore.state === 'unconfigured') {
      errorMessage = 'Dịch vụ khôi phục mật khẩu Clerk chưa được cấu hình (fail-closed).';
      return;
    }

    isSubmitting = true;
    try {
      const result = await confirmClerkPasswordResetCode({
        code: resetCode,
        newPassword
      });

      if (!result.ok) {
        if (result.step === 'expired') {
          step = 'expired';
        }
        errorMessage = result.error || 'Đặt lại mật khẩu thất bại.';
        return;
      }

      statusNotice = 'Đã đặt lại mật khẩu và làm mới phiên đăng nhập thành công!';
      await authStore.init();
      await goto('/workspaces');
    } finally {
      isSubmitting = false;
    }
  }
</script>

<svelte:head>
  <title>Khôi phục mật khẩu — Creativanta</title>
</svelte:head>

<div class="mx-auto max-w-md py-8">
  <div class="rounded-3xl border border-[#e8e5dc] bg-[#fffefa] p-8 shadow-sm">
    <div class="mb-6">
      <p class="text-[11px] font-extrabold uppercase tracking-[0.2em] text-[#274333]">
        ACCOUNT RECOVERY · W003
      </p>
      <h1 class="mt-2 text-2xl font-bold tracking-tight text-[#242924]">Khôi phục mật khẩu</h1>
      <p class="mt-1 text-sm text-[#7d837b]">
        Nhập email đăng ký để nhận mã xác thực đặt lại mật khẩu (hiệu lực 60 phút).
      </p>
    </div>

    {#if $authStore.state === 'unconfigured'}
      <div class="mb-6 rounded-2xl border border-amber-300 bg-amber-50/90 p-4 text-xs text-amber-900" role="alert">
        <p class="font-bold">Chưa cấu hình dịch vụ khôi phục Clerk</p>
        <p class="mt-1 leading-relaxed">
          Luồng gửi email đặt lại mật khẩu chỉ hoạt động khi cấu hình Clerk IdP hợp lệ (fail-closed).
        </p>
      </div>
    {/if}

    {#if errorMessage}
      <div class="mb-5 rounded-xl border border-red-200 bg-red-50 p-3.5 text-xs text-red-800" role="alert">
        {errorMessage}
      </div>
    {/if}

    {#if statusNotice}
      <div class="mb-5 rounded-xl border border-emerald-200 bg-emerald-50 p-3.5 text-xs text-emerald-900" role="status">
        {statusNotice}
      </div>
    {/if}

    {#if step === 'request_code'}
      <form onsubmit={handleRequestReset} class="space-y-4">
        <div>
          <label for="recovery-email" class="block text-xs font-semibold text-[#242924]">
            Email tài khoản
          </label>
          <input
            id="recovery-email"
            type="email"
            bind:value={email}
            required
            autocomplete="email"
            placeholder="you@brand.vn"
            class="mt-1.5 w-full rounded-xl border border-[#dcd8cc] bg-white px-3.5 py-2.5 text-sm text-[#242924] focus:border-[#274333] focus:outline-none focus:ring-2 focus:ring-[#274333]/20"
          />
        </div>

        <button
          type="submit"
          disabled={isSubmitting}
          class="w-full rounded-xl bg-[#274333] px-4 py-2.5 text-sm font-semibold text-white transition hover:bg-[#1e3428] disabled:opacity-50"
        >
          {isSubmitting ? 'Đang gửi mã khôi phục...' : 'Gửi hướng dẫn đặt lại mật khẩu'}
        </button>
      </form>
    {:else if step === 'confirm_reset'}
      <form onsubmit={handleConfirmReset} class="space-y-4">
        <div>
          <label for="recovery-code" class="block text-xs font-semibold text-[#242924]">
            Mã xác thực khôi phục (Email OTP)
          </label>
          <input
            id="recovery-code"
            type="text"
            inputmode="numeric"
            bind:value={resetCode}
            required
            placeholder="123456"
            class="mt-1.5 w-full rounded-xl border border-[#dcd8cc] bg-white px-3.5 py-2.5 text-sm font-mono tracking-widest text-[#242924] focus:border-[#274333] focus:outline-none focus:ring-2 focus:ring-[#274333]/20"
          />
        </div>

        <div>
          <label for="recovery-new-password" class="block text-xs font-semibold text-[#242924]">
            Mật khẩu mới (tối thiểu 8 ký tự)
          </label>
          <input
            id="recovery-new-password"
            type="password"
            bind:value={newPassword}
            minlength="8"
            required
            autocomplete="new-password"
            placeholder="••••••••"
            class="mt-1.5 w-full rounded-xl border border-[#dcd8cc] bg-white px-3.5 py-2.5 text-sm text-[#242924] focus:border-[#274333] focus:outline-none focus:ring-2 focus:ring-[#274333]/20"
          />
        </div>

        <div class="flex gap-2">
          <button
            type="button"
            onclick={() => (step = 'request_code')}
            class="rounded-xl border border-[#dcd8cc] px-4 py-2.5 text-xs font-semibold text-[#525850] hover:bg-[#f4f1ea]"
          >
            Đổi email
          </button>
          <button
            type="submit"
            disabled={isSubmitting}
            class="flex-1 rounded-xl bg-[#274333] px-4 py-2.5 text-sm font-semibold text-white transition hover:bg-[#1e3428] disabled:opacity-50"
          >
            {isSubmitting ? 'Đang đặt lại mật khẩu...' : 'Xác nhận mật khẩu mới'}
          </button>
        </div>
      </form>
    {:else if step === 'expired'}
      <div class="space-y-4">
        <div class="rounded-xl border border-amber-300 bg-amber-50 p-4 text-xs text-amber-900">
          <p class="font-bold">Recovery expired — Mã khôi phục đã hết hạn</p>
          <p class="mt-1">
            Mã khôi phục mật khẩu chỉ có hiệu lực trong 60 phút. Vui lòng yêu cầu gửi lại mã mới cho
            <strong>{email}</strong>.
          </p>
        </div>
        <button
          type="button"
          onclick={() => handleRequestReset()}
          disabled={isSubmitting}
          class="w-full rounded-xl bg-[#274333] px-4 py-2.5 text-sm font-semibold text-white transition hover:bg-[#1e3428] disabled:opacity-50"
        >
          Gửi lại mã khôi phục mới
        </button>
      </div>
    {/if}

    <div class="mt-6 border-t border-[#e8e5dc] pt-4 text-center text-xs text-[#7d837b]">
      <a href="/login" class="font-semibold text-[#274333] hover:underline">&larr; Quay lại trang đăng nhập</a>
    </div>
  </div>
</div>
