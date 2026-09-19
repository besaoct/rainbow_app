import 'package:flutter/widgets.dart';

import 'package:rainbow_app/core/theme/app_scale.dart';

/// Spacing scale. Use these instead of literal `SizedBox(height: 16)` so that
/// vertical rhythm stays consistent and scales with the device.
abstract final class AppSpacing {
  static double get xxs => AppScale.of(2);
  static double get xs => AppScale.of(4);
  static double get sm => AppScale.of(8);
  static double get md => AppScale.of(12);
  static double get lg => AppScale.of(16);
  static double get xl => AppScale.of(20);
  static double get xxl => AppScale.of(24);
  static double get xxxl => AppScale.of(32);
  static double get huge => AppScale.of(48);

  /// Horizontal padding applied to the content of every screen.
  static double get screenH => AppScale.of(20);

  /// Vertical padding at the top and bottom of scrollable screen content.
  static double get screenV => AppScale.of(16);

  static EdgeInsets get screen =>
      EdgeInsets.symmetric(horizontal: screenH, vertical: screenV);
  static EdgeInsets get screenHorizontal =>
      EdgeInsets.symmetric(horizontal: screenH);

  /// Padding for a scrollable list that fills the screen body.
  ///
  /// The trailing gap clears the bottom action bar and the home indicator so
  /// the last row is always reachable.
  static EdgeInsets get listContent =>
      EdgeInsets.fromLTRB(screenH, screenV, screenH, xxxl);

  /// Padding for a list that sits under a pinned header — a search field, a
  /// filter bar — which has already supplied the top gap.
  static EdgeInsets get listContentUnderHeader =>
      EdgeInsets.fromLTRB(screenH, 0, screenH, xxxl);

  /// Padding for that pinned header block.
  static EdgeInsets get screenHeader =>
      EdgeInsets.fromLTRB(screenH, screenV, screenH, md);
  static EdgeInsets get card => EdgeInsets.all(AppScale.of(16));
  static EdgeInsets get cardCompact => EdgeInsets.all(AppScale.of(12));
  static EdgeInsets get listItem => EdgeInsets.symmetric(
    horizontal: AppScale.of(16),
    vertical: AppScale.of(12),
  );
}

/// Corner radii. Kept small in number so the UI reads as one system.
abstract final class AppRadius {
  static double get xs => AppScale.of(6);
  static double get sm => AppScale.of(10);
  static double get md => AppScale.of(14);
  static double get lg => AppScale.of(20);
  static double get xl => AppScale.of(28);
  static double get pill => AppScale.of(999);

  static BorderRadius get cardRadius => BorderRadius.circular(md);
  static BorderRadius get buttonRadius => BorderRadius.circular(sm);
  static BorderRadius get inputRadius => BorderRadius.circular(sm);
  static BorderRadius get sheetRadius =>
      BorderRadius.vertical(top: Radius.circular(lg));
  static BorderRadius get chipRadius => BorderRadius.circular(pill);
}

/// Icon sizes, matching the 24pt grid the SVG set is drawn on.
abstract final class AppIconSize {
  static double get xs => AppScale.of(14);
  static double get sm => AppScale.of(18);
  static double get md => AppScale.of(22);
  static double get lg => AppScale.of(28);
  static double get xl => AppScale.of(40);
  static double get display => AppScale.of(64);
}

/// Fixed component dimensions.
abstract final class AppSize {
  static double get buttonHeight => AppScale.of(52);
  static double get buttonHeightCompact => AppScale.of(40);
  static double get inputHeight => AppScale.of(52);
  static double get appBarHeight => AppScale.of(56);
  static double get chipHeight => AppScale.of(26);
  static double get avatar => AppScale.of(44);
  static double get logoSm => AppScale.of(32);
  static double get logoMd => AppScale.of(48);
  static double get logoLg => AppScale.of(96);
  static double get dividerThickness => 1;
  static double get borderWidth => 1;
  static double get borderWidthFocused => AppScale.of(1.6);
  static double get progressStroke => AppScale.of(2.4);

  /// Maximum width of a single content column. Beyond this, content is
  /// centred rather than stretched across a tablet or desktop window.
  static const double maxContentWidth = 560;

  /// Maximum width of a two-column content area on large screens.
  static const double maxWideContentWidth = 1100;

  /// Minimum size of any tappable target (WCAG 2.5.5 / Material).
  static const double minTapTarget = 48;
}

/// Layout breakpoints, in logical pixels of the shortest side.
abstract final class AppBreakpoints {
  static const double mobile = 600;
  static const double tablet = 905;
  static const double desktop = 1240;
}
