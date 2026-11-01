/**
 * Authentication and Session Types for Creativanta Web (P0-03)
 * Reference: docs/02_features/platform/auth.md
 * Contracts: docs/04_contracts/api_behavior_contracts.md, docs/04_contracts/database_schema.md
 */

export type AuthState =
  | 'unconfigured'    // Publishable key is missing; honest unavailable notice shown
  | 'unauthenticated' // Ready but user is not signed in
  | 'loading'         // Checking session or initializing Clerk SDK
  | 'authenticated'   // Active provider session with valid short-lived JWT
  | 'expired'         // Session or token expired; refresh failed or re-auth required
  | 'error';          // Provider SDK initialization or network failure

export interface AuthUser {
  id: string; // Clerk provider subject (e.g. user_2xxx)
  email?: string;
  fullName?: string;
  imageUrl?: string;
}

export type WorkspaceRole =
  | 'owner'
  | 'admin'
  | 'manager'
  | 'editor'
  | 'contributor'
  | 'viewer'
  | 'external'
  | string;

/**
 * Summary of a workspace membership discovered for the authenticated user.
 * Exactly mirrors `identity.WorkspaceSummary` from `apps/api/internal/identity/discovery.go`.
 */
export interface WorkspaceSummary {
  id: string;
  name: string;
  role: WorkspaceRole;
  plan?: string;
  status?: 'active' | 'suspended' | 'deactivated';
}

/**
 * 6 Canonical Operator Modes (PRD §8.2, docs/01_business/user_segments_and_modes.md)
 */
export type OperatorMode =
  | 'creator'
  | 'seller'
  | 'affiliate_operator'
  | 'live_operator'
  | 'agency_mcn'
  | 'brand_collaboration';

export interface OperatorModeMeta {
  id: OperatorMode;
  label: string;
  vietnameseLabel: string;
  description: string;
  primaryObjects: string;
}

export const CANONICAL_OPERATOR_MODES: readonly OperatorModeMeta[] = [
  {
    id: 'creator',
    label: 'Creator',
    vietnameseLabel: 'Nhà sáng tạo',
    description: 'Tạo ý tưởng, kịch bản, sản xuất video AI và xuất bản đa kênh.',
    primaryObjects: 'Idea, Script, Asset, Publish Item, Thread, Offer'
  },
  {
    id: 'seller',
    label: 'Seller',
    vietnameseLabel: 'Người bán hàng',
    description: 'Quản lý sản phẩm, đơn hàng, tồn kho và đối soát dòng tiền.',
    primaryObjects: 'Product, SKU, Offer, Order, Thread, Profit Snapshot'
  },
  {
    id: 'affiliate_operator',
    label: 'Affiliate Operator',
    vietnameseLabel: 'Tiếp thị liên kết',
    description: 'Nghiên cứu cơ hội, liên kết tiếp thị, mã giảm giá và doanh thu ghi nhận.',
    primaryObjects: 'Opportunity, Product, Offer, Affiliate Link, Campaign, Profit Snapshot'
  },
  {
    id: 'live_operator',
    label: 'Live Operator',
    vietnameseLabel: 'Phòng chiến Live',
    description: 'Điều phối phiên Live bán hàng, ghim deal, cue card và tương tác thời gian thực.',
    primaryObjects: 'Live Session, Cue Card, Thread, Offer, Highlight'
  },
  {
    id: 'agency_mcn',
    label: 'Agency / MCN',
    vietnameseLabel: 'Mạng lưới & Đại lý',
    description: 'Quản trị đa workspace, phân quyền creator, phê duyệt và báo cáo tập trung.',
    primaryObjects: 'Workspace, Approval Request, Script, Asset, Report, Workflow'
  },
  {
    id: 'brand_collaboration',
    label: 'Brand Collaboration',
    vietnameseLabel: 'Hợp tác nhãn hàng',
    description: 'Yêu cầu nhãn hàng, bàn giao bằng chứng nghiệm thu và đối soát thanh toán.',
    primaryObjects: 'Sponsor Inquiry, Campaign, Publish Item, Proof Bundle, Invoice, Creator Payout'
  }
] as const;

export interface SessionContext {
  state: AuthState;
  user: AuthUser | null;
  token: string | null;
  activeWorkspace: WorkspaceSummary | null;
  workspaces: WorkspaceSummary[];
  activeMode: OperatorMode;
  errorMessage: string | null;
  isDiscoveryLoading: boolean;
  discoveryError: string | null;
}

/**
 * Pluggable discovery fetcher signature.
 * By default hits the backend discovery endpoint or handles unconfigured/fail-closed states.
 */
export type DiscoveryFetcher = (token: string) => Promise<WorkspaceSummary[]>;
