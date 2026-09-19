import 'package:flutter/material.dart';

import 'package:rainbow_app/core/extensions/build_context_x.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/core/widgets/app_logo.dart';
import 'package:rainbow_app/core/widgets/app_state_views.dart';

/// Bridges the native splash and the first real screen.
///
/// It is drawn to match `flutter_native_splash`'s output exactly — same
/// background, same mark, same position — so the handover is invisible. It
/// performs no work and imposes no delay: the router moves on the instant the
/// session is restored, which is usually within the first frame.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surfaceRaised,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSize.maxContentWidth,
            ),
            child: Padding(
              padding: AppSpacing.screenHorizontal,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AppLogo(size: AppSize.logoLg),
                  SizedBox(height: AppSpacing.huge),
                  const AppLoadingIndicator(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
