// This is a generated file - do not edit.
//
// Generated from creativanta/intelligence/v1/opportunity.proto.

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

import 'opportunity.pb.dart' as $0;

export 'opportunity.pb.dart';

/// OpportunityService manages the opportunity lifecycle, scoring, ownership, and conversions (M04).
@$pb.GrpcServiceName('creativanta.intelligence.v1.OpportunityService')
class OpportunityServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  OpportunityServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.OpportunityServiceListResponse> list(
    $0.OpportunityServiceListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$list, request, options: options);
  }

  $grpc.ResponseFuture<$0.OpportunityServiceGetResponse> get(
    $0.OpportunityServiceGetRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$get, request, options: options);
  }

  $grpc.ResponseFuture<$0.OpportunityServiceCreateResponse> create(
    $0.OpportunityServiceCreateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$create, request, options: options);
  }

  $grpc.ResponseFuture<$0.OpportunityServiceUpdateStateResponse> updateState(
    $0.OpportunityServiceUpdateStateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateState, request, options: options);
  }

  $grpc.ResponseFuture<$0.OpportunityServiceAssignResponse> assign(
    $0.OpportunityServiceAssignRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$assign, request, options: options);
  }

  $grpc.ResponseFuture<$0.OpportunityServiceConvertResponse> convert(
    $0.OpportunityServiceConvertRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$convert, request, options: options);
  }

  $grpc.ResponseFuture<$0.OpportunityServiceSaveResponse> save(
    $0.OpportunityServiceSaveRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$save, request, options: options);
  }

  $grpc.ResponseFuture<$0.OpportunityServiceDismissResponse> dismiss(
    $0.OpportunityServiceDismissRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$dismiss, request, options: options);
  }

  $grpc.ResponseFuture<$0.OpportunityServiceListRelatedResponse> listRelated(
    $0.OpportunityServiceListRelatedRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listRelated, request, options: options);
  }

  // method descriptors

  static final _$list = $grpc.ClientMethod<$0.OpportunityServiceListRequest,
          $0.OpportunityServiceListResponse>(
      '/creativanta.intelligence.v1.OpportunityService/List',
      ($0.OpportunityServiceListRequest value) => value.writeToBuffer(),
      $0.OpportunityServiceListResponse.fromBuffer);
  static final _$get = $grpc.ClientMethod<$0.OpportunityServiceGetRequest,
          $0.OpportunityServiceGetResponse>(
      '/creativanta.intelligence.v1.OpportunityService/Get',
      ($0.OpportunityServiceGetRequest value) => value.writeToBuffer(),
      $0.OpportunityServiceGetResponse.fromBuffer);
  static final _$create = $grpc.ClientMethod<$0.OpportunityServiceCreateRequest,
          $0.OpportunityServiceCreateResponse>(
      '/creativanta.intelligence.v1.OpportunityService/Create',
      ($0.OpportunityServiceCreateRequest value) => value.writeToBuffer(),
      $0.OpportunityServiceCreateResponse.fromBuffer);
  static final _$updateState = $grpc.ClientMethod<
          $0.OpportunityServiceUpdateStateRequest,
          $0.OpportunityServiceUpdateStateResponse>(
      '/creativanta.intelligence.v1.OpportunityService/UpdateState',
      ($0.OpportunityServiceUpdateStateRequest value) => value.writeToBuffer(),
      $0.OpportunityServiceUpdateStateResponse.fromBuffer);
  static final _$assign = $grpc.ClientMethod<$0.OpportunityServiceAssignRequest,
          $0.OpportunityServiceAssignResponse>(
      '/creativanta.intelligence.v1.OpportunityService/Assign',
      ($0.OpportunityServiceAssignRequest value) => value.writeToBuffer(),
      $0.OpportunityServiceAssignResponse.fromBuffer);
  static final _$convert = $grpc.ClientMethod<
          $0.OpportunityServiceConvertRequest,
          $0.OpportunityServiceConvertResponse>(
      '/creativanta.intelligence.v1.OpportunityService/Convert',
      ($0.OpportunityServiceConvertRequest value) => value.writeToBuffer(),
      $0.OpportunityServiceConvertResponse.fromBuffer);
  static final _$save = $grpc.ClientMethod<$0.OpportunityServiceSaveRequest,
          $0.OpportunityServiceSaveResponse>(
      '/creativanta.intelligence.v1.OpportunityService/Save',
      ($0.OpportunityServiceSaveRequest value) => value.writeToBuffer(),
      $0.OpportunityServiceSaveResponse.fromBuffer);
  static final _$dismiss = $grpc.ClientMethod<
          $0.OpportunityServiceDismissRequest,
          $0.OpportunityServiceDismissResponse>(
      '/creativanta.intelligence.v1.OpportunityService/Dismiss',
      ($0.OpportunityServiceDismissRequest value) => value.writeToBuffer(),
      $0.OpportunityServiceDismissResponse.fromBuffer);
  static final _$listRelated = $grpc.ClientMethod<
          $0.OpportunityServiceListRelatedRequest,
          $0.OpportunityServiceListRelatedResponse>(
      '/creativanta.intelligence.v1.OpportunityService/ListRelated',
      ($0.OpportunityServiceListRelatedRequest value) => value.writeToBuffer(),
      $0.OpportunityServiceListRelatedResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.intelligence.v1.OpportunityService')
abstract class OpportunityServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.intelligence.v1.OpportunityService';

  OpportunityServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.OpportunityServiceListRequest,
            $0.OpportunityServiceListResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OpportunityServiceListRequest.fromBuffer(value),
        ($0.OpportunityServiceListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OpportunityServiceGetRequest,
            $0.OpportunityServiceGetResponse>(
        'Get',
        get_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OpportunityServiceGetRequest.fromBuffer(value),
        ($0.OpportunityServiceGetResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OpportunityServiceCreateRequest,
            $0.OpportunityServiceCreateResponse>(
        'Create',
        create_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OpportunityServiceCreateRequest.fromBuffer(value),
        ($0.OpportunityServiceCreateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OpportunityServiceUpdateStateRequest,
            $0.OpportunityServiceUpdateStateResponse>(
        'UpdateState',
        updateState_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OpportunityServiceUpdateStateRequest.fromBuffer(value),
        ($0.OpportunityServiceUpdateStateResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OpportunityServiceAssignRequest,
            $0.OpportunityServiceAssignResponse>(
        'Assign',
        assign_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OpportunityServiceAssignRequest.fromBuffer(value),
        ($0.OpportunityServiceAssignResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OpportunityServiceConvertRequest,
            $0.OpportunityServiceConvertResponse>(
        'Convert',
        convert_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OpportunityServiceConvertRequest.fromBuffer(value),
        ($0.OpportunityServiceConvertResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OpportunityServiceSaveRequest,
            $0.OpportunityServiceSaveResponse>(
        'Save',
        save_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OpportunityServiceSaveRequest.fromBuffer(value),
        ($0.OpportunityServiceSaveResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OpportunityServiceDismissRequest,
            $0.OpportunityServiceDismissResponse>(
        'Dismiss',
        dismiss_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OpportunityServiceDismissRequest.fromBuffer(value),
        ($0.OpportunityServiceDismissResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OpportunityServiceListRelatedRequest,
            $0.OpportunityServiceListRelatedResponse>(
        'ListRelated',
        listRelated_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OpportunityServiceListRelatedRequest.fromBuffer(value),
        ($0.OpportunityServiceListRelatedResponse value) =>
            value.writeToBuffer()));
  }

  $async.Future<$0.OpportunityServiceListResponse> list_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.OpportunityServiceListRequest> $request) async {
    return list($call, await $request);
  }

  $async.Future<$0.OpportunityServiceListResponse> list(
      $grpc.ServiceCall call, $0.OpportunityServiceListRequest request);

  $async.Future<$0.OpportunityServiceGetResponse> get_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.OpportunityServiceGetRequest> $request) async {
    return get($call, await $request);
  }

  $async.Future<$0.OpportunityServiceGetResponse> get(
      $grpc.ServiceCall call, $0.OpportunityServiceGetRequest request);

  $async.Future<$0.OpportunityServiceCreateResponse> create_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.OpportunityServiceCreateRequest> $request) async {
    return create($call, await $request);
  }

  $async.Future<$0.OpportunityServiceCreateResponse> create(
      $grpc.ServiceCall call, $0.OpportunityServiceCreateRequest request);

  $async.Future<$0.OpportunityServiceUpdateStateResponse> updateState_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.OpportunityServiceUpdateStateRequest> $request) async {
    return updateState($call, await $request);
  }

  $async.Future<$0.OpportunityServiceUpdateStateResponse> updateState(
      $grpc.ServiceCall call, $0.OpportunityServiceUpdateStateRequest request);

  $async.Future<$0.OpportunityServiceAssignResponse> assign_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.OpportunityServiceAssignRequest> $request) async {
    return assign($call, await $request);
  }

  $async.Future<$0.OpportunityServiceAssignResponse> assign(
      $grpc.ServiceCall call, $0.OpportunityServiceAssignRequest request);

  $async.Future<$0.OpportunityServiceConvertResponse> convert_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.OpportunityServiceConvertRequest> $request) async {
    return convert($call, await $request);
  }

  $async.Future<$0.OpportunityServiceConvertResponse> convert(
      $grpc.ServiceCall call, $0.OpportunityServiceConvertRequest request);

  $async.Future<$0.OpportunityServiceSaveResponse> save_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.OpportunityServiceSaveRequest> $request) async {
    return save($call, await $request);
  }

  $async.Future<$0.OpportunityServiceSaveResponse> save(
      $grpc.ServiceCall call, $0.OpportunityServiceSaveRequest request);

  $async.Future<$0.OpportunityServiceDismissResponse> dismiss_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.OpportunityServiceDismissRequest> $request) async {
    return dismiss($call, await $request);
  }

  $async.Future<$0.OpportunityServiceDismissResponse> dismiss(
      $grpc.ServiceCall call, $0.OpportunityServiceDismissRequest request);

  $async.Future<$0.OpportunityServiceListRelatedResponse> listRelated_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.OpportunityServiceListRelatedRequest> $request) async {
    return listRelated($call, await $request);
  }

  $async.Future<$0.OpportunityServiceListRelatedResponse> listRelated(
      $grpc.ServiceCall call, $0.OpportunityServiceListRelatedRequest request);
}
