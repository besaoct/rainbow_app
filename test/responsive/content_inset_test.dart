import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/core/widgets/app_card.dart';
import 'package:rainbow_app/core/widgets/responsive_layout.dart';
import 'package:rainbow_app/features/guard/screens/gate_in_screen.dart';
import 'package:rainbow_app/features/guard/screens/ready_orders_screen.dart';
import 'package:rainbow_app/features/guard/screens/vehicle_inspection_screen.dart';
import 'package:rainbow_app/features/guard/screens/vehicles_screen.dart';
import 'package:rainbow_app/features/home/screens/home_screen.dart';
import 'package:rainbow_app/features/settings/screens/settings_screen.dart';
import 'package:rainbow_app/features/store/screens/entered_vehicles_screen.dart';
import 'package:rainbow_app/features/store/screens/vehicle_loading_screen.dart';

import '../support/harness.dart';

/// Every screen must inset its content by the same margin.
///
/// This is easy to get wrong and invisible in review: a list that pads itself
/// *and* wraps each row in a padded container ends up at double the margin,
/// which is exactly what these screens used to do. Measuring the rendered
/// position is the only way to catch it.
void main() {
  final Map<String, Widget> screens = <String, Widget>{
    'home': const HomeScreen(),
    'settings': const SettingsScreen(),
    'ready orders': const ReadyOrdersScreen(),
    'vehicles': const VehiclesScreen(),
    'exit clearance': const VehicleInspectionScreen(vehicleId: 1),
    'store queue': const EnteredVehiclesScreen(),
    'loading': const VehicleLoadingScreen(vehicleId: 1),
    'gate-in': const GateInScreen(),
  };

  // A phone, so the content is narrower than the tablet width cap and the
  // inset is the screen margin rather than a centring offset.
  const TestDevice phone = TestDevice('modern phone', Size(390, 844));

  for (final MapEntry<String, Widget> screen in screens.entries) {
    testWidgets('${screen.key} insets its content by the screen margin', (
      WidgetTester tester,
    ) async {
      final TestHarness harness = TestHarness()..withDefaultRoutes();
      await harness.signIn();

      await pumpAt(tester, phone, harness.wrap(screen.value));

      // A grid cell is only part of a row, so measure the grid itself where
      // one is present; otherwise the first card or field spans the column.
      final Finder content = find.byType(ResponsiveGrid).evaluate().isNotEmpty
          ? find.byType(ResponsiveGrid)
          : find.byType(AppCard).evaluate().isNotEmpty
          ? find.byType(AppCard)
          : find.byType(TextFormField);
      expect(content, findsWidgets, reason: screen.key);

      final Rect rect = tester.getRect(content.first);
      expect(
        rect.left,
        closeTo(AppSpacing.screenH, 0.5),
        reason:
            '${screen.key} starts at ${rect.left}, expected '
            '${AppSpacing.screenH}',
      );
      expect(
        rect.right,
        closeTo(phone.size.width - AppSpacing.screenH, 0.5),
        reason: '${screen.key} ends at ${rect.right}',
      );
    });
  }

  testWidgets('the margin scales with the device rather than being fixed', (
    WidgetTester tester,
  ) async {
    final TestHarness harness = TestHarness()..withDefaultRoutes();
    await harness.signIn();

    // A small phone gets a proportionally smaller margin, so the content
    // column stays usable rather than being squeezed by a fixed inset.
    await pumpAt(
      tester,
      const TestDevice('small phone', Size(320, 568)),
      harness.wrap(const SettingsScreen()),
    );

    final Rect rect = tester.getRect(find.byType(AppCard).first);
    expect(rect.left, closeTo(AppSpacing.screenH, 0.5));
    expect(rect.left, lessThan(20));
  });

  testWidgets('content is centred, not stretched, on a tablet', (
    WidgetTester tester,
  ) async {
    final TestHarness harness = TestHarness()..withDefaultRoutes();
    await harness.signIn();

    const Size window = Size(1024, 768);
    await pumpAt(
      tester,
      const TestDevice('tablet landscape', window),
      harness.wrap(const ReadyOrdersScreen()),
    );

    final Rect rect = tester.getRect(find.byType(AppCard).first);
    expect(rect.width, lessThanOrEqualTo(AppSize.maxContentWidth + 1));
    // Equal gutters either side.
    expect(rect.left, closeTo(window.width - rect.right, 1));
  });
}
