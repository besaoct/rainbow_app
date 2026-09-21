import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rainbow_app/core/theme/app_colors.dart';

/// Every filled accent surface carries light text at readable contrast.
///
/// The brand accents are picked to read as foreground colours, so several are
/// too light for white text on their own — cyan-600 reaches only 3.9:1.
/// `accentFill` darkens them just enough, and these tests hold that line for
/// every accent the app actually paints a badge with.
void main() {
  const AppColors light = AppColors.light;
  const AppColors dark = AppColors.dark;

  /// The accents passed to a count badge today, in both themes.
  final Map<String, Color> accents = <String, Color>{
    'light entered': light.markEntered,
    'light loaded': light.markLoaded,
    'light cleared': light.markCleared,
    'light held': light.markHeld,
    'light info': light.info,
    'dark entered': dark.markEntered,
    'dark loaded': dark.markLoaded,
    'dark cleared': dark.markCleared,
    'dark held': dark.markHeld,
    'dark info': dark.info,
    // The dashboard's "Orders" tile uses the scheme's secondary.
    'cyan 600': const Color(0xFF0891B2),
    'cyan 400': const Color(0xFF22D3EE),
  };

  group('accentFill', () {
    for (final MapEntry<String, Color> accent in accents.entries) {
      test('${accent.key} carries light text at AA contrast', () {
        final Color fill = light.accentFill(accent.value);
        expect(
          light.contrastRatio(light.onAccentFill, fill),
          greaterThanOrEqualTo(4.5),
          reason: '${accent.key} fill $fill is too light for white text',
        );
      });
    }

    test('leaves an accent that is already dark enough alone', () {
      // Red-600 already reaches 4.8:1 against white.
      const Color red600 = Color(0xFFDC2626);
      expect(light.accentFill(red600), red600);
    });

    test('keeps the hue, so the badge still reads as its tile colour', () {
      const Color cyan600 = Color(0xFF0891B2);
      final HSLColor original = HSLColor.fromColor(cyan600);
      final HSLColor filled = HSLColor.fromColor(light.accentFill(cyan600));

      expect(filled.hue, closeTo(original.hue, 2));
      expect(filled.lightness, lessThan(original.lightness));
    });

    test('is a no-op for a colour that is already black', () {
      expect(
        light.accentFill(const Color(0xFF000000)),
        const Color(0xFF000000),
      );
    });
  });

  group('contrastRatio', () {
    test('matches the WCAG reference values', () {
      expect(
        light.contrastRatio(const Color(0xFFFFFFFF), const Color(0xFF000000)),
        closeTo(21, 0.01),
      );
      expect(
        light.contrastRatio(const Color(0xFFFFFFFF), const Color(0xFFFFFFFF)),
        closeTo(1, 0.01),
      );
    });

    test('is symmetric', () {
      const Color a = Color(0xFF0891B2);
      const Color b = Color(0xFFFFFFFF);
      expect(
        light.contrastRatio(a, b),
        closeTo(light.contrastRatio(b, a), 1e-9),
      );
    });
  });
}
