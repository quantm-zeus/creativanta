import { describe, it, expect } from 'vitest';
import {
  validateStateTransition,
  computeSeedingROI,
  evaluateIdempotentSeedingCost,
  type SampleRequest,
  type SeedingCostItem,
} from './seeding';

describe('Seeding CRM & Costs/Outcomes (Module M18)', () => {
  const wsID = '019086a1-7c3e-7000-8000-000000000001';

  // --------------------------------------------------------------------------
  // Target 1: Request, shipment, outcome, and follow-up states separate
  // --------------------------------------------------------------------------
  it('Target 1: validates orthogonal state machine transitions', () => {
    // 1. Initial submitted state: can approve, cannot deliver yet
    const t1 = validateStateTransition('submitted', undefined, 'pending', 'not_started');
    expect(t1.canApprove).toBe(true);
    expect(t1.canShip).toBe(false);
    expect(t1.canDeliver).toBe(false);

    // 2. Approved state: can ship
    const t2 = validateStateTransition('approved', 'label_created', 'pending', 'not_started');
    expect(t2.canApprove).toBe(false);
    expect(t2.canShip).toBe(true);
    expect(t2.canDeliver).toBe(false);

    // 3. In-transit state: can deliver
    const t3 = validateStateTransition('approved', 'in_transit', 'pending', 'not_started');
    expect(t3.canDeliver).toBe(true);

    // 4. Delivered state: logistics fulfilled, follow-up can proceed independently
    const t4 = validateStateTransition('fulfilled', 'delivered', 'pending', 'scheduled');
    expect(t4.canFollowUp).toBe(true);
    expect(t4.canLinkOutcome).toBe(true);

    // 5. Follow-up replied, outcome complete
    const t5 = validateStateTransition('fulfilled', 'delivered', 'complete', 'replied');
    expect(t5.canLinkOutcome).toBe(true);
  });

  // --------------------------------------------------------------------------
  // Target 2: Missing outcome not definitive zero
  // --------------------------------------------------------------------------
  it('Target 2: qualifies delivered samples without outcomes as pending, not definitive zero', () => {
    const requests: SampleRequest[] = [
      {
        sampleRequestId: 'req-delivered-pending',
        workspaceId: wsID,
        creatorEntityId: 'creator-1',
        productId: 'prod-1',
        status: 'fulfilled',
        outcomeStatus: 'pending', // No content outcome yet!
        followUpStatus: 'sent',
        quantity: 2,
        provisionalUnitCost: '150000.000000',
        currency: 'VND',
        shippingAddress: {
          name: 'Nguyen Van A',
          phone: '0901234567',
          addressLine1: '123 Le Loi',
          city: 'HCMC',
          country: 'VN',
        },
        shipment: {
          sampleShipmentId: 'ship-1',
          sampleRequestId: 'req-delivered-pending',
          workspaceId: wsID,
          carrier: 'GHTK',
          trackingNumber: 'GHTK-001',
          status: 'delivered',
          shippingCost: '30000.000000',
          currency: 'VND',
          createdAt: '2026-11-04T00:00:00Z',
          updatedAt: '2026-11-04T00:00:00Z',
        },
        createdAt: '2026-11-04T00:00:00Z',
        updatedAt: '2026-11-04T00:00:00Z',
      },
    ];

    const report = computeSeedingROI(requests, wsID, 'camp-1', 'VND');

    // Total cost = 2 * 150,000 + 30,000 = 330,000 VND
    expect(report.totalCost).toBe('330000.000000');
    expect(report.totalSamplesDelivered).toBe(1);
    expect(report.outcomesLoggedCount).toBe(0);
    expect(report.pendingOutcomesCount).toBe(1);
    expect(report.isMissingOutcomePending).toBe(true);

    // Confidence level cannot be High; must be Medium
    expect(report.overallConfidence).toBe('medium');

    // Confidence notes must explicitly state pending outcome is not zero revenue
    const noteText = report.confidenceNotes.join(' ');
    expect(noteText.toLowerCase()).toContain('pending');
    expect(noteText.toLowerCase()).toContain('not definitive zero revenue');
  });

  // --------------------------------------------------------------------------
  // Target 3: Replay no duplicate sample cost
  // --------------------------------------------------------------------------
  it('Target 3: replay with same idempotency key updates in-place without duplicating cost items', () => {
    const existing: SeedingCostItem[] = [];
    const reqID = 'req-replay-test';
    const idempKey = 'idemp-sample-cost-1';

    // 1. First approval: creates cost item (2 * 100,000 + 0 shipping = 200,000 VND)
    const firstResult = evaluateIdempotentSeedingCost(
      existing,
      reqID,
      wsID,
      2,
      '100000.000000',
      '0.000000',
      idempKey
    );
    expect(firstResult.isReplay).toBe(false);
    expect(firstResult.costItems.length).toBe(1);
    expect(firstResult.totalCost).toBe('200000.000000');

    // 2. Replay approval: should return existing without duplicating
    const replayApprove = evaluateIdempotentSeedingCost(
      firstResult.costItems,
      reqID,
      wsID,
      2,
      '100000.000000',
      '0.000000',
      idempKey
    );
    expect(replayApprove.isReplay).toBe(true);
    expect(replayApprove.costItems.length).toBe(1); // STILL 1!
    expect(replayApprove.totalCost).toBe('200000.000000');

    // 3. Shipment updates cost with actual shipping (200,000 + 35,000 = 235,000 VND)
    const shipResult = evaluateIdempotentSeedingCost(
      replayApprove.costItems,
      reqID,
      wsID,
      2,
      '100000.000000',
      '35000.000000',
      'idemp-ship-cost-1'
    );
    expect(shipResult.isReplay).toBe(true);
    expect(shipResult.costItems.length).toBe(1); // STILL 1, updated in-place!
    expect(shipResult.totalCost).toBe('235000.000000');
  });
});
