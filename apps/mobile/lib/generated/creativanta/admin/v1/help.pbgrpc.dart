// This is a generated file - do not edit.
//
// Generated from creativanta/admin/v1/help.proto.

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

import 'help.pb.dart' as $0;

export 'help.pb.dart';

/// User-facing Help Center Service (M01/help)
@$pb.GrpcServiceName('creativanta.admin.v1.KBService')
class KBServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  KBServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.SearchResponse> search(
    $0.SearchRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$search, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetCategoriesResponse> getCategories(
    $0.GetCategoriesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getCategories, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetArticleResponse> getArticle(
    $0.GetArticleRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getArticle, request, options: options);
  }

  $grpc.ResponseFuture<$0.RateArticleResponse> rateArticle(
    $0.RateArticleRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$rateArticle, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListRecentResponse> listRecent(
    $0.ListRecentRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listRecent, request, options: options);
  }

  // method descriptors

  static final _$search =
      $grpc.ClientMethod<$0.SearchRequest, $0.SearchResponse>(
          '/creativanta.admin.v1.KBService/Search',
          ($0.SearchRequest value) => value.writeToBuffer(),
          $0.SearchResponse.fromBuffer);
  static final _$getCategories =
      $grpc.ClientMethod<$0.GetCategoriesRequest, $0.GetCategoriesResponse>(
          '/creativanta.admin.v1.KBService/GetCategories',
          ($0.GetCategoriesRequest value) => value.writeToBuffer(),
          $0.GetCategoriesResponse.fromBuffer);
  static final _$getArticle =
      $grpc.ClientMethod<$0.GetArticleRequest, $0.GetArticleResponse>(
          '/creativanta.admin.v1.KBService/GetArticle',
          ($0.GetArticleRequest value) => value.writeToBuffer(),
          $0.GetArticleResponse.fromBuffer);
  static final _$rateArticle =
      $grpc.ClientMethod<$0.RateArticleRequest, $0.RateArticleResponse>(
          '/creativanta.admin.v1.KBService/RateArticle',
          ($0.RateArticleRequest value) => value.writeToBuffer(),
          $0.RateArticleResponse.fromBuffer);
  static final _$listRecent =
      $grpc.ClientMethod<$0.ListRecentRequest, $0.ListRecentResponse>(
          '/creativanta.admin.v1.KBService/ListRecent',
          ($0.ListRecentRequest value) => value.writeToBuffer(),
          $0.ListRecentResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.admin.v1.KBService')
abstract class KBServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.admin.v1.KBService';

  KBServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.SearchRequest, $0.SearchResponse>(
        'Search',
        search_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SearchRequest.fromBuffer(value),
        ($0.SearchResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetCategoriesRequest, $0.GetCategoriesResponse>(
            'GetCategories',
            getCategories_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetCategoriesRequest.fromBuffer(value),
            ($0.GetCategoriesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetArticleRequest, $0.GetArticleResponse>(
        'GetArticle',
        getArticle_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetArticleRequest.fromBuffer(value),
        ($0.GetArticleResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.RateArticleRequest, $0.RateArticleResponse>(
            'RateArticle',
            rateArticle_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.RateArticleRequest.fromBuffer(value),
            ($0.RateArticleResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListRecentRequest, $0.ListRecentResponse>(
        'ListRecent',
        listRecent_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListRecentRequest.fromBuffer(value),
        ($0.ListRecentResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.SearchResponse> search_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.SearchRequest> $request) async {
    return search($call, await $request);
  }

  $async.Future<$0.SearchResponse> search(
      $grpc.ServiceCall call, $0.SearchRequest request);

  $async.Future<$0.GetCategoriesResponse> getCategories_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetCategoriesRequest> $request) async {
    return getCategories($call, await $request);
  }

  $async.Future<$0.GetCategoriesResponse> getCategories(
      $grpc.ServiceCall call, $0.GetCategoriesRequest request);

  $async.Future<$0.GetArticleResponse> getArticle_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetArticleRequest> $request) async {
    return getArticle($call, await $request);
  }

  $async.Future<$0.GetArticleResponse> getArticle(
      $grpc.ServiceCall call, $0.GetArticleRequest request);

  $async.Future<$0.RateArticleResponse> rateArticle_Pre($grpc.ServiceCall $call,
      $async.Future<$0.RateArticleRequest> $request) async {
    return rateArticle($call, await $request);
  }

  $async.Future<$0.RateArticleResponse> rateArticle(
      $grpc.ServiceCall call, $0.RateArticleRequest request);

  $async.Future<$0.ListRecentResponse> listRecent_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListRecentRequest> $request) async {
    return listRecent($call, await $request);
  }

  $async.Future<$0.ListRecentResponse> listRecent(
      $grpc.ServiceCall call, $0.ListRecentRequest request);
}

/// Ops-facing Internal Admin KB Service (S26/help)
@$pb.GrpcServiceName('creativanta.admin.v1.KBAdminService')
class KBAdminServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  KBAdminServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.ListArticlesResponse> listArticles(
    $0.ListArticlesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listArticles, request, options: options);
  }

  $grpc.ResponseFuture<$0.KBAdminServiceGetArticleResponse> getArticle(
    $0.KBAdminServiceGetArticleRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getArticle, request, options: options);
  }

  $grpc.ResponseFuture<$0.CreateArticleResponse> createArticle(
    $0.CreateArticleRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createArticle, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdateArticleResponse> updateArticle(
    $0.UpdateArticleRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateArticle, request, options: options);
  }

  $grpc.ResponseFuture<$0.PublishArticleResponse> publishArticle(
    $0.PublishArticleRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$publishArticle, request, options: options);
  }

  $grpc.ResponseFuture<$0.ArchiveArticleResponse> archiveArticle(
    $0.ArchiveArticleRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$archiveArticle, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListStaleArticlesResponse> listStaleArticles(
    $0.ListStaleArticlesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listStaleArticles, request, options: options);
  }

  // method descriptors

  static final _$listArticles =
      $grpc.ClientMethod<$0.ListArticlesRequest, $0.ListArticlesResponse>(
          '/creativanta.admin.v1.KBAdminService/ListArticles',
          ($0.ListArticlesRequest value) => value.writeToBuffer(),
          $0.ListArticlesResponse.fromBuffer);
  static final _$getArticle = $grpc.ClientMethod<
          $0.KBAdminServiceGetArticleRequest,
          $0.KBAdminServiceGetArticleResponse>(
      '/creativanta.admin.v1.KBAdminService/GetArticle',
      ($0.KBAdminServiceGetArticleRequest value) => value.writeToBuffer(),
      $0.KBAdminServiceGetArticleResponse.fromBuffer);
  static final _$createArticle =
      $grpc.ClientMethod<$0.CreateArticleRequest, $0.CreateArticleResponse>(
          '/creativanta.admin.v1.KBAdminService/CreateArticle',
          ($0.CreateArticleRequest value) => value.writeToBuffer(),
          $0.CreateArticleResponse.fromBuffer);
  static final _$updateArticle =
      $grpc.ClientMethod<$0.UpdateArticleRequest, $0.UpdateArticleResponse>(
          '/creativanta.admin.v1.KBAdminService/UpdateArticle',
          ($0.UpdateArticleRequest value) => value.writeToBuffer(),
          $0.UpdateArticleResponse.fromBuffer);
  static final _$publishArticle =
      $grpc.ClientMethod<$0.PublishArticleRequest, $0.PublishArticleResponse>(
          '/creativanta.admin.v1.KBAdminService/PublishArticle',
          ($0.PublishArticleRequest value) => value.writeToBuffer(),
          $0.PublishArticleResponse.fromBuffer);
  static final _$archiveArticle =
      $grpc.ClientMethod<$0.ArchiveArticleRequest, $0.ArchiveArticleResponse>(
          '/creativanta.admin.v1.KBAdminService/ArchiveArticle',
          ($0.ArchiveArticleRequest value) => value.writeToBuffer(),
          $0.ArchiveArticleResponse.fromBuffer);
  static final _$listStaleArticles = $grpc.ClientMethod<
          $0.ListStaleArticlesRequest, $0.ListStaleArticlesResponse>(
      '/creativanta.admin.v1.KBAdminService/ListStaleArticles',
      ($0.ListStaleArticlesRequest value) => value.writeToBuffer(),
      $0.ListStaleArticlesResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.admin.v1.KBAdminService')
abstract class KBAdminServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.admin.v1.KBAdminService';

  KBAdminServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.ListArticlesRequest, $0.ListArticlesResponse>(
            'ListArticles',
            listArticles_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListArticlesRequest.fromBuffer(value),
            ($0.ListArticlesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.KBAdminServiceGetArticleRequest,
            $0.KBAdminServiceGetArticleResponse>(
        'GetArticle',
        getArticle_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.KBAdminServiceGetArticleRequest.fromBuffer(value),
        ($0.KBAdminServiceGetArticleResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.CreateArticleRequest, $0.CreateArticleResponse>(
            'CreateArticle',
            createArticle_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.CreateArticleRequest.fromBuffer(value),
            ($0.CreateArticleResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.UpdateArticleRequest, $0.UpdateArticleResponse>(
            'UpdateArticle',
            updateArticle_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.UpdateArticleRequest.fromBuffer(value),
            ($0.UpdateArticleResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PublishArticleRequest,
            $0.PublishArticleResponse>(
        'PublishArticle',
        publishArticle_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.PublishArticleRequest.fromBuffer(value),
        ($0.PublishArticleResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ArchiveArticleRequest,
            $0.ArchiveArticleResponse>(
        'ArchiveArticle',
        archiveArticle_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ArchiveArticleRequest.fromBuffer(value),
        ($0.ArchiveArticleResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListStaleArticlesRequest,
            $0.ListStaleArticlesResponse>(
        'ListStaleArticles',
        listStaleArticles_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListStaleArticlesRequest.fromBuffer(value),
        ($0.ListStaleArticlesResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.ListArticlesResponse> listArticles_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListArticlesRequest> $request) async {
    return listArticles($call, await $request);
  }

  $async.Future<$0.ListArticlesResponse> listArticles(
      $grpc.ServiceCall call, $0.ListArticlesRequest request);

  $async.Future<$0.KBAdminServiceGetArticleResponse> getArticle_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.KBAdminServiceGetArticleRequest> $request) async {
    return getArticle($call, await $request);
  }

  $async.Future<$0.KBAdminServiceGetArticleResponse> getArticle(
      $grpc.ServiceCall call, $0.KBAdminServiceGetArticleRequest request);

  $async.Future<$0.CreateArticleResponse> createArticle_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CreateArticleRequest> $request) async {
    return createArticle($call, await $request);
  }

  $async.Future<$0.CreateArticleResponse> createArticle(
      $grpc.ServiceCall call, $0.CreateArticleRequest request);

  $async.Future<$0.UpdateArticleResponse> updateArticle_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UpdateArticleRequest> $request) async {
    return updateArticle($call, await $request);
  }

  $async.Future<$0.UpdateArticleResponse> updateArticle(
      $grpc.ServiceCall call, $0.UpdateArticleRequest request);

  $async.Future<$0.PublishArticleResponse> publishArticle_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.PublishArticleRequest> $request) async {
    return publishArticle($call, await $request);
  }

  $async.Future<$0.PublishArticleResponse> publishArticle(
      $grpc.ServiceCall call, $0.PublishArticleRequest request);

  $async.Future<$0.ArchiveArticleResponse> archiveArticle_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ArchiveArticleRequest> $request) async {
    return archiveArticle($call, await $request);
  }

  $async.Future<$0.ArchiveArticleResponse> archiveArticle(
      $grpc.ServiceCall call, $0.ArchiveArticleRequest request);

  $async.Future<$0.ListStaleArticlesResponse> listStaleArticles_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListStaleArticlesRequest> $request) async {
    return listStaleArticles($call, await $request);
  }

  $async.Future<$0.ListStaleArticlesResponse> listStaleArticles(
      $grpc.ServiceCall call, $0.ListStaleArticlesRequest request);
}
