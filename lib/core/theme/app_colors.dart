import 'package:flutter/material.dart';

import 'package:rainbow_app/core/theme/app_palette.dart';

/// Semantic colours that Material's [ColorScheme] does not cover.
///
/// Registered as a [ThemeExtension] so light and dark variants resolve
/// automatically and animate together with the rest of the theme. Read it with
/// `context.colors` (see `BuildContextX`).
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textInverse,
    required this.border,
    required this.borderStrong,
    required this.surfaceSunken,
    required this.surfaceRaised,
    required this.overlay,
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.info,
    required this.infoContainer,
    required this.onInfoContainer,
    required this.markEntered,
    required this.markEnteredContainer,
    required this.onMarkEnteredContainer,
    required this.markLoaded,
    required this.markLoadedContainer,
    required this.onMarkLoadedContainer,
    required this.markCleared,
    required this.markClearedContainer,
    required this.onMarkClearedContainer,
    required this.markHeld,
    required this.markHeldContainer,
    required this.onMarkHeldContainer,
  });

  /// Light theme values.
  static const AppColors light = AppColors(
    textPrimary: AppPalette.slate900,
    textSecondary: AppPalette.slate500,
    textTertiary: AppPalette.slate400,
    textInverse: AppPalette.white,
    border: AppPalette.slate200,
    borderStrong: AppPalette.slate300,
    surfaceSunken: AppPalette.slate50,
    surfaceRaised: AppPalette.white,
    overlay: Color(0x520F172A),
    success: AppPalette.green600,
    onSuccess: AppPalette.white,
    successContainer: AppPalette.green100,
    onSuccessContainer: Color(0xFF14532D),
    warning: AppPalette.amber600,
    onWarning: AppPalette.white,
    warningContainer: AppPalette.amber100,
    onWarningContainer: Color(0xFF78350F),
    info: AppPalette.indigo600,
    infoContainer: AppPalette.indigo50,
    onInfoContainer: AppPalette.indigo900,
    markEntered: AppPalette.orange600,
    markEnteredContainer: AppPalette.orange100,
    onMarkEnteredContainer: Color(0xFF7C2D12),
    markLoaded: AppPalette.red600,
    markLoadedContainer: AppPalette.red100,
    onMarkLoadedContainer: Color(0xFF7F1D1D),
    markCleared: AppPalette.green600,
    markClearedContainer: AppPalette.green100,
    onMarkClearedContainer: Color(0xFF14532D),
    markHeld: AppPalette.pink600,
    markHeldContainer: AppPalette.pink100,
    onMarkHeldContainer: Color(0xFF831843),
  );

  /// Dark theme values. Containers become translucent tints of the accent so
  /// they sit correctly on the elevated dark surfaces.
  static const AppColors dark = AppColors(
    textPrimary: Color(0xFFE8ECF6),
    textSecondary: Color(0xFF9AA6C2),
    textTertiary: Color(0xFF6B7794),
    textInverse: AppPalette.ink900,
    border: AppPalette.ink600,
    borderStrong: Color(0xFF3B466E),
    surfaceSunken: AppPalette.ink900,
    surfaceRaised: AppPalette.ink700,
    overlay: Color(0x8A05070F),
    success: AppPalette.green300,
    onSuccess: Color(0xFF052E16),
    successContainer: Color(0x2E22C55E),
    onSuccessContainer: AppPalette.green300,
    warning: AppPalette.amber300,
    onWarning: Color(0xFF451A03),
    warningContainer: Color(0x2EF59E0B),
    onWarningContainer: AppPalette.amber300,
    info: AppPalette.indigo300,
    infoContainer: Color(0x2E6366F1),
    onInfoContainer: AppPalette.indigo200,
    markEntered: AppPalette.orange300,
    markEnteredContainer: Color(0x33F97316),
    onMarkEnteredContainer: AppPalette.orange300,
    markLoaded: AppPalette.red300,
    markLoadedContainer: Color(0x33EF4444),
    onMarkLoadedContainer: AppPalette.red300,
    markCleared: AppPalette.green300,
    markClearedContainer: Color(0x3322C55E),
    onMarkClearedContainer: AppPalette.green300,
    markHeld: AppPalette.pink300,
    markHeldContainer: Color(0x33EC4899),
    onMarkHeldContainer: AppPalette.pink300,
  );

  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textInverse;

  final Color border;
  final Color borderStrong;
  final Color surfaceSunken;
  final Color surfaceRaised;
  final Color overlay;

  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;

  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color onWarningContainer;

  final Color info;
  final Color infoContainer;
  final Color onInfoContainer;

  /// Orange mark — the vehicle has entered the gate.
  final Color markEntered;
  final Color markEnteredContainer;
  final Color onMarkEnteredContainer;

  /// Red mark — the vehicle is loaded and awaiting security clearance.
  final Color markLoaded;
  final Color markLoadedContainer;
  final Color onMarkLoadedContainer;

  /// Green mark — the vehicle is cleared to leave.
  final Color markCleared;
  final Color markClearedContainer;
  final Color onMarkClearedContainer;

  /// Held — an issue was recorded and the vehicle may not leave.
  final Color markHeld;
  final Color markHeldContainer;
  final Color onMarkHeldContainer;

  @override
  AppColors copyWith({
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textInverse,
    Color? border,
    Color? borderStrong,
    Color? surfaceSunken,
    Color? surfaceRaised,
    Color? overlay,
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? info,
    Color? infoContainer,
    Color? onInfoContainer,
    Color? markEntered,
    Color? markEnteredContainer,
    Color? onMarkEnteredContainer,
    Color? markLoaded,
    Color? markLoadedContainer,
    Color? onMarkLoadedContainer,
    Color? markCleared,
    Color? markClearedContainer,
    Color? onMarkClearedContainer,
    Color? markHeld,
    Color? markHeldContainer,
    Color? onMarkHeldContainer,
  }) {
    return AppColors(
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textInverse: textInverse ?? this.textInverse,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      surfaceSunken: surfaceSunken ?? this.surfaceSunken,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      overlay: overlay ?? this.overlay,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      info: info ?? this.info,
      infoContainer: infoContainer ?? this.infoContainer,
      onInfoContainer: onInfoContainer ?? this.onInfoContainer,
      markEntered: markEntered ?? this.markEntered,
      markEnteredContainer: markEnteredContainer ?? this.markEnteredContainer,
      onMarkEnteredContainer:
          onMarkEnteredContainer ?? this.onMarkEnteredContainer,
      markLoaded: markLoaded ?? this.markLoaded,
      markLoadedContainer: markLoadedContainer ?? this.markLoadedContainer,
      onMarkLoadedContainer:
          onMarkLoadedContainer ?? this.onMarkLoadedContainer,
      markCleared: markCleared ?? this.markCleared,
      markClearedContainer: markClearedContainer ?? this.markClearedContainer,
      onMarkClearedContainer:
          onMarkClearedContainer ?? this.onMarkClearedContainer,
      markHeld: markHeld ?? this.markHeld,
      markHeldContainer: markHeldContainer ?? this.markHeldContainer,
      onMarkHeldContainer: onMarkHeldContainer ?? this.onMarkHeldContainer,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      textPrimary: c(textPrimary, other.textPrimary),
      textSecondary: c(textSecondary, other.textSecondary),
      textTertiary: c(textTertiary, other.textTertiary),
      textInverse: c(textInverse, other.textInverse),
      border: c(border, other.border),
      borderStrong: c(borderStrong, other.borderStrong),
      surfaceSunken: c(surfaceSunken, other.surfaceSunken),
      surfaceRaised: c(surfaceRaised, other.surfaceRaised),
      overlay: c(overlay, other.overlay),
      success: c(success, other.success),
      onSuccess: c(onSuccess, other.onSuccess),
      successContainer: c(successContainer, other.successContainer),
      onSuccessContainer: c(onSuccessContainer, other.onSuccessContainer),
      warning: c(warning, other.warning),
      onWarning: c(onWarning, other.onWarning),
      warningContainer: c(warningContainer, other.warningContainer),
      onWarningContainer: c(onWarningContainer, other.onWarningContainer),
      info: c(info, other.info),
      infoContainer: c(infoContainer, other.infoContainer),
      onInfoContainer: c(onInfoContainer, other.onInfoContainer),
      markEntered: c(markEntered, other.markEntered),
      markEnteredContainer: c(markEnteredContainer, other.markEnteredContainer),
      onMarkEnteredContainer: c(
        onMarkEnteredContainer,
        other.onMarkEnteredContainer,
      ),
      markLoaded: c(markLoaded, other.markLoaded),
      markLoadedContainer: c(markLoadedContainer, other.markLoadedContainer),
      onMarkLoadedContainer: c(
        onMarkLoadedContainer,
        other.onMarkLoadedContainer,
      ),
      markCleared: c(markCleared, other.markCleared),
      markClearedContainer: c(markClearedContainer, other.markClearedContainer),
      onMarkClearedContainer: c(
        onMarkClearedContainer,
        other.onMarkClearedContainer,
      ),
      markHeld: c(markHeld, other.markHeld),
      markHeldContainer: c(markHeldContainer, other.markHeldContainer),
      onMarkHeldContainer: c(onMarkHeldContainer, other.onMarkHeldContainer),
    );
  }
}
