package outbox

import (
	"context"
	"encoding/json"
	"errors"
	"sync"
	"sync/atomic"
	"testing"
	"time"
)

const (
	testWorkspaceA = "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa"
	testWorkspaceB = "bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb"
	testUserA      = "11111111-1111-4111-8111-111111111111"
	testEvent1     = "e1111111-1111-4111-8111-111111111111"
	testEvent2     = "e2222222-2222-4222-8222-222222222222"
	testAgg1       = "a1111111-1111-4111-8111-111111111111"
	testDiag1      = "d1111111-1111-4111-8111-111111111111"
)

func TestCanonicalQueueSpecsAndErrorClassification(t *testing.T) {
	specs := AllQueueSpecs()
	if len(specs) != 11 {
		t.Fatalf("expected 11 canonical queues, got %d", len(specs))
	}

	wh, ok := GetQueueSpec(QueueWebhookDelivery)
	if !ok {
		t.Fatalf("missing webhook_delivery queue spec")
	}
	if wh.MaxRetries != 3 || wh.ConsecutiveFailSuspend != 100 {
		t.Fatalf("unexpected webhook_delivery retry spec: %+v", wh)
	}
	d1, ok1 := wh.NextBackoff(1)
	d2, ok2 := wh.NextBackoff(2)
	d3, ok3 := wh.NextBackoff(3)
	_, ok4 := wh.NextBackoff(4)
	if !ok1 || !ok2 || !ok3 || ok4 || d1 != 1*time.Second || d2 != 10*time.Second || d3 != 60*time.Second {
		t.Fatalf("expected S24 backoff 1s/10s/60s, got %v %v %v (ok4=%v)", d1, d2, d3, ok4)
	}

	// Provider timeout must NEVER allow blind retry.
	timeoutClass := ClassifyError(ErrorClassProviderTimeout)
	if timeoutClass.AllowBlindRetry || !timeoutClass.RequiresStatusCk || timeoutClass.Action != RetryActionVerifyStatusFirst {
		t.Fatalf("provider_timeout must forbid blind retry and require status check: %+v", timeoutClass)
	}

	// Priority weights 8 : 4 : 2 : 1.
	if PriorityUrgent.Weight() != 8 || PriorityHigh.Weight() != 4 || PriorityNormal.Weight() != 2 || PriorityLow.Weight() != 1 {
		t.Fatalf("unexpected priority weights")
	}
}

func TestValidateOutboxEnvelopeRejectsCredentialLeaks(t *testing.T) {
	validEnv := DomainEventEnvelope{
		EventID:       testEvent1,
		EventType:     "publish.scheduled",
		TargetStream:  QueuePublishJobs,
		AggregateType: "publish_job",
		AggregateID:   testAgg1,
		WorkspaceID:   testWorkspaceA,
		Payload:       json.RawMessage(`{"publish_job_id":"a1111111-1111-4111-8111-111111111111","platform":"tiktok"}`),
	}
	if err := ValidateOutboxEnvelope(validEnv); err != nil {
		t.Fatalf("expected valid envelope to pass, got %v", err)
	}

	leaked := validEnv
	leaked.Payload = json.RawMessage(`{"platform":"tiktok","nested":{"access_token":"secret_oauth_token"}}`)
	if err := ValidateOutboxEnvelope(leaked); !errors.Is(err, ErrCredentialLeakBlocked) {
		t.Fatalf("expected ErrCredentialLeakBlocked for access_token in payload, got %v", err)
	}
}

func TestKillBeforeAndAfterOutboxLeaseAndConsumerCommitAndAck(t *testing.T) {
	ctx := context.Background()
	t0 := time.Date(2026, 11, 2, 6, 0, 0, 0, time.UTC)

	store := NewMemoryOutboxStore()
	broker := NewMemoryStreamBroker()
	inboxEngine := NewMemoryConsumerInboxEngine()

	_, err := store.Enqueue(DomainEventEnvelope{
		EventID:       testEvent1,
		EventType:     "publish.scheduled",
		TargetStream:  QueuePublishJobs,
		AggregateType: "publish_job",
		AggregateID:   testAgg1,
		WorkspaceID:   testWorkspaceA,
		Payload:       json.RawMessage(`{"title":"Launch video"}`),
	}, t0)
	if err != nil {
		t.Fatalf("Enqueue failed: %v", err)
	}

	// 1. Outbox Poller A claims 30s lease, then is killed BEFORE XADD.
	pollerA := NewOutboxPoller("poller-a", store, broker)
	pollerA.Faults.AfterClaimBeforePublish = func(row OutboxRow) error {
		return errors.New("simulated SIGKILL after lease commit before XADD")
	}
	if _, err := pollerA.PollOnce(ctx, t0); err == nil {
		t.Fatalf("expected simulated crash error on poller-a")
	}

	// At t0 + 10s (within 30s lease window), Poller B must NOT steal the active lease.
	pollerB := NewOutboxPoller("poller-b", store, broker)
	resEarly, err := pollerB.PollOnce(ctx, t0.Add(10*time.Second))
	if err != nil {
		t.Fatalf("pollerB early poll failed: %v", err)
	}
	if resEarly.ClaimedCount != 0 {
		t.Fatalf("expected 0 claimed while poller-a lease is active, got %d", resEarly.ClaimedCount)
	}

	// 2. At t0 + 31s (lease expired), Poller B claims the row, calls XADD, then crashes BEFORE MarkPublished!
	pollerB.Faults.AfterPublishBeforeMarkSaved = func(row OutboxRow, streamEntryID string) error {
		return errors.New("simulated SIGKILL after XADD before MarkPublished")
	}
	if _, err := pollerB.PollOnce(ctx, t0.Add(31*time.Second)); err == nil {
		t.Fatalf("expected simulated crash error on poller-b after XADD")
	}
	// If stale Poller A wakes up and attempts to MarkPublished on outbox_id=1, it must be rejected!
	if err := store.MarkPublished(ctx, 1, "poller-a", t0.Add(32*time.Second)); !errors.Is(err, ErrStaleOutboxLease) {
		t.Fatalf("expected ErrStaleOutboxLease for stale poller-a, got %v", err)
	}

	// 3. At t0 + 62s (second lease expired), Poller B recovers cleanly, calls XADD again (producing a 2nd stream entry with the SAME EventID), and marks published.
	pollerB.Faults.AfterPublishBeforeMarkSaved = nil
	resRecovered, err := pollerB.PollOnce(ctx, t0.Add(62*time.Second))
	if err != nil {
		t.Fatalf("pollerB recovery PollOnce failed: %v", err)
	}
	if resRecovered.PublishedCount != 1 {
		t.Fatalf("expected 1 published row on recovery, got %+v", resRecovered)
	}

	// Verify outbox row is now published with attempt_count == 3.
	snap := store.Snapshot()
	if len(snap) != 1 || !snap[0].Published || snap[0].AttemptCount != 3 {
		t.Fatalf("expected published=true and attempt_count=3, got %+v", snap[0])
	}

	// 4. Consumer Worker 1 reads message #1 from stream, then is killed BEFORE DB commit!
	var domainEffectCount int32
	worker1 := NewConsumerWorker(QueuePublishJobs, "cg_publish", "worker-1", broker, inboxEngine)
	worker1.Faults.BeforeTxCommit = func(msg StreamMessage) error {
		return errors.New("simulated SIGKILL before consumer DB commit")
	}
	_, err = worker1.ProcessNext(ctx, t0.Add(63*time.Second), 1, func(ctx context.Context, msg StreamMessage) error {
		return nil
	})
	if err == nil {
		t.Fatalf("expected simulated crash before consumer DB commit")
	}
	if broker.PendingCount(QueuePublishJobs, "cg_publish") != 1 {
		t.Fatalf("expected 1 unacknowledged message in PEL after crash before commit")
	}

	// 5. At t0 + 125s (>60s PEL idle timeout), Worker 2 reclaims message #1 via XAUTOCLAIM,
	// commits the DB transaction (recording consumer_inbox + domain effect), and is killed BEFORE XACK!
	worker2 := NewConsumerWorker(QueuePublishJobs, "cg_publish", "worker-2", broker, inboxEngine)
	worker2.Faults.AfterTxCommitBeforeAck = func(msg StreamMessage) error {
		return errors.New("simulated SIGKILL after consumer DB commit before XACK")
	}
	outcomes, err := worker2.ProcessNext(ctx, t0.Add(125*time.Second), 1, func(ctx context.Context, msg StreamMessage) error {
		atomic.AddInt32(&domainEffectCount, 1)
		return nil
	})
	if err == nil {
		t.Fatalf("expected simulated crash after DB commit before XACK")
	}
	if len(outcomes) != 1 || !outcomes[0].Executed || outcomes[0].Acked {
		t.Fatalf("expected Executed=true, Acked=false on crash before XACK, got %+v", outcomes)
	}
	if atomic.LoadInt32(&domainEffectCount) != 1 {
		t.Fatalf("expected domainEffectCount == 1 after committed tx, got %d", domainEffectCount)
	}

	// 6. At t0 + 190s (>60s PEL idle timeout), Worker 3 runs XAUTOCLAIM + XREADGROUP:
	// - Reclaimed message #1 is deduplicated by consumer_inbox and ACKed without re-running handler
	// - Duplicate stream entry #2 (from Poller B's earlier crash after XADD) is ALSO deduplicated by consumer_inbox and ACKed!
	worker3 := NewConsumerWorker(QueuePublishJobs, "cg_publish", "worker-3", broker, inboxEngine)
	finalOutcomes, err := worker3.ProcessNext(ctx, t0.Add(190*time.Second), 10, func(ctx context.Context, msg StreamMessage) error {
		atomic.AddInt32(&domainEffectCount, 1)
		return nil
	})
	if err != nil {
		t.Fatalf("worker3 ProcessNext failed: %v", err)
	}
	if len(finalOutcomes) != 2 {
		t.Fatalf("expected 2 messages processed (1 reclaimed + 1 duplicate stream entry), got %d", len(finalOutcomes))
	}
	for i, o := range finalOutcomes {
		if o.Executed || !o.Deduplicated || !o.Acked {
			t.Fatalf("outcome[%d] expected Executed=false, Deduplicated=true, Acked=true, got %+v", i, o)
		}
	}
	if broker.PendingCount(QueuePublishJobs, "cg_publish") != 0 {
		t.Fatalf("expected 0 pending messages in PEL after recovery ACK, got %d", broker.PendingCount(QueuePublishJobs, "cg_publish"))
	}
	if got := atomic.LoadInt32(&domainEffectCount); got != 1 {
		t.Fatalf("ACCEPTANCE TARGET 1 VIOLATION: expected domain side effect count == 1 across all kills/recoveries, got %d", got)
	}
}

func TestDuplicateWebhookHasStrictlyOneEffect(t *testing.T) {
	ctx := context.Background()
	proc := NewWebhookProcessor()
	now := time.Date(2026, 11, 2, 6, 10, 0, 0, time.UTC)

	var orderMutations int32
	const deliveries = 20
	var wg sync.WaitGroup
	results := make([]InboundWebhookResult, deliveries)
	errs := make([]error, deliveries)

	req := InboundWebhookRequest{
		WebhookEventID:  "77777777-7777-4777-8777-777777777777",
		WorkspaceID:     testWorkspaceA,
		Provider:        "tiktok_shop",
		ExternalEventID: "tts_evt_999888",
		IdempotencyKey:  "tiktok_shop:tts_evt_999888",
		ConsumerName:    "commerce_order_sync",
		EventID:         testEvent1,
		Payload:         json.RawMessage(`{"order_id":"o_1","status":"paid","amount":"250000.00"}`),
		ReceivedAt:      now,
	}

	for i := 0; i < deliveries; i++ {
		wg.Add(1)
		go func(idx int) {
			defer wg.Done()
			results[idx], errs[idx] = proc.ProcessInboundWebhook(ctx, req, func(ctx context.Context, r InboundWebhookRequest) error {
				atomic.AddInt32(&orderMutations, 1)
				return nil
			})
		}(i)
	}
	wg.Wait()

	processedCount := 0
	dedupCount := 0
	for i := 0; i < deliveries; i++ {
		if errs[i] != nil {
			t.Fatalf("delivery %d returned unexpected error: %v", i, errs[i])
		}
		if results[i].Processed {
			processedCount++
		}
		if results[i].Deduplicated {
			dedupCount++
		}
	}

	if processedCount != 1 || dedupCount != deliveries-1 {
		t.Fatalf("expected 1 processed and %d deduplicated, got processed=%d deduplicated=%d",
			deliveries-1, processedCount, dedupCount)
	}
	if got := atomic.LoadInt32(&orderMutations); got != 1 {
		t.Fatalf("ACCEPTANCE TARGET 2 VIOLATION: duplicate webhook mutated state %d times, want 1", got)
	}
	if got := proc.EffectCount("tiktok_shop", "tiktok_shop:tts_evt_999888"); got != 1 {
		t.Fatalf("expected recorded EffectCount == 1, got %d", got)
	}
}

func TestOutboundWebhookSanitizationSigningAndAutoSuspension(t *testing.T) {
	now := time.Date(2026, 11, 2, 6, 15, 0, 0, time.UTC)

	// Ineligible event type is rejected.
	if _, err := SanitizeOutboundWebhookPayload("internal.secret_event", json.RawMessage(`{}`)); !errors.Is(err, ErrIneligibleOutboundWebhookEvent) {
		t.Fatalf("expected ErrIneligibleOutboundWebhookEvent, got %v", err)
	}

	// Eligible event strips internal cost/operator fields.
	cleaned, err := SanitizeOutboundWebhookPayload(
		"order.created",
		json.RawMessage(`{"order_id":"ord_1","total_amount":"199000.00","actual_cost_usd":"0.12","platform_margin":"0.35","operator_explanation":"raw sql trace"}`),
	)
	if err != nil {
		t.Fatalf("SanitizeOutboundWebhookPayload failed: %v", err)
	}
	var parsed map[string]any
	if err := json.Unmarshal(cleaned, &parsed); err != nil {
		t.Fatal(err)
	}
	if _, bad := parsed["actual_cost_usd"]; bad {
		t.Fatalf("internal field actual_cost_usd leaked in outbound webhook")
	}
	if _, bad := parsed["platform_margin"]; bad {
		t.Fatalf("internal field platform_margin leaked in outbound webhook")
	}
	if _, bad := parsed["operator_explanation"]; bad {
		t.Fatalf("internal field operator_explanation leaked in outbound webhook")
	}
	if parsed["total_amount"] != "199000.00" {
		t.Fatalf("expected total_amount preserved, got %v", parsed["total_amount"])
	}

	sig := SignOutboundWebhookPayload("whsec_test_secret", now, cleaned)
	if len(sig) != len("sha256=")+64 {
		t.Fatalf("expected sha256=<64 hex chars>, got %q", sig)
	}

	// 100 consecutive failures auto-suspend the subscription (RULE-S24-05).
	sub := &WebhookSubscription{
		SubscriptionID: "sub_1",
		WorkspaceID:    testWorkspaceA,
		TargetURL:      "https://partner.example.com/webhooks",
		Status:         "active",
	}
	for i := 1; i <= 99; i++ {
		if suspended := RecordSubscriptionDeliveryOutcome(sub, false, "HTTP 502 Bad Gateway", now); suspended {
			t.Fatalf("should not auto-suspend at failure #%d", i)
		}
	}
	if suspended := RecordSubscriptionDeliveryOutcome(sub, false, "HTTP 502 Bad Gateway", now); !suspended || sub.Status != "suspended" {
		t.Fatalf("expected subscription auto-suspended at 100th consecutive failure, got status=%s", sub.Status)
	}
}

func TestUnresolvedExternalEffectNeverBlindlyRetried(t *testing.T) {
	ctx := context.Background()
	now := time.Date(2026, 11, 2, 6, 20, 0, 0, time.UTC)
	guard := NewExternalEffectGuard()
	dlq := NewDLQManager(guard)
	broker := NewMemoryStreamBroker()

	const opKey = "publish:tiktok:item_a1111111:v1"
	var providerCalls int32

	// Step 1: BeginExecution prepares the effect ('prepared') and allows execution.
	dec, rec, err := guard.BeginExecution(ctx, BeginEffectRequest{
		EffectID:      testEvent1,
		WorkspaceID:   testWorkspaceA,
		OperationKey:  opKey,
		Provider:      "tiktok",
		AggregateType: "publish_job",
		AggregateID:   testAgg1,
		Now:           now,
	})
	if err != nil || dec != DecisionProceed || rec.Status != EffectStatusPrepared {
		t.Fatalf("expected DecisionProceed & status=prepared, got dec=%s status=%s err=%v", dec, rec.Status, err)
	}

	// Step 2: Worker marks effect 'submitted' right as it sends the HTTP request to TikTok, then times out!
	if _, err := guard.MarkSubmitted(ctx, testWorkspaceA, opKey, "tt_req_001", now.Add(1*time.Second)); err != nil {
		t.Fatalf("MarkSubmitted failed: %v", err)
	}
	atomic.AddInt32(&providerCalls, 1)

	// Step 3: Provider call times out -> worker transitions effect to 'unknown' and records M23 diagnostic issue.
	unkRec, diag, err := guard.MarkUnknownOnTimeout(ctx, testWorkspaceA, opKey, testDiag1, "context deadline exceeded after 120s", now.Add(121*time.Second))
	if err != nil {
		t.Fatalf("MarkUnknownOnTimeout failed: %v", err)
	}
	if unkRec.Status != EffectStatusUnknown {
		t.Fatalf("expected status=unknown after timeout, got %s", unkRec.Status)
	}
	if diag.Status != "open" || diag.ErrorType != "external_effect_outcome_unknown" {
		t.Fatalf("expected open diagnostic record for unknown external effect, got %+v", diag)
	}

	// Step 4: Repeated automatic retry attempts MUST be blocked with ErrExternalOutcomeUnresolved!
	for attempt := 1; attempt <= 3; attempt++ {
		retryDec, _, retryErr := guard.BeginExecution(ctx, BeginEffectRequest{
			EffectID:      testEvent1,
			WorkspaceID:   testWorkspaceA,
			OperationKey:  opKey,
			Provider:      "tiktok",
			AggregateType: "publish_job",
			AggregateID:   testAgg1,
			Now:           now.Add(time.Duration(130+attempt*10) * time.Second),
		})
		if !errors.Is(retryErr, ErrExternalOutcomeUnresolved) || retryDec != DecisionBlockedRequiresReconciliation {
			t.Fatalf("attempt %d: expected ErrExternalOutcomeUnresolved, got dec=%s err=%v", attempt, retryDec, retryErr)
		}
	}
	if got := atomic.LoadInt32(&providerCalls); got != 1 {
		t.Fatalf("ACCEPTANCE TARGET 3 VIOLATION: provider was called %d times while effect was unknown", got)
	}

	// Step 5: Even if the job is in DLQ, manual ReplayDLQItem MUST refuse to replay while status is 'unknown'!
	_, err = dlq.EnqueueDLQ(DLQItem{
		DLQID:             "dlq_unknown_1",
		QueueName:         QueuePublishJobs,
		OriginalMessageID: "1-1",
		EventID:           testEvent1,
		OperationKey:      opKey,
		WorkspaceID:       testWorkspaceA,
		Payload:           json.RawMessage(`{"publish_job_id":"a1111111-1111-4111-8111-111111111111"}`),
		ErrorClass:        ErrorClassProviderTimeout,
		ErrorMessage:      "provider timeout; external outcome unknown",
		LastErrorAt:       now.Add(121 * time.Second),
		AttemptCount:      1,
		CreatedAt:         now.Add(121 * time.Second),
	})
	if err != nil {
		t.Fatalf("EnqueueDLQ failed: %v", err)
	}
	if _, err := dlq.ReplayDLQItem(ctx, "dlq_unknown_1", broker, now.Add(200*time.Second)); !errors.Is(err, ErrExternalOutcomeUnresolved) {
		t.Fatalf("expected DLQ replay to be blocked while external effect is unknown, got %v", err)
	}

	// Step 6: OPS-2026-02 retention protection must NEVER purge a DLQ item with an unresolved 'unknown' external effect even after 40 days!
	purged, protected := dlq.PurgeExpiredItems(now.Add(40 * 24 * time.Hour))
	if purged != 0 || protected != 1 {
		t.Fatalf("expected OPS-2026-02 to protect unresolved external effect DLQ item, got purged=%d protected=%d", purged, protected)
	}

	// Step 7: Reconciling without proof fails closed.
	if _, err := guard.ReconcileUnknownEffect(ctx, ReconcileRequest{
		WorkspaceID:  testWorkspaceA,
		OperationKey: opKey,
		ActorID:      testUserA,
		Mode:         ReconcileConfirmedSucceeded,
	}); !errors.Is(err, ErrReconciliationProofRequired) {
		t.Fatalf("expected ErrReconciliationProofRequired when proof is empty, got %v", err)
	}

	// Step 8: Reconciling with authoritative provider proof ('confirmed_succeeded') resolves the effect AND prevents any duplicate provider call on subsequent replay!
	reconciled, err := guard.ReconcileUnknownEffect(ctx, ReconcileRequest{
		WorkspaceID:           testWorkspaceA,
		OperationKey:          opKey,
		ActorID:               testUserA,
		Mode:                  ReconcileConfirmedSucceeded,
		ProviderRequestID:     "tt_post_888777",
		VerificationReference: "verified_via_tiktok_post_lookup:tt_post_888777",
		ResultPayload:         json.RawMessage(`{"platform_post_id":"tt_post_888777"}`),
		Now:                   now.Add(300 * time.Second),
	})
	if err != nil || reconciled.Status != EffectStatusSucceeded {
		t.Fatalf("expected reconciled status=succeeded, got %+v err=%v", reconciled, err)
	}

	postRecDec, postRecEffect, err := guard.BeginExecution(ctx, BeginEffectRequest{
		EffectID:      testEvent1,
		WorkspaceID:   testWorkspaceA,
		OperationKey:  opKey,
		Provider:      "tiktok",
		AggregateType: "publish_job",
		AggregateID:   testAgg1,
		Now:           now.Add(310 * time.Second),
	})
	if err != nil || postRecDec != DecisionAlreadySucceeded {
		t.Fatalf("expected DecisionAlreadySucceeded after reconciliation, got dec=%s err=%v", postRecDec, err)
	}
	if string(postRecEffect.ResultPayload) != `{"platform_post_id":"tt_post_888777"}` {
		t.Fatalf("expected cached ResultPayload returned, got %s", string(postRecEffect.ResultPayload))
	}
	if got := atomic.LoadInt32(&providerCalls); got != 1 {
		t.Fatalf("expected providerCalls to remain 1 after reconciliation, got %d", got)
	}
}

type fakeAuthVerifier struct {
	revoked bool
}

func (f *fakeAuthVerifier) VerifyActorAndApproval(_ context.Context, _, _, _, _ string, _ time.Time) error {
	if f.revoked {
		return ErrLiveActorAuthorizationRevoked
	}
	return nil
}

func TestConsumerLiveAuthRevocationAbortsQueuedEffectAndAudits(t *testing.T) {
	ctx := context.Background()
	now := time.Date(2026, 11, 2, 6, 30, 0, 0, time.UTC)
	broker := NewMemoryStreamBroker()
	inbox := NewMemoryConsumerInboxEngine()

	_, err := broker.XAdd(ctx, QueuePublishJobs, StreamMessage{
		EventID:       testEvent2,
		EventType:     "publish.scheduled",
		TargetStream:  QueuePublishJobs,
		AggregateType: "publish_job",
		AggregateID:   testAgg1,
		WorkspaceID:   testWorkspaceA,
		ActorID:       testUserA,
		ActorType:     "user",
		RequiredPerm:  "publish:execute",
		Payload:       json.RawMessage(`{}`),
		PublishedAt:   now,
	})
	if err != nil {
		t.Fatal(err)
	}

	worker := NewConsumerWorker(QueuePublishJobs, "cg_publish", "worker-auth", broker, inbox)
	worker.AuthVerifier = &fakeAuthVerifier{revoked: true}

	called := false
	outcomes, err := worker.ProcessNext(ctx, now.Add(5*time.Second), 5, func(ctx context.Context, msg StreamMessage) error {
		called = true
		return nil
	})
	if err != nil {
		t.Fatalf("ProcessNext failed: %v", err)
	}
	if called {
		t.Fatalf("expected handler NOT to be called when live actor authorization was revoked")
	}
	if len(outcomes) != 1 || !outcomes[0].AbortedAuth || !outcomes[0].Acked {
		t.Fatalf("expected AbortedAuth=true and Acked=true, got %+v", outcomes)
	}
	audits := inbox.AuditEntries()
	if len(audits) != 1 || audits[0].Action != "consumer.aborted:publish.scheduled" {
		t.Fatalf("expected aborted audit event recorded, got %+v", audits)
	}
}

func TestCircuitBreakerAndFairWorkspaceScheduler(t *testing.T) {
	t0 := time.Date(2026, 11, 2, 6, 40, 0, 0, time.UTC)
	cb := NewCircuitBreaker("runway_gen3")

	for i := 0; i < 5; i++ {
		if err := cb.Allow(t0.Add(time.Duration(i) * time.Second)); err != nil {
			t.Fatalf("expected Allow before threshold at i=%d: %v", i, err)
		}
		cb.RecordFailure(t0.Add(time.Duration(i) * time.Second))
	}
	if cb.State(t0.Add(5*time.Second)) != CircuitOpen {
		t.Fatalf("expected CircuitOpen after 5 failures in 60s, got %s", cb.State(t0.Add(5*time.Second)))
	}
	if err := cb.Allow(t0.Add(10 * time.Second)); !errors.Is(err, ErrCircuitOpen) {
		t.Fatalf("expected ErrCircuitOpen while open, got %v", err)
	}

	// After 30s open duration, transitions to HalfOpen and permits 1 probe request.
	tProbe := t0.Add(35 * time.Second)
	if cb.State(tProbe) != CircuitHalfOpen {
		t.Fatalf("expected CircuitHalfOpen after 30s, got %s", cb.State(tProbe))
	}
	if err := cb.Allow(tProbe); err != nil {
		t.Fatalf("expected first probe request in HalfOpen to be allowed, got %v", err)
	}
	if err := cb.Allow(tProbe); !errors.Is(err, ErrCircuitOpen) {
		t.Fatalf("expected concurrent second probe in HalfOpen to be blocked, got %v", err)
	}
	cb.RecordSuccess(tProbe.Add(1 * time.Second))
	if cb.State(tProbe.Add(1*time.Second)) != CircuitClosed {
		t.Fatalf("expected CircuitClosed after probe success, got %s", cb.State(tProbe.Add(1*time.Second)))
	}

	// FairWorkspaceScheduler enforces MaxPerWorkspaceActive = 2 on publish_jobs.
	sched := NewFairWorkspaceScheduler()
	rel1, err := sched.Acquire(QueuePublishJobs, testWorkspaceA)
	if err != nil {
		t.Fatal(err)
	}
	rel2, err := sched.Acquire(QueuePublishJobs, testWorkspaceA)
	if err != nil {
		t.Fatal(err)
	}
	if _, err := sched.Acquire(QueuePublishJobs, testWorkspaceA); !errors.Is(err, ErrWorkspaceConcurrencyCap) {
		t.Fatalf("expected 3rd concurrent job for Workspace A on publish_jobs to hit cap, got %v", err)
	}
	// Workspace B is unaffected by Workspace A's cap!
	relB, err := sched.Acquire(QueuePublishJobs, testWorkspaceB)
	if err != nil {
		t.Fatalf("expected Workspace B to acquire slot while Workspace A is at cap: %v", err)
	}
	rel1()
	rel2()
	relB()
}
