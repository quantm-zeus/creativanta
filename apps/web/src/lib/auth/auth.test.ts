import { describe, it, expect, beforeEach, vi } from 'vitest';
import {
  createAuthStore,
  defaultDiscoveryFetcher,
  parseWorkspaceDiscoveryPayload,
  registerAuthResetHook,
  sanitizeRedirectTarget,
  slugifyWorkspaceName
} from './store';
import { CANONICAL_OPERATOR_MODES, type WorkspaceSummary } from './types';
import {
  resetClerkInstance,
  startClerkEmailSignUp,
  verifyClerkEmailSignUpCode,
  requestClerkPasswordResetCode,
  confirmClerkPasswordResetCode,
  type ClerkBrowserInstance
} from './clerk';
import { modeStore } from '../constants/modes';
import {
  CANONICAL_WORKSPACE_ROLES,
  canModifyMemberInUI,
  reconcileRevokedWorkspaceSession,
  assertSafeClientProjection
} from './rbac';

describe('P0-03 Web User-Facing Identity & Auth Store', () => {
  let mockClerk: ClerkBrowserInstance;
  let mockWorkspaces: WorkspaceSummary[];

  beforeEach(() => {
    resetClerkInstance();
    mockWorkspaces = [
      {
        id: 'ws-owner-1',
        name: 'Creative Studio (Chính)',
        role: 'owner',
        plan: 'Pro',
        status: 'active'
      },
      {
        id: 'ws-editor-2',
        name: 'Agency Client A',
        role: 'editor',
        plan: 'Team',
        status: 'active'
      },
      {
        id: 'ws-viewer-3',
        name: 'MCN Network Media',
        role: 'viewer',
        plan: 'Enterprise',
        status: 'active'
      }
    ];

    mockClerk = {
      loaded: true,
      user: {
        id: 'user_clerk_test_123',
        primaryEmailAddress: { emailAddress: 'creator@creativanta.vn' },
        fullName: 'Nguyễn Văn Creator',
        imageUrl: 'https://img.clerk.com/test.png'
      },
      session: {
        id: 'sess_test_123',
        status: 'active',
        getToken: vi.fn().mockResolvedValue('jwt_short_lived_token_valid')
      },
      load: vi.fn().mockResolvedValue(undefined),
      signOut: vi.fn().mockResolvedValue(undefined),
      addListener: vi.fn().mockReturnValue(() => {})
    };
  });

  describe('1. Missing Publishable Key Handling (Fail-Closed)', () => {
    it('initializes to unconfigured state when publishable key is missing', async () => {
      const store = createAuthStore();
      await store.init({ publishableKey: '' });

      let current: any;
      store.subscribe((val) => (current = val))();

      expect(current.state).toBe('unconfigured');
      expect(current.user).toBeNull();
      expect(current.token).toBeNull();
      expect(current.activeWorkspace).toBeNull();
      expect(current.errorMessage).toContain('Chưa cấu hình khóa định danh Clerk');
    });

    it('rejects workspace selection when unconfigured or unauthenticated', async () => {
      const store = createAuthStore();
      await store.init({ publishableKey: '' });

      await expect(store.selectWorkspace('ws-owner-1')).rejects.toThrow(
        /fail-closed/
      );
    });

    it('rejects secret key prefixes to prevent client bundle credential leakage', async () => {
      const store = createAuthStore();
      // Provide a secret key instead of publishable key
      await store.init({ publishableKey: 'sk_test_super_secret_key' });

      let current: any;
      store.subscribe((val) => (current = val))();

      expect(current.state).toBe('unconfigured');
      expect(current.token).toBeNull();
    });
  });

  describe('2. Expired Session Lifecycle', () => {
    it('transitions to expired state if session token is null or invalid', async () => {
      mockClerk.session!.getToken = vi.fn().mockResolvedValue(null);

      const store = createAuthStore();
      await store.init({
        publishableKey: 'pk_test_valid_dummy_key',
        clerkInstance: mockClerk
      });

      let current: any;
      store.subscribe((val) => (current = val))();

      expect(current.state).toBe('expired');
      expect(current.token).toBeNull();
      expect(current.errorMessage).toContain('hết hạn');
    });

    it('transitions to expired state when token refresh fails during active session', async () => {
      const store = createAuthStore();
      await store.init({
        publishableKey: 'pk_test_valid_dummy_key',
        clerkInstance: mockClerk,
        discoveryFetcher: vi.fn().mockResolvedValue(mockWorkspaces)
      });

      let current: any;
      store.subscribe((val) => (current = val))();
      expect(current.state).toBe('authenticated');
      expect(current.token).toBe('jwt_short_lived_token_valid');

      // Now simulate token expiration on refresh
      mockClerk.session!.getToken = vi.fn().mockRejectedValue(new Error('Session revoked by IdP'));
      const refreshed = await store.refreshSession();

      expect(refreshed).toBeNull();
      store.subscribe((val) => (current = val))();
      expect(current.state).toBe('expired');
      expect(current.token).toBeNull();
      expect(current.activeWorkspace).toBeNull();
    });
  });

  describe('3. Multi-Workspace Non-Owner Selection', () => {
    it('allows selecting non-owner workspace roles (editor, viewer) when discovered', async () => {
      const store = createAuthStore();
      await store.init({
        publishableKey: 'pk_test_valid_dummy_key',
        clerkInstance: mockClerk,
        discoveryFetcher: vi.fn().mockResolvedValue(mockWorkspaces)
      });

      let current: any;
      store.subscribe((val) => (current = val))();

      expect(current.workspaces).toHaveLength(3);

      // Select editor workspace (non-owner)
      const selectedEditor = await store.selectWorkspace('ws-editor-2');
      expect(selectedEditor.id).toBe('ws-editor-2');
      expect(selectedEditor.role).toBe('editor');

      store.subscribe((val) => (current = val))();
      expect(current.activeWorkspace?.id).toBe('ws-editor-2');
      expect(current.activeWorkspace?.role).toBe('editor');

      // Select viewer workspace (non-owner)
      const selectedViewer = await store.selectWorkspace('ws-viewer-3');
      expect(selectedViewer.id).toBe('ws-viewer-3');
      expect(selectedViewer.role).toBe('viewer');

      store.subscribe((val) => (current = val))();
      expect(current.activeWorkspace?.id).toBe('ws-viewer-3');
      expect(current.activeWorkspace?.role).toBe('viewer');
    });

    it('rejects non-member workspace selection fail-closed', async () => {
      const store = createAuthStore();
      await store.init({
        publishableKey: 'pk_test_valid_dummy_key',
        clerkInstance: mockClerk,
        discoveryFetcher: vi.fn().mockResolvedValue(mockWorkspaces)
      });

      // User attempts to select a foreign workspace
      await expect(store.selectWorkspace('foreign-unauthorized-workspace')).rejects.toThrow(
        /Không tìm thấy quyền thành viên/
      );
    });

    it('auto-selects when user belongs to exactly one workspace per RULE-AUTH-003', async () => {
      const singleWorkspace: WorkspaceSummary[] = [
        {
          id: 'ws-solo-1',
          name: 'Solo Brand',
          role: 'owner',
          plan: 'Starter',
          status: 'active'
        }
      ];

      const store = createAuthStore();
      await store.init({
        publishableKey: 'pk_test_valid_dummy_key',
        clerkInstance: mockClerk,
        discoveryFetcher: vi.fn().mockResolvedValue(singleWorkspace)
      });

      let current: any;
      store.subscribe((val) => (current = val))();

      expect(current.workspaces).toHaveLength(1);
      expect(current.activeWorkspace?.id).toBe('ws-solo-1');
    });
  });

  describe('4. Sign-Out & Failure Transitions', () => {
    it('cleanly transitions to unauthenticated on signOut', async () => {
      const store = createAuthStore();
      await store.init({
        publishableKey: 'pk_test_valid_dummy_key',
        clerkInstance: mockClerk,
        discoveryFetcher: vi.fn().mockResolvedValue(mockWorkspaces)
      });

      await store.selectWorkspace('ws-editor-2');
      await store.signOut();

      expect(mockClerk.signOut).toHaveBeenCalled();

      let current: any;
      store.subscribe((val) => (current = val))();

      expect(current.state).toBe('unauthenticated');
      expect(current.user).toBeNull();
      expect(current.token).toBeNull();
      expect(current.activeWorkspace).toBeNull();
    });

    it('handles discovery network or server failure honestly without faking data', async () => {
      const store = createAuthStore();
      const failingFetcher = vi.fn().mockRejectedValue(new Error('503 Service Unavailable'));

      await store.init({
        publishableKey: 'pk_test_valid_dummy_key',
        clerkInstance: mockClerk,
        discoveryFetcher: failingFetcher
      });

      let current: any;
      store.subscribe((val) => (current = val))();

      expect(current.state).toBe('authenticated'); // Auth with Clerk succeeded
      expect(current.workspaces).toHaveLength(0);   // But discovery failed
      expect(current.activeWorkspace).toBeNull();
      expect(current.discoveryError).toContain('503 Service Unavailable');
    });

    it('transitions to error state when Clerk initialization throws unexpectedly', async () => {
      mockClerk.load = vi.fn().mockRejectedValue(new Error('Clerk SDK network timeout'));
      // Clear cached instance
      mockClerk.loaded = false;

      const store = createAuthStore();
      await store.init({
        publishableKey: 'pk_test_valid_dummy_key',
        clerkInstance: mockClerk
      });

      let current: any;
      store.subscribe((val) => (current = val))();
      expect(['error', 'unconfigured']).toContain(current.state);
    });
  });

  describe('5. Canonical Operator Modes Support (PRD §8.2)', () => {
    it('defines exactly the 6 canonical operator modes', () => {
      expect(CANONICAL_OPERATOR_MODES).toHaveLength(6);
      const modeIds = CANONICAL_OPERATOR_MODES.map((m) => m.id);
      expect(modeIds).toEqual([
        'creator',
        'seller',
        'affiliate_operator',
        'live_operator',
        'agency_mcn',
        'brand_collaboration'
      ]);
    });

    it('allows switching operator modes and retains choice', async () => {
      const store = createAuthStore();
      await store.init({ publishableKey: '' });

      let current: any;
      store.subscribe((val) => (current = val))();
      expect(current.activeMode).toBe('creator');

      store.setOperatorMode('live_operator');
      store.subscribe((val) => (current = val))();
      expect(current.activeMode).toBe('live_operator');

      store.setOperatorMode('agency_mcn');
      store.subscribe((val) => (current = val))();
      expect(current.activeMode).toBe('agency_mcn');
    });
  });

  describe('6. P0-04 RBAC, Last-Owner Protection, Revocation & Private Projections', () => {
    it('defines all 7 canonical workspace roles from rbac_permission_matrix.md §1', () => {
      expect(CANONICAL_WORKSPACE_ROLES).toHaveLength(7);
      expect(CANONICAL_WORKSPACE_ROLES.map((r) => r.role)).toEqual([
        'owner',
        'admin',
        'manager',
        'editor',
        'contributor',
        'viewer',
        'external'
      ]);
    });

    it('protects the last workspace owner and prevents self/privilege escalation in UI', () => {
      // Owner cannot demote/remove self when last owner
      const selfOwner = canModifyMemberInUI({
        actorRole: 'owner',
        actorUserId: 'u-1',
        targetUserId: 'u-1',
        targetRole: 'owner',
        activeOwnerCount: 1
      });
      expect(selfOwner.canChangeRole).toBe(false);
      expect(selfOwner.canRemove).toBe(false);
      expect(selfOwner.reason).toContain('Chủ sở hữu duy nhất');

      // Admin cannot modify Owner
      const adminOnOwner = canModifyMemberInUI({
        actorRole: 'admin',
        actorUserId: 'u-admin',
        targetUserId: 'u-owner',
        targetRole: 'owner',
        activeOwnerCount: 1
      });
      expect(adminOnOwner.canChangeRole).toBe(false);
      expect(adminOnOwner.canRemove).toBe(false);
      expect(adminOnOwner.reason).toContain('Quản trị viên không thể');

      // Admin can modify Editor
      const adminOnEditor = canModifyMemberInUI({
        actorRole: 'admin',
        actorUserId: 'u-admin',
        targetUserId: 'u-editor',
        targetRole: 'editor',
        activeOwnerCount: 1
      });
      expect(adminOnEditor.canChangeRole).toBe(true);
      expect(adminOnEditor.canRemove).toBe(true);
    });

    it('enforces member revocation on active workspace (EC-AUTH-003)', () => {
      const revokedRes = reconcileRevokedWorkspaceSession(
        mockWorkspaces,
        'ws-editor-2',
        'ws-editor-2'
      );
      expect(revokedRes.remainingWorkspaces.map((w) => w.id)).toEqual(['ws-owner-1', 'ws-viewer-3']);
      expect(revokedRes.nextActiveWorkspace).toBeNull();
      expect(revokedRes.redirectPath).toBe('/workspaces');
    });

    it('rejects private notes and secret fields in client projections', () => {
      expect(() =>
        assertSafeClientProjection({
          workspace_id: 'ws-1',
          name: 'Safe Workspace'
        })
      ).not.toThrow();

      expect(() =>
        assertSafeClientProjection({
          connected_account_id: 'ca-1',
          access_token_encrypted: 'leaked_bytes'
        })
      ).toThrow(/Forbidden secret\/private key/);

      expect(() =>
        assertSafeClientProjection({
          message_id: 'msg-1',
          body: 'Confidential internal triage',
          is_internal_note: true
        })
      ).toThrow(/Forbidden internal support note/);
    });
  });

  describe('7. UF-10 Open Redirect Sanitization', () => {
    it('allows safe internal paths and preserves query/hash', () => {
      expect(sanitizeRedirectTarget('/studio/agent?tab=plan#step-1')).toBe(
        '/studio/agent?tab=plan#step-1'
      );
      expect(sanitizeRedirectTarget('/kinh-doanh')).toBe('/kinh-doanh');
    });

    it('rejects absolute URLs, protocol-relative URLs, javascript/data schemes, and backslashes', () => {
      expect(sanitizeRedirectTarget('https://evil.example/phish')).toBe('/workspaces');
      expect(sanitizeRedirectTarget('http://evil.example/phish')).toBe('/workspaces');
      expect(sanitizeRedirectTarget('//evil.example/phish')).toBe('/workspaces');
      expect(sanitizeRedirectTarget('/\\evil.example')).toBe('/workspaces');
      expect(sanitizeRedirectTarget('/%5cevil.example')).toBe('/workspaces');
      expect(sanitizeRedirectTarget('/%2f/evil.example')).toBe('/workspaces');
      expect(sanitizeRedirectTarget('javascript:alert(1)')).toBe('/workspaces');
      expect(sanitizeRedirectTarget('data:text/html,<script>alert(1)</script>')).toBe('/workspaces');
      expect(sanitizeRedirectTarget(null)).toBe('/workspaces');
      expect(sanitizeRedirectTarget('https://evil.example/phish', '/')).toBe('/');
    });
  });

  describe('8. UF-09 Six-Mode Bidirectional Synchronization', () => {
    it('synchronizes operator mode changes between authStore and modeStore', async () => {
      const store = createAuthStore();
      await store.init({ publishableKey: '' });

      let authMode = 'creator';
      let globalMode = 'creator';
      const unsubAuth = store.subscribe((s) => (authMode = s.activeMode));
      const unsubGlobal = modeStore.subscribe((m) => (globalMode = m));

      // Change via authStore -> reflects in modeStore
      store.setOperatorMode('seller');
      expect(authMode).toBe('seller');
      expect(globalMode).toBe('seller');

      // Change via modeStore -> reflects in authStore
      modeStore.setMode('brand_collaboration');
      expect(globalMode).toBe('brand_collaboration');
      expect(authMode).toBe('brand_collaboration');

      // Reset
      modeStore.setMode('creator');
      unsubAuth();
      unsubGlobal();
    });
  });

  describe('9. UF-02 Clerk Registration, Password Reset & First Workspace Creation', () => {
    it('fails closed when Clerk sign-up or password reset is invoked without Clerk configured', async () => {
      const signUpFail = await startClerkEmailSignUp({
        fullName: 'Người Dùng Mới',
        email: 'new@creativanta.vn',
        password: 'Password123!'
      });
      expect(signUpFail.ok).toBe(false);
      expect(signUpFail.step).toBe('failed');
      expect(signUpFail.error).toMatch(/fail-closed/);

      const resetFail = await requestClerkPasswordResetCode({
        email: 'user@creativanta.vn'
      });
      expect(resetFail.ok).toBe(false);
      expect(resetFail.step).toBe('failed');
      expect(resetFail.error).toMatch(/fail-closed/);
    });

    it('completes Clerk email sign-up and password reset when Clerk client is provided', async () => {
      const setActive = vi.fn().mockResolvedValue(undefined);
      const clerkWithClient: ClerkBrowserInstance = {
        ...mockClerk,
        setActive,
        client: {
          signUp: {
            create: vi.fn().mockResolvedValue({ status: 'missing_requirements' }),
            prepareEmailAddressVerification: vi.fn().mockResolvedValue(undefined),
            attemptEmailAddressVerification: vi.fn().mockResolvedValue({
              status: 'complete',
              createdSessionId: 'sess_new_signup_1'
            })
          },
          signIn: {
            create: vi.fn().mockResolvedValue({ status: 'needs_first_factor' }),
            attemptFirstFactor: vi.fn().mockResolvedValue({
              status: 'complete',
              createdSessionId: 'sess_recovered_1'
            })
          }
        }
      };

      const startRes = await startClerkEmailSignUp({
        fullName: 'Trần Thị B',
        email: 'new@creativanta.vn',
        password: 'Password123!',
        clerk: clerkWithClient
      });
      expect(startRes.ok).toBe(true);
      expect(startRes.step).toBe('verification_required');

      const verifyRes = await verifyClerkEmailSignUpCode({
        code: '123456',
        clerk: clerkWithClient
      });
      expect(verifyRes.ok).toBe(true);
      expect(verifyRes.step).toBe('complete');
      expect(setActive).toHaveBeenCalledWith({ session: 'sess_new_signup_1' });

      const reqReset = await requestClerkPasswordResetCode({
        email: 'new@creativanta.vn',
        clerk: clerkWithClient
      });
      expect(reqReset.ok).toBe(true);
      expect(reqReset.step).toBe('code_sent');

      const resetRes = await confirmClerkPasswordResetCode({
        code: '654321',
        newPassword: 'NewStrongPass123!',
        clerk: clerkWithClient
      });
      expect(resetRes.ok).toBe(true);
      expect(resetRes.step).toBe('complete');
      expect(setActive).toHaveBeenCalledWith({ session: 'sess_recovered_1' });
    });

    it('creates first workspace via canonical WorkspaceService/Create RPC and fails closed on backend error', async () => {
      const store = createAuthStore();
      await store.init({
        publishableKey: 'pk_test_valid_dummy_key',
        clerkInstance: mockClerk,
        discoveryFetcher: vi.fn().mockResolvedValue([])
      });

      expect(slugifyWorkspaceName('Creativanta Việt Nam Studio!')).toBe(
        'creativanta-viet-nam-studio'
      );

      // 1. Negative test: backend returns 503 -> fails closed without fabricating workspace
      const failingFetch = vi.fn().mockResolvedValue(
        new Response(JSON.stringify({ message: 'Database unavailable' }), {
          status: 503,
          headers: { 'content-type': 'application/json' }
        })
      );

      const failCreate = await store.createWorkspace(
        {
          displayName: 'New Studio',
          defaultOperatorMode: 'seller'
        },
        failingFetch as unknown as typeof fetch
      );
      expect(failCreate.ok).toBe(false);
      expect(failCreate.error).toContain('Database unavailable');
      expect(store.getSnapshot().workspaces).toHaveLength(0);

      // 2. Positive test: backend returns created workspace -> updates activeWorkspace & mode
      const successFetch = vi.fn().mockResolvedValue(
        new Response(
          JSON.stringify({
            workspace: {
              workspace_id: 'ws-created-001',
              display_name: 'New Studio',
              slug: 'new-studio',
              plan_tier: 'Starter',
              status: 'active',
              default_operator_mode: 'seller'
            }
          }),
          {
            status: 200,
            headers: { 'content-type': 'application/json' }
          }
        )
      );

      const okCreate = await store.createWorkspace(
        {
          displayName: 'New Studio',
          defaultOperatorMode: 'seller'
        },
        successFetch as unknown as typeof fetch
      );

      expect(okCreate.ok).toBe(true);
      expect(okCreate.workspace?.id).toBe('ws-created-001');
      expect(okCreate.workspace?.role).toBe('owner');
      expect(store.getSnapshot().activeWorkspace?.id).toBe('ws-created-001');
      expect(store.getSnapshot().activeMode).toBe('seller');
    });
  });

  describe('10. R7 Remediation: Canonical Discovery Shape & Session Epoch Isolation', () => {
    it('parses canonical Go /api/workspaces/discovery {"workspaces": [...]} payload for 0, 1, and 3 workspaces and fails closed on malformed payloads', async () => {
      const originalFetch = globalThis.fetch;
      try {
        // 1. Single workspace envelope -> auto-selected with workspace_id and display_name
        globalThis.fetch = vi.fn().mockResolvedValue(
          new Response(
            JSON.stringify({
              workspaces: [
                {
                  workspace_id: '018f7a31-2233-7444-8555-667788990011',
                  name: 'creativanta-hq',
                  display_name: 'Creativanta HQ',
                  role: 'admin',
                  default_mode: 'seller',
                  default_operator_mode: 'seller'
                }
              ]
            }),
            { status: 200, headers: { 'content-type': 'application/json' } }
          )
        ) as unknown as typeof fetch;

        const store = createAuthStore();
        await store.init({
          publishableKey: 'pk_test_valid_dummy_key',
          clerkInstance: mockClerk
        });

        const snap1 = store.getSnapshot();
        expect(snap1.workspaces).toHaveLength(1);
        expect(snap1.activeWorkspace?.id).toBe('018f7a31-2233-7444-8555-667788990011');
        expect(snap1.activeWorkspace?.name).toBe('Creativanta HQ');
        expect(snap1.activeWorkspace?.role).toBe('admin');

        // 2. Three workspaces (including non-owner member/editor/viewer)
        globalThis.fetch = vi.fn().mockResolvedValue(
          new Response(
            JSON.stringify({
              workspaces: [
                {
                  workspace_id: 'ws-alpha',
                  name: 'alpha-slug',
                  display_name: 'Alpha Studio',
                  role: 'owner'
                },
                {
                  workspace_id: 'ws-beta',
                  name: 'beta-slug',
                  display_name: 'Beta Agency',
                  role: 'editor'
                },
                {
                  workspace_id: 'ws-gamma',
                  name: 'gamma-slug',
                  display_name: 'Gamma Brand',
                  role: 'member'
                }
              ]
            }),
            { status: 200, headers: { 'content-type': 'application/json' } }
          )
        ) as unknown as typeof fetch;

        const store3 = createAuthStore();
        await store3.init({
          publishableKey: 'pk_test_valid_dummy_key',
          clerkInstance: mockClerk
        });
        const snap3 = store3.getSnapshot();
        expect(snap3.workspaces.map((w) => w.id)).toEqual(['ws-alpha', 'ws-beta', 'ws-gamma']);
        expect(snap3.workspaces.map((w) => w.role)).toEqual(['owner', 'editor', 'member']);
        const selected = await store3.selectWorkspace('ws-beta');
        expect(selected.id).toBe('ws-beta');
        expect(store3.getSnapshot().activeWorkspace?.name).toBe('Beta Agency');

        // 3. Zero workspaces (null or empty array in Go JSON)
        expect(parseWorkspaceDiscoveryPayload({ workspaces: null })).toEqual([]);
        expect(parseWorkspaceDiscoveryPayload({ workspaces: [] })).toEqual([]);

        // 4. Malformed payloads fail closed
        expect(() => parseWorkspaceDiscoveryPayload({ unexpected: true })).toThrow(/fail-closed/);
        expect(() => parseWorkspaceDiscoveryPayload({ workspaces: 'not-an-array' })).toThrow(
          /fail-closed/
        );
        expect(() =>
          parseWorkspaceDiscoveryPayload({ workspaces: [{ display_name: 'Missing ID' }] })
        ).toThrow(/workspace_id/);

        globalThis.fetch = vi.fn().mockResolvedValue(
          new Response(JSON.stringify({ unexpected: 'shape' }), {
            status: 200,
            headers: { 'content-type': 'application/json' }
          })
        ) as unknown as typeof fetch;
        await expect(defaultDiscoveryFetcher('tok_123')).rejects.toThrow(/fail-closed/);
      } finally {
        globalThis.fetch = originalFetch;
      }
    });

    it('prevents stale in-flight getToken() or discovery callbacks from re-authenticating after signOut()', async () => {
      let capturedListener: ((emission: any) => Promise<void> | void) | null = null;
      const unsubSpy = vi.fn();

      let resolveDeferredToken!: (token: string | null) => void;
      const deferredTokenPromise = new Promise<string | null>((resolve) => {
        resolveDeferredToken = resolve;
      });

      const clerkWithListener: ClerkBrowserInstance = {
        ...mockClerk,
        addListener: vi.fn((cb) => {
          capturedListener = cb;
          return unsubSpy;
        })
      };

      const store = createAuthStore();
      await store.init({
        publishableKey: 'pk_test_valid_dummy_key',
        clerkInstance: clerkWithListener,
        discoveryFetcher: vi.fn().mockResolvedValue(mockWorkspaces)
      });
      expect(store.getSnapshot().state).toBe('authenticated');
      expect(capturedListener).not.toBeNull();

      // Trigger listener emission whose getToken() is slow / in-flight
      const emissionPromise = capturedListener!({
        user: {
          id: 'user_stale_1',
          fullName: 'Stale User',
          primaryEmailAddress: { emailAddress: 'stale@creativanta.vn' }
        },
        session: {
          id: 'sess_stale_1',
          getToken: () => deferredTokenPromise
        }
      });

      // User logs out before getToken() resolves
      await store.signOut();
      expect(unsubSpy).toHaveBeenCalledTimes(1);
      expect(store.getSnapshot().state).toBe('unauthenticated');
      expect(store.getSnapshot().user).toBeNull();
      expect(store.getSnapshot().token).toBeNull();
      expect(store.getSnapshot().activeWorkspace).toBeNull();

      // Now the stale getToken() resolves AFTER signOut()
      resolveDeferredToken('stale-jwt-after-logout');
      await emissionPromise;

      // State MUST remain unauthenticated
      const afterSnap = store.getSnapshot();
      expect(afterSnap.state).toBe('unauthenticated');
      expect(afterSnap.user).toBeNull();
      expect(afterSnap.token).toBeNull();
      expect(afterSnap.activeWorkspace).toBeNull();
      expect(afterSnap.workspaces).toHaveLength(0);
    });

    it('isolates subject switch (User A -> User B) and purges prior workspace & singleton stores', async () => {
      let capturedListener: ((emission: any) => Promise<void> | void) | null = null;
      let resolveUserADiscovery!: (items: WorkspaceSummary[]) => void;
      const userADiscoveryPromise = new Promise<WorkspaceSummary[]>((resolve) => {
        resolveUserADiscovery = resolve;
      });

      const userBWorkspaces: WorkspaceSummary[] = [
        {
          id: 'ws-user-b-only',
          name: 'User B Exclusive Workspace',
          role: 'member',
          plan: 'Pro',
          status: 'active'
        }
      ];

      const discoveryFetcher = vi.fn((token: string) => {
        if (token === 'token-user-a-slow') {
          return userADiscoveryPromise;
        }
        return Promise.resolve(userBWorkspaces);
      });

      const clerkWithListener: ClerkBrowserInstance = {
        ...mockClerk,
        addListener: vi.fn((cb) => {
          capturedListener = cb;
          return () => {};
        })
      };

      let resetHookCalls = 0;
      const unsubResetHook = registerAuthResetHook(() => {
        resetHookCalls += 1;
      });

      try {
        const store = createAuthStore();
        await store.init({
          publishableKey: 'pk_test_valid_dummy_key',
          clerkInstance: clerkWithListener,
          discoveryFetcher: vi.fn().mockResolvedValue(mockWorkspaces)
        });
        await store.selectWorkspace('ws-owner-1');
        expect(store.getSnapshot().activeWorkspace?.id).toBe('ws-owner-1');

        // Re-configure discoveryFetcher via listener emissions:
        // First emit for user_clerk_123 with slow discovery
        await store.init({
          publishableKey: 'pk_test_valid_dummy_key',
          clerkInstance: {
            ...clerkWithListener,
            session: {
              id: 'sess_a',
              status: 'active',
              getToken: vi.fn().mockResolvedValue('token-user-a-init')
            }
          },
          discoveryFetcher
        });

        const slowEmissionA = capturedListener!({
          user: {
            id: 'user_clerk_123',
            fullName: 'User A',
            primaryEmailAddress: { emailAddress: 'a@creativanta.vn' }
          },
          session: {
            id: 'sess_a',
            getToken: async () => 'token-user-a-slow'
          }
        });

        // Before User A's slow discovery finishes, switch subject to User B
        const emissionB = capturedListener!({
          user: {
            id: 'user_clerk_999',
            fullName: 'User B',
            primaryEmailAddress: { emailAddress: 'b@creativanta.vn' }
          },
          session: {
            id: 'sess_b',
            getToken: async () => 'token-user-b'
          }
        });

        await emissionB;
        expect(resetHookCalls).toBeGreaterThanOrEqual(1);
        expect(store.getSnapshot().user?.id).toBe('user_clerk_999');
        expect(store.getSnapshot().activeWorkspace?.id).toBe('ws-user-b-only');

        // Now User A's slow discovery resolves late -> must be ignored
        resolveUserADiscovery(mockWorkspaces);
        await slowEmissionA;

        expect(store.getSnapshot().user?.id).toBe('user_clerk_999');
        expect(store.getSnapshot().activeWorkspace?.id).toBe('ws-user-b-only');
        expect(store.getSnapshot().workspaces.map((w) => w.id)).toEqual(['ws-user-b-only']);
      } finally {
        unsubResetHook();
      }
    });

    it('invokes registerAuthResetHook when refreshSession expires or discovery revokes activeWorkspace (T8-F4)', async () => {
      let resetHookCalls = 0;
      const unsubResetHook = registerAuthResetHook(() => {
        resetHookCalls += 1;
      });

      try {
        let currentWorkspaces: WorkspaceSummary[] = [mockWorkspaces[0]];
        let nextToken: string | null = 'token-initial';

        const dynamicClerk: ClerkBrowserInstance = {
          ...mockClerk,
          session: {
            id: 'sess_dyn_1',
            status: 'active',
            getToken: vi.fn(async () => nextToken)
          }
        };

        const store = createAuthStore();
        await store.init({
          publishableKey: 'pk_test_valid_dummy_key',
          clerkInstance: dynamicClerk,
          discoveryFetcher: vi.fn(async () => currentWorkspaces)
        });
        expect(store.getSnapshot().activeWorkspace?.id).toBe(mockWorkspaces[0].id);
        const baselineCalls = resetHookCalls;

        // 1. Re-discovery revokes membership in activeWorkspace -> reset hooks fire
        currentWorkspaces = [mockWorkspaces[1]];
        await store.discoverWorkspaces();
        expect(store.getSnapshot().activeWorkspace?.id).toBe(mockWorkspaces[1].id);
        expect(resetHookCalls).toBe(baselineCalls + 1);

        // 2. Session refresh fails / returns null token -> state becomes expired and reset hooks fire
        nextToken = null;
        const refreshed = await store.refreshSession();
        expect(refreshed).toBeNull();
        expect(store.getSnapshot().state).toBe('expired');
        expect(store.getSnapshot().activeWorkspace).toBeNull();
        expect(resetHookCalls).toBe(baselineCalls + 2);
      } finally {
        unsubResetHook();
      }
    });
  });
});
