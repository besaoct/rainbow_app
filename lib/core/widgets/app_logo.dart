import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:rainbow_app/core/constants/asset_constants.dart';
import 'package:rainbow_app/core/extensions/build_context_x.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/core/theme/app_typography.dart';

/// How much of the brand to show.
enum AppLogoVariant {
  /// The rainbow mark on its own.
  mark,

  /// Mark plus the wordmark and tagline.
  lockup,
}

/// The Rainbow brand lockup.
///
/// The wordmark is rendered as text rather than as a path so it picks up the
/// app's own type scale and, critically, so the product name comes from the
/// localisation system like every other visible string.
class AppLogo extends StatelessWidget {
  const AppLogo({
    this.variant = AppLogoVariant.lockup,
    this.size,
    this.onDarkSurface,
    this.monochromeColor,
    super.key,
  });

  final AppLogoVariant variant;

  /// Height of the mark. Defaults to [AppSize.logoMd].
  final double? size;

  /// Forces the light or dark artwork. Defaults to the ambient brightness.
  final bool? onDarkSurface;

  /// When set, the mark is drawn as a single-colour silhouette in this
  /// colour — used on the brand-coloured splash and on photographic panels.
  final Color? monochromeColor;

  @override
  Widget build(BuildContext context) {
    final double markSize = size ?? AppSize.logoMd;
    final bool dark = onDarkSurface ?? context.isDarkMode;
    final Widget mark = SvgPicture.asset(
      monochromeColor != null
          ? AppAssets.logoMonoWhite
          : (dark ? AppAssets.logoMarkDark : AppAssets.logoMark),
      height: markSize,
      colorFilter: monochromeColor == null
          ? null
          : ColorFilter.mode(monochromeColor!, BlendMode.srcIn),
    );

    if (variant == AppLogoVariant.mark) {
      return Semantics(
        label: context.l10n.a11yAppLogo,
        image: true,
        child: mark,
      );
    }

    final Color wordColor = monochromeColor ?? context.colors.textPrimary;
    return Semantics(
      label: context.l10n.a11yAppLogo,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ExcludeSemantics(child: mark),
          SizedBox(height: AppSpacing.sm),
          Text(
            context.l10n.appName,
            textAlign: TextAlign.center,
            style: AppTextStyles.headingLarge.copyWith(
              color: wordColor,
              letterSpacing: -0.4,
            ),
          ),
          if (variant == AppLogoVariant.lockup) ...<Widget>[
            SizedBox(height: AppSpacing.xxs),
            Text(
              context.l10n.appTagline,
              textAlign: TextAlign.center,
              style: AppTextStyles.labelMedium.copyWith(
                color:
                    monochromeColor?.withValues(alpha: 0.75) ??
                    context.colors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
