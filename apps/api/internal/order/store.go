package order

import (
	"context"
	"crypto/rand"
	"encoding/json"
	"errors"
	"fmt"
	"strings"
	"sync"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

func newUUID() string {
	b := make([]byte, 16)
	_, _ = rand.Read(b)
	b[6] = (b[6] & 0x0f) | 0x40
	b[8] = (b[8] & 0x3f) | 0x80
	return fmt.Sprintf("%08x-%04x-%04x-%04x-%012x",
		b[0:4], b[4:6], b[6:8], b[8:10], b[10:16])
}

type OrderFilter struct {
	State          LifecycleState
	SourcePlatform string
	DateFrom       *time.Time
	DateTo         *time.Time
}

type Store interface {
	CreateOrder(ctx context.Context, o *Order) error
	DeleteOrder(ctx context.Context, workspaceID, orderID string) error
	GetOrder(ctx context.Context, workspaceID, orderID string) (*Order, error)
	FindOrderByExternalID(ctx context.Context, workspaceID, platform, externalOrderID, connectedAccountID string) (*Order, error)
	FindOrderByImportFingerprint(ctx context.Context, workspaceID, fingerprint string) (*Order, error)
	UpdateOrderStatus(ctx context.Context, workspaceID, orderID string, state LifecycleState, refundedAmount *tenantdb.ExactDecimal) error
	UpdateOrder(ctx context.Context, o *Order) error
	ListOrders(ctx context.Context, workspaceID string, filter OrderFilter, limit, offset int) ([]*Order, int64, error)

	CreateRefund(ctx context.Context, r *Refund) error
	GetRefund(ctx context.Context, workspaceID, refundID string) (*Refund, error)
	FindRefundByExternalID(ctx context.Context, workspaceID, orderID, platform, externalRefundID string) (*Refund, error)
	ListRefundsByOrder(ctx context.Context, workspaceID, orderID string) ([]*Refund, error)
	UpdateRefundStatus(ctx context.Context, workspaceID, refundID string, state RefundState) error
	ApproveRefundAtomic(ctx context.Context, workspaceID, refundID string) (*Refund, *Order, LifecycleState, tenantdb.ExactDecimal, bool, error)
	RevertRefundApproval(ctx context.Context, workspaceID, refundID, orderID string, prevState LifecycleState, prevRefunded tenantdb.ExactDecimal) error

	CreateReturn(ctx context.Context, ret *Return) error
	GetReturn(ctx context.Context, workspaceID, returnID string) (*Return, error)
	ListReturnsByOrder(ctx context.Context, workspaceID, orderID string) ([]*Return, error)
	UpdateReturnStatus(ctx context.Context, workspaceID, returnID string, state ReturnState) error
}

// ----------------------------------------------------------------------------
// In-Memory Hermetic Store Implementation
// ----------------------------------------------------------------------------

type MemoryStore struct {
	mu      sync.RWMutex
	orders  map[string]*Order  // key: workspaceID:orderID
	refunds map[string]*Refund // key: workspaceID:refundID
	returns map[string]*Return // key: workspaceID:returnID
}

func NewMemoryStore() *MemoryStore {
	return &MemoryStore{
		orders:  make(map[string]*Order),
		refunds: make(map[string]*Refund),
		returns: make(map[string]*Return),
	}
}

func cloneOrder(o *Order) *Order {
	if o == nil {
		return nil
	}
	cp := *o
	if len(o.Items) > 0 {
		cp.Items = make([]OrderItem, len(o.Items))
		copy(cp.Items, o.Items)
	}
	if len(o.EvidenceRefs) > 0 {
		cp.EvidenceRefs = make([]string, len(o.EvidenceRefs))
		copy(cp.EvidenceRefs, o.EvidenceRefs)
	}
	if o.Metadata != nil {
		cp.Metadata = make(map[string]any, len(o.Metadata))
		for k, v := range o.Metadata {
			cp.Metadata[k] = v
		}
	}
	return &cp
}

func cloneRefund(r *Refund) *Refund {
	if r == nil {
		return nil
	}
	cp := *r
	if len(r.EvidenceRefs) > 0 {
		cp.EvidenceRefs = make([]string, len(r.EvidenceRefs))
		copy(cp.EvidenceRefs, r.EvidenceRefs)
	}
	return &cp
}

func cloneReturn(ret *Return) *Return {
	if ret == nil {
		return nil
	}
	cp := *ret
	if len(ret.Items) > 0 {
		cp.Items = make([]ReturnItem, len(ret.Items))
		copy(cp.Items, ret.Items)
	}
	return &cp
}

func (m *MemoryStore) CreateOrder(_ context.Context, o *Order) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	if o.OrderID == "" {
		o.OrderID = newUUID()
	}
	key := o.WorkspaceID + ":" + o.OrderID
	if _, exists := m.orders[key]; exists {
		return ErrOrderAlreadyExists
	}
	now := time.Now().UTC()
	if o.CreatedAt.IsZero() {
		o.CreatedAt = now
	}
	if o.UpdatedAt.IsZero() {
		o.UpdatedAt = now
	}
	if o.Metadata == nil {
		o.Metadata = make(map[string]any)
	}
	o.Metadata["refunded_amount"] = o.RefundedAmount.Fixed6String()

	m.orders[key] = cloneOrder(o)
	return nil
}

func (m *MemoryStore) DeleteOrder(_ context.Context, workspaceID, orderID string) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	key := workspaceID + ":" + orderID
	delete(m.orders, key)
	return nil
}

func (m *MemoryStore) GetOrder(_ context.Context, workspaceID, orderID string) (*Order, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	key := workspaceID + ":" + orderID
	o, exists := m.orders[key]
	if !exists || o.DeletedAt != nil {
		return nil, ErrOrderNotFound
	}
	return cloneOrder(o), nil
}

func (m *MemoryStore) FindOrderByExternalID(_ context.Context, workspaceID, platform, externalOrderID, connectedAccountID string) (*Order, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	for _, o := range m.orders {
		if o.WorkspaceID == workspaceID &&
			o.SourcePlatform == platform &&
			o.ExternalOrderID == externalOrderID &&
			o.ConnectedAccountID == connectedAccountID &&
			o.DeletedAt == nil {
			return cloneOrder(o), nil
		}
	}
	return nil, nil
}

func (m *MemoryStore) FindOrderByImportFingerprint(_ context.Context, workspaceID, fingerprint string) (*Order, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	for _, o := range m.orders {
		if o.WorkspaceID == workspaceID &&
			o.ImportFingerprint == fingerprint &&
			o.DeletedAt == nil {
			return cloneOrder(o), nil
		}
	}
	return nil, nil
}

func (m *MemoryStore) UpdateOrderStatus(_ context.Context, workspaceID, orderID string, state LifecycleState, refundedAmount *tenantdb.ExactDecimal) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	key := workspaceID + ":" + orderID
	o, exists := m.orders[key]
	if !exists || o.DeletedAt != nil {
		return ErrOrderNotFound
	}

	o.LifecycleState = state
	if refundedAmount != nil {
		o.RefundedAmount = *refundedAmount
		if o.Metadata == nil {
			o.Metadata = make(map[string]any)
		}
		o.Metadata["refunded_amount"] = refundedAmount.Fixed6String()
	}
	o.UpdatedAt = time.Now().UTC()
	return nil
}

func (m *MemoryStore) UpdateOrder(_ context.Context, o *Order) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	key := o.WorkspaceID + ":" + o.OrderID
	if _, exists := m.orders[key]; !exists {
		return ErrOrderNotFound
	}
	if o.Metadata == nil {
		o.Metadata = make(map[string]any)
	}
	o.Metadata["refunded_amount"] = o.RefundedAmount.Fixed6String()
	o.UpdatedAt = time.Now().UTC()
	m.orders[key] = cloneOrder(o)
	return nil
}

func (m *MemoryStore) ListOrders(_ context.Context, workspaceID string, filter OrderFilter, limit, offset int) ([]*Order, int64, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var matching []*Order
	for _, o := range m.orders {
		if o.WorkspaceID != workspaceID || o.DeletedAt != nil {
			continue
		}
		if filter.State != "" && o.LifecycleState != filter.State {
			continue
		}
		if filter.SourcePlatform != "" && o.SourcePlatform != filter.SourcePlatform {
			continue
		}
		if filter.DateFrom != nil && o.OrderedAt.Before(*filter.DateFrom) {
			continue
		}
		if filter.DateTo != nil && o.OrderedAt.After(*filter.DateTo) {
			continue
		}
		matching = append(matching, cloneOrder(o))
	}

	total := int64(len(matching))
	if offset > len(matching) {
		return []*Order{}, total, nil
	}
	end := offset + limit
	if limit <= 0 || end > len(matching) {
		end = len(matching)
	}
	return matching[offset:end], total, nil
}

func (m *MemoryStore) CreateRefund(_ context.Context, r *Refund) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	if r.RefundID == "" {
		r.RefundID = newUUID()
	}
	key := r.WorkspaceID + ":" + r.RefundID
	now := time.Now().UTC()
	if r.CreatedAt.IsZero() {
		r.CreatedAt = now
	}
	if r.UpdatedAt.IsZero() {
		r.UpdatedAt = now
	}
	m.refunds[key] = cloneRefund(r)
	return nil
}

func (m *MemoryStore) GetRefund(_ context.Context, workspaceID, refundID string) (*Refund, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	key := workspaceID + ":" + refundID
	r, exists := m.refunds[key]
	if !exists || r.DeletedAt != nil {
		return nil, ErrRefundNotFound
	}
	return cloneRefund(r), nil
}

func (m *MemoryStore) FindRefundByExternalID(_ context.Context, workspaceID, orderID, platform, externalRefundID string) (*Refund, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	if externalRefundID == "" {
		return nil, nil
	}
	for _, r := range m.refunds {
		if r.WorkspaceID == workspaceID &&
			r.OrderID == orderID &&
			(platform == "" || r.SourcePlatform == platform) &&
			r.ExternalRefundID == externalRefundID &&
			r.DeletedAt == nil {
			return cloneRefund(r), nil
		}
	}
	return nil, nil
}

func (m *MemoryStore) ListRefundsByOrder(_ context.Context, workspaceID, orderID string) ([]*Refund, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var results []*Refund
	for _, r := range m.refunds {
		if r.WorkspaceID == workspaceID && r.OrderID == orderID && r.DeletedAt == nil {
			results = append(results, cloneRefund(r))
		}
	}
	return results, nil
}

func (m *MemoryStore) UpdateRefundStatus(_ context.Context, workspaceID, refundID string, state RefundState) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	key := workspaceID + ":" + refundID
	r, exists := m.refunds[key]
	if !exists || r.DeletedAt != nil {
		return ErrRefundNotFound
	}
	r.LifecycleState = state
	r.UpdatedAt = time.Now().UTC()
	return nil
}

func (m *MemoryStore) ApproveRefundAtomic(_ context.Context, workspaceID, refundID string) (*Refund, *Order, LifecycleState, tenantdb.ExactDecimal, bool, error) {
	m.mu.Lock()
	defer m.mu.Unlock()

	rKey := workspaceID + ":" + refundID
	r, exists := m.refunds[rKey]
	if !exists || r.DeletedAt != nil {
		return nil, nil, "", tenantdb.ZeroDecimal(), false, ErrRefundNotFound
	}

	oKey := workspaceID + ":" + r.OrderID
	o, oExists := m.orders[oKey]
	if !oExists || o.DeletedAt != nil {
		return nil, nil, "", tenantdb.ZeroDecimal(), false, ErrOrderNotFound
	}

	if r.LifecycleState == RefundApproved || r.LifecycleState == RefundCompleted {
		return cloneRefund(r), cloneOrder(o), o.LifecycleState, o.RefundedAmount, false, nil
	}
	if r.LifecycleState != RefundRequested && r.LifecycleState != RefundProcessing {
		return nil, nil, "", tenantdb.ZeroDecimal(), false, fmt.Errorf("%w: cannot approve refund in state %s", ErrInvalidRefundTransition, r.LifecycleState)
	}
	if r.Currency != "" && o.Currency != "" && r.Currency != o.Currency {
		return nil, nil, "", tenantdb.ZeroDecimal(), false, fmt.Errorf("%w: refund currency %s does not match order currency %s", ErrCurrencyMismatch, r.Currency, o.Currency)
	}

	rem, err := o.RefundableRemaining()
	if err != nil {
		return nil, nil, "", tenantdb.ZeroDecimal(), false, err
	}
	if r.Amount.Cmp(rem) > 0 {
		return nil, nil, "", tenantdb.ZeroDecimal(), false, fmt.Errorf("%w: refund amount %s exceeds remaining refundable %s", ErrRefundExceedsOrderTotal, r.Amount.Fixed6String(), rem.Fixed6String())
	}

	newRefunded, err := o.RefundedAmount.Add(r.Amount)
	if err != nil {
		return nil, nil, "", tenantdb.ZeroDecimal(), false, err
	}

	prevState := o.LifecycleState
	prevRefunded := o.RefundedAmount

	var newOrderState LifecycleState
	if newRefunded.Cmp(o.Amount) == 0 {
		newOrderState = StateRefunded
	} else {
		newOrderState = StatePartiallyRefunded
	}

	now := time.Now().UTC()
	o.LifecycleState = newOrderState
	o.RefundedAmount = newRefunded
	if o.Metadata == nil {
		o.Metadata = make(map[string]any)
	}
	o.Metadata["refunded_amount"] = newRefunded.Fixed6String()
	o.UpdatedAt = now

	r.LifecycleState = RefundCompleted
	r.UpdatedAt = now

	return cloneRefund(r), cloneOrder(o), prevState, prevRefunded, true, nil
}

func (m *MemoryStore) RevertRefundApproval(_ context.Context, workspaceID, refundID, orderID string, prevState LifecycleState, prevRefunded tenantdb.ExactDecimal) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	rKey := workspaceID + ":" + refundID
	if r, exists := m.refunds[rKey]; exists && r.DeletedAt == nil {
		r.LifecycleState = RefundRequested
		r.UpdatedAt = time.Now().UTC()
	}
	oKey := workspaceID + ":" + orderID
	if o, exists := m.orders[oKey]; exists && o.DeletedAt == nil {
		o.LifecycleState = prevState
		o.RefundedAmount = prevRefunded
		if o.Metadata == nil {
			o.Metadata = make(map[string]any)
		}
		o.Metadata["refunded_amount"] = prevRefunded.Fixed6String()
		o.UpdatedAt = time.Now().UTC()
	}
	return nil
}

func (m *MemoryStore) CreateReturn(_ context.Context, ret *Return) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	if ret.ReturnID == "" {
		ret.ReturnID = newUUID()
	}
	key := ret.WorkspaceID + ":" + ret.ReturnID
	now := time.Now().UTC()
	if ret.CreatedAt.IsZero() {
		ret.CreatedAt = now
	}
	if ret.UpdatedAt.IsZero() {
		ret.UpdatedAt = now
	}
	m.returns[key] = cloneReturn(ret)
	return nil
}

func (m *MemoryStore) GetReturn(_ context.Context, workspaceID, returnID string) (*Return, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	key := workspaceID + ":" + returnID
	ret, exists := m.returns[key]
	if !exists || ret.DeletedAt != nil {
		return nil, ErrReturnNotFound
	}
	return cloneReturn(ret), nil
}

func (m *MemoryStore) ListReturnsByOrder(_ context.Context, workspaceID, orderID string) ([]*Return, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var results []*Return
	for _, ret := range m.returns {
		if ret.WorkspaceID == workspaceID && ret.OrderID == orderID && ret.DeletedAt == nil {
			results = append(results, cloneReturn(ret))
		}
	}
	return results, nil
}

func (m *MemoryStore) UpdateReturnStatus(_ context.Context, workspaceID, returnID string, state ReturnState) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	key := workspaceID + ":" + returnID
	ret, exists := m.returns[key]
	if !exists || ret.DeletedAt != nil {
		return ErrReturnNotFound
	}
	ret.LifecycleState = state
	ret.UpdatedAt = time.Now().UTC()
	return nil
}

// ----------------------------------------------------------------------------
// PostgreSQL 17 Store Implementation
// ----------------------------------------------------------------------------

const defaultServiceUserID = "00000000-0000-4000-8000-000000000001"

const setLocalTenantContextSQL = `
SELECT
  set_config('app.current_tenant_id', $1, true),
  set_config('app.current_user_id', $2, true)
`

type activeTxContextKey struct{}

type activeTenantTx struct {
	tx          pgx.Tx
	workspaceID string
}

type PostgresStore struct {
	pool     *pgxpool.Pool
	beginner tenantdb.TxBeginner
}

func NewPostgresStore(pool *pgxpool.Pool) *PostgresStore {
	var b tenantdb.TxBeginner
	if pool != nil {
		b = pool
	}
	return &PostgresStore{pool: pool, beginner: b}
}

func NewPostgresStoreWithBeginner(beginner tenantdb.TxBeginner) *PostgresStore {
	return &PostgresStore{beginner: beginner}
}

func (s *PostgresStore) txBeginner() tenantdb.TxBeginner {
	if s.beginner != nil {
		return s.beginner
	}
	if s.pool != nil {
		return s.pool
	}
	return nil
}

func (s *PostgresStore) withTenantTx(ctx context.Context, workspaceID string, fn func(ctx context.Context, tx pgx.Tx) error) (retErr error) {
	if ctx == nil {
		return tenantdb.ErrNilContext
	}
	if err := ctx.Err(); err != nil {
		return err
	}
	wsID := strings.TrimSpace(workspaceID)
	if wsID == "" {
		return ErrMissingTenant
	}
	userID := defaultServiceUserID
	if sc, ok := tenantdb.ScopeFromContext(ctx); ok {
		if sc.WorkspaceID != "" && sc.WorkspaceID != wsID {
			return tenantdb.ErrScopeMismatch
		}
		if sc.UserID != "" {
			userID = sc.UserID
		}
	}
	if active, ok := ctx.Value(activeTxContextKey{}).(activeTenantTx); ok && active.tx != nil {
		if active.workspaceID != wsID {
			return tenantdb.ErrScopeMismatch
		}
		return fn(ctx, active.tx)
	}
	b := s.txBeginner()
	if b == nil {
		return tenantdb.ErrNilBeginner
	}
	tx, err := b.Begin(ctx)
	if err != nil {
		return fmt.Errorf("order: begin tenant transaction: %w", err)
	}
	committed := false
	defer func() {
		if p := recover(); p != nil {
			_ = tx.Rollback(context.Background())
			panic(p)
		}
		if !committed {
			_ = tx.Rollback(context.Background())
		}
	}()

	var configuredTenant, configuredUser string
	if err := tx.QueryRow(ctx, setLocalTenantContextSQL, wsID, userID).Scan(&configuredTenant, &configuredUser); err != nil {
		return fmt.Errorf("order: set local tenant context: %w", err)
	}
	if configuredTenant != wsID || configuredUser != userID {
		return fmt.Errorf("%w: set_config verification mismatch", tenantdb.ErrInvalidTenantScope)
	}

	txCtx := context.WithValue(ctx, activeTxContextKey{}, activeTenantTx{
		tx:          tx,
		workspaceID: wsID,
	})
	if err := fn(txCtx, tx); err != nil {
		return err
	}
	if err := ctx.Err(); err != nil {
		return err
	}
	if err := tx.Commit(ctx); err != nil {
		return fmt.Errorf("order: commit tenant transaction: %w", err)
	}
	committed = true
	return nil
}

func (s *PostgresStore) CreateOrder(ctx context.Context, o *Order) error {
	if o.OrderID == "" {
		o.OrderID = newUUID()
	}
	if o.Metadata == nil {
		o.Metadata = make(map[string]any)
	}
	o.Metadata["refunded_amount"] = o.RefundedAmount.Fixed6String()

	itemsJSON, err := json.Marshal(o.Items)
	if err != nil {
		return fmt.Errorf("marshal items: %w", err)
	}
	feeJSON, err := json.Marshal(o.FeeBreakdown)
	if err != nil {
		return fmt.Errorf("marshal fee_breakdown: %w", err)
	}
	shipJSON, err := json.Marshal(o.ShippingAddress)
	if err != nil {
		shipJSON = []byte("{}")
	}
	rateJSON, err := json.Marshal(o.ExchangeRateSnapshot)
	if err != nil {
		rateJSON = []byte("{}")
	}
	evidenceJSON, err := json.Marshal(o.EvidenceRefs)
	if err != nil {
		evidenceJSON = []byte("[]")
	}
	metaJSON, err := json.Marshal(o.Metadata)
	if err != nil {
		metaJSON = []byte("{}")
	}

	const q = `
		INSERT INTO orders (
			order_id, workspace_id, source_class, source_platform, external_order_id,
			connected_account_id, tax_amount, tax_jurisdiction, tax_note, exchange_rate_snapshot,
			recognized_at, source_updated_at, import_fingerprint, lifecycle_state,
			amount, currency, product_id, offer_id, campaign_id, post_id, live_session_id,
			customer_entity_id, items, fee_breakdown, shipping_address, reconciliation_state,
			evidence_refs, metadata, ordered_at, created_at, updated_at
		) VALUES (
			$1, $2, $3, NULLIF($4, ''), NULLIF($5, ''),
			NULLIF($6, '')::uuid, $7, $8, $9, $10,
			$11, $12, NULLIF($13, ''), $14,
			$15, $16, NULLIF($17, '')::uuid, NULLIF($18, '')::uuid, NULLIF($19, '')::uuid, NULLIF($20, '')::uuid, NULLIF($21, '')::uuid,
			NULLIF($22, '')::uuid, $23, $24, $25, NULLIF($26, '')::reconciliation_state,
			$27, $28, $29, NOW(), NOW()
		);
	`

	return s.withTenantTx(ctx, o.WorkspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		_, err := tx.Exec(txCtx, q,
			o.OrderID, o.WorkspaceID, string(o.SourceClass), o.SourcePlatform, o.ExternalOrderID,
			o.ConnectedAccountID, o.TaxAmount.Fixed6String(), o.TaxJurisdiction, o.TaxNote, rateJSON,
			o.RecognizedAt, o.SourceUpdatedAt, o.ImportFingerprint, string(o.LifecycleState),
			o.Amount.Fixed6String(), o.Currency, o.ProductID, o.OfferID, o.CampaignID, o.PostID, o.LiveSessionID,
			o.CustomerEntityID, itemsJSON, feeJSON, shipJSON, o.ReconciliationState,
			evidenceJSON, metaJSON, o.OrderedAt,
		)
		return err
	})
}

func (s *PostgresStore) DeleteOrder(ctx context.Context, workspaceID, orderID string) error {
	const q = `
		DELETE FROM orders
		WHERE workspace_id = $1 AND order_id = $2;
	`
	return s.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		_, err := tx.Exec(txCtx, q, workspaceID, orderID)
		return err
	})
}

func (s *PostgresStore) scanOrder(row pgx.Row) (*Order, error) {
	var o Order
	var sourceClass, lifecycleState, recState string
	var taxNum, amountNum pgtype.Numeric
	var extOrderID, connAccID, taxJurisdiction, taxNote, fingerprint *string
	var prodID, offerID, campID, postID, liveID, custID *string
	var rateJSON, itemsJSON, feeJSON, shipJSON, evJSON, metaJSON []byte

	err := row.Scan(
		&o.OrderID, &o.WorkspaceID, &sourceClass, &o.SourcePlatform, &extOrderID,
		&connAccID, &taxNum, &taxJurisdiction, &taxNote, &rateJSON,
		&o.RecognizedAt, &o.SourceUpdatedAt, &fingerprint, &lifecycleState,
		&amountNum, &o.Currency, &prodID, &offerID, &campID, &postID, &liveID,
		&custID, &itemsJSON, &feeJSON, &shipJSON, &recState,
		&evJSON, &metaJSON, &o.OrderedAt, &o.CreatedAt, &o.UpdatedAt, &o.DeletedAt,
	)
	if err != nil {
		return nil, err
	}

	o.SourceClass = SourceClass(sourceClass)
	o.LifecycleState = LifecycleState(lifecycleState)
	o.ReconciliationState = recState
	if extOrderID != nil {
		o.ExternalOrderID = *extOrderID
	}
	if connAccID != nil {
		o.ConnectedAccountID = *connAccID
	}
	if taxJurisdiction != nil {
		o.TaxJurisdiction = *taxJurisdiction
	}
	if taxNote != nil {
		o.TaxNote = *taxNote
	}
	if fingerprint != nil {
		o.ImportFingerprint = *fingerprint
	}
	if prodID != nil {
		o.ProductID = *prodID
	}
	if offerID != nil {
		o.OfferID = *offerID
	}
	if campID != nil {
		o.CampaignID = *campID
	}
	if postID != nil {
		o.PostID = *postID
	}
	if liveID != nil {
		o.LiveSessionID = *liveID
	}
	if custID != nil {
		o.CustomerEntityID = *custID
	}

	if taxDec, err := tenantdb.FromPgNumeric(taxNum); err == nil {
		o.TaxAmount = taxDec
	}
	if amtDec, err := tenantdb.FromPgNumeric(amountNum); err == nil {
		o.Amount = amtDec
	}

	if len(rateJSON) > 0 {
		_ = json.Unmarshal(rateJSON, &o.ExchangeRateSnapshot)
	}
	if len(itemsJSON) > 0 {
		_ = json.Unmarshal(itemsJSON, &o.Items)
	}
	if len(feeJSON) > 0 {
		_ = json.Unmarshal(feeJSON, &o.FeeBreakdown)
	}
	if len(shipJSON) > 0 {
		_ = json.Unmarshal(shipJSON, &o.ShippingAddress)
	}
	if len(evJSON) > 0 {
		_ = json.Unmarshal(evJSON, &o.EvidenceRefs)
	}
	if len(metaJSON) > 0 {
		_ = json.Unmarshal(metaJSON, &o.Metadata)
		if refStr, ok := o.Metadata["refunded_amount"].(string); ok && refStr != "" {
			if refDec, err := tenantdb.ParseExactDecimal(refStr); err == nil {
				o.RefundedAmount = refDec
			}
		}
	}

	return &o, nil
}

func (s *PostgresStore) GetOrder(ctx context.Context, workspaceID, orderID string) (*Order, error) {
	const q = `
		SELECT
			order_id, workspace_id, source_class, COALESCE(source_platform, ''), external_order_id,
			connected_account_id::text, tax_amount, tax_jurisdiction, tax_note, exchange_rate_snapshot,
			recognized_at, source_updated_at, import_fingerprint, lifecycle_state,
			amount, currency, product_id::text, offer_id::text, campaign_id::text, post_id::text, live_session_id::text,
			customer_entity_id::text, items, fee_breakdown, shipping_address, reconciliation_state::text,
			evidence_refs, metadata, ordered_at, created_at, updated_at, deleted_at
		FROM orders
		WHERE workspace_id = $1 AND order_id = $2 AND deleted_at IS NULL;
	`
	var o *Order
	err := s.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		var scanErr error
		o, scanErr = s.scanOrder(tx.QueryRow(txCtx, q, workspaceID, orderID))
		if scanErr != nil {
			if errors.Is(scanErr, pgx.ErrNoRows) {
				return ErrOrderNotFound
			}
			return scanErr
		}
		return nil
	})
	if err != nil {
		return nil, err
	}
	return o, nil
}

func (s *PostgresStore) FindOrderByExternalID(ctx context.Context, workspaceID, platform, externalOrderID, connectedAccountID string) (*Order, error) {
	const q = `
		SELECT
			order_id, workspace_id, source_class, COALESCE(source_platform, ''), external_order_id,
			connected_account_id::text, tax_amount, tax_jurisdiction, tax_note, exchange_rate_snapshot,
			recognized_at, source_updated_at, import_fingerprint, lifecycle_state,
			amount, currency, product_id::text, offer_id::text, campaign_id::text, post_id::text, live_session_id::text,
			customer_entity_id::text, items, fee_breakdown, shipping_address, reconciliation_state::text,
			evidence_refs, metadata, ordered_at, created_at, updated_at, deleted_at
		FROM orders
		WHERE workspace_id = $1
		  AND source_platform = $2
		  AND external_order_id = $3
		  AND ($4 = '' OR connected_account_id = $4::uuid)
		  AND deleted_at IS NULL
		LIMIT 1;
	`
	var o *Order
	err := s.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		var scanErr error
		o, scanErr = s.scanOrder(tx.QueryRow(txCtx, q, workspaceID, platform, externalOrderID, connectedAccountID))
		if scanErr != nil {
			if errors.Is(scanErr, pgx.ErrNoRows) {
				o = nil
				return nil
			}
			return scanErr
		}
		return nil
	})
	if err != nil {
		return nil, err
	}
	return o, nil
}

func (s *PostgresStore) FindOrderByImportFingerprint(ctx context.Context, workspaceID, fingerprint string) (*Order, error) {
	const q = `
		SELECT
			order_id, workspace_id, source_class, COALESCE(source_platform, ''), external_order_id,
			connected_account_id::text, tax_amount, tax_jurisdiction, tax_note, exchange_rate_snapshot,
			recognized_at, source_updated_at, import_fingerprint, lifecycle_state,
			amount, currency, product_id::text, offer_id::text, campaign_id::text, post_id::text, live_session_id::text,
			customer_entity_id::text, items, fee_breakdown, shipping_address, reconciliation_state::text,
			evidence_refs, metadata, ordered_at, created_at, updated_at, deleted_at
		FROM orders
		WHERE workspace_id = $1 AND import_fingerprint = $2 AND deleted_at IS NULL
		LIMIT 1;
	`
	var o *Order
	err := s.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		var scanErr error
		o, scanErr = s.scanOrder(tx.QueryRow(txCtx, q, workspaceID, fingerprint))
		if scanErr != nil {
			if errors.Is(scanErr, pgx.ErrNoRows) {
				o = nil
				return nil
			}
			return scanErr
		}
		return nil
	})
	if err != nil {
		return nil, err
	}
	return o, nil
}

func (s *PostgresStore) UpdateOrderStatus(ctx context.Context, workspaceID, orderID string, state LifecycleState, refundedAmount *tenantdb.ExactDecimal) error {
	var q string
	var args []any

	if refundedAmount != nil {
		q = `
			UPDATE orders
			SET lifecycle_state = $1,
			    metadata = jsonb_set(COALESCE(metadata, '{}'::jsonb), '{refunded_amount}', to_jsonb($2::text)),
			    updated_at = NOW()
			WHERE workspace_id = $3 AND order_id = $4 AND deleted_at IS NULL;
		`
		args = []any{string(state), refundedAmount.Fixed6String(), workspaceID, orderID}
	} else {
		q = `
			UPDATE orders
			SET lifecycle_state = $1, updated_at = NOW()
			WHERE workspace_id = $2 AND order_id = $3 AND deleted_at IS NULL;
		`
		args = []any{string(state), workspaceID, orderID}
	}

	return s.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		tag, err := tx.Exec(txCtx, q, args...)
		if err != nil {
			return err
		}
		if tag.RowsAffected() == 0 {
			return ErrOrderNotFound
		}
		return nil
	})
}

func (s *PostgresStore) UpdateOrder(ctx context.Context, o *Order) error {
	feeJSON, err := json.Marshal(o.FeeBreakdown)
	if err != nil {
		feeJSON = []byte("{}")
	}
	itemsJSON, err := json.Marshal(o.Items)
	if err != nil {
		itemsJSON = []byte("[]")
	}
	metaJSON, err := json.Marshal(o.Metadata)
	if err != nil {
		metaJSON = []byte("{}")
	}

	const q = `
		UPDATE orders
		SET lifecycle_state = $1,
		    fee_breakdown = $2,
		    items = $3,
		    amount = $4,
		    metadata = jsonb_set(COALESCE($5::jsonb, '{}'::jsonb), '{refunded_amount}', to_jsonb($6::text)),
		    updated_at = NOW()
		WHERE workspace_id = $7 AND order_id = $8 AND deleted_at IS NULL;
	`
	return s.withTenantTx(ctx, o.WorkspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		tag, err := tx.Exec(txCtx, q,
			string(o.LifecycleState),
			feeJSON,
			itemsJSON,
			o.Amount.ToPgNumeric(),
			metaJSON,
			o.RefundedAmount.Fixed6String(),
			o.WorkspaceID,
			o.OrderID,
		)
		if err != nil {
			return err
		}
		if tag.RowsAffected() == 0 {
			return ErrOrderNotFound
		}
		return nil
	})
}

func (s *PostgresStore) ListOrders(ctx context.Context, workspaceID string, filter OrderFilter, limit, offset int) ([]*Order, int64, error) {
	countQ := `
		SELECT COUNT(*) FROM orders
		WHERE workspace_id = $1
		  AND ($2 = '' OR lifecycle_state = $2)
		  AND ($3 = '' OR source_platform = $3)
		  AND ($4::timestamptz IS NULL OR ordered_at >= $4)
		  AND ($5::timestamptz IS NULL OR ordered_at <= $5)
		  AND deleted_at IS NULL;
	`
	const q = `
		SELECT
			order_id, workspace_id, source_class, COALESCE(source_platform, ''), external_order_id,
			connected_account_id::text, tax_amount, tax_jurisdiction, tax_note, exchange_rate_snapshot,
			recognized_at, source_updated_at, import_fingerprint, lifecycle_state,
			amount, currency, product_id::text, offer_id::text, campaign_id::text, post_id::text, live_session_id::text,
			customer_entity_id::text, items, fee_breakdown, shipping_address, reconciliation_state::text,
			evidence_refs, metadata, ordered_at, created_at, updated_at, deleted_at
		FROM orders
		WHERE workspace_id = $1
		  AND ($2 = '' OR lifecycle_state = $2)
		  AND ($3 = '' OR source_platform = $3)
		  AND ($4::timestamptz IS NULL OR ordered_at >= $4)
		  AND ($5::timestamptz IS NULL OR ordered_at <= $5)
		  AND deleted_at IS NULL
		ORDER BY ordered_at DESC
		LIMIT $6 OFFSET $7;
	`
	var total int64
	var results []*Order
	err := s.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		if err := tx.QueryRow(txCtx, countQ, workspaceID, string(filter.State), filter.SourcePlatform, filter.DateFrom, filter.DateTo).Scan(&total); err != nil {
			return err
		}
		rows, err := tx.Query(txCtx, q, workspaceID, string(filter.State), filter.SourcePlatform, filter.DateFrom, filter.DateTo, limit, offset)
		if err != nil {
			return err
		}
		defer rows.Close()

		for rows.Next() {
			o, err := s.scanOrder(rows)
			if err != nil {
				return err
			}
			results = append(results, o)
		}
		return rows.Err()
	})
	if err != nil {
		return nil, 0, err
	}
	return results, total, nil
}

func (s *PostgresStore) CreateRefund(ctx context.Context, r *Refund) error {
	if r.RefundID == "" {
		r.RefundID = newUUID()
	}
	evJSON, err := json.Marshal(r.EvidenceRefs)
	if err != nil {
		evJSON = []byte("[]")
	}

	const q = `
		INSERT INTO refunds (
			refund_id, workspace_id, order_id, refund_type, amount, currency,
			reason, lifecycle_state, source_class, source_platform, external_refund_id,
			settlement_id, evidence_refs, created_at, updated_at
		) VALUES (
			$1, $2, $3, $4, $5, $6,
			$7, $8, $9, NULLIF($10, ''), NULLIF($11, ''),
			NULLIF($12, '')::uuid, $13, NOW(), NOW()
		);
	`
	return s.withTenantTx(ctx, r.WorkspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		_, err := tx.Exec(txCtx, q,
			r.RefundID, r.WorkspaceID, r.OrderID, r.RefundType, r.Amount.Fixed6String(), r.Currency,
			r.Reason, string(r.LifecycleState), string(r.SourceClass), r.SourcePlatform, r.ExternalRefundID,
			r.SettlementID, evJSON,
		)
		return err
	})
}

func (s *PostgresStore) scanRefund(row pgx.Row) (*Refund, error) {
	var r Refund
	var amtNum pgtype.Numeric
	var lifecycleState, sourceClass string
	var extRefID, settID, platform *string
	var evJSON []byte

	err := row.Scan(
		&r.RefundID, &r.WorkspaceID, &r.OrderID, &r.RefundType, &amtNum, &r.Currency,
		&r.Reason, &lifecycleState, &sourceClass, &platform, &extRefID,
		&settID, &evJSON, &r.CreatedAt, &r.UpdatedAt, &r.DeletedAt,
	)
	if err != nil {
		return nil, err
	}
	r.LifecycleState = RefundState(lifecycleState)
	r.SourceClass = SourceClass(sourceClass)
	if platform != nil {
		r.SourcePlatform = *platform
	}
	if extRefID != nil {
		r.ExternalRefundID = *extRefID
	}
	if settID != nil {
		r.SettlementID = *settID
	}
	if amtDec, err := tenantdb.FromPgNumeric(amtNum); err == nil {
		r.Amount = amtDec
	}
	if len(evJSON) > 0 {
		_ = json.Unmarshal(evJSON, &r.EvidenceRefs)
	}
	return &r, nil
}

func (s *PostgresStore) GetRefund(ctx context.Context, workspaceID, refundID string) (*Refund, error) {
	const q = `
		SELECT
			refund_id, workspace_id, order_id, refund_type, amount, currency,
			reason, lifecycle_state, source_class, source_platform, external_refund_id,
			settlement_id::text, evidence_refs, created_at, updated_at, deleted_at
		FROM refunds
		WHERE workspace_id = $1 AND refund_id = $2 AND deleted_at IS NULL;
	`
	var r *Refund
	err := s.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		var scanErr error
		r, scanErr = s.scanRefund(tx.QueryRow(txCtx, q, workspaceID, refundID))
		if scanErr != nil {
			if errors.Is(scanErr, pgx.ErrNoRows) {
				return ErrRefundNotFound
			}
			return scanErr
		}
		return nil
	})
	if err != nil {
		return nil, err
	}
	return r, nil
}

func (s *PostgresStore) FindRefundByExternalID(ctx context.Context, workspaceID, orderID, platform, externalRefundID string) (*Refund, error) {
	if externalRefundID == "" {
		return nil, nil
	}
	const q = `
		SELECT
			refund_id, workspace_id, order_id, refund_type, amount, currency,
			reason, lifecycle_state, source_class, source_platform, external_refund_id,
			settlement_id::text, evidence_refs, created_at, updated_at, deleted_at
		FROM refunds
		WHERE workspace_id = $1
		  AND order_id = $2
		  AND ($3 = '' OR source_platform = $3)
		  AND external_refund_id = $4
		  AND deleted_at IS NULL
		LIMIT 1;
	`
	var r *Refund
	err := s.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		var scanErr error
		r, scanErr = s.scanRefund(tx.QueryRow(txCtx, q, workspaceID, orderID, platform, externalRefundID))
		if scanErr != nil {
			if errors.Is(scanErr, pgx.ErrNoRows) {
				r = nil
				return nil
			}
			return scanErr
		}
		return nil
	})
	if err != nil {
		return nil, err
	}
	return r, nil
}

func (s *PostgresStore) ListRefundsByOrder(ctx context.Context, workspaceID, orderID string) ([]*Refund, error) {
	const q = `
		SELECT
			refund_id, workspace_id, order_id, refund_type, amount, currency,
			reason, lifecycle_state, source_class, source_platform, external_refund_id,
			settlement_id::text, evidence_refs, created_at, updated_at, deleted_at
		FROM refunds
		WHERE workspace_id = $1 AND order_id = $2 AND deleted_at IS NULL
		ORDER BY created_at ASC;
	`
	var results []*Refund
	err := s.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		rows, err := tx.Query(txCtx, q, workspaceID, orderID)
		if err != nil {
			return err
		}
		defer rows.Close()

		for rows.Next() {
			r, err := s.scanRefund(rows)
			if err != nil {
				return err
			}
			results = append(results, r)
		}
		return rows.Err()
	})
	if err != nil {
		return nil, err
	}
	return results, nil
}

func (s *PostgresStore) UpdateRefundStatus(ctx context.Context, workspaceID, refundID string, state RefundState) error {
	const q = `
		UPDATE refunds
		SET lifecycle_state = $1, updated_at = NOW()
		WHERE workspace_id = $2 AND refund_id = $3 AND deleted_at IS NULL;
	`
	return s.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		tag, err := tx.Exec(txCtx, q, string(state), workspaceID, refundID)
		if err != nil {
			return err
		}
		if tag.RowsAffected() == 0 {
			return ErrRefundNotFound
		}
		return nil
	})
}

func (s *PostgresStore) ApproveRefundAtomic(ctx context.Context, workspaceID, refundID string) (*Refund, *Order, LifecycleState, tenantdb.ExactDecimal, bool, error) {
	var r *Refund
	var o *Order
	var prevState LifecycleState
	var prevRefunded tenantdb.ExactDecimal
	var newlyApproved bool

	err := s.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		const refundQ = `
			SELECT
				refund_id, workspace_id, order_id, refund_type, amount, currency,
				reason, lifecycle_state, source_class, source_platform, external_refund_id,
				settlement_id::text, evidence_refs, created_at, updated_at, deleted_at
			FROM refunds
			WHERE workspace_id = $1 AND refund_id = $2 AND deleted_at IS NULL
			FOR UPDATE;
		`
		var scanErr error
		r, scanErr = s.scanRefund(tx.QueryRow(txCtx, refundQ, workspaceID, refundID))
		if scanErr != nil {
			if errors.Is(scanErr, pgx.ErrNoRows) {
				return ErrRefundNotFound
			}
			return scanErr
		}

		const orderQ = `
			SELECT
				order_id, workspace_id, source_class, COALESCE(source_platform, ''), external_order_id,
				connected_account_id::text, tax_amount, tax_jurisdiction, tax_note, exchange_rate_snapshot,
				recognized_at, source_updated_at, import_fingerprint, lifecycle_state,
				amount, currency, product_id::text, offer_id::text, campaign_id::text, post_id::text, live_session_id::text,
				customer_entity_id::text, items, fee_breakdown, shipping_address, reconciliation_state::text,
				evidence_refs, metadata, ordered_at, created_at, updated_at, deleted_at
			FROM orders
			WHERE workspace_id = $1 AND order_id = $2 AND deleted_at IS NULL
			FOR UPDATE;
		`
		o, scanErr = s.scanOrder(tx.QueryRow(txCtx, orderQ, workspaceID, r.OrderID))
		if scanErr != nil {
			if errors.Is(scanErr, pgx.ErrNoRows) {
				return ErrOrderNotFound
			}
			return scanErr
		}

		if r.LifecycleState == RefundApproved || r.LifecycleState == RefundCompleted {
			prevState = o.LifecycleState
			prevRefunded = o.RefundedAmount
			newlyApproved = false
			return nil
		}
		if r.LifecycleState != RefundRequested && r.LifecycleState != RefundProcessing {
			return fmt.Errorf("%w: cannot approve refund in state %s", ErrInvalidRefundTransition, r.LifecycleState)
		}
		if r.Currency != "" && o.Currency != "" && r.Currency != o.Currency {
			return fmt.Errorf("%w: refund currency %s does not match order currency %s", ErrCurrencyMismatch, r.Currency, o.Currency)
		}

		rem, err := o.RefundableRemaining()
		if err != nil {
			return err
		}
		if r.Amount.Cmp(rem) > 0 {
			return fmt.Errorf("%w: refund amount %s exceeds remaining refundable %s", ErrRefundExceedsOrderTotal, r.Amount.Fixed6String(), rem.Fixed6String())
		}

		newRefunded, err := o.RefundedAmount.Add(r.Amount)
		if err != nil {
			return err
		}

		prevState = o.LifecycleState
		prevRefunded = o.RefundedAmount

		var newOrderState LifecycleState
		if newRefunded.Cmp(o.Amount) == 0 {
			newOrderState = StateRefunded
		} else {
			newOrderState = StatePartiallyRefunded
		}

		const updOrderQ = `
			UPDATE orders
			SET lifecycle_state = $1,
			    metadata = jsonb_set(COALESCE(metadata, '{}'::jsonb), '{refunded_amount}', to_jsonb($2::text)),
			    updated_at = NOW()
			WHERE workspace_id = $3 AND order_id = $4 AND deleted_at IS NULL;
		`
		if _, err := tx.Exec(txCtx, updOrderQ, string(newOrderState), newRefunded.Fixed6String(), workspaceID, o.OrderID); err != nil {
			return err
		}

		const updRefundQ = `
			UPDATE refunds
			SET lifecycle_state = $1, updated_at = NOW()
			WHERE workspace_id = $2 AND refund_id = $3 AND deleted_at IS NULL;
		`
		if _, err := tx.Exec(txCtx, updRefundQ, string(RefundCompleted), workspaceID, refundID); err != nil {
			return err
		}

		now := time.Now().UTC()
		r.LifecycleState = RefundCompleted
		r.UpdatedAt = now
		o.LifecycleState = newOrderState
		o.RefundedAmount = newRefunded
		if o.Metadata == nil {
			o.Metadata = make(map[string]any)
		}
		o.Metadata["refunded_amount"] = newRefunded.Fixed6String()
		o.UpdatedAt = now
		newlyApproved = true
		return nil
	})
	if err != nil {
		return nil, nil, "", tenantdb.ZeroDecimal(), false, err
	}
	return r, o, prevState, prevRefunded, newlyApproved, nil
}

func (s *PostgresStore) RevertRefundApproval(ctx context.Context, workspaceID, refundID, orderID string, prevState LifecycleState, prevRefunded tenantdb.ExactDecimal) error {
	return s.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		const updOrderQ = `
			UPDATE orders
			SET lifecycle_state = $1,
			    metadata = jsonb_set(COALESCE(metadata, '{}'::jsonb), '{refunded_amount}', to_jsonb($2::text)),
			    updated_at = NOW()
			WHERE workspace_id = $3 AND order_id = $4 AND deleted_at IS NULL;
		`
		if _, err := tx.Exec(txCtx, updOrderQ, string(prevState), prevRefunded.Fixed6String(), workspaceID, orderID); err != nil {
			return err
		}
		const updRefundQ = `
			UPDATE refunds
			SET lifecycle_state = $1, updated_at = NOW()
			WHERE workspace_id = $2 AND refund_id = $3 AND deleted_at IS NULL;
		`
		_, err := tx.Exec(txCtx, updRefundQ, string(RefundRequested), workspaceID, refundID)
		return err
	})
}

func (s *PostgresStore) CreateReturn(ctx context.Context, ret *Return) error {
	if ret.ReturnID == "" {
		ret.ReturnID = newUUID()
	}
	itemsJSON, err := json.Marshal(ret.Items)
	if err != nil {
		itemsJSON = []byte("[]")
	}

	const q = `
		INSERT INTO returns (
			return_id, workspace_id, order_id, refund_id, return_type, items,
			lifecycle_state, tracking_number, evidence_photo_url, created_at, updated_at
		) VALUES (
			$1, $2, $3, NULLIF($4, '')::uuid, $5, $6,
			$7, $8, $9, NOW(), NOW()
		);
	`
	return s.withTenantTx(ctx, ret.WorkspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		_, err := tx.Exec(txCtx, q,
			ret.ReturnID, ret.WorkspaceID, ret.OrderID, ret.RefundID, ret.ReturnType, itemsJSON,
			string(ret.LifecycleState), ret.TrackingNumber, ret.EvidencePhotoURL,
		)
		return err
	})
}

func (s *PostgresStore) scanReturn(row pgx.Row) (*Return, error) {
	var ret Return
	var refID, tracking, photo *string
	var lifecycleState string
	var itemsJSON []byte

	err := row.Scan(
		&ret.ReturnID, &ret.WorkspaceID, &ret.OrderID, &refID, &ret.ReturnType, &itemsJSON,
		&lifecycleState, &tracking, &photo, &ret.CreatedAt, &ret.UpdatedAt, &ret.DeletedAt,
	)
	if err != nil {
		return nil, err
	}
	ret.LifecycleState = ReturnState(lifecycleState)
	if refID != nil {
		ret.RefundID = *refID
	}
	if tracking != nil {
		ret.TrackingNumber = *tracking
	}
	if photo != nil {
		ret.EvidencePhotoURL = *photo
	}
	if len(itemsJSON) > 0 {
		_ = json.Unmarshal(itemsJSON, &ret.Items)
	}
	return &ret, nil
}

func (s *PostgresStore) GetReturn(ctx context.Context, workspaceID, returnID string) (*Return, error) {
	const q = `
		SELECT
			return_id, workspace_id, order_id, refund_id::text, return_type, items,
			lifecycle_state, tracking_number, evidence_photo_url, created_at, updated_at, deleted_at
		FROM returns
		WHERE workspace_id = $1 AND return_id = $2 AND deleted_at IS NULL;
	`
	var ret *Return
	err := s.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		var scanErr error
		ret, scanErr = s.scanReturn(tx.QueryRow(txCtx, q, workspaceID, returnID))
		if scanErr != nil {
			if errors.Is(scanErr, pgx.ErrNoRows) {
				return ErrReturnNotFound
			}
			return scanErr
		}
		return nil
	})
	if err != nil {
		return nil, err
	}
	return ret, nil
}

func (s *PostgresStore) ListReturnsByOrder(ctx context.Context, workspaceID, orderID string) ([]*Return, error) {
	const q = `
		SELECT
			return_id, workspace_id, order_id, refund_id::text, return_type, items,
			lifecycle_state, tracking_number, evidence_photo_url, created_at, updated_at, deleted_at
		FROM returns
		WHERE workspace_id = $1 AND order_id = $2 AND deleted_at IS NULL
		ORDER BY created_at ASC;
	`
	var results []*Return
	err := s.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		rows, err := tx.Query(txCtx, q, workspaceID, orderID)
		if err != nil {
			return err
		}
		defer rows.Close()

		for rows.Next() {
			ret, err := s.scanReturn(rows)
			if err != nil {
				return err
			}
			results = append(results, ret)
		}
		return rows.Err()
	})
	if err != nil {
		return nil, err
	}
	return results, nil
}

func (s *PostgresStore) UpdateReturnStatus(ctx context.Context, workspaceID, returnID string, state ReturnState) error {
	const q = `
		UPDATE returns
		SET lifecycle_state = $1, updated_at = NOW()
		WHERE workspace_id = $2 AND return_id = $3 AND deleted_at IS NULL;
	`
	return s.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		tag, err := tx.Exec(txCtx, q, string(state), workspaceID, returnID)
		if err != nil {
			return err
		}
		if tag.RowsAffected() == 0 {
			return ErrReturnNotFound
		}
		return nil
	})
}
