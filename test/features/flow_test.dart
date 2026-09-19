import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rainbow_app/core/services/preferences_service.dart';
import 'package:rainbow_app/core/widgets/app_button.dart';
import 'package:rainbow_app/core/widgets/app_status_badge.dart';
import 'package:rainbow_app/features/auth/screens/login_screen.dart';
import 'package:rainbow_app/features/guard/screens/ready_orders_screen.dart';
import 'package:rainbow_app/features/guard/screens/vehicle_inspection_screen.dart';
import 'package:rainbow_app/features/guard/screens/vehicles_screen.dart';
import 'package:rainbow_app/features/guard/widgets/gate_entry_card.dart';
import 'package:rainbow_app/features/onboarding/screens/onboarding_screen.dart';
import 'package:rainbow_app/features/store/screens/entered_vehicles_screen.dart';
import 'package:rainbow_app/features/store/screens/vehicle_loading_screen.dart';

import '../support/fake_api.dart';
import '../support/fixtures.dart';
import '../support/harness.dart';

const TestDevice _phone = TestDevice('modern phone', Size(390, 844));

void main() {
  group('first-launch flow', () {
    testWidgets('the introduction runs and records that it is complete', (
      WidgetTester tester,
    ) async {
      final InMemoryPreferencesService preferences =
          InMemoryPreferencesService();
      final TestHarness harness = TestHarness(preferences: preferences);

      await pumpAt(tester, _phone, harness.wrap(const OnboardingScreen()));

      expect(preferences.hasCompletedOnboarding, isFalse);
      expect(find.text('Register every vehicle at the gate'), findsOneWidget);

      // Step through to the final page.
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      expect(find.text('Clear the exit with confidence'), findsOneWidget);
      await tester.tap(find.text('Get started'));
      await tester.pump();

      expect(preferences.hasCompletedOnboarding, isTrue);
    });

    testWidgets('skipping also completes it, so it does not reappear', (
      WidgetTester tester,
    ) async {
      final InMemoryPreferencesService preferences =
          InMemoryPreferencesService();
      final TestHarness harness = TestHarness(preferences: preferences);

      await pumpAt(tester, _phone, harness.wrap(const OnboardingScreen()));
      await tester.tap(find.text('Skip'));
      await tester.pump();

      expect(preferences.hasCompletedOnboarding, isTrue);
    });
  });

  group('sign-in', () {
    testWidgets('rejects a malformed address before calling the server', (
      WidgetTester tester,
    ) async {
      final TestHarness harness = TestHarness();

      await pumpAt(tester, _phone, harness.wrap(const LoginScreen()));

      await tester.enterText(find.byType(TextFormField).first, 'not-an-email');
      await tester.enterText(find.byType(TextFormField).last, 'Guard@12345');
      await tester.tap(find.byType(AppButton));
      await tester.pump();

      expect(find.text('Enter a valid email address.'), findsOneWidget);
      expect(harness.api.requestedPaths, isEmpty);
    });

    testWidgets('shows the server’s rejection inline', (
      WidgetTester tester,
    ) async {
      final TestHarness harness = TestHarness();
      harness.api.on(
        '/auth/login',
        const FakeResponse(Fixtures.unauthorized, statusCode: 401),
      );

      await pumpAt(tester, _phone, harness.wrap(const LoginScreen()));

      await tester.enterText(
        find.byType(TextFormField).first,
        'guard@rainbowerp.com',
      );
      await tester.enterText(find.byType(TextFormField).last, 'wrong-password');
      await tester.tap(find.byType(AppButton));
      await tester.pumpAndSettle();

      expect(
        find.text('Your session has expired. Please sign in again.'),
        findsOneWidget,
      );
    });

    testWidgets('an account with no gate or store rights is turned away', (
      WidgetTester tester,
    ) async {
      final TestHarness harness = TestHarness();
      harness.api.on(
        '/auth/login',
        const FakeResponse(<String, Object?>{
          'success': true,
          'data': <String, Object?>{
            'token': 'sales-token',
            'user': Fixtures.salesUser,
          },
        }),
      );

      await pumpAt(tester, _phone, harness.wrap(const LoginScreen()));

      await tester.enterText(
        find.byType(TextFormField).first,
        'sales@rainbowerp.com',
      );
      await tester.enterText(find.byType(TextFormField).last, 'Sales@12345');
      await tester.tap(find.byType(AppButton));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('not set up for gate or store operations'),
        findsOneWidget,
      );
    });
  });

  group('guard screens', () {
    testWidgets('the vehicle list shows each vehicle and its colour mark', (
      WidgetTester tester,
    ) async {
      final TestHarness harness = TestHarness()..withDefaultRoutes();
      await harness.signIn();

      await pumpAt(tester, _phone, harness.wrap(const VehiclesScreen()));

      expect(find.text('KA 01 ZZ 7777'), findsOneWidget);
      expect(find.text('GJ 05 AB 1234'), findsOneWidget);
      // Scoped to the rows: the same labels also appear as filter chips.
      expect(
        find.descendant(
          of: find.byType(GateEntryCard),
          matching: find.descendant(
            of: find.byType(AppStatusBadge),
            matching: find.text('Cleared'),
          ),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(GateEntryCard),
          matching: find.descendant(
            of: find.byType(AppStatusBadge),
            matching: find.text('Held'),
          ),
        ),
        findsOneWidget,
      );
      // The recorded reason is surfaced on the row, not hidden in a detail.
      expect(find.text('Challan mismatch'), findsOneWidget);
    });

    testWidgets('ready orders list the pending quantity and line count', (
      WidgetTester tester,
    ) async {
      final TestHarness harness = TestHarness()..withDefaultRoutes();
      await harness.signIn();

      await pumpAt(tester, _phone, harness.wrap(const ReadyOrdersScreen()));

      expect(find.text('SO-20260818-786E'), findsOneWidget);
      expect(find.text('Ambica Interior Studio'), findsOneWidget);
      expect(find.text('10 pcs'), findsOneWidget);
      expect(find.text('1 line'), findsOneWidget);
    });

    testWidgets('an empty queue shows the empty state, never a blank page', (
      WidgetTester tester,
    ) async {
      final TestHarness harness = TestHarness();
      harness.api.on(
        '/guard/orders-ready',
        const FakeResponse(<String, Object?>{
          'success': true,
          'data': <Object?>[],
        }),
      );
      await harness.signIn();

      await pumpAt(tester, _phone, harness.wrap(const ReadyOrdersScreen()));

      expect(find.text('No orders ready for dispatch'), findsOneWidget);
    });

    testWidgets('an offline device shows the offline state with a retry', (
      WidgetTester tester,
    ) async {
      final TestHarness harness = TestHarness();
      harness.api.on(
        '/guard/orders-ready',
        const FakeResponse(<String, Object?>{
          'message': 'Server Error',
        }, statusCode: 503),
      );
      await harness.signIn();

      await pumpAt(tester, _phone, harness.wrap(const ReadyOrdersScreen()));

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('exit clearance shows the load, documents and both decisions', (
      WidgetTester tester,
    ) async {
      final TestHarness harness = TestHarness()..withDefaultRoutes();
      await harness.signIn();

      await pumpAt(
        tester,
        _phone,
        harness.wrap(const VehicleInspectionScreen(vehicleId: 1)),
      );

      expect(find.text('CH-2026-901'), findsOneWidget);
      expect(find.text('EWB-8877665544'), findsOneWidget);
      expect(find.text('10FT Panel Design 6197'), findsOneWidget);
      expect(find.text('Approve exit'), findsOneWidget);
      expect(find.text('Hold vehicle'), findsOneWidget);
    });

    testWidgets('a vehicle that is not loaded cannot be cleared', (
      WidgetTester tester,
    ) async {
      final TestHarness harness = TestHarness();
      harness.api.on(
        '/inspection',
        const FakeResponse(<String, Object?>{
          'success': true,
          'data': <String, Object?>{
            'id': 1,
            'gate_pass_no': 'GP-20260919-0001',
            'vehicle_no': 'KA 01 ZZ 7777',
            'status': 'entered',
            'color_mark': 'orange',
            'items_to_verify': <Object?>[],
            'total_pcs': 0,
            'total_boxes': 0,
          },
        }),
      );
      await harness.signIn();

      await pumpAt(
        tester,
        _phone,
        harness.wrap(const VehicleInspectionScreen(vehicleId: 1)),
      );

      expect(find.text('Not loaded yet'), findsOneWidget);
      expect(find.text('Approve exit'), findsNothing);
    });

    testWidgets('approving the exit posts the decision', (
      WidgetTester tester,
    ) async {
      final TestHarness harness = TestHarness()..withDefaultRoutes();
      harness.api.on(
        '/gate-out',
        const FakeResponse(<String, Object?>{
          'success': true,
          'message': 'Cleared',
          'data': <String, Object?>{
            'id': 1,
            'gate_pass_no': 'GP-20260919-0001',
            'vehicle_no': 'KA 01 ZZ 7777',
            'status': 'cleared',
          },
        }),
      );
      await harness.signIn();

      await pumpAt(
        tester,
        _phone,
        harness.wrap(const VehicleInspectionScreen(vehicleId: 1)),
      );

      await tester.tap(find.widgetWithText(AppButton, 'Approve exit'));
      await tester.pumpAndSettle();
      // The action is confirmed before it is sent.
      expect(find.text('Approve exit?'), findsOneWidget);

      await tester.tap(find.widgetWithText(AppButton, 'Approve exit').last);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(
        harness.api.requestedPaths.any((String p) => p.contains('gate-out')),
        isTrue,
      );
    });
  });

  group('store screens', () {
    testWidgets('the queue lists what is waiting to be loaded', (
      WidgetTester tester,
    ) async {
      final TestHarness harness = TestHarness()..withDefaultRoutes();
      await harness.signIn();

      await pumpAt(tester, _phone, harness.wrap(const EnteredVehiclesScreen()));

      expect(find.text('KA 01 ZZ 7777'), findsOneWidget);
      expect(find.text('Entered'), findsOneWidget);
      expect(find.text('Start loading'), findsOneWidget);
    });

    testWidgets('loading shows pending quantity and stock for each line', (
      WidgetTester tester,
    ) async {
      final TestHarness harness = TestHarness()..withDefaultRoutes();
      await harness.signIn();

      await pumpAt(
        tester,
        _phone,
        harness.wrap(const VehicleLoadingScreen(vehicleId: 1)),
      );

      expect(find.text('10FT Panel Design 6197'), findsOneWidget);
      expect(find.text('In stock'), findsOneWidget);
      expect(find.text('36'), findsOneWidget);
    });

    testWidgets('submitting with no quantities is refused before sending', (
      WidgetTester tester,
    ) async {
      final TestHarness harness = TestHarness()..withDefaultRoutes();
      await harness.signIn();

      await pumpAt(
        tester,
        _phone,
        harness.wrap(const VehicleLoadingScreen(vehicleId: 1)),
      );

      await tester.tap(find.widgetWithText(AppButton, 'Submit loading'));
      await tester.pump();

      expect(
        find.text('Enter a quantity for at least one item.'),
        findsOneWidget,
      );
      expect(
        harness.api.requestedPaths.any((String p) => p.endsWith('/load')),
        isFalse,
      );
    });

    testWidgets('a quantity above the pending amount is rejected inline', (
      WidgetTester tester,
    ) async {
      final TestHarness harness = TestHarness()..withDefaultRoutes();
      await harness.signIn();

      await pumpAt(
        tester,
        _phone,
        harness.wrap(const VehicleLoadingScreen(vehicleId: 1)),
      );

      // The line has 10 pending and 36 in stock.
      final Finder quantityField = find.widgetWithText(TextFormField, '0');
      await tester.ensureVisible(quantityField);
      await tester.pump();
      await tester.enterText(quantityField, '11');
      await tester.pump();

      expect(
        find.text('Only 10 pcs are pending on this line.'),
        findsOneWidget,
      );
    });

    testWidgets('"load all pending" fills the line and derives the boxes', (
      WidgetTester tester,
    ) async {
      final TestHarness harness = TestHarness()..withDefaultRoutes();
      await harness.signIn();

      await pumpAt(
        tester,
        _phone,
        harness.wrap(const VehicleLoadingScreen(vehicleId: 1)),
      );

      final Finder fillButton = find.widgetWithText(
        AppButton,
        'Load all pending',
      );
      await tester.ensureVisible(fillButton);
      await tester.pump();
      await tester.tap(fillButton);
      await tester.pump();

      // 10 pieces at 10 per box is exactly one box.
      expect(find.text('1 box'), findsOneWidget);
      expect(find.text('1 of 1 lines have a quantity'), findsOneWidget);
    });
  });
}
