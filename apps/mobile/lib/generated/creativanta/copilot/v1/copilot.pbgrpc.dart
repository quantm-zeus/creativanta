// This is a generated file - do not edit.
//
// Generated from creativanta/copilot/v1/copilot.proto.

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

import 'copilot.pb.dart' as $0;

export 'copilot.pb.dart';

/// CopilotService provides conversational operational intelligence, action guidance,
/// and quoted draft generation across the Creativanta operating graph.
@$pb.GrpcServiceName('creativanta.copilot.v1.CopilotService')
class CopilotServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  CopilotServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.CopilotServiceQueryResponse> query(
    $0.CopilotServiceQueryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$query, request, options: options);
  }

  $grpc.ResponseFuture<$0.CopilotServiceGetSuggestionsResponse> getSuggestions(
    $0.CopilotServiceGetSuggestionsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getSuggestions, request, options: options);
  }

  $grpc.ResponseFuture<$0.CopilotServiceGetContextualActionsResponse>
      getContextualActions(
    $0.CopilotServiceGetContextualActionsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getContextualActions, request, options: options);
  }

  $grpc.ResponseFuture<$0.CopilotServiceSetContextResponse> setContext(
    $0.CopilotServiceSetContextRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$setContext, request, options: options);
  }

  $grpc.ResponseFuture<$0.CopilotServiceGetHistoryResponse> getHistory(
    $0.CopilotServiceGetHistoryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getHistory, request, options: options);
  }

  $grpc.ResponseFuture<$0.CopilotServiceChatResponse> chat(
    $0.CopilotServiceChatRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$chat, request, options: options);
  }

  $grpc.ResponseFuture<$0.CopilotServiceSendMessageResponse> sendMessage(
    $0.CopilotServiceSendMessageRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$sendMessage, request, options: options);
  }

  $grpc.ResponseFuture<$0.CopilotServiceGetSessionResponse> getSession(
    $0.CopilotServiceGetSessionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getSession, request, options: options);
  }

  $grpc.ResponseFuture<$0.CopilotServiceClearSessionResponse> clearSession(
    $0.CopilotServiceClearSessionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$clearSession, request, options: options);
  }

  $grpc.ResponseFuture<$0.CopilotServiceFeedbackResponse> feedback(
    $0.CopilotServiceFeedbackRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$feedback, request, options: options);
  }

  $grpc.ResponseFuture<$0.CopilotServiceGenerateIdeasResponse> generateIdeas(
    $0.CopilotServiceGenerateIdeasRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$generateIdeas, request, options: options);
  }

  $grpc.ResponseFuture<$0.CopilotServiceGenerateCaptionResponse>
      generateCaption(
    $0.CopilotServiceGenerateCaptionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$generateCaption, request, options: options);
  }

  $grpc.ResponseFuture<$0.CopilotServiceGenerateReplyResponse> generateReply(
    $0.CopilotServiceGenerateReplyRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$generateReply, request, options: options);
  }

  $grpc.ResponseFuture<$0.CopilotServiceGenerateAvatarResponse> generateAvatar(
    $0.CopilotServiceGenerateAvatarRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$generateAvatar, request, options: options);
  }

  $grpc.ResponseFuture<$0.CopilotServiceShortenCaptionResponse> shortenCaption(
    $0.CopilotServiceShortenCaptionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$shortenCaption, request, options: options);
  }

  $grpc.ResponseFuture<$0.CopilotServiceSuggestHashtagsResponse>
      suggestHashtags(
    $0.CopilotServiceSuggestHashtagsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$suggestHashtags, request, options: options);
  }

  $grpc.ResponseFuture<$0.CopilotServiceDismissReplyResponse> dismissReply(
    $0.CopilotServiceDismissReplyRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$dismissReply, request, options: options);
  }

  $grpc.ResponseFuture<$0.CopilotServiceRegenerateSectionResponse>
      regenerateSection(
    $0.CopilotServiceRegenerateSectionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$regenerateSection, request, options: options);
  }

  $grpc.ResponseFuture<$0.CopilotServiceScoreIdeaResponse> scoreIdea(
    $0.CopilotServiceScoreIdeaRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$scoreIdea, request, options: options);
  }

  $grpc.ResponseFuture<$0.CopilotServiceCheckBrandVoiceResponse>
      checkBrandVoice(
    $0.CopilotServiceCheckBrandVoiceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$checkBrandVoice, request, options: options);
  }

  $grpc.ResponseFuture<$0.CopilotServiceAnalyzeAnalyticsResponse>
      analyzeAnalytics(
    $0.CopilotServiceAnalyzeAnalyticsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$analyzeAnalytics, request, options: options);
  }

  $grpc.ResponseFuture<$0.CopilotServiceAnalyzePipelineResponse>
      analyzePipeline(
    $0.CopilotServiceAnalyzePipelineRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$analyzePipeline, request, options: options);
  }

  $grpc.ResponseFuture<$0.CopilotServiceAnalyticsInsightsResponse>
      analyticsInsights(
    $0.CopilotServiceAnalyticsInsightsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$analyticsInsights, request, options: options);
  }

  $grpc.ResponseFuture<$0.CopilotServiceFinanceInsightResponse> financeInsight(
    $0.CopilotServiceFinanceInsightRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$financeInsight, request, options: options);
  }

  $grpc.ResponseFuture<$0.CopilotServiceTrendInsightResponse> trendInsight(
    $0.CopilotServiceTrendInsightRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$trendInsight, request, options: options);
  }

  $grpc.ResponseFuture<$0.CopilotServiceGetContentOptimizationResponse>
      getContentOptimization(
    $0.CopilotServiceGetContentOptimizationRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getContentOptimization, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.CopilotServiceGetCostOptimizationResponse>
      getCostOptimization(
    $0.CopilotServiceGetCostOptimizationRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getCostOptimization, request, options: options);
  }

  $grpc.ResponseFuture<$0.CopilotServiceGetOptimalTimesResponse>
      getOptimalTimes(
    $0.CopilotServiceGetOptimalTimesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getOptimalTimes, request, options: options);
  }

  // method descriptors

  static final _$query = $grpc.ClientMethod<$0.CopilotServiceQueryRequest,
          $0.CopilotServiceQueryResponse>(
      '/creativanta.copilot.v1.CopilotService/Query',
      ($0.CopilotServiceQueryRequest value) => value.writeToBuffer(),
      $0.CopilotServiceQueryResponse.fromBuffer);
  static final _$getSuggestions = $grpc.ClientMethod<
          $0.CopilotServiceGetSuggestionsRequest,
          $0.CopilotServiceGetSuggestionsResponse>(
      '/creativanta.copilot.v1.CopilotService/GetSuggestions',
      ($0.CopilotServiceGetSuggestionsRequest value) => value.writeToBuffer(),
      $0.CopilotServiceGetSuggestionsResponse.fromBuffer);
  static final _$getContextualActions = $grpc.ClientMethod<
          $0.CopilotServiceGetContextualActionsRequest,
          $0.CopilotServiceGetContextualActionsResponse>(
      '/creativanta.copilot.v1.CopilotService/GetContextualActions',
      ($0.CopilotServiceGetContextualActionsRequest value) =>
          value.writeToBuffer(),
      $0.CopilotServiceGetContextualActionsResponse.fromBuffer);
  static final _$setContext = $grpc.ClientMethod<
          $0.CopilotServiceSetContextRequest,
          $0.CopilotServiceSetContextResponse>(
      '/creativanta.copilot.v1.CopilotService/SetContext',
      ($0.CopilotServiceSetContextRequest value) => value.writeToBuffer(),
      $0.CopilotServiceSetContextResponse.fromBuffer);
  static final _$getHistory = $grpc.ClientMethod<
          $0.CopilotServiceGetHistoryRequest,
          $0.CopilotServiceGetHistoryResponse>(
      '/creativanta.copilot.v1.CopilotService/GetHistory',
      ($0.CopilotServiceGetHistoryRequest value) => value.writeToBuffer(),
      $0.CopilotServiceGetHistoryResponse.fromBuffer);
  static final _$chat = $grpc.ClientMethod<$0.CopilotServiceChatRequest,
          $0.CopilotServiceChatResponse>(
      '/creativanta.copilot.v1.CopilotService/Chat',
      ($0.CopilotServiceChatRequest value) => value.writeToBuffer(),
      $0.CopilotServiceChatResponse.fromBuffer);
  static final _$sendMessage = $grpc.ClientMethod<
          $0.CopilotServiceSendMessageRequest,
          $0.CopilotServiceSendMessageResponse>(
      '/creativanta.copilot.v1.CopilotService/SendMessage',
      ($0.CopilotServiceSendMessageRequest value) => value.writeToBuffer(),
      $0.CopilotServiceSendMessageResponse.fromBuffer);
  static final _$getSession = $grpc.ClientMethod<
          $0.CopilotServiceGetSessionRequest,
          $0.CopilotServiceGetSessionResponse>(
      '/creativanta.copilot.v1.CopilotService/GetSession',
      ($0.CopilotServiceGetSessionRequest value) => value.writeToBuffer(),
      $0.CopilotServiceGetSessionResponse.fromBuffer);
  static final _$clearSession = $grpc.ClientMethod<
          $0.CopilotServiceClearSessionRequest,
          $0.CopilotServiceClearSessionResponse>(
      '/creativanta.copilot.v1.CopilotService/ClearSession',
      ($0.CopilotServiceClearSessionRequest value) => value.writeToBuffer(),
      $0.CopilotServiceClearSessionResponse.fromBuffer);
  static final _$feedback = $grpc.ClientMethod<$0.CopilotServiceFeedbackRequest,
          $0.CopilotServiceFeedbackResponse>(
      '/creativanta.copilot.v1.CopilotService/Feedback',
      ($0.CopilotServiceFeedbackRequest value) => value.writeToBuffer(),
      $0.CopilotServiceFeedbackResponse.fromBuffer);
  static final _$generateIdeas = $grpc.ClientMethod<
          $0.CopilotServiceGenerateIdeasRequest,
          $0.CopilotServiceGenerateIdeasResponse>(
      '/creativanta.copilot.v1.CopilotService/GenerateIdeas',
      ($0.CopilotServiceGenerateIdeasRequest value) => value.writeToBuffer(),
      $0.CopilotServiceGenerateIdeasResponse.fromBuffer);
  static final _$generateCaption = $grpc.ClientMethod<
          $0.CopilotServiceGenerateCaptionRequest,
          $0.CopilotServiceGenerateCaptionResponse>(
      '/creativanta.copilot.v1.CopilotService/GenerateCaption',
      ($0.CopilotServiceGenerateCaptionRequest value) => value.writeToBuffer(),
      $0.CopilotServiceGenerateCaptionResponse.fromBuffer);
  static final _$generateReply = $grpc.ClientMethod<
          $0.CopilotServiceGenerateReplyRequest,
          $0.CopilotServiceGenerateReplyResponse>(
      '/creativanta.copilot.v1.CopilotService/GenerateReply',
      ($0.CopilotServiceGenerateReplyRequest value) => value.writeToBuffer(),
      $0.CopilotServiceGenerateReplyResponse.fromBuffer);
  static final _$generateAvatar = $grpc.ClientMethod<
          $0.CopilotServiceGenerateAvatarRequest,
          $0.CopilotServiceGenerateAvatarResponse>(
      '/creativanta.copilot.v1.CopilotService/GenerateAvatar',
      ($0.CopilotServiceGenerateAvatarRequest value) => value.writeToBuffer(),
      $0.CopilotServiceGenerateAvatarResponse.fromBuffer);
  static final _$shortenCaption = $grpc.ClientMethod<
          $0.CopilotServiceShortenCaptionRequest,
          $0.CopilotServiceShortenCaptionResponse>(
      '/creativanta.copilot.v1.CopilotService/ShortenCaption',
      ($0.CopilotServiceShortenCaptionRequest value) => value.writeToBuffer(),
      $0.CopilotServiceShortenCaptionResponse.fromBuffer);
  static final _$suggestHashtags = $grpc.ClientMethod<
          $0.CopilotServiceSuggestHashtagsRequest,
          $0.CopilotServiceSuggestHashtagsResponse>(
      '/creativanta.copilot.v1.CopilotService/SuggestHashtags',
      ($0.CopilotServiceSuggestHashtagsRequest value) => value.writeToBuffer(),
      $0.CopilotServiceSuggestHashtagsResponse.fromBuffer);
  static final _$dismissReply = $grpc.ClientMethod<
          $0.CopilotServiceDismissReplyRequest,
          $0.CopilotServiceDismissReplyResponse>(
      '/creativanta.copilot.v1.CopilotService/DismissReply',
      ($0.CopilotServiceDismissReplyRequest value) => value.writeToBuffer(),
      $0.CopilotServiceDismissReplyResponse.fromBuffer);
  static final _$regenerateSection = $grpc.ClientMethod<
          $0.CopilotServiceRegenerateSectionRequest,
          $0.CopilotServiceRegenerateSectionResponse>(
      '/creativanta.copilot.v1.CopilotService/RegenerateSection',
      ($0.CopilotServiceRegenerateSectionRequest value) =>
          value.writeToBuffer(),
      $0.CopilotServiceRegenerateSectionResponse.fromBuffer);
  static final _$scoreIdea = $grpc.ClientMethod<
          $0.CopilotServiceScoreIdeaRequest,
          $0.CopilotServiceScoreIdeaResponse>(
      '/creativanta.copilot.v1.CopilotService/ScoreIdea',
      ($0.CopilotServiceScoreIdeaRequest value) => value.writeToBuffer(),
      $0.CopilotServiceScoreIdeaResponse.fromBuffer);
  static final _$checkBrandVoice = $grpc.ClientMethod<
          $0.CopilotServiceCheckBrandVoiceRequest,
          $0.CopilotServiceCheckBrandVoiceResponse>(
      '/creativanta.copilot.v1.CopilotService/CheckBrandVoice',
      ($0.CopilotServiceCheckBrandVoiceRequest value) => value.writeToBuffer(),
      $0.CopilotServiceCheckBrandVoiceResponse.fromBuffer);
  static final _$analyzeAnalytics = $grpc.ClientMethod<
          $0.CopilotServiceAnalyzeAnalyticsRequest,
          $0.CopilotServiceAnalyzeAnalyticsResponse>(
      '/creativanta.copilot.v1.CopilotService/AnalyzeAnalytics',
      ($0.CopilotServiceAnalyzeAnalyticsRequest value) => value.writeToBuffer(),
      $0.CopilotServiceAnalyzeAnalyticsResponse.fromBuffer);
  static final _$analyzePipeline = $grpc.ClientMethod<
          $0.CopilotServiceAnalyzePipelineRequest,
          $0.CopilotServiceAnalyzePipelineResponse>(
      '/creativanta.copilot.v1.CopilotService/AnalyzePipeline',
      ($0.CopilotServiceAnalyzePipelineRequest value) => value.writeToBuffer(),
      $0.CopilotServiceAnalyzePipelineResponse.fromBuffer);
  static final _$analyticsInsights = $grpc.ClientMethod<
          $0.CopilotServiceAnalyticsInsightsRequest,
          $0.CopilotServiceAnalyticsInsightsResponse>(
      '/creativanta.copilot.v1.CopilotService/AnalyticsInsights',
      ($0.CopilotServiceAnalyticsInsightsRequest value) =>
          value.writeToBuffer(),
      $0.CopilotServiceAnalyticsInsightsResponse.fromBuffer);
  static final _$financeInsight = $grpc.ClientMethod<
          $0.CopilotServiceFinanceInsightRequest,
          $0.CopilotServiceFinanceInsightResponse>(
      '/creativanta.copilot.v1.CopilotService/FinanceInsight',
      ($0.CopilotServiceFinanceInsightRequest value) => value.writeToBuffer(),
      $0.CopilotServiceFinanceInsightResponse.fromBuffer);
  static final _$trendInsight = $grpc.ClientMethod<
          $0.CopilotServiceTrendInsightRequest,
          $0.CopilotServiceTrendInsightResponse>(
      '/creativanta.copilot.v1.CopilotService/TrendInsight',
      ($0.CopilotServiceTrendInsightRequest value) => value.writeToBuffer(),
      $0.CopilotServiceTrendInsightResponse.fromBuffer);
  static final _$getContentOptimization = $grpc.ClientMethod<
          $0.CopilotServiceGetContentOptimizationRequest,
          $0.CopilotServiceGetContentOptimizationResponse>(
      '/creativanta.copilot.v1.CopilotService/GetContentOptimization',
      ($0.CopilotServiceGetContentOptimizationRequest value) =>
          value.writeToBuffer(),
      $0.CopilotServiceGetContentOptimizationResponse.fromBuffer);
  static final _$getCostOptimization = $grpc.ClientMethod<
          $0.CopilotServiceGetCostOptimizationRequest,
          $0.CopilotServiceGetCostOptimizationResponse>(
      '/creativanta.copilot.v1.CopilotService/GetCostOptimization',
      ($0.CopilotServiceGetCostOptimizationRequest value) =>
          value.writeToBuffer(),
      $0.CopilotServiceGetCostOptimizationResponse.fromBuffer);
  static final _$getOptimalTimes = $grpc.ClientMethod<
          $0.CopilotServiceGetOptimalTimesRequest,
          $0.CopilotServiceGetOptimalTimesResponse>(
      '/creativanta.copilot.v1.CopilotService/GetOptimalTimes',
      ($0.CopilotServiceGetOptimalTimesRequest value) => value.writeToBuffer(),
      $0.CopilotServiceGetOptimalTimesResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.copilot.v1.CopilotService')
abstract class CopilotServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.copilot.v1.CopilotService';

  CopilotServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CopilotServiceQueryRequest,
            $0.CopilotServiceQueryResponse>(
        'Query',
        query_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CopilotServiceQueryRequest.fromBuffer(value),
        ($0.CopilotServiceQueryResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CopilotServiceGetSuggestionsRequest,
            $0.CopilotServiceGetSuggestionsResponse>(
        'GetSuggestions',
        getSuggestions_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CopilotServiceGetSuggestionsRequest.fromBuffer(value),
        ($0.CopilotServiceGetSuggestionsResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CopilotServiceGetContextualActionsRequest,
            $0.CopilotServiceGetContextualActionsResponse>(
        'GetContextualActions',
        getContextualActions_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CopilotServiceGetContextualActionsRequest.fromBuffer(value),
        ($0.CopilotServiceGetContextualActionsResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CopilotServiceSetContextRequest,
            $0.CopilotServiceSetContextResponse>(
        'SetContext',
        setContext_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CopilotServiceSetContextRequest.fromBuffer(value),
        ($0.CopilotServiceSetContextResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CopilotServiceGetHistoryRequest,
            $0.CopilotServiceGetHistoryResponse>(
        'GetHistory',
        getHistory_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CopilotServiceGetHistoryRequest.fromBuffer(value),
        ($0.CopilotServiceGetHistoryResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CopilotServiceChatRequest,
            $0.CopilotServiceChatResponse>(
        'Chat',
        chat_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CopilotServiceChatRequest.fromBuffer(value),
        ($0.CopilotServiceChatResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CopilotServiceSendMessageRequest,
            $0.CopilotServiceSendMessageResponse>(
        'SendMessage',
        sendMessage_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CopilotServiceSendMessageRequest.fromBuffer(value),
        ($0.CopilotServiceSendMessageResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CopilotServiceGetSessionRequest,
            $0.CopilotServiceGetSessionResponse>(
        'GetSession',
        getSession_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CopilotServiceGetSessionRequest.fromBuffer(value),
        ($0.CopilotServiceGetSessionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CopilotServiceClearSessionRequest,
            $0.CopilotServiceClearSessionResponse>(
        'ClearSession',
        clearSession_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CopilotServiceClearSessionRequest.fromBuffer(value),
        ($0.CopilotServiceClearSessionResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CopilotServiceFeedbackRequest,
            $0.CopilotServiceFeedbackResponse>(
        'Feedback',
        feedback_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CopilotServiceFeedbackRequest.fromBuffer(value),
        ($0.CopilotServiceFeedbackResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CopilotServiceGenerateIdeasRequest,
            $0.CopilotServiceGenerateIdeasResponse>(
        'GenerateIdeas',
        generateIdeas_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CopilotServiceGenerateIdeasRequest.fromBuffer(value),
        ($0.CopilotServiceGenerateIdeasResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CopilotServiceGenerateCaptionRequest,
            $0.CopilotServiceGenerateCaptionResponse>(
        'GenerateCaption',
        generateCaption_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CopilotServiceGenerateCaptionRequest.fromBuffer(value),
        ($0.CopilotServiceGenerateCaptionResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CopilotServiceGenerateReplyRequest,
            $0.CopilotServiceGenerateReplyResponse>(
        'GenerateReply',
        generateReply_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CopilotServiceGenerateReplyRequest.fromBuffer(value),
        ($0.CopilotServiceGenerateReplyResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CopilotServiceGenerateAvatarRequest,
            $0.CopilotServiceGenerateAvatarResponse>(
        'GenerateAvatar',
        generateAvatar_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CopilotServiceGenerateAvatarRequest.fromBuffer(value),
        ($0.CopilotServiceGenerateAvatarResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CopilotServiceShortenCaptionRequest,
            $0.CopilotServiceShortenCaptionResponse>(
        'ShortenCaption',
        shortenCaption_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CopilotServiceShortenCaptionRequest.fromBuffer(value),
        ($0.CopilotServiceShortenCaptionResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CopilotServiceSuggestHashtagsRequest,
            $0.CopilotServiceSuggestHashtagsResponse>(
        'SuggestHashtags',
        suggestHashtags_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CopilotServiceSuggestHashtagsRequest.fromBuffer(value),
        ($0.CopilotServiceSuggestHashtagsResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CopilotServiceDismissReplyRequest,
            $0.CopilotServiceDismissReplyResponse>(
        'DismissReply',
        dismissReply_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CopilotServiceDismissReplyRequest.fromBuffer(value),
        ($0.CopilotServiceDismissReplyResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CopilotServiceRegenerateSectionRequest,
            $0.CopilotServiceRegenerateSectionResponse>(
        'RegenerateSection',
        regenerateSection_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CopilotServiceRegenerateSectionRequest.fromBuffer(value),
        ($0.CopilotServiceRegenerateSectionResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CopilotServiceScoreIdeaRequest,
            $0.CopilotServiceScoreIdeaResponse>(
        'ScoreIdea',
        scoreIdea_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CopilotServiceScoreIdeaRequest.fromBuffer(value),
        ($0.CopilotServiceScoreIdeaResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CopilotServiceCheckBrandVoiceRequest,
            $0.CopilotServiceCheckBrandVoiceResponse>(
        'CheckBrandVoice',
        checkBrandVoice_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CopilotServiceCheckBrandVoiceRequest.fromBuffer(value),
        ($0.CopilotServiceCheckBrandVoiceResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CopilotServiceAnalyzeAnalyticsRequest,
            $0.CopilotServiceAnalyzeAnalyticsResponse>(
        'AnalyzeAnalytics',
        analyzeAnalytics_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CopilotServiceAnalyzeAnalyticsRequest.fromBuffer(value),
        ($0.CopilotServiceAnalyzeAnalyticsResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CopilotServiceAnalyzePipelineRequest,
            $0.CopilotServiceAnalyzePipelineResponse>(
        'AnalyzePipeline',
        analyzePipeline_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CopilotServiceAnalyzePipelineRequest.fromBuffer(value),
        ($0.CopilotServiceAnalyzePipelineResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CopilotServiceAnalyticsInsightsRequest,
            $0.CopilotServiceAnalyticsInsightsResponse>(
        'AnalyticsInsights',
        analyticsInsights_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CopilotServiceAnalyticsInsightsRequest.fromBuffer(value),
        ($0.CopilotServiceAnalyticsInsightsResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CopilotServiceFinanceInsightRequest,
            $0.CopilotServiceFinanceInsightResponse>(
        'FinanceInsight',
        financeInsight_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CopilotServiceFinanceInsightRequest.fromBuffer(value),
        ($0.CopilotServiceFinanceInsightResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CopilotServiceTrendInsightRequest,
            $0.CopilotServiceTrendInsightResponse>(
        'TrendInsight',
        trendInsight_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CopilotServiceTrendInsightRequest.fromBuffer(value),
        ($0.CopilotServiceTrendInsightResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<
            $0.CopilotServiceGetContentOptimizationRequest,
            $0.CopilotServiceGetContentOptimizationResponse>(
        'GetContentOptimization',
        getContentOptimization_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CopilotServiceGetContentOptimizationRequest.fromBuffer(value),
        ($0.CopilotServiceGetContentOptimizationResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CopilotServiceGetCostOptimizationRequest,
            $0.CopilotServiceGetCostOptimizationResponse>(
        'GetCostOptimization',
        getCostOptimization_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CopilotServiceGetCostOptimizationRequest.fromBuffer(value),
        ($0.CopilotServiceGetCostOptimizationResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CopilotServiceGetOptimalTimesRequest,
            $0.CopilotServiceGetOptimalTimesResponse>(
        'GetOptimalTimes',
        getOptimalTimes_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CopilotServiceGetOptimalTimesRequest.fromBuffer(value),
        ($0.CopilotServiceGetOptimalTimesResponse value) =>
            value.writeToBuffer()));
  }

  $async.Future<$0.CopilotServiceQueryResponse> query_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CopilotServiceQueryRequest> $request) async {
    return query($call, await $request);
  }

  $async.Future<$0.CopilotServiceQueryResponse> query(
      $grpc.ServiceCall call, $0.CopilotServiceQueryRequest request);

  $async.Future<$0.CopilotServiceGetSuggestionsResponse> getSuggestions_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CopilotServiceGetSuggestionsRequest> $request) async {
    return getSuggestions($call, await $request);
  }

  $async.Future<$0.CopilotServiceGetSuggestionsResponse> getSuggestions(
      $grpc.ServiceCall call, $0.CopilotServiceGetSuggestionsRequest request);

  $async.Future<$0.CopilotServiceGetContextualActionsResponse>
      getContextualActions_Pre(
          $grpc.ServiceCall $call,
          $async.Future<$0.CopilotServiceGetContextualActionsRequest>
              $request) async {
    return getContextualActions($call, await $request);
  }

  $async.Future<$0.CopilotServiceGetContextualActionsResponse>
      getContextualActions($grpc.ServiceCall call,
          $0.CopilotServiceGetContextualActionsRequest request);

  $async.Future<$0.CopilotServiceSetContextResponse> setContext_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CopilotServiceSetContextRequest> $request) async {
    return setContext($call, await $request);
  }

  $async.Future<$0.CopilotServiceSetContextResponse> setContext(
      $grpc.ServiceCall call, $0.CopilotServiceSetContextRequest request);

  $async.Future<$0.CopilotServiceGetHistoryResponse> getHistory_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CopilotServiceGetHistoryRequest> $request) async {
    return getHistory($call, await $request);
  }

  $async.Future<$0.CopilotServiceGetHistoryResponse> getHistory(
      $grpc.ServiceCall call, $0.CopilotServiceGetHistoryRequest request);

  $async.Future<$0.CopilotServiceChatResponse> chat_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CopilotServiceChatRequest> $request) async {
    return chat($call, await $request);
  }

  $async.Future<$0.CopilotServiceChatResponse> chat(
      $grpc.ServiceCall call, $0.CopilotServiceChatRequest request);

  $async.Future<$0.CopilotServiceSendMessageResponse> sendMessage_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CopilotServiceSendMessageRequest> $request) async {
    return sendMessage($call, await $request);
  }

  $async.Future<$0.CopilotServiceSendMessageResponse> sendMessage(
      $grpc.ServiceCall call, $0.CopilotServiceSendMessageRequest request);

  $async.Future<$0.CopilotServiceGetSessionResponse> getSession_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CopilotServiceGetSessionRequest> $request) async {
    return getSession($call, await $request);
  }

  $async.Future<$0.CopilotServiceGetSessionResponse> getSession(
      $grpc.ServiceCall call, $0.CopilotServiceGetSessionRequest request);

  $async.Future<$0.CopilotServiceClearSessionResponse> clearSession_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CopilotServiceClearSessionRequest> $request) async {
    return clearSession($call, await $request);
  }

  $async.Future<$0.CopilotServiceClearSessionResponse> clearSession(
      $grpc.ServiceCall call, $0.CopilotServiceClearSessionRequest request);

  $async.Future<$0.CopilotServiceFeedbackResponse> feedback_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CopilotServiceFeedbackRequest> $request) async {
    return feedback($call, await $request);
  }

  $async.Future<$0.CopilotServiceFeedbackResponse> feedback(
      $grpc.ServiceCall call, $0.CopilotServiceFeedbackRequest request);

  $async.Future<$0.CopilotServiceGenerateIdeasResponse> generateIdeas_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CopilotServiceGenerateIdeasRequest> $request) async {
    return generateIdeas($call, await $request);
  }

  $async.Future<$0.CopilotServiceGenerateIdeasResponse> generateIdeas(
      $grpc.ServiceCall call, $0.CopilotServiceGenerateIdeasRequest request);

  $async.Future<$0.CopilotServiceGenerateCaptionResponse> generateCaption_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CopilotServiceGenerateCaptionRequest> $request) async {
    return generateCaption($call, await $request);
  }

  $async.Future<$0.CopilotServiceGenerateCaptionResponse> generateCaption(
      $grpc.ServiceCall call, $0.CopilotServiceGenerateCaptionRequest request);

  $async.Future<$0.CopilotServiceGenerateReplyResponse> generateReply_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CopilotServiceGenerateReplyRequest> $request) async {
    return generateReply($call, await $request);
  }

  $async.Future<$0.CopilotServiceGenerateReplyResponse> generateReply(
      $grpc.ServiceCall call, $0.CopilotServiceGenerateReplyRequest request);

  $async.Future<$0.CopilotServiceGenerateAvatarResponse> generateAvatar_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CopilotServiceGenerateAvatarRequest> $request) async {
    return generateAvatar($call, await $request);
  }

  $async.Future<$0.CopilotServiceGenerateAvatarResponse> generateAvatar(
      $grpc.ServiceCall call, $0.CopilotServiceGenerateAvatarRequest request);

  $async.Future<$0.CopilotServiceShortenCaptionResponse> shortenCaption_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CopilotServiceShortenCaptionRequest> $request) async {
    return shortenCaption($call, await $request);
  }

  $async.Future<$0.CopilotServiceShortenCaptionResponse> shortenCaption(
      $grpc.ServiceCall call, $0.CopilotServiceShortenCaptionRequest request);

  $async.Future<$0.CopilotServiceSuggestHashtagsResponse> suggestHashtags_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CopilotServiceSuggestHashtagsRequest> $request) async {
    return suggestHashtags($call, await $request);
  }

  $async.Future<$0.CopilotServiceSuggestHashtagsResponse> suggestHashtags(
      $grpc.ServiceCall call, $0.CopilotServiceSuggestHashtagsRequest request);

  $async.Future<$0.CopilotServiceDismissReplyResponse> dismissReply_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CopilotServiceDismissReplyRequest> $request) async {
    return dismissReply($call, await $request);
  }

  $async.Future<$0.CopilotServiceDismissReplyResponse> dismissReply(
      $grpc.ServiceCall call, $0.CopilotServiceDismissReplyRequest request);

  $async.Future<$0.CopilotServiceRegenerateSectionResponse>
      regenerateSection_Pre(
          $grpc.ServiceCall $call,
          $async.Future<$0.CopilotServiceRegenerateSectionRequest>
              $request) async {
    return regenerateSection($call, await $request);
  }

  $async.Future<$0.CopilotServiceRegenerateSectionResponse> regenerateSection(
      $grpc.ServiceCall call,
      $0.CopilotServiceRegenerateSectionRequest request);

  $async.Future<$0.CopilotServiceScoreIdeaResponse> scoreIdea_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CopilotServiceScoreIdeaRequest> $request) async {
    return scoreIdea($call, await $request);
  }

  $async.Future<$0.CopilotServiceScoreIdeaResponse> scoreIdea(
      $grpc.ServiceCall call, $0.CopilotServiceScoreIdeaRequest request);

  $async.Future<$0.CopilotServiceCheckBrandVoiceResponse> checkBrandVoice_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CopilotServiceCheckBrandVoiceRequest> $request) async {
    return checkBrandVoice($call, await $request);
  }

  $async.Future<$0.CopilotServiceCheckBrandVoiceResponse> checkBrandVoice(
      $grpc.ServiceCall call, $0.CopilotServiceCheckBrandVoiceRequest request);

  $async.Future<$0.CopilotServiceAnalyzeAnalyticsResponse> analyzeAnalytics_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CopilotServiceAnalyzeAnalyticsRequest> $request) async {
    return analyzeAnalytics($call, await $request);
  }

  $async.Future<$0.CopilotServiceAnalyzeAnalyticsResponse> analyzeAnalytics(
      $grpc.ServiceCall call, $0.CopilotServiceAnalyzeAnalyticsRequest request);

  $async.Future<$0.CopilotServiceAnalyzePipelineResponse> analyzePipeline_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CopilotServiceAnalyzePipelineRequest> $request) async {
    return analyzePipeline($call, await $request);
  }

  $async.Future<$0.CopilotServiceAnalyzePipelineResponse> analyzePipeline(
      $grpc.ServiceCall call, $0.CopilotServiceAnalyzePipelineRequest request);

  $async.Future<$0.CopilotServiceAnalyticsInsightsResponse>
      analyticsInsights_Pre(
          $grpc.ServiceCall $call,
          $async.Future<$0.CopilotServiceAnalyticsInsightsRequest>
              $request) async {
    return analyticsInsights($call, await $request);
  }

  $async.Future<$0.CopilotServiceAnalyticsInsightsResponse> analyticsInsights(
      $grpc.ServiceCall call,
      $0.CopilotServiceAnalyticsInsightsRequest request);

  $async.Future<$0.CopilotServiceFinanceInsightResponse> financeInsight_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CopilotServiceFinanceInsightRequest> $request) async {
    return financeInsight($call, await $request);
  }

  $async.Future<$0.CopilotServiceFinanceInsightResponse> financeInsight(
      $grpc.ServiceCall call, $0.CopilotServiceFinanceInsightRequest request);

  $async.Future<$0.CopilotServiceTrendInsightResponse> trendInsight_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CopilotServiceTrendInsightRequest> $request) async {
    return trendInsight($call, await $request);
  }

  $async.Future<$0.CopilotServiceTrendInsightResponse> trendInsight(
      $grpc.ServiceCall call, $0.CopilotServiceTrendInsightRequest request);

  $async.Future<$0.CopilotServiceGetContentOptimizationResponse>
      getContentOptimization_Pre(
          $grpc.ServiceCall $call,
          $async.Future<$0.CopilotServiceGetContentOptimizationRequest>
              $request) async {
    return getContentOptimization($call, await $request);
  }

  $async.Future<$0.CopilotServiceGetContentOptimizationResponse>
      getContentOptimization($grpc.ServiceCall call,
          $0.CopilotServiceGetContentOptimizationRequest request);

  $async.Future<$0.CopilotServiceGetCostOptimizationResponse>
      getCostOptimization_Pre(
          $grpc.ServiceCall $call,
          $async.Future<$0.CopilotServiceGetCostOptimizationRequest>
              $request) async {
    return getCostOptimization($call, await $request);
  }

  $async.Future<$0.CopilotServiceGetCostOptimizationResponse>
      getCostOptimization($grpc.ServiceCall call,
          $0.CopilotServiceGetCostOptimizationRequest request);

  $async.Future<$0.CopilotServiceGetOptimalTimesResponse> getOptimalTimes_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CopilotServiceGetOptimalTimesRequest> $request) async {
    return getOptimalTimes($call, await $request);
  }

  $async.Future<$0.CopilotServiceGetOptimalTimesResponse> getOptimalTimes(
      $grpc.ServiceCall call, $0.CopilotServiceGetOptimalTimesRequest request);
}
