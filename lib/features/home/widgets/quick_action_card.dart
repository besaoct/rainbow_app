import 'package:flutter/material.dart';

import 'package:rainbow_app/core/extensions/build_context_x.dart';
import 'package:rainbow_app/core/helpers/formatters.dart';
import 'package:rainbow_app/core/theme/app_colors.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/core/theme/app_scale.dart';
import 'package:rainbow_app/core/theme/app_typography.dart';
import 'package:rainbow_app/core/widgets/app_card.dart';
import 'package:rainbow_app/core/widgets/app_icon.dart';

/// A dashboard tile that opens one workflow.
///
/// The card is two rows — icon, then label and count. The count is a round
/// badge inline at the end of the label row: it sits inside the card's
/// bounds, so the grid keeps an even gap in both directions and no tile
/// overhangs its neighbour.
///
/// There is no chevron. On a grid tile it duplicates what the ripple and the
/// layout already say, and on the narrowest phone the ~15pt it costs is the
/// difference between a label that fits and one that is ellipsised.
///
/// The label is a single line: a wrapped label makes a row of tiles look
/// ragged, and the short labels in `AppLocalizations` are written to fit.
/// Ellipsis is the safety net for a translation or a text scale that still
/// overflows, and the full label always reaches screen readers through the
/// card's semantics.
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

  /// Diameter of the count badge.
  static double get badgeSize => AppScale.of(24);

  @override
  Widget build(BuildContext context) {
    final Color tint = accent ?? context.colorScheme.primary;
    final int? waiting = count;

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
          _IconChip(icon: icon, tint: tint),
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
              // An empty queue carries no badge at all: a circle reading "0"
              // draws the eye to the one tile that needs no attention.
              if (waiting != null && waiting > 0) ...<Widget>[
                SizedBox(width: AppSpacing.xs),
                _CountBadge(value: waiting, tint: tint),
              ],
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

/// How many items are waiting, as a round badge on the card's corner.
class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.value, required this.tint});

  final int value;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    final double diameter = QuickActionCard.badgeSize;
    final String display = Formatters.countBadge(value);

    // One and two digits are pinned to a square so the badge is a true
    // circle. Only the capped "99+" is allowed to widen into a stadium,
    // which is better than shrinking the number until it cannot be read.
    final bool isRound = display.length <= 2;

    final Widget number = Text(
      display,
      textAlign: TextAlign.center,
      maxLines: 1,
      style: AppTextStyles.labelSmall.copyWith(
        color: context.colors.onAccentFill,
        fontWeight: AppFontWeight.bold,
        height: 1,
      ),
    );

    return Container(
      alignment: Alignment.center,
      constraints: BoxConstraints(minWidth: diameter, minHeight: diameter),
      padding: isRound
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      decoration: BoxDecoration(
        // Darkened where the accent is too light to carry white text, so
        // every badge looks the same regardless of its tile's colour.
        color: context.colors.accentFill(tint),
        borderRadius: BorderRadius.circular(diameter),
      ),
      child: isRound
          ? SizedBox(
              width: diameter,
              height: diameter,
              // Scales a wide glyph set down rather than letting it push the
              // circle out of shape.
              child: Center(
                child: FittedBox(fit: BoxFit.scaleDown, child: number),
              ),
            )
          : number,
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
