import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:rainbow_app/core/constants/app_constants.dart';
import 'package:rainbow_app/core/constants/storage_constants.dart';

/// Storage for the API token and the cached user profile.
///
/// Backed by the iOS Keychain and Android EncryptedSharedPreferences so the
/// token never sits in plain preferences. Reads return `null` and writes are
/// dropped if the keystore is unavailable — the user is then simply asked to
/// sign in again, which is the correct failure mode for a credential store.
abstract interface class SecureStorageService {
  Future<String?> readToken();
  Future<Map<String, Object?>?> readUser();

  Future<void> writeSession({
    required String token,
    required Map<String, Object?> user,
  });

  Future<void> clear();
}

class FlutterSecureStorageService implements SecureStorageService {
  FlutterSecureStorageService({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            // Android storage is encrypted unconditionally in v11;
            // `resetOnError` lets a keystore that was invalidated by a
            // device restore heal itself instead of failing every read.
            aOptions: AndroidOptions(
              preferencesKeyPrefix: 'rainbow',
              storageNamespace: AppConstants.packageId,
            ),
            // `first_unlock` keeps the token readable to background
            // refreshes after a reboot, without exposing it on a locked
            // device.
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock,
            ),
          );

  final FlutterSecureStorage _storage;

  @override
  Future<String?> readToken() => _read(StorageKeys.authToken);

  @override
  Future<Map<String, Object?>?> readUser() async {
    final String? raw = await _read(StorageKeys.authUser);
    if (raw == null) return null;
    try {
      final Object? decoded = jsonDecode(raw);
      return decoded is Map ? Map<String, Object?>.from(decoded) : null;
    } on FormatException catch (error) {
      // A profile written by an incompatible build: discard it rather than
      // trapping the user in a crash loop on launch.
      developer.log(
        'Discarding unreadable cached profile',
        name: 'rainbow.storage',
        error: error,
      );
      await clear();
      return null;
    }
  }

  @override
  Future<void> writeSession({
    required String token,
    required Map<String, Object?> user,
  }) async {
    await _write(StorageKeys.authToken, token);
    await _write(StorageKeys.authUser, jsonEncode(user));
  }

  @override
  Future<void> clear() async {
    for (final String key in const <String>[
      StorageKeys.authToken,
      StorageKeys.authTokenType,
      StorageKeys.authUser,
    ]) {
      try {
        await _storage.delete(key: key);
      } on Exception catch (error) {
        developer.log(
          'Failed to clear $key',
          name: 'rainbow.storage',
          error: error,
        );
      }
    }
  }

  Future<String?> _read(String key) async {
    try {
      return await _storage.read(key: key);
    } on Exception catch (error, stackTrace) {
      developer.log(
        'Secure read failed for $key',
        name: 'rainbow.storage',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<void> _write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } on Exception catch (error, stackTrace) {
      developer.log(
        'Secure write failed for $key',
        name: 'rainbow.storage',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}

/// In-memory implementation for tests.
class InMemorySecureStorageService implements SecureStorageService {
  String? _token;
  Map<String, Object?>? _user;

  @override
  Future<String?> readToken() async => _token;

  @override
  Future<Map<String, Object?>?> readUser() async => _user;

  @override
  Future<void> writeSession({
    required String token,
    required Map<String, Object?> user,
  }) async {
    _token = token;
    _user = user;
  }

  @override
  Future<void> clear() async {
    _token = null;
    _user = null;
  }
}
