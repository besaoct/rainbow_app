import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rainbow_app/features/home/screens/home_screen.dart';
import 'package:rainbow_app/features/home/widgets/quick_action_card.dart';

import '../support/harness.dart';

/// The dashboard stacks on a phone and splits into two columns on a tablet.
///
/// The overflow suite proves nothing clips; this proves the responsive
/// layout actually changes shape, which is the part an overflow check cannot
/// see. It measures where the sections land rather than asserting on the
/// widget tree, so a refactor that keeps the layout is free to change how it
/// is built.
void main() {
  Finder quickActions() => find.byType(QuickActionCard);
  Finder queueStat() => find.byType(StatTile);

  testWidgets('stacks into one column on a phone', (WidgetTester tester) async {
    final TestHarness harness = TestHarness()..withDefaultRoutes();
    await harness.signIn();

    await pumpAt(
      tester,
      const TestDevice('modern phone', Size(390, 844)),
      harness.wrap(const HomeScreen()),
    );

    expect(quickActions(), findsWidgets);
    expect(queueStat(), findsWidgets);

    final Rect action = tester.getRect(quickActions().first);
    final Rect stat = tester.getRect(queueStat().first);

    // The queue section sits below the actions, not beside them.
    expect(stat.top, greaterThan(action.bottom));
  });

  testWidgets('splits into two columns on a tablet', (
    WidgetTester tester,
  ) async {
    final TestHarness harness = TestHarness()..withDefaultRoutes();
    await harness.signIn();

    await pumpAt(
      tester,
      const TestDevice('tablet landscape', Size(1024, 768)),
      harness.wrap(const HomeScreen()),
    );

    final Rect action = tester.getRect(quickActions().first);
    final Rect stat = tester.getRect(queueStat().first);

    // The queue section sits to the right of the actions, and their vertical
    // ranges overlap — that is what "two columns" means.
    expect(stat.left, greaterThan(action.right));
    expect(stat.top, lessThan(action.bottom));
  });

  testWidgets('content stays width-capped rather than stretching', (
    WidgetTester tester,
  ) async {
    final TestHarness harness = TestHarness()..withDefaultRoutes();
    await harness.signIn();

    const Size window = Size(1024, 768);
    await pumpAt(
      tester,
      const TestDevice('tablet landscape', window),
      harness.wrap(const HomeScreen()),
    );

    // A quick-action card on a 1024pt window must not span the whole width.
    final Rect action = tester.getRect(quickActions().first);
    expect(action.width, lessThan(window.width / 2));
  });
}
