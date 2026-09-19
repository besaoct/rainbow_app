import 'package:rainbow_app/l10n/generated/app_localizations.dart';

/// The operational role the app runs in.
///
/// Derived from the API's `is_guard` / `is_store_manager` flags rather than
/// from the free-form `roles` list, because those flags are what the server
/// actually enforces on the guard and store endpoints. An administrator has
/// both flags set and can use either side of the app.
enum UserRole {
  guard,
  storeManager,
  admin,
  sales,
  member;

  /// Whether this role may register gate-in and clear vehicles for exit.
  bool get canOperateGate => this == guard || this == admin;

  /// Whether this role may record loading against a vehicle.
  bool get canOperateStore => this == storeManager || this == admin;

  /// Whether the account can use the app at all.
  bool get hasOperationsAccess => canOperateGate || canOperateStore;

  String label(AppLocalizations l10n) => switch (this) {
    UserRole.guard => l10n.roleGuard,
    UserRole.storeManager => l10n.roleStoreManager,
    UserRole.admin => l10n.roleAdmin,
    UserRole.sales => l10n.roleSales,
    UserRole.member => l10n.roleMember,
  };

  /// Resolves the role from the flags and role names in the login response.
  static UserRole resolve({
    required bool isGuard,
    required bool isStoreManager,
    required List<String> roleNames,
  }) {
    if (isGuard && isStoreManager) return UserRole.admin;
    if (isGuard) return UserRole.guard;
    if (isStoreManager) return UserRole.storeManager;
    if (roleNames.any((String r) => r.toLowerCase() == 'sales')) {
      return UserRole.sales;
    }
    return UserRole.member;
  }
}
