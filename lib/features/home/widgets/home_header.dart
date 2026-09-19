import 'package:flutter/material.dart';

import 'package:rainbow_app/core/constants/asset_constants.dart';
import 'package:rainbow_app/core/extensions/build_context_x.dart';
import 'package:rainbow_app/core/extensions/date_time_x.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/core/theme/app_typography.dart';
import 'package:rainbow_app/core/widgets/app_icon.dart';
import 'package:rainbow_app/features/auth/models/auth_user.dart';

/// The dashboard's greeting row: who is signed in, in what capacity, and the
/// way into settings.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    required this.user,
    required this.onOpenSettings,
    super.key,
  });

  final AuthUser user;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final String greeting = switch (DateTime.now().dayPart) {
      DayPart.morning => context.l10n.greetingMorning,
      DayPart.afternoon => context.l10n.greetingAfternoon,
      DayPart.evening => context.l10n.greetingEvening,
    };

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _Avatar(initials: user.initials),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                greeting,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
              Text(
                user.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.headingSmall.copyWith(
                  color: context.colors.textPrimary,
                ),
              ),
              Text(
                user.role.label(context.l10n),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: context.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        IconButton(
          onPressed: onOpenSettings,
          tooltip: context.l10n.settingsTitle,
          icon: AppIcon(
            AppAssets.iconSettings,
            size: AppIconSize.md,
            color: context.colors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSize.avatar,
      width: AppSize.avatar,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.colorScheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Text(
        initials,
        style: AppTextStyles.labelLarge.copyWith(
          color: context.colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}
