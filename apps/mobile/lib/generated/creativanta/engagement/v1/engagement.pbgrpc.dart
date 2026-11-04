// This is a generated file - do not edit.
//
// Generated from creativanta/engagement/v1/engagement.proto.

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

import 'engagement.pb.dart' as $0;

export 'engagement.pb.dart';

/// ThreadService manages engagement threads and message lifecycle (M12).
@$pb.GrpcServiceName('creativanta.engagement.v1.ThreadService')
class ThreadServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ThreadServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.ThreadServiceListResponse> list(
    $0.ThreadServiceListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$list, request, options: options);
  }

  $grpc.ResponseFuture<$0.ThreadServiceGetResponse> get(
    $0.ThreadServiceGetRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$get, request, options: options);
  }

  $grpc.ResponseFuture<$0.ThreadServiceTriageResponse> triage(
    $0.ThreadServiceTriageRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$triage, request, options: options);
  }

  $grpc.ResponseFuture<$0.ThreadServiceAssignResponse> assign(
    $0.ThreadServiceAssignRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$assign, request, options: options);
  }

  $grpc.ResponseFuture<$0.ThreadServiceReplyResponse> reply(
    $0.ThreadServiceReplyRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$reply, request, options: options);
  }

  $grpc.ResponseFuture<$0.ThreadServiceResolveResponse> resolve(
    $0.ThreadServiceResolveRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$resolve, request, options: options);
  }

  $grpc.ResponseFuture<$0.ThreadServiceBulkTriageResponse> bulkTriage(
    $0.ThreadServiceBulkTriageRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$bulkTriage, request, options: options);
  }

  $grpc.ResponseFuture<$0.ThreadServiceGetMessagesResponse> getMessages(
    $0.ThreadServiceGetMessagesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getMessages, request, options: options);
  }

  $grpc.ResponseFuture<$0.ThreadServiceGetUnreadCountResponse> getUnreadCount(
    $0.ThreadServiceGetUnreadCountRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getUnreadCount, request, options: options);
  }

  $grpc.ResponseFuture<$0.ThreadServiceMarkReadResponse> markRead(
    $0.ThreadServiceMarkReadRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$markRead, request, options: options);
  }

  $grpc.ResponseFuture<$0.ThreadServiceUpdateResponse> update(
    $0.ThreadServiceUpdateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$update, request, options: options);
  }

  $grpc.ResponseFuture<$0.ThreadServiceAddTagResponse> addTag(
    $0.ThreadServiceAddTagRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$addTag, request, options: options);
  }

  $grpc.ResponseFuture<$0.ThreadServiceMuteResponse> mute(
    $0.ThreadServiceMuteRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$mute, request, options: options);
  }

  $grpc.ResponseFuture<$0.ThreadServiceSnoozeResponse> snooze(
    $0.ThreadServiceSnoozeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$snooze, request, options: options);
  }

  $grpc.ResponseFuture<$0.ThreadServiceListMobileResponse> listMobile(
    $0.ThreadServiceListMobileRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listMobile, request, options: options);
  }

  $grpc.ResponseFuture<$0.ThreadServiceHandleGhostMessageResponse>
      handleGhostMessage(
    $0.ThreadServiceHandleGhostMessageRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$handleGhostMessage, request, options: options);
  }

  $grpc.ResponseFuture<$0.ThreadServiceResetAutoReplyLoopResponse>
      resetAutoReplyLoop(
    $0.ThreadServiceResetAutoReplyLoopRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$resetAutoReplyLoop, request, options: options);
  }

  // method descriptors

  static final _$list = $grpc.ClientMethod<$0.ThreadServiceListRequest,
          $0.ThreadServiceListResponse>(
      '/creativanta.engagement.v1.ThreadService/List',
      ($0.ThreadServiceListRequest value) => value.writeToBuffer(),
      $0.ThreadServiceListResponse.fromBuffer);
  static final _$get = $grpc.ClientMethod<$0.ThreadServiceGetRequest,
          $0.ThreadServiceGetResponse>(
      '/creativanta.engagement.v1.ThreadService/Get',
      ($0.ThreadServiceGetRequest value) => value.writeToBuffer(),
      $0.ThreadServiceGetResponse.fromBuffer);
  static final _$triage = $grpc.ClientMethod<$0.ThreadServiceTriageRequest,
          $0.ThreadServiceTriageResponse>(
      '/creativanta.engagement.v1.ThreadService/Triage',
      ($0.ThreadServiceTriageRequest value) => value.writeToBuffer(),
      $0.ThreadServiceTriageResponse.fromBuffer);
  static final _$assign = $grpc.ClientMethod<$0.ThreadServiceAssignRequest,
          $0.ThreadServiceAssignResponse>(
      '/creativanta.engagement.v1.ThreadService/Assign',
      ($0.ThreadServiceAssignRequest value) => value.writeToBuffer(),
      $0.ThreadServiceAssignResponse.fromBuffer);
  static final _$reply = $grpc.ClientMethod<$0.ThreadServiceReplyRequest,
          $0.ThreadServiceReplyResponse>(
      '/creativanta.engagement.v1.ThreadService/Reply',
      ($0.ThreadServiceReplyRequest value) => value.writeToBuffer(),
      $0.ThreadServiceReplyResponse.fromBuffer);
  static final _$resolve = $grpc.ClientMethod<$0.ThreadServiceResolveRequest,
          $0.ThreadServiceResolveResponse>(
      '/creativanta.engagement.v1.ThreadService/Resolve',
      ($0.ThreadServiceResolveRequest value) => value.writeToBuffer(),
      $0.ThreadServiceResolveResponse.fromBuffer);
  static final _$bulkTriage = $grpc.ClientMethod<
          $0.ThreadServiceBulkTriageRequest,
          $0.ThreadServiceBulkTriageResponse>(
      '/creativanta.engagement.v1.ThreadService/BulkTriage',
      ($0.ThreadServiceBulkTriageRequest value) => value.writeToBuffer(),
      $0.ThreadServiceBulkTriageResponse.fromBuffer);
  static final _$getMessages = $grpc.ClientMethod<
          $0.ThreadServiceGetMessagesRequest,
          $0.ThreadServiceGetMessagesResponse>(
      '/creativanta.engagement.v1.ThreadService/GetMessages',
      ($0.ThreadServiceGetMessagesRequest value) => value.writeToBuffer(),
      $0.ThreadServiceGetMessagesResponse.fromBuffer);
  static final _$getUnreadCount = $grpc.ClientMethod<
          $0.ThreadServiceGetUnreadCountRequest,
          $0.ThreadServiceGetUnreadCountResponse>(
      '/creativanta.engagement.v1.ThreadService/GetUnreadCount',
      ($0.ThreadServiceGetUnreadCountRequest value) => value.writeToBuffer(),
      $0.ThreadServiceGetUnreadCountResponse.fromBuffer);
  static final _$markRead = $grpc.ClientMethod<$0.ThreadServiceMarkReadRequest,
          $0.ThreadServiceMarkReadResponse>(
      '/creativanta.engagement.v1.ThreadService/MarkRead',
      ($0.ThreadServiceMarkReadRequest value) => value.writeToBuffer(),
      $0.ThreadServiceMarkReadResponse.fromBuffer);
  static final _$update = $grpc.ClientMethod<$0.ThreadServiceUpdateRequest,
          $0.ThreadServiceUpdateResponse>(
      '/creativanta.engagement.v1.ThreadService/Update',
      ($0.ThreadServiceUpdateRequest value) => value.writeToBuffer(),
      $0.ThreadServiceUpdateResponse.fromBuffer);
  static final _$addTag = $grpc.ClientMethod<$0.ThreadServiceAddTagRequest,
          $0.ThreadServiceAddTagResponse>(
      '/creativanta.engagement.v1.ThreadService/AddTag',
      ($0.ThreadServiceAddTagRequest value) => value.writeToBuffer(),
      $0.ThreadServiceAddTagResponse.fromBuffer);
  static final _$mute = $grpc.ClientMethod<$0.ThreadServiceMuteRequest,
          $0.ThreadServiceMuteResponse>(
      '/creativanta.engagement.v1.ThreadService/Mute',
      ($0.ThreadServiceMuteRequest value) => value.writeToBuffer(),
      $0.ThreadServiceMuteResponse.fromBuffer);
  static final _$snooze = $grpc.ClientMethod<$0.ThreadServiceSnoozeRequest,
          $0.ThreadServiceSnoozeResponse>(
      '/creativanta.engagement.v1.ThreadService/Snooze',
      ($0.ThreadServiceSnoozeRequest value) => value.writeToBuffer(),
      $0.ThreadServiceSnoozeResponse.fromBuffer);
  static final _$listMobile = $grpc.ClientMethod<
          $0.ThreadServiceListMobileRequest,
          $0.ThreadServiceListMobileResponse>(
      '/creativanta.engagement.v1.ThreadService/ListMobile',
      ($0.ThreadServiceListMobileRequest value) => value.writeToBuffer(),
      $0.ThreadServiceListMobileResponse.fromBuffer);
  static final _$handleGhostMessage = $grpc.ClientMethod<
          $0.ThreadServiceHandleGhostMessageRequest,
          $0.ThreadServiceHandleGhostMessageResponse>(
      '/creativanta.engagement.v1.ThreadService/HandleGhostMessage',
      ($0.ThreadServiceHandleGhostMessageRequest value) =>
          value.writeToBuffer(),
      $0.ThreadServiceHandleGhostMessageResponse.fromBuffer);
  static final _$resetAutoReplyLoop = $grpc.ClientMethod<
          $0.ThreadServiceResetAutoReplyLoopRequest,
          $0.ThreadServiceResetAutoReplyLoopResponse>(
      '/creativanta.engagement.v1.ThreadService/ResetAutoReplyLoop',
      ($0.ThreadServiceResetAutoReplyLoopRequest value) =>
          value.writeToBuffer(),
      $0.ThreadServiceResetAutoReplyLoopResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.engagement.v1.ThreadService')
abstract class ThreadServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.engagement.v1.ThreadService';

  ThreadServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ThreadServiceListRequest,
            $0.ThreadServiceListResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ThreadServiceListRequest.fromBuffer(value),
        ($0.ThreadServiceListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ThreadServiceGetRequest,
            $0.ThreadServiceGetResponse>(
        'Get',
        get_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ThreadServiceGetRequest.fromBuffer(value),
        ($0.ThreadServiceGetResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ThreadServiceTriageRequest,
            $0.ThreadServiceTriageResponse>(
        'Triage',
        triage_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ThreadServiceTriageRequest.fromBuffer(value),
        ($0.ThreadServiceTriageResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ThreadServiceAssignRequest,
            $0.ThreadServiceAssignResponse>(
        'Assign',
        assign_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ThreadServiceAssignRequest.fromBuffer(value),
        ($0.ThreadServiceAssignResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ThreadServiceReplyRequest,
            $0.ThreadServiceReplyResponse>(
        'Reply',
        reply_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ThreadServiceReplyRequest.fromBuffer(value),
        ($0.ThreadServiceReplyResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ThreadServiceResolveRequest,
            $0.ThreadServiceResolveResponse>(
        'Resolve',
        resolve_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ThreadServiceResolveRequest.fromBuffer(value),
        ($0.ThreadServiceResolveResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ThreadServiceBulkTriageRequest,
            $0.ThreadServiceBulkTriageResponse>(
        'BulkTriage',
        bulkTriage_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ThreadServiceBulkTriageRequest.fromBuffer(value),
        ($0.ThreadServiceBulkTriageResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ThreadServiceGetMessagesRequest,
            $0.ThreadServiceGetMessagesResponse>(
        'GetMessages',
        getMessages_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ThreadServiceGetMessagesRequest.fromBuffer(value),
        ($0.ThreadServiceGetMessagesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ThreadServiceGetUnreadCountRequest,
            $0.ThreadServiceGetUnreadCountResponse>(
        'GetUnreadCount',
        getUnreadCount_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ThreadServiceGetUnreadCountRequest.fromBuffer(value),
        ($0.ThreadServiceGetUnreadCountResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ThreadServiceMarkReadRequest,
            $0.ThreadServiceMarkReadResponse>(
        'MarkRead',
        markRead_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ThreadServiceMarkReadRequest.fromBuffer(value),
        ($0.ThreadServiceMarkReadResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ThreadServiceUpdateRequest,
            $0.ThreadServiceUpdateResponse>(
        'Update',
        update_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ThreadServiceUpdateRequest.fromBuffer(value),
        ($0.ThreadServiceUpdateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ThreadServiceAddTagRequest,
            $0.ThreadServiceAddTagResponse>(
        'AddTag',
        addTag_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ThreadServiceAddTagRequest.fromBuffer(value),
        ($0.ThreadServiceAddTagResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ThreadServiceMuteRequest,
            $0.ThreadServiceMuteResponse>(
        'Mute',
        mute_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ThreadServiceMuteRequest.fromBuffer(value),
        ($0.ThreadServiceMuteResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ThreadServiceSnoozeRequest,
            $0.ThreadServiceSnoozeResponse>(
        'Snooze',
        snooze_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ThreadServiceSnoozeRequest.fromBuffer(value),
        ($0.ThreadServiceSnoozeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ThreadServiceListMobileRequest,
            $0.ThreadServiceListMobileResponse>(
        'ListMobile',
        listMobile_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ThreadServiceListMobileRequest.fromBuffer(value),
        ($0.ThreadServiceListMobileResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ThreadServiceHandleGhostMessageRequest,
            $0.ThreadServiceHandleGhostMessageResponse>(
        'HandleGhostMessage',
        handleGhostMessage_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ThreadServiceHandleGhostMessageRequest.fromBuffer(value),
        ($0.ThreadServiceHandleGhostMessageResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ThreadServiceResetAutoReplyLoopRequest,
            $0.ThreadServiceResetAutoReplyLoopResponse>(
        'ResetAutoReplyLoop',
        resetAutoReplyLoop_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ThreadServiceResetAutoReplyLoopRequest.fromBuffer(value),
        ($0.ThreadServiceResetAutoReplyLoopResponse value) =>
            value.writeToBuffer()));
  }

  $async.Future<$0.ThreadServiceListResponse> list_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ThreadServiceListRequest> $request) async {
    return list($call, await $request);
  }

  $async.Future<$0.ThreadServiceListResponse> list(
      $grpc.ServiceCall call, $0.ThreadServiceListRequest request);

  $async.Future<$0.ThreadServiceGetResponse> get_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ThreadServiceGetRequest> $request) async {
    return get($call, await $request);
  }

  $async.Future<$0.ThreadServiceGetResponse> get(
      $grpc.ServiceCall call, $0.ThreadServiceGetRequest request);

  $async.Future<$0.ThreadServiceTriageResponse> triage_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ThreadServiceTriageRequest> $request) async {
    return triage($call, await $request);
  }

  $async.Future<$0.ThreadServiceTriageResponse> triage(
      $grpc.ServiceCall call, $0.ThreadServiceTriageRequest request);

  $async.Future<$0.ThreadServiceAssignResponse> assign_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ThreadServiceAssignRequest> $request) async {
    return assign($call, await $request);
  }

  $async.Future<$0.ThreadServiceAssignResponse> assign(
      $grpc.ServiceCall call, $0.ThreadServiceAssignRequest request);

  $async.Future<$0.ThreadServiceReplyResponse> reply_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ThreadServiceReplyRequest> $request) async {
    return reply($call, await $request);
  }

  $async.Future<$0.ThreadServiceReplyResponse> reply(
      $grpc.ServiceCall call, $0.ThreadServiceReplyRequest request);

  $async.Future<$0.ThreadServiceResolveResponse> resolve_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ThreadServiceResolveRequest> $request) async {
    return resolve($call, await $request);
  }

  $async.Future<$0.ThreadServiceResolveResponse> resolve(
      $grpc.ServiceCall call, $0.ThreadServiceResolveRequest request);

  $async.Future<$0.ThreadServiceBulkTriageResponse> bulkTriage_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ThreadServiceBulkTriageRequest> $request) async {
    return bulkTriage($call, await $request);
  }

  $async.Future<$0.ThreadServiceBulkTriageResponse> bulkTriage(
      $grpc.ServiceCall call, $0.ThreadServiceBulkTriageRequest request);

  $async.Future<$0.ThreadServiceGetMessagesResponse> getMessages_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ThreadServiceGetMessagesRequest> $request) async {
    return getMessages($call, await $request);
  }

  $async.Future<$0.ThreadServiceGetMessagesResponse> getMessages(
      $grpc.ServiceCall call, $0.ThreadServiceGetMessagesRequest request);

  $async.Future<$0.ThreadServiceGetUnreadCountResponse> getUnreadCount_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ThreadServiceGetUnreadCountRequest> $request) async {
    return getUnreadCount($call, await $request);
  }

  $async.Future<$0.ThreadServiceGetUnreadCountResponse> getUnreadCount(
      $grpc.ServiceCall call, $0.ThreadServiceGetUnreadCountRequest request);

  $async.Future<$0.ThreadServiceMarkReadResponse> markRead_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ThreadServiceMarkReadRequest> $request) async {
    return markRead($call, await $request);
  }

  $async.Future<$0.ThreadServiceMarkReadResponse> markRead(
      $grpc.ServiceCall call, $0.ThreadServiceMarkReadRequest request);

  $async.Future<$0.ThreadServiceUpdateResponse> update_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ThreadServiceUpdateRequest> $request) async {
    return update($call, await $request);
  }

  $async.Future<$0.ThreadServiceUpdateResponse> update(
      $grpc.ServiceCall call, $0.ThreadServiceUpdateRequest request);

  $async.Future<$0.ThreadServiceAddTagResponse> addTag_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ThreadServiceAddTagRequest> $request) async {
    return addTag($call, await $request);
  }

  $async.Future<$0.ThreadServiceAddTagResponse> addTag(
      $grpc.ServiceCall call, $0.ThreadServiceAddTagRequest request);

  $async.Future<$0.ThreadServiceMuteResponse> mute_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ThreadServiceMuteRequest> $request) async {
    return mute($call, await $request);
  }

  $async.Future<$0.ThreadServiceMuteResponse> mute(
      $grpc.ServiceCall call, $0.ThreadServiceMuteRequest request);

  $async.Future<$0.ThreadServiceSnoozeResponse> snooze_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ThreadServiceSnoozeRequest> $request) async {
    return snooze($call, await $request);
  }

  $async.Future<$0.ThreadServiceSnoozeResponse> snooze(
      $grpc.ServiceCall call, $0.ThreadServiceSnoozeRequest request);

  $async.Future<$0.ThreadServiceListMobileResponse> listMobile_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ThreadServiceListMobileRequest> $request) async {
    return listMobile($call, await $request);
  }

  $async.Future<$0.ThreadServiceListMobileResponse> listMobile(
      $grpc.ServiceCall call, $0.ThreadServiceListMobileRequest request);

  $async.Future<$0.ThreadServiceHandleGhostMessageResponse>
      handleGhostMessage_Pre(
          $grpc.ServiceCall $call,
          $async.Future<$0.ThreadServiceHandleGhostMessageRequest>
              $request) async {
    return handleGhostMessage($call, await $request);
  }

  $async.Future<$0.ThreadServiceHandleGhostMessageResponse> handleGhostMessage(
      $grpc.ServiceCall call,
      $0.ThreadServiceHandleGhostMessageRequest request);

  $async.Future<$0.ThreadServiceResetAutoReplyLoopResponse>
      resetAutoReplyLoop_Pre(
          $grpc.ServiceCall $call,
          $async.Future<$0.ThreadServiceResetAutoReplyLoopRequest>
              $request) async {
    return resetAutoReplyLoop($call, await $request);
  }

  $async.Future<$0.ThreadServiceResetAutoReplyLoopResponse> resetAutoReplyLoop(
      $grpc.ServiceCall call,
      $0.ThreadServiceResetAutoReplyLoopRequest request);
}

/// EntityService manages contact identities and relationship CRM (M12).
@$pb.GrpcServiceName('creativanta.engagement.v1.EntityService')
class EntityServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  EntityServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.EntityServiceListResponse> list(
    $0.EntityServiceListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$list, request, options: options);
  }

  $grpc.ResponseFuture<$0.EntityServiceGetResponse> get(
    $0.EntityServiceGetRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$get, request, options: options);
  }

  $grpc.ResponseFuture<$0.EntityServiceCreateResponse> create(
    $0.EntityServiceCreateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$create, request, options: options);
  }

  $grpc.ResponseFuture<$0.EntityServiceMergeResponse> merge(
    $0.EntityServiceMergeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$merge, request, options: options);
  }

  $grpc.ResponseFuture<$0.EntityServiceAddNoteResponse> addNote(
    $0.EntityServiceAddNoteRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$addNote, request, options: options);
  }

  $grpc.ResponseFuture<$0.EntityServiceAddTagResponse> addTag(
    $0.EntityServiceAddTagRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$addTag, request, options: options);
  }

  // method descriptors

  static final _$list = $grpc.ClientMethod<$0.EntityServiceListRequest,
          $0.EntityServiceListResponse>(
      '/creativanta.engagement.v1.EntityService/List',
      ($0.EntityServiceListRequest value) => value.writeToBuffer(),
      $0.EntityServiceListResponse.fromBuffer);
  static final _$get = $grpc.ClientMethod<$0.EntityServiceGetRequest,
          $0.EntityServiceGetResponse>(
      '/creativanta.engagement.v1.EntityService/Get',
      ($0.EntityServiceGetRequest value) => value.writeToBuffer(),
      $0.EntityServiceGetResponse.fromBuffer);
  static final _$create = $grpc.ClientMethod<$0.EntityServiceCreateRequest,
          $0.EntityServiceCreateResponse>(
      '/creativanta.engagement.v1.EntityService/Create',
      ($0.EntityServiceCreateRequest value) => value.writeToBuffer(),
      $0.EntityServiceCreateResponse.fromBuffer);
  static final _$merge = $grpc.ClientMethod<$0.EntityServiceMergeRequest,
          $0.EntityServiceMergeResponse>(
      '/creativanta.engagement.v1.EntityService/Merge',
      ($0.EntityServiceMergeRequest value) => value.writeToBuffer(),
      $0.EntityServiceMergeResponse.fromBuffer);
  static final _$addNote = $grpc.ClientMethod<$0.EntityServiceAddNoteRequest,
          $0.EntityServiceAddNoteResponse>(
      '/creativanta.engagement.v1.EntityService/AddNote',
      ($0.EntityServiceAddNoteRequest value) => value.writeToBuffer(),
      $0.EntityServiceAddNoteResponse.fromBuffer);
  static final _$addTag = $grpc.ClientMethod<$0.EntityServiceAddTagRequest,
          $0.EntityServiceAddTagResponse>(
      '/creativanta.engagement.v1.EntityService/AddTag',
      ($0.EntityServiceAddTagRequest value) => value.writeToBuffer(),
      $0.EntityServiceAddTagResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.engagement.v1.EntityService')
abstract class EntityServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.engagement.v1.EntityService';

  EntityServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.EntityServiceListRequest,
            $0.EntityServiceListResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.EntityServiceListRequest.fromBuffer(value),
        ($0.EntityServiceListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.EntityServiceGetRequest,
            $0.EntityServiceGetResponse>(
        'Get',
        get_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.EntityServiceGetRequest.fromBuffer(value),
        ($0.EntityServiceGetResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.EntityServiceCreateRequest,
            $0.EntityServiceCreateResponse>(
        'Create',
        create_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.EntityServiceCreateRequest.fromBuffer(value),
        ($0.EntityServiceCreateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.EntityServiceMergeRequest,
            $0.EntityServiceMergeResponse>(
        'Merge',
        merge_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.EntityServiceMergeRequest.fromBuffer(value),
        ($0.EntityServiceMergeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.EntityServiceAddNoteRequest,
            $0.EntityServiceAddNoteResponse>(
        'AddNote',
        addNote_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.EntityServiceAddNoteRequest.fromBuffer(value),
        ($0.EntityServiceAddNoteResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.EntityServiceAddTagRequest,
            $0.EntityServiceAddTagResponse>(
        'AddTag',
        addTag_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.EntityServiceAddTagRequest.fromBuffer(value),
        ($0.EntityServiceAddTagResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.EntityServiceListResponse> list_Pre($grpc.ServiceCall $call,
      $async.Future<$0.EntityServiceListRequest> $request) async {
    return list($call, await $request);
  }

  $async.Future<$0.EntityServiceListResponse> list(
      $grpc.ServiceCall call, $0.EntityServiceListRequest request);

  $async.Future<$0.EntityServiceGetResponse> get_Pre($grpc.ServiceCall $call,
      $async.Future<$0.EntityServiceGetRequest> $request) async {
    return get($call, await $request);
  }

  $async.Future<$0.EntityServiceGetResponse> get(
      $grpc.ServiceCall call, $0.EntityServiceGetRequest request);

  $async.Future<$0.EntityServiceCreateResponse> create_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.EntityServiceCreateRequest> $request) async {
    return create($call, await $request);
  }

  $async.Future<$0.EntityServiceCreateResponse> create(
      $grpc.ServiceCall call, $0.EntityServiceCreateRequest request);

  $async.Future<$0.EntityServiceMergeResponse> merge_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.EntityServiceMergeRequest> $request) async {
    return merge($call, await $request);
  }

  $async.Future<$0.EntityServiceMergeResponse> merge(
      $grpc.ServiceCall call, $0.EntityServiceMergeRequest request);

  $async.Future<$0.EntityServiceAddNoteResponse> addNote_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.EntityServiceAddNoteRequest> $request) async {
    return addNote($call, await $request);
  }

  $async.Future<$0.EntityServiceAddNoteResponse> addNote(
      $grpc.ServiceCall call, $0.EntityServiceAddNoteRequest request);

  $async.Future<$0.EntityServiceAddTagResponse> addTag_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.EntityServiceAddTagRequest> $request) async {
    return addTag($call, await $request);
  }

  $async.Future<$0.EntityServiceAddTagResponse> addTag(
      $grpc.ServiceCall call, $0.EntityServiceAddTagRequest request);
}

/// SuggestionService provides AI reply and commercial action recommendations (M12).
@$pb.GrpcServiceName('creativanta.engagement.v1.SuggestionService')
class SuggestionServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  SuggestionServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.SuggestionServiceGetReplyResponse> getReply(
    $0.SuggestionServiceGetReplyRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getReply, request, options: options);
  }

  $grpc.ResponseFuture<$0.SuggestionServiceGetActionsResponse> getActions(
    $0.SuggestionServiceGetActionsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getActions, request, options: options);
  }

  // method descriptors

  static final _$getReply = $grpc.ClientMethod<
          $0.SuggestionServiceGetReplyRequest,
          $0.SuggestionServiceGetReplyResponse>(
      '/creativanta.engagement.v1.SuggestionService/GetReply',
      ($0.SuggestionServiceGetReplyRequest value) => value.writeToBuffer(),
      $0.SuggestionServiceGetReplyResponse.fromBuffer);
  static final _$getActions = $grpc.ClientMethod<
          $0.SuggestionServiceGetActionsRequest,
          $0.SuggestionServiceGetActionsResponse>(
      '/creativanta.engagement.v1.SuggestionService/GetActions',
      ($0.SuggestionServiceGetActionsRequest value) => value.writeToBuffer(),
      $0.SuggestionServiceGetActionsResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.engagement.v1.SuggestionService')
abstract class SuggestionServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.engagement.v1.SuggestionService';

  SuggestionServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.SuggestionServiceGetReplyRequest,
            $0.SuggestionServiceGetReplyResponse>(
        'GetReply',
        getReply_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SuggestionServiceGetReplyRequest.fromBuffer(value),
        ($0.SuggestionServiceGetReplyResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SuggestionServiceGetActionsRequest,
            $0.SuggestionServiceGetActionsResponse>(
        'GetActions',
        getActions_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SuggestionServiceGetActionsRequest.fromBuffer(value),
        ($0.SuggestionServiceGetActionsResponse value) =>
            value.writeToBuffer()));
  }

  $async.Future<$0.SuggestionServiceGetReplyResponse> getReply_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SuggestionServiceGetReplyRequest> $request) async {
    return getReply($call, await $request);
  }

  $async.Future<$0.SuggestionServiceGetReplyResponse> getReply(
      $grpc.ServiceCall call, $0.SuggestionServiceGetReplyRequest request);

  $async.Future<$0.SuggestionServiceGetActionsResponse> getActions_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SuggestionServiceGetActionsRequest> $request) async {
    return getActions($call, await $request);
  }

  $async.Future<$0.SuggestionServiceGetActionsResponse> getActions(
      $grpc.ServiceCall call, $0.SuggestionServiceGetActionsRequest request);
}

/// FollowUpService tracks task assignments created from inbox threads (M12).
@$pb.GrpcServiceName('creativanta.engagement.v1.FollowUpService')
class FollowUpServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  FollowUpServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.FollowUpServiceCreateResponse> create(
    $0.FollowUpServiceCreateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$create, request, options: options);
  }

  $grpc.ResponseFuture<$0.FollowUpServiceListResponse> list(
    $0.FollowUpServiceListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$list, request, options: options);
  }

  $grpc.ResponseFuture<$0.FollowUpServiceUpdateResponse> update(
    $0.FollowUpServiceUpdateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$update, request, options: options);
  }

  $grpc.ResponseFuture<$0.FollowUpServiceCompleteResponse> complete(
    $0.FollowUpServiceCompleteRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$complete, request, options: options);
  }

  $grpc.ResponseFuture<$0.FollowUpServiceRescheduleResponse> reschedule(
    $0.FollowUpServiceRescheduleRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$reschedule, request, options: options);
  }

  // method descriptors

  static final _$create = $grpc.ClientMethod<$0.FollowUpServiceCreateRequest,
          $0.FollowUpServiceCreateResponse>(
      '/creativanta.engagement.v1.FollowUpService/Create',
      ($0.FollowUpServiceCreateRequest value) => value.writeToBuffer(),
      $0.FollowUpServiceCreateResponse.fromBuffer);
  static final _$list = $grpc.ClientMethod<$0.FollowUpServiceListRequest,
          $0.FollowUpServiceListResponse>(
      '/creativanta.engagement.v1.FollowUpService/List',
      ($0.FollowUpServiceListRequest value) => value.writeToBuffer(),
      $0.FollowUpServiceListResponse.fromBuffer);
  static final _$update = $grpc.ClientMethod<$0.FollowUpServiceUpdateRequest,
          $0.FollowUpServiceUpdateResponse>(
      '/creativanta.engagement.v1.FollowUpService/Update',
      ($0.FollowUpServiceUpdateRequest value) => value.writeToBuffer(),
      $0.FollowUpServiceUpdateResponse.fromBuffer);
  static final _$complete = $grpc.ClientMethod<
          $0.FollowUpServiceCompleteRequest,
          $0.FollowUpServiceCompleteResponse>(
      '/creativanta.engagement.v1.FollowUpService/Complete',
      ($0.FollowUpServiceCompleteRequest value) => value.writeToBuffer(),
      $0.FollowUpServiceCompleteResponse.fromBuffer);
  static final _$reschedule = $grpc.ClientMethod<
          $0.FollowUpServiceRescheduleRequest,
          $0.FollowUpServiceRescheduleResponse>(
      '/creativanta.engagement.v1.FollowUpService/Reschedule',
      ($0.FollowUpServiceRescheduleRequest value) => value.writeToBuffer(),
      $0.FollowUpServiceRescheduleResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.engagement.v1.FollowUpService')
abstract class FollowUpServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.engagement.v1.FollowUpService';

  FollowUpServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.FollowUpServiceCreateRequest,
            $0.FollowUpServiceCreateResponse>(
        'Create',
        create_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.FollowUpServiceCreateRequest.fromBuffer(value),
        ($0.FollowUpServiceCreateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.FollowUpServiceListRequest,
            $0.FollowUpServiceListResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.FollowUpServiceListRequest.fromBuffer(value),
        ($0.FollowUpServiceListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.FollowUpServiceUpdateRequest,
            $0.FollowUpServiceUpdateResponse>(
        'Update',
        update_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.FollowUpServiceUpdateRequest.fromBuffer(value),
        ($0.FollowUpServiceUpdateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.FollowUpServiceCompleteRequest,
            $0.FollowUpServiceCompleteResponse>(
        'Complete',
        complete_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.FollowUpServiceCompleteRequest.fromBuffer(value),
        ($0.FollowUpServiceCompleteResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.FollowUpServiceRescheduleRequest,
            $0.FollowUpServiceRescheduleResponse>(
        'Reschedule',
        reschedule_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.FollowUpServiceRescheduleRequest.fromBuffer(value),
        ($0.FollowUpServiceRescheduleResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.FollowUpServiceCreateResponse> create_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.FollowUpServiceCreateRequest> $request) async {
    return create($call, await $request);
  }

  $async.Future<$0.FollowUpServiceCreateResponse> create(
      $grpc.ServiceCall call, $0.FollowUpServiceCreateRequest request);

  $async.Future<$0.FollowUpServiceListResponse> list_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.FollowUpServiceListRequest> $request) async {
    return list($call, await $request);
  }

  $async.Future<$0.FollowUpServiceListResponse> list(
      $grpc.ServiceCall call, $0.FollowUpServiceListRequest request);

  $async.Future<$0.FollowUpServiceUpdateResponse> update_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.FollowUpServiceUpdateRequest> $request) async {
    return update($call, await $request);
  }

  $async.Future<$0.FollowUpServiceUpdateResponse> update(
      $grpc.ServiceCall call, $0.FollowUpServiceUpdateRequest request);

  $async.Future<$0.FollowUpServiceCompleteResponse> complete_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.FollowUpServiceCompleteRequest> $request) async {
    return complete($call, await $request);
  }

  $async.Future<$0.FollowUpServiceCompleteResponse> complete(
      $grpc.ServiceCall call, $0.FollowUpServiceCompleteRequest request);

  $async.Future<$0.FollowUpServiceRescheduleResponse> reschedule_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.FollowUpServiceRescheduleRequest> $request) async {
    return reschedule($call, await $request);
  }

  $async.Future<$0.FollowUpServiceRescheduleResponse> reschedule(
      $grpc.ServiceCall call, $0.FollowUpServiceRescheduleRequest request);
}

/// EngagementProtectionService guards against viral surges, loops, and account issues.
@$pb.GrpcServiceName('creativanta.engagement.v1.EngagementProtectionService')
class EngagementProtectionServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  EngagementProtectionServiceClient(super.channel,
      {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.EngagementProtectionServiceGetThrottleStatusResponse>
      getThrottleStatus(
    $0.EngagementProtectionServiceGetThrottleStatusRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getThrottleStatus, request, options: options);
  }

  $grpc.ResponseFuture<
          $0.EngagementProtectionServiceTriggerBatchAnalysisResponse>
      triggerBatchAnalysis(
    $0.EngagementProtectionServiceTriggerBatchAnalysisRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$triggerBatchAnalysis, request, options: options);
  }

  $grpc.ResponseFuture<
          $0.EngagementProtectionServiceRepairRevokedAccountResponse>
      repairRevokedAccount(
    $0.EngagementProtectionServiceRepairRevokedAccountRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$repairRevokedAccount, request, options: options);
  }

  // method descriptors

  static final _$getThrottleStatus = $grpc.ClientMethod<
          $0.EngagementProtectionServiceGetThrottleStatusRequest,
          $0.EngagementProtectionServiceGetThrottleStatusResponse>(
      '/creativanta.engagement.v1.EngagementProtectionService/GetThrottleStatus',
      ($0.EngagementProtectionServiceGetThrottleStatusRequest value) =>
          value.writeToBuffer(),
      $0.EngagementProtectionServiceGetThrottleStatusResponse.fromBuffer);
  static final _$triggerBatchAnalysis = $grpc.ClientMethod<
          $0.EngagementProtectionServiceTriggerBatchAnalysisRequest,
          $0.EngagementProtectionServiceTriggerBatchAnalysisResponse>(
      '/creativanta.engagement.v1.EngagementProtectionService/TriggerBatchAnalysis',
      ($0.EngagementProtectionServiceTriggerBatchAnalysisRequest value) =>
          value.writeToBuffer(),
      $0.EngagementProtectionServiceTriggerBatchAnalysisResponse.fromBuffer);
  static final _$repairRevokedAccount = $grpc.ClientMethod<
          $0.EngagementProtectionServiceRepairRevokedAccountRequest,
          $0.EngagementProtectionServiceRepairRevokedAccountResponse>(
      '/creativanta.engagement.v1.EngagementProtectionService/RepairRevokedAccount',
      ($0.EngagementProtectionServiceRepairRevokedAccountRequest value) =>
          value.writeToBuffer(),
      $0.EngagementProtectionServiceRepairRevokedAccountResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.engagement.v1.EngagementProtectionService')
abstract class EngagementProtectionServiceBase extends $grpc.Service {
  $core.String get $name =>
      'creativanta.engagement.v1.EngagementProtectionService';

  EngagementProtectionServiceBase() {
    $addMethod($grpc.ServiceMethod<
            $0.EngagementProtectionServiceGetThrottleStatusRequest,
            $0.EngagementProtectionServiceGetThrottleStatusResponse>(
        'GetThrottleStatus',
        getThrottleStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.EngagementProtectionServiceGetThrottleStatusRequest.fromBuffer(
                value),
        ($0.EngagementProtectionServiceGetThrottleStatusResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<
            $0.EngagementProtectionServiceTriggerBatchAnalysisRequest,
            $0.EngagementProtectionServiceTriggerBatchAnalysisResponse>(
        'TriggerBatchAnalysis',
        triggerBatchAnalysis_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.EngagementProtectionServiceTriggerBatchAnalysisRequest
                .fromBuffer(value),
        ($0.EngagementProtectionServiceTriggerBatchAnalysisResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<
            $0.EngagementProtectionServiceRepairRevokedAccountRequest,
            $0.EngagementProtectionServiceRepairRevokedAccountResponse>(
        'RepairRevokedAccount',
        repairRevokedAccount_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.EngagementProtectionServiceRepairRevokedAccountRequest
                .fromBuffer(value),
        ($0.EngagementProtectionServiceRepairRevokedAccountResponse value) =>
            value.writeToBuffer()));
  }

  $async.Future<$0.EngagementProtectionServiceGetThrottleStatusResponse>
      getThrottleStatus_Pre(
          $grpc.ServiceCall $call,
          $async.Future<$0.EngagementProtectionServiceGetThrottleStatusRequest>
              $request) async {
    return getThrottleStatus($call, await $request);
  }

  $async.Future<$0.EngagementProtectionServiceGetThrottleStatusResponse>
      getThrottleStatus($grpc.ServiceCall call,
          $0.EngagementProtectionServiceGetThrottleStatusRequest request);

  $async.Future<$0.EngagementProtectionServiceTriggerBatchAnalysisResponse>
      triggerBatchAnalysis_Pre(
          $grpc.ServiceCall $call,
          $async
              .Future<$0.EngagementProtectionServiceTriggerBatchAnalysisRequest>
              $request) async {
    return triggerBatchAnalysis($call, await $request);
  }

  $async.Future<$0.EngagementProtectionServiceTriggerBatchAnalysisResponse>
      triggerBatchAnalysis($grpc.ServiceCall call,
          $0.EngagementProtectionServiceTriggerBatchAnalysisRequest request);

  $async.Future<$0.EngagementProtectionServiceRepairRevokedAccountResponse>
      repairRevokedAccount_Pre(
          $grpc.ServiceCall $call,
          $async
              .Future<$0.EngagementProtectionServiceRepairRevokedAccountRequest>
              $request) async {
    return repairRevokedAccount($call, await $request);
  }

  $async.Future<$0.EngagementProtectionServiceRepairRevokedAccountResponse>
      repairRevokedAccount($grpc.ServiceCall call,
          $0.EngagementProtectionServiceRepairRevokedAccountRequest request);
}
