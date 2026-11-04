// This is a generated file - do not edit.
//
// Generated from creativanta/commerce/v1/live.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'live.pb.dart' as $0;

export 'live.pb.dart';

/// LiveCommerceService provides real-time live commerce orchestration (M17).
/// Canonical Sources: docs/02_features/commerce/live_war_room.md
///                    docs/04_contracts/api_endpoint_map.md §2.8.3
///                    docs/04_contracts/rpc_permission_bindings.csv
@$pb.GrpcServiceName('creativanta.commerce.v1.LiveCommerceService')
class LiveCommerceServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  LiveCommerceServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.LiveCommerceServiceCreateSessionResponse>
      createSession(
    $0.LiveCommerceServiceCreateSessionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createSession, request, options: options);
  }

  $grpc.ResponseFuture<$0.LiveCommerceServiceGetResponse> get(
    $0.LiveCommerceServiceGetRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$get, request, options: options);
  }

  $grpc.ResponseFuture<$0.LiveCommerceServiceListResponse> list(
    $0.LiveCommerceServiceListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$list, request, options: options);
  }

  $grpc.ResponseFuture<$0.LiveCommerceServiceStartSessionResponse> startSession(
    $0.LiveCommerceServiceStartSessionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$startSession, request, options: options);
  }

  $grpc.ResponseFuture<$0.LiveCommerceServiceEndSessionResponse> endSession(
    $0.LiveCommerceServiceEndSessionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$endSession, request, options: options);
  }

  $grpc.ResponseFuture<$0.LiveCommerceServicePauseSessionResponse> pauseSession(
    $0.LiveCommerceServicePauseSessionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$pauseSession, request, options: options);
  }

  $grpc.ResponseFuture<$0.LiveCommerceServiceResumeSessionResponse>
      resumeSession(
    $0.LiveCommerceServiceResumeSessionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$resumeSession, request, options: options);
  }

  $grpc.ResponseFuture<$0.LiveCommerceServiceAddCueResponse> addCue(
    $0.LiveCommerceServiceAddCueRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$addCue, request, options: options);
  }

  $grpc.ResponseFuture<$0.LiveCommerceServiceRemoveCueResponse> removeCue(
    $0.LiveCommerceServiceRemoveCueRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$removeCue, request, options: options);
  }

  $grpc.ResponseFuture<$0.LiveCommerceServiceTriggerCueResponse> triggerCue(
    $0.LiveCommerceServiceTriggerCueRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$triggerCue, request, options: options);
  }

  $grpc.ResponseFuture<$0.LiveCommerceServiceHighlightProductResponse>
      highlightProduct(
    $0.LiveCommerceServiceHighlightProductRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$highlightProduct, request, options: options);
  }

  $grpc.ResponseFuture<$0.LiveCommerceServiceGetAnalyticsResponse> getAnalytics(
    $0.LiveCommerceServiceGetAnalyticsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getAnalytics, request, options: options);
  }

  $grpc.ResponseFuture<$0.LiveCommerceServiceUpdateRunOfShowResponse>
      updateRunOfShow(
    $0.LiveCommerceServiceUpdateRunOfShowRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateRunOfShow, request, options: options);
  }

  $grpc.ResponseFuture<$0.LiveCommerceServiceCreateHighlightResponse>
      createHighlight(
    $0.LiveCommerceServiceCreateHighlightRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createHighlight, request, options: options);
  }

  $grpc.ResponseFuture<$0.LiveCommerceServiceExtractHighlightsResponse>
      extractHighlights(
    $0.LiveCommerceServiceExtractHighlightsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$extractHighlights, request, options: options);
  }

  $grpc.ResponseFuture<$0.LiveCommerceServiceGetProofSummaryResponse>
      getProofSummary(
    $0.LiveCommerceServiceGetProofSummaryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getProofSummary, request, options: options);
  }

  // method descriptors

  static final _$createSession = $grpc.ClientMethod<
          $0.LiveCommerceServiceCreateSessionRequest,
          $0.LiveCommerceServiceCreateSessionResponse>(
      '/creativanta.commerce.v1.LiveCommerceService/CreateSession',
      ($0.LiveCommerceServiceCreateSessionRequest value) =>
          value.writeToBuffer(),
      $0.LiveCommerceServiceCreateSessionResponse.fromBuffer);
  static final _$get = $grpc.ClientMethod<$0.LiveCommerceServiceGetRequest,
          $0.LiveCommerceServiceGetResponse>(
      '/creativanta.commerce.v1.LiveCommerceService/Get',
      ($0.LiveCommerceServiceGetRequest value) => value.writeToBuffer(),
      $0.LiveCommerceServiceGetResponse.fromBuffer);
  static final _$list = $grpc.ClientMethod<$0.LiveCommerceServiceListRequest,
          $0.LiveCommerceServiceListResponse>(
      '/creativanta.commerce.v1.LiveCommerceService/List',
      ($0.LiveCommerceServiceListRequest value) => value.writeToBuffer(),
      $0.LiveCommerceServiceListResponse.fromBuffer);
  static final _$startSession = $grpc.ClientMethod<
          $0.LiveCommerceServiceStartSessionRequest,
          $0.LiveCommerceServiceStartSessionResponse>(
      '/creativanta.commerce.v1.LiveCommerceService/StartSession',
      ($0.LiveCommerceServiceStartSessionRequest value) =>
          value.writeToBuffer(),
      $0.LiveCommerceServiceStartSessionResponse.fromBuffer);
  static final _$endSession = $grpc.ClientMethod<
          $0.LiveCommerceServiceEndSessionRequest,
          $0.LiveCommerceServiceEndSessionResponse>(
      '/creativanta.commerce.v1.LiveCommerceService/EndSession',
      ($0.LiveCommerceServiceEndSessionRequest value) => value.writeToBuffer(),
      $0.LiveCommerceServiceEndSessionResponse.fromBuffer);
  static final _$pauseSession = $grpc.ClientMethod<
          $0.LiveCommerceServicePauseSessionRequest,
          $0.LiveCommerceServicePauseSessionResponse>(
      '/creativanta.commerce.v1.LiveCommerceService/PauseSession',
      ($0.LiveCommerceServicePauseSessionRequest value) =>
          value.writeToBuffer(),
      $0.LiveCommerceServicePauseSessionResponse.fromBuffer);
  static final _$resumeSession = $grpc.ClientMethod<
          $0.LiveCommerceServiceResumeSessionRequest,
          $0.LiveCommerceServiceResumeSessionResponse>(
      '/creativanta.commerce.v1.LiveCommerceService/ResumeSession',
      ($0.LiveCommerceServiceResumeSessionRequest value) =>
          value.writeToBuffer(),
      $0.LiveCommerceServiceResumeSessionResponse.fromBuffer);
  static final _$addCue = $grpc.ClientMethod<
          $0.LiveCommerceServiceAddCueRequest,
          $0.LiveCommerceServiceAddCueResponse>(
      '/creativanta.commerce.v1.LiveCommerceService/AddCue',
      ($0.LiveCommerceServiceAddCueRequest value) => value.writeToBuffer(),
      $0.LiveCommerceServiceAddCueResponse.fromBuffer);
  static final _$removeCue = $grpc.ClientMethod<
          $0.LiveCommerceServiceRemoveCueRequest,
          $0.LiveCommerceServiceRemoveCueResponse>(
      '/creativanta.commerce.v1.LiveCommerceService/RemoveCue',
      ($0.LiveCommerceServiceRemoveCueRequest value) => value.writeToBuffer(),
      $0.LiveCommerceServiceRemoveCueResponse.fromBuffer);
  static final _$triggerCue = $grpc.ClientMethod<
          $0.LiveCommerceServiceTriggerCueRequest,
          $0.LiveCommerceServiceTriggerCueResponse>(
      '/creativanta.commerce.v1.LiveCommerceService/TriggerCue',
      ($0.LiveCommerceServiceTriggerCueRequest value) => value.writeToBuffer(),
      $0.LiveCommerceServiceTriggerCueResponse.fromBuffer);
  static final _$highlightProduct = $grpc.ClientMethod<
          $0.LiveCommerceServiceHighlightProductRequest,
          $0.LiveCommerceServiceHighlightProductResponse>(
      '/creativanta.commerce.v1.LiveCommerceService/HighlightProduct',
      ($0.LiveCommerceServiceHighlightProductRequest value) =>
          value.writeToBuffer(),
      $0.LiveCommerceServiceHighlightProductResponse.fromBuffer);
  static final _$getAnalytics = $grpc.ClientMethod<
          $0.LiveCommerceServiceGetAnalyticsRequest,
          $0.LiveCommerceServiceGetAnalyticsResponse>(
      '/creativanta.commerce.v1.LiveCommerceService/GetAnalytics',
      ($0.LiveCommerceServiceGetAnalyticsRequest value) =>
          value.writeToBuffer(),
      $0.LiveCommerceServiceGetAnalyticsResponse.fromBuffer);
  static final _$updateRunOfShow = $grpc.ClientMethod<
          $0.LiveCommerceServiceUpdateRunOfShowRequest,
          $0.LiveCommerceServiceUpdateRunOfShowResponse>(
      '/creativanta.commerce.v1.LiveCommerceService/UpdateRunOfShow',
      ($0.LiveCommerceServiceUpdateRunOfShowRequest value) =>
          value.writeToBuffer(),
      $0.LiveCommerceServiceUpdateRunOfShowResponse.fromBuffer);
  static final _$createHighlight = $grpc.ClientMethod<
          $0.LiveCommerceServiceCreateHighlightRequest,
          $0.LiveCommerceServiceCreateHighlightResponse>(
      '/creativanta.commerce.v1.LiveCommerceService/CreateHighlight',
      ($0.LiveCommerceServiceCreateHighlightRequest value) =>
          value.writeToBuffer(),
      $0.LiveCommerceServiceCreateHighlightResponse.fromBuffer);
  static final _$extractHighlights = $grpc.ClientMethod<
          $0.LiveCommerceServiceExtractHighlightsRequest,
          $0.LiveCommerceServiceExtractHighlightsResponse>(
      '/creativanta.commerce.v1.LiveCommerceService/ExtractHighlights',
      ($0.LiveCommerceServiceExtractHighlightsRequest value) =>
          value.writeToBuffer(),
      $0.LiveCommerceServiceExtractHighlightsResponse.fromBuffer);
  static final _$getProofSummary = $grpc.ClientMethod<
          $0.LiveCommerceServiceGetProofSummaryRequest,
          $0.LiveCommerceServiceGetProofSummaryResponse>(
      '/creativanta.commerce.v1.LiveCommerceService/GetProofSummary',
      ($0.LiveCommerceServiceGetProofSummaryRequest value) =>
          value.writeToBuffer(),
      $0.LiveCommerceServiceGetProofSummaryResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.LiveCommerceService')
abstract class LiveCommerceServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.commerce.v1.LiveCommerceService';

  LiveCommerceServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.LiveCommerceServiceCreateSessionRequest,
            $0.LiveCommerceServiceCreateSessionResponse>(
        'CreateSession',
        createSession_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.LiveCommerceServiceCreateSessionRequest.fromBuffer(value),
        ($0.LiveCommerceServiceCreateSessionResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LiveCommerceServiceGetRequest,
            $0.LiveCommerceServiceGetResponse>(
        'Get',
        get_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.LiveCommerceServiceGetRequest.fromBuffer(value),
        ($0.LiveCommerceServiceGetResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LiveCommerceServiceListRequest,
            $0.LiveCommerceServiceListResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.LiveCommerceServiceListRequest.fromBuffer(value),
        ($0.LiveCommerceServiceListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LiveCommerceServiceStartSessionRequest,
            $0.LiveCommerceServiceStartSessionResponse>(
        'StartSession',
        startSession_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.LiveCommerceServiceStartSessionRequest.fromBuffer(value),
        ($0.LiveCommerceServiceStartSessionResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LiveCommerceServiceEndSessionRequest,
            $0.LiveCommerceServiceEndSessionResponse>(
        'EndSession',
        endSession_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.LiveCommerceServiceEndSessionRequest.fromBuffer(value),
        ($0.LiveCommerceServiceEndSessionResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LiveCommerceServicePauseSessionRequest,
            $0.LiveCommerceServicePauseSessionResponse>(
        'PauseSession',
        pauseSession_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.LiveCommerceServicePauseSessionRequest.fromBuffer(value),
        ($0.LiveCommerceServicePauseSessionResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LiveCommerceServiceResumeSessionRequest,
            $0.LiveCommerceServiceResumeSessionResponse>(
        'ResumeSession',
        resumeSession_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.LiveCommerceServiceResumeSessionRequest.fromBuffer(value),
        ($0.LiveCommerceServiceResumeSessionResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LiveCommerceServiceAddCueRequest,
            $0.LiveCommerceServiceAddCueResponse>(
        'AddCue',
        addCue_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.LiveCommerceServiceAddCueRequest.fromBuffer(value),
        ($0.LiveCommerceServiceAddCueResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LiveCommerceServiceRemoveCueRequest,
            $0.LiveCommerceServiceRemoveCueResponse>(
        'RemoveCue',
        removeCue_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.LiveCommerceServiceRemoveCueRequest.fromBuffer(value),
        ($0.LiveCommerceServiceRemoveCueResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LiveCommerceServiceTriggerCueRequest,
            $0.LiveCommerceServiceTriggerCueResponse>(
        'TriggerCue',
        triggerCue_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.LiveCommerceServiceTriggerCueRequest.fromBuffer(value),
        ($0.LiveCommerceServiceTriggerCueResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<
            $0.LiveCommerceServiceHighlightProductRequest,
            $0.LiveCommerceServiceHighlightProductResponse>(
        'HighlightProduct',
        highlightProduct_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.LiveCommerceServiceHighlightProductRequest.fromBuffer(value),
        ($0.LiveCommerceServiceHighlightProductResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LiveCommerceServiceGetAnalyticsRequest,
            $0.LiveCommerceServiceGetAnalyticsResponse>(
        'GetAnalytics',
        getAnalytics_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.LiveCommerceServiceGetAnalyticsRequest.fromBuffer(value),
        ($0.LiveCommerceServiceGetAnalyticsResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LiveCommerceServiceUpdateRunOfShowRequest,
            $0.LiveCommerceServiceUpdateRunOfShowResponse>(
        'UpdateRunOfShow',
        updateRunOfShow_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.LiveCommerceServiceUpdateRunOfShowRequest.fromBuffer(value),
        ($0.LiveCommerceServiceUpdateRunOfShowResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LiveCommerceServiceCreateHighlightRequest,
            $0.LiveCommerceServiceCreateHighlightResponse>(
        'CreateHighlight',
        createHighlight_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.LiveCommerceServiceCreateHighlightRequest.fromBuffer(value),
        ($0.LiveCommerceServiceCreateHighlightResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<
            $0.LiveCommerceServiceExtractHighlightsRequest,
            $0.LiveCommerceServiceExtractHighlightsResponse>(
        'ExtractHighlights',
        extractHighlights_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.LiveCommerceServiceExtractHighlightsRequest.fromBuffer(value),
        ($0.LiveCommerceServiceExtractHighlightsResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LiveCommerceServiceGetProofSummaryRequest,
            $0.LiveCommerceServiceGetProofSummaryResponse>(
        'GetProofSummary',
        getProofSummary_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.LiveCommerceServiceGetProofSummaryRequest.fromBuffer(value),
        ($0.LiveCommerceServiceGetProofSummaryResponse value) =>
            value.writeToBuffer()));
  }

  $async.Future<$0.LiveCommerceServiceCreateSessionResponse> createSession_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.LiveCommerceServiceCreateSessionRequest>
          $request) async {
    return createSession($call, await $request);
  }

  $async.Future<$0.LiveCommerceServiceCreateSessionResponse> createSession(
      $grpc.ServiceCall call,
      $0.LiveCommerceServiceCreateSessionRequest request);

  $async.Future<$0.LiveCommerceServiceGetResponse> get_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.LiveCommerceServiceGetRequest> $request) async {
    return get($call, await $request);
  }

  $async.Future<$0.LiveCommerceServiceGetResponse> get(
      $grpc.ServiceCall call, $0.LiveCommerceServiceGetRequest request);

  $async.Future<$0.LiveCommerceServiceListResponse> list_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.LiveCommerceServiceListRequest> $request) async {
    return list($call, await $request);
  }

  $async.Future<$0.LiveCommerceServiceListResponse> list(
      $grpc.ServiceCall call, $0.LiveCommerceServiceListRequest request);

  $async.Future<$0.LiveCommerceServiceStartSessionResponse> startSession_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.LiveCommerceServiceStartSessionRequest> $request) async {
    return startSession($call, await $request);
  }

  $async.Future<$0.LiveCommerceServiceStartSessionResponse> startSession(
      $grpc.ServiceCall call,
      $0.LiveCommerceServiceStartSessionRequest request);

  $async.Future<$0.LiveCommerceServiceEndSessionResponse> endSession_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.LiveCommerceServiceEndSessionRequest> $request) async {
    return endSession($call, await $request);
  }

  $async.Future<$0.LiveCommerceServiceEndSessionResponse> endSession(
      $grpc.ServiceCall call, $0.LiveCommerceServiceEndSessionRequest request);

  $async.Future<$0.LiveCommerceServicePauseSessionResponse> pauseSession_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.LiveCommerceServicePauseSessionRequest> $request) async {
    return pauseSession($call, await $request);
  }

  $async.Future<$0.LiveCommerceServicePauseSessionResponse> pauseSession(
      $grpc.ServiceCall call,
      $0.LiveCommerceServicePauseSessionRequest request);

  $async.Future<$0.LiveCommerceServiceResumeSessionResponse> resumeSession_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.LiveCommerceServiceResumeSessionRequest>
          $request) async {
    return resumeSession($call, await $request);
  }

  $async.Future<$0.LiveCommerceServiceResumeSessionResponse> resumeSession(
      $grpc.ServiceCall call,
      $0.LiveCommerceServiceResumeSessionRequest request);

  $async.Future<$0.LiveCommerceServiceAddCueResponse> addCue_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.LiveCommerceServiceAddCueRequest> $request) async {
    return addCue($call, await $request);
  }

  $async.Future<$0.LiveCommerceServiceAddCueResponse> addCue(
      $grpc.ServiceCall call, $0.LiveCommerceServiceAddCueRequest request);

  $async.Future<$0.LiveCommerceServiceRemoveCueResponse> removeCue_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.LiveCommerceServiceRemoveCueRequest> $request) async {
    return removeCue($call, await $request);
  }

  $async.Future<$0.LiveCommerceServiceRemoveCueResponse> removeCue(
      $grpc.ServiceCall call, $0.LiveCommerceServiceRemoveCueRequest request);

  $async.Future<$0.LiveCommerceServiceTriggerCueResponse> triggerCue_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.LiveCommerceServiceTriggerCueRequest> $request) async {
    return triggerCue($call, await $request);
  }

  $async.Future<$0.LiveCommerceServiceTriggerCueResponse> triggerCue(
      $grpc.ServiceCall call, $0.LiveCommerceServiceTriggerCueRequest request);

  $async.Future<$0.LiveCommerceServiceHighlightProductResponse>
      highlightProduct_Pre(
          $grpc.ServiceCall $call,
          $async.Future<$0.LiveCommerceServiceHighlightProductRequest>
              $request) async {
    return highlightProduct($call, await $request);
  }

  $async.Future<$0.LiveCommerceServiceHighlightProductResponse>
      highlightProduct($grpc.ServiceCall call,
          $0.LiveCommerceServiceHighlightProductRequest request);

  $async.Future<$0.LiveCommerceServiceGetAnalyticsResponse> getAnalytics_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.LiveCommerceServiceGetAnalyticsRequest> $request) async {
    return getAnalytics($call, await $request);
  }

  $async.Future<$0.LiveCommerceServiceGetAnalyticsResponse> getAnalytics(
      $grpc.ServiceCall call,
      $0.LiveCommerceServiceGetAnalyticsRequest request);

  $async.Future<$0.LiveCommerceServiceUpdateRunOfShowResponse>
      updateRunOfShow_Pre(
          $grpc.ServiceCall $call,
          $async.Future<$0.LiveCommerceServiceUpdateRunOfShowRequest>
              $request) async {
    return updateRunOfShow($call, await $request);
  }

  $async.Future<$0.LiveCommerceServiceUpdateRunOfShowResponse> updateRunOfShow(
      $grpc.ServiceCall call,
      $0.LiveCommerceServiceUpdateRunOfShowRequest request);

  $async.Future<$0.LiveCommerceServiceCreateHighlightResponse>
      createHighlight_Pre(
          $grpc.ServiceCall $call,
          $async.Future<$0.LiveCommerceServiceCreateHighlightRequest>
              $request) async {
    return createHighlight($call, await $request);
  }

  $async.Future<$0.LiveCommerceServiceCreateHighlightResponse> createHighlight(
      $grpc.ServiceCall call,
      $0.LiveCommerceServiceCreateHighlightRequest request);

  $async.Future<$0.LiveCommerceServiceExtractHighlightsResponse>
      extractHighlights_Pre(
          $grpc.ServiceCall $call,
          $async.Future<$0.LiveCommerceServiceExtractHighlightsRequest>
              $request) async {
    return extractHighlights($call, await $request);
  }

  $async.Future<$0.LiveCommerceServiceExtractHighlightsResponse>
      extractHighlights($grpc.ServiceCall call,
          $0.LiveCommerceServiceExtractHighlightsRequest request);

  $async.Future<$0.LiveCommerceServiceGetProofSummaryResponse>
      getProofSummary_Pre(
          $grpc.ServiceCall $call,
          $async.Future<$0.LiveCommerceServiceGetProofSummaryRequest>
              $request) async {
    return getProofSummary($call, await $request);
  }

  $async.Future<$0.LiveCommerceServiceGetProofSummaryResponse> getProofSummary(
      $grpc.ServiceCall call,
      $0.LiveCommerceServiceGetProofSummaryRequest request);
}
