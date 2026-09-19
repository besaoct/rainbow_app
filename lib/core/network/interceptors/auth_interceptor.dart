import 'package:dio/dio.dart';

/// Attaches the bearer token and the JSON `Accept` header to every request.
///
/// Authentication *failures* are handled in `ApiClient` rather than here:
/// the client admits non-2xx responses so it can read their bodies, so a 401
/// never reaches [Interceptor.onError].
class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.readToken});

  /// Supplies the current token, or `null` when signed out.
  final Future<String?> Function() readToken;

  /// The sign-in endpoint issues the token, so it must never carry one.
  static const String _loginPath = '/auth/login';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!options.path.contains(_loginPath)) {
      final String? token = await readToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    options.headers['Accept'] = 'application/json';
    handler.next(options);
  }
}
