package inventory

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"sort"
	"strconv"
	"strings"
	"sync"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

type SkuLocPair struct {
	SkuID      string
	LocationID string
}

type Store interface {
	CreateLocation(ctx context.Context, loc *Location) error
	GetLocation(ctx context.Context, workspaceID, locationID string) (*Location, error)
	ListLocations(ctx context.Context, workspaceID string) ([]*Location, error)
	GetDefaultLocation(ctx context.Context, workspaceID string) (*Location, error)

	GetBalance(ctx context.Context, workspaceID, skuID, locationID string) (*Balance, error)
	ListBalances(ctx context.Context, workspaceID, locationID string, limit, offset int) ([]*Balance, int64, error)
	UpsertBalance(ctx context.Context, bal *Balance) error

	AppendMovement(ctx context.Context, mov *Movement) error
	ListMovements(ctx context.Context, workspaceID, skuID, locationID string, limit, offset int) ([]*Movement, int64, error)
	FindMovementByKey(ctx context.Context, workspaceID, movementKey string) (*Movement, error)

	CreateReservation(ctx context.Context, res *Reservation) error
	GetReservation(ctx context.Context, workspaceID, resKey string) (*Reservation, error)
	ListReservationsByOrder(ctx context.Context, workspaceID, orderID string) ([]*Reservation, error)
	UpdateReservationStatus(ctx context.Context, workspaceID, resID, newStatus string) error
	ListExpiredReservations(ctx context.Context, now time.Time) ([]*Reservation, error)

	// AtomicExecute executes fn inside a transaction with rows locked in sorted order.
	AtomicExecute(ctx context.Context, workspaceID string, pairs []SkuLocPair, fn func(tx StoreTx) error) error
}

type StoreTx interface {
	GetBalanceForUpdate(ctx context.Context, workspaceID, skuID, locationID string) (*Balance, error)
	UpdateBalance(ctx context.Context, bal *Balance) error
	AppendMovement(ctx context.Context, mov *Movement) error
	FindMovementByKey(ctx context.Context, workspaceID, movementKey string) (*Movement, error)
	CheckOrRecordSyncKey(ctx context.Context, workspaceID, syncKey string, targetCount int32) (alreadyProcessed bool, prevCount int32, err error)
	CreateReservation(ctx context.Context, res *Reservation) error
	GetReservation(ctx context.Context, workspaceID, resKey string) (*Reservation, error)
	ListReservationsByOrder(ctx context.Context, workspaceID, orderID string) ([]*Reservation, error)
	UpdateReservationStatus(ctx context.Context, workspaceID, resID, newStatus string) error
}

// ----------------------------------------------------------------------------
// In-Memory Thread-Safe Implementation
// ----------------------------------------------------------------------------

type MemoryStore struct {
	mu           sync.RWMutex
	locations    map[string]*Location    // key: locationID
	balances     map[string]*Balance     // key: workspaceID:skuID:locationID
	movements    map[string]*Movement    // key: movementID
	movementKeys map[string]string       // key: workspaceID:movementKey -> movementID
	syncKeys     map[string]int32        // key: workspaceID:syncKey -> targetCount
	reservations map[string]*Reservation // key: reservationID
	resKeys      map[string]string       // key: workspaceID:resKey -> reservationID

	rowLocksMu sync.Mutex
	rowLocks   map[string]*sync.Mutex
}

func NewMemoryStore() *MemoryStore {
	return &MemoryStore{
		locations:    make(map[string]*Location),
		balances:     make(map[string]*Balance),
		movements:    make(map[string]*Movement),
		movementKeys: make(map[string]string),
		syncKeys:     make(map[string]int32),
		reservations: make(map[string]*Reservation),
		resKeys:      make(map[string]string),
		rowLocks:     make(map[string]*sync.Mutex),
	}
}

func (m *MemoryStore) getRowLock(lockKey string) *sync.Mutex {
	m.rowLocksMu.Lock()
	defer m.rowLocksMu.Unlock()
	l, exists := m.rowLocks[lockKey]
	if !exists {
		l = &sync.Mutex{}
		m.rowLocks[lockKey] = l
	}
	return l
}

func (m *MemoryStore) CreateLocation(_ context.Context, loc *Location) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	if loc.LocationID == "" {
		loc.LocationID = newUUID()
	}
	if loc.CreatedAt.IsZero() {
		loc.CreatedAt = time.Now().UTC()
	}
	cp := *loc
	m.locations[loc.LocationID] = &cp
	return nil
}

func (m *MemoryStore) GetLocation(_ context.Context, workspaceID, locationID string) (*Location, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	loc, ok := m.locations[locationID]
	if !ok || loc.WorkspaceID != workspaceID {
		return nil, ErrLocationNotFound
	}
	cp := *loc
	return &cp, nil
}

func (m *MemoryStore) ListLocations(_ context.Context, workspaceID string) ([]*Location, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var result []*Location
	for _, l := range m.locations {
		if l.WorkspaceID == workspaceID {
			cp := *l
			result = append(result, &cp)
		}
	}
	sort.Slice(result, func(i, j int) bool {
		return result[i].Name < result[j].Name
	})
	return result, nil
}

func (m *MemoryStore) GetDefaultLocation(_ context.Context, workspaceID string) (*Location, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	for _, l := range m.locations {
		if l.WorkspaceID == workspaceID && l.IsDefault {
			cp := *l
			return &cp, nil
		}
	}
	// Fallback to any active location in workspace
	for _, l := range m.locations {
		if l.WorkspaceID == workspaceID && l.Status == StatusActive {
			cp := *l
			return &cp, nil
		}
	}
	return nil, ErrLocationNotFound
}

func balanceKey(workspaceID, skuID, locationID string) string {
	return fmt.Sprintf("%s:%s:%s", workspaceID, skuID, locationID)
}

func (m *MemoryStore) GetBalance(_ context.Context, workspaceID, skuID, locationID string) (*Balance, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	b, ok := m.balances[balanceKey(workspaceID, skuID, locationID)]
	if !ok {
		return nil, ErrSkuNotInitialized
	}
	cp := *b
	return &cp, nil
}

func (m *MemoryStore) ListBalances(_ context.Context, workspaceID, locationID string, limit, offset int) ([]*Balance, int64, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var matching []*Balance
	for _, b := range m.balances {
		if b.WorkspaceID == workspaceID && (locationID == "" || b.LocationID == locationID) {
			cp := *b
			matching = append(matching, &cp)
		}
	}
	sort.Slice(matching, func(i, j int) bool {
		return matching[i].SkuID < matching[j].SkuID
	})

	total := int64(len(matching))
	if offset >= len(matching) {
		return []*Balance{}, total, nil
	}
	end := offset + limit
	if limit <= 0 || end > len(matching) {
		end = len(matching)
	}
	return matching[offset:end], total, nil
}

func (m *MemoryStore) UpsertBalance(_ context.Context, bal *Balance) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	k := balanceKey(bal.WorkspaceID, bal.SkuID, bal.LocationID)
	if bal.BalanceID == "" {
		bal.BalanceID = newUUID()
	}
	bal.UpdatedAt = time.Now().UTC()
	cp := *bal
	m.balances[k] = &cp
	return nil
}

func (m *MemoryStore) AppendMovement(_ context.Context, mov *Movement) error {
	if mov.Quantity == 0 {
		return ErrInvalidQuantity
	}
	m.mu.Lock()
	defer m.mu.Unlock()

	dedupKey := fmt.Sprintf("%s:%s", mov.WorkspaceID, mov.MovementKey)
	if existingID, ok := m.movementKeys[dedupKey]; ok {
		// Idempotency: exact same movement key and payload returns nil (no-op)
		existing := m.movements[existingID]
		if existing.Quantity == mov.Quantity &&
			existing.MovementType == mov.MovementType &&
			existing.SkuID == mov.SkuID &&
			existing.LocationID == mov.LocationID {
			*mov = *existing
			return nil
		}
		return ErrMovementDuplicate
	}

	if mov.MovementID == "" {
		mov.MovementID = newUUID()
	}
	if mov.CreatedAt.IsZero() {
		mov.CreatedAt = time.Now().UTC()
	}
	cp := *mov
	m.movements[mov.MovementID] = &cp
	m.movementKeys[dedupKey] = mov.MovementID
	return nil
}

func (m *MemoryStore) ListMovements(_ context.Context, workspaceID, skuID, locationID string, limit, offset int) ([]*Movement, int64, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var matching []*Movement
	for _, mv := range m.movements {
		if mv.WorkspaceID == workspaceID {
			if (skuID == "" || mv.SkuID == skuID) && (locationID == "" || mv.LocationID == locationID) {
				cp := *mv
				matching = append(matching, &cp)
			}
		}
	}
	sort.Slice(matching, func(i, j int) bool {
		return matching[i].CreatedAt.After(matching[j].CreatedAt)
	})

	total := int64(len(matching))
	if offset >= len(matching) {
		return []*Movement{}, total, nil
	}
	end := offset + limit
	if limit <= 0 || end > len(matching) {
		end = len(matching)
	}
	return matching[offset:end], total, nil
}

func (m *MemoryStore) FindMovementByKey(_ context.Context, workspaceID, movementKey string) (*Movement, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	dedupKey := fmt.Sprintf("%s:%s", workspaceID, movementKey)
	id, ok := m.movementKeys[dedupKey]
	if !ok {
		return nil, nil
	}
	cp := *m.movements[id]
	return &cp, nil
}

func (m *MemoryStore) CreateReservation(_ context.Context, res *Reservation) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	dedupKey := fmt.Sprintf("%s:%s", res.WorkspaceID, res.ReservationKey)
	if existingID, ok := m.resKeys[dedupKey]; ok {
		existing := m.reservations[existingID]
		if existing.Quantity == res.Quantity && existing.Status == res.Status {
			return nil
		}
		if existing.Status == ResExpired || existing.Status == ResReleased {
			existing.Quantity = res.Quantity
			existing.Status = res.Status
			existing.ExpiresAt = res.ExpiresAt
			existing.UpdatedAt = time.Now().UTC()
			*res = *existing
			return nil
		}
		return ErrReservationConflict
	}

	if res.ReservationID == "" {
		res.ReservationID = newUUID()
	}
	now := time.Now().UTC()
	if res.CreatedAt.IsZero() {
		res.CreatedAt = now
	}
	res.UpdatedAt = now
	cp := *res
	m.reservations[res.ReservationID] = &cp
	m.resKeys[dedupKey] = res.ReservationID
	return nil
}

func (m *MemoryStore) GetReservation(_ context.Context, workspaceID, resKey string) (*Reservation, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	dedupKey := fmt.Sprintf("%s:%s", workspaceID, resKey)
	id, ok := m.resKeys[dedupKey]
	if !ok {
		return nil, ErrReservationNotFound
	}
	cp := *m.reservations[id]
	return &cp, nil
}

func (m *MemoryStore) ListReservationsByOrder(_ context.Context, workspaceID, orderID string) ([]*Reservation, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var result []*Reservation
	for _, r := range m.reservations {
		if r.WorkspaceID == workspaceID && r.OrderID == orderID {
			cp := *r
			result = append(result, &cp)
		}
	}
	return result, nil
}

func (m *MemoryStore) UpdateReservationStatus(_ context.Context, workspaceID, resID, newStatus string) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	res, ok := m.reservations[resID]
	if !ok || res.WorkspaceID != workspaceID {
		return ErrReservationNotFound
	}
	res.Status = newStatus
	res.UpdatedAt = time.Now().UTC()
	return nil
}

func (m *MemoryStore) ListExpiredReservations(_ context.Context, now time.Time) ([]*Reservation, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var expired []*Reservation
	for _, r := range m.reservations {
		if r.Status == ResHeld && r.ExpiresAt != nil && r.ExpiresAt.Before(now) {
			cp := *r
			expired = append(expired, &cp)
		}
	}
	return expired, nil
}

type memoryTx struct {
	store *MemoryStore
}

func (tx *memoryTx) GetBalanceForUpdate(ctx context.Context, workspaceID, skuID, locationID string) (*Balance, error) {
	return tx.store.GetBalance(ctx, workspaceID, skuID, locationID)
}

func (tx *memoryTx) UpdateBalance(ctx context.Context, bal *Balance) error {
	return tx.store.UpsertBalance(ctx, bal)
}

func (tx *memoryTx) AppendMovement(ctx context.Context, mov *Movement) error {
	return tx.store.AppendMovement(ctx, mov)
}

func (tx *memoryTx) FindMovementByKey(ctx context.Context, workspaceID, movementKey string) (*Movement, error) {
	return tx.store.FindMovementByKey(ctx, workspaceID, movementKey)
}

func (tx *memoryTx) CheckOrRecordSyncKey(_ context.Context, workspaceID, syncKey string, targetCount int32) (bool, int32, error) {
	tx.store.mu.Lock()
	defer tx.store.mu.Unlock()
	k := fmt.Sprintf("%s:%s", workspaceID, syncKey)
	if prev, ok := tx.store.syncKeys[k]; ok {
		return true, prev, nil
	}
	tx.store.syncKeys[k] = targetCount
	return false, targetCount, nil
}

func (tx *memoryTx) CreateReservation(ctx context.Context, res *Reservation) error {
	return tx.store.CreateReservation(ctx, res)
}

func (tx *memoryTx) GetReservation(ctx context.Context, workspaceID, resKey string) (*Reservation, error) {
	return tx.store.GetReservation(ctx, workspaceID, resKey)
}

func (tx *memoryTx) ListReservationsByOrder(ctx context.Context, workspaceID, orderID string) ([]*Reservation, error) {
	return tx.store.ListReservationsByOrder(ctx, workspaceID, orderID)
}

func (tx *memoryTx) UpdateReservationStatus(ctx context.Context, workspaceID, resID, newStatus string) error {
	return tx.store.UpdateReservationStatus(ctx, workspaceID, resID, newStatus)
}

func (m *MemoryStore) AtomicExecute(ctx context.Context, workspaceID string, pairs []SkuLocPair, fn func(tx StoreTx) error) error {
	// Deduplicate and sort pairs by (sku_id, location_id)
	keysMap := make(map[string]SkuLocPair)
	for _, p := range pairs {
		k := fmt.Sprintf("%s:%s", p.SkuID, p.LocationID)
		keysMap[k] = p
	}
	sortedKeys := make([]string, 0, len(keysMap))
	for k := range keysMap {
		sortedKeys = append(sortedKeys, k)
	}
	sort.Strings(sortedKeys)

	// Acquire row mutexes in deterministic sorted order
	var acquired []*sync.Mutex
	for _, k := range sortedKeys {
		lock := m.getRowLock(fmt.Sprintf("%s:%s", workspaceID, k))
		lock.Lock()
		acquired = append(acquired, lock)
	}
	defer func() {
		for i := len(acquired) - 1; i >= 0; i-- {
			acquired[i].Unlock()
		}
	}()

	tx := &memoryTx{store: m}
	return fn(tx)
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
		return fmt.Errorf("inventory: begin tenant transaction: %w", err)
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
		return fmt.Errorf("inventory: set local tenant context: %w", err)
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
		return fmt.Errorf("inventory: commit tenant transaction: %w", err)
	}
	committed = true
	return nil
}

func (s *PostgresStore) CreateLocation(ctx context.Context, loc *Location) error {
	if loc.LocationID == "" {
		loc.LocationID = newUUID()
	}
	addrJSON, err := json.Marshal(loc.Address)
	if err != nil {
		addrJSON = []byte("{}")
	}

	const q = `
		INSERT INTO inventory_locations (
			location_id, workspace_id, name, location_type, address, is_default, status, created_at
		) VALUES ($1, $2, $3, $4, $5, $6, $7, NOW())
		ON CONFLICT (workspace_id, location_id) DO UPDATE SET
			name = EXCLUDED.name,
			location_type = EXCLUDED.location_type,
			address = EXCLUDED.address,
			is_default = EXCLUDED.is_default,
			status = EXCLUDED.status;
	`
	return s.withTenantTx(ctx, loc.WorkspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		_, err := tx.Exec(txCtx, q, loc.LocationID, loc.WorkspaceID, loc.Name, loc.LocationType, addrJSON, loc.IsDefault, loc.Status)
		return err
	})
}

func (s *PostgresStore) GetLocation(ctx context.Context, workspaceID, locationID string) (*Location, error) {
	var loc Location
	var addrBytes []byte

	const q = `
		SELECT location_id, workspace_id, name, location_type, address, is_default, status, created_at
		FROM inventory_locations
		WHERE workspace_id = $1 AND location_id = $2;
	`
	err := s.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		row := tx.QueryRow(txCtx, q, workspaceID, locationID)
		err := row.Scan(&loc.LocationID, &loc.WorkspaceID, &loc.Name, &loc.LocationType, &addrBytes, &loc.IsDefault, &loc.Status, &loc.CreatedAt)
		if err != nil {
			if errors.Is(err, pgx.ErrNoRows) {
				return ErrLocationNotFound
			}
			return err
		}
		return nil
	})
	if err != nil {
		return nil, err
	}
	if len(addrBytes) > 0 {
		_ = json.Unmarshal(addrBytes, &loc.Address)
	}
	return &loc, nil
}

func (s *PostgresStore) ListLocations(ctx context.Context, workspaceID string) ([]*Location, error) {
	const q = `
		SELECT location_id, workspace_id, name, location_type, address, is_default, status, created_at
		FROM inventory_locations
		WHERE workspace_id = $1
		ORDER BY name ASC;
	`
	var results []*Location
	err := s.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		rows, err := tx.Query(txCtx, q, workspaceID)
		if err != nil {
			return err
		}
		defer rows.Close()

		for rows.Next() {
			var loc Location
			var addrBytes []byte
			if err := rows.Scan(&loc.LocationID, &loc.WorkspaceID, &loc.Name, &loc.LocationType, &addrBytes, &loc.IsDefault, &loc.Status, &loc.CreatedAt); err != nil {
				return err
			}
			if len(addrBytes) > 0 {
				_ = json.Unmarshal(addrBytes, &loc.Address)
			}
			results = append(results, &loc)
		}
		return rows.Err()
	})
	if err != nil {
		return nil, err
	}
	return results, nil
}

func (s *PostgresStore) GetDefaultLocation(ctx context.Context, workspaceID string) (*Location, error) {
	var loc Location
	var addrBytes []byte

	const q = `
		SELECT location_id, workspace_id, name, location_type, address, is_default, status, created_at
		FROM inventory_locations
		WHERE workspace_id = $1 AND is_default = true
		LIMIT 1;
	`
	const fallbackQ = `
		SELECT location_id, workspace_id, name, location_type, address, is_default, status, created_at
		FROM inventory_locations
		WHERE workspace_id = $1 AND status = 'active'
		LIMIT 1;
	`
	err := s.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		err := tx.QueryRow(txCtx, q, workspaceID).Scan(&loc.LocationID, &loc.WorkspaceID, &loc.Name, &loc.LocationType, &addrBytes, &loc.IsDefault, &loc.Status, &loc.CreatedAt)
		if errors.Is(err, pgx.ErrNoRows) {
			err = tx.QueryRow(txCtx, fallbackQ, workspaceID).Scan(
				&loc.LocationID, &loc.WorkspaceID, &loc.Name, &loc.LocationType, &addrBytes, &loc.IsDefault, &loc.Status, &loc.CreatedAt)
		}
		if err != nil {
			if errors.Is(err, pgx.ErrNoRows) {
				return ErrLocationNotFound
			}
			return err
		}
		return nil
	})
	if err != nil {
		return nil, err
	}
	if len(addrBytes) > 0 {
		_ = json.Unmarshal(addrBytes, &loc.Address)
	}
	return &loc, nil
}

func (s *PostgresStore) GetBalance(ctx context.Context, workspaceID, skuID, locationID string) (*Balance, error) {
	var b Balance
	const q = `
		SELECT balance_id, workspace_id, sku_id, location_id, on_hand, reserved, opening_at, updated_at
		FROM inventory_balances
		WHERE workspace_id = $1 AND sku_id = $2 AND location_id = $3;
	`
	err := s.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		err := tx.QueryRow(txCtx, q, workspaceID, skuID, locationID).Scan(
			&b.BalanceID, &b.WorkspaceID, &b.SkuID, &b.LocationID, &b.OnHand, &b.Reserved, &b.OpeningAt, &b.UpdatedAt)
		if err != nil {
			if errors.Is(err, pgx.ErrNoRows) {
				return ErrSkuNotInitialized
			}
			return err
		}
		return nil
	})
	if err != nil {
		return nil, err
	}
	return &b, nil
}

func (s *PostgresStore) ListBalances(ctx context.Context, workspaceID, locationID string, limit, offset int) ([]*Balance, int64, error) {
	var total int64
	var results []*Balance
	countQ := `
		SELECT COUNT(*) FROM inventory_balances
		WHERE workspace_id = $1 AND ($2 = '' OR location_id = $2::uuid);
	`
	const q = `
		SELECT balance_id, workspace_id, sku_id, location_id, on_hand, reserved, opening_at, updated_at
		FROM inventory_balances
		WHERE workspace_id = $1 AND ($2 = '' OR location_id = $2::uuid)
		ORDER BY sku_id ASC
		LIMIT $3 OFFSET $4;
	`
	err := s.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		if err := tx.QueryRow(txCtx, countQ, workspaceID, locationID).Scan(&total); err != nil {
			return err
		}
		rows, err := tx.Query(txCtx, q, workspaceID, locationID, limit, offset)
		if err != nil {
			return err
		}
		defer rows.Close()

		for rows.Next() {
			var b Balance
			if err := rows.Scan(&b.BalanceID, &b.WorkspaceID, &b.SkuID, &b.LocationID, &b.OnHand, &b.Reserved, &b.OpeningAt, &b.UpdatedAt); err != nil {
				return err
			}
			results = append(results, &b)
		}
		return rows.Err()
	})
	if err != nil {
		return nil, 0, err
	}
	return results, total, nil
}

func (s *PostgresStore) UpsertBalance(ctx context.Context, bal *Balance) error {
	return s.withTenantTx(ctx, bal.WorkspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		ptx := &postgresTx{tx: tx, workspaceID: bal.WorkspaceID}
		return ptx.UpdateBalance(txCtx, bal)
	})
}

func (s *PostgresStore) AppendMovement(ctx context.Context, mov *Movement) error {
	return s.withTenantTx(ctx, mov.WorkspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		ptx := &postgresTx{tx: tx, workspaceID: mov.WorkspaceID}
		return ptx.AppendMovement(txCtx, mov)
	})
}

func (s *PostgresStore) ListMovements(ctx context.Context, workspaceID, skuID, locationID string, limit, offset int) ([]*Movement, int64, error) {
	var total int64
	var results []*Movement
	countQ := `
		SELECT COUNT(*) FROM stock_movements
		WHERE workspace_id = $1
		  AND ($2 = '' OR sku_id = $2::uuid)
		  AND ($3 = '' OR location_id = $3::uuid);
	`
	const q = `
		SELECT movement_id, workspace_id, sku_id, location_id, movement_type, movement_key,
		       quantity, reference_type, COALESCE(reference_id::text, ''), source_created_at, reason, metadata, created_at
		FROM stock_movements
		WHERE workspace_id = $1
		  AND ($2 = '' OR sku_id = $2::uuid)
		  AND ($3 = '' OR location_id = $3::uuid)
		ORDER BY created_at DESC
		LIMIT $4 OFFSET $5;
	`
	err := s.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		if err := tx.QueryRow(txCtx, countQ, workspaceID, skuID, locationID).Scan(&total); err != nil {
			return err
		}
		rows, err := tx.Query(txCtx, q, workspaceID, skuID, locationID, limit, offset)
		if err != nil {
			return err
		}
		defer rows.Close()

		for rows.Next() {
			var m Movement
			var metaBytes []byte
			if err := rows.Scan(&m.MovementID, &m.WorkspaceID, &m.SkuID, &m.LocationID, &m.MovementType, &m.MovementKey,
				&m.Quantity, &m.ReferenceType, &m.ReferenceID, &m.SourceCreatedAt, &m.Reason, &metaBytes, &m.CreatedAt); err != nil {
				return err
			}
			if len(metaBytes) > 0 {
				_ = json.Unmarshal(metaBytes, &m.Metadata)
			}
			results = append(results, &m)
		}
		return rows.Err()
	})
	if err != nil {
		return nil, 0, err
	}
	return results, total, nil
}

func (s *PostgresStore) FindMovementByKey(ctx context.Context, workspaceID, movementKey string) (*Movement, error) {
	var m Movement
	var metaBytes []byte
	var found bool

	const q = `
		SELECT movement_id, workspace_id, sku_id, location_id, movement_type, movement_key,
		       quantity, reference_type, COALESCE(reference_id::text, ''), source_created_at, reason, metadata, created_at
		FROM stock_movements
		WHERE workspace_id = $1 AND movement_key = $2;
	`
	err := s.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		err := tx.QueryRow(txCtx, q, workspaceID, movementKey).Scan(
			&m.MovementID, &m.WorkspaceID, &m.SkuID, &m.LocationID, &m.MovementType, &m.MovementKey,
			&m.Quantity, &m.ReferenceType, &m.ReferenceID, &m.SourceCreatedAt, &m.Reason, &metaBytes, &m.CreatedAt)
		if err != nil {
			if errors.Is(err, pgx.ErrNoRows) {
				return nil
			}
			return err
		}
		found = true
		return nil
	})
	if err != nil || !found {
		return nil, err
	}
	if len(metaBytes) > 0 {
		_ = json.Unmarshal(metaBytes, &m.Metadata)
	}
	return &m, nil
}

func (s *PostgresStore) CreateReservation(ctx context.Context, res *Reservation) error {
	return s.withTenantTx(ctx, res.WorkspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		ptx := &postgresTx{tx: tx, workspaceID: res.WorkspaceID}
		return ptx.CreateReservation(txCtx, res)
	})
}

func (s *PostgresStore) GetReservation(ctx context.Context, workspaceID, resKey string) (*Reservation, error) {
	var r Reservation
	const q = `
		SELECT reservation_id, workspace_id, order_id, sku_id, location_id, reservation_key, quantity, status, expires_at, created_at, updated_at
		FROM stock_reservations
		WHERE workspace_id = $1 AND reservation_key = $2;
	`
	err := s.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		err := tx.QueryRow(txCtx, q, workspaceID, resKey).Scan(
			&r.ReservationID, &r.WorkspaceID, &r.OrderID, &r.SkuID, &r.LocationID, &r.ReservationKey,
			&r.Quantity, &r.Status, &r.ExpiresAt, &r.CreatedAt, &r.UpdatedAt)
		if err != nil {
			if errors.Is(err, pgx.ErrNoRows) {
				return ErrReservationNotFound
			}
			return err
		}
		return nil
	})
	if err != nil {
		return nil, err
	}
	return &r, nil
}

func (s *PostgresStore) ListReservationsByOrder(ctx context.Context, workspaceID, orderID string) ([]*Reservation, error) {
	const q = `
		SELECT reservation_id, workspace_id, order_id, sku_id, location_id, reservation_key, quantity, status, expires_at, created_at, updated_at
		FROM stock_reservations
		WHERE workspace_id = $1 AND order_id = $2;
	`
	var results []*Reservation
	err := s.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		rows, err := tx.Query(txCtx, q, workspaceID, orderID)
		if err != nil {
			return err
		}
		defer rows.Close()

		for rows.Next() {
			var r Reservation
			if err := rows.Scan(&r.ReservationID, &r.WorkspaceID, &r.OrderID, &r.SkuID, &r.LocationID, &r.ReservationKey,
				&r.Quantity, &r.Status, &r.ExpiresAt, &r.CreatedAt, &r.UpdatedAt); err != nil {
				return err
			}
			results = append(results, &r)
		}
		return rows.Err()
	})
	if err != nil {
		return nil, err
	}
	return results, nil
}

func (s *PostgresStore) UpdateReservationStatus(ctx context.Context, workspaceID, resID, newStatus string) error {
	const q = `
		UPDATE stock_reservations
		SET status = $1, updated_at = NOW()
		WHERE workspace_id = $2 AND reservation_id = $3;
	`
	return s.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		tag, err := tx.Exec(txCtx, q, newStatus, workspaceID, resID)
		if err != nil {
			return err
		}
		if tag.RowsAffected() == 0 {
			return ErrReservationNotFound
		}
		return nil
	})
}

func (s *PostgresStore) ListExpiredReservations(ctx context.Context, now time.Time) ([]*Reservation, error) {
	var results []*Reservation
	const q = `
		SELECT reservation_id, workspace_id, order_id, sku_id, location_id, reservation_key, quantity, status, expires_at, created_at, updated_at
		FROM stock_reservations
		WHERE status = 'held' AND expires_at IS NOT NULL AND expires_at < $1;
	`
	scanRows := func(txCtx context.Context, tx pgx.Tx) error {
		rows, err := tx.Query(txCtx, q, now)
		if err != nil {
			return err
		}
		defer rows.Close()

		for rows.Next() {
			var r Reservation
			if err := rows.Scan(&r.ReservationID, &r.WorkspaceID, &r.OrderID, &r.SkuID, &r.LocationID, &r.ReservationKey,
				&r.Quantity, &r.Status, &r.ExpiresAt, &r.CreatedAt, &r.UpdatedAt); err != nil {
				return err
			}
			results = append(results, &r)
		}
		return rows.Err()
	}

	if sc, ok := tenantdb.ScopeFromContext(ctx); ok && sc.WorkspaceID != "" {
		if err := s.withTenantTx(ctx, sc.WorkspaceID, scanRows); err != nil {
			return nil, err
		}
		return results, nil
	}

	b := s.txBeginner()
	if b == nil {
		return nil, tenantdb.ErrNilBeginner
	}
	tx, err := b.Begin(ctx)
	if err != nil {
		return nil, err
	}
	defer func() { _ = tx.Rollback(context.Background()) }()
	if err := scanRows(ctx, tx); err != nil {
		return nil, err
	}
	if err := tx.Commit(ctx); err != nil {
		return nil, err
	}
	return results, nil
}

type postgresTx struct {
	tx          pgx.Tx
	workspaceID string
}

func (ptx *postgresTx) GetBalanceForUpdate(ctx context.Context, workspaceID, skuID, locationID string) (*Balance, error) {
	var b Balance
	const q = `
		SELECT balance_id, workspace_id, sku_id, location_id, on_hand, reserved, opening_at, updated_at
		FROM inventory_balances
		WHERE workspace_id = $1 AND sku_id = $2 AND location_id = $3
		FOR UPDATE;
	`
	err := ptx.tx.QueryRow(ctx, q, workspaceID, skuID, locationID).Scan(
		&b.BalanceID, &b.WorkspaceID, &b.SkuID, &b.LocationID, &b.OnHand, &b.Reserved, &b.OpeningAt, &b.UpdatedAt)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrSkuNotInitialized
		}
		return nil, err
	}
	return &b, nil
}

func (ptx *postgresTx) UpdateBalance(ctx context.Context, bal *Balance) error {
	if bal.BalanceID == "" {
		bal.BalanceID = newUUID()
	}
	const q = `
		INSERT INTO inventory_balances (
			balance_id, workspace_id, sku_id, location_id, on_hand, reserved, opening_at, updated_at
		) VALUES ($1, $2, $3, $4, $5, $6, $7, NOW())
		ON CONFLICT (workspace_id, sku_id, location_id) DO UPDATE SET
			on_hand = EXCLUDED.on_hand,
			reserved = EXCLUDED.reserved,
			opening_at = COALESCE(EXCLUDED.opening_at, inventory_balances.opening_at),
			updated_at = NOW()
		RETURNING balance_id;
	`
	if err := ptx.tx.QueryRow(ctx, q, bal.BalanceID, bal.WorkspaceID, bal.SkuID, bal.LocationID, bal.OnHand, bal.Reserved, bal.OpeningAt).Scan(&bal.BalanceID); err != nil {
		return err
	}
	const syncSkuQ = `
		UPDATE product_skus
		SET stock_quantity = COALESCE((SELECT SUM(on_hand) FROM inventory_balances WHERE workspace_id = $1 AND sku_id = $2), 0),
		    stock_reserved = COALESCE((SELECT SUM(reserved) FROM inventory_balances WHERE workspace_id = $1 AND sku_id = $2), 0),
		    updated_at = NOW()
		WHERE workspace_id = $1 AND sku_id = $2;
	`
	_, err := ptx.tx.Exec(ctx, syncSkuQ, bal.WorkspaceID, bal.SkuID)
	return err
}

func (ptx *postgresTx) AppendMovement(ctx context.Context, mov *Movement) error {
	if mov.Quantity == 0 {
		return ErrInvalidQuantity
	}
	if mov.MovementID == "" {
		mov.MovementID = newUUID()
	}
	metaJSON, err := json.Marshal(mov.Metadata)
	if err != nil {
		metaJSON = []byte("{}")
	}

	const q = `
		INSERT INTO stock_movements (
			movement_id, workspace_id, sku_id, location_id, movement_type, movement_key,
			quantity, reference_type, reference_id, source_created_at, reason, metadata, created_at
		) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, NULLIF($9, '')::uuid, $10, $11, $12, NOW())
		ON CONFLICT (workspace_id, movement_key) DO NOTHING;
	`
	tag, err := ptx.tx.Exec(ctx, q, mov.MovementID, mov.WorkspaceID, mov.SkuID, mov.LocationID, mov.MovementType, mov.MovementKey,
		mov.Quantity, mov.ReferenceType, mov.ReferenceID, mov.SourceCreatedAt, mov.Reason, metaJSON)
	if err != nil {
		return err
	}
	if tag.RowsAffected() == 0 {
		existing, err := ptx.FindMovementByKey(ctx, mov.WorkspaceID, mov.MovementKey)
		if err != nil {
			return err
		}
		if existing == nil {
			return ErrMovementDuplicate
		}
		if existing.Quantity != mov.Quantity ||
			existing.MovementType != mov.MovementType ||
			existing.SkuID != mov.SkuID ||
			existing.LocationID != mov.LocationID {
			return ErrMovementDuplicate
		}
		*mov = *existing
	}
	return nil
}

func (ptx *postgresTx) FindMovementByKey(ctx context.Context, workspaceID, movementKey string) (*Movement, error) {
	var m Movement
	var metaBytes []byte
	const q = `
		SELECT movement_id, workspace_id, sku_id, location_id, movement_type, movement_key,
		       quantity, reference_type, COALESCE(reference_id::text, ''), source_created_at, reason, metadata, created_at
		FROM stock_movements
		WHERE workspace_id = $1 AND movement_key = $2;
	`
	err := ptx.tx.QueryRow(ctx, q, workspaceID, movementKey).Scan(
		&m.MovementID, &m.WorkspaceID, &m.SkuID, &m.LocationID, &m.MovementType, &m.MovementKey,
		&m.Quantity, &m.ReferenceType, &m.ReferenceID, &m.SourceCreatedAt, &m.Reason, &metaBytes, &m.CreatedAt)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, nil
		}
		return nil, err
	}
	if len(metaBytes) > 0 {
		_ = json.Unmarshal(metaBytes, &m.Metadata)
	}
	return &m, nil
}

func (ptx *postgresTx) CheckOrRecordSyncKey(ctx context.Context, workspaceID, syncKey string, targetCount int32) (bool, int32, error) {
	const selQ = `
		SELECT request_hash
		FROM api_idempotency_records
		WHERE workspace_id = $1::uuid AND actor_id = $1::uuid AND rpc = 'inventory.platform_sync' AND idempotency_key = $2
		FOR UPDATE;
	`
	var existingHash string
	err := ptx.tx.QueryRow(ctx, selQ, workspaceID, syncKey).Scan(&existingHash)
	if err == nil {
		parsed, pErr := strconv.ParseInt(existingHash, 10, 32)
		if pErr != nil {
			return true, 0, ErrMovementDuplicate
		}
		return true, int32(parsed), nil
	}
	if !errors.Is(err, pgx.ErrNoRows) {
		return false, 0, err
	}
	const insQ = `
		INSERT INTO api_idempotency_records (
			workspace_id, actor_id, rpc, idempotency_key,
			request_hash, status, response_payload, created_at, expires_at
		) VALUES (
			$1::uuid, $1::uuid, 'inventory.platform_sync', $2,
			$3, 'completed', '{}'::jsonb, NOW(), NOW() + INTERVAL '365 days'
		);
	`
	if _, err := ptx.tx.Exec(ctx, insQ, workspaceID, syncKey, strconv.FormatInt(int64(targetCount), 10)); err != nil {
		return false, 0, err
	}
	return false, targetCount, nil
}

func (ptx *postgresTx) CreateReservation(ctx context.Context, res *Reservation) error {
	if res.ReservationID == "" {
		res.ReservationID = newUUID()
	}
	const q = `
		INSERT INTO stock_reservations (
			reservation_id, workspace_id, order_id, sku_id, location_id, reservation_key, quantity, status, expires_at, created_at, updated_at
		) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, NOW(), NOW())
		ON CONFLICT (workspace_id, reservation_key) DO UPDATE SET
			quantity = EXCLUDED.quantity,
			status = EXCLUDED.status,
			expires_at = EXCLUDED.expires_at,
			updated_at = NOW()
		WHERE stock_reservations.status IN ('expired', 'released');
	`
	tag, err := ptx.tx.Exec(ctx, q, res.ReservationID, res.WorkspaceID, res.OrderID, res.SkuID, res.LocationID,
		res.ReservationKey, res.Quantity, res.Status, res.ExpiresAt)
	if err != nil {
		return err
	}
	if tag.RowsAffected() == 0 {
		return ErrReservationConflict
	}
	return nil
}

func (ptx *postgresTx) GetReservation(ctx context.Context, workspaceID, resKey string) (*Reservation, error) {
	var r Reservation
	const q = `
		SELECT reservation_id, workspace_id, order_id, sku_id, location_id, reservation_key, quantity, status, expires_at, created_at, updated_at
		FROM stock_reservations
		WHERE workspace_id = $1 AND reservation_key = $2;
	`
	err := ptx.tx.QueryRow(ctx, q, workspaceID, resKey).Scan(
		&r.ReservationID, &r.WorkspaceID, &r.OrderID, &r.SkuID, &r.LocationID, &r.ReservationKey,
		&r.Quantity, &r.Status, &r.ExpiresAt, &r.CreatedAt, &r.UpdatedAt)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrReservationNotFound
		}
		return nil, err
	}
	return &r, nil
}

func (ptx *postgresTx) ListReservationsByOrder(ctx context.Context, workspaceID, orderID string) ([]*Reservation, error) {
	var results []*Reservation
	const q = `
		SELECT reservation_id, workspace_id, order_id, sku_id, location_id, reservation_key, quantity, status, expires_at, created_at, updated_at
		FROM stock_reservations
		WHERE workspace_id = $1 AND order_id = $2
		FOR UPDATE;
	`
	rows, err := ptx.tx.Query(ctx, q, workspaceID, orderID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {
		var r Reservation
		if err := rows.Scan(&r.ReservationID, &r.WorkspaceID, &r.OrderID, &r.SkuID, &r.LocationID, &r.ReservationKey,
			&r.Quantity, &r.Status, &r.ExpiresAt, &r.CreatedAt, &r.UpdatedAt); err != nil {
			return nil, err
		}
		results = append(results, &r)
	}
	return results, rows.Err()
}

func (ptx *postgresTx) UpdateReservationStatus(ctx context.Context, workspaceID, resID, newStatus string) error {
	const q = `
		UPDATE stock_reservations
		SET status = $1, updated_at = NOW()
		WHERE workspace_id = $2 AND reservation_id = $3;
	`
	tag, err := ptx.tx.Exec(ctx, q, newStatus, workspaceID, resID)
	if err != nil {
		return err
	}
	if tag.RowsAffected() == 0 {
		return ErrReservationNotFound
	}
	return nil
}

func (s *PostgresStore) AtomicExecute(ctx context.Context, workspaceID string, pairs []SkuLocPair, fn func(tx StoreTx) error) error {
	// Deduplicate and sort pairs by (sku_id, location_id)
	keysMap := make(map[string]SkuLocPair)
	for _, p := range pairs {
		k := fmt.Sprintf("%s:%s", p.SkuID, p.LocationID)
		keysMap[k] = p
	}
	sortedPairs := make([]SkuLocPair, 0, len(keysMap))
	for _, p := range keysMap {
		sortedPairs = append(sortedPairs, p)
	}
	sort.Slice(sortedPairs, func(i, j int) bool {
		if sortedPairs[i].SkuID != sortedPairs[j].SkuID {
			return sortedPairs[i].SkuID < sortedPairs[j].SkuID
		}
		return sortedPairs[i].LocationID < sortedPairs[j].LocationID
	})

	return s.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		// Lock affected rows in deterministic sorted order
		for _, p := range sortedPairs {
			const lockQ = `
				SELECT 1 FROM inventory_balances
				WHERE workspace_id = $1 AND sku_id = $2 AND location_id = $3
				FOR UPDATE;
			`
			var dummy int
			_ = tx.QueryRow(txCtx, lockQ, workspaceID, p.SkuID, p.LocationID).Scan(&dummy)
		}

		ptx := &postgresTx{tx: tx, workspaceID: workspaceID}
		return fn(ptx)
	})
}
