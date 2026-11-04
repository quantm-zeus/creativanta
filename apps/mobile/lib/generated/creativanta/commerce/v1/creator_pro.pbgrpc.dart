// This is a generated file - do not edit.
//
// Generated from creativanta/commerce/v1/creator_pro.proto.

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

import 'creator_pro.pb.dart' as $0;

export 'creator_pro.pb.dart';

@$pb.GrpcServiceName('creativanta.commerce.v1.LinkInBioService')
class LinkInBioServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  LinkInBioServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.CreatePageResponse> createPage(
    $0.CreatePageRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createPage, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetPageResponse> getPage(
    $0.GetPageRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getPage, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdatePageResponse> updatePage(
    $0.UpdatePageRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updatePage, request, options: options);
  }

  $grpc.ResponseFuture<$0.LinkInBioServiceSaveResponse> save(
    $0.LinkInBioServiceSaveRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$save, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetAnalyticsResponse> getAnalytics(
    $0.GetAnalyticsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getAnalytics, request, options: options);
  }

  $grpc.ResponseFuture<$0.LinkInBioServiceReorderResponse> reorder(
    $0.LinkInBioServiceReorderRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$reorder, request, options: options);
  }

  $grpc.ResponseFuture<$0.ToggleLinkResponse> toggleLink(
    $0.ToggleLinkRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$toggleLink, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdateThemeResponse> updateTheme(
    $0.UpdateThemeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateTheme, request, options: options);
  }

  $grpc.ResponseFuture<$0.ScanLinkResponse> scanLink(
    $0.ScanLinkRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$scanLink, request, options: options);
  }

  $grpc.ResponseFuture<$0.ReportLinkResponse> reportLink(
    $0.ReportLinkRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$reportLink, request, options: options);
  }

  $grpc.ResponseFuture<$0.VerifyCustomDomainResponse> verifyCustomDomain(
    $0.VerifyCustomDomainRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$verifyCustomDomain, request, options: options);
  }

  // method descriptors

  static final _$createPage =
      $grpc.ClientMethod<$0.CreatePageRequest, $0.CreatePageResponse>(
          '/creativanta.commerce.v1.LinkInBioService/CreatePage',
          ($0.CreatePageRequest value) => value.writeToBuffer(),
          $0.CreatePageResponse.fromBuffer);
  static final _$getPage =
      $grpc.ClientMethod<$0.GetPageRequest, $0.GetPageResponse>(
          '/creativanta.commerce.v1.LinkInBioService/GetPage',
          ($0.GetPageRequest value) => value.writeToBuffer(),
          $0.GetPageResponse.fromBuffer);
  static final _$updatePage =
      $grpc.ClientMethod<$0.UpdatePageRequest, $0.UpdatePageResponse>(
          '/creativanta.commerce.v1.LinkInBioService/UpdatePage',
          ($0.UpdatePageRequest value) => value.writeToBuffer(),
          $0.UpdatePageResponse.fromBuffer);
  static final _$save = $grpc.ClientMethod<$0.LinkInBioServiceSaveRequest,
          $0.LinkInBioServiceSaveResponse>(
      '/creativanta.commerce.v1.LinkInBioService/Save',
      ($0.LinkInBioServiceSaveRequest value) => value.writeToBuffer(),
      $0.LinkInBioServiceSaveResponse.fromBuffer);
  static final _$getAnalytics =
      $grpc.ClientMethod<$0.GetAnalyticsRequest, $0.GetAnalyticsResponse>(
          '/creativanta.commerce.v1.LinkInBioService/GetAnalytics',
          ($0.GetAnalyticsRequest value) => value.writeToBuffer(),
          $0.GetAnalyticsResponse.fromBuffer);
  static final _$reorder = $grpc.ClientMethod<$0.LinkInBioServiceReorderRequest,
          $0.LinkInBioServiceReorderResponse>(
      '/creativanta.commerce.v1.LinkInBioService/Reorder',
      ($0.LinkInBioServiceReorderRequest value) => value.writeToBuffer(),
      $0.LinkInBioServiceReorderResponse.fromBuffer);
  static final _$toggleLink =
      $grpc.ClientMethod<$0.ToggleLinkRequest, $0.ToggleLinkResponse>(
          '/creativanta.commerce.v1.LinkInBioService/ToggleLink',
          ($0.ToggleLinkRequest value) => value.writeToBuffer(),
          $0.ToggleLinkResponse.fromBuffer);
  static final _$updateTheme =
      $grpc.ClientMethod<$0.UpdateThemeRequest, $0.UpdateThemeResponse>(
          '/creativanta.commerce.v1.LinkInBioService/UpdateTheme',
          ($0.UpdateThemeRequest value) => value.writeToBuffer(),
          $0.UpdateThemeResponse.fromBuffer);
  static final _$scanLink =
      $grpc.ClientMethod<$0.ScanLinkRequest, $0.ScanLinkResponse>(
          '/creativanta.commerce.v1.LinkInBioService/ScanLink',
          ($0.ScanLinkRequest value) => value.writeToBuffer(),
          $0.ScanLinkResponse.fromBuffer);
  static final _$reportLink =
      $grpc.ClientMethod<$0.ReportLinkRequest, $0.ReportLinkResponse>(
          '/creativanta.commerce.v1.LinkInBioService/ReportLink',
          ($0.ReportLinkRequest value) => value.writeToBuffer(),
          $0.ReportLinkResponse.fromBuffer);
  static final _$verifyCustomDomain = $grpc.ClientMethod<
          $0.VerifyCustomDomainRequest, $0.VerifyCustomDomainResponse>(
      '/creativanta.commerce.v1.LinkInBioService/VerifyCustomDomain',
      ($0.VerifyCustomDomainRequest value) => value.writeToBuffer(),
      $0.VerifyCustomDomainResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.LinkInBioService')
abstract class LinkInBioServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.commerce.v1.LinkInBioService';

  LinkInBioServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CreatePageRequest, $0.CreatePageResponse>(
        'CreatePage',
        createPage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.CreatePageRequest.fromBuffer(value),
        ($0.CreatePageResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetPageRequest, $0.GetPageResponse>(
        'GetPage',
        getPage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetPageRequest.fromBuffer(value),
        ($0.GetPageResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdatePageRequest, $0.UpdatePageResponse>(
        'UpdatePage',
        updatePage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UpdatePageRequest.fromBuffer(value),
        ($0.UpdatePageResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LinkInBioServiceSaveRequest,
            $0.LinkInBioServiceSaveResponse>(
        'Save',
        save_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.LinkInBioServiceSaveRequest.fromBuffer(value),
        ($0.LinkInBioServiceSaveResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetAnalyticsRequest, $0.GetAnalyticsResponse>(
            'GetAnalytics',
            getAnalytics_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetAnalyticsRequest.fromBuffer(value),
            ($0.GetAnalyticsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LinkInBioServiceReorderRequest,
            $0.LinkInBioServiceReorderResponse>(
        'Reorder',
        reorder_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.LinkInBioServiceReorderRequest.fromBuffer(value),
        ($0.LinkInBioServiceReorderResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ToggleLinkRequest, $0.ToggleLinkResponse>(
        'ToggleLink',
        toggleLink_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ToggleLinkRequest.fromBuffer(value),
        ($0.ToggleLinkResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.UpdateThemeRequest, $0.UpdateThemeResponse>(
            'UpdateTheme',
            updateTheme_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.UpdateThemeRequest.fromBuffer(value),
            ($0.UpdateThemeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ScanLinkRequest, $0.ScanLinkResponse>(
        'ScanLink',
        scanLink_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ScanLinkRequest.fromBuffer(value),
        ($0.ScanLinkResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ReportLinkRequest, $0.ReportLinkResponse>(
        'ReportLink',
        reportLink_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ReportLinkRequest.fromBuffer(value),
        ($0.ReportLinkResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.VerifyCustomDomainRequest,
            $0.VerifyCustomDomainResponse>(
        'VerifyCustomDomain',
        verifyCustomDomain_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.VerifyCustomDomainRequest.fromBuffer(value),
        ($0.VerifyCustomDomainResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.CreatePageResponse> createPage_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CreatePageRequest> $request) async {
    return createPage($call, await $request);
  }

  $async.Future<$0.CreatePageResponse> createPage(
      $grpc.ServiceCall call, $0.CreatePageRequest request);

  $async.Future<$0.GetPageResponse> getPage_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetPageRequest> $request) async {
    return getPage($call, await $request);
  }

  $async.Future<$0.GetPageResponse> getPage(
      $grpc.ServiceCall call, $0.GetPageRequest request);

  $async.Future<$0.UpdatePageResponse> updatePage_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UpdatePageRequest> $request) async {
    return updatePage($call, await $request);
  }

  $async.Future<$0.UpdatePageResponse> updatePage(
      $grpc.ServiceCall call, $0.UpdatePageRequest request);

  $async.Future<$0.LinkInBioServiceSaveResponse> save_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.LinkInBioServiceSaveRequest> $request) async {
    return save($call, await $request);
  }

  $async.Future<$0.LinkInBioServiceSaveResponse> save(
      $grpc.ServiceCall call, $0.LinkInBioServiceSaveRequest request);

  $async.Future<$0.GetAnalyticsResponse> getAnalytics_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetAnalyticsRequest> $request) async {
    return getAnalytics($call, await $request);
  }

  $async.Future<$0.GetAnalyticsResponse> getAnalytics(
      $grpc.ServiceCall call, $0.GetAnalyticsRequest request);

  $async.Future<$0.LinkInBioServiceReorderResponse> reorder_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.LinkInBioServiceReorderRequest> $request) async {
    return reorder($call, await $request);
  }

  $async.Future<$0.LinkInBioServiceReorderResponse> reorder(
      $grpc.ServiceCall call, $0.LinkInBioServiceReorderRequest request);

  $async.Future<$0.ToggleLinkResponse> toggleLink_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ToggleLinkRequest> $request) async {
    return toggleLink($call, await $request);
  }

  $async.Future<$0.ToggleLinkResponse> toggleLink(
      $grpc.ServiceCall call, $0.ToggleLinkRequest request);

  $async.Future<$0.UpdateThemeResponse> updateTheme_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UpdateThemeRequest> $request) async {
    return updateTheme($call, await $request);
  }

  $async.Future<$0.UpdateThemeResponse> updateTheme(
      $grpc.ServiceCall call, $0.UpdateThemeRequest request);

  $async.Future<$0.ScanLinkResponse> scanLink_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ScanLinkRequest> $request) async {
    return scanLink($call, await $request);
  }

  $async.Future<$0.ScanLinkResponse> scanLink(
      $grpc.ServiceCall call, $0.ScanLinkRequest request);

  $async.Future<$0.ReportLinkResponse> reportLink_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ReportLinkRequest> $request) async {
    return reportLink($call, await $request);
  }

  $async.Future<$0.ReportLinkResponse> reportLink(
      $grpc.ServiceCall call, $0.ReportLinkRequest request);

  $async.Future<$0.VerifyCustomDomainResponse> verifyCustomDomain_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.VerifyCustomDomainRequest> $request) async {
    return verifyCustomDomain($call, await $request);
  }

  $async.Future<$0.VerifyCustomDomainResponse> verifyCustomDomain(
      $grpc.ServiceCall call, $0.VerifyCustomDomainRequest request);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.MediaKitService')
class MediaKitServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  MediaKitServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.MediaKitServiceGenerateResponse> generate(
    $0.MediaKitServiceGenerateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$generate, request, options: options);
  }

  $grpc.ResponseFuture<$0.MediaKitServiceGetResponse> get(
    $0.MediaKitServiceGetRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$get, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetKitResponse> getKit(
    $0.GetKitRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getKit, request, options: options);
  }

  $grpc.ResponseFuture<$0.MediaKitServiceExportResponse> export(
    $0.MediaKitServiceExportRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$export, request, options: options);
  }

  $grpc.ResponseFuture<$0.SetDirectoryProfileResponse> setDirectoryProfile(
    $0.SetDirectoryProfileRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$setDirectoryProfile, request, options: options);
  }

  // method descriptors

  static final _$generate = $grpc.ClientMethod<
          $0.MediaKitServiceGenerateRequest,
          $0.MediaKitServiceGenerateResponse>(
      '/creativanta.commerce.v1.MediaKitService/Generate',
      ($0.MediaKitServiceGenerateRequest value) => value.writeToBuffer(),
      $0.MediaKitServiceGenerateResponse.fromBuffer);
  static final _$get = $grpc.ClientMethod<$0.MediaKitServiceGetRequest,
          $0.MediaKitServiceGetResponse>(
      '/creativanta.commerce.v1.MediaKitService/Get',
      ($0.MediaKitServiceGetRequest value) => value.writeToBuffer(),
      $0.MediaKitServiceGetResponse.fromBuffer);
  static final _$getKit =
      $grpc.ClientMethod<$0.GetKitRequest, $0.GetKitResponse>(
          '/creativanta.commerce.v1.MediaKitService/GetKit',
          ($0.GetKitRequest value) => value.writeToBuffer(),
          $0.GetKitResponse.fromBuffer);
  static final _$export = $grpc.ClientMethod<$0.MediaKitServiceExportRequest,
          $0.MediaKitServiceExportResponse>(
      '/creativanta.commerce.v1.MediaKitService/Export',
      ($0.MediaKitServiceExportRequest value) => value.writeToBuffer(),
      $0.MediaKitServiceExportResponse.fromBuffer);
  static final _$setDirectoryProfile = $grpc.ClientMethod<
          $0.SetDirectoryProfileRequest, $0.SetDirectoryProfileResponse>(
      '/creativanta.commerce.v1.MediaKitService/SetDirectoryProfile',
      ($0.SetDirectoryProfileRequest value) => value.writeToBuffer(),
      $0.SetDirectoryProfileResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.MediaKitService')
abstract class MediaKitServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.commerce.v1.MediaKitService';

  MediaKitServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.MediaKitServiceGenerateRequest,
            $0.MediaKitServiceGenerateResponse>(
        'Generate',
        generate_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.MediaKitServiceGenerateRequest.fromBuffer(value),
        ($0.MediaKitServiceGenerateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.MediaKitServiceGetRequest,
            $0.MediaKitServiceGetResponse>(
        'Get',
        get_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.MediaKitServiceGetRequest.fromBuffer(value),
        ($0.MediaKitServiceGetResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetKitRequest, $0.GetKitResponse>(
        'GetKit',
        getKit_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetKitRequest.fromBuffer(value),
        ($0.GetKitResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.MediaKitServiceExportRequest,
            $0.MediaKitServiceExportResponse>(
        'Export',
        export_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.MediaKitServiceExportRequest.fromBuffer(value),
        ($0.MediaKitServiceExportResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SetDirectoryProfileRequest,
            $0.SetDirectoryProfileResponse>(
        'SetDirectoryProfile',
        setDirectoryProfile_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SetDirectoryProfileRequest.fromBuffer(value),
        ($0.SetDirectoryProfileResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.MediaKitServiceGenerateResponse> generate_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.MediaKitServiceGenerateRequest> $request) async {
    return generate($call, await $request);
  }

  $async.Future<$0.MediaKitServiceGenerateResponse> generate(
      $grpc.ServiceCall call, $0.MediaKitServiceGenerateRequest request);

  $async.Future<$0.MediaKitServiceGetResponse> get_Pre($grpc.ServiceCall $call,
      $async.Future<$0.MediaKitServiceGetRequest> $request) async {
    return get($call, await $request);
  }

  $async.Future<$0.MediaKitServiceGetResponse> get(
      $grpc.ServiceCall call, $0.MediaKitServiceGetRequest request);

  $async.Future<$0.GetKitResponse> getKit_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.GetKitRequest> $request) async {
    return getKit($call, await $request);
  }

  $async.Future<$0.GetKitResponse> getKit(
      $grpc.ServiceCall call, $0.GetKitRequest request);

  $async.Future<$0.MediaKitServiceExportResponse> export_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.MediaKitServiceExportRequest> $request) async {
    return export($call, await $request);
  }

  $async.Future<$0.MediaKitServiceExportResponse> export(
      $grpc.ServiceCall call, $0.MediaKitServiceExportRequest request);

  $async.Future<$0.SetDirectoryProfileResponse> setDirectoryProfile_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SetDirectoryProfileRequest> $request) async {
    return setDirectoryProfile($call, await $request);
  }

  $async.Future<$0.SetDirectoryProfileResponse> setDirectoryProfile(
      $grpc.ServiceCall call, $0.SetDirectoryProfileRequest request);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.RateCardService')
class RateCardServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  RateCardServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.RateCardServiceCreateResponse> create(
    $0.RateCardServiceCreateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$create, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetRateCardResponse> getRateCard(
    $0.GetRateCardRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getRateCard, request, options: options);
  }

  $grpc.ResponseFuture<$0.RateCardServiceListResponse> list(
    $0.RateCardServiceListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$list, request, options: options);
  }

  $grpc.ResponseFuture<$0.RateCardServiceSaveResponse> save(
    $0.RateCardServiceSaveRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$save, request, options: options);
  }

  $grpc.ResponseFuture<$0.RateCardServiceDeleteItemResponse> deleteItem(
    $0.RateCardServiceDeleteItemRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteItem, request, options: options);
  }

  $grpc.ResponseFuture<$0.RateCardServiceReorderResponse> reorder(
    $0.RateCardServiceReorderRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$reorder, request, options: options);
  }

  $grpc.ResponseFuture<$0.CompareScopeResponse> compareScope(
    $0.CompareScopeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$compareScope, request, options: options);
  }

  $grpc.ResponseFuture<$0.RateCardServiceAISuggestResponse> aISuggest(
    $0.RateCardServiceAISuggestRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$aISuggest, request, options: options);
  }

  // method descriptors

  static final _$create = $grpc.ClientMethod<$0.RateCardServiceCreateRequest,
          $0.RateCardServiceCreateResponse>(
      '/creativanta.commerce.v1.RateCardService/Create',
      ($0.RateCardServiceCreateRequest value) => value.writeToBuffer(),
      $0.RateCardServiceCreateResponse.fromBuffer);
  static final _$getRateCard =
      $grpc.ClientMethod<$0.GetRateCardRequest, $0.GetRateCardResponse>(
          '/creativanta.commerce.v1.RateCardService/GetRateCard',
          ($0.GetRateCardRequest value) => value.writeToBuffer(),
          $0.GetRateCardResponse.fromBuffer);
  static final _$list = $grpc.ClientMethod<$0.RateCardServiceListRequest,
          $0.RateCardServiceListResponse>(
      '/creativanta.commerce.v1.RateCardService/List',
      ($0.RateCardServiceListRequest value) => value.writeToBuffer(),
      $0.RateCardServiceListResponse.fromBuffer);
  static final _$save = $grpc.ClientMethod<$0.RateCardServiceSaveRequest,
          $0.RateCardServiceSaveResponse>(
      '/creativanta.commerce.v1.RateCardService/Save',
      ($0.RateCardServiceSaveRequest value) => value.writeToBuffer(),
      $0.RateCardServiceSaveResponse.fromBuffer);
  static final _$deleteItem = $grpc.ClientMethod<
          $0.RateCardServiceDeleteItemRequest,
          $0.RateCardServiceDeleteItemResponse>(
      '/creativanta.commerce.v1.RateCardService/DeleteItem',
      ($0.RateCardServiceDeleteItemRequest value) => value.writeToBuffer(),
      $0.RateCardServiceDeleteItemResponse.fromBuffer);
  static final _$reorder = $grpc.ClientMethod<$0.RateCardServiceReorderRequest,
          $0.RateCardServiceReorderResponse>(
      '/creativanta.commerce.v1.RateCardService/Reorder',
      ($0.RateCardServiceReorderRequest value) => value.writeToBuffer(),
      $0.RateCardServiceReorderResponse.fromBuffer);
  static final _$compareScope =
      $grpc.ClientMethod<$0.CompareScopeRequest, $0.CompareScopeResponse>(
          '/creativanta.commerce.v1.RateCardService/CompareScope',
          ($0.CompareScopeRequest value) => value.writeToBuffer(),
          $0.CompareScopeResponse.fromBuffer);
  static final _$aISuggest = $grpc.ClientMethod<
          $0.RateCardServiceAISuggestRequest,
          $0.RateCardServiceAISuggestResponse>(
      '/creativanta.commerce.v1.RateCardService/AISuggest',
      ($0.RateCardServiceAISuggestRequest value) => value.writeToBuffer(),
      $0.RateCardServiceAISuggestResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.RateCardService')
abstract class RateCardServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.commerce.v1.RateCardService';

  RateCardServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.RateCardServiceCreateRequest,
            $0.RateCardServiceCreateResponse>(
        'Create',
        create_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RateCardServiceCreateRequest.fromBuffer(value),
        ($0.RateCardServiceCreateResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetRateCardRequest, $0.GetRateCardResponse>(
            'GetRateCard',
            getRateCard_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetRateCardRequest.fromBuffer(value),
            ($0.GetRateCardResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RateCardServiceListRequest,
            $0.RateCardServiceListResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RateCardServiceListRequest.fromBuffer(value),
        ($0.RateCardServiceListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RateCardServiceSaveRequest,
            $0.RateCardServiceSaveResponse>(
        'Save',
        save_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RateCardServiceSaveRequest.fromBuffer(value),
        ($0.RateCardServiceSaveResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RateCardServiceDeleteItemRequest,
            $0.RateCardServiceDeleteItemResponse>(
        'DeleteItem',
        deleteItem_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RateCardServiceDeleteItemRequest.fromBuffer(value),
        ($0.RateCardServiceDeleteItemResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RateCardServiceReorderRequest,
            $0.RateCardServiceReorderResponse>(
        'Reorder',
        reorder_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RateCardServiceReorderRequest.fromBuffer(value),
        ($0.RateCardServiceReorderResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.CompareScopeRequest, $0.CompareScopeResponse>(
            'CompareScope',
            compareScope_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.CompareScopeRequest.fromBuffer(value),
            ($0.CompareScopeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RateCardServiceAISuggestRequest,
            $0.RateCardServiceAISuggestResponse>(
        'AISuggest',
        aISuggest_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RateCardServiceAISuggestRequest.fromBuffer(value),
        ($0.RateCardServiceAISuggestResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.RateCardServiceCreateResponse> create_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RateCardServiceCreateRequest> $request) async {
    return create($call, await $request);
  }

  $async.Future<$0.RateCardServiceCreateResponse> create(
      $grpc.ServiceCall call, $0.RateCardServiceCreateRequest request);

  $async.Future<$0.GetRateCardResponse> getRateCard_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetRateCardRequest> $request) async {
    return getRateCard($call, await $request);
  }

  $async.Future<$0.GetRateCardResponse> getRateCard(
      $grpc.ServiceCall call, $0.GetRateCardRequest request);

  $async.Future<$0.RateCardServiceListResponse> list_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RateCardServiceListRequest> $request) async {
    return list($call, await $request);
  }

  $async.Future<$0.RateCardServiceListResponse> list(
      $grpc.ServiceCall call, $0.RateCardServiceListRequest request);

  $async.Future<$0.RateCardServiceSaveResponse> save_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RateCardServiceSaveRequest> $request) async {
    return save($call, await $request);
  }

  $async.Future<$0.RateCardServiceSaveResponse> save(
      $grpc.ServiceCall call, $0.RateCardServiceSaveRequest request);

  $async.Future<$0.RateCardServiceDeleteItemResponse> deleteItem_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RateCardServiceDeleteItemRequest> $request) async {
    return deleteItem($call, await $request);
  }

  $async.Future<$0.RateCardServiceDeleteItemResponse> deleteItem(
      $grpc.ServiceCall call, $0.RateCardServiceDeleteItemRequest request);

  $async.Future<$0.RateCardServiceReorderResponse> reorder_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RateCardServiceReorderRequest> $request) async {
    return reorder($call, await $request);
  }

  $async.Future<$0.RateCardServiceReorderResponse> reorder(
      $grpc.ServiceCall call, $0.RateCardServiceReorderRequest request);

  $async.Future<$0.CompareScopeResponse> compareScope_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CompareScopeRequest> $request) async {
    return compareScope($call, await $request);
  }

  $async.Future<$0.CompareScopeResponse> compareScope(
      $grpc.ServiceCall call, $0.CompareScopeRequest request);

  $async.Future<$0.RateCardServiceAISuggestResponse> aISuggest_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RateCardServiceAISuggestRequest> $request) async {
    return aISuggest($call, await $request);
  }

  $async.Future<$0.RateCardServiceAISuggestResponse> aISuggest(
      $grpc.ServiceCall call, $0.RateCardServiceAISuggestRequest request);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.BrandDealService')
class BrandDealServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  BrandDealServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.BrandDealServiceCreateResponse> create(
    $0.BrandDealServiceCreateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$create, request, options: options);
  }

  $grpc.ResponseFuture<$0.BrandDealServiceUpdateStatusResponse> updateStatus(
    $0.BrandDealServiceUpdateStatusRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateStatus, request, options: options);
  }

  $grpc.ResponseFuture<$0.BrandDealServiceListResponse> list(
    $0.BrandDealServiceListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$list, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListDealsResponse> listDeals(
    $0.ListDealsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listDeals, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListPartnershipsResponse> listPartnerships(
    $0.ListPartnershipsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listPartnerships, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetPipelineStatsResponse> getPipelineStats(
    $0.GetPipelineStatsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getPipelineStats, request, options: options);
  }

  $grpc.ResponseFuture<$0.BrandDealServiceGetSummaryResponse> getSummary(
    $0.BrandDealServiceGetSummaryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getSummary, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdateDeliverableResponse> updateDeliverable(
    $0.UpdateDeliverableRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateDeliverable, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdatePaymentResponse> updatePayment(
    $0.UpdatePaymentRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updatePayment, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListContractTemplatesResponse> listContractTemplates(
    $0.ListContractTemplatesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listContractTemplates, request, options: options);
  }

  $grpc.ResponseFuture<$0.AttachContractResponse> attachContract(
    $0.AttachContractRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$attachContract, request, options: options);
  }

  // method descriptors

  static final _$create = $grpc.ClientMethod<$0.BrandDealServiceCreateRequest,
          $0.BrandDealServiceCreateResponse>(
      '/creativanta.commerce.v1.BrandDealService/Create',
      ($0.BrandDealServiceCreateRequest value) => value.writeToBuffer(),
      $0.BrandDealServiceCreateResponse.fromBuffer);
  static final _$updateStatus = $grpc.ClientMethod<
          $0.BrandDealServiceUpdateStatusRequest,
          $0.BrandDealServiceUpdateStatusResponse>(
      '/creativanta.commerce.v1.BrandDealService/UpdateStatus',
      ($0.BrandDealServiceUpdateStatusRequest value) => value.writeToBuffer(),
      $0.BrandDealServiceUpdateStatusResponse.fromBuffer);
  static final _$list = $grpc.ClientMethod<$0.BrandDealServiceListRequest,
          $0.BrandDealServiceListResponse>(
      '/creativanta.commerce.v1.BrandDealService/List',
      ($0.BrandDealServiceListRequest value) => value.writeToBuffer(),
      $0.BrandDealServiceListResponse.fromBuffer);
  static final _$listDeals =
      $grpc.ClientMethod<$0.ListDealsRequest, $0.ListDealsResponse>(
          '/creativanta.commerce.v1.BrandDealService/ListDeals',
          ($0.ListDealsRequest value) => value.writeToBuffer(),
          $0.ListDealsResponse.fromBuffer);
  static final _$listPartnerships = $grpc.ClientMethod<
          $0.ListPartnershipsRequest, $0.ListPartnershipsResponse>(
      '/creativanta.commerce.v1.BrandDealService/ListPartnerships',
      ($0.ListPartnershipsRequest value) => value.writeToBuffer(),
      $0.ListPartnershipsResponse.fromBuffer);
  static final _$getPipelineStats = $grpc.ClientMethod<
          $0.GetPipelineStatsRequest, $0.GetPipelineStatsResponse>(
      '/creativanta.commerce.v1.BrandDealService/GetPipelineStats',
      ($0.GetPipelineStatsRequest value) => value.writeToBuffer(),
      $0.GetPipelineStatsResponse.fromBuffer);
  static final _$getSummary = $grpc.ClientMethod<
          $0.BrandDealServiceGetSummaryRequest,
          $0.BrandDealServiceGetSummaryResponse>(
      '/creativanta.commerce.v1.BrandDealService/GetSummary',
      ($0.BrandDealServiceGetSummaryRequest value) => value.writeToBuffer(),
      $0.BrandDealServiceGetSummaryResponse.fromBuffer);
  static final _$updateDeliverable = $grpc.ClientMethod<
          $0.UpdateDeliverableRequest, $0.UpdateDeliverableResponse>(
      '/creativanta.commerce.v1.BrandDealService/UpdateDeliverable',
      ($0.UpdateDeliverableRequest value) => value.writeToBuffer(),
      $0.UpdateDeliverableResponse.fromBuffer);
  static final _$updatePayment =
      $grpc.ClientMethod<$0.UpdatePaymentRequest, $0.UpdatePaymentResponse>(
          '/creativanta.commerce.v1.BrandDealService/UpdatePayment',
          ($0.UpdatePaymentRequest value) => value.writeToBuffer(),
          $0.UpdatePaymentResponse.fromBuffer);
  static final _$listContractTemplates = $grpc.ClientMethod<
          $0.ListContractTemplatesRequest, $0.ListContractTemplatesResponse>(
      '/creativanta.commerce.v1.BrandDealService/ListContractTemplates',
      ($0.ListContractTemplatesRequest value) => value.writeToBuffer(),
      $0.ListContractTemplatesResponse.fromBuffer);
  static final _$attachContract =
      $grpc.ClientMethod<$0.AttachContractRequest, $0.AttachContractResponse>(
          '/creativanta.commerce.v1.BrandDealService/AttachContract',
          ($0.AttachContractRequest value) => value.writeToBuffer(),
          $0.AttachContractResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.BrandDealService')
abstract class BrandDealServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.commerce.v1.BrandDealService';

  BrandDealServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.BrandDealServiceCreateRequest,
            $0.BrandDealServiceCreateResponse>(
        'Create',
        create_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.BrandDealServiceCreateRequest.fromBuffer(value),
        ($0.BrandDealServiceCreateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.BrandDealServiceUpdateStatusRequest,
            $0.BrandDealServiceUpdateStatusResponse>(
        'UpdateStatus',
        updateStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.BrandDealServiceUpdateStatusRequest.fromBuffer(value),
        ($0.BrandDealServiceUpdateStatusResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.BrandDealServiceListRequest,
            $0.BrandDealServiceListResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.BrandDealServiceListRequest.fromBuffer(value),
        ($0.BrandDealServiceListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListDealsRequest, $0.ListDealsResponse>(
        'ListDeals',
        listDeals_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListDealsRequest.fromBuffer(value),
        ($0.ListDealsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListPartnershipsRequest,
            $0.ListPartnershipsResponse>(
        'ListPartnerships',
        listPartnerships_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListPartnershipsRequest.fromBuffer(value),
        ($0.ListPartnershipsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetPipelineStatsRequest,
            $0.GetPipelineStatsResponse>(
        'GetPipelineStats',
        getPipelineStats_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetPipelineStatsRequest.fromBuffer(value),
        ($0.GetPipelineStatsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.BrandDealServiceGetSummaryRequest,
            $0.BrandDealServiceGetSummaryResponse>(
        'GetSummary',
        getSummary_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.BrandDealServiceGetSummaryRequest.fromBuffer(value),
        ($0.BrandDealServiceGetSummaryResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateDeliverableRequest,
            $0.UpdateDeliverableResponse>(
        'UpdateDeliverable',
        updateDeliverable_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateDeliverableRequest.fromBuffer(value),
        ($0.UpdateDeliverableResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.UpdatePaymentRequest, $0.UpdatePaymentResponse>(
            'UpdatePayment',
            updatePayment_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.UpdatePaymentRequest.fromBuffer(value),
            ($0.UpdatePaymentResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListContractTemplatesRequest,
            $0.ListContractTemplatesResponse>(
        'ListContractTemplates',
        listContractTemplates_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListContractTemplatesRequest.fromBuffer(value),
        ($0.ListContractTemplatesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.AttachContractRequest,
            $0.AttachContractResponse>(
        'AttachContract',
        attachContract_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.AttachContractRequest.fromBuffer(value),
        ($0.AttachContractResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.BrandDealServiceCreateResponse> create_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.BrandDealServiceCreateRequest> $request) async {
    return create($call, await $request);
  }

  $async.Future<$0.BrandDealServiceCreateResponse> create(
      $grpc.ServiceCall call, $0.BrandDealServiceCreateRequest request);

  $async.Future<$0.BrandDealServiceUpdateStatusResponse> updateStatus_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.BrandDealServiceUpdateStatusRequest> $request) async {
    return updateStatus($call, await $request);
  }

  $async.Future<$0.BrandDealServiceUpdateStatusResponse> updateStatus(
      $grpc.ServiceCall call, $0.BrandDealServiceUpdateStatusRequest request);

  $async.Future<$0.BrandDealServiceListResponse> list_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.BrandDealServiceListRequest> $request) async {
    return list($call, await $request);
  }

  $async.Future<$0.BrandDealServiceListResponse> list(
      $grpc.ServiceCall call, $0.BrandDealServiceListRequest request);

  $async.Future<$0.ListDealsResponse> listDeals_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListDealsRequest> $request) async {
    return listDeals($call, await $request);
  }

  $async.Future<$0.ListDealsResponse> listDeals(
      $grpc.ServiceCall call, $0.ListDealsRequest request);

  $async.Future<$0.ListPartnershipsResponse> listPartnerships_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListPartnershipsRequest> $request) async {
    return listPartnerships($call, await $request);
  }

  $async.Future<$0.ListPartnershipsResponse> listPartnerships(
      $grpc.ServiceCall call, $0.ListPartnershipsRequest request);

  $async.Future<$0.GetPipelineStatsResponse> getPipelineStats_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetPipelineStatsRequest> $request) async {
    return getPipelineStats($call, await $request);
  }

  $async.Future<$0.GetPipelineStatsResponse> getPipelineStats(
      $grpc.ServiceCall call, $0.GetPipelineStatsRequest request);

  $async.Future<$0.BrandDealServiceGetSummaryResponse> getSummary_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.BrandDealServiceGetSummaryRequest> $request) async {
    return getSummary($call, await $request);
  }

  $async.Future<$0.BrandDealServiceGetSummaryResponse> getSummary(
      $grpc.ServiceCall call, $0.BrandDealServiceGetSummaryRequest request);

  $async.Future<$0.UpdateDeliverableResponse> updateDeliverable_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UpdateDeliverableRequest> $request) async {
    return updateDeliverable($call, await $request);
  }

  $async.Future<$0.UpdateDeliverableResponse> updateDeliverable(
      $grpc.ServiceCall call, $0.UpdateDeliverableRequest request);

  $async.Future<$0.UpdatePaymentResponse> updatePayment_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UpdatePaymentRequest> $request) async {
    return updatePayment($call, await $request);
  }

  $async.Future<$0.UpdatePaymentResponse> updatePayment(
      $grpc.ServiceCall call, $0.UpdatePaymentRequest request);

  $async.Future<$0.ListContractTemplatesResponse> listContractTemplates_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListContractTemplatesRequest> $request) async {
    return listContractTemplates($call, await $request);
  }

  $async.Future<$0.ListContractTemplatesResponse> listContractTemplates(
      $grpc.ServiceCall call, $0.ListContractTemplatesRequest request);

  $async.Future<$0.AttachContractResponse> attachContract_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.AttachContractRequest> $request) async {
    return attachContract($call, await $request);
  }

  $async.Future<$0.AttachContractResponse> attachContract(
      $grpc.ServiceCall call, $0.AttachContractRequest request);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.SponsorInquiryService')
class SponsorInquiryServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  SponsorInquiryServiceClient(super.channel,
      {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.ListInquiriesResponse> listInquiries(
    $0.ListInquiriesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listInquiries, request, options: options);
  }

  $grpc.ResponseFuture<$0.SponsorInquiryServiceAcceptResponse> accept(
    $0.SponsorInquiryServiceAcceptRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$accept, request, options: options);
  }

  $grpc.ResponseFuture<$0.SponsorInquiryServiceDeclineResponse> decline(
    $0.SponsorInquiryServiceDeclineRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$decline, request, options: options);
  }

  $grpc.ResponseFuture<$0.SponsorInquiryServiceFlagResponse> flag(
    $0.SponsorInquiryServiceFlagRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$flag, request, options: options);
  }

  $grpc.ResponseFuture<$0.SponsorInquiryServiceGetStatsResponse> getStats(
    $0.SponsorInquiryServiceGetStatsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getStats, request, options: options);
  }

  $grpc.ResponseFuture<$0.SponsorInquiryServiceSubmitResponse> submit(
    $0.SponsorInquiryServiceSubmitRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$submit, request, options: options);
  }

  // method descriptors

  static final _$listInquiries =
      $grpc.ClientMethod<$0.ListInquiriesRequest, $0.ListInquiriesResponse>(
          '/creativanta.commerce.v1.SponsorInquiryService/ListInquiries',
          ($0.ListInquiriesRequest value) => value.writeToBuffer(),
          $0.ListInquiriesResponse.fromBuffer);
  static final _$accept = $grpc.ClientMethod<
          $0.SponsorInquiryServiceAcceptRequest,
          $0.SponsorInquiryServiceAcceptResponse>(
      '/creativanta.commerce.v1.SponsorInquiryService/Accept',
      ($0.SponsorInquiryServiceAcceptRequest value) => value.writeToBuffer(),
      $0.SponsorInquiryServiceAcceptResponse.fromBuffer);
  static final _$decline = $grpc.ClientMethod<
          $0.SponsorInquiryServiceDeclineRequest,
          $0.SponsorInquiryServiceDeclineResponse>(
      '/creativanta.commerce.v1.SponsorInquiryService/Decline',
      ($0.SponsorInquiryServiceDeclineRequest value) => value.writeToBuffer(),
      $0.SponsorInquiryServiceDeclineResponse.fromBuffer);
  static final _$flag = $grpc.ClientMethod<$0.SponsorInquiryServiceFlagRequest,
          $0.SponsorInquiryServiceFlagResponse>(
      '/creativanta.commerce.v1.SponsorInquiryService/Flag',
      ($0.SponsorInquiryServiceFlagRequest value) => value.writeToBuffer(),
      $0.SponsorInquiryServiceFlagResponse.fromBuffer);
  static final _$getStats = $grpc.ClientMethod<
          $0.SponsorInquiryServiceGetStatsRequest,
          $0.SponsorInquiryServiceGetStatsResponse>(
      '/creativanta.commerce.v1.SponsorInquiryService/GetStats',
      ($0.SponsorInquiryServiceGetStatsRequest value) => value.writeToBuffer(),
      $0.SponsorInquiryServiceGetStatsResponse.fromBuffer);
  static final _$submit = $grpc.ClientMethod<
          $0.SponsorInquiryServiceSubmitRequest,
          $0.SponsorInquiryServiceSubmitResponse>(
      '/creativanta.commerce.v1.SponsorInquiryService/Submit',
      ($0.SponsorInquiryServiceSubmitRequest value) => value.writeToBuffer(),
      $0.SponsorInquiryServiceSubmitResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.SponsorInquiryService')
abstract class SponsorInquiryServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.commerce.v1.SponsorInquiryService';

  SponsorInquiryServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.ListInquiriesRequest, $0.ListInquiriesResponse>(
            'ListInquiries',
            listInquiries_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListInquiriesRequest.fromBuffer(value),
            ($0.ListInquiriesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SponsorInquiryServiceAcceptRequest,
            $0.SponsorInquiryServiceAcceptResponse>(
        'Accept',
        accept_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SponsorInquiryServiceAcceptRequest.fromBuffer(value),
        ($0.SponsorInquiryServiceAcceptResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SponsorInquiryServiceDeclineRequest,
            $0.SponsorInquiryServiceDeclineResponse>(
        'Decline',
        decline_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SponsorInquiryServiceDeclineRequest.fromBuffer(value),
        ($0.SponsorInquiryServiceDeclineResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SponsorInquiryServiceFlagRequest,
            $0.SponsorInquiryServiceFlagResponse>(
        'Flag',
        flag_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SponsorInquiryServiceFlagRequest.fromBuffer(value),
        ($0.SponsorInquiryServiceFlagResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SponsorInquiryServiceGetStatsRequest,
            $0.SponsorInquiryServiceGetStatsResponse>(
        'GetStats',
        getStats_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SponsorInquiryServiceGetStatsRequest.fromBuffer(value),
        ($0.SponsorInquiryServiceGetStatsResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SponsorInquiryServiceSubmitRequest,
            $0.SponsorInquiryServiceSubmitResponse>(
        'Submit',
        submit_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SponsorInquiryServiceSubmitRequest.fromBuffer(value),
        ($0.SponsorInquiryServiceSubmitResponse value) =>
            value.writeToBuffer()));
  }

  $async.Future<$0.ListInquiriesResponse> listInquiries_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListInquiriesRequest> $request) async {
    return listInquiries($call, await $request);
  }

  $async.Future<$0.ListInquiriesResponse> listInquiries(
      $grpc.ServiceCall call, $0.ListInquiriesRequest request);

  $async.Future<$0.SponsorInquiryServiceAcceptResponse> accept_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SponsorInquiryServiceAcceptRequest> $request) async {
    return accept($call, await $request);
  }

  $async.Future<$0.SponsorInquiryServiceAcceptResponse> accept(
      $grpc.ServiceCall call, $0.SponsorInquiryServiceAcceptRequest request);

  $async.Future<$0.SponsorInquiryServiceDeclineResponse> decline_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SponsorInquiryServiceDeclineRequest> $request) async {
    return decline($call, await $request);
  }

  $async.Future<$0.SponsorInquiryServiceDeclineResponse> decline(
      $grpc.ServiceCall call, $0.SponsorInquiryServiceDeclineRequest request);

  $async.Future<$0.SponsorInquiryServiceFlagResponse> flag_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SponsorInquiryServiceFlagRequest> $request) async {
    return flag($call, await $request);
  }

  $async.Future<$0.SponsorInquiryServiceFlagResponse> flag(
      $grpc.ServiceCall call, $0.SponsorInquiryServiceFlagRequest request);

  $async.Future<$0.SponsorInquiryServiceGetStatsResponse> getStats_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SponsorInquiryServiceGetStatsRequest> $request) async {
    return getStats($call, await $request);
  }

  $async.Future<$0.SponsorInquiryServiceGetStatsResponse> getStats(
      $grpc.ServiceCall call, $0.SponsorInquiryServiceGetStatsRequest request);

  $async.Future<$0.SponsorInquiryServiceSubmitResponse> submit_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SponsorInquiryServiceSubmitRequest> $request) async {
    return submit($call, await $request);
  }

  $async.Future<$0.SponsorInquiryServiceSubmitResponse> submit(
      $grpc.ServiceCall call, $0.SponsorInquiryServiceSubmitRequest request);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.RevenueTrackerService')
class RevenueTrackerServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  RevenueTrackerServiceClient(super.channel,
      {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.GetPerContentResponse> getPerContent(
    $0.GetPerContentRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getPerContent, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetRPMTrendsResponse> getRPMTrends(
    $0.GetRPMTrendsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getRPMTrends, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetROIResponse> getROI(
    $0.GetROIRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getROI, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetTopPerformersResponse> getTopPerformers(
    $0.GetTopPerformersRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getTopPerformers, request, options: options);
  }

  // method descriptors

  static final _$getPerContent =
      $grpc.ClientMethod<$0.GetPerContentRequest, $0.GetPerContentResponse>(
          '/creativanta.commerce.v1.RevenueTrackerService/GetPerContent',
          ($0.GetPerContentRequest value) => value.writeToBuffer(),
          $0.GetPerContentResponse.fromBuffer);
  static final _$getRPMTrends =
      $grpc.ClientMethod<$0.GetRPMTrendsRequest, $0.GetRPMTrendsResponse>(
          '/creativanta.commerce.v1.RevenueTrackerService/GetRPMTrends',
          ($0.GetRPMTrendsRequest value) => value.writeToBuffer(),
          $0.GetRPMTrendsResponse.fromBuffer);
  static final _$getROI =
      $grpc.ClientMethod<$0.GetROIRequest, $0.GetROIResponse>(
          '/creativanta.commerce.v1.RevenueTrackerService/GetROI',
          ($0.GetROIRequest value) => value.writeToBuffer(),
          $0.GetROIResponse.fromBuffer);
  static final _$getTopPerformers = $grpc.ClientMethod<
          $0.GetTopPerformersRequest, $0.GetTopPerformersResponse>(
      '/creativanta.commerce.v1.RevenueTrackerService/GetTopPerformers',
      ($0.GetTopPerformersRequest value) => value.writeToBuffer(),
      $0.GetTopPerformersResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.RevenueTrackerService')
abstract class RevenueTrackerServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.commerce.v1.RevenueTrackerService';

  RevenueTrackerServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.GetPerContentRequest, $0.GetPerContentResponse>(
            'GetPerContent',
            getPerContent_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetPerContentRequest.fromBuffer(value),
            ($0.GetPerContentResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetRPMTrendsRequest, $0.GetRPMTrendsResponse>(
            'GetRPMTrends',
            getRPMTrends_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetRPMTrendsRequest.fromBuffer(value),
            ($0.GetRPMTrendsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetROIRequest, $0.GetROIResponse>(
        'GetROI',
        getROI_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetROIRequest.fromBuffer(value),
        ($0.GetROIResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetTopPerformersRequest,
            $0.GetTopPerformersResponse>(
        'GetTopPerformers',
        getTopPerformers_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetTopPerformersRequest.fromBuffer(value),
        ($0.GetTopPerformersResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.GetPerContentResponse> getPerContent_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetPerContentRequest> $request) async {
    return getPerContent($call, await $request);
  }

  $async.Future<$0.GetPerContentResponse> getPerContent(
      $grpc.ServiceCall call, $0.GetPerContentRequest request);

  $async.Future<$0.GetRPMTrendsResponse> getRPMTrends_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetRPMTrendsRequest> $request) async {
    return getRPMTrends($call, await $request);
  }

  $async.Future<$0.GetRPMTrendsResponse> getRPMTrends(
      $grpc.ServiceCall call, $0.GetRPMTrendsRequest request);

  $async.Future<$0.GetROIResponse> getROI_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.GetROIRequest> $request) async {
    return getROI($call, await $request);
  }

  $async.Future<$0.GetROIResponse> getROI(
      $grpc.ServiceCall call, $0.GetROIRequest request);

  $async.Future<$0.GetTopPerformersResponse> getTopPerformers_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetTopPerformersRequest> $request) async {
    return getTopPerformers($call, await $request);
  }

  $async.Future<$0.GetTopPerformersResponse> getTopPerformers(
      $grpc.ServiceCall call, $0.GetTopPerformersRequest request);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.TaxReportService')
class TaxReportServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  TaxReportServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.TaxReportServiceGetReportResponse> getReport(
    $0.TaxReportServiceGetReportRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getReport, request, options: options);
  }

  $grpc.ResponseFuture<$0.ExportTaxReportResponse> exportTaxReport(
    $0.ExportTaxReportRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$exportTaxReport, request, options: options);
  }

  // method descriptors

  static final _$getReport = $grpc.ClientMethod<
          $0.TaxReportServiceGetReportRequest,
          $0.TaxReportServiceGetReportResponse>(
      '/creativanta.commerce.v1.TaxReportService/GetReport',
      ($0.TaxReportServiceGetReportRequest value) => value.writeToBuffer(),
      $0.TaxReportServiceGetReportResponse.fromBuffer);
  static final _$exportTaxReport =
      $grpc.ClientMethod<$0.ExportTaxReportRequest, $0.ExportTaxReportResponse>(
          '/creativanta.commerce.v1.TaxReportService/ExportTaxReport',
          ($0.ExportTaxReportRequest value) => value.writeToBuffer(),
          $0.ExportTaxReportResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.TaxReportService')
abstract class TaxReportServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.commerce.v1.TaxReportService';

  TaxReportServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.TaxReportServiceGetReportRequest,
            $0.TaxReportServiceGetReportResponse>(
        'GetReport',
        getReport_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.TaxReportServiceGetReportRequest.fromBuffer(value),
        ($0.TaxReportServiceGetReportResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ExportTaxReportRequest,
            $0.ExportTaxReportResponse>(
        'ExportTaxReport',
        exportTaxReport_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ExportTaxReportRequest.fromBuffer(value),
        ($0.ExportTaxReportResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.TaxReportServiceGetReportResponse> getReport_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.TaxReportServiceGetReportRequest> $request) async {
    return getReport($call, await $request);
  }

  $async.Future<$0.TaxReportServiceGetReportResponse> getReport(
      $grpc.ServiceCall call, $0.TaxReportServiceGetReportRequest request);

  $async.Future<$0.ExportTaxReportResponse> exportTaxReport_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ExportTaxReportRequest> $request) async {
    return exportTaxReport($call, await $request);
  }

  $async.Future<$0.ExportTaxReportResponse> exportTaxReport(
      $grpc.ServiceCall call, $0.ExportTaxReportRequest request);
}
