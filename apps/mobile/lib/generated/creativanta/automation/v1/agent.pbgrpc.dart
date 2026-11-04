// This is a generated file - do not edit.
//
// Generated from creativanta/automation/v1/agent.proto.

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

import 'agent.pb.dart' as $0;

export 'agent.pb.dart';

/// AgentService provides multi-step autonomous planning, execution, bounded memory,
/// and audited handoff across the Creativanta operating graph (§17.6).
@$pb.GrpcServiceName('creativanta.automation.v1.AgentService')
class AgentServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  AgentServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.AgentServiceLaunchAgentResponse> launchAgent(
    $0.AgentServiceLaunchAgentRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$launchAgent, request, options: options);
  }

  $grpc.ResponseFuture<$0.AgentServiceListRunsResponse> listRuns(
    $0.AgentServiceListRunsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listRuns, request, options: options);
  }

  $grpc.ResponseFuture<$0.AgentServiceCancelRunResponse> cancelRun(
    $0.AgentServiceCancelRunRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$cancelRun, request, options: options);
  }

  $grpc.ResponseFuture<$0.AgentServiceStreamRunResponse> streamRun(
    $0.AgentServiceStreamRunRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$streamRun, request, options: options);
  }

  $grpc.ResponseFuture<$0.AgentServiceProvideInputResponse> provideInput(
    $0.AgentServiceProvideInputRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$provideInput, request, options: options);
  }

  // method descriptors

  static final _$launchAgent = $grpc.ClientMethod<
          $0.AgentServiceLaunchAgentRequest,
          $0.AgentServiceLaunchAgentResponse>(
      '/creativanta.automation.v1.AgentService/LaunchAgent',
      ($0.AgentServiceLaunchAgentRequest value) => value.writeToBuffer(),
      $0.AgentServiceLaunchAgentResponse.fromBuffer);
  static final _$listRuns = $grpc.ClientMethod<$0.AgentServiceListRunsRequest,
          $0.AgentServiceListRunsResponse>(
      '/creativanta.automation.v1.AgentService/ListRuns',
      ($0.AgentServiceListRunsRequest value) => value.writeToBuffer(),
      $0.AgentServiceListRunsResponse.fromBuffer);
  static final _$cancelRun = $grpc.ClientMethod<$0.AgentServiceCancelRunRequest,
          $0.AgentServiceCancelRunResponse>(
      '/creativanta.automation.v1.AgentService/CancelRun',
      ($0.AgentServiceCancelRunRequest value) => value.writeToBuffer(),
      $0.AgentServiceCancelRunResponse.fromBuffer);
  static final _$streamRun = $grpc.ClientMethod<$0.AgentServiceStreamRunRequest,
          $0.AgentServiceStreamRunResponse>(
      '/creativanta.automation.v1.AgentService/StreamRun',
      ($0.AgentServiceStreamRunRequest value) => value.writeToBuffer(),
      $0.AgentServiceStreamRunResponse.fromBuffer);
  static final _$provideInput = $grpc.ClientMethod<
          $0.AgentServiceProvideInputRequest,
          $0.AgentServiceProvideInputResponse>(
      '/creativanta.automation.v1.AgentService/ProvideInput',
      ($0.AgentServiceProvideInputRequest value) => value.writeToBuffer(),
      $0.AgentServiceProvideInputResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.automation.v1.AgentService')
abstract class AgentServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.automation.v1.AgentService';

  AgentServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.AgentServiceLaunchAgentRequest,
            $0.AgentServiceLaunchAgentResponse>(
        'LaunchAgent',
        launchAgent_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.AgentServiceLaunchAgentRequest.fromBuffer(value),
        ($0.AgentServiceLaunchAgentResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.AgentServiceListRunsRequest,
            $0.AgentServiceListRunsResponse>(
        'ListRuns',
        listRuns_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.AgentServiceListRunsRequest.fromBuffer(value),
        ($0.AgentServiceListRunsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.AgentServiceCancelRunRequest,
            $0.AgentServiceCancelRunResponse>(
        'CancelRun',
        cancelRun_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.AgentServiceCancelRunRequest.fromBuffer(value),
        ($0.AgentServiceCancelRunResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.AgentServiceStreamRunRequest,
            $0.AgentServiceStreamRunResponse>(
        'StreamRun',
        streamRun_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.AgentServiceStreamRunRequest.fromBuffer(value),
        ($0.AgentServiceStreamRunResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.AgentServiceProvideInputRequest,
            $0.AgentServiceProvideInputResponse>(
        'ProvideInput',
        provideInput_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.AgentServiceProvideInputRequest.fromBuffer(value),
        ($0.AgentServiceProvideInputResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.AgentServiceLaunchAgentResponse> launchAgent_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.AgentServiceLaunchAgentRequest> $request) async {
    return launchAgent($call, await $request);
  }

  $async.Future<$0.AgentServiceLaunchAgentResponse> launchAgent(
      $grpc.ServiceCall call, $0.AgentServiceLaunchAgentRequest request);

  $async.Future<$0.AgentServiceListRunsResponse> listRuns_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.AgentServiceListRunsRequest> $request) async {
    return listRuns($call, await $request);
  }

  $async.Future<$0.AgentServiceListRunsResponse> listRuns(
      $grpc.ServiceCall call, $0.AgentServiceListRunsRequest request);

  $async.Future<$0.AgentServiceCancelRunResponse> cancelRun_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.AgentServiceCancelRunRequest> $request) async {
    return cancelRun($call, await $request);
  }

  $async.Future<$0.AgentServiceCancelRunResponse> cancelRun(
      $grpc.ServiceCall call, $0.AgentServiceCancelRunRequest request);

  $async.Future<$0.AgentServiceStreamRunResponse> streamRun_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.AgentServiceStreamRunRequest> $request) async {
    return streamRun($call, await $request);
  }

  $async.Future<$0.AgentServiceStreamRunResponse> streamRun(
      $grpc.ServiceCall call, $0.AgentServiceStreamRunRequest request);

  $async.Future<$0.AgentServiceProvideInputResponse> provideInput_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.AgentServiceProvideInputRequest> $request) async {
    return provideInput($call, await $request);
  }

  $async.Future<$0.AgentServiceProvideInputResponse> provideInput(
      $grpc.ServiceCall call, $0.AgentServiceProvideInputRequest request);
}
