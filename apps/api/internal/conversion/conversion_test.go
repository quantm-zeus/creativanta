package conversion

import (
	"context"
	"errors"
	"strings"
	"testing"
	"time"
)

// setupTestEnvironment initializes test service with in-memory stores and default test sources.
func setupTestEnvironment() (*Service, *MemoryLineageStore, *MemoryEventRecorder, *MemorySourceProvider, *MemoryTargetCreator) {
	lineageStore := NewMemoryLineageStore()
	eventRecorder := NewMemoryEventRecorder()
	svc := NewService(lineageStore, eventRecorder)

	srcProvider := NewMemorySourceProvider()
	tgtCreator := NewMemoryTargetCreator()

	svc.RegisterSourceProvider(SourceTypeOpportunity, srcProvider)
	svc.RegisterSourceProvider(SourceTypeIdea, srcProvider)
	svc.RegisterSourceProvider(SourceTypeThread, srcProvider)

	svc.RegisterTargetCreator(TargetTypeCampaign, tgtCreator)
	svc.RegisterTargetCreator(TargetTypeLive, tgtCreator)
	svc.RegisterTargetCreator(TargetTypeOffer, tgtCreator)
	svc.RegisterTargetCreator(TargetTypeSeeding, tgtCreator)
	svc.RegisterTargetCreator(TargetTypeDeal, tgtCreator)
	svc.RegisterTargetCreator(TargetTypeScript, tgtCreator)

	return svc, lineageStore, eventRecorder, srcProvider, tgtCreator
}

// ----------------------------------------------------------------------------
// ACCEPTANCE TARGET 1: EACH TARGET PERMISSION RECHECKED
// ----------------------------------------------------------------------------

func TestTarget1_PermissionRecheckMatrix(t *testing.T) {
	ctx := context.Background()
	svc, _, _, srcProvider, _ := setupTestEnvironment()
	wsID := "ws-test-perm"

	// Seed source objects
	oppID := "opp-perm-01"
	srcProvider.AddSource(SourceSnapshot{
		ID:          oppID,
		WorkspaceID: wsID,
		Type:        SourceTypeOpportunity,
		Title:       "Hot Skincare Trend Opportunity",
		Description: "Proven trend for facial moisturizers",
		Status:      "in_progress",
	})

	ideaID := "idea-perm-01"
	srcProvider.AddSource(SourceSnapshot{
		ID:          ideaID,
		WorkspaceID: wsID,
		Type:        SourceTypeIdea,
		Title:       "Skincare 5-Step Routine Idea",
		Description: "Short-form video breakdown of skincare routine",
		Status:      "selected",
	})

	threadID := "thread-perm-01"
	srcProvider.AddSource(SourceSnapshot{
		ID:          threadID,
		WorkspaceID: wsID,
		Type:        SourceTypeThread,
		Title:       "Inbound brand sponsorship inquiry",
		Description: "Sponsor asking for dedicated product review",
		Status:      "active",
	})

	testCases := []struct {
		name          string
		role          string
		srcType       SourceType
		srcID         string
		targetType    TargetType
		expectSuccess bool
		expectedErr   error
	}{
		// 1. Editor has opportunity:convert AND campaign:manage -> SUCCEED
		{
			name:          "Editor converts Opportunity to Campaign (Allowed)",
			role:          "editor",
			srcType:       SourceTypeOpportunity,
			srcID:         oppID,
			targetType:    TargetTypeCampaign,
			expectSuccess: true,
		},
		// 2. Editor has opportunity:convert, but lacks brand_deal:manage (Manager+ only) -> DENIED
		{
			name:          "Editor converts Opportunity to Brand Deal (Denied by Target Permission)",
			role:          "editor",
			srcType:       SourceTypeOpportunity,
			srcID:         "opp-deal-denied",
			targetType:    TargetTypeDeal,
			expectSuccess: false,
			expectedErr:   ErrTargetPermissionDenied,
		},
		// 3. Manager has both opportunity:convert AND brand_deal:manage -> SUCCEED
		{
			name:          "Manager converts Opportunity to Brand Deal (Allowed)",
			role:          "manager",
			srcType:       SourceTypeOpportunity,
			srcID:         "opp-deal-mgr",
			targetType:    TargetTypeDeal,
			expectSuccess: true,
		},
		// 4. Editor converts Idea to Offer (Allowed: offer:manage)
		{
			name:          "Editor converts Idea to Offer (Allowed)",
			role:          "editor",
			srcType:       SourceTypeIdea,
			srcID:         ideaID,
			targetType:    TargetTypeOffer,
			expectSuccess: true,
		},
		// 5. Editor converts Idea to Brand Deal (Denied by Target Permission)
		{
			name:          "Editor converts Idea to Brand Deal (Denied by Target Permission)",
			role:          "editor",
			srcType:       SourceTypeIdea,
			srcID:         "idea-deal-denied",
			targetType:    TargetTypeDeal,
			expectSuccess: false,
			expectedErr:   ErrTargetPermissionDenied,
		},
		// 6. Contributor lacks opportunity:convert -> DENIED at Source Check
		{
			name:          "Contributor converts Opportunity to Campaign (Denied at Source Check)",
			role:          "contributor",
			srcType:       SourceTypeOpportunity,
			srcID:         "opp-contrib",
			targetType:    TargetTypeCampaign,
			expectSuccess: false,
			expectedErr:   ErrPermissionDenied,
		},
		// 7. Viewer lacks everything -> DENIED
		{
			name:          "Viewer converts Thread to Seeding (Denied at Source Check)",
			role:          "viewer",
			srcType:       SourceTypeThread,
			srcID:         threadID,
			targetType:    TargetTypeSeeding,
			expectSuccess: false,
			expectedErr:   ErrPermissionDenied,
		},
		// 8. Editor converts Thread to Seeding (Allowed: sample:manage)
		{
			name:          "Editor converts Thread to Seeding (Allowed)",
			role:          "editor",
			srcType:       SourceTypeThread,
			srcID:         "thread-seeding-ok",
			targetType:    TargetTypeSeeding,
			expectSuccess: true,
		},
		// 9. Editor converts Thread to Brand Deal (Denied: brand_deal:manage is Manager+)
		{
			name:          "Editor converts Thread to Brand Deal (Denied by Target Permission)",
			role:          "editor",
			srcType:       SourceTypeThread,
			srcID:         "thread-deal-denied",
			targetType:    TargetTypeDeal,
			expectSuccess: false,
			expectedErr:   ErrTargetPermissionDenied,
		},
		// 10. Manager converts Thread to Brand Deal (Allowed)
		{
			name:          "Manager converts Thread to Brand Deal (Allowed)",
			role:          "manager",
			srcType:       SourceTypeThread,
			srcID:         "thread-deal-mgr",
			targetType:    TargetTypeDeal,
			expectSuccess: true,
		},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			// Seed test source if it's a new ID
			srcProvider.AddSource(SourceSnapshot{
				ID:          tc.srcID,
				WorkspaceID: wsID,
				Type:        tc.srcType,
				Title:       "Test Source for " + tc.name,
				Description: "Valid description for testing",
				Status:      "in_progress",
			})

			caller := CallerContext{
				UserID:        "user-" + tc.role,
				WorkspaceID:   wsID,
				WorkspaceRole: tc.role,
			}

			res, err := svc.Convert(ctx, caller, ConversionParams{
				WorkspaceID: wsID,
				SourceType:  tc.srcType,
				SourceID:    tc.srcID,
				TargetType:  tc.targetType,
				TargetTitle: "Generated Target for " + tc.name,
			})

			if tc.expectSuccess {
				if err != nil {
					t.Fatalf("expected conversion success, got err: %v", err)
				}
				if res == nil || res.TargetID == "" {
					t.Fatalf("expected non-nil conversion result with targetID")
				}
				if res.TargetType != tc.targetType {
					t.Errorf("expected target type %s, got %s", tc.targetType, res.TargetType)
				}
			} else {
				if err == nil {
					t.Fatalf("expected conversion failure with error %v, got success", tc.expectedErr)
				}
				if tc.expectedErr != nil && !errors.Is(err, tc.expectedErr) && !strings.Contains(err.Error(), tc.expectedErr.Error()) {
					t.Errorf("expected error wrapping %v, got %v", tc.expectedErr, err)
				}
			}
		})
	}
}

// ----------------------------------------------------------------------------
// ACCEPTANCE TARGET 2: FAILED CONVERSION ATOMIC
// ----------------------------------------------------------------------------

func TestTarget2_FailedConversionIsAtomic(t *testing.T) {
	ctx := context.Background()
	wsID := "ws-atomic-test"

	callerEditor := CallerContext{
		UserID:        "user-editor",
		WorkspaceID:   wsID,
		WorkspaceRole: "editor",
	}

	t.Run("Target creation failure leaves source completely unchanged and writes no lineage", func(t *testing.T) {
		svc, lineageStore, eventRecorder, srcProvider, tgtCreator := setupTestEnvironment()
		sourceID := "opp-fail-tgt"

		initialTime := time.Now().UTC().Add(-time.Hour)
		srcProvider.AddSource(SourceSnapshot{
			ID:          sourceID,
			WorkspaceID: wsID,
			Type:        SourceTypeOpportunity,
			Title:       "Opportunity Atomic Check",
			Description: "Must not be mutated when downstream creation fails",
			Status:      "in_progress",
			UpdatedAt:   initialTime,
		})

		// Configure downstream target creator to fail (e.g. database timeout / constraint violation)
		tgtCreator.SetFailOnCreate(true, errors.New("downstream target database connection closed"))

		_, err := svc.Convert(ctx, callerEditor, ConversionParams{
			WorkspaceID: wsID,
			SourceType:  SourceTypeOpportunity,
			SourceID:    sourceID,
			TargetType:  TargetTypeCampaign,
			TargetTitle: "Failing Campaign",
		})

		if err == nil {
			t.Fatal("expected convert to fail due to target creator failure")
		}
		if !errors.Is(err, ErrTargetCreationFailed) {
			t.Errorf("expected ErrTargetCreationFailed, got %v", err)
		}

		// Verify Source is completely untouched!
		srcSnap, err := srcProvider.GetSnapshot(ctx, wsID, sourceID)
		if err != nil {
			t.Fatalf("failed to retrieve source: %v", err)
		}
		if srcSnap.Status != "in_progress" {
			t.Errorf("expected source status 'in_progress', got %q", srcSnap.Status)
		}
		if srcSnap.ConvertedToType != "" || srcSnap.ConvertedToID != "" {
			t.Errorf("expected empty converted pointers, got type=%s id=%s", srcSnap.ConvertedToType, srcSnap.ConvertedToID)
		}

		// Verify zero lineage records were written
		records, err := lineageStore.ListWorkspaceLineage(ctx, wsID)
		if err != nil {
			t.Fatalf("failed to query lineage store: %v", err)
		}
		if len(records) != 0 {
			t.Errorf("expected 0 lineage records, got %d", len(records))
		}

		// Verify no converted events were emitted
		events := eventRecorder.GetEvents()
		if len(events) != 0 {
			t.Errorf("expected 0 domain events emitted on failure, got %d", len(events))
		}
	})

	t.Run("Failure during source update rolls back created target so no orphan target exists", func(t *testing.T) {
		svc, lineageStore, _, srcProvider, tgtCreator := setupTestEnvironment()
		sourceID := "opp-fail-src-upd"

		srcProvider.AddSource(SourceSnapshot{
			ID:          sourceID,
			WorkspaceID: wsID,
			Type:        SourceTypeOpportunity,
			Title:       "Opportunity Rollback Check",
			Description: "Must roll back target if source update fails",
			Status:      "in_progress",
		})

		// Inject simulated failure during source update stage
		svc.InjectSimulatedFailure("source_update", errors.New("source row lock timeout"))

		_, err := svc.Convert(ctx, callerEditor, ConversionParams{
			WorkspaceID: wsID,
			SourceType:  SourceTypeOpportunity,
			SourceID:    sourceID,
			TargetType:  TargetTypeCampaign,
			TargetTitle: "Orphan Prevention Campaign",
		})

		if err == nil {
			t.Fatal("expected convert to fail due to injected source update failure")
		}

		// Verify target was deleted / rolled back in target store
		tgtCreator.mu.RLock()
		targetCount := len(tgtCreator.targets)
		tgtCreator.mu.RUnlock()
		if targetCount != 0 {
			t.Errorf("expected target object to be rolled back, found %d orphan targets", targetCount)
		}

		// Verify source status remains in_progress
		snap, _ := srcProvider.GetSnapshot(ctx, wsID, sourceID)
		if snap.Status != "in_progress" {
			t.Errorf("expected source status 'in_progress', got %q", snap.Status)
		}

		// Verify no lineage record
		recs, _ := lineageStore.ListWorkspaceLineage(ctx, wsID)
		if len(recs) != 0 {
			t.Errorf("expected 0 lineage records, got %d", len(recs))
		}
	})

	t.Run("Failure during lineage save rolls back both target and source", func(t *testing.T) {
		svc, lineageStore, _, srcProvider, tgtCreator := setupTestEnvironment()
		sourceID := "opp-fail-lineage"

		srcProvider.AddSource(SourceSnapshot{
			ID:          sourceID,
			WorkspaceID: wsID,
			Type:        SourceTypeOpportunity,
			Title:       "Lineage Failure Rollback",
			Description: "Must revert both source and target if lineage fails",
			Status:      "in_progress",
		})

		// Inject simulated failure during lineage_save stage
		svc.InjectSimulatedFailure("lineage_save", errors.New("lineage database disk full"))

		_, err := svc.Convert(ctx, callerEditor, ConversionParams{
			WorkspaceID: wsID,
			SourceType:  SourceTypeOpportunity,
			SourceID:    sourceID,
			TargetType:  TargetTypeCampaign,
			TargetTitle: "Lineage Fail Campaign",
		})

		if err == nil {
			t.Fatal("expected convert to fail due to injected lineage save failure")
		}

		// Verify target object was deleted
		tgtCreator.mu.RLock()
		targetCount := len(tgtCreator.targets)
		tgtCreator.mu.RUnlock()
		if targetCount != 0 {
			t.Errorf("expected target object rolled back, found %d targets", targetCount)
		}

		// Verify source was rolled back to in_progress
		snap, _ := srcProvider.GetSnapshot(ctx, wsID, sourceID)
		if snap.Status != "in_progress" {
			t.Errorf("expected source status reverted to 'in_progress', got %q", snap.Status)
		}
		if snap.ConvertedToType != "" || snap.ConvertedToID != "" {
			t.Errorf("expected source pointers cleared on rollback, got type=%s id=%s", snap.ConvertedToType, snap.ConvertedToID)
		}

		// Verify 0 lineage records
		recs, _ := lineageStore.ListWorkspaceLineage(ctx, wsID)
		if len(recs) != 0 {
			t.Errorf("expected 0 lineage records, got %d", len(recs))
		}
	})
}

// ----------------------------------------------------------------------------
// ACCEPTANCE TARGET 3: SOURCE SURVIVES CONVERSION
// ----------------------------------------------------------------------------

func TestTarget3_SourceSurvivesConversion(t *testing.T) {
	ctx := context.Background()
	svc, lineageStore, eventRecorder, srcProvider, tgtCreator := setupTestEnvironment()
	wsID := "ws-survives-test"

	callerEditor := CallerContext{
		UserID:        "user-editor",
		WorkspaceID:   wsID,
		WorkspaceRole: "editor",
	}

	callerManager := CallerContext{
		UserID:        "user-manager",
		WorkspaceID:   wsID,
		WorkspaceRole: "manager",
	}

	sources := []struct {
		srcType    SourceType
		srcID      string
		title      string
		desc       string
		initStatus string
		targetType TargetType
		targetPerm string
		caller     CallerContext
	}{
		{
			srcType:    SourceTypeOpportunity,
			srcID:      "opp-live-01",
			title:      "Mega Sale Live Opportunity",
			desc:       "High engagement window for evening livestream",
			initStatus: "in_progress",
			targetType: TargetTypeLive,
			caller:     callerEditor,
		},
		{
			srcType:    SourceTypeIdea,
			srcID:      "idea-seeding-01",
			title:      "Unboxing 10 Skincare Samples",
			desc:       "Creator seeding campaign unboxing video idea",
			initStatus: "selected",
			targetType: TargetTypeSeeding,
			caller:     callerEditor,
		},
		{
			srcType:    SourceTypeThread,
			srcID:      "thread-deal-01",
			title:      "Acme Corp Sponsor Message",
			desc:       "Acme asking to sponsor 2 video integrations",
			initStatus: "active",
			targetType: TargetTypeDeal,
			caller:     callerManager,
		},
	}

	for _, s := range sources {
		t.Run(string(s.srcType)+"->"+string(s.targetType)+" survives", func(t *testing.T) {
			srcProvider.AddSource(SourceSnapshot{
				ID:          s.srcID,
				WorkspaceID: wsID,
				Type:        s.srcType,
				Title:       s.title,
				Description: s.desc,
				Status:      s.initStatus,
				Metadata: map[string]any{
					"root_source_type": "trend",
					"root_source_id":   "trend-root-456",
					"lineage_depth":    1,
				},
			})

			res, err := svc.Convert(ctx, s.caller, ConversionParams{
				WorkspaceID: wsID,
				SourceType:  s.srcType,
				SourceID:    s.srcID,
				TargetType:  s.targetType,
				TargetTitle: "Target for " + s.title,
			})

			if err != nil {
				t.Fatalf("conversion failed unexpectedly: %v", err)
			}

			if !res.SourceSurvives {
				t.Errorf("expected res.SourceSurvives to be true")
			}

			// 1. Verify Source Survival via direct VerifySourceSurvival API
			survivedSnap, err := svc.VerifySourceSurvival(ctx, s.caller, s.srcType, s.srcID)
			if err != nil {
				t.Fatalf("VerifySourceSurvival failed: %v", err)
			}

			// Validate all original fields survive!
			if survivedSnap.ID != s.srcID {
				t.Errorf("expected source ID %s, got %s", s.srcID, survivedSnap.ID)
			}
			if survivedSnap.Title != s.title {
				t.Errorf("expected source Title %q, got %q", s.title, survivedSnap.Title)
			}
			if survivedSnap.Description != s.desc {
				t.Errorf("expected source Description %q, got %q", s.desc, survivedSnap.Description)
			}

			// Validate updated conversion pointers
			if survivedSnap.ConvertedToType != string(s.targetType) {
				t.Errorf("expected ConvertedToType %s, got %s", s.targetType, survivedSnap.ConvertedToType)
			}
			if survivedSnap.ConvertedToID != res.TargetID {
				t.Errorf("expected ConvertedToID %s, got %s", res.TargetID, survivedSnap.ConvertedToID)
			}
			if s.srcType == SourceTypeThread {
				if survivedSnap.Status != "converted_to_task" {
					t.Errorf("expected thread status 'converted_to_task', got %q", survivedSnap.Status)
				}
			} else {
				if survivedSnap.Status != "converted" {
					t.Errorf("expected source status 'converted', got %q", survivedSnap.Status)
				}
			}

			// 2. Validate Target Object in target store
			tgtObj, found := tgtCreator.GetTarget(wsID, s.targetType, res.TargetID)
			if !found || tgtObj == nil {
				t.Fatalf("expected target object %s to exist in target store", res.TargetID)
			}
			if tgtObj.SourceRef["source_id"] != s.srcID {
				t.Errorf("target object should reference source_id %s, got %v", s.srcID, tgtObj.SourceRef["source_id"])
			}

			// 3. Validate Shared Lineage Record
			lineageRecs, err := lineageStore.ListLineageBySource(ctx, wsID, s.srcType, s.srcID)
			if err != nil || len(lineageRecs) == 0 {
				t.Fatalf("expected lineage record for source %s, got err=%v len=%d", s.srcID, err, len(lineageRecs))
			}
			rec := lineageRecs[0]
			if rec.TargetID != res.TargetID {
				t.Errorf("lineage record target_id mismatch: %s vs %s", rec.TargetID, res.TargetID)
			}
			if rec.RootSourceType != "trend" || rec.RootSourceID != "trend-root-456" {
				t.Errorf("expected root provenance trend:trend-root-456, got %s:%s", rec.RootSourceType, rec.RootSourceID)
			}
			if rec.LineageDepth != 2 {
				t.Errorf("expected incremented lineage depth 2, got %d", rec.LineageDepth)
			}

			// 4. Validate Lineage Graph
			graph, err := svc.GetLineageGraph(ctx, s.caller, string(s.srcType), s.srcID)
			if err != nil {
				t.Fatalf("GetLineageGraph failed: %v", err)
			}
			if len(graph.Downstream) == 0 {
				t.Errorf("expected downstream lineage nodes, got 0")
			}
			if graph.Downstream[0].ID != res.TargetID {
				t.Errorf("expected downstream node ID %s, got %s", res.TargetID, graph.Downstream[0].ID)
			}

			// 5. Validate Domain Event
			events := eventRecorder.GetEvents()
			foundEvent := false
			expectedEventType := string(s.srcType) + ".converted"
			for _, ev := range events {
				if ev.EventType == expectedEventType && ev.Payload["source_id"] == s.srcID {
					foundEvent = true
					if ev.Payload["target_id"] != res.TargetID {
						t.Errorf("event target_id mismatch: %v vs %s", ev.Payload["target_id"], res.TargetID)
					}
					break
				}
			}
			if !foundEvent {
				t.Errorf("expected domain event %q for source %s was not emitted", expectedEventType, s.srcID)
			}
		})
	}
}

// ----------------------------------------------------------------------------
// REPLAY / IDEMPOTENCY & CONCURRENCY
// ----------------------------------------------------------------------------

func TestReplayAndConcurrency(t *testing.T) {
	ctx := context.Background()
	svc, _, _, srcProvider, _ := setupTestEnvironment()
	wsID := "ws-replay-test"

	caller := CallerContext{
		UserID:        "user-mgr",
		WorkspaceID:   wsID,
		WorkspaceRole: "manager",
	}

	srcID := "opp-replay-01"
	srcTime := time.Now().UTC().Truncate(time.Microsecond)
	srcProvider.AddSource(SourceSnapshot{
		ID:          srcID,
		WorkspaceID: wsID,
		Type:        SourceTypeOpportunity,
		Title:       "Concurrency Opportunity",
		Description: "Testing replay and concurrency locks",
		Status:      "in_progress",
		UpdatedAt:   srcTime,
	})

	// 1. Initial conversion succeeds
	res1, err := svc.Convert(ctx, caller, ConversionParams{
		WorkspaceID:       wsID,
		SourceType:        SourceTypeOpportunity,
		SourceID:          srcID,
		TargetType:        TargetTypeCampaign,
		TargetTitle:       "Campaign 1",
		ExpectedUpdatedAt: &srcTime,
	})
	if err != nil {
		t.Fatalf("first conversion failed: %v", err)
	}
	if res1.TargetID == "" {
		t.Fatalf("expected valid targetID")
	}

	// 2. Replay attempt on already converted source fails with ErrAlreadyConverted
	_, errReplay := svc.Convert(ctx, caller, ConversionParams{
		WorkspaceID: wsID,
		SourceType:  SourceTypeOpportunity,
		SourceID:    srcID,
		TargetType:  TargetTypeCampaign,
		TargetTitle: "Campaign 2 Replay",
	})
	if errReplay == nil {
		t.Fatal("expected replay conversion to fail")
	}
	if !errors.Is(errReplay, ErrAlreadyConverted) {
		t.Errorf("expected ErrAlreadyConverted, got %v", errReplay)
	}

	// 3. Stale timestamp expectedUpdatedAt fails with ErrConcurrentConflict
	freshSourceID := "opp-stale-01"
	srcProvider.AddSource(SourceSnapshot{
		ID:          freshSourceID,
		WorkspaceID: wsID,
		Type:        SourceTypeOpportunity,
		Title:       "Stale Timestamp Test",
		Description: "Valid description",
		Status:      "in_progress",
		UpdatedAt:   time.Now().UTC().Add(time.Minute),
	})

	staleTime := time.Now().UTC().Add(-time.Hour)
	_, errConflict := svc.Convert(ctx, caller, ConversionParams{
		WorkspaceID:       wsID,
		SourceType:        SourceTypeOpportunity,
		SourceID:          freshSourceID,
		TargetType:        TargetTypeCampaign,
		TargetTitle:       "Stale Campaign",
		ExpectedUpdatedAt: &staleTime,
	})
	if errConflict == nil {
		t.Fatal("expected conflict on stale timestamp")
	}
	if !errors.Is(errConflict, ErrConcurrentConflict) {
		t.Errorf("expected ErrConcurrentConflict, got %v", errConflict)
	}

	// 4. Cross-tenant access denied
	_, errCrossTenant := svc.Convert(ctx, caller, ConversionParams{
		WorkspaceID: "ws-different-tenant",
		SourceType:  SourceTypeOpportunity,
		SourceID:    freshSourceID,
		TargetType:  TargetTypeCampaign,
	})
	if errCrossTenant == nil {
		t.Fatal("expected cross tenant to fail")
	}
	if !errors.Is(errCrossTenant, ErrCrossTenantDenied) {
		t.Errorf("expected ErrCrossTenantDenied, got %v", errCrossTenant)
	}
}
