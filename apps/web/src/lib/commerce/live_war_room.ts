/**
 * Live Commerce War Room Domain Model & Real-Time Orchestration
 * Module M17 (docs/02_features/commerce/live_war_room.md)
 * Module M09 (docs/02_features/production/asset_derivatives.md)
 *
 * Implements:
 * - RULE-M17-001: Live session canonical lifecycle (planned -> ready -> live -> paused -> ended -> post_live_processing -> closed)
 * - RULE-M17-002: Cues and highlights linking to parent live_session_id
 * - RULE-M17-003: Post-live proof document generation for M19 proof layer
 * - RULE-M17-004: Revenue traceability chain (Session -> Product -> Offer -> Order -> Revenue)
 * - Acceptance Target 1: Reconnect does not duplicate commands
 * - Acceptance Target 2: M07 extracts, M09 registers clips
 * - Acceptance Target 3: Revenue traceable and labeled
 */

export type LiveSessionStatus =
  | 'planned'
  | 'ready'
  | 'live'
  | 'paused'
  | 'ended'
  | 'post_live_processing'
  | 'closed';

export type CueCardStatus = 'pending' | 'active' | 'used' | 'skipped';

export interface RunOfShowItem {
  timeOffsetMin: number;
  type: 'product_pin' | 'poll' | 'giveaway' | 'cta' | 'break' | 'talking_point';
  title: string;
  productId?: string;
  offerId?: string;
  notes?: string;
  durationMin?: number;
  executed: boolean;
  executedAt?: string;
  cueCardIds?: string[];
}

export interface LiveMetricsSnapshot {
  peakViewers: number;
  avgViewers: number;
  totalViewers: number;
  totalComments: number;
  totalLikes: number;
  totalShares: number;
  productsShown: number;
  ordersDuringLive: number;
  revenueDuringLive: string; // Exact numeric string (NUMERIC 18,6)
  revenueCurrency: string;
  engagementRate: number;
}

export interface LiveSession {
  sessionId: string;
  workspaceId: string;
  title: string;
  platform: string;
  connectedAccountId?: string;
  status: LiveSessionStatus;
  plannedStartAt?: string;
  actualStartAt?: string;
  actualEndAt?: string;
  runOfShow: RunOfShowItem[];
  metricsSnapshot: LiveMetricsSnapshot;
  metadata: Record<string, any>;
  createdAt: string;
  updatedAt: string;
}

export interface CueCard {
  cueCardId: string;
  sessionId: string;
  workspaceId: string;
  segmentId?: string;
  cueType: 'product_highlight' | 'talking_point' | 'price_drop' | 'giveaway' | 'qa_prompt' | 'cta' | 'transition';
  title: string;
  body: string;
  pinnedProductId?: string;
  pinnedOfferId?: string;
  displayOrder: number;
  triggeredAt?: string;
  status: CueCardStatus;
  createdAt: string;
  updatedAt: string;
}

export interface Highlight {
  highlightId: string;
  sessionId: string;
  workspaceId: string;
  title: string;
  startOffsetSeconds: number;
  endOffsetSeconds: number;
  highlightType: string;
  autoDetected: boolean;
  assetId?: string; // M09 clip derivative link
  engagementScore: number;
  notes?: string;
  pinnedOfferId?: string;
  pinnedProductId?: string;
  createdAt: string;
  updatedAt: string;
}

export interface TraceableOrderLink {
  orderId: string;
  productId: string;
  offerId: string;
  customerId: string;
  amount: string; // Exact numeric string
  currency: string;
  createdAt: string;
  reconciliationState: string;
}

export interface PostLiveProofSummary {
  summaryId: string;
  sessionId: string;
  workspaceId: string;
  sessionTitle: string;
  platform: string;
  metrics: LiveMetricsSnapshot;
  highlights: Highlight[];
  extractedClipAssetIds: string[];
  orders: TraceableOrderLink[];
  totalRevenue: string; // Exact numeric string
  revenueCurrency: string;
  sourceClass: 'live_attributed';
  proofBundleId: string;
  generatedAt: string;
}

export interface CommentTriageItem {
  commentId: string;
  sessionId: string;
  author: string;
  text: string;
  intent: 'purchase_intent' | 'objection' | 'question' | 'praise';
  isPriority: boolean;
  timestamp: string;
}

// In-Memory Idempotency & State Manager for Reconnection Resilience
export class LiveWarRoomClient {
  private executedCommands = new Set<string>();
  private sessionState: LiveSession | null = null;
  private cueCards: CueCard[] = [];
  private highlights: Highlight[] = [];
  private orders: TraceableOrderLink[] = [];

  constructor(session?: LiveSession) {
    if (session) {
      this.sessionState = { ...session };
    }
  }

  getSession(): LiveSession | null {
    return this.sessionState;
  }

  getCueCards(): CueCard[] {
    return [...this.cueCards];
  }

  getHighlights(): Highlight[] {
    return [...this.highlights];
  }

  getOrders(): TraceableOrderLink[] {
    return [...this.orders];
  }

  /**
   * Acceptance Target 1: Reconnect does not duplicate commands.
   * Checks if an idempotency key has already been executed.
   */
  hasExecuted(idempotencyKey: string): boolean {
    if (!idempotencyKey) return false;
    return this.executedCommands.has(idempotencyKey);
  }

  recordCommand(idempotencyKey: string): void {
    if (idempotencyKey) {
      this.executedCommands.add(idempotencyKey);
    }
  }

  /**
   * Initializes or creates a new session.
   */
  createSession(
    workspaceId: string,
    title: string,
    platform: string,
    idempotencyKey?: string,
    runOfShow: RunOfShowItem[] = []
  ): { session: LiveSession; isDuplicate: boolean } {
    if (idempotencyKey && this.hasExecuted(idempotencyKey) && this.sessionState) {
      return { session: this.sessionState, isDuplicate: true };
    }

    const now = new Date().toISOString();
    this.sessionState = {
      sessionId: `live-sess-${Date.now()}`,
      workspaceId,
      title,
      platform,
      status: 'planned',
      runOfShow,
      metricsSnapshot: {
        peakViewers: 0,
        avgViewers: 0,
        totalViewers: 0,
        totalComments: 0,
        totalLikes: 0,
        totalShares: 0,
        productsShown: 0,
        ordersDuringLive: 0,
        revenueDuringLive: '0.000000',
        revenueCurrency: 'VND',
        engagementRate: 0.0,
      },
      metadata: {},
      createdAt: now,
      updatedAt: now,
    };

    if (idempotencyKey) this.recordCommand(idempotencyKey);
    return { session: this.sessionState, isDuplicate: false };
  }

  /**
   * Transitions session to live (RULE-M17-001).
   */
  startSession(idempotencyKey?: string): { session: LiveSession; isDuplicate: boolean } {
    if (!this.sessionState) throw new Error('Session not initialized');
    if (idempotencyKey && this.hasExecuted(idempotencyKey)) {
      return { session: this.sessionState, isDuplicate: true };
    }
    if (this.sessionState.status === 'live') {
      return { session: this.sessionState, isDuplicate: true };
    }

    this.sessionState.status = 'live';
    this.sessionState.actualStartAt = new Date().toISOString();
    this.sessionState.updatedAt = new Date().toISOString();

    if (idempotencyKey) this.recordCommand(idempotencyKey);
    return { session: this.sessionState, isDuplicate: false };
  }

  /**
   * Adds an operational cue card.
   */
  addCueCard(
    cueType: CueCard['cueType'],
    title: string,
    body: string,
    pinnedProductId?: string,
    pinnedOfferId?: string,
    idempotencyKey?: string
  ): { cueCard: CueCard; isDuplicate: boolean } {
    if (!this.sessionState) throw new Error('Session not initialized');
    if (idempotencyKey && this.hasExecuted(idempotencyKey)) {
      const existing = this.cueCards.find((c) => c.title === title);
      if (existing) return { cueCard: existing, isDuplicate: true };
    }

    const now = new Date().toISOString();
    const cue: CueCard = {
      cueCardId: `cue-${Date.now()}-${this.cueCards.length}`,
      sessionId: this.sessionState.sessionId,
      workspaceId: this.sessionState.workspaceId,
      cueType,
      title,
      body,
      pinnedProductId,
      pinnedOfferId,
      displayOrder: this.cueCards.length + 1,
      status: 'pending',
      createdAt: now,
      updatedAt: now,
    };

    this.cueCards.push(cue);
    if (idempotencyKey) this.recordCommand(idempotencyKey);
    return { cueCard: cue, isDuplicate: false };
  }

  /**
   * Triggers a cue card.
   */
  triggerCueCard(cueCardId: string, idempotencyKey?: string): { cueCard: CueCard; isDuplicate: boolean } {
    const cue = this.cueCards.find((c) => c.cueCardId === cueCardId);
    if (!cue) throw new Error(`Cue card ${cueCardId} not found`);

    if (idempotencyKey && this.hasExecuted(idempotencyKey)) {
      return { cueCard: cue, isDuplicate: true };
    }
    if (cue.status === 'used') {
      return { cueCard: cue, isDuplicate: true };
    }

    cue.status = 'used';
    cue.triggeredAt = new Date().toISOString();
    cue.updatedAt = new Date().toISOString();

    if (idempotencyKey) this.recordCommand(idempotencyKey);
    return { cueCard: cue, isDuplicate: false };
  }

  /**
   * Pins or unpins product/offer on live timeline.
   */
  highlightProduct(
    productId: string,
    offerId: string,
    isPinned: boolean,
    offsetSec: number,
    idempotencyKey?: string
  ): { isPinned: boolean; isDuplicate: boolean } {
    if (!this.sessionState) throw new Error('Session not initialized');
    if (idempotencyKey && this.hasExecuted(idempotencyKey)) {
      return { isPinned, isDuplicate: true };
    }

    if (isPinned) {
      this.sessionState.metadata['currently_pinned_product_id'] = productId;
      this.sessionState.metadata['currently_pinned_offer_id'] = offerId;
      this.sessionState.metadata['pinned_at_offset_sec'] = offsetSec;
    } else {
      delete this.sessionState.metadata['currently_pinned_product_id'];
      delete this.sessionState.metadata['currently_pinned_offer_id'];
      delete this.sessionState.metadata['pinned_at_offset_sec'];
    }

    if (idempotencyKey) this.recordCommand(idempotencyKey);
    return { isPinned, isDuplicate: false };
  }

  /**
   * Creates/marks a highlight moment.
   */
  createHighlight(
    title: string,
    highlightType: string,
    startSec: number,
    endSec: number,
    notes?: string,
    pinnedOfferId?: string,
    idempotencyKey?: string
  ): { highlight: Highlight; isDuplicate: boolean } {
    if (!this.sessionState) throw new Error('Session not initialized');
    if (idempotencyKey && this.hasExecuted(idempotencyKey)) {
      const existing = this.highlights.find((h) => h.title === title && h.startOffsetSeconds === startSec);
      if (existing) return { highlight: existing, isDuplicate: true };
    }

    const now = new Date().toISOString();
    const hl: Highlight = {
      highlightId: `hl-${Date.now()}-${this.highlights.length}`,
      sessionId: this.sessionState.sessionId,
      workspaceId: this.sessionState.workspaceId,
      title,
      highlightType,
      startOffsetSeconds: startSec,
      endOffsetSeconds: endSec,
      autoDetected: false,
      engagementScore: 90.0,
      notes,
      pinnedOfferId,
      createdAt: now,
      updatedAt: now,
    };

    this.highlights.push(hl);
    if (idempotencyKey) this.recordCommand(idempotencyKey);
    return { highlight: hl, isDuplicate: false };
  }

  /**
   * Acceptance Target 2: M07 extracts, M09 registers clips.
   * Simulates M07 extraction and sets M09 derivative asset ID on each highlight.
   */
  extractHighlights(
    sourceAssetId: string,
    idempotencyKey?: string
  ): { extractedCount: number; registeredAssetIds: string[]; isDuplicate: boolean } {
    if (!sourceAssetId) throw new Error('sourceAssetId is required for extraction');
    if (idempotencyKey && this.hasExecuted(idempotencyKey)) {
      const existingAssets = this.highlights.filter((h) => !!h.assetId).map((h) => h.assetId!);
      return { extractedCount: existingAssets.length, registeredAssetIds: existingAssets, isDuplicate: true };
    }

    const registeredAssetIds: string[] = [];
    for (const hl of this.highlights) {
      if (!hl.assetId) {
        // M09 derivative clip registration
        const clipAssetId = `asset-clip-${Date.now()}-${registeredAssetIds.length + 1}`;
        hl.assetId = clipAssetId;
        registeredAssetIds.push(clipAssetId);
      } else {
        registeredAssetIds.push(hl.assetId);
      }
    }

    if (idempotencyKey) this.recordCommand(idempotencyKey);
    return {
      extractedCount: registeredAssetIds.length,
      registeredAssetIds,
      isDuplicate: false,
    };
  }

  /**
   * Attaches an order arriving during live session (Acceptance Target 3).
   */
  attachOrder(order: TraceableOrderLink): void {
    this.orders.push(order);
  }

  /**
   * Acceptance Target 3: Revenue traceable and labeled.
   * Compiles post-live summary proof document.
   */
  generatePostLiveProofSummary(): PostLiveProofSummary {
    if (!this.sessionState) throw new Error('Session not initialized');

    // Aggregate exact revenue
    let totalMicros = 0n;
    for (const o of this.orders) {
      const parts = o.amount.split('.');
      const intPart = BigInt(parts[0]);
      const fracPart = parts[1] ? parts[1].padEnd(6, '0').slice(0, 6) : '000000';
      const microVal = intPart * 1000000n + BigInt(fracPart);
      totalMicros += microVal;
    }

    const whole = totalMicros / 1000000n;
    const frac = (totalMicros % 1000000n).toString().padStart(6, '0');
    const totalRevStr = `${whole}.${frac}`;

    const metrics: LiveMetricsSnapshot = {
      ...this.sessionState.metricsSnapshot,
      ordersDuringLive: this.orders.length,
      revenueDuringLive: totalRevStr,
      revenueCurrency: 'VND',
    };

    const extractedAssets = this.highlights.filter((h) => !!h.assetId).map((h) => h.assetId!);

    return {
      summaryId: `summary-${Date.now()}`,
      sessionId: this.sessionState.sessionId,
      workspaceId: this.sessionState.workspaceId,
      sessionTitle: this.sessionState.title,
      platform: this.sessionState.platform,
      metrics,
      highlights: [...this.highlights],
      extractedClipAssetIds: extractedAssets,
      orders: [...this.orders],
      totalRevenue: totalRevStr,
      revenueCurrency: 'VND',
      sourceClass: 'live_attributed', // Labeled revenue
      proofBundleId: `bundle-${Date.now()}`,
      generatedAt: new Date().toISOString(),
    };
  }

  /**
   * Triages incoming live chat comment for high purchase intent or objections.
   */
  static triageComment(commentId: string, sessionId: string, author: string, text: string): CommentTriageItem {
    const lower = text.toLowerCase();
    let intent: CommentTriageItem['intent'] = 'question';
    let isPriority = false;

    if (
      lower.includes('mua') ||
      lower.includes('giá') ||
      lower.includes('bao nhiêu') ||
      lower.includes('chốt') ||
      lower.includes('đặt') ||
      lower.includes('order') ||
      lower.includes('buy')
    ) {
      intent = 'purchase_intent';
      isPriority = true;
    } else if (
      lower.includes('hàng giả') ||
      lower.includes('đắt') ||
      lower.includes('lỗi') ||
      lower.includes('khiếu nại') ||
      lower.includes('fake')
    ) {
      intent = 'objection';
      isPriority = true;
    } else if (lower.includes('thích') || lower.includes('xịn') || lower.includes('đẹp') || lower.includes('love')) {
      intent = 'praise';
    }

    return {
      commentId,
      sessionId,
      author,
      text,
      intent,
      isPriority,
      timestamp: new Date().toISOString(),
    };
  }
}
