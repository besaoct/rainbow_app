import 'dart:ui' show Locale;

import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rainbow_app/core/constants/app_constants.dart';
import 'package:rainbow_app/core/providers/core_providers.dart';

/// Light/dark preference, persisted across launches.
class ThemeModeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final String? stored = ref.watch(preferencesServiceProvider).themeModeName;
    return ThemeMode.values
            .where((ThemeMode m) => m.name == stored)
            .firstOrNull ??
        ThemeMode.system;
  }

  Future<void> set(ThemeMode mode) async {
    state = mode;
    await ref
        .read(preferencesServiceProvider)
        .setThemeModeName(mode == ThemeMode.system ? null : mode.name);
  }
}

final NotifierProvider<ThemeModeController, ThemeMode> themeModeProvider =
    NotifierProvider<ThemeModeController, ThemeMode>(
      ThemeModeController.new,
      name: 'themeMode',
    );

/// The chosen language, or `null` to follow the device.
class LocaleController extends Notifier<Locale?> {
  @override
  Locale? build() {
    final String? code = ref.watch(preferencesServiceProvider).localeCode;
    if (code == null) return null;
    return AppConstants.supportedLocales
        .where((Locale l) => l.languageCode == code)
        .firstOrNull;
  }

  /// Passing `null` restores "follow the device language".
  Future<void> set(Locale? locale) async {
    state = locale;
    await ref
        .read(preferencesServiceProvider)
        .setLocaleCode(locale?.languageCode);
  }
}

final NotifierProvider<LocaleController, Locale?> localeProvider =
    NotifierProvider<LocaleController, Locale?>(
      LocaleController.new,
      name: 'locale',
    );

/// Whether preferences could be opened. The settings screen warns when they
/// could not, because the user's choices will not survive a restart.
final Provider<bool> preferencesAvailableProvider = Provider<bool>(
  (Ref ref) => ref.watch(preferencesServiceProvider).isAvailable,
  name: 'preferencesAvailable',
);
