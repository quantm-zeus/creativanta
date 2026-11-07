package outbox

import (
	"bufio"
	"context"
	"crypto/rand"
	"crypto/sha256"
	"crypto/tls"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net"
	"net/url"
	"sort"
	"strconv"
	"strings"
	"sync"
	"sync/atomic"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

const brokerEntriesMetaKey = "_broker_entries"

const fallbackSystemActorUUID = "ffffffff-ffff-4fff-8fff-ffffffffffff"

// ErrInvalidEventPermissionPolicy is returned when an outbox event carries an unknown or
// unmapped RBAC permission key. Unlike ErrLiveActorAuthorizationRevoked, policy configuration
// errors must never cause ConsumerWorker to ACK or silently drop a message.
var ErrInvalidEventPermissionPolicy = errors.New("outbox: invalid or unknown event permission policy")

// ResolveCanonicalEventPermission normalizes event-specific permission tokens to canonical
// workspace RBAC permission keys (docs/04_contracts/rbac_permission_matrix.md) and enforces
// default required permissions for catalog and inventory domain events.
func ResolveCanonicalEventPermission(eventType, requiredPerm string) string {
	perm := strings.TrimSpace(requiredPerm)
	switch perm {
	case "inventory:adjust":
		return "product:manage"
	}
	if perm != "" {
		return perm
	}
	switch strings.TrimSpace(eventType) {
	case "inventory.stock_moved",
		"product.created",
		"product.updated",
		"product.catalog_status_changed":
		return "product:manage"
	default:
		return ""
	}
}

type envelopeAuthMeta struct {
	ActorID      string `json:"actor_id"`
	ActorType    string `json:"actor_type"`
	RequiredPerm string `json:"required_perm"`
	ApprovalID   string `json:"approval_id"`
}

func populateEnvelopeAuthFields(msg *StreamMessage, metadata, payload json.RawMessage) {
	if msg == nil {
		return
	}
	for _, raw := range []json.RawMessage{metadata, payload} {
		if len(raw) == 0 {
			continue
		}
		var m envelopeAuthMeta
		if err := json.Unmarshal(raw, &m); err != nil {
			continue
		}
		if msg.ActorID == "" && m.ActorID != "" {
			msg.ActorID = m.ActorID
		}
		if msg.ActorType == "" && m.ActorType != "" {
			msg.ActorType = m.ActorType
		}
		if msg.RequiredPerm == "" && m.RequiredPerm != "" {
			msg.RequiredPerm = m.RequiredPerm
		}
		if msg.ApprovalID == "" && m.ApprovalID != "" {
			msg.ApprovalID = m.ApprovalID
		}
	}
	msg.RequiredPerm = ResolveCanonicalEventPermission(msg.EventType, msg.RequiredPerm)
}

func stripBrokerMetadata(raw json.RawMessage) json.RawMessage {
	if len(raw) == 0 {
		return raw
	}
	var obj map[string]any
	if err := json.Unmarshal(raw, &obj); err != nil {
		return raw
	}
	if _, has := obj[brokerEntriesMetaKey]; !has {
		return raw
	}
	delete(obj, brokerEntriesMetaKey)
	cleaned, err := json.Marshal(obj)
	if err != nil {
		return raw
	}
	return cleaned
}

func newDeterministicUUID(seed string) string {
	sum := sha256.Sum256([]byte(seed))
	var b [16]byte
	copy(b[:], sum[:16])
	b[6] = (b[6] & 0x0f) | 0x40
	b[8] = (b[8] & 0x3f) | 0x80
	return fmt.Sprintf("%08x-%04x-%04x-%04x-%012x",
		b[0:4], b[4:6], b[6:8], b[8:10], b[10:16])
}

func newRandomUUID() string {
	var b [16]byte
	if _, err := rand.Read(b[:]); err != nil {
		return newDeterministicUUID(fmt.Sprintf("rand-fallback-%d", time.Now().UnixNano()))
	}
	b[6] = (b[6] & 0x0f) | 0x40
	b[8] = (b[8] & 0x3f) | 0x80
	return fmt.Sprintf("%08x-%04x-%04x-%04x-%012x",
		b[0:4], b[4:6], b[6:8], b[8:10], b[10:16])
}

// =============================================================================
// Shared Recoverable PostgreSQL StreamBroker (PgStreamBroker)
// =============================================================================

type pgGroupDeliveryState struct {
	State           string    `json:"state"` // "" (undelivered) | "pending" | "acked"
	ConsumerID      string    `json:"consumer_id,omitempty"`
	LastDeliveredAt time.Time `json:"last_delivered_at,omitempty"`
	DeliveryCount   int       `json:"delivery_count,omitempty"`
	AckedAt         time.Time `json:"acked_at,omitempty"`
}

type pgBrokerEntry struct {
	StreamEntryID string                          `json:"stream_entry_id"`
	Stream        QueueName                       `json:"stream"`
	Message       StreamMessage                   `json:"message"`
	Groups        map[string]pgGroupDeliveryState `json:"groups,omitempty"`
}

// PgStreamBroker implements StreamBroker durably backed by PostgreSQL event_outbox rows
// so separate outbox poller and worker OS processes share stream entries, consumer group
// PELs, XAUTOCLAIM recovery, and XACK state without volatile process-local memory.
type PgStreamBroker struct {
	db      tenantdb.TxBeginner
	setRole bool
	seq     atomic.Int64
}

// NewPgStreamBroker creates a PostgreSQL-backed durable StreamBroker.
func NewPgStreamBroker(db tenantdb.TxBeginner, setOutboxPollerRole bool) *PgStreamBroker {
	b := &PgStreamBroker{
		db:      db,
		setRole: setOutboxPollerRole,
	}
	b.seq.Store(1)
	return b
}

// Ping verifies database connectivity and outbox table access before polling or consuming.
func (b *PgStreamBroker) Ping(ctx context.Context) error {
	if b == nil || b.db == nil {
		return errors.New("outbox: nil PgStreamBroker database handle")
	}
	tx, err := b.db.Begin(ctx)
	if err != nil {
		return fmt.Errorf("outbox: broker db begin failed: %w", err)
	}
	defer func() { _ = tx.Rollback(ctx) }()

	if b.setRole {
		if _, err := tx.Exec(ctx, `SET LOCAL ROLE outbox_poller`); err != nil {
			return fmt.Errorf("outbox: broker SET LOCAL ROLE outbox_poller failed: %w", err)
		}
	}
	var one int
	if err := tx.QueryRow(ctx, `SELECT 1 FROM event_outbox LIMIT 1`).Scan(&one); err != nil && !errors.Is(err, pgx.ErrNoRows) {
		return fmt.Errorf("outbox: broker event_outbox probe failed: %w", err)
	}
	return nil
}

// XAdd durably appends msg to stream inside PostgreSQL event_outbox metadata.
func (b *PgStreamBroker) XAdd(ctx context.Context, stream QueueName, msg StreamMessage) (string, error) {
	if b == nil || b.db == nil {
		return "", errors.New("outbox: PgStreamBroker not initialized")
	}
	tx, err := b.db.Begin(ctx)
	if err != nil {
		return "", err
	}
	defer func() { _ = tx.Rollback(ctx) }()

	if b.setRole {
		if _, err := tx.Exec(ctx, `SET LOCAL ROLE outbox_poller`); err != nil {
			return "", fmt.Errorf("outbox: SET LOCAL ROLE outbox_poller: %w", err)
		}
	}

	pubAt := msg.PublishedAt
	if pubAt.IsZero() {
		pubAt = time.Now().UTC()
		msg.PublishedAt = pubAt
	}
	if msg.TargetStream == "" {
		msg.TargetStream = stream
	}
	msg.Metadata = stripBrokerMetadata(msg.Metadata)
	populateEnvelopeAuthFields(&msg, msg.Metadata, msg.Payload)

	var outboxID int64
	var rawMeta []byte
	err = tx.QueryRow(
		ctx,
		`SELECT outbox_id, COALESCE(metadata, '{}'::jsonb) FROM event_outbox WHERE event_id = $1::uuid FOR UPDATE`,
		msg.EventID,
	).Scan(&outboxID, &rawMeta)

	if err != nil && !errors.Is(err, pgx.ErrNoRows) {
		return "", fmt.Errorf("outbox: XAdd lock event_outbox: %w", err)
	}

	metaMap := make(map[string]any)
	if len(rawMeta) > 0 {
		_ = json.Unmarshal(rawMeta, &metaMap)
	}
	var entries []pgBrokerEntry
	if existingRaw, ok := metaMap[brokerEntriesMetaKey]; ok {
		if rawBytes, mErr := json.Marshal(existingRaw); mErr == nil {
			_ = json.Unmarshal(rawBytes, &entries)
		}
	}

	var dbSeq int64
	if err := tx.QueryRow(ctx, `SELECT nextval('event_outbox_outbox_id_seq')`).Scan(&dbSeq); err != nil {
		return "", fmt.Errorf("outbox: XAdd allocate stream sequence: %w", err)
	}
	entryID := fmt.Sprintf("%d-%d", pubAt.UnixMilli(), dbSeq)
	msg.StreamEntryID = entryID

	entries = append(entries, pgBrokerEntry{
		StreamEntryID: entryID,
		Stream:        stream,
		Message:       msg,
		Groups:        make(map[string]pgGroupDeliveryState),
	})
	metaMap[brokerEntriesMetaKey] = entries
	updatedMeta, mErr := json.Marshal(metaMap)
	if mErr != nil {
		return "", mErr
	}

	if errors.Is(err, pgx.ErrNoRows) {
		// Standalone broker publish (e.g. DLQ replay or direct XAdd in tests).
		// Reset role if needed so INSERT is permitted when running as DB owner in tests.
		if b.setRole {
			_, _ = tx.Exec(ctx, `RESET ROLE`)
		}
		if msg.WorkspaceID != "" {
			_, _ = tx.Exec(ctx, `SELECT set_config('app.current_tenant_id', $1, true)`, msg.WorkspaceID)
		}
		eventID := msg.EventID
		if !tenantdb.IsValidNonZeroUUID(eventID) {
			eventID = newRandomUUID()
		}
		aggID := msg.AggregateID
		if !tenantdb.IsValidNonZeroUUID(aggID) {
			aggID = eventID
		}
		payload := msg.Payload
		if len(payload) == 0 {
			payload = json.RawMessage(`{}`)
		}
		_, insErr := tx.Exec(ctx, `
			INSERT INTO event_outbox (
				event_id, event_type, target_stream, aggregate_type, aggregate_id,
				workspace_id, payload, metadata, published, published_at
			) VALUES (
				$1::uuid, $2, $3, $4, $5::uuid,
				NULLIF($6, '')::uuid, $7::jsonb, $8::jsonb, true, $9
			)
		`,
			eventID,
			nonEmpty(msg.EventType, "stream.published"),
			string(stream),
			nonEmpty(msg.AggregateType, "stream_entry"),
			aggID,
			msg.WorkspaceID,
			[]byte(payload),
			updatedMeta,
			pubAt,
		)
		if insErr != nil {
			return "", fmt.Errorf("outbox: XAdd insert standalone outbox row: %w", insErr)
		}
	} else {
		if _, updErr := tx.Exec(ctx, `UPDATE event_outbox SET metadata = $2::jsonb WHERE outbox_id = $1`, outboxID, updatedMeta); updErr != nil {
			return "", fmt.Errorf("outbox: XAdd update broker entries: %w", updErr)
		}
	}

	if err := tx.Commit(ctx); err != nil {
		return "", err
	}
	return entryID, nil
}

// XReadGroup reads up to count undelivered stream entries for groupName and records them in the durable PEL.
func (b *PgStreamBroker) XReadGroup(ctx context.Context, stream QueueName, groupName, consumerID string, now time.Time, count int) ([]StreamMessage, error) {
	return b.claimEntries(ctx, stream, groupName, consumerID, 0, now, count, false)
}

// XAutoClaim scans the group's durable PEL and transfers entries idle for >= minIdle at time now to consumerID.
func (b *PgStreamBroker) XAutoClaim(ctx context.Context, stream QueueName, groupName, consumerID string, minIdle time.Duration, now time.Time, count int) ([]StreamMessage, error) {
	return b.claimEntries(ctx, stream, groupName, consumerID, minIdle, now, count, true)
}

func (b *PgStreamBroker) claimEntries(
	ctx context.Context,
	stream QueueName,
	groupName string,
	consumerID string,
	minIdle time.Duration,
	now time.Time,
	count int,
	reclaimOnly bool,
) ([]StreamMessage, error) {
	if b == nil || b.db == nil {
		return nil, errors.New("outbox: PgStreamBroker not initialized")
	}
	if count <= 0 {
		count = 10
	}

	tx, err := b.db.Begin(ctx)
	if err != nil {
		return nil, err
	}
	defer func() { _ = tx.Rollback(ctx) }()

	if b.setRole {
		if _, err := tx.Exec(ctx, `SET LOCAL ROLE outbox_poller`); err != nil {
			return nil, fmt.Errorf("outbox: SET LOCAL ROLE outbox_poller: %w", err)
		}
	}

	rows, err := tx.Query(ctx, `
		SELECT outbox_id, COALESCE(metadata, '{}'::jsonb)
		FROM event_outbox
		WHERE target_stream = $1
		  AND metadata ? $2
		ORDER BY outbox_id ASC
		FOR UPDATE SKIP LOCKED
	`, string(stream), brokerEntriesMetaKey)
	if err != nil {
		return nil, err
	}

	type rowUpdate struct {
		outboxID int64
		metaJSON []byte
	}
	var updates []rowUpdate
	var claimed []StreamMessage

	for rows.Next() {
		var outboxID int64
		var rawMeta []byte
		if err := rows.Scan(&outboxID, &rawMeta); err != nil {
			rows.Close()
			return nil, err
		}
		if len(claimed) >= count {
			continue
		}

		var metaMap map[string]any
		if err := json.Unmarshal(rawMeta, &metaMap); err != nil {
			continue
		}
		rawEntries, ok := metaMap[brokerEntriesMetaKey]
		if !ok {
			continue
		}
		entriesBytes, err := json.Marshal(rawEntries)
		if err != nil {
			continue
		}
		var entries []pgBrokerEntry
		if err := json.Unmarshal(entriesBytes, &entries); err != nil {
			continue
		}

		modified := false
		for i := range entries {
			if len(claimed) >= count {
				break
			}
			if entries[i].Stream != "" && entries[i].Stream != stream {
				continue
			}
			if entries[i].Groups == nil {
				entries[i].Groups = make(map[string]pgGroupDeliveryState)
			}
			st := entries[i].Groups[groupName]

			if reclaimOnly {
				if st.State != "pending" {
					continue
				}
				if now.Sub(st.LastDeliveredAt) < minIdle {
					continue
				}
				st.ConsumerID = consumerID
				st.LastDeliveredAt = now
				st.DeliveryCount++
			} else {
				if st.State != "" {
					continue
				}
				st.State = "pending"
				st.ConsumerID = consumerID
				st.LastDeliveredAt = now
				st.DeliveryCount = 1
			}

			entries[i].Groups[groupName] = st
			entries[i].Message.ClaimedBy = consumerID
			entries[i].Message.LastDeliveredAt = now
			entries[i].Message.DeliveryCount = st.DeliveryCount
			claimed = append(claimed, entries[i].Message)
			modified = true
		}

		if modified {
			metaMap[brokerEntriesMetaKey] = entries
			if updatedBytes, err := json.Marshal(metaMap); err == nil {
				updates = append(updates, rowUpdate{outboxID: outboxID, metaJSON: updatedBytes})
			}
		}
	}
	rows.Close()
	if err := rows.Err(); err != nil {
		return nil, err
	}

	for _, u := range updates {
		if _, err := tx.Exec(ctx, `UPDATE event_outbox SET metadata = $2::jsonb WHERE outbox_id = $1`, u.outboxID, u.metaJSON); err != nil {
			return nil, err
		}
	}

	if err := tx.Commit(ctx); err != nil {
		return nil, err
	}
	return claimed, nil
}

// XAck removes streamEntryID from the group's Pending Entries List (PEL) in PostgreSQL.
func (b *PgStreamBroker) XAck(ctx context.Context, stream QueueName, groupName, streamEntryID string) error {
	if b == nil || b.db == nil {
		return errors.New("outbox: PgStreamBroker not initialized")
	}
	tx, err := b.db.Begin(ctx)
	if err != nil {
		return err
	}
	defer func() { _ = tx.Rollback(ctx) }()

	if b.setRole {
		if _, err := tx.Exec(ctx, `SET LOCAL ROLE outbox_poller`); err != nil {
			return fmt.Errorf("outbox: SET LOCAL ROLE outbox_poller: %w", err)
		}
	}

	rows, err := tx.Query(ctx, `
		SELECT outbox_id, COALESCE(metadata, '{}'::jsonb)
		FROM event_outbox
		WHERE target_stream = $1
		  AND metadata ? $2
		FOR UPDATE
	`, string(stream), brokerEntriesMetaKey)
	if err != nil {
		return err
	}

	var targetID int64
	var updatedMeta []byte
	found := false

	for rows.Next() {
		var outboxID int64
		var rawMeta []byte
		if err := rows.Scan(&outboxID, &rawMeta); err != nil {
			rows.Close()
			return err
		}
		if found {
			continue
		}
		var metaMap map[string]any
		if err := json.Unmarshal(rawMeta, &metaMap); err != nil {
			continue
		}
		entriesBytes, err := json.Marshal(metaMap[brokerEntriesMetaKey])
		if err != nil {
			continue
		}
		var entries []pgBrokerEntry
		if err := json.Unmarshal(entriesBytes, &entries); err != nil {
			continue
		}
		for i := range entries {
			if entries[i].StreamEntryID == streamEntryID {
				if entries[i].Groups == nil {
					entries[i].Groups = make(map[string]pgGroupDeliveryState)
				}
				st := entries[i].Groups[groupName]
				st.State = "acked"
				st.AckedAt = time.Now().UTC()
				entries[i].Groups[groupName] = st
				metaMap[brokerEntriesMetaKey] = entries
				if bBytes, mErr := json.Marshal(metaMap); mErr == nil {
					targetID = outboxID
					updatedMeta = bBytes
					found = true
				}
				break
			}
		}
	}
	rows.Close()
	if err := rows.Err(); err != nil {
		return err
	}

	if !found {
		return fmt.Errorf("outbox: stream entry %q not found in stream %q", streamEntryID, stream)
	}
	if _, err := tx.Exec(ctx, `UPDATE event_outbox SET metadata = $2::jsonb WHERE outbox_id = $1`, targetID, updatedMeta); err != nil {
		return err
	}
	return tx.Commit(ctx)
}

// PendingCount returns the number of unacknowledged messages in the group's durable PEL.
func (b *PgStreamBroker) PendingCount(stream QueueName, groupName string) int {
	if b == nil || b.db == nil {
		return 0
	}
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	tx, err := b.db.Begin(ctx)
	if err != nil {
		return 0
	}
	defer func() { _ = tx.Rollback(ctx) }()

	if b.setRole {
		if _, err := tx.Exec(ctx, `SET LOCAL ROLE outbox_poller`); err != nil {
			return 0
		}
	}

	rows, err := tx.Query(ctx, `
		SELECT COALESCE(metadata, '{}'::jsonb)
		FROM event_outbox
		WHERE target_stream = $1
		  AND metadata ? $2
	`, string(stream), brokerEntriesMetaKey)
	if err != nil {
		return 0
	}
	defer rows.Close()

	pending := 0
	for rows.Next() {
		var rawMeta []byte
		if err := rows.Scan(&rawMeta); err != nil {
			continue
		}
		var metaMap map[string]any
		if err := json.Unmarshal(rawMeta, &metaMap); err != nil {
			continue
		}
		entriesBytes, err := json.Marshal(metaMap[brokerEntriesMetaKey])
		if err != nil {
			continue
		}
		var entries []pgBrokerEntry
		if err := json.Unmarshal(entriesBytes, &entries); err != nil {
			continue
		}
		for _, e := range entries {
			if e.Groups[groupName].State == "pending" {
				pending++
			}
		}
	}
	return pending
}

// =============================================================================
// Dragonfly / Redis Streams RESP2 Broker Adapter (RedisStreamBroker)
// =============================================================================

// RedisStreamBroker implements StreamBroker over TCP/TLS RESP2 against Dragonfly / Redis 6.2+.
type RedisStreamBroker struct {
	addr       string
	serverName string
	username   string
	password   string
	dbIndex    int
	prefix     string
	useTLS     bool
	tlsConfig  *tls.Config
}

// NewRedisStreamBroker parses redisURL (e.g. redis://127.0.0.1:6379/0 or rediss://redis.internal:6379/0)
// and returns a RedisStreamBroker without leaking raw credentials in any error string.
func NewRedisStreamBroker(redisURL, keyPrefix string) (*RedisStreamBroker, error) {
	trimmed := strings.TrimSpace(redisURL)
	if trimmed == "" {
		return nil, errors.New("outbox: empty redis URL")
	}
	if strings.ContainsAny(trimmed, " \t\r\n") {
		return nil, errors.New("outbox: invalid redis URL")
	}
	u, err := url.Parse(trimmed)
	if err != nil {
		return nil, errors.New("outbox: invalid redis URL")
	}
	scheme := strings.ToLower(strings.TrimSpace(u.Scheme))
	if scheme != "redis" && scheme != "rediss" {
		return nil, errors.New("outbox: unsupported redis URL scheme (expected redis or rediss)")
	}
	if u.Opaque != "" {
		return nil, errors.New("outbox: invalid redis URL")
	}
	host := strings.TrimSpace(u.Hostname())
	if host == "" {
		return nil, errors.New("outbox: redis URL missing host")
	}
	port := strings.TrimSpace(u.Port())
	if port == "" {
		port = "6379"
	} else {
		portNum, convErr := strconv.Atoi(port)
		if convErr != nil || portNum < 1 || portNum > 65535 {
			return nil, errors.New("outbox: invalid redis port")
		}
	}
	var user, pw string
	if u.User != nil {
		user = u.User.Username()
		var hasPw bool
		pw, hasPw = u.User.Password()
		if user != "" && (!hasPw || pw == "") {
			return nil, errors.New("outbox: redis URL username requires password")
		}
	}
	dbIdx := 0
	if p := strings.TrimPrefix(u.Path, "/"); p != "" {
		n, convErr := strconv.Atoi(p)
		if convErr != nil || n < 0 {
			return nil, errors.New("outbox: invalid redis database index")
		}
		dbIdx = n
	}
	if keyPrefix == "" {
		keyPrefix = "creativanta:stream:"
	}
	return &RedisStreamBroker{
		addr:       net.JoinHostPort(host, port),
		serverName: host,
		username:   user,
		password:   pw,
		dbIndex:    dbIdx,
		prefix:     keyPrefix,
		useTLS:     scheme == "rediss",
	}, nil
}

// SetTLSConfig configures custom TLS settings (such as custom RootCAs for isolated test listeners)
// when connecting to a rediss:// endpoint. Minimum TLS version is always enforced as TLS 1.2+.
func (r *RedisStreamBroker) SetTLSConfig(cfg *tls.Config) {
	if r == nil {
		return
	}
	r.tlsConfig = cfg
}

func (r *RedisStreamBroker) streamKey(stream QueueName) string {
	return r.prefix + string(stream)
}

func (r *RedisStreamBroker) execCmd(ctx context.Context, args ...string) (any, error) {
	d := net.Dialer{Timeout: 5 * time.Second}
	rawConn, err := d.DialContext(ctx, "tcp", r.addr)
	if err != nil {
		return nil, err
	}
	defer rawConn.Close()

	if deadline, ok := ctx.Deadline(); ok {
		_ = rawConn.SetDeadline(deadline)
	} else {
		_ = rawConn.SetDeadline(time.Now().Add(5 * time.Second))
	}

	var conn net.Conn = rawConn
	if r.useTLS {
		tlsCfg := &tls.Config{
			MinVersion: tls.VersionTLS12,
			ServerName: r.serverName,
		}
		if r.tlsConfig != nil {
			tlsCfg = r.tlsConfig.Clone()
			if tlsCfg.MinVersion < tls.VersionTLS12 {
				tlsCfg.MinVersion = tls.VersionTLS12
			}
			if tlsCfg.ServerName == "" {
				tlsCfg.ServerName = r.serverName
			}
		}
		tlsConn := tls.Client(rawConn, tlsCfg)
		if err := tlsConn.HandshakeContext(ctx); err != nil {
			return nil, fmt.Errorf("outbox: redis TLS handshake failed: %w", err)
		}
		conn = tlsConn
	}

	br := bufio.NewReader(conn)
	if r.password != "" {
		authArgs := []string{"AUTH", r.password}
		if r.username != "" {
			authArgs = []string{"AUTH", r.username, r.password}
		}
		if err := writeRESPArray(conn, authArgs); err != nil {
			return nil, errors.New("outbox: redis authentication write failed")
		}
		if _, err := readRESPValue(br); err != nil {
			return nil, errors.New("outbox: redis authentication failed")
		}
	}
	if r.dbIndex > 0 {
		if err := writeRESPArray(conn, []string{"SELECT", strconv.Itoa(r.dbIndex)}); err != nil {
			return nil, err
		}
		if _, err := readRESPValue(br); err != nil {
			return nil, err
		}
	}

	if err := writeRESPArray(conn, args); err != nil {
		return nil, err
	}
	return readRESPValue(br)
}

func writeRESPArray(w io.Writer, args []string) error {
	var sb strings.Builder
	sb.WriteString(fmt.Sprintf("*%d\r\n", len(args)))
	for _, a := range args {
		sb.WriteString(fmt.Sprintf("$%d\r\n%s\r\n", len(a), a))
	}
	_, err := io.WriteString(w, sb.String())
	return err
}

func readRESPValue(br *bufio.Reader) (any, error) {
	line, err := br.ReadString('\n')
	if err != nil {
		return nil, err
	}
	line = strings.TrimSuffix(strings.TrimSuffix(line, "\n"), "\r")
	if len(line) == 0 {
		return nil, errors.New("outbox: empty RESP response")
	}
	switch line[0] {
	case '+':
		return line[1:], nil
	case '-':
		return nil, errors.New(line[1:])
	case ':':
		return strconv.ParseInt(line[1:], 10, 64)
	case '$':
		length, err := strconv.Atoi(line[1:])
		if err != nil {
			return nil, err
		}
		if length < 0 {
			return nil, nil
		}
		buf := make([]byte, length+2)
		if _, err := io.ReadFull(br, buf); err != nil {
			return nil, err
		}
		return string(buf[:length]), nil
	case '*':
		count, err := strconv.Atoi(line[1:])
		if err != nil {
			return nil, err
		}
		if count < 0 {
			return nil, nil
		}
		items := make([]any, count)
		for i := 0; i < count; i++ {
			val, err := readRESPValue(br)
			if err != nil {
				return nil, err
			}
			items[i] = val
		}
		return items, nil
	default:
		return nil, fmt.Errorf("outbox: unexpected RESP prefix %q", line)
	}
}

// Ping verifies Dragonfly/Redis reachability.
func (r *RedisStreamBroker) Ping(ctx context.Context) error {
	res, err := r.execCmd(ctx, "PING")
	if err != nil {
		return err
	}
	if s, ok := res.(string); !ok || !strings.EqualFold(s, "PONG") {
		return fmt.Errorf("outbox: unexpected redis PING response %v", res)
	}
	return nil
}

func (r *RedisStreamBroker) ensureGroup(ctx context.Context, stream QueueName, groupName string) error {
	_, err := r.execCmd(ctx, "XGROUP", "CREATE", r.streamKey(stream), groupName, "0", "MKSTREAM")
	if err != nil && !strings.Contains(err.Error(), "BUSYGROUP") {
		return err
	}
	return nil
}

// XAdd appends msg to the Redis Stream via XADD.
func (r *RedisStreamBroker) XAdd(ctx context.Context, stream QueueName, msg StreamMessage) (string, error) {
	if msg.PublishedAt.IsZero() {
		msg.PublishedAt = time.Now().UTC()
	}
	if msg.TargetStream == "" {
		msg.TargetStream = stream
	}
	msg.Metadata = stripBrokerMetadata(msg.Metadata)
	populateEnvelopeAuthFields(&msg, msg.Metadata, msg.Payload)

	encoded, err := json.Marshal(msg)
	if err != nil {
		return "", err
	}
	res, err := r.execCmd(ctx, "XADD", r.streamKey(stream), "*", "envelope", string(encoded))
	if err != nil {
		return "", err
	}
	entryID, _ := res.(string)
	return entryID, nil
}

// XReadGroup reads undelivered entries for groupName via XREADGROUP.
func (r *RedisStreamBroker) XReadGroup(ctx context.Context, stream QueueName, groupName, consumerID string, now time.Time, count int) ([]StreamMessage, error) {
	if err := r.ensureGroup(ctx, stream, groupName); err != nil {
		return nil, err
	}
	if count <= 0 {
		count = 10
	}
	res, err := r.execCmd(ctx, "XREADGROUP", "GROUP", groupName, consumerID, "COUNT", strconv.Itoa(count), "STREAMS", r.streamKey(stream), ">")
	if err != nil {
		return nil, err
	}
	if res == nil {
		return nil, nil
	}
	streamsArr, ok := res.([]any)
	if !ok || len(streamsArr) == 0 {
		return nil, nil
	}
	streamPair, ok := streamsArr[0].([]any)
	if !ok || len(streamPair) < 2 {
		return nil, nil
	}
	return parseRedisStreamEntries(streamPair[1], consumerID, now), nil
}

// XAutoClaim reclaims entries idle for >= minIdle via XAUTOCLAIM.
func (r *RedisStreamBroker) XAutoClaim(ctx context.Context, stream QueueName, groupName, consumerID string, minIdle time.Duration, now time.Time, count int) ([]StreamMessage, error) {
	if err := r.ensureGroup(ctx, stream, groupName); err != nil {
		return nil, err
	}
	if count <= 0 {
		count = 10
	}
	res, err := r.execCmd(ctx, "XAUTOCLAIM", r.streamKey(stream), groupName, consumerID, strconv.FormatInt(minIdle.Milliseconds(), 10), "0-0", "COUNT", strconv.Itoa(count))
	if err != nil {
		return nil, err
	}
	arr, ok := res.([]any)
	if !ok || len(arr) < 2 {
		return nil, nil
	}
	return parseRedisStreamEntries(arr[1], consumerID, now), nil
}

func parseRedisStreamEntries(raw any, consumerID string, now time.Time) []StreamMessage {
	entries, ok := raw.([]any)
	if !ok {
		return nil
	}
	var out []StreamMessage
	for _, item := range entries {
		pair, ok := item.([]any)
		if !ok || len(pair) < 2 {
			continue
		}
		entryID, _ := pair[0].(string)
		fields, ok := pair[1].([]any)
		if !ok {
			continue
		}
		for i := 0; i+1 < len(fields); i += 2 {
			k, _ := fields[i].(string)
			v, _ := fields[i+1].(string)
			if k == "envelope" && v != "" {
				var msg StreamMessage
				if err := json.Unmarshal([]byte(v), &msg); err == nil {
					msg.StreamEntryID = entryID
					msg.ClaimedBy = consumerID
					msg.LastDeliveredAt = now
					msg.DeliveryCount++
					out = append(out, msg)
				}
			}
		}
	}
	return out
}

// XAck acknowledges streamEntryID in groupName via XACK.
func (r *RedisStreamBroker) XAck(ctx context.Context, stream QueueName, groupName, streamEntryID string) error {
	_, err := r.execCmd(ctx, "XACK", r.streamKey(stream), groupName, streamEntryID)
	return err
}

// PendingCount queries XPENDING for the number of unacknowledged entries in groupName.
func (r *RedisStreamBroker) PendingCount(stream QueueName, groupName string) int {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	res, err := r.execCmd(ctx, "XPENDING", r.streamKey(stream), groupName)
	if err != nil {
		return 0
	}
	arr, ok := res.([]any)
	if !ok || len(arr) == 0 {
		return 0
	}
	n, _ := arr[0].(int64)
	return int(n)
}

// OpenSharedStreamBroker constructs and verifies the shared recoverable StreamBroker.
// If redisURL is non-empty, it connects and pings RedisStreamBroker; otherwise it uses
// PgStreamBroker over PostgreSQL and verifies event_outbox access. It never returns a volatile MemoryStreamBroker.
func OpenSharedStreamBroker(ctx context.Context, db tenantdb.TxBeginner, setOutboxPollerRole bool, redisURL string) (StreamBroker, error) {
	if strings.TrimSpace(redisURL) != "" {
		rb, err := NewRedisStreamBroker(redisURL, "")
		if err != nil {
			return nil, err
		}
		if err := rb.Ping(ctx); err != nil {
			return nil, fmt.Errorf("outbox: redis stream broker unreachable: %w", err)
		}
		return rb, nil
	}
	pgBroker := NewPgStreamBroker(db, setOutboxPollerRole)
	if err := pgBroker.Ping(ctx); err != nil {
		return nil, err
	}
	return pgBroker, nil
}

// =============================================================================
// PostgreSQL Transactional ConsumerInboxEngine (PgConsumerInboxEngine)
// =============================================================================

type queriesContextKey struct{}
type txContextKey struct{}

// WithQueries attaches a trusted *tenantdb.Queries to ctx inside PgConsumerInboxEngine.ExecuteAtomically.
func WithQueries(ctx context.Context, q *tenantdb.Queries) context.Context {
	return context.WithValue(ctx, queriesContextKey{}, q)
}

// QueriesFromContext retrieves the active *tenantdb.Queries bound by PgConsumerInboxEngine.
func QueriesFromContext(ctx context.Context) (*tenantdb.Queries, bool) {
	if ctx == nil {
		return nil, false
	}
	q, ok := ctx.Value(queriesContextKey{}).(*tenantdb.Queries)
	return q, ok
}

// WithTx attaches the active tenant-scoped pgx.Tx to ctx inside PgConsumerInboxEngine.ExecuteAtomically.
func WithTx(ctx context.Context, tx pgx.Tx) context.Context {
	return context.WithValue(ctx, txContextKey{}, tx)
}

// TxFromContext retrieves the active tenant-scoped pgx.Tx bound by PgConsumerInboxEngine.
func TxFromContext(ctx context.Context) (pgx.Tx, bool) {
	if ctx == nil {
		return nil, false
	}
	tx, ok := ctx.Value(txContextKey{}).(pgx.Tx)
	return tx, ok
}

type txCapturingBeginner struct {
	base tenantdb.TxBeginner
	tx   pgx.Tx
}

func (b *txCapturingBeginner) Begin(ctx context.Context) (pgx.Tx, error) {
	tx, err := b.base.Begin(ctx)
	if err != nil {
		return nil, err
	}
	b.tx = tx
	return tx, nil
}

// PgConsumerInboxEngine implements ConsumerInboxEngine using PostgreSQL tenantdb.WithTx,
// consumer_inbox deduplication, and immutable audit_events logging.
type PgConsumerInboxEngine struct {
	db tenantdb.TxBeginner
}

type appUserRoleBeginner struct {
	db tenantdb.TxBeginner
}

func (b appUserRoleBeginner) Begin(ctx context.Context) (pgx.Tx, error) {
	tx, err := b.db.Begin(ctx)
	if err != nil {
		return nil, err
	}
	if _, err := tx.Exec(ctx, `SET LOCAL ROLE app_user`); err != nil {
		_ = tx.Rollback(ctx)
		return nil, fmt.Errorf("outbox: SET LOCAL ROLE app_user: %w", err)
	}
	return tx, nil
}

// NewPgConsumerInboxEngine constructs a PgConsumerInboxEngine.
func NewPgConsumerInboxEngine(db tenantdb.TxBeginner) *PgConsumerInboxEngine {
	if db != nil {
		db = appUserRoleBeginner{db: db}
	}
	return &PgConsumerInboxEngine{db: db}
}

func (e *PgConsumerInboxEngine) resolveScopeUser(ctx context.Context, workspaceID, actorID, actorType string) (string, bool, error) {
	if tenantdb.IsValidNonZeroUUID(actorID) {
		requireMembership := strings.ToLower(strings.TrimSpace(actorType)) != "system"
		return actorID, requireMembership, nil
	}

	tx, err := e.db.Begin(ctx)
	if err != nil {
		return "", false, err
	}
	defer func() { _ = tx.Rollback(ctx) }()

	if _, err := tx.Exec(ctx, `SELECT set_config('app.current_tenant_id', $1, true)`, workspaceID); err != nil {
		return "", false, err
	}
	var ownerID string
	if err := tx.QueryRow(ctx, `SELECT owner_user_id::text FROM workspaces WHERE workspace_id = $1::uuid`, workspaceID).Scan(&ownerID); err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return fallbackSystemActorUUID, false, nil
		}
		return "", false, err
	}
	return ownerID, false, nil
}

// ExecuteAtomically runs handler inside a single tenantdb.WithTx transaction together with
// TryInsertConsumerInbox and InsertAuditEvent. Any error from handler or beforeCommit rolls back
// both the consumer_inbox marker and all domain mutations.
func (e *PgConsumerInboxEngine) ExecuteAtomically(
	ctx context.Context,
	consumerName string,
	msg StreamMessage,
	_ time.Time,
	beforeCommit func(StreamMessage) error,
	handler func(ctx context.Context, msg StreamMessage) error,
) (bool, bool, error) {
	if e == nil || e.db == nil {
		return false, false, errors.New("outbox: PgConsumerInboxEngine not initialized")
	}
	if !tenantdb.IsValidNonZeroUUID(msg.WorkspaceID) || !tenantdb.IsValidNonZeroUUID(msg.EventID) {
		return false, false, tenantdb.ErrInvalidTenantScope
	}

	userID, requireMembership, err := e.resolveScopeUser(ctx, msg.WorkspaceID, msg.ActorID, msg.ActorType)
	if err != nil {
		return false, false, err
	}

	var executed bool
	var deduplicated bool
	capBeginner := &txCapturingBeginner{base: e.db}

	txErr := tenantdb.WithTx(ctx, capBeginner, tenantdb.Scope{
		WorkspaceID:             msg.WorkspaceID,
		UserID:                  userID,
		RequireActiveMembership: requireMembership,
	}, func(txCtx context.Context, q *tenantdb.Queries) error {
		inboxID := newDeterministicUUID("inbox:" + msg.WorkspaceID + ":" + consumerName + ":" + msg.EventID)
		inserted, err := q.TryInsertConsumerInbox(txCtx, inboxID, msg.WorkspaceID, consumerName, msg.EventID)
		if err != nil {
			return err
		}
		if !inserted {
			deduplicated = true
			return nil
		}

		handlerCtx := WithQueries(WithTx(txCtx, capBeginner.tx), q)
		if err := handler(handlerCtx, msg); err != nil {
			return err
		}
		if beforeCommit != nil {
			if err := beforeCommit(msg); err != nil {
				return err
			}
		}

		aggID := msg.AggregateID
		if !tenantdb.IsValidNonZeroUUID(aggID) {
			aggID = msg.EventID
		}
		actorType := nonEmpty(msg.ActorType, "system")
		if !tenantdb.IsValidNonZeroUUID(msg.ActorID) {
			actorType = "system"
		}
		auditID := newDeterministicUUID("audit:processed:" + consumerName + ":" + msg.EventID)
		if err := q.InsertAuditEvent(txCtx, tenantdb.AuditEventParams{
			AuditEventID: auditID,
			WorkspaceID:  msg.WorkspaceID,
			ActorUserID:  userID,
			ActorType:    actorType,
			Action:       "consumer.processed:" + msg.EventType,
			ResourceType: nonEmpty(msg.AggregateType, "event"),
			ResourceID:   aggID,
			ChangesJSON:  []byte(fmt.Sprintf(`{"consumer_group":%q,"stream_entry_id":%q}`, consumerName, msg.StreamEntryID)),
		}); err != nil {
			return err
		}

		executed = true
		return nil
	})
	if txErr != nil {
		return false, false, txErr
	}
	return executed, deduplicated, nil
}

// RecordAbortedAudit writes an immutable audit_events row when live auth/approval verification aborts a queued message.
func (e *PgConsumerInboxEngine) RecordAbortedAudit(ctx context.Context, msg StreamMessage, reason string, _ time.Time) error {
	if e == nil || e.db == nil {
		return errors.New("outbox: PgConsumerInboxEngine not initialized")
	}
	if !tenantdb.IsValidNonZeroUUID(msg.WorkspaceID) {
		return tenantdb.ErrInvalidTenantScope
	}
	userID, _, err := e.resolveScopeUser(ctx, msg.WorkspaceID, msg.ActorID, msg.ActorType)
	if err != nil {
		return err
	}
	return tenantdb.WithTx(ctx, e.db, tenantdb.Scope{
		WorkspaceID:             msg.WorkspaceID,
		UserID:                  userID,
		RequireActiveMembership: false,
	}, func(txCtx context.Context, q *tenantdb.Queries) error {
		aggID := msg.AggregateID
		if !tenantdb.IsValidNonZeroUUID(aggID) {
			aggID = msg.EventID
		}
		if !tenantdb.IsValidNonZeroUUID(aggID) {
			aggID = newRandomUUID()
		}
		auditID := newDeterministicUUID("audit:aborted:" + msg.EventID + ":" + msg.StreamEntryID)
		return q.InsertAuditEvent(txCtx, tenantdb.AuditEventParams{
			AuditEventID: auditID,
			WorkspaceID:  msg.WorkspaceID,
			ActorUserID:  userID,
			ActorType:    nonEmpty(msg.ActorType, "user"),
			Action:       "consumer.aborted:" + msg.EventType,
			ResourceType: nonEmpty(msg.AggregateType, "event"),
			ResourceID:   aggID,
			Reason:       reason,
		})
	})
}

// =============================================================================
// PostgreSQL LiveAuthVerifier (PgLiveAuthVerifier)
// =============================================================================

// PgLiveAuthVerifier re-verifies workspace status, actor membership/role permission,
// and approval_requests validity against live PostgreSQL tables at worker execution time.
type PgLiveAuthVerifier struct {
	db tenantdb.TxBeginner
}

// NewPgLiveAuthVerifier creates a PgLiveAuthVerifier.
func NewPgLiveAuthVerifier(db tenantdb.TxBeginner) *PgLiveAuthVerifier {
	if db != nil {
		db = appUserRoleBeginner{db: db}
	}
	return &PgLiveAuthVerifier{db: db}
}

// VerifyActorAndApproval checks live PostgreSQL state before executing a queued message.
// Transient database/network errors and unknown permission policy errors are returned directly
// (NOT wrapped as ErrLiveActorAuthorizationRevoked) so the worker leaves the message in the PEL
// for retry instead of permanently dropping it.
func (v *PgLiveAuthVerifier) VerifyActorAndApproval(
	ctx context.Context,
	workspaceID, actorID, requiredPerm, approvalID string,
	now time.Time,
) error {
	if v == nil || v.db == nil {
		return errors.New("outbox: PgLiveAuthVerifier not initialized")
	}
	if !tenantdb.IsValidNonZeroUUID(workspaceID) {
		return ErrLiveActorAuthorizationRevoked
	}
	if now.IsZero() {
		now = time.Now().UTC()
	}

	tx, err := v.db.Begin(ctx)
	if err != nil {
		return err
	}
	defer func() { _ = tx.Rollback(ctx) }()

	userCfg := actorID
	if !tenantdb.IsValidNonZeroUUID(userCfg) {
		userCfg = ""
	}
	if _, err := tx.Exec(ctx, `SELECT set_config('app.current_tenant_id', $1, true), set_config('app.current_user_id', $2, true)`, workspaceID, userCfg); err != nil {
		return err
	}

	var wsActive bool
	err = tx.QueryRow(ctx, `
		SELECT status = 'active' AND deleted_at IS NULL
		FROM workspaces
		WHERE workspace_id = $1::uuid
	`, workspaceID).Scan(&wsActive)
	if errors.Is(err, pgx.ErrNoRows) {
		return ErrLiveActorAuthorizationRevoked
	}
	if err != nil {
		return fmt.Errorf("outbox: verify workspace active status: %w", err)
	}
	if !wsActive {
		return ErrLiveActorAuthorizationRevoked
	}

	if actorID != "" && !strings.EqualFold(actorID, "system") {
		if !tenantdb.IsValidNonZeroUUID(actorID) {
			return ErrLiveActorAuthorizationRevoked
		}
		var role string
		err := tx.QueryRow(ctx, `
			SELECT wm.role
			FROM workspace_members wm
			JOIN users u ON u.user_id = wm.user_id
			WHERE wm.workspace_id = $1::uuid
				AND wm.user_id = $2::uuid
				AND wm.status = 'active'
				AND u.status = 'active'
		`, workspaceID, actorID).Scan(&role)
		if errors.Is(err, pgx.ErrNoRows) {
			return ErrLiveActorAuthorizationRevoked
		}
		if err != nil {
			return fmt.Errorf("outbox: verify actor membership: %w", err)
		}
		canonicalPerm := ResolveCanonicalEventPermission("", requiredPerm)
		if canonicalPerm != "" {
			if err := rbac.CheckWorkspacePermission(canonicalPerm, rbac.PolicyContext{
				ActorUserID: actorID,
				WorkspaceID: workspaceID,
				Role:        role,
			}); err != nil {
				if errors.Is(err, rbac.ErrUnknownPermission) || errors.Is(err, rbac.ErrUnknownRole) {
					return fmt.Errorf("%w: %v", ErrInvalidEventPermissionPolicy, err)
				}
				return fmt.Errorf("%w: %v", ErrLiveActorAuthorizationRevoked, err)
			}
		}
	}

	if approvalID != "" {
		if !tenantdb.IsValidNonZeroUUID(approvalID) {
			return ErrApprovalExpiredBeforeExecution
		}
		var status string
		var expiresAt *time.Time
		err := tx.QueryRow(ctx, `
			SELECT status, expires_at
			FROM approval_requests
			WHERE workspace_id = $1::uuid
				AND request_id = $2::uuid
		`, workspaceID, approvalID).Scan(&status, &expiresAt)
		if errors.Is(err, pgx.ErrNoRows) {
			return ErrApprovalExpiredBeforeExecution
		}
		if err != nil {
			return fmt.Errorf("outbox: verify approval request: %w", err)
		}
		if status != "approved" && status != "not_required" {
			return ErrApprovalExpiredBeforeExecution
		}
		if expiresAt != nil && !now.Before(*expiresAt) {
			return ErrApprovalExpiredBeforeExecution
		}
	}

	return nil
}

// =============================================================================
// PostgreSQL Domain Action Handler & Durable Catalog Search Index
// =============================================================================

var (
	// ErrNoDomainExecutorRegistered is returned when a worker receives a message for a stream,
	// event type, or external provider that has no registered domain/connector executor.
	// The worker fails closed (rolling back consumer_inbox and leaving the message un-ACKed)
	// instead of fabricating a synthetic succeeded external_effects record.
	ErrNoDomainExecutorRegistered = errors.New("outbox: no authorized domain or provider executor registered for message")

	// ErrSearchIndexTargetNotFound is returned when a catalog search indexing event references
	// a product that does not exist (or is soft-deleted / in another workspace) under tenant RLS.
	ErrSearchIndexTargetNotFound = errors.New("outbox: catalog search index target product not found in workspace")

	// ErrSearchIndexVerificationFailed is returned when read-after-write verification of a
	// catalog search document fails in PostgreSQL or the configured SearchIndexBackend.
	ErrSearchIndexVerificationFailed = errors.New("outbox: catalog search index read-after-write verification failed")

	// ErrSearchDocumentNotIndexed is returned when querying a product's search document before
	// the search_indexing worker has indexed it.
	ErrSearchDocumentNotIndexed = errors.New("outbox: product search document not indexed")

	// ErrInventoryMovementNotFound is returned when an inventory.stock_moved event references
	// a missing SKU or lacks a committed stock_movements ledger row in the workspace.
	ErrInventoryMovementNotFound = errors.New("outbox: inventory stock movement or SKU not found in workspace")
)

// CatalogSearchDocument is the canonical tenant-isolated searchable product document
// persisted and verified by the search_indexing worker (docs/05_system/cache_search_strategy.md §2.1).
type CatalogSearchDocument struct {
	DocumentID       string    `json:"document_id"`
	WorkspaceID      string    `json:"workspace_id"`
	ProductID        string    `json:"product_id"`
	Title            string    `json:"title"`
	Description      string    `json:"description"`
	Category         string    `json:"category"`
	ProductType      string    `json:"product_type"`
	CatalogStatus    string    `json:"catalog_status"`
	BasePrice        string    `json:"base_price"`
	Currency         string    `json:"currency"`
	InventoryEnabled bool      `json:"inventory_enabled"`
	SKUCount         int       `json:"sku_count"`
	SKUCodes         []string  `json:"sku_codes"`
	TotalStock       int64     `json:"total_stock"`
	ReservedStock    int64     `json:"reserved_stock"`
	AvailableStock   int64     `json:"available_stock"`
	LowStockSKUCount int       `json:"low_stock_sku_count"`
	InStock          bool      `json:"in_stock"`
	SearchTokens     []string  `json:"search_tokens"`
	SearchableText   string    `json:"searchable_text"`
	LastEventID      string    `json:"last_event_id"`
	LastEventType    string    `json:"last_event_type"`
	DocumentVersion  string    `json:"document_version"`
	ProductCreatedAt time.Time `json:"product_created_at"`
	ProductUpdatedAt time.Time `json:"product_updated_at"`
	IndexedAt        time.Time `json:"indexed_at"`
}

// CatalogSearchQuery specifies filter, full-text query, and sort criteria for querying
// the durable catalog search index under tenant RLS.
type CatalogSearchQuery struct {
	Query         string
	CatalogStatus string
	ProductType   string
	Category      string
	InStockOnly   bool
	SortBy        string
	Limit         int
}

// SearchIndexBackend abstracts an optional external search engine adapter (e.g. Meilisearch)
// that receives canonical CatalogSearchDocument upserts and supports read-after-write verification.
type SearchIndexBackend interface {
	ProviderName() string
	UpsertProductDocument(ctx context.Context, doc CatalogSearchDocument) (providerRequestID string, err error)
	GetProductDocument(ctx context.Context, workspaceID, productID string) (*CatalogSearchDocument, error)
}

// DomainActionResult holds the verified outcome returned by an authorized DomainEffectExecutor.
type DomainActionResult struct {
	ProviderRequestID string
	ResultPayload     json.RawMessage
}

// DomainEffectExecutor executes an authorized domain or connector action inside the active
// tenantdb.Queries transaction before external_effects is marked succeeded.
type DomainEffectExecutor func(ctx context.Context, q *tenantdb.Queries, msg StreamMessage) (DomainActionResult, error)

type domainPayloadSpec struct {
	OperationKey       string `json:"operation_key"`
	Provider           string `json:"provider"`
	ConnectedAccountID string `json:"connected_account_id"`
	ProviderRequestID  string `json:"provider_request_id"`
}

// PgDomainActionHandler executes registered domain actions inside the PgConsumerInboxEngine
// transaction, enforcing external_effects idempotency/unknown-outcome protection and recording
// diagnostics_records in PostgreSQL. If no real executor is registered for the target stream,
// event type, or external provider, Handle fails closed with ErrNoDomainExecutorRegistered.
type PgDomainActionHandler struct {
	mu                  sync.RWMutex
	streamEventExecs    map[string]DomainEffectExecutor
	externalProviderMap map[string]DomainEffectExecutor
	searchBackend       SearchIndexBackend
}

// NewPgDomainActionHandler creates a PgDomainActionHandler with the durable catalog search
// indexing executor registered for QueueSearchIndexing product catalog events and the
// inventory stock movement executor registered for QueueAnalyticsEvents.
func NewPgDomainActionHandler() *PgDomainActionHandler {
	h := &PgDomainActionHandler{
		streamEventExecs:    make(map[string]DomainEffectExecutor),
		externalProviderMap: make(map[string]DomainEffectExecutor),
	}
	for _, evType := range []string{
		"product.created",
		"product.updated",
		"product.catalog_status_changed",
	} {
		h.RegisterExecutor(QueueSearchIndexing, evType, h.executeCatalogSearchIndexing)
	}
	h.RegisterExecutor(QueueAnalyticsEvents, "inventory.stock_moved", h.executeInventoryStockMoved)
	h.RegisterExecutor(QueueSearchIndexing, "inventory.stock_moved", h.executeInventoryStockMoved)
	return h
}

// SetSearchIndexBackend configures an optional external SearchIndexBackend that receives
// product document upserts and read-after-write verification alongside PostgreSQL.
func (h *PgDomainActionHandler) SetSearchIndexBackend(backend SearchIndexBackend) {
	if h == nil {
		return
	}
	h.mu.Lock()
	defer h.mu.Unlock()
	h.searchBackend = backend
}

func (h *PgDomainActionHandler) getSearchBackend() SearchIndexBackend {
	if h == nil {
		return nil
	}
	h.mu.RLock()
	defer h.mu.RUnlock()
	return h.searchBackend
}

// RegisterExecutor registers an authorized internal domain executor for (stream, eventType).
func (h *PgDomainActionHandler) RegisterExecutor(stream QueueName, eventType string, exec DomainEffectExecutor) {
	if h == nil || exec == nil {
		return
	}
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.streamEventExecs == nil {
		h.streamEventExecs = make(map[string]DomainEffectExecutor)
	}
	key := string(stream) + ":" + strings.TrimSpace(eventType)
	h.streamEventExecs[key] = exec
}

// RegisterProviderExecutor registers an authorized external provider connector executor.
func (h *PgDomainActionHandler) RegisterProviderExecutor(provider string, exec DomainEffectExecutor) {
	if h == nil || exec == nil {
		return
	}
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.externalProviderMap == nil {
		h.externalProviderMap = make(map[string]DomainEffectExecutor)
	}
	h.externalProviderMap[strings.ToLower(strings.TrimSpace(provider))] = exec
}

func (h *PgDomainActionHandler) resolveExecutor(stream QueueName, eventType, provider string) DomainEffectExecutor {
	if h == nil {
		return nil
	}
	h.mu.RLock()
	defer h.mu.RUnlock()

	normProvider := strings.ToLower(strings.TrimSpace(provider))
	if normProvider != "" && normProvider != "internal_worker" {
		return h.externalProviderMap[normProvider]
	}
	if stream == "" {
		stream = QueueSearchIndexing
	}
	key := string(stream) + ":" + strings.TrimSpace(eventType)
	return h.streamEventExecs[key]
}

func buildSearchTokens(parts ...string) ([]string, string) {
	seen := make(map[string]struct{})
	var ordered []string
	var rawBuilder strings.Builder
	for _, p := range parts {
		trimmed := strings.TrimSpace(p)
		if trimmed == "" {
			continue
		}
		if rawBuilder.Len() > 0 {
			rawBuilder.WriteByte(' ')
		}
		rawBuilder.WriteString(strings.ToLower(trimmed))
		fields := strings.FieldsFunc(strings.ToLower(trimmed), func(r rune) bool {
			return r == ' ' || r == '\t' || r == '\n' || r == '\r' || r == ',' || r == ';' || r == '.' || r == ':' || r == '/' || r == '\\'
		})
		for _, tok := range fields {
			if tok == "" {
				continue
			}
			if _, exists := seen[tok]; !exists {
				seen[tok] = struct{}{}
				ordered = append(ordered, tok)
			}
		}
	}
	return ordered, rawBuilder.String()
}

func (h *PgDomainActionHandler) syncProductSearchIndexTx(
	ctx context.Context,
	tx pgx.Tx,
	workspaceID, productID, eventID, eventType string,
) (CatalogSearchDocument, string, error) {
	if tx == nil {
		return CatalogSearchDocument{}, "", errors.New("outbox: syncProductSearchIndexTx requires active pgx.Tx")
	}
	if !tenantdb.IsValidNonZeroUUID(workspaceID) || !tenantdb.IsValidNonZeroUUID(productID) {
		return CatalogSearchDocument{}, "", tenantdb.ErrInvalidTenantScope
	}

	var doc CatalogSearchDocument
	err := tx.QueryRow(ctx, `
		SELECT
			product_id::text,
			workspace_id::text,
			product_type,
			title,
			COALESCE(description, ''),
			COALESCE(category, ''),
			COALESCE(base_price::numeric(18,6)::text, '0.000000'),
			COALESCE(currency, 'VND'),
			catalog_status,
			COALESCE(inventory_enabled, false),
			created_at,
			updated_at
		FROM products
		WHERE workspace_id = $1::uuid
		  AND product_id = $2::uuid
		  AND deleted_at IS NULL
		FOR UPDATE
	`, workspaceID, productID).Scan(
		&doc.ProductID,
		&doc.WorkspaceID,
		&doc.ProductType,
		&doc.Title,
		&doc.Description,
		&doc.Category,
		&doc.BasePrice,
		&doc.Currency,
		&doc.CatalogStatus,
		&doc.InventoryEnabled,
		&doc.ProductCreatedAt,
		&doc.ProductUpdatedAt,
	)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return CatalogSearchDocument{}, "", fmt.Errorf("%w: product_id=%s workspace_id=%s", ErrSearchIndexTargetNotFound, productID, workspaceID)
		}
		return CatalogSearchDocument{}, "", fmt.Errorf("outbox: load product for search index: %w", err)
	}
	if strings.TrimSpace(doc.Title) == "" {
		return CatalogSearchDocument{}, "", fmt.Errorf("%w: product %s has empty title", ErrSearchIndexVerificationFailed, productID)
	}

	rows, err := tx.Query(ctx, `
		SELECT
			sku_code,
			COALESCE(stock_quantity, 0),
			COALESCE(stock_reserved, 0),
			COALESCE(low_stock_threshold, 5),
			COALESCE(is_active, true)
		FROM product_skus
		WHERE workspace_id = $1::uuid
		  AND product_id = $2::uuid
		  AND deleted_at IS NULL
		ORDER BY created_at ASC, sku_id ASC
	`, workspaceID, productID)
	if err != nil {
		return CatalogSearchDocument{}, "", fmt.Errorf("outbox: query product_skus for search index: %w", err)
	}
	skuCodes := make([]string, 0)
	var totalStock, reservedStock int64
	var activeSKUs, lowStockSKUs int
	for rows.Next() {
		var skuCode string
		var stockQty, stockRes, lowThreshold int64
		var isActive bool
		if scanErr := rows.Scan(&skuCode, &stockQty, &stockRes, &lowThreshold, &isActive); scanErr != nil {
			rows.Close()
			return CatalogSearchDocument{}, "", fmt.Errorf("outbox: scan product_sku for search index: %w", scanErr)
		}
		if !isActive {
			continue
		}
		activeSKUs++
		skuCodes = append(skuCodes, skuCode)
		totalStock += stockQty
		reservedStock += stockRes
		avail := stockQty - stockRes
		if avail <= lowThreshold {
			lowStockSKUs++
		}
	}
	if err := rows.Err(); err != nil {
		rows.Close()
		return CatalogSearchDocument{}, "", fmt.Errorf("outbox: iterate product_skus for search index: %w", err)
	}
	rows.Close()

	availableStock := totalStock - reservedStock
	inStock := !doc.InventoryEnabled || availableStock > 0
	tokenParts := append([]string{doc.Title, doc.Description, doc.Category, doc.ProductType}, skuCodes...)
	tokens, searchableText := buildSearchTokens(tokenParts...)

	doc.DocumentID = doc.ProductID
	doc.SKUCount = activeSKUs
	doc.SKUCodes = skuCodes
	doc.TotalStock = totalStock
	doc.ReservedStock = reservedStock
	doc.AvailableStock = availableStock
	doc.LowStockSKUCount = lowStockSKUs
	doc.InStock = inStock
	doc.SearchTokens = tokens
	doc.SearchableText = searchableText
	doc.LastEventID = eventID
	doc.LastEventType = eventType
	doc.ProductCreatedAt = doc.ProductCreatedAt.UTC()
	doc.ProductUpdatedAt = doc.ProductUpdatedAt.UTC()
	doc.IndexedAt = time.Now().UTC().Truncate(time.Microsecond)

	versionSum := sha256.Sum256([]byte(fmt.Sprintf(
		"%s|%s|%s|%s|%s|%s|%s|%s|%t|%d|%d|%d|%s|%s",
		doc.WorkspaceID,
		doc.ProductID,
		doc.Title,
		doc.Description,
		doc.Category,
		doc.ProductType,
		doc.CatalogStatus,
		doc.BasePrice,
		doc.InventoryEnabled,
		doc.SKUCount,
		doc.TotalStock,
		doc.ReservedStock,
		strings.Join(doc.SKUCodes, ","),
		doc.LastEventID,
	)))
	doc.DocumentVersion = hex.EncodeToString(versionSum[:16])

	docBytes, err := json.Marshal(doc)
	if err != nil {
		return CatalogSearchDocument{}, "", fmt.Errorf("outbox: marshal search document: %w", err)
	}

	// Persist the canonical search document inside products.metadata['search_index'] without
	// modifying products.updated_at (preserving optimistic concurrency tokens on products).
	tag, err := tx.Exec(ctx, `
		UPDATE products
		SET metadata = jsonb_set(COALESCE(metadata, '{}'::jsonb), '{search_index}', $1::jsonb, true)
		WHERE workspace_id = $2::uuid
		  AND product_id = $3::uuid
		  AND deleted_at IS NULL
	`, docBytes, workspaceID, productID)
	if err != nil {
		return CatalogSearchDocument{}, "", fmt.Errorf("outbox: persist catalog search document: %w", err)
	}
	if tag.RowsAffected() != 1 {
		return CatalogSearchDocument{}, "", fmt.Errorf("%w: update affected %d rows for product %s", ErrSearchIndexVerificationFailed, tag.RowsAffected(), productID)
	}

	// Read-after-write verification from PostgreSQL inside the tenant RLS transaction.
	verifiedDoc, err := getIndexedProductDocumentTx(ctx, tx, workspaceID, productID)
	if err != nil {
		return CatalogSearchDocument{}, "", fmt.Errorf("%w: %v", ErrSearchIndexVerificationFailed, err)
	}
	if verifiedDoc.ProductID != doc.ProductID ||
		verifiedDoc.WorkspaceID != doc.WorkspaceID ||
		verifiedDoc.Title != doc.Title ||
		verifiedDoc.CatalogStatus != doc.CatalogStatus ||
		verifiedDoc.DocumentVersion != doc.DocumentVersion ||
		verifiedDoc.LastEventID != doc.LastEventID {
		return CatalogSearchDocument{}, "", fmt.Errorf(
			"%w: readback mismatch got=%+v want=%+v",
			ErrSearchIndexVerificationFailed,
			verifiedDoc,
			doc,
		)
	}

	providerReqID := fmt.Sprintf("search_idx_%s_%s", productID[:8], doc.DocumentVersion[:16])

	// If an external SearchIndexBackend (e.g. Meilisearch adapter) is configured, upsert and
	// verify read-after-write on the backend before allowing the transaction to succeed.
	if backend := h.getSearchBackend(); backend != nil {
		extReqID, err := backend.UpsertProductDocument(ctx, doc)
		if err != nil {
			return CatalogSearchDocument{}, "", fmt.Errorf("%w: external backend (%s) upsert failed: %v", ErrSearchIndexVerificationFailed, backend.ProviderName(), err)
		}
		if strings.TrimSpace(extReqID) == "" {
			return CatalogSearchDocument{}, "", fmt.Errorf("%w: external backend (%s) returned empty provider_request_id", ErrSearchIndexVerificationFailed, backend.ProviderName())
		}
		extDoc, err := backend.GetProductDocument(ctx, workspaceID, productID)
		if err != nil || extDoc == nil {
			return CatalogSearchDocument{}, "", fmt.Errorf("%w: external backend (%s) read-after-write failed: %v", ErrSearchIndexVerificationFailed, backend.ProviderName(), err)
		}
		if extDoc.ProductID != doc.ProductID ||
			extDoc.WorkspaceID != doc.WorkspaceID ||
			extDoc.Title != doc.Title ||
			extDoc.CatalogStatus != doc.CatalogStatus ||
			extDoc.DocumentVersion != doc.DocumentVersion {
			return CatalogSearchDocument{}, "", fmt.Errorf("%w: external backend (%s) document mismatch", ErrSearchIndexVerificationFailed, backend.ProviderName())
		}
		providerReqID = strings.TrimSpace(extReqID)
	}

	return doc, providerReqID, nil
}

func getIndexedProductDocumentTx(ctx context.Context, tx pgx.Tx, workspaceID, productID string) (*CatalogSearchDocument, error) {
	var rawDoc []byte
	err := tx.QueryRow(ctx, `
		SELECT metadata->'search_index'
		FROM products
		WHERE workspace_id = $1::uuid
		  AND product_id = $2::uuid
		  AND deleted_at IS NULL
	`, workspaceID, productID).Scan(&rawDoc)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrSearchIndexTargetNotFound
		}
		return nil, err
	}
	if len(rawDoc) == 0 || string(rawDoc) == "null" {
		return nil, ErrSearchDocumentNotIndexed
	}
	var doc CatalogSearchDocument
	if err := json.Unmarshal(rawDoc, &doc); err != nil {
		return nil, fmt.Errorf("outbox: unmarshal indexed search document: %w", err)
	}
	if doc.ProductID == "" || doc.WorkspaceID != workspaceID {
		return nil, ErrSearchDocumentNotIndexed
	}
	return &doc, nil
}

// GetCatalogSearchDocument retrieves the indexed CatalogSearchDocument for (workspaceID, productID)
// under PostgreSQL tenant RLS (ROLE app_user, app.current_tenant_id = workspaceID).
// Returns ErrSearchDocumentNotIndexed if the product has not been indexed by the worker yet.
func GetCatalogSearchDocument(ctx context.Context, db tenantdb.TxBeginner, workspaceID, productID string) (*CatalogSearchDocument, error) {
	if db == nil {
		return nil, errors.New("outbox: database beginner is nil")
	}
	if !tenantdb.IsValidNonZeroUUID(workspaceID) || !tenantdb.IsValidNonZeroUUID(productID) {
		return nil, tenantdb.ErrInvalidTenantScope
	}
	tx, err := appUserRoleBeginner{db: db}.Begin(ctx)
	if err != nil {
		return nil, err
	}
	defer func() { _ = tx.Rollback(ctx) }()

	if _, err := tx.Exec(ctx, `SELECT set_config('app.current_tenant_id', $1, true)`, workspaceID); err != nil {
		return nil, err
	}
	return getIndexedProductDocumentTx(ctx, tx, workspaceID, productID)
}

// SearchCatalogProducts queries the durable catalog search index for workspaceID under PostgreSQL
// tenant RLS (ROLE app_user, app.current_tenant_id = workspaceID), applying full-text/token search,
// filterable attributes (catalog_status, product_type, category, in_stock), and sorting.
func SearchCatalogProducts(ctx context.Context, db tenantdb.TxBeginner, workspaceID string, query CatalogSearchQuery) ([]CatalogSearchDocument, error) {
	if db == nil {
		return nil, errors.New("outbox: database beginner is nil")
	}
	if !tenantdb.IsValidNonZeroUUID(workspaceID) {
		return nil, tenantdb.ErrInvalidTenantScope
	}
	tx, err := appUserRoleBeginner{db: db}.Begin(ctx)
	if err != nil {
		return nil, err
	}
	defer func() { _ = tx.Rollback(ctx) }()

	if _, err := tx.Exec(ctx, `SELECT set_config('app.current_tenant_id', $1, true)`, workspaceID); err != nil {
		return nil, err
	}

	rows, err := tx.Query(ctx, `
		SELECT metadata->'search_index'
		FROM products
		WHERE workspace_id = $1::uuid
		  AND deleted_at IS NULL
		  AND metadata ? 'search_index'
	`, workspaceID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	qTokens, _ := buildSearchTokens(query.Query)
	wantStatus := strings.ToLower(strings.TrimSpace(query.CatalogStatus))
	wantType := strings.ToLower(strings.TrimSpace(query.ProductType))
	wantCategory := strings.ToLower(strings.TrimSpace(query.Category))

	var results []CatalogSearchDocument
	for rows.Next() {
		var rawDoc []byte
		if err := rows.Scan(&rawDoc); err != nil {
			return nil, err
		}
		if len(rawDoc) == 0 || string(rawDoc) == "null" {
			continue
		}
		var doc CatalogSearchDocument
		if err := json.Unmarshal(rawDoc, &doc); err != nil {
			continue
		}
		if doc.WorkspaceID != workspaceID || doc.ProductID == "" {
			continue
		}
		if wantStatus != "" && strings.ToLower(doc.CatalogStatus) != wantStatus {
			continue
		}
		if wantType != "" && strings.ToLower(doc.ProductType) != wantType {
			continue
		}
		if wantCategory != "" && strings.ToLower(doc.Category) != wantCategory {
			continue
		}
		if query.InStockOnly && !doc.InStock {
			continue
		}
		if len(qTokens) > 0 {
			haystack := strings.ToLower(doc.SearchableText)
			matchedAll := true
			for _, qt := range qTokens {
				if !strings.Contains(haystack, qt) {
					matchedAll = false
					break
				}
			}
			if !matchedAll {
				continue
			}
		}
		results = append(results, doc)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}

	sort.Slice(results, func(i, j int) bool {
		switch strings.ToLower(strings.TrimSpace(query.SortBy)) {
		case "created_at_asc":
			if !results[i].ProductCreatedAt.Equal(results[j].ProductCreatedAt) {
				return results[i].ProductCreatedAt.Before(results[j].ProductCreatedAt)
			}
			return results[i].ProductID < results[j].ProductID
		case "base_price_asc":
			di, errI := tenantdb.ParseExactDecimal(results[i].BasePrice)
			dj, errJ := tenantdb.ParseExactDecimal(results[j].BasePrice)
			if errI == nil && errJ == nil {
				if cmp := di.Cmp(dj); cmp != 0 {
					return cmp < 0
				}
			}
			return results[i].ProductID < results[j].ProductID
		case "base_price_desc":
			di, errI := tenantdb.ParseExactDecimal(results[i].BasePrice)
			dj, errJ := tenantdb.ParseExactDecimal(results[j].BasePrice)
			if errI == nil && errJ == nil {
				if cmp := di.Cmp(dj); cmp != 0 {
					return cmp > 0
				}
			}
			return results[i].ProductID < results[j].ProductID
		default:
			if !results[i].ProductCreatedAt.Equal(results[j].ProductCreatedAt) {
				return results[i].ProductCreatedAt.After(results[j].ProductCreatedAt)
			}
			return results[i].ProductID < results[j].ProductID
		}
	})

	if query.Limit > 0 && len(results) > query.Limit {
		results = results[:query.Limit]
	}
	return results, nil
}

func (h *PgDomainActionHandler) executeCatalogSearchIndexing(ctx context.Context, q *tenantdb.Queries, msg StreamMessage) (DomainActionResult, error) {
	if !tenantdb.IsValidNonZeroUUID(msg.WorkspaceID) {
		return DomainActionResult{}, tenantdb.ErrInvalidTenantScope
	}
	tx, ok := TxFromContext(ctx)
	if !ok || tx == nil {
		return DomainActionResult{}, errors.New("outbox: executeCatalogSearchIndexing requires active pgx.Tx in context")
	}

	var payloadMap map[string]any
	if len(msg.Payload) > 0 {
		if err := json.Unmarshal(msg.Payload, &payloadMap); err != nil {
			return DomainActionResult{}, fmt.Errorf("outbox: invalid product indexing payload JSON: %w", err)
		}
		if payloadWs, ok := payloadMap["workspace_id"].(string); ok && strings.TrimSpace(payloadWs) != "" {
			if strings.TrimSpace(payloadWs) != msg.WorkspaceID {
				return DomainActionResult{}, tenantdb.ErrScopeMismatch
			}
		}
	}

	productID := strings.TrimSpace(msg.AggregateID)
	if payloadProdID, ok := payloadMap["product_id"].(string); ok && strings.TrimSpace(payloadProdID) != "" {
		payloadProdID = strings.TrimSpace(payloadProdID)
		if productID != "" && productID != payloadProdID {
			return DomainActionResult{}, fmt.Errorf("outbox: product_id payload %q mismatches aggregate_id %q", payloadProdID, productID)
		}
		productID = payloadProdID
	}
	if !tenantdb.IsValidNonZeroUUID(productID) {
		return DomainActionResult{}, tenantdb.ErrInvalidTenantScope
	}

	wsRow, err := q.GetWorkspace(ctx, msg.WorkspaceID)
	if err != nil {
		return DomainActionResult{}, fmt.Errorf("outbox: search indexing verify workspace under RLS: %w", err)
	}
	if wsRow.Status != "active" {
		return DomainActionResult{}, ErrLiveActorAuthorizationRevoked
	}

	doc, reqID, err := h.syncProductSearchIndexTx(ctx, tx, msg.WorkspaceID, productID, msg.EventID, msg.EventType)
	if err != nil {
		return DomainActionResult{}, err
	}

	resBytes, err := json.Marshal(map[string]any{
		"event_id":            msg.EventID,
		"event_type":          msg.EventType,
		"workspace_id":        msg.WorkspaceID,
		"aggregate_id":        productID,
		"product_id":          doc.ProductID,
		"provider_request_id": reqID,
		"index_document":      doc.DocumentVersion,
		"document":            doc,
		"verified":            true,
		"processed_at":        doc.IndexedAt.Format(time.RFC3339Nano),
	})
	if err != nil {
		return DomainActionResult{}, err
	}
	return DomainActionResult{
		ProviderRequestID: reqID,
		ResultPayload:     resBytes,
	}, nil
}

type inventoryStockMovedPayload struct {
	WorkspaceID  string `json:"workspace_id"`
	SkuID        string `json:"sku_id"`
	MovementID   string `json:"movement_id"`
	LocationID   string `json:"location_id"`
	MovementType string `json:"movement_type"`
	Delta        *int64 `json:"delta"`
	Quantity     *int64 `json:"quantity"`
	NewQuantity  *int64 `json:"new_quantity"`
	Reason       string `json:"reason"`
}

func (h *PgDomainActionHandler) executeInventoryStockMoved(ctx context.Context, q *tenantdb.Queries, msg StreamMessage) (DomainActionResult, error) {
	if !tenantdb.IsValidNonZeroUUID(msg.WorkspaceID) {
		return DomainActionResult{}, tenantdb.ErrInvalidTenantScope
	}
	tx, ok := TxFromContext(ctx)
	if !ok || tx == nil {
		return DomainActionResult{}, errors.New("outbox: executeInventoryStockMoved requires active pgx.Tx in context")
	}

	var p inventoryStockMovedPayload
	if len(msg.Payload) > 0 {
		if err := json.Unmarshal(msg.Payload, &p); err != nil {
			return DomainActionResult{}, fmt.Errorf("outbox: invalid inventory.stock_moved payload JSON: %w", err)
		}
	}
	if strings.TrimSpace(p.WorkspaceID) != "" && strings.TrimSpace(p.WorkspaceID) != msg.WorkspaceID {
		return DomainActionResult{}, tenantdb.ErrScopeMismatch
	}

	skuID := strings.TrimSpace(p.SkuID)
	if skuID == "" {
		skuID = strings.TrimSpace(msg.AggregateID)
	}
	if !tenantdb.IsValidNonZeroUUID(skuID) {
		return DomainActionResult{}, fmt.Errorf("%w: invalid sku_id %q", ErrInventoryMovementNotFound, skuID)
	}
	if strings.TrimSpace(msg.AggregateID) != "" && strings.TrimSpace(msg.AggregateID) != skuID {
		return DomainActionResult{}, fmt.Errorf("outbox: inventory.stock_moved sku_id %q mismatches aggregate_id %q", skuID, msg.AggregateID)
	}

	var delta int64
	switch {
	case p.Delta != nil:
		delta = *p.Delta
	case p.Quantity != nil:
		delta = *p.Quantity
	}
	if delta == 0 {
		return DomainActionResult{}, fmt.Errorf("outbox: inventory.stock_moved requires non-zero delta or quantity")
	}

	wsRow, err := q.GetWorkspace(ctx, msg.WorkspaceID)
	if err != nil {
		return DomainActionResult{}, fmt.Errorf("outbox: inventory.stock_moved verify workspace under RLS: %w", err)
	}
	if wsRow.Status != "active" {
		return DomainActionResult{}, ErrLiveActorAuthorizationRevoked
	}

	var (
		productID         string
		skuCode           string
		stockQuantity     int64
		stockReserved     int64
		lowStockThreshold int64
	)
	err = tx.QueryRow(ctx, `
		SELECT
			ps.product_id::text,
			ps.sku_code,
			COALESCE(ps.stock_quantity, 0),
			COALESCE(ps.stock_reserved, 0),
			COALESCE(ps.low_stock_threshold, 5)
		FROM product_skus ps
		JOIN products pr ON pr.workspace_id = ps.workspace_id AND pr.product_id = ps.product_id
		WHERE ps.workspace_id = $1::uuid
		  AND ps.sku_id = $2::uuid
		  AND ps.deleted_at IS NULL
		  AND pr.deleted_at IS NULL
		FOR UPDATE OF ps
	`, msg.WorkspaceID, skuID).Scan(
		&productID,
		&skuCode,
		&stockQuantity,
		&stockReserved,
		&lowStockThreshold,
	)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return DomainActionResult{}, fmt.Errorf("%w: sku_id=%s workspace_id=%s", ErrInventoryMovementNotFound, skuID, msg.WorkspaceID)
		}
		return DomainActionResult{}, fmt.Errorf("outbox: verify sku in product_skus: %w", err)
	}

	var (
		movementID   string
		locationID   string
		movementType string
		ledgerQty    int64
		ledgerReason string
	)
	wantMovementID := strings.TrimSpace(p.MovementID)
	if wantMovementID != "" && !tenantdb.IsValidNonZeroUUID(wantMovementID) {
		return DomainActionResult{}, fmt.Errorf("%w: invalid movement_id %q", ErrInventoryMovementNotFound, wantMovementID)
	}
	err = tx.QueryRow(ctx, `
		SELECT
			movement_id::text,
			location_id::text,
			movement_type,
			quantity,
			COALESCE(reason, '')
		FROM stock_movements
		WHERE workspace_id = $1::uuid
		  AND sku_id = $2::uuid
		  AND ($3 = '' OR movement_id = NULLIF($3, '')::uuid)
		ORDER BY created_at DESC, movement_id DESC
		LIMIT 1
	`, msg.WorkspaceID, skuID, wantMovementID).Scan(
		&movementID,
		&locationID,
		&movementType,
		&ledgerQty,
		&ledgerReason,
	)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return DomainActionResult{}, fmt.Errorf("%w: no committed stock_movements ledger row for sku_id=%s workspace_id=%s", ErrInventoryMovementNotFound, skuID, msg.WorkspaceID)
		}
		return DomainActionResult{}, fmt.Errorf("outbox: verify stock_movements ledger row: %w", err)
	}

	// Synchronize and verify the parent product's durable catalog search index projection
	// so SKU stock changes are immediately reflected in catalog search results.
	doc, _, err := h.syncProductSearchIndexTx(ctx, tx, msg.WorkspaceID, productID, msg.EventID, msg.EventType)
	if err != nil {
		return DomainActionResult{}, err
	}

	availableQty := stockQuantity - stockReserved
	lowStockAlert := availableQty <= lowStockThreshold
	reqID := fmt.Sprintf("stock_move_%s_%s", movementID[:8], msg.EventID[:8])

	resBytes, err := json.Marshal(map[string]any{
		"event_id":             msg.EventID,
		"event_type":           msg.EventType,
		"workspace_id":         msg.WorkspaceID,
		"product_id":           productID,
		"sku_id":               skuID,
		"sku_code":             skuCode,
		"movement_id":          movementID,
		"location_id":          locationID,
		"movement_type":        movementType,
		"delta":                delta,
		"ledger_quantity":      ledgerQty,
		"reason":               nonEmpty(strings.TrimSpace(p.Reason), ledgerReason),
		"stock_quantity":       stockQuantity,
		"stock_reserved":       stockReserved,
		"available_quantity":   availableQty,
		"low_stock_alert":      lowStockAlert,
		"search_index_version": doc.DocumentVersion,
		"search_index_synced":  true,
		"processed_at":         time.Now().UTC().Format(time.RFC3339Nano),
	})
	if err != nil {
		return DomainActionResult{}, err
	}
	return DomainActionResult{
		ProviderRequestID: reqID,
		ResultPayload:     resBytes,
	}, nil
}

// Handle processes a StreamMessage inside the active PgConsumerInboxEngine transaction.
func (h *PgDomainActionHandler) Handle(ctx context.Context, msg StreamMessage) error {
	q, ok := QueriesFromContext(ctx)
	if !ok || q == nil {
		return errors.New("outbox: PgDomainActionHandler requires active tenantdb.Queries in context")
	}

	var spec domainPayloadSpec
	if len(msg.Payload) > 0 {
		_ = json.Unmarshal(msg.Payload, &spec)
	}

	aggID := msg.AggregateID
	if !tenantdb.IsValidNonZeroUUID(aggID) {
		aggID = msg.EventID
	}
	aggType := nonEmpty(msg.AggregateType, "domain_aggregate")

	// Enforce the durable external_effects state machine for every domain action.
	opKey := strings.TrimSpace(spec.OperationKey)
	if opKey == "" && strings.TrimSpace(spec.Provider) != "" {
		opKey = fmt.Sprintf("%s:%s:%s", msg.TargetStream, spec.Provider, aggID)
	}
	if opKey == "" {
		opKey = fmt.Sprintf("worker:%s:%s:%s:%s", msg.EventType, aggType, aggID, msg.EventID)
	}

	provider := nonEmpty(strings.TrimSpace(spec.Provider), "internal_worker")
	existing, exists, err := q.GetExternalEffectForUpdate(ctx, msg.WorkspaceID, opKey)
	if err != nil {
		return err
	}
	if exists {
		switch ExternalEffectStatus(existing.Status) {
		case EffectStatusSucceeded:
			return nil
		case EffectStatusUnknown, EffectStatusSubmitted:
			return fmt.Errorf("%w: operation_key=%s status=%s", ErrExternalOutcomeUnresolved, opKey, existing.Status)
		}
	}

	executor := h.resolveExecutor(msg.TargetStream, msg.EventType, provider)
	if executor == nil {
		return fmt.Errorf(
			"%w: stream=%s event_type=%s provider=%s",
			ErrNoDomainExecutorRegistered,
			msg.TargetStream,
			msg.EventType,
			provider,
		)
	}

	if !exists {
		effectID := newDeterministicUUID("effect:" + msg.WorkspaceID + ":" + opKey)
		if _, err := q.InsertPreparedExternalEffect(ctx, tenantdb.PrepareExternalEffectParams{
			EffectID:           effectID,
			WorkspaceID:        msg.WorkspaceID,
			OperationKey:       opKey,
			Provider:           provider,
			ConnectedAccountID: spec.ConnectedAccountID,
			AggregateType:      aggType,
			AggregateID:        aggID,
		}); err != nil {
			return err
		}
	}

	execRes, execErr := executor(ctx, q, msg)
	if execErr != nil {
		return execErr
	}

	providerReqID := strings.TrimSpace(execRes.ProviderRequestID)
	if providerReqID == "" {
		providerReqID = strings.TrimSpace(spec.ProviderRequestID)
	}
	if providerReqID == "" {
		return errors.New("outbox: domain executor returned empty provider_request_id")
	}
	resultPayload := execRes.ResultPayload
	if len(resultPayload) == 0 {
		resultPayload, _ = json.Marshal(map[string]any{
			"event_id":     msg.EventID,
			"event_type":   msg.EventType,
			"processed_at": time.Now().UTC().Format(time.RFC3339Nano),
		})
	}

	if _, err := q.UpdateExternalEffectStatus(ctx, tenantdb.UpdateExternalEffectStatusParams{
		WorkspaceID:       msg.WorkspaceID,
		OperationKey:      opKey,
		Status:            string(EffectStatusSucceeded),
		ProviderRequestID: providerReqID,
		ResultPayload:     resultPayload,
	}); err != nil {
		return err
	}

	// Persist a resolved domain execution diagnostic record so every processed domain event leaves
	// a verifiable tenant-scoped domain artifact in PostgreSQL alongside consumer_inbox and audit_events.
	diagID := newDeterministicUUID("diag:processed:" + msg.WorkspaceID + ":" + msg.EventID)
	_, err = q.InsertDiagnosticRecord(ctx, tenantdb.InsertDiagnosticRecordParams{
		DiagnosticsID:         diagID,
		WorkspaceID:           msg.WorkspaceID,
		ScopeType:             aggType,
		ScopeID:               aggID,
		ErrorType:             "domain_event_processed:" + msg.EventType,
		Severity:              "info",
		UserFacingExplanation: "Tác vụ nền đã được xử lý và đồng bộ hoàn tất.",
		OperatorExplanation:   fmt.Sprintf("Processed event %s (%s) on stream %s", msg.EventID, msg.EventType, msg.TargetStream),
		LikelyCauses:          []string{"Chu trình xử lý sự kiện chuẩn"},
		SuggestedActions:      []string{"Không cần thao tác thêm"},
		RepairPath:            "none",
		Status:                "resolved",
	})
	return err
}
