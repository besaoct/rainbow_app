import 'package:flutter/material.dart';

import 'package:rainbow_app/core/extensions/build_context_x.dart';
import 'package:rainbow_app/core/helpers/formatters.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/core/theme/app_typography.dart';
import 'package:rainbow_app/core/widgets/app_card.dart';
import 'package:rainbow_app/features/guard/models/vehicle_inspection.dart';

/// One loaded line, as the guard checks it against the physical load.
class InspectionItemTile extends StatelessWidget {
  const InspectionItemTile({required this.item, super.key});

  final InspectionItem item;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: AppSpacing.cardCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            item.productName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyMedium.copyWith(
              color: context.colors.textPrimary,
              fontWeight: AppFontWeight.medium,
            ),
          ),
          if (item.sku.isNotEmpty) ...<Widget>[
            SizedBox(height: AppSpacing.xxs),
            Text(
              item.sku,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: context.colors.textTertiary,
              ),
            ),
          ],
          SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.xs,
            children: <Widget>[
              _Metric(
                label: context.l10n.quantityPiecesLabel,
                value: Formatters.integer(item.qtyPcs),
              ),
              _Metric(
                label: context.l10n.quantityBoxesLabel,
                value: Formatters.quantity(item.qtyBox),
              ),
              _Metric(
                label: context.l10n.lineTotalLabel,
                value: Formatters.currency(item.lineTotal),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: context.colors.textTertiary,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.mono.copyWith(color: context.colors.textPrimary),
        ),
      ],
    );
  }
}
