import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rainbow_app/core/constants/asset_constants.dart';
import 'package:rainbow_app/core/enums/user_role.dart';
import 'package:rainbow_app/core/extensions/build_context_x.dart';
import 'package:rainbow_app/core/helpers/validators.dart';
import 'package:rainbow_app/core/network/api_failure.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/core/theme/app_typography.dart';
import 'package:rainbow_app/core/widgets/app_button.dart';
import 'package:rainbow_app/core/widgets/app_logo.dart';
import 'package:rainbow_app/core/widgets/app_state_views.dart';
import 'package:rainbow_app/core/widgets/app_text_field.dart';
import 'package:rainbow_app/features/auth/providers/auth_providers.dart';

/// Sign-in against the Rainbow ERP account.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();

  bool _isSubmitting = false;

  /// Localised failure message, shown above the form.
  String? _error;

  /// Per-field errors the server reported.
  Map<String, List<String>> _fieldErrors = const <String, List<String>>{};

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    context.dismissKeyboard();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isSubmitting = true;
      _error = null;
      _fieldErrors = const <String, List<String>>{};
    });

    try {
      await ref
          .read(authControllerProvider.notifier)
          .signIn(email: _email.text, password: _password.text);
      if (!mounted) return;

      // The ERP has accounts that can sign in but have no gate or store
      // rights. Rejecting them here, rather than dropping them on an empty
      // dashboard, makes the reason explicit.
      final UserRole role = ref.read(currentRoleProvider);
      if (!role.hasOperationsAccess) {
        await ref.read(authControllerProvider.notifier).signOut();
        if (!mounted) return;
        setState(() => _error = context.l10n.loginNoRoleMessage);
      }
    } on ApiFailure catch (failure) {
      if (!mounted) return;
      setState(() {
        _error = failure.localizedMessage(context.l10n);
        _fieldErrors = failure is ValidationFailure
            ? failure.fieldErrors
            : const <String, List<String>>{};
      });
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // A session that expired mid-shift explains itself instead of silently
    // dropping the guard back at sign-in.
    final AuthState? auth = ref.watch(authControllerProvider).value;
    final bool expired =
        auth is AuthSignedOut && auth.becauseSessionExpired && _error == null;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSize.maxContentWidth,
              ),
              child: Padding(
                padding: AppSpacing.screenHorizontal,
                child: AutofillGroup(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        AppLogo(size: AppSize.logoMd),
                        SizedBox(height: AppSpacing.huge),
                        Text(
                          context.l10n.loginTitle,
                          style: AppTextStyles.displaySmall.copyWith(
                            color: context.colors.textPrimary,
                          ),
                        ),
                        SizedBox(height: AppSpacing.xs),
                        Text(
                          context.l10n.loginSubtitle,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        ),
                        SizedBox(height: AppSpacing.xxl),
                        if (_error != null) ...<Widget>[
                          AppInlineError(message: _error!),
                          SizedBox(height: AppSpacing.lg),
                        ] else if (expired) ...<Widget>[
                          AppInlineError(
                            message: context.l10n.errorUnauthorized,
                          ),
                          SizedBox(height: AppSpacing.lg),
                        ],
                        AppTextField(
                          label: context.l10n.loginEmailLabel,
                          hint: context.l10n.loginEmailHint,
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          leadingIcon: AppAssets.iconMail,
                          enabled: !_isSubmitting,
                          errorText: _fieldErrors['login']?.firstOrNull,
                          autofillHints: const <String>[
                            AutofillHints.username,
                            AutofillHints.email,
                          ],
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                          ],
                          validator: (String? v) =>
                              Validators.email(v, context.l10n),
                          onSubmitted: (_) => _passwordFocus.requestFocus(),
                        ),
                        SizedBox(height: AppSpacing.lg),
                        AppPasswordField(
                          label: context.l10n.loginPasswordLabel,
                          hint: context.l10n.loginPasswordHint,
                          controller: _password,
                          focusNode: _passwordFocus,
                          enabled: !_isSubmitting,
                          textInputAction: TextInputAction.done,
                          errorText: _fieldErrors['password']?.firstOrNull,
                          validator: (String? v) =>
                              Validators.password(v, context.l10n),
                          onSubmitted: (_) => unawaited(_submit()),
                        ),
                        SizedBox(height: AppSpacing.xxl),
                        AppButton(
                          label: _isSubmitting
                              ? context.l10n.loginSubmitting
                              : context.l10n.actionSignIn,
                          isBusy: _isSubmitting,
                          onPressed: () => unawaited(_submit()),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
