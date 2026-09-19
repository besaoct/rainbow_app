import 'package:flutter/material.dart';

import 'package:rainbow_app/core/constants/asset_constants.dart';
import 'package:rainbow_app/core/extensions/build_context_x.dart';
import 'package:rainbow_app/core/network/api_failure.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/core/theme/app_typography.dart';
import 'package:rainbow_app/core/widgets/app_button.dart';
import 'package:rainbow_app/core/widgets/app_icon.dart';

/// The loading state. Centred and labelled for screen readers.
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({this.size, this.color, super.key});

  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final double resolved = size ?? AppIconSize.lg;
    return Semantics(
      label: context.l10n.a11yLoading,
      child: Center(
        child: SizedBox(
          height: resolved,
          width: resolved,
          child: CircularProgressIndicator(
            strokeWidth: AppSize.progressStroke,
            color: color ?? context.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

/// Full-screen loading state, sized so it occupies the same space the loaded
/// content will — the list does not jump when data arrives.
class AppLoadingView extends StatelessWidget {
  const AppLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.huge),
      child: const AppLoadingIndicator(),
    );
  }
}

/// A message with an illustration and an optional action.
///
/// Used as the base for both the empty and the error state so the two read
/// as one family.
class AppMessageView extends StatelessWidget {
  const AppMessageView({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.iconColor,
    this.iconBackground,
    super.key,
  });

  /// Path from `AppAssets`.
  final String icon;

  /// Localised title.
  final String title;

  /// Localised body.
  final String message;

  /// Localised action label.
  final String? actionLabel;

  final VoidCallback? onAction;
  final Color? iconColor;
  final Color? iconBackground;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSize.maxContentWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.xxxl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: iconBackground ?? context.colors.surfaceSunken,
                  shape: BoxShape.circle,
                ),
                child: AppIcon(
                  icon,
                  size: AppIconSize.lg,
                  color: iconColor ?? context.colors.textTertiary,
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.headingSmall.copyWith(
                  color: context.colors.textPrimary,
                ),
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
              if (actionLabel != null && onAction != null) ...<Widget>[
                SizedBox(height: AppSpacing.xl),
                AppButton.secondary(
                  label: actionLabel!,
                  onPressed: onAction,
                  size: AppButtonSize.compact,
                  expand: false,
                  icon: AppAssets.iconRefresh,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// The empty state for a list that loaded successfully but has no rows.
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    required this.title,
    required this.message,
    this.icon = AppAssets.iconInbox,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final String title;
  final String message;
  final String icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return AppMessageView(
      icon: icon,
      title: title,
      message: message,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }
}

/// The error state.
///
/// Takes the [ApiFailure] itself rather than a string so the icon and the
/// message can both follow from the failure kind — an offline device shows a
/// connectivity icon and an expired session shows a lock.
class AppErrorView extends StatelessWidget {
  const AppErrorView({required this.failure, this.onRetry, super.key});

  final Object failure;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final (String icon, String title, String message) = _resolve(context);
    return AppMessageView(
      icon: icon,
      title: title,
      message: message,
      iconColor: context.colorScheme.error,
      iconBackground: context.colorScheme.errorContainer,
      actionLabel: onRetry == null ? null : context.l10n.actionRetry,
      onAction: onRetry,
    );
  }

  (String, String, String) _resolve(BuildContext context) {
    final failure = this.failure;
    if (failure is! ApiFailure) {
      return (
        AppAssets.iconAlertTriangle,
        context.l10n.errorTitle,
        context.l10n.errorGeneric,
      );
    }
    final String message = failure.localizedMessage(context.l10n);
    return switch (failure) {
      NetworkFailure() => (
        AppAssets.iconWifiOff,
        context.l10n.errorTitleNoConnection,
        message,
      ),
      TimeoutFailure() => (
        AppAssets.iconClock,
        context.l10n.errorTitle,
        message,
      ),
      UnauthorizedFailure() => (
        AppAssets.iconLock,
        context.l10n.errorTitleSession,
        message,
      ),
      _ => (AppAssets.iconAlertTriangle, context.l10n.errorTitle, message),
    };
  }
}

/// A compact inline error, for a failure inside a card rather than a page.
class AppInlineError extends StatelessWidget {
  const AppInlineError({required this.message, this.onRetry, super.key});

  /// Already-localised message.
  final String message;

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.cardCompact,
      decoration: BoxDecoration(
        color: context.colorScheme.errorContainer,
        borderRadius: AppRadius.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppIcon(
            AppAssets.iconAlertTriangle,
            size: AppIconSize.sm,
            color: context.colorScheme.onErrorContainer,
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodySmall.copyWith(
                color: context.colorScheme.onErrorContainer,
              ),
            ),
          ),
          if (onRetry != null) ...<Widget>[
            SizedBox(width: AppSpacing.sm),
            AppButton(
              label: context.l10n.actionRetry,
              onPressed: onRetry,
              variant: AppButtonVariant.text,
              size: AppButtonSize.compact,
              expand: false,
            ),
          ],
        ],
      ),
    );
  }
}
