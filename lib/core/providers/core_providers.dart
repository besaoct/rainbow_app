import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rainbow_app/app/config/app_config.dart';
import 'package:rainbow_app/core/network/api_client.dart';
import 'package:rainbow_app/core/services/preferences_service.dart';
import 'package:rainbow_app/core/services/secure_storage_service.dart';

/// Infrastructure that every feature depends on.
///
/// [preferencesServiceProvider] is opened during bootstrap and injected as an
/// override, so the rest of the app can read preferences synchronously and no
/// screen has to handle "preferences not ready yet".

final Provider<AppConfig> appConfigProvider = Provider<AppConfig>(
  (Ref ref) => AppConfig.fromEnvironment(),
  name: 'appConfig',
);

final Provider<PreferencesService> preferencesServiceProvider =
    Provider<PreferencesService>(
      (Ref ref) => throw UnimplementedError(
        'preferencesServiceProvider must be overridden in bootstrap()',
      ),
      name: 'preferencesService',
    );

final Provider<SecureStorageService> secureStorageServiceProvider =
    Provider<SecureStorageService>(
      (Ref ref) => FlutterSecureStorageService(),
      name: 'secureStorageService',
    );

/// Signalled when the server rejects the current token.
///
/// The auth controller listens to this and clears the session. Routing it
/// through a provider keeps `ApiClient` free of any dependency on the auth
/// feature, which would otherwise be a cycle.
final Provider<SessionExpiryNotifier> sessionExpiryProvider =
    Provider<SessionExpiryNotifier>((Ref ref) {
      final SessionExpiryNotifier notifier = SessionExpiryNotifier();
      ref.onDispose(notifier.dispose);
      return notifier;
    }, name: 'sessionExpiry');

/// A one-shot signal that the session is no longer valid.
class SessionExpiryNotifier {
  final List<void Function()> _listeners = <void Function()>[];

  void addListener(void Function() listener) => _listeners.add(listener);

  void removeListener(void Function() listener) => _listeners.remove(listener);

  void notify() {
    for (final void Function() listener in List<void Function()>.of(
      _listeners,
    )) {
      listener();
    }
  }

  void dispose() => _listeners.clear();
}

final Provider<ApiClient> apiClientProvider = Provider<ApiClient>((Ref ref) {
  final SecureStorageService storage = ref.watch(secureStorageServiceProvider);
  final SessionExpiryNotifier expiry = ref.watch(sessionExpiryProvider);
  return ApiClient(
    config: ref.watch(appConfigProvider),
    readToken: storage.readToken,
    onUnauthorized: () async => expiry.notify(),
  );
}, name: 'apiClient');
