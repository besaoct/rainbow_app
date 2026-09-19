import 'package:flutter/material.dart';

import 'package:rainbow_app/core/constants/asset_constants.dart';
import 'package:rainbow_app/core/extensions/build_context_x.dart';
import 'package:rainbow_app/core/helpers/formatters.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/core/theme/app_typography.dart';
import 'package:rainbow_app/core/widgets/app_card.dart';
import 'package:rainbow_app/core/widgets/app_icon.dart';

/// A dashboard tile that opens one workflow.
///
/// The layout is two rows — icon and count, then label and chevron — so the
/// tile can be read in one glance: what it is, how much is waiting, where it
/// goes. The label is a single line: a wrapped label makes a row of tiles
/// look ragged, and the short labels in `AppLocalizations` are written to
/// fit. Ellipsis is the safety net for a translation or a text scale that
/// still overflows, and the full label always reaches screen readers through
/// the card's semantics.
class QuickActionCard extends StatelessWidget {
  const QuickActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
    this.accent,
    this.count,
    super.key,
  });

  /// Path from `AppAssets`.
  final String icon;

  /// Short localised label. One line.
  final String label;

  final VoidCallback onTap;

  /// Tints the icon chip and the count. Defaults to the primary colour.
  final Color? accent;

  /// How many items are waiting behind this action. `null` hides the count —
  /// used for tiles that create something rather than open a queue.
  final int? count;

  @override
  Widget build(BuildContext context) {
    final Color tint = accent ?? context.colorScheme.primary;

    return AppCard(
      onTap: onTap,
      padding: AppSpacing.cardCompact,
      // Carries the untruncated label, so the tile reads correctly even when
      // the visible text is ellipsised.
      semanticLabel: label,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              _IconChip(icon: icon, tint: tint),
              const Spacer(),
              if (count != null) _Count(value: count!, tint: tint),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.xs),
              AppIcon(
                AppAssets.iconChevronRight,
                size: AppIconSize.xs,
                color: context.colors.textTertiary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconChip extends StatelessWidget {
  const _IconChip({required this.icon, required this.tint});

  final String icon;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: AppIcon(icon, size: AppIconSize.md, color: tint),
    );
  }
}

/// How many items are waiting, as a tinted pill.
class _Count extends StatelessWidget {
  const _Count({required this.value, required this.tint});

  final int value;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    // A zero queue is stated plainly rather than highlighted: nothing waiting
    // is not something to draw the eye to.
    final bool isEmpty = value == 0;
    final Color foreground = isEmpty ? context.colors.textTertiary : tint;

    return Container(
      constraints: BoxConstraints(minWidth: AppSize.chipHeight),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: isEmpty
            ? context.colors.surfaceSunken
            : tint.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        Formatters.integer(value),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.mono.copyWith(
          color: foreground,
          fontWeight: AppFontWeight.bold,
        ),
      ),
    );
  }
}

/// A compact number with a caption, for the summary row.
class StatTile extends StatelessWidget {
  const StatTile({
    required this.value,
    required this.label,
    required this.color,
    super.key,
  });

  /// Already-formatted number.
  final String value;

  /// Localised caption.
  final String label;

  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: AppSpacing.cardCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                height: AppSpacing.sm,
                width: AppSpacing.sm,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.monoLarge.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xxs),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
