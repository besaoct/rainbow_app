import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rainbow_app/core/widgets/app_card.dart';
import 'package:rainbow_app/core/widgets/responsive_layout.dart';
import 'package:rainbow_app/features/home/screens/home_screen.dart';
import 'package:rainbow_app/features/home/widgets/quick_action_card.dart';

import '../support/harness.dart';

/// The dashboard tiles read as one row: a single line of text each, the same
/// size, never wrapped and never clipped.
void main() {
  Finder tiles() => find.descendant(
    of: find.byType(ResponsiveGrid).first,
    matching: find.byType(QuickActionCard),
  );

  /// The tile's label, scoped to the card body: the count badge sits outside
  /// the card in the same subtree, so an unscoped search finds it instead.
  Finder labelOf(Element tile) => find.descendant(
    of: find.descendant(
      of: find.byWidget(tile.widget),
      matching: find.byType(AppCard),
    ),
    matching: find.byType(Text),
  );

  Iterable<Text> labelsIn(WidgetTester tester) => tiles().evaluate().map(
    (Element tile) => tester.widget<Text>(labelOf(tile).first),
  );

  group('labels', () {
    for (final TestDevice device in kTestDevices) {
      testWidgets('stay on one line on $device', (WidgetTester tester) async {
        final TestHarness harness = TestHarness()..withDefaultRoutes();
        await harness.signIn();

        await pumpAt(tester, device, harness.wrap(const HomeScreen()));

        expect(tiles(), findsWidgets);
        for (final Text label in labelsIn(tester)) {
          expect(label.maxLines, 1, reason: '"${label.data}" on $device');
          expect(
            label.overflow,
            TextOverflow.ellipsis,
            reason: '"${label.data}" on $device',
          );
        }
      });
    }

    testWidgets('are short enough to fit without being ellipsised', (
      WidgetTester tester,
    ) async {
      final TestHarness harness = TestHarness()..withDefaultRoutes();
      await harness.signIn();

      // The narrowest supported phone — where a tile column is tightest.
      await pumpAt(
        tester,
        const TestDevice('small phone', Size(320, 568)),
        harness.wrap(const HomeScreen()),
      );

      for (final Element tile in tiles().evaluate()) {
        final Finder text = labelOf(tile).first;
        final RenderParagraph paragraph = tester.renderObject<RenderParagraph>(
          text,
        );
        expect(
          paragraph.didExceedMaxLines,
          isFalse,
          reason:
              '"${tester.widget<Text>(text).data}" is truncated on a '
              '320pt phone; shorten the label in the ARB files',
        );
      }
    });

    testWidgets('remain untruncated in every supported language', (
      WidgetTester tester,
    ) async {
      for (final Locale locale in const <Locale>[
        Locale('en'),
        Locale('hi'),
        Locale('bn'),
        Locale('as'),
      ]) {
        final TestHarness harness = TestHarness()..withDefaultRoutes();
        await harness.signIn();

        await pumpAt(
          tester,
          const TestDevice('small phone', Size(320, 568)),
          harness.wrap(const HomeScreen(), locale: locale),
        );

        for (final Element tile in tiles().evaluate()) {
          final Finder text = labelOf(tile).first;
          expect(
            tester.renderObject<RenderParagraph>(text).didExceedMaxLines,
            isFalse,
            reason:
                '"${tester.widget<Text>(text).data}" is truncated in '
                '${locale.languageCode}',
          );
        }
      }
    });
  });

  /// The badge's own box, found by the number it renders.
  Finder badgeIn(Finder tile, String value) => find.ancestor(
    of: find.descendant(of: tile, matching: find.text(value)),
    matching: find.byType(Container),
  );

  group('count badge', () {
    testWidgets('sits inline at the end of the label row', (
      WidgetTester tester,
    ) async {
      final TestHarness harness = TestHarness()..withDefaultRoutes();
      await harness.signIn();

      await pumpAt(
        tester,
        const TestDevice('modern phone', Size(390, 844)),
        harness.wrap(const HomeScreen()),
      );

      final Finder tile = tiles().at(1);
      final Rect card = tester.getRect(tile);
      final Rect badge = tester.getRect(badgeIn(tile, '32').first);

      // Inside the card, not overhanging it.
      expect(badge.left, greaterThan(card.left));
      expect(badge.right, lessThan(card.right));
      expect(badge.top, greaterThan(card.top));
      expect(badge.bottom, lessThan(card.bottom));
      // On the label's row, after the label.
      expect(
        badge.left,
        greaterThan(tester.getRect(labelOf(tile.evaluate().single).first).left),
      );
      expect(
        badge.width,
        closeTo(badge.height, 1),
        reason: 'a two-digit count stays a circle',
      );
    });

    testWidgets('leaves the grid with an even gap in both directions', (
      WidgetTester tester,
    ) async {
      final TestHarness harness = TestHarness()..withDefaultRoutes();
      await harness.signIn();

      await pumpAt(
        tester,
        const TestDevice('modern phone', Size(390, 844)),
        harness.wrap(const HomeScreen()),
      );

      final Rect topLeft = tester.getRect(tiles().at(0));
      final Rect topRight = tester.getRect(tiles().at(1));
      final Rect bottomLeft = tester.getRect(tiles().at(2));

      expect(
        bottomLeft.top - topLeft.bottom,
        closeTo(topRight.left - topLeft.right, 0.5),
        reason: 'the row gap and the column gap must match',
      );
    });
  });

  group('counts', () {
    testWidgets('show the size of the queue behind the tile', (
      WidgetTester tester,
    ) async {
      final TestHarness harness = TestHarness()..withDefaultRoutes();
      await harness.signIn();

      await pumpAt(
        tester,
        const TestDevice('modern phone', Size(390, 844)),
        harness.wrap(const HomeScreen()),
      );

      // From `dashboard/summary`, not from the length of a list: the
      // ready-orders fixture holds two rows while the summary reports 32,
      // mirroring the live API, where the list endpoint caps its page.
      expect(
        find.descendant(of: tiles().at(1), matching: find.text('32')),
        findsOneWidget,
        reason:
            'the orders tile must show the server count, not the rows '
            'returned by the capped list endpoint',
      );
      expect(
        find.descendant(of: tiles().at(3), matching: find.text('2')),
        findsOneWidget,
      );
    });

    testWidgets('are omitted on a tile that creates rather than queues', (
      WidgetTester tester,
    ) async {
      final TestHarness harness = TestHarness()..withDefaultRoutes();
      await harness.signIn();

      await pumpAt(
        tester,
        const TestDevice('modern phone', Size(390, 844)),
        harness.wrap(const HomeScreen()),
      );

      expect(tester.widget<QuickActionCard>(tiles().first).count, isNull);
    });
  });
}
