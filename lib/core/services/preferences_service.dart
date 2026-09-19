import 'dart:developer' as developer;

import 'package:rainbow_app/core/constants/storage_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Non-sensitive on-device preferences: onboarding progress, theme and locale.
///
/// Every operation degrades gracefully. If the platform store cannot be
/// opened — a corrupt profile, a restricted device, a first frame during a
/// restore — the app still runs with in-memory defaults rather than failing
/// to start, and [isAvailable] lets the UI say so.
abstract interface class PreferencesService {
  /// Whether the backing store was opened successfully.
  bool get isAvailable;

  bool get hasCompletedOnboarding;
  Future<void> setHasCompletedOnboarding({required bool value});

  /// Stored theme mode as `ThemeMode.name`, or `null` when unset.
  String? get themeModeName;
  Future<void> setThemeModeName(String? value);

  /// Stored locale as a language code, or `null` to follow the system.
  String? get localeCode;
  Future<void> setLocaleCode(String? value);
}

class SharedPreferencesService implements PreferencesService {
  SharedPreferencesService._(this._prefs);

  /// Opens the store. Never throws: a failure yields an unavailable service
  /// backed by defaults.
  static Future<SharedPreferencesService> open() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final SharedPreferencesService service = SharedPreferencesService._(
        prefs,
      );
      await service._migrate();
      return service;
    } on Exception catch (error, stackTrace) {
      developer.log(
        'Preferences unavailable; continuing with defaults',
        name: 'rainbow.storage',
        error: error,
        stackTrace: stackTrace,
      );
      return SharedPreferencesService._(null);
    }
  }

  final SharedPreferences? _prefs;

  @override
  bool get isAvailable => _prefs != null;

  /// Records the schema version so a future release can migrate data written
  /// by this one instead of guessing at its shape.
  Future<void> _migrate() async {
    final SharedPreferences? prefs = _prefs;
    if (prefs == null) return;
    final int stored = prefs.getInt(StorageKeys.schemaVersion) ?? 0;
    if (stored == StorageKeys.currentSchemaVersion) return;
    await prefs.setInt(
      StorageKeys.schemaVersion,
      StorageKeys.currentSchemaVersion,
    );
  }

  @override
  bool get hasCompletedOnboarding =>
      _prefs?.getBool(StorageKeys.hasCompletedOnboarding) ?? false;

  @override
  Future<void> setHasCompletedOnboarding({required bool value}) =>
      _write(() => _prefs!.setBool(StorageKeys.hasCompletedOnboarding, value));

  @override
  String? get themeModeName => _prefs?.getString(StorageKeys.themeMode);

  @override
  Future<void> setThemeModeName(String? value) => _write(
    () => value == null
        ? _prefs!.remove(StorageKeys.themeMode)
        : _prefs!.setString(StorageKeys.themeMode, value),
  );

  @override
  String? get localeCode => _prefs?.getString(StorageKeys.localeCode);

  @override
  Future<void> setLocaleCode(String? value) => _write(
    () => value == null
        ? _prefs!.remove(StorageKeys.localeCode)
        : _prefs!.setString(StorageKeys.localeCode, value),
  );

  Future<void> _write(Future<bool> Function() action) async {
    if (_prefs == null) return;
    try {
      await action();
    } on Exception catch (error, stackTrace) {
      developer.log(
        'Failed to write preference',
        name: 'rainbow.storage',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}

/// In-memory implementation used by tests and as the fallback when the
/// platform store is unavailable.
class InMemoryPreferencesService implements PreferencesService {
  InMemoryPreferencesService({
    bool hasCompletedOnboarding = false,
    this.isAvailable = true,
  }) : _onboardingComplete = hasCompletedOnboarding;

  bool _onboardingComplete;
  String? _themeModeName;
  String? _localeCode;

  @override
  final bool isAvailable;

  @override
  bool get hasCompletedOnboarding => _onboardingComplete;

  @override
  Future<void> setHasCompletedOnboarding({required bool value}) async =>
      _onboardingComplete = value;

  @override
  String? get themeModeName => _themeModeName;

  @override
  Future<void> setThemeModeName(String? value) async => _themeModeName = value;

  @override
  String? get localeCode => _localeCode;

  @override
  Future<void> setLocaleCode(String? value) async => _localeCode = value;
}
