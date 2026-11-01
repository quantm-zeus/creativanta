// This is a generated file - do not edit.
//
// Generated from creativanta/transport/test/v1/fixture.proto.

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

import 'fixture.pb.dart' as $0;

export 'fixture.pb.dart';

/// TEST-ONLY TRANSPORT VERIFICATION CONTRACT.
/// This service is strictly for the integration test server to verify that TypeScript Connect
/// and Dart gRPC clients reach the exact same Go generated handler implementation.
/// It MUST NEVER be registered on the production API or isolated admin API.
@$pb.GrpcServiceName('creativanta.transport.test.v1.TransportFixtureService')
class TransportFixtureServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  TransportFixtureServiceClient(super.channel,
      {super.options, super.interceptors});

  /// Verifies unary request/response serialization, auth context propagation, and workspace scoping.
  $grpc.ResponseFuture<$0.EchoResponse> echo(
    $0.EchoRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$echo, request, options: options);
  }

  /// Verifies mutating command envelope handling and idempotency replay detection.
  $grpc.ResponseFuture<$0.ExecuteResponse> execute(
    $0.ExecuteRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$execute, request, options: options);
  }

  /// Verifies cursor pagination, filtering, and sorting parameters across transports.
  $grpc.ResponseFuture<$0.ListResponse> list(
    $0.ListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$list, request, options: options);
  }

  /// Verifies server-streaming delivery over Connect and gRPC transports.
  $grpc.ResponseStream<$0.WatchResponse> watch(
    $0.WatchRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(_$watch, $async.Stream.fromIterable([request]),
        options: options);
  }

  // method descriptors

  static final _$echo = $grpc.ClientMethod<$0.EchoRequest, $0.EchoResponse>(
      '/creativanta.transport.test.v1.TransportFixtureService/Echo',
      ($0.EchoRequest value) => value.writeToBuffer(),
      $0.EchoResponse.fromBuffer);
  static final _$execute =
      $grpc.ClientMethod<$0.ExecuteRequest, $0.ExecuteResponse>(
          '/creativanta.transport.test.v1.TransportFixtureService/Execute',
          ($0.ExecuteRequest value) => value.writeToBuffer(),
          $0.ExecuteResponse.fromBuffer);
  static final _$list = $grpc.ClientMethod<$0.ListRequest, $0.ListResponse>(
      '/creativanta.transport.test.v1.TransportFixtureService/List',
      ($0.ListRequest value) => value.writeToBuffer(),
      $0.ListResponse.fromBuffer);
  static final _$watch = $grpc.ClientMethod<$0.WatchRequest, $0.WatchResponse>(
      '/creativanta.transport.test.v1.TransportFixtureService/Watch',
      ($0.WatchRequest value) => value.writeToBuffer(),
      $0.WatchResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.transport.test.v1.TransportFixtureService')
abstract class TransportFixtureServiceBase extends $grpc.Service {
  $core.String get $name =>
      'creativanta.transport.test.v1.TransportFixtureService';

  TransportFixtureServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.EchoRequest, $0.EchoResponse>(
        'Echo',
        echo_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.EchoRequest.fromBuffer(value),
        ($0.EchoResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ExecuteRequest, $0.ExecuteResponse>(
        'Execute',
        execute_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ExecuteRequest.fromBuffer(value),
        ($0.ExecuteResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListRequest, $0.ListResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListRequest.fromBuffer(value),
        ($0.ListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WatchRequest, $0.WatchResponse>(
        'Watch',
        watch_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.WatchRequest.fromBuffer(value),
        ($0.WatchResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.EchoResponse> echo_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.EchoRequest> $request) async {
    return echo($call, await $request);
  }

  $async.Future<$0.EchoResponse> echo(
      $grpc.ServiceCall call, $0.EchoRequest request);

  $async.Future<$0.ExecuteResponse> execute_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ExecuteRequest> $request) async {
    return execute($call, await $request);
  }

  $async.Future<$0.ExecuteResponse> execute(
      $grpc.ServiceCall call, $0.ExecuteRequest request);

  $async.Future<$0.ListResponse> list_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.ListRequest> $request) async {
    return list($call, await $request);
  }

  $async.Future<$0.ListResponse> list(
      $grpc.ServiceCall call, $0.ListRequest request);

  $async.Stream<$0.WatchResponse> watch_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.WatchRequest> $request) async* {
    yield* watch($call, await $request);
  }

  $async.Stream<$0.WatchResponse> watch(
      $grpc.ServiceCall call, $0.WatchRequest request);
}
