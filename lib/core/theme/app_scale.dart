import 'dart:math' as math;
import 'dart:ui' show Size;

import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Central responsive scale factor for the whole design system.
///
/// Every spacing, radius, icon size and font size in `AppSpacing`, `AppRadius`,
/// `AppIconSize`, `AppSize` and `AppTypography` is a design-space value
/// multiplied by [factor]. That keeps a single knob for "how big is the UI on
/// this device" instead of scattering `MediaQuery` maths through widgets.
///
/// The factor is derived from the smaller of the width and height scale so a
/// landscape phone does not inflate type, and it is clamped: an unclamped
/// linear scale makes a 13" tablet look like a zoomed-in phone and squeezes
/// small phones below legibility.
abstract final class AppScale {
  /// The reference device the design tokens were authored against.
  static const Size designSize = Size(390, 844);

  /// Lower bound, protecting legibility on small phones (320pt wide).
  static const double minFactor = 0.86;

  /// Upper bound, protecting proportion on tablets and large screens.
  static const double maxFactor = 1.28;

  /// The clamped uniform scale factor. Falls back to `1.0` before
  /// `ScreenUtilInit` has measured the window.
  static double get factor {
    final ScreenUtil util = ScreenUtil();
    final double raw = math.min(util.scaleWidth, util.scaleHeight);
    if (!raw.isFinite || raw <= 0) return 1;
    return raw.clamp(minFactor, maxFactor);
  }

  /// Scales a design-space value to the current device.
  static double of(double designValue) => designValue * factor;
}
