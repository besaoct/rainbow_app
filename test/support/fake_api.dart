import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// A Dio adapter that answers from canned payloads instead of the network.
///
/// Routes are matched by a substring of the request path, which keeps the
/// fixtures readable while still exercising the real `ApiClient`: the
/// envelope unwrapping, the failure mapping and the model parsing all run
/// exactly as they do against the live server.
class FakeApi implements HttpClientAdapter {
  FakeApi([Map<String, FakeResponse>? routes])
    : _routes = <String, FakeResponse>{...?routes};

  final Map<String, FakeResponse> _routes;

  /// Paths requested so far, in order. Lets a test assert what was called.
  final List<String> requestedPaths = <String>[];

  /// The options of the most recent request, for asserting on headers and
  /// query parameters.
  RequestOptions? lastRequest;

  void on(String pathFragment, FakeResponse response) =>
      _routes[pathFragment] = response;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requestedPaths.add(options.path);
    lastRequest = options;
    for (final MapEntry<String, FakeResponse> entry in _routes.entries) {
      if (options.path.contains(entry.key)) {
        final FakeResponse response = entry.value;
        if (response.error != null) throw response.error!;
        return ResponseBody.fromString(
          jsonEncode(response.body),
          response.statusCode,
          headers: <String, List<String>>{
            Headers.contentTypeHeader: <String>[Headers.jsonContentType],
          },
        );
      }
    }
    return ResponseBody.fromString(
      jsonEncode(<String, Object?>{
        'success': false,
        'message': 'No fixture for ${options.path}',
      }),
      404,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>[Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

/// One canned answer.
class FakeResponse {
  const FakeResponse(this.body, {this.statusCode = 200}) : error = null;

  /// A transport-level failure, for testing the offline and timeout paths.
  const FakeResponse.failure(this.error)
    : body = const <String, Object?>{},
      statusCode = 0;

  final Object body;
  final int statusCode;
  final DioException? error;
}
