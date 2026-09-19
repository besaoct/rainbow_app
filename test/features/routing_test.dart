import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:rainbow_app/core/services/preferences_service.dart';
import 'package:rainbow_app/features/auth/screens/login_screen.dart';
import 'package:rainbow_app/features/guard/screens/vehicles_screen.dart';
import 'package:rainbow_app/features/home/screens/home_screen.dart';
import 'package:rainbow_app/features/onboarding/screens/onboarding_screen.dart';

import '../support/fixtures.dart';
import '../support/harness.dart';

const TestDevice _phone = TestDevice('modern phone', Size(390, 844));

/// The first-launch decision, exercised through the real router.
///
/// ```text
/// launch → restore session → first launch? → onboarding : signed in? →
///          home : sign-in
/// ```
void main() {
  group('first launch', () {
    testWidgets('a fresh install lands on the introduction', (
      WidgetTester tester,
    ) async {
      final TestHarness harness = TestHarness(
        preferences: InMemoryPreferencesService(),
      )..withDefaultRoutes();

      await pumpAt(tester, _phone, harness.wrapApp());

      expect(find.byType(OnboardingScreen), findsOneWidget);
    });

    testWidgets('a second launch skips the introduction and asks to sign in', (
      WidgetTester tester,
    ) async {
      final TestHarness harness = TestHarness(
        preferences: InMemoryPreferencesService(hasCompletedOnboarding: true),
      )..withDefaultRoutes();

      await pumpAt(tester, _phone, harness.wrapApp());

      expect(find.byType(OnboardingScreen), findsNothing);
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('a restored session goes straight to the dashboard', (
      WidgetTester tester,
    ) async {
      final TestHarness harness = TestHarness(
        preferences: InMemoryPreferencesService(hasCompletedOnboarding: true),
      )..withDefaultRoutes();
      await harness.signIn();

      await pumpAt(tester, _phone, harness.wrapApp());

      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('completing the introduction moves on without a manual push', (
      WidgetTester tester,
    ) async {
      final InMemoryPreferencesService preferences =
          InMemoryPreferencesService();
      final TestHarness harness = TestHarness(preferences: preferences)
        ..withDefaultRoutes();

      await pumpAt(tester, _phone, harness.wrapApp());
      expect(find.byType(OnboardingScreen), findsOneWidget);

      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();

      expect(preferences.hasCompletedOnboarding, isTrue);
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('storage that cannot be written still lets the app run', (
      WidgetTester tester,
    ) async {
      // `SharedPreferencesService.open()` degrades to this when the platform
      // store is unavailable.
      final TestHarness harness = TestHarness(
        preferences: InMemoryPreferencesService(isAvailable: false),
      )..withDefaultRoutes();

      await pumpAt(tester, _phone, harness.wrapApp());

      expect(find.byType(OnboardingScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('route guards', () {
    testWidgets('a guard account can open the gate screens', (
      WidgetTester tester,
    ) async {
      final TestHarness harness = TestHarness(
        preferences: InMemoryPreferencesService(hasCompletedOnboarding: true),
      )..withDefaultRoutes();
      await harness.signIn();

      await pumpAt(tester, _phone, harness.wrapApp());
      tester.element(find.byType(HomeScreen)).go('/guard/vehicles');
      await tester.pumpAndSettle();

      expect(find.byType(VehiclesScreen), findsOneWidget);
    });

    testWidgets(
      'an account without gate rights is sent back to the dashboard',
      (WidgetTester tester) async {
        final TestHarness harness = TestHarness(
          preferences: InMemoryPreferencesService(hasCompletedOnboarding: true),
        )..withDefaultRoutes();
        // Signed in, but with neither capability flag.
        await harness.signIn(user: Fixtures.salesUser);

        await pumpAt(tester, _phone, harness.wrapApp());
        tester.element(find.byType(HomeScreen)).go('/guard/vehicles');
        await tester.pumpAndSettle();

        expect(find.byType(VehiclesScreen), findsNothing);
        expect(find.byType(HomeScreen), findsOneWidget);
      },
    );

    testWidgets('an unknown URL shows the not-found screen, not a crash', (
      WidgetTester tester,
    ) async {
      final TestHarness harness = TestHarness(
        preferences: InMemoryPreferencesService(hasCompletedOnboarding: true),
      )..withDefaultRoutes();
      await harness.signIn();

      await pumpAt(tester, _phone, harness.wrapApp());
      tester.element(find.byType(HomeScreen)).go('/no/such/place');
      await tester.pumpAndSettle();

      expect(
        find.text('We could not find what you were looking for.'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  });
}
