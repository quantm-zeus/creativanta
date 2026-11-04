// This is a generated file - do not edit.
//
// Generated from creativanta/platform/v1/gamification.proto.

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

import 'gamification.pb.dart' as $0;

export 'gamification.pb.dart';

@$pb.GrpcServiceName('creativanta.platform.v1.GamificationService')
class GamificationServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  GamificationServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.GetProgressResponse> getProgress(
    $0.GetProgressRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getProgress, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListAchievementsResponse> listAchievements(
    $0.ListAchievementsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listAchievements, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListChallengesResponse> listChallenges(
    $0.ListChallengesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listChallenges, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetChallengeProgressResponse> getChallengeProgress(
    $0.GetChallengeProgressRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getChallengeProgress, request, options: options);
  }

  $grpc.ResponseFuture<$0.ShareAchievementResponse> shareAchievement(
    $0.ShareAchievementRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$shareAchievement, request, options: options);
  }

  $grpc.ResponseFuture<$0.GamificationServiceGetDashboardResponse> getDashboard(
    $0.GamificationServiceGetDashboardRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getDashboard, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetAchievementsResponse> getAchievements(
    $0.GetAchievementsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getAchievements, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetActiveQuestsResponse> getActiveQuests(
    $0.GetActiveQuestsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getActiveQuests, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetLeaderboardResponse> getLeaderboard(
    $0.GetLeaderboardRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getLeaderboard, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetStreakResponse> getStreak(
    $0.GetStreakRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getStreak, request, options: options);
  }

  $grpc.ResponseFuture<$0.AdminRestoreStreakResponse> adminRestoreStreak(
    $0.AdminRestoreStreakRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$adminRestoreStreak, request, options: options);
  }

  // method descriptors

  static final _$getProgress =
      $grpc.ClientMethod<$0.GetProgressRequest, $0.GetProgressResponse>(
          '/creativanta.platform.v1.GamificationService/GetProgress',
          ($0.GetProgressRequest value) => value.writeToBuffer(),
          $0.GetProgressResponse.fromBuffer);
  static final _$listAchievements = $grpc.ClientMethod<
          $0.ListAchievementsRequest, $0.ListAchievementsResponse>(
      '/creativanta.platform.v1.GamificationService/ListAchievements',
      ($0.ListAchievementsRequest value) => value.writeToBuffer(),
      $0.ListAchievementsResponse.fromBuffer);
  static final _$listChallenges =
      $grpc.ClientMethod<$0.ListChallengesRequest, $0.ListChallengesResponse>(
          '/creativanta.platform.v1.GamificationService/ListChallenges',
          ($0.ListChallengesRequest value) => value.writeToBuffer(),
          $0.ListChallengesResponse.fromBuffer);
  static final _$getChallengeProgress = $grpc.ClientMethod<
          $0.GetChallengeProgressRequest, $0.GetChallengeProgressResponse>(
      '/creativanta.platform.v1.GamificationService/GetChallengeProgress',
      ($0.GetChallengeProgressRequest value) => value.writeToBuffer(),
      $0.GetChallengeProgressResponse.fromBuffer);
  static final _$shareAchievement = $grpc.ClientMethod<
          $0.ShareAchievementRequest, $0.ShareAchievementResponse>(
      '/creativanta.platform.v1.GamificationService/ShareAchievement',
      ($0.ShareAchievementRequest value) => value.writeToBuffer(),
      $0.ShareAchievementResponse.fromBuffer);
  static final _$getDashboard = $grpc.ClientMethod<
          $0.GamificationServiceGetDashboardRequest,
          $0.GamificationServiceGetDashboardResponse>(
      '/creativanta.platform.v1.GamificationService/GetDashboard',
      ($0.GamificationServiceGetDashboardRequest value) =>
          value.writeToBuffer(),
      $0.GamificationServiceGetDashboardResponse.fromBuffer);
  static final _$getAchievements =
      $grpc.ClientMethod<$0.GetAchievementsRequest, $0.GetAchievementsResponse>(
          '/creativanta.platform.v1.GamificationService/GetAchievements',
          ($0.GetAchievementsRequest value) => value.writeToBuffer(),
          $0.GetAchievementsResponse.fromBuffer);
  static final _$getActiveQuests =
      $grpc.ClientMethod<$0.GetActiveQuestsRequest, $0.GetActiveQuestsResponse>(
          '/creativanta.platform.v1.GamificationService/GetActiveQuests',
          ($0.GetActiveQuestsRequest value) => value.writeToBuffer(),
          $0.GetActiveQuestsResponse.fromBuffer);
  static final _$getLeaderboard =
      $grpc.ClientMethod<$0.GetLeaderboardRequest, $0.GetLeaderboardResponse>(
          '/creativanta.platform.v1.GamificationService/GetLeaderboard',
          ($0.GetLeaderboardRequest value) => value.writeToBuffer(),
          $0.GetLeaderboardResponse.fromBuffer);
  static final _$getStreak =
      $grpc.ClientMethod<$0.GetStreakRequest, $0.GetStreakResponse>(
          '/creativanta.platform.v1.GamificationService/GetStreak',
          ($0.GetStreakRequest value) => value.writeToBuffer(),
          $0.GetStreakResponse.fromBuffer);
  static final _$adminRestoreStreak = $grpc.ClientMethod<
          $0.AdminRestoreStreakRequest, $0.AdminRestoreStreakResponse>(
      '/creativanta.platform.v1.GamificationService/AdminRestoreStreak',
      ($0.AdminRestoreStreakRequest value) => value.writeToBuffer(),
      $0.AdminRestoreStreakResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.platform.v1.GamificationService')
abstract class GamificationServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.platform.v1.GamificationService';

  GamificationServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.GetProgressRequest, $0.GetProgressResponse>(
            'GetProgress',
            getProgress_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetProgressRequest.fromBuffer(value),
            ($0.GetProgressResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListAchievementsRequest,
            $0.ListAchievementsResponse>(
        'ListAchievements',
        listAchievements_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListAchievementsRequest.fromBuffer(value),
        ($0.ListAchievementsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListChallengesRequest,
            $0.ListChallengesResponse>(
        'ListChallenges',
        listChallenges_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListChallengesRequest.fromBuffer(value),
        ($0.ListChallengesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetChallengeProgressRequest,
            $0.GetChallengeProgressResponse>(
        'GetChallengeProgress',
        getChallengeProgress_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetChallengeProgressRequest.fromBuffer(value),
        ($0.GetChallengeProgressResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ShareAchievementRequest,
            $0.ShareAchievementResponse>(
        'ShareAchievement',
        shareAchievement_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ShareAchievementRequest.fromBuffer(value),
        ($0.ShareAchievementResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GamificationServiceGetDashboardRequest,
            $0.GamificationServiceGetDashboardResponse>(
        'GetDashboard',
        getDashboard_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GamificationServiceGetDashboardRequest.fromBuffer(value),
        ($0.GamificationServiceGetDashboardResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetAchievementsRequest,
            $0.GetAchievementsResponse>(
        'GetAchievements',
        getAchievements_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetAchievementsRequest.fromBuffer(value),
        ($0.GetAchievementsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetActiveQuestsRequest,
            $0.GetActiveQuestsResponse>(
        'GetActiveQuests',
        getActiveQuests_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetActiveQuestsRequest.fromBuffer(value),
        ($0.GetActiveQuestsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetLeaderboardRequest,
            $0.GetLeaderboardResponse>(
        'GetLeaderboard',
        getLeaderboard_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetLeaderboardRequest.fromBuffer(value),
        ($0.GetLeaderboardResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetStreakRequest, $0.GetStreakResponse>(
        'GetStreak',
        getStreak_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetStreakRequest.fromBuffer(value),
        ($0.GetStreakResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.AdminRestoreStreakRequest,
            $0.AdminRestoreStreakResponse>(
        'AdminRestoreStreak',
        adminRestoreStreak_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.AdminRestoreStreakRequest.fromBuffer(value),
        ($0.AdminRestoreStreakResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.GetProgressResponse> getProgress_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetProgressRequest> $request) async {
    return getProgress($call, await $request);
  }

  $async.Future<$0.GetProgressResponse> getProgress(
      $grpc.ServiceCall call, $0.GetProgressRequest request);

  $async.Future<$0.ListAchievementsResponse> listAchievements_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListAchievementsRequest> $request) async {
    return listAchievements($call, await $request);
  }

  $async.Future<$0.ListAchievementsResponse> listAchievements(
      $grpc.ServiceCall call, $0.ListAchievementsRequest request);

  $async.Future<$0.ListChallengesResponse> listChallenges_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListChallengesRequest> $request) async {
    return listChallenges($call, await $request);
  }

  $async.Future<$0.ListChallengesResponse> listChallenges(
      $grpc.ServiceCall call, $0.ListChallengesRequest request);

  $async.Future<$0.GetChallengeProgressResponse> getChallengeProgress_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetChallengeProgressRequest> $request) async {
    return getChallengeProgress($call, await $request);
  }

  $async.Future<$0.GetChallengeProgressResponse> getChallengeProgress(
      $grpc.ServiceCall call, $0.GetChallengeProgressRequest request);

  $async.Future<$0.ShareAchievementResponse> shareAchievement_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ShareAchievementRequest> $request) async {
    return shareAchievement($call, await $request);
  }

  $async.Future<$0.ShareAchievementResponse> shareAchievement(
      $grpc.ServiceCall call, $0.ShareAchievementRequest request);

  $async.Future<$0.GamificationServiceGetDashboardResponse> getDashboard_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GamificationServiceGetDashboardRequest> $request) async {
    return getDashboard($call, await $request);
  }

  $async.Future<$0.GamificationServiceGetDashboardResponse> getDashboard(
      $grpc.ServiceCall call,
      $0.GamificationServiceGetDashboardRequest request);

  $async.Future<$0.GetAchievementsResponse> getAchievements_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetAchievementsRequest> $request) async {
    return getAchievements($call, await $request);
  }

  $async.Future<$0.GetAchievementsResponse> getAchievements(
      $grpc.ServiceCall call, $0.GetAchievementsRequest request);

  $async.Future<$0.GetActiveQuestsResponse> getActiveQuests_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetActiveQuestsRequest> $request) async {
    return getActiveQuests($call, await $request);
  }

  $async.Future<$0.GetActiveQuestsResponse> getActiveQuests(
      $grpc.ServiceCall call, $0.GetActiveQuestsRequest request);

  $async.Future<$0.GetLeaderboardResponse> getLeaderboard_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetLeaderboardRequest> $request) async {
    return getLeaderboard($call, await $request);
  }

  $async.Future<$0.GetLeaderboardResponse> getLeaderboard(
      $grpc.ServiceCall call, $0.GetLeaderboardRequest request);

  $async.Future<$0.GetStreakResponse> getStreak_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetStreakRequest> $request) async {
    return getStreak($call, await $request);
  }

  $async.Future<$0.GetStreakResponse> getStreak(
      $grpc.ServiceCall call, $0.GetStreakRequest request);

  $async.Future<$0.AdminRestoreStreakResponse> adminRestoreStreak_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.AdminRestoreStreakRequest> $request) async {
    return adminRestoreStreak($call, await $request);
  }

  $async.Future<$0.AdminRestoreStreakResponse> adminRestoreStreak(
      $grpc.ServiceCall call, $0.AdminRestoreStreakRequest request);
}
