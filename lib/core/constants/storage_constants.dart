/// Keys used for on-device persistence.
///
/// Values that identify the user or authorise requests go to the secure store
/// (Keychain / EncryptedSharedPreferences); everything else goes to
/// `SharedPreferences`.
abstract final class StorageKeys {
  /// Namespace prefix, so a key collision with a plugin is impossible.
  static const String _p = 'com.gitcs.rainbow';

  // --- Secure (Keychain / Keystore) --------------------------------------
  static const String authToken = '$_p.auth.token';
  static const String authTokenType = '$_p.auth.token_type';
  static const String authUser = '$_p.auth.user';

  // --- Preferences -------------------------------------------------------
  static const String hasCompletedOnboarding = '$_p.onboarding.completed';
  static const String themeMode = '$_p.settings.theme_mode';
  static const String localeCode = '$_p.settings.locale';

  /// Schema version of the persisted preferences, so a future migration can
  /// detect and upgrade data written by an older build.
  static const String schemaVersion = '$_p.schema_version';
  static const int currentSchemaVersion = 1;
}
