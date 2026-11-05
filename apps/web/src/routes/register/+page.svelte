<script lang="ts">
  /**
   * Registration Screen (W002 /register)
   * Canonical spec: docs/03_screens/web/screen_web_auth_register.md
   * Implements live Clerk SignUp widget + email/OTP registration when Clerk is configured,
   * and fail-closed provider protection when unconfigured (UF-02).
   */
  import { onMount } from 'svelte';
  import { goto } from '$app/navigation';
  import {
    authStore,
    getOrInitClerk,
    startClerkEmailSignUp,
    verifyClerkEmailSignUpCode
  } from '$lib/auth';

  let clerkSignUpEl: HTMLDivElement | undefined = $state();
  let fullName = $state('');
  let email = $state('');
  let password = $state('');
  let verificationCode = $state('');
  let acceptedTerms = $state(false);
  let step = $state<'register' | 'verify_email' | 'complete'>('register');
  let isSubmitting = $state(false);
  let localError = $state<string | null>(null);
  let localNotice = $state<string | null>(null);

  onMount(() => {
    let cleanup: (() => void) | undefined;

    (async () => {
      await authStore.init();
      const clerk = await getOrInitClerk();
      if (clerk && clerkSignUpEl && typeof clerk.mountSignUp === 'function') {
        clerk.mountSignUp(clerkSignUpEl, {
          afterSignUpUrl: '/workspaces',
          signInUrl: '/login'
        });
        cleanup = () => {
          if (clerkSignUpEl && typeof clerk.unmountSignUp === 'function') {
            clerk.unmountSignUp(clerkSignUpEl);
          }
        };
      }
    })();

    return () => {
      if (cleanup) cleanup();
    };
  });

  async function handleRegister(e: SubmitEvent) {
    e.preventDefault();
    localError = null;
    localNotice = null;

    if (!acceptedTerms) {
      localError = 'Vui lòng đồng ý với Điều khoản dịch vụ và Chính sách bảo mật trước khi tiếp tục.';
      return;
    }

    if ($authStore.state === 'unconfigured') {
      localError =
        'Dịch vụ đăng ký Clerk chưa được cấu hình khóa VITE_CLERK_PUBLISHABLE_KEY (fail-closed). Thông tin nhập được giữ nguyên.';
      return;
    }

    isSubmitting = true;
    try {
      const result = await startClerkEmailSignUp({
        fullName,
        email,
        password
      });

      if (!result.ok) {
        localError = result.error || 'Đăng ký tài khoản thất bại. Thông tin nhập được giữ nguyên.';
        return;
      }

      if (result.step === 'complete') {
        step = 'complete';
        await authStore.init();
        await goto('/workspaces');
        return;
      }

      step = 'verify_email';
      localNotice = `Mã xác minh đã được gửi tới ${email}. Vui lòng nhập mã OTP để kích hoạt tài khoản.`;
    } finally {
      isSubmitting = false;
    }
  }

  async function handleVerifyCode(e: SubmitEvent) {
    e.preventDefault();
    localError = null;
    localNotice = null;

    if (!verificationCode.trim()) {
      localError = 'Vui lòng nhập mã xác minh gồm 6 chữ số.';
      return;
    }

    isSubmitting = true;
    try {
      const result = await verifyClerkEmailSignUpCode({
        code: verificationCode
      });

      if (!result.ok) {
        localError = result.error || 'Xác minh mã OTP thất bại.';
        return;
      }

      step = 'complete';
      await authStore.init();
      await goto('/workspaces');
    } finally {
      isSubmitting = false;
    }
  }
</script>

<svelte:head>
  <title>Đăng ký tài khoản — Creativanta</title>
</svelte:head>

<div class="mx-auto max-w-md py-8">
  <div class="rounded-3xl border border-[#e8e5dc] bg-[#fffefa] p-8 shadow-sm">
    <div class="mb-6">
      <p class="text-[11px] font-extrabold uppercase tracking-[0.2em] text-[#274333]">
        IDENTITY &amp; ONBOARDING · W002
      </p>
      <h1 class="mt-2 text-2xl font-bold tracking-tight text-[#242924]">Tạo tài khoản mới</h1>
      <p class="mt-1 text-sm text-[#7d837b]">
        Khởi tạo tài khoản để thiết lập Workspace đầu tiên và lựa chọn 1 trong 6 chế độ vận hành.
      </p>
    </div>

    {#if $authStore.state === 'unconfigured'}
      <div class="mb-6 rounded-2xl border border-amber-300 bg-amber-50/90 p-4 text-xs text-amber-900" role="alert">
        <p class="font-bold">Chế độ bảo vệ Fail-Closed (Chưa cấu hình Clerk)</p>
        <p class="mt-1 leading-relaxed">
          Hệ thống từ chối tạo tài khoản giả lập khi chưa có kết nối Clerk thực tế
          (<code class="rounded bg-amber-100 px-1 py-0.5 font-mono">VITE_CLERK_PUBLISHABLE_KEY</code>).
        </p>
      </div>
    {/if}

    <!-- Official Clerk SignUp Mount Target -->
    <div bind:this={clerkSignUpEl} class="mb-4"></div>

    {#if localError}
      <div class="mb-5 rounded-xl border border-red-200 bg-red-50 p-3.5 text-xs text-red-800" role="alert">
        {localError}
      </div>
    {/if}

    {#if localNotice}
      <div class="mb-5 rounded-xl border border-emerald-200 bg-emerald-50 p-3.5 text-xs text-emerald-900" role="status">
        {localNotice}
      </div>
    {/if}

    {#if step === 'register'}
      <form onsubmit={handleRegister} class="space-y-4">
        <div>
          <label for="reg-name" class="block text-xs font-semibold text-[#242924]">
            Họ và tên / Tên hiển thị
          </label>
          <input
            id="reg-name"
            type="text"
            bind:value={fullName}
            required
            placeholder="Nguyễn Văn A"
            class="mt-1.5 w-full rounded-xl border border-[#dcd8cc] bg-white px-3.5 py-2.5 text-sm text-[#242924] focus:border-[#274333] focus:outline-none focus:ring-2 focus:ring-[#274333]/20"
          />
        </div>

        <div>
          <label for="reg-email" class="block text-xs font-semibold text-[#242924]">
            Địa chỉ Email
          </label>
          <input
            id="reg-email"
            type="email"
            bind:value={email}
            required
            autocomplete="email"
            placeholder="you@brand.vn"
            class="mt-1.5 w-full rounded-xl border border-[#dcd8cc] bg-white px-3.5 py-2.5 text-sm text-[#242924] focus:border-[#274333] focus:outline-none focus:ring-2 focus:ring-[#274333]/20"
          />
        </div>

        <div>
          <label for="reg-password" class="block text-xs font-semibold text-[#242924]">
            Mật khẩu (tối thiểu 8 ký tự)
          </label>
          <input
            id="reg-password"
            type="password"
            bind:value={password}
            minlength="8"
            required
            autocomplete="new-password"
            placeholder="••••••••"
            class="mt-1.5 w-full rounded-xl border border-[#dcd8cc] bg-white px-3.5 py-2.5 text-sm text-[#242924] focus:border-[#274333] focus:outline-none focus:ring-2 focus:ring-[#274333]/20"
          />
        </div>

        <label class="flex items-start gap-2.5 pt-1 text-xs text-[#525850]">
          <input
            type="checkbox"
            bind:checked={acceptedTerms}
            class="mt-0.5 rounded border-[#dcd8cc] text-[#274333] focus:ring-[#274333]"
          />
          <span>
            Tôi đồng ý với Điều khoản dịch vụ và Chính sách bảo mật dữ liệu của Creativanta.
          </span>
        </label>

        <button
          type="submit"
          disabled={isSubmitting}
          class="w-full rounded-xl bg-[#274333] px-4 py-2.5 text-sm font-semibold text-white transition hover:bg-[#1e3428] disabled:opacity-50"
        >
          {isSubmitting ? 'Đang xử lý với Clerk...' : 'Đăng ký tài khoản'}
        </button>
      </form>
    {:else if step === 'verify_email'}
      <form onsubmit={handleVerifyCode} class="space-y-4">
        <div>
          <label for="reg-otp" class="block text-xs font-semibold text-[#242924]">
            Mã xác minh Email (OTP)
          </label>
          <input
            id="reg-otp"
            type="text"
            inputmode="numeric"
            bind:value={verificationCode}
            required
            placeholder="123456"
            class="mt-1.5 w-full rounded-xl border border-[#dcd8cc] bg-white px-3.5 py-2.5 text-sm font-mono tracking-widest text-[#242924] focus:border-[#274333] focus:outline-none focus:ring-2 focus:ring-[#274333]/20"
          />
        </div>

        <div class="flex gap-2">
          <button
            type="button"
            onclick={() => (step = 'register')}
            class="rounded-xl border border-[#dcd8cc] px-4 py-2.5 text-xs font-semibold text-[#525850] hover:bg-[#f4f1ea]"
          >
            Quay lại
          </button>
          <button
            type="submit"
            disabled={isSubmitting}
            class="flex-1 rounded-xl bg-[#274333] px-4 py-2.5 text-sm font-semibold text-white transition hover:bg-[#1e3428] disabled:opacity-50"
          >
            {isSubmitting ? 'Đang xác minh...' : 'Xác minh & Tiếp tục tới Workspace'}
          </button>
        </div>
      </form>
    {/if}

    <div class="mt-6 border-t border-[#e8e5dc] pt-4 text-center text-xs text-[#7d837b]">
      Đã có tài khoản?
      <a href="/login" class="font-semibold text-[#274333] hover:underline">Đăng nhập</a>
    </div>
  </div>
</div>
