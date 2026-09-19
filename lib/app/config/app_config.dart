/// Build-time configuration.
///
/// Values are supplied with `--dart-define` so a single codebase can target
/// staging and production without a code change:
///
/// ```sh
/// flutter build apk --dart-define=API_BASE_URL=https://erp.example.com
/// ```
enum AppFlavor { development, staging, production }

final class AppConfig {
  const AppConfig({
    required this.flavor,
    required this.apiBaseUrl,
    required this.enableNetworkLogging,
  });

  /// Reads the configuration from `--dart-define` values, falling back to the
  /// shared development server.
  factory AppConfig.fromEnvironment() {
    const String flavorName = String.fromEnvironment(
      'APP_FLAVOR',
      defaultValue: 'development',
    );
    final AppFlavor flavor = AppFlavor.values.firstWhere(
      (AppFlavor f) => f.name == flavorName,
      orElse: () => AppFlavor.development,
    );
    return AppConfig(
      flavor: flavor,
      apiBaseUrl: const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: defaultApiBaseUrl,
      ),
      enableNetworkLogging: const bool.fromEnvironment(
        'ENABLE_NETWORK_LOGGING',
        defaultValue: true,
      ),
    );
  }

  /// The shared Rainbow ERP server used when no `API_BASE_URL` is defined.
  static const String defaultApiBaseUrl =
      'https://indigo-parrot-908857.hostingersite.com';

  final AppFlavor flavor;

  /// Origin of the Rainbow ERP API, without a trailing slash.
  final String apiBaseUrl;

  /// Whether request/response lines are written to the debug log. Request
  /// bodies are redacted regardless (see `LoggingInterceptor`).
  final bool enableNetworkLogging;

  bool get isProduction => flavor == AppFlavor.production;

  /// Host shown on the settings screen so field staff can confirm which
  /// server the app is pointed at.
  String get displayHost => Uri.tryParse(apiBaseUrl)?.host ?? apiBaseUrl;
}
