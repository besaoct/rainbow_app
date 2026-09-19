import 'dart:developer' as developer;

import 'package:dio/dio.dart';

/// Writes a one-line trace of each request to the debug log.
///
/// Bodies and query strings are **not** logged: the sign-in call carries a
/// password in its query string, and gate entries carry driver phone numbers.
/// Only the method, path, status and duration are recorded.
class LoggingInterceptor extends Interceptor {
  static const String _name = 'rainbow.api';
  static const String _startKey = 'x-rainbow-start';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_startKey] = DateTime.now().millisecondsSinceEpoch;
    developer.log('→ ${options.method} ${options.path}', name: _name);
    handler.next(options);
  }

  @override
  void onResponse(
    Response<Object?> response,
    ResponseInterceptorHandler handler,
  ) {
    developer.log(
      '← ${response.statusCode} ${response.requestOptions.path} '
      '(${_elapsed(response.requestOptions)}ms)',
      name: _name,
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    developer.log(
      '✕ ${err.response?.statusCode ?? err.type.name} '
      '${err.requestOptions.path} (${_elapsed(err.requestOptions)}ms)',
      name: _name,
    );
    handler.next(err);
  }

  int _elapsed(RequestOptions options) {
    final Object? start = options.extra[_startKey];
    if (start is! int) return 0;
    return DateTime.now().millisecondsSinceEpoch - start;
  }
}
