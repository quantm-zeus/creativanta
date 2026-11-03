// This is a generated file - do not edit.
//
// Generated from creativanta/content/v1/continuity.proto.

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

import 'continuity.pb.dart' as $0;

export 'continuity.pb.dart';

/// CharacterService manages digital twins, AI personas, stock avatars, and wizard workflows (M08).
@$pb.GrpcServiceName('creativanta.content.v1.CharacterService')
class CharacterServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  CharacterServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.CharacterServiceCreateResponse> create(
    $0.CharacterServiceCreateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$create, request, options: options);
  }

  $grpc.ResponseFuture<$0.CharacterServiceGetResponse> get(
    $0.CharacterServiceGetRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$get, request, options: options);
  }

  $grpc.ResponseFuture<$0.CharacterServiceListResponse> list(
    $0.CharacterServiceListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$list, request, options: options);
  }

  $grpc.ResponseFuture<$0.CharacterServiceUpdateResponse> update(
    $0.CharacterServiceUpdateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$update, request, options: options);
  }

  $grpc.ResponseFuture<$0.CharacterServiceDeleteResponse> delete(
    $0.CharacterServiceDeleteRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$delete, request, options: options);
  }

  // method descriptors

  static final _$create = $grpc.ClientMethod<$0.CharacterServiceCreateRequest,
          $0.CharacterServiceCreateResponse>(
      '/creativanta.content.v1.CharacterService/Create',
      ($0.CharacterServiceCreateRequest value) => value.writeToBuffer(),
      $0.CharacterServiceCreateResponse.fromBuffer);
  static final _$get = $grpc.ClientMethod<$0.CharacterServiceGetRequest,
          $0.CharacterServiceGetResponse>(
      '/creativanta.content.v1.CharacterService/Get',
      ($0.CharacterServiceGetRequest value) => value.writeToBuffer(),
      $0.CharacterServiceGetResponse.fromBuffer);
  static final _$list = $grpc.ClientMethod<$0.CharacterServiceListRequest,
          $0.CharacterServiceListResponse>(
      '/creativanta.content.v1.CharacterService/List',
      ($0.CharacterServiceListRequest value) => value.writeToBuffer(),
      $0.CharacterServiceListResponse.fromBuffer);
  static final _$update = $grpc.ClientMethod<$0.CharacterServiceUpdateRequest,
          $0.CharacterServiceUpdateResponse>(
      '/creativanta.content.v1.CharacterService/Update',
      ($0.CharacterServiceUpdateRequest value) => value.writeToBuffer(),
      $0.CharacterServiceUpdateResponse.fromBuffer);
  static final _$delete = $grpc.ClientMethod<$0.CharacterServiceDeleteRequest,
          $0.CharacterServiceDeleteResponse>(
      '/creativanta.content.v1.CharacterService/Delete',
      ($0.CharacterServiceDeleteRequest value) => value.writeToBuffer(),
      $0.CharacterServiceDeleteResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.content.v1.CharacterService')
abstract class CharacterServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.content.v1.CharacterService';

  CharacterServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CharacterServiceCreateRequest,
            $0.CharacterServiceCreateResponse>(
        'Create',
        create_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CharacterServiceCreateRequest.fromBuffer(value),
        ($0.CharacterServiceCreateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CharacterServiceGetRequest,
            $0.CharacterServiceGetResponse>(
        'Get',
        get_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CharacterServiceGetRequest.fromBuffer(value),
        ($0.CharacterServiceGetResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CharacterServiceListRequest,
            $0.CharacterServiceListResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CharacterServiceListRequest.fromBuffer(value),
        ($0.CharacterServiceListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CharacterServiceUpdateRequest,
            $0.CharacterServiceUpdateResponse>(
        'Update',
        update_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CharacterServiceUpdateRequest.fromBuffer(value),
        ($0.CharacterServiceUpdateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CharacterServiceDeleteRequest,
            $0.CharacterServiceDeleteResponse>(
        'Delete',
        delete_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CharacterServiceDeleteRequest.fromBuffer(value),
        ($0.CharacterServiceDeleteResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.CharacterServiceCreateResponse> create_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CharacterServiceCreateRequest> $request) async {
    return create($call, await $request);
  }

  $async.Future<$0.CharacterServiceCreateResponse> create(
      $grpc.ServiceCall call, $0.CharacterServiceCreateRequest request);

  $async.Future<$0.CharacterServiceGetResponse> get_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CharacterServiceGetRequest> $request) async {
    return get($call, await $request);
  }

  $async.Future<$0.CharacterServiceGetResponse> get(
      $grpc.ServiceCall call, $0.CharacterServiceGetRequest request);

  $async.Future<$0.CharacterServiceListResponse> list_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CharacterServiceListRequest> $request) async {
    return list($call, await $request);
  }

  $async.Future<$0.CharacterServiceListResponse> list(
      $grpc.ServiceCall call, $0.CharacterServiceListRequest request);

  $async.Future<$0.CharacterServiceUpdateResponse> update_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CharacterServiceUpdateRequest> $request) async {
    return update($call, await $request);
  }

  $async.Future<$0.CharacterServiceUpdateResponse> update(
      $grpc.ServiceCall call, $0.CharacterServiceUpdateRequest request);

  $async.Future<$0.CharacterServiceDeleteResponse> delete_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CharacterServiceDeleteRequest> $request) async {
    return delete($call, await $request);
  }

  $async.Future<$0.CharacterServiceDeleteResponse> delete(
      $grpc.ServiceCall call, $0.CharacterServiceDeleteRequest request);
}

/// ContinuityService manages continuity packs, versioning, approved references, and pack usage (M08).
@$pb.GrpcServiceName('creativanta.content.v1.ContinuityService')
class ContinuityServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ContinuityServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.ContinuityServiceCreateResponse> create(
    $0.ContinuityServiceCreateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$create, request, options: options);
  }

  $grpc.ResponseFuture<$0.ContinuityServiceGetResponse> get(
    $0.ContinuityServiceGetRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$get, request, options: options);
  }

  $grpc.ResponseFuture<$0.ContinuityServiceGetPackResponse> getPack(
    $0.ContinuityServiceGetPackRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getPack, request, options: options);
  }

  $grpc.ResponseFuture<$0.ContinuityServiceUpdatePackResponse> updatePack(
    $0.ContinuityServiceUpdatePackRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updatePack, request, options: options);
  }

  $grpc.ResponseFuture<$0.ContinuityServiceCloneResponse> clone(
    $0.ContinuityServiceCloneRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$clone, request, options: options);
  }

  $grpc.ResponseFuture<$0.ContinuityServiceDeleteResponse> delete(
    $0.ContinuityServiceDeleteRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$delete, request, options: options);
  }

  $grpc.ResponseFuture<$0.ContinuityServiceGetUsageStatsResponse> getUsageStats(
    $0.ContinuityServiceGetUsageStatsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getUsageStats, request, options: options);
  }

  $grpc.ResponseFuture<$0.ContinuityServiceListBrandPacksResponse>
      listBrandPacks(
    $0.ContinuityServiceListBrandPacksRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listBrandPacks, request, options: options);
  }

  $grpc.ResponseFuture<$0.ContinuityServiceListCharactersResponse>
      listCharacters(
    $0.ContinuityServiceListCharactersRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listCharacters, request, options: options);
  }

  $grpc.ResponseFuture<$0.ContinuityServiceListVoicesResponse> listVoices(
    $0.ContinuityServiceListVoicesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listVoices, request, options: options);
  }

  // method descriptors

  static final _$create = $grpc.ClientMethod<$0.ContinuityServiceCreateRequest,
          $0.ContinuityServiceCreateResponse>(
      '/creativanta.content.v1.ContinuityService/Create',
      ($0.ContinuityServiceCreateRequest value) => value.writeToBuffer(),
      $0.ContinuityServiceCreateResponse.fromBuffer);
  static final _$get = $grpc.ClientMethod<$0.ContinuityServiceGetRequest,
          $0.ContinuityServiceGetResponse>(
      '/creativanta.content.v1.ContinuityService/Get',
      ($0.ContinuityServiceGetRequest value) => value.writeToBuffer(),
      $0.ContinuityServiceGetResponse.fromBuffer);
  static final _$getPack = $grpc.ClientMethod<
          $0.ContinuityServiceGetPackRequest,
          $0.ContinuityServiceGetPackResponse>(
      '/creativanta.content.v1.ContinuityService/GetPack',
      ($0.ContinuityServiceGetPackRequest value) => value.writeToBuffer(),
      $0.ContinuityServiceGetPackResponse.fromBuffer);
  static final _$updatePack = $grpc.ClientMethod<
          $0.ContinuityServiceUpdatePackRequest,
          $0.ContinuityServiceUpdatePackResponse>(
      '/creativanta.content.v1.ContinuityService/UpdatePack',
      ($0.ContinuityServiceUpdatePackRequest value) => value.writeToBuffer(),
      $0.ContinuityServiceUpdatePackResponse.fromBuffer);
  static final _$clone = $grpc.ClientMethod<$0.ContinuityServiceCloneRequest,
          $0.ContinuityServiceCloneResponse>(
      '/creativanta.content.v1.ContinuityService/Clone',
      ($0.ContinuityServiceCloneRequest value) => value.writeToBuffer(),
      $0.ContinuityServiceCloneResponse.fromBuffer);
  static final _$delete = $grpc.ClientMethod<$0.ContinuityServiceDeleteRequest,
          $0.ContinuityServiceDeleteResponse>(
      '/creativanta.content.v1.ContinuityService/Delete',
      ($0.ContinuityServiceDeleteRequest value) => value.writeToBuffer(),
      $0.ContinuityServiceDeleteResponse.fromBuffer);
  static final _$getUsageStats = $grpc.ClientMethod<
          $0.ContinuityServiceGetUsageStatsRequest,
          $0.ContinuityServiceGetUsageStatsResponse>(
      '/creativanta.content.v1.ContinuityService/GetUsageStats',
      ($0.ContinuityServiceGetUsageStatsRequest value) => value.writeToBuffer(),
      $0.ContinuityServiceGetUsageStatsResponse.fromBuffer);
  static final _$listBrandPacks = $grpc.ClientMethod<
          $0.ContinuityServiceListBrandPacksRequest,
          $0.ContinuityServiceListBrandPacksResponse>(
      '/creativanta.content.v1.ContinuityService/ListBrandPacks',
      ($0.ContinuityServiceListBrandPacksRequest value) =>
          value.writeToBuffer(),
      $0.ContinuityServiceListBrandPacksResponse.fromBuffer);
  static final _$listCharacters = $grpc.ClientMethod<
          $0.ContinuityServiceListCharactersRequest,
          $0.ContinuityServiceListCharactersResponse>(
      '/creativanta.content.v1.ContinuityService/ListCharacters',
      ($0.ContinuityServiceListCharactersRequest value) =>
          value.writeToBuffer(),
      $0.ContinuityServiceListCharactersResponse.fromBuffer);
  static final _$listVoices = $grpc.ClientMethod<
          $0.ContinuityServiceListVoicesRequest,
          $0.ContinuityServiceListVoicesResponse>(
      '/creativanta.content.v1.ContinuityService/ListVoices',
      ($0.ContinuityServiceListVoicesRequest value) => value.writeToBuffer(),
      $0.ContinuityServiceListVoicesResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.content.v1.ContinuityService')
abstract class ContinuityServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.content.v1.ContinuityService';

  ContinuityServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ContinuityServiceCreateRequest,
            $0.ContinuityServiceCreateResponse>(
        'Create',
        create_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ContinuityServiceCreateRequest.fromBuffer(value),
        ($0.ContinuityServiceCreateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ContinuityServiceGetRequest,
            $0.ContinuityServiceGetResponse>(
        'Get',
        get_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ContinuityServiceGetRequest.fromBuffer(value),
        ($0.ContinuityServiceGetResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ContinuityServiceGetPackRequest,
            $0.ContinuityServiceGetPackResponse>(
        'GetPack',
        getPack_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ContinuityServiceGetPackRequest.fromBuffer(value),
        ($0.ContinuityServiceGetPackResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ContinuityServiceUpdatePackRequest,
            $0.ContinuityServiceUpdatePackResponse>(
        'UpdatePack',
        updatePack_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ContinuityServiceUpdatePackRequest.fromBuffer(value),
        ($0.ContinuityServiceUpdatePackResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ContinuityServiceCloneRequest,
            $0.ContinuityServiceCloneResponse>(
        'Clone',
        clone_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ContinuityServiceCloneRequest.fromBuffer(value),
        ($0.ContinuityServiceCloneResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ContinuityServiceDeleteRequest,
            $0.ContinuityServiceDeleteResponse>(
        'Delete',
        delete_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ContinuityServiceDeleteRequest.fromBuffer(value),
        ($0.ContinuityServiceDeleteResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ContinuityServiceGetUsageStatsRequest,
            $0.ContinuityServiceGetUsageStatsResponse>(
        'GetUsageStats',
        getUsageStats_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ContinuityServiceGetUsageStatsRequest.fromBuffer(value),
        ($0.ContinuityServiceGetUsageStatsResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ContinuityServiceListBrandPacksRequest,
            $0.ContinuityServiceListBrandPacksResponse>(
        'ListBrandPacks',
        listBrandPacks_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ContinuityServiceListBrandPacksRequest.fromBuffer(value),
        ($0.ContinuityServiceListBrandPacksResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ContinuityServiceListCharactersRequest,
            $0.ContinuityServiceListCharactersResponse>(
        'ListCharacters',
        listCharacters_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ContinuityServiceListCharactersRequest.fromBuffer(value),
        ($0.ContinuityServiceListCharactersResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ContinuityServiceListVoicesRequest,
            $0.ContinuityServiceListVoicesResponse>(
        'ListVoices',
        listVoices_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ContinuityServiceListVoicesRequest.fromBuffer(value),
        ($0.ContinuityServiceListVoicesResponse value) =>
            value.writeToBuffer()));
  }

  $async.Future<$0.ContinuityServiceCreateResponse> create_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ContinuityServiceCreateRequest> $request) async {
    return create($call, await $request);
  }

  $async.Future<$0.ContinuityServiceCreateResponse> create(
      $grpc.ServiceCall call, $0.ContinuityServiceCreateRequest request);

  $async.Future<$0.ContinuityServiceGetResponse> get_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ContinuityServiceGetRequest> $request) async {
    return get($call, await $request);
  }

  $async.Future<$0.ContinuityServiceGetResponse> get(
      $grpc.ServiceCall call, $0.ContinuityServiceGetRequest request);

  $async.Future<$0.ContinuityServiceGetPackResponse> getPack_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ContinuityServiceGetPackRequest> $request) async {
    return getPack($call, await $request);
  }

  $async.Future<$0.ContinuityServiceGetPackResponse> getPack(
      $grpc.ServiceCall call, $0.ContinuityServiceGetPackRequest request);

  $async.Future<$0.ContinuityServiceUpdatePackResponse> updatePack_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ContinuityServiceUpdatePackRequest> $request) async {
    return updatePack($call, await $request);
  }

  $async.Future<$0.ContinuityServiceUpdatePackResponse> updatePack(
      $grpc.ServiceCall call, $0.ContinuityServiceUpdatePackRequest request);

  $async.Future<$0.ContinuityServiceCloneResponse> clone_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ContinuityServiceCloneRequest> $request) async {
    return clone($call, await $request);
  }

  $async.Future<$0.ContinuityServiceCloneResponse> clone(
      $grpc.ServiceCall call, $0.ContinuityServiceCloneRequest request);

  $async.Future<$0.ContinuityServiceDeleteResponse> delete_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ContinuityServiceDeleteRequest> $request) async {
    return delete($call, await $request);
  }

  $async.Future<$0.ContinuityServiceDeleteResponse> delete(
      $grpc.ServiceCall call, $0.ContinuityServiceDeleteRequest request);

  $async.Future<$0.ContinuityServiceGetUsageStatsResponse> getUsageStats_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ContinuityServiceGetUsageStatsRequest> $request) async {
    return getUsageStats($call, await $request);
  }

  $async.Future<$0.ContinuityServiceGetUsageStatsResponse> getUsageStats(
      $grpc.ServiceCall call, $0.ContinuityServiceGetUsageStatsRequest request);

  $async.Future<$0.ContinuityServiceListBrandPacksResponse> listBrandPacks_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ContinuityServiceListBrandPacksRequest> $request) async {
    return listBrandPacks($call, await $request);
  }

  $async.Future<$0.ContinuityServiceListBrandPacksResponse> listBrandPacks(
      $grpc.ServiceCall call,
      $0.ContinuityServiceListBrandPacksRequest request);

  $async.Future<$0.ContinuityServiceListCharactersResponse> listCharacters_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ContinuityServiceListCharactersRequest> $request) async {
    return listCharacters($call, await $request);
  }

  $async.Future<$0.ContinuityServiceListCharactersResponse> listCharacters(
      $grpc.ServiceCall call,
      $0.ContinuityServiceListCharactersRequest request);

  $async.Future<$0.ContinuityServiceListVoicesResponse> listVoices_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ContinuityServiceListVoicesRequest> $request) async {
    return listVoices($call, await $request);
  }

  $async.Future<$0.ContinuityServiceListVoicesResponse> listVoices(
      $grpc.ServiceCall call, $0.ContinuityServiceListVoicesRequest request);
}

/// ConsentService manages user and digital likeness consents and revocation (M08 / Compliance).
@$pb.GrpcServiceName('creativanta.content.v1.ConsentService')
class ConsentServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ConsentServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.ConsentServiceGrantResponse> grant(
    $0.ConsentServiceGrantRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$grant, request, options: options);
  }

  $grpc.ResponseFuture<$0.ConsentServiceRevokeResponse> revoke(
    $0.ConsentServiceRevokeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$revoke, request, options: options);
  }

  // method descriptors

  static final _$grant = $grpc.ClientMethod<$0.ConsentServiceGrantRequest,
          $0.ConsentServiceGrantResponse>(
      '/creativanta.content.v1.ConsentService/Grant',
      ($0.ConsentServiceGrantRequest value) => value.writeToBuffer(),
      $0.ConsentServiceGrantResponse.fromBuffer);
  static final _$revoke = $grpc.ClientMethod<$0.ConsentServiceRevokeRequest,
          $0.ConsentServiceRevokeResponse>(
      '/creativanta.content.v1.ConsentService/Revoke',
      ($0.ConsentServiceRevokeRequest value) => value.writeToBuffer(),
      $0.ConsentServiceRevokeResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.content.v1.ConsentService')
abstract class ConsentServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.content.v1.ConsentService';

  ConsentServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ConsentServiceGrantRequest,
            $0.ConsentServiceGrantResponse>(
        'Grant',
        grant_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ConsentServiceGrantRequest.fromBuffer(value),
        ($0.ConsentServiceGrantResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ConsentServiceRevokeRequest,
            $0.ConsentServiceRevokeResponse>(
        'Revoke',
        revoke_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ConsentServiceRevokeRequest.fromBuffer(value),
        ($0.ConsentServiceRevokeResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.ConsentServiceGrantResponse> grant_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ConsentServiceGrantRequest> $request) async {
    return grant($call, await $request);
  }

  $async.Future<$0.ConsentServiceGrantResponse> grant(
      $grpc.ServiceCall call, $0.ConsentServiceGrantRequest request);

  $async.Future<$0.ConsentServiceRevokeResponse> revoke_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ConsentServiceRevokeRequest> $request) async {
    return revoke($call, await $request);
  }

  $async.Future<$0.ConsentServiceRevokeResponse> revoke(
      $grpc.ServiceCall call, $0.ConsentServiceRevokeRequest request);
}
