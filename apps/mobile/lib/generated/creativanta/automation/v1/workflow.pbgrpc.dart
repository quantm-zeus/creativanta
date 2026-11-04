// This is a generated file - do not edit.
//
// Generated from creativanta/automation/v1/workflow.proto.

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

import 'workflow.pb.dart' as $0;

export 'workflow.pb.dart';

@$pb.GrpcServiceName('creativanta.automation.v1.WorkflowService')
class WorkflowServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  WorkflowServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.WorkflowServiceCreateResponse> create(
    $0.WorkflowServiceCreateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$create, request, options: options);
  }

  $grpc.ResponseFuture<$0.WorkflowServiceGetResponse> get(
    $0.WorkflowServiceGetRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$get, request, options: options);
  }

  $grpc.ResponseFuture<$0.WorkflowServiceListResponse> list(
    $0.WorkflowServiceListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$list, request, options: options);
  }

  $grpc.ResponseFuture<$0.WorkflowServiceUpdateResponse> update(
    $0.WorkflowServiceUpdateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$update, request, options: options);
  }

  $grpc.ResponseFuture<$0.WorkflowServiceActivateResponse> activate(
    $0.WorkflowServiceActivateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$activate, request, options: options);
  }

  $grpc.ResponseFuture<$0.WorkflowServiceDeactivateResponse> deactivate(
    $0.WorkflowServiceDeactivateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deactivate, request, options: options);
  }

  $grpc.ResponseFuture<$0.WorkflowServiceRunResponse> run(
    $0.WorkflowServiceRunRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$run, request, options: options);
  }

  $grpc.ResponseFuture<$0.WorkflowServiceGetRunDetailResponse> getRunDetail(
    $0.WorkflowServiceGetRunDetailRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getRunDetail, request, options: options);
  }

  $grpc.ResponseFuture<$0.WorkflowServiceGetRunLogsResponse> getRunLogs(
    $0.WorkflowServiceGetRunLogsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getRunLogs, request, options: options);
  }

  $grpc.ResponseFuture<$0.WorkflowServiceListRunsResponse> listRuns(
    $0.WorkflowServiceListRunsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listRuns, request, options: options);
  }

  $grpc.ResponseFuture<$0.WorkflowServiceCloneResponse> clone(
    $0.WorkflowServiceCloneRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$clone, request, options: options);
  }

  $grpc.ResponseFuture<$0.WorkflowServiceExportResponse> export(
    $0.WorkflowServiceExportRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$export, request, options: options);
  }

  $grpc.ResponseFuture<$0.WorkflowServiceImportResponse> import(
    $0.WorkflowServiceImportRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$import, request, options: options);
  }

  $grpc.ResponseFuture<$0.WorkflowServiceTestResponse> test(
    $0.WorkflowServiceTestRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$test, request, options: options);
  }

  $grpc.ResponseFuture<$0.WorkflowServiceGetRunStatsResponse> getRunStats(
    $0.WorkflowServiceGetRunStatsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getRunStats, request, options: options);
  }

  $grpc.ResponseFuture<$0.WorkflowServiceCancelRunResponse> cancelRun(
    $0.WorkflowServiceCancelRunRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$cancelRun, request, options: options);
  }

  $grpc.ResponseFuture<$0.WorkflowServiceRetryRunResponse> retryRun(
    $0.WorkflowServiceRetryRunRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$retryRun, request, options: options);
  }

  $grpc.ResponseFuture<$0.WorkflowServiceDismissRunResponse> dismissRun(
    $0.WorkflowServiceDismissRunRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$dismissRun, request, options: options);
  }

  $grpc.ResponseFuture<$0.WorkflowServiceSkipStepResponse> skipStep(
    $0.WorkflowServiceSkipStepRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$skipStep, request, options: options);
  }

  $grpc.ResponseFuture<$0.WorkflowServiceProvideInputResponse> provideInput(
    $0.WorkflowServiceProvideInputRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$provideInput, request, options: options);
  }

  $grpc.ResponseFuture<$0.WorkflowServiceExportRunsResponse> exportRuns(
    $0.WorkflowServiceExportRunsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$exportRuns, request, options: options);
  }

  // method descriptors

  static final _$create = $grpc.ClientMethod<$0.WorkflowServiceCreateRequest,
          $0.WorkflowServiceCreateResponse>(
      '/creativanta.automation.v1.WorkflowService/Create',
      ($0.WorkflowServiceCreateRequest value) => value.writeToBuffer(),
      $0.WorkflowServiceCreateResponse.fromBuffer);
  static final _$get = $grpc.ClientMethod<$0.WorkflowServiceGetRequest,
          $0.WorkflowServiceGetResponse>(
      '/creativanta.automation.v1.WorkflowService/Get',
      ($0.WorkflowServiceGetRequest value) => value.writeToBuffer(),
      $0.WorkflowServiceGetResponse.fromBuffer);
  static final _$list = $grpc.ClientMethod<$0.WorkflowServiceListRequest,
          $0.WorkflowServiceListResponse>(
      '/creativanta.automation.v1.WorkflowService/List',
      ($0.WorkflowServiceListRequest value) => value.writeToBuffer(),
      $0.WorkflowServiceListResponse.fromBuffer);
  static final _$update = $grpc.ClientMethod<$0.WorkflowServiceUpdateRequest,
          $0.WorkflowServiceUpdateResponse>(
      '/creativanta.automation.v1.WorkflowService/Update',
      ($0.WorkflowServiceUpdateRequest value) => value.writeToBuffer(),
      $0.WorkflowServiceUpdateResponse.fromBuffer);
  static final _$activate = $grpc.ClientMethod<
          $0.WorkflowServiceActivateRequest,
          $0.WorkflowServiceActivateResponse>(
      '/creativanta.automation.v1.WorkflowService/Activate',
      ($0.WorkflowServiceActivateRequest value) => value.writeToBuffer(),
      $0.WorkflowServiceActivateResponse.fromBuffer);
  static final _$deactivate = $grpc.ClientMethod<
          $0.WorkflowServiceDeactivateRequest,
          $0.WorkflowServiceDeactivateResponse>(
      '/creativanta.automation.v1.WorkflowService/Deactivate',
      ($0.WorkflowServiceDeactivateRequest value) => value.writeToBuffer(),
      $0.WorkflowServiceDeactivateResponse.fromBuffer);
  static final _$run = $grpc.ClientMethod<$0.WorkflowServiceRunRequest,
          $0.WorkflowServiceRunResponse>(
      '/creativanta.automation.v1.WorkflowService/Run',
      ($0.WorkflowServiceRunRequest value) => value.writeToBuffer(),
      $0.WorkflowServiceRunResponse.fromBuffer);
  static final _$getRunDetail = $grpc.ClientMethod<
          $0.WorkflowServiceGetRunDetailRequest,
          $0.WorkflowServiceGetRunDetailResponse>(
      '/creativanta.automation.v1.WorkflowService/GetRunDetail',
      ($0.WorkflowServiceGetRunDetailRequest value) => value.writeToBuffer(),
      $0.WorkflowServiceGetRunDetailResponse.fromBuffer);
  static final _$getRunLogs = $grpc.ClientMethod<
          $0.WorkflowServiceGetRunLogsRequest,
          $0.WorkflowServiceGetRunLogsResponse>(
      '/creativanta.automation.v1.WorkflowService/GetRunLogs',
      ($0.WorkflowServiceGetRunLogsRequest value) => value.writeToBuffer(),
      $0.WorkflowServiceGetRunLogsResponse.fromBuffer);
  static final _$listRuns = $grpc.ClientMethod<
          $0.WorkflowServiceListRunsRequest,
          $0.WorkflowServiceListRunsResponse>(
      '/creativanta.automation.v1.WorkflowService/ListRuns',
      ($0.WorkflowServiceListRunsRequest value) => value.writeToBuffer(),
      $0.WorkflowServiceListRunsResponse.fromBuffer);
  static final _$clone = $grpc.ClientMethod<$0.WorkflowServiceCloneRequest,
          $0.WorkflowServiceCloneResponse>(
      '/creativanta.automation.v1.WorkflowService/Clone',
      ($0.WorkflowServiceCloneRequest value) => value.writeToBuffer(),
      $0.WorkflowServiceCloneResponse.fromBuffer);
  static final _$export = $grpc.ClientMethod<$0.WorkflowServiceExportRequest,
          $0.WorkflowServiceExportResponse>(
      '/creativanta.automation.v1.WorkflowService/Export',
      ($0.WorkflowServiceExportRequest value) => value.writeToBuffer(),
      $0.WorkflowServiceExportResponse.fromBuffer);
  static final _$import = $grpc.ClientMethod<$0.WorkflowServiceImportRequest,
          $0.WorkflowServiceImportResponse>(
      '/creativanta.automation.v1.WorkflowService/Import',
      ($0.WorkflowServiceImportRequest value) => value.writeToBuffer(),
      $0.WorkflowServiceImportResponse.fromBuffer);
  static final _$test = $grpc.ClientMethod<$0.WorkflowServiceTestRequest,
          $0.WorkflowServiceTestResponse>(
      '/creativanta.automation.v1.WorkflowService/Test',
      ($0.WorkflowServiceTestRequest value) => value.writeToBuffer(),
      $0.WorkflowServiceTestResponse.fromBuffer);
  static final _$getRunStats = $grpc.ClientMethod<
          $0.WorkflowServiceGetRunStatsRequest,
          $0.WorkflowServiceGetRunStatsResponse>(
      '/creativanta.automation.v1.WorkflowService/GetRunStats',
      ($0.WorkflowServiceGetRunStatsRequest value) => value.writeToBuffer(),
      $0.WorkflowServiceGetRunStatsResponse.fromBuffer);
  static final _$cancelRun = $grpc.ClientMethod<
          $0.WorkflowServiceCancelRunRequest,
          $0.WorkflowServiceCancelRunResponse>(
      '/creativanta.automation.v1.WorkflowService/CancelRun',
      ($0.WorkflowServiceCancelRunRequest value) => value.writeToBuffer(),
      $0.WorkflowServiceCancelRunResponse.fromBuffer);
  static final _$retryRun = $grpc.ClientMethod<
          $0.WorkflowServiceRetryRunRequest,
          $0.WorkflowServiceRetryRunResponse>(
      '/creativanta.automation.v1.WorkflowService/RetryRun',
      ($0.WorkflowServiceRetryRunRequest value) => value.writeToBuffer(),
      $0.WorkflowServiceRetryRunResponse.fromBuffer);
  static final _$dismissRun = $grpc.ClientMethod<
          $0.WorkflowServiceDismissRunRequest,
          $0.WorkflowServiceDismissRunResponse>(
      '/creativanta.automation.v1.WorkflowService/DismissRun',
      ($0.WorkflowServiceDismissRunRequest value) => value.writeToBuffer(),
      $0.WorkflowServiceDismissRunResponse.fromBuffer);
  static final _$skipStep = $grpc.ClientMethod<
          $0.WorkflowServiceSkipStepRequest,
          $0.WorkflowServiceSkipStepResponse>(
      '/creativanta.automation.v1.WorkflowService/SkipStep',
      ($0.WorkflowServiceSkipStepRequest value) => value.writeToBuffer(),
      $0.WorkflowServiceSkipStepResponse.fromBuffer);
  static final _$provideInput = $grpc.ClientMethod<
          $0.WorkflowServiceProvideInputRequest,
          $0.WorkflowServiceProvideInputResponse>(
      '/creativanta.automation.v1.WorkflowService/ProvideInput',
      ($0.WorkflowServiceProvideInputRequest value) => value.writeToBuffer(),
      $0.WorkflowServiceProvideInputResponse.fromBuffer);
  static final _$exportRuns = $grpc.ClientMethod<
          $0.WorkflowServiceExportRunsRequest,
          $0.WorkflowServiceExportRunsResponse>(
      '/creativanta.automation.v1.WorkflowService/ExportRuns',
      ($0.WorkflowServiceExportRunsRequest value) => value.writeToBuffer(),
      $0.WorkflowServiceExportRunsResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.automation.v1.WorkflowService')
abstract class WorkflowServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.automation.v1.WorkflowService';

  WorkflowServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.WorkflowServiceCreateRequest,
            $0.WorkflowServiceCreateResponse>(
        'Create',
        create_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.WorkflowServiceCreateRequest.fromBuffer(value),
        ($0.WorkflowServiceCreateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WorkflowServiceGetRequest,
            $0.WorkflowServiceGetResponse>(
        'Get',
        get_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.WorkflowServiceGetRequest.fromBuffer(value),
        ($0.WorkflowServiceGetResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WorkflowServiceListRequest,
            $0.WorkflowServiceListResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.WorkflowServiceListRequest.fromBuffer(value),
        ($0.WorkflowServiceListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WorkflowServiceUpdateRequest,
            $0.WorkflowServiceUpdateResponse>(
        'Update',
        update_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.WorkflowServiceUpdateRequest.fromBuffer(value),
        ($0.WorkflowServiceUpdateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WorkflowServiceActivateRequest,
            $0.WorkflowServiceActivateResponse>(
        'Activate',
        activate_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.WorkflowServiceActivateRequest.fromBuffer(value),
        ($0.WorkflowServiceActivateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WorkflowServiceDeactivateRequest,
            $0.WorkflowServiceDeactivateResponse>(
        'Deactivate',
        deactivate_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.WorkflowServiceDeactivateRequest.fromBuffer(value),
        ($0.WorkflowServiceDeactivateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WorkflowServiceRunRequest,
            $0.WorkflowServiceRunResponse>(
        'Run',
        run_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.WorkflowServiceRunRequest.fromBuffer(value),
        ($0.WorkflowServiceRunResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WorkflowServiceGetRunDetailRequest,
            $0.WorkflowServiceGetRunDetailResponse>(
        'GetRunDetail',
        getRunDetail_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.WorkflowServiceGetRunDetailRequest.fromBuffer(value),
        ($0.WorkflowServiceGetRunDetailResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WorkflowServiceGetRunLogsRequest,
            $0.WorkflowServiceGetRunLogsResponse>(
        'GetRunLogs',
        getRunLogs_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.WorkflowServiceGetRunLogsRequest.fromBuffer(value),
        ($0.WorkflowServiceGetRunLogsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WorkflowServiceListRunsRequest,
            $0.WorkflowServiceListRunsResponse>(
        'ListRuns',
        listRuns_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.WorkflowServiceListRunsRequest.fromBuffer(value),
        ($0.WorkflowServiceListRunsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WorkflowServiceCloneRequest,
            $0.WorkflowServiceCloneResponse>(
        'Clone',
        clone_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.WorkflowServiceCloneRequest.fromBuffer(value),
        ($0.WorkflowServiceCloneResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WorkflowServiceExportRequest,
            $0.WorkflowServiceExportResponse>(
        'Export',
        export_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.WorkflowServiceExportRequest.fromBuffer(value),
        ($0.WorkflowServiceExportResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WorkflowServiceImportRequest,
            $0.WorkflowServiceImportResponse>(
        'Import',
        import_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.WorkflowServiceImportRequest.fromBuffer(value),
        ($0.WorkflowServiceImportResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WorkflowServiceTestRequest,
            $0.WorkflowServiceTestResponse>(
        'Test',
        test_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.WorkflowServiceTestRequest.fromBuffer(value),
        ($0.WorkflowServiceTestResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WorkflowServiceGetRunStatsRequest,
            $0.WorkflowServiceGetRunStatsResponse>(
        'GetRunStats',
        getRunStats_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.WorkflowServiceGetRunStatsRequest.fromBuffer(value),
        ($0.WorkflowServiceGetRunStatsResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WorkflowServiceCancelRunRequest,
            $0.WorkflowServiceCancelRunResponse>(
        'CancelRun',
        cancelRun_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.WorkflowServiceCancelRunRequest.fromBuffer(value),
        ($0.WorkflowServiceCancelRunResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WorkflowServiceRetryRunRequest,
            $0.WorkflowServiceRetryRunResponse>(
        'RetryRun',
        retryRun_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.WorkflowServiceRetryRunRequest.fromBuffer(value),
        ($0.WorkflowServiceRetryRunResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WorkflowServiceDismissRunRequest,
            $0.WorkflowServiceDismissRunResponse>(
        'DismissRun',
        dismissRun_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.WorkflowServiceDismissRunRequest.fromBuffer(value),
        ($0.WorkflowServiceDismissRunResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WorkflowServiceSkipStepRequest,
            $0.WorkflowServiceSkipStepResponse>(
        'SkipStep',
        skipStep_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.WorkflowServiceSkipStepRequest.fromBuffer(value),
        ($0.WorkflowServiceSkipStepResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WorkflowServiceProvideInputRequest,
            $0.WorkflowServiceProvideInputResponse>(
        'ProvideInput',
        provideInput_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.WorkflowServiceProvideInputRequest.fromBuffer(value),
        ($0.WorkflowServiceProvideInputResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WorkflowServiceExportRunsRequest,
            $0.WorkflowServiceExportRunsResponse>(
        'ExportRuns',
        exportRuns_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.WorkflowServiceExportRunsRequest.fromBuffer(value),
        ($0.WorkflowServiceExportRunsResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.WorkflowServiceCreateResponse> create_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.WorkflowServiceCreateRequest> $request) async {
    return create($call, await $request);
  }

  $async.Future<$0.WorkflowServiceCreateResponse> create(
      $grpc.ServiceCall call, $0.WorkflowServiceCreateRequest request);

  $async.Future<$0.WorkflowServiceGetResponse> get_Pre($grpc.ServiceCall $call,
      $async.Future<$0.WorkflowServiceGetRequest> $request) async {
    return get($call, await $request);
  }

  $async.Future<$0.WorkflowServiceGetResponse> get(
      $grpc.ServiceCall call, $0.WorkflowServiceGetRequest request);

  $async.Future<$0.WorkflowServiceListResponse> list_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.WorkflowServiceListRequest> $request) async {
    return list($call, await $request);
  }

  $async.Future<$0.WorkflowServiceListResponse> list(
      $grpc.ServiceCall call, $0.WorkflowServiceListRequest request);

  $async.Future<$0.WorkflowServiceUpdateResponse> update_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.WorkflowServiceUpdateRequest> $request) async {
    return update($call, await $request);
  }

  $async.Future<$0.WorkflowServiceUpdateResponse> update(
      $grpc.ServiceCall call, $0.WorkflowServiceUpdateRequest request);

  $async.Future<$0.WorkflowServiceActivateResponse> activate_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.WorkflowServiceActivateRequest> $request) async {
    return activate($call, await $request);
  }

  $async.Future<$0.WorkflowServiceActivateResponse> activate(
      $grpc.ServiceCall call, $0.WorkflowServiceActivateRequest request);

  $async.Future<$0.WorkflowServiceDeactivateResponse> deactivate_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.WorkflowServiceDeactivateRequest> $request) async {
    return deactivate($call, await $request);
  }

  $async.Future<$0.WorkflowServiceDeactivateResponse> deactivate(
      $grpc.ServiceCall call, $0.WorkflowServiceDeactivateRequest request);

  $async.Future<$0.WorkflowServiceRunResponse> run_Pre($grpc.ServiceCall $call,
      $async.Future<$0.WorkflowServiceRunRequest> $request) async {
    return run($call, await $request);
  }

  $async.Future<$0.WorkflowServiceRunResponse> run(
      $grpc.ServiceCall call, $0.WorkflowServiceRunRequest request);

  $async.Future<$0.WorkflowServiceGetRunDetailResponse> getRunDetail_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.WorkflowServiceGetRunDetailRequest> $request) async {
    return getRunDetail($call, await $request);
  }

  $async.Future<$0.WorkflowServiceGetRunDetailResponse> getRunDetail(
      $grpc.ServiceCall call, $0.WorkflowServiceGetRunDetailRequest request);

  $async.Future<$0.WorkflowServiceGetRunLogsResponse> getRunLogs_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.WorkflowServiceGetRunLogsRequest> $request) async {
    return getRunLogs($call, await $request);
  }

  $async.Future<$0.WorkflowServiceGetRunLogsResponse> getRunLogs(
      $grpc.ServiceCall call, $0.WorkflowServiceGetRunLogsRequest request);

  $async.Future<$0.WorkflowServiceListRunsResponse> listRuns_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.WorkflowServiceListRunsRequest> $request) async {
    return listRuns($call, await $request);
  }

  $async.Future<$0.WorkflowServiceListRunsResponse> listRuns(
      $grpc.ServiceCall call, $0.WorkflowServiceListRunsRequest request);

  $async.Future<$0.WorkflowServiceCloneResponse> clone_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.WorkflowServiceCloneRequest> $request) async {
    return clone($call, await $request);
  }

  $async.Future<$0.WorkflowServiceCloneResponse> clone(
      $grpc.ServiceCall call, $0.WorkflowServiceCloneRequest request);

  $async.Future<$0.WorkflowServiceExportResponse> export_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.WorkflowServiceExportRequest> $request) async {
    return export($call, await $request);
  }

  $async.Future<$0.WorkflowServiceExportResponse> export(
      $grpc.ServiceCall call, $0.WorkflowServiceExportRequest request);

  $async.Future<$0.WorkflowServiceImportResponse> import_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.WorkflowServiceImportRequest> $request) async {
    return import($call, await $request);
  }

  $async.Future<$0.WorkflowServiceImportResponse> import(
      $grpc.ServiceCall call, $0.WorkflowServiceImportRequest request);

  $async.Future<$0.WorkflowServiceTestResponse> test_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.WorkflowServiceTestRequest> $request) async {
    return test($call, await $request);
  }

  $async.Future<$0.WorkflowServiceTestResponse> test(
      $grpc.ServiceCall call, $0.WorkflowServiceTestRequest request);

  $async.Future<$0.WorkflowServiceGetRunStatsResponse> getRunStats_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.WorkflowServiceGetRunStatsRequest> $request) async {
    return getRunStats($call, await $request);
  }

  $async.Future<$0.WorkflowServiceGetRunStatsResponse> getRunStats(
      $grpc.ServiceCall call, $0.WorkflowServiceGetRunStatsRequest request);

  $async.Future<$0.WorkflowServiceCancelRunResponse> cancelRun_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.WorkflowServiceCancelRunRequest> $request) async {
    return cancelRun($call, await $request);
  }

  $async.Future<$0.WorkflowServiceCancelRunResponse> cancelRun(
      $grpc.ServiceCall call, $0.WorkflowServiceCancelRunRequest request);

  $async.Future<$0.WorkflowServiceRetryRunResponse> retryRun_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.WorkflowServiceRetryRunRequest> $request) async {
    return retryRun($call, await $request);
  }

  $async.Future<$0.WorkflowServiceRetryRunResponse> retryRun(
      $grpc.ServiceCall call, $0.WorkflowServiceRetryRunRequest request);

  $async.Future<$0.WorkflowServiceDismissRunResponse> dismissRun_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.WorkflowServiceDismissRunRequest> $request) async {
    return dismissRun($call, await $request);
  }

  $async.Future<$0.WorkflowServiceDismissRunResponse> dismissRun(
      $grpc.ServiceCall call, $0.WorkflowServiceDismissRunRequest request);

  $async.Future<$0.WorkflowServiceSkipStepResponse> skipStep_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.WorkflowServiceSkipStepRequest> $request) async {
    return skipStep($call, await $request);
  }

  $async.Future<$0.WorkflowServiceSkipStepResponse> skipStep(
      $grpc.ServiceCall call, $0.WorkflowServiceSkipStepRequest request);

  $async.Future<$0.WorkflowServiceProvideInputResponse> provideInput_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.WorkflowServiceProvideInputRequest> $request) async {
    return provideInput($call, await $request);
  }

  $async.Future<$0.WorkflowServiceProvideInputResponse> provideInput(
      $grpc.ServiceCall call, $0.WorkflowServiceProvideInputRequest request);

  $async.Future<$0.WorkflowServiceExportRunsResponse> exportRuns_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.WorkflowServiceExportRunsRequest> $request) async {
    return exportRuns($call, await $request);
  }

  $async.Future<$0.WorkflowServiceExportRunsResponse> exportRuns(
      $grpc.ServiceCall call, $0.WorkflowServiceExportRunsRequest request);
}
