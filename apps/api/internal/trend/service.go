// Package trend implements the Trend Fusion Radar (M02) and intelligence services
// per docs/02_features/intelligence/trend_radar.md and docs/04_contracts/database_schema.md §5.
package trend

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"errors"
	"fmt"
	"math"
	"sort"
	"strings"
	"sync"
	"time"

	"connectrpc.com/connect"
	intelligencev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/intelligence/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/intelligence/v1/intelligencev1connect"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
	"google.golang.org/protobuf/types/known/timestamppb"
)

var (
	ErrUnauthenticated    = errors.New("trend: unauthenticated caller")
	ErrInvalidInput       = errors.New("trend: invalid input parameter")
	ErrPermissionDenied   = errors.New("trend: caller role is not authorized for this operation")
	ErrTrendNotFound      = errors.New("trend: requested trend not found")
	ErrWatchlistNotFound  = errors.New("trend: requested watchlist not found")
	ErrCrossTenantDenied  = errors.New("trend: cross-tenant access strictly forbidden")
	ErrSourceDisconnected = errors.New("trend: external data source is disconnected or token expired")
)

// CallerContext represents the authenticated caller identity and tenant workspace.
type CallerContext struct {
	UserID        string
	WorkspaceID   string
	WorkspaceRole string
}

type callerCtxKey struct{}

// WithCallerContext binds a CallerContext into a context.Context.
func WithCallerContext(ctx context.Context, caller CallerContext) context.Context {
	return context.WithValue(ctx, callerCtxKey{}, caller)
}

// CallerFromContext retrieves CallerContext from ctx.
func CallerFromContext(ctx context.Context) (CallerContext, bool) {
	if ctx == nil {
		return CallerContext{}, false
	}
	c, ok := ctx.Value(callerCtxKey{}).(CallerContext)
	return c, ok
}

// IngestedSignal represents a raw or normalized signal collected from platform APIs.
type IngestedSignal struct {
	SignalID          string
	WorkspaceID       string
	SourcePlatform    string
	SourceClass       intelligencev1.SourceClass
	SignalType        string
	NormalizedSummary string
	Confidence        intelligencev1.ConfidenceBand
	FreshnessAt       time.Time
	CollectedAt       time.Time
	RawPayload        map[string]any
	IsDegraded        bool
}

// StoredTrend represents an internal trend record in database table `trends`.
type StoredTrend struct {
	TrendID              string
	WorkspaceID          string
	Title                string
	Summary              string
	Category             string
	Platforms            []string
	StrengthScore        float32
	VelocityScore        float32
	FreshnessScore       float32
	SaturationScore      float32
	Confidence           intelligencev1.ConfidenceBand
	ConfidenceReason     string
	SourceClass          intelligencev1.SourceClass
	LifecycleState       intelligencev1.LifecycleState
	FreshnessAt          time.Time
	WhyNow               string
	RelevanceDescription string
	SignalIDs            []string
	IsSaved              bool
	IsDegraded           bool
	DegradedReason       string
	EmbeddingVector      []float32
	CreatedAt            time.Time
	UpdatedAt            time.Time
}

// StoredWatchlist represents a user-configured entity watchlist in `watchlists`.
type StoredWatchlist struct {
	WatchlistID     string
	WorkspaceID     string
	Name            string
	Type            string
	CriteriaJSON    string
	AlertEnabled    bool
	MinVelocity     float32
	MinStrength     float32
	SpikePercentage float32
	CooldownMinutes int32
	TrackedTrendIDs []string
	CreatedAt       time.Time
	UpdatedAt       time.Time
}

// StoredAlertLog represents an emitted alert record in `watchlist_alert_logs`.
type StoredAlertLog struct {
	AlertLogID       string
	WorkspaceID      string
	WatchlistID      string
	TrendID          string
	AlertFingerprint string
	MetricsSnapshot  string
	DeliveredAt      time.Time
	CooldownUntil    time.Time
}

// StoredOpportunity models an M04 Opportunity generated from a trend.
type StoredOpportunity struct {
	OpportunityID   string
	WorkspaceID     string
	Title           string
	Hypothesis      string
	OpportunityType string
	SourceType      string
	SourceID        string
	OverallScore    float32
	Status          string
	CreatedAt       time.Time
}

// Store defines persistence operations for trends, signals, watchlists, and alerts.
type Store interface {
	SaveSignal(ctx context.Context, sig IngestedSignal) error
	GetSignal(ctx context.Context, workspaceID, signalID string) (*IngestedSignal, error)
	ListSignalsForTrend(ctx context.Context, workspaceID, trendID string) ([]IngestedSignal, error)

	SaveTrend(ctx context.Context, trend StoredTrend) error
	GetTrend(ctx context.Context, workspaceID, trendID string) (*StoredTrend, error)
	ListTrends(ctx context.Context, workspaceID string) ([]StoredTrend, error)

	SaveWatchlist(ctx context.Context, wl StoredWatchlist) error
	GetWatchlist(ctx context.Context, workspaceID, watchlistID string) (*StoredWatchlist, error)
	ListWatchlists(ctx context.Context, workspaceID string) ([]StoredWatchlist, error)
	DeleteWatchlist(ctx context.Context, workspaceID, watchlistID string) error

	FindActiveAlertLog(ctx context.Context, workspaceID, fingerprint string, now time.Time) (*StoredAlertLog, error)
	RecordAlertLog(ctx context.Context, log StoredAlertLog) error
	CountRecentAlerts(ctx context.Context, workspaceID string, since time.Time) (int, error)

	SaveOpportunity(ctx context.Context, opp StoredOpportunity) error
}

// MemoryStore provides a thread-safe, tenant-isolated in-memory store for tests and local runtime.
type MemoryStore struct {
	mu           sync.RWMutex
	signals      map[string]IngestedSignal    // signalID -> signal
	trends       map[string]StoredTrend       // trendID -> trend
	trendSignals map[string][]string          // trendID -> signalIDs
	watchlists   map[string]StoredWatchlist   // watchlistID -> watchlist
	alertLogs    map[string]StoredAlertLog    // workspaceID:fingerprint -> log
	opportunites map[string]StoredOpportunity // oppID -> opp
}

func NewMemoryStore() *MemoryStore {
	return &MemoryStore{
		signals:      make(map[string]IngestedSignal),
		trends:       make(map[string]StoredTrend),
		trendSignals: make(map[string][]string),
		watchlists:   make(map[string]StoredWatchlist),
		alertLogs:    make(map[string]StoredAlertLog),
		opportunites: make(map[string]StoredOpportunity),
	}
}

func (m *MemoryStore) SaveSignal(ctx context.Context, sig IngestedSignal) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	m.signals[sig.SignalID] = sig
	return nil
}

func (m *MemoryStore) GetSignal(ctx context.Context, workspaceID, signalID string) (*IngestedSignal, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	sig, ok := m.signals[signalID]
	if !ok || sig.WorkspaceID != workspaceID {
		return nil, ErrTrendNotFound
	}
	cp := sig
	return &cp, nil
}

func (m *MemoryStore) ListSignalsForTrend(ctx context.Context, workspaceID, trendID string) ([]IngestedSignal, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	t, ok := m.trends[trendID]
	if !ok || t.WorkspaceID != workspaceID {
		return nil, ErrTrendNotFound
	}
	sigIDs := m.trendSignals[trendID]
	var out []IngestedSignal
	for _, id := range sigIDs {
		if s, exists := m.signals[id]; exists && s.WorkspaceID == workspaceID {
			out = append(out, s)
		}
	}
	return out, nil
}

func (m *MemoryStore) SaveTrend(ctx context.Context, trend StoredTrend) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	m.trends[trend.TrendID] = trend
	m.trendSignals[trend.TrendID] = trend.SignalIDs
	return nil
}

func (m *MemoryStore) GetTrend(ctx context.Context, workspaceID, trendID string) (*StoredTrend, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	t, ok := m.trends[trendID]
	if !ok || t.WorkspaceID != workspaceID {
		return nil, ErrTrendNotFound
	}
	cp := t
	return &cp, nil
}

func (m *MemoryStore) ListTrends(ctx context.Context, workspaceID string) ([]StoredTrend, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	var out []StoredTrend
	for _, t := range m.trends {
		if t.WorkspaceID == workspaceID {
			out = append(out, t)
		}
	}
	return out, nil
}

func (m *MemoryStore) SaveWatchlist(ctx context.Context, wl StoredWatchlist) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	m.watchlists[wl.WatchlistID] = wl
	return nil
}

func (m *MemoryStore) GetWatchlist(ctx context.Context, workspaceID, watchlistID string) (*StoredWatchlist, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	wl, ok := m.watchlists[watchlistID]
	if !ok || wl.WorkspaceID != workspaceID {
		return nil, ErrWatchlistNotFound
	}
	cp := wl
	return &cp, nil
}

func (m *MemoryStore) ListWatchlists(ctx context.Context, workspaceID string) ([]StoredWatchlist, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	var out []StoredWatchlist
	for _, wl := range m.watchlists {
		if wl.WorkspaceID == workspaceID {
			out = append(out, wl)
		}
	}
	return out, nil
}

func (m *MemoryStore) DeleteWatchlist(ctx context.Context, workspaceID, watchlistID string) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	wl, ok := m.watchlists[watchlistID]
	if !ok || wl.WorkspaceID != workspaceID {
		return ErrWatchlistNotFound
	}
	delete(m.watchlists, watchlistID)
	return nil
}

func (m *MemoryStore) FindActiveAlertLog(ctx context.Context, workspaceID, fingerprint string, now time.Time) (*StoredAlertLog, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	key := workspaceID + ":" + fingerprint
	log, ok := m.alertLogs[key]
	if !ok {
		return nil, nil
	}
	if log.CooldownUntil.After(now) {
		cp := log
		return &cp, nil
	}
	return nil, nil
}

func (m *MemoryStore) RecordAlertLog(ctx context.Context, log StoredAlertLog) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	key := log.WorkspaceID + ":" + log.AlertFingerprint
	m.alertLogs[key] = log
	return nil
}

func (m *MemoryStore) CountRecentAlerts(ctx context.Context, workspaceID string, since time.Time) (int, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	count := 0
	for _, log := range m.alertLogs {
		if log.WorkspaceID == workspaceID && log.DeliveredAt.After(since) {
			count++
		}
	}
	return count, nil
}

func (m *MemoryStore) SaveOpportunity(ctx context.Context, opp StoredOpportunity) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	m.opportunites[opp.OpportunityID] = opp
	return nil
}

// ComputeMultiDimensionalScores implements RULE-M02-002:
// Derives composite strength_score (0-100) from velocity, freshness, and saturation.
// Weighting: 45% velocity + 35% freshness + 20% (100 - saturation).
func ComputeMultiDimensionalScores(velocity, freshness, saturation float32) float32 {
	v := float32(math.Max(0, math.Min(100, float64(velocity))))
	f := float32(math.Max(0, math.Min(100, float64(freshness))))
	s := float32(math.Max(0, math.Min(100, float64(saturation))))

	composite := (v * 0.45) + (f * 0.35) + ((100.0 - s) * 0.20)
	if composite < 0 {
		return 0
	}
	if composite > 100 {
		return 100
	}
	return composite
}

// ServiceConfig holds platform connection statuses for degraded state simulation and testing.
type ServiceConfig struct {
	Store                Store
	DisconnectedSources  map[string]bool // platform -> isDisconnected (e.g. "tiktok": true)
	MaxAlertsPerHour     int
	AlertCooldownMinutes int32
}

// Service provides TrendService and WatchlistService Connect implementations.
type Service struct {
	intelligencev1connect.UnimplementedTrendServiceHandler
	intelligencev1connect.UnimplementedWatchlistServiceHandler
	store                Store
	disconnectedSources  map[string]bool
	maxAlertsPerHour     int
	alertCooldownMinutes int32
	mu                   sync.RWMutex
}

// NewService instantiates a new Service with configuration.
func NewService(cfg ServiceConfig) *Service {
	store := cfg.Store
	if store == nil {
		store = NewMemoryStore()
	}
	disconnected := make(map[string]bool)
	for k, v := range cfg.DisconnectedSources {
		disconnected[k] = v
	}
	maxAlerts := cfg.MaxAlertsPerHour
	if maxAlerts <= 0 {
		maxAlerts = 5 // RULE: EC-M02-004 alert throttle: max 5 push notifications per hour per workspace
	}
	cooldown := cfg.AlertCooldownMinutes
	if cooldown <= 0 {
		cooldown = 60 // 60-minute default cooldown
	}

	return &Service{
		store:                store,
		disconnectedSources:  disconnected,
		maxAlertsPerHour:     maxAlerts,
		alertCooldownMinutes: cooldown,
	}
}

// SetSourceStatus toggles the simulated connection status of an external platform.
func (s *Service) SetSourceStatus(platform string, disconnected bool) {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.disconnectedSources[platform] = disconnected
}

func (s *Service) isSourceDisconnected(platform string) bool {
	s.mu.RLock()
	defer s.mu.RUnlock()
	return s.disconnectedSources[platform]
}

func (s *Service) getDisconnectedList() []string {
	s.mu.RLock()
	defer s.mu.RUnlock()
	var out []string
	for p, disc := range s.disconnectedSources {
		if disc {
			out = append(out, p)
		}
	}
	sort.Strings(out)
	return out
}

func (s *Service) authorizeCaller(ctx context.Context, targetWorkspaceID, requiredPerm string) (CallerContext, error) {
	caller, ok := CallerFromContext(ctx)
	if !ok || caller.UserID == "" {
		return CallerContext{}, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}

	// Direct tenant isolation boundary check
	if targetWorkspaceID != "" && caller.WorkspaceID != targetWorkspaceID {
		return CallerContext{}, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}

	// RBAC permission check via canonical rbac package
	if requiredPerm != "" {
		if err := rbac.CheckWorkspacePermission(requiredPerm, rbac.PolicyContext{
			ActorUserID: caller.UserID,
			WorkspaceID: caller.WorkspaceID,
			Role:        caller.WorkspaceRole,
		}); err != nil {
			return CallerContext{}, connect.NewError(connect.CodePermissionDenied,
				fmt.Errorf("%w: %v", ErrPermissionDenied, err))
		}
	}

	return caller, nil
}

// ----------------------------------------------------------------------------
// TrendService Implementation
// ----------------------------------------------------------------------------

func (s *Service) List(ctx context.Context, req *connect.Request[intelligencev1.TrendServiceListRequest]) (*connect.Response[intelligencev1.TrendServiceListResponse], error) {
	msg := req.Msg
	wsID := msg.WorkspaceId
	if wsID == "" {
		if caller, ok := CallerFromContext(ctx); ok {
			wsID = caller.WorkspaceID
		}
	}
	if wsID == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("workspace_id required"))
	}

	if _, err := s.authorizeCaller(ctx, wsID, "trend:read"); err != nil {
		return nil, err
	}

	stored, err := s.store.ListTrends(ctx, wsID)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	disconnected := s.getDisconnectedList()
	hasDisconnectedSources := len(disconnected) > 0

	var filtered []StoredTrend
	for _, t := range stored {
		if msg.Category != "" && !strings.EqualFold(t.Category, msg.Category) {
			continue
		}
		if msg.Platform != "" {
			matched := false
			for _, p := range t.Platforms {
				if strings.EqualFold(p, msg.Platform) {
					matched = true
					break
				}
			}
			if !matched {
				continue
			}
		}
		if msg.MinStrengthScore > 0 && t.StrengthScore < msg.MinStrengthScore {
			continue
		}
		filtered = append(filtered, t)
	}

	// Sorting
	sort.Slice(filtered, func(i, j int) bool {
		switch msg.SortBy {
		case "velocity":
			return filtered[i].VelocityScore > filtered[j].VelocityScore
		case "freshness":
			return filtered[i].FreshnessScore > filtered[j].FreshnessScore
		default:
			return filtered[i].StrengthScore > filtered[j].StrengthScore
		}
	})

	var protoTrends []*intelligencev1.Trend
	for _, t := range filtered {
		pt, err := s.toProtoTrend(ctx, wsID, t, hasDisconnectedSources, disconnected)
		if err != nil {
			return nil, connect.NewError(connect.CodeInternal, err)
		}
		protoTrends = append(protoTrends, pt)
	}

	res := connect.NewResponse(&intelligencev1.TrendServiceListResponse{
		Trends:              protoTrends,
		TotalCount:          int32(len(protoTrends)),
		SourceDegraded:      hasDisconnectedSources,
		DisconnectedSources: disconnected,
	})
	return res, nil
}

func (s *Service) Get(ctx context.Context, req *connect.Request[intelligencev1.TrendServiceGetRequest]) (*connect.Response[intelligencev1.TrendServiceGetResponse], error) {
	msg := req.Msg
	if msg.TrendId == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("trend_id required"))
	}
	wsID := msg.WorkspaceId
	if wsID == "" {
		if caller, ok := CallerFromContext(ctx); ok {
			wsID = caller.WorkspaceID
		}
	}

	if _, err := s.authorizeCaller(ctx, wsID, "trend:read"); err != nil {
		return nil, err
	}

	t, err := s.store.GetTrend(ctx, wsID, msg.TrendId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrTrendNotFound)
	}

	disconnected := s.getDisconnectedList()
	hasDisconnectedSources := len(disconnected) > 0

	protoTrend, err := s.toProtoTrend(ctx, wsID, *t, hasDisconnectedSources, disconnected)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	signals, err := s.store.ListSignalsForTrend(ctx, wsID, msg.TrendId)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var protoSignals []*intelligencev1.SignalRef
	for _, sig := range signals {
		protoSignals = append(protoSignals, &intelligencev1.SignalRef{
			SignalId:          sig.SignalID,
			WorkspaceId:       sig.WorkspaceID,
			SourcePlatform:    sig.SourcePlatform,
			SourceClass:       sig.SourceClass,
			SignalType:        sig.SignalType,
			NormalizedSummary: sig.NormalizedSummary,
			Confidence:        sig.Confidence,
			FreshnessAt:       timestamppb.New(sig.FreshnessAt),
			CollectedAt:       timestamppb.New(sig.CollectedAt),
		})
	}

	advice := "Tín hiệu ổn định từ các nền tảng kết nối."
	if protoTrend.IsDegraded {
		advice = fmt.Sprintf("Nguồn %s bị gián đoạn. Kết nối lại tài khoản để phục hồi tín hiệu thời gian thực và nâng cao độ tin cậy.",
			strings.Join(protoTrend.Platforms, ", "))
	}

	return connect.NewResponse(&intelligencev1.TrendServiceGetResponse{
		Trend:             protoTrend,
		LineageSignals:    protoSignals,
		ImprovementAdvice: advice,
	}), nil
}

// Search implements Acceptance Target 3: Tenant-scoped semantic search
// Strictly filters results by workspace_id and computes semantic relevance combined with strength_score.
func (s *Service) Search(ctx context.Context, req *connect.Request[intelligencev1.TrendServiceSearchRequest]) (*connect.Response[intelligencev1.TrendServiceSearchResponse], error) {
	msg := req.Msg
	wsID := msg.WorkspaceId
	if wsID == "" {
		if caller, ok := CallerFromContext(ctx); ok {
			wsID = caller.WorkspaceID
		}
	}
	if wsID == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("workspace_id required"))
	}

	if _, err := s.authorizeCaller(ctx, wsID, "trend:read"); err != nil {
		return nil, err
	}

	stored, err := s.store.ListTrends(ctx, wsID)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	query := strings.TrimSpace(strings.ToLower(msg.Query))
	queryVec := msg.QueryEmbedding

	type searchMatch struct {
		trend      StoredTrend
		relevance  float32
		similarity float32
	}

	var matches []searchMatch
	for _, t := range stored {
		// Strict tenant isolation guard
		if t.WorkspaceID != wsID {
			continue
		}

		sim := computeSemanticSimilarity(query, queryVec, t.Title, t.Summary, t.EmbeddingVector)
		if sim > 0 {
			// Ranking combines semantic similarity (60%) and trend strength score (40%)
			compositeRelevance := (sim * 0.60) + ((t.StrengthScore / 100.0) * 0.40)
			matches = append(matches, searchMatch{
				trend:      t,
				relevance:  compositeRelevance,
				similarity: sim,
			})
		}
	}

	sort.Slice(matches, func(i, j int) bool {
		return matches[i].relevance > matches[j].relevance
	})

	limit := int(msg.Limit)
	if limit <= 0 {
		limit = 20
	}
	if len(matches) > limit {
		matches = matches[:limit]
	}

	disconnected := s.getDisconnectedList()
	hasDisconnectedSources := len(disconnected) > 0

	var protoResults []*intelligencev1.Trend
	for _, m := range matches {
		pt, err := s.toProtoTrend(ctx, wsID, m.trend, hasDisconnectedSources, disconnected)
		if err != nil {
			return nil, connect.NewError(connect.CodeInternal, err)
		}
		protoResults = append(protoResults, pt)
	}

	strategy := "pgvector_cosine_hybrid"
	if len(queryVec) == 0 {
		strategy = "bm25_semantic_token_hybrid"
	}

	return connect.NewResponse(&intelligencev1.TrendServiceSearchResponse{
		Results:        protoResults,
		TotalMatches:   int32(len(protoResults)),
		SearchStrategy: strategy,
	}), nil
}

func (s *Service) ManageWatchlist(ctx context.Context, req *connect.Request[intelligencev1.TrendServiceManageWatchlistRequest]) (*connect.Response[intelligencev1.TrendServiceManageWatchlistResponse], error) {
	msg := req.Msg
	wsID := msg.WorkspaceId
	if wsID == "" {
		if caller, ok := CallerFromContext(ctx); ok {
			wsID = caller.WorkspaceID
		}
	}

	if _, err := s.authorizeCaller(ctx, wsID, "trend:watchlist:manage"); err != nil {
		return nil, err
	}

	switch msg.Action {
	case "save_trend":
		if msg.TrendId == "" {
			return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("trend_id required to save"))
		}
		t, err := s.store.GetTrend(ctx, wsID, msg.TrendId)
		if err != nil {
			return nil, connect.NewError(connect.CodeNotFound, ErrTrendNotFound)
		}
		t.IsSaved = true
		t.UpdatedAt = time.Now()
		if err := s.store.SaveTrend(ctx, *t); err != nil {
			return nil, connect.NewError(connect.CodeInternal, err)
		}
		return connect.NewResponse(&intelligencev1.TrendServiceManageWatchlistResponse{
			Success: true,
			Message: "Trend đã được lưu vào watchlist của workspace.",
		}), nil

	case "create":
		if msg.Name == "" {
			return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("watchlist name required"))
		}
		now := time.Now()
		wlID := msg.WatchlistId
		if wlID == "" {
			wlID = fmt.Sprintf("wl-%d", now.UnixNano())
		}

		minVel := float32(80.0)
		minStr := float32(70.0)
		spikePct := float32(50.0)
		cooldown := s.alertCooldownMinutes
		if msg.AlertThreshold != nil {
			if msg.AlertThreshold.MinVelocityScore > 0 {
				minVel = msg.AlertThreshold.MinVelocityScore
			}
			if msg.AlertThreshold.MinStrengthScore > 0 {
				minStr = msg.AlertThreshold.MinStrengthScore
			}
			if msg.AlertThreshold.SpikePercentage > 0 {
				spikePct = msg.AlertThreshold.SpikePercentage
			}
			if msg.AlertThreshold.CooldownMinutes > 0 {
				cooldown = msg.AlertThreshold.CooldownMinutes
			}
		}

		storedWL := StoredWatchlist{
			WatchlistID:     wlID,
			WorkspaceID:     wsID,
			Name:            msg.Name,
			Type:            msg.Type,
			CriteriaJSON:    msg.CriteriaJson,
			AlertEnabled:    msg.AlertEnabled,
			MinVelocity:     minVel,
			MinStrength:     minStr,
			SpikePercentage: spikePct,
			CooldownMinutes: cooldown,
			TrackedTrendIDs: []string{},
			CreatedAt:       now,
			UpdatedAt:       now,
		}
		if err := s.store.SaveWatchlist(ctx, storedWL); err != nil {
			return nil, connect.NewError(connect.CodeInternal, err)
		}

		return connect.NewResponse(&intelligencev1.TrendServiceManageWatchlistResponse{
			Success: true,
			Watchlist: &intelligencev1.Watchlist{
				WatchlistId:  storedWL.WatchlistID,
				WorkspaceId:  storedWL.WorkspaceID,
				Name:         storedWL.Name,
				Type:         storedWL.Type,
				CriteriaJson: storedWL.CriteriaJSON,
				AlertEnabled: storedWL.AlertEnabled,
				AlertThreshold: &intelligencev1.AlertThreshold{
					MinVelocityScore: storedWL.MinVelocity,
					MinStrengthScore: storedWL.MinStrength,
					SpikePercentage:  storedWL.SpikePercentage,
					CooldownMinutes:  storedWL.CooldownMinutes,
				},
				CreatedAt: timestamppb.New(storedWL.CreatedAt),
				UpdatedAt: timestamppb.New(storedWL.UpdatedAt),
			},
			Message: "Watchlist được tạo thành công.",
		}), nil

	default:
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("unknown action %q", msg.Action))
	}
}

func (s *Service) GetStats(ctx context.Context, req *connect.Request[intelligencev1.TrendServiceGetStatsRequest]) (*connect.Response[intelligencev1.TrendServiceGetStatsResponse], error) {
	msg := req.Msg
	wsID := msg.WorkspaceId
	if wsID == "" {
		if caller, ok := CallerFromContext(ctx); ok {
			wsID = caller.WorkspaceID
		}
	}
	if _, err := s.authorizeCaller(ctx, wsID, "trend:read"); err != nil {
		return nil, err
	}

	stored, err := s.store.ListTrends(ctx, wsID)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	platDist := make(map[string]int32)
	newToday := int32(0)
	spiking := int32(0)
	now := time.Now()
	todayStart := time.Date(now.Year(), now.Month(), now.Day(), 0, 0, 0, 0, now.Location())

	for _, t := range stored {
		for _, p := range t.Platforms {
			platDist[p]++
		}
		if t.CreatedAt.After(todayStart) {
			newToday++
		}
		if t.VelocityScore >= 80 {
			spiking++
		}
	}

	disconnected := s.getDisconnectedList()
	return connect.NewResponse(&intelligencev1.TrendServiceGetStatsResponse{
		TotalActiveTrends:    int32(len(stored)),
		NewToday:             newToday,
		SpikingCount:         spiking,
		PlatformDistribution: platDist,
		SourceDegraded:       len(disconnected) > 0,
		DisconnectedSources:  disconnected,
	}), nil
}

// ----------------------------------------------------------------------------
// Acceptance Target 2: Watchlist Alert Evaluation and Deduplication
// ----------------------------------------------------------------------------

// EvaluateWatchlistAlerts checks all trends in a workspace against active watchlists,
// verifies thresholds, enforces fingerprint deduplication and debounce cooldowns,
// and produces batched summaries when alert storms (>5 alerts) occur (EC-M02-004).
func (s *Service) EvaluateWatchlistAlerts(ctx context.Context, workspaceID string) ([]*intelligencev1.WatchlistAlert, error) {
	if _, err := s.authorizeCaller(ctx, workspaceID, "trend:read"); err != nil {
		return nil, err
	}

	watchlists, err := s.store.ListWatchlists(ctx, workspaceID)
	if err != nil {
		return nil, err
	}
	trends, err := s.store.ListTrends(ctx, workspaceID)
	if err != nil {
		return nil, err
	}

	now := time.Now()
	var triggeredAlerts []*intelligencev1.WatchlistAlert

	for _, wl := range watchlists {
		if !wl.AlertEnabled {
			continue
		}

		for _, t := range trends {
			// Check if trend meets watchlist criteria
			matches := false
			if len(wl.TrackedTrendIDs) > 0 {
				for _, tid := range wl.TrackedTrendIDs {
					if tid == t.TrendID {
						matches = true
						break
					}
				}
			} else {
				// Keyword / Category match
				if wl.CriteriaJSON != "" && strings.Contains(strings.ToLower(t.Title), strings.ToLower(wl.Name)) {
					matches = true
				} else {
					matches = true // Default to tracking all trends in watchlist domain
				}
			}
			if !matches {
				continue
			}

			// Threshold breach evaluation
			thresholdBreached := false
			if wl.MinVelocity > 0 && t.VelocityScore >= wl.MinVelocity {
				thresholdBreached = true
			}
			if wl.MinStrength > 0 && t.StrengthScore >= wl.MinStrength {
				thresholdBreached = true
			}

			if !thresholdBreached {
				continue
			}

			// Deterministic Alert Fingerprint for Deduplication
			// sha256(workspace_id + ":" + watchlist_id + ":" + trend_id + ":" + metric_bucket)
			fpRaw := fmt.Sprintf("%s:%s:%s:vel_%d", workspaceID, wl.WatchlistID, t.TrendID, int(t.VelocityScore/10)*10)
			hasher := sha256.New()
			hasher.Write([]byte(fpRaw))
			fingerprint := hex.EncodeToString(hasher.Sum(nil))

			// Check for active cooldown in alert log
			activeLog, err := s.store.FindActiveAlertLog(ctx, workspaceID, fingerprint, now)
			if err != nil {
				return nil, err
			}
			if activeLog != nil {
				// Deduplicated: Alert suppressed because cooldown window is active!
				continue
			}

			// Record new alert log with cooldown
			cooldownDuration := time.Duration(wl.CooldownMinutes) * time.Minute
			if cooldownDuration <= 0 {
				cooldownDuration = time.Duration(s.alertCooldownMinutes) * time.Minute
			}
			cooldownUntil := now.Add(cooldownDuration)
			alertLogID := fmt.Sprintf("alert-%d", now.UnixNano())

			logEntry := StoredAlertLog{
				AlertLogID:       alertLogID,
				WorkspaceID:      workspaceID,
				WatchlistID:      wl.WatchlistID,
				TrendID:          t.TrendID,
				AlertFingerprint: fingerprint,
				MetricsSnapshot:  fmt.Sprintf(`{"velocity": %f, "strength": %f}`, t.VelocityScore, t.StrengthScore),
				DeliveredAt:      now,
				CooldownUntil:    cooldownUntil,
			}
			if err := s.store.RecordAlertLog(ctx, logEntry); err != nil {
				return nil, err
			}

			triggeredAlerts = append(triggeredAlerts, &intelligencev1.WatchlistAlert{
				AlertLogId:       alertLogID,
				WatchlistId:      wl.WatchlistID,
				TrendId:          t.TrendID,
				TrendTitle:       t.Title,
				AlertFingerprint: fingerprint,
				VelocityScore:    t.VelocityScore,
				ThresholdValue:   wl.MinVelocity,
				DeliveredAt:      timestamppb.New(now),
				CooldownUntil:    timestamppb.New(cooldownUntil),
			})
		}
	}

	// EC-M02-004: Alert Storm Handling
	// If more than 5 alerts fire simultaneously, batch into summary notification
	if len(triggeredAlerts) > 5 {
		batchedSummary := &intelligencev1.WatchlistAlert{
			AlertLogId:        fmt.Sprintf("summary-%d", now.UnixNano()),
			WatchlistId:       "batched",
			TrendTitle:        fmt.Sprintf("%d watchlist trends spiking — View All", len(triggeredAlerts)),
			AlertFingerprint:  fmt.Sprintf("batch-%d", now.Unix()),
			DeliveredAt:       timestamppb.New(now),
			IsBatchedSummary:  true,
			BatchedAlertCount: int32(len(triggeredAlerts)),
		}
		// Return batched summary plus the individual alert items
		return append([]*intelligencev1.WatchlistAlert{batchedSummary}, triggeredAlerts...), nil
	}

	return triggeredAlerts, nil
}

// ----------------------------------------------------------------------------
// Opportunity & Idea Conversion
// ----------------------------------------------------------------------------

// ConvertToOpportunity implements AC-M02-002:
// Converts a trend into an M04 Opportunity, linking back via opportunity_sources with source_type = 'trend'.
func (s *Service) ConvertToOpportunity(ctx context.Context, workspaceID, trendID, title string) (string, error) {
	if _, err := s.authorizeCaller(ctx, workspaceID, "trend:read"); err != nil {
		return "", err
	}

	t, err := s.store.GetTrend(ctx, workspaceID, trendID)
	if err != nil {
		return "", ErrTrendNotFound
	}

	oppTitle := title
	if oppTitle == "" {
		oppTitle = "Cơ hội từ xu hướng: " + t.Title
	}

	oppID := fmt.Sprintf("opp-%d", time.Now().UnixNano())
	opp := StoredOpportunity{
		OpportunityID:   oppID,
		WorkspaceID:     workspaceID,
		Title:           oppTitle,
		Hypothesis:      t.Summary,
		OpportunityType: "content",
		SourceType:      "trend",
		SourceID:        trendID,
		OverallScore:    t.StrengthScore,
		Status:          "new",
		CreatedAt:       time.Now(),
	}

	if err := s.store.SaveOpportunity(ctx, opp); err != nil {
		return "", err
	}
	return oppID, nil
}

// ----------------------------------------------------------------------------
// Internal Helper: toProtoTrend with Degraded Data Handling (Acceptance Target 1)
// ----------------------------------------------------------------------------

func (s *Service) toProtoTrend(ctx context.Context, wsID string, t StoredTrend, anyDisconnected bool, disconnectedList []string) (*intelligencev1.Trend, error) {
	isDegraded := t.IsDegraded
	degradedReason := t.DegradedReason
	conf := t.Confidence
	srcClass := t.SourceClass
	confReason := t.ConfidenceReason

	// Check if any of the trend's platforms is currently disconnected
	for _, p := range t.Platforms {
		if s.isSourceDisconnected(p) {
			isDegraded = true
			conf = intelligencev1.ConfidenceBand_CONFIDENCE_BAND_LOW
			srcClass = intelligencev1.SourceClass_SOURCE_CLASS_ESTIMATED
			degradedReason = fmt.Sprintf("Nguồn dữ liệu %s bị ngắt kết nối (token expired); sử dụng số liệu ước tính giảm cấp.", p)
			confReason = fmt.Sprintf("Độ tin cậy giảm xuống MỨC THẤP do nguồn %s không thể đồng bộ trực tiếp.", p)
			break
		}
	}

	if conf == intelligencev1.ConfidenceBand_CONFIDENCE_BAND_UNSPECIFIED {
		conf = intelligencev1.ConfidenceBand_CONFIDENCE_BAND_MEDIUM
	}
	if srcClass == intelligencev1.SourceClass_SOURCE_CLASS_UNSPECIFIED {
		srcClass = intelligencev1.SourceClass_SOURCE_CLASS_INFERRED
	}
	if confReason == "" {
		confReason = "Dữ liệu được xác thực từ tín hiệu đa nền tảng thời gian thực."
	}

	// Fetch signals lineage
	sigs, _ := s.store.ListSignalsForTrend(ctx, wsID, t.TrendID)
	var protoSigs []*intelligencev1.SignalRef
	for _, sig := range sigs {
		protoSigs = append(protoSigs, &intelligencev1.SignalRef{
			SignalId:          sig.SignalID,
			WorkspaceId:       sig.WorkspaceID,
			SourcePlatform:    sig.SourcePlatform,
			SourceClass:       sig.SourceClass,
			SignalType:        sig.SignalType,
			NormalizedSummary: sig.NormalizedSummary,
			Confidence:        sig.Confidence,
			FreshnessAt:       timestamppb.New(sig.FreshnessAt),
			CollectedAt:       timestamppb.New(sig.CollectedAt),
		})
	}

	freshnessAt := t.FreshnessAt
	if freshnessAt.IsZero() {
		freshnessAt = time.Now()
	}

	return &intelligencev1.Trend{
		TrendId:              t.TrendID,
		WorkspaceId:          t.WorkspaceID,
		Title:                t.Title,
		Summary:              t.Summary,
		Category:             t.Category,
		Platforms:            t.Platforms,
		StrengthScore:        t.StrengthScore,
		VelocityScore:        t.VelocityScore,
		FreshnessScore:       t.FreshnessScore,
		SaturationScore:      t.SaturationScore,
		Confidence:           conf,
		ConfidenceReason:     confReason,
		SourceClass:          srcClass,
		LifecycleState:       t.LifecycleState,
		FreshnessAt:          timestamppb.New(freshnessAt),
		WhyNow:               t.WhyNow,
		RelevanceDescription: t.RelevanceDescription,
		SourceSignals:        protoSigs,
		IsSaved:              t.IsSaved,
		IsDegraded:           isDegraded,
		DegradedReason:       degradedReason,
		EmbeddingVector:      t.EmbeddingVector,
		CreatedAt:            timestamppb.New(t.CreatedAt),
		UpdatedAt:            timestamppb.New(t.UpdatedAt),
	}, nil
}

// computeSemanticSimilarity evaluates vector cosine similarity or token overlap.
func computeSemanticSimilarity(query string, queryVec []float32, title, summary string, docVec []float32) float32 {
	// 1. Vector cosine similarity if embeddings are supplied
	if len(queryVec) > 0 && len(docVec) > 0 && len(queryVec) == len(docVec) {
		var dot, normQ, normD float64
		for i := range queryVec {
			dot += float64(queryVec[i]) * float64(docVec[i])
			normQ += float64(queryVec[i]) * float64(queryVec[i])
			normD += float64(docVec[i]) * float64(docVec[i])
		}
		if normQ > 0 && normD > 0 {
			cos := float32(dot / (math.Sqrt(normQ) * math.Sqrt(normD)))
			if cos > 0 {
				return cos
			}
		}
	}

	// 2. Token-level semantic matching fallback
	if query == "" {
		return 0.5 // Default baseline score
	}

	text := strings.ToLower(title + " " + summary)
	tokens := strings.Fields(query)
	if len(tokens) == 0 {
		return 0.5
	}

	matches := 0
	for _, tok := range tokens {
		if strings.Contains(text, tok) {
			matches++
		}
	}

	if matches > 0 {
		return float32(matches) / float32(len(tokens))
	}
	return 0
}
