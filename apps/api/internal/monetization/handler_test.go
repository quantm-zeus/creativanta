package monetization_test

import (
	"context"
	"testing"
	"time"

	"connectrpc.com/connect"
	commercev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/commerce/v1"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/monetization"
	"google.golang.org/protobuf/types/known/timestamppb"
)

const testWorkspaceID = "11111111-1111-4111-8111-111111111111"

func TestHandler_ConnectRPCEndpoints(t *testing.T) {
	ctx := context.Background()
	store := monetization.NewMemoryStore()
	fixedNow := time.Date(2026, 11, 4, 10, 0, 0, 0, time.UTC)
	svc := monetization.NewService(store, nil, nil, func() time.Time { return fixedNow })

	offerHandler := monetization.NewOfferHandler(svc)
	couponHandler := monetization.NewCouponHandler(svc)
	campaignHandler := monetization.NewCampaignHandler(svc)
	monetizationHandler := monetization.NewMonetizationHandler(svc)

	cmdCtx := &commonv1.CommandContext{
		WorkspaceId: &commonv1.UUID{Value: testWorkspaceID},
	}

	// 1. Create Offer via OfferHandler
	offerValidUntil := fixedNow.Add(24 * time.Hour)
	createOfferReq := connect.NewRequest(&commercev1.OfferServiceCreateRequest{
		CommandContext:  cmdCtx,
		WorkspaceId:     testWorkspaceID,
		Title:           "Black Friday 50% Off",
		OfferType:       commercev1.OfferType_OFFER_TYPE_PRODUCT_OFFER,
		PricingValue:    "50.000000",
		PricingCurrency: "VND",
		ProductId:       "prod-12345",
		ValidUntil:      timestamppb.New(offerValidUntil),
	})
	createOfferResp, err := offerHandler.Create(ctx, createOfferReq)
	if err != nil {
		t.Fatalf("OfferHandler Create failed: %v", err)
	}
	offerID := createOfferResp.Msg.Offer.OfferId
	if offerID == "" {
		t.Fatal("expected offer_id in Create response")
	}

	// 2. Activate Offer
	activateOfferReq := connect.NewRequest(&commercev1.OfferServiceActivateRequest{
		CommandContext: cmdCtx,
		WorkspaceId:    testWorkspaceID,
		OfferId:        offerID,
	})
	activateOfferResp, err := offerHandler.Activate(ctx, activateOfferReq)
	if err != nil {
		t.Fatalf("OfferHandler Activate failed: %v", err)
	}
	if activateOfferResp.Msg.Offer.LifecycleState != commercev1.OfferLifecycleState_OFFER_LIFECYCLE_STATE_ACTIVE {
		t.Fatalf("expected state active, got %v", activateOfferResp.Msg.Offer.LifecycleState)
	}

	// 3. Create Coupon via CouponHandler
	createCouponReq := connect.NewRequest(&commercev1.CouponServiceCreateRequest{
		CommandContext: cmdCtx,
		WorkspaceId:    testWorkspaceID,
		Code:           "VIP20K",
		CouponType:     commercev1.CouponType_COUPON_TYPE_FIXED_AMOUNT,
		DiscountValue:  "20000.000000",
		MaxUses:        5,
		MinOrderAmount: "100000.000000",
		ValidUntil:     timestamppb.New(offerValidUntil),
	})
	createCouponResp, err := couponHandler.Create(ctx, createCouponReq)
	if err != nil {
		t.Fatalf("CouponHandler Create failed: %v", err)
	}
	couponID := createCouponResp.Msg.Coupon.CouponId
	if couponID == "" {
		t.Fatal("expected coupon_id in Create response")
	}

	// Activate Coupon
	activateCouponReq := connect.NewRequest(&commercev1.CouponServiceActivateRequest{
		CommandContext: cmdCtx,
		WorkspaceId:    testWorkspaceID,
		CouponId:       couponID,
	})
	if _, err := couponHandler.Activate(ctx, activateCouponReq); err != nil {
		t.Fatalf("CouponHandler Activate failed: %v", err)
	}

	// 4. Validate Coupon via CouponHandler
	validateReq := connect.NewRequest(&commercev1.CouponServiceValidateCouponRequest{
		WorkspaceId: testWorkspaceID,
		Code:        "VIP20K",
		OrderContext: &commercev1.OrderContext{
			Subtotal: "150000.000000",
			Currency: "VND",
		},
	})
	validateResp, err := couponHandler.ValidateCoupon(ctx, validateReq)
	if err != nil {
		t.Fatalf("CouponHandler ValidateCoupon failed: %v", err)
	}
	if !validateResp.Msg.Valid {
		t.Fatalf("expected valid coupon, got false: %s", validateResp.Msg.FailureReason)
	}

	// 5. Create Campaign via CampaignHandler
	createCampReq := connect.NewRequest(&commercev1.CampaignServiceCreateRequest{
		CommandContext: cmdCtx,
		WorkspaceId:    testWorkspaceID,
		Title:          "Holiday Sales Blitz",
		CampaignType:   commercev1.CampaignType_CAMPAIGN_TYPE_CONTENT,
		Budget:         "5000000.000000",
		BudgetCurrency: "VND",
	})
	createCampResp, err := campaignHandler.Create(ctx, createCampReq)
	if err != nil {
		t.Fatalf("CampaignHandler Create failed: %v", err)
	}
	campID := createCampResp.Msg.Campaign.CampaignId
	if campID == "" {
		t.Fatal("expected campaign_id in Create response")
	}

	// 6. Add Cost to Campaign
	addCostReq := connect.NewRequest(&commercev1.CampaignServiceAddCostRequest{
		CommandContext: cmdCtx,
		WorkspaceId:    testWorkspaceID,
		CampaignId:     campID,
		CostType:       "ad_spend",
		Amount:         "1000000.000000",
		Currency:       "VND",
		Description:    "TikTok Ads placement",
	})
	addCostResp, err := campaignHandler.AddCost(ctx, addCostReq)
	if err != nil {
		t.Fatalf("CampaignHandler AddCost failed: %v", err)
	}
	if addCostResp.Msg.TotalSpend != "1000000" && addCostResp.Msg.TotalSpend != "1000000.000000" {
		t.Fatalf("expected total spend 1000000, got %s", addCostResp.Msg.TotalSpend)
	}

	// 7. Evaluate Checkout via MonetizationHandler
	evalReq := connect.NewRequest(&commercev1.MonetizationServiceEvaluateCheckoutRequest{
		CommandContext: cmdCtx,
		WorkspaceId:    testWorkspaceID,
		OfferId:        offerID,
		CouponCode:     "VIP20K",
		OrderAmount:    "200000.000000",
		Currency:       "VND",
	})
	evalResp, err := monetizationHandler.EvaluateCheckout(ctx, evalReq)
	if err != nil {
		t.Fatalf("MonetizationHandler EvaluateCheckout failed: %v", err)
	}
	if !evalResp.Msg.Accepted {
		t.Fatalf("expected checkout accepted, got false: %s", evalResp.Msg.ErrorMessage)
	}
	// Fixed coupon discount = 20,000. Net = 180,000.
	if evalResp.Msg.DiscountAmount != "20000" && evalResp.Msg.DiscountAmount != "20000.000000" {
		t.Fatalf("expected discount 20000, got %s", evalResp.Msg.DiscountAmount)
	}
	if evalResp.Msg.NetPayableAmount != "180000" && evalResp.Msg.NetPayableAmount != "180000.000000" {
		t.Fatalf("expected net payable 180000, got %s", evalResp.Msg.NetPayableAmount)
	}
}
