import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rainbow_app/core/constants/asset_constants.dart';
import 'package:rainbow_app/core/widgets/app_icon.dart';

import '../support/harness.dart';

/// Every asset referenced from `AppAssets` must exist, parse and render.
///
/// A missing SVG is invisible in code review and only shows up as a blank
/// square at run time, so it is checked mechanically here.
void main() {
  const TestDevice device = TestDevice('modern phone', Size(390, 844));

  group('files on disk', () {
    for (final String asset in <String>[
      ...AppAssets.allIcons,
      ...AppAssets.allLogos,
    ]) {
      test('$asset exists and is an SVG', () {
        final File file = File(asset);
        expect(file.existsSync(), isTrue, reason: asset);
        final String contents = file.readAsStringSync();
        expect(contents.trimLeft(), startsWith('<svg'), reason: asset);
        expect(contents, contains('viewBox'), reason: asset);
      });
    }

    test('every SVG in the icon directory is declared in AppAssets', () {
      final List<String> onDisk =
          Directory('assets/icons')
              .listSync()
              .whereType<File>()
              .map((File f) => f.path)
              .where((String p) => p.endsWith('.svg'))
              .toList()
            ..sort();
      final List<String> declared = <String>[...AppAssets.allIcons]..sort();

      // An icon nobody references is dead weight in the bundle.
      expect(onDisk, declared);
    });

    test('every branding raster used by the tooling exists', () {
      for (final String path in <String>[
        'assets/branding/app_icon.png',
        'assets/branding/app_icon_foreground.png',
        'assets/branding/app_icon_monochrome.png',
        'assets/branding/splash_logo.png',
        'assets/branding/splash_logo_dark.png',
        'assets/branding/splash_android12.png',
        'assets/branding/splash_android12_dark.png',
      ]) {
        expect(File(path).existsSync(), isTrue, reason: path);
      }
    });

    test('the bundled font files and their licence are present', () {
      for (final String weight in <String>['400', '500', '600', '700']) {
        expect(
          File('assets/fonts/Inter-$weight.ttf').existsSync(),
          isTrue,
          reason: weight,
        );
      }
      expect(File('assets/fonts/OFL.txt').existsSync(), isTrue);
    });
  });

  group('rendering', () {
    testWidgets('every icon renders without error', (
      WidgetTester tester,
    ) async {
      final TestHarness harness = TestHarness();

      await pumpAt(
        tester,
        device,
        harness.wrap(
          Scaffold(
            body: SingleChildScrollView(
              child: Wrap(
                children: <Widget>[
                  for (final String icon in AppAssets.allIcons)
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: AppIcon(icon, semanticLabel: icon),
                    ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(AppIcon), findsNWidgets(AppAssets.allIcons.length));
    });
  });
}
