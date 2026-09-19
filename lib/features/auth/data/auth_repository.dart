import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

import 'package:rainbow_app/core/constants/app_constants.dart';
import 'package:rainbow_app/core/network/api_client.dart';
import 'package:rainbow_app/core/network/api_endpoints.dart';
import 'package:rainbow_app/core/network/api_response.dart';
import 'package:rainbow_app/core/services/secure_storage_service.dart';
import 'package:rainbow_app/features/auth/models/auth_user.dart';

/// Sign-in, sign-out and session persistence.
///
/// The repository owns the secure store so nothing above it has to remember
/// to persist a token after a successful login or to clear one after a 401.
class AuthRepository {
  const AuthRepository(this._client, this._storage);

  final ApiClient _client;
  final SecureStorageService _storage;

  /// Name reported to the server so a user can identify this session in the
  /// ERP's token list.
  static String get deviceName {
    if (kIsWeb) return AppConstants.genericDeviceName;
    if (Platform.isAndroid) return AppConstants.androidDeviceName;
    if (Platform.isIOS) return AppConstants.iosDeviceName;
    return AppConstants.genericDeviceName;
  }

  /// Exchanges credentials for a bearer token and persists the session.
  ///
  /// Throws an `ApiFailure`; a wrong password surfaces as
  /// `UnauthorizedFailure`, which the login form shows inline.
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    final ApiResponse<Map<String, Object?>> response = await _client
        .post<Map<String, Object?>>(
          ApiEndpoints.login,
          // The endpoint reads credentials from the query string. They travel
          // over TLS, and the logging interceptor never records query strings.
          query: <String, Object?>{
            ApiEndpoints.qLogin: email.trim(),
            ApiEndpoints.qPassword: password,
            ApiEndpoints.qDeviceName: deviceName,
          },
          decode: asJsonMap,
        );

    final Map<String, Object?> data = response.data;
    final String token = data.requireString('token');
    final Map<String, Object?> userJson =
        data.optMap('user') ?? <String, Object?>{};
    final AuthUser user = AuthUser.fromJson(userJson);

    await _storage.writeSession(token: token, user: userJson);
    return user;
  }

  /// Restores a previously persisted session, or `null` when signed out or
  /// when the stored profile cannot be read.
  Future<AuthUser?> restoreSession() async {
    final String? token = await _storage.readToken();
    if (token == null || token.isEmpty) return null;
    final Map<String, Object?>? userJson = await _storage.readUser();
    if (userJson == null) {
      // A token without a profile is unusable: the app cannot tell which
      // side of the workflow to show. Start clean.
      await _storage.clear();
      return null;
    }
    return AuthUser.fromJson(userJson);
  }

  /// Revokes the token server-side, then clears it locally.
  ///
  /// The local clear happens regardless: a guard signing out on a device with
  /// no signal must still end up signed out.
  Future<void> signOut() async {
    try {
      await _client.post<void>(ApiEndpoints.logout, decode: (Object? _) {});
    } on Exception {
      // Revoking remotely is best-effort; the token expires server-side.
    } finally {
      await _storage.clear();
    }
  }

  /// Clears the local session without calling the server. Used when the
  /// server has already rejected the token.
  Future<void> clearSession() => _storage.clear();
}
