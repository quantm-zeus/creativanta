// Package capability implements the M22 Capability Matrix, Connector Action
// Verification Registry, Pre-Execution Capability Gate, Policy Notes, Fallback
// Paths, and Composite Platform Health Score engine.
//
// Canonical contracts:
//   - docs/02_features/platform/capability_matrix.md (M22)
//   - docs/04_contracts/connector_specs.md (§2)
//   - docs/04_contracts/database_schema.md (§3, §4.5, §18.2, §22.15, §25.6)
//   - docs/04_contracts/rbac_permission_matrix.md
//   - docs/04_contracts/rpc_permission_bindings.csv
package capability

import (
	"context"
	"crypto/rand"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"math"
	"sort"
	"strings"
	"sync"
	"time"

	"connectrpc.com/connect"
	adminv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/admin/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/admin/v1/adminv1connect"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/outbox"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
	"google.golang.org/protobuf/proto"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// State represents the 5 canonical values of the capability_state PostgreSQL enum (§3).
// Unknown or stale verification is tracked via VerificationFresh metadata, never as a 6th enum value.
type State string

const (
	StateNative      State = "native"
	StateReadOnly    State = "read_only"
	StateManual      State = "manual"
	StateDegraded    State = "degraded"
	StateUnsupported State = "unsupported"
)

// FallbackKind enumerates the canonical 5 fallback_paths.fallback_type values (§18.2C).
type FallbackKind string

const (
	FallbackManualUpload      FallbackKind = "manual_upload"
	FallbackCSVImport         FallbackKind = "csv_import"
	FallbackWebhookWorkaround FallbackKind = "webhook_workaround"
	FallbackBrowserAssist     FallbackKind = "browser_assist"
	FallbackUnsupported       FallbackKind = "unsupported"
)

const (
	// SnapshotFreshnessTTL is the maximum age (10 minutes) before a capability snapshot is considered stale (RULE-M22).
	SnapshotFreshnessTTL = 10 * time.Minute
	// MaxVerificationTTL is the maximum duration (7 days) a live probe verification may remain valid (§25.6).
	MaxVerificationTTL = 7 * 24 * time.Hour
)

var (
	// ErrUnauthenticated indicates ActorContext is missing or invalid.
	ErrUnauthenticated = errors.New("capability: unauthenticated request")
	// ErrInvalidInput indicates invalid request parameters.
	ErrInvalidInput = errors.New("capability: invalid request input (VALIDATION_ERROR_001)")
	// ErrIdempotencyConflict indicates an idempotency key was reused with a different payload.
	ErrIdempotencyConflict = errors.New("capability: idempotency key reused with different payload (SYSTEM_CONFLICT_001)")
	// ErrAccountNotFound indicates the connected account does not exist in the caller's workspace.
	ErrAccountNotFound = errors.New("capability: connected account not found in workspace")
	// ErrWildcardOrInvalidScope indicates a wildcard (e.g. shop.*) or undocumented scope was supplied (§2).
	ErrWildcardOrInvalidScope = errors.New("capability: wildcard or undocumented OAuth scope is prohibited")
	// ErrUnverifiedRouteCannotExecute indicates an action route lacks verified native capability and cannot execute.
	ErrUnverifiedRouteCannotExecute = fmt.Errorf("%w: unverified, stale, manual, read_only, degraded, or unsupported route cannot execute", rbac.ErrCapabilityUnavailable)
)

// UnverifiedRouteError provides the structured user-facing explanation (RULE-M22-001)
// and fallback path (RULE-M22-004) whenever pre-execution is denied.
type UnverifiedRouteError struct {
	Platform          string
	ActionKey         string
	State             State
	VerificationFresh bool
	Reason            string
	PolicyNote        PolicyNoteSpec
	FallbackPath      FallbackPathSpec
}

func (e *UnverifiedRouteError) Error() string {
	return fmt.Sprintf("%s: platform=%s action=%s state=%s fresh=%v reason=%s fallback=%s",
		ErrUnverifiedRouteCannotExecute.Error(), e.Platform, e.ActionKey, e.State, e.VerificationFresh, e.Reason, e.FallbackPath.FallbackType)
}

func (e *UnverifiedRouteError) Unwrap() error {
	return ErrUnverifiedRouteCannotExecute
}

// ActorContext carries the authenticated workspace caller identity.
type ActorContext struct {
	UserID           string
	WorkspaceID      string
	WorkspaceRole    string
	WorkspaceActive  bool
	MembershipActive bool
	IsImpersonation  bool
}

type actorContextKey struct{}

// WithActorContext attaches an ActorContext to ctx.
func WithActorContext(ctx context.Context, actor ActorContext) context.Context {
	return context.WithValue(ctx, actorContextKey{}, actor)
}

// ActorFromContext extracts ActorContext from ctx.
func ActorFromContext(ctx context.Context) (ActorContext, bool) {
	if ctx == nil {
		return ActorContext{}, false
	}
	a, ok := ctx.Value(actorContextKey{}).(ActorContext)
	return a, ok
}

// KillSwitchChecker reports whether an emergency kill switch or maintenance lock is active.
type KillSwitchChecker interface {
	IsCapabilityKilled(platform, actionKey string) (bool, string)
}

// ActionAccessVerification implements the canonical contract from database_schema.md §25.6.
type ActionAccessVerification struct {
	Platform          string
	Product           string
	ActionKey         string
	AppApprovalStatus string // "unsubmitted" | "pending" | "approved" | "rejected" | "suspended"
	RequiredScopes    []string
	GrantedScopes     []string
	AccountEligible   bool
	MarketEligibility []string
	ProbeEndpoint     string
	ProbeMethod       string // "GET" | "POST" | "PUT" | "DELETE"
	ProbeStatus       string // "not_run" | "passed" | "failed"
	CheckedAt         time.Time
	ValidUntil        time.Time
}

// PolicyNoteSpec describes the canonical policy explanation for a platform capability (§18.2B).
type PolicyNoteSpec struct {
	PolicyNoteID  string
	Platform      string
	CapabilityKey string
	Summary       string
	Detail        string
	SourceURL     string
	UpdatedAt     time.Time
}

// FallbackPathSpec describes the canonical fallback instructions for a non-native capability (§18.2C).
type FallbackPathSpec struct {
	FallbackPathID      string
	Platform            string
	CapabilityKey       string
	FallbackType        FallbackKind
	Instructions        string
	EstimatedEffort     string
	RelatedPolicyNoteID string
}

// PlatformActionSpec defines the default fail-closed state and required scopes for a platform action.
type PlatformActionSpec struct {
	Platform        string
	ActionKey       string
	DisplayName     string
	Product         string
	RequiresWrite   bool
	DefaultState    State
	RequiredScopes  []string
	SupportedMarket []string
	PolicyNote      PolicyNoteSpec
	FallbackPath    FallbackPathSpec
}

// ConnectedAccountRecord models a workspace connected account with internal encrypted token fields
// that are NEVER serialized to API responses (RULE-M22-005).
type ConnectedAccountRecord struct {
	ConnectedAccountID    string
	WorkspaceID           string
	Platform              string
	AccountType           string
	ExternalAccountID     string
	AccountName           string
	Status                string // "active" | "expired" | "revoked" | "disconnected" | "error"
	HealthScore           int
	GrantedScopes         []string
	Market                string
	AccessTokenEncrypted  []byte // stripped from all API responses (RULE-M22-005)
	RefreshTokenEncrypted []byte // stripped from all API responses (RULE-M22-005)
	TokenExpiresAt        time.Time
	LastSyncedAt          time.Time
}

// HealthMetricsInput supplies raw telemetry for computing the composite 0-100 health score (RULE-M22-003)
// and optional proactive business coaching cards (PRD §36B).
type HealthMetricsInput struct {
	AvailabilityPct            float64 // weight 40%
	ErrorRatePct               float64 // weight 25% (lower error rate -> higher score)
	LatencyP95Ms               float64 // weight 20%
	RateLimitRemainingPct      float64 // weight 15%
	ShopResponseNumerator      int64   // optional business coaching metric (PRD §36B)
	ShopResponseDenom          int64
	ListingQualityNumerator    int64 // listing quality < 80%
	ListingQualityDenom        int64
	DelayedFulfillmentCount    int32   // fulfillment delay > 24h
	EngagementDropPct          float64 // engagement drop > 20%
	ConnectorAuthExpiresInDays int32   // auth expiring in <= 3 days
	BusinessWindowLabel        string
}

// EvaluationResult holds the resolved capability state and verification metadata for a platform action.
type EvaluationResult struct {
	Platform          string
	ActionKey         string
	DisplayName       string
	State             State
	VerificationFresh bool
	Executable        bool
	Reason            string
	PolicyNote        PolicyNoteSpec
	FallbackPath      FallbackPathSpec
	CheckedAt         time.Time
	ValidUntil        time.Time
}

// CanonicalPlatformActions returns the fail-closed baseline registry across all 6 platforms (connector_specs.md §2).
// Every action starts as 'manual' (when an authorized handoff/export/import exists) or 'unsupported'
// until a live ActionAccessVerification proves 'native' or 'read_only' access.
func CanonicalPlatformActions() []PlatformActionSpec {
	return []PlatformActionSpec{
		// TikTok
		{
			Platform:        "tiktok",
			ActionKey:       "publish_post",
			DisplayName:     "Đăng video trực tiếp TikTok",
			Product:         "TikTok Content Posting API",
			RequiresWrite:   true,
			DefaultState:    StateManual,
			RequiredScopes:  []string{"video.publish", "video.upload"},
			SupportedMarket: []string{"VN", "SG", "TH", "ID", "MY", "PH", "US", "GB"},
			PolicyNote: PolicyNoteSpec{
				PolicyNoteID:  "00000000-0000-4000-8000-000000002201",
				Platform:      "tiktok",
				CapabilityKey: "publish_post",
				Summary:       "TikTok Direct Post yêu cầu phê duyệt ứng dụng Content Posting API và quyền video.publish + video.upload.",
				Detail:        "Khi tài khoản chưa được phê duyệt Direct Post hoặc thiếu scope, hệ thống chuyển sang chế độ tải lên thủ công có hướng dẫn.",
				SourceURL:     "https://developers.tiktok.com/doc/content-posting-api-get-started",
			},
			FallbackPath: FallbackPathSpec{
				FallbackPathID:      "00000000-0000-4000-8000-000000002301",
				Platform:            "tiktok",
				CapabilityKey:       "publish_post",
				FallbackType:        FallbackManualUpload,
				Instructions:        "Tải gói xuất bản (video + caption + hashtag) từ Publish Hub và đăng qua TikTok Studio.",
				EstimatedEffort:     "2 phút",
				RelatedPolicyNoteID: "00000000-0000-4000-8000-000000002201",
			},
		},
		{
			Platform:        "tiktok",
			ActionKey:       "read_analytics",
			DisplayName:     "Đồng bộ chỉ số video TikTok",
			Product:         "TikTok Display API",
			RequiresWrite:   false,
			DefaultState:    StateManual,
			RequiredScopes:  []string{"user.info.basic", "video.list"},
			SupportedMarket: []string{"VN", "SG", "TH", "ID", "MY", "PH", "US", "GB"},
			PolicyNote: PolicyNoteSpec{
				PolicyNoteID:  "00000000-0000-4000-8000-000000002202",
				Platform:      "tiktok",
				CapabilityKey: "read_analytics",
				Summary:       "Đồng bộ chỉ số TikTok yêu cầu quyền user.info.basic và video.list.",
				Detail:        "Nếu chưa cấp quyền đọc danh sách video, bạn có thể nhập báo cáo CSV từ TikTok Analytics.",
				SourceURL:     "https://developers.tiktok.com/doc/display-api-get-started",
			},
			FallbackPath: FallbackPathSpec{
				FallbackPathID:      "00000000-0000-4000-8000-000000002302",
				Platform:            "tiktok",
				CapabilityKey:       "read_analytics",
				FallbackType:        FallbackCSVImport,
				Instructions:        "Xuất tệp CSV từ TikTok Studio Analytics và tải lên mục Nhập dữ liệu.",
				EstimatedEffort:     "3 phút",
				RelatedPolicyNoteID: "00000000-0000-4000-8000-000000002202",
			},
		},
		{
			Platform:        "tiktok",
			ActionKey:       "sync_orders",
			DisplayName:     "Đồng bộ đơn hàng TikTok Shop",
			Product:         "TikTok Shop Partner API",
			RequiresWrite:   false,
			DefaultState:    StateManual,
			RequiredScopes:  []string{"seller.order.info"},
			SupportedMarket: []string{"VN", "SG", "TH", "ID", "MY", "PH", "US", "GB"},
			PolicyNote: PolicyNoteSpec{
				PolicyNoteID:  "00000000-0000-4000-8000-000000002203",
				Platform:      "tiktok",
				CapabilityKey: "sync_orders",
				Summary:       "Đồng bộ đơn hàng TikTok Shop yêu cầu ứng dụng Partner được duyệt và scope seller.order.info (cấm wildcard shop.*).",
				Detail:        "Chỉ các quyền cụ thể đã được TikTok Shop Partner Center phê duyệt mới được phép thực thi.",
				SourceURL:     "https://partner.tiktokshop.com/docv2/page/6507ead7b99d5302be949ba9",
			},
			FallbackPath: FallbackPathSpec{
				FallbackPathID:      "00000000-0000-4000-8000-000000002303",
				Platform:            "tiktok",
				CapabilityKey:       "sync_orders",
				FallbackType:        FallbackCSVImport,
				Instructions:        "Xuất danh sách đơn hàng CSV từ TikTok Seller Center và tải lên Product Hub.",
				EstimatedEffort:     "5 phút",
				RelatedPolicyNoteID: "00000000-0000-4000-8000-000000002203",
			},
		},
		// Shopee
		{
			Platform:        "shopee",
			ActionKey:       "sync_orders",
			DisplayName:     "Đồng bộ đơn hàng Shopee",
			Product:         "Shopee Open Platform v2",
			RequiresWrite:   false,
			DefaultState:    StateManual,
			RequiredScopes:  []string{"order.get_order_list", "order.get_order_detail"},
			SupportedMarket: []string{"VN", "SG", "TH", "ID", "MY", "PH", "TW", "BR"},
			PolicyNote: PolicyNoteSpec{
				PolicyNoteID:  "00000000-0000-4000-8000-000000002204",
				Platform:      "shopee",
				CapabilityKey: "sync_orders",
				Summary:       "Shopee Open Platform v2 yêu cầu phê duyệt App Partner và quyền order.get_order_list + order.get_order_detail.",
				Detail:        "Khi chưa xác minh kết nối API trực tiếp, hệ thống hỗ trợ nhập báo cáo đơn hàng CSV từ Shopee Seller Centre.",
				SourceURL:     "https://open.shopee.com/documents/v2/v2.order.get_order_list",
			},
			FallbackPath: FallbackPathSpec{
				FallbackPathID:      "00000000-0000-4000-8000-000000002304",
				Platform:            "shopee",
				CapabilityKey:       "sync_orders",
				FallbackType:        FallbackCSVImport,
				Instructions:        "Tải báo cáo đơn hàng từ Shopee Seller Centre (My Orders > Export) và nhập vào Product Hub.",
				EstimatedEffort:     "4 phút",
				RelatedPolicyNoteID: "00000000-0000-4000-8000-000000002204",
			},
		},
		{
			Platform:        "shopee",
			ActionKey:       "publish_post",
			DisplayName:     "Đăng video tự động lên Shopee Video",
			Product:         "Shopee Video",
			RequiresWrite:   true,
			DefaultState:    StateUnsupported,
			RequiredScopes:  nil,
			SupportedMarket: []string{"VN", "SG", "TH", "ID", "MY", "PH"},
			PolicyNote: PolicyNoteSpec{
				PolicyNoteID:  "00000000-0000-4000-8000-000000002205",
				Platform:      "shopee",
				CapabilityKey: "publish_post",
				Summary:       "Shopee không cung cấp Public API để đăng Shopee Video tự động từ bên thứ ba.",
				Detail:        "Theo chính sách Shopee Open Platform, tính năng đăng video tự động không được hỗ trợ qua API công khai.",
				SourceURL:     "https://open.shopee.com/documents",
			},
			FallbackPath: FallbackPathSpec{
				FallbackPathID:      "00000000-0000-4000-8000-000000002305",
				Platform:            "shopee",
				CapabilityKey:       "publish_post",
				FallbackType:        FallbackManualUpload,
				Instructions:        "Tải video đã đóng gói từ Creativanta về thiết bị di động và đăng thủ công trong ứng dụng Shopee Video.",
				EstimatedEffort:     "3 phút",
				RelatedPolicyNoteID: "00000000-0000-4000-8000-000000002205",
			},
		},
		// Lazada
		{
			Platform:        "lazada",
			ActionKey:       "sync_orders",
			DisplayName:     "Đồng bộ đơn hàng Lazada",
			Product:         "Lazada Open Platform",
			RequiresWrite:   false,
			DefaultState:    StateManual,
			RequiredScopes:  []string{"orders.read"},
			SupportedMarket: []string{"VN", "SG", "TH", "ID", "MY", "PH"},
			PolicyNote: PolicyNoteSpec{
				PolicyNoteID:  "00000000-0000-4000-8000-000000002206",
				Platform:      "lazada",
				CapabilityKey: "sync_orders",
				Summary:       "Lazada Open Platform yêu cầu ứng dụng được phê duyệt quyền orders.read.",
				Detail:        "Khi chưa có xác minh probe hợp lệ, sử dụng luồng nhập CSV từ Lazada Seller Center.",
				SourceURL:     "https://open.lazada.com/apps/doc/api?path=%2Forders%2Fget",
			},
			FallbackPath: FallbackPathSpec{
				FallbackPathID:      "00000000-0000-4000-8000-000000002306",
				Platform:            "lazada",
				CapabilityKey:       "sync_orders",
				FallbackType:        FallbackCSVImport,
				Instructions:        "Xuất danh sách đơn hàng CSV từ Lazada Seller Center (Orders & Reviews > Export) và tải lên hệ thống.",
				EstimatedEffort:     "4 phút",
				RelatedPolicyNoteID: "00000000-0000-4000-8000-000000002206",
			},
		},
		// YouTube
		{
			Platform:        "youtube",
			ActionKey:       "publish_post",
			DisplayName:     "Đăng YouTube Shorts / Video",
			Product:         "YouTube Data API v3",
			RequiresWrite:   true,
			DefaultState:    StateManual,
			RequiredScopes:  []string{"https://www.googleapis.com/auth/youtube.upload"},
			SupportedMarket: []string{"VN", "SG", "TH", "ID", "MY", "PH", "US", "GB", "GLOBAL"},
			PolicyNote: PolicyNoteSpec{
				PolicyNoteID:  "00000000-0000-4000-8000-000000002207",
				Platform:      "youtube",
				CapabilityKey: "publish_post",
				Summary:       "YouTube Data API v3 yêu cầu Google OAuth verification, hạn mức quota khả dụng và scope youtube.upload.",
				Detail:        "Video tải lên từ project chưa qua kiểm duyệt Google OAuth sẽ bị khóa ở chế độ riêng tư; cần probe xác minh trước khi kích hoạt native.",
				SourceURL:     "https://developers.google.com/youtube/v3/docs/videos/insert",
			},
			FallbackPath: FallbackPathSpec{
				FallbackPathID:      "00000000-0000-4000-8000-000000002307",
				Platform:            "youtube",
				CapabilityKey:       "publish_post",
				FallbackType:        FallbackManualUpload,
				Instructions:        "Tải tệp video và bộ metadata (tiêu đề, mô tả, tags) để đăng qua YouTube Studio.",
				EstimatedEffort:     "2 phút",
				RelatedPolicyNoteID: "00000000-0000-4000-8000-000000002207",
			},
		},
		// Instagram
		{
			Platform:        "instagram",
			ActionKey:       "publish_post",
			DisplayName:     "Đăng Instagram Reels / Bài viết",
			Product:         "Instagram Graph API",
			RequiresWrite:   true,
			DefaultState:    StateManual,
			RequiredScopes:  []string{"instagram_basic", "instagram_content_publish"},
			SupportedMarket: []string{"VN", "SG", "TH", "ID", "MY", "PH", "US", "GB", "GLOBAL"},
			PolicyNote: PolicyNoteSpec{
				PolicyNoteID:  "00000000-0000-4000-8000-000000002208",
				Platform:      "instagram",
				CapabilityKey: "publish_post",
				Summary:       "Instagram Graph API chỉ hỗ trợ tài khoản Professional (Business/Creator) với quyền instagram_content_publish.",
				Detail:        "Tài khoản cá nhân (Personal) không được Meta cấp quyền đăng bài qua API; cần chuyển sang tài khoản Professional hoặc đăng thủ công.",
				SourceURL:     "https://developers.facebook.com/docs/instagram-platform/instagram-graph-api/content-publishing",
			},
			FallbackPath: FallbackPathSpec{
				FallbackPathID:      "00000000-0000-4000-8000-000000002308",
				Platform:            "instagram",
				CapabilityKey:       "publish_post",
				FallbackType:        FallbackManualUpload,
				Instructions:        "Sử dụng Meta Business Suite hoặc ứng dụng Instagram để đăng video và dán caption từ gói xuất bản.",
				EstimatedEffort:     "2 phút",
				RelatedPolicyNoteID: "00000000-0000-4000-8000-000000002208",
			},
		},
		// Facebook
		{
			Platform:        "facebook",
			ActionKey:       "publish_post",
			DisplayName:     "Đăng Facebook Page Reels / Video",
			Product:         "Meta Graph API",
			RequiresWrite:   true,
			DefaultState:    StateManual,
			RequiredScopes:  []string{"pages_manage_posts", "pages_read_engagement"},
			SupportedMarket: []string{"VN", "SG", "TH", "ID", "MY", "PH", "US", "GB", "GLOBAL"},
			PolicyNote: PolicyNoteSpec{
				PolicyNoteID:  "00000000-0000-4000-8000-000000002209",
				Platform:      "facebook",
				CapabilityKey: "publish_post",
				Summary:       "Meta Graph API yêu cầu Facebook Page token kèm quyền pages_manage_posts và pages_read_engagement.",
				Detail:        "Chỉ Facebook Page đã cấp quyền App Review mới thực thi đăng bài tự động; trang cá nhân chỉ hỗ trợ tải lên thủ công.",
				SourceURL:     "https://developers.facebook.com/docs/video-api/guides/publishing",
			},
			FallbackPath: FallbackPathSpec{
				FallbackPathID:      "00000000-0000-4000-8000-000000002309",
				Platform:            "facebook",
				CapabilityKey:       "publish_post",
				FallbackType:        FallbackManualUpload,
				Instructions:        "Tải gói xuất bản từ Publish Hub và lên lịch trực tiếp trên Meta Business Suite.",
				EstimatedEffort:     "2 phút",
				RelatedPolicyNoteID: "00000000-0000-4000-8000-000000002209",
			},
		},
	}
}

// ValidateScopes enforces connector_specs.md §2: wildcard scopes (e.g. "shop.*") or blank scopes are prohibited.
func ValidateScopes(scopes []string) error {
	for _, sc := range scopes {
		trimmed := strings.TrimSpace(sc)
		if trimmed == "" || strings.Contains(trimmed, "*") {
			return fmt.Errorf("%w: %q", ErrWildcardOrInvalidScope, sc)
		}
	}
	return nil
}

// EvaluateActionAccess implements the canonical ActionAccessVerification promotion rules
// from database_schema.md §25.6 and connector_specs.md §2.
//
// Key invariants:
//  1. Every platform/action starts at spec.DefaultState ('manual' or 'unsupported').
//  2. If an active kill switch applies, state immediately becomes 'degraded' and Executable=false.
//  3. If the action has no lawful API path (spec.DefaultState == 'unsupported'), it remains 'unsupported' and Executable=false.
//  4. Wildcard scopes (e.g., "shop.*") are rejected.
//  5. Promotion requires: connected account active & token not expired, AppApprovalStatus == "approved",
//     AccountEligible == true, targetMarket in MarketEligibility, ProbeStatus == "passed",
//     ValidUntil > now, ValidUntil <= CheckedAt + 7d, and snapshot age <= 10 minutes.
//  6. A read-only probe (ProbeMethod == "GET") can at most yield StateReadOnly; it NEVER grants StateNative
//     or Executable=true for a write action (spec.RequiresWrite == true).
func EvaluateActionAccess(
	spec PlatformActionSpec,
	account *ConnectedAccountRecord,
	verification *ActionAccessVerification,
	targetMarket string,
	requireWrite bool,
	killed bool,
	killReason string,
	now time.Time,
) EvaluationResult {
	res := EvaluationResult{
		Platform:          spec.Platform,
		ActionKey:         spec.ActionKey,
		DisplayName:       spec.DisplayName,
		State:             spec.DefaultState,
		VerificationFresh: false,
		Executable:        false,
		PolicyNote:        spec.PolicyNote,
		FallbackPath:      spec.FallbackPath,
		CheckedAt:         now,
	}

	if killed {
		res.State = StateDegraded
		res.Executable = false
		res.VerificationFresh = true
		if strings.TrimSpace(killReason) == "" {
			killReason = "Tính năng này đang tạm ngắt khẩn cấp (Kill Switch) bởi quản trị viên hệ thống."
		}
		res.Reason = killReason
		res.PolicyNote.Summary = killReason
		return res
	}

	if spec.DefaultState == StateUnsupported || len(spec.RequiredScopes) == 0 {
		res.State = StateUnsupported
		res.Executable = false
		res.VerificationFresh = true
		res.Reason = spec.PolicyNote.Summary
		return res
	}

	if account == nil {
		res.Reason = "Chưa có tài khoản kết nối cho nền tảng này; sử dụng phương án dự phòng thủ công."
		return res
	}

	if account.Status != "active" && account.Status != "connected" {
		res.State = StateDegraded
		res.Reason = fmt.Sprintf("Tài khoản kết nối đang ở trạng thái %q; cần kết nối lại trước khi thực thi tự động.", account.Status)
		return res
	}

	if !account.TokenExpiresAt.IsZero() && !account.TokenExpiresAt.After(now) {
		res.State = StateDegraded
		res.Reason = "OAuth token của tài khoản đã hết hạn; cần làm mới hoặc kết nối lại."
		return res
	}

	if err := ValidateScopes(account.GrantedScopes); err != nil {
		res.Reason = "Phát hiện scope không hợp lệ hoặc chứa ký tự đại diện (wildcard); từ chối cấp quyền native."
		return res
	}

	if verification == nil {
		res.Reason = "Tác vụ chưa có bản ghi xác minh thực tế (ActionAccessVerification); chỉ cho phép phương án thủ công."
		return res
	}

	if err := ValidateScopes(verification.GrantedScopes); err != nil {
		res.Reason = "Bản ghi xác minh chứa wildcard scope bị cấm (ví dụ shop.*); giữ ở trạng thái dự phòng."
		return res
	}
	if err := ValidateScopes(verification.RequiredScopes); err != nil {
		res.Reason = "Cấu hình required_scopes không hợp lệ."
		return res
	}

	res.CheckedAt = verification.CheckedAt
	res.ValidUntil = verification.ValidUntil

	if verification.AppApprovalStatus != "approved" {
		res.Reason = fmt.Sprintf("Ứng dụng đối tác chưa được phê duyệt hoàn tất (app_approval_status=%q).", verification.AppApprovalStatus)
		return res
	}

	if !verification.AccountEligible {
		res.Reason = "Loại tài khoản người dùng chưa đủ điều kiện sử dụng API này (account_eligible=false)."
		return res
	}

	mkt := strings.ToUpper(strings.TrimSpace(targetMarket))
	if mkt == "" {
		mkt = strings.ToUpper(strings.TrimSpace(account.Market))
	}
	if mkt == "" {
		mkt = "VN"
	}
	if !marketAllowed(mkt, verification.MarketEligibility) {
		res.Reason = fmt.Sprintf("Thị trường %q không nằm trong danh sách được cấp phép của API (%v).", mkt, verification.MarketEligibility)
		return res
	}

	// RequiredScopes must be a subset of both account.GrantedScopes and verification.GrantedScopes.
	if !scopesSubset(spec.RequiredScopes, account.GrantedScopes) || !scopesSubset(spec.RequiredScopes, verification.GrantedScopes) {
		res.Reason = fmt.Sprintf("Tài khoản thiếu quyền OAuth bắt buộc (%v).", spec.RequiredScopes)
		return res
	}

	if verification.ProbeStatus != "passed" {
		res.Reason = fmt.Sprintf("Kiểm tra kết nối thực tế (probe) chưa đạt (probe_status=%q).", verification.ProbeStatus)
		return res
	}

	// Freshness checks (§25.6 & capability_matrix.md):
	// 1) valid_until must be in the future and at most 7 days after checked_at
	// 2) snapshot age must not exceed 10 minutes (SnapshotFreshnessTTL)
	if verification.CheckedAt.IsZero() || verification.ValidUntil.IsZero() ||
		!verification.ValidUntil.After(now) ||
		verification.ValidUntil.Sub(verification.CheckedAt) > MaxVerificationTTL ||
		now.Sub(verification.CheckedAt) > SnapshotFreshnessTTL {
		res.VerificationFresh = false
		res.Executable = false
		res.Reason = "Bản ghi xác minh năng lực đã quá hạn (stale > 10 phút hoặc hết hạn valid_until); cần xác minh lại trước khi thực thi tự động."
		return res
	}

	res.VerificationFresh = true

	// A read-only probe (GET) can at most unlock StateReadOnly, NEVER StateNative for write actions!
	probeMethod := strings.ToUpper(strings.TrimSpace(verification.ProbeMethod))
	if probeMethod == "GET" && (spec.RequiresWrite || requireWrite) {
		res.State = StateReadOnly
		res.Executable = false
		res.Reason = "Probe chỉ xác minh quyền đọc (GET); không cấp quyền thực thi ghi (native write)."
		return res
	}

	if !spec.RequiresWrite && !requireWrite {
		if probeMethod == "GET" {
			res.State = StateNative
			res.Executable = true
			res.Reason = "Đã xác minh đầy đủ quyền đọc trực tiếp qua API."
			return res
		}
	}

	res.State = StateNative
	res.Executable = true
	res.Reason = "Đã xác minh đầy đủ phê duyệt ứng dụng, OAuth scopes, điều kiện tài khoản/thị trường và probe thực tế."
	return res
}

// ComputeHealthScore calculates the composite 0-100 platform health score per RULE-M22-003:
//   - API availability: 40%
//   - Error rate: 25% (100 - errorRatePct*2, clamped 0..100)
//   - Latency: 20% (<=200ms -> 100, >=2000ms -> 0, linear interpolation)
//   - Rate limit remaining: 15%
//
// Also evaluates proactive business coaching cards per PRD §36B without altering technical capability state.
func ComputeHealthScore(
	healthScoreID, connectedAccountID, platform string,
	input HealthMetricsInput,
	now time.Time,
) *adminv1.PlatformHealthScoreCard {
	avail := clampScore(input.AvailabilityPct)
	errScore := clampScore(100.0 - (input.ErrorRatePct * 2.0))
	latScore := 100
	if input.LatencyP95Ms > 200 {
		latScore = clampScore(100.0 - ((input.LatencyP95Ms-200.0)/1800.0)*100.0)
	}
	rateScore := clampScore(input.RateLimitRemainingPct)

	composite := float64(avail)*0.40 + float64(errScore)*0.25 + float64(latScore)*0.20 + float64(rateScore)*0.15
	overall := clampScore(composite)

	band := "healthy"
	var riskFlags []string
	if overall < 50 {
		band = "critical"
		riskFlags = append(riskFlags, "critical_health_score")
	} else if overall < 80 {
		band = "degraded"
		riskFlags = append(riskFlags, "degraded_health_score")
	}
	if avail < 90 {
		riskFlags = append(riskFlags, "low_api_availability")
	}
	if input.ErrorRatePct > 10 {
		riskFlags = append(riskFlags, "elevated_api_error_rate")
	}
	if rateScore < 20 {
		riskFlags = append(riskFlags, "rate_limit_near_exhaustion")
	}

	var coaching []*adminv1.ProactiveCoachingCard
	// Rule 1 (PRD §36B): Shop response rate < 90% -> alert + CTA [Mở Inbox]
	if input.ShopResponseDenom > 0 {
		ratePct := (float64(input.ShopResponseNumerator) / float64(input.ShopResponseDenom)) * 100.0
		if ratePct < 90.0 {
			win := strings.TrimSpace(input.BusinessWindowLabel)
			if win == "" {
				win = "7d"
			}
			obs := fmt.Sprintf("%.0f%%", math.Round(ratePct))
			coaching = append(coaching, &adminv1.ProactiveCoachingCard{
				MetricKey:      "shop_response_rate",
				ObservedValue:  obs,
				ThresholdValue: "90%",
				Numerator:      input.ShopResponseNumerator,
				Denominator:    input.ShopResponseDenom,
				WindowLabel:    win,
				Message: fmt.Sprintf(
					"Tỷ lệ phản hồi khách hàng của gian hàng đạt %s (%d/%d trong %s), thấp hơn ngưỡng khuyến nghị 90%%. [Mở Inbox]",
					obs, input.ShopResponseNumerator, input.ShopResponseDenom, win,
				),
				RecommendedActions: []string{
					"Bật gợi ý trả lời nhanh trong Unified Inbox (M12)",
					"Thiết lập quy tắc phân luồng tin nhắn ưu tiên đơn hàng",
				},
			})
		}
	}

	// Rule 2 (PRD §36B): Listing quality < 80% -> alert + CTA [Sửa sản phẩm]
	if input.ListingQualityDenom > 0 {
		qualPct := (float64(input.ListingQualityNumerator) / float64(input.ListingQualityDenom)) * 100.0
		if qualPct < 80.0 {
			win := strings.TrimSpace(input.BusinessWindowLabel)
			if win == "" {
				win = "30d"
			}
			obs := fmt.Sprintf("%.0f%%", math.Round(qualPct))
			coaching = append(coaching, &adminv1.ProactiveCoachingCard{
				MetricKey:      "listing_quality",
				ObservedValue:  obs,
				ThresholdValue: "80%",
				Numerator:      input.ListingQualityNumerator,
				Denominator:    input.ListingQualityDenom,
				WindowLabel:    win,
				Message: fmt.Sprintf(
					"Điểm chất lượng niêm yết sản phẩm đạt %s (%d/%d đạt chuẩn trong %s), thấp hơn ngưỡng 80%%. [Sửa sản phẩm]",
					obs, input.ListingQualityNumerator, input.ListingQualityDenom, win,
				),
				RecommendedActions: []string{
					"Bổ sung thuộc tính sản phẩm và mô tả chuẩn SEO trong Product Hub (M13)",
					"Tạo video showcase sản phẩm độ phân giải cao bằng AI Video Studio (M07)",
				},
			})
		}
	}

	// Rule 3 (PRD §36B): Order fulfillment delay -> alert + CTA [Xem đơn hàng]
	if input.DelayedFulfillmentCount > 0 {
		coaching = append(coaching, &adminv1.ProactiveCoachingCard{
			MetricKey:      "fulfillment_delay",
			ObservedValue:  fmt.Sprintf("%d", input.DelayedFulfillmentCount),
			ThresholdValue: "0",
			Numerator:      int64(input.DelayedFulfillmentCount),
			Denominator:    int64(input.DelayedFulfillmentCount),
			WindowLabel:    "24h",
			Message: fmt.Sprintf(
				"%d đơn hàng chưa xử lý quá 24h — nguy cơ bị sàn phạt tỷ lệ giao trễ. [Xem đơn hàng]",
				input.DelayedFulfillmentCount,
			),
			RecommendedActions: []string{
				"In phiếu đóng gói và bàn giao đối tác vận chuyển trong Product Hub (M13)",
				"Tự động cập nhật tồn kho sàn qua Workflow Studio (M20)",
			},
		})
	}

	// Rule 4 (PRD §36B): Engagement rate drop > 20% -> alert + CTA [Xem phân tích]
	if input.EngagementDropPct > 20.0 {
		coaching = append(coaching, &adminv1.ProactiveCoachingCard{
			MetricKey:      "engagement_drop",
			ObservedValue:  fmt.Sprintf("-%.0f%%", input.EngagementDropPct),
			ThresholdValue: "-20%",
			Numerator:      int64(input.EngagementDropPct),
			Denominator:    100,
			WindowLabel:    "7d",
			Message: fmt.Sprintf(
				"Tương tác kênh %s giảm %.0f%% tuần này so với tuần trước. [Xem phân tích]",
				platform, input.EngagementDropPct,
			),
			RecommendedActions: []string{
				"Phân tích nội dung thịnh hành và đối thủ cạnh tranh bằng M03 Research",
				"Sản xuất kịch bản và hook bắt trend mới từ M06 Script Lab",
			},
		})
	}

	// Rule 5 (PRD §36B): Connector auth expiring in <= 3 days -> alert + CTA [Gia hạn]
	if input.ConnectorAuthExpiresInDays > 0 && input.ConnectorAuthExpiresInDays <= 3 {
		coaching = append(coaching, &adminv1.ProactiveCoachingCard{
			MetricKey:      "connector_auth_expiring",
			ObservedValue:  fmt.Sprintf("%d ngày", input.ConnectorAuthExpiresInDays),
			ThresholdValue: "3 ngày",
			Numerator:      int64(input.ConnectorAuthExpiresInDays),
			Denominator:    3,
			WindowLabel:    "realtime",
			Message: fmt.Sprintf(
				"Kết nối %s hết hạn trong %d ngày — cần gia hạn ủy quyền token. [Gia hạn]",
				platform, input.ConnectorAuthExpiresInDays,
			),
			RecommendedActions: []string{
				"Mở Cài đặt kết nối (M22) và xác thực lại token OAuth sàn",
				"Kiểm tra danh sách quyền (scopes) trước khi phiên làm việc gián đoạn",
			},
		})
	}

	return &adminv1.PlatformHealthScoreCard{
		HealthScoreId:      &commonv1.UUID{Value: healthScoreID},
		ConnectedAccountId: &commonv1.UUID{Value: connectedAccountID},
		Platform:           platform,
		OverallScore:       int32(overall),
		StatusBand:         band,
		AvailabilityScore:  int32(avail),
		ErrorRateScore:     int32(errScore),
		LatencyScore:       int32(latScore),
		RateLimitScore:     int32(rateScore),
		RiskFlags:          riskFlags,
		CoachingCards:      coaching,
		CapturedAt:         timestamppb.New(now),
	}
}

func clampScore(v float64) int {
	r := int(math.Round(v))
	if r < 0 {
		return 0
	}
	if r > 100 {
		return 100
	}
	return r
}

func marketAllowed(target string, allowed []string) bool {
	if len(allowed) == 0 {
		return false
	}
	for _, m := range allowed {
		u := strings.ToUpper(strings.TrimSpace(m))
		if u == "GLOBAL" || u == target {
			return true
		}
	}
	return false
}

func scopesSubset(required, granted []string) bool {
	set := make(map[string]struct{}, len(granted))
	for _, g := range granted {
		set[strings.TrimSpace(g)] = struct{}{}
	}
	for _, r := range required {
		if _, ok := set[strings.TrimSpace(r)]; !ok {
			return false
		}
	}
	return true
}

type cachedCommandResult struct {
	requestHash string
	response    any
}

// Service implements both CapabilityService and ConnectorService (M22).
type Service struct {
	adminv1connect.UnimplementedCapabilityServiceHandler
	adminv1connect.UnimplementedConnectorServiceHandler

	mu          sync.Mutex
	Bindings    *rbac.Registry
	Beginner    tenantdb.TxBeginner
	KillSwitch  KillSwitchChecker
	IDGenerator func() string
	Now         func() time.Time

	actions       map[string]PlatformActionSpec                          // platform::action -> spec
	accounts      map[string]map[string]*ConnectedAccountRecord          // workspaceID -> accountID -> record
	verifications map[string]map[string]*ActionAccessVerification        // workspaceID -> accountID::platform::action -> verification
	healthInputs  map[string]map[string]HealthMetricsInput               // workspaceID -> accountID -> input
	healthScores  map[string]map[string]*adminv1.PlatformHealthScoreCard // workspaceID -> accountID -> card
	lastStates    map[string]map[string]State                            // workspaceID -> platform::action -> last state
	idempotency   map[string]cachedCommandResult
	emittedEvents []outbox.DomainEventEnvelope
	audits        []outbox.AuditLogEntry
}

// NewService constructs a new M22 Capability & Connector service initialized with the canonical 6-platform registry.
func NewService(bindings *rbac.Registry, killSwitch KillSwitchChecker) *Service {
	actions := make(map[string]PlatformActionSpec)
	for _, spec := range CanonicalPlatformActions() {
		actions[actionMapKey(spec.Platform, spec.ActionKey)] = spec
	}
	return &Service{
		Bindings:      bindings,
		KillSwitch:    killSwitch,
		IDGenerator:   generateUUIDv4,
		Now:           func() time.Time { return time.Now().UTC() },
		actions:       actions,
		accounts:      make(map[string]map[string]*ConnectedAccountRecord),
		verifications: make(map[string]map[string]*ActionAccessVerification),
		healthInputs:  make(map[string]map[string]HealthMetricsInput),
		healthScores:  make(map[string]map[string]*adminv1.PlatformHealthScoreCard),
		lastStates:    make(map[string]map[string]State),
		idempotency:   make(map[string]cachedCommandResult),
	}
}

func actionMapKey(platform, actionKey string) string {
	return strings.ToLower(strings.TrimSpace(platform)) + "::" + strings.ToLower(strings.TrimSpace(actionKey))
}

func verificationMapKey(accountID, platform, actionKey string) string {
	return strings.TrimSpace(accountID) + "::" + actionMapKey(platform, actionKey)
}

func generateUUIDv4() string {
	var b [16]byte
	if _, err := rand.Read(b[:]); err != nil {
		panic(fmt.Sprintf("capability: crypto/rand failed: %v", err))
	}
	b[6] = (b[6] & 0x0f) | 0x40
	b[8] = (b[8] & 0x3f) | 0x80
	return fmt.Sprintf("%08x-%04x-%04x-%04x-%012x", b[0:4], b[4:6], b[6:8], b[8:10], b[10:16])
}

func hashIdempotencyPayload(parts ...string) string {
	h := sha256.New()
	for _, p := range parts {
		h.Write([]byte(p))
		h.Write([]byte{0})
	}
	return hex.EncodeToString(h.Sum(nil))
}

// RegisterConnectedAccount seeds or updates a connected account in the workspace.
func (s *Service) RegisterConnectedAccount(rec ConnectedAccountRecord) error {
	if !tenantdb.IsValidNonZeroUUID(rec.WorkspaceID) || !tenantdb.IsValidNonZeroUUID(rec.ConnectedAccountID) {
		return tenantdb.ErrInvalidTenantScope
	}
	if err := ValidateScopes(rec.GrantedScopes); err != nil {
		return err
	}
	if rec.Status == "" {
		rec.Status = "active"
	}
	if rec.HealthScore == 0 {
		rec.HealthScore = 100
	}
	now := s.Now()
	if rec.LastSyncedAt.IsZero() {
		rec.LastSyncedAt = now
	}

	s.mu.Lock()
	defer s.mu.Unlock()
	wsAccs, ok := s.accounts[rec.WorkspaceID]
	if !ok {
		wsAccs = make(map[string]*ConnectedAccountRecord)
		s.accounts[rec.WorkspaceID] = wsAccs
	}
	cp := rec
	cp.GrantedScopes = append([]string(nil), rec.GrantedScopes...)
	cp.AccessTokenEncrypted = append([]byte(nil), rec.AccessTokenEncrypted...)
	cp.RefreshTokenEncrypted = append([]byte(nil), rec.RefreshTokenEncrypted...)
	wsAccs[rec.ConnectedAccountID] = &cp
	return nil
}

// RecordVerification stores a live ActionAccessVerification record for a connected account and action.
// Rejects wildcard scopes (e.g. "shop.*") immediately per connector_specs.md §2.
func (s *Service) RecordVerification(workspaceID, connectedAccountID string, v ActionAccessVerification) error {
	if !tenantdb.IsValidNonZeroUUID(workspaceID) || !tenantdb.IsValidNonZeroUUID(connectedAccountID) {
		return tenantdb.ErrInvalidTenantScope
	}
	if err := ValidateScopes(v.RequiredScopes); err != nil {
		return err
	}
	if err := ValidateScopes(v.GrantedScopes); err != nil {
		return err
	}

	s.mu.Lock()
	defer s.mu.Unlock()
	wsVer, ok := s.verifications[workspaceID]
	if !ok {
		wsVer = make(map[string]*ActionAccessVerification)
		s.verifications[workspaceID] = wsVer
	}
	cp := v
	cp.RequiredScopes = append([]string(nil), v.RequiredScopes...)
	cp.GrantedScopes = append([]string(nil), v.GrantedScopes...)
	cp.MarketEligibility = append([]string(nil), v.MarketEligibility...)
	wsVer[verificationMapKey(connectedAccountID, v.Platform, v.ActionKey)] = &cp
	return nil
}

// SetHealthMetrics sets the latest telemetry metrics for a connected account.
func (s *Service) SetHealthMetrics(workspaceID, connectedAccountID string, metrics HealthMetricsInput) {
	s.mu.Lock()
	defer s.mu.Unlock()
	wsInputs, ok := s.healthInputs[workspaceID]
	if !ok {
		wsInputs = make(map[string]HealthMetricsInput)
		s.healthInputs[workspaceID] = wsInputs
	}
	wsInputs[connectedAccountID] = metrics
}

// EmittedEvents returns a copy of domain events emitted by capability/health transitions.
func (s *Service) EmittedEvents() []outbox.DomainEventEnvelope {
	s.mu.Lock()
	defer s.mu.Unlock()
	out := make([]outbox.DomainEventEnvelope, len(s.emittedEvents))
	copy(out, s.emittedEvents)
	return out
}

// RequireExecutableCapability is the mandatory pre-execution gate for any platform connector route
// (Acceptance Target #1: "Unverified route cannot execute").
//
// If the requested platform/action is unverified, stale (>10m), manual, read_only (when requireWrite=true),
// degraded, unsupported, or killed by an emergency kill switch, this function returns *UnverifiedRouteError
// containing the user-facing PolicyNote and FallbackPath, and prevents the route from executing.
func (s *Service) RequireExecutableCapability(
	ctx context.Context,
	workspaceID, connectedAccountID, platform, actionKey, targetMarket string,
	requireWrite bool,
) (EvaluationResult, error) {
	if !tenantdb.IsValidNonZeroUUID(workspaceID) {
		return EvaluationResult{}, tenantdb.ErrInvalidTenantScope
	}
	eval := s.evaluateForWorkspaceLockedOrUnlocked(ctx, workspaceID, connectedAccountID, platform, actionKey, targetMarket, requireWrite)
	if !eval.Executable || !eval.VerificationFresh || eval.State != StateNative {
		return eval, &UnverifiedRouteError{
			Platform:          eval.Platform,
			ActionKey:         eval.ActionKey,
			State:             eval.State,
			VerificationFresh: eval.VerificationFresh,
			Reason:            eval.Reason,
			PolicyNote:        eval.PolicyNote,
			FallbackPath:      eval.FallbackPath,
		}
	}
	return eval, nil
}

func (s *Service) evaluateForWorkspaceLockedOrUnlocked(
	ctx context.Context,
	workspaceID, connectedAccountID, platform, actionKey, targetMarket string,
	requireWrite bool,
) EvaluationResult {
	now := s.Now()
	key := actionMapKey(platform, actionKey)

	s.mu.Lock()
	spec, exists := s.actions[key]
	if !exists {
		p := strings.ToLower(strings.TrimSpace(platform))
		a := strings.ToLower(strings.TrimSpace(actionKey))
		spec = PlatformActionSpec{
			Platform:      p,
			ActionKey:     a,
			DisplayName:   fmt.Sprintf("%s/%s", p, a),
			RequiresWrite: requireWrite,
			DefaultState:  StateUnsupported,
			PolicyNote: PolicyNoteSpec{
				PolicyNoteID:  "00000000-0000-4000-8000-000000002299",
				Platform:      p,
				CapabilityKey: a,
				Summary:       "Hành động này chưa được đăng ký trong danh mục Connector chuẩn; mặc định từ chối thực thi.",
				Detail:        "Mọi hành động chưa được xác minh hợp lệ đều bị chặn theo nguyên tắc fail-closed.",
			},
			FallbackPath: FallbackPathSpec{
				FallbackPathID:      "00000000-0000-4000-8000-000000002399",
				Platform:            p,
				CapabilityKey:       a,
				FallbackType:        FallbackUnsupported,
				Instructions:        "Vui lòng thực hiện thao tác trực tiếp trên ứng dụng của nền tảng đối tác.",
				EstimatedEffort:     "Thủ công",
				RelatedPolicyNoteID: "00000000-0000-4000-8000-000000002299",
			},
		}
	}

	var acc *ConnectedAccountRecord
	if wsAccs, ok := s.accounts[workspaceID]; ok {
		if connectedAccountID != "" {
			if found, ok := wsAccs[connectedAccountID]; ok && strings.EqualFold(found.Platform, spec.Platform) {
				cp := *found
				acc = &cp
			}
		} else {
			for _, candidate := range wsAccs {
				if strings.EqualFold(candidate.Platform, spec.Platform) {
					cp := *candidate
					acc = &cp
					break
				}
			}
		}
	}

	var ver *ActionAccessVerification
	if acc != nil {
		if wsVer, ok := s.verifications[workspaceID]; ok {
			if v, ok := wsVer[verificationMapKey(acc.ConnectedAccountID, spec.Platform, spec.ActionKey)]; ok {
				cp := *v
				ver = &cp
			}
		}
	}
	s.mu.Unlock()

	killed := false
	killReason := ""
	if s.KillSwitch != nil {
		killed, killReason = s.KillSwitch.IsCapabilityKilled(spec.Platform, spec.ActionKey)
	}

	eval := EvaluateActionAccess(spec, acc, ver, targetMarket, requireWrite, killed, killReason, now)

	// Track state transitions and emit capability.state_changed when state changes.
	s.mu.Lock()
	wsStates, ok := s.lastStates[workspaceID]
	if !ok {
		wsStates = make(map[string]State)
		s.lastStates[workspaceID] = wsStates
	}
	prev, hadPrev := wsStates[key]
	wsStates[key] = eval.State
	if hadPrev && prev != eval.State {
		payload, _ := json.Marshal(map[string]any{
			"platform":       eval.Platform,
			"capability_key": eval.ActionKey,
			"previous_state": string(prev),
			"current_state":  string(eval.State),
			"reason":         eval.Reason,
		})
		s.emittedEvents = append(s.emittedEvents, outbox.DomainEventEnvelope{
			EventID:       s.IDGenerator(),
			EventType:     "capability.state_changed",
			TargetStream:  outbox.QueueConnectorSync,
			AggregateType: "capability_snapshot",
			AggregateID:   s.IDGenerator(),
			WorkspaceID:   workspaceID,
			Payload:       payload,
			OccurredAt:    now,
		})
	}
	s.mu.Unlock()

	if s.Beginner != nil {
		if actor, ok := ActorFromContext(ctx); ok && actor.WorkspaceID == workspaceID && !actor.IsImpersonation {
			var validUntilPtr *time.Time
			if !eval.ValidUntil.IsZero() {
				vu := eval.ValidUntil
				validUntilPtr = &vu
			}
			_ = tenantdb.WithTx(ctx, s.Beginner, tenantdb.Scope{
				WorkspaceID:             actor.WorkspaceID,
				UserID:                  actor.UserID,
				RequireActiveMembership: true,
			}, func(txCtx context.Context, q *tenantdb.Queries) error {
				_, err := q.InsertCapabilitySnapshot(txCtx, tenantdb.InsertCapabilitySnapshotParams{
					SnapshotID:           s.IDGenerator(),
					WorkspaceID:          actor.WorkspaceID,
					Platform:             eval.Platform,
					CapabilityKey:        eval.ActionKey,
					State:                string(eval.State),
					Reason:               eval.Reason,
					FallbackType:         string(eval.FallbackPath.FallbackType),
					FallbackInstructions: eval.FallbackPath.Instructions,
					PolicyNote:           eval.PolicyNote.Summary,
					CheckedAt:            eval.CheckedAt,
					ValidUntil:           validUntilPtr,
				})
				return err
			})
		}
	}

	return eval
}

func (s *Service) authorize(ctx context.Context, rpcName, requestedWorkspaceID string) (ActorContext, error) {
	actor, ok := ActorFromContext(ctx)
	if !ok || !tenantdb.IsValidNonZeroUUID(actor.UserID) || !tenantdb.IsValidNonZeroUUID(actor.WorkspaceID) {
		return ActorContext{}, ErrUnauthenticated
	}
	if !actor.WorkspaceActive || !actor.MembershipActive {
		return ActorContext{}, rbac.ErrPermissionDenied
	}
	if requestedWorkspaceID != "" && requestedWorkspaceID != actor.WorkspaceID {
		return ActorContext{}, tenantdb.ErrScopeMismatch
	}
	if s.Bindings == nil {
		return ActorContext{}, errors.New("capability: missing RBAC registry")
	}
	_, err := s.Bindings.Authorize(rpcName, rbac.PolicyContext{
		ActorUserID:     actor.UserID,
		WorkspaceID:     actor.WorkspaceID,
		Role:            actor.WorkspaceRole,
		IsImpersonation: actor.IsImpersonation,
	})
	if err != nil {
		return ActorContext{}, err
	}
	return actor, nil
}

// GetMatrix implements CapabilityService/GetMatrix (requires capability:read).
func (s *Service) GetMatrix(
	ctx context.Context,
	req *connect.Request[adminv1.GetMatrixRequest],
) (*connect.Response[adminv1.GetMatrixResponse], error) {
	wsID := ""
	platformFilter := ""
	if req.Msg != nil {
		if req.Msg.GetWorkspaceId() != nil {
			wsID = req.Msg.GetWorkspaceId().GetValue()
		}
		platformFilter = strings.ToLower(strings.TrimSpace(req.Msg.GetPlatformFilter()))
	}
	actor, err := s.authorize(ctx, "CapabilityService/GetMatrix", wsID)
	if err != nil {
		return nil, toConnectError(err)
	}

	specs := CanonicalPlatformActions()
	cells := make([]*adminv1.CapabilityMatrixCell, 0, len(specs))
	for _, spec := range specs {
		if platformFilter != "" && spec.Platform != platformFilter {
			continue
		}
		eval := s.evaluateForWorkspaceLockedOrUnlocked(ctx, actor.WorkspaceID, "", spec.Platform, spec.ActionKey, "VN", spec.RequiresWrite)
		cell := &adminv1.CapabilityMatrixCell{
			Platform:          eval.Platform,
			CapabilityKey:     eval.ActionKey,
			DisplayName:       eval.DisplayName,
			State:             toProtoState(eval.State),
			VerificationFresh: eval.VerificationFresh,
			Executable:        eval.Executable,
			Reason:            eval.Reason,
			PolicyNote:        toProtoPolicyNote(eval.PolicyNote),
			FallbackPath:      toProtoFallbackPath(eval.FallbackPath),
			CheckedAt:         timestamppb.New(eval.CheckedAt),
		}
		if !eval.ValidUntil.IsZero() {
			cell.ValidUntil = timestamppb.New(eval.ValidUntil)
		}
		cells = append(cells, cell)
	}

	return connect.NewResponse(&adminv1.GetMatrixResponse{
		WorkspaceId: &commonv1.UUID{Value: actor.WorkspaceID},
		Cells:       cells,
		GeneratedAt: timestamppb.New(s.Now()),
	}), nil
}

// GetHealthScores implements CapabilityService/GetHealthScores (requires capability:read).
func (s *Service) GetHealthScores(
	ctx context.Context,
	req *connect.Request[adminv1.GetHealthScoresRequest],
) (*connect.Response[adminv1.GetHealthScoresResponse], error) {
	wsID := ""
	if req.Msg != nil && req.Msg.GetWorkspaceId() != nil {
		wsID = req.Msg.GetWorkspaceId().GetValue()
	}
	actor, err := s.authorize(ctx, "CapabilityService/GetHealthScores", wsID)
	if err != nil {
		return nil, toConnectError(err)
	}

	s.mu.Lock()
	wsAccs := s.accounts[actor.WorkspaceID]
	accIDs := make([]string, 0, len(wsAccs))
	for id := range wsAccs {
		accIDs = append(accIDs, id)
	}
	sort.Strings(accIDs)
	s.mu.Unlock()

	scores := make([]*adminv1.PlatformHealthScoreCard, 0, len(accIDs))
	for _, accID := range accIDs {
		card, err := s.computeAndRecordAccountHealth(ctx, actor.WorkspaceID, accID)
		if err == nil && card != nil {
			scores = append(scores, card)
		}
	}

	return connect.NewResponse(&adminv1.GetHealthScoresResponse{
		WorkspaceId: &commonv1.UUID{Value: actor.WorkspaceID},
		Scores:      scores,
	}), nil
}

// ListPolicyNotes implements CapabilityService/ListPolicyNotes (requires capability:read).
func (s *Service) ListPolicyNotes(
	ctx context.Context,
	req *connect.Request[adminv1.ListPolicyNotesRequest],
) (*connect.Response[adminv1.ListPolicyNotesResponse], error) {
	wsID := ""
	platformFilter := ""
	if req.Msg != nil {
		if req.Msg.GetWorkspaceId() != nil {
			wsID = req.Msg.GetWorkspaceId().GetValue()
		}
		platformFilter = strings.ToLower(strings.TrimSpace(req.Msg.GetPlatformFilter()))
	}
	if _, err := s.authorize(ctx, "CapabilityService/ListPolicyNotes", wsID); err != nil {
		return nil, toConnectError(err)
	}

	var notes []*adminv1.PolicyNoteItem
	for _, spec := range CanonicalPlatformActions() {
		if platformFilter != "" && spec.Platform != platformFilter {
			continue
		}
		notes = append(notes, toProtoPolicyNote(spec.PolicyNote))
	}
	return connect.NewResponse(&adminv1.ListPolicyNotesResponse{
		PolicyNotes: notes,
	}), nil
}

// ListFallbackPaths implements CapabilityService/ListFallbackPaths (requires capability:read).
func (s *Service) ListFallbackPaths(
	ctx context.Context,
	req *connect.Request[adminv1.ListFallbackPathsRequest],
) (*connect.Response[adminv1.ListFallbackPathsResponse], error) {
	wsID := ""
	platformFilter := ""
	if req.Msg != nil {
		if req.Msg.GetWorkspaceId() != nil {
			wsID = req.Msg.GetWorkspaceId().GetValue()
		}
		platformFilter = strings.ToLower(strings.TrimSpace(req.Msg.GetPlatformFilter()))
	}
	if _, err := s.authorize(ctx, "CapabilityService/ListFallbackPaths", wsID); err != nil {
		return nil, toConnectError(err)
	}

	var paths []*adminv1.FallbackPathItem
	for _, spec := range CanonicalPlatformActions() {
		if platformFilter != "" && spec.Platform != platformFilter {
			continue
		}
		paths = append(paths, toProtoFallbackPath(spec.FallbackPath))
	}
	return connect.NewResponse(&adminv1.ListFallbackPathsResponse{
		FallbackPaths: paths,
	}), nil
}

// List implements ConnectorService/List (requires account:read).
// Strictly strips AccessTokenEncrypted and RefreshTokenEncrypted (RULE-M22-005).
func (s *Service) List(
	ctx context.Context,
	req *connect.Request[adminv1.ConnectorServiceListRequest],
) (*connect.Response[adminv1.ConnectorServiceListResponse], error) {
	wsID := ""
	if req.Msg != nil && req.Msg.GetWorkspaceId() != nil {
		wsID = req.Msg.GetWorkspaceId().GetValue()
	}
	actor, err := s.authorize(ctx, "ConnectorService/List", wsID)
	if err != nil {
		return nil, toConnectError(err)
	}

	s.mu.Lock()
	wsAccs := s.accounts[actor.WorkspaceID]
	ids := make([]string, 0, len(wsAccs))
	for id := range wsAccs {
		ids = append(ids, id)
	}
	sort.Strings(ids)
	items := make([]*adminv1.ConnectedAccountItem, 0, len(ids))
	for _, id := range ids {
		items = append(items, toProtoConnectedAccount(*wsAccs[id]))
	}
	s.mu.Unlock()

	return connect.NewResponse(&adminv1.ConnectorServiceListResponse{
		Accounts: items,
	}), nil
}

// Check implements ConnectorService/Check (requires account:read).
func (s *Service) Check(
	ctx context.Context,
	req *connect.Request[adminv1.ConnectorServiceCheckRequest],
) (*connect.Response[adminv1.ConnectorServiceCheckResponse], error) {
	if req.Msg == nil {
		return nil, toConnectError(ErrInvalidInput)
	}
	wsID := ""
	if req.Msg.GetWorkspaceId() != nil {
		wsID = req.Msg.GetWorkspaceId().GetValue()
	}
	actor, err := s.authorize(ctx, "ConnectorService/Check", wsID)
	if err != nil {
		return nil, toConnectError(err)
	}

	accID := ""
	if req.Msg.GetConnectedAccountId() != nil {
		accID = req.Msg.GetConnectedAccountId().GetValue()
	}
	eval := s.evaluateForWorkspaceLockedOrUnlocked(
		ctx,
		actor.WorkspaceID,
		accID,
		req.Msg.GetPlatform(),
		req.Msg.GetActionKey(),
		req.Msg.GetTargetMarket(),
		req.Msg.GetRequireWrite(),
	)

	return connect.NewResponse(&adminv1.ConnectorServiceCheckResponse{
		State:             toProtoState(eval.State),
		Executable:        eval.Executable,
		VerificationFresh: eval.VerificationFresh,
		Reason:            eval.Reason,
		PolicyNote:        toProtoPolicyNote(eval.PolicyNote),
		FallbackPath:      toProtoFallbackPath(eval.FallbackPath),
	}), nil
}

// CheckHealth implements ConnectorService/CheckHealth (requires account:read).
func (s *Service) CheckHealth(
	ctx context.Context,
	req *connect.Request[adminv1.ConnectorServiceCheckHealthRequest],
) (*connect.Response[adminv1.ConnectorServiceCheckHealthResponse], error) {
	if req.Msg == nil || req.Msg.GetConnectedAccountId() == nil {
		return nil, toConnectError(ErrInvalidInput)
	}
	wsID := ""
	if req.Msg.GetWorkspaceId() != nil {
		wsID = req.Msg.GetWorkspaceId().GetValue()
	}
	actor, err := s.authorize(ctx, "ConnectorService/CheckHealth", wsID)
	if err != nil {
		return nil, toConnectError(err)
	}

	accID := req.Msg.GetConnectedAccountId().GetValue()
	card, err := s.computeAndRecordAccountHealth(ctx, actor.WorkspaceID, accID)
	if err != nil {
		return nil, toConnectError(err)
	}
	return connect.NewResponse(&adminv1.ConnectorServiceCheckHealthResponse{
		HealthScore: card,
	}), nil
}

// Disconnect implements ConnectorService/Disconnect (requires account:disconnect).
func (s *Service) Disconnect(
	ctx context.Context,
	req *connect.Request[adminv1.ConnectorServiceDisconnectRequest],
) (*connect.Response[adminv1.ConnectorServiceDisconnectResponse], error) {
	if req.Msg == nil || req.Msg.GetContext() == nil || req.Msg.GetConnectedAccountId() == nil {
		return nil, toConnectError(ErrInvalidInput)
	}
	cmdCtx := req.Msg.GetContext()
	idemKey := strings.TrimSpace(cmdCtx.GetIdempotencyKey())
	accID := strings.TrimSpace(req.Msg.GetConnectedAccountId().GetValue())
	if idemKey == "" || !tenantdb.IsValidNonZeroUUID(accID) {
		return nil, toConnectError(ErrInvalidInput)
	}

	wsID := ""
	if cmdCtx.GetWorkspaceId() != nil {
		wsID = cmdCtx.GetWorkspaceId().GetValue()
	}
	actor, err := s.authorize(ctx, "ConnectorService/Disconnect", wsID)
	if err != nil {
		return nil, toConnectError(err)
	}

	reqHash := hashIdempotencyPayload("Disconnect", actor.WorkspaceID, accID, cmdCtx.GetReason())
	cacheKey := actor.WorkspaceID + "::" + actor.UserID + "::ConnectorService/Disconnect::" + idemKey

	s.mu.Lock()
	if prev, ok := s.idempotency[cacheKey]; ok {
		s.mu.Unlock()
		if prev.requestHash != reqHash {
			return nil, toConnectError(ErrIdempotencyConflict)
		}
		cloned := proto.Clone(prev.response.(*adminv1.ConnectorServiceDisconnectResponse)).(*adminv1.ConnectorServiceDisconnectResponse)
		cloned.Replayed = true
		return connect.NewResponse(cloned), nil
	}

	wsAccs := s.accounts[actor.WorkspaceID]
	acc, exists := wsAccs[accID]
	if !exists {
		s.mu.Unlock()
		return nil, toConnectError(ErrAccountNotFound)
	}

	now := s.Now()
	acc.Status = "disconnected"
	acc.AccessTokenEncrypted = nil
	acc.RefreshTokenEncrypted = nil
	acc.LastSyncedAt = now

	if wsVer, ok := s.verifications[actor.WorkspaceID]; ok {
		for k := range wsVer {
			if strings.HasPrefix(k, accID+"::") {
				delete(wsVer, k)
			}
		}
	}

	resp := &adminv1.ConnectorServiceDisconnectResponse{
		ConnectedAccountId: &commonv1.UUID{Value: accID},
		Status:             "disconnected",
		Replayed:           false,
		DisconnectedAt:     timestamppb.New(now),
	}
	s.idempotency[cacheKey] = cachedCommandResult{
		requestHash: reqHash,
		response:    resp,
	}
	s.audits = append(s.audits, outbox.AuditLogEntry{
		AuditEventID: s.IDGenerator(),
		WorkspaceID:  actor.WorkspaceID,
		ActorID:      actor.UserID,
		ActorType:    "user",
		Action:       "account.disconnected",
		ResourceType: "connected_account",
		ResourceID:   accID,
		Reason:       cmdCtx.GetReason(),
		CreatedAt:    now,
	})
	s.mu.Unlock()

	return connect.NewResponse(resp), nil
}

func (s *Service) computeAndRecordAccountHealth(ctx context.Context, workspaceID, accID string) (*adminv1.PlatformHealthScoreCard, error) {
	now := s.Now()
	s.mu.Lock()
	wsAccs := s.accounts[workspaceID]
	acc, exists := wsAccs[accID]
	if !exists {
		s.mu.Unlock()
		return nil, ErrAccountNotFound
	}
	platform := acc.Platform
	metrics, hasMetrics := s.healthInputs[workspaceID][accID]
	if !hasMetrics {
		metrics = HealthMetricsInput{
			AvailabilityPct:       100,
			ErrorRatePct:          0,
			LatencyP95Ms:          120,
			RateLimitRemainingPct: 95,
		}
	}
	prevCard := s.healthScores[workspaceID][accID]
	scoreID := s.IDGenerator()
	card := ComputeHealthScore(scoreID, accID, platform, metrics, now)

	acc.HealthScore = int(card.GetOverallScore())
	if s.healthScores[workspaceID] == nil {
		s.healthScores[workspaceID] = make(map[string]*adminv1.PlatformHealthScoreCard)
	}
	s.healthScores[workspaceID][accID] = card

	// Emit domain events per RULE-M22-003 & domain_event_catalog.md:
	// - connector.health_score.captured
	// - connector.degraded when band drops to degraded/critical
	// - connector.recovered when band recovers to healthy from degraded/critical
	scorePayload, _ := json.Marshal(map[string]any{
		"connected_account_id": accID,
		"platform":             platform,
		"overall_score":        card.GetOverallScore(),
		"status_band":          card.GetStatusBand(),
	})
	s.emittedEvents = append(s.emittedEvents, outbox.DomainEventEnvelope{
		EventID:       s.IDGenerator(),
		EventType:     "connector.health_score.captured",
		TargetStream:  outbox.QueueConnectorSync,
		AggregateType: "connected_account",
		AggregateID:   accID,
		WorkspaceID:   workspaceID,
		Payload:       scorePayload,
		OccurredAt:    now,
	})

	if card.GetOverallScore() < 80 {
		s.emittedEvents = append(s.emittedEvents, outbox.DomainEventEnvelope{
			EventID:       s.IDGenerator(),
			EventType:     "connector.degraded",
			TargetStream:  outbox.QueueConnectorSync,
			AggregateType: "connected_account",
			AggregateID:   accID,
			WorkspaceID:   workspaceID,
			Payload:       scorePayload,
			OccurredAt:    now,
		})
	} else if prevCard != nil && prevCard.GetOverallScore() < 80 && card.GetOverallScore() >= 80 {
		s.emittedEvents = append(s.emittedEvents, outbox.DomainEventEnvelope{
			EventID:       s.IDGenerator(),
			EventType:     "connector.recovered",
			TargetStream:  outbox.QueueConnectorSync,
			AggregateType: "connected_account",
			AggregateID:   accID,
			WorkspaceID:   workspaceID,
			Payload:       scorePayload,
			OccurredAt:    now,
		})
	}
	s.mu.Unlock()

	if s.Beginner != nil {
		if actor, ok := ActorFromContext(ctx); ok && actor.WorkspaceID == workspaceID && !actor.IsImpersonation {
			dimsJSON, _ := json.Marshal(map[string]int32{
				"availability": card.GetAvailabilityScore(),
				"error_rate":   card.GetErrorRateScore(),
				"latency":      card.GetLatencyScore(),
				"rate_limit":   card.GetRateLimitScore(),
			})
			flagsJSON, _ := json.Marshal(card.GetRiskFlags())
			_ = tenantdb.WithTx(ctx, s.Beginner, tenantdb.Scope{
				WorkspaceID:             actor.WorkspaceID,
				UserID:                  actor.UserID,
				RequireActiveMembership: true,
			}, func(txCtx context.Context, q *tenantdb.Queries) error {
				_, err := q.UpsertPlatformHealthScore(txCtx, tenantdb.UpsertPlatformHealthScoreParams{
					HealthScoreID:      scoreID,
					WorkspaceID:        actor.WorkspaceID,
					ConnectedAccountID: accID,
					Platform:           platform,
					OverallScore:       int(card.GetOverallScore()),
					Dimensions:         dimsJSON,
					RiskFlags:          flagsJSON,
					SnapshotDate:       now,
				})
				return err
			})
		}
	}

	return card, nil
}

func toProtoConnectedAccount(rec ConnectedAccountRecord) *adminv1.ConnectedAccountItem {
	item := &adminv1.ConnectedAccountItem{
		ConnectedAccountId: &commonv1.UUID{Value: rec.ConnectedAccountID},
		WorkspaceId:        &commonv1.UUID{Value: rec.WorkspaceID},
		Platform:           rec.Platform,
		AccountType:        rec.AccountType,
		ExternalAccountId:  rec.ExternalAccountID,
		AccountName:        rec.AccountName,
		Status:             rec.Status,
		HealthScore:        int32(rec.HealthScore),
		GrantedScopes:      append([]string(nil), rec.GrantedScopes...),
	}
	if !rec.TokenExpiresAt.IsZero() {
		item.TokenExpiresAt = timestamppb.New(rec.TokenExpiresAt)
	}
	if !rec.LastSyncedAt.IsZero() {
		item.LastSyncedAt = timestamppb.New(rec.LastSyncedAt)
	}
	return item
}

func toProtoState(st State) adminv1.CapabilityState {
	switch st {
	case StateNative:
		return adminv1.CapabilityState_CAPABILITY_STATE_NATIVE
	case StateReadOnly:
		return adminv1.CapabilityState_CAPABILITY_STATE_READ_ONLY
	case StateManual:
		return adminv1.CapabilityState_CAPABILITY_STATE_MANUAL
	case StateDegraded:
		return adminv1.CapabilityState_CAPABILITY_STATE_DEGRADED
	case StateUnsupported:
		return adminv1.CapabilityState_CAPABILITY_STATE_UNSUPPORTED
	default:
		return adminv1.CapabilityState_CAPABILITY_STATE_UNSPECIFIED
	}
}

func toProtoFallbackType(ft FallbackKind) adminv1.FallbackType {
	switch ft {
	case FallbackManualUpload:
		return adminv1.FallbackType_FALLBACK_TYPE_MANUAL_UPLOAD
	case FallbackCSVImport:
		return adminv1.FallbackType_FALLBACK_TYPE_CSV_IMPORT
	case FallbackWebhookWorkaround:
		return adminv1.FallbackType_FALLBACK_TYPE_WEBHOOK_WORKAROUND
	case FallbackBrowserAssist:
		return adminv1.FallbackType_FALLBACK_TYPE_BROWSER_ASSIST
	case FallbackUnsupported:
		return adminv1.FallbackType_FALLBACK_TYPE_UNSUPPORTED
	default:
		return adminv1.FallbackType_FALLBACK_TYPE_UNSPECIFIED
	}
}

func toProtoPolicyNote(n PolicyNoteSpec) *adminv1.PolicyNoteItem {
	item := &adminv1.PolicyNoteItem{
		PolicyNoteId:  &commonv1.UUID{Value: n.PolicyNoteID},
		Platform:      n.Platform,
		CapabilityKey: n.CapabilityKey,
		Summary:       n.Summary,
		Detail:        n.Detail,
		SourceUrl:     n.SourceURL,
	}
	if !n.UpdatedAt.IsZero() {
		item.UpdatedAt = timestamppb.New(n.UpdatedAt)
	}
	return item
}

func toProtoFallbackPath(fp FallbackPathSpec) *adminv1.FallbackPathItem {
	item := &adminv1.FallbackPathItem{
		FallbackPathId:  &commonv1.UUID{Value: fp.FallbackPathID},
		Platform:        fp.Platform,
		CapabilityKey:   fp.CapabilityKey,
		FallbackType:    toProtoFallbackType(fp.FallbackType),
		Instructions:    fp.Instructions,
		EstimatedEffort: fp.EstimatedEffort,
	}
	if tenantdb.IsValidNonZeroUUID(fp.RelatedPolicyNoteID) {
		item.RelatedPolicyNoteId = &commonv1.UUID{Value: fp.RelatedPolicyNoteID}
	}
	return item
}

func toConnectError(err error) error {
	switch {
	case errors.Is(err, ErrUnauthenticated):
		return connect.NewError(connect.CodeUnauthenticated, err)
	case errors.Is(err, rbac.ErrImpersonationReadOnly):
		return connect.NewError(connect.CodePermissionDenied, err)
	case errors.Is(err, rbac.ErrPermissionDenied), errors.Is(err, tenantdb.ErrScopeMismatch):
		return connect.NewError(connect.CodePermissionDenied, err)
	case errors.Is(err, ErrAccountNotFound):
		return connect.NewError(connect.CodeNotFound, err)
	case errors.Is(err, ErrIdempotencyConflict):
		return connect.NewError(connect.CodeAborted, err)
	case errors.Is(err, ErrUnverifiedRouteCannotExecute), errors.Is(err, rbac.ErrCapabilityUnavailable):
		return connect.NewError(connect.CodeFailedPrecondition, err)
	default:
		return connect.NewError(connect.CodeInvalidArgument, err)
	}
}
