/**
 * Reactive Auth & Session Store for Creativanta Web (P0-03)
 * Implements client fail-closed behavior, workspace discovery,
 * operator modes, and token lifecycle without trusting client claims.
 */

import { writable, type Readable } from 'svelte/store';
import {
  type AuthState,
  type AuthUser,
  type WorkspaceSummary,
  type OperatorMode,
  type SessionContext,
  type DiscoveryFetcher,
  CANONICAL_OPERATOR_MODES
} from './types';
import {
  getOrInitClerk,
  getClerkPublishableKey,
  mapClerkUser,
  resetClerkInstance,
  type ClerkBrowserInstance
} from './clerk';

const ACTIVE_WORKSPACE_STORAGE_KEY = 'creativanta_active_workspace_id';
const ACTIVE_MODE_STORAGE_KEY = 'creativanta_active_mode';

const initialState: SessionContext = {
  state: 'loading',
  user: null,
  token: null,
  activeWorkspace: null,
  workspaces: [],
  activeMode: 'creator',
  errorMessage: null,
  isDiscoveryLoading: false,
  discoveryError: null
};

export interface AuthStore extends Readable<SessionContext> {
  init: (options?: {
    publishableKey?: string;
    clerkInstance?: ClerkBrowserInstance;
    discoveryFetcher?: DiscoveryFetcher;
  }) => Promise<void>;
  selectWorkspace: (workspaceId: string) => Promise<WorkspaceSummary>;
  setOperatorMode: (mode: OperatorMode) => void;
  refreshSession: () => Promise<string | null>;
  signOut: () => Promise<void>;
  discoverWorkspaces: () => Promise<WorkspaceSummary[]>;
  reset: () => void;
}

/**
 * Default workspace discovery fetcher.
 * Calls the backend discovery endpoint with short-lived JWT.
 * Fails closed if backend is unmounted, unconfigured, or returns an error.
 */
export const defaultDiscoveryFetcher: DiscoveryFetcher = async (token: string) => {
  if (!token) {
    throw new Error('Missing bearer token for workspace discovery');
  }

  const apiOrigin = import.meta.env.VITE_API_ORIGIN || '';
  const endpoint = `${apiOrigin}/api/workspaces/discovery`;

  try {
    const res = await fetch(endpoint, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${token}`
      }
    });

    if (!res.ok) {
      if (res.status === 401 || res.status === 403) {
        throw new Error('Không có quyền truy cập hoặc phiên đã hết hạn');
      }
      if (res.status === 404 || res.status === 502 || res.status === 503) {
        throw new Error('Dịch vụ khám phá Workspace chưa khả dụng (P0-03 fail-closed)');
      }
      throw new Error(`Lỗi máy chủ khi khám phá workspace (${res.status})`);
    }

    const data = await res.json();
    if (!Array.isArray(data)) {
      return [];
    }

    return data.map((item: any) => ({
      id: String(item.id || item.ID || ''),
      name: String(item.name || item.Name || 'Workspace không tên'),
      role: String(item.role || item.Role || 'viewer'),
      plan: item.plan ? String(item.plan) : 'Starter',
      status: item.status || 'active'
    }));
  } catch (err: any) {
    // If running in development/disconnected shell and network fails:
    const msg = err?.message || 'Không thể kết nối dịch vụ khám phá Workspace (P0-03)';
    throw new Error(msg);
  }
};

export function createAuthStore(): AuthStore {
  const { subscribe, set, update } = writable<SessionContext>({ ...initialState });

  let activeClerk: ClerkBrowserInstance | null = null;
  let customDiscoveryFetcher: DiscoveryFetcher = defaultDiscoveryFetcher;
  let unsubscribeClerkListener: (() => void) | null = null;

  function loadPersistedMode(): OperatorMode {
    if (typeof localStorage === 'undefined') return 'creator';
    try {
      const saved = localStorage.getItem(ACTIVE_MODE_STORAGE_KEY) as OperatorMode | null;
      if (saved && CANONICAL_OPERATOR_MODES.some((m) => m.id === saved)) {
        return saved;
      }
    } catch {
      // ignore storage errors
    }
    return 'creator';
  }

  function getPersistedWorkspaceId(): string | null {
    if (typeof localStorage === 'undefined') return null;
    try {
      return localStorage.getItem(ACTIVE_WORKSPACE_STORAGE_KEY);
    } catch {
      return null;
    }
  }

  function setPersistedWorkspaceId(id: string | null): void {
    if (typeof localStorage === 'undefined') return;
    try {
      if (id) {
        localStorage.setItem(ACTIVE_WORKSPACE_STORAGE_KEY, id);
      } else {
        localStorage.removeItem(ACTIVE_WORKSPACE_STORAGE_KEY);
      }
    } catch {
      // ignore storage errors
    }
  }

  async function discoverWorkspacesInternal(token: string): Promise<WorkspaceSummary[]> {
    update((s) => ({ ...s, isDiscoveryLoading: true, discoveryError: null }));
    try {
      const items = await customDiscoveryFetcher(token);
      let selectedWorkspace: WorkspaceSummary | null = null;

      const savedId = getPersistedWorkspaceId();
      if (savedId) {
        const found = items.find((w) => w.id === savedId);
        if (found) {
          selectedWorkspace = found;
        }
      }

      // RULE-AUTH-003: If exactly 1 workspace, auto-select
      if (!selectedWorkspace && items.length === 1) {
        selectedWorkspace = items[0];
        setPersistedWorkspaceId(selectedWorkspace.id);
      }

      update((s) => ({
        ...s,
        workspaces: items,
        activeWorkspace: selectedWorkspace,
        isDiscoveryLoading: false,
        discoveryError: null
      }));

      return items;
    } catch (err: any) {
      const errorMsg = err?.message || 'Lỗi khi tải danh sách workspace';
      update((s) => ({
        ...s,
        workspaces: [],
        activeWorkspace: null,
        isDiscoveryLoading: false,
        discoveryError: errorMsg
      }));
      return [];
    }
  }

  return {
    subscribe,

    async init(options) {
      if (options?.discoveryFetcher) {
        customDiscoveryFetcher = options.discoveryFetcher;
      }

      const activeMode = loadPersistedMode();

      // Check publishable key
      const key = options?.publishableKey !== undefined ? options.publishableKey : getClerkPublishableKey();
      if (!key) {
        set({
          ...initialState,
          state: 'unconfigured',
          activeMode,
          errorMessage: 'Chưa cấu hình khóa định danh Clerk (VITE_CLERK_PUBLISHABLE_KEY)'
        });
        return;
      }

      try {
        update((s) => ({ ...s, state: 'loading', errorMessage: null }));

        const clerk = await getOrInitClerk(key, options?.clerkInstance);
        activeClerk = clerk;

        if (!clerk) {
          // SSR environment or initialization returned null
          set({
            ...initialState,
            state: 'unconfigured',
            activeMode,
            errorMessage: 'Chưa thể khởi tạo Clerk trong môi trường hiện tại'
          });
          return;
        }

        if (!clerk.loaded && typeof clerk.load === 'function') {
          await clerk.load();
        }

        // Setup listener for auth state updates
        if (unsubscribeClerkListener) {
          unsubscribeClerkListener();
          unsubscribeClerkListener = null;
        }

        if (typeof clerk.addListener === 'function') {
          unsubscribeClerkListener = clerk.addListener(async (emission) => {
            if (!emission.user || !emission.session) {
              update((s) => ({
                ...s,
                state: 'unauthenticated',
                user: null,
                token: null,
                activeWorkspace: null,
                workspaces: []
              }));
              setPersistedWorkspaceId(null);
            } else {
              try {
                const token = await emission.session.getToken();
                const user = mapClerkUser(emission.user);
                update((s) => ({
                  ...s,
                  state: token ? 'authenticated' : 'expired',
                  user,
                  token
                }));
                if (token) {
                  await discoverWorkspacesInternal(token);
                }
              } catch (err: any) {
                update((s) => ({
                  ...s,
                  state: 'expired',
                  errorMessage: err?.message || 'Phiên làm việc đã hết hạn'
                }));
              }
            }
          });
        }

        // Process current Clerk state
        if (!clerk.user || !clerk.session) {
          set({
            ...initialState,
            state: 'unauthenticated',
            activeMode,
            errorMessage: null
          });
          return;
        }

        const user = mapClerkUser(clerk.user);
        const token = await clerk.session.getToken();

        if (!token) {
          set({
            ...initialState,
            state: 'expired',
            user,
            activeMode,
            errorMessage: 'Phiên làm việc đã hết hạn hoặc không thể tạo token'
          });
          return;
        }

        set({
          ...initialState,
          state: 'authenticated',
          user,
          token,
          activeMode,
          errorMessage: null
        });

        // Trigger workspace discovery
        await discoverWorkspacesInternal(token);
      } catch (err: any) {
        console.error('[AUTH STORE] Init error:', err);
        set({
          ...initialState,
          state: 'error',
          activeMode,
          errorMessage: err?.message || 'Lỗi không xác định khi khởi tạo xác thực'
        });
      }
    },

    async selectWorkspace(workspaceId: string) {
      return new Promise<WorkspaceSummary>((resolve, reject) => {
        update((s) => {
          if (s.state !== 'authenticated') {
            reject(new Error('Yêu cầu đăng nhập trước khi chọn workspace (fail-closed)'));
            return s;
          }

          const target = s.workspaces.find((w) => w.id === workspaceId);
          if (!target) {
            // Principle: never trust client claims; cannot select non-member workspace
            reject(new Error(`Không tìm thấy quyền thành viên cho workspace ${workspaceId} (fail-closed)`));
            return s;
          }

          setPersistedWorkspaceId(target.id);
          resolve(target);
          return {
            ...s,
            activeWorkspace: target
          };
        });
      });
    },

    setOperatorMode(mode: OperatorMode) {
      if (!CANONICAL_OPERATOR_MODES.some((m) => m.id === mode)) {
        console.warn(`[AUTH] Invalid operator mode: ${mode}`);
        return;
      }

      if (typeof localStorage !== 'undefined') {
        try {
          localStorage.setItem(ACTIVE_MODE_STORAGE_KEY, mode);
        } catch {
          // ignore
        }
      }

      update((s) => ({ ...s, activeMode: mode }));
    },

    async refreshSession() {
      let currentSession = activeClerk?.session;
      if (!currentSession) {
        update((s) => ({
          ...s,
          state: 'expired',
          token: null,
          activeWorkspace: null,
          errorMessage: 'Không tìm thấy phiên làm việc'
        }));
        return null;
      }

      try {
        const freshToken = await currentSession.getToken({ skipCache: true });
        if (!freshToken) {
          update((s) => ({
            ...s,
            state: 'expired',
            token: null,
            activeWorkspace: null,
            errorMessage: 'Không thể làm mới token phiên'
          }));
          return null;
        }

        update((s) => ({
          ...s,
          state: 'authenticated',
          token: freshToken,
          errorMessage: null
        }));
        return freshToken;
      } catch (err: any) {
        update((s) => ({
          ...s,
          state: 'expired',
          token: null,
          activeWorkspace: null,
          errorMessage: err?.message || 'Phiên đã hết hạn'
        }));
        return null;
      }
    },

    async signOut() {
      if (activeClerk && typeof activeClerk.signOut === 'function') {
        try {
          await activeClerk.signOut();
        } catch (err) {
          console.warn('[AUTH] Error during Clerk signOut:', err);
        }
      }

      setPersistedWorkspaceId(null);
      resetClerkInstance();
      activeClerk = null;

      update((s) => ({
        ...initialState,
        state: 'unauthenticated',
        activeMode: s.activeMode,
        errorMessage: null
      }));
    },

    async discoverWorkspaces() {
      let currentToken: string | null = null;
      subscribe((s) => {
        currentToken = s.token;
      })();

      if (!currentToken) {
        throw new Error('Chưa đăng nhập — không thể khám phá workspace');
      }

      return discoverWorkspacesInternal(currentToken);
    },

    reset() {
      if (unsubscribeClerkListener) {
        unsubscribeClerkListener();
        unsubscribeClerkListener = null;
      }
      setPersistedWorkspaceId(null);
      resetClerkInstance();
      activeClerk = null;
      set({ ...initialState });
    }
  };
}

export const authStore = createAuthStore();
