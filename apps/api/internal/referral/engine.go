package referral

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"math/big"
	"strings"
	"sync"
	"time"
)

// Engine executes referral business logic, tier calculations, anti-fraud checks,
// and replay-safe settlement and refund reversals.
type Engine struct {
	mu    sync.RWMutex
	store Store
	clock func() time.Time

	// Anti-fraud fingerprint tracking (IPs, device fingerprints, card hashes)
	knownWorkspacesByIP     map[string]string // ipHash -> workspaceID
	knownWorkspacesByDevice map[string]string // deviceHash -> workspaceID
	knownWorkspacesByCard   map[string]string // cardHash -> workspaceID
	ipClusteringCount       map[string]int    // ipPrefix -> count
}

// NewEngine creates a new Engine backed by the given Store.
func NewEngine(store Store) *Engine {
	if store == nil {
		store = NewMemoryStore()
	}
	return &Engine{
		store:                   store,
		clock:                   func() time.Time { return time.Now().UTC() },
		knownWorkspacesByIP:     make(map[string]string),
		knownWorkspacesByDevice: make(map[string]string),
		knownWorkspacesByCard:   make(map[string]string),
		ipClusteringCount:       make(map[string]int),
	}
}

// SetClock allows test suites to inject deterministic clocks.
func (e *Engine) SetClock(clockFn func() time.Time) {
	if clockFn != nil {
		e.clock = clockFn
	}
}

// Store returns the underlying storage layer.
func (e *Engine) Store() Store {
	return e.store
}

// RegisterWorkspaceFingerprints records known entity signatures for anti-fraud comparison.
func (e *Engine) RegisterWorkspaceFingerprints(workspaceID, ip, deviceID, cardFingerprint string) {
	e.mu.Lock()
	defer e.mu.Unlock()

	if ip != "" {
		hash := hashString(ip)
		e.knownWorkspacesByIP[hash] = workspaceID
		prefix := getIPPrefix(ip)
		e.ipClusteringCount[prefix]++
	}
	if deviceID != "" {
		hash := hashString(deviceID)
		e.knownWorkspacesByDevice[hash] = workspaceID
	}
	if cardFingerprint != "" {
		hash := hashString(cardFingerprint)
		e.knownWorkspacesByCard[hash] = workspaceID
	}
}

// EvaluateFraud checks inbound referral conversion against anti-fraud rules (referral_growth.md §5.1).
func (e *Engine) EvaluateFraud(referrerWorkspaceID, referrerUserID, refereeWorkspaceID, refereeUserID string, fctx FraudContext) (bool, string, []string) {
	e.mu.RLock()
	defer e.mu.RUnlock()

	var signals []string

	// 1. Same user referral
	if referrerUserID != "" && refereeUserID != "" && referrerUserID == refereeUserID {
		signals = append(signals, SignalSelfReferralSameUser)
	}

	// 2. Same workspace referral
	if referrerWorkspaceID != "" && refereeWorkspaceID != "" && referrerWorkspaceID == refereeWorkspaceID {
		signals = append(signals, SignalSelfReferralSameWorkspace)
	}

	// 3. Scripted bot signup
	if fctx.IsBot {
		signals = append(signals, SignalScriptedSignup)
	}

	// 4. IP match or IP clustering
	if fctx.IPAddress != "" {
		ipHash := hashString(fctx.IPAddress)
		if ws, ok := e.knownWorkspacesByIP[ipHash]; ok && ws == referrerWorkspaceID {
			signals = append(signals, SignalSelfReferralSameIP)
		}
		prefix := getIPPrefix(fctx.IPAddress)
		if e.ipClusteringCount[prefix] >= 10 {
			signals = append(signals, SignalIPRangeClustering)
		}
	}

	// 5. Device fingerprint reuse
	if fctx.DeviceFingerprint != "" {
		devHash := hashString(fctx.DeviceFingerprint)
		if ws, ok := e.knownWorkspacesByDevice[devHash]; ok && ws == referrerWorkspaceID {
			signals = append(signals, SignalSelfReferralSameDevice)
		}
	}

	// 6. Payment method reuse
	if fctx.CardFingerprint != "" {
		cardHash := hashString(fctx.CardFingerprint)
		if ws, ok := e.knownWorkspacesByCard[cardHash]; ok && ws == referrerWorkspaceID {
			signals = append(signals, SignalSelfReferralSameCard)
		}
	}

	if len(signals) > 0 {
		return false, strings.Join(signals, "; "), signals
	}
	return true, "", nil
}

// CalculateTier computes tier progress based on qualified referral count (referral_growth.md §4.2).
func (e *Engine) CalculateTier(qualifiedCount int) TierProgress {
	var currentTier, nextTier, multiplier, recurringRate string
	var nextTierThreshold int
	var progressPct float64

	switch {
	case qualifiedCount >= 51:
		currentTier = TierPlatinum
		nextTier = "max"
		nextTierThreshold = 51
		progressPct = 100.0
		multiplier = "2.5"
		recurringRate = "0.150000" // 15% recurring
	case qualifiedCount >= 21:
		currentTier = TierGold
		nextTier = TierPlatinum
		nextTierThreshold = 51
		multiplier = "2.0"
		recurringRate = "0.100000" // 10% recurring
		progressPct = float64(qualifiedCount-20) / float64(51-20) * 100.0
	case qualifiedCount >= 6:
		currentTier = TierSilver
		nextTier = TierGold
		nextTierThreshold = 21
		multiplier = "1.5"
		recurringRate = "0.000000"
		progressPct = float64(qualifiedCount-5) / float64(21-5) * 100.0
	case qualifiedCount >= 1:
		currentTier = TierBronze
		nextTier = TierSilver
		nextTierThreshold = 6
		multiplier = "1.0"
		recurringRate = "0.000000"
		progressPct = float64(qualifiedCount) / float64(6) * 100.0
	default:
		currentTier = TierBronze
		nextTier = TierSilver
		nextTierThreshold = 6
		multiplier = "1.0"
		recurringRate = "0.000000"
		progressPct = 0.0
	}

	remaining := nextTierThreshold - qualifiedCount
	if remaining < 0 {
		remaining = 0
	}

	return TierProgress{
		CurrentTier:             currentTier,
		NextTier:                nextTier,
		QualifiedReferralsCount: qualifiedCount,
		ReferralsToNextTier:     remaining,
		ProgressPercentage:      progressPct,
		RewardMultiplier:        multiplier,
		RecurringCommissionRate: recurringRate,
	}
}

// GenerateReferralCode creates an idempotent, human-readable code for a workspace.
func (e *Engine) EnsureWorkspaceReferralCode(ctx context.Context, workspaceID string) (string, error) {
	existing, err := e.store.GetWorkspaceReferralCode(ctx, workspaceID)
	if err == nil && existing != "" {
		return existing, nil
	}

	// Deterministic 8-char uppercase referral code from workspace ID
	h := sha256.Sum256([]byte("ref-code:" + workspaceID))
	code := fmt.Sprintf("REF%s", strings.ToUpper(hex.EncodeToString(h[:])[:5]))
	if err := e.store.SetWorkspaceReferralCode(ctx, workspaceID, code); err != nil {
		return "", err
	}
	return code, nil
}

// ProcessSignup handles initial user registration via a referral link.
func (e *Engine) ProcessSignup(
	ctx context.Context,
	referrerWorkspaceID, referrerUserID, refereeWorkspaceID, refereeUserID, refereeName, refereeEmail, referralCode string,
	fctx FraudContext,
) (*ReferralRecord, error) {
	now := e.clock()
	referralID := fmt.Sprintf("ref-%s-%s", referrerWorkspaceID[:8], refereeUserID)

	// 1. Evaluate anti-fraud rules (Target 2)
	passed, reason, signals := e.EvaluateFraud(referrerWorkspaceID, referrerUserID, refereeWorkspaceID, refereeUserID, fctx)

	passedBool := passed
	rec := &ReferralRecord{
		ReferralID:                referralID,
		WorkspaceID:               referrerWorkspaceID,
		RefereeWorkspaceID:        refereeWorkspaceID,
		ReferrerUserID:            referrerUserID,
		RefereeUserID:             refereeUserID,
		RefereeName:               refereeName,
		RefereeEmailMasked:        maskEmail(refereeEmail),
		ReferralCode:              referralCode,
		PlanTier:                  "free",
		PaymentStatus:             "unpaid",
		FraudCheckPassed:          &passedBool,
		FraudReason:               reason,
		FraudSignals:              signals,
		RecurringCommissionRate:   "0.000000",
		RecurringCommissionEarned: "0.000000",
		CreatedAt:                 now,
		UpdatedAt:                 now,
	}

	if !passed {
		// TARGET 2: Self-referral held for review
		rec.Status = StatusFraudFlagged
		rec.ReferrerCreditsAwarded = "0.000000"
		rec.RefereeCreditsAwarded = "0.000000"

		if err := e.store.SaveReferral(ctx, rec); err != nil {
			return nil, err
		}

		_ = e.store.EmitEvent(ctx, &DomainEvent{
			EventID:     fmt.Sprintf("evt-fraud-%s", referralID),
			EventType:   EventReferralFraudDetected,
			WorkspaceID: referrerWorkspaceID,
			Payload: map[string]interface{}{
				"referral_id": referralID,
				"reason":      reason,
				"signals":     signals,
			},
			OccurredAt: now,
		})

		return rec, ErrSelfReferralForbidden
	}

	// Normal valid signup: award 20 bonus credits each immediately, status remains pending
	rec.Status = StatusPending
	rec.ReferrerCreditsAwarded = CreditsFreeSignupReferrer
	rec.RefereeCreditsAwarded = CreditsFreeSignupReferee

	if err := e.store.SaveReferral(ctx, rec); err != nil {
		return nil, err
	}

	// Track signup funnel event
	_ = e.store.RecordEvent(ctx, &ReferralEvent{
		EventID:      fmt.Sprintf("rev-%s-signup", referralID),
		WorkspaceID:  referrerWorkspaceID,
		ReferralCode: referralCode,
		EventType:    "signup",
		IPHash:       hashString(fctx.IPAddress),
		CreatedAt:    now,
	})

	return rec, nil
}

// ProcessPaymentSettlement handles referee plan upgrade / payment event (Acceptance Target 1).
func (e *Engine) ProcessPaymentSettlement(
	ctx context.Context,
	referralID, paymentStatus, planTier, paidAmount, referenceID, idempotencyKey string,
) (qualified bool, status string, creditsAwarded string, message string, err error) {
	now := e.clock()

	rec, err := e.store.GetReferralRecord(ctx, referralID)
	if err != nil {
		return false, "", "0.000000", "", err
	}

	// TARGET 1: No immediate qualified reward on pending payment
	if strings.ToLower(paymentStatus) == "pending" {
		rec.PaymentStatus = "pending"
		rec.PlanTier = planTier
		rec.UpdatedAt = now
		_ = e.store.SaveReferral(ctx, rec)
		return false, StatusPending, "0.000000", "Payment is pending; referral reward held until payment settlement and qualification", nil
	}

	// Check if referral was flagged for fraud
	if rec.Status == StatusFraudFlagged || (rec.FraudCheckPassed != nil && !*rec.FraudCheckPassed) {
		return false, StatusFraudFlagged, "0.000000", "Referral is flagged for fraud review; no reward distributed", ErrFraudFlagged
	}

	// If already rewarded, return existing reward
	if rec.Status == StatusRewarded {
		return true, StatusRewarded, rec.ReferrerCreditsAwarded, "Already rewarded", nil
	}

	// Payment settled (paid): calculate upgrade bonus credits with referrer's tier multiplier
	// Count existing qualified referrals for referrer to compute tier multiplier
	refs, _, _ := e.store.ListReferrals(ctx, rec.WorkspaceID, StatusQualified, 1000, 0)
	tier := e.CalculateTier(len(refs))

	multRat, ok := new(big.Rat).SetString(tier.RewardMultiplier)
	if !ok {
		multRat = big.NewRat(1, 1)
	}

	var baseCreditsStr string
	var refereeBonusStr string
	switch strings.ToLower(planTier) {
	case "starter":
		baseCreditsStr = CreditsStarterReferrerBase // 100
		refereeBonusStr = CreditsStarterReferee     // 50
	case "pro":
		baseCreditsStr = CreditsProReferrerBase // 300
		refereeBonusStr = CreditsProReferee     // 100
	case "business":
		baseCreditsStr = CreditsBusinessReferrerBase // 1000
		refereeBonusStr = CreditsBusinessReferee     // 300
	default:
		baseCreditsStr = CreditsStarterReferrerBase
		refereeBonusStr = CreditsStarterReferee
	}

	baseRat, _ := new(big.Rat).SetString(baseCreditsStr)
	totalAwardedRat := new(big.Rat).Mul(baseRat, multRat)

	// Format exact decimal string
	totalAwardedFloat, _ := totalAwardedRat.Float64()
	totalAwardedFormatted := fmt.Sprintf("%.6f", totalAwardedFloat)

	// Update record
	rec.Status = StatusRewarded
	rec.PaymentStatus = "paid"
	rec.PlanTier = planTier
	rec.ReferrerCreditsAwarded = totalAwardedFormatted
	rec.RefereeCreditsAwarded = refereeBonusStr
	rec.RecurringCommissionRate = tier.RecurringCommissionRate
	rec.QualifiedAt = &now
	rec.RewardedAt = &now
	rec.UpdatedAt = now

	if err := e.store.SaveReferral(ctx, rec); err != nil {
		return false, "", "0.000000", "", err
	}

	// Record conversion event
	_ = e.store.RecordEvent(ctx, &ReferralEvent{
		EventID:      fmt.Sprintf("rev-%s-paid", referralID),
		WorkspaceID:  rec.WorkspaceID,
		ReferralCode: rec.ReferralCode,
		EventType:    "paid_convert",
		CreatedAt:    now,
	})

	// Emit domain events
	_ = e.store.EmitEvent(ctx, &DomainEvent{
		EventID:     fmt.Sprintf("evt-qual-%s", referralID),
		EventType:   EventReferralQualified,
		WorkspaceID: rec.WorkspaceID,
		Payload: map[string]interface{}{
			"referrer_id": rec.ReferrerUserID,
			"referee_id":  rec.RefereeUserID,
			"plan_tier":   planTier,
		},
		OccurredAt: now,
	})
	_ = e.store.EmitEvent(ctx, &DomainEvent{
		EventID:     fmt.Sprintf("evt-rew-%s", referralID),
		EventType:   EventReferralRewarded,
		WorkspaceID: rec.WorkspaceID,
		Payload: map[string]interface{}{
			"referrer_id": rec.ReferrerUserID,
			"referee_id":  rec.RefereeUserID,
			"credits":     totalAwardedFormatted,
		},
		OccurredAt: now,
	})

	return true, StatusRewarded, totalAwardedFormatted, "Referral qualified and rewarded successfully", nil
}

// ProcessRefundReversal handles referee refund / reversal (Acceptance Target 3: Replay reverses once).
func (e *Engine) ProcessRefundReversal(
	ctx context.Context,
	referralID, refundReason, refundRefID, idempotencyKey string,
) (reversed bool, duplicateReplay bool, status string, creditsReversed string, reversalTxID string, err error) {
	now := e.clock()

	rec, err := e.store.GetReferralRecord(ctx, referralID)
	if err != nil {
		return false, false, "", "0.000000", "", err
	}

	// TARGET 3: Replay/refund reverses once
	// If already revoked, this is an idempotent duplicate replay!
	if rec.Status == StatusRevoked {
		return false, true, StatusRevoked, "0.000000", rec.ReversalTransactionID, nil
	}

	// Calculate credits to reverse
	creditsToRev := rec.ReferrerCreditsAwarded
	if creditsToRev == "" {
		creditsToRev = "0.000000"
	}

	txID := fmt.Sprintf("rev-tx-%s-%s", referralID, idempotencyKey)
	if idempotencyKey == "" {
		txID = fmt.Sprintf("rev-tx-%s-%d", referralID, now.UnixNano())
	}

	rec.Status = StatusRevoked
	rec.ReversalTransactionID = txID
	rec.ReversedAt = &now
	rec.PaymentStatus = "refunded"
	rec.UpdatedAt = now

	if err := e.store.SaveReferral(ctx, rec); err != nil {
		return false, false, "", "0.000000", "", err
	}

	return true, false, StatusRevoked, creditsToRev, txID, nil
}

// ReviewFraudCase allows an admin to clear or confirm a flagged referral.
func (e *Engine) ReviewFraudCase(ctx context.Context, referralID, adminAction, notes string) (*ReferralRecord, error) {
	now := e.clock()

	rec, err := e.store.GetReferralRecord(ctx, referralID)
	if err != nil {
		return nil, err
	}

	switch adminAction {
	case "clear_and_qualify":
		tVal := true
		rec.FraudCheckPassed = &tVal
		rec.Status = StatusPending
		rec.FraudReason = fmt.Sprintf("Cleared by admin: %s", notes)
		rec.ReferrerCreditsAwarded = CreditsFreeSignupReferrer
		rec.RefereeCreditsAwarded = CreditsFreeSignupReferee
		rec.UpdatedAt = now
	case "confirm_and_forfeit":
		fVal := false
		rec.FraudCheckPassed = &fVal
		rec.Status = StatusForfeited
		rec.FraudReason = fmt.Sprintf("Confirmed fraud by admin: %s", notes)
		rec.ReferrerCreditsAwarded = "0.000000"
		rec.RefereeCreditsAwarded = "0.000000"
		rec.UpdatedAt = now
	default:
		return nil, fmt.Errorf("unknown admin action: %q", adminAction)
	}

	if err := e.store.SaveReferral(ctx, rec); err != nil {
		return nil, err
	}
	return rec, nil
}

// RedeemPromotion processes a promotional credit code (referral_growth.md §6).
func (e *Engine) RedeemPromotion(ctx context.Context, workspaceID, userID, promoCode, idempotencyKey string) (*PromotionalCampaign, string, error) {
	cmp, err := e.store.GetCampaignByCode(ctx, strings.ToUpper(strings.TrimSpace(promoCode)))
	if err != nil {
		return nil, "", ErrCampaignNotFound
	}

	now := e.clock()
	if !cmp.IsActive || (!cmp.ExpiresAt.IsZero() && cmp.ExpiresAt.Before(now)) {
		return nil, "", ErrCampaignExpired
	}
	if cmp.CurrentRedemptions >= cmp.MaxRedemptions {
		return nil, "", ErrCampaignExhausted
	}

	alreadyRedeemed, err := e.store.HasRedeemed(ctx, workspaceID, cmp.CampaignID)
	if err != nil {
		return nil, "", err
	}
	if alreadyRedeemed {
		return nil, "", ErrAlreadyRedeemed
	}

	redemption := &PromotionalRedemption{
		RedemptionID:   fmt.Sprintf("prm-%s-%d", workspaceID[:8], now.UnixNano()),
		WorkspaceID:    workspaceID,
		UserID:         userID,
		CampaignID:     cmp.CampaignID,
		CreditsAwarded: cmp.CreditBonus,
		CreatedAt:      now,
	}

	if err := e.store.RecordPromoRedemption(ctx, redemption); err != nil {
		return nil, "", err
	}

	return cmp, cmp.CreditBonus, nil
}

// TriggerGrowthPrompt records and executes in-product prompt completion.
func (e *Engine) TriggerGrowthPrompt(ctx context.Context, workspaceID, userID, triggerPoint string) (*GrowthPrompt, error) {
	now := e.clock()

	var title, desc, reward string
	switch triggerPoint {
	case TriggerFirstPublish:
		title = "Chia sẻ Creativanta sau lần xuất bản đầu tiên!"
		desc = "Giới thiệu bạn bè và nhận ngay 20 credits thưởng."
		reward = CreditsPromptFirstPublish
	case TriggerFirstProfit:
		title = "Minh chứng lợi nhuận đầu tiên đạt được!"
		desc = "Chia sẻ case study nhận ngay 50 credits thưởng."
		reward = CreditsPromptFirstProfit
	case TriggerFollowerMilestone:
		title = "Cột mốc 1.000 người theo dõi!"
		desc = "Nhận huy hiệu thành tích và 30 credits."
		reward = CreditsPromptFollowers1000
	case TriggerTeamInvite:
		title = "Mời đồng nghiệp vào không gian làm việc"
		desc = "Nhận 10 credits cho mỗi thành viên tham gia."
		reward = CreditsPromptTeamInvite
	case TriggerRecipeSubmit:
		title = "Đóng góp Recipe lên Marketplace"
		desc = "Nhận 50 credits khi recipe được duyệt."
		reward = CreditsPromptRecipeSubmit
	case TriggerFeatureUpvote:
		title = "Bình chọn tính năng mới"
		desc = "Nhận 5 credits khi đóng góp ý kiến cộng đồng."
		reward = CreditsPromptFeatureUpvote
	default:
		title = "Giới thiệu bạn bè"
		desc = "Chia sẻ liên kết và nhận thưởng."
		reward = "20.000000"
	}

	prompt := &GrowthPrompt{
		PromptID:      fmt.Sprintf("gp-%s-%d", triggerPoint, now.UnixNano()),
		WorkspaceID:   workspaceID,
		UserID:        userID,
		TriggerPoint:  triggerPoint,
		Status:        "active",
		CreditsReward: reward,
		CreatedAt:     now,
	}

	if err := e.store.SaveGrowthPrompt(ctx, prompt); err != nil {
		return nil, err
	}
	_ = title
	_ = desc

	return prompt, nil
}

func hashString(s string) string {
	sum := sha256.Sum256([]byte(s))
	return hex.EncodeToString(sum[:])
}

func getIPPrefix(ip string) string {
	parts := strings.Split(ip, ".")
	if len(parts) >= 3 {
		return fmt.Sprintf("%s.%s.%s.0/24", parts[0], parts[1], parts[2])
	}
	return ip
}

func maskEmail(email string) string {
	parts := strings.Split(email, "@")
	if len(parts) != 2 {
		return email
	}
	name := parts[0]
	domain := parts[1]
	if len(name) <= 2 {
		return name + "***@" + domain
	}
	return name[:2] + "***@" + domain
}
