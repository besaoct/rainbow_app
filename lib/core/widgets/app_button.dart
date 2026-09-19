import 'package:flutter/material.dart';

import 'package:rainbow_app/core/extensions/build_context_x.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/core/widgets/app_icon.dart';

/// Visual weight of an action.
enum AppButtonVariant {
  /// The one primary action on a screen.
  primary,

  /// A secondary action beside a primary one.
  secondary,

  /// Low-emphasis, inline.
  text,

  /// Destructive or blocking: holding a vehicle, signing out.
  danger,
}

enum AppButtonSize { regular, compact }

/// The application's button.
///
/// Handles the three things a bare [FilledButton] does not: a busy state that
/// keeps the button's width so the layout never jumps, a leading icon from
/// the app's own SVG set, and a label that ellipsises rather than overflowing
/// when a translation is longer than the English original.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.regular,
    this.icon,
    this.isBusy = false,
    this.expand = true,
    super.key,
  });

  /// Convenience constructor for the secondary variant.
  const AppButton.secondary({
    required this.label,
    required this.onPressed,
    this.size = AppButtonSize.regular,
    this.icon,
    this.isBusy = false,
    this.expand = true,
    super.key,
  }) : variant = AppButtonVariant.secondary;

  /// Convenience constructor for the destructive variant.
  const AppButton.danger({
    required this.label,
    required this.onPressed,
    this.size = AppButtonSize.regular,
    this.icon,
    this.isBusy = false,
    this.expand = true,
    super.key,
  }) : variant = AppButtonVariant.danger;

  /// Comes from `AppLocalizations` — never a literal.
  final String label;

  /// `null` disables the button.
  final VoidCallback? onPressed;

  final AppButtonVariant variant;
  final AppButtonSize size;

  /// Path from `AppAssets`.
  final String? icon;

  /// Shows a spinner and blocks input while an action is in flight.
  final bool isBusy;

  /// Whether the button fills the available width.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final double height = size == AppButtonSize.regular
        ? AppSize.buttonHeight
        : AppSize.buttonHeightCompact;
    final VoidCallback? handler = isBusy ? null : onPressed;
    final Widget child = _Content(
      label: label,
      icon: icon,
      isBusy: isBusy,
      variant: variant,
    );
    final Size minimumSize = Size(expand ? double.infinity : 0, height);

    final Widget button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
        onPressed: handler,
        style: FilledButton.styleFrom(minimumSize: minimumSize),
        child: child,
      ),
      AppButtonVariant.danger => FilledButton(
        onPressed: handler,
        style: FilledButton.styleFrom(
          minimumSize: minimumSize,
          backgroundColor: context.colorScheme.error,
          foregroundColor: context.colorScheme.onError,
        ),
        child: child,
      ),
      AppButtonVariant.secondary => OutlinedButton(
        onPressed: handler,
        style: OutlinedButton.styleFrom(minimumSize: minimumSize),
        child: child,
      ),
      AppButtonVariant.text => TextButton(
        onPressed: handler,
        style: TextButton.styleFrom(
          minimumSize: Size(expand ? double.infinity : 0, height),
        ),
        child: child,
      ),
    };

    return Semantics(
      button: true,
      enabled: handler != null,
      label: label,
      child: ExcludeSemantics(child: button),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.label,
    required this.isBusy,
    required this.variant,
    this.icon,
  });

  final String label;
  final String? icon;
  final bool isBusy;
  final AppButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    if (isBusy) {
      return SizedBox(
        height: AppIconSize.sm,
        width: AppIconSize.sm,
        child: CircularProgressIndicator(
          strokeWidth: AppSize.progressStroke,
          color: _foreground(context),
        ),
      );
    }
    final Widget text = Flexible(
      child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
    if (icon == null) {
      return Row(mainAxisSize: MainAxisSize.min, children: <Widget>[text]);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AppIcon(icon!, size: AppIconSize.sm, color: _foreground(context)),
        SizedBox(width: AppSpacing.sm),
        text,
      ],
    );
  }

  Color _foreground(BuildContext context) => switch (variant) {
    AppButtonVariant.primary => context.colorScheme.onPrimary,
    AppButtonVariant.danger => context.colorScheme.onError,
    AppButtonVariant.secondary => context.colors.textPrimary,
    AppButtonVariant.text => context.colorScheme.primary,
  };
}
