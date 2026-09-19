import 'package:flutter/material.dart';

import 'package:rainbow_app/core/extensions/build_context_x.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/core/theme/app_durations.dart';
import 'package:rainbow_app/core/theme/app_typography.dart';
import 'package:rainbow_app/core/widgets/app_icon.dart';
import 'package:rainbow_app/features/onboarding/models/onboarding_page.dart';

/// One page of the introduction.
///
/// The copy area scrolls rather than shrinking, so a long translation at a
/// large system text size cannot overflow on a short phone.
class OnboardingPageContent extends StatelessWidget {
  const OnboardingPageContent({required this.page, super.key});

  final OnboardingPage page;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: context.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: AppIcon(
              page.icon,
              size: AppIconSize.xl,
              color: context.colorScheme.onPrimaryContainer,
            ),
          ),
          SizedBox(height: AppSpacing.xxl),
          Text(
            page.title,
            style: AppTextStyles.displaySmall.copyWith(
              color: context.colors.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            page.body,
            style: AppTextStyles.bodyLarge.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// The dot row under the pages. The active dot widens rather than changing
/// colour alone, so progress is visible without relying on hue.
class OnboardingIndicator extends StatelessWidget {
  const OnboardingIndicator({
    required this.count,
    required this.activeIndex,
    super.key,
  });

  final int count;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (int i = 0; i < count; i++)
          AnimatedContainer(
            duration: AppDurations.fast,
            curve: Curves.easeOut,
            margin: EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
            height: AppSpacing.sm,
            width: i == activeIndex ? AppSpacing.xxl : AppSpacing.sm,
            decoration: BoxDecoration(
              color: i == activeIndex
                  ? context.colorScheme.primary
                  : context.colors.borderStrong,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
          ),
      ],
    );
  }
}
