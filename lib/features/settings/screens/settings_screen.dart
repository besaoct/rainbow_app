import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rainbow_app/app/config/app_config.dart';
import 'package:rainbow_app/core/constants/app_constants.dart';
import 'package:rainbow_app/core/constants/asset_constants.dart';
import 'package:rainbow_app/core/extensions/build_context_x.dart';
import 'package:rainbow_app/core/providers/core_providers.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/core/theme/app_typography.dart';
import 'package:rainbow_app/core/widgets/app_button.dart';
import 'package:rainbow_app/core/widgets/app_card.dart';
import 'package:rainbow_app/core/widgets/app_feedback.dart';
import 'package:rainbow_app/core/widgets/app_icon.dart';
import 'package:rainbow_app/core/widgets/app_scaffold.dart';
import 'package:rainbow_app/core/widgets/app_state_views.dart';
import 'package:rainbow_app/features/auth/models/auth_user.dart';
import 'package:rainbow_app/features/auth/providers/auth_providers.dart';
import 'package:rainbow_app/features/onboarding/providers/onboarding_providers.dart';
import 'package:rainbow_app/features/settings/providers/settings_providers.dart';
import 'package:rainbow_app/features/settings/widgets/settings_option_tile.dart';

/// Appearance, language, account and build information.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final bool? confirmed = await AppDialog.confirm(
      context,
      title: context.l10n.homeSignOutTitle,
      message: context.l10n.homeSignOutMessage,
      confirmLabel: context.l10n.actionSignOut,
      isDestructive: true,
    );
    if (confirmed != true) return;
    await ref.read(authControllerProvider.notifier).signOut();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeMode themeMode = ref.watch(themeModeProvider);
    final Locale? locale = ref.watch(localeProvider);
    final AuthUser? user = ref.watch(currentUserProvider);
    final AppConfig config = ref.watch(appConfigProvider);
    final bool storageAvailable = ref.watch(preferencesAvailableProvider);

    return AppScaffold(
      title: context.l10n.settingsTitle,
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (!storageAvailable) ...<Widget>[
            AppInlineError(message: context.l10n.errorStorageUnavailable),
            SizedBox(height: AppSpacing.lg),
          ],
          if (user != null) ...<Widget>[
            AppSectionHeader(title: context.l10n.settingsAccount),
            AppCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  AppDetailRow(
                    label: user.role.label(context.l10n),
                    value: user.name,
                  ),
                  AppDetailRow(
                    label: context.l10n.loginEmailLabel,
                    value: user.email,
                  ),
                  if (user.phone.isNotEmpty)
                    AppDetailRow(
                      label: context.l10n.contactPhoneLabel,
                      value: user.phone,
                    ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.xxl),
          ],
          AppSectionHeader(title: context.l10n.settingsAppearance),
          SettingsOptionGroup<ThemeMode>(
            selected: themeMode,
            onChanged: (ThemeMode mode) =>
                unawaited(ref.read(themeModeProvider.notifier).set(mode)),
            options: <SettingsOption<ThemeMode>>[
              SettingsOption<ThemeMode>(
                value: ThemeMode.system,
                label: context.l10n.settingsThemeSystem,
                icon: AppAssets.iconSettings,
              ),
              SettingsOption<ThemeMode>(
                value: ThemeMode.light,
                label: context.l10n.settingsThemeLight,
                icon: AppAssets.iconSun,
              ),
              SettingsOption<ThemeMode>(
                value: ThemeMode.dark,
                label: context.l10n.settingsThemeDark,
                icon: AppAssets.iconMoon,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xxl),
          AppSectionHeader(title: context.l10n.settingsLanguage),
          SettingsOptionGroup<Locale?>(
            selected: locale,
            onChanged: (Locale? value) =>
                unawaited(ref.read(localeProvider.notifier).set(value)),
            options: <SettingsOption<Locale?>>[
              SettingsOption<Locale?>(
                value: null,
                label: context.l10n.settingsThemeSystem,
                icon: AppAssets.iconSettings,
              ),
              for (final Locale supported in AppConstants.supportedLocales)
                SettingsOption<Locale?>(
                  value: supported,
                  label: _languageName(context, supported),
                  icon: AppAssets.iconLanguage,
                ),
            ],
          ),
          SizedBox(height: AppSpacing.xxl),
          AppSectionHeader(title: context.l10n.settingsAbout),
          AppCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AppDetailRow(
                  label: context.l10n.appName,
                  value: context.l10n.appTagline,
                ),
                AppDetailRow(
                  label: context.l10n.settingsVersion,
                  value: context.l10n.settingsVersionValue(
                    AppConstants.version,
                    AppConstants.buildNumber,
                  ),
                ),
                AppDetailRow(
                  label: context.l10n.settingsServer,
                  value: config.displayHost,
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.md),
          AppCard(
            onTap: () => unawaited(
              ref.read(onboardingCompletedProvider.notifier).reset(),
            ),
            padding: AppSpacing.cardCompact,
            child: Row(
              children: <Widget>[
                AppIcon(
                  AppAssets.iconHistory,
                  size: AppIconSize.sm,
                  color: context.colors.textSecondary,
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    context.l10n.settingsReplayOnboarding,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: context.colors.textPrimary,
                    ),
                  ),
                ),
                AppIcon(
                  AppAssets.iconChevronRight,
                  size: AppIconSize.sm,
                  color: context.colors.textTertiary,
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.xxl),
          AppButton.danger(
            label: context.l10n.actionSignOut,
            icon: AppAssets.iconLogout,
            onPressed: () => unawaited(_signOut(context, ref)),
          ),
        ],
      ),
    );
  }

  /// Language names are written in their own script, so they are readable
  /// whichever language the interface is currently in.
  String _languageName(BuildContext context, Locale locale) {
    return switch (locale.languageCode) {
      'hi' => context.l10n.languageHindi,
      'bn' => context.l10n.languageBengali,
      'as' => context.l10n.languageAssamese,
      _ => context.l10n.languageEnglish,
    };
  }
}
