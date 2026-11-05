/**
 * Browser-only Clerk SDK integration for Creativanta Web (P0-03)
 * Fail-closed: Never runs in SSR; never embeds hardcoded secrets;
 * returns unconfigured state if VITE_CLERK_PUBLISHABLE_KEY is absent.
 */

import type { AuthUser } from './types';

export interface ClerkSignUpResource {
  status?: string;
  createdSessionId?: string | null;
  create: (params: {
    emailAddress: string;
    password: string;
    firstName?: string;
    lastName?: string;
  }) => Promise<{ status?: string; createdSessionId?: string | null }>;
  prepareEmailAddressVerification?: (params?: { strategy?: string }) => Promise<unknown>;
  attemptEmailAddressVerification?: (params: {
    code: string;
  }) => Promise<{ status?: string; createdSessionId?: string | null }>;
}

export interface ClerkSignInResource {
  status?: string;
  createdSessionId?: string | null;
  create: (params: {
    strategy?: string;
    identifier: string;
    password?: string;
  }) => Promise<{ status?: string; createdSessionId?: string | null }>;
  attemptFirstFactor?: (params: {
    strategy: string;
    code: string;
    password?: string;
  }) => Promise<{ status?: string; createdSessionId?: string | null }>;
}

// Minimal interface for Clerk browser instance
export interface ClerkBrowserInstance {
  loaded: boolean;
  user: {
    id: string;
    primaryEmailAddress?: { emailAddress: string };
    fullName?: string | null;
    imageUrl?: string;
  } | null;
  session: {
    id: string;
    status: string;
    getToken: (options?: { template?: string; skipCache?: boolean }) => Promise<string | null>;
  } | null;
  client?: {
    signUp?: ClerkSignUpResource;
    signIn?: ClerkSignInResource;
  };
  setActive?: (params: { session: string | null }) => Promise<void>;
  load: (options?: Record<string, unknown>) => Promise<void>;
  signOut: () => Promise<void>;
  addListener: (callback: (emission: { user: any; session: any }) => void) => () => void;
  mountSignIn?: (node: HTMLElement, props?: Record<string, unknown>) => void;
  unmountSignIn?: (node: HTMLElement) => void;
  mountSignUp?: (node: HTMLElement, props?: Record<string, unknown>) => void;
  unmountSignUp?: (node: HTMLElement) => void;
}

let clerkInstance: ClerkBrowserInstance | null = null;
let initPromise: Promise<ClerkBrowserInstance | null> | null = null;

/**
 * Safely retrieve the publishable key from environment.
 * Rejects empty, whitespace-only, or suspicious secret values.
 */
export function getClerkPublishableKey(): string | null {
  const key = (import.meta.env.VITE_CLERK_PUBLISHABLE_KEY || '').trim();
  if (!key) {
    return null;
  }
  // Hard validation: must be a publishable key, never a secret key
  if (key.startsWith('sk_') || key.includes('secret')) {
    console.error('[AUTH SECURITY] Detected invalid key prefix. Never provide Clerk Secret Keys to client bundle.');
    return null;
  }
  return key;
}

/**
 * Initialize Clerk in the browser only.
 * Returns null if running in SSR, or if publishable key is missing.
 */
export async function getOrInitClerk(
  injectedKey?: string,
  injectedClerk?: ClerkBrowserInstance
): Promise<ClerkBrowserInstance | null> {
  // 1. Check for injected instance first (used in unit tests)
  if (injectedClerk) {
    clerkInstance = injectedClerk;
    return clerkInstance;
  }

  // 2. If already initialized, return cached instance
  if (clerkInstance) {
    return clerkInstance;
  }

  // 3. SSR Guard: fail-closed on server
  if (typeof window === 'undefined') {
    return null;
  }

  // 4. Validate publishable key
  const publishableKey = injectedKey ?? getClerkPublishableKey();
  if (!publishableKey) {
    return null;
  }

  if (initPromise) {
    return initPromise;
  }

  initPromise = (async () => {
    try {
      // Dynamic import to guarantee browser-only bundle evaluation
      const { Clerk } = await import('@clerk/clerk-js');
      const clerk = new Clerk(publishableKey);
      await clerk.load();
      clerkInstance = clerk as unknown as ClerkBrowserInstance;
      return clerkInstance;
    } catch (err) {
      console.error('[AUTH] Failed to initialize Clerk SDK:', err);
      initPromise = null;
      throw err;
    }
  })();

  return initPromise;
}

/**
 * Retrieve the currently cached Clerk browser instance without triggering network load.
 */
export function getCachedClerkInstance(): ClerkBrowserInstance | null {
  return clerkInstance;
}

/**
 * Retrieve the current short-lived Clerk session JWT token if a session is active.
 */
export async function getClerkSessionToken(): Promise<string | null> {
  if (!clerkInstance?.session) {
    return null;
  }
  try {
    return await clerkInstance.session.getToken();
  } catch {
    return null;
  }
}

/**
 * Reset cached Clerk instance (useful for tests and clean transitions).
 */
export function resetClerkInstance(): void {
  clerkInstance = null;
  initPromise = null;
}

/**
 * Maps a Clerk user object to the application's AuthUser.
 */
export function mapClerkUser(user: ClerkBrowserInstance['user']): AuthUser | null {
  if (!user || !user.id) {
    return null;
  }
  return {
    id: user.id,
    email: user.primaryEmailAddress?.emailAddress,
    fullName: user.fullName || undefined,
    imageUrl: user.imageUrl
  };
}

export interface ClerkSignUpFlowResult {
  ok: boolean;
  step: 'verification_required' | 'complete' | 'failed';
  sessionId?: string | null;
  error?: string;
}

/**
 * Executes Clerk email/password sign-up and triggers email verification code when required.
 * Fails closed when Clerk is unconfigured or when client.signUp is unavailable.
 */
export async function startClerkEmailSignUp(params: {
  fullName: string;
  email: string;
  password: string;
  clerk?: ClerkBrowserInstance | null;
}): Promise<ClerkSignUpFlowResult> {
  const clerk = params.clerk ?? (await getOrInitClerk());
  if (!clerk || !clerk.client?.signUp) {
    return {
      ok: false,
      step: 'failed',
      error: 'Cổng đăng ký Clerk chưa được cấu hình hoặc chưa sẵn sàng (fail-closed).'
    };
  }

  const trimmedName = params.fullName.trim();
  const [firstName, ...rest] = trimmedName.split(/\s+/);
  const lastName = rest.length > 0 ? rest.join(' ') : undefined;

  try {
    const res = await clerk.client.signUp.create({
      emailAddress: params.email.trim(),
      password: params.password,
      firstName: firstName || undefined,
      lastName
    });

    if (res.status === 'complete') {
      if (res.createdSessionId && clerk.setActive) {
        await clerk.setActive({ session: res.createdSessionId });
      }
      return {
        ok: true,
        step: 'complete',
        sessionId: res.createdSessionId ?? null
      };
    }

    if (clerk.client.signUp.prepareEmailAddressVerification) {
      await clerk.client.signUp.prepareEmailAddressVerification({ strategy: 'email_code' });
    }

    return {
      ok: true,
      step: 'verification_required'
    };
  } catch (err) {
    const msg = err instanceof Error ? err.message : 'Đăng ký tài khoản thất bại.';
    return {
      ok: false,
      step: 'failed',
      error: msg
    };
  }
}

/**
 * Verifies the Clerk email OTP code during registration and activates the session.
 */
export async function verifyClerkEmailSignUpCode(params: {
  code: string;
  clerk?: ClerkBrowserInstance | null;
}): Promise<ClerkSignUpFlowResult> {
  const clerk = params.clerk ?? (await getOrInitClerk());
  if (!clerk || !clerk.client?.signUp?.attemptEmailAddressVerification) {
    return {
      ok: false,
      step: 'failed',
      error: 'Cổng xác minh email Clerk chưa sẵn sàng (fail-closed).'
    };
  }

  try {
    const res = await clerk.client.signUp.attemptEmailAddressVerification({
      code: params.code.trim()
    });

    if (res.status === 'complete') {
      if (res.createdSessionId && clerk.setActive) {
        await clerk.setActive({ session: res.createdSessionId });
      }
      return {
        ok: true,
        step: 'complete',
        sessionId: res.createdSessionId ?? null
      };
    }

    return {
      ok: false,
      step: 'failed',
      error: 'Mã xác minh chưa hoàn tất. Vui lòng kiểm tra lại mã OTP.'
    };
  } catch (err) {
    const msg = err instanceof Error ? err.message : 'Mã xác minh không hợp lệ hoặc đã hết hạn.';
    return {
      ok: false,
      step: 'failed',
      error: msg
    };
  }
}

export interface ClerkPasswordRecoveryResult {
  ok: boolean;
  step: 'code_sent' | 'complete' | 'expired' | 'failed';
  sessionId?: string | null;
  error?: string;
}

/**
 * Initiates Clerk password reset (`reset_password_email_code`).
 * Fails closed when Clerk is unconfigured.
 */
export async function requestClerkPasswordResetCode(params: {
  email: string;
  clerk?: ClerkBrowserInstance | null;
}): Promise<ClerkPasswordRecoveryResult> {
  const clerk = params.clerk ?? (await getOrInitClerk());
  if (!clerk || !clerk.client?.signIn) {
    return {
      ok: false,
      step: 'failed',
      error: 'Dịch vụ khôi phục mật khẩu Clerk chưa được cấu hình (fail-closed).'
    };
  }

  try {
    await clerk.client.signIn.create({
      strategy: 'reset_password_email_code',
      identifier: params.email.trim()
    });
    return {
      ok: true,
      step: 'code_sent'
    };
  } catch (err) {
    const msg = err instanceof Error ? err.message : 'Không thể gửi mã khôi phục mật khẩu.';
    return {
      ok: false,
      step: 'failed',
      error: msg
    };
  }
}

/**
 * Completes Clerk password reset with email code and new password.
 * Detects expired codes (`expired` / `code_expired`) and surfaces `Recovery expired`.
 */
export async function confirmClerkPasswordResetCode(params: {
  code: string;
  newPassword: string;
  clerk?: ClerkBrowserInstance | null;
}): Promise<ClerkPasswordRecoveryResult> {
  const clerk = params.clerk ?? (await getOrInitClerk());
  if (!clerk || !clerk.client?.signIn?.attemptFirstFactor) {
    return {
      ok: false,
      step: 'failed',
      error: 'Dịch vụ đặt lại mật khẩu Clerk chưa sẵn sàng (fail-closed).'
    };
  }

  try {
    const res = await clerk.client.signIn.attemptFirstFactor({
      strategy: 'reset_password_email_code',
      code: params.code.trim(),
      password: params.newPassword
    });

    if (res.status === 'complete') {
      if (res.createdSessionId && clerk.setActive) {
        await clerk.setActive({ session: res.createdSessionId });
      }
      return {
        ok: true,
        step: 'complete',
        sessionId: res.createdSessionId ?? null
      };
    }

    return {
      ok: false,
      step: 'failed',
      error: 'Chưa thể hoàn tất đặt lại mật khẩu. Vui lòng kiểm tra mã xác thực.'
    };
  } catch (err) {
    const rawMsg = err instanceof Error ? err.message : 'Đặt lại mật khẩu thất bại.';
    const isExpired = /expired|hết hạn/i.test(rawMsg);
    return {
      ok: false,
      step: isExpired ? 'expired' : 'failed',
      error: isExpired
        ? 'Recovery expired: Mã khôi phục đã hết hạn (quá 60 phút). Vui lòng yêu cầu gửi lại mã mới.'
        : rawMsg
    };
  }
}
