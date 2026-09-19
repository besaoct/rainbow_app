import 'package:rainbow_app/core/constants/asset_constants.dart';
import 'package:rainbow_app/l10n/generated/app_localizations.dart';

/// One screen of the first-run introduction.
class OnboardingPage {
  const OnboardingPage({
    required this.icon,
    required this.title,
    required this.body,
  });

  /// Path from `AppAssets`.
  final String icon;

  /// Localised heading.
  final String title;

  /// Localised body copy.
  final String body;
}

/// The introduction's content.
///
/// Built from [AppLocalizations] on every read so that switching language on
/// the onboarding screen itself re-renders in the new language.
abstract final class OnboardingContent {
  static List<OnboardingPage> pages(AppLocalizations l10n) => <OnboardingPage>[
    OnboardingPage(
      icon: AppAssets.iconGateIn,
      title: l10n.onboardingTitle1,
      body: l10n.onboardingBody1,
    ),
    OnboardingPage(
      icon: AppAssets.iconBox,
      title: l10n.onboardingTitle2,
      body: l10n.onboardingBody2,
    ),
    OnboardingPage(
      icon: AppAssets.iconShieldCheck,
      title: l10n.onboardingTitle3,
      body: l10n.onboardingBody3,
    ),
  ];
}
