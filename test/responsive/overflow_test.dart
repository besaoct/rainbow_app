import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rainbow_app/features/auth/screens/login_screen.dart';
import 'package:rainbow_app/features/guard/screens/gate_in_screen.dart';
import 'package:rainbow_app/features/guard/screens/ready_orders_screen.dart';
import 'package:rainbow_app/features/guard/screens/vehicle_inspection_screen.dart';
import 'package:rainbow_app/features/guard/screens/vehicles_screen.dart';
import 'package:rainbow_app/features/home/screens/home_screen.dart';
import 'package:rainbow_app/features/onboarding/screens/onboarding_screen.dart';
import 'package:rainbow_app/features/settings/screens/settings_screen.dart';
import 'package:rainbow_app/features/splash/screens/splash_screen.dart';
import 'package:rainbow_app/features/store/screens/entered_vehicles_screen.dart';
import 'package:rainbow_app/features/store/screens/vehicle_loading_screen.dart';

import '../support/harness.dart';

/// Every screen, rendered at every supported size, in every language, with
/// no overflow.
///
/// Flutter reports a `RenderFlex` or `RenderBox` overflow through
/// `FlutterError`, which the test binding records; `tester.takeException()`
/// surfacing anything means a layout broke at that size. This is the
/// regression net for the "no overflow on any device" requirement — it is
/// cheaper and far more reliable than checking screenshots by hand.
void main() {
  /// Screens that need no signed-in session.
  final Map<String, Widget Function()> publicScreens =
      <String, Widget Function()>{
        'splash': SplashScreen.new,
        'onboarding': OnboardingScreen.new,
        'login': LoginScreen.new,
      };

  /// Screens behind the auth guard, with their API fixtures loaded.
  final Map<String, Widget Function()> signedInScreens =
      <String, Widget Function()>{
        'home': HomeScreen.new,
        'settings': SettingsScreen.new,
        'ready orders': ReadyOrdersScreen.new,
        'gate-in': GateInScreen.new,
        'vehicles': VehiclesScreen.new,
        'inspection': () => const VehicleInspectionScreen(vehicleId: 1),
        'store queue': EnteredVehiclesScreen.new,
        'loading': () => const VehicleLoadingScreen(vehicleId: 1),
      };

  group('renders without overflow', () {
    for (final MapEntry<String, Widget Function()> screen
        in publicScreens.entries) {
      for (final TestDevice device in kTestDevices) {
        testWidgets('${screen.key} on $device', (WidgetTester tester) async {
          final TestHarness harness = TestHarness();
          await pumpAt(tester, device, harness.wrap(screen.value()));
          expect(tester.takeException(), isNull);
        });
      }
    }

    for (final MapEntry<String, Widget Function()> screen
        in signedInScreens.entries) {
      for (final TestDevice device in kTestDevices) {
        testWidgets('${screen.key} on $device', (WidgetTester tester) async {
          final TestHarness harness = TestHarness()..withDefaultRoutes();
          await harness.signIn();
          await pumpAt(tester, device, harness.wrap(screen.value()));
          expect(tester.takeException(), isNull);
        });
      }
    }
  });

  group('renders without overflow in every supported language', () {
    // Translations are longer than the English source in every one of these
    // languages, which is where fixed-width layouts break first.
    const List<Locale> locales = <Locale>[
      Locale('en'),
      Locale('hi'),
      Locale('bn'),
      Locale('as'),
    ];
    // The narrowest phone at the largest supported text size: the worst case.
    const TestDevice worstCase = TestDevice(
      'small phone, large text',
      Size(320, 568),
      textScale: 1.35,
    );

    for (final Locale locale in locales) {
      for (final MapEntry<String, Widget Function()> screen
          in signedInScreens.entries) {
        testWidgets('${screen.key} in ${locale.languageCode}', (
          WidgetTester tester,
        ) async {
          final TestHarness harness = TestHarness()..withDefaultRoutes();
          await harness.signIn();
          await pumpAt(
            tester,
            worstCase,
            harness.wrap(screen.value(), locale: locale),
          );
          expect(tester.takeException(), isNull);
        });
      }

      for (final MapEntry<String, Widget Function()> screen
          in publicScreens.entries) {
        testWidgets('${screen.key} in ${locale.languageCode}', (
          WidgetTester tester,
        ) async {
          final TestHarness harness = TestHarness();
          await pumpAt(
            tester,
            worstCase,
            harness.wrap(screen.value(), locale: locale),
          );
          expect(tester.takeException(), isNull);
        });
      }
    }
  });

  group('renders without overflow in dark mode', () {
    const TestDevice device = TestDevice('modern phone', Size(390, 844));

    for (final MapEntry<String, Widget Function()> screen
        in signedInScreens.entries) {
      testWidgets(screen.key, (WidgetTester tester) async {
        final TestHarness harness = TestHarness()..withDefaultRoutes();
        await harness.signIn();
        await pumpAt(
          tester,
          device,
          harness.wrap(screen.value(), brightness: Brightness.dark),
        );
        expect(tester.takeException(), isNull);
      });
    }
  });
}
