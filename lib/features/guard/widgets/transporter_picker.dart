import 'package:flutter/material.dart';

import 'package:rainbow_app/core/extensions/build_context_x.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/core/theme/app_typography.dart';
import 'package:rainbow_app/core/widgets/app_choice_chip.dart';
import 'package:rainbow_app/features/guard/models/transporter.dart';

/// Quick-pick chips for the transporters the ERP already knows.
///
/// The text field above stays the source of truth, so the two work together:
/// tapping a chip fills the field, tapping the selected chip clears it again,
/// and typing anything else simply deselects every chip. That covers picking
/// a known transporter, correcting one, and entering a company that is not on
/// the list yet — without a second control for "other".
///
/// The chips scroll horizontally on one line. A `Wrap` would push the rest of
/// the form down by several rows once the list grows past a handful.
class TransporterPicker extends StatelessWidget {
  const TransporterPicker({
    required this.transporters,
    required this.selectedName,
    required this.onSelected,
    this.enabled = true,
    super.key,
  });

  final List<Transporter> transporters;

  /// The name currently in the field, or empty.
  final String selectedName;

  /// Receives the chosen name, or `null` when the selected chip is tapped
  /// again to clear it.
  final ValueChanged<String?> onSelected;

  final bool enabled;

  /// Whether [name] is what the field currently holds, ignoring case and
  /// surrounding spaces so a hand-typed name still matches its chip.
  bool _isSelected(String name) =>
      name.toLowerCase() == selectedName.trim().toLowerCase();

  @override
  Widget build(BuildContext context) {
    if (transporters.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: AppSpacing.sm),
        Text(
          context.l10n.transporterSuggestionsLabel,
          style: AppTextStyles.caption.copyWith(
            color: context.colors.textTertiary,
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        AppChipRow(
          children: <Widget>[
            for (final Transporter transporter in transporters)
              AppChoiceChip(
                label: transporter.name,
                isSelected: _isSelected(transporter.name),
                onTap: enabled
                    ? () => onSelected(
                        _isSelected(transporter.name) ? null : transporter.name,
                      )
                    : () {},
              ),
          ],
        ),
      ],
    );
  }
}
