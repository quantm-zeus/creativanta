/**
 * Canonical Authenticated Connect/JSON RPC Client for Creativanta Web
 *
 * Enforces:
 * - Short-lived Bearer token (`Authorization: Bearer <token>`)
 * - Active tenant context (`X-Workspace-Id: <workspaceId>`)
 * - Idempotency key on mutating operations (`X-Idempotency-Key`)
 * - Fail-closed error handling: never fabricates success when unauthenticated,
 *   when backend RPC is unmounted (404/501), or when transport fails.
 */

import { authStore } from '$lib/auth/store';
import { getClerkSessionToken } from '$lib/auth/clerk';

export interface CanonicalRpcOptions {
  apiOrigin?: string;
  token?: string | null;
  workspaceId?: string | null;
  idempotencyKey?: string;
  requireAuth?: boolean;
  requireWorkspace?: boolean;
  fetchFn?: typeof fetch;
  signal?: AbortSignal;
}

export interface CanonicalRpcError {
  code: string;
  message: string;
  status: number;
  retryable: boolean;
}

export type CanonicalRpcResult<T> =
  | { ok: true; status: number; data: T }
  | { ok: false; error: CanonicalRpcError };

export function resolveApiOrigin(overrideOrigin?: string): string {
  if (overrideOrigin && overrideOrigin.trim().length > 0) {
    return overrideOrigin.trim().replace(/\/+$/, '');
  }
  const envOrigin = (import.meta.env?.VITE_API_ORIGIN as string | undefined) ?? '';
  if (envOrigin.trim().length > 0) {
    return envOrigin.trim().replace(/\/+$/, '');
  }
  return 'http://localhost:8080';
}

export function generateIdempotencyKey(prefix = 'idem'): string {
  if (typeof crypto !== 'undefined' && typeof crypto.randomUUID === 'function') {
    return `${prefix}-${crypto.randomUUID()}`;
  }
  return `${prefix}-${Date.now()}-${Math.random().toString(36).slice(2, 10)}`;
}

export async function callCanonicalRpc<TReq extends Record<string, unknown>, TRes>(
  serviceProcedure: string,
  payload: TReq,
  options: CanonicalRpcOptions = {}
): Promise<CanonicalRpcResult<TRes>> {
  const requireAuth = options.requireAuth ?? true;
  const requireWorkspace = options.requireWorkspace ?? true;
  const fetchImpl = options.fetchFn ?? (typeof fetch !== 'undefined' ? fetch : undefined);

  if (!fetchImpl) {
    return {
      ok: false,
      error: {
        code: 'TRANSPORT_UNAVAILABLE_001',
        message: 'Không có kết nối mạng (fetch transport unavailable).',
        status: 503,
        retryable: true
      }
    };
  }

  const snapshot = authStore.getSnapshot();
  let token = options.token ?? snapshot.token ?? null;
  if (!token) {
    token = await getClerkSessionToken();
  }

  const workspaceId =
    options.workspaceId ??
    snapshot.activeWorkspace?.id ??
    (typeof payload.workspace_id === 'string' ? payload.workspace_id : null) ??
    (typeof payload.workspaceId === 'string' ? payload.workspaceId : null);

  if (requireAuth && !token && snapshot.state !== 'authenticated') {
    return {
      ok: false,
      error: {
        code: 'AUTH_REQUIRED_001',
        message: 'Phiên đăng nhập chưa xác thực. Vui lòng đăng nhập trước khi thực hiện thao tác này.',
        status: 401,
        retryable: false
      }
    };
  }

  if (requireWorkspace && (!workspaceId || workspaceId.trim().length === 0)) {
    return {
      ok: false,
      error: {
        code: 'WORKSPACE_REQUIRED_001',
        message: 'Chưa chọn không gian làm việc (Workspace). Vui lòng chọn workspace hợp lệ.',
        status: 400,
        retryable: false
      }
    };
  }

  const cleanProcedure = serviceProcedure.replace(/^\/+/, '');
  const url = `${resolveApiOrigin(options.apiOrigin)}/${cleanProcedure}`;
  const idempotencyKey = options.idempotencyKey || generateIdempotencyKey('rpc');

  const headers: Record<string, string> = {
    'Content-Type': 'application/json',
    Accept: 'application/json',
    'Connect-Protocol-Version': '1',
    'X-Idempotency-Key': idempotencyKey
  };

  if (token) {
    headers['Authorization'] = `Bearer ${token}`;
  }
  if (workspaceId) {
    headers['X-Workspace-Id'] = workspaceId;
  }

  try {
    const response = await fetchImpl(url, {
      method: 'POST',
      headers,
      body: JSON.stringify(payload),
      signal: options.signal
    });

    let bodyJson: Record<string, unknown> | null = null;
    try {
      bodyJson = (await response.json()) as Record<string, unknown>;
    } catch {
      bodyJson = null;
    }

    if (!response.ok) {
      const serverCode =
        (typeof bodyJson?.code === 'string' && bodyJson.code) ||
        (response.status === 404
          ? 'SERVICE_UNMOUNTED_404'
          : response.status === 401
            ? 'AUTH_UNAUTHORIZED_001'
            : response.status === 403
              ? 'AUTH_FORBIDDEN_001'
              : `HTTP_${response.status}`);

      const serverMsg =
        (typeof bodyJson?.message === 'string' && bodyJson.message) ||
        (response.status === 404
          ? `Dịch vụ backend (${cleanProcedure}) hiện chưa được gắn kết hoặc chưa sẵn sàng. Dữ liệu nhập của bạn đã được giữ nguyên.`
          : `Yêu cầu thất bại (${response.status}). Dữ liệu nhập của bạn đã được giữ nguyên.`);

      return {
        ok: false,
        error: {
          code: serverCode,
          message: serverMsg,
          status: response.status,
          retryable: response.status >= 500 || response.status === 429
        }
      };
    }

    if (!bodyJson) {
      return {
        ok: false,
        error: {
          code: 'INVALID_RESPONSE_001',
          message: 'Phản hồi từ máy chủ không đúng định dạng JSON.',
          status: 502,
          retryable: true
        }
      };
    }

    return {
      ok: true,
      status: response.status,
      data: bodyJson as unknown as TRes
    };
  } catch (err) {
    const detail = err instanceof Error ? err.message : 'Unknown network error';
    return {
      ok: false,
      error: {
        code: 'NETWORK_ERROR_001',
        message: `Không thể kết nối tới máy chủ API (${detail}). Dữ liệu nhập của bạn đã được giữ nguyên.`,
        status: 503,
        retryable: true
      }
    };
  }
}
