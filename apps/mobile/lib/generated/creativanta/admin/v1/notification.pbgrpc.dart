// This is a generated file - do not edit.
//
// Generated from creativanta/admin/v1/notification.proto.

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

import 'notification.pb.dart' as $0;

export 'notification.pb.dart';

/// Scoped Notification Service (M23)
@$pb.GrpcServiceName('creativanta.admin.v1.NotificationService')
class NotificationServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  NotificationServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.ListResponse> list(
    $0.ListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$list, request, options: options);
  }

  $grpc.ResponseFuture<$0.MarkReadResponse> markRead(
    $0.MarkReadRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$markRead, request, options: options);
  }

  $grpc.ResponseFuture<$0.MarkAllReadResponse> markAllRead(
    $0.MarkAllReadRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$markAllRead, request, options: options);
  }

  $grpc.ResponseFuture<$0.DismissResponse> dismiss(
    $0.DismissRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$dismiss, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetUnreadCountResponse> getUnreadCount(
    $0.GetUnreadCountRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getUnreadCount, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetPreferencesResponse> getPreferences(
    $0.GetPreferencesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getPreferences, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdatePreferencesResponse> updatePreferences(
    $0.UpdatePreferencesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updatePreferences, request, options: options);
  }

  // method descriptors

  static final _$list = $grpc.ClientMethod<$0.ListRequest, $0.ListResponse>(
      '/creativanta.admin.v1.NotificationService/List',
      ($0.ListRequest value) => value.writeToBuffer(),
      $0.ListResponse.fromBuffer);
  static final _$markRead =
      $grpc.ClientMethod<$0.MarkReadRequest, $0.MarkReadResponse>(
          '/creativanta.admin.v1.NotificationService/MarkRead',
          ($0.MarkReadRequest value) => value.writeToBuffer(),
          $0.MarkReadResponse.fromBuffer);
  static final _$markAllRead =
      $grpc.ClientMethod<$0.MarkAllReadRequest, $0.MarkAllReadResponse>(
          '/creativanta.admin.v1.NotificationService/MarkAllRead',
          ($0.MarkAllReadRequest value) => value.writeToBuffer(),
          $0.MarkAllReadResponse.fromBuffer);
  static final _$dismiss =
      $grpc.ClientMethod<$0.DismissRequest, $0.DismissResponse>(
          '/creativanta.admin.v1.NotificationService/Dismiss',
          ($0.DismissRequest value) => value.writeToBuffer(),
          $0.DismissResponse.fromBuffer);
  static final _$getUnreadCount =
      $grpc.ClientMethod<$0.GetUnreadCountRequest, $0.GetUnreadCountResponse>(
          '/creativanta.admin.v1.NotificationService/GetUnreadCount',
          ($0.GetUnreadCountRequest value) => value.writeToBuffer(),
          $0.GetUnreadCountResponse.fromBuffer);
  static final _$getPreferences =
      $grpc.ClientMethod<$0.GetPreferencesRequest, $0.GetPreferencesResponse>(
          '/creativanta.admin.v1.NotificationService/GetPreferences',
          ($0.GetPreferencesRequest value) => value.writeToBuffer(),
          $0.GetPreferencesResponse.fromBuffer);
  static final _$updatePreferences = $grpc.ClientMethod<
          $0.UpdatePreferencesRequest, $0.UpdatePreferencesResponse>(
      '/creativanta.admin.v1.NotificationService/UpdatePreferences',
      ($0.UpdatePreferencesRequest value) => value.writeToBuffer(),
      $0.UpdatePreferencesResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.admin.v1.NotificationService')
abstract class NotificationServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.admin.v1.NotificationService';

  NotificationServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ListRequest, $0.ListResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListRequest.fromBuffer(value),
        ($0.ListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.MarkReadRequest, $0.MarkReadResponse>(
        'MarkRead',
        markRead_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.MarkReadRequest.fromBuffer(value),
        ($0.MarkReadResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.MarkAllReadRequest, $0.MarkAllReadResponse>(
            'MarkAllRead',
            markAllRead_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.MarkAllReadRequest.fromBuffer(value),
            ($0.MarkAllReadResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DismissRequest, $0.DismissResponse>(
        'Dismiss',
        dismiss_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DismissRequest.fromBuffer(value),
        ($0.DismissResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetUnreadCountRequest,
            $0.GetUnreadCountResponse>(
        'GetUnreadCount',
        getUnreadCount_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetUnreadCountRequest.fromBuffer(value),
        ($0.GetUnreadCountResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetPreferencesRequest,
            $0.GetPreferencesResponse>(
        'GetPreferences',
        getPreferences_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetPreferencesRequest.fromBuffer(value),
        ($0.GetPreferencesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdatePreferencesRequest,
            $0.UpdatePreferencesResponse>(
        'UpdatePreferences',
        updatePreferences_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdatePreferencesRequest.fromBuffer(value),
        ($0.UpdatePreferencesResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.ListResponse> list_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.ListRequest> $request) async {
    return list($call, await $request);
  }

  $async.Future<$0.ListResponse> list(
      $grpc.ServiceCall call, $0.ListRequest request);

  $async.Future<$0.MarkReadResponse> markRead_Pre($grpc.ServiceCall $call,
      $async.Future<$0.MarkReadRequest> $request) async {
    return markRead($call, await $request);
  }

  $async.Future<$0.MarkReadResponse> markRead(
      $grpc.ServiceCall call, $0.MarkReadRequest request);

  $async.Future<$0.MarkAllReadResponse> markAllRead_Pre($grpc.ServiceCall $call,
      $async.Future<$0.MarkAllReadRequest> $request) async {
    return markAllRead($call, await $request);
  }

  $async.Future<$0.MarkAllReadResponse> markAllRead(
      $grpc.ServiceCall call, $0.MarkAllReadRequest request);

  $async.Future<$0.DismissResponse> dismiss_Pre($grpc.ServiceCall $call,
      $async.Future<$0.DismissRequest> $request) async {
    return dismiss($call, await $request);
  }

  $async.Future<$0.DismissResponse> dismiss(
      $grpc.ServiceCall call, $0.DismissRequest request);

  $async.Future<$0.GetUnreadCountResponse> getUnreadCount_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetUnreadCountRequest> $request) async {
    return getUnreadCount($call, await $request);
  }

  $async.Future<$0.GetUnreadCountResponse> getUnreadCount(
      $grpc.ServiceCall call, $0.GetUnreadCountRequest request);

  $async.Future<$0.GetPreferencesResponse> getPreferences_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetPreferencesRequest> $request) async {
    return getPreferences($call, await $request);
  }

  $async.Future<$0.GetPreferencesResponse> getPreferences(
      $grpc.ServiceCall call, $0.GetPreferencesRequest request);

  $async.Future<$0.UpdatePreferencesResponse> updatePreferences_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UpdatePreferencesRequest> $request) async {
    return updatePreferences($call, await $request);
  }

  $async.Future<$0.UpdatePreferencesResponse> updatePreferences(
      $grpc.ServiceCall call, $0.UpdatePreferencesRequest request);
}
