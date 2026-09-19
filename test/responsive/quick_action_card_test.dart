import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

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

  /// The label is the tile's own text; the count, where present, is rendered
  /// with tabular figures in a separate pill.
  Iterable<Text> labelsIn(WidgetTester tester) => tiles().evaluate().map(
        (Element tile) => tester.widget<Text>(
          find
              .descendant(
                of: find.byWidget(tile.widget),
                matching: find.byType(Text),
              )
              .last,
        ),
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
        final Finder text = find
            .descendant(
              of: find.byWidget(tile.widget),
              matching: find.byType(Text),
            )
            .last;
        final RenderParagraph paragraph =
            tester.renderObject<RenderParagraph>(text);
        expect(
          paragraph.didExceedMaxLines,
          isFalse,
          reason: '"${tester.widget<Text>(text).data}" is truncated on a '
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
          final Finder text = find
              .descendant(
                of: find.byWidget(tile.widget),
                matching: find.byType(Text),
              )
              .last;
          expect(
            tester.renderObject<RenderParagraph>(text).didExceedMaxLines,
            isFalse,
            reason: '"${tester.widget<Text>(text).data}" is truncated in '
                '${locale.languageCode}',
          );
        }
      }
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

      // The fixtures hold two ready orders and one vehicle inside the gate.
      expect(
        find.descendant(of: tiles().at(1), matching: find.text('2')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: tiles().at(3), matching: find.text('1')),
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
