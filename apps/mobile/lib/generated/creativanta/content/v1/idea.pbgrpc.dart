// This is a generated file - do not edit.
//
// Generated from creativanta/content/v1/idea.proto.

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

import 'idea.pb.dart' as $0;

export 'idea.pb.dart';

/// IdeaService manages ideation, hooks, deduplication, scoring, and conversions (M05).
@$pb.GrpcServiceName('creativanta.content.v1.IdeaService')
class IdeaServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  IdeaServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.IdeaServiceCreateResponse> create(
    $0.IdeaServiceCreateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$create, request, options: options);
  }

  $grpc.ResponseFuture<$0.IdeaServiceListResponse> list(
    $0.IdeaServiceListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$list, request, options: options);
  }

  $grpc.ResponseFuture<$0.IdeaServiceGetResponse> get(
    $0.IdeaServiceGetRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$get, request, options: options);
  }

  $grpc.ResponseFuture<$0.IdeaServiceUpdateResponse> update(
    $0.IdeaServiceUpdateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$update, request, options: options);
  }

  $grpc.ResponseFuture<$0.IdeaServiceDeleteResponse> delete(
    $0.IdeaServiceDeleteRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$delete, request, options: options);
  }

  $grpc.ResponseFuture<$0.IdeaServiceUpdateStatusResponse> updateStatus(
    $0.IdeaServiceUpdateStatusRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateStatus, request, options: options);
  }

  $grpc.ResponseFuture<$0.IdeaServiceGenerateResponse> generate(
    $0.IdeaServiceGenerateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$generate, request, options: options);
  }

  $grpc.ResponseFuture<$0.IdeaServiceConvertResponse> convert(
    $0.IdeaServiceConvertRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$convert, request, options: options);
  }

  $grpc.ResponseFuture<$0.IdeaServiceSearchResponse> search(
    $0.IdeaServiceSearchRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$search, request, options: options);
  }

  $grpc.ResponseFuture<$0.IdeaServiceCreateFromTrendResponse> createFromTrend(
    $0.IdeaServiceCreateFromTrendRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createFromTrend, request, options: options);
  }

  $grpc.ResponseFuture<$0.IdeaServiceListMobileResponse> listMobile(
    $0.IdeaServiceListMobileRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listMobile, request, options: options);
  }

  // method descriptors

  static final _$create = $grpc.ClientMethod<$0.IdeaServiceCreateRequest,
          $0.IdeaServiceCreateResponse>(
      '/creativanta.content.v1.IdeaService/Create',
      ($0.IdeaServiceCreateRequest value) => value.writeToBuffer(),
      $0.IdeaServiceCreateResponse.fromBuffer);
  static final _$list =
      $grpc.ClientMethod<$0.IdeaServiceListRequest, $0.IdeaServiceListResponse>(
          '/creativanta.content.v1.IdeaService/List',
          ($0.IdeaServiceListRequest value) => value.writeToBuffer(),
          $0.IdeaServiceListResponse.fromBuffer);
  static final _$get =
      $grpc.ClientMethod<$0.IdeaServiceGetRequest, $0.IdeaServiceGetResponse>(
          '/creativanta.content.v1.IdeaService/Get',
          ($0.IdeaServiceGetRequest value) => value.writeToBuffer(),
          $0.IdeaServiceGetResponse.fromBuffer);
  static final _$update = $grpc.ClientMethod<$0.IdeaServiceUpdateRequest,
          $0.IdeaServiceUpdateResponse>(
      '/creativanta.content.v1.IdeaService/Update',
      ($0.IdeaServiceUpdateRequest value) => value.writeToBuffer(),
      $0.IdeaServiceUpdateResponse.fromBuffer);
  static final _$delete = $grpc.ClientMethod<$0.IdeaServiceDeleteRequest,
          $0.IdeaServiceDeleteResponse>(
      '/creativanta.content.v1.IdeaService/Delete',
      ($0.IdeaServiceDeleteRequest value) => value.writeToBuffer(),
      $0.IdeaServiceDeleteResponse.fromBuffer);
  static final _$updateStatus = $grpc.ClientMethod<
          $0.IdeaServiceUpdateStatusRequest,
          $0.IdeaServiceUpdateStatusResponse>(
      '/creativanta.content.v1.IdeaService/UpdateStatus',
      ($0.IdeaServiceUpdateStatusRequest value) => value.writeToBuffer(),
      $0.IdeaServiceUpdateStatusResponse.fromBuffer);
  static final _$generate = $grpc.ClientMethod<$0.IdeaServiceGenerateRequest,
          $0.IdeaServiceGenerateResponse>(
      '/creativanta.content.v1.IdeaService/Generate',
      ($0.IdeaServiceGenerateRequest value) => value.writeToBuffer(),
      $0.IdeaServiceGenerateResponse.fromBuffer);
  static final _$convert = $grpc.ClientMethod<$0.IdeaServiceConvertRequest,
          $0.IdeaServiceConvertResponse>(
      '/creativanta.content.v1.IdeaService/Convert',
      ($0.IdeaServiceConvertRequest value) => value.writeToBuffer(),
      $0.IdeaServiceConvertResponse.fromBuffer);
  static final _$search = $grpc.ClientMethod<$0.IdeaServiceSearchRequest,
          $0.IdeaServiceSearchResponse>(
      '/creativanta.content.v1.IdeaService/Search',
      ($0.IdeaServiceSearchRequest value) => value.writeToBuffer(),
      $0.IdeaServiceSearchResponse.fromBuffer);
  static final _$createFromTrend = $grpc.ClientMethod<
          $0.IdeaServiceCreateFromTrendRequest,
          $0.IdeaServiceCreateFromTrendResponse>(
      '/creativanta.content.v1.IdeaService/CreateFromTrend',
      ($0.IdeaServiceCreateFromTrendRequest value) => value.writeToBuffer(),
      $0.IdeaServiceCreateFromTrendResponse.fromBuffer);
  static final _$listMobile = $grpc.ClientMethod<
          $0.IdeaServiceListMobileRequest, $0.IdeaServiceListMobileResponse>(
      '/creativanta.content.v1.IdeaService/ListMobile',
      ($0.IdeaServiceListMobileRequest value) => value.writeToBuffer(),
      $0.IdeaServiceListMobileResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.content.v1.IdeaService')
abstract class IdeaServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.content.v1.IdeaService';

  IdeaServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.IdeaServiceCreateRequest,
            $0.IdeaServiceCreateResponse>(
        'Create',
        create_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.IdeaServiceCreateRequest.fromBuffer(value),
        ($0.IdeaServiceCreateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.IdeaServiceListRequest,
            $0.IdeaServiceListResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.IdeaServiceListRequest.fromBuffer(value),
        ($0.IdeaServiceListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.IdeaServiceGetRequest,
            $0.IdeaServiceGetResponse>(
        'Get',
        get_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.IdeaServiceGetRequest.fromBuffer(value),
        ($0.IdeaServiceGetResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.IdeaServiceUpdateRequest,
            $0.IdeaServiceUpdateResponse>(
        'Update',
        update_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.IdeaServiceUpdateRequest.fromBuffer(value),
        ($0.IdeaServiceUpdateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.IdeaServiceDeleteRequest,
            $0.IdeaServiceDeleteResponse>(
        'Delete',
        delete_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.IdeaServiceDeleteRequest.fromBuffer(value),
        ($0.IdeaServiceDeleteResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.IdeaServiceUpdateStatusRequest,
            $0.IdeaServiceUpdateStatusResponse>(
        'UpdateStatus',
        updateStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.IdeaServiceUpdateStatusRequest.fromBuffer(value),
        ($0.IdeaServiceUpdateStatusResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.IdeaServiceGenerateRequest,
            $0.IdeaServiceGenerateResponse>(
        'Generate',
        generate_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.IdeaServiceGenerateRequest.fromBuffer(value),
        ($0.IdeaServiceGenerateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.IdeaServiceConvertRequest,
            $0.IdeaServiceConvertResponse>(
        'Convert',
        convert_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.IdeaServiceConvertRequest.fromBuffer(value),
        ($0.IdeaServiceConvertResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.IdeaServiceSearchRequest,
            $0.IdeaServiceSearchResponse>(
        'Search',
        search_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.IdeaServiceSearchRequest.fromBuffer(value),
        ($0.IdeaServiceSearchResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.IdeaServiceCreateFromTrendRequest,
            $0.IdeaServiceCreateFromTrendResponse>(
        'CreateFromTrend',
        createFromTrend_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.IdeaServiceCreateFromTrendRequest.fromBuffer(value),
        ($0.IdeaServiceCreateFromTrendResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.IdeaServiceListMobileRequest,
            $0.IdeaServiceListMobileResponse>(
        'ListMobile',
        listMobile_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.IdeaServiceListMobileRequest.fromBuffer(value),
        ($0.IdeaServiceListMobileResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.IdeaServiceCreateResponse> create_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.IdeaServiceCreateRequest> $request) async {
    return create($call, await $request);
  }

  $async.Future<$0.IdeaServiceCreateResponse> create(
      $grpc.ServiceCall call, $0.IdeaServiceCreateRequest request);

  $async.Future<$0.IdeaServiceListResponse> list_Pre($grpc.ServiceCall $call,
      $async.Future<$0.IdeaServiceListRequest> $request) async {
    return list($call, await $request);
  }

  $async.Future<$0.IdeaServiceListResponse> list(
      $grpc.ServiceCall call, $0.IdeaServiceListRequest request);

  $async.Future<$0.IdeaServiceGetResponse> get_Pre($grpc.ServiceCall $call,
      $async.Future<$0.IdeaServiceGetRequest> $request) async {
    return get($call, await $request);
  }

  $async.Future<$0.IdeaServiceGetResponse> get(
      $grpc.ServiceCall call, $0.IdeaServiceGetRequest request);

  $async.Future<$0.IdeaServiceUpdateResponse> update_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.IdeaServiceUpdateRequest> $request) async {
    return update($call, await $request);
  }

  $async.Future<$0.IdeaServiceUpdateResponse> update(
      $grpc.ServiceCall call, $0.IdeaServiceUpdateRequest request);

  $async.Future<$0.IdeaServiceDeleteResponse> delete_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.IdeaServiceDeleteRequest> $request) async {
    return delete($call, await $request);
  }

  $async.Future<$0.IdeaServiceDeleteResponse> delete(
      $grpc.ServiceCall call, $0.IdeaServiceDeleteRequest request);

  $async.Future<$0.IdeaServiceUpdateStatusResponse> updateStatus_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.IdeaServiceUpdateStatusRequest> $request) async {
    return updateStatus($call, await $request);
  }

  $async.Future<$0.IdeaServiceUpdateStatusResponse> updateStatus(
      $grpc.ServiceCall call, $0.IdeaServiceUpdateStatusRequest request);

  $async.Future<$0.IdeaServiceGenerateResponse> generate_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.IdeaServiceGenerateRequest> $request) async {
    return generate($call, await $request);
  }

  $async.Future<$0.IdeaServiceGenerateResponse> generate(
      $grpc.ServiceCall call, $0.IdeaServiceGenerateRequest request);

  $async.Future<$0.IdeaServiceConvertResponse> convert_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.IdeaServiceConvertRequest> $request) async {
    return convert($call, await $request);
  }

  $async.Future<$0.IdeaServiceConvertResponse> convert(
      $grpc.ServiceCall call, $0.IdeaServiceConvertRequest request);

  $async.Future<$0.IdeaServiceSearchResponse> search_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.IdeaServiceSearchRequest> $request) async {
    return search($call, await $request);
  }

  $async.Future<$0.IdeaServiceSearchResponse> search(
      $grpc.ServiceCall call, $0.IdeaServiceSearchRequest request);

  $async.Future<$0.IdeaServiceCreateFromTrendResponse> createFromTrend_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.IdeaServiceCreateFromTrendRequest> $request) async {
    return createFromTrend($call, await $request);
  }

  $async.Future<$0.IdeaServiceCreateFromTrendResponse> createFromTrend(
      $grpc.ServiceCall call, $0.IdeaServiceCreateFromTrendRequest request);

  $async.Future<$0.IdeaServiceListMobileResponse> listMobile_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.IdeaServiceListMobileRequest> $request) async {
    return listMobile($call, await $request);
  }

  $async.Future<$0.IdeaServiceListMobileResponse> listMobile(
      $grpc.ServiceCall call, $0.IdeaServiceListMobileRequest request);
}
