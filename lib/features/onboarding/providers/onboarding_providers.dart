import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rainbow_app/core/providers/core_providers.dart';

/// Whether the introduction has been completed.
///
/// The router watches this, so completing onboarding navigates by itself
/// rather than by an imperative push from the last page.
class OnboardingController extends Notifier<bool> {
  @override
  bool build() => ref.watch(preferencesServiceProvider).hasCompletedOnboarding;

  /// Marks the introduction as done.
  ///
  /// The in-memory flag is set first so navigation is immediate; if the write
  /// fails the user simply sees the introduction again next launch, which is
  /// a better outcome than blocking them at the gate while storage retries.
  Future<void> complete() async {
    state = true;
    await ref
        .read(preferencesServiceProvider)
        .setHasCompletedOnboarding(value: true);
  }

  /// Shows the introduction again, from the settings screen.
  Future<void> reset() async {
    state = false;
    await ref
        .read(preferencesServiceProvider)
        .setHasCompletedOnboarding(value: false);
  }
}

final NotifierProvider<OnboardingController, bool> onboardingCompletedProvider =
    NotifierProvider<OnboardingController, bool>(
      OnboardingController.new,
      name: 'onboardingCompleted',
    );
