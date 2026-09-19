import 'package:flutter/material.dart';

import 'package:rainbow_app/core/theme/app_scale.dart';

/// Font families available to the app.
abstract final class AppFonts {
  /// Bundled for Latin text. Devanagari and Bengali/Assamese glyphs fall back
  /// to the platform font automatically, which is why no family is forced on
  /// the engine's fallback chain.
  static const String primary = 'Inter';
}

/// The font weights the design system uses. Only these four are bundled.
abstract final class AppFontWeight {
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
}

/// Design-space font sizes, before responsive scaling.
abstract final class AppFontSize {
  static double get displayLg => AppScale.of(34);
  static double get displaySm => AppScale.of(28);
  static double get headingLg => AppScale.of(24);
  static double get headingMd => AppScale.of(20);
  static double get headingSm => AppScale.of(17);
  static double get bodyLg => AppScale.of(16);
  static double get bodyMd => AppScale.of(14);
  static double get bodySm => AppScale.of(13);
  static double get caption => AppScale.of(12);
  static double get overline => AppScale.of(11);
}

/// The complete type scale.
///
/// Every style is a getter rather than a constant because sizes depend on the
/// device's responsive [AppScale.factor].
abstract final class AppTextStyles {
  static TextStyle _base(
    double size,
    FontWeight weight, {
    double height = 1.4,
    double letterSpacing = 0,
  }) {
    return TextStyle(
      fontFamily: AppFonts.primary,
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle get displayLarge => _base(
    AppFontSize.displayLg,
    AppFontWeight.bold,
    height: 1.15,
    letterSpacing: -0.6,
  );
  static TextStyle get displaySmall => _base(
    AppFontSize.displaySm,
    AppFontWeight.bold,
    height: 1.2,
    letterSpacing: -0.4,
  );

  static TextStyle get headingLarge => _base(
    AppFontSize.headingLg,
    AppFontWeight.bold,
    height: 1.25,
    letterSpacing: -0.3,
  );
  static TextStyle get headingMedium => _base(
    AppFontSize.headingMd,
    AppFontWeight.semiBold,
    height: 1.3,
    letterSpacing: -0.2,
  );
  static TextStyle get headingSmall =>
      _base(AppFontSize.headingSm, AppFontWeight.semiBold, height: 1.35);

  static TextStyle get bodyLarge =>
      _base(AppFontSize.bodyLg, AppFontWeight.regular, height: 1.5);
  static TextStyle get bodyMedium =>
      _base(AppFontSize.bodyMd, AppFontWeight.regular, height: 1.5);
  static TextStyle get bodySmall =>
      _base(AppFontSize.bodySm, AppFontWeight.regular, height: 1.45);

  static TextStyle get labelLarge =>
      _base(AppFontSize.bodyMd, AppFontWeight.semiBold, height: 1.2);
  static TextStyle get labelMedium =>
      _base(AppFontSize.bodySm, AppFontWeight.medium, height: 1.25);
  static TextStyle get labelSmall =>
      _base(AppFontSize.caption, AppFontWeight.medium, height: 1.25);

  static TextStyle get caption =>
      _base(AppFontSize.caption, AppFontWeight.regular, height: 1.35);

  /// Small, uppercase, wide-tracked label used for section headers.
  static TextStyle get overline => _base(
    AppFontSize.overline,
    AppFontWeight.semiBold,
    height: 1.2,
    letterSpacing: 0.8,
  );

  /// Tabular style for identifiers and quantities, so digits line up in
  /// columns and never reflow as values change.
  static TextStyle get mono => _base(
    AppFontSize.bodyMd,
    AppFontWeight.medium,
    height: 1.3,
    letterSpacing: 0.2,
  ).copyWith(fontFeatures: const <FontFeature>[FontFeature.tabularFigures()]);

  static TextStyle get monoLarge => mono.copyWith(
    fontSize: AppFontSize.headingMd,
    fontWeight: AppFontWeight.bold,
  );

  /// Maps the scale onto Material's [TextTheme].
  static TextTheme textTheme(Color primary, Color secondary) {
    return TextTheme(
      displayLarge: displayLarge.copyWith(color: primary),
      displayMedium: displaySmall.copyWith(color: primary),
      displaySmall: headingLarge.copyWith(color: primary),
      headlineLarge: headingLarge.copyWith(color: primary),
      headlineMedium: headingMedium.copyWith(color: primary),
      headlineSmall: headingSmall.copyWith(color: primary),
      titleLarge: headingMedium.copyWith(color: primary),
      titleMedium: headingSmall.copyWith(color: primary),
      titleSmall: labelLarge.copyWith(color: primary),
      bodyLarge: bodyLarge.copyWith(color: primary),
      bodyMedium: bodyMedium.copyWith(color: primary),
      bodySmall: bodySmall.copyWith(color: secondary),
      labelLarge: labelLarge.copyWith(color: primary),
      labelMedium: labelMedium.copyWith(color: secondary),
      labelSmall: labelSmall.copyWith(color: secondary),
    );
  }
}
