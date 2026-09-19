import 'package:flutter/material.dart';

import 'package:rainbow_app/core/constants/asset_constants.dart';
import 'package:rainbow_app/core/extensions/build_context_x.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/core/theme/app_typography.dart';
import 'package:rainbow_app/core/widgets/app_icon.dart';

/// One choice in a settings group.
class SettingsOption<T> {
  const SettingsOption({
    required this.value,
    required this.label,
    required this.icon,
  });

  final T value;

  /// Localised label.
  final String label;

  /// Path from `AppAssets`.
  final String icon;
}

/// A single-select list of options, rendered as one card.
///
/// Rows grow with their content, so a long language name in a large text size
/// wraps instead of clipping.
class SettingsOptionGroup<T> extends StatelessWidget {
  const SettingsOptionGroup({
    required this.options,
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final List<SettingsOption<T>> options;
  final T selected;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surfaceRaised,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        children: <Widget>[
          for (int i = 0; i < options.length; i++) ...<Widget>[
            if (i > 0)
              Divider(
                height: 1,
                indent: AppSpacing.huge,
                color: context.colors.border,
              ),
            _OptionRow<T>(
              option: options[i],
              isSelected: options[i].value == selected,
              onTap: () => onChanged(options[i].value),
              isFirst: i == 0,
              isLast: i == options.length - 1,
            ),
          ],
        ],
      ),
    );
  }
}

class _OptionRow<T> extends StatelessWidget {
  const _OptionRow({
    required this.option,
    required this.isSelected,
    required this.onTap,
    required this.isFirst,
    required this.isLast,
  });

  final SettingsOption<T> option;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final Radius radius = Radius.circular(AppRadius.md);
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.vertical(
          top: isFirst ? radius : Radius.zero,
          bottom: isLast ? radius : Radius.zero,
        ),
        child: Semantics(
          selected: isSelected,
          button: true,
          label: option.label,
          excludeSemantics: true,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: <Widget>[
                AppIcon(
                  option.icon,
                  size: AppIconSize.sm,
                  color: isSelected
                      ? context.colorScheme.primary
                      : context.colors.textTertiary,
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    option.label,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: context.colors.textPrimary,
                      fontWeight: isSelected
                          ? AppFontWeight.semiBold
                          : AppFontWeight.regular,
                    ),
                  ),
                ),
                if (isSelected)
                  AppIcon(
                    AppAssets.iconCheck,
                    size: AppIconSize.sm,
                    color: context.colorScheme.primary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
