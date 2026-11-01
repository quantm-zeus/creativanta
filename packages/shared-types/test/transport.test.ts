import { describe, expect, it } from "vitest";
import { create } from "@bufbuild/protobuf";
import { createClient, Code, ConnectError } from "@connectrpc/connect";
import { createConnectTransport } from "@connectrpc/connect-node";
import { TransportFixtureService } from "../src/creativanta/transport/test/v1/fixture_pb";
import { CommandContextSchema, PaginationSchema, UUIDSchema } from "../src/creativanta/common/v1/types_pb";

const url = process.env.CV_FIXTURE_URL;
if (!url) throw new Error("CV_FIXTURE_URL required: integration tests must execute against actual Go fixture");
const client = createClient(TransportFixtureService, createConnectTransport({ baseUrl: url, httpVersion: "1.1" }));
const workspace = "018f7a31-2233-7444-8555-667788990011";
const foreign = "018f7a31-2233-7444-8555-667788990022";
function headers(id: string, tenant = workspace): HeadersInit {
  return { "x-workspace-id": tenant, "x-request-id": id };
}

describe("P0-02: actual TypeScript Connect -> Go fixture", () => {
  it("round trips a typed unary message and metadata", async () => {
    const response = await client.echo({ text: "TS Connect real client", workspaceId: workspace }, { headers: headers("ts-echo") });
    expect(response.text).toBe("TS Connect real client");
    expect(response.workspaceId).toBe(workspace);
  }, 10_000);

  it("replays an identical command but rejects changed payload with the same key", async () => {
    const idempotencyKey = "ts-idem-" + Date.now().toString();
    const context = create(CommandContextSchema, {
      idempotencyKey,
      workspaceId: create(UUIDSchema, { value: workspace }),
    });
    const request = { context, payload: "one" };
    const first = await client.execute(request, { headers: headers("ts-command1") });
    const replay = await client.execute(request, { headers: headers("ts-command2") });
    expect(first.replayed).toBe(false);
    expect(replay.replayed).toBe(true);
    let error: unknown;
    try { await client.execute({ context, payload: "different" }, { headers: headers("ts-command3") }); }
    catch (caught) { error = caught; }
    expect(error).toBeInstanceOf(ConnectError);
    expect((error as ConnectError).code).toBe(Code.AlreadyExists);
    expect((error as Error).message).toContain("SYSTEM_CONFLICT_001");
  }, 10_000);

  it("returns a signed cursor and rejects reuse by a foreign workspace", async () => {
    const first = await client.list({
      workspaceId: workspace, pagination: create(PaginationSchema, { pageSize: 2 }),
    }, { headers: headers("ts-list1") });
    const token = first.pagination?.nextPageToken || "";
    expect(token.length).toBeGreaterThan(10);
    let error: unknown;
    try {
      await client.list({
        workspaceId: foreign, pagination: create(PaginationSchema, { pageSize: 2, pageToken: token }),
      }, { headers: headers("ts-list2", foreign) });
    } catch (caught) { error = caught; }
    expect(error).toBeInstanceOf(ConnectError);
    expect((error as ConnectError).code).toBe(Code.InvalidArgument);
  }, 10_000);

  it("propagates abort to a deliberately delayed request", async () => {
    const controller = new AbortController();
    const promise = client.echo({ text: "delayed", workspaceId: workspace }, {
      headers: { ...headers("ts-timeout"), "x-test-delay-ms": "600" },
      signal: controller.signal,
    });
    setTimeout(() => controller.abort(), 40);
    let error: unknown;
    try { await promise; } catch (caught) { error = caught; }
    expect(error).toBeDefined();
    if (error instanceof ConnectError) {
      expect([Code.Canceled, Code.DeadlineExceeded]).toContain(error.code);
    } else {
      expect((error as Error).name).toMatch(/AbortError|Cancel/i);
    }
  }, 10_000);

  it("receives a server stream and cancels it without waiting for completion", async () => {
    const controller = new AbortController();
    const stream = client.watch({ maxEvents: 10 }, { headers: headers("ts-watch"), signal: controller.signal });
    let seen = 0;
    let error: unknown;
    try {
      for await (const item of stream) {
        expect(item.sequence).toBeGreaterThan(0);
        seen++;
        controller.abort();
      }
    } catch (caught) { error = caught; }
    expect(seen).toBeGreaterThan(0);
    // Cancellation must not falsely pass because the stream completed normally.
    expect(controller.signal.aborted).toBe(true);
    expect(error).toBeDefined();
  }, 10_000);
});
