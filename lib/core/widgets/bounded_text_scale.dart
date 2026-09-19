import 'package:flutter/material.dart';

import 'package:rainbow_app/core/constants/app_constants.dart';

/// Bounds the OS text-scale factor for everything below it.
///
/// The app honours the user's system text size, but only within a range.
/// Beyond roughly 1.35x, fixed-height controls — the app bar, the bottom
/// action bar, a compact button — begin to clip; below 0.85x the plate
/// numbers a guard reads at arm's length stop being legible. Clamping here
/// rather than in each widget keeps the bound in one place, and means the
/// responsive tests can exercise exactly what ships.
class BoundedTextScale extends StatelessWidget {
  const BoundedTextScale({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    return MediaQuery(
      data: media.copyWith(
        textScaler: media.textScaler.clamp(
          minScaleFactor: AppConstants.minTextScale,
          maxScaleFactor: AppConstants.maxTextScale,
        ),
      ),
      child: child,
    );
  }
}
