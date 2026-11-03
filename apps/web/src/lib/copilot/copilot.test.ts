import { describe, it, expect, beforeEach } from 'vitest';
import {
  canDeleteProduct,
  canAccessFinance,
  evaluateCopilotCommand,
  createScriptQuotePreview,
  confirmScriptQuote,
  createCopilotStore,
  REFUSAL_PRODUCT_DELETE,
  REFUSAL_FINANCE_ACCESS,
  SCRIPT_GENERATION_CREDIT_COST
} from './index';

describe('Copilot (Module M23) - Frontend Acceptance Targets & Logic', () => {
  // Acceptance Target 1: Contributor cannot delete product
  describe('Acceptance Target 1: Contributor cannot delete product', () => {
    it('denies product deletion for Contributor, Viewer, and External roles', () => {
      expect(canDeleteProduct('contributor')).toBe(false);
      expect(canDeleteProduct('viewer')).toBe(false);
      expect(canDeleteProduct('external')).toBe(false);
      expect(canDeleteProduct('editor')).toBe(false);
      expect(canDeleteProduct('manager')).toBe(false);
    });

    it('allows product deletion for Owner and Admin roles', () => {
      expect(canDeleteProduct('owner')).toBe(true);
      expect(canDeleteProduct('admin')).toBe(true);
    });

    it('evaluates deletion prompt for Contributor and returns explicit refusal', () => {
      const res = evaluateCopilotCommand('Hãy xóa sản phẩm SP-001 giùm tôi', 'contributor', 100);
      expect(res.isRefusal).toBe(true);
      expect(res.messageContent).toBe(REFUSAL_PRODUCT_DELETE);
      expect(res.actions?.[0].actionType).toBe('refusal');
    });

    it('allows deletion evaluation for Admin role with navigation confirmation', () => {
      const res = evaluateCopilotCommand('Xóa sản phẩm SP-002', 'admin', 100);
      expect(res.isRefusal).toBe(false);
      expect(res.actions?.[0].actionType).toBe('navigate');
      expect(res.actions?.[0].payload).toEqual({ route: '/kinh-doanh/san-pham' });
    });
  });

  // Acceptance Target 2: Read query cannot expose finance
  describe('Acceptance Target 2: Read query cannot expose finance', () => {
    it('denies financial read queries for Contributor, Viewer, and External roles', () => {
      expect(canAccessFinance('contributor')).toBe(false);
      expect(canAccessFinance('viewer')).toBe(false);
      expect(canAccessFinance('external')).toBe(false);
    });

    it('allows financial read queries for Owner, Admin, Manager, and Editor', () => {
      expect(canAccessFinance('owner')).toBe(true);
      expect(canAccessFinance('admin')).toBe(true);
      expect(canAccessFinance('manager')).toBe(true);
      expect(canAccessFinance('editor')).toBe(true);
    });

    it('refuses financial revenue query when executed by Contributor', () => {
      const res = evaluateCopilotCommand('Cho tôi biết doanh thu và lợi nhuận tuần này', 'contributor', 50);
      expect(res.isRefusal).toBe(true);
      expect(res.messageContent).toBe(REFUSAL_FINANCE_ACCESS);
    });

    it('exposes financial numbers only when executed by Manager or Admin', () => {
      const res = evaluateCopilotCommand('Báo cáo doanh thu tháng này', 'manager', 50);
      expect(res.isRefusal).toBe(false);
      expect(res.messageContent).toContain('doanh thu tháng hiện tại');
      expect(res.messageContent).toContain('45,200,000 VND');
    });
  });

  // Acceptance Target 3: Generated script needs quote confirmation
  describe('Acceptance Target 3: Generated script needs quote confirmation', () => {
    it('creates an explicit credit quote preview for script draft requests', () => {
      const prompt = 'Viết kịch bản video TikTok 30s giới thiệu serum';
      const preview = createScriptQuotePreview(prompt, 50);

      expect(preview.costCredits).toBe(SCRIPT_GENERATION_CREDIT_COST);
      expect(preview.costCredits).toBe(5);
      expect(preview.status).toBe('pending');
      expect(preview.confirmed).toBe(false);
      expect(preview.title).toContain('Báo giá tạo kịch bản AI');
    });

    it('triggers quote preview card in evaluateCopilotCommand', () => {
      const res = evaluateCopilotCommand('Tạo kịch bản video viral', 'contributor', 30);
      expect(res.isRefusal).toBe(false);
      expect(res.requiresQuote).toBe(true);
      expect(res.quotePreview).toBeDefined();
      expect(res.quotePreview?.costCredits).toBe(5);
      expect(res.actions?.[0].actionType).toBe('confirm_quote');
    });

    it('cancels script generation when user rejects quote confirmation', () => {
      const preview = createScriptQuotePreview('Kịch bản quảng cáo', 20);
      const res = confirmScriptQuote(preview, false);

      expect(res.success).toBe(false);
      expect(res.error).toContain('Người dùng đã hủy thao tác');
      expect(res.updatedQuote.status).toBe('cancelled');
      expect(res.updatedQuote.confirmed).toBe(false);
    });

    it('rejects confirmation if workspace credit balance is insufficient', () => {
      const preview = createScriptQuotePreview('Kịch bản ngắn', 2); // only 2 credits available, need 5
      const res = confirmScriptQuote(preview, true);

      expect(res.success).toBe(false);
      expect(res.error).toContain('Không đủ credits');
      expect(res.updatedQuote.status).toBe('cancelled');
    });

    it('successfully confirms quote and debits credits when balance is sufficient', () => {
      const preview = createScriptQuotePreview('Kịch bản review', 25);
      const res = confirmScriptQuote(preview, true);

      expect(res.success).toBe(true);
      expect(res.updatedQuote.confirmed).toBe(true);
      expect(res.updatedQuote.status).toBe('confirmed');
      expect(res.updatedQuote.currentBalance).toBe(20); // 25 - 5
    });
  });

  // Store & Conversation Flow tests
  describe('Copilot Store & Conversation State', () => {
    let store: ReturnType<typeof createCopilotStore>;

    beforeEach(() => {
      store = createCopilotStore();
    });

    it('initializes with default welcome message and closed drawer', () => {
      let isOpen = false;
      store.isOpen.subscribe((val) => (isOpen = val));
      expect(isOpen).toBe(false);

      store.open();
      expect(isOpen).toBe(true);

      store.close();
      expect(isOpen).toBe(false);
    });

    it('enforces Target 1 refusal through store conversation as Contributor', () => {
      store.setRole('contributor');
      store.sendMessage('Vui lòng xóa sản phẩm này');

      let sessionMessages: any[] = [];
      store.session.subscribe((s) => (sessionMessages = s.messages));

      const botMsg = sessionMessages[sessionMessages.length - 1];
      expect(botMsg.sender).toBe('assistant');
      expect(botMsg.isRefusal).toBe(true);
      expect(botMsg.content).toBe(REFUSAL_PRODUCT_DELETE);
    });

    it('enforces Target 2 refusal through store conversation as Viewer', () => {
      store.setRole('viewer');
      store.sendMessage('Xem doanh thu chi tiết');

      let sessionMessages: any[] = [];
      store.session.subscribe((s) => (sessionMessages = s.messages));

      const botMsg = sessionMessages[sessionMessages.length - 1];
      expect(botMsg.sender).toBe('assistant');
      expect(botMsg.isRefusal).toBe(true);
      expect(botMsg.content).toBe(REFUSAL_FINANCE_ACCESS);
    });

    it('handles Target 3 script quote workflow through store conversation', () => {
      store.setRole('contributor');
      store.setCreditBalance(15);
      store.sendMessage('Viết kịch bản video TikTok 15s');

      let sessionMessages: any[] = [];
      let balance = 15;
      store.session.subscribe((s) => (sessionMessages = s.messages));
      store.creditBalance.subscribe((b) => (balance = b));

      const botMsg = sessionMessages[sessionMessages.length - 1];
      expect(botMsg.quotePreview).toBeDefined();
      expect(botMsg.quotePreview.status).toBe('pending');
      expect(balance).toBe(15); // not deducted yet

      // User confirms quote
      store.confirmQuoteInMessage(botMsg.id, true);

      expect(balance).toBe(10); // 15 - 5 = 10
      const updatedBotMsg = sessionMessages.find((m) => m.id === botMsg.id);
      expect(updatedBotMsg.quotePreview.status).toBe('confirmed');
      expect(updatedBotMsg.content).toContain('Đã xác nhận báo giá!');
    });
  });
});
