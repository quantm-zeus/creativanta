/**
 * Reactive Auth & Session Store for Creativanta Web (P0-03)
 * Implements client fail-closed behavior, workspace discovery,
 * first-workspace onboarding, unified 6-mode synchronization,
 * safe internal redirect validation, and token lifecycle without trusting client claims.
 */

import { writable, get, type Readable } from 'svelte/store';
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
import {
  modeStore,
  readPersistedOperatorMode,
  persistOperatorMode
} from '$lib/constants/modes';

const ACTIVE_WORKSPACE_STORAGE_KEY = 'creativanta_active_workspace_id';

/**
 * Validates and sanitizes post-login redirect targets (UF-10).
 * Rejects external origins, protocol-relative URLs (`//`), backslash paths (`/\`),
 * javascript:/data: schemes, and control characters. Allows only internal `/...` paths.
 */
export function sanitizeRedirectTarget(
  raw: string | null | undefined,
  fallback = '/workspaces'
): string {
  if (!raw || typeof raw !== 'string') {
    return fallback;
  }
  const trimmed = raw.trim();
  if (!trimmed.startsWith('/')) {
    return fallback;
  }
  if (trimmed.startsWith('//') || trimmed.startsWith('/\\')) {
    return fallback;
  }
  if (/\\|%5c/i.test(trimmed) || /^\/%2f/i.test(trimmed)) {
    return fallback;
  }
  try {
    const decoded = decodeURIComponent(trimmed);
    if (decoded.startsWith('//') || decoded.startsWith('/\\') || decoded.includes('\\')) {
      return fallback;
    }
  } catch {
    return fallback;
  }
  if (/[\u0000-\u001F\u007F]/.test(trimmed)) {
    return fallback;
  }
  if (/^[a-zA-Z][a-zA-Z0-9+.-]*:/.test(trimmed)) {
    return fallback;
  }
  try {
    const parsed = new URL(trimmed, 'https://creativanta.internal');
    if (parsed.origin !== 'https://creativanta.internal') {
      return fallback;
    }
    return `${parsed.pathname}${parsed.search}${parsed.hash}`;
  } catch {
    return fallback;
  }
}

export interface CreateWorkspaceInput {
  displayName: string;
  slug?: string;
  defaultOperatorMode?: OperatorMode;
  timezone?: string;
  locale?: string;
}

export interface CreateWorkspaceResult {
  ok: boolean;
  workspace?: WorkspaceSummary;
  stale?: boolean;
  error?: string;
}

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
  createWorkspace: (
    input: CreateWorkspaceInput,
    customFetch?: typeof fetch
  ) => Promise<CreateWorkspaceResult>;
  setOperatorMode: (mode: OperatorMode) => void;
  refreshSession: () => Promise<string | null>;
  signOut: () => Promise<void>;
  discoverWorkspaces: () => Promise<WorkspaceSummary[]>;
  getSnapshot: () => SessionContext;
  reset: () => void;
}

export function parseWorkspaceDiscoveryPayload(data: unknown): WorkspaceSummary[] {
  let rawItems: unknown[];
  if (Array.isArray(data)) {
    rawItems = data;
  } else if (data && typeof data === 'object' && 'workspaces' in data) {
    const wsField = (data as Record<string, unknown>).workspaces;
    if (wsField === null || wsField === undefined) {
      rawItems = [];
    } else if (Array.isArray(wsField)) {
      rawItems = wsField;
    } else {
      throw new Error(
        'Phản hồi khám phá Workspace không đúng định dạng hợp đồng (workspaces phải là danh sách, fail-closed)'
      );
    }
  } else {
    throw new Error('Phản hồi khám phá Workspace không đúng định dạng hợp đồng (fail-closed)');
  }

  return rawItems.map((raw) => {
    if (!raw || typeof raw !== 'object') {
      throw new Error('Phần tử Workspace trong phản hồi khám phá không hợp lệ (fail-closed)');
    }
    const item = raw as Record<string, unknown>;
    const id = String(
      item.workspace_id || item.workspaceId || item.id || item.ID || ''
    ).trim();
    if (!id) {
      throw new Error('Phản hồi khám phá Workspace thiếu workspace_id hợp lệ (fail-closed)');
    }
    const name =
      String(
        item.display_name || item.displayName || item.name || item.Name || ''
      ).trim() || 'Workspace không tên';
    const role = String(item.role || item.Role || 'viewer').trim() || 'viewer';
    const plan =
      String(item.plan_tier || item.planTier || item.plan || item.Plan || 'Starter').trim() ||
      'Starter';
    const statusRaw = String(item.status || item.Status || 'active')
      .trim()
      .toLowerCase();
    const status: WorkspaceSummary['status'] =
      statusRaw === 'suspended'
        ? 'suspended'
        : statusRaw === 'deactivated'
          ? 'deactivated'
          : 'active';

    return {
      id,
      name,
      role,
      plan,
      status
    };
  });
}

type AuthResetHook = () => void;
const authResetHooks = new Set<AuthResetHook>();

export function registerAuthResetHook(hook: AuthResetHook): () => void {
  authResetHooks.add(hook);
  return () => {
    authResetHooks.delete(hook);
  };
}

function runAuthResetHooks(): void {
  for (const hook of authResetHooks) {
    try {
      hook();
    } catch {
      // ignore individual store reset errors
    }
  }
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
    return parseWorkspaceDiscoveryPayload(data);
  } catch (err: any) {
    const msg = err?.message || 'Không thể kết nối dịch vụ khám phá Workspace (P0-03)';
    throw new Error(msg);
  }
};

export function slugifyWorkspaceName(name: string): string {
  return name
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/đ/g, 'd')
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
    .slice(0, 48);
}

export function createAuthStore(): AuthStore {
  const store = writable<SessionContext>({
    ...initialState,
    activeMode: readPersistedOperatorMode()
  });
  const { subscribe, set, update } = store;

  let activeClerk: ClerkBrowserInstance | null = null;
  let customDiscoveryFetcher: DiscoveryFetcher = defaultDiscoveryFetcher;
  let unsubscribeClerkListener: (() => void) | null = null;
  let authEpoch = 0;

  // Keep authStore.activeMode synchronized whenever modeStore changes (UF-09)
  modeStore.subscribe((mode) => {
    update((s) => (s.activeMode === mode ? s : { ...s, activeMode: mode }));
  });

  function loadPersistedMode(): OperatorMode {
    return modeStore.syncFromStorage();
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

  async function discoverWorkspacesInternal(
    token: string,
    expectedEpoch?: number
  ): Promise<WorkspaceSummary[]> {
    const targetEpoch = expectedEpoch ?? authEpoch;
    if (targetEpoch !== authEpoch) {
      return [];
    }

    update((s) => ({ ...s, isDiscoveryLoading: true, discoveryError: null }));
    try {
      const items = await customDiscoveryFetcher(token);
      if (targetEpoch !== authEpoch || get(store).state !== 'authenticated') {
        return [];
      }

      let selectedWorkspace: WorkspaceSummary | null = null;

      const savedId = getPersistedWorkspaceId();
      if (savedId) {
        const found = items.find((w) => w.id === savedId);
        if (found) {
          selectedWorkspace = found;
        } else {
          // Clear stale persisted workspace ID that does not belong to discovered memberships
          setPersistedWorkspaceId(null);
        }
      }

      // RULE-AUTH-003: If exactly 1 workspace, auto-select
      if (!selectedWorkspace && items.length === 1) {
        selectedWorkspace = items[0];
        setPersistedWorkspaceId(selectedWorkspace.id);
      }

      const previousWorkspaceId = get(store).activeWorkspace?.id ?? null;
      const nextWorkspaceId = selectedWorkspace?.id ?? null;
      if (previousWorkspaceId && previousWorkspaceId !== nextWorkspaceId) {
        runAuthResetHooks();
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
      if (targetEpoch !== authEpoch) {
        return [];
      }
      if (get(store).activeWorkspace) {
        runAuthResetHooks();
      }
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

    getSnapshot(): SessionContext {
      return get(store);
    },

    async init(options) {
      const myEpoch = ++authEpoch;
      if (options?.discoveryFetcher) {
        customDiscoveryFetcher = options.discoveryFetcher;
      }

      const activeMode = loadPersistedMode();

      // Check publishable key
      const key =
        options?.publishableKey !== undefined ? options.publishableKey : getClerkPublishableKey();
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
        if (myEpoch !== authEpoch) return;
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
          if (myEpoch !== authEpoch) return;
        }

        // Setup listener for auth state updates
        if (unsubscribeClerkListener) {
          unsubscribeClerkListener();
          unsubscribeClerkListener = null;
        }

        if (typeof clerk.addListener === 'function') {
          unsubscribeClerkListener = clerk.addListener(async (emission) => {
            const emissionEpoch = ++authEpoch;
            if (!emission.user || !emission.session) {
              setPersistedWorkspaceId(null);
              runAuthResetHooks();
              update((s) => ({
                ...s,
                state: 'unauthenticated',
                user: null,
                token: null,
                activeWorkspace: null,
                workspaces: [],
                isDiscoveryLoading: false,
                discoveryError: null
              }));
            } else {
              const nextUser = mapClerkUser(emission.user);
              const previousUserId = get(store).user?.id;
              const isSubjectSwitch = Boolean(
                previousUserId && nextUser?.id && previousUserId !== nextUser.id
              );
              if (isSubjectSwitch) {
                setPersistedWorkspaceId(null);
                runAuthResetHooks();
                update((s) => ({
                  ...s,
                  user: nextUser,
                  token: null,
                  activeWorkspace: null,
                  workspaces: [],
                  isDiscoveryLoading: true,
                  discoveryError: null
                }));
              }
              try {
                const token = await emission.session.getToken();
                if (emissionEpoch !== authEpoch) return;
                if (!token) {
                  runAuthResetHooks();
                }
                update((s) => ({
                  ...s,
                  state: token ? 'authenticated' : 'expired',
                  user: nextUser,
                  token,
                  activeWorkspace: token && !isSubjectSwitch ? s.activeWorkspace : null,
                  workspaces: token && !isSubjectSwitch ? s.workspaces : []
                }));
                if (token) {
                  await discoverWorkspacesInternal(token, emissionEpoch);
                }
              } catch (err: any) {
                if (emissionEpoch !== authEpoch) return;
                runAuthResetHooks();
                update((s) => ({
                  ...s,
                  state: 'expired',
                  token: null,
                  activeWorkspace: null,
                  errorMessage: err?.message || 'Phiên làm việc đã hết hạn'
                }));
              }
            }
          });
        }

        // Process current Clerk state
        if (!clerk.user || !clerk.session) {
          runAuthResetHooks();
          set({
            ...initialState,
            state: 'unauthenticated',
            activeMode,
            errorMessage: null
          });
          return;
        }

        const user = mapClerkUser(clerk.user);
        const previousUserId = get(store).user?.id;
        if (previousUserId && user?.id && previousUserId !== user.id) {
          setPersistedWorkspaceId(null);
          runAuthResetHooks();
        }

        const token = await clerk.session.getToken();
        if (myEpoch !== authEpoch) return;

        if (!token) {
          runAuthResetHooks();
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
        await discoverWorkspacesInternal(token, myEpoch);
      } catch (err: any) {
        if (myEpoch !== authEpoch) return;
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
            reject(
              new Error(`Không tìm thấy quyền thành viên cho workspace ${workspaceId} (fail-closed)`)
            );
            return s;
          }

          if (s.activeWorkspace?.id && s.activeWorkspace.id !== target.id) {
            runAuthResetHooks();
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

    async createWorkspace(
      input: CreateWorkspaceInput,
      customFetch?: typeof fetch
    ): Promise<CreateWorkspaceResult> {
      const snapshot = get(store);
      if (snapshot.state !== 'authenticated' || !snapshot.token || !snapshot.user?.id) {
        return {
          ok: false,
          error: 'Yêu cầu đăng nhập hợp lệ trước khi tạo Workspace mới (fail-closed).'
        };
      }

      const requestEpoch = authEpoch;
      const requestUserId = snapshot.user.id;
      const isStaleCreateSession = (): boolean => {
        const current = get(store);
        return (
          requestEpoch !== authEpoch ||
          current.state !== 'authenticated' ||
          !current.user?.id ||
          current.user.id !== requestUserId
        );
      };

      const displayName = (input.displayName || '').trim();
      if (displayName.length < 2) {
        return {
          ok: false,
          error: 'Tên Workspace phải có ít nhất 2 ký tự.'
        };
      }

      const slug = input.slug?.trim() || slugifyWorkspaceName(displayName);
      if (!slug || slug.length < 2) {
        return {
          ok: false,
          error: 'Định danh slug không hợp lệ (chỉ dùng chữ thường, số và dấu gạch ngang).'
        };
      }

      const chosenMode: OperatorMode =
        input.defaultOperatorMode &&
        CANONICAL_OPERATOR_MODES.some((m) => m.id === input.defaultOperatorMode)
          ? input.defaultOperatorMode
          : snapshot.activeMode;

      const fetchImpl = customFetch ?? (typeof fetch !== 'undefined' ? fetch : undefined);
      if (!fetchImpl) {
        return {
          ok: false,
          error: 'Không có kết nối mạng để tạo Workspace.'
        };
      }

      const apiOrigin = (import.meta.env.VITE_API_ORIGIN || '').replace(/\/+$/, '');
      const endpoint = `${apiOrigin}/creativanta.workspace.v1.WorkspaceService/Create`;
      const idempotencyKey = `ws-create-${slug}-${Date.now()}`;

      try {
        const res = await fetchImpl(endpoint, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            Accept: 'application/json',
            'Connect-Protocol-Version': '1',
            Authorization: `Bearer ${snapshot.token}`,
            'X-Idempotency-Key': idempotencyKey
          },
          body: JSON.stringify({
            idempotency_key: idempotencyKey,
            display_name: displayName,
            slug,
            default_operator_mode: chosenMode,
            timezone: input.timezone || 'Asia/Ho_Chi_Minh',
            locale: input.locale || 'vi-VN'
          })
        });

        if (isStaleCreateSession()) {
          return {
            ok: false,
            stale: true,
            error: 'Phiên đăng nhập đã thay đổi trong khi tạo Workspace (fail-closed).'
          };
        }

        let payload: any = null;
        try {
          payload = await res.json();
        } catch {
          payload = null;
        }

        if (isStaleCreateSession()) {
          return {
            ok: false,
            stale: true,
            error: 'Phiên đăng nhập đã thay đổi trong khi tạo Workspace (fail-closed).'
          };
        }

        if (!res.ok) {
          const serverMessage =
            (payload && typeof payload.message === 'string' && payload.message) ||
            (res.status === 404
              ? 'Dịch vụ WorkspaceService/Create chưa được gắn kết trên máy chủ hiện tại. Thông tin bạn nhập đã được giữ nguyên.'
              : `Không thể tạo Workspace (${res.status}). Thông tin bạn nhập đã được giữ nguyên.`);
          return {
            ok: false,
            error: serverMessage
          };
        }

        const wsObj = payload?.workspace || payload;
        const createdId = String(wsObj?.workspace_id || wsObj?.id || '');
        if (!createdId) {
          return {
            ok: false,
            error: 'Phản hồi máy chủ thiếu mã định danh workspace_id (fail-closed).'
          };
        }

        const createdSummary: WorkspaceSummary = {
          id: createdId,
          name: String(wsObj?.display_name || wsObj?.name || displayName),
          role: 'owner',
          plan: String(wsObj?.plan_tier || wsObj?.plan || 'Starter'),
          status: 'active'
        };

        if (isStaleCreateSession()) {
          return {
            ok: false,
            stale: true,
            error: 'Phiên đăng nhập đã thay đổi trong khi tạo Workspace (fail-closed).'
          };
        }

        setPersistedWorkspaceId(createdSummary.id);
        persistOperatorMode(chosenMode);
        modeStore.setMode(chosenMode);

        update((s) => {
          const exists = s.workspaces.some((w) => w.id === createdSummary.id);
          const nextWorkspaces = exists ? s.workspaces : [...s.workspaces, createdSummary];
          return {
            ...s,
            workspaces: nextWorkspaces,
            activeWorkspace: createdSummary,
            activeMode: chosenMode,
            discoveryError: null
          };
        });

        return {
          ok: true,
          workspace: createdSummary
        };
      } catch (err: any) {
        if (isStaleCreateSession()) {
          return {
            ok: false,
            stale: true,
            error: 'Phiên đăng nhập đã thay đổi trong khi tạo Workspace (fail-closed).'
          };
        }
        return {
          ok: false,
          error:
            err?.message ||
            'Không thể kết nối tới dịch vụ tạo Workspace. Thông tin bạn nhập đã được giữ nguyên.'
        };
      }
    },

    setOperatorMode(mode: OperatorMode) {
      if (!CANONICAL_OPERATOR_MODES.some((m) => m.id === mode)) {
        console.warn(`[AUTH] Invalid operator mode: ${mode}`);
        return;
      }

      persistOperatorMode(mode);
      modeStore.setMode(mode);
      update((s) => ({ ...s, activeMode: mode }));
    },

    async refreshSession() {
      const refreshEpoch = authEpoch;
      const currentSession = activeClerk?.session;
      if (!currentSession || get(store).state === 'unauthenticated') {
        runAuthResetHooks();
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
        if (refreshEpoch !== authEpoch || get(store).state === 'unauthenticated') {
          return null;
        }
        if (!freshToken) {
          runAuthResetHooks();
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
        if (refreshEpoch !== authEpoch || get(store).state === 'unauthenticated') {
          return null;
        }
        runAuthResetHooks();
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
      ++authEpoch;
      if (unsubscribeClerkListener) {
        unsubscribeClerkListener();
        unsubscribeClerkListener = null;
      }

      const clerkToSignOut = activeClerk;
      activeClerk = null;
      setPersistedWorkspaceId(null);
      resetClerkInstance();
      runAuthResetHooks();

      update((s) => ({
        ...initialState,
        state: 'unauthenticated',
        activeMode: s.activeMode,
        errorMessage: null
      }));

      if (clerkToSignOut && typeof clerkToSignOut.signOut === 'function') {
        try {
          await clerkToSignOut.signOut();
        } catch (err) {
          console.warn('[AUTH] Error during Clerk signOut:', err);
        }
      }
    },

    async discoverWorkspaces() {
      const currentToken = get(store).token;

      if (!currentToken) {
        throw new Error('Chưa đăng nhập — không thể khám phá workspace');
      }

      return discoverWorkspacesInternal(currentToken, authEpoch);
    },

    reset() {
      ++authEpoch;
      if (unsubscribeClerkListener) {
        unsubscribeClerkListener();
        unsubscribeClerkListener = null;
      }
      setPersistedWorkspaceId(null);
      resetClerkInstance();
      runAuthResetHooks();
      activeClerk = null;
      const persistedMode = readPersistedOperatorMode();
      set({ ...initialState, activeMode: persistedMode });
    }
  };
}

export const authStore = createAuthStore();
