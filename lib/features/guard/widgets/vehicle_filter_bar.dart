import 'package:flutter/material.dart';

import 'package:rainbow_app/core/enums/gate_entry_status.dart';
import 'package:rainbow_app/core/extensions/build_context_x.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/core/theme/app_typography.dart';

/// The status filter above the vehicle list.
///
/// A horizontal scroller rather than a wrap: the row keeps its height no
/// matter how long the translated labels are, so the list below never shifts.
class VehicleFilterBar extends StatelessWidget {
  const VehicleFilterBar({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  /// `null` means "all statuses".
  final GateEntryStatus? selected;

  final ValueChanged<GateEntryStatus?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.minTapTarget,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: AppSpacing.screenHorizontal,
        children: <Widget>[
          _Chip(
            label: context.l10n.filterAll,
            isSelected: selected == null,
            onTap: () => onChanged(null),
          ),
          for (final GateEntryStatus status in GateEntryStatus.filterable)
            _Chip(
              label: status.label(context.l10n),
              color: status.color(context.colors),
              isSelected: selected == status,
              onTap: () => onChanged(status),
            ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final Color accent = color ?? context.colorScheme.primary;
    return Padding(
      padding: EdgeInsets.only(right: AppSpacing.sm),
      child: Center(
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadius.chipRadius,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? accent.withValues(alpha: 0.14)
                    : context.colors.surfaceRaised,
                borderRadius: AppRadius.chipRadius,
                border: Border.all(
                  color: isSelected ? accent : context.colors.border,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (color != null) ...<Widget>[
                    Container(
                      height: AppSpacing.sm,
                      width: AppSpacing.sm,
                      decoration: BoxDecoration(
                        color: accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: AppSpacing.xs),
                  ],
                  Text(
                    label,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: isSelected ? accent : context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
