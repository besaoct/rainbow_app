import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rainbow_app/core/extensions/build_context_x.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/core/theme/app_durations.dart';
import 'package:rainbow_app/core/theme/app_typography.dart';
import 'package:rainbow_app/core/widgets/app_button.dart';
import 'package:rainbow_app/core/widgets/app_logo.dart';
import 'package:rainbow_app/features/onboarding/models/onboarding_page.dart';
import 'package:rainbow_app/features/onboarding/providers/onboarding_providers.dart';
import 'package:rainbow_app/features/onboarding/widgets/onboarding_page_view.dart';

/// The first-launch introduction.
///
/// Completing it flips the persisted flag; the router is watching that flag
/// and moves to sign-in on its own, so this screen never navigates directly.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() =>
      ref.read(onboardingCompletedProvider.notifier).complete();

  void _next(int pageCount) {
    if (_index >= pageCount - 1) {
      unawaited(_finish());
      return;
    }
    unawaited(
      _controller.nextPage(
        duration: AppDurations.medium,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<OnboardingPage> pages = OnboardingContent.pages(context.l10n);
    final bool isLast = _index == pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSize.maxContentWidth,
            ),
            child: Column(
              children: <Widget>[
                _Header(showSkip: !isLast, onSkip: () => unawaited(_finish())),
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: pages.length,
                    onPageChanged: (int i) => setState(() => _index = i),
                    itemBuilder: (BuildContext context, int i) => Padding(
                      padding: AppSpacing.screenHorizontal,
                      child: OnboardingPageContent(page: pages[i]),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.screenH,
                    AppSpacing.lg,
                    AppSpacing.screenH,
                    AppSpacing.lg,
                  ),
                  child: Column(
                    children: <Widget>[
                      Semantics(
                        label: context.l10n.onboardingPageIndicator(
                          _index + 1,
                          pages.length,
                        ),
                        child: OnboardingIndicator(
                          count: pages.length,
                          activeIndex: _index,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xl),
                      AppButton(
                        label: isLast
                            ? context.l10n.actionGetStarted
                            : context.l10n.actionNext,
                        onPressed: () => _next(pages.length),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.showSkip, required this.onSkip});

  final bool showSkip;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        AppSpacing.md,
        AppSpacing.sm,
        0,
      ),
      child: Row(
        children: <Widget>[
          AppLogo(variant: AppLogoVariant.mark, size: AppSize.logoSm),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              context.l10n.appName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.headingSmall.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
          ),
          if (showSkip)
            TextButton(onPressed: onSkip, child: Text(context.l10n.actionSkip)),
        ],
      ),
    );
  }
}
