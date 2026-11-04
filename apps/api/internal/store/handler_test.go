package store_test

import (
	"context"
	"testing"

	"connectrpc.com/connect"
	commercev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/commerce/v1"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/store"
	"github.com/stretchr/testify/require"
)

func TestHandler_StoreService_CreateAndPublish(t *testing.T) {
	memStore := store.NewMemoryStore()
	svc := store.NewService(memStore, nil, nil)
	handler := store.NewStoreHandler(svc)

	ctx := context.Background()
	wsID := "ws-handler-test-1"

	// 1. Create page
	createReq := connect.NewRequest(&commercev1.StoreServiceCreatePageRequest{
		WorkspaceId:  wsID,
		Title:        "My Creator Store",
		Slug:         "my-creator-store",
		LayoutJson:   `{"sections":[{"type":"hero","title":"Welcome"}]}`,
		CustomDomain: "creator.example.com",
	})
	createResp, err := handler.CreatePage(ctx, createReq)
	require.NoError(t, err)
	require.NotEmpty(t, createResp.Msg.Page.StorePageId)
	require.Equal(t, commercev1.StorePageStatus_STORE_PAGE_STATUS_DRAFT, createResp.Msg.Page.Status)

	pageID := createResp.Msg.Page.StorePageId

	// 2. Publish page
	publishReq := connect.NewRequest(&commercev1.StoreServicePublishPageRequest{
		StorePageId: pageID,
		WorkspaceId: wsID,
	})
	publishResp, err := handler.PublishPage(ctx, publishReq)
	require.NoError(t, err)
	require.Equal(t, commercev1.StorePageStatus_STORE_PAGE_STATUS_PUBLISHED, publishResp.Msg.Page.Status)

	// 3. Get page
	getReq := connect.NewRequest(&commercev1.StoreServiceGetPageRequest{
		StorePageId: pageID,
		WorkspaceId: wsID,
	})
	getResp, err := handler.GetPage(ctx, getReq)
	require.NoError(t, err)
	require.Equal(t, pageID, getResp.Msg.Page.StorePageId)
}

func TestHandler_BundleService_StockAndCheckoutReplay(t *testing.T) {
	memStore := store.NewMemoryStore()
	svc := store.NewService(memStore, nil, nil)
	bundleHandler := store.NewBundleHandler(svc)
	storeHandler := store.NewStoreHandler(svc)

	ctx := context.Background()
	wsID := "ws-handler-bundle"

	// Create bundle via handler
	createBundleReq := connect.NewRequest(&commercev1.BundleServiceCreateBundleRequest{
		WorkspaceId: wsID,
		Title:       "Pro Photography Bundle",
		BundlePrice: "499000.000000",
		Items: []*commercev1.BundleItem{
			{ProductId: "prod-photo-preset", Quantity: 1, ProductTitle: "Presets Pack"},
			{ProductId: "prod-camera-strap", Quantity: 1, ProductTitle: "Physical Strap"},
		},
	})
	bundleResp, err := bundleHandler.CreateBundle(ctx, createBundleReq)
	require.NoError(t, err)
	require.NotEmpty(t, bundleResp.Msg.Bundle.BundleId)
	bundleID := bundleResp.Msg.Bundle.BundleId

	// Set stock
	err = memStore.SetProductStock(ctx, wsID, "prod-photo-preset", 100)
	require.NoError(t, err)
	err = memStore.SetProductStock(ctx, wsID, "prod-camera-strap", 5)
	require.NoError(t, err)

	// Check stock via handler
	stockReq := connect.NewRequest(&commercev1.BundleServiceCheckBundleStockRequest{
		WorkspaceId:       wsID,
		BundleId:          bundleID,
		RequestedQuantity: 2,
	})
	stockResp, err := bundleHandler.CheckBundleStock(ctx, stockReq)
	require.NoError(t, err)
	require.True(t, stockResp.Msg.IsAvailable)
	require.Len(t, stockResp.Msg.StockBreakdown, 2)

	// Checkout via StoreHandler
	checkoutReq := connect.NewRequest(&commercev1.StoreServiceCheckoutRequest{
		WorkspaceId:      wsID,
		CustomerEntityId: "buyer-handler-1",
		IdempotencyKey:   "idem-handler-checkout-1",
		PaymentIntentId:  "pi-handler-1",
		BundleId:         bundleID,
		OrderAmount:      "499000.000000",
		Currency:         "VND",
		CommandContext: &commonv1.CommandContext{
			IdempotencyKey: "idem-handler-checkout-1",
			WorkspaceId:    &commonv1.UUID{Value: wsID},
		},
	})
	checkoutResp, err := storeHandler.Checkout(ctx, checkoutReq)
	require.NoError(t, err)
	require.NotEmpty(t, checkoutResp.Msg.OrderId)
	require.False(t, checkoutResp.Msg.IsReplayed)

	// Replay checkout via StoreHandler
	replayResp, err := storeHandler.Checkout(ctx, checkoutReq)
	require.NoError(t, err)
	require.Equal(t, checkoutResp.Msg.OrderId, replayResp.Msg.OrderId)
	require.True(t, replayResp.Msg.IsReplayed)
}

func TestHandler_MembershipService_PlanAndMRR(t *testing.T) {
	memStore := store.NewMemoryStore()
	svc := store.NewService(memStore, nil, nil)
	memHandler := store.NewMembershipHandler(svc)
	storeHandler := store.NewStoreHandler(svc)

	ctx := context.Background()
	wsID := "ws-handler-membership"

	// Create plan via handler
	planReq := connect.NewRequest(&commercev1.MembershipServiceCreatePlanRequest{
		WorkspaceId:     wsID,
		Title:           "VIP Creator Club",
		Price:           "99000.000000",
		Currency:        "VND",
		BillingInterval: "monthly",
		BenefitsJson:    `[{"title":"Exclusive Discord"},{"title":"Early Video Access"}]`,
	})
	planResp, err := memHandler.CreatePlan(ctx, planReq)
	require.NoError(t, err)
	require.NotEmpty(t, planResp.Msg.Plan.PlanId)
	planID := planResp.Msg.Plan.PlanId

	// Publish plan
	pubReq := connect.NewRequest(&commercev1.MembershipServicePublishRequest{
		WorkspaceId: wsID,
		PlanId:      planID,
	})
	pubResp, err := memHandler.Publish(ctx, pubReq)
	require.NoError(t, err)
	require.Equal(t, commercev1.MembershipPlanStatus_MEMBERSHIP_PLAN_STATUS_ACTIVE, pubResp.Msg.Plan.Status)

	// Subscribe buyer via checkout
	checkoutReq := connect.NewRequest(&commercev1.StoreServiceCheckoutRequest{
		WorkspaceId:      wsID,
		CustomerEntityId: "buyer-sub-1",
		IdempotencyKey:   "idem-sub-1",
		PaymentIntentId:  "pi-sub-1",
		MembershipPlanId: planID,
		OrderAmount:      "99000.000000",
		Currency:         "VND",
	})
	checkoutResp, err := storeHandler.Checkout(ctx, checkoutReq)
	require.NoError(t, err)
	require.NotNil(t, checkoutResp.Msg.Subscription)

	// Query MRR summary
	mrrReq := connect.NewRequest(&commercev1.MembershipServiceGetMRRSummaryRequest{
		WorkspaceId: wsID,
	})
	mrrResp, err := memHandler.GetMRRSummary(ctx, mrrReq)
	require.NoError(t, err)
	require.Equal(t, "99000", mrrResp.Msg.CurrentMrr)
	require.Equal(t, int32(1), mrrResp.Msg.ActiveSubscribers)

	// Validate buyer privilege barrier (Acceptance Target 3)
	err = svc.ValidateBuyerPrivilegeIsolation("buyer", true, "store:manage")
	require.Error(t, err)
	require.ErrorIs(t, err, store.ErrForbiddenSaaSFromBuyerMembership)
}
