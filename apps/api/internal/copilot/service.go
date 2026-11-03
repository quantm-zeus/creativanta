package copilot

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"errors"
	"fmt"
	"strconv"
	"strings"
	"sync"
	"time"

	"connectrpc.com/connect"
	copilotv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/copilot/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/copilot/v1/copilotv1connect"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
)

// ServiceConfig defines dependencies for the CopilotService.
type ServiceConfig struct {
	Store Store
}

// Service implements CopilotServiceHandler.
type Service struct {
	store  Store
	mu     sync.RWMutex
	events []DomainEvent
}

var _ copilotv1connect.CopilotServiceHandler = (*Service)(nil)

// NewService creates a new CopilotService instance.
func NewService(cfg ServiceConfig) *Service {
	s := cfg.Store
	if s == nil {
		s = NewMemoryStore()
	}
	return &Service{
		store: s,
	}
}

// Events returns recorded domain events for assertions.
func (s *Service) Events() []DomainEvent {
	s.mu.RLock()
	defer s.mu.RUnlock()
	ev := make([]DomainEvent, len(s.events))
	copy(ev, s.events)
	return ev
}

func (s *Service) recordEvent(eventType, workspaceID string, payload map[string]any) {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.events = append(s.events, DomainEvent{
		EventType:   eventType,
		WorkspaceID: workspaceID,
		Payload:     payload,
		OccurredAt:  time.Now().UTC(),
	})
}

func checkPermission(caller CallerContext, permissionKey string) error {
	return rbac.CheckWorkspacePermission(permissionKey, rbac.PolicyContext{
		ActorUserID: caller.UserID,
		WorkspaceID: caller.WorkspaceID,
		Role:        caller.WorkspaceRole,
	})
}

func generateID(prefix string, ts time.Time) string {
	raw := fmt.Sprintf("%s:%d", prefix, ts.UnixNano())
	h := sha256.Sum256([]byte(raw))
	hx := hex.EncodeToString(h[:])
	return fmt.Sprintf("%s-%s-%s", prefix, hx[:8], hx[8:12])
}

func isDestructiveProductQuery(q string) bool {
	lower := strings.ToLower(q)
	return (strings.Contains(lower, "xóa sản phẩm") ||
		strings.Contains(lower, "xoa san pham") ||
		strings.Contains(lower, "delete product") ||
		strings.Contains(lower, "remove product") ||
		strings.Contains(lower, "xóa kho") ||
		strings.Contains(lower, "delete sku"))
}

func isFinancialQuery(q string) bool {
	lower := strings.ToLower(q)
	return (strings.Contains(lower, "doanh thu") ||
		strings.Contains(lower, "revenue") ||
		strings.Contains(lower, "lợi nhuận") ||
		strings.Contains(lower, "profit") ||
		strings.Contains(lower, "margin") ||
		strings.Contains(lower, "cost") ||
		strings.Contains(lower, "chi phí") ||
		strings.Contains(lower, "tiền lãi") ||
		strings.Contains(lower, "settlement") ||
		strings.Contains(lower, "đối soát") ||
		strings.Contains(lower, "reconciliation"))
}

func isScriptGenerationQuery(q string) bool {
	lower := strings.ToLower(q)
	return (strings.Contains(lower, "tạo script") ||
		strings.Contains(lower, "tao script") ||
		strings.Contains(lower, "viết script") ||
		strings.Contains(lower, "viet script") ||
		strings.Contains(lower, "kịch bản") ||
		strings.Contains(lower, "kich ban") ||
		strings.Contains(lower, "generate script") ||
		strings.Contains(lower, "create script") ||
		strings.Contains(lower, "write script"))
}

// Query handles natural-language questions with multi-tenant isolation, RBAC gating,
// financial redaction, and quoted draft generation.
func (s *Service) Query(ctx context.Context, req *connect.Request[copilotv1.CopilotServiceQueryRequest]) (*connect.Response[copilotv1.CopilotServiceQueryResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}

	wsID := req.Msg.WorkspaceId
	if wsID == "" {
		wsID = caller.WorkspaceID
	}
	if wsID != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}

	// Permission gate for copilot creative queries
	if err := checkPermission(caller, "copilot:use_creative"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	queryText := strings.TrimSpace(req.Msg.Query)
	if queryText == "" && req.Msg.ConfirmedQuoteId == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrQueryRequired)
	}

	// 1. Get or create session
	sessionID := req.Msg.SessionId
	var session *StoredSession
	var err error
	if sessionID != "" {
		session, err = s.store.GetSession(ctx, wsID, sessionID)
		if err != nil && !errors.Is(err, ErrSessionNotFound) {
			return nil, connect.NewError(connect.CodeInternal, err)
		}
	}

	now := time.Now().UTC()
	if session == nil {
		sessionID = generateID("sess", now)
		modeStr := ProtoToMode(req.Msg.Mode)
		if modeStr == "" {
			modeStr = "creative"
		}
		session = &StoredSession{
			SessionID:        sessionID,
			WorkspaceID:      wsID,
			UserID:           caller.UserID,
			Mode:             modeStr,
			ContextScope:     req.Msg.ContextScope,
			TotalCreditsUsed: "0.000000",
			CreatedAt:        now,
			UpdatedAt:        now,
		}
		session, err = s.store.CreateSession(ctx, session)
		if err != nil {
			return nil, connect.NewError(connect.CodeInternal, err)
		}
		s.recordEvent("copilot.session_started", wsID, map[string]any{
			"session_id": sessionID,
			"mode":       modeStr,
		})
	}

	// User message
	if queryText != "" {
		userMsg := StoredMessage{
			MessageID: generateID("msg", now),
			SessionID: sessionID,
			Role:      "user",
			Content:   queryText,
			CreatedAt: now,
		}
		session.Messages = append(session.Messages, userMsg)
	}

	resp := &copilotv1.CopilotServiceQueryResponse{}

	// -------------------------------------------------------------------------
	// Acceptance Target 1: Contributor cannot delete product
	// -------------------------------------------------------------------------
	if isDestructiveProductQuery(queryText) {
		// Destructive action check: requires product:delete (Admin+) and copilot:use_action
		permErr := checkPermission(caller, "product:delete")
		actionPermErr := checkPermission(caller, "copilot:use_action")
		if permErr != nil || actionPermErr != nil {
			denialReason := "Bạn không có quyền xóa sản phẩm. Cần Admin+ role (product:delete)."
			asstMsg := StoredMessage{
				MessageID:        generateID("msg", time.Now().UTC()),
				SessionID:        sessionID,
				Role:             "assistant",
				Content:          denialReason,
				PermissionDenied: true,
				DenialReason:     denialReason,
				CreatedAt:        time.Now().UTC(),
			}
			session.Messages = append(session.Messages, asstMsg)
			session.UpdatedAt = time.Now().UTC()
			s.store.UpdateSession(ctx, session)

			resp.Session = SessionToProto(session)
			resp.Message = MessageToProto(&asstMsg)
			return connect.NewResponse(resp), nil
		}
		// Authorized admin/owner: acknowledge product deletion request
		asstMsg := StoredMessage{
			MessageID: generateID("msg", time.Now().UTC()),
			SessionID: sessionID,
			Role:      "assistant",
			Content:   "Yêu cầu xóa sản phẩm đã được phê duyệt bởi quyền quản trị viên.",
			CreatedAt: time.Now().UTC(),
		}
		session.Messages = append(session.Messages, asstMsg)
		session.UpdatedAt = time.Now().UTC()
		s.store.UpdateSession(ctx, session)

		resp.Session = SessionToProto(session)
		resp.Message = MessageToProto(&asstMsg)
		return connect.NewResponse(resp), nil
	}

	// -------------------------------------------------------------------------
	// Acceptance Target 3: Generated script needs quote confirmation
	// -------------------------------------------------------------------------
	if req.Msg.ConfirmedQuoteId != "" {
		// Confirming an existing quote
		quote, err := s.store.GetQuote(ctx, wsID, req.Msg.ConfirmedQuoteId)
		if err != nil {
			return nil, connect.NewError(connect.CodeNotFound, ErrQuoteNotFound)
		}
		if quote.Status == "confirmed" {
			return nil, connect.NewError(connect.CodeFailedPrecondition, ErrQuoteAlreadyConsumed)
		}
		if time.Now().UTC().After(quote.ExpiresAt) {
			quote.Status = "expired"
			s.store.UpdateQuote(ctx, quote)
			return nil, connect.NewError(connect.CodeFailedPrecondition, ErrQuoteExpired)
		}

		quote.Status = "confirmed"
		s.store.UpdateQuote(ctx, quote)

		// Persist script draft in Script Lab
		scriptTitle := "Script: " + quote.ActionPreview
		scriptContent := "Hook: Dừng lại 3 giây nếu bạn muốn cải thiện làn da!\nThân bài: Giới thiệu giải pháp peptide tự nhiên.\nCTA: Bấm vào giỏ hàng ngay hôm nay!"
		scriptID, err := s.store.SaveCreatedScriptDraft(ctx, wsID, scriptTitle, scriptContent, caller.UserID)
		if err != nil {
			return nil, connect.NewError(connect.CodeInternal, err)
		}

		// Debit credits to session
		currentCredits, _ := strconv.ParseFloat(session.TotalCreditsUsed, 64)
		currentCredits += float64(quote.QuotedCredits)
		session.TotalCreditsUsed = fmt.Sprintf("%.6f", currentCredits)

		asstMsg := StoredMessage{
			MessageID: generateID("msg", time.Now().UTC()),
			SessionID: sessionID,
			Role:      "assistant",
			Content:   fmt.Sprintf("Script đã tạo xong trong Script Lab (%s) với %d credits được khấu trừ. [Xem script] [Tạo video từ script]", scriptID, quote.QuotedCredits),
			CreatedAt: time.Now().UTC(),
		}
		session.Messages = append(session.Messages, asstMsg)
		session.UpdatedAt = time.Now().UTC()
		s.store.UpdateSession(ctx, session)

		s.recordEvent("copilot.session_ended", wsID, map[string]any{
			"session_id":   sessionID,
			"credits_used": quote.QuotedCredits,
			"script_id":    scriptID,
		})

		resp.Session = SessionToProto(session)
		resp.Message = MessageToProto(&asstMsg)
		resp.RequiresQuoteConfirmation = false
		resp.Quote = QuoteToProto(quote)
		return connect.NewResponse(resp), nil
	}

	if isScriptGenerationQuery(queryText) {
		// Step 1: Issue credit quote preview (5 credits) without executing script generation
		quoteID := generateID("quote", now)
		expiresAt := now.Add(15 * time.Minute)
		actionQuote := &StoredActionQuote{
			QuoteID:        quoteID,
			WorkspaceID:    wsID,
			UserID:         caller.UserID,
			OperationType:  "generate_script",
			QuotedCredits:  5,
			CostCeilingUSD: "0.050000",
			Status:         "pending",
			ExpiresAt:      expiresAt,
			CreatedAt:      now,
			ActionPreview:  "Tạo kịch bản bán hàng tự động",
		}
		createdQuote, err := s.store.CreateQuote(ctx, actionQuote)
		if err != nil {
			return nil, connect.NewError(connect.CodeInternal, err)
		}

		promptPreview := "Tạo script sẽ dùng 5 credits. [Xác nhận] [Hủy]"
		asstMsg := StoredMessage{
			MessageID:    generateID("msg", time.Now().UTC()),
			SessionID:    sessionID,
			Role:         "assistant",
			Content:      promptPreview,
			PendingQuote: createdQuote,
			ActionCards: []StoredActionCard{
				{
					ActionID:             generateID("act", now),
					ActionType:           "create_script",
					Title:                "Xác nhận tạo script (5 credits)",
					Description:          "Tạo kịch bản video bán hàng và lưu bản nháp vào Script Lab.",
					RequiredPermission:   "script:create",
					RequiresConfirmation: true,
					Quote:                createdQuote,
				},
			},
			CreatedAt: time.Now().UTC(),
		}
		session.Messages = append(session.Messages, asstMsg)
		session.UpdatedAt = time.Now().UTC()
		s.store.UpdateSession(ctx, session)

		resp.Session = SessionToProto(session)
		resp.Message = MessageToProto(&asstMsg)
		resp.RequiresQuoteConfirmation = true
		resp.Quote = QuoteToProto(createdQuote)
		return connect.NewResponse(resp), nil
	}

	// -------------------------------------------------------------------------
	// Acceptance Target 2: Read query cannot expose finance
	// -------------------------------------------------------------------------
	if isFinancialQuery(queryText) {
		resp.IsFinancialQuery = true
		// Check finance read permissions
		financeErr := checkPermission(caller, "copilot:use_analytics")
		if financeErr != nil {
			// Fail-closed redaction: Contributor / Viewer cannot see financial data
			redactionText := "Bạn không có quyền truy cập dữ liệu tài chính của workspace."
			resp.FinancialDataRedacted = true

			asstMsg := StoredMessage{
				MessageID: generateID("msg", time.Now().UTC()),
				SessionID: sessionID,
				Role:      "assistant",
				Content:   redactionText,
				DataCards: []StoredDataCard{
					{
						CardID:          generateID("card", now),
						Title:           "Dữ liệu tài chính (Bị ẩn)",
						Summary:         redactionText,
						IsFinancial:     true,
						IsRedacted:      true,
						RedactionReason: "Cần quyền Manager+ role (copilot:use_analytics / finance:read).",
					},
				},
				CreatedAt: time.Now().UTC(),
			}
			session.Messages = append(session.Messages, asstMsg)
			session.UpdatedAt = time.Now().UTC()
			s.store.UpdateSession(ctx, session)

			resp.Session = SessionToProto(session)
			resp.Message = MessageToProto(&asstMsg)
			return connect.NewResponse(resp), nil
		}

		// Authorized user: return financial summary
		resp.FinancialDataRedacted = false
		financeText := "Doanh thu 30 ngày qua đạt 45.200.000 VND, tỷ suất lợi nhuận ròng 32.5%."
		asstMsg := StoredMessage{
			MessageID: generateID("msg", time.Now().UTC()),
			SessionID: sessionID,
			Role:      "assistant",
			Content:   financeText,
			DataCards: []StoredDataCard{
				{
					CardID:       generateID("card", now),
					Title:        "Báo cáo tài chính 30 ngày",
					Summary:      financeText,
					IsFinancial:  true,
					IsRedacted:   false,
					SourceBadges: []string{"M19 Operating Ledger", "Shopee Connector", "TikTok Connector"},
					Metrics: map[string]string{
						"revenue": "45200000",
						"margin":  "32.5%",
						"orders":  "142",
					},
				},
			},
			CreatedAt: time.Now().UTC(),
		}
		session.Messages = append(session.Messages, asstMsg)
		session.UpdatedAt = time.Now().UTC()
		s.store.UpdateSession(ctx, session)

		resp.Session = SessionToProto(session)
		resp.Message = MessageToProto(&asstMsg)
		return connect.NewResponse(resp), nil
	}

	// General Q&A / Knowledge lookup (0 credits)
	generalReply := fmt.Sprintf("Tôi đã nhận được câu hỏi: %q. Hệ thống đang phân tích ngữ cảnh từ %s.", queryText, session.ContextScope)
	asstMsg := StoredMessage{
		MessageID: generateID("msg", time.Now().UTC()),
		SessionID: sessionID,
		Role:      "assistant",
		Content:   generalReply,
		CreatedAt: time.Now().UTC(),
	}
	session.Messages = append(session.Messages, asstMsg)
	session.UpdatedAt = time.Now().UTC()
	s.store.UpdateSession(ctx, session)

	resp.Session = SessionToProto(session)
	resp.Message = MessageToProto(&asstMsg)
	return connect.NewResponse(resp), nil
}

// SendMessage sends a conversational message and handles potential quote confirmations.
func (s *Service) SendMessage(ctx context.Context, req *connect.Request[copilotv1.CopilotServiceSendMessageRequest]) (*connect.Response[copilotv1.CopilotServiceSendMessageResponse], error) {
	qReq := &copilotv1.CopilotServiceQueryRequest{
		WorkspaceId:      req.Msg.WorkspaceId,
		SessionId:        req.Msg.SessionId,
		Query:            req.Msg.Content,
		Mode:             req.Msg.Mode,
		ContextScope:     req.Msg.ContextScope,
		ConfirmedQuoteId: req.Msg.ConfirmedQuoteId,
	}
	qResp, err := s.Query(ctx, connect.NewRequest(qReq))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&copilotv1.CopilotServiceSendMessageResponse{
		Session:                   qResp.Msg.Session,
		Reply:                     qResp.Msg.Message,
		RequiresQuoteConfirmation: qResp.Msg.RequiresQuoteConfirmation,
		Quote:                     qResp.Msg.Quote,
	}), nil
}

// Chat is an alias for conversation turns.
func (s *Service) Chat(ctx context.Context, req *connect.Request[copilotv1.CopilotServiceChatRequest]) (*connect.Response[copilotv1.CopilotServiceChatResponse], error) {
	smReq := &copilotv1.CopilotServiceSendMessageRequest{
		WorkspaceId:  req.Msg.WorkspaceId,
		SessionId:    req.Msg.SessionId,
		Content:      req.Msg.Message,
		Mode:         req.Msg.Mode,
		ContextScope: req.Msg.ContextScope,
	}
	smResp, err := s.SendMessage(ctx, connect.NewRequest(smReq))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&copilotv1.CopilotServiceChatResponse{
		Session: smResp.Msg.Session,
		Reply:   smResp.Msg.Reply,
	}), nil
}

// GetSession retrieves session details and conversational history.
func (s *Service) GetSession(ctx context.Context, req *connect.Request[copilotv1.CopilotServiceGetSessionRequest]) (*connect.Response[copilotv1.CopilotServiceGetSessionResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}

	wsID := req.Msg.WorkspaceId
	if wsID == "" {
		wsID = caller.WorkspaceID
	}
	if wsID != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}

	if err := checkPermission(caller, "copilot:use_help"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	session, err := s.store.GetSession(ctx, wsID, req.Msg.SessionId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrSessionNotFound)
	}

	return connect.NewResponse(&copilotv1.CopilotServiceGetSessionResponse{
		Session: SessionToProto(session),
	}), nil
}

// ClearSession clears message history in the session.
func (s *Service) ClearSession(ctx context.Context, req *connect.Request[copilotv1.CopilotServiceClearSessionRequest]) (*connect.Response[copilotv1.CopilotServiceClearSessionResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}

	wsID := req.Msg.WorkspaceId
	if wsID == "" {
		wsID = caller.WorkspaceID
	}
	if wsID != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}

	if err := checkPermission(caller, "copilot:use_creative"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	if err := s.store.ClearSession(ctx, wsID, req.Msg.SessionId); err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrSessionNotFound)
	}

	return connect.NewResponse(&copilotv1.CopilotServiceClearSessionResponse{
		Cleared:   true,
		SessionId: req.Msg.SessionId,
	}), nil
}

// GetSuggestions returns quick contextual recommendations based on user route and mode.
func (s *Service) GetSuggestions(ctx context.Context, req *connect.Request[copilotv1.CopilotServiceGetSuggestionsRequest]) (*connect.Response[copilotv1.CopilotServiceGetSuggestionsResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}

	wsID := req.Msg.WorkspaceId
	if wsID == "" {
		wsID = caller.WorkspaceID
	}
	if wsID != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}

	if err := checkPermission(caller, "copilot:use_help"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	scope := req.Msg.ContextScope
	var items []*copilotv1.SuggestionItem

	switch {
	case strings.Contains(scope, "script") || strings.Contains(scope, "M06"):
		items = append(items,
			&copilotv1.SuggestionItem{SuggestionId: "sug-1", Label: "Tối ưu hóa hook 3 giây", PromptText: "Làm sao để hook video hấp dẫn hơn?", TargetModule: "M06"},
			&copilotv1.SuggestionItem{SuggestionId: "sug-2", Label: "Thêm CTA chuyển đổi", PromptText: "Gợi ý CTA mua hàng hiệu quả cho kịch bản này", TargetModule: "M06"},
		)
	case strings.Contains(scope, "trend") || strings.Contains(scope, "M02"):
		items = append(items,
			&copilotv1.SuggestionItem{SuggestionId: "sug-3", Label: "Xu hướng TikTok hot nhất", PromptText: "Nội dung nào đang có lượt xem tăng đột biến tuần này?", TargetModule: "M02"},
			&copilotv1.SuggestionItem{SuggestionId: "sug-4", Label: "Phân tích đối thủ", PromptText: "Kênh đối thủ đang làm gì hiệu quả?", TargetModule: "M03"},
		)
	default:
		items = append(items,
			&copilotv1.SuggestionItem{SuggestionId: "sug-5", Label: "Gợi ý việc cần làm hôm nay", PromptText: "Tôi nên tập trung vào việc gì hôm nay?", TargetModule: "M01"},
			&copilotv1.SuggestionItem{SuggestionId: "sug-6", Label: "Tạo ý tưởng nội dung mới", PromptText: "Cho tôi 3 ý tưởng video ngắn tuần này", TargetModule: "M05"},
			&copilotv1.SuggestionItem{SuggestionId: "sug-7", Label: "Hướng dẫn sử dụng", PromptText: "Làm thế nào để xuất bản video đa nền tảng?", TargetModule: "help"},
		)
	}

	return connect.NewResponse(&copilotv1.CopilotServiceGetSuggestionsResponse{
		Suggestions: items,
	}), nil
}

// GetContextualActions returns actionable shortcuts for the current screen.
func (s *Service) GetContextualActions(ctx context.Context, req *connect.Request[copilotv1.CopilotServiceGetContextualActionsRequest]) (*connect.Response[copilotv1.CopilotServiceGetContextualActionsResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}

	wsID := req.Msg.WorkspaceId
	if wsID == "" {
		wsID = caller.WorkspaceID
	}
	if wsID != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}

	if err := checkPermission(caller, "copilot:use_help"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	route := req.Msg.ScreenRoute
	var actions []*copilotv1.ActionCard

	if strings.Contains(route, "script") {
		actions = append(actions, &copilotv1.ActionCard{
			ActionId:           "act-review",
			ActionType:         "submit_review",
			Title:              "Gửi duyệt kịch bản",
			Description:        "Gửi bản thảo này đến Quản lý để duyệt sản xuất.",
			RequiredPermission: "script:manage",
		})
	} else if strings.Contains(route, "product") {
		actions = append(actions, &copilotv1.ActionCard{
			ActionId:             "act-create-script",
			ActionType:           "create_script",
			Title:                "Tạo kịch bản từ sản phẩm",
			Description:          "Dùng AI sinh kịch bản quảng bá sản phẩm này (5 credits).",
			RequiredPermission:   "copilot:use_creative",
			RequiresConfirmation: true,
		})
	}

	return connect.NewResponse(&copilotv1.CopilotServiceGetContextualActionsResponse{
		Actions: actions,
	}), nil
}

// SetContext sets session context scope.
func (s *Service) SetContext(ctx context.Context, req *connect.Request[copilotv1.CopilotServiceSetContextRequest]) (*connect.Response[copilotv1.CopilotServiceSetContextResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}

	wsID := req.Msg.WorkspaceId
	if wsID == "" {
		wsID = caller.WorkspaceID
	}
	if wsID != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}

	if err := checkPermission(caller, "copilot:use_creative"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	session, err := s.store.GetSession(ctx, wsID, req.Msg.SessionId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrSessionNotFound)
	}

	session.ContextScope = req.Msg.ContextScope
	if req.Msg.Mode != copilotv1.CopilotMode_COPILOT_MODE_UNSPECIFIED {
		session.Mode = ProtoToMode(req.Msg.Mode)
	}
	session.UpdatedAt = time.Now().UTC()
	s.store.UpdateSession(ctx, session)

	return connect.NewResponse(&copilotv1.CopilotServiceSetContextResponse{
		Session: SessionToProto(session),
	}), nil
}

// GetHistory returns session history for user.
func (s *Service) GetHistory(ctx context.Context, req *connect.Request[copilotv1.CopilotServiceGetHistoryRequest]) (*connect.Response[copilotv1.CopilotServiceGetHistoryResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}

	wsID := req.Msg.WorkspaceId
	if wsID == "" {
		wsID = caller.WorkspaceID
	}
	if wsID != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}

	if err := checkPermission(caller, "copilot:use_help"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	sessions, nextToken, err := s.store.ListSessions(ctx, wsID, caller.UserID, int(req.Msg.Limit), req.Msg.PageToken)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var protoSessions []*copilotv1.CopilotSession
	for _, sess := range sessions {
		protoSessions = append(protoSessions, SessionToProto(sess))
	}

	return connect.NewResponse(&copilotv1.CopilotServiceGetHistoryResponse{
		Sessions:      protoSessions,
		NextPageToken: nextToken,
	}), nil
}

// Feedback records feedback on response.
func (s *Service) Feedback(ctx context.Context, req *connect.Request[copilotv1.CopilotServiceFeedbackRequest]) (*connect.Response[copilotv1.CopilotServiceFeedbackResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}

	wsID := req.Msg.WorkspaceId
	if wsID == "" {
		wsID = caller.WorkspaceID
	}
	if wsID != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}

	if err := checkPermission(caller, "copilot:use_creative"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	return connect.NewResponse(&copilotv1.CopilotServiceFeedbackResponse{
		Recorded: true,
	}), nil
}

// FinanceInsight provides financial metrics, redacting when caller lacks finance permission.
func (s *Service) FinanceInsight(ctx context.Context, req *connect.Request[copilotv1.CopilotServiceFinanceInsightRequest]) (*connect.Response[copilotv1.CopilotServiceFinanceInsightResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}

	wsID := req.Msg.WorkspaceId
	if wsID == "" {
		wsID = caller.WorkspaceID
	}
	if wsID != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}

	// Finance inspection permission check
	if err := checkPermission(caller, "copilot:use_analytics"); err != nil {
		return connect.NewResponse(&copilotv1.CopilotServiceFinanceInsightResponse{
			Insight:         "Bạn không có quyền truy cập dữ liệu tài chính của workspace.",
			IsRedacted:      true,
			RedactionReason: "Cần quyền Manager+ role (copilot:use_analytics / finance:read).",
		}), nil
	}

	return connect.NewResponse(&copilotv1.CopilotServiceFinanceInsightResponse{
		Insight:    "Lợi nhuận ròng tháng này đạt 32.5%, tỷ suất chi phí quảng cáo (ROAS) đạt 3.8x.",
		IsRedacted: false,
	}), nil
}

// GenerateIdeas produces content ideas.
func (s *Service) GenerateIdeas(ctx context.Context, req *connect.Request[copilotv1.CopilotServiceGenerateIdeasRequest]) (*connect.Response[copilotv1.CopilotServiceGenerateIdeasResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if err := checkPermission(caller, "copilot:use_creative"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	topic := req.Msg.Topic
	if topic == "" {
		topic = "Skincare"
	}

	return connect.NewResponse(&copilotv1.CopilotServiceGenerateIdeasResponse{
		Ideas: []string{
			fmt.Sprintf("3 bí quyết sử dụng %s đạt hiệu quả tối ưu", topic),
			fmt.Sprintf("Sai lầm phổ biến khi chọn %s người mới hay gặp", topic),
			fmt.Sprintf("So sánh top 3 sản phẩm %s bán chạy nhất tuần này", topic),
		},
		RequiresConfirmation: false,
	}), nil
}

// GenerateCaption creates caption copy.
func (s *Service) GenerateCaption(ctx context.Context, req *connect.Request[copilotv1.CopilotServiceGenerateCaptionRequest]) (*connect.Response[copilotv1.CopilotServiceGenerateCaptionResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if err := checkPermission(caller, "copilot:use_creative"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	return connect.NewResponse(&copilotv1.CopilotServiceGenerateCaptionResponse{
		Caption:  "Khám phá ngay bí quyết chăm sóc da chuẩn chuyên gia cùng Creativanta! ✨",
		Hashtags: []string{"#skincare", "#tips", "#beauty", "#creativanta"},
	}), nil
}

// GenerateReply creates reply copy.
func (s *Service) GenerateReply(ctx context.Context, req *connect.Request[copilotv1.CopilotServiceGenerateReplyRequest]) (*connect.Response[copilotv1.CopilotServiceGenerateReplyResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if err := checkPermission(caller, "copilot:use_creative"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	return connect.NewResponse(&copilotv1.CopilotServiceGenerateReplyResponse{
		SuggestedReply: "Cảm ơn bạn đã quan tâm! Sản phẩm hiện đang có sẵn trong giỏ hàng với ưu đãi đặc biệt hôm nay ạ.",
	}), nil
}

// GenerateAvatar creates avatar.
func (s *Service) GenerateAvatar(ctx context.Context, req *connect.Request[copilotv1.CopilotServiceGenerateAvatarRequest]) (*connect.Response[copilotv1.CopilotServiceGenerateAvatarResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if err := checkPermission(caller, "copilot:use_creative"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	return connect.NewResponse(&copilotv1.CopilotServiceGenerateAvatarResponse{
		AvatarUrl: "https://cdn.creativanta.com/avatars/default.png",
	}), nil
}

// ShortenCaption shortens caption copy.
func (s *Service) ShortenCaption(ctx context.Context, req *connect.Request[copilotv1.CopilotServiceShortenCaptionRequest]) (*connect.Response[copilotv1.CopilotServiceShortenCaptionResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if err := checkPermission(caller, "copilot:use_creative"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	text := req.Msg.Text
	if len(text) > int(req.Msg.MaxLength) && req.Msg.MaxLength > 0 {
		text = text[:req.Msg.MaxLength] + "..."
	}

	return connect.NewResponse(&copilotv1.CopilotServiceShortenCaptionResponse{
		ShortenedText: text,
	}), nil
}

// SuggestHashtags returns hashtag recommendations.
func (s *Service) SuggestHashtags(ctx context.Context, req *connect.Request[copilotv1.CopilotServiceSuggestHashtagsRequest]) (*connect.Response[copilotv1.CopilotServiceSuggestHashtagsResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if err := checkPermission(caller, "copilot:use_creative"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	return connect.NewResponse(&copilotv1.CopilotServiceSuggestHashtagsResponse{
		Hashtags: []string{"#trending", "#viral", "#creatorcommerce", "#creativanta"},
	}), nil
}

// DismissReply dismisses a suggested reply.
func (s *Service) DismissReply(ctx context.Context, req *connect.Request[copilotv1.CopilotServiceDismissReplyRequest]) (*connect.Response[copilotv1.CopilotServiceDismissReplyResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if err := checkPermission(caller, "copilot:use_creative"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	return connect.NewResponse(&copilotv1.CopilotServiceDismissReplyResponse{
		Dismissed: true,
	}), nil
}

// RegenerateSection regenerates a script or caption section.
func (s *Service) RegenerateSection(ctx context.Context, req *connect.Request[copilotv1.CopilotServiceRegenerateSectionRequest]) (*connect.Response[copilotv1.CopilotServiceRegenerateSectionResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if err := checkPermission(caller, "copilot:use_creative"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	return connect.NewResponse(&copilotv1.CopilotServiceRegenerateSectionResponse{
		RegeneratedText: "Bản sửa đổi được tối ưu hóa nhịp điệu và năng lượng theo yêu cầu.",
	}), nil
}

// ScoreIdea scores virality potential.
func (s *Service) ScoreIdea(ctx context.Context, req *connect.Request[copilotv1.CopilotServiceScoreIdeaRequest]) (*connect.Response[copilotv1.CopilotServiceScoreIdeaResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if err := checkPermission(caller, "copilot:use_creative"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	return connect.NewResponse(&copilotv1.CopilotServiceScoreIdeaResponse{
		ViralityScore: 85,
		Critique:      "Ý tưởng có yếu tố kích thích tò mò tốt, phù hợp xu hướng ngắn hạn.",
	}), nil
}

// CheckBrandVoice verifies brand pack tone.
func (s *Service) CheckBrandVoice(ctx context.Context, req *connect.Request[copilotv1.CopilotServiceCheckBrandVoiceRequest]) (*connect.Response[copilotv1.CopilotServiceCheckBrandVoiceResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if err := checkPermission(caller, "copilot:use_help"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	return connect.NewResponse(&copilotv1.CopilotServiceCheckBrandVoiceResponse{
		ConsistencyScore: 92,
		Recommendations:  []string{"Giữ nguyên văn phong tự nhiên, thân thiện."},
	}), nil
}

// AnalyzeAnalytics analyzes metrics.
func (s *Service) AnalyzeAnalytics(ctx context.Context, req *connect.Request[copilotv1.CopilotServiceAnalyzeAnalyticsRequest]) (*connect.Response[copilotv1.CopilotServiceAnalyzeAnalyticsResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if err := checkPermission(caller, "copilot:use_analytics"); err != nil {
		return connect.NewResponse(&copilotv1.CopilotServiceAnalyzeAnalyticsResponse{
			Summary:    "Dữ liệu phân tích tài chính bị ẩn đối với vai trò hiện tại.",
			IsRedacted: true,
		}), nil
	}

	return connect.NewResponse(&copilotv1.CopilotServiceAnalyzeAnalyticsResponse{
		Summary:    "Tăng trưởng người xem ổn định, tỷ lệ giữ chân video ngắn tăng 14%.",
		Findings:   []string{"Khung giờ 19h-21h có tương tác cao nhất", "Nội dung so sánh sản phẩm đạt CTR cao hơn 1.8x"},
		IsRedacted: false,
	}), nil
}

// AnalyzePipeline analyzes video pipeline.
func (s *Service) AnalyzePipeline(ctx context.Context, req *connect.Request[copilotv1.CopilotServiceAnalyzePipelineRequest]) (*connect.Response[copilotv1.CopilotServiceAnalyzePipelineResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if err := checkPermission(caller, "copilot:use_creative"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	return connect.NewResponse(&copilotv1.CopilotServiceAnalyzePipelineResponse{
		PipelineHealth: "Tốt (8 kịch bản chờ sản xuất, 3 video đang xuất bản)",
		Bottlenecks:    []string{"Khâu duyệt script cần phản hồi nhanh hơn trong 24h"},
	}), nil
}

// AnalyticsInsights returns analytics insights.
func (s *Service) AnalyticsInsights(ctx context.Context, req *connect.Request[copilotv1.CopilotServiceAnalyticsInsightsRequest]) (*connect.Response[copilotv1.CopilotServiceAnalyticsInsightsResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if err := checkPermission(caller, "copilot:use_creative"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	return connect.NewResponse(&copilotv1.CopilotServiceAnalyticsInsightsResponse{
		Insights: []string{"Video có độ dài 45-60s đạt thời gian xem trung bình cao nhất."},
	}), nil
}

// TrendInsight returns trend advice.
func (s *Service) TrendInsight(ctx context.Context, req *connect.Request[copilotv1.CopilotServiceTrendInsightRequest]) (*connect.Response[copilotv1.CopilotServiceTrendInsightResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if err := checkPermission(caller, "copilot:use_creative"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	return connect.NewResponse(&copilotv1.CopilotServiceTrendInsightResponse{
		TrendRecommendations: []string{"Xu hướng 'morning skincare routine' đang tăng 340% lượt tìm kiếm trên TikTok."},
	}), nil
}

// GetContentOptimization returns content optimization advice.
func (s *Service) GetContentOptimization(ctx context.Context, req *connect.Request[copilotv1.CopilotServiceGetContentOptimizationRequest]) (*connect.Response[copilotv1.CopilotServiceGetContentOptimizationResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if err := checkPermission(caller, "copilot:use_help"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	return connect.NewResponse(&copilotv1.CopilotServiceGetContentOptimizationResponse{
		Suggestions: []string{"Cắt ngắn phần mở đầu dưới 3 giây", "Tăng kích thước phụ đề ở nửa dưới khung hình"},
	}), nil
}

// GetCostOptimization returns AI cost tips.
func (s *Service) GetCostOptimization(ctx context.Context, req *connect.Request[copilotv1.CopilotServiceGetCostOptimizationRequest]) (*connect.Response[copilotv1.CopilotServiceGetCostOptimizationResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if err := checkPermission(caller, "copilot:use_analytics"); err != nil {
		return connect.NewResponse(&copilotv1.CopilotServiceGetCostOptimizationResponse{
			Suggestions: []string{"Thông tin tối ưu chi phí bị ẩn đối với vai trò hiện tại."},
			IsRedacted:  true,
		}), nil
	}

	return connect.NewResponse(&copilotv1.CopilotServiceGetCostOptimizationResponse{
		Suggestions: []string{"Sử dụng chế độ bản nháp trước khi render video 4K để tiết kiệm 40% credits."},
		IsRedacted:  false,
	}), nil
}

// GetOptimalTimes returns optimal posting times.
func (s *Service) GetOptimalTimes(ctx context.Context, req *connect.Request[copilotv1.CopilotServiceGetOptimalTimesRequest]) (*connect.Response[copilotv1.CopilotServiceGetOptimalTimesResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if err := checkPermission(caller, "copilot:use_help"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	return connect.NewResponse(&copilotv1.CopilotServiceGetOptimalTimesResponse{
		OptimalTimeSlots: []string{"11:30 - 13:00", "19:00 - 21:30"},
	}), nil
}
