/**
 * Browser-only Clerk SDK integration for Creativanta Web (P0-03)
 * Fail-closed: Never runs in SSR; never embeds hardcoded secrets;
 * returns unconfigured state if VITE_CLERK_PUBLISHABLE_KEY is absent.
 */

import type { AuthUser } from './types';

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
  load: (options?: Record<string, unknown>) => Promise<void>;
  signOut: () => Promise<void>;
  addListener: (callback: (emission: { user: any; session: any }) => void) => () => void;
  mountSignIn?: (node: HTMLElement, props?: Record<string, unknown>) => void;
  unmountSignIn?: (node: HTMLElement) => void;
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
