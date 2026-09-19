import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:rainbow_app/core/extensions/build_context_x.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';

/// Renders an SVG from the bundled icon set at a design-system size.
///
/// The set is drawn on a 24pt grid with a single stroke weight, so icons stay
/// optically consistent at every size. Colour is applied as a filter rather
/// than baked into the file, which keeps one asset per glyph.
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.asset, {
    this.size,
    this.color,
    this.semanticLabel,
    super.key,
  });

  /// A path from `AppAssets`.
  final String asset;

  /// Defaults to [AppIconSize.md].
  final double? size;

  /// Defaults to the current text colour.
  final Color? color;

  /// Announced by screen readers. Leave null for decorative icons that sit
  /// beside a label.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final double resolved = size ?? AppIconSize.md;
    final Color tint = color ?? context.colors.textPrimary;
    return SvgPicture.asset(
      asset,
      width: resolved,
      height: resolved,
      colorFilter: ColorFilter.mode(tint, BlendMode.srcIn),
      semanticsLabel: semanticLabel,
      excludeFromSemantics: semanticLabel == null,
    );
  }
}
