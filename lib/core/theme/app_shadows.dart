import 'package:flutter/material.dart';

import 'package:rainbow_app/core/theme/app_scale.dart';

/// Elevation is expressed as explicit shadow lists rather than Material
/// elevation numbers, so cards read the same in light and dark themes.
abstract final class AppShadows {
  /// Cards and list rows at rest.
  static List<BoxShadow> resting(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return <BoxShadow>[
        BoxShadow(
          color: const Color(0x66000000),
          blurRadius: AppScale.of(14),
          offset: Offset(0, AppScale.of(3)),
        ),
      ];
    }
    return <BoxShadow>[
      BoxShadow(
        color: const Color(0x0F0F172A),
        blurRadius: AppScale.of(12),
        offset: Offset(0, AppScale.of(3)),
      ),
      BoxShadow(
        color: const Color(0x0A0F172A),
        blurRadius: AppScale.of(2),
        offset: Offset(0, AppScale.of(1)),
      ),
    ];
  }
}
