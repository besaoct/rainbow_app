import 'package:flutter/material.dart';

import 'package:rainbow_app/core/enums/gate_entry_status.dart';
import 'package:rainbow_app/core/extensions/build_context_x.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/core/widgets/app_choice_chip.dart';

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
    return AppChipRow(
      padding: AppSpacing.screenHorizontal,
      children: <Widget>[
        AppChoiceChip(
          label: context.l10n.filterAll,
          isSelected: selected == null,
          onTap: () => onChanged(null),
        ),
        for (final GateEntryStatus status in GateEntryStatus.filterable)
          AppChoiceChip(
            label: status.label(context.l10n),
            accent: status.color(context.colors),
            dotColor: status.color(context.colors),
            isSelected: selected == status,
            onTap: () => onChanged(status),
          ),
      ],
    );
  }
}
