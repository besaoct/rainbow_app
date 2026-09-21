import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:rainbow_app/core/extensions/build_context_x.dart';
import 'package:rainbow_app/core/helpers/formatters.dart';
import 'package:rainbow_app/core/helpers/validators.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/core/theme/app_typography.dart';
import 'package:rainbow_app/core/widgets/app_card.dart';
import 'package:rainbow_app/core/widgets/app_text_field.dart';
import 'package:rainbow_app/features/store/models/order_item.dart';

/// One order line on the loading screen.
///
/// The store manager types pieces; boxes are derived and shown live, because
/// the API wants both and a hand-computed box count is the easiest thing to
/// get wrong on a loading bay.
class LoadLineTile extends StatelessWidget {
  const LoadLineTile({
    required this.item,
    required this.controller,
    required this.onChanged,
    this.enabled = true,
    this.errorText,
    super.key,
  });

  final OrderItem item;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool enabled;
  final String? errorText;

  void _fillMax() {
    controller.text = '${item.maxLoadablePcs}';
    onChanged(controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final int entered = int.tryParse(controller.text.trim()) ?? 0;
    final bool outOfStock = !item.isLoadable;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            item.productName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyLarge.copyWith(
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
          SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.sm,
            children: <Widget>[
              _Metric(
                label: context.l10n.quantityOrderedLabel,
                value: Formatters.integer(item.qtyOrderedPcs),
              ),
              _Metric(
                label: context.l10n.quantityDispatchedLabel,
                value: Formatters.integer(item.qtyDispatchedPcs),
              ),
              _Metric(
                label: context.l10n.quantityPendingLabel,
                value: Formatters.integer(item.qtyPendingPcs),
                emphasised: true,
              ),
              _Metric(
                label: context.l10n.currentStockLabel,
                value: Formatters.integer(item.currentStockPcs),
                color: outOfStock ? context.colorScheme.error : null,
              ),
              _Metric(
                label: context.l10n.piecesPerBoxLabel,
                value: Formatters.integer(item.piecesPerBox),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          AppTextField(
            label: context.l10n.quantityToLoadLabel,
            hint: '0',
            controller: controller,
            enabled: enabled && !outOfStock,
            errorText: errorText,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(7),
            ],
            onChanged: onChanged,
            // On the label row rather than beside the field: a button
            // sharing the row could not fit its own label at any sensible
            // width, and sat at a different height from the input.
            labelAction: enabled && !outOfStock
                ? _FillMaxAction(
                    label: context.l10n.storeLoadFullPending,
                    onTap: _fillMax,
                  )
                : null,
            helper: entered > 0
                ? context.l10n.boxesShort(
                    double.parse(item.boxesFor(entered).toStringAsFixed(2)),
                  )
                : null,
            validator: (String? v) => Validators.loadQuantity(
              v,
              pendingPcs: item.qtyPendingPcs,
              stockPcs: item.currentStockPcs,
              l10n: context.l10n,
            ),
          ),
        ],
      ),
    );
  }
}

/// The "fill this line with everything still pending" shortcut.
///
/// Compact by design: it duplicates something the user can always type, so
/// it sits on the label row without pushing the form down. The field itself
/// stays the primary, full-size target.
class _FillMaxAction extends StatelessWidget {
  const _FillMaxAction({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        textStyle: AppTextStyles.labelMedium,
      ),
      child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    this.emphasised = false,
    this.color,
  });

  final String label;
  final String value;
  final bool emphasised;
  final Color? color;

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
          style: AppTextStyles.mono.copyWith(
            color:
                color ??
                (emphasised
                    ? context.colorScheme.primary
                    : context.colors.textPrimary),
            fontWeight: emphasised ? AppFontWeight.bold : AppFontWeight.medium,
          ),
        ),
      ],
    );
  }
}
