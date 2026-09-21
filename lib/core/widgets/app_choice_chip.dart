import 'package:flutter/material.dart';

import 'package:rainbow_app/core/extensions/build_context_x.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/core/theme/app_durations.dart';
import 'package:rainbow_app/core/theme/app_typography.dart';

/// A selectable chip.
///
/// Used wherever a short list of options is picked inline — the vehicle
/// status filter, the transporter suggestions. Selection is shown with a
/// tinted fill *and* a coloured border, never colour alone, so the state
/// survives a colour-blind reading and a greyscale screenshot.
class AppChoiceChip extends StatelessWidget {
  const AppChoiceChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.accent,
    this.dotColor,
    super.key,
  });

  /// Localised label.
  final String label;

  final bool isSelected;

  /// Tapping a selected chip is expected to clear the selection, so callers
  /// get a plain callback rather than a value.
  final VoidCallback onTap;

  /// Colour of the selected treatment. Defaults to the primary colour.
  final Color? accent;

  /// Optional leading dot, for chips that stand for a status colour.
  final Color? dotColor;

  @override
  Widget build(BuildContext context) {
    final Color tint = accent ?? context.colorScheme.primary;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.chipRadius,
        child: AnimatedContainer(
          duration: AppDurations.instant,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? tint.withValues(alpha: 0.14)
                : context.colors.surfaceRaised,
            borderRadius: AppRadius.chipRadius,
            border: Border.all(
              color: isSelected ? tint : context.colors.border,
              width: isSelected
                  ? AppSize.borderWidthFocused
                  : AppSize.borderWidth,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (dotColor != null) ...<Widget>[
                Container(
                  height: AppSpacing.sm,
                  width: AppSpacing.sm,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: AppSpacing.xs),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: isSelected ? tint : context.colors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A single-line, horizontally scrolling row of chips.
///
/// Keeps a long option list to one row instead of letting a `Wrap` push the
/// rest of a form down the screen, and gives every row the same height
/// whatever the labels are.
class AppChipRow extends StatelessWidget {
  const AppChipRow({required this.children, this.padding, super.key});

  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.minTapTarget,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: padding ?? EdgeInsets.zero,
        itemCount: children.length,
        separatorBuilder: (_, _) => SizedBox(width: AppSpacing.sm),
        itemBuilder: (BuildContext context, int index) =>
            Center(child: children[index]),
      ),
    );
  }
}
