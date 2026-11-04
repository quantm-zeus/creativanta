// This is a generated file - do not edit.
//
// Generated from creativanta/admin/v1/billing.proto.

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

import 'billing.pb.dart' as $0;

export 'billing.pb.dart';

@$pb.GrpcServiceName('creativanta.admin.v1.AdminBillingService')
class AdminBillingServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  AdminBillingServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.GetBillingSummaryResponse> getBillingSummary(
    $0.GetBillingSummaryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getBillingSummary, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListSubscriptionsResponse> listSubscriptions(
    $0.ListSubscriptionsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listSubscriptions, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetCreditBalanceResponse> getCreditBalance(
    $0.GetCreditBalanceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getCreditBalance, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetCreditLedgerResponse> getCreditLedger(
    $0.GetCreditLedgerRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getCreditLedger, request, options: options);
  }

  $grpc.ResponseFuture<$0.PurchaseCreditsResponse> purchaseCredits(
    $0.PurchaseCreditsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$purchaseCredits, request, options: options);
  }

  $grpc.ResponseFuture<$0.ChangePlanResponse> changePlan(
    $0.ChangePlanRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$changePlan, request, options: options);
  }

  $grpc.ResponseFuture<$0.CancelSubscriptionResponse> cancelSubscription(
    $0.CancelSubscriptionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$cancelSubscription, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetUsageReportResponse> getUsageReport(
    $0.GetUsageReportRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getUsageReport, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetInvoiceHistoryResponse> getInvoiceHistory(
    $0.GetInvoiceHistoryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getInvoiceHistory, request, options: options);
  }

  $grpc.ResponseFuture<$0.DownloadInvoiceResponse> downloadInvoice(
    $0.DownloadInvoiceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$downloadInvoice, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdatePaymentMethodResponse> updatePaymentMethod(
    $0.UpdatePaymentMethodRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updatePaymentMethod, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetPaymentMethodResponse> getPaymentMethod(
    $0.GetPaymentMethodRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getPaymentMethod, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListBillingEventsResponse> listBillingEvents(
    $0.ListBillingEventsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listBillingEvents, request, options: options);
  }

  $grpc.ResponseFuture<$0.EstimateCostResponse> estimateCost(
    $0.EstimateCostRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$estimateCost, request, options: options);
  }

  // method descriptors

  static final _$getBillingSummary = $grpc.ClientMethod<
          $0.GetBillingSummaryRequest, $0.GetBillingSummaryResponse>(
      '/creativanta.admin.v1.AdminBillingService/GetBillingSummary',
      ($0.GetBillingSummaryRequest value) => value.writeToBuffer(),
      $0.GetBillingSummaryResponse.fromBuffer);
  static final _$listSubscriptions = $grpc.ClientMethod<
          $0.ListSubscriptionsRequest, $0.ListSubscriptionsResponse>(
      '/creativanta.admin.v1.AdminBillingService/ListSubscriptions',
      ($0.ListSubscriptionsRequest value) => value.writeToBuffer(),
      $0.ListSubscriptionsResponse.fromBuffer);
  static final _$getCreditBalance = $grpc.ClientMethod<
          $0.GetCreditBalanceRequest, $0.GetCreditBalanceResponse>(
      '/creativanta.admin.v1.AdminBillingService/GetCreditBalance',
      ($0.GetCreditBalanceRequest value) => value.writeToBuffer(),
      $0.GetCreditBalanceResponse.fromBuffer);
  static final _$getCreditLedger =
      $grpc.ClientMethod<$0.GetCreditLedgerRequest, $0.GetCreditLedgerResponse>(
          '/creativanta.admin.v1.AdminBillingService/GetCreditLedger',
          ($0.GetCreditLedgerRequest value) => value.writeToBuffer(),
          $0.GetCreditLedgerResponse.fromBuffer);
  static final _$purchaseCredits =
      $grpc.ClientMethod<$0.PurchaseCreditsRequest, $0.PurchaseCreditsResponse>(
          '/creativanta.admin.v1.AdminBillingService/PurchaseCredits',
          ($0.PurchaseCreditsRequest value) => value.writeToBuffer(),
          $0.PurchaseCreditsResponse.fromBuffer);
  static final _$changePlan =
      $grpc.ClientMethod<$0.ChangePlanRequest, $0.ChangePlanResponse>(
          '/creativanta.admin.v1.AdminBillingService/ChangePlan',
          ($0.ChangePlanRequest value) => value.writeToBuffer(),
          $0.ChangePlanResponse.fromBuffer);
  static final _$cancelSubscription = $grpc.ClientMethod<
          $0.CancelSubscriptionRequest, $0.CancelSubscriptionResponse>(
      '/creativanta.admin.v1.AdminBillingService/CancelSubscription',
      ($0.CancelSubscriptionRequest value) => value.writeToBuffer(),
      $0.CancelSubscriptionResponse.fromBuffer);
  static final _$getUsageReport =
      $grpc.ClientMethod<$0.GetUsageReportRequest, $0.GetUsageReportResponse>(
          '/creativanta.admin.v1.AdminBillingService/GetUsageReport',
          ($0.GetUsageReportRequest value) => value.writeToBuffer(),
          $0.GetUsageReportResponse.fromBuffer);
  static final _$getInvoiceHistory = $grpc.ClientMethod<
          $0.GetInvoiceHistoryRequest, $0.GetInvoiceHistoryResponse>(
      '/creativanta.admin.v1.AdminBillingService/GetInvoiceHistory',
      ($0.GetInvoiceHistoryRequest value) => value.writeToBuffer(),
      $0.GetInvoiceHistoryResponse.fromBuffer);
  static final _$downloadInvoice =
      $grpc.ClientMethod<$0.DownloadInvoiceRequest, $0.DownloadInvoiceResponse>(
          '/creativanta.admin.v1.AdminBillingService/DownloadInvoice',
          ($0.DownloadInvoiceRequest value) => value.writeToBuffer(),
          $0.DownloadInvoiceResponse.fromBuffer);
  static final _$updatePaymentMethod = $grpc.ClientMethod<
          $0.UpdatePaymentMethodRequest, $0.UpdatePaymentMethodResponse>(
      '/creativanta.admin.v1.AdminBillingService/UpdatePaymentMethod',
      ($0.UpdatePaymentMethodRequest value) => value.writeToBuffer(),
      $0.UpdatePaymentMethodResponse.fromBuffer);
  static final _$getPaymentMethod = $grpc.ClientMethod<
          $0.GetPaymentMethodRequest, $0.GetPaymentMethodResponse>(
      '/creativanta.admin.v1.AdminBillingService/GetPaymentMethod',
      ($0.GetPaymentMethodRequest value) => value.writeToBuffer(),
      $0.GetPaymentMethodResponse.fromBuffer);
  static final _$listBillingEvents = $grpc.ClientMethod<
          $0.ListBillingEventsRequest, $0.ListBillingEventsResponse>(
      '/creativanta.admin.v1.AdminBillingService/ListBillingEvents',
      ($0.ListBillingEventsRequest value) => value.writeToBuffer(),
      $0.ListBillingEventsResponse.fromBuffer);
  static final _$estimateCost =
      $grpc.ClientMethod<$0.EstimateCostRequest, $0.EstimateCostResponse>(
          '/creativanta.admin.v1.AdminBillingService/EstimateCost',
          ($0.EstimateCostRequest value) => value.writeToBuffer(),
          $0.EstimateCostResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.admin.v1.AdminBillingService')
abstract class AdminBillingServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.admin.v1.AdminBillingService';

  AdminBillingServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetBillingSummaryRequest,
            $0.GetBillingSummaryResponse>(
        'GetBillingSummary',
        getBillingSummary_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetBillingSummaryRequest.fromBuffer(value),
        ($0.GetBillingSummaryResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListSubscriptionsRequest,
            $0.ListSubscriptionsResponse>(
        'ListSubscriptions',
        listSubscriptions_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListSubscriptionsRequest.fromBuffer(value),
        ($0.ListSubscriptionsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetCreditBalanceRequest,
            $0.GetCreditBalanceResponse>(
        'GetCreditBalance',
        getCreditBalance_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetCreditBalanceRequest.fromBuffer(value),
        ($0.GetCreditBalanceResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetCreditLedgerRequest,
            $0.GetCreditLedgerResponse>(
        'GetCreditLedger',
        getCreditLedger_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetCreditLedgerRequest.fromBuffer(value),
        ($0.GetCreditLedgerResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PurchaseCreditsRequest,
            $0.PurchaseCreditsResponse>(
        'PurchaseCredits',
        purchaseCredits_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.PurchaseCreditsRequest.fromBuffer(value),
        ($0.PurchaseCreditsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ChangePlanRequest, $0.ChangePlanResponse>(
        'ChangePlan',
        changePlan_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ChangePlanRequest.fromBuffer(value),
        ($0.ChangePlanResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CancelSubscriptionRequest,
            $0.CancelSubscriptionResponse>(
        'CancelSubscription',
        cancelSubscription_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CancelSubscriptionRequest.fromBuffer(value),
        ($0.CancelSubscriptionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetUsageReportRequest,
            $0.GetUsageReportResponse>(
        'GetUsageReport',
        getUsageReport_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetUsageReportRequest.fromBuffer(value),
        ($0.GetUsageReportResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetInvoiceHistoryRequest,
            $0.GetInvoiceHistoryResponse>(
        'GetInvoiceHistory',
        getInvoiceHistory_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetInvoiceHistoryRequest.fromBuffer(value),
        ($0.GetInvoiceHistoryResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DownloadInvoiceRequest,
            $0.DownloadInvoiceResponse>(
        'DownloadInvoice',
        downloadInvoice_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.DownloadInvoiceRequest.fromBuffer(value),
        ($0.DownloadInvoiceResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdatePaymentMethodRequest,
            $0.UpdatePaymentMethodResponse>(
        'UpdatePaymentMethod',
        updatePaymentMethod_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdatePaymentMethodRequest.fromBuffer(value),
        ($0.UpdatePaymentMethodResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetPaymentMethodRequest,
            $0.GetPaymentMethodResponse>(
        'GetPaymentMethod',
        getPaymentMethod_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetPaymentMethodRequest.fromBuffer(value),
        ($0.GetPaymentMethodResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListBillingEventsRequest,
            $0.ListBillingEventsResponse>(
        'ListBillingEvents',
        listBillingEvents_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListBillingEventsRequest.fromBuffer(value),
        ($0.ListBillingEventsResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.EstimateCostRequest, $0.EstimateCostResponse>(
            'EstimateCost',
            estimateCost_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.EstimateCostRequest.fromBuffer(value),
            ($0.EstimateCostResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.GetBillingSummaryResponse> getBillingSummary_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetBillingSummaryRequest> $request) async {
    return getBillingSummary($call, await $request);
  }

  $async.Future<$0.GetBillingSummaryResponse> getBillingSummary(
      $grpc.ServiceCall call, $0.GetBillingSummaryRequest request);

  $async.Future<$0.ListSubscriptionsResponse> listSubscriptions_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListSubscriptionsRequest> $request) async {
    return listSubscriptions($call, await $request);
  }

  $async.Future<$0.ListSubscriptionsResponse> listSubscriptions(
      $grpc.ServiceCall call, $0.ListSubscriptionsRequest request);

  $async.Future<$0.GetCreditBalanceResponse> getCreditBalance_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetCreditBalanceRequest> $request) async {
    return getCreditBalance($call, await $request);
  }

  $async.Future<$0.GetCreditBalanceResponse> getCreditBalance(
      $grpc.ServiceCall call, $0.GetCreditBalanceRequest request);

  $async.Future<$0.GetCreditLedgerResponse> getCreditLedger_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetCreditLedgerRequest> $request) async {
    return getCreditLedger($call, await $request);
  }

  $async.Future<$0.GetCreditLedgerResponse> getCreditLedger(
      $grpc.ServiceCall call, $0.GetCreditLedgerRequest request);

  $async.Future<$0.PurchaseCreditsResponse> purchaseCredits_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.PurchaseCreditsRequest> $request) async {
    return purchaseCredits($call, await $request);
  }

  $async.Future<$0.PurchaseCreditsResponse> purchaseCredits(
      $grpc.ServiceCall call, $0.PurchaseCreditsRequest request);

  $async.Future<$0.ChangePlanResponse> changePlan_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ChangePlanRequest> $request) async {
    return changePlan($call, await $request);
  }

  $async.Future<$0.ChangePlanResponse> changePlan(
      $grpc.ServiceCall call, $0.ChangePlanRequest request);

  $async.Future<$0.CancelSubscriptionResponse> cancelSubscription_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CancelSubscriptionRequest> $request) async {
    return cancelSubscription($call, await $request);
  }

  $async.Future<$0.CancelSubscriptionResponse> cancelSubscription(
      $grpc.ServiceCall call, $0.CancelSubscriptionRequest request);

  $async.Future<$0.GetUsageReportResponse> getUsageReport_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetUsageReportRequest> $request) async {
    return getUsageReport($call, await $request);
  }

  $async.Future<$0.GetUsageReportResponse> getUsageReport(
      $grpc.ServiceCall call, $0.GetUsageReportRequest request);

  $async.Future<$0.GetInvoiceHistoryResponse> getInvoiceHistory_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetInvoiceHistoryRequest> $request) async {
    return getInvoiceHistory($call, await $request);
  }

  $async.Future<$0.GetInvoiceHistoryResponse> getInvoiceHistory(
      $grpc.ServiceCall call, $0.GetInvoiceHistoryRequest request);

  $async.Future<$0.DownloadInvoiceResponse> downloadInvoice_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.DownloadInvoiceRequest> $request) async {
    return downloadInvoice($call, await $request);
  }

  $async.Future<$0.DownloadInvoiceResponse> downloadInvoice(
      $grpc.ServiceCall call, $0.DownloadInvoiceRequest request);

  $async.Future<$0.UpdatePaymentMethodResponse> updatePaymentMethod_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UpdatePaymentMethodRequest> $request) async {
    return updatePaymentMethod($call, await $request);
  }

  $async.Future<$0.UpdatePaymentMethodResponse> updatePaymentMethod(
      $grpc.ServiceCall call, $0.UpdatePaymentMethodRequest request);

  $async.Future<$0.GetPaymentMethodResponse> getPaymentMethod_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetPaymentMethodRequest> $request) async {
    return getPaymentMethod($call, await $request);
  }

  $async.Future<$0.GetPaymentMethodResponse> getPaymentMethod(
      $grpc.ServiceCall call, $0.GetPaymentMethodRequest request);

  $async.Future<$0.ListBillingEventsResponse> listBillingEvents_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListBillingEventsRequest> $request) async {
    return listBillingEvents($call, await $request);
  }

  $async.Future<$0.ListBillingEventsResponse> listBillingEvents(
      $grpc.ServiceCall call, $0.ListBillingEventsRequest request);

  $async.Future<$0.EstimateCostResponse> estimateCost_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.EstimateCostRequest> $request) async {
    return estimateCost($call, await $request);
  }

  $async.Future<$0.EstimateCostResponse> estimateCost(
      $grpc.ServiceCall call, $0.EstimateCostRequest request);
}

@$pb.GrpcServiceName('creativanta.admin.v1.DataService')
class DataServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  DataServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.RequestExportResponse> requestExport(
    $0.RequestExportRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$requestExport, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetExportUrlResponse> getExportUrl(
    $0.GetExportUrlRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getExportUrl, request, options: options);
  }

  // method descriptors

  static final _$requestExport =
      $grpc.ClientMethod<$0.RequestExportRequest, $0.RequestExportResponse>(
          '/creativanta.admin.v1.DataService/RequestExport',
          ($0.RequestExportRequest value) => value.writeToBuffer(),
          $0.RequestExportResponse.fromBuffer);
  static final _$getExportUrl =
      $grpc.ClientMethod<$0.GetExportUrlRequest, $0.GetExportUrlResponse>(
          '/creativanta.admin.v1.DataService/GetExportUrl',
          ($0.GetExportUrlRequest value) => value.writeToBuffer(),
          $0.GetExportUrlResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.admin.v1.DataService')
abstract class DataServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.admin.v1.DataService';

  DataServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.RequestExportRequest, $0.RequestExportResponse>(
            'RequestExport',
            requestExport_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.RequestExportRequest.fromBuffer(value),
            ($0.RequestExportResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetExportUrlRequest, $0.GetExportUrlResponse>(
            'GetExportUrl',
            getExportUrl_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetExportUrlRequest.fromBuffer(value),
            ($0.GetExportUrlResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.RequestExportResponse> requestExport_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RequestExportRequest> $request) async {
    return requestExport($call, await $request);
  }

  $async.Future<$0.RequestExportResponse> requestExport(
      $grpc.ServiceCall call, $0.RequestExportRequest request);

  $async.Future<$0.GetExportUrlResponse> getExportUrl_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetExportUrlRequest> $request) async {
    return getExportUrl($call, await $request);
  }

  $async.Future<$0.GetExportUrlResponse> getExportUrl(
      $grpc.ServiceCall call, $0.GetExportUrlRequest request);
}

@$pb.GrpcServiceName('creativanta.admin.v1.CreditService')
class CreditServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  CreditServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.GetBalanceResponse> getBalance(
    $0.GetBalanceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getBalance, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetUsageStatsResponse> getUsageStats(
    $0.GetUsageStatsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getUsageStats, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetMonthlyUsageResponse> getMonthlyUsage(
    $0.GetMonthlyUsageRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getMonthlyUsage, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListTransactionsResponse> listTransactions(
    $0.ListTransactionsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listTransactions, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListRecentUsageResponse> listRecentUsage(
    $0.ListRecentUsageRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listRecentUsage, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListPackagesResponse> listPackages(
    $0.ListPackagesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listPackages, request, options: options);
  }

  $grpc.ResponseFuture<$0.PurchaseResponse> purchase(
    $0.PurchaseRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$purchase, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetAutoRefillConfigResponse> getAutoRefillConfig(
    $0.GetAutoRefillConfigRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getAutoRefillConfig, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdateAutoRefillResponse> updateAutoRefill(
    $0.UpdateAutoRefillRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateAutoRefill, request, options: options);
  }

  // method descriptors

  static final _$getBalance =
      $grpc.ClientMethod<$0.GetBalanceRequest, $0.GetBalanceResponse>(
          '/creativanta.admin.v1.CreditService/GetBalance',
          ($0.GetBalanceRequest value) => value.writeToBuffer(),
          $0.GetBalanceResponse.fromBuffer);
  static final _$getUsageStats =
      $grpc.ClientMethod<$0.GetUsageStatsRequest, $0.GetUsageStatsResponse>(
          '/creativanta.admin.v1.CreditService/GetUsageStats',
          ($0.GetUsageStatsRequest value) => value.writeToBuffer(),
          $0.GetUsageStatsResponse.fromBuffer);
  static final _$getMonthlyUsage =
      $grpc.ClientMethod<$0.GetMonthlyUsageRequest, $0.GetMonthlyUsageResponse>(
          '/creativanta.admin.v1.CreditService/GetMonthlyUsage',
          ($0.GetMonthlyUsageRequest value) => value.writeToBuffer(),
          $0.GetMonthlyUsageResponse.fromBuffer);
  static final _$listTransactions = $grpc.ClientMethod<
          $0.ListTransactionsRequest, $0.ListTransactionsResponse>(
      '/creativanta.admin.v1.CreditService/ListTransactions',
      ($0.ListTransactionsRequest value) => value.writeToBuffer(),
      $0.ListTransactionsResponse.fromBuffer);
  static final _$listRecentUsage =
      $grpc.ClientMethod<$0.ListRecentUsageRequest, $0.ListRecentUsageResponse>(
          '/creativanta.admin.v1.CreditService/ListRecentUsage',
          ($0.ListRecentUsageRequest value) => value.writeToBuffer(),
          $0.ListRecentUsageResponse.fromBuffer);
  static final _$listPackages =
      $grpc.ClientMethod<$0.ListPackagesRequest, $0.ListPackagesResponse>(
          '/creativanta.admin.v1.CreditService/ListPackages',
          ($0.ListPackagesRequest value) => value.writeToBuffer(),
          $0.ListPackagesResponse.fromBuffer);
  static final _$purchase =
      $grpc.ClientMethod<$0.PurchaseRequest, $0.PurchaseResponse>(
          '/creativanta.admin.v1.CreditService/Purchase',
          ($0.PurchaseRequest value) => value.writeToBuffer(),
          $0.PurchaseResponse.fromBuffer);
  static final _$getAutoRefillConfig = $grpc.ClientMethod<
          $0.GetAutoRefillConfigRequest, $0.GetAutoRefillConfigResponse>(
      '/creativanta.admin.v1.CreditService/GetAutoRefillConfig',
      ($0.GetAutoRefillConfigRequest value) => value.writeToBuffer(),
      $0.GetAutoRefillConfigResponse.fromBuffer);
  static final _$updateAutoRefill = $grpc.ClientMethod<
          $0.UpdateAutoRefillRequest, $0.UpdateAutoRefillResponse>(
      '/creativanta.admin.v1.CreditService/UpdateAutoRefill',
      ($0.UpdateAutoRefillRequest value) => value.writeToBuffer(),
      $0.UpdateAutoRefillResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.admin.v1.CreditService')
abstract class CreditServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.admin.v1.CreditService';

  CreditServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetBalanceRequest, $0.GetBalanceResponse>(
        'GetBalance',
        getBalance_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetBalanceRequest.fromBuffer(value),
        ($0.GetBalanceResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetUsageStatsRequest, $0.GetUsageStatsResponse>(
            'GetUsageStats',
            getUsageStats_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetUsageStatsRequest.fromBuffer(value),
            ($0.GetUsageStatsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetMonthlyUsageRequest,
            $0.GetMonthlyUsageResponse>(
        'GetMonthlyUsage',
        getMonthlyUsage_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetMonthlyUsageRequest.fromBuffer(value),
        ($0.GetMonthlyUsageResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListTransactionsRequest,
            $0.ListTransactionsResponse>(
        'ListTransactions',
        listTransactions_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListTransactionsRequest.fromBuffer(value),
        ($0.ListTransactionsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListRecentUsageRequest,
            $0.ListRecentUsageResponse>(
        'ListRecentUsage',
        listRecentUsage_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListRecentUsageRequest.fromBuffer(value),
        ($0.ListRecentUsageResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListPackagesRequest, $0.ListPackagesResponse>(
            'ListPackages',
            listPackages_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListPackagesRequest.fromBuffer(value),
            ($0.ListPackagesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PurchaseRequest, $0.PurchaseResponse>(
        'Purchase',
        purchase_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.PurchaseRequest.fromBuffer(value),
        ($0.PurchaseResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetAutoRefillConfigRequest,
            $0.GetAutoRefillConfigResponse>(
        'GetAutoRefillConfig',
        getAutoRefillConfig_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetAutoRefillConfigRequest.fromBuffer(value),
        ($0.GetAutoRefillConfigResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateAutoRefillRequest,
            $0.UpdateAutoRefillResponse>(
        'UpdateAutoRefill',
        updateAutoRefill_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateAutoRefillRequest.fromBuffer(value),
        ($0.UpdateAutoRefillResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.GetBalanceResponse> getBalance_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetBalanceRequest> $request) async {
    return getBalance($call, await $request);
  }

  $async.Future<$0.GetBalanceResponse> getBalance(
      $grpc.ServiceCall call, $0.GetBalanceRequest request);

  $async.Future<$0.GetUsageStatsResponse> getUsageStats_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetUsageStatsRequest> $request) async {
    return getUsageStats($call, await $request);
  }

  $async.Future<$0.GetUsageStatsResponse> getUsageStats(
      $grpc.ServiceCall call, $0.GetUsageStatsRequest request);

  $async.Future<$0.GetMonthlyUsageResponse> getMonthlyUsage_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetMonthlyUsageRequest> $request) async {
    return getMonthlyUsage($call, await $request);
  }

  $async.Future<$0.GetMonthlyUsageResponse> getMonthlyUsage(
      $grpc.ServiceCall call, $0.GetMonthlyUsageRequest request);

  $async.Future<$0.ListTransactionsResponse> listTransactions_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListTransactionsRequest> $request) async {
    return listTransactions($call, await $request);
  }

  $async.Future<$0.ListTransactionsResponse> listTransactions(
      $grpc.ServiceCall call, $0.ListTransactionsRequest request);

  $async.Future<$0.ListRecentUsageResponse> listRecentUsage_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListRecentUsageRequest> $request) async {
    return listRecentUsage($call, await $request);
  }

  $async.Future<$0.ListRecentUsageResponse> listRecentUsage(
      $grpc.ServiceCall call, $0.ListRecentUsageRequest request);

  $async.Future<$0.ListPackagesResponse> listPackages_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListPackagesRequest> $request) async {
    return listPackages($call, await $request);
  }

  $async.Future<$0.ListPackagesResponse> listPackages(
      $grpc.ServiceCall call, $0.ListPackagesRequest request);

  $async.Future<$0.PurchaseResponse> purchase_Pre($grpc.ServiceCall $call,
      $async.Future<$0.PurchaseRequest> $request) async {
    return purchase($call, await $request);
  }

  $async.Future<$0.PurchaseResponse> purchase(
      $grpc.ServiceCall call, $0.PurchaseRequest request);

  $async.Future<$0.GetAutoRefillConfigResponse> getAutoRefillConfig_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetAutoRefillConfigRequest> $request) async {
    return getAutoRefillConfig($call, await $request);
  }

  $async.Future<$0.GetAutoRefillConfigResponse> getAutoRefillConfig(
      $grpc.ServiceCall call, $0.GetAutoRefillConfigRequest request);

  $async.Future<$0.UpdateAutoRefillResponse> updateAutoRefill_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UpdateAutoRefillRequest> $request) async {
    return updateAutoRefill($call, await $request);
  }

  $async.Future<$0.UpdateAutoRefillResponse> updateAutoRefill(
      $grpc.ServiceCall call, $0.UpdateAutoRefillRequest request);
}

@$pb.GrpcServiceName('creativanta.admin.v1.BillingService')
class BillingServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  BillingServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.GetCurrentPlanResponse> getCurrentPlan(
    $0.GetCurrentPlanRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getCurrentPlan, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListPlansResponse> listPlans(
    $0.ListPlansRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listPlans, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetSubscriptionResponse> getSubscription(
    $0.GetSubscriptionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getSubscription, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetPaymentMethodsResponse> getPaymentMethods(
    $0.GetPaymentMethodsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getPaymentMethods, request, options: options);
  }

  $grpc.ResponseFuture<$0.CancelPlanResponse> cancelPlan(
    $0.CancelPlanRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$cancelPlan, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListInvoicesResponse> listInvoices(
    $0.ListInvoicesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listInvoices, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetInvoiceUrlResponse> getInvoiceUrl(
    $0.GetInvoiceUrlRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getInvoiceUrl, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetCheckoutStatusResponse> getCheckoutStatus(
    $0.GetCheckoutStatusRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getCheckoutStatus, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListCreditPackagesResponse> listCreditPackages(
    $0.ListCreditPackagesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listCreditPackages, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListCreditPurchasesResponse> listCreditPurchases(
    $0.ListCreditPurchasesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listCreditPurchases, request, options: options);
  }

  $grpc.ResponseFuture<$0.ApplyRetentionDiscountResponse>
      applyRetentionDiscount(
    $0.ApplyRetentionDiscountRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$applyRetentionDiscount, request,
        options: options);
  }

  // method descriptors

  static final _$getCurrentPlan =
      $grpc.ClientMethod<$0.GetCurrentPlanRequest, $0.GetCurrentPlanResponse>(
          '/creativanta.admin.v1.BillingService/GetCurrentPlan',
          ($0.GetCurrentPlanRequest value) => value.writeToBuffer(),
          $0.GetCurrentPlanResponse.fromBuffer);
  static final _$listPlans =
      $grpc.ClientMethod<$0.ListPlansRequest, $0.ListPlansResponse>(
          '/creativanta.admin.v1.BillingService/ListPlans',
          ($0.ListPlansRequest value) => value.writeToBuffer(),
          $0.ListPlansResponse.fromBuffer);
  static final _$getSubscription =
      $grpc.ClientMethod<$0.GetSubscriptionRequest, $0.GetSubscriptionResponse>(
          '/creativanta.admin.v1.BillingService/GetSubscription',
          ($0.GetSubscriptionRequest value) => value.writeToBuffer(),
          $0.GetSubscriptionResponse.fromBuffer);
  static final _$getPaymentMethods = $grpc.ClientMethod<
          $0.GetPaymentMethodsRequest, $0.GetPaymentMethodsResponse>(
      '/creativanta.admin.v1.BillingService/GetPaymentMethods',
      ($0.GetPaymentMethodsRequest value) => value.writeToBuffer(),
      $0.GetPaymentMethodsResponse.fromBuffer);
  static final _$cancelPlan =
      $grpc.ClientMethod<$0.CancelPlanRequest, $0.CancelPlanResponse>(
          '/creativanta.admin.v1.BillingService/CancelPlan',
          ($0.CancelPlanRequest value) => value.writeToBuffer(),
          $0.CancelPlanResponse.fromBuffer);
  static final _$listInvoices =
      $grpc.ClientMethod<$0.ListInvoicesRequest, $0.ListInvoicesResponse>(
          '/creativanta.admin.v1.BillingService/ListInvoices',
          ($0.ListInvoicesRequest value) => value.writeToBuffer(),
          $0.ListInvoicesResponse.fromBuffer);
  static final _$getInvoiceUrl =
      $grpc.ClientMethod<$0.GetInvoiceUrlRequest, $0.GetInvoiceUrlResponse>(
          '/creativanta.admin.v1.BillingService/GetInvoiceUrl',
          ($0.GetInvoiceUrlRequest value) => value.writeToBuffer(),
          $0.GetInvoiceUrlResponse.fromBuffer);
  static final _$getCheckoutStatus = $grpc.ClientMethod<
          $0.GetCheckoutStatusRequest, $0.GetCheckoutStatusResponse>(
      '/creativanta.admin.v1.BillingService/GetCheckoutStatus',
      ($0.GetCheckoutStatusRequest value) => value.writeToBuffer(),
      $0.GetCheckoutStatusResponse.fromBuffer);
  static final _$listCreditPackages = $grpc.ClientMethod<
          $0.ListCreditPackagesRequest, $0.ListCreditPackagesResponse>(
      '/creativanta.admin.v1.BillingService/ListCreditPackages',
      ($0.ListCreditPackagesRequest value) => value.writeToBuffer(),
      $0.ListCreditPackagesResponse.fromBuffer);
  static final _$listCreditPurchases = $grpc.ClientMethod<
          $0.ListCreditPurchasesRequest, $0.ListCreditPurchasesResponse>(
      '/creativanta.admin.v1.BillingService/ListCreditPurchases',
      ($0.ListCreditPurchasesRequest value) => value.writeToBuffer(),
      $0.ListCreditPurchasesResponse.fromBuffer);
  static final _$applyRetentionDiscount = $grpc.ClientMethod<
          $0.ApplyRetentionDiscountRequest, $0.ApplyRetentionDiscountResponse>(
      '/creativanta.admin.v1.BillingService/ApplyRetentionDiscount',
      ($0.ApplyRetentionDiscountRequest value) => value.writeToBuffer(),
      $0.ApplyRetentionDiscountResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.admin.v1.BillingService')
abstract class BillingServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.admin.v1.BillingService';

  BillingServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetCurrentPlanRequest,
            $0.GetCurrentPlanResponse>(
        'GetCurrentPlan',
        getCurrentPlan_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetCurrentPlanRequest.fromBuffer(value),
        ($0.GetCurrentPlanResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListPlansRequest, $0.ListPlansResponse>(
        'ListPlans',
        listPlans_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListPlansRequest.fromBuffer(value),
        ($0.ListPlansResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetSubscriptionRequest,
            $0.GetSubscriptionResponse>(
        'GetSubscription',
        getSubscription_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetSubscriptionRequest.fromBuffer(value),
        ($0.GetSubscriptionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetPaymentMethodsRequest,
            $0.GetPaymentMethodsResponse>(
        'GetPaymentMethods',
        getPaymentMethods_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetPaymentMethodsRequest.fromBuffer(value),
        ($0.GetPaymentMethodsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CancelPlanRequest, $0.CancelPlanResponse>(
        'CancelPlan',
        cancelPlan_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.CancelPlanRequest.fromBuffer(value),
        ($0.CancelPlanResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListInvoicesRequest, $0.ListInvoicesResponse>(
            'ListInvoices',
            listInvoices_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListInvoicesRequest.fromBuffer(value),
            ($0.ListInvoicesResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetInvoiceUrlRequest, $0.GetInvoiceUrlResponse>(
            'GetInvoiceUrl',
            getInvoiceUrl_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetInvoiceUrlRequest.fromBuffer(value),
            ($0.GetInvoiceUrlResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetCheckoutStatusRequest,
            $0.GetCheckoutStatusResponse>(
        'GetCheckoutStatus',
        getCheckoutStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetCheckoutStatusRequest.fromBuffer(value),
        ($0.GetCheckoutStatusResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListCreditPackagesRequest,
            $0.ListCreditPackagesResponse>(
        'ListCreditPackages',
        listCreditPackages_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListCreditPackagesRequest.fromBuffer(value),
        ($0.ListCreditPackagesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListCreditPurchasesRequest,
            $0.ListCreditPurchasesResponse>(
        'ListCreditPurchases',
        listCreditPurchases_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListCreditPurchasesRequest.fromBuffer(value),
        ($0.ListCreditPurchasesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ApplyRetentionDiscountRequest,
            $0.ApplyRetentionDiscountResponse>(
        'ApplyRetentionDiscount',
        applyRetentionDiscount_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ApplyRetentionDiscountRequest.fromBuffer(value),
        ($0.ApplyRetentionDiscountResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.GetCurrentPlanResponse> getCurrentPlan_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetCurrentPlanRequest> $request) async {
    return getCurrentPlan($call, await $request);
  }

  $async.Future<$0.GetCurrentPlanResponse> getCurrentPlan(
      $grpc.ServiceCall call, $0.GetCurrentPlanRequest request);

  $async.Future<$0.ListPlansResponse> listPlans_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListPlansRequest> $request) async {
    return listPlans($call, await $request);
  }

  $async.Future<$0.ListPlansResponse> listPlans(
      $grpc.ServiceCall call, $0.ListPlansRequest request);

  $async.Future<$0.GetSubscriptionResponse> getSubscription_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetSubscriptionRequest> $request) async {
    return getSubscription($call, await $request);
  }

  $async.Future<$0.GetSubscriptionResponse> getSubscription(
      $grpc.ServiceCall call, $0.GetSubscriptionRequest request);

  $async.Future<$0.GetPaymentMethodsResponse> getPaymentMethods_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetPaymentMethodsRequest> $request) async {
    return getPaymentMethods($call, await $request);
  }

  $async.Future<$0.GetPaymentMethodsResponse> getPaymentMethods(
      $grpc.ServiceCall call, $0.GetPaymentMethodsRequest request);

  $async.Future<$0.CancelPlanResponse> cancelPlan_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CancelPlanRequest> $request) async {
    return cancelPlan($call, await $request);
  }

  $async.Future<$0.CancelPlanResponse> cancelPlan(
      $grpc.ServiceCall call, $0.CancelPlanRequest request);

  $async.Future<$0.ListInvoicesResponse> listInvoices_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListInvoicesRequest> $request) async {
    return listInvoices($call, await $request);
  }

  $async.Future<$0.ListInvoicesResponse> listInvoices(
      $grpc.ServiceCall call, $0.ListInvoicesRequest request);

  $async.Future<$0.GetInvoiceUrlResponse> getInvoiceUrl_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetInvoiceUrlRequest> $request) async {
    return getInvoiceUrl($call, await $request);
  }

  $async.Future<$0.GetInvoiceUrlResponse> getInvoiceUrl(
      $grpc.ServiceCall call, $0.GetInvoiceUrlRequest request);

  $async.Future<$0.GetCheckoutStatusResponse> getCheckoutStatus_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetCheckoutStatusRequest> $request) async {
    return getCheckoutStatus($call, await $request);
  }

  $async.Future<$0.GetCheckoutStatusResponse> getCheckoutStatus(
      $grpc.ServiceCall call, $0.GetCheckoutStatusRequest request);

  $async.Future<$0.ListCreditPackagesResponse> listCreditPackages_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListCreditPackagesRequest> $request) async {
    return listCreditPackages($call, await $request);
  }

  $async.Future<$0.ListCreditPackagesResponse> listCreditPackages(
      $grpc.ServiceCall call, $0.ListCreditPackagesRequest request);

  $async.Future<$0.ListCreditPurchasesResponse> listCreditPurchases_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListCreditPurchasesRequest> $request) async {
    return listCreditPurchases($call, await $request);
  }

  $async.Future<$0.ListCreditPurchasesResponse> listCreditPurchases(
      $grpc.ServiceCall call, $0.ListCreditPurchasesRequest request);

  $async.Future<$0.ApplyRetentionDiscountResponse> applyRetentionDiscount_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ApplyRetentionDiscountRequest> $request) async {
    return applyRetentionDiscount($call, await $request);
  }

  $async.Future<$0.ApplyRetentionDiscountResponse> applyRetentionDiscount(
      $grpc.ServiceCall call, $0.ApplyRetentionDiscountRequest request);
}
