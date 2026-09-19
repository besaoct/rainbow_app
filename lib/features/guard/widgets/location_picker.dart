import 'package:flutter/material.dart';

import 'package:rainbow_app/core/constants/asset_constants.dart';
import 'package:rainbow_app/core/extensions/build_context_x.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/core/theme/app_typography.dart';
import 'package:rainbow_app/core/widgets/app_card.dart';
import 'package:rainbow_app/core/widgets/app_icon.dart';
import 'package:rainbow_app/features/auth/models/auth_user.dart';

/// The list of locations a gate-in can be registered against.
class LocationPicker extends StatelessWidget {
  const LocationPicker({required this.locations, this.selectedId, super.key});

  final List<AssignedLocation> locations;
  final int? selectedId;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        0,
        AppSpacing.screenH,
        AppSpacing.xl,
      ),
      itemCount: locations.length,
      separatorBuilder: (_, _) => SizedBox(height: AppSpacing.sm),
      itemBuilder: (BuildContext context, int index) {
        final AssignedLocation location = locations[index];
        final bool selected = location.id == selectedId;
        return AppCard(
          onTap: () => Navigator.of(context).pop(location),
          borderColor: selected ? context.colorScheme.primary : null,
          color: selected ? context.colorScheme.primaryContainer : null,
          padding: AppSpacing.cardCompact,
          child: Row(
            children: <Widget>[
              AppIcon(
                AppAssets.iconWarehouse,
                size: AppIconSize.sm,
                color: selected
                    ? context.colorScheme.primary
                    : context.colors.textTertiary,
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      location.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: context.colors.textPrimary,
                      ),
                    ),
                    if (location.code.isNotEmpty)
                      Text(
                        location.code,
                        style: AppTextStyles.caption.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              if (selected)
                AppIcon(
                  AppAssets.iconCheckCircle,
                  size: AppIconSize.sm,
                  color: context.colorScheme.primary,
                ),
            ],
          ),
        );
      },
    );
  }
}
