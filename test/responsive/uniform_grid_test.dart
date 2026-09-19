import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rainbow_app/core/widgets/responsive_layout.dart';
import 'package:rainbow_app/core/widgets/uniform_grid.dart';
import 'package:rainbow_app/features/home/screens/home_screen.dart';
import 'package:rainbow_app/features/home/widgets/quick_action_card.dart';

import '../support/harness.dart';

/// Grid cells are all exactly the same size.
///
/// The dashboard's quick actions have labels of different lengths, and those
/// lengths change with the language and the text scale. Without a uniform
/// layout the cards end up different heights, which reads as a broken grid.
void main() {
  Widget box(double height) => SizedBox(height: height, key: Key('$height'));

  group('UniformGrid', () {
    testWidgets('gives every cell the height of the tallest child', (
      WidgetTester tester,
    ) async {
      final TestHarness harness = TestHarness();

      await pumpAt(
        tester,
        const TestDevice('phone', Size(390, 844)),
        harness.wrap(
          Scaffold(
            body: SizedBox(
              width: 300,
              child: UniformGrid(
                columns: 2,
                spacing: 10,
                runSpacing: 10,
                children: <Widget>[box(20), box(80), box(35), box(50)],
              ),
            ),
          ),
        ),
      );

      final List<Rect> cells = <Rect>[
        for (final double h in <double>[20, 80, 35, 50])
          tester.getRect(find.byKey(Key('$h'))),
      ];

      for (final Rect cell in cells) {
        expect(cell.height, 80, reason: 'every cell takes the tallest height');
        expect(cell.width, (300 - 10) / 2);
      }
    });

    testWidgets('places children in row-major order with the given gaps', (
      WidgetTester tester,
    ) async {
      final TestHarness harness = TestHarness();

      await pumpAt(
        tester,
        const TestDevice('phone', Size(390, 844)),
        harness.wrap(
          Scaffold(
            body: SizedBox(
              width: 300,
              child: UniformGrid(
                columns: 2,
                spacing: 10,
                runSpacing: 16,
                children: <Widget>[box(20), box(80), box(35), box(50)],
              ),
            ),
          ),
        ),
      );

      final Rect first = tester.getRect(find.byKey(const Key('20.0')));
      final Rect second = tester.getRect(find.byKey(const Key('80.0')));
      final Rect third = tester.getRect(find.byKey(const Key('35.0')));

      expect(second.left - first.right, 10, reason: 'column gap');
      expect(second.top, first.top, reason: 'same row');
      expect(third.top - first.bottom, 16, reason: 'row gap');
      expect(third.left, first.left, reason: 'same column');
    });

    testWidgets('a single child fills the row rather than half of it', (
      WidgetTester tester,
    ) async {
      final TestHarness harness = TestHarness();

      await pumpAt(
        tester,
        const TestDevice('phone', Size(390, 844)),
        harness.wrap(
          Scaffold(
            body: SizedBox(
              width: 300,
              child: UniformGrid(
                columns: 2,
                spacing: 10,
                runSpacing: 10,
                children: <Widget>[box(40)],
              ),
            ),
          ),
        ),
      );

      expect(tester.getRect(find.byKey(const Key('40.0'))).width, 300);
    });
  });

  group('dashboard quick actions', () {
    for (final TestDevice device in kTestDevices) {
      testWidgets('are all the same size on $device', (
        WidgetTester tester,
      ) async {
        final TestHarness harness = TestHarness()..withDefaultRoutes();
        await harness.signIn();

        await pumpAt(tester, device, harness.wrap(const HomeScreen()));

        final Finder cards = find.descendant(
          of: find.byType(ResponsiveGrid).first,
          matching: find.byType(QuickActionCard),
        );
        expect(cards, findsWidgets);

        final List<Size> sizes = <Size>[
          for (final Element e in cards.evaluate())
            tester.getRect(find.byWidget(e.widget)).size,
        ];
        for (final Size size in sizes) {
          // `closeTo` rather than equality: the column width comes from a
          // division, so cells can differ by a float epsilon.
          expect(
            size.height,
            closeTo(sizes.first.height, 0.01),
            reason: 'height on $device',
          );
          expect(
            size.width,
            closeTo(sizes.first.width, 0.01),
            reason: 'width on $device',
          );
        }
      });
    }

    testWidgets('stay uniform when a translation makes one label longer', (
      WidgetTester tester,
    ) async {
      final TestHarness harness = TestHarness()..withDefaultRoutes();
      await harness.signIn();

      // Assamese labels wrap differently from the English source.
      await pumpAt(
        tester,
        const TestDevice('small phone', Size(320, 568)),
        harness.wrap(const HomeScreen(), locale: const Locale('as')),
      );

      final Finder cards = find.descendant(
        of: find.byType(ResponsiveGrid).first,
        matching: find.byType(QuickActionCard),
      );
      final List<double> heights = <double>[
        for (final Element e in cards.evaluate())
          tester.getRect(find.byWidget(e.widget)).height,
      ];
      for (final double height in heights) {
        expect(height, closeTo(heights.first, 0.01));
      }
    });
  });
}
