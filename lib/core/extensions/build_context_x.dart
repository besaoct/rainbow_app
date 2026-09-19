import 'package:flutter/material.dart';

import 'package:rainbow_app/core/theme/app_colors.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/l10n/generated/app_localizations.dart';

/// Screen-size class, used to choose between layouts rather than to scale
/// them. Scaling is handled globally by `AppScale`.
enum ScreenClass { compact, medium, expanded }

/// Shorthands for the four things widgets reach for constantly.
extension BuildContextX on BuildContext {
  /// Localised strings. Every user-facing string comes from here.
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// The active locale's language code, for `intl` formatters.
  String get localeCode => Localizations.localeOf(this).toLanguageTag();

  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Semantic colours beyond Material's [ColorScheme].
  AppColors get colors =>
      Theme.of(this).extension<AppColors>() ??
      (Theme.of(this).brightness == Brightness.dark
          ? AppColors.dark
          : AppColors.light);

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  Size get screenSize => MediaQuery.sizeOf(this);

  ScreenClass get screenClass {
    final double width = MediaQuery.sizeOf(this).width;
    if (width >= AppBreakpoints.tablet) return ScreenClass.expanded;
    if (width >= AppBreakpoints.mobile) return ScreenClass.medium;
    return ScreenClass.compact;
  }

  /// Dismisses the keyboard without moving focus to another field.
  void dismissKeyboard() => FocusScope.of(this).unfocus();
}
