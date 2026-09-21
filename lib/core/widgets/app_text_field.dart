import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:rainbow_app/core/constants/asset_constants.dart';
import 'package:rainbow_app/core/extensions/build_context_x.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/core/theme/app_typography.dart';
import 'package:rainbow_app/core/widgets/app_icon.dart';

/// The application's text input.
///
/// The label sits above the field rather than inside it, which keeps the
/// control's height stable across languages — a floating label that wraps in
/// Assamese is the most common source of clipped inputs.
class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.label,
    required this.controller,
    this.hint,
    this.helper,
    this.errorText,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.obscureText = false,
    this.enabled = true,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.leadingIcon,
    this.trailing,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.isOptional = false,
    this.autofillHints,
    this.labelAction,
    super.key,
  });

  /// Localised label shown above the field.
  final String label;

  final TextEditingController controller;

  /// Localised placeholder.
  final String? hint;

  /// Localised hint shown under the field when there is no error.
  final String? helper;

  /// Server-side error, shown in place of [validator]'s result.
  final String? errorText;

  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final bool enabled;
  final bool autofocus;
  final int maxLines;
  final int? minLines;
  final int? maxLength;

  /// Path from `AppAssets`.
  final String? leadingIcon;

  final Widget? trailing;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;

  /// Appends the localised "Optional" marker to the label.
  final bool isOptional;

  /// A small action placed at the end of the label row — a "fill with the
  /// maximum" shortcut, for example. It belongs here rather than beside the
  /// field: a button next to the input has to share the row's width, which
  /// truncates its label and leaves the two controls at different heights.
  final Widget? labelAction;

  final List<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _Label(label: label, isOptional: isOptional, action: labelAction),
        SizedBox(height: AppSpacing.xs),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          validator: validator,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          inputFormatters: inputFormatters,
          obscureText: obscureText,
          enabled: enabled,
          autofocus: autofocus,
          maxLines: obscureText ? 1 : maxLines,
          minLines: minLines,
          maxLength: maxLength,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          autofillHints: autofillHints,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: AppTextStyles.bodyLarge.copyWith(
            color: enabled
                ? context.colors.textPrimary
                : context.colors.textTertiary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            helperText: helper,
            helperMaxLines: 2,
            errorText: errorText,
            // The counter duplicates information the validator already gives
            // and adds an unpredictable line of height below the field.
            counterText: '',
            prefixIcon: leadingIcon == null
                ? null
                : Padding(
                    padding: EdgeInsets.only(
                      left: AppSpacing.md,
                      right: AppSpacing.sm,
                    ),
                    child: AppIcon(
                      leadingIcon!,
                      size: AppIconSize.sm,
                      color: context.colors.textTertiary,
                    ),
                  ),
            prefixIconConstraints: BoxConstraints(
              minWidth: AppIconSize.sm + AppSpacing.xl,
              minHeight: AppIconSize.sm,
            ),
            suffixIcon: trailing,
          ),
        ),
      ],
    );
  }
}

/// A password field with a show/hide toggle.
class AppPasswordField extends StatefulWidget {
  const AppPasswordField({
    required this.label,
    required this.controller,
    this.hint,
    this.validator,
    this.errorText,
    this.textInputAction,
    this.onSubmitted,
    this.focusNode,
    this.enabled = true,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final String? Function(String?)? validator;
  final String? errorText;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final bool enabled;

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: widget.label,
      controller: widget.controller,
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      hint: widget.hint,
      validator: widget.validator,
      errorText: widget.errorText,
      obscureText: _obscured,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      leadingIcon: AppAssets.iconLock,
      autofillHints: const <String>[AutofillHints.password],
      trailing: IconButton(
        onPressed: () => setState(() => _obscured = !_obscured),
        tooltip: _obscured
            ? context.l10n.loginShowPassword
            : context.l10n.loginHidePassword,
        icon: AppIcon(
          _obscured ? AppAssets.iconEye : AppAssets.iconEyeOff,
          size: AppIconSize.sm,
          color: context.colors.textSecondary,
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label({required this.label, required this.isOptional, this.action});

  final String label;
  final bool isOptional;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    // `spaceBetween` with both sides flexible: the label keeps the room it
    // needs, the action sits at the end, and either ellipsises rather than
    // overflowing when a translation is long on a narrow phone.
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ),
              if (isOptional) ...<Widget>[
                SizedBox(width: AppSpacing.xs),
                Text(
                  context.l10n.labelOptional,
                  style: AppTextStyles.caption.copyWith(
                    color: context.colors.textTertiary,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (action != null) ...<Widget>[
          SizedBox(width: AppSpacing.sm),
          Flexible(child: action!),
        ],
      ],
    );
  }
}
