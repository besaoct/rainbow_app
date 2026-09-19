import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:rainbow_app/app/router/app_router.dart';
import 'package:rainbow_app/app/theme/app_theme.dart';
import 'package:rainbow_app/core/constants/app_constants.dart';
import 'package:rainbow_app/core/theme/app_scale.dart';
import 'package:rainbow_app/core/widgets/bounded_text_scale.dart';
import 'package:rainbow_app/features/settings/providers/settings_providers.dart';
import 'package:rainbow_app/l10n/generated/app_localizations.dart';

/// The application root.
class RainbowApp extends ConsumerWidget {
  const RainbowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // `ScreenUtilInit` measures the window before the first frame so the
    // design-system tokens in `AppScale` resolve correctly from the very
    // first build.
    return ScreenUtilInit(
      designSize: AppScale.designSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? _) => const _MaterialRoot(),
    );
  }
}

class _MaterialRoot extends ConsumerWidget {
  const _MaterialRoot();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoRouter router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,

      // The window title is the localised app name, resolved once the
      // localisations for the active locale are loaded.
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context).appName,

      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ref.watch(themeModeProvider),

      locale: ref.watch(localeProvider),
      supportedLocales: AppConstants.supportedLocales,
      localizationsDelegates: const <LocalizationsDelegate<Object>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      builder: (BuildContext context, Widget? child) =>
          BoundedTextScale(child: child ?? const SizedBox.shrink()),
    );
  }
}
