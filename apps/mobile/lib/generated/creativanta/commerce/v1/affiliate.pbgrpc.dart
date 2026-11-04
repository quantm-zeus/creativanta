// This is a generated file - do not edit.
//
// Generated from creativanta/commerce/v1/affiliate.proto.

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

import 'affiliate.pb.dart' as $0;

export 'affiliate.pb.dart';

@$pb.GrpcServiceName('creativanta.commerce.v1.AffiliateService')
class AffiliateServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  AffiliateServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.CreateAffiliateLinkResponse> createAffiliateLink(
    $0.CreateAffiliateLinkRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createAffiliateLink, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetAffiliateLinkResponse> getAffiliateLink(
    $0.GetAffiliateLinkRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getAffiliateLink, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListAffiliateLinksResponse> listAffiliateLinks(
    $0.ListAffiliateLinksRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listAffiliateLinks, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdateAffiliateLinkResponse> updateAffiliateLink(
    $0.UpdateAffiliateLinkRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateAffiliateLink, request, options: options);
  }

  $grpc.ResponseFuture<$0.DeleteAffiliateLinkResponse> deleteAffiliateLink(
    $0.DeleteAffiliateLinkRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteAffiliateLink, request, options: options);
  }

  $grpc.ResponseFuture<$0.PauseAffiliateLinkResponse> pauseAffiliateLink(
    $0.PauseAffiliateLinkRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$pauseAffiliateLink, request, options: options);
  }

  $grpc.ResponseFuture<$0.ResumeAffiliateLinkResponse> resumeAffiliateLink(
    $0.ResumeAffiliateLinkRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$resumeAffiliateLink, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetAffiliateAnalyticsResponse> getAffiliateAnalytics(
    $0.GetAffiliateAnalyticsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getAffiliateAnalytics, request, options: options);
  }

  // method descriptors

  static final _$createAffiliateLink = $grpc.ClientMethod<
          $0.CreateAffiliateLinkRequest, $0.CreateAffiliateLinkResponse>(
      '/creativanta.commerce.v1.AffiliateService/CreateAffiliateLink',
      ($0.CreateAffiliateLinkRequest value) => value.writeToBuffer(),
      $0.CreateAffiliateLinkResponse.fromBuffer);
  static final _$getAffiliateLink = $grpc.ClientMethod<
          $0.GetAffiliateLinkRequest, $0.GetAffiliateLinkResponse>(
      '/creativanta.commerce.v1.AffiliateService/GetAffiliateLink',
      ($0.GetAffiliateLinkRequest value) => value.writeToBuffer(),
      $0.GetAffiliateLinkResponse.fromBuffer);
  static final _$listAffiliateLinks = $grpc.ClientMethod<
          $0.ListAffiliateLinksRequest, $0.ListAffiliateLinksResponse>(
      '/creativanta.commerce.v1.AffiliateService/ListAffiliateLinks',
      ($0.ListAffiliateLinksRequest value) => value.writeToBuffer(),
      $0.ListAffiliateLinksResponse.fromBuffer);
  static final _$updateAffiliateLink = $grpc.ClientMethod<
          $0.UpdateAffiliateLinkRequest, $0.UpdateAffiliateLinkResponse>(
      '/creativanta.commerce.v1.AffiliateService/UpdateAffiliateLink',
      ($0.UpdateAffiliateLinkRequest value) => value.writeToBuffer(),
      $0.UpdateAffiliateLinkResponse.fromBuffer);
  static final _$deleteAffiliateLink = $grpc.ClientMethod<
          $0.DeleteAffiliateLinkRequest, $0.DeleteAffiliateLinkResponse>(
      '/creativanta.commerce.v1.AffiliateService/DeleteAffiliateLink',
      ($0.DeleteAffiliateLinkRequest value) => value.writeToBuffer(),
      $0.DeleteAffiliateLinkResponse.fromBuffer);
  static final _$pauseAffiliateLink = $grpc.ClientMethod<
          $0.PauseAffiliateLinkRequest, $0.PauseAffiliateLinkResponse>(
      '/creativanta.commerce.v1.AffiliateService/PauseAffiliateLink',
      ($0.PauseAffiliateLinkRequest value) => value.writeToBuffer(),
      $0.PauseAffiliateLinkResponse.fromBuffer);
  static final _$resumeAffiliateLink = $grpc.ClientMethod<
          $0.ResumeAffiliateLinkRequest, $0.ResumeAffiliateLinkResponse>(
      '/creativanta.commerce.v1.AffiliateService/ResumeAffiliateLink',
      ($0.ResumeAffiliateLinkRequest value) => value.writeToBuffer(),
      $0.ResumeAffiliateLinkResponse.fromBuffer);
  static final _$getAffiliateAnalytics = $grpc.ClientMethod<
          $0.GetAffiliateAnalyticsRequest, $0.GetAffiliateAnalyticsResponse>(
      '/creativanta.commerce.v1.AffiliateService/GetAffiliateAnalytics',
      ($0.GetAffiliateAnalyticsRequest value) => value.writeToBuffer(),
      $0.GetAffiliateAnalyticsResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.AffiliateService')
abstract class AffiliateServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.commerce.v1.AffiliateService';

  AffiliateServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CreateAffiliateLinkRequest,
            $0.CreateAffiliateLinkResponse>(
        'CreateAffiliateLink',
        createAffiliateLink_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CreateAffiliateLinkRequest.fromBuffer(value),
        ($0.CreateAffiliateLinkResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetAffiliateLinkRequest,
            $0.GetAffiliateLinkResponse>(
        'GetAffiliateLink',
        getAffiliateLink_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetAffiliateLinkRequest.fromBuffer(value),
        ($0.GetAffiliateLinkResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListAffiliateLinksRequest,
            $0.ListAffiliateLinksResponse>(
        'ListAffiliateLinks',
        listAffiliateLinks_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListAffiliateLinksRequest.fromBuffer(value),
        ($0.ListAffiliateLinksResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateAffiliateLinkRequest,
            $0.UpdateAffiliateLinkResponse>(
        'UpdateAffiliateLink',
        updateAffiliateLink_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateAffiliateLinkRequest.fromBuffer(value),
        ($0.UpdateAffiliateLinkResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteAffiliateLinkRequest,
            $0.DeleteAffiliateLinkResponse>(
        'DeleteAffiliateLink',
        deleteAffiliateLink_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.DeleteAffiliateLinkRequest.fromBuffer(value),
        ($0.DeleteAffiliateLinkResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PauseAffiliateLinkRequest,
            $0.PauseAffiliateLinkResponse>(
        'PauseAffiliateLink',
        pauseAffiliateLink_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.PauseAffiliateLinkRequest.fromBuffer(value),
        ($0.PauseAffiliateLinkResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ResumeAffiliateLinkRequest,
            $0.ResumeAffiliateLinkResponse>(
        'ResumeAffiliateLink',
        resumeAffiliateLink_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ResumeAffiliateLinkRequest.fromBuffer(value),
        ($0.ResumeAffiliateLinkResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetAffiliateAnalyticsRequest,
            $0.GetAffiliateAnalyticsResponse>(
        'GetAffiliateAnalytics',
        getAffiliateAnalytics_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetAffiliateAnalyticsRequest.fromBuffer(value),
        ($0.GetAffiliateAnalyticsResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.CreateAffiliateLinkResponse> createAffiliateLink_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CreateAffiliateLinkRequest> $request) async {
    return createAffiliateLink($call, await $request);
  }

  $async.Future<$0.CreateAffiliateLinkResponse> createAffiliateLink(
      $grpc.ServiceCall call, $0.CreateAffiliateLinkRequest request);

  $async.Future<$0.GetAffiliateLinkResponse> getAffiliateLink_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetAffiliateLinkRequest> $request) async {
    return getAffiliateLink($call, await $request);
  }

  $async.Future<$0.GetAffiliateLinkResponse> getAffiliateLink(
      $grpc.ServiceCall call, $0.GetAffiliateLinkRequest request);

  $async.Future<$0.ListAffiliateLinksResponse> listAffiliateLinks_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListAffiliateLinksRequest> $request) async {
    return listAffiliateLinks($call, await $request);
  }

  $async.Future<$0.ListAffiliateLinksResponse> listAffiliateLinks(
      $grpc.ServiceCall call, $0.ListAffiliateLinksRequest request);

  $async.Future<$0.UpdateAffiliateLinkResponse> updateAffiliateLink_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UpdateAffiliateLinkRequest> $request) async {
    return updateAffiliateLink($call, await $request);
  }

  $async.Future<$0.UpdateAffiliateLinkResponse> updateAffiliateLink(
      $grpc.ServiceCall call, $0.UpdateAffiliateLinkRequest request);

  $async.Future<$0.DeleteAffiliateLinkResponse> deleteAffiliateLink_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.DeleteAffiliateLinkRequest> $request) async {
    return deleteAffiliateLink($call, await $request);
  }

  $async.Future<$0.DeleteAffiliateLinkResponse> deleteAffiliateLink(
      $grpc.ServiceCall call, $0.DeleteAffiliateLinkRequest request);

  $async.Future<$0.PauseAffiliateLinkResponse> pauseAffiliateLink_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.PauseAffiliateLinkRequest> $request) async {
    return pauseAffiliateLink($call, await $request);
  }

  $async.Future<$0.PauseAffiliateLinkResponse> pauseAffiliateLink(
      $grpc.ServiceCall call, $0.PauseAffiliateLinkRequest request);

  $async.Future<$0.ResumeAffiliateLinkResponse> resumeAffiliateLink_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ResumeAffiliateLinkRequest> $request) async {
    return resumeAffiliateLink($call, await $request);
  }

  $async.Future<$0.ResumeAffiliateLinkResponse> resumeAffiliateLink(
      $grpc.ServiceCall call, $0.ResumeAffiliateLinkRequest request);

  $async.Future<$0.GetAffiliateAnalyticsResponse> getAffiliateAnalytics_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetAffiliateAnalyticsRequest> $request) async {
    return getAffiliateAnalytics($call, await $request);
  }

  $async.Future<$0.GetAffiliateAnalyticsResponse> getAffiliateAnalytics(
      $grpc.ServiceCall call, $0.GetAffiliateAnalyticsRequest request);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.CreatorAssignmentService')
class CreatorAssignmentServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  CreatorAssignmentServiceClient(super.channel,
      {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.CreateAssignmentResponse> createAssignment(
    $0.CreateAssignmentRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createAssignment, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListAssignmentsResponse> listAssignments(
    $0.ListAssignmentsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listAssignments, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdateAssignmentResponse> updateAssignment(
    $0.UpdateAssignmentRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateAssignment, request, options: options);
  }

  // method descriptors

  static final _$createAssignment = $grpc.ClientMethod<
          $0.CreateAssignmentRequest, $0.CreateAssignmentResponse>(
      '/creativanta.commerce.v1.CreatorAssignmentService/CreateAssignment',
      ($0.CreateAssignmentRequest value) => value.writeToBuffer(),
      $0.CreateAssignmentResponse.fromBuffer);
  static final _$listAssignments =
      $grpc.ClientMethod<$0.ListAssignmentsRequest, $0.ListAssignmentsResponse>(
          '/creativanta.commerce.v1.CreatorAssignmentService/ListAssignments',
          ($0.ListAssignmentsRequest value) => value.writeToBuffer(),
          $0.ListAssignmentsResponse.fromBuffer);
  static final _$updateAssignment = $grpc.ClientMethod<
          $0.UpdateAssignmentRequest, $0.UpdateAssignmentResponse>(
      '/creativanta.commerce.v1.CreatorAssignmentService/UpdateAssignment',
      ($0.UpdateAssignmentRequest value) => value.writeToBuffer(),
      $0.UpdateAssignmentResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.CreatorAssignmentService')
abstract class CreatorAssignmentServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.commerce.v1.CreatorAssignmentService';

  CreatorAssignmentServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CreateAssignmentRequest,
            $0.CreateAssignmentResponse>(
        'CreateAssignment',
        createAssignment_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CreateAssignmentRequest.fromBuffer(value),
        ($0.CreateAssignmentResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListAssignmentsRequest,
            $0.ListAssignmentsResponse>(
        'ListAssignments',
        listAssignments_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListAssignmentsRequest.fromBuffer(value),
        ($0.ListAssignmentsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateAssignmentRequest,
            $0.UpdateAssignmentResponse>(
        'UpdateAssignment',
        updateAssignment_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateAssignmentRequest.fromBuffer(value),
        ($0.UpdateAssignmentResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.CreateAssignmentResponse> createAssignment_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CreateAssignmentRequest> $request) async {
    return createAssignment($call, await $request);
  }

  $async.Future<$0.CreateAssignmentResponse> createAssignment(
      $grpc.ServiceCall call, $0.CreateAssignmentRequest request);

  $async.Future<$0.ListAssignmentsResponse> listAssignments_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListAssignmentsRequest> $request) async {
    return listAssignments($call, await $request);
  }

  $async.Future<$0.ListAssignmentsResponse> listAssignments(
      $grpc.ServiceCall call, $0.ListAssignmentsRequest request);

  $async.Future<$0.UpdateAssignmentResponse> updateAssignment_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UpdateAssignmentRequest> $request) async {
    return updateAssignment($call, await $request);
  }

  $async.Future<$0.UpdateAssignmentResponse> updateAssignment(
      $grpc.ServiceCall call, $0.UpdateAssignmentRequest request);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.AttributionService')
class AttributionServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  AttributionServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.RecordAttributionResponse> recordAttribution(
    $0.RecordAttributionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$recordAttribution, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetAttributionReportResponse> getAttributionReport(
    $0.GetAttributionReportRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getAttributionReport, request, options: options);
  }

  // method descriptors

  static final _$recordAttribution = $grpc.ClientMethod<
          $0.RecordAttributionRequest, $0.RecordAttributionResponse>(
      '/creativanta.commerce.v1.AttributionService/RecordAttribution',
      ($0.RecordAttributionRequest value) => value.writeToBuffer(),
      $0.RecordAttributionResponse.fromBuffer);
  static final _$getAttributionReport = $grpc.ClientMethod<
          $0.GetAttributionReportRequest, $0.GetAttributionReportResponse>(
      '/creativanta.commerce.v1.AttributionService/GetAttributionReport',
      ($0.GetAttributionReportRequest value) => value.writeToBuffer(),
      $0.GetAttributionReportResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.AttributionService')
abstract class AttributionServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.commerce.v1.AttributionService';

  AttributionServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.RecordAttributionRequest,
            $0.RecordAttributionResponse>(
        'RecordAttribution',
        recordAttribution_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RecordAttributionRequest.fromBuffer(value),
        ($0.RecordAttributionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetAttributionReportRequest,
            $0.GetAttributionReportResponse>(
        'GetAttributionReport',
        getAttributionReport_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetAttributionReportRequest.fromBuffer(value),
        ($0.GetAttributionReportResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.RecordAttributionResponse> recordAttribution_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RecordAttributionRequest> $request) async {
    return recordAttribution($call, await $request);
  }

  $async.Future<$0.RecordAttributionResponse> recordAttribution(
      $grpc.ServiceCall call, $0.RecordAttributionRequest request);

  $async.Future<$0.GetAttributionReportResponse> getAttributionReport_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetAttributionReportRequest> $request) async {
    return getAttributionReport($call, await $request);
  }

  $async.Future<$0.GetAttributionReportResponse> getAttributionReport(
      $grpc.ServiceCall call, $0.GetAttributionReportRequest request);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.AffiliateCommissionService')
class AffiliateCommissionServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  AffiliateCommissionServiceClient(super.channel,
      {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.CalculateCommissionResponse> calculateCommission(
    $0.CalculateCommissionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$calculateCommission, request, options: options);
  }

  $grpc.ResponseFuture<$0.ConfirmCommissionResponse> confirmCommission(
    $0.ConfirmCommissionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$confirmCommission, request, options: options);
  }

  $grpc.ResponseFuture<$0.ClawbackCommissionResponse> clawbackCommission(
    $0.ClawbackCommissionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$clawbackCommission, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListCommissionsResponse> listCommissions(
    $0.ListCommissionsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listCommissions, request, options: options);
  }

  $grpc.ResponseFuture<$0.PostCommissionToLedgerResponse>
      postCommissionToLedger(
    $0.PostCommissionToLedgerRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$postCommissionToLedger, request,
        options: options);
  }

  // method descriptors

  static final _$calculateCommission = $grpc.ClientMethod<
          $0.CalculateCommissionRequest, $0.CalculateCommissionResponse>(
      '/creativanta.commerce.v1.AffiliateCommissionService/CalculateCommission',
      ($0.CalculateCommissionRequest value) => value.writeToBuffer(),
      $0.CalculateCommissionResponse.fromBuffer);
  static final _$confirmCommission = $grpc.ClientMethod<
          $0.ConfirmCommissionRequest, $0.ConfirmCommissionResponse>(
      '/creativanta.commerce.v1.AffiliateCommissionService/ConfirmCommission',
      ($0.ConfirmCommissionRequest value) => value.writeToBuffer(),
      $0.ConfirmCommissionResponse.fromBuffer);
  static final _$clawbackCommission = $grpc.ClientMethod<
          $0.ClawbackCommissionRequest, $0.ClawbackCommissionResponse>(
      '/creativanta.commerce.v1.AffiliateCommissionService/ClawbackCommission',
      ($0.ClawbackCommissionRequest value) => value.writeToBuffer(),
      $0.ClawbackCommissionResponse.fromBuffer);
  static final _$listCommissions =
      $grpc.ClientMethod<$0.ListCommissionsRequest, $0.ListCommissionsResponse>(
          '/creativanta.commerce.v1.AffiliateCommissionService/ListCommissions',
          ($0.ListCommissionsRequest value) => value.writeToBuffer(),
          $0.ListCommissionsResponse.fromBuffer);
  static final _$postCommissionToLedger = $grpc.ClientMethod<
          $0.PostCommissionToLedgerRequest, $0.PostCommissionToLedgerResponse>(
      '/creativanta.commerce.v1.AffiliateCommissionService/PostCommissionToLedger',
      ($0.PostCommissionToLedgerRequest value) => value.writeToBuffer(),
      $0.PostCommissionToLedgerResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.AffiliateCommissionService')
abstract class AffiliateCommissionServiceBase extends $grpc.Service {
  $core.String get $name =>
      'creativanta.commerce.v1.AffiliateCommissionService';

  AffiliateCommissionServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CalculateCommissionRequest,
            $0.CalculateCommissionResponse>(
        'CalculateCommission',
        calculateCommission_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CalculateCommissionRequest.fromBuffer(value),
        ($0.CalculateCommissionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ConfirmCommissionRequest,
            $0.ConfirmCommissionResponse>(
        'ConfirmCommission',
        confirmCommission_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ConfirmCommissionRequest.fromBuffer(value),
        ($0.ConfirmCommissionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ClawbackCommissionRequest,
            $0.ClawbackCommissionResponse>(
        'ClawbackCommission',
        clawbackCommission_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ClawbackCommissionRequest.fromBuffer(value),
        ($0.ClawbackCommissionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListCommissionsRequest,
            $0.ListCommissionsResponse>(
        'ListCommissions',
        listCommissions_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListCommissionsRequest.fromBuffer(value),
        ($0.ListCommissionsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PostCommissionToLedgerRequest,
            $0.PostCommissionToLedgerResponse>(
        'PostCommissionToLedger',
        postCommissionToLedger_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.PostCommissionToLedgerRequest.fromBuffer(value),
        ($0.PostCommissionToLedgerResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.CalculateCommissionResponse> calculateCommission_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CalculateCommissionRequest> $request) async {
    return calculateCommission($call, await $request);
  }

  $async.Future<$0.CalculateCommissionResponse> calculateCommission(
      $grpc.ServiceCall call, $0.CalculateCommissionRequest request);

  $async.Future<$0.ConfirmCommissionResponse> confirmCommission_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ConfirmCommissionRequest> $request) async {
    return confirmCommission($call, await $request);
  }

  $async.Future<$0.ConfirmCommissionResponse> confirmCommission(
      $grpc.ServiceCall call, $0.ConfirmCommissionRequest request);

  $async.Future<$0.ClawbackCommissionResponse> clawbackCommission_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ClawbackCommissionRequest> $request) async {
    return clawbackCommission($call, await $request);
  }

  $async.Future<$0.ClawbackCommissionResponse> clawbackCommission(
      $grpc.ServiceCall call, $0.ClawbackCommissionRequest request);

  $async.Future<$0.ListCommissionsResponse> listCommissions_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListCommissionsRequest> $request) async {
    return listCommissions($call, await $request);
  }

  $async.Future<$0.ListCommissionsResponse> listCommissions(
      $grpc.ServiceCall call, $0.ListCommissionsRequest request);

  $async.Future<$0.PostCommissionToLedgerResponse> postCommissionToLedger_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.PostCommissionToLedgerRequest> $request) async {
    return postCommissionToLedger($call, await $request);
  }

  $async.Future<$0.PostCommissionToLedgerResponse> postCommissionToLedger(
      $grpc.ServiceCall call, $0.PostCommissionToLedgerRequest request);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.AffiliatePayoutService')
class AffiliatePayoutServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  AffiliatePayoutServiceClient(super.channel,
      {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.CreatePayoutBatchResponse> createPayoutBatch(
    $0.CreatePayoutBatchRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createPayoutBatch, request, options: options);
  }

  $grpc.ResponseFuture<$0.ExecutePayoutBatchResponse> executePayoutBatch(
    $0.ExecutePayoutBatchRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$executePayoutBatch, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetPayoutProofResponse> getPayoutProof(
    $0.GetPayoutProofRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getPayoutProof, request, options: options);
  }

  $grpc.ResponseFuture<$0.ImportStatementResponse> importStatement(
    $0.ImportStatementRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$importStatement, request, options: options);
  }

  $grpc.ResponseFuture<$0.ReconcileStatementResponse> reconcileStatement(
    $0.ReconcileStatementRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$reconcileStatement, request, options: options);
  }

  // method descriptors

  static final _$createPayoutBatch = $grpc.ClientMethod<
          $0.CreatePayoutBatchRequest, $0.CreatePayoutBatchResponse>(
      '/creativanta.commerce.v1.AffiliatePayoutService/CreatePayoutBatch',
      ($0.CreatePayoutBatchRequest value) => value.writeToBuffer(),
      $0.CreatePayoutBatchResponse.fromBuffer);
  static final _$executePayoutBatch = $grpc.ClientMethod<
          $0.ExecutePayoutBatchRequest, $0.ExecutePayoutBatchResponse>(
      '/creativanta.commerce.v1.AffiliatePayoutService/ExecutePayoutBatch',
      ($0.ExecutePayoutBatchRequest value) => value.writeToBuffer(),
      $0.ExecutePayoutBatchResponse.fromBuffer);
  static final _$getPayoutProof =
      $grpc.ClientMethod<$0.GetPayoutProofRequest, $0.GetPayoutProofResponse>(
          '/creativanta.commerce.v1.AffiliatePayoutService/GetPayoutProof',
          ($0.GetPayoutProofRequest value) => value.writeToBuffer(),
          $0.GetPayoutProofResponse.fromBuffer);
  static final _$importStatement =
      $grpc.ClientMethod<$0.ImportStatementRequest, $0.ImportStatementResponse>(
          '/creativanta.commerce.v1.AffiliatePayoutService/ImportStatement',
          ($0.ImportStatementRequest value) => value.writeToBuffer(),
          $0.ImportStatementResponse.fromBuffer);
  static final _$reconcileStatement = $grpc.ClientMethod<
          $0.ReconcileStatementRequest, $0.ReconcileStatementResponse>(
      '/creativanta.commerce.v1.AffiliatePayoutService/ReconcileStatement',
      ($0.ReconcileStatementRequest value) => value.writeToBuffer(),
      $0.ReconcileStatementResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.AffiliatePayoutService')
abstract class AffiliatePayoutServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.commerce.v1.AffiliatePayoutService';

  AffiliatePayoutServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CreatePayoutBatchRequest,
            $0.CreatePayoutBatchResponse>(
        'CreatePayoutBatch',
        createPayoutBatch_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CreatePayoutBatchRequest.fromBuffer(value),
        ($0.CreatePayoutBatchResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ExecutePayoutBatchRequest,
            $0.ExecutePayoutBatchResponse>(
        'ExecutePayoutBatch',
        executePayoutBatch_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ExecutePayoutBatchRequest.fromBuffer(value),
        ($0.ExecutePayoutBatchResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetPayoutProofRequest,
            $0.GetPayoutProofResponse>(
        'GetPayoutProof',
        getPayoutProof_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetPayoutProofRequest.fromBuffer(value),
        ($0.GetPayoutProofResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ImportStatementRequest,
            $0.ImportStatementResponse>(
        'ImportStatement',
        importStatement_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ImportStatementRequest.fromBuffer(value),
        ($0.ImportStatementResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ReconcileStatementRequest,
            $0.ReconcileStatementResponse>(
        'ReconcileStatement',
        reconcileStatement_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ReconcileStatementRequest.fromBuffer(value),
        ($0.ReconcileStatementResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.CreatePayoutBatchResponse> createPayoutBatch_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CreatePayoutBatchRequest> $request) async {
    return createPayoutBatch($call, await $request);
  }

  $async.Future<$0.CreatePayoutBatchResponse> createPayoutBatch(
      $grpc.ServiceCall call, $0.CreatePayoutBatchRequest request);

  $async.Future<$0.ExecutePayoutBatchResponse> executePayoutBatch_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ExecutePayoutBatchRequest> $request) async {
    return executePayoutBatch($call, await $request);
  }

  $async.Future<$0.ExecutePayoutBatchResponse> executePayoutBatch(
      $grpc.ServiceCall call, $0.ExecutePayoutBatchRequest request);

  $async.Future<$0.GetPayoutProofResponse> getPayoutProof_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetPayoutProofRequest> $request) async {
    return getPayoutProof($call, await $request);
  }

  $async.Future<$0.GetPayoutProofResponse> getPayoutProof(
      $grpc.ServiceCall call, $0.GetPayoutProofRequest request);

  $async.Future<$0.ImportStatementResponse> importStatement_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ImportStatementRequest> $request) async {
    return importStatement($call, await $request);
  }

  $async.Future<$0.ImportStatementResponse> importStatement(
      $grpc.ServiceCall call, $0.ImportStatementRequest request);

  $async.Future<$0.ReconcileStatementResponse> reconcileStatement_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ReconcileStatementRequest> $request) async {
    return reconcileStatement($call, await $request);
  }

  $async.Future<$0.ReconcileStatementResponse> reconcileStatement(
      $grpc.ServiceCall call, $0.ReconcileStatementRequest request);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.LinkHealthService')
class LinkHealthServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  LinkHealthServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.RunHealthCheckResponse> runHealthCheck(
    $0.RunHealthCheckRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$runHealthCheck, request, options: options);
  }

  $grpc.ResponseFuture<$0.RepairBrokenLinkResponse> repairBrokenLink(
    $0.RepairBrokenLinkRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$repairBrokenLink, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetHealthReportResponse> getHealthReport(
    $0.GetHealthReportRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getHealthReport, request, options: options);
  }

  // method descriptors

  static final _$runHealthCheck =
      $grpc.ClientMethod<$0.RunHealthCheckRequest, $0.RunHealthCheckResponse>(
          '/creativanta.commerce.v1.LinkHealthService/RunHealthCheck',
          ($0.RunHealthCheckRequest value) => value.writeToBuffer(),
          $0.RunHealthCheckResponse.fromBuffer);
  static final _$repairBrokenLink = $grpc.ClientMethod<
          $0.RepairBrokenLinkRequest, $0.RepairBrokenLinkResponse>(
      '/creativanta.commerce.v1.LinkHealthService/RepairBrokenLink',
      ($0.RepairBrokenLinkRequest value) => value.writeToBuffer(),
      $0.RepairBrokenLinkResponse.fromBuffer);
  static final _$getHealthReport =
      $grpc.ClientMethod<$0.GetHealthReportRequest, $0.GetHealthReportResponse>(
          '/creativanta.commerce.v1.LinkHealthService/GetHealthReport',
          ($0.GetHealthReportRequest value) => value.writeToBuffer(),
          $0.GetHealthReportResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.LinkHealthService')
abstract class LinkHealthServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.commerce.v1.LinkHealthService';

  LinkHealthServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.RunHealthCheckRequest,
            $0.RunHealthCheckResponse>(
        'RunHealthCheck',
        runHealthCheck_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RunHealthCheckRequest.fromBuffer(value),
        ($0.RunHealthCheckResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RepairBrokenLinkRequest,
            $0.RepairBrokenLinkResponse>(
        'RepairBrokenLink',
        repairBrokenLink_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RepairBrokenLinkRequest.fromBuffer(value),
        ($0.RepairBrokenLinkResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetHealthReportRequest,
            $0.GetHealthReportResponse>(
        'GetHealthReport',
        getHealthReport_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetHealthReportRequest.fromBuffer(value),
        ($0.GetHealthReportResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.RunHealthCheckResponse> runHealthCheck_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RunHealthCheckRequest> $request) async {
    return runHealthCheck($call, await $request);
  }

  $async.Future<$0.RunHealthCheckResponse> runHealthCheck(
      $grpc.ServiceCall call, $0.RunHealthCheckRequest request);

  $async.Future<$0.RepairBrokenLinkResponse> repairBrokenLink_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RepairBrokenLinkRequest> $request) async {
    return repairBrokenLink($call, await $request);
  }

  $async.Future<$0.RepairBrokenLinkResponse> repairBrokenLink(
      $grpc.ServiceCall call, $0.RepairBrokenLinkRequest request);

  $async.Future<$0.GetHealthReportResponse> getHealthReport_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetHealthReportRequest> $request) async {
    return getHealthReport($call, await $request);
  }

  $async.Future<$0.GetHealthReportResponse> getHealthReport(
      $grpc.ServiceCall call, $0.GetHealthReportRequest request);
}
