/**
 * Seeding CRM và Costs/Outcomes (Module M18)
 * Canonical Sources:
 * - docs/02_features/commerce/seeding_crm.md
 * - docs/04_contracts/database_schema.md#sample_requests
 * - docs/04_contracts/database_schema.md#sample_shipments
 * - docs/04_contracts/financial_computation_contract.md
 *
 * Implements:
 * - Acceptance Target 1: Request, shipment, outcome, and follow-up states separate
 * - Acceptance Target 2: Missing outcome not definitive zero
 * - Acceptance Target 3: Replay no duplicate sample cost
 */

export type SampleRequestStatus =
  | 'submitted'
  | 'under_review'
  | 'approved'
  | 'declined'
  | 'fulfilled'
  | 'cancelled';

export type SampleShipmentStatus =
  | 'label_created'
  | 'shipped'
  | 'in_transit'
  | 'out_for_delivery'
  | 'delivered'
  | 'failed_delivery'
  | 'returned';

export type SampleOutcomeStatus =
  | 'pending'
  | 'claimed'
  | 'partial'
  | 'complete'
  | 'unresponsive'
  | 'waived';

export type FollowUpStatus =
  | 'not_started'
  | 'scheduled'
  | 'sent'
  | 'replied'
  | 'overdue'
  | 'abandoned';

export type SeedingSourceClass =
  | 'official'
  | 'imported'
  | 'inferred'
  | 'estimated'
  | 'unreconciled';

export type SeedingConfidenceLevel = 'high' | 'medium' | 'low';

export interface ShippingAddress {
  name: string;
  phone: string;
  addressLine1: string;
  addressLine2?: string;
  city: string;
  postalCode?: string;
  country: string;
}

export interface SampleShipment {
  sampleShipmentId: string;
  sampleRequestId: string;
  workspaceId: string;
  carrier: string;
  trackingNumber: string;
  status: SampleShipmentStatus;
  shippingCost: string; // Exact decimal string e.g. "30000.000000"
  currency: string;
  shippedAt?: string;
  deliveredAt?: string;
  notes?: string;
  createdAt: string;
  updatedAt: string;
}

export interface SampleOutcome {
  contentUrl?: string;
  contentType?: string;
  publishItemId?: string;
  attributedOrders: number;
  attributedGmv: string; // Exact decimal string
  attributedComm: string; // Exact decimal string
  currency: string;
  sourceClass: SeedingSourceClass;
  confidenceLevel: SeedingConfidenceLevel;
  confidenceReason?: string;
  notes?: string;
  loggedAt: string;
}

export interface SampleRequest {
  sampleRequestId: string;
  workspaceId: string;
  campaignId?: string;
  creatorEntityId: string;
  productId: string;
  status: SampleRequestStatus;
  outcomeStatus: SampleOutcomeStatus;
  followUpStatus: FollowUpStatus;
  quantity: number;
  provisionalUnitCost: string; // Exact decimal string per unit
  currency: string;
  shippingAddress: ShippingAddress;
  contentRequirements?: string;
  deadline?: string;
  declineReason?: string;
  notes?: string;
  shipment?: SampleShipment;
  outcome?: SampleOutcome;
  productTitle?: string;
  creatorName?: string;
  creatorHandle?: string;
  creatorPlatform?: string;
  createdAt: string;
  updatedAt: string;
}

export interface SeedingCostItem {
  costItemId: string;
  workspaceId: string;
  sampleRequestId: string;
  costType: 'seeding';
  amount: string; // Exact decimal string
  currency: string;
  sourceClass: string;
  description: string;
  idempotencyKey?: string;
  createdAt: string;
  updatedAt: string;
}

export interface SeedingCampaign {
  campaignId: string;
  workspaceId: string;
  title: string;
  objective: string;
  status: 'draft' | 'active' | 'completed' | 'paused';
  startDate?: string;
  endDate?: string;
  budget: string;
  budgetCurrency: string;
  relatedProductIds?: string[];
  createdAt: string;
  updatedAt: string;
}

export interface SeedingROIReport {
  campaignId?: string;
  workspaceId: string;
  totalSamplesRequested: number;
  totalSamplesApproved: number;
  totalSamplesShipped: number;
  totalSamplesDelivered: number;
  outcomesLoggedCount: number;
  pendingOutcomesCount: number;
  outcomeCoverageRate: string; // e.g. "50.0%"
  totalCogs: string;
  totalShipping: string;
  totalCost: string;
  attributableRevenue: string;
  roiPercentage: string;
  overallConfidence: SeedingConfidenceLevel;
  confidenceNotes: string[];
  currency: string;
  isMissingOutcomePending: boolean;
}

// ----------------------------------------------------------------------------
// Target 1: Orthogonal State Machine Operations
// ----------------------------------------------------------------------------

/**
 * Validates orthogonal state transitions.
 * Request status, shipment status, outcome status, and follow-up status
 * transition independently across their respective lifecycles.
 */
export function validateStateTransition(
  currentRequestStatus: SampleRequestStatus,
  currentShipmentStatus?: SampleShipmentStatus,
  currentOutcomeStatus?: SampleOutcomeStatus,
  currentFollowUpStatus?: FollowUpStatus
): {
  canApprove: boolean;
  canShip: boolean;
  canDeliver: boolean;
  canFollowUp: boolean;
  canLinkOutcome: boolean;
} {
  const canApprove =
    currentRequestStatus === 'submitted' || currentRequestStatus === 'under_review';

  const canShip =
    currentRequestStatus === 'approved' &&
    (!currentShipmentStatus ||
      currentShipmentStatus === 'label_created' ||
      currentShipmentStatus === 'failed_delivery');

  const canDeliver =
    currentShipmentStatus === 'shipped' ||
    currentShipmentStatus === 'in_transit' ||
    currentShipmentStatus === 'out_for_delivery';

  // Follow-up can be updated once sample is delivered or in transit
  const canFollowUp =
    currentRequestStatus === 'fulfilled' ||
    currentShipmentStatus === 'delivered' ||
    currentFollowUpStatus !== 'abandoned';

  // Outcome can be linked regardless of whether follow-up is finished or still ongoing
  const canLinkOutcome =
    currentRequestStatus === 'approved' || currentRequestStatus === 'fulfilled';

  return {
    canApprove,
    canShip,
    canDeliver,
    canFollowUp,
    canLinkOutcome,
  };
}

// ----------------------------------------------------------------------------
// Target 2: Missing Outcome Not Definitive Zero
// ----------------------------------------------------------------------------

/**
 * Calculates campaign Seeding ROI while enforcing:
 * Acceptance Target 2: Missing outcome not definitive zero.
 * Delivered samples without logged outcomes are tracked as pending outcomes.
 * The system never reports 0 revenue as definitive loss when outcomes are pending.
 */
export function computeSeedingROI(
  requests: SampleRequest[],
  workspaceId: string,
  campaignId?: string,
  currency: string = 'VND'
): SeedingROIReport {
  let totalRequested = 0;
  let totalApproved = 0;
  let totalShipped = 0;
  let totalDelivered = 0;
  let outcomesLogged = 0;

  let totalCogsMicro = 0n;
  let totalShippingMicro = 0n;
  let totalRevenueMicro = 0n;

  const notes: string[] = [];

  for (const req of requests) {
    totalRequested++;
    if (req.status === 'approved' || req.status === 'fulfilled') {
      totalApproved++;
    }

    if (req.shipment) {
      if (
        req.shipment.status === 'shipped' ||
        req.shipment.status === 'in_transit' ||
        req.shipment.status === 'out_for_delivery' ||
        req.shipment.status === 'delivered'
      ) {
        totalShipped++;
      }
      if (req.shipment.status === 'delivered') {
        totalDelivered++;
      }

      const shipCostMicro = parseDecimalToMicro(req.shipment.shippingCost || '0.000000');
      totalShippingMicro += shipCostMicro;
    }

    // COGS
    const unitCostMicro = parseDecimalToMicro(req.provisionalUnitCost || '0.000000');
    totalCogsMicro += unitCostMicro * BigInt(req.quantity || 1);

    // Outcome
    if (req.outcomeStatus === 'complete' || req.outcomeStatus === 'claimed' || req.outcome) {
      outcomesLogged++;
      if (req.outcome) {
        const revMicro = parseDecimalToMicro(req.outcome.attributedGmv || '0.000000');
        totalRevenueMicro += revMicro;
      }
    }
  }

  const pendingOutcomesCount = Math.max(0, totalDelivered - outcomesLogged);
  const isMissingOutcomePending = pendingOutcomesCount > 0;

  let overallConfidence: SeedingConfidenceLevel = 'high';

  if (isMissingOutcomePending) {
    overallConfidence = 'medium';
    notes.push(
      `${pendingOutcomesCount} delivered sample(s) have pending content/conversion outcomes; missing data is qualified as pending, not definitive zero revenue.`
    );
  } else if (totalDelivered === 0) {
    overallConfidence = 'medium';
    notes.push('No samples delivered yet; pending shipment and creator receipt.');
  } else {
    notes.push('All delivered samples have verified logged outcomes.');
  }

  const totalCostMicro = totalCogsMicro + totalShippingMicro;
  const coverageRate =
    totalDelivered > 0
      ? `${((outcomesLogged / totalDelivered) * 100).toFixed(1)}%`
      : '0.0%';

  let roiPercentage = '0.00%';
  if (totalCostMicro > 0n) {
    const netProfitMicro = totalRevenueMicro - totalCostMicro;
    const roi = (Number(netProfitMicro) / Number(totalCostMicro)) * 100;
    roiPercentage = `${roi >= 0 ? '+' : ''}${roi.toFixed(2)}%`;
  }

  return {
    campaignId,
    workspaceId,
    totalSamplesRequested: totalRequested,
    totalSamplesApproved: totalApproved,
    totalSamplesShipped: totalShipped,
    totalSamplesDelivered: totalDelivered,
    outcomesLoggedCount: outcomesLogged,
    pendingOutcomesCount,
    outcomeCoverageRate: coverageRate,
    totalCogs: formatMicroToDecimal(totalCogsMicro),
    totalShipping: formatMicroToDecimal(totalShippingMicro),
    totalCost: formatMicroToDecimal(totalCostMicro),
    attributableRevenue: formatMicroToDecimal(totalRevenueMicro),
    roiPercentage,
    overallConfidence,
    confidenceNotes: notes,
    currency,
    isMissingOutcomePending,
  };
}

// ----------------------------------------------------------------------------
// Target 3: Replay No Duplicate Sample Cost
// ----------------------------------------------------------------------------

/**
 * Evaluates cost creation / replay for sample approvals and shipments.
 * Enforces: Replaying approve or ship with the same idempotency key
 * updates/returns existing cost items without creating duplicates.
 */
export function evaluateIdempotentSeedingCost(
  existingCostItems: SeedingCostItem[],
  sampleRequestId: string,
  workspaceId: string,
  quantity: number,
  unitCost: string,
  shippingCost: string,
  idempotencyKey?: string
): {
  costItems: SeedingCostItem[];
  isReplay: boolean;
  totalCost: string;
} {
  // Check if cost item already exists for this sample request
  const existing = existingCostItems.find(
    (c) =>
      c.sampleRequestId === sampleRequestId ||
      (idempotencyKey && c.idempotencyKey === idempotencyKey)
  );

  const unitCostMicro = parseDecimalToMicro(unitCost);
  const shipCostMicro = parseDecimalToMicro(shippingCost);
  const cogsMicro = unitCostMicro * BigInt(quantity);
  const totalMicro = cogsMicro + shipCostMicro;
  const totalCost = formatMicroToDecimal(totalMicro);

  if (existing) {
    // Replay / update in-place without duplicating
    const updated: SeedingCostItem = {
      ...existing,
      amount: totalCost,
      description: `Seeding cost: ${quantity} x COGS (${unitCost}) + shipping (${shippingCost})`,
      updatedAt: new Date().toISOString(),
    };
    return {
      costItems: existingCostItems.map((c) =>
        c.costItemId === existing.costItemId ? updated : c
      ),
      isReplay: true,
      totalCost,
    };
  }

  // Create new cost item
  const newItem: SeedingCostItem = {
    costItemId: `cost-${Math.random().toString(36).substring(2, 10)}`,
    workspaceId,
    sampleRequestId,
    costType: 'seeding',
    amount: totalCost,
    currency: 'VND',
    sourceClass: 'estimated',
    description: `Seeding cost: ${quantity} x COGS (${unitCost}) + shipping (${shippingCost})`,
    idempotencyKey,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  };

  return {
    costItems: [...existingCostItems, newItem],
    isReplay: false,
    totalCost,
  };
}

// ----------------------------------------------------------------------------
// Helpers: Exact Decimal Math (Fixed 6 digits)
// ----------------------------------------------------------------------------

export function parseDecimalToMicro(val: string): bigint {
  const clean = val.trim();
  if (!clean) return 0n;

  const parts = clean.split('.');
  const whole = BigInt(parts[0] || '0');
  const fractionStr = (parts[1] || '').padEnd(6, '0').slice(0, 6);
  const fraction = BigInt(fractionStr);

  const isNeg = clean.startsWith('-');
  const wholeAbs = whole < 0n ? -whole : whole;
  const total = wholeAbs * 1000000n + fraction;
  return isNeg ? -total : total;
}

export function formatMicroToDecimal(micro: bigint): string {
  const isNeg = micro < 0n;
  const abs = isNeg ? -micro : micro;
  const whole = abs / 1000000n;
  const frac = abs % 1000000n;
  const fracStr = frac.toString().padStart(6, '0');
  return `${isNeg ? '-' : ''}${whole.toString()}.${fracStr}`;
}
