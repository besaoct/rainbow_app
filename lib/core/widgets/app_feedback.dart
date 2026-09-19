import 'package:flutter/material.dart';

import 'package:rainbow_app/core/constants/asset_constants.dart';
import 'package:rainbow_app/core/extensions/build_context_x.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/core/theme/app_durations.dart';
import 'package:rainbow_app/core/theme/app_typography.dart';
import 'package:rainbow_app/core/widgets/app_button.dart';
import 'package:rainbow_app/core/widgets/app_icon.dart';

enum AppSnackbarKind { neutral, success, error }

/// Transient confirmations and failures.
///
/// Messages are passed in already localised; this helper only decides how
/// they look and how long they stay.
abstract final class AppSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    AppSnackbarKind kind = AppSnackbarKind.neutral,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar();

    final (Color background, Color foreground, String? icon) = switch (kind) {
      AppSnackbarKind.success => (
        context.colors.success,
        context.colors.onSuccess,
        AppAssets.iconCheckCircle,
      ),
      AppSnackbarKind.error => (
        context.colorScheme.error,
        context.colorScheme.onError,
        AppAssets.iconAlertTriangle,
      ),
      AppSnackbarKind.neutral => (
        context.colors.textPrimary,
        context.colors.textInverse,
        null,
      ),
    };

    messenger.showSnackBar(
      SnackBar(
        backgroundColor: background,
        duration: AppDurations.snackbar,
        content: Row(
          children: <Widget>[
            if (icon != null) ...<Widget>[
              AppIcon(icon, size: AppIconSize.sm, color: foreground),
              SizedBox(width: AppSpacing.sm),
            ],
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(color: foreground),
              ),
            ),
          ],
        ),
        action: (actionLabel != null && onAction != null)
            ? SnackBarAction(
                label: actionLabel,
                textColor: foreground,
                onPressed: onAction,
              )
            : null,
      ),
    );
  }

  static void success(BuildContext context, String message) =>
      show(context, message: message, kind: AppSnackbarKind.success);

  static void error(BuildContext context, String message) =>
      show(context, message: message, kind: AppSnackbarKind.error);
}

/// A two-choice confirmation dialog.
///
/// Returns `true` when confirmed and `null` when dismissed, so callers can
/// treat a dismissal as a cancellation without a separate branch.
abstract final class AppDialog {
  static Future<bool?> confirm(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    String? cancelLabel,
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actionsPadding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        actions: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: AppButton(
                  label: cancelLabel ?? dialogContext.l10n.actionCancel,
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  variant: AppButtonVariant.secondary,
                  size: AppButtonSize.compact,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppButton(
                  label: confirmLabel,
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  variant: isDestructive
                      ? AppButtonVariant.danger
                      : AppButtonVariant.primary,
                  size: AppButtonSize.compact,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A modal bottom sheet that never grows past the viewport and always keeps
/// its header visible while its body scrolls.
abstract final class AppSheet {
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required WidgetBuilder builder,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext sheetContext) {
        return SafeArea(
          top: false,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.85,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.screenH,
                    AppSpacing.xs,
                    AppSpacing.screenH,
                    AppSpacing.md,
                  ),
                  child: Text(
                    title,
                    style: AppTextStyles.headingSmall.copyWith(
                      color: sheetContext.colors.textPrimary,
                    ),
                  ),
                ),
                Flexible(child: builder(sheetContext)),
              ],
            ),
          ),
        );
      },
    );
  }
}
