import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rainbow_app/app/app.dart';
import 'package:rainbow_app/core/providers/core_providers.dart';
import 'package:rainbow_app/core/services/preferences_service.dart';

/// Starts the application.
///
/// The native splash is held only for the work that genuinely has to finish
/// before the first frame — opening preferences, so the theme and language
/// are correct immediately — and is removed as soon as that frame is ready.
/// There is no artificial delay: the session restore continues behind the
/// Flutter splash, which is drawn to match the native one.
Future<void> bootstrap() async {
  final WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  // Report framework errors through the same channel as the rest of the app
  // so a release build has one place to attach a crash reporter.
  FlutterError.onError = (FlutterErrorDetails details) {
    developer.log(
      details.exceptionAsString(),
      name: 'rainbow.error',
      error: details.exception,
      stackTrace: details.stack,
    );
    FlutterError.presentError(details);
  };

  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  // Never throws: an unavailable store yields defaults and the settings
  // screen tells the user their preferences will not persist.
  final PreferencesService preferences = await SharedPreferencesService.open();

  runApp(
    ProviderScope(
      // The element type (`Override`) is internal to Riverpod, so the list
      // literal takes its type from the parameter.
      overrides: [preferencesServiceProvider.overrideWithValue(preferences)],
      observers: kDebugMode ? <ProviderObserver>[_LoggingObserver()] : null,
      child: const RainbowApp(),
    ),
  );

  // Hand over to Flutter once it has something to show.
  binding.addPostFrameCallback((_) => FlutterNativeSplash.remove());
}

/// Logs provider failures in debug builds, so a repository throwing inside a
/// provider is visible without attaching a debugger.
final class _LoggingObserver extends ProviderObserver {
  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    developer.log(
      'Provider ${context.provider.name ?? context.provider.runtimeType} failed',
      name: 'rainbow.provider',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
