import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/harness.dart';

/// Proves the overflow net in `overflow_test.dart` actually catches overflow.
///
/// Without this, a harness that silently swallowed layout errors would make
/// every screen look correct. A deliberately over-wide row must fail.
void main() {
  const TestDevice device = TestDevice('small phone', Size(320, 568));

  testWidgets('a row wider than the screen is reported', (
    WidgetTester tester,
  ) async {
    final TestHarness harness = TestHarness();

    await pumpAt(
      tester,
      device,
      harness.wrap(
        const Scaffold(
          body: Row(
            children: <Widget>[
              SizedBox(width: 500, height: 20),
              SizedBox(width: 500, height: 20),
            ],
          ),
        ),
      ),
    );

    final Object? exception = tester.takeException();
    expect(exception, isNotNull);
    expect(exception.toString(), contains('overflowed'));
  });

  testWidgets('a column taller than the screen is reported', (
    WidgetTester tester,
  ) async {
    final TestHarness harness = TestHarness();

    await pumpAt(
      tester,
      device,
      harness.wrap(
        const Scaffold(
          body: Column(
            children: <Widget>[
              SizedBox(height: 400, width: 10),
              SizedBox(height: 400, width: 10),
            ],
          ),
        ),
      ),
    );

    final Object? exception = tester.takeException();
    expect(exception, isNotNull);
    expect(exception.toString(), contains('overflowed'));
  });

  testWidgets('a layout that fits reports nothing', (
    WidgetTester tester,
  ) async {
    final TestHarness harness = TestHarness();

    await pumpAt(
      tester,
      device,
      harness.wrap(const Scaffold(body: Center(child: Text('Fits')))),
    );

    expect(tester.takeException(), isNull);
  });
}
