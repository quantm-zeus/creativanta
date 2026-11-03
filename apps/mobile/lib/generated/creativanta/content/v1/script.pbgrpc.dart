// This is a generated file - do not edit.
//
// Generated from creativanta/content/v1/script.proto.

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

import 'script.pb.dart' as $0;

export 'script.pb.dart';

/// ScriptService manages script authoring, approval workflows, version compare, and asset brief conversion (M06).
@$pb.GrpcServiceName('creativanta.content.v1.ScriptService')
class ScriptServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ScriptServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.ScriptServiceCreateResponse> create(
    $0.ScriptServiceCreateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$create, request, options: options);
  }

  $grpc.ResponseFuture<$0.ScriptServiceGetResponse> get(
    $0.ScriptServiceGetRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$get, request, options: options);
  }

  $grpc.ResponseFuture<$0.ScriptServiceUpdateResponse> update(
    $0.ScriptServiceUpdateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$update, request, options: options);
  }

  $grpc.ResponseFuture<$0.ScriptServiceSubmitApprovalResponse> submitApproval(
    $0.ScriptServiceSubmitApprovalRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$submitApproval, request, options: options);
  }

  $grpc.ResponseFuture<$0.ScriptServiceApproveResponse> approve(
    $0.ScriptServiceApproveRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$approve, request, options: options);
  }

  $grpc.ResponseFuture<$0.ScriptServiceRejectResponse> reject(
    $0.ScriptServiceRejectRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$reject, request, options: options);
  }

  $grpc.ResponseFuture<$0.ScriptServiceListResponse> list(
    $0.ScriptServiceListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$list, request, options: options);
  }

  $grpc.ResponseFuture<$0.ScriptServiceDeleteResponse> delete(
    $0.ScriptServiceDeleteRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$delete, request, options: options);
  }

  $grpc.ResponseFuture<$0.ScriptServiceDuplicateResponse> duplicate(
    $0.ScriptServiceDuplicateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$duplicate, request, options: options);
  }

  $grpc.ResponseFuture<$0.ScriptServiceGetStatsResponse> getStats(
    $0.ScriptServiceGetStatsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getStats, request, options: options);
  }

  $grpc.ResponseFuture<$0.ScriptServiceGetBriefResponse> getBrief(
    $0.ScriptServiceGetBriefRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getBrief, request, options: options);
  }

  $grpc.ResponseFuture<$0.ScriptServiceGetReviewResponse> getReview(
    $0.ScriptServiceGetReviewRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getReview, request, options: options);
  }

  $grpc.ResponseFuture<$0.ScriptServiceSubmitReviewResponse> submitReview(
    $0.ScriptServiceSubmitReviewRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$submitReview, request, options: options);
  }

  $grpc.ResponseFuture<$0.ScriptServiceRequestChangesResponse> requestChanges(
    $0.ScriptServiceRequestChangesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$requestChanges, request, options: options);
  }

  $grpc.ResponseFuture<$0.ScriptServiceAddSectionResponse> addSection(
    $0.ScriptServiceAddSectionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$addSection, request, options: options);
  }

  $grpc.ResponseFuture<$0.ScriptServiceUpdateSectionResponse> updateSection(
    $0.ScriptServiceUpdateSectionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateSection, request, options: options);
  }

  $grpc.ResponseFuture<$0.ScriptServiceDeleteSectionResponse> deleteSection(
    $0.ScriptServiceDeleteSectionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteSection, request, options: options);
  }

  $grpc.ResponseFuture<$0.ScriptServiceReorderSectionsResponse> reorderSections(
    $0.ScriptServiceReorderSectionsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$reorderSections, request, options: options);
  }

  $grpc.ResponseFuture<$0.ScriptServiceAddCommentResponse> addComment(
    $0.ScriptServiceAddCommentRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$addComment, request, options: options);
  }

  $grpc.ResponseFuture<$0.ScriptServiceResolveCommentResponse> resolveComment(
    $0.ScriptServiceResolveCommentRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$resolveComment, request, options: options);
  }

  $grpc.ResponseFuture<$0.ScriptServiceGetVersionResponse> getVersion(
    $0.ScriptServiceGetVersionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getVersion, request, options: options);
  }

  $grpc.ResponseFuture<$0.ScriptServiceListVersionsResponse> listVersions(
    $0.ScriptServiceListVersionsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listVersions, request, options: options);
  }

  $grpc.ResponseFuture<$0.ScriptServiceRestoreVersionResponse> restoreVersion(
    $0.ScriptServiceRestoreVersionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$restoreVersion, request, options: options);
  }

  // method descriptors

  static final _$create = $grpc.ClientMethod<$0.ScriptServiceCreateRequest,
          $0.ScriptServiceCreateResponse>(
      '/creativanta.content.v1.ScriptService/Create',
      ($0.ScriptServiceCreateRequest value) => value.writeToBuffer(),
      $0.ScriptServiceCreateResponse.fromBuffer);
  static final _$get = $grpc.ClientMethod<$0.ScriptServiceGetRequest,
          $0.ScriptServiceGetResponse>(
      '/creativanta.content.v1.ScriptService/Get',
      ($0.ScriptServiceGetRequest value) => value.writeToBuffer(),
      $0.ScriptServiceGetResponse.fromBuffer);
  static final _$update = $grpc.ClientMethod<$0.ScriptServiceUpdateRequest,
          $0.ScriptServiceUpdateResponse>(
      '/creativanta.content.v1.ScriptService/Update',
      ($0.ScriptServiceUpdateRequest value) => value.writeToBuffer(),
      $0.ScriptServiceUpdateResponse.fromBuffer);
  static final _$submitApproval = $grpc.ClientMethod<
          $0.ScriptServiceSubmitApprovalRequest,
          $0.ScriptServiceSubmitApprovalResponse>(
      '/creativanta.content.v1.ScriptService/SubmitApproval',
      ($0.ScriptServiceSubmitApprovalRequest value) => value.writeToBuffer(),
      $0.ScriptServiceSubmitApprovalResponse.fromBuffer);
  static final _$approve = $grpc.ClientMethod<$0.ScriptServiceApproveRequest,
          $0.ScriptServiceApproveResponse>(
      '/creativanta.content.v1.ScriptService/Approve',
      ($0.ScriptServiceApproveRequest value) => value.writeToBuffer(),
      $0.ScriptServiceApproveResponse.fromBuffer);
  static final _$reject = $grpc.ClientMethod<$0.ScriptServiceRejectRequest,
          $0.ScriptServiceRejectResponse>(
      '/creativanta.content.v1.ScriptService/Reject',
      ($0.ScriptServiceRejectRequest value) => value.writeToBuffer(),
      $0.ScriptServiceRejectResponse.fromBuffer);
  static final _$list = $grpc.ClientMethod<$0.ScriptServiceListRequest,
          $0.ScriptServiceListResponse>(
      '/creativanta.content.v1.ScriptService/List',
      ($0.ScriptServiceListRequest value) => value.writeToBuffer(),
      $0.ScriptServiceListResponse.fromBuffer);
  static final _$delete = $grpc.ClientMethod<$0.ScriptServiceDeleteRequest,
          $0.ScriptServiceDeleteResponse>(
      '/creativanta.content.v1.ScriptService/Delete',
      ($0.ScriptServiceDeleteRequest value) => value.writeToBuffer(),
      $0.ScriptServiceDeleteResponse.fromBuffer);
  static final _$duplicate = $grpc.ClientMethod<
          $0.ScriptServiceDuplicateRequest, $0.ScriptServiceDuplicateResponse>(
      '/creativanta.content.v1.ScriptService/Duplicate',
      ($0.ScriptServiceDuplicateRequest value) => value.writeToBuffer(),
      $0.ScriptServiceDuplicateResponse.fromBuffer);
  static final _$getStats = $grpc.ClientMethod<$0.ScriptServiceGetStatsRequest,
          $0.ScriptServiceGetStatsResponse>(
      '/creativanta.content.v1.ScriptService/GetStats',
      ($0.ScriptServiceGetStatsRequest value) => value.writeToBuffer(),
      $0.ScriptServiceGetStatsResponse.fromBuffer);
  static final _$getBrief = $grpc.ClientMethod<$0.ScriptServiceGetBriefRequest,
          $0.ScriptServiceGetBriefResponse>(
      '/creativanta.content.v1.ScriptService/GetBrief',
      ($0.ScriptServiceGetBriefRequest value) => value.writeToBuffer(),
      $0.ScriptServiceGetBriefResponse.fromBuffer);
  static final _$getReview = $grpc.ClientMethod<
          $0.ScriptServiceGetReviewRequest, $0.ScriptServiceGetReviewResponse>(
      '/creativanta.content.v1.ScriptService/GetReview',
      ($0.ScriptServiceGetReviewRequest value) => value.writeToBuffer(),
      $0.ScriptServiceGetReviewResponse.fromBuffer);
  static final _$submitReview = $grpc.ClientMethod<
          $0.ScriptServiceSubmitReviewRequest,
          $0.ScriptServiceSubmitReviewResponse>(
      '/creativanta.content.v1.ScriptService/SubmitReview',
      ($0.ScriptServiceSubmitReviewRequest value) => value.writeToBuffer(),
      $0.ScriptServiceSubmitReviewResponse.fromBuffer);
  static final _$requestChanges = $grpc.ClientMethod<
          $0.ScriptServiceRequestChangesRequest,
          $0.ScriptServiceRequestChangesResponse>(
      '/creativanta.content.v1.ScriptService/RequestChanges',
      ($0.ScriptServiceRequestChangesRequest value) => value.writeToBuffer(),
      $0.ScriptServiceRequestChangesResponse.fromBuffer);
  static final _$addSection = $grpc.ClientMethod<
          $0.ScriptServiceAddSectionRequest,
          $0.ScriptServiceAddSectionResponse>(
      '/creativanta.content.v1.ScriptService/AddSection',
      ($0.ScriptServiceAddSectionRequest value) => value.writeToBuffer(),
      $0.ScriptServiceAddSectionResponse.fromBuffer);
  static final _$updateSection = $grpc.ClientMethod<
          $0.ScriptServiceUpdateSectionRequest,
          $0.ScriptServiceUpdateSectionResponse>(
      '/creativanta.content.v1.ScriptService/UpdateSection',
      ($0.ScriptServiceUpdateSectionRequest value) => value.writeToBuffer(),
      $0.ScriptServiceUpdateSectionResponse.fromBuffer);
  static final _$deleteSection = $grpc.ClientMethod<
          $0.ScriptServiceDeleteSectionRequest,
          $0.ScriptServiceDeleteSectionResponse>(
      '/creativanta.content.v1.ScriptService/DeleteSection',
      ($0.ScriptServiceDeleteSectionRequest value) => value.writeToBuffer(),
      $0.ScriptServiceDeleteSectionResponse.fromBuffer);
  static final _$reorderSections = $grpc.ClientMethod<
          $0.ScriptServiceReorderSectionsRequest,
          $0.ScriptServiceReorderSectionsResponse>(
      '/creativanta.content.v1.ScriptService/ReorderSections',
      ($0.ScriptServiceReorderSectionsRequest value) => value.writeToBuffer(),
      $0.ScriptServiceReorderSectionsResponse.fromBuffer);
  static final _$addComment = $grpc.ClientMethod<
          $0.ScriptServiceAddCommentRequest,
          $0.ScriptServiceAddCommentResponse>(
      '/creativanta.content.v1.ScriptService/AddComment',
      ($0.ScriptServiceAddCommentRequest value) => value.writeToBuffer(),
      $0.ScriptServiceAddCommentResponse.fromBuffer);
  static final _$resolveComment = $grpc.ClientMethod<
          $0.ScriptServiceResolveCommentRequest,
          $0.ScriptServiceResolveCommentResponse>(
      '/creativanta.content.v1.ScriptService/ResolveComment',
      ($0.ScriptServiceResolveCommentRequest value) => value.writeToBuffer(),
      $0.ScriptServiceResolveCommentResponse.fromBuffer);
  static final _$getVersion = $grpc.ClientMethod<
          $0.ScriptServiceGetVersionRequest,
          $0.ScriptServiceGetVersionResponse>(
      '/creativanta.content.v1.ScriptService/GetVersion',
      ($0.ScriptServiceGetVersionRequest value) => value.writeToBuffer(),
      $0.ScriptServiceGetVersionResponse.fromBuffer);
  static final _$listVersions = $grpc.ClientMethod<
          $0.ScriptServiceListVersionsRequest,
          $0.ScriptServiceListVersionsResponse>(
      '/creativanta.content.v1.ScriptService/ListVersions',
      ($0.ScriptServiceListVersionsRequest value) => value.writeToBuffer(),
      $0.ScriptServiceListVersionsResponse.fromBuffer);
  static final _$restoreVersion = $grpc.ClientMethod<
          $0.ScriptServiceRestoreVersionRequest,
          $0.ScriptServiceRestoreVersionResponse>(
      '/creativanta.content.v1.ScriptService/RestoreVersion',
      ($0.ScriptServiceRestoreVersionRequest value) => value.writeToBuffer(),
      $0.ScriptServiceRestoreVersionResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.content.v1.ScriptService')
abstract class ScriptServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.content.v1.ScriptService';

  ScriptServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ScriptServiceCreateRequest,
            $0.ScriptServiceCreateResponse>(
        'Create',
        create_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ScriptServiceCreateRequest.fromBuffer(value),
        ($0.ScriptServiceCreateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ScriptServiceGetRequest,
            $0.ScriptServiceGetResponse>(
        'Get',
        get_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ScriptServiceGetRequest.fromBuffer(value),
        ($0.ScriptServiceGetResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ScriptServiceUpdateRequest,
            $0.ScriptServiceUpdateResponse>(
        'Update',
        update_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ScriptServiceUpdateRequest.fromBuffer(value),
        ($0.ScriptServiceUpdateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ScriptServiceSubmitApprovalRequest,
            $0.ScriptServiceSubmitApprovalResponse>(
        'SubmitApproval',
        submitApproval_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ScriptServiceSubmitApprovalRequest.fromBuffer(value),
        ($0.ScriptServiceSubmitApprovalResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ScriptServiceApproveRequest,
            $0.ScriptServiceApproveResponse>(
        'Approve',
        approve_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ScriptServiceApproveRequest.fromBuffer(value),
        ($0.ScriptServiceApproveResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ScriptServiceRejectRequest,
            $0.ScriptServiceRejectResponse>(
        'Reject',
        reject_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ScriptServiceRejectRequest.fromBuffer(value),
        ($0.ScriptServiceRejectResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ScriptServiceListRequest,
            $0.ScriptServiceListResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ScriptServiceListRequest.fromBuffer(value),
        ($0.ScriptServiceListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ScriptServiceDeleteRequest,
            $0.ScriptServiceDeleteResponse>(
        'Delete',
        delete_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ScriptServiceDeleteRequest.fromBuffer(value),
        ($0.ScriptServiceDeleteResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ScriptServiceDuplicateRequest,
            $0.ScriptServiceDuplicateResponse>(
        'Duplicate',
        duplicate_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ScriptServiceDuplicateRequest.fromBuffer(value),
        ($0.ScriptServiceDuplicateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ScriptServiceGetStatsRequest,
            $0.ScriptServiceGetStatsResponse>(
        'GetStats',
        getStats_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ScriptServiceGetStatsRequest.fromBuffer(value),
        ($0.ScriptServiceGetStatsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ScriptServiceGetBriefRequest,
            $0.ScriptServiceGetBriefResponse>(
        'GetBrief',
        getBrief_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ScriptServiceGetBriefRequest.fromBuffer(value),
        ($0.ScriptServiceGetBriefResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ScriptServiceGetReviewRequest,
            $0.ScriptServiceGetReviewResponse>(
        'GetReview',
        getReview_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ScriptServiceGetReviewRequest.fromBuffer(value),
        ($0.ScriptServiceGetReviewResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ScriptServiceSubmitReviewRequest,
            $0.ScriptServiceSubmitReviewResponse>(
        'SubmitReview',
        submitReview_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ScriptServiceSubmitReviewRequest.fromBuffer(value),
        ($0.ScriptServiceSubmitReviewResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ScriptServiceRequestChangesRequest,
            $0.ScriptServiceRequestChangesResponse>(
        'RequestChanges',
        requestChanges_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ScriptServiceRequestChangesRequest.fromBuffer(value),
        ($0.ScriptServiceRequestChangesResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ScriptServiceAddSectionRequest,
            $0.ScriptServiceAddSectionResponse>(
        'AddSection',
        addSection_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ScriptServiceAddSectionRequest.fromBuffer(value),
        ($0.ScriptServiceAddSectionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ScriptServiceUpdateSectionRequest,
            $0.ScriptServiceUpdateSectionResponse>(
        'UpdateSection',
        updateSection_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ScriptServiceUpdateSectionRequest.fromBuffer(value),
        ($0.ScriptServiceUpdateSectionResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ScriptServiceDeleteSectionRequest,
            $0.ScriptServiceDeleteSectionResponse>(
        'DeleteSection',
        deleteSection_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ScriptServiceDeleteSectionRequest.fromBuffer(value),
        ($0.ScriptServiceDeleteSectionResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ScriptServiceReorderSectionsRequest,
            $0.ScriptServiceReorderSectionsResponse>(
        'ReorderSections',
        reorderSections_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ScriptServiceReorderSectionsRequest.fromBuffer(value),
        ($0.ScriptServiceReorderSectionsResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ScriptServiceAddCommentRequest,
            $0.ScriptServiceAddCommentResponse>(
        'AddComment',
        addComment_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ScriptServiceAddCommentRequest.fromBuffer(value),
        ($0.ScriptServiceAddCommentResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ScriptServiceResolveCommentRequest,
            $0.ScriptServiceResolveCommentResponse>(
        'ResolveComment',
        resolveComment_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ScriptServiceResolveCommentRequest.fromBuffer(value),
        ($0.ScriptServiceResolveCommentResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ScriptServiceGetVersionRequest,
            $0.ScriptServiceGetVersionResponse>(
        'GetVersion',
        getVersion_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ScriptServiceGetVersionRequest.fromBuffer(value),
        ($0.ScriptServiceGetVersionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ScriptServiceListVersionsRequest,
            $0.ScriptServiceListVersionsResponse>(
        'ListVersions',
        listVersions_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ScriptServiceListVersionsRequest.fromBuffer(value),
        ($0.ScriptServiceListVersionsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ScriptServiceRestoreVersionRequest,
            $0.ScriptServiceRestoreVersionResponse>(
        'RestoreVersion',
        restoreVersion_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ScriptServiceRestoreVersionRequest.fromBuffer(value),
        ($0.ScriptServiceRestoreVersionResponse value) =>
            value.writeToBuffer()));
  }

  $async.Future<$0.ScriptServiceCreateResponse> create_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ScriptServiceCreateRequest> $request) async {
    return create($call, await $request);
  }

  $async.Future<$0.ScriptServiceCreateResponse> create(
      $grpc.ServiceCall call, $0.ScriptServiceCreateRequest request);

  $async.Future<$0.ScriptServiceGetResponse> get_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ScriptServiceGetRequest> $request) async {
    return get($call, await $request);
  }

  $async.Future<$0.ScriptServiceGetResponse> get(
      $grpc.ServiceCall call, $0.ScriptServiceGetRequest request);

  $async.Future<$0.ScriptServiceUpdateResponse> update_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ScriptServiceUpdateRequest> $request) async {
    return update($call, await $request);
  }

  $async.Future<$0.ScriptServiceUpdateResponse> update(
      $grpc.ServiceCall call, $0.ScriptServiceUpdateRequest request);

  $async.Future<$0.ScriptServiceSubmitApprovalResponse> submitApproval_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ScriptServiceSubmitApprovalRequest> $request) async {
    return submitApproval($call, await $request);
  }

  $async.Future<$0.ScriptServiceSubmitApprovalResponse> submitApproval(
      $grpc.ServiceCall call, $0.ScriptServiceSubmitApprovalRequest request);

  $async.Future<$0.ScriptServiceApproveResponse> approve_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ScriptServiceApproveRequest> $request) async {
    return approve($call, await $request);
  }

  $async.Future<$0.ScriptServiceApproveResponse> approve(
      $grpc.ServiceCall call, $0.ScriptServiceApproveRequest request);

  $async.Future<$0.ScriptServiceRejectResponse> reject_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ScriptServiceRejectRequest> $request) async {
    return reject($call, await $request);
  }

  $async.Future<$0.ScriptServiceRejectResponse> reject(
      $grpc.ServiceCall call, $0.ScriptServiceRejectRequest request);

  $async.Future<$0.ScriptServiceListResponse> list_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ScriptServiceListRequest> $request) async {
    return list($call, await $request);
  }

  $async.Future<$0.ScriptServiceListResponse> list(
      $grpc.ServiceCall call, $0.ScriptServiceListRequest request);

  $async.Future<$0.ScriptServiceDeleteResponse> delete_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ScriptServiceDeleteRequest> $request) async {
    return delete($call, await $request);
  }

  $async.Future<$0.ScriptServiceDeleteResponse> delete(
      $grpc.ServiceCall call, $0.ScriptServiceDeleteRequest request);

  $async.Future<$0.ScriptServiceDuplicateResponse> duplicate_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ScriptServiceDuplicateRequest> $request) async {
    return duplicate($call, await $request);
  }

  $async.Future<$0.ScriptServiceDuplicateResponse> duplicate(
      $grpc.ServiceCall call, $0.ScriptServiceDuplicateRequest request);

  $async.Future<$0.ScriptServiceGetStatsResponse> getStats_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ScriptServiceGetStatsRequest> $request) async {
    return getStats($call, await $request);
  }

  $async.Future<$0.ScriptServiceGetStatsResponse> getStats(
      $grpc.ServiceCall call, $0.ScriptServiceGetStatsRequest request);

  $async.Future<$0.ScriptServiceGetBriefResponse> getBrief_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ScriptServiceGetBriefRequest> $request) async {
    return getBrief($call, await $request);
  }

  $async.Future<$0.ScriptServiceGetBriefResponse> getBrief(
      $grpc.ServiceCall call, $0.ScriptServiceGetBriefRequest request);

  $async.Future<$0.ScriptServiceGetReviewResponse> getReview_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ScriptServiceGetReviewRequest> $request) async {
    return getReview($call, await $request);
  }

  $async.Future<$0.ScriptServiceGetReviewResponse> getReview(
      $grpc.ServiceCall call, $0.ScriptServiceGetReviewRequest request);

  $async.Future<$0.ScriptServiceSubmitReviewResponse> submitReview_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ScriptServiceSubmitReviewRequest> $request) async {
    return submitReview($call, await $request);
  }

  $async.Future<$0.ScriptServiceSubmitReviewResponse> submitReview(
      $grpc.ServiceCall call, $0.ScriptServiceSubmitReviewRequest request);

  $async.Future<$0.ScriptServiceRequestChangesResponse> requestChanges_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ScriptServiceRequestChangesRequest> $request) async {
    return requestChanges($call, await $request);
  }

  $async.Future<$0.ScriptServiceRequestChangesResponse> requestChanges(
      $grpc.ServiceCall call, $0.ScriptServiceRequestChangesRequest request);

  $async.Future<$0.ScriptServiceAddSectionResponse> addSection_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ScriptServiceAddSectionRequest> $request) async {
    return addSection($call, await $request);
  }

  $async.Future<$0.ScriptServiceAddSectionResponse> addSection(
      $grpc.ServiceCall call, $0.ScriptServiceAddSectionRequest request);

  $async.Future<$0.ScriptServiceUpdateSectionResponse> updateSection_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ScriptServiceUpdateSectionRequest> $request) async {
    return updateSection($call, await $request);
  }

  $async.Future<$0.ScriptServiceUpdateSectionResponse> updateSection(
      $grpc.ServiceCall call, $0.ScriptServiceUpdateSectionRequest request);

  $async.Future<$0.ScriptServiceDeleteSectionResponse> deleteSection_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ScriptServiceDeleteSectionRequest> $request) async {
    return deleteSection($call, await $request);
  }

  $async.Future<$0.ScriptServiceDeleteSectionResponse> deleteSection(
      $grpc.ServiceCall call, $0.ScriptServiceDeleteSectionRequest request);

  $async.Future<$0.ScriptServiceReorderSectionsResponse> reorderSections_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ScriptServiceReorderSectionsRequest> $request) async {
    return reorderSections($call, await $request);
  }

  $async.Future<$0.ScriptServiceReorderSectionsResponse> reorderSections(
      $grpc.ServiceCall call, $0.ScriptServiceReorderSectionsRequest request);

  $async.Future<$0.ScriptServiceAddCommentResponse> addComment_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ScriptServiceAddCommentRequest> $request) async {
    return addComment($call, await $request);
  }

  $async.Future<$0.ScriptServiceAddCommentResponse> addComment(
      $grpc.ServiceCall call, $0.ScriptServiceAddCommentRequest request);

  $async.Future<$0.ScriptServiceResolveCommentResponse> resolveComment_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ScriptServiceResolveCommentRequest> $request) async {
    return resolveComment($call, await $request);
  }

  $async.Future<$0.ScriptServiceResolveCommentResponse> resolveComment(
      $grpc.ServiceCall call, $0.ScriptServiceResolveCommentRequest request);

  $async.Future<$0.ScriptServiceGetVersionResponse> getVersion_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ScriptServiceGetVersionRequest> $request) async {
    return getVersion($call, await $request);
  }

  $async.Future<$0.ScriptServiceGetVersionResponse> getVersion(
      $grpc.ServiceCall call, $0.ScriptServiceGetVersionRequest request);

  $async.Future<$0.ScriptServiceListVersionsResponse> listVersions_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ScriptServiceListVersionsRequest> $request) async {
    return listVersions($call, await $request);
  }

  $async.Future<$0.ScriptServiceListVersionsResponse> listVersions(
      $grpc.ServiceCall call, $0.ScriptServiceListVersionsRequest request);

  $async.Future<$0.ScriptServiceRestoreVersionResponse> restoreVersion_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ScriptServiceRestoreVersionRequest> $request) async {
    return restoreVersion($call, await $request);
  }

  $async.Future<$0.ScriptServiceRestoreVersionResponse> restoreVersion(
      $grpc.ServiceCall call, $0.ScriptServiceRestoreVersionRequest request);
}
