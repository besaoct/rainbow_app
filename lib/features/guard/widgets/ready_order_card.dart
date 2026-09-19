import 'package:flutter/material.dart';

import 'package:rainbow_app/core/constants/asset_constants.dart';
import 'package:rainbow_app/core/extensions/build_context_x.dart';
import 'package:rainbow_app/core/helpers/formatters.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/core/theme/app_typography.dart';
import 'package:rainbow_app/core/widgets/app_card.dart';
import 'package:rainbow_app/core/widgets/app_icon.dart';
import 'package:rainbow_app/features/guard/models/ready_order.dart';

/// A sales order awaiting dispatch.
class ReadyOrderCard extends StatelessWidget {
  const ReadyOrderCard({
    required this.order,
    this.onTap,
    this.isSelected = false,
    super.key,
  });

  final ReadyOrder order;
  final VoidCallback? onTap;

  /// Draws the selected treatment when used inside the order picker.
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      borderColor: isSelected ? context.colorScheme.primary : null,
      color: isSelected ? context.colorScheme.primaryContainer : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  order.orderNo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.mono.copyWith(
                    color: context.colors.textPrimary,
                    fontWeight: AppFontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              if (isSelected)
                AppIcon(
                  AppAssets.iconCheckCircle,
                  size: AppIconSize.sm,
                  color: context.colorScheme.primary,
                ),
            ],
          ),
          SizedBox(height: AppSpacing.xxs),
          Text(
            order.customerName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyMedium.copyWith(
              color: context.colors.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: <Widget>[
              _Pill(
                icon: AppAssets.iconBox,
                text: context.l10n.piecesShort(order.pendingPcs),
              ),
              _Pill(
                icon: AppAssets.iconOrders,
                text: context.l10n.lineCount(order.totalLines),
              ),
              if (order.orderDate != null)
                _Pill(
                  icon: AppAssets.iconCalendar,
                  text: Formatters.date(order.orderDate, context.localeCode),
                ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              AppIcon(
                AppAssets.iconLocation,
                size: AppIconSize.xs,
                color: context.colors.textTertiary,
              ),
              SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  order.locationName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.text});

  final String icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: context.colors.surfaceSunken,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AppIcon(
            icon,
            size: AppIconSize.xs,
            color: context.colors.textTertiary,
          ),
          SizedBox(width: AppSpacing.xs),
          Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
