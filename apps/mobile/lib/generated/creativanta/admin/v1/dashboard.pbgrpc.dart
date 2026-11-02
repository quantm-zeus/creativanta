// This is a generated file - do not edit.
//
// Generated from creativanta/admin/v1/dashboard.proto.

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

import 'dashboard.pb.dart' as $0;

export 'dashboard.pb.dart';

/// Daily Decision Engine & Dashboard Service (M01)
@$pb.GrpcServiceName('creativanta.admin.v1.DashboardService')
class DashboardServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  DashboardServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.GetMobileHomeResponse> getMobileHome(
    $0.GetMobileHomeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getMobileHome, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetPipelineResponse> getPipeline(
    $0.GetPipelineRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getPipeline, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetDecisionCardsResponse> getDecisionCards(
    $0.GetDecisionCardsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getDecisionCards, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetWhyThisNumberResponse> getWhyThisNumber(
    $0.GetWhyThisNumberRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getWhyThisNumber, request, options: options);
  }

  $grpc.ResponseFuture<$0.CompleteOnboardingStepResponse>
      completeOnboardingStep(
    $0.CompleteOnboardingStepRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$completeOnboardingStep, request,
        options: options);
  }

  // method descriptors

  static final _$getMobileHome =
      $grpc.ClientMethod<$0.GetMobileHomeRequest, $0.GetMobileHomeResponse>(
          '/creativanta.admin.v1.DashboardService/GetMobileHome',
          ($0.GetMobileHomeRequest value) => value.writeToBuffer(),
          $0.GetMobileHomeResponse.fromBuffer);
  static final _$getPipeline =
      $grpc.ClientMethod<$0.GetPipelineRequest, $0.GetPipelineResponse>(
          '/creativanta.admin.v1.DashboardService/GetPipeline',
          ($0.GetPipelineRequest value) => value.writeToBuffer(),
          $0.GetPipelineResponse.fromBuffer);
  static final _$getDecisionCards = $grpc.ClientMethod<
          $0.GetDecisionCardsRequest, $0.GetDecisionCardsResponse>(
      '/creativanta.admin.v1.DashboardService/GetDecisionCards',
      ($0.GetDecisionCardsRequest value) => value.writeToBuffer(),
      $0.GetDecisionCardsResponse.fromBuffer);
  static final _$getWhyThisNumber = $grpc.ClientMethod<
          $0.GetWhyThisNumberRequest, $0.GetWhyThisNumberResponse>(
      '/creativanta.admin.v1.DashboardService/GetWhyThisNumber',
      ($0.GetWhyThisNumberRequest value) => value.writeToBuffer(),
      $0.GetWhyThisNumberResponse.fromBuffer);
  static final _$completeOnboardingStep = $grpc.ClientMethod<
          $0.CompleteOnboardingStepRequest, $0.CompleteOnboardingStepResponse>(
      '/creativanta.admin.v1.DashboardService/CompleteOnboardingStep',
      ($0.CompleteOnboardingStepRequest value) => value.writeToBuffer(),
      $0.CompleteOnboardingStepResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.admin.v1.DashboardService')
abstract class DashboardServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.admin.v1.DashboardService';

  DashboardServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.GetMobileHomeRequest, $0.GetMobileHomeResponse>(
            'GetMobileHome',
            getMobileHome_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetMobileHomeRequest.fromBuffer(value),
            ($0.GetMobileHomeResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetPipelineRequest, $0.GetPipelineResponse>(
            'GetPipeline',
            getPipeline_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetPipelineRequest.fromBuffer(value),
            ($0.GetPipelineResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetDecisionCardsRequest,
            $0.GetDecisionCardsResponse>(
        'GetDecisionCards',
        getDecisionCards_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetDecisionCardsRequest.fromBuffer(value),
        ($0.GetDecisionCardsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetWhyThisNumberRequest,
            $0.GetWhyThisNumberResponse>(
        'GetWhyThisNumber',
        getWhyThisNumber_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetWhyThisNumberRequest.fromBuffer(value),
        ($0.GetWhyThisNumberResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CompleteOnboardingStepRequest,
            $0.CompleteOnboardingStepResponse>(
        'CompleteOnboardingStep',
        completeOnboardingStep_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CompleteOnboardingStepRequest.fromBuffer(value),
        ($0.CompleteOnboardingStepResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.GetMobileHomeResponse> getMobileHome_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetMobileHomeRequest> $request) async {
    return getMobileHome($call, await $request);
  }

  $async.Future<$0.GetMobileHomeResponse> getMobileHome(
      $grpc.ServiceCall call, $0.GetMobileHomeRequest request);

  $async.Future<$0.GetPipelineResponse> getPipeline_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetPipelineRequest> $request) async {
    return getPipeline($call, await $request);
  }

  $async.Future<$0.GetPipelineResponse> getPipeline(
      $grpc.ServiceCall call, $0.GetPipelineRequest request);

  $async.Future<$0.GetDecisionCardsResponse> getDecisionCards_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetDecisionCardsRequest> $request) async {
    return getDecisionCards($call, await $request);
  }

  $async.Future<$0.GetDecisionCardsResponse> getDecisionCards(
      $grpc.ServiceCall call, $0.GetDecisionCardsRequest request);

  $async.Future<$0.GetWhyThisNumberResponse> getWhyThisNumber_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetWhyThisNumberRequest> $request) async {
    return getWhyThisNumber($call, await $request);
  }

  $async.Future<$0.GetWhyThisNumberResponse> getWhyThisNumber(
      $grpc.ServiceCall call, $0.GetWhyThisNumberRequest request);

  $async.Future<$0.CompleteOnboardingStepResponse> completeOnboardingStep_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CompleteOnboardingStepRequest> $request) async {
    return completeOnboardingStep($call, await $request);
  }

  $async.Future<$0.CompleteOnboardingStepResponse> completeOnboardingStep(
      $grpc.ServiceCall call, $0.CompleteOnboardingStepRequest request);
}
