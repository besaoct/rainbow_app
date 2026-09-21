import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rainbow_app/core/widgets/app_button.dart';
import 'package:rainbow_app/features/guard/screens/gate_in_screen.dart';
import 'package:rainbow_app/features/guard/screens/vehicle_inspection_screen.dart';
import 'package:rainbow_app/features/store/screens/vehicle_loading_screen.dart';

import '../support/harness.dart';

/// The primary action on a form screen must stay pinned to the bottom edge.
///
/// `Scaffold.bottomSheet` passes loose constraints, so any widget in that
/// slot that expands — a `Center`, an unconstrained `Column` — silently
/// floats the action bar into the middle of the screen while still rendering
/// and still passing an overflow check. This test measures where the button
/// actually lands.
void main() {
  final Map<String, (Widget, String)> screens = <String, (Widget, String)>{
    'gate-in': (const GateInScreen(), 'Register gate-in'),
    'loading': (const VehicleLoadingScreen(vehicleId: 1), 'Submit loading'),
    'inspection': (const VehicleInspectionScreen(vehicleId: 1), 'Approve exit'),
  };

  for (final MapEntry<String, (Widget, String)> screen in screens.entries) {
    for (final TestDevice device in kTestDevices) {
      testWidgets('${screen.key} action bar is anchored on $device', (
        WidgetTester tester,
      ) async {
        final TestHarness harness = TestHarness()..withDefaultRoutes();
        await harness.signIn();

        await pumpAt(tester, device, harness.wrap(screen.value.$1));

        final Finder action = find.widgetWithText(AppButton, screen.value.$2);
        expect(action, findsOneWidget, reason: screen.key);

        final Rect rect = tester.getRect(action);
        // Within one button height of the bottom edge, allowing for the
        // bar's own padding and the home indicator inset.
        expect(
          rect.bottom,
          greaterThan(device.size.height * 0.8),
          reason:
              '${screen.key} on $device: action bar at $rect in a '
              '${device.size} window',
        );
        expect(rect.bottom, lessThanOrEqualTo(device.size.height));
      });
    }
  }

  group('system insets', () {
    // Android's gesture bar and the iPhone home indicator both sit in the
    // bottom inset. The action bar has to clear it, or the primary button on
    // every form ends up under the system navigation.
    const double inset = 34;

    for (final MapEntry<String, (Widget, String)> screen in screens.entries) {
      testWidgets('${screen.key} action bar clears the bottom inset', (
        WidgetTester tester,
      ) async {
        final TestHarness harness = TestHarness()..withDefaultRoutes();
        await harness.signIn();

        const TestDevice device = TestDevice(
          'phone with gesture bar',
          Size(390, 844),
          bottomInset: inset,
        );
        await pumpAt(tester, device, harness.wrap(screen.value.$1));

        final Rect rect = tester.getRect(
          find.widgetWithText(AppButton, screen.value.$2),
        );
        expect(
          rect.bottom,
          lessThanOrEqualTo(device.size.height - inset),
          reason:
              '${screen.key}: the button reaches ${rect.bottom} in an '
              '${device.size.height}pt window with a ${inset}pt inset, so it '
              'sits under the system bar',
        );
      });
    }
  });
}
