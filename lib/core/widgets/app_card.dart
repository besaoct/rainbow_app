import 'package:flutter/material.dart';

import 'package:rainbow_app/core/extensions/build_context_x.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/core/theme/app_shadows.dart';
import 'package:rainbow_app/core/theme/app_typography.dart';

/// A bordered surface, optionally tappable.
///
/// Elevation is a border plus a soft shadow rather than a Material elevation
/// overlay, so cards read identically in light and dark.
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.onTap,
    this.padding,
    this.color,
    this.borderColor,
    this.elevated = false,
    this.semanticLabel,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color? borderColor;

  /// Adds the resting shadow. Off by default so dense lists stay flat.
  final bool elevated;

  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = AppRadius.cardRadius;
    final Widget content = Padding(
      padding: padding ?? AppSpacing.card,
      child: child,
    );

    final Widget card = DecoratedBox(
      decoration: BoxDecoration(
        color: color ?? context.colors.surfaceRaised,
        borderRadius: radius,
        border: Border.all(
          color: borderColor ?? context.colors.border,
          width: AppSize.borderWidth,
        ),
        boxShadow: elevated
            ? AppShadows.resting(context.theme.brightness)
            : null,
      ),
      child: onTap == null
          ? content
          : Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: onTap,
                borderRadius: radius,
                child: content,
              ),
            ),
    );

    if (semanticLabel == null) return card;
    return Semantics(
      label: semanticLabel,
      button: onTap != null,
      container: true,
      child: card,
    );
  }
}

/// A heading above a group of content, with an optional trailing action.
class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    required this.title,
    this.actionLabel,
    this.onAction,
    this.padding,
    super.key,
  });

  /// Localised section title.
  final String title;

  /// Localised label for the trailing text button.
  final String? actionLabel;

  final VoidCallback? onAction;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.headingSmall.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
          ),
          if (actionLabel != null && onAction != null)
            TextButton(
              onPressed: onAction,
              child: Text(
                actionLabel!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }
}

/// A label/value pair inside a detail card.
///
/// The value is allowed to wrap to two lines and then ellipsise, which is
/// what keeps long customer names from overflowing on a small phone.
class AppDetailRow extends StatelessWidget {
  const AppDetailRow({
    required this.label,
    required this.value,
    this.valueStyle,
    this.icon,
    this.dense = false,
    super.key,
  });

  /// Localised field name.
  final String label;

  /// Already-formatted value. Empty values render the localised placeholder.
  final String value;

  final TextStyle? valueStyle;
  final Widget? icon;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final String display = value.isEmpty
        ? context.l10n.labelNotAvailable
        : value;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: dense ? AppSpacing.xxs : AppSpacing.xs,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            flex: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (icon != null) ...<Widget>[
                  icon!,
                  SizedBox(width: AppSpacing.xs),
                ],
                Flexible(
                  child: Text(
                    display,
                    textAlign: TextAlign.end,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        valueStyle ??
                        AppTextStyles.bodySmall.copyWith(
                          color: context.colors.textPrimary,
                          fontWeight: AppFontWeight.medium,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
