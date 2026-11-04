// This is a generated file - do not edit.
//
// Generated from creativanta/platform/v1/referral.proto.

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

import 'referral.pb.dart' as $0;

export 'referral.pb.dart';

@$pb.GrpcServiceName('creativanta.platform.v1.ReferralService')
class ReferralServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ReferralServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.GetMyReferralCodeResponse> getMyReferralCode(
    $0.GetMyReferralCodeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getMyReferralCode, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetReferralStatsResponse> getReferralStats(
    $0.GetReferralStatsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getReferralStats, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListReferralsResponse> listReferrals(
    $0.ListReferralsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listReferrals, request, options: options);
  }

  $grpc.ResponseFuture<$0.ClaimRewardResponse> claimReward(
    $0.ClaimRewardRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$claimReward, request, options: options);
  }

  $grpc.ResponseFuture<$0.ValidateCodeResponse> validateCode(
    $0.ValidateCodeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$validateCode, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetDashboardResponse> getDashboard(
    $0.GetDashboardRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getDashboard, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetReferralLinkResponse> getReferralLink(
    $0.GetReferralLinkRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getReferralLink, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetStatsResponse> getStats(
    $0.GetStatsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getStats, request, options: options);
  }

  $grpc.ResponseFuture<$0.SendReminderResponse> sendReminder(
    $0.SendReminderRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$sendReminder, request, options: options);
  }

  /// Settlement, Reversal & Anti-Fraud lifecycle
  $grpc.ResponseFuture<$0.ProcessPaymentSettlementResponse>
      processPaymentSettlement(
    $0.ProcessPaymentSettlementRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$processPaymentSettlement, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.ProcessRefundReversalResponse> processRefundReversal(
    $0.ProcessRefundReversalRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$processRefundReversal, request, options: options);
  }

  $grpc.ResponseFuture<$0.ReviewFraudCaseResponse> reviewFraudCase(
    $0.ReviewFraudCaseRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$reviewFraudCase, request, options: options);
  }

  // method descriptors

  static final _$getMyReferralCode = $grpc.ClientMethod<
          $0.GetMyReferralCodeRequest, $0.GetMyReferralCodeResponse>(
      '/creativanta.platform.v1.ReferralService/GetMyReferralCode',
      ($0.GetMyReferralCodeRequest value) => value.writeToBuffer(),
      $0.GetMyReferralCodeResponse.fromBuffer);
  static final _$getReferralStats = $grpc.ClientMethod<
          $0.GetReferralStatsRequest, $0.GetReferralStatsResponse>(
      '/creativanta.platform.v1.ReferralService/GetReferralStats',
      ($0.GetReferralStatsRequest value) => value.writeToBuffer(),
      $0.GetReferralStatsResponse.fromBuffer);
  static final _$listReferrals =
      $grpc.ClientMethod<$0.ListReferralsRequest, $0.ListReferralsResponse>(
          '/creativanta.platform.v1.ReferralService/ListReferrals',
          ($0.ListReferralsRequest value) => value.writeToBuffer(),
          $0.ListReferralsResponse.fromBuffer);
  static final _$claimReward =
      $grpc.ClientMethod<$0.ClaimRewardRequest, $0.ClaimRewardResponse>(
          '/creativanta.platform.v1.ReferralService/ClaimReward',
          ($0.ClaimRewardRequest value) => value.writeToBuffer(),
          $0.ClaimRewardResponse.fromBuffer);
  static final _$validateCode =
      $grpc.ClientMethod<$0.ValidateCodeRequest, $0.ValidateCodeResponse>(
          '/creativanta.platform.v1.ReferralService/ValidateCode',
          ($0.ValidateCodeRequest value) => value.writeToBuffer(),
          $0.ValidateCodeResponse.fromBuffer);
  static final _$getDashboard =
      $grpc.ClientMethod<$0.GetDashboardRequest, $0.GetDashboardResponse>(
          '/creativanta.platform.v1.ReferralService/GetDashboard',
          ($0.GetDashboardRequest value) => value.writeToBuffer(),
          $0.GetDashboardResponse.fromBuffer);
  static final _$getReferralLink =
      $grpc.ClientMethod<$0.GetReferralLinkRequest, $0.GetReferralLinkResponse>(
          '/creativanta.platform.v1.ReferralService/GetReferralLink',
          ($0.GetReferralLinkRequest value) => value.writeToBuffer(),
          $0.GetReferralLinkResponse.fromBuffer);
  static final _$getStats =
      $grpc.ClientMethod<$0.GetStatsRequest, $0.GetStatsResponse>(
          '/creativanta.platform.v1.ReferralService/GetStats',
          ($0.GetStatsRequest value) => value.writeToBuffer(),
          $0.GetStatsResponse.fromBuffer);
  static final _$sendReminder =
      $grpc.ClientMethod<$0.SendReminderRequest, $0.SendReminderResponse>(
          '/creativanta.platform.v1.ReferralService/SendReminder',
          ($0.SendReminderRequest value) => value.writeToBuffer(),
          $0.SendReminderResponse.fromBuffer);
  static final _$processPaymentSettlement = $grpc.ClientMethod<
          $0.ProcessPaymentSettlementRequest,
          $0.ProcessPaymentSettlementResponse>(
      '/creativanta.platform.v1.ReferralService/ProcessPaymentSettlement',
      ($0.ProcessPaymentSettlementRequest value) => value.writeToBuffer(),
      $0.ProcessPaymentSettlementResponse.fromBuffer);
  static final _$processRefundReversal = $grpc.ClientMethod<
          $0.ProcessRefundReversalRequest, $0.ProcessRefundReversalResponse>(
      '/creativanta.platform.v1.ReferralService/ProcessRefundReversal',
      ($0.ProcessRefundReversalRequest value) => value.writeToBuffer(),
      $0.ProcessRefundReversalResponse.fromBuffer);
  static final _$reviewFraudCase =
      $grpc.ClientMethod<$0.ReviewFraudCaseRequest, $0.ReviewFraudCaseResponse>(
          '/creativanta.platform.v1.ReferralService/ReviewFraudCase',
          ($0.ReviewFraudCaseRequest value) => value.writeToBuffer(),
          $0.ReviewFraudCaseResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.platform.v1.ReferralService')
abstract class ReferralServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.platform.v1.ReferralService';

  ReferralServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetMyReferralCodeRequest,
            $0.GetMyReferralCodeResponse>(
        'GetMyReferralCode',
        getMyReferralCode_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetMyReferralCodeRequest.fromBuffer(value),
        ($0.GetMyReferralCodeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetReferralStatsRequest,
            $0.GetReferralStatsResponse>(
        'GetReferralStats',
        getReferralStats_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetReferralStatsRequest.fromBuffer(value),
        ($0.GetReferralStatsResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListReferralsRequest, $0.ListReferralsResponse>(
            'ListReferrals',
            listReferrals_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListReferralsRequest.fromBuffer(value),
            ($0.ListReferralsResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ClaimRewardRequest, $0.ClaimRewardResponse>(
            'ClaimReward',
            claimReward_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ClaimRewardRequest.fromBuffer(value),
            ($0.ClaimRewardResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ValidateCodeRequest, $0.ValidateCodeResponse>(
            'ValidateCode',
            validateCode_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ValidateCodeRequest.fromBuffer(value),
            ($0.ValidateCodeResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetDashboardRequest, $0.GetDashboardResponse>(
            'GetDashboard',
            getDashboard_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetDashboardRequest.fromBuffer(value),
            ($0.GetDashboardResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetReferralLinkRequest,
            $0.GetReferralLinkResponse>(
        'GetReferralLink',
        getReferralLink_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetReferralLinkRequest.fromBuffer(value),
        ($0.GetReferralLinkResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetStatsRequest, $0.GetStatsResponse>(
        'GetStats',
        getStats_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetStatsRequest.fromBuffer(value),
        ($0.GetStatsResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.SendReminderRequest, $0.SendReminderResponse>(
            'SendReminder',
            sendReminder_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.SendReminderRequest.fromBuffer(value),
            ($0.SendReminderResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ProcessPaymentSettlementRequest,
            $0.ProcessPaymentSettlementResponse>(
        'ProcessPaymentSettlement',
        processPaymentSettlement_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ProcessPaymentSettlementRequest.fromBuffer(value),
        ($0.ProcessPaymentSettlementResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ProcessRefundReversalRequest,
            $0.ProcessRefundReversalResponse>(
        'ProcessRefundReversal',
        processRefundReversal_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ProcessRefundReversalRequest.fromBuffer(value),
        ($0.ProcessRefundReversalResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ReviewFraudCaseRequest,
            $0.ReviewFraudCaseResponse>(
        'ReviewFraudCase',
        reviewFraudCase_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ReviewFraudCaseRequest.fromBuffer(value),
        ($0.ReviewFraudCaseResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.GetMyReferralCodeResponse> getMyReferralCode_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetMyReferralCodeRequest> $request) async {
    return getMyReferralCode($call, await $request);
  }

  $async.Future<$0.GetMyReferralCodeResponse> getMyReferralCode(
      $grpc.ServiceCall call, $0.GetMyReferralCodeRequest request);

  $async.Future<$0.GetReferralStatsResponse> getReferralStats_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetReferralStatsRequest> $request) async {
    return getReferralStats($call, await $request);
  }

  $async.Future<$0.GetReferralStatsResponse> getReferralStats(
      $grpc.ServiceCall call, $0.GetReferralStatsRequest request);

  $async.Future<$0.ListReferralsResponse> listReferrals_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListReferralsRequest> $request) async {
    return listReferrals($call, await $request);
  }

  $async.Future<$0.ListReferralsResponse> listReferrals(
      $grpc.ServiceCall call, $0.ListReferralsRequest request);

  $async.Future<$0.ClaimRewardResponse> claimReward_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ClaimRewardRequest> $request) async {
    return claimReward($call, await $request);
  }

  $async.Future<$0.ClaimRewardResponse> claimReward(
      $grpc.ServiceCall call, $0.ClaimRewardRequest request);

  $async.Future<$0.ValidateCodeResponse> validateCode_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ValidateCodeRequest> $request) async {
    return validateCode($call, await $request);
  }

  $async.Future<$0.ValidateCodeResponse> validateCode(
      $grpc.ServiceCall call, $0.ValidateCodeRequest request);

  $async.Future<$0.GetDashboardResponse> getDashboard_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetDashboardRequest> $request) async {
    return getDashboard($call, await $request);
  }

  $async.Future<$0.GetDashboardResponse> getDashboard(
      $grpc.ServiceCall call, $0.GetDashboardRequest request);

  $async.Future<$0.GetReferralLinkResponse> getReferralLink_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetReferralLinkRequest> $request) async {
    return getReferralLink($call, await $request);
  }

  $async.Future<$0.GetReferralLinkResponse> getReferralLink(
      $grpc.ServiceCall call, $0.GetReferralLinkRequest request);

  $async.Future<$0.GetStatsResponse> getStats_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetStatsRequest> $request) async {
    return getStats($call, await $request);
  }

  $async.Future<$0.GetStatsResponse> getStats(
      $grpc.ServiceCall call, $0.GetStatsRequest request);

  $async.Future<$0.SendReminderResponse> sendReminder_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SendReminderRequest> $request) async {
    return sendReminder($call, await $request);
  }

  $async.Future<$0.SendReminderResponse> sendReminder(
      $grpc.ServiceCall call, $0.SendReminderRequest request);

  $async.Future<$0.ProcessPaymentSettlementResponse>
      processPaymentSettlement_Pre($grpc.ServiceCall $call,
          $async.Future<$0.ProcessPaymentSettlementRequest> $request) async {
    return processPaymentSettlement($call, await $request);
  }

  $async.Future<$0.ProcessPaymentSettlementResponse> processPaymentSettlement(
      $grpc.ServiceCall call, $0.ProcessPaymentSettlementRequest request);

  $async.Future<$0.ProcessRefundReversalResponse> processRefundReversal_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ProcessRefundReversalRequest> $request) async {
    return processRefundReversal($call, await $request);
  }

  $async.Future<$0.ProcessRefundReversalResponse> processRefundReversal(
      $grpc.ServiceCall call, $0.ProcessRefundReversalRequest request);

  $async.Future<$0.ReviewFraudCaseResponse> reviewFraudCase_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ReviewFraudCaseRequest> $request) async {
    return reviewFraudCase($call, await $request);
  }

  $async.Future<$0.ReviewFraudCaseResponse> reviewFraudCase(
      $grpc.ServiceCall call, $0.ReviewFraudCaseRequest request);
}

@$pb.GrpcServiceName('creativanta.platform.v1.PromotionalService')
class PromotionalServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  PromotionalServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.RedeemPromoCodeResponse> redeemPromoCode(
    $0.RedeemPromoCodeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$redeemPromoCode, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetActivePromotionsResponse> getActivePromotions(
    $0.GetActivePromotionsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getActivePromotions, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetPromotionDetailResponse> getPromotionDetail(
    $0.GetPromotionDetailRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getPromotionDetail, request, options: options);
  }

  // method descriptors

  static final _$redeemPromoCode =
      $grpc.ClientMethod<$0.RedeemPromoCodeRequest, $0.RedeemPromoCodeResponse>(
          '/creativanta.platform.v1.PromotionalService/RedeemPromoCode',
          ($0.RedeemPromoCodeRequest value) => value.writeToBuffer(),
          $0.RedeemPromoCodeResponse.fromBuffer);
  static final _$getActivePromotions = $grpc.ClientMethod<
          $0.GetActivePromotionsRequest, $0.GetActivePromotionsResponse>(
      '/creativanta.platform.v1.PromotionalService/GetActivePromotions',
      ($0.GetActivePromotionsRequest value) => value.writeToBuffer(),
      $0.GetActivePromotionsResponse.fromBuffer);
  static final _$getPromotionDetail = $grpc.ClientMethod<
          $0.GetPromotionDetailRequest, $0.GetPromotionDetailResponse>(
      '/creativanta.platform.v1.PromotionalService/GetPromotionDetail',
      ($0.GetPromotionDetailRequest value) => value.writeToBuffer(),
      $0.GetPromotionDetailResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.platform.v1.PromotionalService')
abstract class PromotionalServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.platform.v1.PromotionalService';

  PromotionalServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.RedeemPromoCodeRequest,
            $0.RedeemPromoCodeResponse>(
        'RedeemPromoCode',
        redeemPromoCode_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RedeemPromoCodeRequest.fromBuffer(value),
        ($0.RedeemPromoCodeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetActivePromotionsRequest,
            $0.GetActivePromotionsResponse>(
        'GetActivePromotions',
        getActivePromotions_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetActivePromotionsRequest.fromBuffer(value),
        ($0.GetActivePromotionsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetPromotionDetailRequest,
            $0.GetPromotionDetailResponse>(
        'GetPromotionDetail',
        getPromotionDetail_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetPromotionDetailRequest.fromBuffer(value),
        ($0.GetPromotionDetailResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.RedeemPromoCodeResponse> redeemPromoCode_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RedeemPromoCodeRequest> $request) async {
    return redeemPromoCode($call, await $request);
  }

  $async.Future<$0.RedeemPromoCodeResponse> redeemPromoCode(
      $grpc.ServiceCall call, $0.RedeemPromoCodeRequest request);

  $async.Future<$0.GetActivePromotionsResponse> getActivePromotions_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetActivePromotionsRequest> $request) async {
    return getActivePromotions($call, await $request);
  }

  $async.Future<$0.GetActivePromotionsResponse> getActivePromotions(
      $grpc.ServiceCall call, $0.GetActivePromotionsRequest request);

  $async.Future<$0.GetPromotionDetailResponse> getPromotionDetail_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetPromotionDetailRequest> $request) async {
    return getPromotionDetail($call, await $request);
  }

  $async.Future<$0.GetPromotionDetailResponse> getPromotionDetail(
      $grpc.ServiceCall call, $0.GetPromotionDetailRequest request);
}
