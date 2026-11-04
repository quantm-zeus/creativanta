import { describe, expect, it } from 'vitest';
import { LiveWarRoomClient } from './live_war_room';

describe('M17 Live War Room — Domain & Acceptance Targets', () => {
  const workspaceId = '019086a1-7c3e-7000-8000-000000000001';

  it('Target 1: Reconnect does not duplicate commands', () => {
    const client = new LiveWarRoomClient();

    // 1. Create session with idempotency key
    const idempCreate = 'client-idemp-create-001';
    const res1 = client.createSession(workspaceId, 'Big TikTok Live', 'tiktok_live', idempCreate);
    expect(res1.isDuplicate).toBe(false);
    expect(res1.session.status).toBe('planned');

    // Replay on network reconnect
    const res2 = client.createSession(workspaceId, 'Big TikTok Live', 'tiktok_live', idempCreate);
    expect(res2.isDuplicate).toBe(true);
    expect(res2.session.sessionId).toBe(res1.session.sessionId);

    // 2. Start session with idempotency key
    const idempStart = 'client-idemp-start-001';
    const start1 = client.startSession(idempStart);
    expect(start1.isDuplicate).toBe(false);
    expect(start1.session.status).toBe('live');

    // Replay on reconnect
    const start2 = client.startSession(idempStart);
    expect(start2.isDuplicate).toBe(true);
    expect(start2.session.status).toBe('live');

    // 3. Add cue card with idempotency key
    const idempCue = 'client-idemp-cue-001';
    const cue1 = client.addCueCard('product_highlight', 'Flash Drop Serum', 'Tell viewers deal ends in 5m', 'prod-1', 'off-1', idempCue);
    expect(cue1.isDuplicate).toBe(false);
    expect(client.getCueCards()).toHaveLength(1);

    // Replay AddCue
    const cue2 = client.addCueCard('product_highlight', 'Flash Drop Serum', 'Tell viewers deal ends in 5m', 'prod-1', 'off-1', idempCue);
    expect(cue2.isDuplicate).toBe(true);
    expect(client.getCueCards()).toHaveLength(1);

    // 4. Trigger cue with idempotency key
    const idempTrig = 'client-idemp-trig-001';
    const trig1 = client.triggerCueCard(cue1.cueCard.cueCardId, idempTrig);
    expect(trig1.isDuplicate).toBe(false);
    expect(trig1.cueCard.status).toBe('used');

    // Replay TriggerCue
    const trig2 = client.triggerCueCard(cue1.cueCard.cueCardId, idempTrig);
    expect(trig2.isDuplicate).toBe(true);
    expect(trig2.cueCard.status).toBe('used');

    // 5. Highlight product with idempotency key
    const idempPin = 'client-idemp-pin-001';
    const pin1 = client.highlightProduct('prod-1', 'off-1', true, 120, idempPin);
    expect(pin1.isDuplicate).toBe(false);
    expect(pin1.isPinned).toBe(true);

    const pin2 = client.highlightProduct('prod-1', 'off-1', true, 120, idempPin);
    expect(pin2.isDuplicate).toBe(true);

    // 6. Create highlight with idempotency key
    const idempHl = 'client-idemp-hl-001';
    const hl1 = client.createHighlight('Audience Surge', 'viral_moment', 100, 140, 'Deal drop moment', 'off-1', idempHl);
    expect(hl1.isDuplicate).toBe(false);
    expect(client.getHighlights()).toHaveLength(1);

    const hl2 = client.createHighlight('Audience Surge', 'viral_moment', 100, 140, 'Deal drop moment', 'off-1', idempHl);
    expect(hl2.isDuplicate).toBe(true);
    expect(client.getHighlights()).toHaveLength(1);
  });

  it('Target 2: M07 extracts, M09 registers clips', () => {
    const client = new LiveWarRoomClient();
    client.createSession(workspaceId, 'Highlight Extraction Test', 'tiktok_live');
    client.startSession();

    // Mark 3 highlights during live
    client.createHighlight('Intro Hook', 'intro', 0, 30);
    client.createHighlight('Serum Demo', 'product_demo', 120, 180);
    client.createHighlight('Q&A Best Answer', 'qa_prompt', 300, 340);

    const initialHighlights = client.getHighlights();
    expect(initialHighlights).toHaveLength(3);
    for (const h of initialHighlights) {
      expect(h.assetId).toBeUndefined();
    }

    // Run extraction with source recording asset
    const sourceAssetId = 'source-video-recording-xyz';
    const ext = client.extractHighlights(sourceAssetId, 'idemp-ext-001');

    expect(ext.isDuplicate).toBe(false);
    expect(ext.extractedCount).toBe(3);
    expect(ext.registeredAssetIds).toHaveLength(3);

    // Verify all highlights now link to M09 registered derivative assets
    for (const h of client.getHighlights()) {
      expect(h.assetId).toBeDefined();
      expect(h.assetId).toMatch(/^asset-clip-/);
    }
  });

  it('Target 3: Revenue traceable and labeled', () => {
    const client = new LiveWarRoomClient();
    client.createSession(workspaceId, 'Revenue Traceability Live', 'tiktok_live');
    client.startSession();

    // Attach 3 orders arriving during the live session
    client.attachOrder({
      orderId: 'ord-001',
      productId: 'prod-001',
      offerId: 'off-001',
      customerId: 'cust-101',
      amount: '200000.000000',
      currency: 'VND',
      createdAt: new Date().toISOString(),
      reconciliationState: 'matched',
    });
    client.attachOrder({
      orderId: 'ord-002',
      productId: 'prod-002',
      offerId: 'off-002',
      customerId: 'cust-102',
      amount: '350000.000000',
      currency: 'VND',
      createdAt: new Date().toISOString(),
      reconciliationState: 'matched',
    });
    client.attachOrder({
      orderId: 'ord-003',
      productId: 'prod-001',
      offerId: 'off-001',
      customerId: 'cust-103',
      amount: '150000.000000',
      currency: 'VND',
      createdAt: new Date().toISOString(),
      reconciliationState: 'matched',
    });

    const summary = client.generatePostLiveProofSummary();

    // Verify labeled revenue and proof attributes
    expect(summary.sourceClass).toBe('live_attributed');
    expect(summary.orders).toHaveLength(3);
    // 200,000 + 350,000 + 150,000 = 700,000.000000
    expect(summary.totalRevenue).toBe('700000.000000');
    expect(summary.metrics.ordersDuringLive).toBe(3);
    expect(summary.metrics.revenueDuringLive).toBe('700000.000000');

    // Verify navigable traceability chain for each order
    for (const order of summary.orders) {
      expect(order.orderId).toBeTruthy();
      expect(order.productId).toBeTruthy();
      expect(order.offerId).toBeTruthy();
      expect(order.amount).toBeTruthy();
    }
  });

  it('Comment triage classifies purchase intent and objections', () => {
    const buyComment = LiveWarRoomClient.triageComment('c-1', 's-1', 'Lan Anh', 'Cho mình hỏi giá serum bao nhiêu và mua thế nào?');
    expect(buyComment.intent).toBe('purchase_intent');
    expect(buyComment.isPriority).toBe(true);

    const objectionComment = LiveWarRoomClient.triageComment('c-2', 's-1', 'Minh', 'Hàng này có phải hàng fake không shop?');
    expect(objectionComment.intent).toBe('objection');
    expect(objectionComment.isPriority).toBe(true);

    const regularComment = LiveWarRoomClient.triageComment('c-3', 's-1', 'Hoa', 'Serum này có thơm không?');
    expect(regularComment.intent).toBe('question');
  });
});
