import 'dart:async';
import 'dart:io';

import 'package:grpc/grpc.dart';

import 'package:creativanta_mobile/generated/creativanta/common/v1/types.pb.dart';
import 'package:creativanta_mobile/generated/creativanta/transport/test/v1/fixture.pbgrpc.dart';

Future<void> main() async {
  final rawUrl = Platform.environment['CV_FIXTURE_URL'];
  if (rawUrl == null || rawUrl.trim().isEmpty) {
    throw StateError('CV_FIXTURE_URL environment variable is not set');
  }

  final uri = Uri.parse(rawUrl);
  if (!uri.hasPort || uri.host.isEmpty) {
    throw StateError('Invalid CV_FIXTURE_URL (missing host or port): $rawUrl');
  }

  try {
    final socket = await Socket.connect(
      uri.host,
      uri.port,
      timeout: const Duration(seconds: 2),
    );
    await socket.close();
  } catch (e) {
    throw StateError(
      'Localhost test server not running at ${uri.host}:${uri.port}: $e',
    );
  }

  final channel = ClientChannel(
    uri.host,
    port: uri.port,
    options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
  );

  try {
    final client = TransportFixtureServiceClient(channel);
    const workspace = '018f7a31-2233-7444-8555-667788990011';
    final baseOptions = CallOptions(
      metadata: {'x-workspace-id': workspace, 'x-request-id': 'dart-fixture'},
    );

    final echoResp = await client.echo(
      EchoRequest(text: 'Dart grpc', workspaceId: workspace),
      options: baseOptions,
    );
    if (echoResp.text != 'Dart grpc') {
      throw StateError(
        'Echo text mismatch: expected "Dart grpc", got "${echoResp.text}"',
      );
    }

    final cmdCtx = CommandContext(
      idempotencyKey: 'dart-01',
      workspaceId: UUID(value: workspace),
    );

    final exec1 = await client.execute(
      ExecuteRequest(context: cmdCtx, payload: 'payload-initial'),
      options: baseOptions,
    );
    if (exec1.replayed != false) {
      throw StateError(
        'Expected first execute replay to be false, got ${exec1.replayed}',
      );
    }

    final exec2 = await client.execute(
      ExecuteRequest(context: cmdCtx, payload: 'payload-initial'),
      options: baseOptions,
    );
    if (exec2.replayed != true) {
      throw StateError(
        'Expected second execute replay to be true, got ${exec2.replayed}',
      );
    }

    bool alreadyExistsCaught = false;
    try {
      await client.execute(
        ExecuteRequest(context: cmdCtx, payload: 'payload-changed'),
        options: baseOptions,
      );
    } on GrpcError catch (e) {
      if (e.code == StatusCode.alreadyExists) {
        alreadyExistsCaught = true;
      } else {
        throw StateError(
          'Expected StatusCode.alreadyExists on changed payload, got ${e.code}: ${e.message}',
        );
      }
    }
    if (!alreadyExistsCaught) {
      throw StateError(
        'Execute with changed payload should have failed with alreadyExists',
      );
    }

    final listResp = await client.list(
      ListRequest(pagination: Pagination(pageSize: 2), workspaceId: workspace),
      options: baseOptions,
    );
    final copiedCursor = listResp.pagination.nextPageToken;

    const foreignWorkspace = '018f7a31-2233-7444-8555-667788990022';
    final foreignOptions = CallOptions(
      metadata: {
        'x-workspace-id': foreignWorkspace,
        'x-request-id': 'dart-fixture-foreign',
      },
    );

    bool invalidArgumentCaught = false;
    try {
      await client.list(
        ListRequest(
          pagination: Pagination(pageSize: 2, pageToken: copiedCursor),
          workspaceId: foreignWorkspace,
        ),
        options: foreignOptions,
      );
    } on GrpcError catch (e) {
      if (e.code == StatusCode.invalidArgument) {
        invalidArgumentCaught = true;
      } else {
        throw StateError(
          'Expected StatusCode.invalidArgument on foreign cursor, got ${e.code}: ${e.message}',
        );
      }
    }
    if (!invalidArgumentCaught) {
      throw StateError(
        'List with foreign tenant cursor should have failed with invalidArgument',
      );
    }

    bool deadlineExceededCaught = false;
    try {
      await client.echo(
        EchoRequest(text: 'Dart grpc deadline', workspaceId: workspace),
        options: CallOptions(
          timeout: const Duration(milliseconds: 50),
          metadata: {
            'x-workspace-id': workspace,
            'x-request-id': 'dart-fixture-deadline',
            'x-test-delay-ms': '500',
          },
        ),
      );
    } on GrpcError catch (e) {
      if (e.code == StatusCode.deadlineExceeded) {
        deadlineExceededCaught = true;
      } else {
        throw StateError(
          'Expected StatusCode.deadlineExceeded, got ${e.code}: ${e.message}',
        );
      }
    }
    if (!deadlineExceededCaught) {
      throw StateError(
        'Echo with 50ms deadline should have failed with deadlineExceeded',
      );
    }

    final watchStream = client.watch(
      WatchRequest(maxEvents: 5),
      options: baseOptions,
    );

    final firstEventReceived = Completer<WatchResponse>();
    late final StreamSubscription<WatchResponse> watchSub;
    watchSub = watchStream.listen(
      (event) {
        if (!firstEventReceived.isCompleted) {
          firstEventReceived.complete(event);
        }
      },
      onError: (Object error) {
        if (!firstEventReceived.isCompleted) {
          firstEventReceived.completeError(error);
        }
      },
      cancelOnError: true,
    );

    await firstEventReceived.future.timeout(
      const Duration(seconds: 5),
      onTimeout: () =>
          throw StateError('Timed out waiting for first Watch event'),
    );
    await watchSub.cancel();
  } finally {
    // Streaming RPCs may remain in-flight. Test must not hang on graceful shutdown.
    await channel.terminate().timeout(const Duration(seconds: 3));
  }
  stdout.writeln('DART_GRPC_REAL_TRANSPORT_PASS');
}
