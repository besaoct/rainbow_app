import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:rainbow_app/core/theme/app_colors.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/core/theme/app_durations.dart';
import 'package:rainbow_app/core/theme/app_palette.dart';
import 'package:rainbow_app/core/theme/app_typography.dart';

/// Assembles [ThemeData] from the design tokens.
///
/// Component themes are configured here so screens never restyle a button or
/// an input inline; a change to, say, input radius is a one-line edit.
abstract final class AppTheme {
  static ThemeData get light => _build(
    brightness: Brightness.light,
    colors: AppColors.light,
    scheme: const ColorScheme.light(
      primary: AppPalette.indigo600,
      onPrimary: AppPalette.white,
      primaryContainer: AppPalette.indigo50,
      onPrimaryContainer: AppPalette.indigo900,
      secondary: AppPalette.cyan600,
      onSecondary: AppPalette.white,
      secondaryContainer: AppPalette.cyan100,
      onSecondaryContainer: AppPalette.cyan800,
      error: AppPalette.red600,
      onError: AppPalette.white,
      errorContainer: AppPalette.red100,
      onErrorContainer: Color(0xFF7F1D1D),
      surface: AppPalette.white,
      onSurface: AppPalette.slate900,
      surfaceContainerLowest: AppPalette.white,
      surfaceContainerLow: AppPalette.slate50,
      surfaceContainer: AppPalette.slate100,
      surfaceContainerHigh: AppPalette.slate100,
      surfaceContainerHighest: AppPalette.slate200,
      onSurfaceVariant: AppPalette.slate500,
      outline: AppPalette.slate300,
      outlineVariant: AppPalette.slate200,
      inverseSurface: AppPalette.slate900,
      onInverseSurface: AppPalette.white,
      inversePrimary: AppPalette.indigo300,
    ),
  );

  static ThemeData get dark => _build(
    brightness: Brightness.dark,
    colors: AppColors.dark,
    scheme: const ColorScheme.dark(
      primary: AppPalette.indigo400,
      onPrimary: AppPalette.indigo950,
      primaryContainer: AppPalette.indigo700,
      onPrimaryContainer: AppPalette.indigo100,
      secondary: AppPalette.cyan400,
      onSecondary: Color(0xFF042F36),
      secondaryContainer: AppPalette.cyan800,
      onSecondaryContainer: AppPalette.cyan100,
      error: AppPalette.red300,
      onError: Color(0xFF450A0A),
      errorContainer: Color(0xFF7F1D1D),
      onErrorContainer: AppPalette.red100,
      surface: AppPalette.ink800,
      onSurface: Color(0xFFE8ECF6),
      surfaceContainerLowest: AppPalette.ink900,
      surfaceContainerLow: AppPalette.ink800,
      surfaceContainer: AppPalette.ink700,
      surfaceContainerHigh: AppPalette.ink700,
      surfaceContainerHighest: AppPalette.ink600,
      onSurfaceVariant: Color(0xFF9AA6C2),
      outline: AppPalette.ink600,
      outlineVariant: AppPalette.ink700,
      inverseSurface: AppPalette.slate100,
      onInverseSurface: AppPalette.slate900,
      inversePrimary: AppPalette.indigo600,
    ),
  );

  static ThemeData _build({
    required Brightness brightness,
    required ColorScheme scheme,
    required AppColors colors,
  }) {
    final TextTheme textTheme = AppTextStyles.textTheme(
      colors.textPrimary,
      colors.textSecondary,
    );
    final bool isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: colors.surfaceSunken,
      canvasColor: scheme.surface,
      fontFamily: AppFonts.primary,
      textTheme: textTheme,
      extensions: <ThemeExtension<Object?>>[colors],
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.standard,

      appBarTheme: AppBarTheme(
        backgroundColor: colors.surfaceSunken,
        foregroundColor: colors.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: AppSpacing.screenH,
        toolbarHeight: AppSize.appBarHeight,
        titleTextStyle: AppTextStyles.headingMedium.copyWith(
          color: colors.textPrimary,
        ),
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light.copyWith(
                statusBarColor: Colors.transparent,
                systemNavigationBarColor: colors.surfaceSunken,
              )
            : SystemUiOverlayStyle.dark.copyWith(
                statusBarColor: Colors.transparent,
                systemNavigationBarColor: colors.surfaceSunken,
              ),
      ),

      dividerTheme: DividerThemeData(
        color: colors.border,
        thickness: AppSize.dividerThickness,
        space: AppSize.dividerThickness,
      ),

      cardTheme: CardThemeData(
        color: colors.surfaceRaised,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.cardRadius,
          side: BorderSide(color: colors.border, width: AppSize.borderWidth),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: Size(double.infinity, AppSize.buttonHeight),
          textStyle: AppTextStyles.labelLarge,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          animationDuration: AppDurations.instant,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: Size(double.infinity, AppSize.buttonHeight),
          textStyle: AppTextStyles.labelLarge,
          foregroundColor: colors.textPrimary,
          side: BorderSide(
            color: colors.borderStrong,
            width: AppSize.borderWidth,
          ),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: AppTextStyles.labelLarge,
          foregroundColor: scheme.primary,
          minimumSize: const Size(0, AppSize.minTapTarget),
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? colors.surfaceRaised : AppPalette.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(color: colors.textTertiary),
        labelStyle: textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
        floatingLabelStyle: textTheme.labelMedium?.copyWith(
          color: scheme.primary,
        ),
        errorStyle: AppTextStyles.caption.copyWith(color: scheme.error),
        errorMaxLines: 3,
        border: _inputBorder(colors.border),
        enabledBorder: _inputBorder(colors.border),
        focusedBorder: _inputBorder(scheme.primary, focused: true),
        errorBorder: _inputBorder(scheme.error),
        focusedErrorBorder: _inputBorder(scheme.error, focused: true),
        disabledBorder: _inputBorder(colors.border),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: colors.surfaceRaised,
        selectedColor: scheme.primaryContainer,
        side: BorderSide(color: colors.border, width: AppSize.borderWidth),
        labelStyle: AppTextStyles.labelMedium.copyWith(
          color: colors.textPrimary,
        ),
        secondaryLabelStyle: AppTextStyles.labelMedium.copyWith(
          color: scheme.onPrimaryContainer,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.chipRadius),
        showCheckmark: false,
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: scheme.surface,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.sheetRadius),
        showDragHandle: true,
        dragHandleColor: colors.borderStrong,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        titleTextStyle: AppTextStyles.headingSmall.copyWith(
          color: colors.textPrimary,
        ),
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: colors.textSecondary,
        ),
        insetPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xxl,
          vertical: AppSpacing.xxl,
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colors.textPrimary,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: colors.textInverse,
        ),
        actionTextColor: scheme.inversePrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        insetPadding: EdgeInsets.all(AppSpacing.lg),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: scheme.primaryContainer,
        elevation: 0,
        height: AppScaleSizes.navigationBarHeight,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (Set<WidgetState> states) => states.contains(WidgetState.selected)
              ? AppTextStyles.labelSmall.copyWith(color: scheme.primary)
              : AppTextStyles.labelSmall.copyWith(color: colors.textSecondary),
        ),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: colors.border,
        circularTrackColor: Colors.transparent,
        strokeWidth: AppSize.progressStroke,
      ),

      listTileTheme: ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        minVerticalPadding: AppSpacing.md,
        titleTextStyle: AppTextStyles.bodyLarge.copyWith(
          color: colors.textPrimary,
        ),
        subtitleTextStyle: AppTextStyles.bodySmall.copyWith(
          color: colors.textSecondary,
        ),
        iconColor: colors.textSecondary,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.cardRadius),
      ),

      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  static OutlineInputBorder _inputBorder(Color color, {bool focused = false}) {
    return OutlineInputBorder(
      borderRadius: AppRadius.inputRadius,
      borderSide: BorderSide(
        color: color,
        width: focused ? AppSize.borderWidthFocused : AppSize.borderWidth,
      ),
    );
  }
}

/// Sizes that belong to the theme rather than to a component.
abstract final class AppScaleSizes {
  static double get navigationBarHeight => AppSize.appBarHeight * 1.25;
}
