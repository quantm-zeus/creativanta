import { describe, expect, it } from "vitest";
import { create, fromBinary, toBinary } from "@bufbuild/protobuf";
import {
  MoneySchema, CommandContextSchema, PaginationSchema, UUIDSchema,
} from "../src/creativanta/common/v1/types_pb";
import { ErrorDetailSchema } from "../src/creativanta/common/v1/errors_pb";

describe("P0-02 generated wire types", () => {
  it("preserves exact decimal strings without float conversions", () => {
    const amount = "123456789012.123456";
    const request = create(MoneySchema, { amount, currency: "USD" });
    const decoded = fromBinary(MoneySchema, toBinary(MoneySchema, request));
    expect(decoded.amount).toBe(amount);
    expect(decoded.currency).toBe("USD");
  });

  it("round-trips a typed command envelope and UUID", () => {
    const workspaceId = create(UUIDSchema, { value: "018f7a31-2233-7444-8555-667788990011" });
    const envelope = create(CommandContextSchema, {
      idempotencyKey: "test-123",
      workspaceId,
      reason: "safe testing",
    });
    const decoded = fromBinary(CommandContextSchema, toBinary(CommandContextSchema, envelope));
    expect(decoded.workspaceId?.value).toBe(workspaceId.value);
    expect(decoded.idempotencyKey).toBe("test-123");
    expect(decoded.reason).toBe("safe testing");
  });

  it("preserves opaque page tokens and optional total count", () => {
    const page = create(PaginationSchema, { pageSize: 20, pageToken: "opaque-jwt-like-cursor" });
    const decoded = fromBinary(PaginationSchema, toBinary(PaginationSchema, page));
    expect(decoded.pageSize).toBe(20);
    expect(decoded.pageToken).toBe("opaque-jwt-like-cursor");
  });

  it("keeps canonical error details typed rather than arbitrary JSON", () => {
    const problem = create(ErrorDetailSchema, { code: "SYSTEM_CONFLICT_001", message: "Duplicate key" });
    const decoded = fromBinary(ErrorDetailSchema, toBinary(ErrorDetailSchema, problem));
    expect(decoded.code).toBe("SYSTEM_CONFLICT_001");
    expect(decoded.message).toBe("Duplicate key");
  });
});
