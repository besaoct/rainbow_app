import 'package:flutter/material.dart';

import 'package:rainbow_app/core/constants/asset_constants.dart';
import 'package:rainbow_app/core/extensions/build_context_x.dart';
import 'package:rainbow_app/core/helpers/formatters.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/core/theme/app_typography.dart';
import 'package:rainbow_app/core/widgets/app_button.dart';
import 'package:rainbow_app/core/widgets/app_card.dart';
import 'package:rainbow_app/core/widgets/app_icon.dart';
import 'package:rainbow_app/core/widgets/app_status_badge.dart';
import 'package:rainbow_app/features/store/models/entered_vehicle.dart';

/// A vehicle waiting inside the gate, with the way into its loading screen.
class EnteredVehicleCard extends StatelessWidget {
  const EnteredVehicleCard({
    required this.vehicle,
    required this.onStartLoading,
    super.key,
  });

  final EnteredVehicle vehicle;
  final VoidCallback onStartLoading;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  Formatters.vehicleNumber(vehicle.vehicleNo),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.monoLarge.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              AppStatusBadge(status: vehicle.status, compact: true),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          _Row(
            icon: AppAssets.iconHash,
            label: context.l10n.gatePassLabel,
            value: vehicle.gatePassNo,
          ),
          if (vehicle.orderNo.isNotEmpty)
            _Row(
              icon: AppAssets.iconDocument,
              label: context.l10n.orderNumberLabel,
              value: vehicle.orderNo,
            ),
          if (vehicle.customerName.isNotEmpty)
            _Row(
              icon: AppAssets.iconUser,
              label: context.l10n.orderCustomerLabel,
              value: vehicle.customerName,
            ),
          if (vehicle.enteredAt != null)
            _Row(
              icon: AppAssets.iconClock,
              label: context.l10n.enteredAtLabel,
              value: Formatters.dateTime(vehicle.enteredAt, context.localeCode),
            ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: context.colors.infoContainer,
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                  ),
                  child: Text(
                    context.l10n.lineCount(vehicle.pendingLinesCount),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: context.colors.onInfoContainer,
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                flex: 2,
                child: AppButton(
                  label: context.l10n.storeStartLoading,
                  onPressed: onStartLoading,
                  size: AppButtonSize.compact,
                  icon: AppAssets.iconBox,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.icon, required this.label, required this.value});

  final String icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.xxs),
      child: Row(
        children: <Widget>[
          AppIcon(
            icon,
            size: AppIconSize.xs,
            color: context.colors.textTertiary,
            semanticLabel: label,
          ),
          SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySmall.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
