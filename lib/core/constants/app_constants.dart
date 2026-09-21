import 'dart:ui' show Locale;

/// Application-wide metadata and tuning constants.
///
/// User-facing text is **not** here — it lives in `lib/l10n/arb/*.arb` and is
/// reached through `AppLocalizations`. This file holds identifiers, limits and
/// other values that are not shown verbatim to the user.
abstract final class AppConstants {
  /// Android application id / iOS bundle identifier.
  static const String packageId = 'com.gitcs.rainbow';

  /// Marketing version. Overridden in CI builds via `--dart-define=APP_VERSION=...`
  static const String version = String.fromEnvironment(
    'APP_VERSION',
    defaultValue: '1.0.1',
  );

  /// Build number. Overridden in CI builds via `--dart-define=APP_BUILD_NUMBER=...`
  static const String buildNumber = String.fromEnvironment(
    'APP_BUILD_NUMBER',
    defaultValue: '2',
  );

  /// Locales the app ships translations for.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('bn'),
    Locale('as'),
  ];

  static const Locale fallbackLocale = Locale('en');

  /// Bounds on the OS text-scale factor. Users who enlarge system text still
  /// get larger type, but not so large that fixed-height controls clip.
  static const double minTextScale = 0.85;
  static const double maxTextScale = 1.35;

  /// Page size used by the paginated vehicle list.
  static const int pageSize = 30;

  /// Number of vehicles surfaced on the home dashboard.
  static const int dashboardPreviewCount = 3;

  /// Length limits enforced on free-text inputs before they reach the API.
  static const int maxRemarksLength = 500;
  static const int maxReasonLength = 250;
  static const int maxNameLength = 120;
  static const int maxDocumentNumberLength = 64;
  static const int minPasswordLength = 6;

  /// Device name reported to the API when issuing a token, used so a user can
  /// recognise and revoke sessions.
  static const String androidDeviceName = 'Rainbow Android';
  static const String iosDeviceName = 'Rainbow iOS';
  static const String genericDeviceName = 'Rainbow App';
}
