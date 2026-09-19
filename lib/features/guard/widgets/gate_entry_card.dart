import 'package:flutter/material.dart';

import 'package:rainbow_app/core/constants/asset_constants.dart';
import 'package:rainbow_app/core/enums/gate_entry_status.dart';
import 'package:rainbow_app/core/extensions/build_context_x.dart';
import 'package:rainbow_app/core/helpers/formatters.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/core/theme/app_typography.dart';
import 'package:rainbow_app/core/widgets/app_card.dart';
import 'package:rainbow_app/core/widgets/app_icon.dart';
import 'package:rainbow_app/core/widgets/app_status_badge.dart';
import 'package:rainbow_app/features/guard/models/gate_entry.dart';

/// One vehicle in the guard's list.
///
/// The plate is the primary line because that is what a guard reads off the
/// windscreen; the gate pass, order and customer follow.
class GateEntryCard extends StatelessWidget {
  const GateEntryCard({required this.entry, this.onTap, super.key});

  final GateEntry entry;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StatusEdge(status: entry.status),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          Formatters.vehicleNumber(entry.vehicleNo),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.monoLarge.copyWith(
                            color: context.colors.textPrimary,
                          ),
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      AppStatusBadge(status: entry.status, compact: true),
                    ],
                  ),
                  SizedBox(height: AppSpacing.xs),
                  _MetaLine(icon: AppAssets.iconHash, text: entry.gatePassNo),
                  if (entry.orderNo.isNotEmpty)
                    _MetaLine(
                      icon: AppAssets.iconDocument,
                      text: entry.customerName.isEmpty
                          ? entry.orderNo
                          : '${entry.orderNo} · ${entry.customerName}',
                    ),
                  if (entry.latestActivityAt != null)
                    _MetaLine(
                      icon: AppAssets.iconClock,
                      text: Formatters.dateTime(
                        entry.latestActivityAt,
                        context.localeCode,
                      ),
                    ),
                  if (entry.status == GateEntryStatus.held &&
                      (entry.rejectionReason?.isNotEmpty ?? false)) ...<Widget>[
                    SizedBox(height: AppSpacing.sm),
                    _HoldReason(reason: entry.rejectionReason!),
                  ],
                ],
              ),
            ),
            if (onTap != null) ...<Widget>[
              SizedBox(width: AppSpacing.sm),
              Center(
                child: AppIcon(
                  AppAssets.iconChevronRight,
                  size: AppIconSize.sm,
                  color: context.colors.textTertiary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MetaLine extends StatelessWidget {
  const _MetaLine({required this.icon, required this.text});

  final String icon;
  final String text;

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
          ),
          SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              text,
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

class _HoldReason extends StatelessWidget {
  const _HoldReason({required this.reason});

  final String reason;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: context.colors.markHeldContainer,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Text(
        reason,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption.copyWith(
          color: context.colors.onMarkHeldContainer,
        ),
      ),
    );
  }
}
