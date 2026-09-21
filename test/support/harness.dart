import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rainbow_app/app/config/app_config.dart';
import 'package:rainbow_app/app/router/app_router.dart';
import 'package:rainbow_app/app/theme/app_theme.dart';
import 'package:rainbow_app/core/constants/app_constants.dart';
import 'package:rainbow_app/core/network/api_client.dart';
import 'package:rainbow_app/core/providers/core_providers.dart';
import 'package:rainbow_app/core/services/preferences_service.dart';
import 'package:rainbow_app/core/services/secure_storage_service.dart';
import 'package:rainbow_app/core/theme/app_scale.dart';
import 'package:rainbow_app/core/widgets/bounded_text_scale.dart';
import 'package:rainbow_app/l10n/generated/app_localizations.dart';

import 'fake_api.dart';
import 'fixtures.dart';

/// A device to render a screen at, for the responsive and overflow checks.
class TestDevice {
  const TestDevice(
    this.name,
    this.size, {
    this.textScale = 1.0,
    this.bottomInset = 0,
  });

  final String name;
  final Size size;
  final double textScale;

  /// System inset at the bottom of the screen, in logical pixels — Android's
  /// gesture bar or an iPhone's home indicator.
  final double bottomInset;

  @override
  String toString() =>
      '$name (${size.width.toInt()}x${size.height.toInt()}'
      '${textScale == 1.0 ? '' : ' @${textScale}x'})';
}

/// The matrix every screen is checked against: the smallest phone still in
/// service, mainstream phones, a large phone, both tablet orientations, and
/// the extremes of the supported text-scale range.
const List<TestDevice> kTestDevices = <TestDevice>[
  TestDevice('small phone', Size(320, 568)),
  TestDevice('compact phone', Size(360, 640)),
  TestDevice('modern phone', Size(390, 844)),
  TestDevice('large phone', Size(430, 932)),
  TestDevice('tablet portrait', Size(768, 1024)),
  TestDevice('tablet landscape', Size(1024, 768)),
  TestDevice('small phone, large text', Size(320, 568), textScale: 1.35),
  TestDevice('modern phone, large text', Size(390, 844), textScale: 1.35),
  TestDevice('modern phone, small text', Size(390, 844), textScale: 0.85),
  // Well past the supported range: proves the clamp in `BoundedTextScale`
  // keeps an accessibility-maximum device usable rather than clipped.
  TestDevice('small phone, maximum OS text', Size(320, 568), textScale: 2.5),
];

/// Builds the provider graph a widget test runs against.
///
/// Everything below the repositories is real — the `ApiClient`, the envelope
/// handling and the models — with only the socket replaced by [api]. That
/// way a test failure means the app is wrong, not that a mock drifted.
class TestHarness {
  TestHarness({
    FakeApi? api,
    PreferencesService? preferences,
    SecureStorageService? secureStorage,
  }) : api = api ?? FakeApi(),
       preferences =
           preferences ??
           InMemoryPreferencesService(hasCompletedOnboarding: true),
       secureStorage = secureStorage ?? InMemorySecureStorageService();

  final FakeApi api;
  final PreferencesService preferences;
  final SecureStorageService secureStorage;

  /// Seeds a signed-in session, so screens behind the auth guard can render.
  Future<TestHarness> signIn({
    Map<String, Object?> user = Fixtures.guardUser,
  }) async {
    await secureStorage.writeSession(token: 'test-token', user: user);
    return this;
  }

  /// Registers the fixtures the gate and store screens read.
  void withDefaultRoutes() {
    api
      ..on('/dashboard/summary', const FakeResponse(Fixtures.dashboardSummary))
      ..on('/guard/orders-ready', const FakeResponse(Fixtures.ordersReady))
      ..on(
        '/guard/vehicles/gate-in',
        const FakeResponse(Fixtures.gateInCreated, statusCode: 201),
      )
      ..on('/inspection', const FakeResponse(Fixtures.inspectionLoaded))
      ..on('/guard/vehicles', const FakeResponse(Fixtures.guardVehicles))
      ..on(
        '/store/entered-vehicles',
        const FakeResponse(Fixtures.enteredVehicles),
      )
      ..on('/order-items', const FakeResponse(Fixtures.orderItems));
  }

  /// Builds the whole application, router included, so the first-launch and
  /// route-guard decisions can be exercised end to end.
  ProviderScope wrapApp({Locale? locale}) =>
      _scope(_TestRouterApp(locale: locale));

  ProviderScope wrap(
    Widget child, {
    Locale? locale,
    Brightness brightness = Brightness.light,
  }) => _scope(_TestApp(locale: locale, brightness: brightness, child: child));

  ProviderScope _scope(Widget child) {
    return ProviderScope(
      overrides: [
        preferencesServiceProvider.overrideWithValue(preferences),
        secureStorageServiceProvider.overrideWithValue(secureStorage),
        apiClientProvider.overrideWith((Ref ref) {
          final ApiClient client = ApiClient(
            config: const AppConfig(
              flavor: AppFlavor.development,
              apiBaseUrl: 'https://rainbow.test',
              enableNetworkLogging: false,
            ),
            readToken: secureStorage.readToken,
            onUnauthorized: () async =>
                ref.read(sessionExpiryProvider).notify(),
          );
          client.dio.httpClientAdapter = api;
          return client;
        }),
      ],
      child: child,
    );
  }
}

/// The real `MaterialApp.router`, wired to the real `appRouterProvider`.
class _TestRouterApp extends ConsumerWidget {
  const _TestRouterApp({this.locale});

  final Locale? locale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: AppScale.designSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? _) => MaterialApp.router(
        routerConfig: ref.watch(appRouterProvider),
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        locale: locale,
        supportedLocales: AppConstants.supportedLocales,
        localizationsDelegates: const <LocalizationsDelegate<Object>>[
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: (BuildContext context, Widget? built) =>
            BoundedTextScale(child: built ?? const SizedBox.shrink()),
      ),
    );
  }
}

/// A `MaterialApp` configured exactly as the real one: same theme, same
/// localisation delegates, same responsive initialisation.
class _TestApp extends StatelessWidget {
  const _TestApp({required this.child, required this.brightness, this.locale});

  final Widget child;
  final Locale? locale;
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: AppScale.designSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: brightness == Brightness.dark
            ? ThemeMode.dark
            : ThemeMode.light,
        locale: locale,
        supportedLocales: AppConstants.supportedLocales,
        localizationsDelegates: const <LocalizationsDelegate<Object>>[
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        // Same bound the real app applies, so a test at an extreme OS text
        // size exercises what actually ships.
        builder: (BuildContext context, Widget? built) =>
            BoundedTextScale(child: built ?? const SizedBox.shrink()),
        home: child,
      ),
    );
  }
}

/// Renders [child] at [device]'s dimensions and text scale.
///
/// Pumps a bounded number of frames rather than calling `pumpAndSettle`:
/// several screens show a progress indicator, which never settles, and a
/// perpetual animation is not a reason to skip an overflow check. The frames
/// are enough for the fixtures to resolve and for entry transitions to run.
Future<void> pumpAt(
  WidgetTester tester,
  TestDevice device,
  Widget child,
) async {
  // Drive the real view rather than wrapping the tree in a second
  // `MediaQuery`: an override below the `View` disagrees with the window the
  // `Scaffold` actually lays out against, which silently misplaces anything
  // anchored to the bottom.
  tester.view
    ..physicalSize = device.size * 3
    ..devicePixelRatio = 3
    ..padding = FakeViewPadding(bottom: device.bottomInset * 3)
    ..viewPadding = FakeViewPadding(bottom: device.bottomInset * 3);
  tester.platformDispatcher.textScaleFactorTestValue = device.textScale;
  addTearDown(() {
    tester.view.reset();
    tester.platformDispatcher.clearTextScaleFactorTestValue();
  });

  await tester.pumpWidget(child);
  // First frame, then let the provider futures complete, then let any
  // entry animation finish.
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 16));
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pump(const Duration(milliseconds: 400));
}
