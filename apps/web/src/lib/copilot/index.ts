// Package copilot provides frontend client logic, RBAC gating, quote confirmations,
// and chat session state for Creativanta Copilot (Module M23 / Screen W008).
// Canonical references: docs/02_features/platform/copilot.md & docs/04_contracts/database_schema.md §16.

import { writable, derived, get } from 'svelte/store';

export type CopilotRole =
  | 'owner'
  | 'admin'
  | 'manager'
  | 'editor'
  | 'contributor'
  | 'viewer'
  | 'external';

export type MessageSender = 'user' | 'assistant' | 'system';

export interface CitationRef {
  sourceType: string;
  sourceId: string;
  title: string;
  snippet?: string;
  url?: string;
}

export interface CopilotAction {
  id: string;
  label: string;
  actionType: 'navigate' | 'confirm_quote' | 'draft_created' | 'refusal';
  payload?: Record<string, unknown>;
}

export interface CreditQuotePreview {
  quoteId: string;
  operationType: string;
  costCredits: number;
  currentBalance: number;
  confirmed: boolean;
  status: 'pending' | 'confirmed' | 'cancelled' | 'executed';
  title: string;
  summary: string;
}

export interface CopilotMessage {
  id: string;
  sessionId: string;
  sender: MessageSender;
  content: string;
  createdAt: string;
  citations?: CitationRef[];
  quotePreview?: CreditQuotePreview;
  actions?: CopilotAction[];
  isRefusal?: boolean;
}

export interface CopilotSession {
  id: string;
  workspaceId: string;
  userId: string;
  title: string;
  createdAt: string;
  updatedAt: string;
  messages: CopilotMessage[];
}

// Acceptance Target 1: Contributor cannot delete product (RBAC check)
export const REFUSAL_PRODUCT_DELETE =
  'Bạn không có quyền xóa sản phẩm. Cần Admin+ role (product:delete).';

export function canDeleteProduct(role: CopilotRole): boolean {
  return role === 'owner' || role === 'admin';
}

// Acceptance Target 2: Read query cannot expose finance (Permission check)
export const REFUSAL_FINANCE_ACCESS =
  'Bạn không có quyền truy cập dữ liệu tài chính của workspace.';

export function canAccessFinance(role: CopilotRole): boolean {
  return role === 'owner' || role === 'admin' || role === 'manager' || role === 'editor';
}

// Acceptance Target 3: Script generation quote constants
export const SCRIPT_GENERATION_CREDIT_COST = 5;

export function createScriptQuotePreview(
  title: string,
  currentBalance: number
): CreditQuotePreview {
  return {
    quoteId: `quote-${Date.now()}-${Math.random().toString(36).substring(2, 7)}`,
    operationType: 'generate_script_draft',
    costCredits: SCRIPT_GENERATION_CREDIT_COST,
    currentBalance,
    confirmed: false,
    status: 'pending',
    title: `Báo giá tạo kịch bản AI: ${title}`,
    summary: `Thao tác tạo bản nháp kịch bản trong Script Lab tiêu tốn ${SCRIPT_GENERATION_CREDIT_COST} credits. Vui lòng xác nhận trước khi tiếp tục.`
  };
}

export function confirmScriptQuote(
  quote: CreditQuotePreview,
  userConfirmed: boolean
): { success: boolean; error?: string; updatedQuote: CreditQuotePreview } {
  if (!userConfirmed) {
    return {
      success: false,
      error: 'Người dùng đã hủy thao tác tạo kịch bản.',
      updatedQuote: { ...quote, confirmed: false, status: 'cancelled' }
    };
  }

  if (quote.currentBalance < quote.costCredits) {
    return {
      success: false,
      error: `Không đủ credits (Hiện có: ${quote.currentBalance}, Cần: ${quote.costCredits}). Vui lòng nạp thêm.`,
      updatedQuote: { ...quote, status: 'cancelled' }
    };
  }

  return {
    success: true,
    updatedQuote: {
      ...quote,
      confirmed: true,
      status: 'confirmed',
      currentBalance: quote.currentBalance - quote.costCredits
    }
  };
}

export interface CommandEvaluationResult {
  messageContent: string;
  isRefusal: boolean;
  requiresQuote?: boolean;
  quotePreview?: CreditQuotePreview;
  actions?: CopilotAction[];
}

export function evaluateCopilotCommand(
  input: string,
  userRole: CopilotRole,
  currentBalance: number
): CommandEvaluationResult {
  const normalized = input.trim().toLowerCase();

  // Target 1 Check: Product Deletion attempt
  if (
    normalized.includes('xóa sản phẩm') ||
    normalized.includes('delete product') ||
    normalized.includes('remove product')
  ) {
    if (!canDeleteProduct(userRole)) {
      return {
        messageContent: REFUSAL_PRODUCT_DELETE,
        isRefusal: true,
        actions: [
          {
            id: 'act-refusal-delete',
            label: 'Yêu cầu quyền Quản trị viên',
            actionType: 'refusal'
          }
        ]
      };
    }
    return {
      messageContent:
        'Bạn có quyền xóa sản phẩm. Vui lòng xác nhận mã sản phẩm cần xóa trên Product Hub.',
      isRefusal: false,
      actions: [
        {
          id: 'act-nav-product-hub',
          label: 'Mở Product Hub',
          actionType: 'navigate',
          payload: { route: '/kinh-doanh/san-pham' }
        }
      ]
    };
  }

  // Target 2 Check: Financial exposure query
  if (
    normalized.includes('doanh thu') ||
    normalized.includes('lợi nhuận') ||
    normalized.includes('chi phí') ||
    normalized.includes('revenue') ||
    normalized.includes('profit') ||
    normalized.includes('finance')
  ) {
    if (!canAccessFinance(userRole)) {
      return {
        messageContent: REFUSAL_FINANCE_ACCESS,
        isRefusal: true,
        actions: [
          {
            id: 'act-refusal-finance',
            label: 'Xem quyền hạn phân vai',
            actionType: 'refusal'
          }
        ]
      };
    }
    return {
      messageContent:
        'Tổng doanh thu tháng hiện tại của workspace: 45,200,000 VND (Biên lợi nhuận gộp ước tính 38.5%).',
      isRefusal: false
    };
  }

  // Target 3 Check: Generated script draft request
  if (
    normalized.includes('viết kịch bản') ||
    normalized.includes('tạo kịch bản') ||
    normalized.includes('draft script') ||
    normalized.includes('generate script')
  ) {
    const preview = createScriptQuotePreview(input, currentBalance);
    return {
      messageContent: `Tôi có thể soạn thảo kịch bản này cho bạn trong Script Lab (M06). Thao tác này cần báo giá ${preview.costCredits} credits.`,
      isRefusal: false,
      requiresQuote: true,
      quotePreview: preview,
      actions: [
        {
          id: 'act-confirm-quote',
          label: 'Xác nhận tạo kịch bản',
          actionType: 'confirm_quote',
          payload: { quoteId: preview.quoteId }
        }
      ]
    };
  }

  // General Copilot Q&A
  return {
    messageContent: `Tôi đã ghi nhận câu hỏi: "${input}". Hệ thống Creativanta đã kết nối với tài nguyên workspace của bạn.`,
    isRefusal: false
  };
}

export function createCopilotStore() {
  const session = writable<CopilotSession>({
    id: 'session-default',
    workspaceId: 'ws-default',
    userId: 'user-default',
    title: 'Hội thoại mới',
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
    messages: [
      {
        id: 'msg-welcome',
        sessionId: 'session-default',
        sender: 'assistant',
        content:
          'Xin chào! Tôi là Creativanta Copilot, trợ lý sáng tạo & phân tích thông minh cho workspace của bạn.',
        createdAt: new Date().toISOString()
      }
    ]
  });

  const isOpen = writable<boolean>(false);
  const userRole = writable<CopilotRole>('contributor');
  const creditBalance = writable<number>(100);
  const isTyping = writable<boolean>(false);

  function open() {
    isOpen.set(true);
  }

  function close() {
    isOpen.set(false);
  }

  function setRole(role: CopilotRole) {
    userRole.set(role);
  }

  function setCreditBalance(balance: number) {
    creditBalance.set(balance);
  }

  function sendMessage(content: string) {
    const trimmed = content.trim();
    if (!trimmed) return;

    const currentRole = get(userRole);
    const balance = get(creditBalance);

    const userMsg: CopilotMessage = {
      id: `msg-user-${Date.now()}`,
      sessionId: get(session).id,
      sender: 'user',
      content: trimmed,
      createdAt: new Date().toISOString()
    };

    session.update((s) => ({
      ...s,
      messages: [...s.messages, userMsg],
      updatedAt: new Date().toISOString()
    }));

    isTyping.set(true);

    const evalResult = evaluateCopilotCommand(trimmed, currentRole, balance);

    const botMsg: CopilotMessage = {
      id: `msg-bot-${Date.now()}`,
      sessionId: get(session).id,
      sender: 'assistant',
      content: evalResult.messageContent,
      createdAt: new Date().toISOString(),
      isRefusal: evalResult.isRefusal,
      quotePreview: evalResult.quotePreview,
      actions: evalResult.actions
    };

    session.update((s) => ({
      ...s,
      messages: [...s.messages, botMsg],
      updatedAt: new Date().toISOString()
    }));

    isTyping.set(false);
  }

  function confirmQuoteInMessage(messageId: string, confirmed: boolean) {
    const curBalance = get(creditBalance);
    session.update((s) => {
      const updatedMessages = s.messages.map((m) => {
        if (m.id === messageId && m.quotePreview) {
          const res = confirmScriptQuote(m.quotePreview, confirmed);
          if (res.success) {
            creditBalance.set(res.updatedQuote.currentBalance);
            return {
              ...m,
              quotePreview: res.updatedQuote,
              content: `${m.content}\n\n✅ **Đã xác nhận báo giá!** Bản nháp kịch bản đã được khởi tạo trong Script Lab.`
            };
          } else {
            return {
              ...m,
              quotePreview: res.updatedQuote,
              content: `${m.content}\n\n❌ **Đã hủy:** ${res.error}`
            };
          }
        }
        return m;
      });
      return { ...s, messages: updatedMessages };
    });
  }

  return {
    session,
    isOpen,
    userRole,
    creditBalance,
    isTyping,
    open,
    close,
    setRole,
    setCreditBalance,
    sendMessage,
    confirmQuoteInMessage
  };
}

export const copilotStore = createCopilotStore();
