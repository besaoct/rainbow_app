import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rainbow_app/app/router/router_refresh.dart';
import 'package:rainbow_app/core/constants/asset_constants.dart';
import 'package:rainbow_app/core/constants/route_constants.dart';
import 'package:rainbow_app/core/enums/user_role.dart';
import 'package:rainbow_app/core/extensions/build_context_x.dart';
import 'package:rainbow_app/core/widgets/app_state_views.dart';
import 'package:rainbow_app/features/auth/providers/auth_providers.dart';
import 'package:rainbow_app/features/auth/screens/login_screen.dart';
import 'package:rainbow_app/features/guard/screens/gate_in_screen.dart';
import 'package:rainbow_app/features/guard/screens/ready_orders_screen.dart';
import 'package:rainbow_app/features/guard/screens/vehicle_inspection_screen.dart';
import 'package:rainbow_app/features/guard/screens/vehicles_screen.dart';
import 'package:rainbow_app/features/home/screens/home_screen.dart';
import 'package:rainbow_app/features/onboarding/providers/onboarding_providers.dart';
import 'package:rainbow_app/features/onboarding/screens/onboarding_screen.dart';
import 'package:rainbow_app/features/settings/screens/settings_screen.dart';
import 'package:rainbow_app/features/splash/screens/splash_screen.dart';
import 'package:rainbow_app/features/store/screens/entered_vehicles_screen.dart';
import 'package:rainbow_app/features/store/screens/vehicle_loading_screen.dart';

/// The application's navigation graph.
///
/// The whole first-launch decision lives in [_redirect] rather than in the
/// splash screen: there is exactly one place that answers "where should this
/// user be right now", and it re-runs automatically whenever the session or
/// the onboarding flag changes.
final Provider<GoRouter> appRouterProvider = Provider<GoRouter>((Ref ref) {
  final RouterRefreshNotifier refresh = RouterRefreshNotifier();
  ref
    ..onDispose(refresh.dispose)
    // Anything that can change where the user belongs re-runs `redirect`.
    ..listen(
      authControllerProvider,
      (AsyncValue<AuthState>? _, AsyncValue<AuthState> _) => refresh.notify(),
    )
    ..listen(
      onboardingCompletedProvider,
      (bool? _, bool _) => refresh.notify(),
    );

  final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splashPath,
    refreshListenable: refresh,
    redirect: (BuildContext context, GoRouterState state) =>
        _redirect(ref, state),
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.splashPath,
        name: AppRoutes.splashName,
        builder: (_, _) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingPath,
        name: AppRoutes.onboardingName,
        builder: (_, _) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.loginPath,
        name: AppRoutes.loginName,
        builder: (_, _) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.homePath,
        name: AppRoutes.homeName,
        builder: (_, _) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.settingsPath,
        name: AppRoutes.settingsName,
        builder: (_, _) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.guardReadyOrdersPath,
        name: AppRoutes.guardReadyOrdersName,
        builder: (_, _) => const ReadyOrdersScreen(),
      ),
      GoRoute(
        path: AppRoutes.guardGateInPath,
        name: AppRoutes.guardGateInName,
        builder: (BuildContext context, GoRouterState state) =>
            GateInScreen(initialOrderId: _intParam(state, 'orderId')),
      ),
      GoRoute(
        path: AppRoutes.guardVehiclesPath,
        name: AppRoutes.guardVehiclesName,
        builder: (_, _) => const VehiclesScreen(),
        routes: <RouteBase>[
          GoRoute(
            path: AppRoutes.guardInspectionPath,
            name: AppRoutes.guardInspectionName,
            builder: (BuildContext context, GoRouterState state) =>
                VehicleInspectionScreen(vehicleId: _requiredId(state)),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.storeEnteredVehiclesPath,
        name: AppRoutes.storeEnteredVehiclesName,
        builder: (_, _) => const EnteredVehiclesScreen(),
        routes: <RouteBase>[
          GoRoute(
            path: AppRoutes.storeLoadingPath,
            name: AppRoutes.storeLoadingName,
            builder: (BuildContext context, GoRouterState state) =>
                VehicleLoadingScreen(vehicleId: _requiredId(state)),
          ),
        ],
      ),
    ],
    errorBuilder: (BuildContext context, GoRouterState state) =>
        const _RouteNotFoundScreen(),
  );
  ref.onDispose(router.dispose);
  return router;
}, name: 'appRouter');

/// Decides where the user belongs, given the session and onboarding state.
///
/// Returning `null` means "stay where you are".
String? _redirect(Ref ref, GoRouterState state) {
  final AsyncValue<AuthState> auth = ref.read(authControllerProvider);
  final String location = state.matchedLocation;

  // The session is still being restored from the keystore. Hold on the
  // splash, which is drawn to match the native one, so there is no flash of
  // the wrong screen.
  if (auth.isLoading || !auth.hasValue) {
    return location == AppRoutes.splashPath ? null : AppRoutes.splashPath;
  }

  final bool onboarded = ref.read(onboardingCompletedProvider);
  if (!onboarded) {
    return location == AppRoutes.onboardingPath
        ? null
        : AppRoutes.onboardingPath;
  }

  final bool signedIn = auth.requireValue.isSignedIn;
  if (!signedIn) {
    if (location == AppRoutes.loginPath) return null;
    // Remember where the user was headed so a deep link survives sign-in.
    final bool isEntryPoint =
        location == AppRoutes.splashPath ||
        location == AppRoutes.onboardingPath;
    return isEntryPoint
        ? AppRoutes.loginPath
        : Uri(
            path: AppRoutes.loginPath,
            queryParameters: <String, String>{
              AppRoutes.redirectQueryParam: location,
            },
          ).toString();
  }

  // Signed in: entry-point routes hand over to the destination.
  if (location == AppRoutes.splashPath ||
      location == AppRoutes.loginPath ||
      location == AppRoutes.onboardingPath) {
    final String? intended =
        state.uri.queryParameters[AppRoutes.redirectQueryParam];
    return intended != null && intended.startsWith('/')
        ? intended
        : AppRoutes.homePath;
  }

  // Role guards: an account without gate rights can never reach a gate
  // screen, even by deep link.
  final UserRole role = ref.read(currentRoleProvider);
  final bool isGuardRoute = location.startsWith('/guard');
  final bool isStoreRoute = location.startsWith('/store');
  if (isGuardRoute && !role.canOperateGate) return AppRoutes.homePath;
  if (isStoreRoute && !role.canOperateStore) return AppRoutes.homePath;

  return null;
}

int _requiredId(GoRouterState state) =>
    int.tryParse(state.pathParameters[AppRoutes.vehicleIdParam] ?? '') ?? 0;

int? _intParam(GoRouterState state, String name) =>
    int.tryParse(state.uri.queryParameters[name] ?? '');

/// Shown for an unknown URL. Routes are generated from `AppRoutes`, so in
/// practice this is only reachable via a malformed deep link.
class _RouteNotFoundScreen extends StatelessWidget {
  const _RouteNotFoundScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AppMessageView(
          icon: AppAssets.iconAlertTriangle,
          title: context.l10n.errorTitle,
          message: context.l10n.errorNotFound,
          actionLabel: context.l10n.homeTitle,
          onAction: () => context.goNamed(AppRoutes.homeName),
        ),
      ),
    );
  }
}
