/// Route names and paths.
///
/// Navigation is always `context.goNamed(AppRoutes.xName)` rather than a
/// literal path, so a URL change never breaks a call site.
abstract final class AppRoutes {
  // --- Names -------------------------------------------------------------
  static const String splashName = 'splash';
  static const String onboardingName = 'onboarding';
  static const String loginName = 'login';
  static const String homeName = 'home';
  static const String settingsName = 'settings';

  static const String guardReadyOrdersName = 'guard-ready-orders';
  static const String guardGateInName = 'guard-gate-in';
  static const String guardVehiclesName = 'guard-vehicles';
  static const String guardInspectionName = 'guard-inspection';

  static const String storeEnteredVehiclesName = 'store-entered-vehicles';
  static const String storeLoadingName = 'store-loading';

  // --- Paths -------------------------------------------------------------
  static const String splashPath = '/';
  static const String onboardingPath = '/onboarding';
  static const String loginPath = '/login';
  static const String homePath = '/home';
  static const String settingsPath = '/settings';

  static const String guardReadyOrdersPath = '/guard/orders-ready';
  static const String guardGateInPath = '/guard/gate-in';
  static const String guardVehiclesPath = '/guard/vehicles';

  /// Sub-route of [guardVehiclesPath]; takes [vehicleIdParam].
  static const String guardInspectionPath = ':vehicleId/inspection';

  static const String storeEnteredVehiclesPath = '/store/vehicles';

  /// Sub-route of [storeEnteredVehiclesPath]; takes [vehicleIdParam].
  static const String storeLoadingPath = ':vehicleId/load';

  // --- Parameters --------------------------------------------------------
  static const String vehicleIdParam = 'vehicleId';

  /// Query parameter carrying the destination a guard should return to after
  /// signing in again.
  static const String redirectQueryParam = 'from';
}
