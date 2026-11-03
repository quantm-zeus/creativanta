// This is a generated file - do not edit.
//
// Generated from creativanta/intelligence/v1/competitor.proto.

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

import 'competitor.pb.dart' as $0;

export 'competitor.pb.dart';

/// CompetitorService manages competitor tracking and on-demand analysis per M03.
@$pb.GrpcServiceName('creativanta.intelligence.v1.CompetitorService')
class CompetitorServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  CompetitorServiceClient(super.channel, {super.options, super.interceptors});

  /// List retrieves the paginated registry of tracked competitors.
  $grpc.ResponseFuture<$0.CompetitorServiceListResponse> list(
    $0.CompetitorServiceListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$list, request, options: options);
  }

  /// Add registers a new competitor into the workspace registry.
  $grpc.ResponseFuture<$0.CompetitorServiceAddResponse> add(
    $0.CompetitorServiceAddRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$add, request, options: options);
  }

  /// Remove removes a competitor from tracking.
  $grpc.ResponseFuture<$0.CompetitorServiceRemoveResponse> remove(
    $0.CompetitorServiceRemoveRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$remove, request, options: options);
  }

  /// GetSuggestions retrieves AI-recommended competitors to track.
  $grpc.ResponseFuture<$0.GetSuggestionsResponse> getSuggestions(
    $0.GetSuggestionsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getSuggestions, request, options: options);
  }

  /// DismissSuggestion dismisses a suggested competitor.
  $grpc.ResponseFuture<$0.DismissSuggestionResponse> dismissSuggestion(
    $0.DismissSuggestionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$dismissSuggestion, request, options: options);
  }

  /// SetAlerts configures alert thresholds for a competitor.
  $grpc.ResponseFuture<$0.SetAlertsResponse> setAlerts(
    $0.SetAlertsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$setAlerts, request, options: options);
  }

  /// ValidateHandle checks if a handle exists and generates preview metadata.
  $grpc.ResponseFuture<$0.ValidateHandleResponse> validateHandle(
    $0.ValidateHandleRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$validateHandle, request, options: options);
  }

  /// AnalyzeBenchmark captures or generates an on-demand benchmark snapshot.
  $grpc.ResponseFuture<$0.AnalyzeBenchmarkResponse> analyzeBenchmark(
    $0.AnalyzeBenchmarkRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$analyzeBenchmark, request, options: options);
  }

  // method descriptors

  static final _$list = $grpc.ClientMethod<$0.CompetitorServiceListRequest,
          $0.CompetitorServiceListResponse>(
      '/creativanta.intelligence.v1.CompetitorService/List',
      ($0.CompetitorServiceListRequest value) => value.writeToBuffer(),
      $0.CompetitorServiceListResponse.fromBuffer);
  static final _$add = $grpc.ClientMethod<$0.CompetitorServiceAddRequest,
          $0.CompetitorServiceAddResponse>(
      '/creativanta.intelligence.v1.CompetitorService/Add',
      ($0.CompetitorServiceAddRequest value) => value.writeToBuffer(),
      $0.CompetitorServiceAddResponse.fromBuffer);
  static final _$remove = $grpc.ClientMethod<$0.CompetitorServiceRemoveRequest,
          $0.CompetitorServiceRemoveResponse>(
      '/creativanta.intelligence.v1.CompetitorService/Remove',
      ($0.CompetitorServiceRemoveRequest value) => value.writeToBuffer(),
      $0.CompetitorServiceRemoveResponse.fromBuffer);
  static final _$getSuggestions =
      $grpc.ClientMethod<$0.GetSuggestionsRequest, $0.GetSuggestionsResponse>(
          '/creativanta.intelligence.v1.CompetitorService/GetSuggestions',
          ($0.GetSuggestionsRequest value) => value.writeToBuffer(),
          $0.GetSuggestionsResponse.fromBuffer);
  static final _$dismissSuggestion = $grpc.ClientMethod<
          $0.DismissSuggestionRequest, $0.DismissSuggestionResponse>(
      '/creativanta.intelligence.v1.CompetitorService/DismissSuggestion',
      ($0.DismissSuggestionRequest value) => value.writeToBuffer(),
      $0.DismissSuggestionResponse.fromBuffer);
  static final _$setAlerts =
      $grpc.ClientMethod<$0.SetAlertsRequest, $0.SetAlertsResponse>(
          '/creativanta.intelligence.v1.CompetitorService/SetAlerts',
          ($0.SetAlertsRequest value) => value.writeToBuffer(),
          $0.SetAlertsResponse.fromBuffer);
  static final _$validateHandle =
      $grpc.ClientMethod<$0.ValidateHandleRequest, $0.ValidateHandleResponse>(
          '/creativanta.intelligence.v1.CompetitorService/ValidateHandle',
          ($0.ValidateHandleRequest value) => value.writeToBuffer(),
          $0.ValidateHandleResponse.fromBuffer);
  static final _$analyzeBenchmark = $grpc.ClientMethod<
          $0.AnalyzeBenchmarkRequest, $0.AnalyzeBenchmarkResponse>(
      '/creativanta.intelligence.v1.CompetitorService/AnalyzeBenchmark',
      ($0.AnalyzeBenchmarkRequest value) => value.writeToBuffer(),
      $0.AnalyzeBenchmarkResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.intelligence.v1.CompetitorService')
abstract class CompetitorServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.intelligence.v1.CompetitorService';

  CompetitorServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CompetitorServiceListRequest,
            $0.CompetitorServiceListResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CompetitorServiceListRequest.fromBuffer(value),
        ($0.CompetitorServiceListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CompetitorServiceAddRequest,
            $0.CompetitorServiceAddResponse>(
        'Add',
        add_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CompetitorServiceAddRequest.fromBuffer(value),
        ($0.CompetitorServiceAddResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CompetitorServiceRemoveRequest,
            $0.CompetitorServiceRemoveResponse>(
        'Remove',
        remove_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CompetitorServiceRemoveRequest.fromBuffer(value),
        ($0.CompetitorServiceRemoveResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetSuggestionsRequest,
            $0.GetSuggestionsResponse>(
        'GetSuggestions',
        getSuggestions_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetSuggestionsRequest.fromBuffer(value),
        ($0.GetSuggestionsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DismissSuggestionRequest,
            $0.DismissSuggestionResponse>(
        'DismissSuggestion',
        dismissSuggestion_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.DismissSuggestionRequest.fromBuffer(value),
        ($0.DismissSuggestionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SetAlertsRequest, $0.SetAlertsResponse>(
        'SetAlerts',
        setAlerts_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SetAlertsRequest.fromBuffer(value),
        ($0.SetAlertsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ValidateHandleRequest,
            $0.ValidateHandleResponse>(
        'ValidateHandle',
        validateHandle_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ValidateHandleRequest.fromBuffer(value),
        ($0.ValidateHandleResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.AnalyzeBenchmarkRequest,
            $0.AnalyzeBenchmarkResponse>(
        'AnalyzeBenchmark',
        analyzeBenchmark_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.AnalyzeBenchmarkRequest.fromBuffer(value),
        ($0.AnalyzeBenchmarkResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.CompetitorServiceListResponse> list_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CompetitorServiceListRequest> $request) async {
    return list($call, await $request);
  }

  $async.Future<$0.CompetitorServiceListResponse> list(
      $grpc.ServiceCall call, $0.CompetitorServiceListRequest request);

  $async.Future<$0.CompetitorServiceAddResponse> add_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CompetitorServiceAddRequest> $request) async {
    return add($call, await $request);
  }

  $async.Future<$0.CompetitorServiceAddResponse> add(
      $grpc.ServiceCall call, $0.CompetitorServiceAddRequest request);

  $async.Future<$0.CompetitorServiceRemoveResponse> remove_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CompetitorServiceRemoveRequest> $request) async {
    return remove($call, await $request);
  }

  $async.Future<$0.CompetitorServiceRemoveResponse> remove(
      $grpc.ServiceCall call, $0.CompetitorServiceRemoveRequest request);

  $async.Future<$0.GetSuggestionsResponse> getSuggestions_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetSuggestionsRequest> $request) async {
    return getSuggestions($call, await $request);
  }

  $async.Future<$0.GetSuggestionsResponse> getSuggestions(
      $grpc.ServiceCall call, $0.GetSuggestionsRequest request);

  $async.Future<$0.DismissSuggestionResponse> dismissSuggestion_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.DismissSuggestionRequest> $request) async {
    return dismissSuggestion($call, await $request);
  }

  $async.Future<$0.DismissSuggestionResponse> dismissSuggestion(
      $grpc.ServiceCall call, $0.DismissSuggestionRequest request);

  $async.Future<$0.SetAlertsResponse> setAlerts_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SetAlertsRequest> $request) async {
    return setAlerts($call, await $request);
  }

  $async.Future<$0.SetAlertsResponse> setAlerts(
      $grpc.ServiceCall call, $0.SetAlertsRequest request);

  $async.Future<$0.ValidateHandleResponse> validateHandle_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ValidateHandleRequest> $request) async {
    return validateHandle($call, await $request);
  }

  $async.Future<$0.ValidateHandleResponse> validateHandle(
      $grpc.ServiceCall call, $0.ValidateHandleRequest request);

  $async.Future<$0.AnalyzeBenchmarkResponse> analyzeBenchmark_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.AnalyzeBenchmarkRequest> $request) async {
    return analyzeBenchmark($call, await $request);
  }

  $async.Future<$0.AnalyzeBenchmarkResponse> analyzeBenchmark(
      $grpc.ServiceCall call, $0.AnalyzeBenchmarkRequest request);
}

/// BenchmarkService provides comparative benchmarking against competitor sets per M03.
@$pb.GrpcServiceName('creativanta.intelligence.v1.BenchmarkService')
class BenchmarkServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  BenchmarkServiceClient(super.channel, {super.options, super.interceptors});

  /// Compare calculates side-by-side performance across competitors and market average.
  $grpc.ResponseFuture<$0.BenchmarkServiceCompareResponse> compare(
    $0.BenchmarkServiceCompareRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$compare, request, options: options);
  }

  /// GetTimeSeries retrieves historical metric curves for visual comparison.
  $grpc.ResponseFuture<$0.GetTimeSeriesResponse> getTimeSeries(
    $0.GetTimeSeriesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getTimeSeries, request, options: options);
  }

  // method descriptors

  static final _$compare = $grpc.ClientMethod<$0.BenchmarkServiceCompareRequest,
          $0.BenchmarkServiceCompareResponse>(
      '/creativanta.intelligence.v1.BenchmarkService/Compare',
      ($0.BenchmarkServiceCompareRequest value) => value.writeToBuffer(),
      $0.BenchmarkServiceCompareResponse.fromBuffer);
  static final _$getTimeSeries =
      $grpc.ClientMethod<$0.GetTimeSeriesRequest, $0.GetTimeSeriesResponse>(
          '/creativanta.intelligence.v1.BenchmarkService/GetTimeSeries',
          ($0.GetTimeSeriesRequest value) => value.writeToBuffer(),
          $0.GetTimeSeriesResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.intelligence.v1.BenchmarkService')
abstract class BenchmarkServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.intelligence.v1.BenchmarkService';

  BenchmarkServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.BenchmarkServiceCompareRequest,
            $0.BenchmarkServiceCompareResponse>(
        'Compare',
        compare_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.BenchmarkServiceCompareRequest.fromBuffer(value),
        ($0.BenchmarkServiceCompareResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetTimeSeriesRequest, $0.GetTimeSeriesResponse>(
            'GetTimeSeries',
            getTimeSeries_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetTimeSeriesRequest.fromBuffer(value),
            ($0.GetTimeSeriesResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.BenchmarkServiceCompareResponse> compare_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.BenchmarkServiceCompareRequest> $request) async {
    return compare($call, await $request);
  }

  $async.Future<$0.BenchmarkServiceCompareResponse> compare(
      $grpc.ServiceCall call, $0.BenchmarkServiceCompareRequest request);

  $async.Future<$0.GetTimeSeriesResponse> getTimeSeries_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetTimeSeriesRequest> $request) async {
    return getTimeSeries($call, await $request);
  }

  $async.Future<$0.GetTimeSeriesResponse> getTimeSeries(
      $grpc.ServiceCall call, $0.GetTimeSeriesRequest request);
}
