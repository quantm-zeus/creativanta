import { describe, it, expect, beforeEach, vi } from 'vitest';
import { createAuthStore } from './store';
import { CANONICAL_OPERATOR_MODES, type WorkspaceSummary } from './types';
import { resetClerkInstance, type ClerkBrowserInstance } from './clerk';

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
});
