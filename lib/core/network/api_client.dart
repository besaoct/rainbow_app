import 'dart:async';

import 'package:dio/dio.dart';

import 'package:rainbow_app/app/config/app_config.dart';
import 'package:rainbow_app/core/network/api_endpoints.dart';
import 'package:rainbow_app/core/network/api_failure.dart';
import 'package:rainbow_app/core/network/api_response.dart';
import 'package:rainbow_app/core/network/interceptors/auth_interceptor.dart';
import 'package:rainbow_app/core/network/interceptors/logging_interceptor.dart';
import 'package:rainbow_app/core/theme/app_durations.dart';

/// The single HTTP entry point for the application.
///
/// Repositories call [get] and [post] with a decoder and receive either a
/// typed [ApiResponse] or an [ApiFailure]. No layer above this one sees a
/// `DioException`, a status code, or the `{success, message, data}` envelope.
class ApiClient {
  ApiClient({
    required AppConfig config,
    required Future<String?> Function() readToken,
    required this.onUnauthorized,
    Dio? dio,
  }) : _dio = dio ?? Dio() {
    _dio.options = _dio.options.copyWith(
      baseUrl: config.apiBaseUrl,
      connectTimeout: AppDurations.connectTimeout,
      receiveTimeout: AppDurations.receiveTimeout,
      sendTimeout: AppDurations.sendTimeout,
      responseType: ResponseType.json,
      // Non-2xx responses carry a useful body, so take them through the
      // normal path and map them in `_mapError` instead of throwing early.
      validateStatus: (int? status) => status != null && status < 500,
      headers: <String, String>{'Accept': 'application/json'},
    );
    _dio.interceptors.add(AuthInterceptor(readToken: readToken));
    if (config.enableNetworkLogging) {
      _dio.interceptors.add(LoggingInterceptor());
    }
  }

  final Dio _dio;

  /// Invoked when the server rejects the token, so the app can end the
  /// session. Owned here rather than in an interceptor because a 401 does
  /// not produce a `DioException`: `validateStatus` admits it so the body
  /// can be read, which means `Interceptor.onError` never sees it.
  final Future<void> Function() onUnauthorized;

  /// Exposed so tests can install a mock adapter.
  Dio get dio => _dio;

  Future<ApiResponse<T>> get<T>(
    String path, {
    required T Function(Object? data) decode,
    Map<String, Object?>? query,
    CancelToken? cancelToken,
  }) {
    return _send<T>(
      decode: decode,
      request: () => _dio.get<Object?>(
        path,
        queryParameters: _clean(query),
        cancelToken: cancelToken,
      ),
    );
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    required T Function(Object? data) decode,
    Map<String, Object?>? query,
    Object? body,
    CancelToken? cancelToken,
  }) {
    return _send<T>(
      decode: decode,
      request: () => _dio.post<Object?>(
        path,
        queryParameters: _clean(query),
        data: body,
        cancelToken: cancelToken,
      ),
    );
  }

  /// Drops null and empty optional parameters so the server does not receive
  /// `driver_phone=` for a field the user left blank.
  Map<String, Object?>? _clean(Map<String, Object?>? query) {
    if (query == null) return null;
    final Map<String, Object?> cleaned = <String, Object?>{
      for (final MapEntry<String, Object?> e in query.entries)
        if (e.value != null && !(e.value is String && e.value == ''))
          e.key: e.value,
    };
    return cleaned.isEmpty ? null : cleaned;
  }

  Future<ApiResponse<T>> _send<T>({
    required Future<Response<Object?>> Function() request,
    required T Function(Object? data) decode,
  }) async {
    try {
      final Response<Object?> response = await request();
      return _unwrap<T>(response, decode);
    } on DioException catch (error) {
      throw _mapError(error);
    } on ApiFailure {
      rethrow;
    } on FormatException catch (error) {
      throw UnknownFailure(serverMessage: error.message);
    }
  }

  ApiResponse<T> _unwrap<T>(
    Response<Object?> response,
    T Function(Object? data) decode,
  ) {
    final int status = response.statusCode ?? 0;
    final Object? raw = response.data;
    final Map<String, Object?> body = raw is Map
        ? Map<String, Object?>.from(raw)
        : <String, Object?>{};

    if (status >= 200 &&
        status < 300 &&
        body.optBool('success', fallback: true)) {
      return ApiResponse<T>(
        data: decode(body.containsKey('data') ? body['data'] : body),
        message: body.optString('message'),
      );
    }
    throw _failureFromBody(status, body, response.requestOptions.path);
  }

  ApiFailure _failureFromBody(
    int status,
    Map<String, Object?> body,
    String path,
  ) {
    final String? message = body.optString('message');
    if (status == 401 && !_isSignInRequest(path)) {
      // A rejected token ends the session wherever the user happens to be.
      // Fire-and-forget: the caller still receives the failure below.
      unawaited(onUnauthorized());
    }
    return switch (status) {
      401 => UnauthorizedFailure(serverMessage: message),
      403 => ForbiddenFailure(serverMessage: message),
      404 => NotFoundFailure(serverMessage: message),
      422 || 400 => ValidationFailure(
        fieldErrors: _fieldErrors(body),
        serverMessage: message,
        statusCode: status,
      ),
      >= 500 => ServerFailure(serverMessage: message, statusCode: status),
      _ => UnknownFailure(serverMessage: message, statusCode: status),
    };
  }

  /// Laravel returns `{"errors": {"field": ["message", …]}}` on validation
  /// failures, and omits the key entirely for workflow-rule rejections.
  Map<String, List<String>> _fieldErrors(Map<String, Object?> body) {
    final Map<String, Object?>? errors = body.optMap('errors');
    if (errors == null) return const <String, List<String>>{};
    return <String, List<String>>{
      for (final MapEntry<String, Object?> entry in errors.entries)
        entry.key: switch (entry.value) {
          final List<Object?> list =>
            list.map((Object? e) => e.toString()).toList(growable: false),
          final Object value => <String>[value.toString()],
          null => const <String>[],
        },
    };
  }

  ApiFailure _mapError(DioException error) {
    final Response<Object?>? response = error.response;
    if (response != null) {
      final Object? raw = response.data;
      return _failureFromBody(
        response.statusCode ?? 0,
        raw is Map ? Map<String, Object?>.from(raw) : <String, Object?>{},
        error.requestOptions.path,
      );
    }
    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout => TimeoutFailure(
        serverMessage: error.message,
      ),
      DioExceptionType.connectionError => NetworkFailure(
        serverMessage: error.message,
      ),
      DioExceptionType.badCertificate => BadCertificateFailure(
        serverMessage: error.message,
      ),
      DioExceptionType.cancel => CancelledFailure(serverMessage: error.message),
      DioExceptionType.badResponse ||
      DioExceptionType.unknown => _unknownOrNetwork(error),
    };
  }

  /// `DioExceptionType.unknown` covers socket errors as well as genuine bugs;
  /// a missing response almost always means the device is offline.
  /// A failed sign-in is a form error, not an expired session, so it must
  /// not trigger the sign-out path.
  bool _isSignInRequest(String path) => path.contains(ApiEndpoints.login);

  ApiFailure _unknownOrNetwork(DioException error) {
    if (error.error is Exception && error.response == null) {
      return NetworkFailure(serverMessage: error.message);
    }
    return UnknownFailure(serverMessage: error.message);
  }
}
